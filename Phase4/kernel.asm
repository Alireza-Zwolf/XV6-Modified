
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 10 56 11 80       	mov    $0x80115610,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 74 10 80       	push   $0x80107400
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 15 45 00 00       	call   80104570 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 74 10 80       	push   $0x80107407
80100097:	50                   	push   %eax
80100098:	e8 a3 43 00 00       	call   80104440 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 57 46 00 00       	call   80104740 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 79 45 00 00       	call   801046e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 43 00 00       	call   80104480 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 74 10 80       	push   $0x8010740e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 5d 43 00 00       	call   80104520 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 74 10 80       	push   $0x8010741f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 43 00 00       	call   80104520 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 42 00 00       	call   801044e0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 20 45 00 00       	call   80104740 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 6f 44 00 00       	jmp    801046e0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 74 10 80       	push   $0x80107426
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 9b 44 00 00       	call   80104740 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 6e 3d 00 00       	call   80104040 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 89 36 00 00       	call   80103970 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 e5 43 00 00       	call   801046e0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 8f 43 00 00       	call   801046e0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 74 10 80       	push   $0x8010742d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 63 7d 10 80 	movl   $0x80107d63,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 41 00 00       	call   80104590 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 74 10 80       	push   $0x80107441
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 01 5b 00 00       	call   80105f20 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 16 5a 00 00       	call   80105f20 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 0a 5a 00 00       	call   80105f20 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 fe 59 00 00       	call   80105f20 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 4a 43 00 00       	call   801048a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 95 42 00 00       	call   80104800 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 45 74 10 80       	push   $0x80107445
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 90 41 00 00       	call   80104740 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 f7 40 00 00       	call   801046e0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 70 74 10 80 	movzbl -0x7fef8b90(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 53 3f 00 00       	call   80104740 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 58 74 10 80       	mov    $0x80107458,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 80 3e 00 00       	call   801046e0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 5f 74 10 80       	push   $0x8010745f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 a8 3e 00 00       	call   80104740 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 0b 3d 00 00       	call   801046e0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 cd 37 00 00       	jmp    801041e0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 b7 36 00 00       	call   80104100 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 74 10 80       	push   $0x80107468
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 fb 3a 00 00       	call   80104570 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 af 2e 00 00       	call   80103970 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 77 65 00 00       	call   801070b0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 28 63 00 00       	call   80106ed0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 02 62 00 00       	call   80106de0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 10 64 00 00       	call   80107030 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 69 62 00 00       	call   80106ed0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 c8 64 00 00       	call   80107150 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 28 3d 00 00       	call   80104a00 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 14 3d 00 00       	call   80104a00 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 23 66 00 00       	call   80107320 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 1a 63 00 00       	call   80107030 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 b8 65 00 00       	call   80107320 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 1a 3c 00 00       	call   801049c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 7e 5e 00 00       	call   80106c50 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 56 62 00 00       	call   80107030 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 81 74 10 80       	push   $0x80107481
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 8d 74 10 80       	push   $0x8010748d
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 4b 37 00 00       	call   80104570 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 fa 38 00 00       	call   80104740 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 6a 38 00 00       	call   801046e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 51 38 00 00       	call   801046e0 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 8c 38 00 00       	call   80104740 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 0f 38 00 00       	call   801046e0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 94 74 10 80       	push   $0x80107494
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 3a 38 00 00       	call   80104740 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 9f 37 00 00       	call   801046e0 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 6d 37 00 00       	jmp    801046e0 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 9c 74 10 80       	push   $0x8010749c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 a6 74 10 80       	push   $0x801074a6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 af 74 10 80       	push   $0x801074af
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 b5 74 10 80       	push   $0x801074b5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 bf 74 10 80       	push   $0x801074bf
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 d2 74 10 80       	push   $0x801074d2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 d6 34 00 00       	call   80104800 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 f9 10 80       	push   $0x8010f960
8010136a:	e8 d1 33 00 00       	call   80104740 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 f9 10 80       	push   $0x8010f960
801013d7:	e8 04 33 00 00       	call   801046e0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 d6 32 00 00       	call   801046e0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 e8 74 10 80       	push   $0x801074e8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 f8 74 10 80       	push   $0x801074f8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 5a 33 00 00       	call   801048a0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 0b 75 10 80       	push   $0x8010750b
80101571:	68 60 f9 10 80       	push   $0x8010f960
80101576:	e8 f5 2f 00 00       	call   80104570 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 12 75 10 80       	push   $0x80107512
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ac 2e 00 00       	call   80104440 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 15 11 80       	push   $0x801115b4
801015bc:	e8 df 32 00 00       	call   801048a0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 15 11 80    	push   0x801115cc
801015cf:	ff 35 c8 15 11 80    	push   0x801115c8
801015d5:	ff 35 c4 15 11 80    	push   0x801115c4
801015db:	ff 35 c0 15 11 80    	push   0x801115c0
801015e1:	ff 35 bc 15 11 80    	push   0x801115bc
801015e7:	ff 35 b8 15 11 80    	push   0x801115b8
801015ed:	ff 35 b4 15 11 80    	push   0x801115b4
801015f3:	68 78 75 10 80       	push   $0x80107578
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 6d 31 00 00       	call   80104800 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 18 75 10 80       	push   $0x80107518
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 6a 31 00 00       	call   801048a0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 f9 10 80       	push   $0x8010f960
8010175f:	e8 dc 2f 00 00       	call   80104740 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010176f:	e8 6c 2f 00 00       	call   801046e0 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 d9 2c 00 00       	call   80104480 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 83 30 00 00       	call   801048a0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 30 75 10 80       	push   $0x80107530
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 2a 75 10 80       	push   $0x8010752a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 a8 2c 00 00       	call   80104520 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 4c 2c 00 00       	jmp    801044e0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 3f 75 10 80       	push   $0x8010753f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 bb 2b 00 00       	call   80104480 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 01 2c 00 00       	call   801044e0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018e6:	e8 55 2e 00 00       	call   80104740 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 db 2d 00 00       	jmp    801046e0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 f9 10 80       	push   $0x8010f960
80101910:	e8 2b 2e 00 00       	call   80104740 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010191f:	e8 bc 2d 00 00       	call   801046e0 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 f8 2a 00 00       	call   80104520 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 a1 2a 00 00       	call   801044e0 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 3f 75 10 80       	push   $0x8010753f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 64 2d 00 00       	call   801048a0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 68 2c 00 00       	call   801048a0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 3d 2c 00 00       	call   80104910 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 de 2b 00 00       	call   80104910 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 59 75 10 80       	push   $0x80107559
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 47 75 10 80       	push   $0x80107547
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 c1 1b 00 00       	call   80103970 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 f9 10 80       	push   $0x8010f960
80101dba:	e8 81 29 00 00       	call   80104740 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dca:	e8 11 29 00 00       	call   801046e0 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 74 2a 00 00       	call   801048a0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 8f 26 00 00       	call   80104520 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 2d 26 00 00       	call   801044e0 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 c0 29 00 00       	call   801048a0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 f0 25 00 00       	call   80104520 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 91 25 00 00       	call   801044e0 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 ae 25 00 00       	call   80104520 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 8b 25 00 00       	call   80104520 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 34 25 00 00       	call   801044e0 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 3f 75 10 80       	push   $0x8010753f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 1e 29 00 00       	call   80104960 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 68 75 10 80       	push   $0x80107568
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 4a 7b 10 80       	push   $0x80107b4a
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 d4 75 10 80       	push   $0x801075d4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 cb 75 10 80       	push   $0x801075cb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 e6 75 10 80       	push   $0x801075e6
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 9b 23 00 00       	call   80104570 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 16 11 80       	push   $0x80111600
8010224e:	e8 ed 24 00 00       	call   80104740 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 4e 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 16 11 80       	push   $0x80111600
801022cb:	e8 10 24 00 00       	call   801046e0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 2d 22 00 00       	call   80104520 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 16 11 80       	push   $0x80111600
80102328:	e8 13 24 00 00       	call   80104740 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	53                   	push   %ebx
80102369:	e8 d2 1c 00 00       	call   80104040 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 55 23 00 00       	jmp    801046e0 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 15 76 10 80       	push   $0x80107615
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 00 76 10 80       	push   $0x80107600
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ea 75 10 80       	push   $0x801075ea
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 34 76 10 80       	push   $0x80107634
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 10 56 11 80    	cmp    $0x80115610,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 09 23 00 00       	call   80104800 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 16 11 80       	mov    0x80111678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 16 11 80       	push   $0x80111640
80102528:	e8 13 22 00 00       	call   80104740 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 98 21 00 00       	jmp    801046e0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 66 76 10 80       	push   $0x80107666
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 6c 76 10 80       	push   $0x8010766c
80102620:	68 40 16 11 80       	push   $0x80111640
80102625:	e8 46 1f 00 00       	call   80104570 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 16 11 80       	mov    0x80111674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 16 11 80       	push   $0x80111640
801026b3:	e8 88 20 00 00       	call   80104740 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 16 11 80       	push   $0x80111640
801026e1:	e8 fa 1f 00 00       	call   801046e0 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 a0 77 10 80 	movzbl -0x7fef8860(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 a0 76 10 80 	movzbl -0x7fef8960(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 a0 77 10 80 	movzbl -0x7fef8860(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 16 11 80       	mov    0x80111680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 54 1d 00 00       	call   80104850 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 16 11 80    	push   0x801116e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c04:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 77 1c 00 00       	call   801048a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 16 11 80    	push   0x801116d4
80102c6d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 a0 78 10 80       	push   $0x801078a0
80102ccf:	68 a0 16 11 80       	push   $0x801116a0
80102cd4:	e8 97 18 00 00       	call   80104570 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 16 11 80       	push   $0x801116a0
80102d6b:	e8 d0 19 00 00       	call   80104740 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 16 11 80       	push   $0x801116a0
80102d80:	68 a0 16 11 80       	push   $0x801116a0
80102d85:	e8 b6 12 00 00       	call   80104040 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102d9b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102db7:	68 a0 16 11 80       	push   $0x801116a0
80102dbc:	e8 1f 19 00 00       	call   801046e0 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 16 11 80       	push   $0x801116a0
80102dde:	e8 5d 19 00 00       	call   80104740 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 16 11 80       	push   $0x801116a0
80102e1c:	e8 bf 18 00 00       	call   801046e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 16 11 80       	push   $0x801116a0
80102e36:	e8 05 19 00 00       	call   80104740 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 af 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e58:	e8 83 18 00 00       	call   801046e0 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102e94:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 e7 19 00 00       	call   801048a0 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 16 11 80       	push   $0x801116a0
80102f08:	e8 f3 11 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f14:	e8 c7 17 00 00       	call   801046e0 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 a4 78 10 80       	push   $0x801078a4
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 16 11 80       	push   $0x801116a0
80102f76:	e8 c5 17 00 00       	call   80104740 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 26 17 00 00       	jmp    801046e0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 b3 78 10 80       	push   $0x801078b3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 c9 78 10 80       	push   $0x801078c9
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 44 09 00 00       	call   80103950 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 3d 09 00 00       	call   80103950 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 e4 78 10 80       	push   $0x801078e4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 29 2b 00 00       	call   80105b50 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 c4 08 00 00       	call   801038f0 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 f1 0b 00 00       	call   80103c30 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 f5 3b 00 00       	call   80106c40 <switchkvm>
  seginit();
8010304b:	e8 60 3b 00 00       	call   80106bb0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 10 56 11 80       	push   $0x80115610
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 aa 40 00 00       	call   80107130 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 1b 3b 00 00       	call   80106bb0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 97 2d 00 00       	call   80105e40 <uartinit>
  pinit();         // process table
801030a9:	e8 22 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 1d 2a 00 00       	call   80105ad0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c a4 10 80       	push   $0x8010a48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 c7 17 00 00       	call   801048a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030eb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 d2 07 00 00       	call   801038f0 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010313b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 19 08 00 00       	call   801039a0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 f8 78 10 80       	push   $0x801078f8
801031c3:	56                   	push   %esi
801031c4:	e8 87 16 00 00       	call   80104850 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 fd 78 10 80       	push   $0x801078fd
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 cc 15 00 00       	call   80104850 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 02 79 10 80       	push   $0x80107902
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 f8 78 10 80       	push   $0x801078f8
801033c7:	53                   	push   %ebx
801033c8:	e8 83 14 00 00       	call   80104850 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 1c 79 10 80       	push   $0x8010791c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 3b 79 10 80       	push   $0x8010793b
801034a8:	50                   	push   %eax
801034a9:	e8 c2 10 00 00       	call   80104570 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 fc 11 00 00       	call   80104740 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 9c 0b 00 00       	call   80104100 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 57 11 00 00       	jmp    801046e0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 47 11 00 00       	call   801046e0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 37 0b 00 00       	call   80104100 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 5e 11 00 00       	call   80104740 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 43 03 00 00       	call   80103970 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 c3 0a 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 fa 09 00 00       	call   80104040 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 6f 10 00 00       	call   801046e0 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 41 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 19 10 00 00       	call   801046e0 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 55 10 00 00       	call   80104740 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 6b 02 00 00       	call   80103970 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 26 09 00 00       	call   80104040 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 85 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 5d 0f 00 00       	call   801046e0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 42 0f 00 00       	call   801046e0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 94 1e 11 80       	mov    $0x80111e94,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 60 1e 11 80       	push   $0x80111e60
801037c1:	e8 7a 0f 00 00       	call   80104740 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 10                	jmp    801037db <allocproc+0x2b>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	83 c3 7c             	add    $0x7c,%ebx
801037d3:	81 fb 94 3d 11 80    	cmp    $0x80113d94,%ebx
801037d9:	74 75                	je     80103850 <allocproc+0xa0>
    if(p->state == UNUSED)
801037db:	8b 43 0c             	mov    0xc(%ebx),%eax
801037de:	85 c0                	test   %eax,%eax
801037e0:	75 ee                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f1:	89 43 10             	mov    %eax,0x10(%ebx)
801037f4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037f7:	68 60 1e 11 80       	push   $0x80111e60
  p->pid = nextpid++;
801037fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103802:	e8 d9 0e 00 00       	call   801046e0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103807:	e8 74 ee ff ff       	call   80102680 <kalloc>
8010380c:	83 c4 10             	add    $0x10,%esp
8010380f:	89 43 08             	mov    %eax,0x8(%ebx)
80103812:	85 c0                	test   %eax,%eax
80103814:	74 53                	je     80103869 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103816:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010381f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103824:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103827:	c7 40 14 bf 5a 10 80 	movl   $0x80105abf,0x14(%eax)
  p->context = (struct context*)sp;
8010382e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103831:	6a 14                	push   $0x14
80103833:	6a 00                	push   $0x0
80103835:	50                   	push   %eax
80103836:	e8 c5 0f 00 00       	call   80104800 <memset>
  p->context->eip = (uint)forkret;
8010383b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010383e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103841:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
80103848:	89 d8                	mov    %ebx,%eax
8010384a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384d:	c9                   	leave  
8010384e:	c3                   	ret    
8010384f:	90                   	nop
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 60 1e 11 80       	push   $0x80111e60
8010385a:	e8 81 0e 00 00       	call   801046e0 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103886:	68 60 1e 11 80       	push   $0x80111e60
8010388b:	e8 50 0e 00 00       	call   801046e0 <release>

  if (first) {
80103890:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	85 c0                	test   %eax,%eax
8010389a:	75 04                	jne    801038a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010389c:	c9                   	leave  
8010389d:	c3                   	ret    
8010389e:	66 90                	xchg   %ax,%ax
    first = 0;
801038a0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038a7:	00 00 00 
    iinit(ROOTDEV);
801038aa:	83 ec 0c             	sub    $0xc,%esp
801038ad:	6a 01                	push   $0x1
801038af:	e8 ac dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038bb:	e8 00 f4 ff ff       	call   80102cc0 <initlog>
}
801038c0:	83 c4 10             	add    $0x10,%esp
801038c3:	c9                   	leave  
801038c4:	c3                   	ret    
801038c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038d0 <pinit>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038d6:	68 40 79 10 80       	push   $0x80107940
801038db:	68 60 1e 11 80       	push   $0x80111e60
801038e0:	e8 8b 0c 00 00       	call   80104570 <initlock>
}
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	c9                   	leave  
801038e9:	c3                   	ret    
801038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038f0 <mycpu>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f5:	9c                   	pushf  
801038f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038f7:	f6 c4 02             	test   $0x2,%ah
801038fa:	75 46                	jne    80103942 <mycpu+0x52>
  apicid = lapicid();
801038fc:	e8 ef ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103901:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103907:	85 f6                	test   %esi,%esi
80103909:	7e 2a                	jle    80103935 <mycpu+0x45>
8010390b:	31 d2                	xor    %edx,%edx
8010390d:	eb 08                	jmp    80103917 <mycpu+0x27>
8010390f:	90                   	nop
80103910:	83 c2 01             	add    $0x1,%edx
80103913:	39 f2                	cmp    %esi,%edx
80103915:	74 1e                	je     80103935 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103917:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010391d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103924:	39 c3                	cmp    %eax,%ebx
80103926:	75 e8                	jne    80103910 <mycpu+0x20>
}
80103928:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010392b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103931:	5b                   	pop    %ebx
80103932:	5e                   	pop    %esi
80103933:	5d                   	pop    %ebp
80103934:	c3                   	ret    
  panic("unknown apicid\n");
80103935:	83 ec 0c             	sub    $0xc,%esp
80103938:	68 47 79 10 80       	push   $0x80107947
8010393d:	e8 3e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103942:	83 ec 0c             	sub    $0xc,%esp
80103945:	68 24 7a 10 80       	push   $0x80107a24
8010394a:	e8 31 ca ff ff       	call   80100380 <panic>
8010394f:	90                   	nop

80103950 <cpuid>:
cpuid() {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103956:	e8 95 ff ff ff       	call   801038f0 <mycpu>
}
8010395b:	c9                   	leave  
  return mycpu()-cpus;
8010395c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103961:	c1 f8 04             	sar    $0x4,%eax
80103964:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010396a:	c3                   	ret    
8010396b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop

80103970 <myproc>:
myproc(void) {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
80103974:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103977:	e8 74 0c 00 00       	call   801045f0 <pushcli>
  c = mycpu();
8010397c:	e8 6f ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103981:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103987:	e8 b4 0c 00 00       	call   80104640 <popcli>
}
8010398c:	89 d8                	mov    %ebx,%eax
8010398e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103991:	c9                   	leave  
80103992:	c3                   	ret    
80103993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039a0 <userinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
801039a4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039a7:	e8 04 fe ff ff       	call   801037b0 <allocproc>
801039ac:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ae:	a3 94 3d 11 80       	mov    %eax,0x80113d94
  if((p->pgdir = setupkvm()) == 0)
801039b3:	e8 f8 36 00 00       	call   801070b0 <setupkvm>
801039b8:	89 43 04             	mov    %eax,0x4(%ebx)
801039bb:	85 c0                	test   %eax,%eax
801039bd:	0f 84 bd 00 00 00    	je     80103a80 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039c3:	83 ec 04             	sub    $0x4,%esp
801039c6:	68 2c 00 00 00       	push   $0x2c
801039cb:	68 60 a4 10 80       	push   $0x8010a460
801039d0:	50                   	push   %eax
801039d1:	e8 8a 33 00 00       	call   80106d60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039d6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039d9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039df:	6a 4c                	push   $0x4c
801039e1:	6a 00                	push   $0x0
801039e3:	ff 73 18             	push   0x18(%ebx)
801039e6:	e8 15 0e 00 00       	call   80104800 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039eb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ee:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039f6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a0d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a11:	8b 43 18             	mov    0x18(%ebx),%eax
80103a14:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a18:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a3a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a3d:	6a 10                	push   $0x10
80103a3f:	68 70 79 10 80       	push   $0x80107970
80103a44:	50                   	push   %eax
80103a45:	e8 76 0f 00 00       	call   801049c0 <safestrcpy>
  p->cwd = namei("/");
80103a4a:	c7 04 24 79 79 10 80 	movl   $0x80107979,(%esp)
80103a51:	e8 4a e6 ff ff       	call   801020a0 <namei>
80103a56:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a59:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80103a60:	e8 db 0c 00 00       	call   80104740 <acquire>
  p->state = RUNNABLE;
80103a65:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a6c:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80103a73:	e8 68 0c 00 00       	call   801046e0 <release>
}
80103a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7b:	83 c4 10             	add    $0x10,%esp
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	68 57 79 10 80       	push   $0x80107957
80103a88:	e8 f3 c8 ff ff       	call   80100380 <panic>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi

80103a90 <growproc>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a98:	e8 53 0b 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80103a9d:	e8 4e fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103aa2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa8:	e8 93 0b 00 00       	call   80104640 <popcli>
  sz = curproc->sz;
80103aad:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aaf:	85 f6                	test   %esi,%esi
80103ab1:	7f 1d                	jg     80103ad0 <growproc+0x40>
  } else if(n < 0){
80103ab3:	75 3b                	jne    80103af0 <growproc+0x60>
  switchuvm(curproc);
80103ab5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ab8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aba:	53                   	push   %ebx
80103abb:	e8 90 31 00 00       	call   80106c50 <switchuvm>
  return 0;
80103ac0:	83 c4 10             	add    $0x10,%esp
80103ac3:	31 c0                	xor    %eax,%eax
}
80103ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac8:	5b                   	pop    %ebx
80103ac9:	5e                   	pop    %esi
80103aca:	5d                   	pop    %ebp
80103acb:	c3                   	ret    
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad0:	83 ec 04             	sub    $0x4,%esp
80103ad3:	01 c6                	add    %eax,%esi
80103ad5:	56                   	push   %esi
80103ad6:	50                   	push   %eax
80103ad7:	ff 73 04             	push   0x4(%ebx)
80103ada:	e8 f1 33 00 00       	call   80106ed0 <allocuvm>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	75 cf                	jne    80103ab5 <growproc+0x25>
      return -1;
80103ae6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aeb:	eb d8                	jmp    80103ac5 <growproc+0x35>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 01 35 00 00       	call   80107000 <deallocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 af                	jne    80103ab5 <growproc+0x25>
80103b06:	eb de                	jmp    80103ae6 <growproc+0x56>
80103b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop

80103b10 <fork>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b19:	e8 d2 0a 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80103b1e:	e8 cd fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b29:	e8 12 0b 00 00       	call   80104640 <popcli>
  if((np = allocproc()) == 0){
80103b2e:	e8 7d fc ff ff       	call   801037b0 <allocproc>
80103b33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b36:	85 c0                	test   %eax,%eax
80103b38:	0f 84 b7 00 00 00    	je     80103bf5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b3e:	83 ec 08             	sub    $0x8,%esp
80103b41:	ff 33                	push   (%ebx)
80103b43:	89 c7                	mov    %eax,%edi
80103b45:	ff 73 04             	push   0x4(%ebx)
80103b48:	e8 53 36 00 00       	call   801071a0 <copyuvm>
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	89 47 04             	mov    %eax,0x4(%edi)
80103b53:	85 c0                	test   %eax,%eax
80103b55:	0f 84 a1 00 00 00    	je     80103bfc <fork+0xec>
  np->sz = curproc->sz;
80103b5b:	8b 03                	mov    (%ebx),%eax
80103b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b60:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b62:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b65:	89 c8                	mov    %ecx,%eax
80103b67:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b6a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b6f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b74:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b76:	8b 40 18             	mov    0x18(%eax),%eax
80103b79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 13                	je     80103b9b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	50                   	push   %eax
80103b8c:	e8 0f d3 ff ff       	call   80100ea0 <filedup>
80103b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b94:	83 c4 10             	add    $0x10,%esp
80103b97:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b9b:	83 c6 01             	add    $0x1,%esi
80103b9e:	83 fe 10             	cmp    $0x10,%esi
80103ba1:	75 dd                	jne    80103b80 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ba3:	83 ec 0c             	sub    $0xc,%esp
80103ba6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bac:	e8 9f db ff ff       	call   80101750 <idup>
80103bb1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bb4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bb7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bba:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	53                   	push   %ebx
80103bc0:	50                   	push   %eax
80103bc1:	e8 fa 0d 00 00       	call   801049c0 <safestrcpy>
  pid = np->pid;
80103bc6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bc9:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80103bd0:	e8 6b 0b 00 00       	call   80104740 <acquire>
  np->state = RUNNABLE;
80103bd5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bdc:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80103be3:	e8 f8 0a 00 00       	call   801046e0 <release>
  return pid;
80103be8:	83 c4 10             	add    $0x10,%esp
}
80103beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bee:	89 d8                	mov    %ebx,%eax
80103bf0:	5b                   	pop    %ebx
80103bf1:	5e                   	pop    %esi
80103bf2:	5f                   	pop    %edi
80103bf3:	5d                   	pop    %ebp
80103bf4:	c3                   	ret    
    return -1;
80103bf5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bfa:	eb ef                	jmp    80103beb <fork+0xdb>
    kfree(np->kstack);
80103bfc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bff:	83 ec 0c             	sub    $0xc,%esp
80103c02:	ff 73 08             	push   0x8(%ebx)
80103c05:	e8 b6 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c0a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c11:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c14:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c20:	eb c9                	jmp    80103beb <fork+0xdb>
80103c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c30 <scheduler>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c39:	e8 b2 fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c45:	00 00 00 
  struct cpu *c = mycpu();
80103c48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c4a:	8d 78 04             	lea    0x4(%eax),%edi
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c50:	fb                   	sti    
    acquire(&ptable.lock);
80103c51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c54:	bb 94 1e 11 80       	mov    $0x80111e94,%ebx
    acquire(&ptable.lock);
80103c59:	68 60 1e 11 80       	push   $0x80111e60
80103c5e:	e8 dd 0a 00 00       	call   80104740 <acquire>
80103c63:	83 c4 10             	add    $0x10,%esp
80103c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c74:	75 33                	jne    80103ca9 <scheduler+0x79>
      switchuvm(p);
80103c76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c7f:	53                   	push   %ebx
80103c80:	e8 cb 2f 00 00       	call   80106c50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c85:	58                   	pop    %eax
80103c86:	5a                   	pop    %edx
80103c87:	ff 73 1c             	push   0x1c(%ebx)
80103c8a:	57                   	push   %edi
      p->state = RUNNING;
80103c8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c92:	e8 84 0d 00 00       	call   80104a1b <swtch>
      switchkvm();
80103c97:	e8 a4 2f 00 00       	call   80106c40 <switchkvm>
      c->proc = 0;
80103c9c:	83 c4 10             	add    $0x10,%esp
80103c9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ca6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca9:	83 c3 7c             	add    $0x7c,%ebx
80103cac:	81 fb 94 3d 11 80    	cmp    $0x80113d94,%ebx
80103cb2:	75 bc                	jne    80103c70 <scheduler+0x40>
    release(&ptable.lock);
80103cb4:	83 ec 0c             	sub    $0xc,%esp
80103cb7:	68 60 1e 11 80       	push   $0x80111e60
80103cbc:	e8 1f 0a 00 00       	call   801046e0 <release>
    sti();
80103cc1:	83 c4 10             	add    $0x10,%esp
80103cc4:	eb 8a                	jmp    80103c50 <scheduler+0x20>
80103cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi

80103cd0 <sched>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
  pushcli();
80103cd5:	e8 16 09 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80103cda:	e8 11 fc ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103cdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce5:	e8 56 09 00 00       	call   80104640 <popcli>
  if(!holding(&ptable.lock))
