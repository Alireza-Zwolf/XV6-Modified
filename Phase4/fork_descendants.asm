
_fork_descendants:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    printf(1 , "Start forking current process, forking for 3 times:\n");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 d8 07 00 00       	push   $0x7d8
  17:	6a 01                	push   $0x1
  19:	e8 92 04 00 00       	call   4b0 <printf>
    int pid;
    pid = fork();
  1e:	e8 f8 02 00 00       	call   31b <fork>
    if(pid < 0){
  23:	83 c4 10             	add    $0x10,%esp
  26:	85 c0                	test   %eax,%eax
  28:	78 6d                	js     97 <main+0x97>
        printf(1 , "Fork Failed!\n");
    }
    if(pid == 0){
  2a:	75 7c                	jne    a8 <main+0xa8>
        printf(1 , "  Process : %d , Parent: %d\n", getpid() , get_parent_pid());
  2c:	e8 92 03 00 00       	call   3c3 <get_parent_pid>
  31:	89 c3                	mov    %eax,%ebx
  33:	e8 6b 03 00 00       	call   3a3 <getpid>
  38:	53                   	push   %ebx
  39:	50                   	push   %eax
  3a:	68 5f 08 00 00       	push   $0x85f
  3f:	6a 01                	push   $0x1
  41:	e8 6a 04 00 00       	call   4b0 <printf>
        int pid1 = fork();
  46:	e8 d0 02 00 00       	call   31b <fork>
        if(pid1 == 0){
  4b:	83 c4 10             	add    $0x10,%esp
  4e:	85 c0                	test   %eax,%eax
  50:	75 76                	jne    c8 <main+0xc8>
            printf(1 , "    Process : %d , Parent: %d\n", getpid() , get_parent_pid());
  52:	e8 6c 03 00 00       	call   3c3 <get_parent_pid>
  57:	89 c3                	mov    %eax,%ebx
  59:	e8 45 03 00 00       	call   3a3 <getpid>
  5e:	53                   	push   %ebx
  5f:	50                   	push   %eax
  60:	68 10 08 00 00       	push   $0x810
  65:	6a 01                	push   $0x1
  67:	e8 44 04 00 00       	call   4b0 <printf>
            int pid2 = fork();
  6c:	e8 aa 02 00 00       	call   31b <fork>
            if(pid2 == 0){
  71:	83 c4 10             	add    $0x10,%esp
  74:	85 c0                	test   %eax,%eax
  76:	75 50                	jne    c8 <main+0xc8>
                printf(1 , "      Process : %d , Parent: %d\n", getpid() , get_parent_pid());
  78:	e8 46 03 00 00       	call   3c3 <get_parent_pid>
  7d:	89 c3                	mov    %eax,%ebx
  7f:	e8 1f 03 00 00       	call   3a3 <getpid>
  84:	53                   	push   %ebx
  85:	50                   	push   %eax
  86:	68 30 08 00 00       	push   $0x830
  8b:	6a 01                	push   $0x1
  8d:	e8 1e 04 00 00       	call   4b0 <printf>
  92:	83 c4 10             	add    $0x10,%esp
  95:	eb 2c                	jmp    c3 <main+0xc3>
        printf(1 , "Fork Failed!\n");
  97:	51                   	push   %ecx
  98:	51                   	push   %ecx
  99:	68 51 08 00 00       	push   $0x851
  9e:	6a 01                	push   $0x1
  a0:	e8 0b 04 00 00       	call   4b0 <printf>
  a5:	83 c4 10             	add    $0x10,%esp
        else{
            pid1 = wait();
        }
    }
    else{
        pid = wait();
  a8:	e8 7e 02 00 00       	call   32b <wait>
        printf(1 , "Origin process: %d\n", getpid());
  ad:	e8 f1 02 00 00       	call   3a3 <getpid>
  b2:	52                   	push   %edx
  b3:	50                   	push   %eax
  b4:	68 7c 08 00 00       	push   $0x87c
  b9:	6a 01                	push   $0x1
  bb:	e8 f0 03 00 00       	call   4b0 <printf>
  c0:	83 c4 10             	add    $0x10,%esp
    }
    exit();
  c3:	e8 5b 02 00 00       	call   323 <exit>
                pid2 = wait();
  c8:	e8 5e 02 00 00       	call   32b <wait>
  cd:	eb f4                	jmp    c3 <main+0xc3>
  cf:	90                   	nop

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d1:	31 c0                	xor    %eax,%eax
{
  d3:	89 e5                	mov    %esp,%ebp
  d5:	53                   	push   %ebx
  d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  e7:	83 c0 01             	add    $0x1,%eax
  ea:	84 d2                	test   %dl,%dl
  ec:	75 f2                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f1:	89 c8                	mov    %ecx,%eax
  f3:	c9                   	leave  
  f4:	c3                   	ret    
  f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 55 08             	mov    0x8(%ebp),%edx
 107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 10a:	0f b6 02             	movzbl (%edx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	75 17                	jne    128 <strcmp+0x28>
 111:	eb 3a                	jmp    14d <strcmp+0x4d>
 113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 117:	90                   	nop
 118:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 11c:	83 c2 01             	add    $0x1,%edx
 11f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 122:	84 c0                	test   %al,%al
 124:	74 1a                	je     140 <strcmp+0x40>
    p++, q++;
 126:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 128:	0f b6 19             	movzbl (%ecx),%ebx
 12b:	38 c3                	cmp    %al,%bl
 12d:	74 e9                	je     118 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 12f:	29 d8                	sub    %ebx,%eax
}
 131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 134:	c9                   	leave  
 135:	c3                   	ret    
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 140:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 144:	31 c0                	xor    %eax,%eax
 146:	29 d8                	sub    %ebx,%eax
}
 148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14b:	c9                   	leave  
 14c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 14d:	0f b6 19             	movzbl (%ecx),%ebx
 150:	31 c0                	xor    %eax,%eax
 152:	eb db                	jmp    12f <strcmp+0x2f>
 154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 15f:	90                   	nop

00000160 <strlen>:

uint
strlen(const char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 3a 00             	cmpb   $0x0,(%edx)
 169:	74 15                	je     180 <strlen+0x20>
 16b:	31 c0                	xor    %eax,%eax
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c0 01             	add    $0x1,%eax
 173:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 177:	89 c1                	mov    %eax,%ecx
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	89 c8                	mov    %ecx,%eax
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
 17f:	90                   	nop
  for(n = 0; s[n]; n++)
 180:	31 c9                	xor    %ecx,%ecx
}
 182:	5d                   	pop    %ebp
 183:	89 c8                	mov    %ecx,%eax
 185:	c3                   	ret    
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1a5:	89 d0                	mov    %edx,%eax
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	75 12                	jne    1d3 <strchr+0x23>
 1c1:	eb 1d                	jmp    1e0 <strchr+0x30>
 1c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c7:	90                   	nop
 1c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1cc:	83 c0 01             	add    $0x1,%eax
 1cf:	84 d2                	test   %dl,%dl
 1d1:	74 0d                	je     1e0 <strchr+0x30>
    if(*s == c)
 1d3:	38 d1                	cmp    %dl,%cl
 1d5:	75 f1                	jne    1c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1e0:	31 c0                	xor    %eax,%eax
}
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1f9:	31 db                	xor    %ebx,%ebx
{
 1fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1fe:	eb 27                	jmp    227 <gets+0x37>
    cc = read(0, &c, 1);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 01                	push   $0x1
 205:	57                   	push   %edi
 206:	6a 00                	push   $0x0
 208:	e8 2e 01 00 00       	call   33b <read>
    if(cc < 1)
 20d:	83 c4 10             	add    $0x10,%esp
 210:	85 c0                	test   %eax,%eax
 212:	7e 1d                	jle    231 <gets+0x41>
      break;
    buf[i++] = c;
 214:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 218:	8b 55 08             	mov    0x8(%ebp),%edx
 21b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 21f:	3c 0a                	cmp    $0xa,%al
 221:	74 1d                	je     240 <gets+0x50>
 223:	3c 0d                	cmp    $0xd,%al
 225:	74 19                	je     240 <gets+0x50>
  for(i=0; i+1 < max; ){
 227:	89 de                	mov    %ebx,%esi
 229:	83 c3 01             	add    $0x1,%ebx
 22c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22f:	7c cf                	jl     200 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 238:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    
  buf[i] = '\0';
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	89 de                	mov    %ebx,%esi
 245:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 249:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	push   0x8(%ebp)
 26d:	e8 f1 00 00 00       	call   363 <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	push   0xc(%ebp)
 27f:	89 c3                	mov    %eax,%ebx
 281:	50                   	push   %eax
 282:	e8 f4 00 00 00       	call   37b <fstat>
  close(fd);
 287:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 28a:	89 c6                	mov    %eax,%esi
  close(fd);
 28c:	e8 ba 00 00 00       	call   34b <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
}
 294:	8d 65 f8             	lea    -0x8(%ebp),%esp
 297:	89 f0                	mov    %esi,%eax
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a5:	eb ed                	jmp    294 <stat+0x34>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 02             	movsbl (%edx),%eax
 2ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2c5:	77 1e                	ja     2e5 <atoi+0x35>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2da:	0f be 02             	movsbl (%edx),%eax
 2dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2e0:	80 fb 09             	cmp    $0x9,%bl
 2e3:	76 eb                	jbe    2d0 <atoi+0x20>
  return n;
}
 2e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e8:	89 c8                	mov    %ecx,%eax
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8b 55 08             	mov    0x8(%ebp),%edx
 2fa:	56                   	push   %esi
 2fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	85 c0                	test   %eax,%eax
 300:	7e 13                	jle    315 <memmove+0x25>
 302:	01 d0                	add    %edx,%eax
  dst = vdst;
 304:	89 d7                	mov    %edx,%edi
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 310:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 311:	39 f8                	cmp    %edi,%eax
 313:	75 fb                	jne    310 <memmove+0x20>
  return vdst;
}
 315:	5e                   	pop    %esi
 316:	89 d0                	mov    %edx,%eax
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    

