#include "types.h"
#include "user.h"
#include "stat.h"

#define PHILS_COUNT 5
 
int temp = 0;

int main()
{
    for (int i = 0; i < PHILS_COUNT; i++)
      temp = sem_init(i, 1);
    
    for (int i = 0; i < PHILS_COUNT; i++)
    {
      char id[] = {i + '0', '\0'};
      char * argv[] = {id};
      int pid = fork();
      if (pid == 0) 
      {
        exec("phil", argv);
        exit();
      }
    }
    for (int i = 0; i < PHILS_COUNT; i++)
      wait();

    exit(); 
}


