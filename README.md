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
- [How to use?]()



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

### Part 3: System Calls


## Phase4: Synchronization

### Part 1: Semaphore Implementation

### Part 2: Dining Philosophers Problem