80103cea:	83 ec 0c             	sub    $0xc,%esp
80103ced:	68 60 1e 11 80       	push   $0x80111e60
80103cf2:	e8 a9 09 00 00       	call   801046a0 <holding>
80103cf7:	83 c4 10             	add    $0x10,%esp
80103cfa:	85 c0                	test   %eax,%eax
80103cfc:	74 4f                	je     80103d4d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103cfe:	e8 ed fb ff ff       	call   801038f0 <mycpu>
80103d03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d0a:	75 68                	jne    80103d74 <sched+0xa4>
  if(p->state == RUNNING)
80103d0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d10:	74 55                	je     80103d67 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d12:	9c                   	pushf  
80103d13:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d14:	f6 c4 02             	test   $0x2,%ah
80103d17:	75 41                	jne    80103d5a <sched+0x8a>
  intena = mycpu()->intena;
80103d19:	e8 d2 fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d1e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d27:	e8 c4 fb ff ff       	call   801038f0 <mycpu>
80103d2c:	83 ec 08             	sub    $0x8,%esp
80103d2f:	ff 70 04             	push   0x4(%eax)
80103d32:	53                   	push   %ebx
80103d33:	e8 e3 0c 00 00       	call   80104a1b <swtch>
  mycpu()->intena = intena;
80103d38:	e8 b3 fb ff ff       	call   801038f0 <mycpu>
}
80103d3d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5d                   	pop    %ebp
80103d4c:	c3                   	ret    
    panic("sched ptable.lock");
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	68 7b 79 10 80       	push   $0x8010797b
80103d55:	e8 26 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 a7 79 10 80       	push   $0x801079a7
80103d62:	e8 19 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d67:	83 ec 0c             	sub    $0xc,%esp
80103d6a:	68 99 79 10 80       	push   $0x80107999
80103d6f:	e8 0c c6 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 8d 79 10 80       	push   $0x8010798d
80103d7c:	e8 ff c5 ff ff       	call   80100380 <panic>
80103d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8f:	90                   	nop

80103d90 <exit>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103d99:	e8 d2 fb ff ff       	call   80103970 <myproc>
  if(curproc == initproc)
80103d9e:	39 05 94 3d 11 80    	cmp    %eax,0x80113d94
80103da4:	0f 84 fd 00 00 00    	je     80103ea7 <exit+0x117>
80103daa:	89 c3                	mov    %eax,%ebx
80103dac:	8d 70 28             	lea    0x28(%eax),%esi
80103daf:	8d 78 68             	lea    0x68(%eax),%edi
80103db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103db8:	8b 06                	mov    (%esi),%eax
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 12                	je     80103dd0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dbe:	83 ec 0c             	sub    $0xc,%esp
80103dc1:	50                   	push   %eax
80103dc2:	e8 29 d1 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103dc7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dcd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103dd0:	83 c6 04             	add    $0x4,%esi
80103dd3:	39 f7                	cmp    %esi,%edi
80103dd5:	75 e1                	jne    80103db8 <exit+0x28>
  begin_op();
80103dd7:	e8 84 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103ddc:	83 ec 0c             	sub    $0xc,%esp
80103ddf:	ff 73 68             	push   0x68(%ebx)
80103de2:	e8 c9 da ff ff       	call   801018b0 <iput>
  end_op();
80103de7:	e8 e4 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103dec:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103df3:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80103dfa:	e8 41 09 00 00       	call   80104740 <acquire>
  wakeup1(curproc->parent);
80103dff:	8b 53 14             	mov    0x14(%ebx),%edx
80103e02:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e05:	b8 94 1e 11 80       	mov    $0x80111e94,%eax
80103e0a:	eb 0e                	jmp    80103e1a <exit+0x8a>
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e10:	83 c0 7c             	add    $0x7c,%eax
80103e13:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80103e18:	74 1c                	je     80103e36 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e1e:	75 f0                	jne    80103e10 <exit+0x80>
80103e20:	3b 50 20             	cmp    0x20(%eax),%edx
80103e23:	75 eb                	jne    80103e10 <exit+0x80>
      p->state = RUNNABLE;
80103e25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e2c:	83 c0 7c             	add    $0x7c,%eax
80103e2f:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80103e34:	75 e4                	jne    80103e1a <exit+0x8a>
      p->parent = initproc;
80103e36:	8b 0d 94 3d 11 80    	mov    0x80113d94,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3c:	ba 94 1e 11 80       	mov    $0x80111e94,%edx
80103e41:	eb 10                	jmp    80103e53 <exit+0xc3>
80103e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e47:	90                   	nop
80103e48:	83 c2 7c             	add    $0x7c,%edx
80103e4b:	81 fa 94 3d 11 80    	cmp    $0x80113d94,%edx
80103e51:	74 3b                	je     80103e8e <exit+0xfe>
    if(p->parent == curproc){
80103e53:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e56:	75 f0                	jne    80103e48 <exit+0xb8>
      if(p->state == ZOMBIE)
80103e58:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e5c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e5f:	75 e7                	jne    80103e48 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e61:	b8 94 1e 11 80       	mov    $0x80111e94,%eax
80103e66:	eb 12                	jmp    80103e7a <exit+0xea>
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop
80103e70:	83 c0 7c             	add    $0x7c,%eax
80103e73:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80103e78:	74 ce                	je     80103e48 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <exit+0xe0>
80103e80:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e83:	75 eb                	jne    80103e70 <exit+0xe0>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e8c:	eb e2                	jmp    80103e70 <exit+0xe0>
  curproc->state = ZOMBIE;
80103e8e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103e95:	e8 36 fe ff ff       	call   80103cd0 <sched>
  panic("zombie exit");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 c8 79 10 80       	push   $0x801079c8
80103ea2:	e8 d9 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ea7:	83 ec 0c             	sub    $0xc,%esp
80103eaa:	68 bb 79 10 80       	push   $0x801079bb
80103eaf:	e8 cc c4 ff ff       	call   80100380 <panic>
80103eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ebf:	90                   	nop

80103ec0 <wait>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  pushcli();
80103ec5:	e8 26 07 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80103eca:	e8 21 fa ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ecf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ed5:	e8 66 07 00 00       	call   80104640 <popcli>
  acquire(&ptable.lock);
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 60 1e 11 80       	push   $0x80111e60
80103ee2:	e8 59 08 00 00       	call   80104740 <acquire>
80103ee7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	bb 94 1e 11 80       	mov    $0x80111e94,%ebx
80103ef1:	eb 10                	jmp    80103f03 <wait+0x43>
80103ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef7:	90                   	nop
80103ef8:	83 c3 7c             	add    $0x7c,%ebx
80103efb:	81 fb 94 3d 11 80    	cmp    $0x80113d94,%ebx
80103f01:	74 1b                	je     80103f1e <wait+0x5e>
      if(p->parent != curproc)
80103f03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f06:	75 f0                	jne    80103ef8 <wait+0x38>
      if(p->state == ZOMBIE){
80103f08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f0c:	74 62                	je     80103f70 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f11:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	81 fb 94 3d 11 80    	cmp    $0x80113d94,%ebx
80103f1c:	75 e5                	jne    80103f03 <wait+0x43>
    if(!havekids || curproc->killed){
80103f1e:	85 c0                	test   %eax,%eax
80103f20:	0f 84 a0 00 00 00    	je     80103fc6 <wait+0x106>
80103f26:	8b 46 24             	mov    0x24(%esi),%eax
80103f29:	85 c0                	test   %eax,%eax
80103f2b:	0f 85 95 00 00 00    	jne    80103fc6 <wait+0x106>
  pushcli();
80103f31:	e8 ba 06 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80103f36:	e8 b5 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f3b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f41:	e8 fa 06 00 00       	call   80104640 <popcli>
  if(p == 0)
80103f46:	85 db                	test   %ebx,%ebx
80103f48:	0f 84 8f 00 00 00    	je     80103fdd <wait+0x11d>
  p->chan = chan;
80103f4e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f51:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f58:	e8 73 fd ff ff       	call   80103cd0 <sched>
  p->chan = 0;
80103f5d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f64:	eb 84                	jmp    80103eea <wait+0x2a>
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f70:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f73:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f76:	ff 73 08             	push   0x8(%ebx)
80103f79:	e8 42 e5 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80103f7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f85:	5a                   	pop    %edx
80103f86:	ff 73 04             	push   0x4(%ebx)
80103f89:	e8 a2 30 00 00       	call   80107030 <freevm>
        p->pid = 0;
80103f8e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f95:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f9c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fa0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fa7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fae:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80103fb5:	e8 26 07 00 00       	call   801046e0 <release>
        return pid;
80103fba:	83 c4 10             	add    $0x10,%esp
}
80103fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc0:	89 f0                	mov    %esi,%eax
80103fc2:	5b                   	pop    %ebx
80103fc3:	5e                   	pop    %esi
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
      release(&ptable.lock);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fc9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fce:	68 60 1e 11 80       	push   $0x80111e60
80103fd3:	e8 08 07 00 00       	call   801046e0 <release>
      return -1;
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	eb e0                	jmp    80103fbd <wait+0xfd>
    panic("sleep");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 d4 79 10 80       	push   $0x801079d4
80103fe5:	e8 96 c3 ff ff       	call   80100380 <panic>
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ff0 <yield>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ff7:	68 60 1e 11 80       	push   $0x80111e60
80103ffc:	e8 3f 07 00 00       	call   80104740 <acquire>
  pushcli();
80104001:	e8 ea 05 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80104006:	e8 e5 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
8010400b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104011:	e8 2a 06 00 00       	call   80104640 <popcli>
  myproc()->state = RUNNABLE;
80104016:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010401d:	e8 ae fc ff ff       	call   80103cd0 <sched>
  release(&ptable.lock);
80104022:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80104029:	e8 b2 06 00 00       	call   801046e0 <release>
}
8010402e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104031:	83 c4 10             	add    $0x10,%esp
80104034:	c9                   	leave  
80104035:	c3                   	ret    
80104036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <sleep>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	8b 7d 08             	mov    0x8(%ebp),%edi
8010404c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010404f:	e8 9c 05 00 00       	call   801045f0 <pushcli>
  c = mycpu();
80104054:	e8 97 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104059:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010405f:	e8 dc 05 00 00       	call   80104640 <popcli>
  if(p == 0)
80104064:	85 db                	test   %ebx,%ebx
80104066:	0f 84 87 00 00 00    	je     801040f3 <sleep+0xb3>
  if(lk == 0)
8010406c:	85 f6                	test   %esi,%esi
8010406e:	74 76                	je     801040e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104070:	81 fe 60 1e 11 80    	cmp    $0x80111e60,%esi
80104076:	74 50                	je     801040c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	68 60 1e 11 80       	push   $0x80111e60
80104080:	e8 bb 06 00 00       	call   80104740 <acquire>
    release(lk);
80104085:	89 34 24             	mov    %esi,(%esp)
80104088:	e8 53 06 00 00       	call   801046e0 <release>
  p->chan = chan;
8010408d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104090:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104097:	e8 34 fc ff ff       	call   80103cd0 <sched>
  p->chan = 0;
8010409c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040a3:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801040aa:	e8 31 06 00 00       	call   801046e0 <release>
    acquire(lk);
801040af:	89 75 08             	mov    %esi,0x8(%ebp)
801040b2:	83 c4 10             	add    $0x10,%esp
}
801040b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b8:	5b                   	pop    %ebx
801040b9:	5e                   	pop    %esi
801040ba:	5f                   	pop    %edi
801040bb:	5d                   	pop    %ebp
    acquire(lk);
801040bc:	e9 7f 06 00 00       	jmp    80104740 <acquire>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d2:	e8 f9 fb ff ff       	call   80103cd0 <sched>
  p->chan = 0;
801040d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5f                   	pop    %edi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret    
    panic("sleep without lk");
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	68 da 79 10 80       	push   $0x801079da
801040ee:	e8 8d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
801040f3:	83 ec 0c             	sub    $0xc,%esp
801040f6:	68 d4 79 10 80       	push   $0x801079d4
801040fb:	e8 80 c2 ff ff       	call   80100380 <panic>

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410a:	68 60 1e 11 80       	push   $0x80111e60
8010410f:	e8 2c 06 00 00       	call   80104740 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104117:	b8 94 1e 11 80       	mov    $0x80111e94,%eax
8010411c:	eb 0c                	jmp    8010412a <wakeup+0x2a>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	83 c0 7c             	add    $0x7c,%eax
80104123:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80104128:	74 1c                	je     80104146 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010412a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010412e:	75 f0                	jne    80104120 <wakeup+0x20>
80104130:	3b 58 20             	cmp    0x20(%eax),%ebx
80104133:	75 eb                	jne    80104120 <wakeup+0x20>
      p->state = RUNNABLE;
80104135:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413c:	83 c0 7c             	add    $0x7c,%eax
8010413f:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80104144:	75 e4                	jne    8010412a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104146:	c7 45 08 60 1e 11 80 	movl   $0x80111e60,0x8(%ebp)
}
8010414d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104150:	c9                   	leave  
  release(&ptable.lock);
80104151:	e9 8a 05 00 00       	jmp    801046e0 <release>
80104156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415d:	8d 76 00             	lea    0x0(%esi),%esi

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416a:	68 60 1e 11 80       	push   $0x80111e60
8010416f:	e8 cc 05 00 00       	call   80104740 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104177:	b8 94 1e 11 80       	mov    $0x80111e94,%eax
8010417c:	eb 0c                	jmp    8010418a <kill+0x2a>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	83 c0 7c             	add    $0x7c,%eax
80104183:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80104188:	74 36                	je     801041c0 <kill+0x60>
    if(p->pid == pid){
8010418a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010418d:	75 f1                	jne    80104180 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010418f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104193:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010419a:	75 07                	jne    801041a3 <kill+0x43>
        p->state = RUNNABLE;
8010419c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 60 1e 11 80       	push   $0x80111e60
801041ab:	e8 30 05 00 00       	call   801046e0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041b3:	83 c4 10             	add    $0x10,%esp
801041b6:	31 c0                	xor    %eax,%eax
}
801041b8:	c9                   	leave  
801041b9:	c3                   	ret    
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c0:	83 ec 0c             	sub    $0xc,%esp
801041c3:	68 60 1e 11 80       	push   $0x80111e60
801041c8:	e8 13 05 00 00       	call   801046e0 <release>
}
801041cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041d0:	83 c4 10             	add    $0x10,%esp
801041d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d8:	c9                   	leave  
801041d9:	c3                   	ret    
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041e8:	53                   	push   %ebx
801041e9:	bb 00 1f 11 80       	mov    $0x80111f00,%ebx
801041ee:	83 ec 3c             	sub    $0x3c,%esp
801041f1:	eb 24                	jmp    80104217 <procdump+0x37>
801041f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 63 7d 10 80       	push   $0x80107d63
80104200:	e8 9b c4 ff ff       	call   801006a0 <cprintf>
80104205:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104208:	83 c3 7c             	add    $0x7c,%ebx
8010420b:	81 fb 00 3e 11 80    	cmp    $0x80113e00,%ebx
80104211:	0f 84 81 00 00 00    	je     80104298 <procdump+0xb8>
    if(p->state == UNUSED)
80104217:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010421a:	85 c0                	test   %eax,%eax
8010421c:	74 ea                	je     80104208 <procdump+0x28>
      state = "???";
8010421e:	ba eb 79 10 80       	mov    $0x801079eb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104223:	83 f8 05             	cmp    $0x5,%eax
80104226:	77 11                	ja     80104239 <procdump+0x59>
80104228:	8b 14 85 4c 7a 10 80 	mov    -0x7fef85b4(,%eax,4),%edx
      state = "???";
8010422f:	b8 eb 79 10 80       	mov    $0x801079eb,%eax
80104234:	85 d2                	test   %edx,%edx
80104236:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104239:	53                   	push   %ebx
8010423a:	52                   	push   %edx
8010423b:	ff 73 a4             	push   -0x5c(%ebx)
8010423e:	68 ef 79 10 80       	push   $0x801079ef
80104243:	e8 58 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
80104248:	83 c4 10             	add    $0x10,%esp
8010424b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010424f:	75 a7                	jne    801041f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104251:	83 ec 08             	sub    $0x8,%esp
80104254:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104257:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010425a:	50                   	push   %eax
8010425b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010425e:	8b 40 0c             	mov    0xc(%eax),%eax
80104261:	83 c0 08             	add    $0x8,%eax
80104264:	50                   	push   %eax
80104265:	e8 26 03 00 00       	call   80104590 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010426a:	83 c4 10             	add    $0x10,%esp
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
80104270:	8b 17                	mov    (%edi),%edx
80104272:	85 d2                	test   %edx,%edx
80104274:	74 82                	je     801041f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104276:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104279:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010427c:	52                   	push   %edx
8010427d:	68 41 74 10 80       	push   $0x80107441
80104282:	e8 19 c4 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104287:	83 c4 10             	add    $0x10,%esp
8010428a:	39 fe                	cmp    %edi,%esi
8010428c:	75 e2                	jne    80104270 <procdump+0x90>
8010428e:	e9 65 ff ff ff       	jmp    801041f8 <procdump+0x18>
80104293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104297:	90                   	nop
  }
}
80104298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010429b:	5b                   	pop    %ebx
8010429c:	5e                   	pop    %esi
8010429d:	5f                   	pop    %edi
8010429e:	5d                   	pop    %ebp
8010429f:	c3                   	ret    

801042a0 <sem_init>:
};

struct semaphore semaphores[SEMAPHORES_SIZE];

int sem_init(int i, int v)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	83 ec 0c             	sub    $0xc,%esp
  if (semaphores[i].init == 1)
801042a9:	6b 5d 08 3c          	imul   $0x3c,0x8(%ebp),%ebx
801042ad:	83 bb 24 1d 11 80 01 	cmpl   $0x1,-0x7feee2dc(%ebx)
801042b4:	74 3a                	je     801042f0 <sem_init+0x50>
    return -1;
    
  acquire(&semaphores[i].lock);
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	8d b3 28 1d 11 80    	lea    -0x7feee2d8(%ebx),%esi
801042bf:	56                   	push   %esi
801042c0:	e8 7b 04 00 00       	call   80104740 <acquire>

  semaphores[i].value = v;
801042c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  semaphores[i].init = 1;

  release(&semaphores[i].lock);
801042c8:	89 34 24             	mov    %esi,(%esp)
  semaphores[i].init = 1;
801042cb:	c7 83 24 1d 11 80 01 	movl   $0x1,-0x7feee2dc(%ebx)
801042d2:	00 00 00 
  semaphores[i].value = v;
801042d5:	89 83 20 1d 11 80    	mov    %eax,-0x7feee2e0(%ebx)
  release(&semaphores[i].lock);
801042db:	e8 00 04 00 00       	call   801046e0 <release>
  return 0;
801042e0:	83 c4 10             	add    $0x10,%esp
801042e3:	31 c0                	xor    %eax,%eax
}
801042e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e8:	5b                   	pop    %ebx
801042e9:	5e                   	pop    %esi
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
801042ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801042f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042f5:	eb ee                	jmp    801042e5 <sem_init+0x45>
801042f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fe:	66 90                	xchg   %ax,%ax

80104300 <sem_acquire>:

int sem_acquire(int i)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	53                   	push   %ebx
80104306:	83 ec 0c             	sub    $0xc,%esp

  if (semaphores[i].init == 0)
80104309:	6b 5d 08 3c          	imul   $0x3c,0x8(%ebp),%ebx
8010430d:	8b 83 24 1d 11 80    	mov    -0x7feee2dc(%ebx),%eax
80104313:	85 c0                	test   %eax,%eax
80104315:	74 63                	je     8010437a <sem_acquire+0x7a>
    return -1;
  // cprintf(" sec1  ");
  acquire(&semaphores[i].lock);
80104317:	83 ec 0c             	sub    $0xc,%esp
8010431a:	8d b3 28 1d 11 80    	lea    -0x7feee2d8(%ebx),%esi
80104320:	8d bb 20 1d 11 80    	lea    -0x7feee2e0(%ebx),%edi
80104326:	56                   	push   %esi
80104327:	e8 14 04 00 00       	call   80104740 <acquire>
  // cprintf(" sec2  ");


  while (semaphores[i].value <= 0) {
8010432c:	8b 83 20 1d 11 80    	mov    -0x7feee2e0(%ebx),%eax
80104332:	83 c4 10             	add    $0x10,%esp
80104335:	85 c0                	test   %eax,%eax
80104337:	7f 1e                	jg     80104357 <sem_acquire+0x57>
80104339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(&semaphores[i], &semaphores[i].lock);
80104340:	83 ec 08             	sub    $0x8,%esp
80104343:	56                   	push   %esi
80104344:	57                   	push   %edi
80104345:	e8 f6 fc ff ff       	call   80104040 <sleep>
  while (semaphores[i].value <= 0) {
8010434a:	8b 83 20 1d 11 80    	mov    -0x7feee2e0(%ebx),%eax
80104350:	83 c4 10             	add    $0x10,%esp
80104353:	85 c0                	test   %eax,%eax
80104355:	7e e9                	jle    80104340 <sem_acquire+0x40>
  
  // cprintf("acquire sem value before: %d\n" , semaphores[i].value);
  semaphores[i].value--;
  // cprintf("acquire sem value after: %d\n" , semaphores[i].value);
  // cprintf(" sec5  ");
  release(&semaphores[i].lock);
80104357:	83 ec 0c             	sub    $0xc,%esp
  semaphores[i].value--;
8010435a:	6b 55 08 3c          	imul   $0x3c,0x8(%ebp),%edx
8010435e:	83 e8 01             	sub    $0x1,%eax
  release(&semaphores[i].lock);
80104361:	56                   	push   %esi
  semaphores[i].value--;
80104362:	89 82 20 1d 11 80    	mov    %eax,-0x7feee2e0(%edx)
  release(&semaphores[i].lock);
80104368:	e8 73 03 00 00       	call   801046e0 <release>
  // cprintf(" sec6  ");
  return 0;
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	31 c0                	xor    %eax,%eax
}
80104372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104375:	5b                   	pop    %ebx
80104376:	5e                   	pop    %esi
80104377:	5f                   	pop    %edi
80104378:	5d                   	pop    %ebp
80104379:	c3                   	ret    
    return -1;
8010437a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010437f:	eb f1                	jmp    80104372 <sem_acquire+0x72>
80104381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438f:	90                   	nop

80104390 <sem_release>:


int sem_release(int i)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	56                   	push   %esi
80104395:	53                   	push   %ebx
80104396:	83 ec 0c             	sub    $0xc,%esp
  if (semaphores[i].init == 0)
80104399:	6b 7d 08 3c          	imul   $0x3c,0x8(%ebp),%edi
8010439d:	8b 87 24 1d 11 80    	mov    -0x7feee2dc(%edi),%eax
801043a3:	85 c0                	test   %eax,%eax
801043a5:	0f 84 87 00 00 00    	je     80104432 <sem_release+0xa2>
    return -1;

  acquire(&semaphores[i].lock);
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	8d b7 28 1d 11 80    	lea    -0x7feee2d8(%edi),%esi
801043b4:	8d 9f 20 1d 11 80    	lea    -0x7feee2e0(%edi),%ebx
801043ba:	56                   	push   %esi
801043bb:	e8 80 03 00 00       	call   80104740 <acquire>
  acquire(&ptable.lock);
801043c0:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
  // cprintf("release sem value before: %d\n" , semaphores[i].value);
  semaphores[i].value++;
801043c7:	83 87 20 1d 11 80 01 	addl   $0x1,-0x7feee2e0(%edi)
  acquire(&ptable.lock);
801043ce:	e8 6d 03 00 00       	call   80104740 <acquire>
801043d3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d6:	b8 94 1e 11 80       	mov    $0x80111e94,%eax
801043db:	eb 0d                	jmp    801043ea <sem_release+0x5a>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
801043e0:	83 c0 7c             	add    $0x7c,%eax
801043e3:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
801043e8:	74 26                	je     80104410 <sem_release+0x80>
    if(p->state == SLEEPING && p->chan == chan)
801043ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043ee:	75 f0                	jne    801043e0 <sem_release+0x50>
801043f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801043f3:	75 eb                	jne    801043e0 <sem_release+0x50>
      p->state = RUNNABLE;
801043f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043fc:	83 c0 7c             	add    $0x7c,%eax
801043ff:	3d 94 3d 11 80       	cmp    $0x80113d94,%eax
80104404:	75 e4                	jne    801043ea <sem_release+0x5a>
80104406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 60 1e 11 80       	push   $0x80111e60
80104418:	e8 c3 02 00 00       	call   801046e0 <release>
  // cprintf("release sem value after: %d\n" , semaphores[i].value);
  wakeup(&semaphores[i]);
  release(&semaphores[i].lock);
8010441d:	89 34 24             	mov    %esi,(%esp)
80104420:	e8 bb 02 00 00       	call   801046e0 <release>
  return 0;
80104425:	83 c4 10             	add    $0x10,%esp
80104428:	31 c0                	xor    %eax,%eax
}
8010442a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010442d:	5b                   	pop    %ebx
8010442e:	5e                   	pop    %esi
8010442f:	5f                   	pop    %edi
80104430:	5d                   	pop    %ebp
80104431:	c3                   	ret    
    return -1;
80104432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104437:	eb f1                	jmp    8010442a <sem_release+0x9a>
80104439:	66 90                	xchg   %ax,%ax
8010443b:	66 90                	xchg   %ax,%ax
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010444a:	68 64 7a 10 80       	push   $0x80107a64
8010444f:	8d 43 04             	lea    0x4(%ebx),%eax
80104452:	50                   	push   %eax
80104453:	e8 18 01 00 00       	call   80104570 <initlock>
  lk->name = name;
80104458:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010445b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104461:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104464:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010446b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010446e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104471:	c9                   	leave  
80104472:	c3                   	ret    
80104473:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104488:	8d 73 04             	lea    0x4(%ebx),%esi
8010448b:	83 ec 0c             	sub    $0xc,%esp
8010448e:	56                   	push   %esi
8010448f:	e8 ac 02 00 00       	call   80104740 <acquire>
  while (lk->locked) {
80104494:	8b 13                	mov    (%ebx),%edx
80104496:	83 c4 10             	add    $0x10,%esp
80104499:	85 d2                	test   %edx,%edx
8010449b:	74 16                	je     801044b3 <acquiresleep+0x33>
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044a0:	83 ec 08             	sub    $0x8,%esp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	e8 96 fb ff ff       	call   80104040 <sleep>
  while (lk->locked) {
801044aa:	8b 03                	mov    (%ebx),%eax
801044ac:	83 c4 10             	add    $0x10,%esp
801044af:	85 c0                	test   %eax,%eax
801044b1:	75 ed                	jne    801044a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044b9:	e8 b2 f4 ff ff       	call   80103970 <myproc>
801044be:	8b 40 10             	mov    0x10(%eax),%eax
801044c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ca:	5b                   	pop    %ebx
801044cb:	5e                   	pop    %esi
801044cc:	5d                   	pop    %ebp
  release(&lk->lk);
801044cd:	e9 0e 02 00 00       	jmp    801046e0 <release>
801044d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
801044e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044e8:	8d 73 04             	lea    0x4(%ebx),%esi
801044eb:	83 ec 0c             	sub    $0xc,%esp
801044ee:	56                   	push   %esi
801044ef:	e8 4c 02 00 00       	call   80104740 <acquire>
  lk->locked = 0;
801044f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104501:	89 1c 24             	mov    %ebx,(%esp)
80104504:	e8 f7 fb ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
80104509:	89 75 08             	mov    %esi,0x8(%ebp)
8010450c:	83 c4 10             	add    $0x10,%esp
}
8010450f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
  release(&lk->lk);
80104515:	e9 c6 01 00 00       	jmp    801046e0 <release>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	31 ff                	xor    %edi,%edi
80104526:	56                   	push   %esi
80104527:	53                   	push   %ebx
80104528:	83 ec 18             	sub    $0x18,%esp
8010452b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010452e:	8d 73 04             	lea    0x4(%ebx),%esi
80104531:	56                   	push   %esi
80104532:	e8 09 02 00 00       	call   80104740 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104537:	8b 03                	mov    (%ebx),%eax
80104539:	83 c4 10             	add    $0x10,%esp
8010453c:	85 c0                	test   %eax,%eax
8010453e:	75 18                	jne    80104558 <holdingsleep+0x38>
  release(&lk->lk);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	56                   	push   %esi
80104544:	e8 97 01 00 00       	call   801046e0 <release>
  return r;
}
80104549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010454c:	89 f8                	mov    %edi,%eax
8010454e:	5b                   	pop    %ebx
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104557:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104558:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010455b:	e8 10 f4 ff ff       	call   80103970 <myproc>
80104560:	39 58 10             	cmp    %ebx,0x10(%eax)
80104563:	0f 94 c0             	sete   %al
80104566:	0f b6 c0             	movzbl %al,%eax
80104569:	89 c7                	mov    %eax,%edi
8010456b:	eb d3                	jmp    80104540 <holdingsleep+0x20>
8010456d:	66 90                	xchg   %ax,%ax
8010456f:	90                   	nop

