
_prime_numbers:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return number_of_numbers; // return number of prime number in range of first and last number given
}


int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 98 00 00 00    	sub    $0x98,%esp
    if (argc != 3)
  17:	83 39 03             	cmpl   $0x3,(%ecx)
{
  1a:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc != 3)
  1d:	74 13                	je     32 <main+0x32>
    {
        printf(1, "Error! Enter exactly 2 number!\n");
  1f:	57                   	push   %edi
  20:	57                   	push   %edi
  21:	68 98 09 00 00       	push   $0x998
  26:	6a 01                	push   $0x1
  28:	e8 43 06 00 00       	call   670 <printf>
        exit();
  2d:	e8 d1 04 00 00       	call   503 <exit>
    {
        int fd;

        int *result;

        if ((fd = open("prime_numbers.txt", O_CREATE | O_WRONLY)) < 0)
  32:	56                   	push   %esi
  33:	56                   	push   %esi
  34:	68 01 02 00 00       	push   $0x201
  39:	68 08 0a 00 00       	push   $0xa08
  3e:	e8 00 05 00 00       	call   543 <open>
  43:	83 c4 10             	add    $0x10,%esp
  46:	89 c6                	mov    %eax,%esi
  48:	85 c0                	test   %eax,%eax
  4a:	0f 88 ec 00 00 00    	js     13c <main+0x13c>
        {
            printf(1, "Error! Cannot open prime numbers file!\n");
            exit();
        }

        result = malloc(sizeof(int) * 100);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	68 90 01 00 00       	push   $0x190
  58:	e8 43 08 00 00       	call   8a0 <malloc>

        int first_number = atoi(argv[1]);
  5d:	5a                   	pop    %edx
  5e:	ff 73 04             	push   0x4(%ebx)
        result = malloc(sizeof(int) * 100);
  61:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
        int first_number = atoi(argv[1]);
  67:	e8 24 04 00 00       	call   490 <atoi>
        int second_number = atoi(argv[2]);
  6c:	59                   	pop    %ecx
  6d:	ff 73 08             	push   0x8(%ebx)
        int first_number = atoi(argv[1]);
  70:	89 c7                	mov    %eax,%edi
        int second_number = atoi(argv[2]);
  72:	e8 19 04 00 00       	call   490 <atoi>
        int num_of_numbers;
        num_of_numbers = find_prime_numbers(first_number, second_number, result);
  77:	83 c4 0c             	add    $0xc,%esp
  7a:	ff b5 60 ff ff ff    	push   -0xa0(%ebp)
  80:	50                   	push   %eax
  81:	57                   	push   %edi
  82:	e8 a9 01 00 00       	call   230 <find_prime_numbers>

        for (int i = 0; i < num_of_numbers - 1; ++i)
  87:	83 c4 10             	add    $0x10,%esp
  8a:	83 e8 01             	sub    $0x1,%eax
  8d:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  93:	85 c0                	test   %eax,%eax
  95:	0f 8e 93 00 00 00    	jle    12e <main+0x12e>
  9b:	31 ff                	xor    %edi,%edi
  9d:	8d 9d 68 ff ff ff    	lea    -0x98(%ebp),%ebx
  a3:	eb 0e                	jmp    b3 <main+0xb3>
  a5:	8d 76 00             	lea    0x0(%esi),%esi
  a8:	83 c7 01             	add    $0x1,%edi
  ab:	3b bd 5c ff ff ff    	cmp    -0xa4(%ebp),%edi
  b1:	74 7b                	je     12e <main+0x12e>
        {
            char this_number[128];
            int_to_string(result[i], this_number);
  b3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	53                   	push   %ebx
  bd:	ff 34 b8             	push   (%eax,%edi,4)
  c0:	e8 8b 00 00 00       	call   150 <int_to_string>
            if (write(fd, this_number, strlen(this_number)) != strlen(this_number))
  c5:	89 1c 24             	mov    %ebx,(%esp)
  c8:	e8 73 02 00 00       	call   340 <strlen>
  cd:	83 c4 0c             	add    $0xc,%esp
  d0:	50                   	push   %eax
  d1:	53                   	push   %ebx
  d2:	56                   	push   %esi
  d3:	e8 4b 04 00 00       	call   523 <write>
  d8:	89 1c 24             	mov    %ebx,(%esp)
  db:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  e1:	e8 5a 02 00 00       	call   340 <strlen>
  e6:	83 c4 10             	add    $0x10,%esp
  e9:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
  ef:	74 12                	je     103 <main+0x103>
            {
                printf(1, "Error! Cannot write in prime_numbers!/n");
  f1:	83 ec 08             	sub    $0x8,%esp
  f4:	68 e0 09 00 00       	push   $0x9e0
  f9:	6a 01                	push   $0x1
  fb:	e8 70 05 00 00       	call   670 <printf>
 100:	83 c4 10             	add    $0x10,%esp
            }
            if (write(fd, "\n", 1) != 1)
 103:	83 ec 04             	sub    $0x4,%esp
 106:	6a 01                	push   $0x1
 108:	68 1a 0a 00 00       	push   $0xa1a
 10d:	56                   	push   %esi
 10e:	e8 10 04 00 00       	call   523 <write>
 113:	83 c4 10             	add    $0x10,%esp
 116:	83 f8 01             	cmp    $0x1,%eax
 119:	74 8d                	je     a8 <main+0xa8>
            {
                printf(1, "Error! Cannot write in prime_numbers!/n");
 11b:	50                   	push   %eax
 11c:	50                   	push   %eax
 11d:	68 e0 09 00 00       	push   $0x9e0
 122:	6a 01                	push   $0x1
 124:	e8 47 05 00 00       	call   670 <printf>
                exit();
 129:	e8 d5 03 00 00       	call   503 <exit>
            }
        }

        close(fd);
 12e:	83 ec 0c             	sub    $0xc,%esp
 131:	56                   	push   %esi
 132:	e8 f4 03 00 00       	call   52b <close>

        exit();
 137:	e8 c7 03 00 00       	call   503 <exit>
            printf(1, "Error! Cannot open prime numbers file!\n");
 13c:	53                   	push   %ebx
 13d:	53                   	push   %ebx
 13e:	68 b8 09 00 00       	push   $0x9b8
 143:	6a 01                	push   $0x1
 145:	e8 26 05 00 00       	call   670 <printf>
            exit();
 14a:	e8 b4 03 00 00       	call   503 <exit>
 14f:	90                   	nop

00000150 <int_to_string>:
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
 155:	53                   	push   %ebx
 156:	83 ec 08             	sub    $0x8,%esp
    unsigned int n1 = isNeg ? -n : n;
 159:	8b 7d 08             	mov    0x8(%ebp),%edi
{
 15c:	8b 75 0c             	mov    0xc(%ebp),%esi
    unsigned int n1 = isNeg ? -n : n;
 15f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 162:	85 ff                	test   %edi,%edi
 164:	0f 88 96 00 00 00    	js     200 <int_to_string+0xb0>
    while (n1 != 0)
 16a:	0f 84 80 00 00 00    	je     1f0 <int_to_string+0xa0>
{
 170:	31 c9                	xor    %ecx,%ecx
 172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        buffer[i++] = n1 % 10 + '0';
 178:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
 17d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
 180:	83 c1 01             	add    $0x1,%ecx
 183:	f7 e3                	mul    %ebx
 185:	89 d8                	mov    %ebx,%eax
 187:	89 4d ec             	mov    %ecx,-0x14(%ebp)
 18a:	c1 ea 03             	shr    $0x3,%edx
 18d:	8d 3c 92             	lea    (%edx,%edx,4),%edi
 190:	01 ff                	add    %edi,%edi
 192:	29 f8                	sub    %edi,%eax
 194:	83 c0 30             	add    $0x30,%eax
 197:	88 44 0e ff          	mov    %al,-0x1(%esi,%ecx,1)
        n1 = n1 / 10;
 19b:	89 d8                	mov    %ebx,%eax
 19d:	89 d3                	mov    %edx,%ebx
    while (n1 != 0)
 19f:	83 f8 09             	cmp    $0x9,%eax
 1a2:	77 d4                	ja     178 <int_to_string+0x28>
    if (isNeg)
 1a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1a7:	85 db                	test   %ebx,%ebx
 1a9:	78 65                	js     210 <int_to_string+0xc0>
    for (int t = 0; t < i / 2; t++)
 1ab:	89 c8                	mov    %ecx,%eax
    buffer[i] = '\0';
 1ad:	c6 04 0e 00          	movb   $0x0,(%esi,%ecx,1)
    for (int t = 0; t < i / 2; t++)
 1b1:	d1 f8                	sar    %eax
 1b3:	74 24                	je     1d9 <int_to_string+0x89>
 1b5:	89 f2                	mov    %esi,%edx
 1b7:	8d 4c 0e ff          	lea    -0x1(%esi,%ecx,1),%ecx
 1bb:	8d 1c 30             	lea    (%eax,%esi,1),%ebx
 1be:	66 90                	xchg   %ax,%ax
        buffer[t] ^= buffer[i - t - 1];
 1c0:	0f b6 02             	movzbl (%edx),%eax
 1c3:	32 01                	xor    (%ecx),%al
    for (int t = 0; t < i / 2; t++)
 1c5:	83 e9 01             	sub    $0x1,%ecx
        buffer[t] ^= buffer[i - t - 1];
 1c8:	88 02                	mov    %al,(%edx)
        buffer[i - t - 1] ^= buffer[t];
 1ca:	32 41 01             	xor    0x1(%ecx),%al
 1cd:	88 41 01             	mov    %al,0x1(%ecx)
        buffer[t] ^= buffer[i - t - 1];
 1d0:	30 02                	xor    %al,(%edx)
    for (int t = 0; t < i / 2; t++)
 1d2:	83 c2 01             	add    $0x1,%edx
 1d5:	39 d3                	cmp    %edx,%ebx
 1d7:	75 e7                	jne    1c0 <int_to_string+0x70>
    if (n == 0)
 1d9:	8b 55 08             	mov    0x8(%ebp),%edx
 1dc:	85 d2                	test   %edx,%edx
 1de:	74 10                	je     1f0 <int_to_string+0xa0>
}
 1e0:	83 c4 08             	add    $0x8,%esp
 1e3:	5b                   	pop    %ebx
 1e4:	5e                   	pop    %esi
 1e5:	5f                   	pop    %edi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    
 1e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop
        buffer[0] = '0';
 1f0:	b8 30 00 00 00       	mov    $0x30,%eax
 1f5:	66 89 06             	mov    %ax,(%esi)
}
 1f8:	83 c4 08             	add    $0x8,%esp
 1fb:	5b                   	pop    %ebx
 1fc:	5e                   	pop    %esi
 1fd:	5f                   	pop    %edi
 1fe:	5d                   	pop    %ebp
 1ff:	c3                   	ret    
    unsigned int n1 = isNeg ? -n : n;
 200:	f7 db                	neg    %ebx
    while (n1 != 0)
 202:	e9 69 ff ff ff       	jmp    170 <int_to_string+0x20>
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax
        buffer[i++] = '-';
 210:	8b 7d f0             	mov    -0x10(%ebp),%edi
 213:	8b 5d ec             	mov    -0x14(%ebp),%ebx
 216:	8d 4f 02             	lea    0x2(%edi),%ecx
 219:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
    for (int t = 0; t < i / 2; t++)
 21d:	89 c8                	mov    %ecx,%eax
    buffer[i] = '\0';
 21f:	c6 44 3e 02 00       	movb   $0x0,0x2(%esi,%edi,1)
    for (int t = 0; t < i / 2; t++)
 224:	d1 f8                	sar    %eax
 226:	eb 8d                	jmp    1b5 <int_to_string+0x65>
 228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <find_prime_numbers>:
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
 236:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (first > last)
 239:	39 5d 08             	cmp    %ebx,0x8(%ebp)
 23c:	7f 0f                	jg     24d <find_prime_numbers+0x1d>
    while (first < last && number_of_numbers <100)
 23e:	bf 01 00 00 00       	mov    $0x1,%edi
 243:	7d 5a                	jge    29f <find_prime_numbers+0x6f>
 245:	89 d8                	mov    %ebx,%eax
 247:	8b 5d 08             	mov    0x8(%ebp),%ebx
 24a:	89 45 08             	mov    %eax,0x8(%ebp)
 24d:	bf 01 00 00 00       	mov    $0x1,%edi
 252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (first <= 1)
 258:	83 fb 01             	cmp    $0x1,%ebx
 25b:	7e 35                	jle    292 <find_prime_numbers+0x62>
        for (int i = 2; i <= first / 2; ++i)
 25d:	89 de                	mov    %ebx,%esi
 25f:	d1 fe                	sar    %esi
 261:	83 fe 01             	cmp    $0x1,%esi
 264:	74 22                	je     288 <find_prime_numbers+0x58>
            if (first % i == 0)
 266:	f6 c3 01             	test   $0x1,%bl
 269:	74 27                	je     292 <find_prime_numbers+0x62>
 26b:	83 c6 01             	add    $0x1,%esi
        for (int i = 2; i <= first / 2; ++i)
 26e:	b9 02 00 00 00       	mov    $0x2,%ecx
 273:	eb 0c                	jmp    281 <find_prime_numbers+0x51>
 275:	8d 76 00             	lea    0x0(%esi),%esi
            if (first % i == 0)
 278:	89 d8                	mov    %ebx,%eax
 27a:	99                   	cltd   
 27b:	f7 f9                	idiv   %ecx
 27d:	85 d2                	test   %edx,%edx
 27f:	74 11                	je     292 <find_prime_numbers+0x62>
        for (int i = 2; i <= first / 2; ++i)
 281:	83 c1 01             	add    $0x1,%ecx
 284:	39 ce                	cmp    %ecx,%esi
 286:	75 f0                	jne    278 <find_prime_numbers+0x48>
            res[number_of_numbers - 1] = first;
 288:	8b 45 10             	mov    0x10(%ebp),%eax
 28b:	89 5c b8 fc          	mov    %ebx,-0x4(%eax,%edi,4)
            number_of_numbers++;
 28f:	83 c7 01             	add    $0x1,%edi
    while (first < last && number_of_numbers <100)
 292:	83 c3 01             	add    $0x1,%ebx
 295:	39 5d 08             	cmp    %ebx,0x8(%ebp)
 298:	7e 05                	jle    29f <find_prime_numbers+0x6f>
 29a:	83 ff 63             	cmp    $0x63,%edi
 29d:	7e b9                	jle    258 <find_prime_numbers+0x28>
}
 29f:	5b                   	pop    %ebx
 2a0:	89 f8                	mov    %edi,%eax
 2a2:	5e                   	pop    %esi
 2a3:	5f                   	pop    %edi
 2a4:	5d                   	pop    %ebp
 2a5:	c3                   	ret    
 2a6:	66 90                	xchg   %ax,%ax
 2a8:	66 90                	xchg   %ax,%ax
 2aa:	66 90                	xchg   %ax,%ax
 2ac:	66 90                	xchg   %ax,%ax
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2b1:	31 c0                	xor    %eax,%eax
{
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	53                   	push   %ebx
 2b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2c7:	83 c0 01             	add    $0x1,%eax
 2ca:	84 d2                	test   %dl,%dl
 2cc:	75 f2                	jne    2c0 <strcpy+0x10>
    ;
  return os;
}
 2ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d1:	89 c8                	mov    %ecx,%eax
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    
 2d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
 2e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2ea:	0f b6 02             	movzbl (%edx),%eax
 2ed:	84 c0                	test   %al,%al
 2ef:	75 17                	jne    308 <strcmp+0x28>
 2f1:	eb 3a                	jmp    32d <strcmp+0x4d>
 2f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2f7:	90                   	nop
 2f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2fc:	83 c2 01             	add    $0x1,%edx
 2ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 302:	84 c0                	test   %al,%al
 304:	74 1a                	je     320 <strcmp+0x40>
    p++, q++;
 306:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 308:	0f b6 19             	movzbl (%ecx),%ebx
 30b:	38 c3                	cmp    %al,%bl
 30d:	74 e9                	je     2f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 30f:	29 d8                	sub    %ebx,%eax
}
 311:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 314:	c9                   	leave  
 315:	c3                   	ret    
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 320:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 324:	31 c0                	xor    %eax,%eax
 326:	29 d8                	sub    %ebx,%eax
}
 328:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 32b:	c9                   	leave  
 32c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 32d:	0f b6 19             	movzbl (%ecx),%ebx
 330:	31 c0                	xor    %eax,%eax
 332:	eb db                	jmp    30f <strcmp+0x2f>
 334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop

