/******************************************
 *
 *              lab1.c
 *
 *  A simple copy program that demostrates
 *  basis system calls.
 *
 *  Usage: lab1 infile outfile
 *
 *****************************************/

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int main(int argc, char **argv) {
	int fin;
	int fout;
	int n;
	char buffer[512];
	int ret;

	struct stat buffer1, buffer2;

	// if(argc != 3) {
	// 	printf("Usage: lab1 infile outfile\n");
	// 	exit(1);
	// }

	// fin = open(argv[1], O_RDONLY);
	fin = 0;
	// if(fin < 0) {
	// 	printf("Can't open input file: %s\n",strerror(errno));
	// 	exit(1);
	// }

	// fout = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	fout = 1;
	// if(fout < 0) {
	// 	printf("Can't open output file: %s\n",strerror(errno));
	// 	exit(1);
	// }

	n=1;  // Get the process started
	// while(n > 0) {
		n = read(fin, buffer, 512);
		if(n < 0) {
			printf("Error on read: %s\n",strerror(errno));
			exit(1);
		}
		ret = write(fout, buffer, n);
		if(ret < 0) {
			printf("Erroc on write: %s\n",strerror(errno));
			exit(1);
		}
	// }

	// Obtaining file information
	// fstat(fin, &buffer1);
	// fstat(fout, &buffer2);

	// printf("Initial Permissions\n");
	// printf("Permissions of %s: %o\n", argv[1], buffer1.st_mode);
	// printf("Permissions of %s: %o\n\n", argv[2], buffer2.st_mode);

	// // Performing chmod on the output file based on the permissions of the input file
	// fchmod(fout, buffer1.st_mode);

	// // Obtaining file information again post chmod
	// fstat(fin, &buffer1);
	// fstat(fout, &buffer2);

	// printf("Post Copy Permissions\n");
	// printf("Permissions of %s: %o\n", argv[1], buffer1.st_mode);
	// printf("Permissions of %s: %o\n", argv[2], buffer2.st_mode);

	// close(fin);
	// close(fout);

	exit(0);
}
