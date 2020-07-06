#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv){

    printf("-----------TASK 1-------------------\n");

    printf("Arguments: \n");
    for(int i = 0; i < argc; i++){
        printf("argv%d: %s \n", i, argv[i]);
    }
    printf("\n");


	// int n;
	// char buffer[512];
	// int ret;


    // n = read(0, buffer, 512);
    // if(n < 0) {
    //     printf("Error on read: %s\n",strerror(errno));
    //     exit(1);
    // }
    // ret = write(1, buffer, n);
    // if(ret < 0) {
    //     printf("Erroc on write: %s\n",strerror(errno));
    //     exit(1);
    // }

    return 0;
}