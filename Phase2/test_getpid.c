#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

int main(void)
{
    int pid;
    pid = getpid();
    printf(1, "pid = %d\n", pid);
    exit();
}