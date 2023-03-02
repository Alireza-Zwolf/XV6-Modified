# OS-Lab
A modified [xv6 operating system](https://github.com/mit-pdos/xv6-public) with several extra features. xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix Version 6 (v6).

- [New Features]()
    - [Phase1: Introduction to xv6](#phase1-introduction-to-xv6) 
        - [Part 1: Boot Message](#part-1-boot-message) 
        - [Part 2: Shell Features](#part-2-shell-features) 
        - [Part 3: User Program](#part-3-user-program)
    - [Phase2: System Calls](#phase2-system-calls)
    - [Phase3: CPU Scheduling](#phase3-cpu-scheduling)
        - [Part 1: Multi-Level Feedback Queue](#part-1-multi-level-feedback-queue)
        - [Part 2: Aging](#part-2-aging)
        - [Part 3: System Calls](#part-3-system-calls)
    - [Phase4: Synchronization](#phase4-synchronization)
        - [Part 1: Semaphore Implementation](#part-1-semaphore-implementation)
        - [Part 2: Dining Philosophers Problem](#part-2-dining-philosophers-problem)
- [How to use?](#how-to-use)



## Phase1: Introduction to xv6

### Part 1: Boot Message
The names of this project contributers is displayed when xv6 boots up.
```text
1. Alireza Arbabi
2. AmirAli Vahidi
3. Hadi Babaloo
```

### Part 2: Shell Features
Following shortcuts are added to console:
- `CTRL+R` : Removes digits from current line
- `CTRL+N` : Reverses current line
- `Tab`    : Filling out current line with the best option from last 15 used commands

### Part 3: User Program
`Prime Numbers` user program added to system which finds prime numbers in the given range and puts them in `prime_numbers.txt` file.

```text
prime_numbers 20 50
```


## Phase2: System Calls

- `find_largest_prime_factor` system call finds the largest prime factor of a given number. The parameter should be passed in the `edx` register. A sample use of this system call is provided in `find_largest_prime_factor` user program.
- `get_callers` system call returns history of the callers of used system calls.
- `get_parent_id` system call returns process ID of parent of the current process. A sample use of this system call is provided in `fork_descendants` user program.


## Phase3: CPU Scheduling

### Part 1: Multi-Level Feedback Queue
The following three scheduling algorithms were implemented in the program, which will be executed in order of priority:
1. Round Robin(RR)
2. Lottery
3. Best Job First(BJF)

### Part 2: Aging
To prevent process ***starvation***, we use the ***aging*** algorithm. In this implementation, if after 10000 cycles the processor was not assigned to the process, that process will be transferred to a queue with higher priority, and monitoring the number of unexecuted cycles of that process will start from the beginning.


### Part 3: System Calls
- `set_proc_queue` system call sets the proccess queue or changing it's queue using *PID* and *Destination Queue Number* as inputs.
- `set_proc_lottery_ticket` system call assigns tickets to the second queue processes to make this queue runnable.It takes PID of the process and its related amount of tickets.
- `set_bjf` system call changes the parameters of bjf in process level.Its inputs are *PID* of the process and *coefficient* of the following equation:
``` text
rank = (Priority * PriorityRatio) + (ArrivalTime * ArrivalTimeRatio) + (ExecutedCycle * ExecutedCycleRatio)
```
- `set_all_bjf` system call changes the parameter of bjf for all processes.Its input is *coefficient* of the following equation:
``` text
rank = (Priority * PriorityRatio) + (ArrivalTime * ArrivalTimeRatio) + (ExecutedCycle * ExecutedCycleRatio)
```
- `procs_status` system call prints a list of all processes with their *pid,state,queue_level,arrival_time,number_of_lottery_tickets,coefficient,rank & number_of_cycles*.

***note:*** to reach better test results, you can run `foo&` command befor calling this system call.*foo* is a user-level program that creats several number of processes that do *CPU Intensive* jobs.

## Phase4: Synchronization

### Part 1: Semaphore Implementation
__Counting Semaphores__ is implemented in this part. This type of semaphore allows a certain number of processes to enter into a critical section simultaneously. If the maximum number of processes that are allowed to be in the critical section has been reached, the processes that are not allowed to enter will go to sleep mode and will be placed in the FIFO queue. After one of the processes leave the critical section, a processes with the most priority will enter to the critical section. 
User-level programs can access to semaphore using folowing system calls:
- `sem_init(i,v)`: The semaphore creates critical section in i index of the array with number v for the maximum number of processes.
- `sem_acquire(i)`: This system call is used when a process wants to enter the critical section.
- `sem_release(i)`: This system call is used when a process wants to exit from the critical section.

### Part 2: Dining Philosophers Problem
The Dining Philosophers Problem is a classic synchronization problem in computer science, which illustrates the challenge of coordinating multiple concurrent processes in a shared resource environment. In this problem, there are five philosophers sitting around a circular table, and each philosopher alternates between thinking and eating. There are five chopsticks placed between each pair of adjacent philosophers, and each philosopher needs two chopsticks to eat.

The challenge is to avoid deadlocks and resource starvation, while ensuring that all philosophers get to eat. In this section, we used semaphores to solve this problem using functions discussed in part 4.1 .

## How to use?
We recommend you to use a virtual environment on the linux to setup the xv6, like QEMU. Follow these steps to run this repo using QEMU:
- navigate to the desire phase of the project
- open the terminal
- run the following command:
```text
make qemu-nox
```
