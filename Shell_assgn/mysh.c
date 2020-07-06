/*******************************************
 *
 *               mysh.c
 *
 *  This is a skeleton for assingment one.
 *  This program doesn't do anything, it
 *  just does into an infinite loop.
 ****************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

struct Pipe{
	char arguments[100][100]; //{LIST}
	char inputFile[100];
	char outputFile[100];
	struct Arguments *args; //{ARGUMENTS}
	struct Pipe *next;
};

struct Arguments{
	char data[512];
	struct Arguments *next;
};

//Global vars
char* prompt = "#~";

// struct Pipe *pipeHead;
// struct Pipe *pipeTail = NULL;
// pipeHead = pipeTail = malloc(sizeof(struct Pipe));

//print pipe linked list
void printPipeLinkedList(struct Pipe *n){
	printf("Printing Linked List:\n");
	while (n != NULL){
		//print linked list args
		// printf("Args Linked List: ");
		// int ccc = 0;
		// while (n->args != NULL && ccc<10) {
		// 	printf("%s, ", n->args->data);
		// 	ccc++;
		// 	n->args = n->args->next;
		// }
		// printf("\n");

		//print arguments {LIST}
		printf("Arguments: ");
		for (int i = 0; i < 100; i++){
			printf("%s, ", n->arguments[i]);
		}
		printf("\n");

		//print input file
		printf("Input File: ");
		printf("%s", n->inputFile);
		printf("\n");

		//print outputfile
		printf("Output File: ");
		printf("%s", n->outputFile);
		printf("\n");

		printf("\n");

		n = n->next;
	}
	// printf("\n");
}

void splitArguments(char *command, struct Pipe *pip){
	struct Arguments *argHead = NULL;
	struct Arguments *argTail = NULL;
	argHead = argTail = pip->args;

	int pipArgCount = 0;

	//Split each command into name and args
	int spacePtrCounter = 0;
	int spaceCount = 0;
	int spaceSize = 0;

	char arguments[512];
	char *s = command;
	char chs = ' ';
	strncat(command, &chs, 1);
	char currentCharS;

	while (*s != '\0' && *s != '\n'){ //spliting on " " for pipes
		currentCharS = *s;
		spaceSize = spacePtrCounter - spaceCount;
		if (currentCharS == ' ' || currentCharS == '\0'){
			memcpy(arguments, &command[spaceCount], spaceSize);
			arguments[spaceSize] = '\0';

			if (arguments[0] == '<'){ //input file command
				char inputFileName[512];
				memcpy(inputFileName, &arguments[1], spaceSize);
				inputFileName[spaceSize] = '\0';

				// printf("\tAt: %d to %d input: %s \n", spaceCount, spacePtrCounter, inputFileName); //DEBUG Print
				//assign input file attribute
				strcpy(pip->inputFile, inputFileName);
			}else if (arguments[0] == '>'){ //Output file command
				char outputFileName[512];
				memcpy(outputFileName, &arguments[1], spaceSize);
				outputFileName[spaceSize] = '\0';

				// printf("\tAt: %d to %d output: %s \n", spaceCount, spacePtrCounter, outputFileName); //DEBUG Print
				//assign output file attribute
				strcpy(pip->outputFile, outputFileName);
			}else{
				if (spaceSize != 0){ //If argument isn't empty
					// printf("\tAt: %d to %d Arg: %s \n", spaceCount, spacePtrCounter, arguments); //DEBUG Print
					strcpy(pip->arguments[pipArgCount], arguments); //Records Arguments in array {LIST}

					//Creating Aruguments Linked List //{ARGUMENTS}
					if (pipArgCount == 0){
						//create head
						strcpy(argHead->data, arguments);
						argHead->next = argTail;
					}else{
						argTail->next = malloc(sizeof(struct Arguments));
						strcpy(argTail->next->data, arguments);
						argTail = argTail->next;
					}

					pipArgCount++;
				}
			}

			spaceCount = spacePtrCounter + 1;
		}
		s++;
		spacePtrCounter++;
	}
	// printf("\n");
}



void read_command(){
	printf("%s", prompt);

	//Input line size
	char input[512];

	// printf("%s", prompt);
	fgets(input, sizeof(input), stdin);

	char* tempStrPtr;
	tempStrPtr = malloc(strlen(input)+1);
	strcpy(tempStrPtr, input);

	//exit prompt
	if (!strcmp(input, "exit\n")){
		exit(0);
	} else if (strcmp(input, "\n") == 0 || input[0] == '#'){
		//Prompt change
		return;
	} else if (!strcmp(strtok(tempStrPtr, " \n"), "prompt")){
		prompt = strtok(NULL, " \n");
		printf("%s\n", prompt);
	} else {
		struct Pipe *pipeHead = NULL;
		struct Pipe *pipeTail;
		pipeHead = pipeTail = malloc(sizeof(struct Pipe));
		
		//Get rid of comments
		char* sPtr = input;
		while(*sPtr != '\0'){
			if(*sPtr == '#'){
				*sPtr = '\n';
				*(sPtr + sizeof(char)) = '\0';
			}
			// printf("-%c-", *s);
			sPtr++;
		}

		char *c = input;

		int commandPtrCounter = 0;
		int commandCount = 0;
		int size = 0;

		char command[512];

		char currentChar;
		while (*c){
			currentChar = *c;

			size = commandPtrCounter - commandCount;
			if (currentChar == '|' || currentChar == '\n'){
				memcpy(command, &input[commandCount], size);
				command[size] = '\0';
				// printf("At: %d to %d command: --%s-- \n", commandCount, commandPtrCounter, command); //DEBUG PRINT
				if (commandCount == 0){
					//create head
					pipeHead->args = malloc(sizeof(struct Arguments));
					splitArguments(command, pipeHead);

					//update tail to latest tail
					pipeHead->next = pipeTail;
				}else{
					//create tail
					pipeTail->next = malloc(sizeof(struct Pipe));

					pipeTail->next->args = malloc(sizeof(struct Arguments));
					splitArguments(command, pipeTail->next);
					//update tail to latest tail
					pipeTail = pipeTail->next;
				}

				commandCount = commandPtrCounter + 1;
			}

			c++;
			commandPtrCounter++;
		}

		//printing pipe linked list
		// printPipeLinkedList(pipeHead);
		execute_command(pipeHead);
	}
}

int countNumberOfCommands(struct Pipe *commands){
	struct Pipe* commandsNew = commands;
	
	int commandCounter = 0;
	while (commandsNew != NULL){
		commandCounter++;
		//Breaks while if only one element in command
		if (commandsNew == commandsNew->next){
			break;
		}else{
			commandsNew = commandsNew->next;
		}
	}
	// printf("Number of Commands: %d\n", commandCounter);
	return commandCounter;
}

void execute_command(struct Pipe *commands){

	// printPipeLinkedList(commands);
	// struct Pipe *commands = pipeHead;

	//File
	int fin;
	int fout;

	//Current number command running
	int currentCommandNumber = 0;

	//Count the number of commands
	int numberOfCommands = countNumberOfCommands(commands);
	// printf("Number of Commands: %d\n", numberOfCommands);

	//Initialize Pipe array
	// (numberOfCommands - 1) * 2 EX: 4 commands have 3 pipes (2 ends each pipe)
	int pipefd[(numberOfCommands - 1) * 2];
	for(int i = 0; i < (numberOfCommands - 1); i++){
		pipe(pipefd + i*2);
	}
	// printf("\n");


	//loop through all the commands
	pid_t pid[numberOfCommands];
	int ret;
	int status;
	while (commands != NULL){
		//Execute commands
		pid[currentCommandNumber] = fork();
		if (pid[currentCommandNumber]){
			if (pid[currentCommandNumber] < 0){
				printf("Fork error: %s\n", strerror(errno));
				exit(1);
			}
		}else{
			char exeCommand[100] = "";
			strcat(exeCommand, commands->arguments[0]);
			strcpy(commands->arguments[0], exeCommand);

			//Counting the number of Arguments
			int argumentsSize = 0;
			for (int i = 0; i < 100; i++){
				if (strcmp(commands->arguments[i], "")){
					argumentsSize++;
				}
			}

			//Takes the arguments and places them in an argv array to send to exec function
			// printf("Argsize %d\n", argumentsSize);
			char *argvs[argumentsSize + 1];
			for (int i = 0; i < argumentsSize; i++){
				argvs[i] = commands->arguments[i];
				// printf("Arg = %s\n", argvs[i]);
			}
			//Adding a /0 null character at the end of argvs
			argvs[argumentsSize] = malloc(sizeof((char *)'\0'));
			argvs[argumentsSize] = (char *)0;
			// printf("\n\n");
						
			//Setup Pipes
			if(currentCommandNumber == 0){
				//FIRST CHILD
				if(strcmp(commands->inputFile, "")){
					fin = open(commands->inputFile, O_RDONLY);
					dup2(fin, 0);
				}

				close(pipefd[0]);
				dup2(pipefd[1], STDOUT_FILENO);
				close(pipefd[1]);
			}else if(currentCommandNumber == numberOfCommands-1){
				//LAST CHILD
				if(strcmp(commands->outputFile, "")){
					fout = open(commands->outputFile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
					dup2(fout, 1);
				}

				close(pipefd[(currentCommandNumber * 2) + 1]);
				dup2(pipefd[(currentCommandNumber - 1) * 2], STDIN_FILENO);
				close(pipefd[(currentCommandNumber - 1) * 2]);
			}else{
				//MIDDLE CHILD
				dup2(pipefd[(currentCommandNumber - 1) * 2], STDIN_FILENO);
				close(pipefd[(currentCommandNumber - 1) * 2]);

				dup2(pipefd[(currentCommandNumber * 2) + 1], STDOUT_FILENO);
				close(pipefd[(currentCommandNumber * 2) + 1]);
			}

			for(int i = 0; i < (numberOfCommands - 1) * 2; i++){
				close(pipefd[i]);
			}

			//running exec function
			ret = execvp(commands->arguments[0], argvs);
			if (ret < 0){
				printf("Execve failed: %s\n", strerror(errno));
				exit(1);
			}

			close(fin);
			close(fout);
			exit(1);
			
		}

		//testFile1 arg1 <input|testFile2 arg1 arg2|testFile3 >output|testFile4 >output.txt
		//testFile2 arg1 input|testFile3 >output|testFile4 output
		currentCommandNumber++;

		//Breaks while if only one element in command
		if (commands == commands->next){
			break;
		}
		
		commands = commands->next;
	}

	//Close All the pipes
	for(int i = 0; i < (numberOfCommands - 1) * 2; i++){
		close(pipefd[i]);
	}

	waitpid(pid[currentCommandNumber - 1], &status, 0);
}

int main(int argc, char **argv){
	printf("My Shell\n");

	while (1){
		read_command();
		// execute_command();
	}
}