80104570 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104576:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010457f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    
8010458b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010458f:	90                   	nop

80104590 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104590:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104591:	31 d2                	xor    %edx,%edx
{
80104593:	89 e5                	mov    %esp,%ebp
80104595:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104596:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104599:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010459c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010459f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045ac:	77 1a                	ja     801045c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045ae:	8b 58 04             	mov    0x4(%eax),%ebx
801045b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045b9:	83 fa 0a             	cmp    $0xa,%edx
801045bc:	75 e2                	jne    801045a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c1:	c9                   	leave  
801045c2:	c3                   	ret    
801045c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c7:	90                   	nop
  for(; i < 10; i++)
801045c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801045cb:	8d 51 28             	lea    0x28(%ecx),%edx
801045ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045d6:	83 c0 04             	add    $0x4,%eax
801045d9:	39 d0                	cmp    %edx,%eax
801045db:	75 f3                	jne    801045d0 <getcallerpcs+0x40>
}
801045dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e0:	c9                   	leave  
801045e1:	c3                   	ret    
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 04             	sub    $0x4,%esp
801045f7:	9c                   	pushf  
801045f8:	5b                   	pop    %ebx
  asm volatile("cli");
801045f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045fa:	e8 f1 f2 ff ff       	call   801038f0 <mycpu>
801045ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104605:	85 c0                	test   %eax,%eax
80104607:	74 17                	je     80104620 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104609:	e8 e2 f2 ff ff       	call   801038f0 <mycpu>
8010460e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104618:	c9                   	leave  
80104619:	c3                   	ret    
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104620:	e8 cb f2 ff ff       	call   801038f0 <mycpu>
80104625:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010462b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104631:	eb d6                	jmp    80104609 <pushcli+0x19>
80104633:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104640 <popcli>:

void
popcli(void)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104646:	9c                   	pushf  
80104647:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104648:	f6 c4 02             	test   $0x2,%ah
8010464b:	75 35                	jne    80104682 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010464d:	e8 9e f2 ff ff       	call   801038f0 <mycpu>
80104652:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104659:	78 34                	js     8010468f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010465b:	e8 90 f2 ff ff       	call   801038f0 <mycpu>
80104660:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104666:	85 d2                	test   %edx,%edx
80104668:	74 06                	je     80104670 <popcli+0x30>
    sti();
}
8010466a:	c9                   	leave  
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104670:	e8 7b f2 ff ff       	call   801038f0 <mycpu>
80104675:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010467b:	85 c0                	test   %eax,%eax
8010467d:	74 eb                	je     8010466a <popcli+0x2a>
  asm volatile("sti");
8010467f:	fb                   	sti    
}
80104680:	c9                   	leave  
80104681:	c3                   	ret    
    panic("popcli - interruptible");
80104682:	83 ec 0c             	sub    $0xc,%esp
80104685:	68 6f 7a 10 80       	push   $0x80107a6f
8010468a:	e8 f1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
8010468f:	83 ec 0c             	sub    $0xc,%esp
80104692:	68 86 7a 10 80       	push   $0x80107a86
80104697:	e8 e4 bc ff ff       	call   80100380 <panic>
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <holding>:
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 75 08             	mov    0x8(%ebp),%esi
801046a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046aa:	e8 41 ff ff ff       	call   801045f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046af:	8b 06                	mov    (%esi),%eax
801046b1:	85 c0                	test   %eax,%eax
801046b3:	75 0b                	jne    801046c0 <holding+0x20>
  popcli();
801046b5:	e8 86 ff ff ff       	call   80104640 <popcli>
}
801046ba:	89 d8                	mov    %ebx,%eax
801046bc:	5b                   	pop    %ebx
801046bd:	5e                   	pop    %esi
801046be:	5d                   	pop    %ebp
801046bf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801046c0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046c3:	e8 28 f2 ff ff       	call   801038f0 <mycpu>
801046c8:	39 c3                	cmp    %eax,%ebx
801046ca:	0f 94 c3             	sete   %bl
  popcli();
801046cd:	e8 6e ff ff ff       	call   80104640 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046d2:	0f b6 db             	movzbl %bl,%ebx
}
801046d5:	89 d8                	mov    %ebx,%eax
801046d7:	5b                   	pop    %ebx
801046d8:	5e                   	pop    %esi
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <release>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046e8:	e8 03 ff ff ff       	call   801045f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046ed:	8b 03                	mov    (%ebx),%eax
801046ef:	85 c0                	test   %eax,%eax
801046f1:	75 15                	jne    80104708 <release+0x28>
  popcli();
801046f3:	e8 48 ff ff ff       	call   80104640 <popcli>
    panic("release");
801046f8:	83 ec 0c             	sub    $0xc,%esp
801046fb:	68 8d 7a 10 80       	push   $0x80107a8d
80104700:	e8 7b bc ff ff       	call   80100380 <panic>
80104705:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104708:	8b 73 08             	mov    0x8(%ebx),%esi
8010470b:	e8 e0 f1 ff ff       	call   801038f0 <mycpu>
80104710:	39 c6                	cmp    %eax,%esi
80104712:	75 df                	jne    801046f3 <release+0x13>
  popcli();
80104714:	e8 27 ff ff ff       	call   80104640 <popcli>
  lk->pcs[0] = 0;
80104719:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104720:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104727:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010472c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104732:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104735:	5b                   	pop    %ebx
80104736:	5e                   	pop    %esi
80104737:	5d                   	pop    %ebp
  popcli();
80104738:	e9 03 ff ff ff       	jmp    80104640 <popcli>
8010473d:	8d 76 00             	lea    0x0(%esi),%esi

80104740 <acquire>:
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104747:	e8 a4 fe ff ff       	call   801045f0 <pushcli>
  if(holding(lk))
8010474c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010474f:	e8 9c fe ff ff       	call   801045f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104754:	8b 03                	mov    (%ebx),%eax
80104756:	85 c0                	test   %eax,%eax
80104758:	75 7e                	jne    801047d8 <acquire+0x98>
  popcli();
8010475a:	e8 e1 fe ff ff       	call   80104640 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010475f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104768:	8b 55 08             	mov    0x8(%ebp),%edx
8010476b:	89 c8                	mov    %ecx,%eax
8010476d:	f0 87 02             	lock xchg %eax,(%edx)
80104770:	85 c0                	test   %eax,%eax
80104772:	75 f4                	jne    80104768 <acquire+0x28>
  __sync_synchronize();
80104774:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104779:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010477c:	e8 6f f1 ff ff       	call   801038f0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104781:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104784:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104786:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104789:	31 c0                	xor    %eax,%eax
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104790:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104796:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010479c:	77 1a                	ja     801047b8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010479e:	8b 5a 04             	mov    0x4(%edx),%ebx
801047a1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047a5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047a8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047aa:	83 f8 0a             	cmp    $0xa,%eax
801047ad:	75 e1                	jne    80104790 <acquire+0x50>
}
801047af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b2:	c9                   	leave  
801047b3:	c3                   	ret    
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801047b8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801047bc:	8d 51 34             	lea    0x34(%ecx),%edx
801047bf:	90                   	nop
    pcs[i] = 0;
801047c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047c6:	83 c0 04             	add    $0x4,%eax
801047c9:	39 c2                	cmp    %eax,%edx
801047cb:	75 f3                	jne    801047c0 <acquire+0x80>
}
801047cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d0:	c9                   	leave  
801047d1:	c3                   	ret    
801047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801047d8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047db:	e8 10 f1 ff ff       	call   801038f0 <mycpu>
801047e0:	39 c3                	cmp    %eax,%ebx
801047e2:	0f 85 72 ff ff ff    	jne    8010475a <acquire+0x1a>
  popcli();
801047e8:	e8 53 fe ff ff       	call   80104640 <popcli>
    panic("acquire");
801047ed:	83 ec 0c             	sub    $0xc,%esp
801047f0:	68 95 7a 10 80       	push   $0x80107a95
801047f5:	e8 86 bb ff ff       	call   80100380 <panic>
801047fa:	66 90                	xchg   %ax,%ax
801047fc:	66 90                	xchg   %ax,%ax
801047fe:	66 90                	xchg   %ax,%ax

80104800 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	8b 55 08             	mov    0x8(%ebp),%edx
80104807:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010480a:	53                   	push   %ebx
8010480b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010480e:	89 d7                	mov    %edx,%edi
80104810:	09 cf                	or     %ecx,%edi
80104812:	83 e7 03             	and    $0x3,%edi
80104815:	75 29                	jne    80104840 <memset+0x40>
    c &= 0xFF;
80104817:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010481a:	c1 e0 18             	shl    $0x18,%eax
8010481d:	89 fb                	mov    %edi,%ebx
8010481f:	c1 e9 02             	shr    $0x2,%ecx
80104822:	c1 e3 10             	shl    $0x10,%ebx
80104825:	09 d8                	or     %ebx,%eax
80104827:	09 f8                	or     %edi,%eax
80104829:	c1 e7 08             	shl    $0x8,%edi
8010482c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010482e:	89 d7                	mov    %edx,%edi
80104830:	fc                   	cld    
80104831:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104833:	5b                   	pop    %ebx
80104834:	89 d0                	mov    %edx,%eax
80104836:	5f                   	pop    %edi
80104837:	5d                   	pop    %ebp
80104838:	c3                   	ret    
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104840:	89 d7                	mov    %edx,%edi
80104842:	fc                   	cld    
80104843:	f3 aa                	rep stos %al,%es:(%edi)
80104845:	5b                   	pop    %ebx
80104846:	89 d0                	mov    %edx,%eax
80104848:	5f                   	pop    %edi
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop

80104850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	8b 75 10             	mov    0x10(%ebp),%esi
80104857:	8b 55 08             	mov    0x8(%ebp),%edx
8010485a:	53                   	push   %ebx
8010485b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010485e:	85 f6                	test   %esi,%esi
80104860:	74 2e                	je     80104890 <memcmp+0x40>
80104862:	01 c6                	add    %eax,%esi
80104864:	eb 14                	jmp    8010487a <memcmp+0x2a>
80104866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104870:	83 c0 01             	add    $0x1,%eax
80104873:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104876:	39 f0                	cmp    %esi,%eax
80104878:	74 16                	je     80104890 <memcmp+0x40>
    if(*s1 != *s2)
8010487a:	0f b6 0a             	movzbl (%edx),%ecx
8010487d:	0f b6 18             	movzbl (%eax),%ebx
80104880:	38 d9                	cmp    %bl,%cl
80104882:	74 ec                	je     80104870 <memcmp+0x20>
      return *s1 - *s2;
80104884:	0f b6 c1             	movzbl %cl,%eax
80104887:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
80104890:	5b                   	pop    %ebx
  return 0;
80104891:	31 c0                	xor    %eax,%eax
}
80104893:	5e                   	pop    %esi
80104894:	5d                   	pop    %ebp
80104895:	c3                   	ret    
80104896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	8b 55 08             	mov    0x8(%ebp),%edx
801048a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048aa:	56                   	push   %esi
801048ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048ae:	39 d6                	cmp    %edx,%esi
801048b0:	73 26                	jae    801048d8 <memmove+0x38>
801048b2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801048b5:	39 fa                	cmp    %edi,%edx
801048b7:	73 1f                	jae    801048d8 <memmove+0x38>
801048b9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801048bc:	85 c9                	test   %ecx,%ecx
801048be:	74 0c                	je     801048cc <memmove+0x2c>
      *--d = *--s;
801048c0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048c4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048c7:	83 e8 01             	sub    $0x1,%eax
801048ca:	73 f4                	jae    801048c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048cc:	5e                   	pop    %esi
801048cd:	89 d0                	mov    %edx,%eax
801048cf:	5f                   	pop    %edi
801048d0:	5d                   	pop    %ebp
801048d1:	c3                   	ret    
801048d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048d8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801048db:	89 d7                	mov    %edx,%edi
801048dd:	85 c9                	test   %ecx,%ecx
801048df:	74 eb                	je     801048cc <memmove+0x2c>
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048e9:	39 c6                	cmp    %eax,%esi
801048eb:	75 fb                	jne    801048e8 <memmove+0x48>
}
801048ed:	5e                   	pop    %esi
801048ee:	89 d0                	mov    %edx,%eax
801048f0:	5f                   	pop    %edi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104900:	eb 9e                	jmp    801048a0 <memmove>
80104902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104910 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	56                   	push   %esi
80104914:	8b 75 10             	mov    0x10(%ebp),%esi
80104917:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010491a:	53                   	push   %ebx
8010491b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010491e:	85 f6                	test   %esi,%esi
80104920:	74 2e                	je     80104950 <strncmp+0x40>
80104922:	01 d6                	add    %edx,%esi
80104924:	eb 18                	jmp    8010493e <strncmp+0x2e>
80104926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	38 d8                	cmp    %bl,%al
80104932:	75 14                	jne    80104948 <strncmp+0x38>
    n--, p++, q++;
80104934:	83 c2 01             	add    $0x1,%edx
80104937:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010493a:	39 f2                	cmp    %esi,%edx
8010493c:	74 12                	je     80104950 <strncmp+0x40>
8010493e:	0f b6 01             	movzbl (%ecx),%eax
80104941:	0f b6 1a             	movzbl (%edx),%ebx
80104944:	84 c0                	test   %al,%al
80104946:	75 e8                	jne    80104930 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104948:	29 d8                	sub    %ebx,%eax
}
8010494a:	5b                   	pop    %ebx
8010494b:	5e                   	pop    %esi
8010494c:	5d                   	pop    %ebp
8010494d:	c3                   	ret    
8010494e:	66 90                	xchg   %ax,%ax
80104950:	5b                   	pop    %ebx
    return 0;
80104951:	31 c0                	xor    %eax,%eax
}
80104953:	5e                   	pop    %esi
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	8b 75 08             	mov    0x8(%ebp),%esi
80104968:	53                   	push   %ebx
80104969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010496c:	89 f0                	mov    %esi,%eax
8010496e:	eb 15                	jmp    80104985 <strncpy+0x25>
80104970:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104974:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104977:	83 c0 01             	add    $0x1,%eax
8010497a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010497e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104981:	84 d2                	test   %dl,%dl
80104983:	74 09                	je     8010498e <strncpy+0x2e>
80104985:	89 cb                	mov    %ecx,%ebx
80104987:	83 e9 01             	sub    $0x1,%ecx
8010498a:	85 db                	test   %ebx,%ebx
8010498c:	7f e2                	jg     80104970 <strncpy+0x10>
    ;
  while(n-- > 0)
8010498e:	89 c2                	mov    %eax,%edx
80104990:	85 c9                	test   %ecx,%ecx
80104992:	7e 17                	jle    801049ab <strncpy+0x4b>
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104998:	83 c2 01             	add    $0x1,%edx
8010499b:	89 c1                	mov    %eax,%ecx
8010499d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801049a1:	29 d1                	sub    %edx,%ecx
801049a3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801049a7:	85 c9                	test   %ecx,%ecx
801049a9:	7f ed                	jg     80104998 <strncpy+0x38>
  return os;
}
801049ab:	5b                   	pop    %ebx
801049ac:	89 f0                	mov    %esi,%eax
801049ae:	5e                   	pop    %esi
801049af:	5f                   	pop    %edi
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	8b 55 10             	mov    0x10(%ebp),%edx
801049c7:	8b 75 08             	mov    0x8(%ebp),%esi
801049ca:	53                   	push   %ebx
801049cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049ce:	85 d2                	test   %edx,%edx
801049d0:	7e 25                	jle    801049f7 <safestrcpy+0x37>
801049d2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049d6:	89 f2                	mov    %esi,%edx
801049d8:	eb 16                	jmp    801049f0 <safestrcpy+0x30>
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049e0:	0f b6 08             	movzbl (%eax),%ecx
801049e3:	83 c0 01             	add    $0x1,%eax
801049e6:	83 c2 01             	add    $0x1,%edx
801049e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049ec:	84 c9                	test   %cl,%cl
801049ee:	74 04                	je     801049f4 <safestrcpy+0x34>
801049f0:	39 d8                	cmp    %ebx,%eax
801049f2:	75 ec                	jne    801049e0 <safestrcpy+0x20>
    ;
  *s = 0;
801049f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801049f7:	89 f0                	mov    %esi,%eax
801049f9:	5b                   	pop    %ebx
801049fa:	5e                   	pop    %esi
801049fb:	5d                   	pop    %ebp
801049fc:	c3                   	ret    
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <strlen>:

int
strlen(const char *s)
{
80104a00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a01:	31 c0                	xor    %eax,%eax
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a08:	80 3a 00             	cmpb   $0x0,(%edx)
80104a0b:	74 0c                	je     80104a19 <strlen+0x19>
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
80104a10:	83 c0 01             	add    $0x1,%eax
80104a13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a17:	75 f7                	jne    80104a10 <strlen+0x10>
    ;
  return n;
}
80104a19:	5d                   	pop    %ebp
80104a1a:	c3                   	ret    

80104a1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a23:	55                   	push   %ebp
  pushl %ebx
80104a24:	53                   	push   %ebx
  pushl %esi
80104a25:	56                   	push   %esi
  pushl %edi
80104a26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a2b:	5f                   	pop    %edi
  popl %esi
80104a2c:	5e                   	pop    %esi
  popl %ebx
80104a2d:	5b                   	pop    %ebx
  popl %ebp
80104a2e:	5d                   	pop    %ebp
  ret
80104a2f:	c3                   	ret    

80104a30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 04             	sub    $0x4,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a3a:	e8 31 ef ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a3f:	8b 00                	mov    (%eax),%eax
80104a41:	39 d8                	cmp    %ebx,%eax
80104a43:	76 1b                	jbe    80104a60 <fetchint+0x30>
80104a45:	8d 53 04             	lea    0x4(%ebx),%edx
80104a48:	39 d0                	cmp    %edx,%eax
80104a4a:	72 14                	jb     80104a60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a4f:	8b 13                	mov    (%ebx),%edx
80104a51:	89 10                	mov    %edx,(%eax)
  return 0;
80104a53:	31 c0                	xor    %eax,%eax
}
80104a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a58:	c9                   	leave  
80104a59:	c3                   	ret    
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a65:	eb ee                	jmp    80104a55 <fetchint+0x25>
80104a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 04             	sub    $0x4,%esp
80104a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a7a:	e8 f1 ee ff ff       	call   80103970 <myproc>

  if(addr >= curproc->sz)
80104a7f:	39 18                	cmp    %ebx,(%eax)
80104a81:	76 2d                	jbe    80104ab0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a86:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a88:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a8a:	39 d3                	cmp    %edx,%ebx
80104a8c:	73 22                	jae    80104ab0 <fetchstr+0x40>
80104a8e:	89 d8                	mov    %ebx,%eax
80104a90:	eb 0d                	jmp    80104a9f <fetchstr+0x2f>
80104a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a98:	83 c0 01             	add    $0x1,%eax
80104a9b:	39 c2                	cmp    %eax,%edx
80104a9d:	76 11                	jbe    80104ab0 <fetchstr+0x40>
    if(*s == 0)
80104a9f:	80 38 00             	cmpb   $0x0,(%eax)
80104aa2:	75 f4                	jne    80104a98 <fetchstr+0x28>
      return s - *pp;
80104aa4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa9:	c9                   	leave  
80104aaa:	c3                   	ret    
80104aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop
80104ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ab8:	c9                   	leave  
80104ab9:	c3                   	ret    
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac5:	e8 a6 ee ff ff       	call   80103970 <myproc>
80104aca:	8b 55 08             	mov    0x8(%ebp),%edx
80104acd:	8b 40 18             	mov    0x18(%eax),%eax
80104ad0:	8b 40 44             	mov    0x44(%eax),%eax
80104ad3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ad6:	e8 95 ee ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104adb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ade:	8b 00                	mov    (%eax),%eax
80104ae0:	39 c6                	cmp    %eax,%esi
80104ae2:	73 1c                	jae    80104b00 <argint+0x40>
80104ae4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ae7:	39 d0                	cmp    %edx,%eax
80104ae9:	72 15                	jb     80104b00 <argint+0x40>
  *ip = *(int*)(addr);
80104aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aee:	8b 53 04             	mov    0x4(%ebx),%edx
80104af1:	89 10                	mov    %edx,(%eax)
  return 0;
80104af3:	31 c0                	xor    %eax,%eax
}
80104af5:	5b                   	pop    %ebx
80104af6:	5e                   	pop    %esi
80104af7:	5d                   	pop    %ebp
80104af8:	c3                   	ret    
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b05:	eb ee                	jmp    80104af5 <argint+0x35>
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	53                   	push   %ebx
80104b16:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b19:	e8 52 ee ff ff       	call   80103970 <myproc>
80104b1e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b20:	e8 4b ee ff ff       	call   80103970 <myproc>
80104b25:	8b 55 08             	mov    0x8(%ebp),%edx
80104b28:	8b 40 18             	mov    0x18(%eax),%eax
80104b2b:	8b 40 44             	mov    0x44(%eax),%eax
80104b2e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b31:	e8 3a ee ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b36:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b39:	8b 00                	mov    (%eax),%eax
80104b3b:	39 c7                	cmp    %eax,%edi
80104b3d:	73 31                	jae    80104b70 <argptr+0x60>
80104b3f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b42:	39 c8                	cmp    %ecx,%eax
80104b44:	72 2a                	jb     80104b70 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b46:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b49:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b4c:	85 d2                	test   %edx,%edx
80104b4e:	78 20                	js     80104b70 <argptr+0x60>
80104b50:	8b 16                	mov    (%esi),%edx
80104b52:	39 c2                	cmp    %eax,%edx
80104b54:	76 1a                	jbe    80104b70 <argptr+0x60>
80104b56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b59:	01 c3                	add    %eax,%ebx
80104b5b:	39 da                	cmp    %ebx,%edx
80104b5d:	72 11                	jb     80104b70 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b62:	89 02                	mov    %eax,(%edx)
  return 0;
80104b64:	31 c0                	xor    %eax,%eax
}
80104b66:	83 c4 0c             	add    $0xc,%esp
80104b69:	5b                   	pop    %ebx
80104b6a:	5e                   	pop    %esi
80104b6b:	5f                   	pop    %edi
80104b6c:	5d                   	pop    %ebp
80104b6d:	c3                   	ret    
80104b6e:	66 90                	xchg   %ax,%ax
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b75:	eb ef                	jmp    80104b66 <argptr+0x56>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b85:	e8 e6 ed ff ff       	call   80103970 <myproc>
80104b8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b8d:	8b 40 18             	mov    0x18(%eax),%eax
80104b90:	8b 40 44             	mov    0x44(%eax),%eax
80104b93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b96:	e8 d5 ed ff ff       	call   80103970 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9e:	8b 00                	mov    (%eax),%eax
80104ba0:	39 c6                	cmp    %eax,%esi
80104ba2:	73 44                	jae    80104be8 <argstr+0x68>
80104ba4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ba7:	39 d0                	cmp    %edx,%eax
80104ba9:	72 3d                	jb     80104be8 <argstr+0x68>
  *ip = *(int*)(addr);
80104bab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bae:	e8 bd ed ff ff       	call   80103970 <myproc>
  if(addr >= curproc->sz)
80104bb3:	3b 18                	cmp    (%eax),%ebx
80104bb5:	73 31                	jae    80104be8 <argstr+0x68>
  *pp = (char*)addr;
80104bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bbc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bbe:	39 d3                	cmp    %edx,%ebx
80104bc0:	73 26                	jae    80104be8 <argstr+0x68>
80104bc2:	89 d8                	mov    %ebx,%eax
80104bc4:	eb 11                	jmp    80104bd7 <argstr+0x57>
80104bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
80104bd0:	83 c0 01             	add    $0x1,%eax
80104bd3:	39 c2                	cmp    %eax,%edx
80104bd5:	76 11                	jbe    80104be8 <argstr+0x68>
    if(*s == 0)
80104bd7:	80 38 00             	cmpb   $0x0,(%eax)
80104bda:	75 f4                	jne    80104bd0 <argstr+0x50>
      return s - *pp;
80104bdc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bde:	5b                   	pop    %ebx
80104bdf:	5e                   	pop    %esi
80104be0:	5d                   	pop    %ebp
80104be1:	c3                   	ret    
80104be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be8:	5b                   	pop    %ebx
    return -1;
80104be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bee:	5e                   	pop    %esi
80104bef:	5d                   	pop    %ebp
80104bf0:	c3                   	ret    
80104bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bff:	90                   	nop

80104c00 <syscall>:

};

