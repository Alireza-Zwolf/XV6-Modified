#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{
    printf(1, "process ids for SYS_write are: ");
    get_callers(16);
    printf(1, "\n");
    printf(1, "process ids for SYS_fork are: ");
    get_callers(1);
    printf(1, "\n");
    printf(1, "process ids for SYS_wait are: ");
    get_callers(3);
    printf(1, "\n");
    exit();
}