0000031b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31b:	b8 01 00 00 00       	mov    $0x1,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <exit>:
SYSCALL(exit)
 323:	b8 02 00 00 00       	mov    $0x2,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <wait>:
SYSCALL(wait)
 32b:	b8 03 00 00 00       	mov    $0x3,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <pipe>:
SYSCALL(pipe)
 333:	b8 04 00 00 00       	mov    $0x4,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <read>:
SYSCALL(read)
 33b:	b8 05 00 00 00       	mov    $0x5,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <write>:
SYSCALL(write)
 343:	b8 10 00 00 00       	mov    $0x10,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <close>:
SYSCALL(close)
 34b:	b8 15 00 00 00       	mov    $0x15,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <kill>:
SYSCALL(kill)
 353:	b8 06 00 00 00       	mov    $0x6,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <exec>:
SYSCALL(exec)
 35b:	b8 07 00 00 00       	mov    $0x7,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <open>:
SYSCALL(open)
 363:	b8 0f 00 00 00       	mov    $0xf,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mknod>:
SYSCALL(mknod)
 36b:	b8 11 00 00 00       	mov    $0x11,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <unlink>:
SYSCALL(unlink)
 373:	b8 12 00 00 00       	mov    $0x12,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <fstat>:
SYSCALL(fstat)
 37b:	b8 08 00 00 00       	mov    $0x8,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <link>:
