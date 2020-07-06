/**
 * This is the linked list structure for each line of chat.
 * */

#ifndef CHATLINKEDLIST_H
#define CHATLINKEDLIST_H

#include <stdio.h> 
#include <stdlib.h> 
#include <string.h>

#define MAX_NUM_OF_LINES 12

struct ChatLine { 
    char* line; 
    struct ChatLine* next; 
}; 

extern struct ChatLine* chatHistoryHead;
extern int currentLineCount;

void printList(struct ChatLine* n);
void push(struct ChatLine** head, char* str);
int pop(struct ChatLine** head);
int addLineToHistory(char* str);


#endif