void
syscall(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c07:	e8 64 ed ff ff       	call   80103970 <myproc>
80104c0c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c0e:	8b 40 18             	mov    0x18(%eax),%eax
80104c11:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c14:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c17:	83 fa 17             	cmp    $0x17,%edx
80104c1a:	77 24                	ja     80104c40 <syscall+0x40>
80104c1c:	8b 14 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%edx
80104c23:	85 d2                	test   %edx,%edx
80104c25:	74 19                	je     80104c40 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c27:	ff d2                	call   *%edx
80104c29:	89 c2                	mov    %eax,%edx
80104c2b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c2e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c34:	c9                   	leave  
80104c35:	c3                   	ret    
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c40:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c41:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c44:	50                   	push   %eax
80104c45:	ff 73 10             	push   0x10(%ebx)
80104c48:	68 9d 7a 10 80       	push   $0x80107a9d
80104c4d:	e8 4e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c52:	8b 43 18             	mov    0x18(%ebx),%eax
80104c55:	83 c4 10             	add    $0x10,%esp
80104c58:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c62:	c9                   	leave  
80104c63:	c3                   	ret    
80104c64:	66 90                	xchg   %ax,%ax
80104c66:	66 90                	xchg   %ax,%ax
80104c68:	66 90                	xchg   %ax,%ax
80104c6a:	66 90                	xchg   %ax,%ax
80104c6c:	66 90                	xchg   %ax,%ax
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c75:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c78:	53                   	push   %ebx
80104c79:	83 ec 34             	sub    $0x34,%esp
80104c7c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c82:	57                   	push   %edi
80104c83:	50                   	push   %eax
{
80104c84:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c87:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c8a:	e8 31 d4 ff ff       	call   801020c0 <nameiparent>
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	85 c0                	test   %eax,%eax
80104c94:	0f 84 46 01 00 00    	je     80104de0 <create+0x170>
    return 0;
  ilock(dp);
80104c9a:	83 ec 0c             	sub    $0xc,%esp
80104c9d:	89 c3                	mov    %eax,%ebx
80104c9f:	50                   	push   %eax
80104ca0:	e8 db ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ca5:	83 c4 0c             	add    $0xc,%esp
80104ca8:	6a 00                	push   $0x0
80104caa:	57                   	push   %edi
80104cab:	53                   	push   %ebx
80104cac:	e8 2f d0 ff ff       	call   80101ce0 <dirlookup>
80104cb1:	83 c4 10             	add    $0x10,%esp
80104cb4:	89 c6                	mov    %eax,%esi
80104cb6:	85 c0                	test   %eax,%eax
80104cb8:	74 56                	je     80104d10 <create+0xa0>
    iunlockput(dp);
80104cba:	83 ec 0c             	sub    $0xc,%esp
80104cbd:	53                   	push   %ebx
80104cbe:	e8 4d cd ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104cc3:	89 34 24             	mov    %esi,(%esp)
80104cc6:	e8 b5 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ccb:	83 c4 10             	add    $0x10,%esp
80104cce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cd3:	75 1b                	jne    80104cf0 <create+0x80>
80104cd5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cda:	75 14                	jne    80104cf0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cdf:	89 f0                	mov    %esi,%eax
80104ce1:	5b                   	pop    %ebx
80104ce2:	5e                   	pop    %esi
80104ce3:	5f                   	pop    %edi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret    
80104ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ced:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104cf0:	83 ec 0c             	sub    $0xc,%esp
80104cf3:	56                   	push   %esi
    return 0;
80104cf4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104cf6:	e8 15 cd ff ff       	call   80101a10 <iunlockput>
    return 0;
80104cfb:	83 c4 10             	add    $0x10,%esp
}
80104cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d01:	89 f0                	mov    %esi,%eax
80104d03:	5b                   	pop    %ebx
80104d04:	5e                   	pop    %esi
80104d05:	5f                   	pop    %edi
80104d06:	5d                   	pop    %ebp
80104d07:	c3                   	ret    
80104d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d14:	83 ec 08             	sub    $0x8,%esp
80104d17:	50                   	push   %eax
80104d18:	ff 33                	push   (%ebx)
80104d1a:	e8 f1 c8 ff ff       	call   80101610 <ialloc>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	89 c6                	mov    %eax,%esi
80104d24:	85 c0                	test   %eax,%eax
80104d26:	0f 84 cd 00 00 00    	je     80104df9 <create+0x189>
  ilock(ip);
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	50                   	push   %eax
80104d30:	e8 4b ca ff ff       	call   80101780 <ilock>
  ip->major = major;
80104d35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d45:	b8 01 00 00 00       	mov    $0x1,%eax
80104d4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d4e:	89 34 24             	mov    %esi,(%esp)
80104d51:	e8 7a c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d5e:	74 30                	je     80104d90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d60:	83 ec 04             	sub    $0x4,%esp
80104d63:	ff 76 04             	push   0x4(%esi)
80104d66:	57                   	push   %edi
80104d67:	53                   	push   %ebx
80104d68:	e8 73 d2 ff ff       	call   80101fe0 <dirlink>
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 78                	js     80104dec <create+0x17c>
  iunlockput(dp);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	53                   	push   %ebx
80104d78:	e8 93 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104d7d:	83 c4 10             	add    $0x10,%esp
}
80104d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d83:	89 f0                	mov    %esi,%eax
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5f                   	pop    %edi
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret    
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d98:	53                   	push   %ebx
80104d99:	e8 32 c9 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d9e:	83 c4 0c             	add    $0xc,%esp
80104da1:	ff 76 04             	push   0x4(%esi)
80104da4:	68 40 7b 10 80       	push   $0x80107b40
80104da9:	56                   	push   %esi
80104daa:	e8 31 d2 ff ff       	call   80101fe0 <dirlink>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	78 18                	js     80104dce <create+0x15e>
80104db6:	83 ec 04             	sub    $0x4,%esp
80104db9:	ff 73 04             	push   0x4(%ebx)
80104dbc:	68 3f 7b 10 80       	push   $0x80107b3f
80104dc1:	56                   	push   %esi
80104dc2:	e8 19 d2 ff ff       	call   80101fe0 <dirlink>
80104dc7:	83 c4 10             	add    $0x10,%esp
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	79 92                	jns    80104d60 <create+0xf0>
      panic("create dots");
80104dce:	83 ec 0c             	sub    $0xc,%esp
80104dd1:	68 33 7b 10 80       	push   $0x80107b33
80104dd6:	e8 a5 b5 ff ff       	call   80100380 <panic>
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop
}
80104de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104de3:	31 f6                	xor    %esi,%esi
}
80104de5:	5b                   	pop    %ebx
80104de6:	89 f0                	mov    %esi,%eax
80104de8:	5e                   	pop    %esi
80104de9:	5f                   	pop    %edi
80104dea:	5d                   	pop    %ebp
80104deb:	c3                   	ret    
    panic("create: dirlink");
80104dec:	83 ec 0c             	sub    $0xc,%esp
80104def:	68 42 7b 10 80       	push   $0x80107b42
80104df4:	e8 87 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104df9:	83 ec 0c             	sub    $0xc,%esp
80104dfc:	68 24 7b 10 80       	push   $0x80107b24
80104e01:	e8 7a b5 ff ff       	call   80100380 <panic>
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi

80104e10 <sys_dup>:
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e15:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e18:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e1b:	50                   	push   %eax
80104e1c:	6a 00                	push   $0x0
80104e1e:	e8 9d fc ff ff       	call   80104ac0 <argint>
80104e23:	83 c4 10             	add    $0x10,%esp
80104e26:	85 c0                	test   %eax,%eax
80104e28:	78 36                	js     80104e60 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e2e:	77 30                	ja     80104e60 <sys_dup+0x50>
80104e30:	e8 3b eb ff ff       	call   80103970 <myproc>
80104e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e38:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e3c:	85 f6                	test   %esi,%esi
80104e3e:	74 20                	je     80104e60 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e40:	e8 2b eb ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e45:	31 db                	xor    %ebx,%ebx
80104e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104e50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e54:	85 d2                	test   %edx,%edx
80104e56:	74 18                	je     80104e70 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e58:	83 c3 01             	add    $0x1,%ebx
80104e5b:	83 fb 10             	cmp    $0x10,%ebx
80104e5e:	75 f0                	jne    80104e50 <sys_dup+0x40>
}
80104e60:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e68:	89 d8                	mov    %ebx,%eax
80104e6a:	5b                   	pop    %ebx
80104e6b:	5e                   	pop    %esi
80104e6c:	5d                   	pop    %ebp
80104e6d:	c3                   	ret    
80104e6e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e70:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e73:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e77:	56                   	push   %esi
80104e78:	e8 23 c0 ff ff       	call   80100ea0 <filedup>
  return fd;
80104e7d:	83 c4 10             	add    $0x10,%esp
}
80104e80:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e83:	89 d8                	mov    %ebx,%eax
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e90 <sys_read>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e9b:	53                   	push   %ebx
80104e9c:	6a 00                	push   $0x0
80104e9e:	e8 1d fc ff ff       	call   80104ac0 <argint>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	78 5e                	js     80104f08 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eae:	77 58                	ja     80104f08 <sys_read+0x78>
80104eb0:	e8 bb ea ff ff       	call   80103970 <myproc>
80104eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eb8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ebc:	85 f6                	test   %esi,%esi
80104ebe:	74 48                	je     80104f08 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec0:	83 ec 08             	sub    $0x8,%esp
80104ec3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ec6:	50                   	push   %eax
80104ec7:	6a 02                	push   $0x2
80104ec9:	e8 f2 fb ff ff       	call   80104ac0 <argint>
80104ece:	83 c4 10             	add    $0x10,%esp
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 33                	js     80104f08 <sys_read+0x78>
80104ed5:	83 ec 04             	sub    $0x4,%esp
80104ed8:	ff 75 f0             	push   -0x10(%ebp)
80104edb:	53                   	push   %ebx
80104edc:	6a 01                	push   $0x1
80104ede:	e8 2d fc ff ff       	call   80104b10 <argptr>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 1e                	js     80104f08 <sys_read+0x78>
  return fileread(f, p, n);
80104eea:	83 ec 04             	sub    $0x4,%esp
80104eed:	ff 75 f0             	push   -0x10(%ebp)
80104ef0:	ff 75 f4             	push   -0xc(%ebp)
80104ef3:	56                   	push   %esi
80104ef4:	e8 27 c1 ff ff       	call   80101020 <fileread>
80104ef9:	83 c4 10             	add    $0x10,%esp
}
80104efc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eff:	5b                   	pop    %ebx
80104f00:	5e                   	pop    %esi
80104f01:	5d                   	pop    %ebp
80104f02:	c3                   	ret    
80104f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f07:	90                   	nop
    return -1;
80104f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0d:	eb ed                	jmp    80104efc <sys_read+0x6c>
80104f0f:	90                   	nop

80104f10 <sys_write>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f15:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f18:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f1b:	53                   	push   %ebx
80104f1c:	6a 00                	push   $0x0
80104f1e:	e8 9d fb ff ff       	call   80104ac0 <argint>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	85 c0                	test   %eax,%eax
80104f28:	78 5e                	js     80104f88 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f2e:	77 58                	ja     80104f88 <sys_write+0x78>
80104f30:	e8 3b ea ff ff       	call   80103970 <myproc>
80104f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f38:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f3c:	85 f6                	test   %esi,%esi
80104f3e:	74 48                	je     80104f88 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f40:	83 ec 08             	sub    $0x8,%esp
80104f43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f46:	50                   	push   %eax
80104f47:	6a 02                	push   $0x2
80104f49:	e8 72 fb ff ff       	call   80104ac0 <argint>
80104f4e:	83 c4 10             	add    $0x10,%esp
80104f51:	85 c0                	test   %eax,%eax
80104f53:	78 33                	js     80104f88 <sys_write+0x78>
80104f55:	83 ec 04             	sub    $0x4,%esp
80104f58:	ff 75 f0             	push   -0x10(%ebp)
80104f5b:	53                   	push   %ebx
80104f5c:	6a 01                	push   $0x1
80104f5e:	e8 ad fb ff ff       	call   80104b10 <argptr>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 1e                	js     80104f88 <sys_write+0x78>
  return filewrite(f, p, n);
80104f6a:	83 ec 04             	sub    $0x4,%esp
80104f6d:	ff 75 f0             	push   -0x10(%ebp)
80104f70:	ff 75 f4             	push   -0xc(%ebp)
80104f73:	56                   	push   %esi
80104f74:	e8 37 c1 ff ff       	call   801010b0 <filewrite>
80104f79:	83 c4 10             	add    $0x10,%esp
}
80104f7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f7f:	5b                   	pop    %ebx
80104f80:	5e                   	pop    %esi
80104f81:	5d                   	pop    %ebp
80104f82:	c3                   	ret    
80104f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f87:	90                   	nop
    return -1;
80104f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8d:	eb ed                	jmp    80104f7c <sys_write+0x6c>
80104f8f:	90                   	nop

80104f90 <sys_close>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9b:	50                   	push   %eax
80104f9c:	6a 00                	push   $0x0
80104f9e:	e8 1d fb ff ff       	call   80104ac0 <argint>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 3e                	js     80104fe8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104faa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fae:	77 38                	ja     80104fe8 <sys_close+0x58>
80104fb0:	e8 bb e9 ff ff       	call   80103970 <myproc>
80104fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fb8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104fbb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104fbf:	85 f6                	test   %esi,%esi
80104fc1:	74 25                	je     80104fe8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104fc3:	e8 a8 e9 ff ff       	call   80103970 <myproc>
  fileclose(f);
80104fc8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104fcb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104fd2:	00 
  fileclose(f);
80104fd3:	56                   	push   %esi
80104fd4:	e8 17 bf ff ff       	call   80100ef0 <fileclose>
  return 0;
80104fd9:	83 c4 10             	add    $0x10,%esp
80104fdc:	31 c0                	xor    %eax,%eax
}
80104fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe1:	5b                   	pop    %ebx
80104fe2:	5e                   	pop    %esi
80104fe3:	5d                   	pop    %ebp
80104fe4:	c3                   	ret    
80104fe5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb ef                	jmp    80104fde <sys_close+0x4e>
80104fef:	90                   	nop

80104ff0 <sys_fstat>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 bd fa ff ff       	call   80104ac0 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 46                	js     80105050 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 40                	ja     80105050 <sys_fstat+0x60>
80105010:	e8 5b e9 ff ff       	call   80103970 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010501c:	85 f6                	test   %esi,%esi
8010501e:	74 30                	je     80105050 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105020:	83 ec 04             	sub    $0x4,%esp
80105023:	6a 14                	push   $0x14
80105025:	53                   	push   %ebx
80105026:	6a 01                	push   $0x1
80105028:	e8 e3 fa ff ff       	call   80104b10 <argptr>
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	85 c0                	test   %eax,%eax
80105032:	78 1c                	js     80105050 <sys_fstat+0x60>
  return filestat(f, st);
80105034:	83 ec 08             	sub    $0x8,%esp
80105037:	ff 75 f4             	push   -0xc(%ebp)
8010503a:	56                   	push   %esi
8010503b:	e8 90 bf ff ff       	call   80100fd0 <filestat>
80105040:	83 c4 10             	add    $0x10,%esp
}
80105043:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105046:	5b                   	pop    %ebx
80105047:	5e                   	pop    %esi
80105048:	5d                   	pop    %ebp
80105049:	c3                   	ret    
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105055:	eb ec                	jmp    80105043 <sys_fstat+0x53>
80105057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505e:	66 90                	xchg   %ax,%ax

80105060 <sys_link>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105065:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105068:	53                   	push   %ebx
80105069:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 0c fb ff ff       	call   80104b80 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 fb 00 00 00    	js     8010517a <sys_link+0x11a>
8010507f:	83 ec 08             	sub    $0x8,%esp
80105082:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105085:	50                   	push   %eax
80105086:	6a 01                	push   $0x1
80105088:	e8 f3 fa ff ff       	call   80104b80 <argstr>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	0f 88 e2 00 00 00    	js     8010517a <sys_link+0x11a>
  begin_op();
80105098:	e8 c3 dc ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
8010509d:	83 ec 0c             	sub    $0xc,%esp
801050a0:	ff 75 d4             	push   -0x2c(%ebp)
801050a3:	e8 f8 cf ff ff       	call   801020a0 <namei>
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	89 c3                	mov    %eax,%ebx
801050ad:	85 c0                	test   %eax,%eax
801050af:	0f 84 e4 00 00 00    	je     80105199 <sys_link+0x139>
  ilock(ip);
801050b5:	83 ec 0c             	sub    $0xc,%esp
801050b8:	50                   	push   %eax
801050b9:	e8 c2 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050c6:	0f 84 b5 00 00 00    	je     80105181 <sys_link+0x121>
  iupdate(ip);
801050cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050d7:	53                   	push   %ebx
801050d8:	e8 f3 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801050dd:	89 1c 24             	mov    %ebx,(%esp)
801050e0:	e8 7b c7 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050e5:	58                   	pop    %eax
801050e6:	5a                   	pop    %edx
801050e7:	57                   	push   %edi
801050e8:	ff 75 d0             	push   -0x30(%ebp)
801050eb:	e8 d0 cf ff ff       	call   801020c0 <nameiparent>
801050f0:	83 c4 10             	add    $0x10,%esp
801050f3:	89 c6                	mov    %eax,%esi
801050f5:	85 c0                	test   %eax,%eax
801050f7:	74 5b                	je     80105154 <sys_link+0xf4>
  ilock(dp);
801050f9:	83 ec 0c             	sub    $0xc,%esp
801050fc:	50                   	push   %eax
801050fd:	e8 7e c6 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105102:	8b 03                	mov    (%ebx),%eax
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	39 06                	cmp    %eax,(%esi)
80105109:	75 3d                	jne    80105148 <sys_link+0xe8>
8010510b:	83 ec 04             	sub    $0x4,%esp
8010510e:	ff 73 04             	push   0x4(%ebx)
80105111:	57                   	push   %edi
80105112:	56                   	push   %esi
80105113:	e8 c8 ce ff ff       	call   80101fe0 <dirlink>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	85 c0                	test   %eax,%eax
8010511d:	78 29                	js     80105148 <sys_link+0xe8>
  iunlockput(dp);
8010511f:	83 ec 0c             	sub    $0xc,%esp
80105122:	56                   	push   %esi
80105123:	e8 e8 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105128:	89 1c 24             	mov    %ebx,(%esp)
8010512b:	e8 80 c7 ff ff       	call   801018b0 <iput>
  end_op();
80105130:	e8 9b dc ff ff       	call   80102dd0 <end_op>
  return 0;
80105135:	83 c4 10             	add    $0x10,%esp
80105138:	31 c0                	xor    %eax,%eax
}
8010513a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010513d:	5b                   	pop    %ebx
8010513e:	5e                   	pop    %esi
8010513f:	5f                   	pop    %edi
80105140:	5d                   	pop    %ebp
80105141:	c3                   	ret    
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105148:	83 ec 0c             	sub    $0xc,%esp
8010514b:	56                   	push   %esi
8010514c:	e8 bf c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105151:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	53                   	push   %ebx
80105158:	e8 23 c6 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010515d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105162:	89 1c 24             	mov    %ebx,(%esp)
80105165:	e8 66 c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010516a:	89 1c 24             	mov    %ebx,(%esp)
8010516d:	e8 9e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105172:	e8 59 dc ff ff       	call   80102dd0 <end_op>
  return -1;
80105177:	83 c4 10             	add    $0x10,%esp
8010517a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517f:	eb b9                	jmp    8010513a <sys_link+0xda>
    iunlockput(ip);
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	53                   	push   %ebx
80105185:	e8 86 c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010518a:	e8 41 dc ff ff       	call   80102dd0 <end_op>
    return -1;
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105197:	eb a1                	jmp    8010513a <sys_link+0xda>
    end_op();
80105199:	e8 32 dc ff ff       	call   80102dd0 <end_op>
    return -1;
8010519e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a3:	eb 95                	jmp    8010513a <sys_link+0xda>
801051a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051b0 <sys_unlink>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051b8:	53                   	push   %ebx
801051b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051bc:	50                   	push   %eax
801051bd:	6a 00                	push   $0x0
801051bf:	e8 bc f9 ff ff       	call   80104b80 <argstr>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	0f 88 7a 01 00 00    	js     80105349 <sys_unlink+0x199>
  begin_op();
801051cf:	e8 8c db ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051d7:	83 ec 08             	sub    $0x8,%esp
801051da:	53                   	push   %ebx
801051db:	ff 75 c0             	push   -0x40(%ebp)
801051de:	e8 dd ce ff ff       	call   801020c0 <nameiparent>
801051e3:	83 c4 10             	add    $0x10,%esp
801051e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801051e9:	85 c0                	test   %eax,%eax
801051eb:	0f 84 62 01 00 00    	je     80105353 <sys_unlink+0x1a3>
  ilock(dp);
801051f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	57                   	push   %edi
801051f8:	e8 83 c5 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051fd:	58                   	pop    %eax
801051fe:	5a                   	pop    %edx
801051ff:	68 40 7b 10 80       	push   $0x80107b40
80105204:	53                   	push   %ebx
80105205:	e8 b6 ca ff ff       	call   80101cc0 <namecmp>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	0f 84 fb 00 00 00    	je     80105310 <sys_unlink+0x160>
80105215:	83 ec 08             	sub    $0x8,%esp
80105218:	68 3f 7b 10 80       	push   $0x80107b3f
8010521d:	53                   	push   %ebx
8010521e:	e8 9d ca ff ff       	call   80101cc0 <namecmp>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	0f 84 e2 00 00 00    	je     80105310 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010522e:	83 ec 04             	sub    $0x4,%esp
80105231:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105234:	50                   	push   %eax
80105235:	53                   	push   %ebx
80105236:	57                   	push   %edi
80105237:	e8 a4 ca ff ff       	call   80101ce0 <dirlookup>
8010523c:	83 c4 10             	add    $0x10,%esp
8010523f:	89 c3                	mov    %eax,%ebx
80105241:	85 c0                	test   %eax,%eax
80105243:	0f 84 c7 00 00 00    	je     80105310 <sys_unlink+0x160>
  ilock(ip);
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	50                   	push   %eax
8010524d:	e8 2e c5 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010525a:	0f 8e 1c 01 00 00    	jle    8010537c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105260:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105265:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105268:	74 66                	je     801052d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010526a:	83 ec 04             	sub    $0x4,%esp
8010526d:	6a 10                	push   $0x10
8010526f:	6a 00                	push   $0x0
80105271:	57                   	push   %edi
80105272:	e8 89 f5 ff ff       	call   80104800 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105277:	6a 10                	push   $0x10
80105279:	ff 75 c4             	push   -0x3c(%ebp)
8010527c:	57                   	push   %edi
8010527d:	ff 75 b4             	push   -0x4c(%ebp)
80105280:	e8 0b c9 ff ff       	call   80101b90 <writei>
80105285:	83 c4 20             	add    $0x20,%esp
80105288:	83 f8 10             	cmp    $0x10,%eax
8010528b:	0f 85 de 00 00 00    	jne    8010536f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105291:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105296:	0f 84 94 00 00 00    	je     80105330 <sys_unlink+0x180>
  iunlockput(dp);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	ff 75 b4             	push   -0x4c(%ebp)
801052a2:	e8 69 c7 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801052a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052ac:	89 1c 24             	mov    %ebx,(%esp)
801052af:	e8 1c c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052b4:	89 1c 24             	mov    %ebx,(%esp)
801052b7:	e8 54 c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052bc:	e8 0f db ff ff       	call   80102dd0 <end_op>
  return 0;
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	31 c0                	xor    %eax,%eax
}
801052c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052c9:	5b                   	pop    %ebx
801052ca:	5e                   	pop    %esi
801052cb:	5f                   	pop    %edi
801052cc:	5d                   	pop    %ebp
801052cd:	c3                   	ret    
801052ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052d4:	76 94                	jbe    8010526a <sys_unlink+0xba>
801052d6:	be 20 00 00 00       	mov    $0x20,%esi
801052db:	eb 0b                	jmp    801052e8 <sys_unlink+0x138>
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
801052e0:	83 c6 10             	add    $0x10,%esi
801052e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801052e6:	73 82                	jae    8010526a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052e8:	6a 10                	push   $0x10
801052ea:	56                   	push   %esi
801052eb:	57                   	push   %edi
801052ec:	53                   	push   %ebx
801052ed:	e8 9e c7 ff ff       	call   80101a90 <readi>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	83 f8 10             	cmp    $0x10,%eax
801052f8:	75 68                	jne    80105362 <sys_unlink+0x1b2>
    if(de.inum != 0)
801052fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052ff:	74 df                	je     801052e0 <sys_unlink+0x130>
    iunlockput(ip);
80105301:	83 ec 0c             	sub    $0xc,%esp
80105304:	53                   	push   %ebx
80105305:	e8 06 c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105310:	83 ec 0c             	sub    $0xc,%esp
80105313:	ff 75 b4             	push   -0x4c(%ebp)
80105316:	e8 f5 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010531b:	e8 b0 da ff ff       	call   80102dd0 <end_op>
  return -1;
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105328:	eb 9c                	jmp    801052c6 <sys_unlink+0x116>
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105330:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105333:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105336:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010533b:	50                   	push   %eax
8010533c:	e8 8f c3 ff ff       	call   801016d0 <iupdate>
80105341:	83 c4 10             	add    $0x10,%esp
80105344:	e9 53 ff ff ff       	jmp    8010529c <sys_unlink+0xec>
    return -1;
80105349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534e:	e9 73 ff ff ff       	jmp    801052c6 <sys_unlink+0x116>
    end_op();
80105353:	e8 78 da ff ff       	call   80102dd0 <end_op>
    return -1;
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	e9 64 ff ff ff       	jmp    801052c6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105362:	83 ec 0c             	sub    $0xc,%esp
80105365:	68 64 7b 10 80       	push   $0x80107b64
8010536a:	e8 11 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	68 76 7b 10 80       	push   $0x80107b76
80105377:	e8 04 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	68 52 7b 10 80       	push   $0x80107b52
80105384:	e8 f7 af ff ff       	call   80100380 <panic>
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_open>:

