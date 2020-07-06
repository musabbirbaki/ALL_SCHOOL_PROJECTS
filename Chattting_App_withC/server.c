/***********************************************
 *
 *                server.c
 *
 **********************************************/

#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/types.h>
#include "lib.h"
#include "chatLineLinkedList.h"


struct User{
    int socket;
    char* username;
	bool usernameReceived;
	bool firstMessageSent;
};

int main(int argc, char **argv) {

	int sock, conn;
	int i;
	int rc;
	struct sockaddr address;
	socklen_t addrLength = sizeof(address);
	struct addrinfo hints;
	struct addrinfo *addr;
	char *message;
	// int messageSender = -1;
	fd_set readfds, allfds;
	int client[FD_SETSIZE];

	struct User users[FD_SETSIZE];

	int maxfd, maxi;
	int nready;

	
	//set the hints structure to zero
	memset(&hints, 0, sizeof(hints));

	/*
	 *  want a stream, also address that will accept all
	 *  connections on this host
	 */
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE | AI_ADDRCONFIG;
	
	if((rc = getaddrinfo(NULL, "55555", &hints, &addr))) {
		printf("host name lookup failed: %s\n", gai_strerror(rc));
		exit(1);
	}

	/*
	 *  use the first entry returned by getaddrinfo
	 */
	sock = socket(addr->ai_family, addr->ai_socktype, addr->ai_protocol);
	if(sock < 0) {
		printf("Can't create socket\n");
		exit(1);
	}

	/*
	 *  want to be able to reuse the address right after
	 *  the socket is closed.  Otherwise must wait for 2 minutes
	 */
	i = 1;
	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &i, sizeof(i));

	rc = bind(sock, addr->ai_addr, addr->ai_addrlen);
	if(rc < 0) {
		printf("Can't bind socket\n");
		exit(1);
	}

	/*
	 *  free results returned by getaddrinfo
	 */
	freeaddrinfo(addr);

	rc = listen(sock, 5);
	if(rc < 0) {
		printf("Listen failed\n");
		exit(1);
	}



	/*
	 *  start with just the accept socket and no clients
	 */
	maxfd = sock;
	maxi = -1;
	for(i=0; i<FD_SETSIZE; i++){
		client[i] = -1;

		users[i].socket = -1;
		users[i].username = NULL;
		users[i].usernameReceived = false;
		users[i].firstMessageSent = false;
	}
	FD_ZERO(&allfds);
	FD_SET(sock, &allfds);

	/*
	 * loop processing requests
	 */
	while(1) {
		readfds = allfds;
		
		//wait until something happens
		nready = select(maxfd+1, &readfds, NULL, NULL, NULL);
		
		//check to see if a client connection is waiting
		//This is server socket, meanning there is new conn we can accpt
		if(FD_ISSET(sock, &readfds)) {
			conn = accept(sock, (struct sockaddr*) &address, &addrLength);
			
			//find an entry in the client table for it
			for(i=0; i<FD_SETSIZE; i++) {
				if(client[i] < 0) {
					client[i] = conn;
					users[i].socket = conn;
					users[i].usernameReceived = false;
					users[i].firstMessageSent = false;
					break;
				}
			}

			//Add client to fdset
			FD_SET(conn, &allfds);
			if(conn > maxfd)
				maxfd = conn;
			if(i > maxi)
				maxi = i;
			if(--nready <= 0)
				continue;
		}

		/*
		 * now check all the existing clients
		 * to see if they have something to read
		 */
		for(i=0; i<=maxi; i++) {
			conn = client[i];
			if(conn < 0)
				continue;
			if(FD_ISSET(conn, &readfds)) { //if a client is read ready
				message = readString(conn);
				// messageSender = conn;

				//Process the message (no bugs?)
				//check if first message
				if(!users[i].usernameReceived && message != NULL){

					char* tempUsername = (char*) malloc(strlen(message)-1);
					memcpy(tempUsername, message, strlen(message) - 1);
					char* ptrPlace = tempUsername + strlen(message) - 1;
					memset(ptrPlace, '\0', 1);
				
					//User logs in
					// users[i].username = strdup(message);
					users[i].username = tempUsername;
					printf("%s logged in.\n", users[i].username);
					users[i].usernameReceived = true;


					//If number of history lines is more then 0
					if(currentLineCount > 0){
						//Send history to user
						struct ChatLine* n = chatHistoryHead;
						while (n != NULL) { 
							// printf("%s\n", n->line);
							writeString(conn, n->line);
							n = n->next; 
						}

						// printf("Sent %d lines of chat history to %s.\n", currentLineCount, users[i].username);
					}

				}else{//message is normal 
					
					if(message != NULL){

						//Add Username to message for history
						char* fullMessage = (char*) malloc(strlen(users[i].username) + 2 + strlen(message) + 1);
						strcpy(fullMessage, users[i].username);
						strcat(fullMessage, ": ");
						strcat(fullMessage, message);
						free(message);
						message = fullMessage;

						//add to history
						addLineToHistory(message);

						//Print message on server
						printf("%s", message); //Message has a new line char
					}

					//Send everyone the message
				}
				//End of processing message

				/*
				 * has the client disconnected
				 */
				if(message == NULL) {
					for(int j=0; j<=maxi; j++){
						if(client[j] == conn){
							// users[j].username //disconected
							if(users[j].username != NULL){
								printf("%s Disconnected.\n", users[j].username);
							}else{
								printf("Client connection cancelled.\n");
							}
						}
					}

					close(conn);

					client[i] = -1;

					users[i].socket = -1;
					free(users[i].username);
					users[i].usernameReceived = false;

					// messageSender = -1;
					FD_CLR(conn, &allfds);
				} else{
					if(users[i].firstMessageSent == true){
						
						//Send everyone the message excluding the current user
						for(int j = 0; j<=maxi; j++){
							writeString(client[j], message);
						}
					
					}else{
						users[i].firstMessageSent = true;
					}


					free(message);
				}
			}
		}
	}

	close(sock);
	exit(0);
}