SYSCALL(link)
 383:	b8 13 00 00 00       	mov    $0x13,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <mkdir>:
SYSCALL(mkdir)
 38b:	b8 14 00 00 00       	mov    $0x14,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <chdir>:
SYSCALL(chdir)
 393:	b8 09 00 00 00       	mov    $0x9,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <dup>:
SYSCALL(dup)
 39b:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <getpid>:
SYSCALL(getpid)
 3a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <sbrk>:
SYSCALL(sbrk)
 3ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <sleep>:
SYSCALL(sleep)
 3b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <uptime>:
SYSCALL(uptime)
 3bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <get_parent_pid>:
SYSCALL(get_parent_pid)
 3c3:	b8 16 00 00 00       	mov    $0x16,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <find_largest_prime_factor>:
SYSCALL(find_largest_prime_factor)
 3cb:	b8 17 00 00 00       	mov    $0x17,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <get_callers>:
SYSCALL(get_callers)
 3d3:	b8 18 00 00 00       	mov    $0x18,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <sem_init>:
SYSCALL(sem_init)
 3db:	b8 19 00 00 00       	mov    $0x19,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <sem_acquire>:
SYSCALL(sem_acquire)
 3e3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sem_release>:
 3eb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    
 3f3:	66 90                	xchg   %ax,%ax
 3f5:	66 90                	xchg   %ax,%ax
 3f7:	66 90                	xchg   %ax,%ax
 3f9:	66 90                	xchg   %ax,%ax
 3fb:	66 90                	xchg   %ax,%ax
 3fd:	66 90                	xchg   %ax,%ax
 3ff:	90                   	nop

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 3c             	sub    $0x3c,%esp
 409:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 40c:	89 d1                	mov    %edx,%ecx
{
 40e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 411:	85 d2                	test   %edx,%edx
 413:	0f 89 7f 00 00 00    	jns    498 <printint+0x98>
 419:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 41d:	74 79                	je     498 <printint+0x98>
    neg = 1;
 41f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 426:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 428:	31 db                	xor    %ebx,%ebx
 42a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 430:	89 c8                	mov    %ecx,%eax
 432:	31 d2                	xor    %edx,%edx
 434:	89 cf                	mov    %ecx,%edi
 436:	f7 75 c4             	divl   -0x3c(%ebp)
 439:	0f b6 92 f0 08 00 00 	movzbl 0x8f0(%edx),%edx
 440:	89 45 c0             	mov    %eax,-0x40(%ebp)
 443:	89 d8                	mov    %ebx,%eax
 445:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 448:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 44b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 44e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 451:	76 dd                	jbe    430 <printint+0x30>
  if(neg)
 453:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 456:	85 c9                	test   %ecx,%ecx
 458:	74 0c                	je     466 <printint+0x66>
    buf[i++] = '-';
 45a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 45f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 461:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 466:	8b 7d b8             	mov    -0x48(%ebp),%edi
 469:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 46d:	eb 07                	jmp    476 <printint+0x76>
 46f:	90                   	nop
    putc(fd, buf[i]);
 470:	0f b6 13             	movzbl (%ebx),%edx
 473:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 476:	83 ec 04             	sub    $0x4,%esp
 479:	88 55 d7             	mov    %dl,-0x29(%ebp)
 47c:	6a 01                	push   $0x1
 47e:	56                   	push   %esi
 47f:	57                   	push   %edi
 480:	e8 be fe ff ff       	call   343 <write>
  while(--i >= 0)
 485:	83 c4 10             	add    $0x10,%esp
 488:	39 de                	cmp    %ebx,%esi
 48a:	75 e4                	jne    470 <printint+0x70>
}
 48c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5f                   	pop    %edi
 492:	5d                   	pop    %ebp
 493:	c3                   	ret    
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 498:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 49f:	eb 87                	jmp    428 <printint+0x28>
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4bc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4bf:	0f b6 13             	movzbl (%ebx),%edx
 4c2:	84 d2                	test   %dl,%dl
 4c4:	74 6a                	je     530 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4c6:	8d 45 10             	lea    0x10(%ebp),%eax
 4c9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4cc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4cf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4d4:	eb 36                	jmp    50c <printf+0x5c>
 4d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
 4e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4e3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	74 15                	je     502 <printf+0x52>
  write(fd, &c, 1);
 4ed:	83 ec 04             	sub    $0x4,%esp
 4f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4f3:	6a 01                	push   $0x1
 4f5:	57                   	push   %edi
 4f6:	56                   	push   %esi
 4f7:	e8 47 fe ff ff       	call   343 <write>
 4fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 502:	0f b6 13             	movzbl (%ebx),%edx
 505:	83 c3 01             	add    $0x1,%ebx
 508:	84 d2                	test   %dl,%dl
 50a:	74 24                	je     530 <printf+0x80>
    c = fmt[i] & 0xff;
 50c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 50f:	85 c9                	test   %ecx,%ecx
 511:	74 cd                	je     4e0 <printf+0x30>
      }
    } else if(state == '%'){
 513:	83 f9 25             	cmp    $0x25,%ecx
 516:	75 ea                	jne    502 <printf+0x52>
      if(c == 'd'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	0f 84 07 01 00 00    	je     628 <printf+0x178>
 521:	83 e8 63             	sub    $0x63,%eax
 524:	83 f8 15             	cmp    $0x15,%eax
 527:	77 17                	ja     540 <printf+0x90>
 529:	ff 24 85 98 08 00 00 	jmp    *0x898(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 530:	8d 65 f4             	lea    -0xc(%ebp),%esp
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    
 538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53f:	90                   	nop
  write(fd, &c, 1);
 540:	83 ec 04             	sub    $0x4,%esp
 543:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 546:	6a 01                	push   $0x1
 548:	57                   	push   %edi
 549:	56                   	push   %esi
 54a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 54e:	e8 f0 fd ff ff       	call   343 <write>
        putc(fd, c);
 553:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 557:	83 c4 0c             	add    $0xc,%esp
 55a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 55d:	6a 01                	push   $0x1
 55f:	57                   	push   %edi
 560:	56                   	push   %esi
 561:	e8 dd fd ff ff       	call   343 <write>
        putc(fd, c);
 566:	83 c4 10             	add    $0x10,%esp
      state = 0;
 569:	31 c9                	xor    %ecx,%ecx
 56b:	eb 95                	jmp    502 <printf+0x52>
 56d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
 578:	6a 00                	push   $0x0
 57a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 57d:	8b 10                	mov    (%eax),%edx
 57f:	89 f0                	mov    %esi,%eax
 581:	e8 7a fe ff ff       	call   400 <printint>
        ap++;
 586:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 58a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58d:	31 c9                	xor    %ecx,%ecx
 58f:	e9 6e ff ff ff       	jmp    502 <printf+0x52>
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 598:	8b 45 d0             	mov    -0x30(%ebp),%eax
 59b:	8b 10                	mov    (%eax),%edx
        ap++;
 59d:	83 c0 04             	add    $0x4,%eax
 5a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5a3:	85 d2                	test   %edx,%edx
 5a5:	0f 84 8d 00 00 00    	je     638 <printf+0x188>
        while(*s != 0){
 5ab:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5ae:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5b0:	84 c0                	test   %al,%al
 5b2:	0f 84 4a ff ff ff    	je     502 <printf+0x52>
 5b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5bb:	89 d3                	mov    %edx,%ebx
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5c3:	83 c3 01             	add    $0x1,%ebx
 5c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5c9:	6a 01                	push   $0x1
 5cb:	57                   	push   %edi
 5cc:	56                   	push   %esi
 5cd:	e8 71 fd ff ff       	call   343 <write>
        while(*s != 0){
 5d2:	0f b6 03             	movzbl (%ebx),%eax
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	84 c0                	test   %al,%al
 5da:	75 e4                	jne    5c0 <printf+0x110>
      state = 0;
 5dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5df:	31 c9                	xor    %ecx,%ecx
 5e1:	e9 1c ff ff ff       	jmp    502 <printf+0x52>
 5e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5f8:	6a 01                	push   $0x1
 5fa:	e9 7b ff ff ff       	jmp    57a <printf+0xca>
 5ff:	90                   	nop
        putc(fd, *ap);
 600:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 606:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 608:	6a 01                	push   $0x1
 60a:	57                   	push   %edi
 60b:	56                   	push   %esi
        putc(fd, *ap);
 60c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 60f:	e8 2f fd ff ff       	call   343 <write>
        ap++;
 614:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 618:	83 c4 10             	add    $0x10,%esp
      state = 0;
 61b:	31 c9                	xor    %ecx,%ecx
 61d:	e9 e0 fe ff ff       	jmp    502 <printf+0x52>
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 628:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 62b:	83 ec 04             	sub    $0x4,%esp
 62e:	e9 2a ff ff ff       	jmp    55d <printf+0xad>
 633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 637:	90                   	nop
          s = "(null)";
 638:	ba 90 08 00 00       	mov    $0x890,%edx
        while(*s != 0){
 63d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 640:	b8 28 00 00 00       	mov    $0x28,%eax
 645:	89 d3                	mov    %edx,%ebx
 647:	e9 74 ff ff ff       	jmp    5c0 <printf+0x110>
 64c:	66 90                	xchg   %ax,%ax
 64e:	66 90                	xchg   %ax,%ax

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 9c 0b 00 00       	mov    0xb9c,%eax
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 65e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 668:	89 c2                	mov    %eax,%edx
 66a:	8b 00                	mov    (%eax),%eax
 66c:	39 ca                	cmp    %ecx,%edx
 66e:	73 30                	jae    6a0 <free+0x50>
 670:	39 c1                	cmp    %eax,%ecx
 672:	72 04                	jb     678 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	39 c2                	cmp    %eax,%edx
 676:	72 f0                	jb     668 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 73 fc             	mov    -0x4(%ebx),%esi
 67b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67e:	39 f8                	cmp    %edi,%eax
 680:	74 30                	je     6b2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 682:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 685:	8b 42 04             	mov    0x4(%edx),%eax
 688:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 68b:	39 f1                	cmp    %esi,%ecx
 68d:	74 3a                	je     6c9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 68f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 691:	5b                   	pop    %ebx
  freep = p;
 692:	89 15 9c 0b 00 00    	mov    %edx,0xb9c
}
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a0:	39 c2                	cmp    %eax,%edx
 6a2:	72 c4                	jb     668 <free+0x18>
 6a4:	39 c1                	cmp    %eax,%ecx
 6a6:	73 c0                	jae    668 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ae:	39 f8                	cmp    %edi,%eax
 6b0:	75 d0                	jne    682 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6b2:	03 70 04             	add    0x4(%eax),%esi
 6b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	8b 02                	mov    (%edx),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6bf:	8b 42 04             	mov    0x4(%edx),%eax
 6c2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6c5:	39 f1                	cmp    %esi,%ecx
 6c7:	75 c6                	jne    68f <free+0x3f>
    p->s.size += bp->s.size;
 6c9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6cc:	89 15 9c 0b 00 00    	mov    %edx,0xb9c
    p->s.size += bp->s.size;
 6d2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6d8:	89 0a                	mov    %ecx,(%edx)
}
 6da:	5b                   	pop    %ebx
 6db:	5e                   	pop    %esi
 6dc:	5f                   	pop    %edi
 6dd:	5d                   	pop    %ebp
 6de:	c3                   	ret    
 6df:	90                   	nop

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 3d 9c 0b 00 00    	mov    0xb9c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	8d 70 07             	lea    0x7(%eax),%esi
 6f5:	c1 ee 03             	shr    $0x3,%esi
 6f8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6fb:	85 ff                	test   %edi,%edi
 6fd:	0f 84 9d 00 00 00    	je     7a0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 703:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 705:	8b 4a 04             	mov    0x4(%edx),%ecx
 708:	39 f1                	cmp    %esi,%ecx
 70a:	73 6a                	jae    776 <malloc+0x96>
 70c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 711:	39 de                	cmp    %ebx,%esi
 713:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 716:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 71d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 720:	eb 17                	jmp    739 <malloc+0x59>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 72a:	8b 48 04             	mov    0x4(%eax),%ecx
 72d:	39 f1                	cmp    %esi,%ecx
 72f:	73 4f                	jae    780 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 731:	8b 3d 9c 0b 00 00    	mov    0xb9c,%edi
 737:	89 c2                	mov    %eax,%edx
 739:	39 d7                	cmp    %edx,%edi
 73b:	75 eb                	jne    728 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 73d:	83 ec 0c             	sub    $0xc,%esp
 740:	ff 75 e4             	push   -0x1c(%ebp)
 743:	e8 63 fc ff ff       	call   3ab <sbrk>
  if(p == (char*)-1)
 748:	83 c4 10             	add    $0x10,%esp
 74b:	83 f8 ff             	cmp    $0xffffffff,%eax
 74e:	74 1c                	je     76c <malloc+0x8c>
  hp->s.size = nu;
 750:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 753:	83 ec 0c             	sub    $0xc,%esp
 756:	83 c0 08             	add    $0x8,%eax
 759:	50                   	push   %eax
 75a:	e8 f1 fe ff ff       	call   650 <free>
  return freep;
 75f:	8b 15 9c 0b 00 00    	mov    0xb9c,%edx
      if((p = morecore(nunits)) == 0)
 765:	83 c4 10             	add    $0x10,%esp
 768:	85 d2                	test   %edx,%edx
 76a:	75 bc                	jne    728 <malloc+0x48>
        return 0;
  }
}
 76c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 76f:	31 c0                	xor    %eax,%eax
}
 771:	5b                   	pop    %ebx
 772:	5e                   	pop    %esi
 773:	5f                   	pop    %edi
 774:	5d                   	pop    %ebp
 775:	c3                   	ret    
    if(p->s.size >= nunits){
 776:	89 d0                	mov    %edx,%eax
 778:	89 fa                	mov    %edi,%edx
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 780:	39 ce                	cmp    %ecx,%esi
 782:	74 4c                	je     7d0 <malloc+0xf0>
        p->s.size -= nunits;
 784:	29 f1                	sub    %esi,%ecx
 786:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 789:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 78c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 78f:	89 15 9c 0b 00 00    	mov    %edx,0xb9c
}
 795:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 798:	83 c0 08             	add    $0x8,%eax
}
 79b:	5b                   	pop    %ebx
 79c:	5e                   	pop    %esi
 79d:	5f                   	pop    %edi
 79e:	5d                   	pop    %ebp
 79f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7a0:	c7 05 9c 0b 00 00 a0 	movl   $0xba0,0xb9c
 7a7:	0b 00 00 
    base.s.size = 0;
 7aa:	bf a0 0b 00 00       	mov    $0xba0,%edi
    base.s.ptr = freep = prevp = &base;
 7af:	c7 05 a0 0b 00 00 a0 	movl   $0xba0,0xba0
 7b6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7bb:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 7c2:	00 00 00 
    if(p->s.size >= nunits){
 7c5:	e9 42 ff ff ff       	jmp    70c <malloc+0x2c>
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 08                	mov    (%eax),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
 7d4:	eb b9                	jmp    78f <malloc+0xaf>