int
sys_open(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105395:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105398:	53                   	push   %ebx
80105399:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 dc f7 ff ff       	call   80104b80 <argstr>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	0f 88 8e 00 00 00    	js     8010543d <sys_open+0xad>
801053af:	83 ec 08             	sub    $0x8,%esp
801053b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053b5:	50                   	push   %eax
801053b6:	6a 01                	push   $0x1
801053b8:	e8 03 f7 ff ff       	call   80104ac0 <argint>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 79                	js     8010543d <sys_open+0xad>
    return -1;

  begin_op();
801053c4:	e8 97 d9 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
801053c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053cd:	75 79                	jne    80105448 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	ff 75 e0             	push   -0x20(%ebp)
801053d5:	e8 c6 cc ff ff       	call   801020a0 <namei>
801053da:	83 c4 10             	add    $0x10,%esp
801053dd:	89 c6                	mov    %eax,%esi
801053df:	85 c0                	test   %eax,%eax
801053e1:	0f 84 7e 00 00 00    	je     80105465 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053e7:	83 ec 0c             	sub    $0xc,%esp
801053ea:	50                   	push   %eax
801053eb:	e8 90 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053f0:	83 c4 10             	add    $0x10,%esp
801053f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053f8:	0f 84 c2 00 00 00    	je     801054c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053fe:	e8 2d ba ff ff       	call   80100e30 <filealloc>
80105403:	89 c7                	mov    %eax,%edi
80105405:	85 c0                	test   %eax,%eax
80105407:	74 23                	je     8010542c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105409:	e8 62 e5 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010540e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105410:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105414:	85 d2                	test   %edx,%edx
80105416:	74 60                	je     80105478 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105418:	83 c3 01             	add    $0x1,%ebx
8010541b:	83 fb 10             	cmp    $0x10,%ebx
8010541e:	75 f0                	jne    80105410 <sys_open+0x80>
    if(f)
      fileclose(f);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	57                   	push   %edi
80105424:	e8 c7 ba ff ff       	call   80100ef0 <fileclose>
80105429:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	56                   	push   %esi
80105430:	e8 db c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105435:	e8 96 d9 ff ff       	call   80102dd0 <end_op>
    return -1;
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105442:	eb 6d                	jmp    801054b1 <sys_open+0x121>
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010544e:	31 c9                	xor    %ecx,%ecx
80105450:	ba 02 00 00 00       	mov    $0x2,%edx
80105455:	6a 00                	push   $0x0
80105457:	e8 14 f8 ff ff       	call   80104c70 <create>
    if(ip == 0){
8010545c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010545f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105461:	85 c0                	test   %eax,%eax
80105463:	75 99                	jne    801053fe <sys_open+0x6e>
      end_op();
80105465:	e8 66 d9 ff ff       	call   80102dd0 <end_op>
      return -1;
8010546a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010546f:	eb 40                	jmp    801054b1 <sys_open+0x121>
80105471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105478:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010547b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010547f:	56                   	push   %esi
80105480:	e8 db c3 ff ff       	call   80101860 <iunlock>
  end_op();
80105485:	e8 46 d9 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010548a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105490:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105493:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105496:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105499:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010549b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054a2:	f7 d0                	not    %eax
801054a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b4:	89 d8                	mov    %ebx,%eax
801054b6:	5b                   	pop    %ebx
801054b7:	5e                   	pop    %esi
801054b8:	5f                   	pop    %edi
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801054c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054c3:	85 c9                	test   %ecx,%ecx
801054c5:	0f 84 33 ff ff ff    	je     801053fe <sys_open+0x6e>
801054cb:	e9 5c ff ff ff       	jmp    8010542c <sys_open+0x9c>

801054d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054d6:	e8 85 d8 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054db:	83 ec 08             	sub    $0x8,%esp
801054de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e1:	50                   	push   %eax
801054e2:	6a 00                	push   $0x0
801054e4:	e8 97 f6 ff ff       	call   80104b80 <argstr>
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	85 c0                	test   %eax,%eax
801054ee:	78 30                	js     80105520 <sys_mkdir+0x50>
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f6:	31 c9                	xor    %ecx,%ecx
801054f8:	ba 01 00 00 00       	mov    $0x1,%edx
801054fd:	6a 00                	push   $0x0
801054ff:	e8 6c f7 ff ff       	call   80104c70 <create>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	74 15                	je     80105520 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010550b:	83 ec 0c             	sub    $0xc,%esp
8010550e:	50                   	push   %eax
8010550f:	e8 fc c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105514:	e8 b7 d8 ff ff       	call   80102dd0 <end_op>
  return 0;
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	31 c0                	xor    %eax,%eax
}
8010551e:	c9                   	leave  
8010551f:	c3                   	ret    
    end_op();
80105520:	e8 ab d8 ff ff       	call   80102dd0 <end_op>
    return -1;
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_mknod>:

int
sys_mknod(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105536:	e8 25 d8 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010553b:	83 ec 08             	sub    $0x8,%esp
8010553e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105541:	50                   	push   %eax
80105542:	6a 00                	push   $0x0
80105544:	e8 37 f6 ff ff       	call   80104b80 <argstr>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	85 c0                	test   %eax,%eax
8010554e:	78 60                	js     801055b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105550:	83 ec 08             	sub    $0x8,%esp
80105553:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105556:	50                   	push   %eax
80105557:	6a 01                	push   $0x1
80105559:	e8 62 f5 ff ff       	call   80104ac0 <argint>
  if((argstr(0, &path)) < 0 ||
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	85 c0                	test   %eax,%eax
80105563:	78 4b                	js     801055b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010556b:	50                   	push   %eax
8010556c:	6a 02                	push   $0x2
8010556e:	e8 4d f5 ff ff       	call   80104ac0 <argint>
     argint(1, &major) < 0 ||
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 36                	js     801055b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010557a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010557e:	83 ec 0c             	sub    $0xc,%esp
80105581:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105585:	ba 03 00 00 00       	mov    $0x3,%edx
8010558a:	50                   	push   %eax
8010558b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010558e:	e8 dd f6 ff ff       	call   80104c70 <create>
     argint(2, &minor) < 0 ||
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	74 16                	je     801055b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010559a:	83 ec 0c             	sub    $0xc,%esp
8010559d:	50                   	push   %eax
8010559e:	e8 6d c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055a3:	e8 28 d8 ff ff       	call   80102dd0 <end_op>
  return 0;
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	31 c0                	xor    %eax,%eax
}
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    
801055af:	90                   	nop
    end_op();
801055b0:	e8 1b d8 ff ff       	call   80102dd0 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ba:	c9                   	leave  
801055bb:	c3                   	ret    
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_chdir>:

int
sys_chdir(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	53                   	push   %ebx
801055c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055c8:	e8 a3 e3 ff ff       	call   80103970 <myproc>
801055cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055cf:	e8 8c d7 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055d4:	83 ec 08             	sub    $0x8,%esp
801055d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055da:	50                   	push   %eax
801055db:	6a 00                	push   $0x0
801055dd:	e8 9e f5 ff ff       	call   80104b80 <argstr>
801055e2:	83 c4 10             	add    $0x10,%esp
801055e5:	85 c0                	test   %eax,%eax
801055e7:	78 77                	js     80105660 <sys_chdir+0xa0>
801055e9:	83 ec 0c             	sub    $0xc,%esp
801055ec:	ff 75 f4             	push   -0xc(%ebp)
801055ef:	e8 ac ca ff ff       	call   801020a0 <namei>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	89 c3                	mov    %eax,%ebx
801055f9:	85 c0                	test   %eax,%eax
801055fb:	74 63                	je     80105660 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	50                   	push   %eax
80105601:	e8 7a c1 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010560e:	75 30                	jne    80105640 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	53                   	push   %ebx
80105614:	e8 47 c2 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105619:	58                   	pop    %eax
8010561a:	ff 76 68             	push   0x68(%esi)
8010561d:	e8 8e c2 ff ff       	call   801018b0 <iput>
  end_op();
80105622:	e8 a9 d7 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105627:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	31 c0                	xor    %eax,%eax
}
8010562f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105632:	5b                   	pop    %ebx
80105633:	5e                   	pop    %esi
80105634:	5d                   	pop    %ebp
80105635:	c3                   	ret    
80105636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	53                   	push   %ebx
80105644:	e8 c7 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105649:	e8 82 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105656:	eb d7                	jmp    8010562f <sys_chdir+0x6f>
80105658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
    end_op();
80105660:	e8 6b d7 ff ff       	call   80102dd0 <end_op>
    return -1;
80105665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566a:	eb c3                	jmp    8010562f <sys_chdir+0x6f>
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105670 <sys_exec>:

int
sys_exec(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	57                   	push   %edi
80105674:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105675:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010567b:	53                   	push   %ebx
8010567c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105682:	50                   	push   %eax
80105683:	6a 00                	push   $0x0
80105685:	e8 f6 f4 ff ff       	call   80104b80 <argstr>
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	85 c0                	test   %eax,%eax
8010568f:	0f 88 87 00 00 00    	js     8010571c <sys_exec+0xac>
80105695:	83 ec 08             	sub    $0x8,%esp
80105698:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010569e:	50                   	push   %eax
8010569f:	6a 01                	push   $0x1
801056a1:	e8 1a f4 ff ff       	call   80104ac0 <argint>
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	85 c0                	test   %eax,%eax
801056ab:	78 6f                	js     8010571c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056ad:	83 ec 04             	sub    $0x4,%esp
801056b0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056b8:	68 80 00 00 00       	push   $0x80
801056bd:	6a 00                	push   $0x0
801056bf:	56                   	push   %esi
801056c0:	e8 3b f1 ff ff       	call   80104800 <memset>
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056d9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801056e0:	50                   	push   %eax
801056e1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056e7:	01 f8                	add    %edi,%eax
801056e9:	50                   	push   %eax
801056ea:	e8 41 f3 ff ff       	call   80104a30 <fetchint>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	78 26                	js     8010571c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801056f6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056fc:	85 c0                	test   %eax,%eax
801056fe:	74 30                	je     80105730 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105700:	83 ec 08             	sub    $0x8,%esp
80105703:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105706:	52                   	push   %edx
80105707:	50                   	push   %eax
80105708:	e8 63 f3 ff ff       	call   80104a70 <fetchstr>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	78 08                	js     8010571c <sys_exec+0xac>
  for(i=0;; i++){
80105714:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105717:	83 fb 20             	cmp    $0x20,%ebx
8010571a:	75 b4                	jne    801056d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010571c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010571f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105724:	5b                   	pop    %ebx
80105725:	5e                   	pop    %esi
80105726:	5f                   	pop    %edi
80105727:	5d                   	pop    %ebp
80105728:	c3                   	ret    
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105730:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105737:	00 00 00 00 
  return exec(path, argv);
8010573b:	83 ec 08             	sub    $0x8,%esp
8010573e:	56                   	push   %esi
8010573f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105745:	e8 66 b3 ff ff       	call   80100ab0 <exec>
8010574a:	83 c4 10             	add    $0x10,%esp
}
8010574d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105750:	5b                   	pop    %ebx
80105751:	5e                   	pop    %esi
80105752:	5f                   	pop    %edi
80105753:	5d                   	pop    %ebp
80105754:	c3                   	ret    
80105755:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_pipe>:

int
sys_pipe(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105765:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105768:	53                   	push   %ebx
80105769:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010576c:	6a 08                	push   $0x8
8010576e:	50                   	push   %eax
8010576f:	6a 00                	push   $0x0
80105771:	e8 9a f3 ff ff       	call   80104b10 <argptr>
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 4a                	js     801057c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010577d:	83 ec 08             	sub    $0x8,%esp
80105780:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105783:	50                   	push   %eax
80105784:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105787:	50                   	push   %eax
80105788:	e8 a3 dc ff ff       	call   80103430 <pipealloc>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	78 33                	js     801057c7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105794:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105797:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105799:	e8 d2 e1 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010579e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801057a0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057a4:	85 f6                	test   %esi,%esi
801057a6:	74 28                	je     801057d0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801057a8:	83 c3 01             	add    $0x1,%ebx
801057ab:	83 fb 10             	cmp    $0x10,%ebx
801057ae:	75 f0                	jne    801057a0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	ff 75 e0             	push   -0x20(%ebp)
801057b6:	e8 35 b7 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801057bb:	58                   	pop    %eax
801057bc:	ff 75 e4             	push   -0x1c(%ebp)
801057bf:	e8 2c b7 ff ff       	call   80100ef0 <fileclose>
    return -1;
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057cc:	eb 53                	jmp    80105821 <sys_pipe+0xc1>
801057ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057d0:	8d 73 08             	lea    0x8(%ebx),%esi
801057d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057da:	e8 91 e1 ff ff       	call   80103970 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057df:	31 d2                	xor    %edx,%edx
801057e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057ec:	85 c9                	test   %ecx,%ecx
801057ee:	74 20                	je     80105810 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801057f0:	83 c2 01             	add    $0x1,%edx
801057f3:	83 fa 10             	cmp    $0x10,%edx
801057f6:	75 f0                	jne    801057e8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801057f8:	e8 73 e1 ff ff       	call   80103970 <myproc>
801057fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105804:	00 
80105805:	eb a9                	jmp    801057b0 <sys_pipe+0x50>
80105807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105810:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105814:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105817:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105819:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010581c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010581f:	31 c0                	xor    %eax,%eax
}
80105821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105824:	5b                   	pop    %ebx
80105825:	5e                   	pop    %esi
80105826:	5f                   	pop    %edi
80105827:	5d                   	pop    %ebp
80105828:	c3                   	ret    
80105829:	66 90                	xchg   %ax,%ax
8010582b:	66 90                	xchg   %ax,%ax
8010582d:	66 90                	xchg   %ax,%ax
8010582f:	90                   	nop

80105830 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105830:	e9 db e2 ff ff       	jmp    80103b10 <fork>
80105835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_exit>:
}

int
sys_exit(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 08             	sub    $0x8,%esp
  exit();
80105846:	e8 45 e5 ff ff       	call   80103d90 <exit>
  return 0;  // not reached
}
8010584b:	31 c0                	xor    %eax,%eax
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    
8010584f:	90                   	nop

80105850 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105850:	e9 6b e6 ff ff       	jmp    80103ec0 <wait>
80105855:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_kill>:
}

int
sys_kill(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105866:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105869:	50                   	push   %eax
8010586a:	6a 00                	push   $0x0
8010586c:	e8 4f f2 ff ff       	call   80104ac0 <argint>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	85 c0                	test   %eax,%eax
80105876:	78 18                	js     80105890 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	ff 75 f4             	push   -0xc(%ebp)
8010587e:	e8 dd e8 ff ff       	call   80104160 <kill>
80105883:	83 c4 10             	add    $0x10,%esp
}
80105886:	c9                   	leave  
80105887:	c3                   	ret    
80105888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
80105890:	c9                   	leave  
    return -1;
80105891:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105896:	c3                   	ret    
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_getpid>:

int
sys_getpid(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058a6:	e8 c5 e0 ff ff       	call   80103970 <myproc>
801058ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ae:	c9                   	leave  
801058af:	c3                   	ret    

801058b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ba:	50                   	push   %eax
801058bb:	6a 00                	push   $0x0
801058bd:	e8 fe f1 ff ff       	call   80104ac0 <argint>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	78 27                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058c9:	e8 a2 e0 ff ff       	call   80103970 <myproc>
  if(growproc(n) < 0)
801058ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058d3:	ff 75 f4             	push   -0xc(%ebp)
801058d6:	e8 b5 e1 ff ff       	call   80103a90 <growproc>
801058db:	83 c4 10             	add    $0x10,%esp
801058de:	85 c0                	test   %eax,%eax
801058e0:	78 0e                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058e2:	89 d8                	mov    %ebx,%eax
801058e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058e7:	c9                   	leave  
801058e8:	c3                   	ret    
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058f5:	eb eb                	jmp    801058e2 <sys_sbrk+0x32>
801058f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fe:	66 90                	xchg   %ax,%ax

80105900 <sys_sleep>:

int
sys_sleep(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105904:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105907:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010590a:	50                   	push   %eax
8010590b:	6a 00                	push   $0x0
8010590d:	e8 ae f1 ff ff       	call   80104ac0 <argint>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	0f 88 8a 00 00 00    	js     801059a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010591d:	83 ec 0c             	sub    $0xc,%esp
80105920:	68 c0 3d 11 80       	push   $0x80113dc0
80105925:	e8 16 ee ff ff       	call   80104740 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010592a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010592d:	8b 1d a0 3d 11 80    	mov    0x80113da0,%ebx
  while(ticks - ticks0 < n){
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 d2                	test   %edx,%edx
80105938:	75 27                	jne    80105961 <sys_sleep+0x61>
8010593a:	eb 54                	jmp    80105990 <sys_sleep+0x90>
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105940:	83 ec 08             	sub    $0x8,%esp
80105943:	68 c0 3d 11 80       	push   $0x80113dc0
80105948:	68 a0 3d 11 80       	push   $0x80113da0
8010594d:	e8 ee e6 ff ff       	call   80104040 <sleep>
  while(ticks - ticks0 < n){
80105952:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	29 d8                	sub    %ebx,%eax
8010595c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010595f:	73 2f                	jae    80105990 <sys_sleep+0x90>
    if(myproc()->killed){
80105961:	e8 0a e0 ff ff       	call   80103970 <myproc>
80105966:	8b 40 24             	mov    0x24(%eax),%eax
80105969:	85 c0                	test   %eax,%eax
8010596b:	74 d3                	je     80105940 <sys_sleep+0x40>
      release(&tickslock);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	68 c0 3d 11 80       	push   $0x80113dc0
80105975:	e8 66 ed ff ff       	call   801046e0 <release>
  }
  release(&tickslock);
  return 0;
}
8010597a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	68 c0 3d 11 80       	push   $0x80113dc0
80105998:	e8 43 ed ff ff       	call   801046e0 <release>
  return 0;
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	31 c0                	xor    %eax,%eax
}
801059a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a5:	c9                   	leave  
801059a6:	c3                   	ret    
    return -1;
801059a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ac:	eb f4                	jmp    801059a2 <sys_sleep+0xa2>
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801059b7:	68 c0 3d 11 80       	push   $0x80113dc0
801059bc:	e8 7f ed ff ff       	call   80104740 <acquire>
  xticks = ticks;
801059c1:	8b 1d a0 3d 11 80    	mov    0x80113da0,%ebx
  release(&tickslock);
801059c7:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
801059ce:	e8 0d ed ff ff       	call   801046e0 <release>
  return xticks;
}
801059d3:	89 d8                	mov    %ebx,%eax
801059d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059d8:	c9                   	leave  
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059e0 <sys_sem_init>:

int
sys_sem_init(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 20             	sub    $0x20,%esp
  int i, v;
  if (argint(0, &i) < 0 || argint(1, &v) < 0)
801059e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059e9:	50                   	push   %eax
801059ea:	6a 00                	push   $0x0
801059ec:	e8 cf f0 ff ff       	call   80104ac0 <argint>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	78 28                	js     80105a20 <sys_sem_init+0x40>
801059f8:	83 ec 08             	sub    $0x8,%esp
801059fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059fe:	50                   	push   %eax
801059ff:	6a 01                	push   $0x1
80105a01:	e8 ba f0 ff ff       	call   80104ac0 <argint>
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	78 13                	js     80105a20 <sys_sem_init+0x40>
    return -1;
  return sem_init(i, v);
80105a0d:	83 ec 08             	sub    $0x8,%esp
80105a10:	ff 75 f4             	push   -0xc(%ebp)
80105a13:	ff 75 f0             	push   -0x10(%ebp)
80105a16:	e8 85 e8 ff ff       	call   801042a0 <sem_init>
80105a1b:	83 c4 10             	add    $0x10,%esp
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    
80105a20:	c9                   	leave  
    return -1;
80105a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a26:	c3                   	ret    
80105a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2e:	66 90                	xchg   %ax,%ax

80105a30 <sys_sem_acquire>:

int
sys_sem_acquire(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0)
80105a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a39:	50                   	push   %eax
80105a3a:	6a 00                	push   $0x0
80105a3c:	e8 7f f0 ff ff       	call   80104ac0 <argint>
80105a41:	83 c4 10             	add    $0x10,%esp
80105a44:	85 c0                	test   %eax,%eax
80105a46:	78 18                	js     80105a60 <sys_sem_acquire+0x30>
    return -1;
  return sem_acquire(i);
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	ff 75 f4             	push   -0xc(%ebp)
80105a4e:	e8 ad e8 ff ff       	call   80104300 <sem_acquire>
80105a53:	83 c4 10             	add    $0x10,%esp
}
80105a56:	c9                   	leave  
80105a57:	c3                   	ret    
80105a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
80105a60:	c9                   	leave  
    return -1;
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a66:	c3                   	ret    
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_sem_release>:

int
sys_sem_release(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0)
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	50                   	push   %eax
80105a7a:	6a 00                	push   $0x0
80105a7c:	e8 3f f0 ff ff       	call   80104ac0 <argint>
80105a81:	83 c4 10             	add    $0x10,%esp
80105a84:	85 c0                	test   %eax,%eax
80105a86:	78 18                	js     80105aa0 <sys_sem_release+0x30>
    return -1;
  return sem_release(i);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 f4             	push   -0xc(%ebp)
80105a8e:	e8 fd e8 ff ff       	call   80104390 <sem_release>
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	c9                   	leave  
80105a97:	c3                   	ret    
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
80105aa0:	c9                   	leave  
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa6:	c3                   	ret    

80105aa7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105aa7:	1e                   	push   %ds
  pushl %es
80105aa8:	06                   	push   %es
  pushl %fs
80105aa9:	0f a0                	push   %fs
  pushl %gs
80105aab:	0f a8                	push   %gs
  pushal
80105aad:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105aae:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ab2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ab4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ab6:	54                   	push   %esp
  call trap
80105ab7:	e8 c4 00 00 00       	call   80105b80 <trap>
  addl $4, %esp
80105abc:	83 c4 04             	add    $0x4,%esp

80105abf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105abf:	61                   	popa   
  popl %gs
80105ac0:	0f a9                	pop    %gs
  popl %fs
80105ac2:	0f a1                	pop    %fs
  popl %es
80105ac4:	07                   	pop    %es
  popl %ds
80105ac5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ac6:	83 c4 08             	add    $0x8,%esp
  iret
80105ac9:	cf                   	iret   
80105aca:	66 90                	xchg   %ax,%ax
80105acc:	66 90                	xchg   %ax,%ax
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ad0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ad1:	31 c0                	xor    %eax,%eax
{
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	83 ec 08             	sub    $0x8,%esp
80105ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ae0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105ae7:	c7 04 c5 02 3e 11 80 	movl   $0x8e000008,-0x7feec1fe(,%eax,8)
80105aee:	08 00 00 8e 
80105af2:	66 89 14 c5 00 3e 11 	mov    %dx,-0x7feec200(,%eax,8)
80105af9:	80 
80105afa:	c1 ea 10             	shr    $0x10,%edx
80105afd:	66 89 14 c5 06 3e 11 	mov    %dx,-0x7feec1fa(,%eax,8)
80105b04:	80 
  for(i = 0; i < 256; i++)
80105b05:	83 c0 01             	add    $0x1,%eax
80105b08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b0d:	75 d1                	jne    80105ae0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b0f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b12:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b17:	c7 05 02 40 11 80 08 	movl   $0xef000008,0x80114002
80105b1e:	00 00 ef 
  initlock(&tickslock, "time");
80105b21:	68 85 7b 10 80       	push   $0x80107b85
80105b26:	68 c0 3d 11 80       	push   $0x80113dc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b2b:	66 a3 00 40 11 80    	mov    %ax,0x80114000
80105b31:	c1 e8 10             	shr    $0x10,%eax
80105b34:	66 a3 06 40 11 80    	mov    %ax,0x80114006
  initlock(&tickslock, "time");
80105b3a:	e8 31 ea ff ff       	call   80104570 <initlock>
}
80105b3f:	83 c4 10             	add    $0x10,%esp
80105b42:	c9                   	leave  
80105b43:	c3                   	ret    
80105b44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop

80105b50 <idtinit>:

void
idtinit(void)
{
80105b50:	55                   	push   %ebp
  pd[0] = size-1;
80105b51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b56:	89 e5                	mov    %esp,%ebp
80105b58:	83 ec 10             	sub    $0x10,%esp
80105b5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b5f:	b8 00 3e 11 80       	mov    $0x80113e00,%eax
80105b64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b68:	c1 e8 10             	shr    $0x10,%eax
80105b6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
80105b86:	83 ec 1c             	sub    $0x1c,%esp
80105b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b8c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b8f:	83 f8 40             	cmp    $0x40,%eax
80105b92:	0f 84 68 01 00 00    	je     80105d00 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b98:	83 e8 20             	sub    $0x20,%eax
80105b9b:	83 f8 1f             	cmp    $0x1f,%eax
80105b9e:	0f 87 8c 00 00 00    	ja     80105c30 <trap+0xb0>
80105ba4:	ff 24 85 2c 7c 10 80 	jmp    *-0x7fef83d4(,%eax,4)
80105bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105bb0:	e8 8b c6 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80105bb5:	e8 56 cd ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bba:	e8 b1 dd ff ff       	call   80103970 <myproc>
80105bbf:	85 c0                	test   %eax,%eax
80105bc1:	74 1d                	je     80105be0 <trap+0x60>
80105bc3:	e8 a8 dd ff ff       	call   80103970 <myproc>
80105bc8:	8b 50 24             	mov    0x24(%eax),%edx
80105bcb:	85 d2                	test   %edx,%edx
80105bcd:	74 11                	je     80105be0 <trap+0x60>
80105bcf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bd3:	83 e0 03             	and    $0x3,%eax
80105bd6:	66 83 f8 03          	cmp    $0x3,%ax
80105bda:	0f 84 e8 01 00 00    	je     80105dc8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	e8 8b dd ff ff       	call   80103970 <myproc>
80105be5:	85 c0                	test   %eax,%eax
80105be7:	74 0f                	je     80105bf8 <trap+0x78>
80105be9:	e8 82 dd ff ff       	call   80103970 <myproc>
80105bee:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bf2:	0f 84 b8 00 00 00    	je     80105cb0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bf8:	e8 73 dd ff ff       	call   80103970 <myproc>
80105bfd:	85 c0                	test   %eax,%eax
80105bff:	74 1d                	je     80105c1e <trap+0x9e>
80105c01:	e8 6a dd ff ff       	call   80103970 <myproc>
80105c06:	8b 40 24             	mov    0x24(%eax),%eax
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	74 11                	je     80105c1e <trap+0x9e>
80105c0d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c11:	83 e0 03             	and    $0x3,%eax
80105c14:	66 83 f8 03          	cmp    $0x3,%ax
80105c18:	0f 84 0f 01 00 00    	je     80105d2d <trap+0x1ad>
    exit();
}
80105c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c21:	5b                   	pop    %ebx
80105c22:	5e                   	pop    %esi
80105c23:	5f                   	pop    %edi
80105c24:	5d                   	pop    %ebp
80105c25:	c3                   	ret    
80105c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c30:	e8 3b dd ff ff       	call   80103970 <myproc>
80105c35:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c38:	85 c0                	test   %eax,%eax
80105c3a:	0f 84 a2 01 00 00    	je     80105de2 <trap+0x262>
80105c40:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c44:	0f 84 98 01 00 00    	je     80105de2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c4a:	0f 20 d1             	mov    %cr2,%ecx
80105c4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c50:	e8 fb dc ff ff       	call   80103950 <cpuid>
80105c55:	8b 73 30             	mov    0x30(%ebx),%esi
80105c58:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c5b:	8b 43 34             	mov    0x34(%ebx),%eax
80105c5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c61:	e8 0a dd ff ff       	call   80103970 <myproc>
80105c66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c69:	e8 02 dd ff ff       	call   80103970 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c74:	51                   	push   %ecx
80105c75:	57                   	push   %edi
80105c76:	52                   	push   %edx
80105c77:	ff 75 e4             	push   -0x1c(%ebp)
80105c7a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c7b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c7e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c81:	56                   	push   %esi
80105c82:	ff 70 10             	push   0x10(%eax)
80105c85:	68 e8 7b 10 80       	push   $0x80107be8
80105c8a:	e8 11 aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105c8f:	83 c4 20             	add    $0x20,%esp
80105c92:	e8 d9 dc ff ff       	call   80103970 <myproc>
80105c97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9e:	e8 cd dc ff ff       	call   80103970 <myproc>
80105ca3:	85 c0                	test   %eax,%eax
80105ca5:	0f 85 18 ff ff ff    	jne    80105bc3 <trap+0x43>
80105cab:	e9 30 ff ff ff       	jmp    80105be0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105cb0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105cb4:	0f 85 3e ff ff ff    	jne    80105bf8 <trap+0x78>
    yield();
80105cba:	e8 31 e3 ff ff       	call   80103ff0 <yield>
80105cbf:	e9 34 ff ff ff       	jmp    80105bf8 <trap+0x78>
80105cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cc8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ccb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105ccf:	e8 7c dc ff ff       	call   80103950 <cpuid>
80105cd4:	57                   	push   %edi
80105cd5:	56                   	push   %esi
80105cd6:	50                   	push   %eax
80105cd7:	68 90 7b 10 80       	push   $0x80107b90
80105cdc:	e8 bf a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ce1:	e8 2a cc ff ff       	call   80102910 <lapiceoi>
    break;
80105ce6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ce9:	e8 82 dc ff ff       	call   80103970 <myproc>
80105cee:	85 c0                	test   %eax,%eax
80105cf0:	0f 85 cd fe ff ff    	jne    80105bc3 <trap+0x43>
80105cf6:	e9 e5 fe ff ff       	jmp    80105be0 <trap+0x60>
80105cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
    if(myproc()->killed)
80105d00:	e8 6b dc ff ff       	call   80103970 <myproc>
80105d05:	8b 70 24             	mov    0x24(%eax),%esi
80105d08:	85 f6                	test   %esi,%esi
80105d0a:	0f 85 c8 00 00 00    	jne    80105dd8 <trap+0x258>
    myproc()->tf = tf;
80105d10:	e8 5b dc ff ff       	call   80103970 <myproc>
80105d15:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d18:	e8 e3 ee ff ff       	call   80104c00 <syscall>
    if(myproc()->killed)
80105d1d:	e8 4e dc ff ff       	call   80103970 <myproc>
80105d22:	8b 48 24             	mov    0x24(%eax),%ecx
80105d25:	85 c9                	test   %ecx,%ecx
80105d27:	0f 84 f1 fe ff ff    	je     80105c1e <trap+0x9e>
}
80105d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d30:	5b                   	pop    %ebx
80105d31:	5e                   	pop    %esi
80105d32:	5f                   	pop    %edi
80105d33:	5d                   	pop    %ebp
      exit();
80105d34:	e9 57 e0 ff ff       	jmp    80103d90 <exit>
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d40:	e8 3b 02 00 00       	call   80105f80 <uartintr>
    lapiceoi();
80105d45:	e8 c6 cb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d4a:	e8 21 dc ff ff       	call   80103970 <myproc>
80105d4f:	85 c0                	test   %eax,%eax
80105d51:	0f 85 6c fe ff ff    	jne    80105bc3 <trap+0x43>
80105d57:	e9 84 fe ff ff       	jmp    80105be0 <trap+0x60>
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d60:	e8 6b ca ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105d65:	e8 a6 cb ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d6a:	e8 01 dc ff ff       	call   80103970 <myproc>
80105d6f:	85 c0                	test   %eax,%eax
80105d71:	0f 85 4c fe ff ff    	jne    80105bc3 <trap+0x43>
80105d77:	e9 64 fe ff ff       	jmp    80105be0 <trap+0x60>
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d80:	e8 cb db ff ff       	call   80103950 <cpuid>
80105d85:	85 c0                	test   %eax,%eax
80105d87:	0f 85 28 fe ff ff    	jne    80105bb5 <trap+0x35>
      acquire(&tickslock);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	68 c0 3d 11 80       	push   $0x80113dc0
80105d95:	e8 a6 e9 ff ff       	call   80104740 <acquire>
      wakeup(&ticks);
80105d9a:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
      ticks++;
80105da1:	83 05 a0 3d 11 80 01 	addl   $0x1,0x80113da0
      wakeup(&ticks);
80105da8:	e8 53 e3 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80105dad:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80105db4:	e8 27 e9 ff ff       	call   801046e0 <release>
80105db9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105dbc:	e9 f4 fd ff ff       	jmp    80105bb5 <trap+0x35>
80105dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105dc8:	e8 c3 df ff ff       	call   80103d90 <exit>
80105dcd:	e9 0e fe ff ff       	jmp    80105be0 <trap+0x60>
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105dd8:	e8 b3 df ff ff       	call   80103d90 <exit>
80105ddd:	e9 2e ff ff ff       	jmp    80105d10 <trap+0x190>
80105de2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105de5:	e8 66 db ff ff       	call   80103950 <cpuid>
80105dea:	83 ec 0c             	sub    $0xc,%esp
80105ded:	56                   	push   %esi
80105dee:	57                   	push   %edi
80105def:	50                   	push   %eax
80105df0:	ff 73 30             	push   0x30(%ebx)
80105df3:	68 b4 7b 10 80       	push   $0x80107bb4
80105df8:	e8 a3 a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105dfd:	83 c4 14             	add    $0x14,%esp
80105e00:	68 8a 7b 10 80       	push   $0x80107b8a
80105e05:	e8 76 a5 ff ff       	call   80100380 <panic>
80105e0a:	66 90                	xchg   %ax,%ax
80105e0c:	66 90                	xchg   %ax,%ax
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e10:	a1 00 46 11 80       	mov    0x80114600,%eax
80105e15:	85 c0                	test   %eax,%eax
80105e17:	74 17                	je     80105e30 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e19:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e1e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e1f:	a8 01                	test   $0x1,%al
80105e21:	74 0d                	je     80105e30 <uartgetc+0x20>
80105e23:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e28:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e29:	0f b6 c0             	movzbl %al,%eax
80105e2c:	c3                   	ret    
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c3                   	ret    
80105e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi

80105e40 <uartinit>:
{
80105e40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e41:	31 c9                	xor    %ecx,%ecx
80105e43:	89 c8                	mov    %ecx,%eax
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	57                   	push   %edi
80105e48:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e4d:	56                   	push   %esi
80105e4e:	89 fa                	mov    %edi,%edx
80105e50:	53                   	push   %ebx
80105e51:	83 ec 1c             	sub    $0x1c,%esp
80105e54:	ee                   	out    %al,(%dx)
80105e55:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e5f:	89 f2                	mov    %esi,%edx
80105e61:	ee                   	out    %al,(%dx)
80105e62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6c:	ee                   	out    %al,(%dx)
80105e6d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e72:	89 c8                	mov    %ecx,%eax
80105e74:	89 da                	mov    %ebx,%edx
80105e76:	ee                   	out    %al,(%dx)
80105e77:	b8 03 00 00 00       	mov    $0x3,%eax
80105e7c:	89 f2                	mov    %esi,%edx
80105e7e:	ee                   	out    %al,(%dx)
80105e7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e84:	89 c8                	mov    %ecx,%eax
80105e86:	ee                   	out    %al,(%dx)
80105e87:	b8 01 00 00 00       	mov    $0x1,%eax
80105e8c:	89 da                	mov    %ebx,%edx
80105e8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e95:	3c ff                	cmp    $0xff,%al
80105e97:	74 78                	je     80105f11 <uartinit+0xd1>
  uart = 1;
80105e99:	c7 05 00 46 11 80 01 	movl   $0x1,0x80114600
80105ea0:	00 00 00 
80105ea3:	89 fa                	mov    %edi,%edx
80105ea5:	ec                   	in     (%dx),%al
80105ea6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105eac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105eaf:	bf ac 7c 10 80       	mov    $0x80107cac,%edi
80105eb4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105eb9:	6a 00                	push   $0x0
80105ebb:	6a 04                	push   $0x4
80105ebd:	e8 be c5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ec2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ed0:	a1 00 46 11 80       	mov    0x80114600,%eax
80105ed5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105eda:	85 c0                	test   %eax,%eax
80105edc:	75 14                	jne    80105ef2 <uartinit+0xb2>
80105ede:	eb 23                	jmp    80105f03 <uartinit+0xc3>
    microdelay(10);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	6a 0a                	push   $0xa
80105ee5:	e8 46 ca ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	83 eb 01             	sub    $0x1,%ebx
80105ef0:	74 07                	je     80105ef9 <uartinit+0xb9>
80105ef2:	89 f2                	mov    %esi,%edx
80105ef4:	ec                   	in     (%dx),%al
80105ef5:	a8 20                	test   $0x20,%al
80105ef7:	74 e7                	je     80105ee0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105efd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f02:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f03:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f07:	83 c7 01             	add    $0x1,%edi
80105f0a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f0d:	84 c0                	test   %al,%al
80105f0f:	75 bf                	jne    80105ed0 <uartinit+0x90>
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	5b                   	pop    %ebx
80105f15:	5e                   	pop    %esi
80105f16:	5f                   	pop    %edi
80105f17:	5d                   	pop    %ebp
80105f18:	c3                   	ret    
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <uartputc>:
  if(!uart)
80105f20:	a1 00 46 11 80       	mov    0x80114600,%eax
80105f25:	85 c0                	test   %eax,%eax
80105f27:	74 47                	je     80105f70 <uartputc+0x50>
{
80105f29:	55                   	push   %ebp
80105f2a:	89 e5                	mov    %esp,%ebp
80105f2c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f32:	53                   	push   %ebx
80105f33:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f38:	eb 18                	jmp    80105f52 <uartputc+0x32>
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f40:	83 ec 0c             	sub    $0xc,%esp
80105f43:	6a 0a                	push   $0xa
80105f45:	e8 e6 c9 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	83 eb 01             	sub    $0x1,%ebx
80105f50:	74 07                	je     80105f59 <uartputc+0x39>
80105f52:	89 f2                	mov    %esi,%edx
80105f54:	ec                   	in     (%dx),%al
80105f55:	a8 20                	test   $0x20,%al
80105f57:	74 e7                	je     80105f40 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f59:	8b 45 08             	mov    0x8(%ebp),%eax
80105f5c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f61:	ee                   	out    %al,(%dx)
}
80105f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f65:	5b                   	pop    %ebx
80105f66:	5e                   	pop    %esi
80105f67:	5d                   	pop    %ebp
80105f68:	c3                   	ret    
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f70:	c3                   	ret    
80105f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop

80105f80 <uartintr>:

void
uartintr(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f86:	68 10 5e 10 80       	push   $0x80105e10
80105f8b:	e8 f0 a8 ff ff       	call   80100880 <consoleintr>
}
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	c9                   	leave  
80105f94:	c3                   	ret    

80105f95 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $0
80105f97:	6a 00                	push   $0x0
  jmp alltraps
80105f99:	e9 09 fb ff ff       	jmp    80105aa7 <alltraps>

80105f9e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $1
80105fa0:	6a 01                	push   $0x1
  jmp alltraps
80105fa2:	e9 00 fb ff ff       	jmp    80105aa7 <alltraps>

80105fa7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $2
80105fa9:	6a 02                	push   $0x2
  jmp alltraps
80105fab:	e9 f7 fa ff ff       	jmp    80105aa7 <alltraps>

80105fb0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $3
80105fb2:	6a 03                	push   $0x3
  jmp alltraps
80105fb4:	e9 ee fa ff ff       	jmp    80105aa7 <alltraps>

80105fb9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $4
80105fbb:	6a 04                	push   $0x4
  jmp alltraps
80105fbd:	e9 e5 fa ff ff       	jmp    80105aa7 <alltraps>

80105fc2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $5
80105fc4:	6a 05                	push   $0x5
  jmp alltraps
80105fc6:	e9 dc fa ff ff       	jmp    80105aa7 <alltraps>

80105fcb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $6
80105fcd:	6a 06                	push   $0x6
  jmp alltraps
80105fcf:	e9 d3 fa ff ff       	jmp    80105aa7 <alltraps>

80105fd4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $7
80105fd6:	6a 07                	push   $0x7
  jmp alltraps
80105fd8:	e9 ca fa ff ff       	jmp    80105aa7 <alltraps>

80105fdd <vector8>:
.globl vector8
vector8:
  pushl $8
80105fdd:	6a 08                	push   $0x8
  jmp alltraps
80105fdf:	e9 c3 fa ff ff       	jmp    80105aa7 <alltraps>

80105fe4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $9
80105fe6:	6a 09                	push   $0x9
  jmp alltraps
80105fe8:	e9 ba fa ff ff       	jmp    80105aa7 <alltraps>

80105fed <vector10>:
.globl vector10
vector10:
  pushl $10
80105fed:	6a 0a                	push   $0xa
  jmp alltraps
80105fef:	e9 b3 fa ff ff       	jmp    80105aa7 <alltraps>

80105ff4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ff4:	6a 0b                	push   $0xb
  jmp alltraps
80105ff6:	e9 ac fa ff ff       	jmp    80105aa7 <alltraps>

80105ffb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ffb:	6a 0c                	push   $0xc
  jmp alltraps
80105ffd:	e9 a5 fa ff ff       	jmp    80105aa7 <alltraps>

80106002 <vector13>:
.globl vector13
vector13:
  pushl $13
80106002:	6a 0d                	push   $0xd
  jmp alltraps
80106004:	e9 9e fa ff ff       	jmp    80105aa7 <alltraps>

80106009 <vector14>:
.globl vector14
vector14:
  pushl $14
80106009:	6a 0e                	push   $0xe
  jmp alltraps
8010600b:	e9 97 fa ff ff       	jmp    80105aa7 <alltraps>

80106010 <vector15>:
.globl vector15
vector15:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $15
80106012:	6a 0f                	push   $0xf
  jmp alltraps
80106014:	e9 8e fa ff ff       	jmp    80105aa7 <alltraps>

80106019 <vector16>:
.globl vector16
vector16:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $16
8010601b:	6a 10                	push   $0x10
  jmp alltraps
8010601d:	e9 85 fa ff ff       	jmp    80105aa7 <alltraps>

80106022 <vector17>:
.globl vector17
vector17:
  pushl $17
80106022:	6a 11                	push   $0x11
  jmp alltraps
80106024:	e9 7e fa ff ff       	jmp    80105aa7 <alltraps>

80106029 <vector18>:
.globl vector18
vector18:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $18
8010602b:	6a 12                	push   $0x12
  jmp alltraps
8010602d:	e9 75 fa ff ff       	jmp    80105aa7 <alltraps>

80106032 <vector19>:
.globl vector19
vector19:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $19
80106034:	6a 13                	push   $0x13
  jmp alltraps
80106036:	e9 6c fa ff ff       	jmp    80105aa7 <alltraps>

8010603b <vector20>:
.globl vector20
vector20:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $20
8010603d:	6a 14                	push   $0x14
  jmp alltraps
8010603f:	e9 63 fa ff ff       	jmp    80105aa7 <alltraps>

80106044 <vector21>:
.globl vector21
vector21:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $21
80106046:	6a 15                	push   $0x15
  jmp alltraps
80106048:	e9 5a fa ff ff       	jmp    80105aa7 <alltraps>

8010604d <vector22>:
.globl vector22
vector22:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $22
8010604f:	6a 16                	push   $0x16
  jmp alltraps
80106051:	e9 51 fa ff ff       	jmp    80105aa7 <alltraps>

80106056 <vector23>:
.globl vector23
vector23:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $23
80106058:	6a 17                	push   $0x17
  jmp alltraps
8010605a:	e9 48 fa ff ff       	jmp    80105aa7 <alltraps>

8010605f <vector24>:
.globl vector24
vector24:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $24
80106061:	6a 18                	push   $0x18
  jmp alltraps
80106063:	e9 3f fa ff ff       	jmp    80105aa7 <alltraps>

80106068 <vector25>:
.globl vector25
vector25:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $25
8010606a:	6a 19                	push   $0x19
  jmp alltraps
8010606c:	e9 36 fa ff ff       	jmp    80105aa7 <alltraps>

80106071 <vector26>:
.globl vector26
vector26:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $26
80106073:	6a 1a                	push   $0x1a
  jmp alltraps
80106075:	e9 2d fa ff ff       	jmp    80105aa7 <alltraps>

8010607a <vector27>:
.globl vector27
vector27:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $27
8010607c:	6a 1b                	push   $0x1b
  jmp alltraps
8010607e:	e9 24 fa ff ff       	jmp    80105aa7 <alltraps>

80106083 <vector28>:
.globl vector28
vector28:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $28
80106085:	6a 1c                	push   $0x1c
  jmp alltraps
80106087:	e9 1b fa ff ff       	jmp    80105aa7 <alltraps>

8010608c <vector29>:
.globl vector29
vector29:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $29
8010608e:	6a 1d                	push   $0x1d
  jmp alltraps
80106090:	e9 12 fa ff ff       	jmp    80105aa7 <alltraps>

80106095 <vector30>:
.globl vector30
vector30:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $30
80106097:	6a 1e                	push   $0x1e
  jmp alltraps
80106099:	e9 09 fa ff ff       	jmp    80105aa7 <alltraps>

8010609e <vector31>:
.globl vector31
vector31:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $31
801060a0:	6a 1f                	push   $0x1f
  jmp alltraps
801060a2:	e9 00 fa ff ff       	jmp    80105aa7 <alltraps>

801060a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $32
801060a9:	6a 20                	push   $0x20
  jmp alltraps
801060ab:	e9 f7 f9 ff ff       	jmp    80105aa7 <alltraps>

801060b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $33
801060b2:	6a 21                	push   $0x21
  jmp alltraps
801060b4:	e9 ee f9 ff ff       	jmp    80105aa7 <alltraps>

801060b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $34
801060bb:	6a 22                	push   $0x22
  jmp alltraps
801060bd:	e9 e5 f9 ff ff       	jmp    80105aa7 <alltraps>

801060c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $35
801060c4:	6a 23                	push   $0x23
  jmp alltraps
801060c6:	e9 dc f9 ff ff       	jmp    80105aa7 <alltraps>

801060cb <vector36>:
.globl vector36
vector36:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $36
801060cd:	6a 24                	push   $0x24
  jmp alltraps
801060cf:	e9 d3 f9 ff ff       	jmp    80105aa7 <alltraps>

801060d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $37
801060d6:	6a 25                	push   $0x25
  jmp alltraps
801060d8:	e9 ca f9 ff ff       	jmp    80105aa7 <alltraps>

801060dd <vector38>:
.globl vector38
vector38:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $38
801060df:	6a 26                	push   $0x26
  jmp alltraps
801060e1:	e9 c1 f9 ff ff       	jmp    80105aa7 <alltraps>

801060e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $39
801060e8:	6a 27                	push   $0x27
  jmp alltraps
801060ea:	e9 b8 f9 ff ff       	jmp    80105aa7 <alltraps>

801060ef <vector40>:
.globl vector40
vector40:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $40
801060f1:	6a 28                	push   $0x28
  jmp alltraps
801060f3:	e9 af f9 ff ff       	jmp    80105aa7 <alltraps>

801060f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $41
801060fa:	6a 29                	push   $0x29
  jmp alltraps
801060fc:	e9 a6 f9 ff ff       	jmp    80105aa7 <alltraps>

80106101 <vector42>:
.globl vector42
vector42:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $42
80106103:	6a 2a                	push   $0x2a
  jmp alltraps
80106105:	e9 9d f9 ff ff       	jmp    80105aa7 <alltraps>

8010610a <vector43>:
.globl vector43
vector43:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $43
8010610c:	6a 2b                	push   $0x2b
  jmp alltraps
8010610e:	e9 94 f9 ff ff       	jmp    80105aa7 <alltraps>

80106113 <vector44>:
.globl vector44
vector44:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $44
80106115:	6a 2c                	push   $0x2c
  jmp alltraps
80106117:	e9 8b f9 ff ff       	jmp    80105aa7 <alltraps>

8010611c <vector45>:
.globl vector45
vector45:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $45
8010611e:	6a 2d                	push   $0x2d
  jmp alltraps
80106120:	e9 82 f9 ff ff       	jmp    80105aa7 <alltraps>

80106125 <vector46>:
.globl vector46
vector46:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $46
80106127:	6a 2e                	push   $0x2e
  jmp alltraps
80106129:	e9 79 f9 ff ff       	jmp    80105aa7 <alltraps>

8010612e <vector47>:
.globl vector47
vector47:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $47
80106130:	6a 2f                	push   $0x2f
  jmp alltraps
80106132:	e9 70 f9 ff ff       	jmp    80105aa7 <alltraps>

80106137 <vector48>:
.globl vector48
vector48:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $48
80106139:	6a 30                	push   $0x30
  jmp alltraps
8010613b:	e9 67 f9 ff ff       	jmp    80105aa7 <alltraps>

80106140 <vector49>:
.globl vector49
vector49:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $49
80106142:	6a 31                	push   $0x31
  jmp alltraps
80106144:	e9 5e f9 ff ff       	jmp    80105aa7 <alltraps>

80106149 <vector50>:
.globl vector50
vector50:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $50
8010614b:	6a 32                	push   $0x32
  jmp alltraps
8010614d:	e9 55 f9 ff ff       	jmp    80105aa7 <alltraps>

80106152 <vector51>:
.globl vector51
vector51:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $51
80106154:	6a 33                	push   $0x33
  jmp alltraps
80106156:	e9 4c f9 ff ff       	jmp    80105aa7 <alltraps>

8010615b <vector52>:
.globl vector52
vector52:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $52
8010615d:	6a 34                	push   $0x34
  jmp alltraps
8010615f:	e9 43 f9 ff ff       	jmp    80105aa7 <alltraps>

80106164 <vector53>:
.globl vector53
vector53:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $53
80106166:	6a 35                	push   $0x35
  jmp alltraps
80106168:	e9 3a f9 ff ff       	jmp    80105aa7 <alltraps>

8010616d <vector54>:
.globl vector54
vector54:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $54
8010616f:	6a 36                	push   $0x36
  jmp alltraps
80106171:	e9 31 f9 ff ff       	jmp    80105aa7 <alltraps>

80106176 <vector55>:
.globl vector55
vector55:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $55
80106178:	6a 37                	push   $0x37
  jmp alltraps
8010617a:	e9 28 f9 ff ff       	jmp    80105aa7 <alltraps>

8010617f <vector56>:
.globl vector56
vector56:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $56
80106181:	6a 38                	push   $0x38
  jmp alltraps
80106183:	e9 1f f9 ff ff       	jmp    80105aa7 <alltraps>

80106188 <vector57>:
.globl vector57
vector57:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $57
8010618a:	6a 39                	push   $0x39
  jmp alltraps
8010618c:	e9 16 f9 ff ff       	jmp    80105aa7 <alltraps>

80106191 <vector58>:
.globl vector58
vector58:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $58
80106193:	6a 3a                	push   $0x3a
  jmp alltraps
80106195:	e9 0d f9 ff ff       	jmp    80105aa7 <alltraps>

8010619a <vector59>:
.globl vector59
vector59:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $59
8010619c:	6a 3b                	push   $0x3b
  jmp alltraps
8010619e:	e9 04 f9 ff ff       	jmp    80105aa7 <alltraps>

801061a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $60
801061a5:	6a 3c                	push   $0x3c
  jmp alltraps
801061a7:	e9 fb f8 ff ff       	jmp    80105aa7 <alltraps>

801061ac <vector61>:
.globl vector61
vector61:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $61
801061ae:	6a 3d                	push   $0x3d
  jmp alltraps
801061b0:	e9 f2 f8 ff ff       	jmp    80105aa7 <alltraps>

801061b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $62
801061b7:	6a 3e                	push   $0x3e
  jmp alltraps
801061b9:	e9 e9 f8 ff ff       	jmp    80105aa7 <alltraps>

801061be <vector63>:
.globl vector63
vector63:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $63
801061c0:	6a 3f                	push   $0x3f
  jmp alltraps
801061c2:	e9 e0 f8 ff ff       	jmp    80105aa7 <alltraps>

801061c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $64
801061c9:	6a 40                	push   $0x40
  jmp alltraps
801061cb:	e9 d7 f8 ff ff       	jmp    80105aa7 <alltraps>

801061d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $65
801061d2:	6a 41                	push   $0x41
  jmp alltraps
801061d4:	e9 ce f8 ff ff       	jmp    80105aa7 <alltraps>

801061d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $66
801061db:	6a 42                	push   $0x42
  jmp alltraps
801061dd:	e9 c5 f8 ff ff       	jmp    80105aa7 <alltraps>

801061e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $67
801061e4:	6a 43                	push   $0x43
  jmp alltraps
801061e6:	e9 bc f8 ff ff       	jmp    80105aa7 <alltraps>

801061eb <vector68>:
.globl vector68
vector68:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $68
801061ed:	6a 44                	push   $0x44
  jmp alltraps
801061ef:	e9 b3 f8 ff ff       	jmp    80105aa7 <alltraps>

801061f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $69
801061f6:	6a 45                	push   $0x45
  jmp alltraps
801061f8:	e9 aa f8 ff ff       	jmp    80105aa7 <alltraps>

801061fd <vector70>:
.globl vector70
vector70:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $70
801061ff:	6a 46                	push   $0x46
  jmp alltraps
80106201:	e9 a1 f8 ff ff       	jmp    80105aa7 <alltraps>

80106206 <vector71>:
.globl vector71
vector71:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $71
80106208:	6a 47                	push   $0x47
  jmp alltraps
8010620a:	e9 98 f8 ff ff       	jmp    80105aa7 <alltraps>

8010620f <vector72>:
.globl vector72
vector72:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $72
80106211:	6a 48                	push   $0x48
  jmp alltraps
80106213:	e9 8f f8 ff ff       	jmp    80105aa7 <alltraps>

80106218 <vector73>:
.globl vector73
vector73:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $73
8010621a:	6a 49                	push   $0x49
  jmp alltraps
8010621c:	e9 86 f8 ff ff       	jmp    80105aa7 <alltraps>

80106221 <vector74>:
.globl vector74
vector74:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $74
80106223:	6a 4a                	push   $0x4a
  jmp alltraps
80106225:	e9 7d f8 ff ff       	jmp    80105aa7 <alltraps>

8010622a <vector75>:
.globl vector75
vector75:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $75
8010622c:	6a 4b                	push   $0x4b
  jmp alltraps
8010622e:	e9 74 f8 ff ff       	jmp    80105aa7 <alltraps>

80106233 <vector76>:
.globl vector76
vector76:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $76
80106235:	6a 4c                	push   $0x4c
  jmp alltraps
80106237:	e9 6b f8 ff ff       	jmp    80105aa7 <alltraps>

8010623c <vector77>:
.globl vector77
vector77:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $77
8010623e:	6a 4d                	push   $0x4d
  jmp alltraps
80106240:	e9 62 f8 ff ff       	jmp    80105aa7 <alltraps>

80106245 <vector78>:
.globl vector78
vector78:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $78
80106247:	6a 4e                	push   $0x4e
  jmp alltraps
80106249:	e9 59 f8 ff ff       	jmp    80105aa7 <alltraps>

8010624e <vector79>:
.globl vector79
vector79:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $79
80106250:	6a 4f                	push   $0x4f
  jmp alltraps
80106252:	e9 50 f8 ff ff       	jmp    80105aa7 <alltraps>

80106257 <vector80>:
.globl vector80
vector80:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $80
80106259:	6a 50                	push   $0x50
  jmp alltraps
8010625b:	e9 47 f8 ff ff       	jmp    80105aa7 <alltraps>

80106260 <vector81>:
.globl vector81
vector81:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $81
80106262:	6a 51                	push   $0x51
  jmp alltraps
80106264:	e9 3e f8 ff ff       	jmp    80105aa7 <alltraps>

80106269 <vector82>:
.globl vector82
vector82:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $82
8010626b:	6a 52                	push   $0x52
  jmp alltraps
8010626d:	e9 35 f8 ff ff       	jmp    80105aa7 <alltraps>

80106272 <vector83>:
.globl vector83
vector83:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $83
80106274:	6a 53                	push   $0x53
  jmp alltraps
80106276:	e9 2c f8 ff ff       	jmp    80105aa7 <alltraps>

8010627b <vector84>:
.globl vector84
vector84:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $84
8010627d:	6a 54                	push   $0x54
  jmp alltraps
8010627f:	e9 23 f8 ff ff       	jmp    80105aa7 <alltraps>

80106284 <vector85>:
.globl vector85
vector85:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $85
80106286:	6a 55                	push   $0x55
  jmp alltraps
80106288:	e9 1a f8 ff ff       	jmp    80105aa7 <alltraps>

8010628d <vector86>:
.globl vector86
vector86:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $86
8010628f:	6a 56                	push   $0x56
  jmp alltraps
80106291:	e9 11 f8 ff ff       	jmp    80105aa7 <alltraps>

80106296 <vector87>:
.globl vector87
vector87:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $87
80106298:	6a 57                	push   $0x57
  jmp alltraps
8010629a:	e9 08 f8 ff ff       	jmp    80105aa7 <alltraps>

8010629f <vector88>:
.globl vector88
vector88:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $88
801062a1:	6a 58                	push   $0x58
  jmp alltraps
801062a3:	e9 ff f7 ff ff       	jmp    80105aa7 <alltraps>

801062a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $89
801062aa:	6a 59                	push   $0x59
  jmp alltraps
801062ac:	e9 f6 f7 ff ff       	jmp    80105aa7 <alltraps>

801062b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $90
801062b3:	6a 5a                	push   $0x5a
  jmp alltraps
801062b5:	e9 ed f7 ff ff       	jmp    80105aa7 <alltraps>

801062ba <vector91>:
.globl vector91
vector91:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $91
801062bc:	6a 5b                	push   $0x5b
  jmp alltraps
801062be:	e9 e4 f7 ff ff       	jmp    80105aa7 <alltraps>

801062c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $92
801062c5:	6a 5c                	push   $0x5c
  jmp alltraps
801062c7:	e9 db f7 ff ff       	jmp    80105aa7 <alltraps>

801062cc <vector93>:
.globl vector93
vector93:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $93
801062ce:	6a 5d                	push   $0x5d
  jmp alltraps
801062d0:	e9 d2 f7 ff ff       	jmp    80105aa7 <alltraps>

801062d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $94
801062d7:	6a 5e                	push   $0x5e
  jmp alltraps
801062d9:	e9 c9 f7 ff ff       	jmp    80105aa7 <alltraps>

801062de <vector95>:
.globl vector95
vector95:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $95
801062e0:	6a 5f                	push   $0x5f
  jmp alltraps
801062e2:	e9 c0 f7 ff ff       	jmp    80105aa7 <alltraps>

801062e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $96
801062e9:	6a 60                	push   $0x60
  jmp alltraps
801062eb:	e9 b7 f7 ff ff       	jmp    80105aa7 <alltraps>

801062f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $97
801062f2:	6a 61                	push   $0x61
  jmp alltraps
801062f4:	e9 ae f7 ff ff       	jmp    80105aa7 <alltraps>

801062f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $98
801062fb:	6a 62                	push   $0x62
  jmp alltraps
801062fd:	e9 a5 f7 ff ff       	jmp    80105aa7 <alltraps>

80106302 <vector99>:
.globl vector99
vector99:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $99
80106304:	6a 63                	push   $0x63
  jmp alltraps
80106306:	e9 9c f7 ff ff       	jmp    80105aa7 <alltraps>

8010630b <vector100>:
.globl vector100
vector100:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $100
8010630d:	6a 64                	push   $0x64
  jmp alltraps
8010630f:	e9 93 f7 ff ff       	jmp    80105aa7 <alltraps>

80106314 <vector101>:
.globl vector101
vector101:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $101
80106316:	6a 65                	push   $0x65
  jmp alltraps
80106318:	e9 8a f7 ff ff       	jmp    80105aa7 <alltraps>

8010631d <vector102>:
.globl vector102
vector102:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $102
8010631f:	6a 66                	push   $0x66
  jmp alltraps
80106321:	e9 81 f7 ff ff       	jmp    80105aa7 <alltraps>

80106326 <vector103>:
.globl vector103
vector103:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $103
80106328:	6a 67                	push   $0x67
  jmp alltraps
8010632a:	e9 78 f7 ff ff       	jmp    80105aa7 <alltraps>

8010632f <vector104>:
.globl vector104
vector104:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $104
80106331:	6a 68                	push   $0x68
  jmp alltraps
80106333:	e9 6f f7 ff ff       	jmp    80105aa7 <alltraps>

80106338 <vector105>:
.globl vector105
vector105:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $105
8010633a:	6a 69                	push   $0x69
  jmp alltraps
8010633c:	e9 66 f7 ff ff       	jmp    80105aa7 <alltraps>

80106341 <vector106>:
.globl vector106
vector106:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $106
80106343:	6a 6a                	push   $0x6a
  jmp alltraps
80106345:	e9 5d f7 ff ff       	jmp    80105aa7 <alltraps>

8010634a <vector107>:
.globl vector107
vector107:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $107
8010634c:	6a 6b                	push   $0x6b
  jmp alltraps
8010634e:	e9 54 f7 ff ff       	jmp    80105aa7 <alltraps>

80106353 <vector108>:
.globl vector108
vector108:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $108
80106355:	6a 6c                	push   $0x6c
  jmp alltraps
80106357:	e9 4b f7 ff ff       	jmp    80105aa7 <alltraps>

8010635c <vector109>:
.globl vector109
vector109:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $109
8010635e:	6a 6d                	push   $0x6d
  jmp alltraps
80106360:	e9 42 f7 ff ff       	jmp    80105aa7 <alltraps>

80106365 <vector110>:
.globl vector110
vector110:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $110
80106367:	6a 6e                	push   $0x6e
  jmp alltraps
80106369:	e9 39 f7 ff ff       	jmp    80105aa7 <alltraps>

8010636e <vector111>:
.globl vector111
vector111:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $111
80106370:	6a 6f                	push   $0x6f
  jmp alltraps
80106372:	e9 30 f7 ff ff       	jmp    80105aa7 <alltraps>

80106377 <vector112>:
.globl vector112
vector112:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $112
80106379:	6a 70                	push   $0x70
  jmp alltraps
8010637b:	e9 27 f7 ff ff       	jmp    80105aa7 <alltraps>

80106380 <vector113>:
.globl vector113
vector113:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $113
80106382:	6a 71                	push   $0x71
  jmp alltraps
80106384:	e9 1e f7 ff ff       	jmp    80105aa7 <alltraps>

80106389 <vector114>:
.globl vector114
vector114:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $114
8010638b:	6a 72                	push   $0x72
  jmp alltraps
8010638d:	e9 15 f7 ff ff       	jmp    80105aa7 <alltraps>

80106392 <vector115>:
.globl vector115
vector115:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $115
80106394:	6a 73                	push   $0x73
  jmp alltraps
80106396:	e9 0c f7 ff ff       	jmp    80105aa7 <alltraps>

8010639b <vector116>:
.globl vector116
vector116:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $116
8010639d:	6a 74                	push   $0x74
  jmp alltraps
8010639f:	e9 03 f7 ff ff       	jmp    80105aa7 <alltraps>

801063a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $117
801063a6:	6a 75                	push   $0x75
  jmp alltraps
801063a8:	e9 fa f6 ff ff       	jmp    80105aa7 <alltraps>

801063ad <vector118>:
.globl vector118
vector118:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $118
801063af:	6a 76                	push   $0x76
  jmp alltraps
801063b1:	e9 f1 f6 ff ff       	jmp    80105aa7 <alltraps>

801063b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $119
801063b8:	6a 77                	push   $0x77
  jmp alltraps
801063ba:	e9 e8 f6 ff ff       	jmp    80105aa7 <alltraps>

801063bf <vector120>:
.globl vector120
vector120:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $120
801063c1:	6a 78                	push   $0x78
  jmp alltraps
801063c3:	e9 df f6 ff ff       	jmp    80105aa7 <alltraps>

801063c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $121
801063ca:	6a 79                	push   $0x79
  jmp alltraps
801063cc:	e9 d6 f6 ff ff       	jmp    80105aa7 <alltraps>

801063d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $122
801063d3:	6a 7a                	push   $0x7a
  jmp alltraps
801063d5:	e9 cd f6 ff ff       	jmp    80105aa7 <alltraps>

801063da <vector123>:
.globl vector123
vector123:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $123
801063dc:	6a 7b                	push   $0x7b
  jmp alltraps
801063de:	e9 c4 f6 ff ff       	jmp    80105aa7 <alltraps>

801063e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $124
801063e5:	6a 7c                	push   $0x7c
  jmp alltraps
801063e7:	e9 bb f6 ff ff       	jmp    80105aa7 <alltraps>

801063ec <vector125>:
.globl vector125
vector125:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $125
801063ee:	6a 7d                	push   $0x7d
  jmp alltraps
801063f0:	e9 b2 f6 ff ff       	jmp    80105aa7 <alltraps>

801063f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $126
801063f7:	6a 7e                	push   $0x7e
  jmp alltraps
801063f9:	e9 a9 f6 ff ff       	jmp    80105aa7 <alltraps>

801063fe <vector127>:
.globl vector127
vector127:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $127
80106400:	6a 7f                	push   $0x7f
  jmp alltraps
80106402:	e9 a0 f6 ff ff       	jmp    80105aa7 <alltraps>

80106407 <vector128>:
.globl vector128
vector128:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $128
80106409:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010640e:	e9 94 f6 ff ff       	jmp    80105aa7 <alltraps>

80106413 <vector129>:
.globl vector129
vector129:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $129
80106415:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010641a:	e9 88 f6 ff ff       	jmp    80105aa7 <alltraps>

8010641f <vector130>:
.globl vector130
vector130:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $130
80106421:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106426:	e9 7c f6 ff ff       	jmp    80105aa7 <alltraps>

8010642b <vector131>:
.globl vector131
vector131:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $131
8010642d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106432:	e9 70 f6 ff ff       	jmp    80105aa7 <alltraps>

80106437 <vector132>:
.globl vector132
vector132:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $132
80106439:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010643e:	e9 64 f6 ff ff       	jmp    80105aa7 <alltraps>

80106443 <vector133>:
.globl vector133
vector133:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $133
80106445:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010644a:	e9 58 f6 ff ff       	jmp    80105aa7 <alltraps>

8010644f <vector134>:
.globl vector134
vector134:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $134
80106451:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106456:	e9 4c f6 ff ff       	jmp    80105aa7 <alltraps>

8010645b <vector135>:
.globl vector135
vector135:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $135
8010645d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106462:	e9 40 f6 ff ff       	jmp    80105aa7 <alltraps>

80106467 <vector136>:
.globl vector136
vector136:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $136
80106469:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010646e:	e9 34 f6 ff ff       	jmp    80105aa7 <alltraps>

80106473 <vector137>:
.globl vector137
vector137:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $137
80106475:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010647a:	e9 28 f6 ff ff       	jmp    80105aa7 <alltraps>

8010647f <vector138>:
.globl vector138
vector138:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $138
80106481:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106486:	e9 1c f6 ff ff       	jmp    80105aa7 <alltraps>

8010648b <vector139>:
.globl vector139
vector139:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $139
8010648d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106492:	e9 10 f6 ff ff       	jmp    80105aa7 <alltraps>

80106497 <vector140>:
.globl vector140
vector140:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $140
80106499:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010649e:	e9 04 f6 ff ff       	jmp    80105aa7 <alltraps>

801064a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $141
801064a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064aa:	e9 f8 f5 ff ff       	jmp    80105aa7 <alltraps>

801064af <vector142>:
.globl vector142
vector142:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $142
801064b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064b6:	e9 ec f5 ff ff       	jmp    80105aa7 <alltraps>

801064bb <vector143>:
.globl vector143
vector143:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $143
801064bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064c2:	e9 e0 f5 ff ff       	jmp    80105aa7 <alltraps>

801064c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $144
801064c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064ce:	e9 d4 f5 ff ff       	jmp    80105aa7 <alltraps>

801064d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $145
801064d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064da:	e9 c8 f5 ff ff       	jmp    80105aa7 <alltraps>

801064df <vector146>:
.globl vector146
vector146:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $146
801064e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064e6:	e9 bc f5 ff ff       	jmp    80105aa7 <alltraps>

801064eb <vector147>:
.globl vector147
vector147:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $147
801064ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064f2:	e9 b0 f5 ff ff       	jmp    80105aa7 <alltraps>

801064f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $148
801064f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064fe:	e9 a4 f5 ff ff       	jmp    80105aa7 <alltraps>

80106503 <vector149>:
.globl vector149
vector149:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $149
80106505:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010650a:	e9 98 f5 ff ff       	jmp    80105aa7 <alltraps>

8010650f <vector150>:
.globl vector150
vector150:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $150
80106511:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106516:	e9 8c f5 ff ff       	jmp    80105aa7 <alltraps>

8010651b <vector151>:
.globl vector151
vector151:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $151
8010651d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106522:	e9 80 f5 ff ff       	jmp    80105aa7 <alltraps>

80106527 <vector152>:
.globl vector152
vector152:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $152
80106529:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010652e:	e9 74 f5 ff ff       	jmp    80105aa7 <alltraps>

80106533 <vector153>:
.globl vector153
vector153:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $153
80106535:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010653a:	e9 68 f5 ff ff       	jmp    80105aa7 <alltraps>

8010653f <vector154>:
.globl vector154
vector154:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $154
80106541:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106546:	e9 5c f5 ff ff       	jmp    80105aa7 <alltraps>

8010654b <vector155>:
.globl vector155
vector155:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $155
8010654d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106552:	e9 50 f5 ff ff       	jmp    80105aa7 <alltraps>

80106557 <vector156>:
.globl vector156
vector156:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $156
80106559:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010655e:	e9 44 f5 ff ff       	jmp    80105aa7 <alltraps>

80106563 <vector157>:
.globl vector157
vector157:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $157
80106565:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010656a:	e9 38 f5 ff ff       	jmp    80105aa7 <alltraps>

8010656f <vector158>:
.globl vector158
vector158:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $158
80106571:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106576:	e9 2c f5 ff ff       	jmp    80105aa7 <alltraps>

8010657b <vector159>:
.globl vector159
vector159:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $159
8010657d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106582:	e9 20 f5 ff ff       	jmp    80105aa7 <alltraps>

80106587 <vector160>:
.globl vector160
vector160:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $160
80106589:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010658e:	e9 14 f5 ff ff       	jmp    80105aa7 <alltraps>

80106593 <vector161>:
.globl vector161
vector161:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $161
80106595:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010659a:	e9 08 f5 ff ff       	jmp    80105aa7 <alltraps>

8010659f <vector162>:
.globl vector162
vector162:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $162
801065a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065a6:	e9 fc f4 ff ff       	jmp    80105aa7 <alltraps>

801065ab <vector163>:
.globl vector163
vector163:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $163
801065ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065b2:	e9 f0 f4 ff ff       	jmp    80105aa7 <alltraps>

801065b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $164
801065b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065be:	e9 e4 f4 ff ff       	jmp    80105aa7 <alltraps>

801065c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $165
801065c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ca:	e9 d8 f4 ff ff       	jmp    80105aa7 <alltraps>

801065cf <vector166>:
.globl vector166
vector166:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $166
801065d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065d6:	e9 cc f4 ff ff       	jmp    80105aa7 <alltraps>

801065db <vector167>:
.globl vector167
vector167:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $167
801065dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065e2:	e9 c0 f4 ff ff       	jmp    80105aa7 <alltraps>

801065e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $168
801065e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065ee:	e9 b4 f4 ff ff       	jmp    80105aa7 <alltraps>

801065f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $169
801065f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065fa:	e9 a8 f4 ff ff       	jmp    80105aa7 <alltraps>

801065ff <vector170>:
.globl vector170
vector170:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $170
80106601:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106606:	e9 9c f4 ff ff       	jmp    80105aa7 <alltraps>

8010660b <vector171>:
.globl vector171
vector171:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $171
8010660d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106612:	e9 90 f4 ff ff       	jmp    80105aa7 <alltraps>

80106617 <vector172>:
.globl vector172
vector172:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $172
80106619:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010661e:	e9 84 f4 ff ff       	jmp    80105aa7 <alltraps>

80106623 <vector173>:
.globl vector173
vector173:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $173
80106625:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010662a:	e9 78 f4 ff ff       	jmp    80105aa7 <alltraps>

8010662f <vector174>:
.globl vector174
vector174:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $174
80106631:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106636:	e9 6c f4 ff ff       	jmp    80105aa7 <alltraps>

8010663b <vector175>:
.globl vector175
vector175:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $175
8010663d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106642:	e9 60 f4 ff ff       	jmp    80105aa7 <alltraps>

80106647 <vector176>:
.globl vector176
vector176:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $176
80106649:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010664e:	e9 54 f4 ff ff       	jmp    80105aa7 <alltraps>

80106653 <vector177>:
.globl vector177
vector177:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $177
80106655:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010665a:	e9 48 f4 ff ff       	jmp    80105aa7 <alltraps>

8010665f <vector178>:
.globl vector178
vector178:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $178
80106661:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106666:	e9 3c f4 ff ff       	jmp    80105aa7 <alltraps>

8010666b <vector179>:
.globl vector179
vector179:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $179
8010666d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106672:	e9 30 f4 ff ff       	jmp    80105aa7 <alltraps>

80106677 <vector180>:
.globl vector180
vector180:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $180
80106679:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010667e:	e9 24 f4 ff ff       	jmp    80105aa7 <alltraps>

80106683 <vector181>:
.globl vector181
vector181:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $181
80106685:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010668a:	e9 18 f4 ff ff       	jmp    80105aa7 <alltraps>

8010668f <vector182>:
.globl vector182
vector182:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $182
80106691:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106696:	e9 0c f4 ff ff       	jmp    80105aa7 <alltraps>

8010669b <vector183>:
.globl vector183
vector183:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $183
8010669d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066a2:	e9 00 f4 ff ff       	jmp    80105aa7 <alltraps>

801066a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $184
801066a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ae:	e9 f4 f3 ff ff       	jmp    80105aa7 <alltraps>

801066b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $185
801066b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066ba:	e9 e8 f3 ff ff       	jmp    80105aa7 <alltraps>

801066bf <vector186>:
.globl vector186
vector186:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $186
801066c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066c6:	e9 dc f3 ff ff       	jmp    80105aa7 <alltraps>

801066cb <vector187>:
.globl vector187
vector187:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $187
801066cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066d2:	e9 d0 f3 ff ff       	jmp    80105aa7 <alltraps>

801066d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $188
801066d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066de:	e9 c4 f3 ff ff       	jmp    80105aa7 <alltraps>

801066e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $189
801066e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066ea:	e9 b8 f3 ff ff       	jmp    80105aa7 <alltraps>

801066ef <vector190>:
.globl vector190
vector190:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $190
801066f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066f6:	e9 ac f3 ff ff       	jmp    80105aa7 <alltraps>

801066fb <vector191>:
.globl vector191
vector191:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $191
801066fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106702:	e9 a0 f3 ff ff       	jmp    80105aa7 <alltraps>

80106707 <vector192>:
.globl vector192
vector192:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $192
80106709:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010670e:	e9 94 f3 ff ff       	jmp    80105aa7 <alltraps>

80106713 <vector193>:
.globl vector193
vector193:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $193
80106715:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010671a:	e9 88 f3 ff ff       	jmp    80105aa7 <alltraps>

8010671f <vector194>:
.globl vector194
vector194:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $194
80106721:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106726:	e9 7c f3 ff ff       	jmp    80105aa7 <alltraps>

8010672b <vector195>:
.globl vector195
vector195:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $195
8010672d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106732:	e9 70 f3 ff ff       	jmp    80105aa7 <alltraps>

80106737 <vector196>:
.globl vector196
vector196:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $196
80106739:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010673e:	e9 64 f3 ff ff       	jmp    80105aa7 <alltraps>

80106743 <vector197>:
.globl vector197
vector197:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $197
80106745:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010674a:	e9 58 f3 ff ff       	jmp    80105aa7 <alltraps>

8010674f <vector198>:
.globl vector198
vector198:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $198
80106751:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106756:	e9 4c f3 ff ff       	jmp    80105aa7 <alltraps>

8010675b <vector199>:
.globl vector199
vector199:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $199
8010675d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106762:	e9 40 f3 ff ff       	jmp    80105aa7 <alltraps>

80106767 <vector200>:
.globl vector200
vector200:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $200
80106769:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010676e:	e9 34 f3 ff ff       	jmp    80105aa7 <alltraps>

80106773 <vector201>:
.globl vector201
vector201:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $201
80106775:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010677a:	e9 28 f3 ff ff       	jmp    80105aa7 <alltraps>

8010677f <vector202>:
.globl vector202
vector202:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $202
80106781:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106786:	e9 1c f3 ff ff       	jmp    80105aa7 <alltraps>

8010678b <vector203>:
.globl vector203
vector203:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $203
8010678d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106792:	e9 10 f3 ff ff       	jmp    80105aa7 <alltraps>

80106797 <vector204>:
.globl vector204
vector204:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $204
80106799:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010679e:	e9 04 f3 ff ff       	jmp    80105aa7 <alltraps>

801067a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $205
801067a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067aa:	e9 f8 f2 ff ff       	jmp    80105aa7 <alltraps>

801067af <vector206>:
.globl vector206
vector206:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $206
801067b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067b6:	e9 ec f2 ff ff       	jmp    80105aa7 <alltraps>

801067bb <vector207>:
.globl vector207
vector207:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $207
801067bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067c2:	e9 e0 f2 ff ff       	jmp    80105aa7 <alltraps>

801067c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $208
801067c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067ce:	e9 d4 f2 ff ff       	jmp    80105aa7 <alltraps>

801067d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $209
801067d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067da:	e9 c8 f2 ff ff       	jmp    80105aa7 <alltraps>

801067df <vector210>:
.globl vector210
vector210:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $210
801067e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067e6:	e9 bc f2 ff ff       	jmp    80105aa7 <alltraps>

801067eb <vector211>:
.globl vector211
vector211:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $211
801067ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067f2:	e9 b0 f2 ff ff       	jmp    80105aa7 <alltraps>

801067f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $212
801067f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067fe:	e9 a4 f2 ff ff       	jmp    80105aa7 <alltraps>

80106803 <vector213>:
.globl vector213
vector213:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $213
80106805:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010680a:	e9 98 f2 ff ff       	jmp    80105aa7 <alltraps>

8010680f <vector214>:
.globl vector214
vector214:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $214
80106811:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106816:	e9 8c f2 ff ff       	jmp    80105aa7 <alltraps>

8010681b <vector215>:
.globl vector215
vector215:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $215
8010681d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106822:	e9 80 f2 ff ff       	jmp    80105aa7 <alltraps>

80106827 <vector216>:
.globl vector216
vector216:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $216
80106829:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010682e:	e9 74 f2 ff ff       	jmp    80105aa7 <alltraps>

80106833 <vector217>:
.globl vector217
vector217:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $217
80106835:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010683a:	e9 68 f2 ff ff       	jmp    80105aa7 <alltraps>

8010683f <vector218>:
.globl vector218
vector218:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $218
80106841:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106846:	e9 5c f2 ff ff       	jmp    80105aa7 <alltraps>

8010684b <vector219>:
.globl vector219
vector219:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $219
8010684d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106852:	e9 50 f2 ff ff       	jmp    80105aa7 <alltraps>

80106857 <vector220>:
.globl vector220
vector220:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $220
80106859:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010685e:	e9 44 f2 ff ff       	jmp    80105aa7 <alltraps>

80106863 <vector221>:
.globl vector221
vector221:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $221
80106865:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010686a:	e9 38 f2 ff ff       	jmp    80105aa7 <alltraps>

8010686f <vector222>:
.globl vector222
vector222:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $222
80106871:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106876:	e9 2c f2 ff ff       	jmp    80105aa7 <alltraps>

8010687b <vector223>:
.globl vector223
vector223:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $223
8010687d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106882:	e9 20 f2 ff ff       	jmp    80105aa7 <alltraps>

80106887 <vector224>:
.globl vector224
vector224:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $224
80106889:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010688e:	e9 14 f2 ff ff       	jmp    80105aa7 <alltraps>

80106893 <vector225>:
.globl vector225
vector225:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $225
80106895:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010689a:	e9 08 f2 ff ff       	jmp    80105aa7 <alltraps>

8010689f <vector226>:
.globl vector226
vector226:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $226
801068a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068a6:	e9 fc f1 ff ff       	jmp    80105aa7 <alltraps>

801068ab <vector227>:
.globl vector227
vector227:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $227
801068ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068b2:	e9 f0 f1 ff ff       	jmp    80105aa7 <alltraps>

801068b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $228
801068b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068be:	e9 e4 f1 ff ff       	jmp    80105aa7 <alltraps>

801068c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $229
801068c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ca:	e9 d8 f1 ff ff       	jmp    80105aa7 <alltraps>

801068cf <vector230>:
.globl vector230
vector230:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $230
801068d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068d6:	e9 cc f1 ff ff       	jmp    80105aa7 <alltraps>

801068db <vector231>:
.globl vector231
vector231:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $231
801068dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068e2:	e9 c0 f1 ff ff       	jmp    80105aa7 <alltraps>

801068e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $232
801068e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068ee:	e9 b4 f1 ff ff       	jmp    80105aa7 <alltraps>

801068f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $233
801068f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068fa:	e9 a8 f1 ff ff       	jmp    80105aa7 <alltraps>

801068ff <vector234>:
.globl vector234
vector234:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $234
80106901:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106906:	e9 9c f1 ff ff       	jmp    80105aa7 <alltraps>

8010690b <vector235>:
.globl vector235
vector235:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $235
8010690d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106912:	e9 90 f1 ff ff       	jmp    80105aa7 <alltraps>

80106917 <vector236>:
.globl vector236
vector236:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $236
80106919:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010691e:	e9 84 f1 ff ff       	jmp    80105aa7 <alltraps>

80106923 <vector237>:
.globl vector237
vector237:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $237
80106925:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010692a:	e9 78 f1 ff ff       	jmp    80105aa7 <alltraps>

8010692f <vector238>:
.globl vector238
vector238:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $238
80106931:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106936:	e9 6c f1 ff ff       	jmp    80105aa7 <alltraps>

8010693b <vector239>:
.globl vector239
vector239:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $239
8010693d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106942:	e9 60 f1 ff ff       	jmp    80105aa7 <alltraps>

80106947 <vector240>:
.globl vector240
vector240:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $240
80106949:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010694e:	e9 54 f1 ff ff       	jmp    80105aa7 <alltraps>

80106953 <vector241>:
.globl vector241
vector241:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $241
80106955:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010695a:	e9 48 f1 ff ff       	jmp    80105aa7 <alltraps>

8010695f <vector242>:
.globl vector242
vector242:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $242
80106961:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106966:	e9 3c f1 ff ff       	jmp    80105aa7 <alltraps>

8010696b <vector243>:
.globl vector243
vector243:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $243
8010696d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106972:	e9 30 f1 ff ff       	jmp    80105aa7 <alltraps>

80106977 <vector244>:
.globl vector244
vector244:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $244
80106979:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010697e:	e9 24 f1 ff ff       	jmp    80105aa7 <alltraps>

80106983 <vector245>:
.globl vector245
vector245:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $245
80106985:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010698a:	e9 18 f1 ff ff       	jmp    80105aa7 <alltraps>

8010698f <vector246>:
.globl vector246
vector246:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $246
80106991:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106996:	e9 0c f1 ff ff       	jmp    80105aa7 <alltraps>

8010699b <vector247>:
.globl vector247
vector247:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $247
8010699d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069a2:	e9 00 f1 ff ff       	jmp    80105aa7 <alltraps>

801069a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $248
801069a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ae:	e9 f4 f0 ff ff       	jmp    80105aa7 <alltraps>

801069b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $249
801069b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069ba:	e9 e8 f0 ff ff       	jmp    80105aa7 <alltraps>

801069bf <vector250>:
.globl vector250
vector250:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $250
801069c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069c6:	e9 dc f0 ff ff       	jmp    80105aa7 <alltraps>

801069cb <vector251>:
.globl vector251
vector251:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $251
801069cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069d2:	e9 d0 f0 ff ff       	jmp    80105aa7 <alltraps>

801069d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $252
801069d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069de:	e9 c4 f0 ff ff       	jmp    80105aa7 <alltraps>

801069e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $253
801069e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069ea:	e9 b8 f0 ff ff       	jmp    80105aa7 <alltraps>

801069ef <vector254>:
.globl vector254
vector254:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $254
801069f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069f6:	e9 ac f0 ff ff       	jmp    80105aa7 <alltraps>

801069fb <vector255>:
.globl vector255
vector255:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $255
801069fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a02:	e9 a0 f0 ff ff       	jmp    80105aa7 <alltraps>
80106a07:	66 90                	xchg   %ax,%ax
80106a09:	66 90                	xchg   %ax,%ax
80106a0b:	66 90                	xchg   %ax,%ax
80106a0d:	66 90                	xchg   %ax,%ax
80106a0f:	90                   	nop

80106a10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a16:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a22:	83 ec 1c             	sub    $0x1c,%esp
80106a25:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a28:	39 d3                	cmp    %edx,%ebx
80106a2a:	73 49                	jae    80106a75 <deallocuvm.part.0+0x65>
80106a2c:	89 c7                	mov    %eax,%edi
80106a2e:	eb 0c                	jmp    80106a3c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a30:	83 c0 01             	add    $0x1,%eax
80106a33:	c1 e0 16             	shl    $0x16,%eax
80106a36:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a38:	39 da                	cmp    %ebx,%edx
80106a3a:	76 39                	jbe    80106a75 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106a3c:	89 d8                	mov    %ebx,%eax
80106a3e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a41:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106a44:	f6 c1 01             	test   $0x1,%cl
80106a47:	74 e7                	je     80106a30 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106a49:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106a51:	c1 ee 0a             	shr    $0xa,%esi
80106a54:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106a5a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106a61:	85 f6                	test   %esi,%esi
80106a63:	74 cb                	je     80106a30 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106a65:	8b 06                	mov    (%esi),%eax
80106a67:	a8 01                	test   $0x1,%al
80106a69:	75 15                	jne    80106a80 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106a6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a71:	39 da                	cmp    %ebx,%edx
80106a73:	77 c7                	ja     80106a3c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7b:	5b                   	pop    %ebx
80106a7c:	5e                   	pop    %esi
80106a7d:	5f                   	pop    %edi
80106a7e:	5d                   	pop    %ebp
80106a7f:	c3                   	ret    
      if(pa == 0)
80106a80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a85:	74 25                	je     80106aac <deallocuvm.part.0+0x9c>
      kfree(v);
80106a87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a8a:	05 00 00 00 80       	add    $0x80000000,%eax
80106a8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a98:	50                   	push   %eax
80106a99:	e8 22 ba ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106a9e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106aa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106aa7:	83 c4 10             	add    $0x10,%esp
80106aaa:	eb 8c                	jmp    80106a38 <deallocuvm.part.0+0x28>
        panic("kfree");
80106aac:	83 ec 0c             	sub    $0xc,%esp
80106aaf:	68 66 76 10 80       	push   $0x80107666
80106ab4:	e8 c7 98 ff ff       	call   80100380 <panic>
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <mappages>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ac6:	89 d3                	mov    %edx,%ebx
80106ac8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ace:	83 ec 1c             	sub    $0x1c,%esp
80106ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ad4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ad8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106add:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae3:	29 d8                	sub    %ebx,%eax
80106ae5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ae8:	eb 3d                	jmp    80106b27 <mappages+0x67>
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106af0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106af2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106af7:	c1 ea 0a             	shr    $0xa,%edx
80106afa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b07:	85 c0                	test   %eax,%eax
80106b09:	74 75                	je     80106b80 <mappages+0xc0>
    if(*pte & PTE_P)
80106b0b:	f6 00 01             	testb  $0x1,(%eax)
80106b0e:	0f 85 86 00 00 00    	jne    80106b9a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b14:	0b 75 0c             	or     0xc(%ebp),%esi
80106b17:	83 ce 01             	or     $0x1,%esi
80106b1a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b1c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106b1f:	74 6f                	je     80106b90 <mappages+0xd0>
    a += PGSIZE;
80106b21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b2a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b2d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106b30:	89 d8                	mov    %ebx,%eax
80106b32:	c1 e8 16             	shr    $0x16,%eax
80106b35:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b38:	8b 07                	mov    (%edi),%eax
80106b3a:	a8 01                	test   $0x1,%al
80106b3c:	75 b2                	jne    80106af0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b3e:	e8 3d bb ff ff       	call   80102680 <kalloc>
80106b43:	85 c0                	test   %eax,%eax
80106b45:	74 39                	je     80106b80 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b47:	83 ec 04             	sub    $0x4,%esp
80106b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b4d:	68 00 10 00 00       	push   $0x1000
80106b52:	6a 00                	push   $0x0
80106b54:	50                   	push   %eax
80106b55:	e8 a6 dc ff ff       	call   80104800 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b5d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b60:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b66:	83 c8 07             	or     $0x7,%eax
80106b69:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b6b:	89 d8                	mov    %ebx,%eax
80106b6d:	c1 e8 0a             	shr    $0xa,%eax
80106b70:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b75:	01 d0                	add    %edx,%eax
80106b77:	eb 92                	jmp    80106b0b <mappages+0x4b>
80106b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b88:	5b                   	pop    %ebx
80106b89:	5e                   	pop    %esi
80106b8a:	5f                   	pop    %edi
80106b8b:	5d                   	pop    %ebp
80106b8c:	c3                   	ret    
80106b8d:	8d 76 00             	lea    0x0(%esi),%esi
80106b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b93:	31 c0                	xor    %eax,%eax
}
80106b95:	5b                   	pop    %ebx
80106b96:	5e                   	pop    %esi
80106b97:	5f                   	pop    %edi
80106b98:	5d                   	pop    %ebp
80106b99:	c3                   	ret    
      panic("remap");
80106b9a:	83 ec 0c             	sub    $0xc,%esp
80106b9d:	68 b4 7c 10 80       	push   $0x80107cb4
80106ba2:	e8 d9 97 ff ff       	call   80100380 <panic>
80106ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bae:	66 90                	xchg   %ax,%ax

80106bb0 <seginit>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bb6:	e8 95 cd ff ff       	call   80103950 <cpuid>
  pd[0] = size-1;
80106bbb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106bc0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bc6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bca:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106bd1:	ff 00 00 
80106bd4:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106bdb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bde:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106be5:	ff 00 00 
80106be8:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106bef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bf2:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106bf9:	ff 00 00 
80106bfc:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106c03:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c06:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106c0d:	ff 00 00 
80106c10:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106c17:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c1a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106c1f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c23:	c1 e8 10             	shr    $0x10,%eax
80106c26:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c2a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c2d:	0f 01 10             	lgdtl  (%eax)
}
80106c30:	c9                   	leave  
80106c31:	c3                   	ret    
80106c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c40 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c40:	a1 04 46 11 80       	mov    0x80114604,%eax
80106c45:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c4a:	0f 22 d8             	mov    %eax,%cr3
}
80106c4d:	c3                   	ret    
80106c4e:	66 90                	xchg   %ax,%ax

