// PARALLEL TEST
#include <iostream>
#include <string>
#include <utility>
#include <math.h>
#include <stdio.h>
#include <omp.h>

#define NUM_OF_THREADS 3

#define dd 4

float similarity (std:: string seq_1, std::string seq_2, bool percentage);
int int_max(int val_1, int val_2, int val_3);
int score(char a, char b);

struct sequences {
    std::string sequence_1;
    std::string sequence_2;
    int score;
};

int main () {
    // std::string seq_1 = "knasdlfjkbashpodiguhpqwokenrpfkjasbdfpoiashjdopfkmnwqepfbnlkjpoijpnpoihpnpoknpoijpoihponpoknopipsdofkjaspokdjnobfpqwoieuhrjpqwoklenfpoasjkdbfpoiqwjerpokalnsdfpjsbdpfojhqwepoirjaspokdlfnapowjebproawpjdfkdlansdpofjaspdofiajpsodiufaposidnfpaskdnfpasoidjfaposidnfaopksdmnfpoasidufjopaisndfpokansdfopajisdfaspdkfjasSOMEBIGWORDSasd;flkjqwpoeinasd;lfkjaspodifhgpqowuhietl;knasdlfjkbashpodiguhpqwokenrpfkjasbdfpoiashjdopfkmnwqepfbnlkjpoijpnpoihpnpoknpoijpoihponpoknopipsdofkjaspokdjnobfpqwoieuhrjpqwoklenfpoasjkdbfpoiqwjerpokalnsdfpjsbdpfojhqwepoirjaspokdlfnapowjebproawpjdfkdlansdpofjaspdofiajpsodiufaposidnfpaskdnfpasoidjfaposidnfaopksdmnfpoasidufjopaisndfpokansdfopajisdfaspdkfjas[dpokfa[psldkfa[psodifpaosdmf[paosdkf[apsodfia[psodmf[pasldfkap[osdkf[poaskdf[poasdmfpo[askdfop[asdkfpoasdf[pasodkfasdnfb";
    // std::string seq_2 = "dfnpowiqeurpalksnflksdnfjpoaishdgopiaishdfojogopibjbipuhpoihponojbnpouhoihnopnpobasopidjfpoqiwejproibhqwepoifjpasodinfpoqwbeprojpasodfjaslpkdnfpoqwerupoaisdjfkalsdnfpoqweirupaosidjfnaslkdbnfpowieapsokdjfapsidufaopisdjfpaoskdnfaopsidjfpaosidnfopaskndofjiasdoipfjasopidnfaoipsdjfpoaisjdfoiasndasdfpaoisdjfaSOMEOTHERBIGWORDSasdflkasjdpoiefrqpwonfpkalsdjfpasokdbfpouiweplkfjaslk;dfnpowiqeurpalksnflksdnfjpoaishdgopiaishdfojogopibjbipuhpoihponojbnpouhoihnopnpobasopidjfpoqiwejproibhqwepoifjpasodinfpoqwbeprojpasodfjaslpkdnfpoqwerupoaisdjfkalsdnfpoqweirupaosidjfnaslkdbnfpowieapsokdjfapsidufaopisdjfpaoskdnfaopsidjfpaosidnfopaskndofjiasdoipfjasopidnfaoipsdjfpoaisjdfoiasndasdfpaoisdjfa[psodif[aposdkfa[psdnf[apsodif[paosdmfalskdmf[aposdkf[paosdkfp[aslmdfl;asdkf[paosdkfapsdmf[apsdokfap[osdkfapo[sdm";
    // std::string seq_1 = "SOMEBIGWORDS";
    // std::string seq_2 = "SOMEOTHERBIGWORDS";

    std::string seq_1 = "SOMEBIGWORD";
    std::string seq_2 = "WORDSOMEBIG";

    ////////////////////////////////////////// Testing
    // Initializing array
    size_t len_1 = seq_1.length() + 1;
    size_t len_2 = seq_2.length() + 1;

    int F[len_1][len_2];

    omp_set_num_threads(NUM_OF_THREADS);
    #pragma omp parallel
    {
        // Initializing the first value of each column
        #pragma omp for nowait
        for (int a = 0; a < len_1; a++) {
            F[a][0] = - a * dd;
        }

        // Initializing the first value of each row
        #pragma omp for
        for (int b = 0; b < len_2; b++) {
            F[0][b] = - b * dd;
        }        
    }
    
    // Inside
    int counter = 0;
    int counter2;
    int i, a, b;
    omp_set_num_threads(2);
    for(i = 1; i < fmin(len_1, len_2); i++){
        #pragma omp parallel
        {
            int thread_id = omp_get_thread_num();
            if(thread_id == 0){
                // Horizontal thread 1
                for(a = i; a < len_2; a++){
                    F[i][a] = fmax(fmax(F[i-1][a-1] + score(seq_1[i-1], seq_2[a-1]), 
                    F[i-1][a] - dd), 
                    F[i][a-1] - dd);
                }
            }else{
                // Vertical thread 2
                counter2 = i;
                for(b = counter2; b < len_1; b++){
                    F[counter2][i] = fmax(fmax(F[counter2 - 1][i - 1] + score(seq_1[counter2-1], seq_2[i-1]), 
                    F[counter2 - 1][i] - dd), 
                    F[counter2][i - 1] - dd);
                    counter2++;
                }
            }
        }
    }

    // Traceback code 
    std::string sequence_1 = "";
    std::string sequence_2 = "";
    std::string temp = "";

    i = len_1-1;
    int j = len_2-1;
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
            int max = int_max(F[i-1][j-1] + score(seq_1[i-1], seq_2[j-1]), F[i-1][j], F[i][j-1]);

            if (max == (F[i-1][j-1] + score(seq_1[i-1], seq_2[j-1]))) {
                i = i-1;
                j = j-1;
                temp = seq_1[i];
                sequence_1.insert(0, temp);

                temp = seq_2[j];
                sequence_2.insert(0, temp);
            } else if (max == F[i-1][j]) {
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
    result.score = F[len_1 - 1][len_2 - 1];

    std::cout << "----Needleman-Wunsch----\n--------Original--------\n" << seq_1 << "\n" << seq_2 << "\n\n---------Results--------\n" << result.sequence_1 << "\n" << result.sequence_2 << "\nScore: " << result.score << "\nMatched Characters: \t" << similarity(result.sequence_1, result.sequence_2, false) << std::endl; 
    // std::cout << result.sequence_1 << "\n" << result.sequence_2 << "\n" << result.score << std::endl;
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