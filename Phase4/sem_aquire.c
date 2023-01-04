#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char *argv[]) 
{
    if (argc <= 1){
        printf(1, "not enough arguments\n");
        exit();
    }

    int i = atoi(argv[1]);
    int result = sem_acquire(i-1);

    if (result > 0)
        printf(1, "process acquired semaphore\n");

    else if (result == 0)
        printf(1, "semaphore has not been initialized\n");

    else
        printf(1, "process added to semaphore queue\n");

    exit();
} 