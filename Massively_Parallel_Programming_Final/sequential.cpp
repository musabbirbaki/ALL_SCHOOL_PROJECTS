// PARALLEL TEST
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <utility>
#include <math.h>
#include <stdio.h>

#define NUM_OF_THREADS 4

int levenshtein_distance(std::string seq_1, std::string seq_2);
struct sequences needleman_distance(std::string seq_1, std::string seq_2, int d);

float similarity(std:: string seq_1, std::string seq_2, bool percentage);
int int_min(int val_1, int val_2, int val_3);
int int_max(int val_1, int val_2, int val_3);
int score(char a, char b);

struct sequences {
    std::string sequence_1;
    std::string sequence_2;
    int score;
};

int main () {
    std::string seq_1 = "Hello";
    std::string seq_2 = "World";

    std::cout << "------Levenshtein-------\n" << seq_1 << "\n" << seq_2 << "\nMED: " << levenshtein_distance(seq_1, seq_2) << "\n" << std::endl;    

    std::string seq_3 = "ACCGTCCCG";
    std::string seq_4 = "GCTTGG";

    struct sequences result = needleman_distance(seq_3, seq_4, 4);
    std::cout << "----Needleman-Wunsch----\n--------Original--------\n" << seq_3 << "\n" << seq_4 << "\n\n---------Results--------\n" << result.sequence_1 << "\n" << result.sequence_2 << "\nScore: " << result.score << "\nMatched Characters: \t" << similarity(result.sequence_1, result.sequence_2, false) << std::endl;

}

int levenshtein_distance(std::string seq_1, std::string seq_2) {
    int val_1, val_2, val_3;

    // Finding the lengths of each sequence argument 
    size_t len_1 = seq_1.length() + 1;
    size_t len_2 = seq_2.length() + 1;

    // Defining table that will keep track of minimum edit distance calculations
    int table[len_1][len_2];

    // Initializing the first value of each column
    for (int i = 0; i < len_1; i++) {
        table[i][0] = i;
    }

    // Initializing the first value of each row
    for (int j = 0; j < len_2; j++) {
        table[0][j] = j;
    }

    for (size_t i = 1; i < len_1; i++) {
        for (size_t j = 1; j < len_2; j++) {
            val_1 = table[i-1][j] + 1;
            val_2 = table[i][j-1] + 1;
            val_3 = table[i-1][j-1];

            // Comparing the lowercase value of the characters (ex. considering a equal to A)
            if (tolower(seq_1[i-1]) != tolower(seq_2[j-1])) {
                val_3 = val_3 + 1;  // Substitution cost is 1
            }

            table[i][j] = int_min(val_1, val_2, val_3);
        }
    }
    return table[len_1 - 1][len_2 - 1];
}

struct sequences needleman_distance(std::string seq_1, std::string seq_2, int d) {
    int val_1, val_2, val_3;

    // Finding the lengths of each sequence argument 
    const size_t len_1 = seq_1.length() + 1;
    const size_t len_2 = seq_2.length() + 1;

    // Defining table that will keep track of minimum edit distance calculations
    int table[len_1][len_2];

    // Initializing the first value of each column
    for (size_t i = 0; i < len_1; i++) {
        table[i][0] = -i * d;
    }

    // Initializing the first value of each row
    for (size_t j = 0; j < len_2; j++) {
        table[0][j] = -j * d;
    }

    for (size_t i = 1; i < len_1; i++) {
        for (size_t j = 1; j < len_2; j++) {
            val_1 = table[i-1][j-1];        // Get diagonal element score (top left)
            if (seq_1[i-1] == seq_2[j-1]) { 
                val_1 = val_1 + 1;          // If Character a == b then add 1 to score
            } else {
                val_1 = val_1 - 3;          // If Character a != b then subtract 3 from score
            }

            val_2 = table[i-1][j] - d;      // Get above element score, space penalty score = -4 (d)
            val_3 = table[i][j-1] - d;      // Get left element score, space penalty score = -4 (d)

            // Maximize score, take max of the three values
            table[i][j] = int_max(val_1, val_2, val_3);     
        }
    }

    std::string sequence_1 = "";
    std::string sequence_2 = "";
    std::string temp = "";
    
    int i = len_1-1, j = len_2-1;
    while(i != 0 || j != 0) {
        if (i == 0) {
            j = j - 1;
            sequence_1.insert(0, "-");

            temp = seq_2[j];
            sequence_2.insert(0, temp);
        } else if (j == 0) {
            i = i - 1;
            temp = seq_1[i];
            sequence_1.insert(0, temp);
            sequence_2.insert(0, "-");
        } else {
            int max = int_max(table[i-1][j-1] + score(seq_1[i-1], seq_2[j-1]), table[i-1][j], table[i][j-1]);

            if (max == (table[i-1][j-1] + score(seq_1[i-1], seq_2[j-1]))) {
                i = i-1;
                j = j-1;
                temp = seq_1[i];
                sequence_1.insert(0, temp);

                temp = seq_2[j];
                sequence_2.insert(0, temp);
            } else if (max == table[i-1][j]) {
                i = i-1;
                temp = seq_1[i];
                sequence_1.insert(0, temp);
                sequence_2.insert(0, "-");
            } else {
                j = j-1;
                sequence_1.insert(0, "-");
                temp = seq_2[j];
                sequence_2.insert(0, temp);
            }
        }
    }

    struct sequences result; 
    result.sequence_1 = sequence_1;
    result.sequence_2 = sequence_2;
    result.score = table[len_1 - 1][len_2 - 1];

    return result;
}

float similarity (std:: string seq_1, std::string seq_2, bool percentage) {
    float length = seq_1.length();
    float counter;

    for (int i = 0; i < length; i++) {
        if (seq_1[i] == seq_2[i]) {
            counter++;
        } 
    }    
    if (percentage) {
        return counter/length;
    } else {
        return counter;
    }
}

int int_min(int val_1, int val_2, int val_3) {
    return fmin(fmin(val_1, val_2), val_3);
}

int int_max(int val_1, int val_2, int val_3) {
    return fmax(fmax(val_1, val_2), val_3);
}

int score(char a, char b){
    if(a == b){
        return 1;
    }else{
        return -3;
    }
}