#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

int main(int argc, char *argv[])
{
   if(argc != 2){
      printf(2, "Usage: find largest prime factor <number>");
      exit();
   }

   int number = atoi(argv[1]);
   int reg_value;
   int max_factor;

   __asm__("movl %%edx, %0" : "=r" (reg_value));
   __asm__("movl %0, %%edx" :  : "r"(number) );

    max_factor = find_largest_prime_factor();
    printf(1, "The largest prime factor of %d is %d\n", number, max_factor);

   __asm__("movl %0, %%edx" :  : "r"(reg_value));
   exit();
}