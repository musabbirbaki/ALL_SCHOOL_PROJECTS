// PARALLEL TEST
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <utility>
#include <math.h>
#include <stdio.h>

#define NUM_OF_THREADS 4

struct sequences {
    std::string sequence_1;
    std::string sequence_2;
    int score;
};

void get_attempt_info(std::string seq_1, std::string seq_2);

struct sequences needleman_distance(std::string seq_1, std::string seq_2, int d);

float similarity(std:: string seq_1, std::string seq_2, bool percentage);
int int_max(int val_1, int val_2, int val_3);
int score(char a, char b);

int main () {
    get_attempt_info("ATGGCCTC", "ACGGCTC");

    std::cout << "\n";

    get_attempt_info("AGCCTCGT", "TCG");
}

void get_attempt_info(std::string seq_1, std::string seq_2) {
    std::cout << "-------Attempt with " << seq_1 << " and " << seq_2 << "-------" << std::endl;
    std::string half = seq_1.substr(0, seq_1.length()/2);
    std::string other_half = seq_1.substr(seq_1.length()/2);

    std::string half_2 = seq_2.substr(0, seq_2.length()/2);
    std::string other_half_2 = seq_2.substr(seq_2.length()/2);

    std::cout << "--------------Original Sequences--------------" << std::endl;
    std::cout << seq_1 << "\n" << seq_2 << std::endl;

    std::cout << "----Sequences split into two parts----" << std::endl;
    std::cout << half << " " << other_half << std::endl;
    std::cout << half_2 << " " << other_half_2 << std::endl;

    struct sequences result = needleman_distance(seq_1, seq_2, 4);
    std::cout << "------Needleman with original sequences------\n" << result.sequence_1 << "\n" << result.sequence_2 << "\nScore: \t\t\t" << result.score << "\nMatched Characters: \t" << similarity(result.sequence_1, result.sequence_2, false) << std::endl;

    struct sequences result_1 = needleman_distance(half, half_2, 4);
    int result_1_matches = similarity(result_1.sequence_1, result_1.sequence_2, false);
    std::cout << "---------Needleman with first part---------\n" << result_1.sequence_1 << "\n" << result_1.sequence_2 << "\nScore: \t\t\t" << result_1.score << "\nMatched Characters: \t" << result_1_matches << std::endl;

    struct sequences result_2 = needleman_distance(other_half, other_half_2, 4);
    int result_2_matches = similarity(result_2.sequence_1, result_2.sequence_2, false);
    std::cout << "---------Needleman with second part---------\n" << result_2.sequence_1 << "\n" << result_2.sequence_2 << "\nScore: \t\t\t" << result_2.score << "\nMatched Characters: \t" << result_2_matches << std::endl;

    std::cout << "---------Needleman with parts combined---------\n" << result_1.sequence_1 << result_2.sequence_1 << "\n" << result_1.sequence_2 << result_2.sequence_2 << "\nMatched Characters: \t" << result_1_matches + result_2_matches << std::endl;
    std::cout << "------------------------------------------------" << std::endl;
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