#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
    printf(1 , "Start forking current process, forking for 3 times:\n");
    int pid;
    pid = fork();
    if(pid < 0){
        printf(1 , "Fork Failed!\n");
    }
    if(pid == 0){
        printf(1 , "  Process : %d , Parent: %d\n", getpid() , get_parent_pid());
        int pid1 = fork();
        if(pid1 == 0){
            printf(1 , "    Process : %d , Parent: %d\n", getpid() , get_parent_pid());
            int pid2 = fork();
            if(pid2 == 0){
                printf(1 , "      Process : %d , Parent: %d\n", getpid() , get_parent_pid());
            }
            else{
                pid2 = wait();
            }
        }
        else{
            pid1 = wait();
        }
    }
    else{
        pid = wait();
        printf(1 , "Origin process: %d\n", getpid());
    }
    exit();
} 