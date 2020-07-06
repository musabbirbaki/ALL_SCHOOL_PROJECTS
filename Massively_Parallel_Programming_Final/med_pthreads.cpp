#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <utility>
#include <math.h>
#include <stdio.h>
#include <pthread.h>

#define NUM_OF_THREADS 4

#define WORD "Hello"
#define DISTANCE_THRESHOLD 1

void* get_similar_words (void* threadarg);

int levenshtein_distance(std::string seq_1, std::string seq_2);

std::vector<std::string> read_file(std::string filename);
std::vector<std::string>* split_vector(std::vector<std::string> content);

int int_min(int val_1, int val_2, int val_3);

struct info {
    int thread_id;
    int distance_threshold;
    std::string word;
    std::vector<std::string> section;
};

int main () {
    // Reading words.txt and storing all the lines in it into the lines variable
    std::vector<std::string> lines = read_file("Data/words.txt");

    // // Sequential Implementation
    // std::cout << "---Words similar to " << WORD << " from words.txt---" << std::endl;
    // for (int i = 0; i < lines.size(); i++) {
    //     if (levenshtein_distance(WORD, lines[i]) <= DISTANCE_THRESHOLD) {
    //         std::cout << lines[i] << std::endl;
    //     }
    // }    

    // Splitting the lines vector based on the number of threads (definition)
    std::vector<std::string> *sections;
    sections = split_vector(lines);

    // Declaring info struct that will hold the arguments for the threads 
    struct info thread_info[NUM_OF_THREADS];

    // Declaring threads
    pthread_t threads[NUM_OF_THREADS];

    pthread_attr_t a;
    void* status;

    // Initializing the thread attributes
    pthread_attr_init(&a); // Setting a to all default attributes (except detach state below)
    pthread_attr_setdetachstate(&a, PTHREAD_CREATE_JOINABLE);

    std::cout << "---Words similar to " << WORD << " from words.txt---" << std::endl;

    for (long i = 0; i < NUM_OF_THREADS; i++) {
        thread_info[i].thread_id = i;
        thread_info[i].distance_threshold = DISTANCE_THRESHOLD;
        thread_info[i].word = WORD;
        thread_info[i].section = sections[i];

        int error = pthread_create(&threads[i], &a, get_similar_words, (void *)&thread_info[i]);

        if (error) {
            printf("ERROR\n");
            exit(-1);
        }
    }

    pthread_attr_destroy(&a);

    for (int i = 0; i < NUM_OF_THREADS; i++) {
        int error = pthread_join(threads[i], &status);
        if(error) {
            std::cout << "ERROR ON JOIN " << i << std::endl;
        }
    }
}

// This is the function that will be run by each pthread on their creation
void* get_similar_words (void* threadarg) {
    struct info *thread_info; 
    thread_info = (struct info*)threadarg;

    std::string keyword = thread_info->word;
    std::vector<std::string> section = thread_info->section;
    int threshold = thread_info->distance_threshold;

    for (int i = 0; i < section.size(); i++) {
        if (levenshtein_distance(keyword, section[i]) <= threshold) {
            std::cout << section[i] << std::endl;
        }
    }    
    pthread_exit(NULL);
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

std::vector<std::string> read_file(std::string filename) {
    std::vector<std::string> output;
    std::ifstream input;
    std::string line;

    input.open(filename);

    while(std::getline(input, line)) {
        output.push_back(line);
    }
    return output;
}

std::vector<std::string>* split_vector(std::vector<std::string> content) {
    static std::vector<std::string> sections[NUM_OF_THREADS];

    for (int i = 0; i < NUM_OF_THREADS - 1; i++) {
        std::vector<std::string> section(content.begin() + (content.size() / NUM_OF_THREADS) * i, content.begin() + (content.size() / NUM_OF_THREADS) * (i + 1));
        sections[i] = section;
    }
    std::vector<std::string> section(content.begin() + (content.size() / NUM_OF_THREADS) * (NUM_OF_THREADS - 1), content.end());
    sections[NUM_OF_THREADS - 1] = section;

    return sections;
}

int int_min(int val_1, int val_2, int val_3) {
    return fmin(fmin(val_1, val_2), val_3);
}
