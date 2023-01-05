#include "types.h"
#include "user.h"
#include "stat.h"

#define PHILS_COUNT 5
 
int main()
{
    for (int i = 0; i < PHILS_COUNT; i++)
        sem_init(i, 1);

    for (int i = 0; i < PHILS_COUNT; i++)
    {
      char id[] = {i+'0', '\0'};
      char * argv[] = {"phil", id, '\0'};
      int pid = fork();
      if (pid == 0) 
      {
        exec("phil", argv);
        exit();
      }
    }
  return 0;
}