80106c50 <switchuvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c5c:	85 f6                	test   %esi,%esi
80106c5e:	0f 84 cb 00 00 00    	je     80106d2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106c64:	8b 46 08             	mov    0x8(%esi),%eax
80106c67:	85 c0                	test   %eax,%eax
80106c69:	0f 84 da 00 00 00    	je     80106d49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c6f:	8b 46 04             	mov    0x4(%esi),%eax
80106c72:	85 c0                	test   %eax,%eax
80106c74:	0f 84 c2 00 00 00    	je     80106d3c <switchuvm+0xec>
  pushcli();
80106c7a:	e8 71 d9 ff ff       	call   801045f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c7f:	e8 6c cc ff ff       	call   801038f0 <mycpu>
80106c84:	89 c3                	mov    %eax,%ebx
80106c86:	e8 65 cc ff ff       	call   801038f0 <mycpu>
80106c8b:	89 c7                	mov    %eax,%edi
80106c8d:	e8 5e cc ff ff       	call   801038f0 <mycpu>
80106c92:	83 c7 08             	add    $0x8,%edi
80106c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c98:	e8 53 cc ff ff       	call   801038f0 <mycpu>
80106c9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ca0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ca5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cac:	83 c0 08             	add    $0x8,%eax
80106caf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cb6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cbb:	83 c1 08             	add    $0x8,%ecx
80106cbe:	c1 e8 18             	shr    $0x18,%eax
80106cc1:	c1 e9 10             	shr    $0x10,%ecx
80106cc4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106cd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106cd5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ce1:	e8 0a cc ff ff       	call   801038f0 <mycpu>
80106ce6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ced:	e8 fe cb ff ff       	call   801038f0 <mycpu>
80106cf2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cf6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106cf9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cff:	e8 ec cb ff ff       	call   801038f0 <mycpu>
80106d04:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d07:	e8 e4 cb ff ff       	call   801038f0 <mycpu>
80106d0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d10:	b8 28 00 00 00       	mov    $0x28,%eax
80106d15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d18:	8b 46 04             	mov    0x4(%esi),%eax
80106d1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d20:	0f 22 d8             	mov    %eax,%cr3
}
80106d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d26:	5b                   	pop    %ebx
80106d27:	5e                   	pop    %esi
80106d28:	5f                   	pop    %edi
80106d29:	5d                   	pop    %ebp
  popcli();