00000340 <strlen>:

uint
strlen(const char *s)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 346:	80 3a 00             	cmpb   $0x0,(%edx)
 349:	74 15                	je     360 <strlen+0x20>
 34b:	31 c0                	xor    %eax,%eax
 34d:	8d 76 00             	lea    0x0(%esi),%esi
 350:	83 c0 01             	add    $0x1,%eax
 353:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 357:	89 c1                	mov    %eax,%ecx
 359:	75 f5                	jne    350 <strlen+0x10>
    ;
  return n;
}
 35b:	89 c8                	mov    %ecx,%eax
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    
 35f:	90                   	nop
  for(n = 0; s[n]; n++)
 360:	31 c9                	xor    %ecx,%ecx
}
 362:	5d                   	pop    %ebp
 363:	89 c8                	mov    %ecx,%eax
 365:	c3                   	ret    
 366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36d:	8d 76 00             	lea    0x0(%esi),%esi

00000370 <memset>:

void*
memset(void *dst, int c, uint n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 377:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	89 d7                	mov    %edx,%edi
 37f:	fc                   	cld    
 380:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 382:	8b 7d fc             	mov    -0x4(%ebp),%edi
 385:	89 d0                	mov    %edx,%eax
 387:	c9                   	leave  
 388:	c3                   	ret    
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000390 <strchr>:

char*
strchr(const char *s, char c)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 39a:	0f b6 10             	movzbl (%eax),%edx
 39d:	84 d2                	test   %dl,%dl
 39f:	75 12                	jne    3b3 <strchr+0x23>
 3a1:	eb 1d                	jmp    3c0 <strchr+0x30>
 3a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a7:	90                   	nop
 3a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3ac:	83 c0 01             	add    $0x1,%eax
 3af:	84 d2                	test   %dl,%dl
 3b1:	74 0d                	je     3c0 <strchr+0x30>
    if(*s == c)
 3b3:	38 d1                	cmp    %dl,%cl
 3b5:	75 f1                	jne    3a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3c0:	31 c0                	xor    %eax,%eax
}
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <gets>:

