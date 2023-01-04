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

    int res;
    res = sem_init(i-1,v);
    
    if (res == 0)
        printf(1, "semaphore %d initialized with value %d\n", i, v);
    else 
        printf(1, "this semaphore is already initialized!\n");

    exit();
} 
