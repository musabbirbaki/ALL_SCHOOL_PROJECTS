CFLAGS = -Wall -g

all: mysh testfile1 testfile2 testfile3 testfile4 lab1

lab1 : lab1.o
	cc -o lab1 lab1.o

testfile1 : testFile1.o
	cc -o testFile1 testFile1.o

testfile2 : testFile2.o
	cc -o testFile2 testFile2.o

testfile3: testFile3.o
	cc -o testFile3 testFile3.o

testfile4 : testFile4.o
	cc -o testFile4 testFile4.o

mysh : mysh.o
	cc -o mysh mysh.o

clean : 
	rm mysh mysh.o testFile1 testFile1.o testFile2 testFile2.o testFile3 testFile3.o testFile4 testFile4.o lab1 lab1.o
