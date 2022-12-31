#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

void int_to_string(int n, char *buffer)
{

    int i = 0;

    int isNeg = n < 0;

    unsigned int n1 = isNeg ? -n : n;

    while (n1 != 0)
    {
        buffer[i++] = n1 % 10 + '0';
        n1 = n1 / 10;
    }

    if (isNeg)
        buffer[i++] = '-';

    buffer[i] = '\0';

    for (int t = 0; t < i / 2; t++)
    {
        buffer[t] ^= buffer[i - t - 1];
        buffer[i - t - 1] ^= buffer[t];
        buffer[t] ^= buffer[i - t - 1];
    }

    if (n == 0)
    {
        buffer[0] = '0';
        buffer[1] = '\0';
    }
}


int find_prime_numbers(int first, int last, int *res)
{
    int number_of_numbers = 1;
    if (first > last)
    {
        int temp = first;
        first = last;
        last = temp;
    }
    int flag;
    while (first < last && number_of_numbers <100)
    {
        flag = 0;

        if (first <= 1)
        {
            ++first;
            continue;
        }

        for (int i = 2; i <= first / 2; ++i)
        {
            if (first % i == 0)
            {
                flag = 1;
                break;
            }
        }
        if (flag == 0)
        {

            res[number_of_numbers - 1] = first;
            number_of_numbers++;
        }
        first++;
    }
    return number_of_numbers; // return number of prime number in range of first and last number given
}


int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf(1, "Error! Enter exactly 2 number!\n");
        exit();
    }
    else
    {
        int fd;

        int *result;

        if ((fd = open("prime_numbers.txt", O_CREATE | O_WRONLY)) < 0)
        {
            printf(1, "Error! Cannot open prime numbers file!\n");
            exit();
        }

        result = malloc(sizeof(int) * 100);

        int first_number = atoi(argv[1]);
        int second_number = atoi(argv[2]);
        int num_of_numbers;
        num_of_numbers = find_prime_numbers(first_number, second_number, result);

        for (int i = 0; i < num_of_numbers - 1; ++i)
        {
            char this_number[128];
            int_to_string(result[i], this_number);
            if (write(fd, this_number, strlen(this_number)) != strlen(this_number))
            {
                printf(1, "Error! Cannot write in prime_numbers!/n");
            }
            if (write(fd, "\n", 1) != 1)
            {
                printf(1, "Error! Cannot write in prime_numbers!/n");
                exit();
            }
        }

        close(fd);

        exit();
    }

    exit();
}