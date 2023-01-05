#include "types.h"
#include "user.h"
#include "stat.h"


#define WRITE_FD 1

int semaphor_state = 0;

int main(int argc, char **argv)
{
    int phNum;
    phNum = atoi(argv[0]);

    for (int round = 0; round < 100; round++) {
        printf(WRITE_FD, "Philosopher %d is thinking\n", phNum);

        //THINKING
        sleep(1);

        printf(WRITE_FD, "Philosopher %d is hungry\n", phNum);\
        /* Even philasophers first take their right chopstick, then take left chopstick */
        /* Odd philasophers first take their left chopstick, then take their right chopstick */
        /* By using this roadmap, we won't encounter any deadlock */
        if (phNum % 2 == 0) {           
            semaphor_state = sem_acquire(phNum, phNum);
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
        }
        else {
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
            semaphor_state = sem_acquire(phNum, phNum);
        }
        
        printf(WRITE_FD, "Philosopher %d is eating\n", phNum);

        // EATING
        sleep(1);
        printf(WRITE_FD, "Philosopher %d is dropping chopsticks\n", phNum);
        // SLEEPING
        semaphor_state = sem_release(phNum, phNum);
        semaphor_state = sem_release((phNum+4) % 5, phNum);
        // sleep(10);
    }
    exit();
    
}