/**
 * This is the linked list structure for each line of chat.
 * */

#include "chatLineLinkedList.h"

// struct ChatLine* listHead = NULL;
struct ChatLine* chatHistoryHead = NULL;
int currentLineCount = 0;

//Prints list
void printList(struct ChatLine* n) 
{ 
    while (n != NULL) { 
        printf("%s\n", n->line); 
        n = n->next; 
    }

    printf("\nCount: %d\n\n", currentLineCount);
}

// struct ChatLine* head = NULL; 
void push(struct ChatLine** head, char* str){

    //check if head is empty
    if((*head) != NULL){
        //get last node
        struct ChatLine* current = *head;
        while(current->next != NULL){
            current = current->next;
        }

        //Set new val.
        current->next = (struct ChatLine*) malloc(sizeof(struct ChatLine));
        current->next->line = strdup(str);
        current->next->next = NULL;
    }else{
        // printf("Setting Head.\n");

        //Set new val.
        *head = (struct ChatLine*) malloc(sizeof(struct ChatLine));
        (*head)->line = strdup(str);
        (*head)->next = NULL;
    }

    currentLineCount++;

}

int pop(struct ChatLine** head){
// int pop(){
    // struct ChatLine** head = &listHead;

    if((*head) != NULL){
        //Save head to free memory later
        struct ChatLine* nextLine = (*head)->next;

        //Make next of head, the head
        nextLine->next = (*head)->next->next;

        //free memory of prev head
        free((*head)->line);
        free(*head);

        //make nextLine the new head
        *head = nextLine;

        currentLineCount--;

        return 0;
    }else{
        return -1;
    }
}


/**
 * This function keeps only MAX_NUM_OF_LINES in the history
*/
int addLineToHistory(char* str){
    if(currentLineCount < MAX_NUM_OF_LINES){
        push(&chatHistoryHead, str);
        return 0;
    }else{
        pop(&chatHistoryHead);
        push(&chatHistoryHead, str);

        return 0;
    }

    return -1;
}