char*
gets(char *buf, int max)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 3d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3d9:	31 db                	xor    %ebx,%ebx
{
 3db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3de:	eb 27                	jmp    407 <gets+0x37>
    cc = read(0, &c, 1);
 3e0:	83 ec 04             	sub    $0x4,%esp
 3e3:	6a 01                	push   $0x1
 3e5:	57                   	push   %edi
 3e6:	6a 00                	push   $0x0
 3e8:	e8 2e 01 00 00       	call   51b <read>
    if(cc < 1)
 3ed:	83 c4 10             	add    $0x10,%esp
 3f0:	85 c0                	test   %eax,%eax
 3f2:	7e 1d                	jle    411 <gets+0x41>
      break;
    buf[i++] = c;
 3f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3f8:	8b 55 08             	mov    0x8(%ebp),%edx
 3fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3ff:	3c 0a                	cmp    $0xa,%al
 401:	74 1d                	je     420 <gets+0x50>
 403:	3c 0d                	cmp    $0xd,%al
 405:	74 19                	je     420 <gets+0x50>
  for(i=0; i+1 < max; ){
 407:	89 de                	mov    %ebx,%esi
 409:	83 c3 01             	add    $0x1,%ebx
 40c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 40f:	7c cf                	jl     3e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 418:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41b:	5b                   	pop    %ebx
 41c:	5e                   	pop    %esi
 41d:	5f                   	pop    %edi
 41e:	5d                   	pop    %ebp
 41f:	c3                   	ret    
  buf[i] = '\0';
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	89 de                	mov    %ebx,%esi
 425:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 429:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop

00000440 <stat>:

int
stat(const char *n, struct stat *st)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	56                   	push   %esi
 444:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 445:	83 ec 08             	sub    $0x8,%esp
 448:	6a 00                	push   $0x0
 44a:	ff 75 08             	push   0x8(%ebp)
 44d:	e8 f1 00 00 00       	call   543 <open>
  if(fd < 0)
 452:	83 c4 10             	add    $0x10,%esp
 455:	85 c0                	test   %eax,%eax
 457:	78 27                	js     480 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 459:	83 ec 08             	sub    $0x8,%esp
 45c:	ff 75 0c             	push   0xc(%ebp)
 45f:	89 c3                	mov    %eax,%ebx
 461:	50                   	push   %eax
 462:	e8 f4 00 00 00       	call   55b <fstat>
  close(fd);
 467:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 46a:	89 c6                	mov    %eax,%esi
  close(fd);
 46c:	e8 ba 00 00 00       	call   52b <close>
  return r;
 471:	83 c4 10             	add    $0x10,%esp
}
 474:	8d 65 f8             	lea    -0x8(%ebp),%esp
 477:	89 f0                	mov    %esi,%eax
 479:	5b                   	pop    %ebx
 47a:	5e                   	pop    %esi
 47b:	5d                   	pop    %ebp
 47c:	c3                   	ret    
 47d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 480:	be ff ff ff ff       	mov    $0xffffffff,%esi
 485:	eb ed                	jmp    474 <stat+0x34>
 487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48e:	66 90                	xchg   %ax,%ax

00000490 <atoi>:

int
atoi(const char *s)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	53                   	push   %ebx
 494:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 497:	0f be 02             	movsbl (%edx),%eax
 49a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 49d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4a5:	77 1e                	ja     4c5 <atoi+0x35>
 4a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4b0:	83 c2 01             	add    $0x1,%edx
 4b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ba:	0f be 02             	movsbl (%edx),%eax
 4bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4c0:	80 fb 09             	cmp    $0x9,%bl
 4c3:	76 eb                	jbe    4b0 <atoi+0x20>
  return n;
}
 4c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4c8:	89 c8                	mov    %ecx,%eax
 4ca:	c9                   	leave  
 4cb:	c3                   	ret    
 4cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	8b 45 10             	mov    0x10(%ebp),%eax
 4d7:	8b 55 08             	mov    0x8(%ebp),%edx
 4da:	56                   	push   %esi
 4db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4de:	85 c0                	test   %eax,%eax
 4e0:	7e 13                	jle    4f5 <memmove+0x25>
 4e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4e4:	89 d7                	mov    %edx,%edi
 4e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4f1:	39 f8                	cmp    %edi,%eax
 4f3:	75 fb                	jne    4f0 <memmove+0x20>
  return vdst;
}
 4f5:	5e                   	pop    %esi
 4f6:	89 d0                	mov    %edx,%eax
 4f8:	5f                   	pop    %edi
 4f9:	5d                   	pop    %ebp
 4fa:	c3                   	ret    

