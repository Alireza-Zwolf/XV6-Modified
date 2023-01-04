#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {

    if (argc <= 2){
        printf(1, "not enough arguments\n");
        exit();
    }

    int i = atoi(argv[1]);
    int v = atoi(argv[2]);

    if (i > 5) {
        printf(1, "too many semaphores!\n");
        exit();
    }

    sem_init(i-1,v); // i-1 because we want to use 0-4 as indices

    exit();
} 
