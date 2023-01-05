
_phil:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define WRITE_FD 1

int semaphor_state = 0;

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi

        printf(WRITE_FD, "Philosopher %d is hungry\n", phNum);\
        /* Even philasophers first take their right chopstick, then take left chopstick */
        /* Odd philasophers first take their left chopstick, then take their right chopstick */
        /* By using this roadmap, we won't encounter any deadlock */
        if (phNum % 2 == 0) {           
   f:	be 64 00 00 00       	mov    $0x64,%esi
{
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 24             	sub    $0x24,%esp
  19:	8b 41 04             	mov    0x4(%ecx),%eax
    phNum = atoi(argv[0]);
  1c:	ff 30                	push   (%eax)
  1e:	e8 ed 02 00 00       	call   310 <atoi>
            semaphor_state = sem_acquire(phNum, phNum);
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
        }
        else {
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  23:	ba 67 66 66 66       	mov    $0x66666667,%edx
        if (phNum % 2 == 0) {           
  28:	83 c4 10             	add    $0x10,%esp
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  2b:	8d 48 04             	lea    0x4(%eax),%ecx
    phNum = atoi(argv[0]);
  2e:	89 c3                	mov    %eax,%ebx
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  30:	89 c8                	mov    %ecx,%eax
  32:	f7 ea                	imul   %edx
  34:	89 c8                	mov    %ecx,%eax
  36:	c1 f8 1f             	sar    $0x1f,%eax
  39:	d1 fa                	sar    %edx
  3b:	29 c2                	sub    %eax,%edx
  3d:	8d 04 92             	lea    (%edx,%edx,4),%eax
  40:	29 c1                	sub    %eax,%ecx
        if (phNum % 2 == 0) {           
  42:	89 d8                	mov    %ebx,%eax
  44:	83 e0 01             	and    $0x1,%eax
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  47:	89 cf                	mov    %ecx,%edi
        if (phNum % 2 == 0) {           
  49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  4c:	eb 72                	jmp    c0 <main+0xc0>
  4e:	66 90                	xchg   %ax,%ax
            semaphor_state = sem_acquire(phNum, phNum);
  50:	83 ec 08             	sub    $0x8,%esp
  53:	53                   	push   %ebx
  54:	53                   	push   %ebx
  55:	e8 d1 03 00 00       	call   42b <sem_acquire>
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  5a:	59                   	pop    %ecx
            semaphor_state = sem_acquire(phNum, phNum);
  5b:	a3 b8 0b 00 00       	mov    %eax,0xbb8
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  60:	58                   	pop    %eax
  61:	53                   	push   %ebx
  62:	57                   	push   %edi
  63:	e8 c3 03 00 00       	call   42b <sem_acquire>
  68:	83 c4 10             	add    $0x10,%esp
            semaphor_state = sem_acquire(phNum, phNum);
        }
        
        printf(WRITE_FD, "Philosopher %d is eating\n", phNum);
  6b:	83 ec 04             	sub    $0x4,%esp
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  6e:	a3 b8 0b 00 00       	mov    %eax,0xbb8
        printf(WRITE_FD, "Philosopher %d is eating\n", phNum);
  73:	53                   	push   %ebx
  74:	68 4e 08 00 00       	push   $0x84e
  79:	6a 01                	push   $0x1
  7b:	e8 70 04 00 00       	call   4f0 <printf>

        // EATING
        sleep(1);
  80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  87:	e8 87 03 00 00       	call   413 <sleep>
        printf(WRITE_FD, "Philosopher %d is dropping chopsticks\n", phNum);
  8c:	83 c4 0c             	add    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	68 68 08 00 00       	push   $0x868
  95:	6a 01                	push   $0x1
  97:	e8 54 04 00 00       	call   4f0 <printf>
        // SLEEPING
        semaphor_state = sem_release(phNum, phNum);
  9c:	58                   	pop    %eax
  9d:	5a                   	pop    %edx
  9e:	53                   	push   %ebx
  9f:	53                   	push   %ebx
  a0:	e8 8e 03 00 00       	call   433 <sem_release>
        semaphor_state = sem_release((phNum+4) % 5, phNum);
  a5:	59                   	pop    %ecx
        semaphor_state = sem_release(phNum, phNum);
  a6:	a3 b8 0b 00 00       	mov    %eax,0xbb8
        semaphor_state = sem_release((phNum+4) % 5, phNum);
  ab:	58                   	pop    %eax
  ac:	53                   	push   %ebx
  ad:	57                   	push   %edi
  ae:	e8 80 03 00 00       	call   433 <sem_release>
    for (int round = 0; round < 100; round++) {
  b3:	83 c4 10             	add    $0x10,%esp
        semaphor_state = sem_release((phNum+4) % 5, phNum);
  b6:	a3 b8 0b 00 00       	mov    %eax,0xbb8
    for (int round = 0; round < 100; round++) {
  bb:	83 ee 01             	sub    $0x1,%esi
  be:	74 5a                	je     11a <main+0x11a>
        printf(WRITE_FD, "Philosopher %d is thinking\n", phNum);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	53                   	push   %ebx
  c4:	68 18 08 00 00       	push   $0x818
  c9:	6a 01                	push   $0x1
  cb:	e8 20 04 00 00       	call   4f0 <printf>
        sleep(1);
  d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d7:	e8 37 03 00 00       	call   413 <sleep>
        printf(WRITE_FD, "Philosopher %d is hungry\n", phNum);\
  dc:	83 c4 0c             	add    $0xc,%esp
  df:	53                   	push   %ebx
  e0:	68 34 08 00 00       	push   $0x834
  e5:	6a 01                	push   $0x1
  e7:	e8 04 04 00 00       	call   4f0 <printf>
        if (phNum % 2 == 0) {           
  ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	85 c0                	test   %eax,%eax
  f4:	0f 84 56 ff ff ff    	je     50 <main+0x50>
            semaphor_state = sem_acquire((phNum+4) % 5, phNum);
  fa:	83 ec 08             	sub    $0x8,%esp
  fd:	53                   	push   %ebx
  fe:	57                   	push   %edi
  ff:	e8 27 03 00 00       	call   42b <sem_acquire>
 104:	a3 b8 0b 00 00       	mov    %eax,0xbb8
            semaphor_state = sem_acquire(phNum, phNum);
 109:	58                   	pop    %eax
 10a:	5a                   	pop    %edx
 10b:	53                   	push   %ebx
 10c:	53                   	push   %ebx
 10d:	e8 19 03 00 00       	call   42b <sem_acquire>
 112:	83 c4 10             	add    $0x10,%esp
 115:	e9 51 ff ff ff       	jmp    6b <main+0x6b>
        // sleep(10);
    }
    
 11a:	8d 65 f0             	lea    -0x10(%ebp),%esp
 11d:	31 c0                	xor    %eax,%eax
 11f:	59                   	pop    %ecx
 120:	5b                   	pop    %ebx
 121:	5e                   	pop    %esi
 122:	5f                   	pop    %edi
 123:	5d                   	pop    %ebp
 124:	8d 61 fc             	lea    -0x4(%ecx),%esp
 127:	c3                   	ret    
 128:	66 90                	xchg   %ax,%ax
 12a:	66 90                	xchg   %ax,%ax
 12c:	66 90                	xchg   %ax,%ax
 12e:	66 90                	xchg   %ax,%ax

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 130:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 131:	31 c0                	xor    %eax,%eax
{
 133:	89 e5                	mov    %esp,%ebp
 135:	53                   	push   %ebx
 136:	8b 4d 08             	mov    0x8(%ebp),%ecx
 139:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 140:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 144:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 147:	83 c0 01             	add    $0x1,%eax
 14a:	84 d2                	test   %dl,%dl
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 151:	89 c8                	mov    %ecx,%eax
 153:	c9                   	leave  
 154:	c3                   	ret    
 155:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 55 08             	mov    0x8(%ebp),%edx
 167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 16a:	0f b6 02             	movzbl (%edx),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 17                	jne    188 <strcmp+0x28>
 171:	eb 3a                	jmp    1ad <strcmp+0x4d>
 173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 177:	90                   	nop
 178:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 17c:	83 c2 01             	add    $0x1,%edx
 17f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 182:	84 c0                	test   %al,%al
 184:	74 1a                	je     1a0 <strcmp+0x40>
    p++, q++;
 186:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 188:	0f b6 19             	movzbl (%ecx),%ebx
 18b:	38 c3                	cmp    %al,%bl
 18d:	74 e9                	je     178 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 18f:	29 d8                	sub    %ebx,%eax
}
 191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 194:	c9                   	leave  
 195:	c3                   	ret    
 196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 1a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1a4:	31 c0                	xor    %eax,%eax
 1a6:	29 d8                	sub    %ebx,%eax
}
 1a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ab:	c9                   	leave  
 1ac:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 1ad:	0f b6 19             	movzbl (%ecx),%ebx
 1b0:	31 c0                	xor    %eax,%eax
 1b2:	eb db                	jmp    18f <strcmp+0x2f>
 1b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1bf:	90                   	nop

000001c0 <strlen>:

uint
strlen(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1c6:	80 3a 00             	cmpb   $0x0,(%edx)
 1c9:	74 15                	je     1e0 <strlen+0x20>
 1cb:	31 c0                	xor    %eax,%eax
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	83 c0 01             	add    $0x1,%eax
 1d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1d7:	89 c1                	mov    %eax,%ecx
 1d9:	75 f5                	jne    1d0 <strlen+0x10>
    ;
  return n;
}
 1db:	89 c8                	mov    %ecx,%eax
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    
 1df:	90                   	nop
  for(n = 0; s[n]; n++)
 1e0:	31 c9                	xor    %ecx,%ecx
}
 1e2:	5d                   	pop    %ebp
 1e3:	89 c8                	mov    %ecx,%eax
 1e5:	c3                   	ret    
 1e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 d7                	mov    %edx,%edi
 1ff:	fc                   	cld    
 200:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 202:	8b 7d fc             	mov    -0x4(%ebp),%edi
 205:	89 d0                	mov    %edx,%eax
 207:	c9                   	leave  
 208:	c3                   	ret    
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 21a:	0f b6 10             	movzbl (%eax),%edx
 21d:	84 d2                	test   %dl,%dl
 21f:	75 12                	jne    233 <strchr+0x23>
 221:	eb 1d                	jmp    240 <strchr+0x30>
 223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 227:	90                   	nop
 228:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 22c:	83 c0 01             	add    $0x1,%eax
 22f:	84 d2                	test   %dl,%dl
 231:	74 0d                	je     240 <strchr+0x30>
    if(*s == c)
 233:	38 d1                	cmp    %dl,%cl
 235:	75 f1                	jne    228 <strchr+0x18>
      return (char*)s;
  return 0;
}
 237:	5d                   	pop    %ebp
 238:	c3                   	ret    
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 240:	31 c0                	xor    %eax,%eax
}
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
 244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 24f:	90                   	nop

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 255:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 258:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 259:	31 db                	xor    %ebx,%ebx
{
 25b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 25e:	eb 27                	jmp    287 <gets+0x37>
    cc = read(0, &c, 1);
 260:	83 ec 04             	sub    $0x4,%esp
 263:	6a 01                	push   $0x1
 265:	57                   	push   %edi
 266:	6a 00                	push   $0x0
 268:	e8 2e 01 00 00       	call   39b <read>
    if(cc < 1)
 26d:	83 c4 10             	add    $0x10,%esp
 270:	85 c0                	test   %eax,%eax
 272:	7e 1d                	jle    291 <gets+0x41>
      break;
    buf[i++] = c;
 274:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 278:	8b 55 08             	mov    0x8(%ebp),%edx
 27b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 27f:	3c 0a                	cmp    $0xa,%al
 281:	74 1d                	je     2a0 <gets+0x50>
 283:	3c 0d                	cmp    $0xd,%al
 285:	74 19                	je     2a0 <gets+0x50>
  for(i=0; i+1 < max; ){
 287:	89 de                	mov    %ebx,%esi
 289:	83 c3 01             	add    $0x1,%ebx
 28c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 28f:	7c cf                	jl     260 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 298:	8d 65 f4             	lea    -0xc(%ebp),%esp
 29b:	5b                   	pop    %ebx
 29c:	5e                   	pop    %esi
 29d:	5f                   	pop    %edi
 29e:	5d                   	pop    %ebp
 29f:	c3                   	ret    
  buf[i] = '\0';
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 de                	mov    %ebx,%esi
 2a5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 2a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ac:	5b                   	pop    %ebx
 2ad:	5e                   	pop    %esi
 2ae:	5f                   	pop    %edi
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    
 2b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	56                   	push   %esi
 2c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c5:	83 ec 08             	sub    $0x8,%esp
 2c8:	6a 00                	push   $0x0
 2ca:	ff 75 08             	push   0x8(%ebp)
 2cd:	e8 f1 00 00 00       	call   3c3 <open>
  if(fd < 0)
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	78 27                	js     300 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	ff 75 0c             	push   0xc(%ebp)
 2df:	89 c3                	mov    %eax,%ebx
 2e1:	50                   	push   %eax
 2e2:	e8 f4 00 00 00       	call   3db <fstat>
  close(fd);
 2e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ea:	89 c6                	mov    %eax,%esi
  close(fd);
 2ec:	e8 ba 00 00 00       	call   3ab <close>
  return r;
 2f1:	83 c4 10             	add    $0x10,%esp
}
 2f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2f7:	89 f0                	mov    %esi,%eax
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 300:	be ff ff ff ff       	mov    $0xffffffff,%esi
 305:	eb ed                	jmp    2f4 <stat+0x34>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 317:	0f be 02             	movsbl (%edx),%eax
 31a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 31d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 320:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 325:	77 1e                	ja     345 <atoi+0x35>
 327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 330:	83 c2 01             	add    $0x1,%edx
 333:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 336:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 33a:	0f be 02             	movsbl (%edx),%eax
 33d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 340:	80 fb 09             	cmp    $0x9,%bl
 343:	76 eb                	jbe    330 <atoi+0x20>
  return n;
}
 345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 348:	89 c8                	mov    %ecx,%eax
 34a:	c9                   	leave  
 34b:	c3                   	ret    
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 45 10             	mov    0x10(%ebp),%eax
 357:	8b 55 08             	mov    0x8(%ebp),%edx
 35a:	56                   	push   %esi
 35b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	85 c0                	test   %eax,%eax
 360:	7e 13                	jle    375 <memmove+0x25>
 362:	01 d0                	add    %edx,%eax
  dst = vdst;
 364:	89 d7                	mov    %edx,%edi
 366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 370:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 371:	39 f8                	cmp    %edi,%eax
 373:	75 fb                	jne    370 <memmove+0x20>
  return vdst;
}
 375:	5e                   	pop    %esi
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    

0000037b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37b:	b8 01 00 00 00       	mov    $0x1,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <exit>:
SYSCALL(exit)
 383:	b8 02 00 00 00       	mov    $0x2,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <wait>:
SYSCALL(wait)
 38b:	b8 03 00 00 00       	mov    $0x3,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <pipe>:
SYSCALL(pipe)
 393:	b8 04 00 00 00       	mov    $0x4,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <read>:
SYSCALL(read)
 39b:	b8 05 00 00 00       	mov    $0x5,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <write>:
SYSCALL(write)
 3a3:	b8 10 00 00 00       	mov    $0x10,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <close>:
SYSCALL(close)
 3ab:	b8 15 00 00 00       	mov    $0x15,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <kill>:
SYSCALL(kill)
 3b3:	b8 06 00 00 00       	mov    $0x6,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <exec>:
SYSCALL(exec)
 3bb:	b8 07 00 00 00       	mov    $0x7,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <open>:
SYSCALL(open)
 3c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mknod>:
SYSCALL(mknod)
 3cb:	b8 11 00 00 00       	mov    $0x11,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <unlink>:
SYSCALL(unlink)
 3d3:	b8 12 00 00 00       	mov    $0x12,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <fstat>:
SYSCALL(fstat)
 3db:	b8 08 00 00 00       	mov    $0x8,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <link>:
SYSCALL(link)
 3e3:	b8 13 00 00 00       	mov    $0x13,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mkdir>:
SYSCALL(mkdir)
 3eb:	b8 14 00 00 00       	mov    $0x14,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <chdir>:
SYSCALL(chdir)
 3f3:	b8 09 00 00 00       	mov    $0x9,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <dup>:
SYSCALL(dup)
 3fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <getpid>:
SYSCALL(getpid)
 403:	b8 0b 00 00 00       	mov    $0xb,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <sbrk>:
SYSCALL(sbrk)
 40b:	b8 0c 00 00 00       	mov    $0xc,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <sleep>:
SYSCALL(sleep)
 413:	b8 0d 00 00 00       	mov    $0xd,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <uptime>:
SYSCALL(uptime)
 41b:	b8 0e 00 00 00       	mov    $0xe,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <sem_init>:
SYSCALL(sem_init)
 423:	b8 16 00 00 00       	mov    $0x16,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sem_acquire>:
SYSCALL(sem_acquire)
 42b:	b8 17 00 00 00       	mov    $0x17,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sem_release>:
SYSCALL(sem_release)
 433:	b8 18 00 00 00       	mov    $0x18,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    
 43b:	66 90                	xchg   %ax,%ax
 43d:	66 90                	xchg   %ax,%ax
 43f:	90                   	nop

00000440 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 3c             	sub    $0x3c,%esp
 449:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 44c:	89 d1                	mov    %edx,%ecx
{
 44e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 451:	85 d2                	test   %edx,%edx
 453:	0f 89 7f 00 00 00    	jns    4d8 <printint+0x98>
 459:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 45d:	74 79                	je     4d8 <printint+0x98>
    neg = 1;
 45f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 466:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 468:	31 db                	xor    %ebx,%ebx
 46a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 470:	89 c8                	mov    %ecx,%eax
 472:	31 d2                	xor    %edx,%edx
 474:	89 cf                	mov    %ecx,%edi
 476:	f7 75 c4             	divl   -0x3c(%ebp)
 479:	0f b6 92 f0 08 00 00 	movzbl 0x8f0(%edx),%edx
 480:	89 45 c0             	mov    %eax,-0x40(%ebp)
 483:	89 d8                	mov    %ebx,%eax
 485:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 488:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 48b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 48e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 491:	76 dd                	jbe    470 <printint+0x30>
  if(neg)
 493:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 496:	85 c9                	test   %ecx,%ecx
 498:	74 0c                	je     4a6 <printint+0x66>
    buf[i++] = '-';
 49a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 49f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4ad:	eb 07                	jmp    4b6 <printint+0x76>
 4af:	90                   	nop
    putc(fd, buf[i]);
 4b0:	0f b6 13             	movzbl (%ebx),%edx
 4b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4b6:	83 ec 04             	sub    $0x4,%esp
 4b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4bc:	6a 01                	push   $0x1
 4be:	56                   	push   %esi
 4bf:	57                   	push   %edi
 4c0:	e8 de fe ff ff       	call   3a3 <write>
  while(--i >= 0)
 4c5:	83 c4 10             	add    $0x10,%esp
 4c8:	39 de                	cmp    %ebx,%esi
 4ca:	75 e4                	jne    4b0 <printint+0x70>
}
 4cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cf:	5b                   	pop    %ebx
 4d0:	5e                   	pop    %esi
 4d1:	5f                   	pop    %edi
 4d2:	5d                   	pop    %ebp
 4d3:	c3                   	ret    
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4df:	eb 87                	jmp    468 <printint+0x28>
 4e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop

000004f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4fc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4ff:	0f b6 13             	movzbl (%ebx),%edx
 502:	84 d2                	test   %dl,%dl
 504:	74 6a                	je     570 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 506:	8d 45 10             	lea    0x10(%ebp),%eax
 509:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 50c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 50f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 511:	89 45 d0             	mov    %eax,-0x30(%ebp)
 514:	eb 36                	jmp    54c <printf+0x5c>
 516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51d:	8d 76 00             	lea    0x0(%esi),%esi
 520:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 523:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	74 15                	je     542 <printf+0x52>
  write(fd, &c, 1);
 52d:	83 ec 04             	sub    $0x4,%esp
 530:	88 55 e7             	mov    %dl,-0x19(%ebp)
 533:	6a 01                	push   $0x1
 535:	57                   	push   %edi
 536:	56                   	push   %esi
 537:	e8 67 fe ff ff       	call   3a3 <write>
 53c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 53f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 542:	0f b6 13             	movzbl (%ebx),%edx
 545:	83 c3 01             	add    $0x1,%ebx
 548:	84 d2                	test   %dl,%dl
 54a:	74 24                	je     570 <printf+0x80>
    c = fmt[i] & 0xff;
 54c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 54f:	85 c9                	test   %ecx,%ecx
 551:	74 cd                	je     520 <printf+0x30>
      }
    } else if(state == '%'){
 553:	83 f9 25             	cmp    $0x25,%ecx
 556:	75 ea                	jne    542 <printf+0x52>
      if(c == 'd'){
 558:	83 f8 25             	cmp    $0x25,%eax
 55b:	0f 84 07 01 00 00    	je     668 <printf+0x178>
 561:	83 e8 63             	sub    $0x63,%eax
 564:	83 f8 15             	cmp    $0x15,%eax
 567:	77 17                	ja     580 <printf+0x90>
 569:	ff 24 85 98 08 00 00 	jmp    *0x898(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 570:	8d 65 f4             	lea    -0xc(%ebp),%esp
 573:	5b                   	pop    %ebx
 574:	5e                   	pop    %esi
 575:	5f                   	pop    %edi
 576:	5d                   	pop    %ebp
 577:	c3                   	ret    
 578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57f:	90                   	nop
  write(fd, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
 583:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 586:	6a 01                	push   $0x1
 588:	57                   	push   %edi
 589:	56                   	push   %esi
 58a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 58e:	e8 10 fe ff ff       	call   3a3 <write>
        putc(fd, c);
 593:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 597:	83 c4 0c             	add    $0xc,%esp
 59a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 59d:	6a 01                	push   $0x1
 59f:	57                   	push   %edi
 5a0:	56                   	push   %esi
 5a1:	e8 fd fd ff ff       	call   3a3 <write>
        putc(fd, c);
 5a6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a9:	31 c9                	xor    %ecx,%ecx
 5ab:	eb 95                	jmp    542 <printf+0x52>
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5b0:	83 ec 0c             	sub    $0xc,%esp
 5b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5b8:	6a 00                	push   $0x0
 5ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5bd:	8b 10                	mov    (%eax),%edx
 5bf:	89 f0                	mov    %esi,%eax
 5c1:	e8 7a fe ff ff       	call   440 <printint>
        ap++;
 5c6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cd:	31 c9                	xor    %ecx,%ecx
 5cf:	e9 6e ff ff ff       	jmp    542 <printf+0x52>
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5db:	8b 10                	mov    (%eax),%edx
        ap++;
 5dd:	83 c0 04             	add    $0x4,%eax
 5e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5e3:	85 d2                	test   %edx,%edx
 5e5:	0f 84 8d 00 00 00    	je     678 <printf+0x188>
        while(*s != 0){
 5eb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5ee:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5f0:	84 c0                	test   %al,%al
 5f2:	0f 84 4a ff ff ff    	je     542 <printf+0x52>
 5f8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5fb:	89 d3                	mov    %edx,%ebx
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
          s++;
 603:	83 c3 01             	add    $0x1,%ebx
 606:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 609:	6a 01                	push   $0x1
 60b:	57                   	push   %edi
 60c:	56                   	push   %esi
 60d:	e8 91 fd ff ff       	call   3a3 <write>
        while(*s != 0){
 612:	0f b6 03             	movzbl (%ebx),%eax
 615:	83 c4 10             	add    $0x10,%esp
 618:	84 c0                	test   %al,%al
 61a:	75 e4                	jne    600 <printf+0x110>
      state = 0;
 61c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 61f:	31 c9                	xor    %ecx,%ecx
 621:	e9 1c ff ff ff       	jmp    542 <printf+0x52>
 626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 630:	83 ec 0c             	sub    $0xc,%esp
 633:	b9 0a 00 00 00       	mov    $0xa,%ecx
 638:	6a 01                	push   $0x1
 63a:	e9 7b ff ff ff       	jmp    5ba <printf+0xca>
 63f:	90                   	nop
        putc(fd, *ap);
 640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 643:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 646:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 648:	6a 01                	push   $0x1
 64a:	57                   	push   %edi
 64b:	56                   	push   %esi
        putc(fd, *ap);
 64c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 64f:	e8 4f fd ff ff       	call   3a3 <write>
        ap++;
 654:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 658:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65b:	31 c9                	xor    %ecx,%ecx
 65d:	e9 e0 fe ff ff       	jmp    542 <printf+0x52>
 662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 668:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 66b:	83 ec 04             	sub    $0x4,%esp
 66e:	e9 2a ff ff ff       	jmp    59d <printf+0xad>
 673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 677:	90                   	nop
          s = "(null)";
 678:	ba 8f 08 00 00       	mov    $0x88f,%edx
        while(*s != 0){
 67d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 680:	b8 28 00 00 00       	mov    $0x28,%eax
 685:	89 d3                	mov    %edx,%ebx
 687:	e9 74 ff ff ff       	jmp    600 <printf+0x110>
 68c:	66 90                	xchg   %ax,%ax
 68e:	66 90                	xchg   %ax,%ax

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 690:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	a1 bc 0b 00 00       	mov    0xbbc,%eax
{
 696:	89 e5                	mov    %esp,%ebp
 698:	57                   	push   %edi
 699:	56                   	push   %esi
 69a:	53                   	push   %ebx
 69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 69e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6a8:	89 c2                	mov    %eax,%edx
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	39 ca                	cmp    %ecx,%edx
 6ae:	73 30                	jae    6e0 <free+0x50>
 6b0:	39 c1                	cmp    %eax,%ecx
 6b2:	72 04                	jb     6b8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b4:	39 c2                	cmp    %eax,%edx
 6b6:	72 f0                	jb     6a8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6be:	39 f8                	cmp    %edi,%eax
 6c0:	74 30                	je     6f2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c5:	8b 42 04             	mov    0x4(%edx),%eax
 6c8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6cb:	39 f1                	cmp    %esi,%ecx
 6cd:	74 3a                	je     709 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6cf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6d1:	5b                   	pop    %ebx
  freep = p;
 6d2:	89 15 bc 0b 00 00    	mov    %edx,0xbbc
}
 6d8:	5e                   	pop    %esi
 6d9:	5f                   	pop    %edi
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	39 c2                	cmp    %eax,%edx
 6e2:	72 c4                	jb     6a8 <free+0x18>
 6e4:	39 c1                	cmp    %eax,%ecx
 6e6:	73 c0                	jae    6a8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ee:	39 f8                	cmp    %edi,%eax
 6f0:	75 d0                	jne    6c2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6f2:	03 70 04             	add    0x4(%eax),%esi
 6f5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	8b 02                	mov    (%edx),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ff:	8b 42 04             	mov    0x4(%edx),%eax
 702:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 705:	39 f1                	cmp    %esi,%ecx
 707:	75 c6                	jne    6cf <free+0x3f>
    p->s.size += bp->s.size;
 709:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 70c:	89 15 bc 0b 00 00    	mov    %edx,0xbbc
    p->s.size += bp->s.size;
 712:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 715:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 718:	89 0a                	mov    %ecx,(%edx)
}
 71a:	5b                   	pop    %ebx
 71b:	5e                   	pop    %esi
 71c:	5f                   	pop    %edi
 71d:	5d                   	pop    %ebp
 71e:	c3                   	ret    
 71f:	90                   	nop

00000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 72c:	8b 3d bc 0b 00 00    	mov    0xbbc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	8d 70 07             	lea    0x7(%eax),%esi
 735:	c1 ee 03             	shr    $0x3,%esi
 738:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 73b:	85 ff                	test   %edi,%edi
 73d:	0f 84 9d 00 00 00    	je     7e0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 743:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 745:	8b 4a 04             	mov    0x4(%edx),%ecx
 748:	39 f1                	cmp    %esi,%ecx
 74a:	73 6a                	jae    7b6 <malloc+0x96>
 74c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 751:	39 de                	cmp    %ebx,%esi
 753:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 756:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 75d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 760:	eb 17                	jmp    779 <malloc+0x59>
 762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 768:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 76a:	8b 48 04             	mov    0x4(%eax),%ecx
 76d:	39 f1                	cmp    %esi,%ecx
 76f:	73 4f                	jae    7c0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 771:	8b 3d bc 0b 00 00    	mov    0xbbc,%edi
 777:	89 c2                	mov    %eax,%edx
 779:	39 d7                	cmp    %edx,%edi
 77b:	75 eb                	jne    768 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 77d:	83 ec 0c             	sub    $0xc,%esp
 780:	ff 75 e4             	push   -0x1c(%ebp)
 783:	e8 83 fc ff ff       	call   40b <sbrk>
  if(p == (char*)-1)
 788:	83 c4 10             	add    $0x10,%esp
 78b:	83 f8 ff             	cmp    $0xffffffff,%eax
 78e:	74 1c                	je     7ac <malloc+0x8c>
  hp->s.size = nu;
 790:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 793:	83 ec 0c             	sub    $0xc,%esp
 796:	83 c0 08             	add    $0x8,%eax
 799:	50                   	push   %eax
 79a:	e8 f1 fe ff ff       	call   690 <free>
  return freep;
 79f:	8b 15 bc 0b 00 00    	mov    0xbbc,%edx
      if((p = morecore(nunits)) == 0)
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	85 d2                	test   %edx,%edx
 7aa:	75 bc                	jne    768 <malloc+0x48>
        return 0;
  }
}
 7ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7af:	31 c0                	xor    %eax,%eax
}
 7b1:	5b                   	pop    %ebx
 7b2:	5e                   	pop    %esi
 7b3:	5f                   	pop    %edi
 7b4:	5d                   	pop    %ebp
 7b5:	c3                   	ret    
    if(p->s.size >= nunits){
 7b6:	89 d0                	mov    %edx,%eax
 7b8:	89 fa                	mov    %edi,%edx
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7c0:	39 ce                	cmp    %ecx,%esi
 7c2:	74 4c                	je     810 <malloc+0xf0>
        p->s.size -= nunits;
 7c4:	29 f1                	sub    %esi,%ecx
 7c6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7c9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7cc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7cf:	89 15 bc 0b 00 00    	mov    %edx,0xbbc
}
 7d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7d8:	83 c0 08             	add    $0x8,%eax
}
 7db:	5b                   	pop    %ebx
 7dc:	5e                   	pop    %esi
 7dd:	5f                   	pop    %edi
 7de:	5d                   	pop    %ebp
 7df:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7e0:	c7 05 bc 0b 00 00 c0 	movl   $0xbc0,0xbbc
 7e7:	0b 00 00 
    base.s.size = 0;
 7ea:	bf c0 0b 00 00       	mov    $0xbc0,%edi
    base.s.ptr = freep = prevp = &base;
 7ef:	c7 05 c0 0b 00 00 c0 	movl   $0xbc0,0xbc0
 7f6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7fb:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 802:	00 00 00 
    if(p->s.size >= nunits){
 805:	e9 42 ff ff ff       	jmp    74c <malloc+0x2c>
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 810:	8b 08                	mov    (%eax),%ecx
 812:	89 0a                	mov    %ecx,(%edx)
 814:	eb b9                	jmp    7cf <malloc+0xaf>