000004fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4fb:	b8 01 00 00 00       	mov    $0x1,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <exit>:
SYSCALL(exit)
 503:	b8 02 00 00 00       	mov    $0x2,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <wait>:
SYSCALL(wait)
 50b:	b8 03 00 00 00       	mov    $0x3,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <pipe>:
SYSCALL(pipe)
 513:	b8 04 00 00 00       	mov    $0x4,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <read>:
SYSCALL(read)
 51b:	b8 05 00 00 00       	mov    $0x5,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <write>:
SYSCALL(write)
 523:	b8 10 00 00 00       	mov    $0x10,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <close>:
SYSCALL(close)
 52b:	b8 15 00 00 00       	mov    $0x15,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <kill>:
SYSCALL(kill)
 533:	b8 06 00 00 00       	mov    $0x6,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <exec>:
SYSCALL(exec)
 53b:	b8 07 00 00 00       	mov    $0x7,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <open>:
SYSCALL(open)
 543:	b8 0f 00 00 00       	mov    $0xf,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <mknod>:
SYSCALL(mknod)
 54b:	b8 11 00 00 00       	mov    $0x11,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <unlink>:
SYSCALL(unlink)
 553:	b8 12 00 00 00       	mov    $0x12,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <fstat>:
SYSCALL(fstat)
 55b:	b8 08 00 00 00       	mov    $0x8,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <link>:
