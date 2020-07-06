.PHONY : all clean
CFLAGS = -Wall -g

all : server client test

chatLineLinkedList:
	cc -o chatLineLinkedList chatLineLinkedList.o

server : server.o lib.o chatLineLinkedList.o
	cc -o server server.o lib.o chatLineLinkedList.o

client : client.o lib.o chatLineLinkedList.o
	cc -o client client.o lib.o chatLineLinkedList.o

test : test.o
	cc -o test test.o chatLineLinkedList.o

lib.o : lib.h

server.o : lib.h

client.o : lib.h

chatLineLinkedList.o : chatLineLinkedList.h

clean :
	rm client server client.o server.o lib.o chatLineLinkedList.o test test.o
