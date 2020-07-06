/********************************************************
 *
 *                          client.c
 *
 *******************************************************/

#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <unistd.h>
#include "lib.h"

void flushStdin(){
	int c;
	while ((c = getchar()) != '\n' && c != EOF);
}

int main(int argc, char **argv) {
	struct addrinfo hints;
	struct addrinfo *addr;
	struct sockaddr_in *addrinfo;
	int rc;
	int sock;

	char* username;
	char* tempUsername;

	//User input buffer and fgets ret
	char buffer[512];
	char *ret;

	//Fork ret
	int forkRet;


	/*
	 *  clear the hints structure to zero
	 */
	memset(&hints, 0, sizeof(hints));

	/*
	 *  want a stream on a compatible interface
         */
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_ADDRCONFIG;
	/*
	 *  localhost is the name of the current computer
	 */
	rc = getaddrinfo("localhost", NULL, &hints, &addr);
	if(rc != 0) {
		printf("Host name lookup failed: %s\n", gai_strerror(rc));
		exit(1);
	}

	/*
	 *  use the first result from getaddrinfo
	 */
	addrinfo = (struct sockaddr_in *) addr->ai_addr;

	sock = socket(addrinfo->sin_family, addr->ai_socktype, addr->ai_protocol);
	if(sock < 0) {
		printf("Can't create socket\n");
		exit(1);
	}

	/*
	 *  specify the port number
	 */
	addrinfo->sin_port = htons(55555);

	rc = connect(sock, (struct sockaddr *) addrinfo, addr->ai_addrlen);
	if(rc != 0) {
		printf("Can't connect to server\n");
		exit(1);
	}

	/*
	 *  free the results returned by get addrinfo
	 */
	freeaddrinfo(addr);

	/*
	 *  Loop reading input from stdin, send the line to
	 *  to the echo server, and then read the results
	 *  from the server.
	 */

	
	printf("Enter Username: ");

	//Send Username without fds lock
	username = fgets(buffer, 512, stdin);
	
	//check for user entering end of file
	if(username == NULL) {
		shutdown(sock, SHUT_WR);
	} else {

		//get rid of /n in username
		tempUsername = (char*) malloc(strlen(username)-1);
		memcpy(tempUsername, username, strlen(username) - 1);
		char* ptrPlace = tempUsername + strlen(username) - 1;
		memset(ptrPlace, '\0', 1);

		writeString(sock, buffer);

		//Logged in
		printf("Logged in as %s.\n", tempUsername);
	
		// free(username);
		username = tempUsername;
	}
	

	forkRet = fork();
	while(1) {

		// child
		if (forkRet == 0){

			ret = fgets(buffer, 512, stdin);

			//check for user entering end of file
			if(ret == NULL) {
				shutdown(sock, SHUT_WR);
				printf("Disconnected from Server.\n");
				break;
			} else {
				writeString(sock, buffer);
			}

		}else{// parent

			ret = readString(sock);

			if(ret == NULL) {
				shutdown(sock, SHUT_WR);
				printf("Disconnected from Server.\n");
				break;
			} else {
				printf("%s", ret);
			}
		}
	}



	free(tempUsername);
	close(sock);

	exit(0);
}