SYSCALL(link)
 563:	b8 13 00 00 00       	mov    $0x13,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <mkdir>:
SYSCALL(mkdir)
 56b:	b8 14 00 00 00       	mov    $0x14,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <chdir>:
SYSCALL(chdir)
 573:	b8 09 00 00 00       	mov    $0x9,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <dup>:
SYSCALL(dup)
 57b:	b8 0a 00 00 00       	mov    $0xa,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <getpid>:
SYSCALL(getpid)
 583:	b8 0b 00 00 00       	mov    $0xb,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <sbrk>:
SYSCALL(sbrk)
 58b:	b8 0c 00 00 00       	mov    $0xc,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <sleep>:
SYSCALL(sleep)
 593:	b8 0d 00 00 00       	mov    $0xd,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <uptime>:
SYSCALL(uptime)
 59b:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <get_parent_pid>:
SYSCALL(get_parent_pid)
 5a3:	b8 16 00 00 00       	mov    $0x16,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <find_largest_prime_factor>:
SYSCALL(find_largest_prime_factor)
 5ab:	b8 17 00 00 00       	mov    $0x17,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <get_callers>:
SYSCALL(get_callers)
 5b3:	b8 18 00 00 00       	mov    $0x18,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    
 5bb:	66 90                	xchg   %ax,%ax
 5bd:	66 90                	xchg   %ax,%ax
 5bf:	90                   	nop

