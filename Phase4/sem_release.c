#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char *argv[]) {

    if (argc <= 1){
        printf(1, "not enough arguments\n");
        exit();
    }

    int i = atoi(argv[1]);
    int res = sem_release(i-1);
    
    if (res == 0)
        printf(1, "semaphore has not been initialized\n");

    else if (res>0)
        printf(1, "process released semaphore\n");

    else
        printf(1, "this semaphore queue is empty\n")
    
    exit();
} 