80106d2a:	e9 11 d9 ff ff       	jmp    80104640 <popcli>
    panic("switchuvm: no process");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 ba 7c 10 80       	push   $0x80107cba
80106d37:	e8 44 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d3c:	83 ec 0c             	sub    $0xc,%esp
80106d3f:	68 e5 7c 10 80       	push   $0x80107ce5
80106d44:	e8 37 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d49:	83 ec 0c             	sub    $0xc,%esp
80106d4c:	68 d0 7c 10 80       	push   $0x80107cd0
80106d51:	e8 2a 96 ff ff       	call   80100380 <panic>
80106d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d5d:	8d 76 00             	lea    0x0(%esi),%esi

80106d60 <inituvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d6c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d6f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d75:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d7b:	77 4b                	ja     80106dc8 <inituvm+0x68>
  mem = kalloc();
80106d7d:	e8 fe b8 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106d82:	83 ec 04             	sub    $0x4,%esp
80106d85:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d8a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d8c:	6a 00                	push   $0x0
80106d8e:	50                   	push   %eax
80106d8f:	e8 6c da ff ff       	call   80104800 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d94:	58                   	pop    %eax
80106d95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d9b:	5a                   	pop    %edx
80106d9c:	6a 06                	push   $0x6
80106d9e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106da3:	31 d2                	xor    %edx,%edx
80106da5:	50                   	push   %eax
80106da6:	89 f8                	mov    %edi,%eax
80106da8:	e8 13 fd ff ff       	call   80106ac0 <mappages>
  memmove(mem, init, sz);