000005c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 3c             	sub    $0x3c,%esp
 5c9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5cc:	89 d1                	mov    %edx,%ecx
{
 5ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5d1:	85 d2                	test   %edx,%edx
 5d3:	0f 89 7f 00 00 00    	jns    658 <printint+0x98>
 5d9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5dd:	74 79                	je     658 <printint+0x98>
    neg = 1;
 5df:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5e6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5e8:	31 db                	xor    %ebx,%ebx
 5ea:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5f0:	89 c8                	mov    %ecx,%eax
 5f2:	31 d2                	xor    %edx,%edx
 5f4:	89 cf                	mov    %ecx,%edi
 5f6:	f7 75 c4             	divl   -0x3c(%ebp)
 5f9:	0f b6 92 7c 0a 00 00 	movzbl 0xa7c(%edx),%edx
 600:	89 45 c0             	mov    %eax,-0x40(%ebp)
 603:	89 d8                	mov    %ebx,%eax
 605:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 608:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 60b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 60e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 611:	76 dd                	jbe    5f0 <printint+0x30>
  if(neg)
 613:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 616:	85 c9                	test   %ecx,%ecx
 618:	74 0c                	je     626 <printint+0x66>
    buf[i++] = '-';
 61a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 61f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 621:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 626:	8b 7d b8             	mov    -0x48(%ebp),%edi
 629:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 62d:	eb 07                	jmp    636 <printint+0x76>
 62f:	90                   	nop
    putc(fd, buf[i]);
 630:	0f b6 13             	movzbl (%ebx),%edx
 633:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 636:	83 ec 04             	sub    $0x4,%esp
 639:	88 55 d7             	mov    %dl,-0x29(%ebp)
 63c:	6a 01                	push   $0x1
 63e:	56                   	push   %esi
 63f:	57                   	push   %edi
 640:	e8 de fe ff ff       	call   523 <write>
  while(--i >= 0)
 645:	83 c4 10             	add    $0x10,%esp
 648:	39 de                	cmp    %ebx,%esi
 64a:	75 e4                	jne    630 <printint+0x70>
}
 64c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64f:	5b                   	pop    %ebx
 650:	5e                   	pop    %esi
 651:	5f                   	pop    %edi
 652:	5d                   	pop    %ebp
 653:	c3                   	ret    
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 658:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 65f:	eb 87                	jmp    5e8 <printint+0x28>
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66f:	90                   	nop

