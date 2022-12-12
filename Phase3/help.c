#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"




int main(int argc, char **argv)
{
  char* s = "\n commands list: \n\n 1. procs_status: show to status of all available processes\n 2. set_queue: set the queue of a process\n 3. set_lottery_ticket: set the lottery ticket of a process\n 4. set_bjf_params: set the bjf params of a process\n 5. set_all_bjf_params: set the bjf params of all processes\n\n";
  printf(1 , "%s" , s);
}