80106dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db0:	89 75 10             	mov    %esi,0x10(%ebp)
80106db3:	83 c4 10             	add    $0x10,%esp
80106db6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106db9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dbf:	5b                   	pop    %ebx
80106dc0:	5e                   	pop    %esi
80106dc1:	5f                   	pop    %edi
80106dc2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106dc3:	e9 d8 da ff ff       	jmp    801048a0 <memmove>
    panic("inituvm: more than a page");
80106dc8:	83 ec 0c             	sub    $0xc,%esp
80106dcb:	68 f9 7c 10 80       	push   $0x80107cf9
80106dd0:	e8 ab 95 ff ff       	call   80100380 <panic>
80106dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106de0 <loaduvm>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
80106de9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106def:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106df4:	0f 85 bb 00 00 00    	jne    80106eb5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106dfa:	01 f0                	add    %esi,%eax
80106dfc:	89 f3                	mov    %esi,%ebx
80106dfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e01:	8b 45 14             	mov    0x14(%ebp),%eax
80106e04:	01 f0                	add    %esi,%eax
80106e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e09:	85 f6                	test   %esi,%esi
80106e0b:	0f 84 87 00 00 00    	je     80106e98 <loaduvm+0xb8>
80106e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106e1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106e1e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106e20:	89 c2                	mov    %eax,%edx
80106e22:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106e25:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106e28:	f6 c2 01             	test   $0x1,%dl
80106e2b:	75 13                	jne    80106e40 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106e2d:	83 ec 0c             	sub    $0xc,%esp
80106e30:	68 13 7d 10 80       	push   $0x80107d13
80106e35:	e8 46 95 ff ff       	call   80100380 <panic>
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e40:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e43:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106e49:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e4e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e55:	85 c0                	test   %eax,%eax
80106e57:	74 d4                	je     80106e2d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106e59:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e5b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e5e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e68:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e6e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e71:	29 d9                	sub    %ebx,%ecx
80106e73:	05 00 00 00 80       	add    $0x80000000,%eax
80106e78:	57                   	push   %edi
80106e79:	51                   	push   %ecx
80106e7a:	50                   	push   %eax
80106e7b:	ff 75 10             	push   0x10(%ebp)
80106e7e:	e8 0d ac ff ff       	call   80101a90 <readi>
80106e83:	83 c4 10             	add    $0x10,%esp
80106e86:	39 f8                	cmp    %edi,%eax
80106e88:	75 1e                	jne    80106ea8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e8a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e90:	89 f0                	mov    %esi,%eax
80106e92:	29 d8                	sub    %ebx,%eax
80106e94:	39 c6                	cmp    %eax,%esi
80106e96:	77 80                	ja     80106e18 <loaduvm+0x38>
}
80106e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e9b:	31 c0                	xor    %eax,%eax
}
80106e9d:	5b                   	pop    %ebx
80106e9e:	5e                   	pop    %esi
80106e9f:	5f                   	pop    %edi
80106ea0:	5d                   	pop    %ebp
80106ea1:	c3                   	ret    
80106ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106eb0:	5b                   	pop    %ebx
80106eb1:	5e                   	pop    %esi
80106eb2:	5f                   	pop    %edi
80106eb3:	5d                   	pop    %ebp
80106eb4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106eb5:	83 ec 0c             	sub    $0xc,%esp
80106eb8:	68 b4 7d 10 80       	push   $0x80107db4
80106ebd:	e8 be 94 ff ff       	call   80100380 <panic>
80106ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <allocuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ed9:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106edc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106edf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ee2:	85 c0                	test   %eax,%eax
80106ee4:	0f 88 b6 00 00 00    	js     80106fa0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106eea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106ef0:	0f 82 9a 00 00 00    	jb     80106f90 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106ef6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106efc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f02:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f05:	77 44                	ja     80106f4b <allocuvm+0x7b>
80106f07:	e9 87 00 00 00       	jmp    80106f93 <allocuvm+0xc3>
80106f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f10:	83 ec 04             	sub    $0x4,%esp
80106f13:	68 00 10 00 00       	push   $0x1000
80106f18:	6a 00                	push   $0x0
80106f1a:	50                   	push   %eax
80106f1b:	e8 e0 d8 ff ff       	call   80104800 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f20:	58                   	pop    %eax
80106f21:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f27:	5a                   	pop    %edx
80106f28:	6a 06                	push   $0x6
80106f2a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f2f:	89 f2                	mov    %esi,%edx
80106f31:	50                   	push   %eax
80106f32:	89 f8                	mov    %edi,%eax
80106f34:	e8 87 fb ff ff       	call   80106ac0 <mappages>
80106f39:	83 c4 10             	add    $0x10,%esp
80106f3c:	85 c0                	test   %eax,%eax
80106f3e:	78 78                	js     80106fb8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f40:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f46:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f49:	76 48                	jbe    80106f93 <allocuvm+0xc3>
    mem = kalloc();
80106f4b:	e8 30 b7 ff ff       	call   80102680 <kalloc>
80106f50:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f52:	85 c0                	test   %eax,%eax
80106f54:	75 ba                	jne    80106f10 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f56:	83 ec 0c             	sub    $0xc,%esp
80106f59:	68 31 7d 10 80       	push   $0x80107d31
80106f5e:	e8 3d 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106f63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f66:	83 c4 10             	add    $0x10,%esp
80106f69:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f6c:	74 32                	je     80106fa0 <allocuvm+0xd0>
80106f6e:	8b 55 10             	mov    0x10(%ebp),%edx
80106f71:	89 c1                	mov    %eax,%ecx
80106f73:	89 f8                	mov    %edi,%eax
80106f75:	e8 96 fa ff ff       	call   80106a10 <deallocuvm.part.0>
      return 0;
80106f7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f87:	5b                   	pop    %ebx
80106f88:	5e                   	pop    %esi
80106f89:	5f                   	pop    %edi
80106f8a:	5d                   	pop    %ebp
80106f8b:	c3                   	ret    
80106f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f99:	5b                   	pop    %ebx
80106f9a:	5e                   	pop    %esi
80106f9b:	5f                   	pop    %edi
80106f9c:	5d                   	pop    %ebp
80106f9d:	c3                   	ret    
80106f9e:	66 90                	xchg   %ax,%ax
    return 0;
80106fa0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fad:	5b                   	pop    %ebx
80106fae:	5e                   	pop    %esi
80106faf:	5f                   	pop    %edi
80106fb0:	5d                   	pop    %ebp
80106fb1:	c3                   	ret    
80106fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fb8:	83 ec 0c             	sub    $0xc,%esp
80106fbb:	68 49 7d 10 80       	push   $0x80107d49
80106fc0:	e8 db 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fc8:	83 c4 10             	add    $0x10,%esp
80106fcb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fce:	74 0c                	je     80106fdc <allocuvm+0x10c>
80106fd0:	8b 55 10             	mov    0x10(%ebp),%edx
80106fd3:	89 c1                	mov    %eax,%ecx
80106fd5:	89 f8                	mov    %edi,%eax
80106fd7:	e8 34 fa ff ff       	call   80106a10 <deallocuvm.part.0>
      kfree(mem);
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	53                   	push   %ebx
80106fe0:	e8 db b4 ff ff       	call   801024c0 <kfree>
      return 0;
80106fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106fec:	83 c4 10             	add    $0x10,%esp
}
80106fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107000 <deallocuvm>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	8b 55 0c             	mov    0xc(%ebp),%edx
80107006:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107009:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010700c:	39 d1                	cmp    %edx,%ecx
8010700e:	73 10                	jae    80107020 <deallocuvm+0x20>
}
80107010:	5d                   	pop    %ebp
80107011:	e9 fa f9 ff ff       	jmp    80106a10 <deallocuvm.part.0>
80107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
80107020:	89 d0                	mov    %edx,%eax
80107022:	5d                   	pop    %ebp
80107023:	c3                   	ret    
80107024:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010702f:	90                   	nop

80107030 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 0c             	sub    $0xc,%esp
80107039:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010703c:	85 f6                	test   %esi,%esi
8010703e:	74 59                	je     80107099 <freevm+0x69>
  if(newsz >= oldsz)
80107040:	31 c9                	xor    %ecx,%ecx
80107042:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107047:	89 f0                	mov    %esi,%eax
80107049:	89 f3                	mov    %esi,%ebx
8010704b:	e8 c0 f9 ff ff       	call   80106a10 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107050:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107056:	eb 0f                	jmp    80107067 <freevm+0x37>
80107058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop
80107060:	83 c3 04             	add    $0x4,%ebx
80107063:	39 df                	cmp    %ebx,%edi
80107065:	74 23                	je     8010708a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107067:	8b 03                	mov    (%ebx),%eax
80107069:	a8 01                	test   $0x1,%al
8010706b:	74 f3                	je     80107060 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010706d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107072:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107075:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107078:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010707d:	50                   	push   %eax
8010707e:	e8 3d b4 ff ff       	call   801024c0 <kfree>
80107083:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107086:	39 df                	cmp    %ebx,%edi
80107088:	75 dd                	jne    80107067 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010708a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010708d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107090:	5b                   	pop    %ebx
80107091:	5e                   	pop    %esi
80107092:	5f                   	pop    %edi
80107093:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107094:	e9 27 b4 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107099:	83 ec 0c             	sub    $0xc,%esp
8010709c:	68 65 7d 10 80       	push   $0x80107d65
801070a1:	e8 da 92 ff ff       	call   80100380 <panic>
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi

801070b0 <setupkvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	56                   	push   %esi
801070b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070b5:	e8 c6 b5 ff ff       	call   80102680 <kalloc>
801070ba:	89 c6                	mov    %eax,%esi
801070bc:	85 c0                	test   %eax,%eax
801070be:	74 42                	je     80107102 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801070c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070c3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070c8:	68 00 10 00 00       	push   $0x1000
801070cd:	6a 00                	push   $0x0
801070cf:	50                   	push   %eax
801070d0:	e8 2b d7 ff ff       	call   80104800 <memset>
801070d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070db:	83 ec 08             	sub    $0x8,%esp
801070de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070e1:	ff 73 0c             	push   0xc(%ebx)
801070e4:	8b 13                	mov    (%ebx),%edx
801070e6:	50                   	push   %eax
801070e7:	29 c1                	sub    %eax,%ecx
801070e9:	89 f0                	mov    %esi,%eax
801070eb:	e8 d0 f9 ff ff       	call   80106ac0 <mappages>
801070f0:	83 c4 10             	add    $0x10,%esp
801070f3:	85 c0                	test   %eax,%eax
801070f5:	78 19                	js     80107110 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070f7:	83 c3 10             	add    $0x10,%ebx
801070fa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107100:	75 d6                	jne    801070d8 <setupkvm+0x28>
}
80107102:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107105:	89 f0                	mov    %esi,%eax
80107107:	5b                   	pop    %ebx
80107108:	5e                   	pop    %esi
80107109:	5d                   	pop    %ebp
8010710a:	c3                   	ret    
8010710b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010710f:	90                   	nop
      freevm(pgdir);
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	56                   	push   %esi
      return 0;
80107114:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107116:	e8 15 ff ff ff       	call   80107030 <freevm>
      return 0;
8010711b:	83 c4 10             	add    $0x10,%esp
}
8010711e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107121:	89 f0                	mov    %esi,%eax
80107123:	5b                   	pop    %ebx
80107124:	5e                   	pop    %esi
80107125:	5d                   	pop    %ebp
80107126:	c3                   	ret    
80107127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712e:	66 90                	xchg   %ax,%ax

80107130 <kvmalloc>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107136:	e8 75 ff ff ff       	call   801070b0 <setupkvm>
8010713b:	a3 04 46 11 80       	mov    %eax,0x80114604
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107140:	05 00 00 00 80       	add    $0x80000000,%eax
80107145:	0f 22 d8             	mov    %eax,%cr3
}
80107148:	c9                   	leave  
80107149:	c3                   	ret    
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107150 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	83 ec 08             	sub    $0x8,%esp
80107156:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107159:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010715c:	89 c1                	mov    %eax,%ecx
8010715e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107161:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107164:	f6 c2 01             	test   $0x1,%dl
80107167:	75 17                	jne    80107180 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	68 76 7d 10 80       	push   $0x80107d76
80107171:	e8 0a 92 ff ff       	call   80100380 <panic>
80107176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107180:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107183:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107189:	25 fc 0f 00 00       	and    $0xffc,%eax
8010718e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107195:	85 c0                	test   %eax,%eax
80107197:	74 d0                	je     80107169 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107199:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010719c:	c9                   	leave  
8010719d:	c3                   	ret    
8010719e:	66 90                	xchg   %ax,%ax

801071a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071a9:	e8 02 ff ff ff       	call   801070b0 <setupkvm>
801071ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071b1:	85 c0                	test   %eax,%eax
801071b3:	0f 84 bd 00 00 00    	je     80107276 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071bc:	85 c9                	test   %ecx,%ecx
801071be:	0f 84 b2 00 00 00    	je     80107276 <copyuvm+0xd6>
801071c4:	31 f6                	xor    %esi,%esi
801071c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801071d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801071d3:	89 f0                	mov    %esi,%eax
801071d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801071db:	a8 01                	test   $0x1,%al
801071dd:	75 11                	jne    801071f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071df:	83 ec 0c             	sub    $0xc,%esp
801071e2:	68 80 7d 10 80       	push   $0x80107d80
801071e7:	e8 94 91 ff ff       	call   80100380 <panic>
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801071f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071f7:	c1 ea 0a             	shr    $0xa,%edx
801071fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107200:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107207:	85 c0                	test   %eax,%eax
80107209:	74 d4                	je     801071df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010720b:	8b 00                	mov    (%eax),%eax
8010720d:	a8 01                	test   $0x1,%al
8010720f:	0f 84 9f 00 00 00    	je     801072b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107215:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107217:	25 ff 0f 00 00       	and    $0xfff,%eax
8010721c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010721f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107225:	e8 56 b4 ff ff       	call   80102680 <kalloc>
8010722a:	89 c3                	mov    %eax,%ebx
8010722c:	85 c0                	test   %eax,%eax
8010722e:	74 64                	je     80107294 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107230:	83 ec 04             	sub    $0x4,%esp
80107233:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107239:	68 00 10 00 00       	push   $0x1000
8010723e:	57                   	push   %edi
8010723f:	50                   	push   %eax
80107240:	e8 5b d6 ff ff       	call   801048a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107245:	58                   	pop    %eax
80107246:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010724c:	5a                   	pop    %edx
8010724d:	ff 75 e4             	push   -0x1c(%ebp)
80107250:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107255:	89 f2                	mov    %esi,%edx
80107257:	50                   	push   %eax
80107258:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010725b:	e8 60 f8 ff ff       	call   80106ac0 <mappages>
80107260:	83 c4 10             	add    $0x10,%esp
80107263:	85 c0                	test   %eax,%eax
80107265:	78 21                	js     80107288 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107267:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010726d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107270:	0f 87 5a ff ff ff    	ja     801071d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107276:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107279:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010727c:	5b                   	pop    %ebx
8010727d:	5e                   	pop    %esi
8010727e:	5f                   	pop    %edi
8010727f:	5d                   	pop    %ebp
80107280:	c3                   	ret    
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	53                   	push   %ebx
8010728c:	e8 2f b2 ff ff       	call   801024c0 <kfree>
      goto bad;
80107291:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107294:	83 ec 0c             	sub    $0xc,%esp
80107297:	ff 75 e0             	push   -0x20(%ebp)
8010729a:	e8 91 fd ff ff       	call   80107030 <freevm>
  return 0;
8010729f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801072a6:	83 c4 10             	add    $0x10,%esp
}
801072a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072af:	5b                   	pop    %ebx
801072b0:	5e                   	pop    %esi
801072b1:	5f                   	pop    %edi
801072b2:	5d                   	pop    %ebp
801072b3:	c3                   	ret    
      panic("copyuvm: page not present");
801072b4:	83 ec 0c             	sub    $0xc,%esp
801072b7:	68 9a 7d 10 80       	push   $0x80107d9a
801072bc:	e8 bf 90 ff ff       	call   80100380 <panic>
801072c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072cf:	90                   	nop

801072d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072d9:	89 c1                	mov    %eax,%ecx
801072db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072e1:	f6 c2 01             	test   $0x1,%dl
801072e4:	0f 84 00 01 00 00    	je     801073ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801072ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801072f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801072f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107300:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107302:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107307:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010730a:	05 00 00 00 80       	add    $0x80000000,%eax
8010730f:	83 fa 05             	cmp    $0x5,%edx
80107312:	ba 00 00 00 00       	mov    $0x0,%edx
80107317:	0f 45 c2             	cmovne %edx,%eax
}
8010731a:	c3                   	ret    
8010731b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010731f:	90                   	nop

80107320 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 14             	mov    0x14(%ebp),%esi
8010732c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010732f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107332:	85 f6                	test   %esi,%esi
80107334:	75 51                	jne    80107387 <copyout+0x67>
80107336:	e9 a5 00 00 00       	jmp    801073e0 <copyout+0xc0>
8010733b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107340:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107346:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010734c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107352:	74 75                	je     801073c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107354:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107356:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107359:	29 c3                	sub    %eax,%ebx
8010735b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107361:	39 f3                	cmp    %esi,%ebx
80107363:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107366:	29 f8                	sub    %edi,%eax
80107368:	83 ec 04             	sub    $0x4,%esp
8010736b:	01 c1                	add    %eax,%ecx
8010736d:	53                   	push   %ebx
8010736e:	52                   	push   %edx
8010736f:	51                   	push   %ecx
80107370:	e8 2b d5 ff ff       	call   801048a0 <memmove>
    len -= n;
    buf += n;
80107375:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107378:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010737e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107381:	01 da                	add    %ebx,%edx
  while(len > 0){
80107383:	29 de                	sub    %ebx,%esi
80107385:	74 59                	je     801073e0 <copyout+0xc0>
  if(*pde & PTE_P){
80107387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010738a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010738c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010738e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107391:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107397:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010739a:	f6 c1 01             	test   $0x1,%cl
8010739d:	0f 84 4e 00 00 00    	je     801073f1 <copyout.cold>
  return &pgtab[PTX(va)];
801073a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801073ab:	c1 eb 0c             	shr    $0xc,%ebx
801073ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801073b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801073bb:	89 d9                	mov    %ebx,%ecx
801073bd:	83 e1 05             	and    $0x5,%ecx
801073c0:	83 f9 05             	cmp    $0x5,%ecx
801073c3:	0f 84 77 ff ff ff    	je     80107340 <copyout+0x20>
  }
  return 0;
}
801073c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073d1:	5b                   	pop    %ebx
801073d2:	5e                   	pop    %esi
801073d3:	5f                   	pop    %edi
801073d4:	5d                   	pop    %ebp
801073d5:	c3                   	ret    
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073e3:	31 c0                	xor    %eax,%eax
}
801073e5:	5b                   	pop    %ebx
801073e6:	5e                   	pop    %esi
801073e7:	5f                   	pop    %edi
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    

801073ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801073ea:	a1 00 00 00 00       	mov    0x0,%eax
801073ef:	0f 0b                	ud2    

801073f1 <copyout.cold>:
801073f1:	a1 00 00 00 00       	mov    0x0,%eax
801073f6:	0f 0b                	ud2    