00000670 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 679:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 67c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 67f:	0f b6 13             	movzbl (%ebx),%edx
 682:	84 d2                	test   %dl,%dl
 684:	74 6a                	je     6f0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 686:	8d 45 10             	lea    0x10(%ebp),%eax
 689:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 68c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 68f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 691:	89 45 d0             	mov    %eax,-0x30(%ebp)
 694:	eb 36                	jmp    6cc <printf+0x5c>
 696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
 6a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6a3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 6a8:	83 f8 25             	cmp    $0x25,%eax
 6ab:	74 15                	je     6c2 <printf+0x52>
  write(fd, &c, 1);
 6ad:	83 ec 04             	sub    $0x4,%esp
 6b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6b3:	6a 01                	push   $0x1
 6b5:	57                   	push   %edi
 6b6:	56                   	push   %esi
 6b7:	e8 67 fe ff ff       	call   523 <write>
 6bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 6bf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6c2:	0f b6 13             	movzbl (%ebx),%edx
 6c5:	83 c3 01             	add    $0x1,%ebx
 6c8:	84 d2                	test   %dl,%dl
 6ca:	74 24                	je     6f0 <printf+0x80>
    c = fmt[i] & 0xff;
 6cc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 6cf:	85 c9                	test   %ecx,%ecx
 6d1:	74 cd                	je     6a0 <printf+0x30>
      }
    } else if(state == '%'){
 6d3:	83 f9 25             	cmp    $0x25,%ecx
 6d6:	75 ea                	jne    6c2 <printf+0x52>
      if(c == 'd'){
 6d8:	83 f8 25             	cmp    $0x25,%eax
 6db:	0f 84 07 01 00 00    	je     7e8 <printf+0x178>
 6e1:	83 e8 63             	sub    $0x63,%eax
 6e4:	83 f8 15             	cmp    $0x15,%eax
 6e7:	77 17                	ja     700 <printf+0x90>
 6e9:	ff 24 85 24 0a 00 00 	jmp    *0xa24(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
 6f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 706:	6a 01                	push   $0x1
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 70e:	e8 10 fe ff ff       	call   523 <write>
        putc(fd, c);
 713:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 717:	83 c4 0c             	add    $0xc,%esp
 71a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 71d:	6a 01                	push   $0x1
 71f:	57                   	push   %edi
 720:	56                   	push   %esi
 721:	e8 fd fd ff ff       	call   523 <write>
        putc(fd, c);
 726:	83 c4 10             	add    $0x10,%esp
      state = 0;
 729:	31 c9                	xor    %ecx,%ecx
 72b:	eb 95                	jmp    6c2 <printf+0x52>
 72d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 730:	83 ec 0c             	sub    $0xc,%esp
 733:	b9 10 00 00 00       	mov    $0x10,%ecx
 738:	6a 00                	push   $0x0
 73a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 73d:	8b 10                	mov    (%eax),%edx
 73f:	89 f0                	mov    %esi,%eax
 741:	e8 7a fe ff ff       	call   5c0 <printint>
        ap++;
 746:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 74a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74d:	31 c9                	xor    %ecx,%ecx
 74f:	e9 6e ff ff ff       	jmp    6c2 <printf+0x52>
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 758:	8b 45 d0             	mov    -0x30(%ebp),%eax
 75b:	8b 10                	mov    (%eax),%edx
        ap++;
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 763:	85 d2                	test   %edx,%edx
 765:	0f 84 8d 00 00 00    	je     7f8 <printf+0x188>
        while(*s != 0){
 76b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 76e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 770:	84 c0                	test   %al,%al
 772:	0f 84 4a ff ff ff    	je     6c2 <printf+0x52>
 778:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 77b:	89 d3                	mov    %edx,%ebx
 77d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
          s++;
 783:	83 c3 01             	add    $0x1,%ebx
 786:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 789:	6a 01                	push   $0x1
 78b:	57                   	push   %edi
 78c:	56                   	push   %esi
 78d:	e8 91 fd ff ff       	call   523 <write>
        while(*s != 0){
 792:	0f b6 03             	movzbl (%ebx),%eax
 795:	83 c4 10             	add    $0x10,%esp
 798:	84 c0                	test   %al,%al
 79a:	75 e4                	jne    780 <printf+0x110>
      state = 0;
 79c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 79f:	31 c9                	xor    %ecx,%ecx
 7a1:	e9 1c ff ff ff       	jmp    6c2 <printf+0x52>
 7a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b8:	6a 01                	push   $0x1
 7ba:	e9 7b ff ff ff       	jmp    73a <printf+0xca>
 7bf:	90                   	nop
        putc(fd, *ap);
 7c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 7c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7c6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 7c8:	6a 01                	push   $0x1
 7ca:	57                   	push   %edi
 7cb:	56                   	push   %esi
        putc(fd, *ap);
 7cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7cf:	e8 4f fd ff ff       	call   523 <write>
        ap++;
 7d4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7db:	31 c9                	xor    %ecx,%ecx
 7dd:	e9 e0 fe ff ff       	jmp    6c2 <printf+0x52>
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 7e8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 7eb:	83 ec 04             	sub    $0x4,%esp
 7ee:	e9 2a ff ff ff       	jmp    71d <printf+0xad>
 7f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7f7:	90                   	nop
          s = "(null)";
 7f8:	ba 1c 0a 00 00       	mov    $0xa1c,%edx
        while(*s != 0){
 7fd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 800:	b8 28 00 00 00       	mov    $0x28,%eax
 805:	89 d3                	mov    %edx,%ebx
 807:	e9 74 ff ff ff       	jmp    780 <printf+0x110>
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 9c 0d 00 00       	mov    0xd9c,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 828:	89 c2                	mov    %eax,%edx
 82a:	8b 00                	mov    (%eax),%eax
 82c:	39 ca                	cmp    %ecx,%edx
 82e:	73 30                	jae    860 <free+0x50>
 830:	39 c1                	cmp    %eax,%ecx
 832:	72 04                	jb     838 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	39 c2                	cmp    %eax,%edx
 836:	72 f0                	jb     828 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 838:	8b 73 fc             	mov    -0x4(%ebx),%esi
 83b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83e:	39 f8                	cmp    %edi,%eax
 840:	74 30                	je     872 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 845:	8b 42 04             	mov    0x4(%edx),%eax
 848:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 84b:	39 f1                	cmp    %esi,%ecx
 84d:	74 3a                	je     889 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 84f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 851:	5b                   	pop    %ebx
  freep = p;
 852:	89 15 9c 0d 00 00    	mov    %edx,0xd9c
}
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret    
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 c2                	cmp    %eax,%edx
 862:	72 c4                	jb     828 <free+0x18>
 864:	39 c1                	cmp    %eax,%ecx
 866:	73 c0                	jae    828 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 868:	8b 73 fc             	mov    -0x4(%ebx),%esi
 86b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 86e:	39 f8                	cmp    %edi,%eax
 870:	75 d0                	jne    842 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 872:	03 70 04             	add    0x4(%eax),%esi
 875:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 878:	8b 02                	mov    (%edx),%eax
 87a:	8b 00                	mov    (%eax),%eax
 87c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 87f:	8b 42 04             	mov    0x4(%edx),%eax
 882:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 885:	39 f1                	cmp    %esi,%ecx
 887:	75 c6                	jne    84f <free+0x3f>
    p->s.size += bp->s.size;
 889:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 88c:	89 15 9c 0d 00 00    	mov    %edx,0xd9c
    p->s.size += bp->s.size;
 892:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 895:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 898:	89 0a                	mov    %ecx,(%edx)
}
 89a:	5b                   	pop    %ebx
 89b:	5e                   	pop    %esi
 89c:	5f                   	pop    %edi
 89d:	5d                   	pop    %ebp
 89e:	c3                   	ret    
 89f:	90                   	nop

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 3d 9c 0d 00 00    	mov    0xd9c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 70 07             	lea    0x7(%eax),%esi
 8b5:	c1 ee 03             	shr    $0x3,%esi
 8b8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8bb:	85 ff                	test   %edi,%edi
 8bd:	0f 84 9d 00 00 00    	je     960 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8c5:	8b 4a 04             	mov    0x4(%edx),%ecx
 8c8:	39 f1                	cmp    %esi,%ecx
 8ca:	73 6a                	jae    936 <malloc+0x96>
 8cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d1:	39 de                	cmp    %ebx,%esi
 8d3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8d6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 8e0:	eb 17                	jmp    8f9 <malloc+0x59>
 8e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ea:	8b 48 04             	mov    0x4(%eax),%ecx
 8ed:	39 f1                	cmp    %esi,%ecx
 8ef:	73 4f                	jae    940 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f1:	8b 3d 9c 0d 00 00    	mov    0xd9c,%edi
 8f7:	89 c2                	mov    %eax,%edx
 8f9:	39 d7                	cmp    %edx,%edi
 8fb:	75 eb                	jne    8e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8fd:	83 ec 0c             	sub    $0xc,%esp
 900:	ff 75 e4             	push   -0x1c(%ebp)
 903:	e8 83 fc ff ff       	call   58b <sbrk>
  if(p == (char*)-1)
 908:	83 c4 10             	add    $0x10,%esp
 90b:	83 f8 ff             	cmp    $0xffffffff,%eax
 90e:	74 1c                	je     92c <malloc+0x8c>
  hp->s.size = nu;
 910:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 913:	83 ec 0c             	sub    $0xc,%esp
 916:	83 c0 08             	add    $0x8,%eax
 919:	50                   	push   %eax
 91a:	e8 f1 fe ff ff       	call   810 <free>
  return freep;
 91f:	8b 15 9c 0d 00 00    	mov    0xd9c,%edx
      if((p = morecore(nunits)) == 0)
 925:	83 c4 10             	add    $0x10,%esp
 928:	85 d2                	test   %edx,%edx
 92a:	75 bc                	jne    8e8 <malloc+0x48>
        return 0;
  }
}
 92c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 92f:	31 c0                	xor    %eax,%eax
}
 931:	5b                   	pop    %ebx
 932:	5e                   	pop    %esi
 933:	5f                   	pop    %edi
 934:	5d                   	pop    %ebp
 935:	c3                   	ret    
    if(p->s.size >= nunits){
 936:	89 d0                	mov    %edx,%eax
 938:	89 fa                	mov    %edi,%edx
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 940:	39 ce                	cmp    %ecx,%esi
 942:	74 4c                	je     990 <malloc+0xf0>
        p->s.size -= nunits;
 944:	29 f1                	sub    %esi,%ecx
 946:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 949:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 94c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 94f:	89 15 9c 0d 00 00    	mov    %edx,0xd9c
}
 955:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 958:	83 c0 08             	add    $0x8,%eax
}
 95b:	5b                   	pop    %ebx
 95c:	5e                   	pop    %esi
 95d:	5f                   	pop    %edi
 95e:	5d                   	pop    %ebp
 95f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 9c 0d 00 00 a0 	movl   $0xda0,0xd9c
 967:	0d 00 00 
    base.s.size = 0;
 96a:	bf a0 0d 00 00       	mov    $0xda0,%edi
    base.s.ptr = freep = prevp = &base;
 96f:	c7 05 a0 0d 00 00 a0 	movl   $0xda0,0xda0
 976:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 979:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 97b:	c7 05 a4 0d 00 00 00 	movl   $0x0,0xda4
 982:	00 00 00 
    if(p->s.size >= nunits){
 985:	e9 42 ff ff ff       	jmp    8cc <malloc+0x2c>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb b9                	jmp    94f <malloc+0xaf>
