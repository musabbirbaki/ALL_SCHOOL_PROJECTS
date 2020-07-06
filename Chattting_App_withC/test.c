
#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include <stdbool.h>
#include "chatLineLinkedList.h"

// struct ChatLine* listHead = NULL;

struct User{
    int socket;
    char* username;
    bool usernameReceived;
};

int main() 
{ 
    //select test
    // fd_set rfds;
    // struct timeval tv;
    // int retval;

    // //user input
    // char buffer[512];
	// char *ret;

    // //watch stdin
    // FD_ZERO(&rfds);
    // FD_SET(0, &rfds); //0 stdin

    // //time
    // tv.tv_sec = 5;
    // tv.tv_usec = 0;

    // while(1){

    //     retval = select(1, &rfds, NULL, NULL, &tv);

    //     if(retval == -1){
    //         printf("Select Error.\n");
    //     }else if(retval){
    //         if(FD_ISSET(0, &rfds)){
    //             ret = fgets(buffer, 512, stdin);
    //             printf("Hello %s.\n");
    //         }
    //     }else{
    //         printf("Doing somthing else.");
    //     }
    // }



    // push(&chatHistoryHead, "This is my new line");
    // // push("This is my new line");
    // // printList(chatHistoryHead);

    // push(&chatHistoryHead, "This is my new new line");
    // // printList(chatHistoryHead);

    // push(&chatHistoryHead, "This is my new new new line");
    // // printList(chatHistoryHead);

    // pop(&chatHistoryHead);
    // // printList(chatHistoryHead);

    // push(&chatHistoryHead, "");
    // // printList(chatHistoryHead);
    
    // push(&chatHistoryHead, "a");
    // // printList(chatHistoryHead);

    // getChatHistory();



    // char* firstString = "This is my first string";
    // char* secondString = "This is my second string";

    // //memcpy(to pinter, from pointer, size int)
    // //memset(to ptr, value, size int)
    // char* combinedString;

    // printf("%s\n", firstString);
    // printf("%s\n", secondString);
    // // printf("%s\n", combinedString);

    char* l1 = "Line 1";
    addLineToHistory(l1);
    // printList(chatHistoryHead);


    char* l2 = "Line 2";
    addLineToHistory(l2);
    // printList(chatHistoryHead);

    addLineToHistory("Line 3");
    // printList(chatHistoryHead);

    addLineToHistory("Line 4");
    // printList(chatHistoryHead);

    addLineToHistory("Line 5");
    // printList(chatHistoryHead);

    addLineToHistory("Line 6");
    // printList(chatHistoryHead);

    addLineToHistory("Line 7");
    addLineToHistory("Line 8");
    addLineToHistory("Line 9");
    addLineToHistory("Line 10");
    addLineToHistory("Line 11");
    addLineToHistory("Line 12");
    addLineToHistory("Line 13");
    addLineToHistory("Line 14");
    addLineToHistory("Line 15");

    // void printList(struct ChatLine* n)
    struct ChatLine* n = chatHistoryHead;
    while (n != NULL) { 
        printf("%s\n", n->line); 
        n = n->next; 
    }

    // printList(chatHistoryHead);

    // struct User users[10];

    // users[1].socket = 0;
    // users[1].username = "Username1";

    // printf("ID %d: Username: %s", users[1].socket, users[1].username);


    // forkRet = fork();
	// while(1) {

	// 	// child
	// 	if (forkRet == 0){

	// 		//Self "Username:"
	// 		printf("%s: ", username);

	// 		ret = fgets(buffer, 512, stdin);
	// 		//check for user entering end of file
	// 		if(ret == NULL) {
	// 			shutdown(sock, SHUT_WR);
	// 			break;
	// 		} else {
	// 			writeString(sock, buffer);
	// 		}

	// 	}else{// parent

	// 		ret = readString(sock);

	// 		if(ret == NULL) {
	// 			shutdown(sock, SHUT_WR);
	// 			break;
	// 		} else {
	// 			printf("%s", ret);
	// 		}
	// 	}

		
	// 	// //SELECT not working
	// 	// selectReady = select(1, &stdin_fds, NULL, NULL, NULL);
	// 	// if(selectReady == -1){
    //     //     printf("Select Error.\n");
	// 	// 	continue;
    //     // }else if(selectReady){
	// 	// 	//Check if stdin has somthing
    //     //     if(FD_ISSET(0, &stdin_fds)){
    //     //         ret = fgets(buffer, 512, stdin);
	// 	// 		//check for user entering end of file
	// 	// 		if(ret == NULL) {
	// 	// 			shutdown(sock, SHUT_WR);
	// 	// 			break;
	// 	// 		} else {
	// 	// 			writeString(sock, buffer);
	// 	// 		}
	// 	// 	}
    //     // }else{
    //     //     //Read from server
	// 	// 	ret = readString(sock);
	// 	// 	printf("%s", ret);
    //     // }
		

	// }//END WHILE




    //////////////DOUBLE LOOOP
    // 	forkRet = fork();
	// // child
	// if (forkRet == 0){
	// 	printf("%s: ", username);

	// 	while(1){
	// 		//Self "Username:"

	// 		ret = fgets(buffer, 512, stdin);
	// 		//check for user entering end of file
	// 		if(ret == NULL) {
	// 			shutdown(sock, SHUT_WR);
	// 			break;
	// 		} else {
	// 			writeString(sock, buffer);
	// 		}
	// 	}

	// }else{// parent

	// 	while(1){
	// 		//read from server
	// 		ret = readString(sock);

	// 		if(ret == NULL) {
	// 			shutdown(sock, SHUT_WR);
	// 			break;
	// 		} else {
	// 			printf("%s", ret);
	// 		}
	// 	}
	// }


    return 0; 
}