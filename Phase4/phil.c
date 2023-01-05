#include "types.h"
#include "user.h"
#include "stat.h"

#define THINKING 2
#define HUNGRY 1
#define EATING 0
#define READ_FD 1

// int state;
int phNum;

// p0 0 p1 1 p2 2 p3 3 p4 4

int main(int argc, char **argv)
{
    phNum = atoi(argv[1]);

    while (1) {
        int i = phNum;
        printf(READ_FD, "Philosopher number %d is thinking\n", phNum);

        //THINKING
        sleep(1);

        printf(READ_FD, "Philosopher number %d is hungry\n", phNum);
        if (phNum%2) {
            sem_acquire(i);
            sem_acquire((i+4) % 5);
        }
        else {
            sem_acquire((i+4) % 5);
            sem_acquire(i);
        }
        
        printf(READ_FD, "Philosopher number %d is eating\n", phNum);

        //EATING
        sleep(1);
        printf(READ_FD, "Philosopher number %d is dropping forks\n", phNum);

        //SLEEPING
        sem_release(i);
        sem_release((i+1) % 5);
    }
}