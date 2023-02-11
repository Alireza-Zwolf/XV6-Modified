# OS-Lab
A modified [xv6 operating system](https://github.com/mit-pdos/xv6-public) with several extra features. xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix Version 6 (v6).

- [New Features]()
    - [Phase1: Introduction to xv6]() 
        - [Part 1: Boot Message]() 
        - [Part 2: Shell Features]() 
        - [Part 3: User Program]()
    - [Phase2: System Calls]()
    - [Phase3: CPU Scheduling]()
        - [Part 1: Multi-Level Feedback Queue]()
        - [Part 2: Aging]()
        - [Part 3: System Calls]()
    - [Phase4: Synchronization]()
        - [Part 1: Semaphore Implementation]()
        - [Part 2: Dining Philosophers Problem]()
- [How to use?]()

## New Features

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





