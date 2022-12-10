
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc b0 fd 12 80       	mov    $0x8012fdb0,%esp
8010002d:	b8 20 35 10 80       	mov    $0x80103520,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 78 10 80       	push   $0x80107860
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 48 00 00       	call   80104940 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
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
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 78 10 80       	push   $0x80107867
80100097:	50                   	push   %eax
80100098:	e8 73 47 00 00       	call   80104810 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 27 4a 00 00       	call   80104b10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 49 49 00 00       	call   80104ab0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 46 00 00       	call   80104850 <acquiresleep>
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
8010018c:	e8 0f 26 00 00       	call   801027a0 <iderw>
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
801001a1:	68 6e 78 10 80       	push   $0x8010786e
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
801001be:	e8 2d 47 00 00       	call   801048f0 <holdingsleep>
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
801001d4:	e9 c7 25 00 00       	jmp    801027a0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 78 10 80       	push   $0x8010787f
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
801001ff:	e8 ec 46 00 00       	call   801048f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 46 00 00       	call   801048b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 48 00 00       	call   80104b10 <acquire>
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
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 48 00 00       	jmp    80104ab0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 78 10 80       	push   $0x80107886
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
80100294:	e8 87 1a 00 00       	call   80101d20 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 01 11 80 	movl   $0x80110140,(%esp)
801002a0:	e8 6b 48 00 00       	call   80104b10 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
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
801002c3:	68 40 01 11 80       	push   $0x80110140
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 2e 42 00 00       	call   80104500 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 3b 00 00       	call   80103e30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 01 11 80       	push   $0x80110140
801002f6:	e8 b5 47 00 00       	call   80104ab0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 3c 19 00 00       	call   80101c40 <ilock>
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
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
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
80100347:	68 40 01 11 80       	push   $0x80110140
8010034c:	e8 5f 47 00 00       	call   80104ab0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 e6 18 00 00       	call   80101c40 <ilock>
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
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
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
80100389:	c7 05 74 01 11 80 00 	movl   $0x0,0x80110174
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 12 2a 00 00       	call   80102db0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 78 10 80       	push   $0x8010788d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 23 82 10 80 	movl   $0x80108223,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 45 00 00       	call   80104960 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 78 10 80       	push   $0x801078a1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 01 11 80 01 	movl   $0x1,0x80110178
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
8010041a:	e8 61 5f 00 00       	call   80106380 <uartputc>
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
80100505:	e8 76 5e 00 00       	call   80106380 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 5e 00 00       	call   80106380 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 5e 00 00       	call   80106380 <uartputc>
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
80100551:	e8 1a 47 00 00       	call   80104c70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 46 00 00       	call   80104bd0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 a5 78 10 80       	push   $0x801078a5
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
8010059f:	e8 7c 17 00 00       	call   80101d20 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 40 01 11 80 	movl   $0x80110140,(%esp)
801005ab:	e8 60 45 00 00       	call   80104b10 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 78 01 11 80    	mov    0x80110178,%edx
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
801005df:	68 40 01 11 80       	push   $0x80110140
801005e4:	e8 c7 44 00 00       	call   80104ab0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 4e 16 00 00       	call   80101c40 <ilock>

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
80100636:	0f b6 92 08 79 10 80 	movzbl -0x7fef86f8(%edx),%edx
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
80100662:	8b 15 78 01 11 80    	mov    0x80110178,%edx
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
801006a9:	a1 74 01 11 80       	mov    0x80110174,%eax
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
80100760:	8b 15 78 01 11 80    	mov    0x80110178,%edx
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
801007a8:	8b 0d 78 01 11 80    	mov    0x80110178,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 78 01 11 80       	mov    0x80110178,%eax
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
801007e3:	68 40 01 11 80       	push   $0x80110140
801007e8:	e8 23 43 00 00       	call   80104b10 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 78 01 11 80    	mov    0x80110178,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 78 01 11 80    	mov    0x80110178,%edx
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
80100838:	bf b8 78 10 80       	mov    $0x801078b8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 01 11 80       	push   $0x80110140
8010085b:	e8 50 42 00 00       	call   80104ab0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 bf 78 10 80       	push   $0x801078bf
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <delete_numbers_in_current_line>:
void delete_numbers_in_current_line(){
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
80100885:	53                   	push   %ebx
80100886:	83 ec 7c             	sub    $0x7c,%esp
  for(int i = input.w ; i < input.e ; i++){                       // read last command from buffer and omit numbers, then save it into ((temp_buff))
80100889:	8b 1d 04 ff 10 80    	mov    0x8010ff04,%ebx
8010088f:	3b 1d 08 ff 10 80    	cmp    0x8010ff08,%ebx
80100895:	0f 83 93 00 00 00    	jae    8010092e <delete_numbers_in_current_line+0xae>
  int pointer = 0;
8010089b:	31 f6                	xor    %esi,%esi
    char temp = input.buf[i];                       
8010089d:	0f b6 83 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%eax
    if(!(temp >= 48 && temp <= 57)){
801008a4:	8d 50 d0             	lea    -0x30(%eax),%edx
801008a7:	80 fa 09             	cmp    $0x9,%dl
801008aa:	76 07                	jbe    801008b3 <delete_numbers_in_current_line+0x33>
      temp_buff[pointer] = temp;
801008ac:	88 44 35 84          	mov    %al,-0x7c(%ebp,%esi,1)
      pointer++;
801008b0:	83 c6 01             	add    $0x1,%esi
  if(panicked){
801008b3:	8b 15 78 01 11 80    	mov    0x80110178,%edx
    input.buf[i] = 0;
801008b9:	c6 83 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%ebx)
  if(panicked){
801008c0:	85 d2                	test   %edx,%edx
801008c2:	74 0c                	je     801008d0 <delete_numbers_in_current_line+0x50>
801008c4:	fa                   	cli    
    for(;;)
801008c5:	eb fe                	jmp    801008c5 <delete_numbers_in_current_line+0x45>
801008c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008ce:	66 90                	xchg   %ax,%ax
801008d0:	b8 00 01 00 00       	mov    $0x100,%eax
  for(int i = input.w ; i < input.e ; i++){                       // read last command from buffer and omit numbers, then save it into ((temp_buff))
801008d5:	83 c3 01             	add    $0x1,%ebx
801008d8:	e8 23 fb ff ff       	call   80100400 <consputc.part.0>
801008dd:	39 1d 08 ff 10 80    	cmp    %ebx,0x8010ff08
801008e3:	77 b8                	ja     8010089d <delete_numbers_in_current_line+0x1d>
  input.e = input.w;
801008e5:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801008ea:	8d 7d 84             	lea    -0x7c(%ebp),%edi
801008ed:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801008f0:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  for(int i = 0 ; i < pointer ; i++){
801008f5:	85 f6                	test   %esi,%esi
801008f7:	74 3b                	je     80100934 <delete_numbers_in_current_line+0xb4>
    input.buf[input.e] = temp_buff[i];                            // put temp_buff in buffer and print it on the console
801008f9:	0f b6 17             	movzbl (%edi),%edx
801008fc:	88 90 80 fe 10 80    	mov    %dl,-0x7fef0180(%eax)
  if(panicked){
80100902:	a1 78 01 11 80       	mov    0x80110178,%eax
80100907:	85 c0                	test   %eax,%eax
80100909:	74 05                	je     80100910 <delete_numbers_in_current_line+0x90>
8010090b:	fa                   	cli    
    for(;;)
8010090c:	eb fe                	jmp    8010090c <delete_numbers_in_current_line+0x8c>
8010090e:	66 90                	xchg   %ax,%ax
    consputc(temp_buff[i]);
80100910:	0f be c2             	movsbl %dl,%eax
  for(int i = 0 ; i < pointer ; i++){
80100913:	83 c7 01             	add    $0x1,%edi
80100916:	e8 e5 fa ff ff       	call   80100400 <consputc.part.0>
    input.e++;
8010091b:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100920:	83 c0 01             	add    $0x1,%eax
80100923:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  for(int i = 0 ; i < pointer ; i++){
80100928:	39 fb                	cmp    %edi,%ebx
8010092a:	75 cd                	jne    801008f9 <delete_numbers_in_current_line+0x79>
8010092c:	eb 06                	jmp    80100934 <delete_numbers_in_current_line+0xb4>
  input.e = input.w;
8010092e:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
}
80100934:	83 c4 7c             	add    $0x7c,%esp
80100937:	5b                   	pop    %ebx
80100938:	5e                   	pop    %esi
80100939:	5f                   	pop    %edi
8010093a:	5d                   	pop    %ebp
8010093b:	c3                   	ret    
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100940 <reverse_row>:
void reverse_row(){
80100940:	55                   	push   %ebp
80100941:	89 e5                	mov    %esp,%ebp
80100943:	57                   	push   %edi
80100944:	56                   	push   %esi
80100945:	53                   	push   %ebx
80100946:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  for(int i = input.w ; i < input.e ; i++){                         // read last command from buffer and save it into ((temp_buff))
8010094c:	8b 1d 04 ff 10 80    	mov    0x8010ff04,%ebx
80100952:	3b 1d 08 ff 10 80    	cmp    0x8010ff08,%ebx
80100958:	0f 83 a3 00 00 00    	jae    80100a01 <reverse_row+0xc1>
  int counter = 0;
8010095e:	31 f6                	xor    %esi,%esi
    char temp = input.buf[i];
80100960:	0f b6 bb 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%edi
  if(panicked){
80100967:	8b 0d 78 01 11 80    	mov    0x80110178,%ecx
8010096d:	89 f2                	mov    %esi,%edx
    input.buf[i] = 0;
8010096f:	c6 83 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%ebx)
    temp_buff[counter] = temp;
80100976:	89 f8                	mov    %edi,%eax
80100978:	88 44 35 84          	mov    %al,-0x7c(%ebp,%esi,1)
    counter++;
8010097c:	83 c6 01             	add    $0x1,%esi
  if(panicked){
8010097f:	85 c9                	test   %ecx,%ecx
80100981:	74 0d                	je     80100990 <reverse_row+0x50>
80100983:	fa                   	cli    
    for(;;)
80100984:	eb fe                	jmp    80100984 <reverse_row+0x44>
80100986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010098d:	8d 76 00             	lea    0x0(%esi),%esi
80100990:	b8 00 01 00 00       	mov    $0x100,%eax
80100995:	89 95 74 ff ff ff    	mov    %edx,-0x8c(%ebp)
  for(int i = input.w ; i < input.e ; i++){                         // read last command from buffer and save it into ((temp_buff))
8010099b:	83 c3 01             	add    $0x1,%ebx
8010099e:	e8 5d fa ff ff       	call   80100400 <consputc.part.0>
801009a3:	39 1d 08 ff 10 80    	cmp    %ebx,0x8010ff08
801009a9:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
801009af:	77 af                	ja     80100960 <reverse_row+0x20>
  input.e = input.w;
801009b1:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801009b6:	8d 74 15 83          	lea    -0x7d(%ebp,%edx,1),%esi
801009ba:	8d 5d 83             	lea    -0x7d(%ebp),%ebx
801009bd:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
    input.buf[input.e] = temp_buff[i];
801009c2:	89 f9                	mov    %edi,%ecx
801009c4:	88 88 80 fe 10 80    	mov    %cl,-0x7fef0180(%eax)
  if(panicked){
801009ca:	a1 78 01 11 80       	mov    0x80110178,%eax
801009cf:	85 c0                	test   %eax,%eax
801009d1:	74 0d                	je     801009e0 <reverse_row+0xa0>
801009d3:	fa                   	cli    
    for(;;)
801009d4:	eb fe                	jmp    801009d4 <reverse_row+0x94>
801009d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009dd:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(temp_buff[i]);
801009e0:	0f be c1             	movsbl %cl,%eax
801009e3:	e8 18 fa ff ff       	call   80100400 <consputc.part.0>
    input.e++;
801009e8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009ed:	83 c0 01             	add    $0x1,%eax
801009f0:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  for(int i = counter - 1 ; i >= 0 ; i--){                          // put temp_buff reversly in buffer and print it on the console
801009f5:	39 de                	cmp    %ebx,%esi
801009f7:	74 0e                	je     80100a07 <reverse_row+0xc7>
    input.buf[input.e] = temp_buff[i];
801009f9:	0f b6 3e             	movzbl (%esi),%edi
801009fc:	83 ee 01             	sub    $0x1,%esi
801009ff:	eb c1                	jmp    801009c2 <reverse_row+0x82>
  input.e = input.w;
80100a01:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
}
80100a07:	81 c4 8c 00 00 00    	add    $0x8c,%esp
80100a0d:	5b                   	pop    %ebx
80100a0e:	5e                   	pop    %esi
80100a0f:	5f                   	pop    %edi
80100a10:	5d                   	pop    %ebp
80100a11:	c3                   	ret    
80100a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100a20 <save_command>:
void save_command(char buffer[] , int buffer_size){                 
80100a20:	55                   	push   %ebp
  commands_size[command_pointer % 15] = buffer_size - 1;
80100a21:	ba 89 88 88 88       	mov    $0x88888889,%edx
  for(int i = input.w ; i < input.e ; i++){
80100a26:	8b 0d 04 ff 10 80    	mov    0x8010ff04,%ecx
void save_command(char buffer[] , int buffer_size){                 
80100a2c:	89 e5                	mov    %esp,%ebp
80100a2e:	57                   	push   %edi
80100a2f:	56                   	push   %esi
  for(int i = input.w ; i < input.e ; i++){
80100a30:	8b 35 08 ff 10 80    	mov    0x8010ff08,%esi
void save_command(char buffer[] , int buffer_size){                 
80100a36:	53                   	push   %ebx
  commands_size[command_pointer % 15] = buffer_size - 1;
80100a37:	8b 1d 0c ff 10 80    	mov    0x8010ff0c,%ebx
80100a3d:	89 d8                	mov    %ebx,%eax
80100a3f:	f7 ea                	imul   %edx
80100a41:	89 d8                	mov    %ebx,%eax
80100a43:	c1 f8 1f             	sar    $0x1f,%eax
80100a46:	01 da                	add    %ebx,%edx
80100a48:	c1 fa 03             	sar    $0x3,%edx
80100a4b:	89 d7                	mov    %edx,%edi
80100a4d:	89 da                	mov    %ebx,%edx
80100a4f:	29 c7                	sub    %eax,%edi
80100a51:	89 f8                	mov    %edi,%eax
80100a53:	c1 e0 04             	shl    $0x4,%eax
80100a56:	29 f8                	sub    %edi,%eax
80100a58:	29 c2                	sub    %eax,%edx
80100a5a:	89 d7                	mov    %edx,%edi
  for(int i = input.w ; i < input.e ; i++){
80100a5c:	39 f1                	cmp    %esi,%ecx
80100a5e:	73 28                	jae    80100a88 <save_command+0x68>
80100a60:	8b 45 08             	mov    0x8(%ebp),%eax
80100a63:	03 75 08             	add    0x8(%ebp),%esi
80100a66:	01 c8                	add    %ecx,%eax
80100a68:	6b ca 1e             	imul   $0x1e,%edx,%ecx
80100a6b:	81 c1 60 ff 10 80    	add    $0x8010ff60,%ecx
80100a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    last_commands[command_pointer %15][counter] = buffer[i];
80100a78:	0f b6 10             	movzbl (%eax),%edx
  for(int i = input.w ; i < input.e ; i++){
80100a7b:	83 c0 01             	add    $0x1,%eax
80100a7e:	83 c1 01             	add    $0x1,%ecx
    last_commands[command_pointer %15][counter] = buffer[i];
80100a81:	88 51 ff             	mov    %dl,-0x1(%ecx)
  for(int i = input.w ; i < input.e ; i++){
80100a84:	39 f0                	cmp    %esi,%eax
80100a86:	75 f0                	jne    80100a78 <save_command+0x58>
  commands_size[command_pointer % 15] = buffer_size - 1;
80100a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  command_pointer += 1;
80100a8b:	83 c3 01             	add    $0x1,%ebx
80100a8e:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
}
80100a94:	5b                   	pop    %ebx
  commands_size[command_pointer % 15] = buffer_size - 1;
80100a95:	83 e8 01             	sub    $0x1,%eax
}
80100a98:	5e                   	pop    %esi
  commands_size[command_pointer % 15] = buffer_size - 1;
80100a99:	89 04 bd 20 ff 10 80 	mov    %eax,-0x7fef00e0(,%edi,4)
}
80100aa0:	5f                   	pop    %edi
80100aa1:	5d                   	pop    %ebp
80100aa2:	c3                   	ret    
80100aa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ab0 <recommend_command>:
void recommend_command(){
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  for(int i = input.w ; i < input.e ; i++){
80100abc:	8b 1d 04 ff 10 80    	mov    0x8010ff04,%ebx
80100ac2:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
80100ac8:	89 9d 6c ff ff ff    	mov    %ebx,-0x94(%ebp)
80100ace:	39 cb                	cmp    %ecx,%ebx
80100ad0:	73 48                	jae    80100b1a <recommend_command+0x6a>
80100ad2:	8d 75 84             	lea    -0x7c(%ebp),%esi
    current_buff[counter] = input.buf[i];
80100ad5:	29 de                	sub    %ebx,%esi
80100ad7:	0f b6 83 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%eax
  if(panicked){
80100ade:	8b 3d 78 01 11 80    	mov    0x80110178,%edi
    input.buf[i] = 0;
80100ae4:	c6 83 80 fe 10 80 00 	movb   $0x0,-0x7fef0180(%ebx)
    current_buff[counter] = input.buf[i];
80100aeb:	88 04 1e             	mov    %al,(%esi,%ebx,1)
  if(panicked){
80100aee:	85 ff                	test   %edi,%edi
80100af0:	74 06                	je     80100af8 <recommend_command+0x48>
80100af2:	fa                   	cli    
    for(;;)
80100af3:	eb fe                	jmp    80100af3 <recommend_command+0x43>
80100af5:	8d 76 00             	lea    0x0(%esi),%esi
80100af8:	b8 00 01 00 00       	mov    $0x100,%eax
  for(int i = input.w ; i < input.e ; i++){
80100afd:	83 c3 01             	add    $0x1,%ebx
80100b00:	e8 fb f8 ff ff       	call   80100400 <consputc.part.0>
80100b05:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
80100b0b:	39 d9                	cmp    %ebx,%ecx
80100b0d:	77 c8                	ja     80100ad7 <recommend_command+0x27>
  int current_buff_size = input.e - input.w;
80100b0f:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80100b14:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
80100b1a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  for(i = (command_pointer % 15) - 1; i >= 0 ; i--){
80100b20:	ba 89 88 88 88       	mov    $0x88888889,%edx
  int current_buff_size = input.e - input.w;
80100b25:	29 c1                	sub    %eax,%ecx
  input.e = input.w;
80100b27:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  for(i = (command_pointer % 15) - 1; i >= 0 ; i--){
80100b2c:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100b31:	89 c7                	mov    %eax,%edi
80100b33:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
80100b39:	f7 ea                	imul   %edx
80100b3b:	89 f8                	mov    %edi,%eax
80100b3d:	c1 f8 1f             	sar    $0x1f,%eax
80100b40:	01 fa                	add    %edi,%edx
80100b42:	c1 fa 03             	sar    $0x3,%edx
80100b45:	29 c2                	sub    %eax,%edx
80100b47:	89 d0                	mov    %edx,%eax
80100b49:	c1 e0 04             	shl    $0x4,%eax
80100b4c:	29 d0                	sub    %edx,%eax
80100b4e:	29 c7                	sub    %eax,%edi
80100b50:	89 f8                	mov    %edi,%eax
80100b52:	89 bd 68 ff ff ff    	mov    %edi,-0x98(%ebp)
80100b58:	83 e8 01             	sub    $0x1,%eax
80100b5b:	89 c3                	mov    %eax,%ebx
80100b5d:	78 5a                	js     80100bb9 <recommend_command+0x109>
80100b5f:	6b d0 1e             	imul   $0x1e,%eax,%edx
80100b62:	8d 79 ff             	lea    -0x1(%ecx),%edi
80100b65:	8d 76 00             	lea    0x0(%esi),%esi
    if(current_buff_size >= commands_size[i]){
80100b68:	8b 04 9d 20 ff 10 80 	mov    -0x7fef00e0(,%ebx,4),%eax
80100b6f:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
80100b75:	39 c8                	cmp    %ecx,%eax
80100b77:	7e 40                	jle    80100bb9 <recommend_command+0x109>
    for(j = 0 ; j < current_buff_size ; j++){
80100b79:	85 c9                	test   %ecx,%ecx
80100b7b:	7e 31                	jle    80100bae <recommend_command+0xfe>
80100b7d:	89 9d 74 ff ff ff    	mov    %ebx,-0x8c(%ebp)
80100b83:	31 c0                	xor    %eax,%eax
80100b85:	8d 75 84             	lea    -0x7c(%ebp),%esi
80100b88:	eb 11                	jmp    80100b9b <recommend_command+0xeb>
80100b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(j == current_buff_size - 1){
80100b90:	39 f8                	cmp    %edi,%eax
80100b92:	74 5c                	je     80100bf0 <recommend_command+0x140>
    for(j = 0 ; j < current_buff_size ; j++){
80100b94:	83 c0 01             	add    $0x1,%eax
80100b97:	39 c1                	cmp    %eax,%ecx
80100b99:	74 0d                	je     80100ba8 <recommend_command+0xf8>
      if(current_buff[j] == last_commands[i][j]){
80100b9b:	0f b6 9c 10 60 ff 10 	movzbl -0x7fef00a0(%eax,%edx,1),%ebx
80100ba2:	80 
80100ba3:	38 1c 06             	cmp    %bl,(%esi,%eax,1)
80100ba6:	74 e8                	je     80100b90 <recommend_command+0xe0>
80100ba8:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
  for(i = (command_pointer % 15) - 1; i >= 0 ; i--){
80100bae:	83 eb 01             	sub    $0x1,%ebx
80100bb1:	83 ea 1e             	sub    $0x1e,%edx
80100bb4:	83 fb ff             	cmp    $0xffffffff,%ebx
80100bb7:	75 af                	jne    80100b68 <recommend_command+0xb8>
  if(command_pointer >= 15 && recommended_successfully == 0){
80100bb9:	83 bd 64 ff ff ff 0e 	cmpl   $0xe,-0x9c(%ebp)
80100bc0:	0f 8f b4 00 00 00    	jg     80100c7a <recommend_command+0x1ca>
    for(int x = 0 ; x < current_buff_size ; x++){
80100bc6:	8d 75 84             	lea    -0x7c(%ebp),%esi
80100bc9:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80100bcf:	8d 1c 31             	lea    (%ecx,%esi,1),%ebx
80100bd2:	85 c9                	test   %ecx,%ecx
80100bd4:	7e 79                	jle    80100c4f <recommend_command+0x19f>
      input.buf[input.e] = current_buff[x];
80100bd6:	0f be 06             	movsbl (%esi),%eax
80100bd9:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
  if(panicked){
80100bdf:	8b 15 78 01 11 80    	mov    0x80110178,%edx
80100be5:	85 d2                	test   %edx,%edx
80100be7:	74 71                	je     80100c5a <recommend_command+0x1aa>
80100be9:	fa                   	cli    
    for(;;)
80100bea:	eb fe                	jmp    80100bea <recommend_command+0x13a>
80100bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(int x = 0 ; x < commands_size[i] ; x++){
80100bf0:	8b b5 70 ff ff ff    	mov    -0x90(%ebp),%esi
80100bf6:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
80100bfc:	85 f6                	test   %esi,%esi
80100bfe:	7e 4f                	jle    80100c4f <recommend_command+0x19f>
80100c00:	6b fb 1e             	imul   $0x1e,%ebx,%edi
80100c03:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80100c09:	31 f6                	xor    %esi,%esi
      input.buf[input.e] = last_commands[i][x];
80100c0b:	0f be 84 37 60 ff 10 	movsbl -0x7fef00a0(%edi,%esi,1),%eax
80100c12:	80 
  if(panicked){
80100c13:	8b 0d 78 01 11 80    	mov    0x80110178,%ecx
      input.buf[input.e] = last_commands[i][x];
80100c19:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
  if(panicked){
80100c1f:	85 c9                	test   %ecx,%ecx
80100c21:	74 0d                	je     80100c30 <recommend_command+0x180>
80100c23:	fa                   	cli    
    for(;;)
80100c24:	eb fe                	jmp    80100c24 <recommend_command+0x174>
80100c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2d:	8d 76 00             	lea    0x0(%esi),%esi
80100c30:	e8 cb f7 ff ff       	call   80100400 <consputc.part.0>
      input.e++;
80100c35:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
    for(int x = 0 ; x < commands_size[i] ; x++){
80100c3a:	83 c6 01             	add    $0x1,%esi
      input.e++;
80100c3d:	8d 50 01             	lea    0x1(%eax),%edx
80100c40:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
    for(int x = 0 ; x < commands_size[i] ; x++){
80100c46:	39 34 9d 20 ff 10 80 	cmp    %esi,-0x7fef00e0(,%ebx,4)
80100c4d:	7f bc                	jg     80100c0b <recommend_command+0x15b>
}
80100c4f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
80100c55:	5b                   	pop    %ebx
80100c56:	5e                   	pop    %esi
80100c57:	5f                   	pop    %edi
80100c58:	5d                   	pop    %ebp
80100c59:	c3                   	ret    
80100c5a:	e8 a1 f7 ff ff       	call   80100400 <consputc.part.0>
      input.e++;
80100c5f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
    for(int x = 0 ; x < current_buff_size ; x++){
80100c64:	83 c6 01             	add    $0x1,%esi
      input.e++;
80100c67:	8d 50 01             	lea    0x1(%eax),%edx
80100c6a:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
    for(int x = 0 ; x < current_buff_size ; x++){
80100c70:	39 f3                	cmp    %esi,%ebx
80100c72:	0f 85 5e ff ff ff    	jne    80100bd6 <recommend_command+0x126>
80100c78:	eb d5                	jmp    80100c4f <recommend_command+0x19f>
  if(command_pointer >= 15 && recommended_successfully == 0){
80100c7a:	ba a4 01 00 00       	mov    $0x1a4,%edx
    for(i = 14; i >= (command_pointer % 15) ; i--){
80100c7f:	bb 0e 00 00 00       	mov    $0xe,%ebx
80100c84:	8d 79 ff             	lea    -0x1(%ecx),%edi
    if(current_buff_size >= commands_size[i]){
80100c87:	8b 04 9d 20 ff 10 80 	mov    -0x7fef00e0(,%ebx,4),%eax
80100c8e:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
80100c94:	39 c8                	cmp    %ecx,%eax
80100c96:	0f 8e 2a ff ff ff    	jle    80100bc6 <recommend_command+0x116>
    for(j = 0 ; j < current_buff_size ; j++){
80100c9c:	85 c9                	test   %ecx,%ecx
80100c9e:	7e 32                	jle    80100cd2 <recommend_command+0x222>
80100ca0:	89 9d 74 ff ff ff    	mov    %ebx,-0x8c(%ebp)
80100ca6:	31 c0                	xor    %eax,%eax
80100ca8:	8d 75 84             	lea    -0x7c(%ebp),%esi
80100cab:	eb 12                	jmp    80100cbf <recommend_command+0x20f>
80100cad:	8d 76 00             	lea    0x0(%esi),%esi
        if(j == current_buff_size - 1){
80100cb0:	39 f8                	cmp    %edi,%eax
80100cb2:	0f 84 38 ff ff ff    	je     80100bf0 <recommend_command+0x140>
    for(j = 0 ; j < current_buff_size ; j++){
80100cb8:	83 c0 01             	add    $0x1,%eax
80100cbb:	39 c1                	cmp    %eax,%ecx
80100cbd:	74 0d                	je     80100ccc <recommend_command+0x21c>
      if(current_buff[j] == last_commands[i][j]){
80100cbf:	0f b6 9c 10 60 ff 10 	movzbl -0x7fef00a0(%eax,%edx,1),%ebx
80100cc6:	80 
80100cc7:	38 1c 06             	cmp    %bl,(%esi,%eax,1)
80100cca:	74 e4                	je     80100cb0 <recommend_command+0x200>
80100ccc:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
    for(i = 14; i >= (command_pointer % 15) ; i--){
80100cd2:	83 eb 01             	sub    $0x1,%ebx
80100cd5:	83 ea 1e             	sub    $0x1e,%edx
80100cd8:	39 9d 68 ff ff ff    	cmp    %ebx,-0x98(%ebp)
80100cde:	7e a7                	jle    80100c87 <recommend_command+0x1d7>
80100ce0:	e9 e1 fe ff ff       	jmp    80100bc6 <recommend_command+0x116>
80100ce5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100cf0 <consoleintr>:
{
80100cf0:	55                   	push   %ebp
80100cf1:	89 e5                	mov    %esp,%ebp
80100cf3:	57                   	push   %edi
  int c, doprocdump = 0;
80100cf4:	31 ff                	xor    %edi,%edi
{
80100cf6:	56                   	push   %esi
80100cf7:	53                   	push   %ebx
80100cf8:	83 ec 18             	sub    $0x18,%esp
80100cfb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100cfe:	68 40 01 11 80       	push   $0x80110140
80100d03:	e8 08 3e 00 00       	call   80104b10 <acquire>
  while((c = getc()) >= 0){
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	ff d6                	call   *%esi
80100d0d:	89 c3                	mov    %eax,%ebx
80100d0f:	85 c0                	test   %eax,%eax
80100d11:	0f 88 e9 00 00 00    	js     80100e00 <consoleintr+0x110>
    switch(c){
80100d17:	83 fb 15             	cmp    $0x15,%ebx
80100d1a:	7f 24                	jg     80100d40 <consoleintr+0x50>
80100d1c:	83 fb 07             	cmp    $0x7,%ebx
80100d1f:	0f 8e c3 00 00 00    	jle    80100de8 <consoleintr+0xf8>
80100d25:	8d 43 f8             	lea    -0x8(%ebx),%eax
80100d28:	83 f8 0d             	cmp    $0xd,%eax
80100d2b:	0f 87 b7 00 00 00    	ja     80100de8 <consoleintr+0xf8>
80100d31:	ff 24 85 d0 78 10 80 	jmp    *-0x7fef8730(,%eax,4)
80100d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d3f:	90                   	nop
80100d40:	83 fb 7f             	cmp    $0x7f,%ebx
80100d43:	0f 84 37 01 00 00    	je     80100e80 <consoleintr+0x190>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100d49:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d4e:	89 c2                	mov    %eax,%edx
80100d50:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100d56:	83 fa 7f             	cmp    $0x7f,%edx
80100d59:	77 b0                	ja     80100d0b <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d5b:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100d5e:	8b 15 78 01 11 80    	mov    0x80110178,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100d64:	83 e0 7f             	and    $0x7f,%eax
80100d67:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
80100d6d:	83 fb 0d             	cmp    $0xd,%ebx
80100d70:	0f 84 7e 01 00 00    	je     80100ef4 <consoleintr+0x204>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d76:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100d7c:	85 d2                	test   %edx,%edx
80100d7e:	0f 85 5d 01 00 00    	jne    80100ee1 <consoleintr+0x1f1>
80100d84:	89 d8                	mov    %ebx,%eax
80100d86:	e8 75 f6 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100d8b:	83 fb 0a             	cmp    $0xa,%ebx
80100d8e:	0f 84 75 01 00 00    	je     80100f09 <consoleintr+0x219>
80100d94:	83 fb 04             	cmp    $0x4,%ebx
80100d97:	0f 84 6c 01 00 00    	je     80100f09 <consoleintr+0x219>
80100d9d:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100da2:	83 e8 80             	sub    $0xffffff80,%eax
80100da5:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100dab:	0f 85 5a ff ff ff    	jne    80100d0b <consoleintr+0x1b>
          save_command(input.buf , buff_size1);
80100db1:	83 ec 08             	sub    $0x8,%esp
          int buff_size1 = input.e - input.w;
80100db4:	2b 05 04 ff 10 80    	sub    0x8010ff04,%eax
          save_command(input.buf , buff_size1);
80100dba:	50                   	push   %eax
80100dbb:	68 80 fe 10 80       	push   $0x8010fe80
80100dc0:	e8 5b fc ff ff       	call   80100a20 <save_command>
          input.w = input.e;
80100dc5:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100dca:	c7 04 24 00 ff 10 80 	movl   $0x8010ff00,(%esp)
          input.w = input.e;
80100dd1:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100dd6:	e8 e5 37 00 00       	call   801045c0 <wakeup>
80100ddb:	83 c4 10             	add    $0x10,%esp
80100dde:	e9 28 ff ff ff       	jmp    80100d0b <consoleintr+0x1b>
80100de3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100de7:	90                   	nop
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100de8:	85 db                	test   %ebx,%ebx
80100dea:	0f 85 59 ff ff ff    	jne    80100d49 <consoleintr+0x59>
  while((c = getc()) >= 0){
80100df0:	ff d6                	call   *%esi
80100df2:	89 c3                	mov    %eax,%ebx
80100df4:	85 c0                	test   %eax,%eax
80100df6:	0f 89 1b ff ff ff    	jns    80100d17 <consoleintr+0x27>
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
80100e03:	68 40 01 11 80       	push   $0x80110140
80100e08:	e8 a3 3c 00 00       	call   80104ab0 <release>
  if(doprocdump) {
80100e0d:	83 c4 10             	add    $0x10,%esp
80100e10:	85 ff                	test   %edi,%edi
80100e12:	0f 85 d0 00 00 00    	jne    80100ee8 <consoleintr+0x1f8>
}
80100e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e1b:	5b                   	pop    %ebx
80100e1c:	5e                   	pop    %esi
80100e1d:	5f                   	pop    %edi
80100e1e:	5d                   	pop    %ebp
80100e1f:	c3                   	ret    
      while(input.e != input.w &&
80100e20:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e25:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100e2b:	0f 84 da fe ff ff    	je     80100d0b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100e31:	83 e8 01             	sub    $0x1,%eax
80100e34:	89 c2                	mov    %eax,%edx
80100e36:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100e39:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100e40:	0f 84 c5 fe ff ff    	je     80100d0b <consoleintr+0x1b>
  if(panicked){
80100e46:	8b 15 78 01 11 80    	mov    0x80110178,%edx
        input.e--;
80100e4c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100e51:	85 d2                	test   %edx,%edx
80100e53:	74 5d                	je     80100eb2 <consoleintr+0x1c2>
80100e55:	fa                   	cli    
    for(;;)
80100e56:	eb fe                	jmp    80100e56 <consoleintr+0x166>
80100e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e5f:	90                   	nop
      reverse_row();
80100e60:	e8 db fa ff ff       	call   80100940 <reverse_row>
      break;
80100e65:	e9 a1 fe ff ff       	jmp    80100d0b <consoleintr+0x1b>
      delete_numbers_in_current_line();
80100e6a:	e8 11 fa ff ff       	call   80100880 <delete_numbers_in_current_line>
      break;
80100e6f:	e9 97 fe ff ff       	jmp    80100d0b <consoleintr+0x1b>
      recommend_command();
80100e74:	e8 37 fc ff ff       	call   80100ab0 <recommend_command>
      break;
80100e79:	e9 8d fe ff ff       	jmp    80100d0b <consoleintr+0x1b>
80100e7e:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
80100e80:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e85:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100e8b:	0f 84 7a fe ff ff    	je     80100d0b <consoleintr+0x1b>
        input.e--;
80100e91:	83 e8 01             	sub    $0x1,%eax
80100e94:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100e99:	a1 78 01 11 80       	mov    0x80110178,%eax
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	74 30                	je     80100ed2 <consoleintr+0x1e2>
80100ea2:	fa                   	cli    
    for(;;)
80100ea3:	eb fe                	jmp    80100ea3 <consoleintr+0x1b3>
80100ea5:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100ea8:	bf 01 00 00 00       	mov    $0x1,%edi
80100ead:	e9 59 fe ff ff       	jmp    80100d0b <consoleintr+0x1b>
80100eb2:	b8 00 01 00 00       	mov    $0x100,%eax
80100eb7:	e8 44 f5 ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100ebc:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ec1:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100ec7:	0f 85 64 ff ff ff    	jne    80100e31 <consoleintr+0x141>
80100ecd:	e9 39 fe ff ff       	jmp    80100d0b <consoleintr+0x1b>
80100ed2:	b8 00 01 00 00       	mov    $0x100,%eax
80100ed7:	e8 24 f5 ff ff       	call   80100400 <consputc.part.0>
80100edc:	e9 2a fe ff ff       	jmp    80100d0b <consoleintr+0x1b>
80100ee1:	fa                   	cli    
    for(;;)
80100ee2:	eb fe                	jmp    80100ee2 <consoleintr+0x1f2>
80100ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80100ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eeb:	5b                   	pop    %ebx
80100eec:	5e                   	pop    %esi
80100eed:	5f                   	pop    %edi
80100eee:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100eef:	e9 ac 37 00 00       	jmp    801046a0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100ef4:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100efb:	85 d2                	test   %edx,%edx
80100efd:	75 e2                	jne    80100ee1 <consoleintr+0x1f1>
80100eff:	b8 0a 00 00 00       	mov    $0xa,%eax
80100f04:	e8 f7 f4 ff ff       	call   80100400 <consputc.part.0>
          int buff_size1 = input.e - input.w;
80100f09:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f0e:	e9 9e fe ff ff       	jmp    80100db1 <consoleintr+0xc1>
80100f13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f20 <consoleinit>:

void
consoleinit(void)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f26:	68 c8 78 10 80       	push   $0x801078c8
80100f2b:	68 40 01 11 80       	push   $0x80110140
80100f30:	e8 0b 3a 00 00       	call   80104940 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f35:	58                   	pop    %eax
80100f36:	5a                   	pop    %edx
80100f37:	6a 00                	push   $0x0
80100f39:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f3b:	c7 05 2c 0b 11 80 90 	movl   $0x80100590,0x80110b2c
80100f42:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100f45:	c7 05 28 0b 11 80 80 	movl   $0x80100280,0x80110b28
80100f4c:	02 10 80 
  cons.locking = 1;
80100f4f:	c7 05 74 01 11 80 01 	movl   $0x1,0x80110174
80100f56:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f59:	e8 e2 19 00 00       	call   80102940 <ioapicenable>
}
80100f5e:	83 c4 10             	add    $0x10,%esp
80100f61:	c9                   	leave  
80100f62:	c3                   	ret    
80100f63:	66 90                	xchg   %ax,%ax
80100f65:	66 90                	xchg   %ax,%ax
80100f67:	66 90                	xchg   %ax,%ax
80100f69:	66 90                	xchg   %ax,%ax
80100f6b:	66 90                	xchg   %ax,%ax
80100f6d:	66 90                	xchg   %ax,%ax
80100f6f:	90                   	nop

80100f70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f7c:	e8 af 2e 00 00       	call   80103e30 <myproc>
80100f81:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100f87:	e8 94 22 00 00       	call   80103220 <begin_op>

  if((ip = namei(path)) == 0){
80100f8c:	83 ec 0c             	sub    $0xc,%esp
80100f8f:	ff 75 08             	push   0x8(%ebp)
80100f92:	e8 c9 15 00 00       	call   80102560 <namei>
80100f97:	83 c4 10             	add    $0x10,%esp
80100f9a:	85 c0                	test   %eax,%eax
80100f9c:	0f 84 02 03 00 00    	je     801012a4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fa2:	83 ec 0c             	sub    $0xc,%esp
80100fa5:	89 c3                	mov    %eax,%ebx
80100fa7:	50                   	push   %eax
80100fa8:	e8 93 0c 00 00       	call   80101c40 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100fad:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fb3:	6a 34                	push   $0x34
80100fb5:	6a 00                	push   $0x0
80100fb7:	50                   	push   %eax
80100fb8:	53                   	push   %ebx
80100fb9:	e8 92 0f 00 00       	call   80101f50 <readi>
80100fbe:	83 c4 20             	add    $0x20,%esp
80100fc1:	83 f8 34             	cmp    $0x34,%eax
80100fc4:	74 22                	je     80100fe8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	53                   	push   %ebx
80100fca:	e8 01 0f 00 00       	call   80101ed0 <iunlockput>
    end_op();
80100fcf:	e8 bc 22 00 00       	call   80103290 <end_op>
80100fd4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fdf:	5b                   	pop    %ebx
80100fe0:	5e                   	pop    %esi
80100fe1:	5f                   	pop    %edi
80100fe2:	5d                   	pop    %ebp
80100fe3:	c3                   	ret    
80100fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100fe8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100fef:	45 4c 46 
80100ff2:	75 d2                	jne    80100fc6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100ff4:	e8 17 65 00 00       	call   80107510 <setupkvm>
80100ff9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100fff:	85 c0                	test   %eax,%eax
80101001:	74 c3                	je     80100fc6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101003:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
8010100a:	00 
8010100b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101011:	0f 84 ac 02 00 00    	je     801012c3 <exec+0x353>
  sz = 0;
80101017:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
8010101e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101021:	31 ff                	xor    %edi,%edi
80101023:	e9 8e 00 00 00       	jmp    801010b6 <exec+0x146>
80101028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010102f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101030:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101037:	75 6c                	jne    801010a5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101039:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010103f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101045:	0f 82 87 00 00 00    	jb     801010d2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010104b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101051:	72 7f                	jb     801010d2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101053:	83 ec 04             	sub    $0x4,%esp
80101056:	50                   	push   %eax
80101057:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
8010105d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101063:	e8 c8 62 00 00       	call   80107330 <allocuvm>
80101068:	83 c4 10             	add    $0x10,%esp
8010106b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101071:	85 c0                	test   %eax,%eax
80101073:	74 5d                	je     801010d2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101075:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010107b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101080:	75 50                	jne    801010d2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101082:	83 ec 0c             	sub    $0xc,%esp
80101085:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010108b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101091:	53                   	push   %ebx
80101092:	50                   	push   %eax
80101093:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101099:	e8 a2 61 00 00       	call   80107240 <loaduvm>
8010109e:	83 c4 20             	add    $0x20,%esp
801010a1:	85 c0                	test   %eax,%eax
801010a3:	78 2d                	js     801010d2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010a5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801010ac:	83 c7 01             	add    $0x1,%edi
801010af:	83 c6 20             	add    $0x20,%esi
801010b2:	39 f8                	cmp    %edi,%eax
801010b4:	7e 3a                	jle    801010f0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010b6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010bc:	6a 20                	push   $0x20
801010be:	56                   	push   %esi
801010bf:	50                   	push   %eax
801010c0:	53                   	push   %ebx
801010c1:	e8 8a 0e 00 00       	call   80101f50 <readi>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	83 f8 20             	cmp    $0x20,%eax
801010cc:	0f 84 5e ff ff ff    	je     80101030 <exec+0xc0>
    freevm(pgdir);
801010d2:	83 ec 0c             	sub    $0xc,%esp
801010d5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010db:	e8 b0 63 00 00       	call   80107490 <freevm>
  if(ip){
801010e0:	83 c4 10             	add    $0x10,%esp
801010e3:	e9 de fe ff ff       	jmp    80100fc6 <exec+0x56>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
  sz = PGROUNDUP(sz);
801010f0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801010f6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801010fc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101102:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	53                   	push   %ebx
8010110c:	e8 bf 0d 00 00       	call   80101ed0 <iunlockput>
  end_op();
80101111:	e8 7a 21 00 00       	call   80103290 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101116:	83 c4 0c             	add    $0xc,%esp
80101119:	56                   	push   %esi
8010111a:	57                   	push   %edi
8010111b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101121:	57                   	push   %edi
80101122:	e8 09 62 00 00       	call   80107330 <allocuvm>
80101127:	83 c4 10             	add    $0x10,%esp
8010112a:	89 c6                	mov    %eax,%esi
8010112c:	85 c0                	test   %eax,%eax
8010112e:	0f 84 94 00 00 00    	je     801011c8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010113d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010113f:	50                   	push   %eax
80101140:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101141:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101143:	e8 68 64 00 00       	call   801075b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101148:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114b:	83 c4 10             	add    $0x10,%esp
8010114e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101154:	8b 00                	mov    (%eax),%eax
80101156:	85 c0                	test   %eax,%eax
80101158:	0f 84 8b 00 00 00    	je     801011e9 <exec+0x279>
8010115e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101164:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010116a:	eb 23                	jmp    8010118f <exec+0x21f>
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101170:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101173:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010117a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010117d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101183:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101186:	85 c0                	test   %eax,%eax
80101188:	74 59                	je     801011e3 <exec+0x273>
    if(argc >= MAXARG)
8010118a:	83 ff 20             	cmp    $0x20,%edi
8010118d:	74 39                	je     801011c8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010118f:	83 ec 0c             	sub    $0xc,%esp
80101192:	50                   	push   %eax
80101193:	e8 38 3c 00 00       	call   80104dd0 <strlen>
80101198:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010119a:	58                   	pop    %eax
8010119b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010119e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011a1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011a4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011a7:	e8 24 3c 00 00       	call   80104dd0 <strlen>
801011ac:	83 c0 01             	add    $0x1,%eax
801011af:	50                   	push   %eax
801011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801011b3:	ff 34 b8             	push   (%eax,%edi,4)
801011b6:	53                   	push   %ebx
801011b7:	56                   	push   %esi
801011b8:	e8 c3 65 00 00       	call   80107780 <copyout>
801011bd:	83 c4 20             	add    $0x20,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	79 ac                	jns    80101170 <exec+0x200>
801011c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011d1:	e8 ba 62 00 00       	call   80107490 <freevm>
801011d6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011de:	e9 f9 fd ff ff       	jmp    80100fdc <exec+0x6c>
801011e3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011e9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801011f0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801011f2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801011f9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011fd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801011ff:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101202:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101208:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010120a:	50                   	push   %eax
8010120b:	52                   	push   %edx
8010120c:	53                   	push   %ebx
8010120d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101213:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010121a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010121d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101223:	e8 58 65 00 00       	call   80107780 <copyout>
80101228:	83 c4 10             	add    $0x10,%esp
8010122b:	85 c0                	test   %eax,%eax
8010122d:	78 99                	js     801011c8 <exec+0x258>
  for(last=s=path; *s; s++)
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 55 08             	mov    0x8(%ebp),%edx
80101235:	0f b6 00             	movzbl (%eax),%eax
80101238:	84 c0                	test   %al,%al
8010123a:	74 13                	je     8010124f <exec+0x2df>
8010123c:	89 d1                	mov    %edx,%ecx
8010123e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101240:	83 c1 01             	add    $0x1,%ecx
80101243:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101245:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101248:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010124b:	84 c0                	test   %al,%al
8010124d:	75 f1                	jne    80101240 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010124f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101255:	83 ec 04             	sub    $0x4,%esp
80101258:	6a 10                	push   $0x10
8010125a:	89 f8                	mov    %edi,%eax
8010125c:	52                   	push   %edx
8010125d:	83 c0 6c             	add    $0x6c,%eax
80101260:	50                   	push   %eax
80101261:	e8 2a 3b 00 00       	call   80104d90 <safestrcpy>
  curproc->pgdir = pgdir;
80101266:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010126c:	89 f8                	mov    %edi,%eax
8010126e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101271:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101273:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101276:	89 c1                	mov    %eax,%ecx
80101278:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010127e:	8b 40 18             	mov    0x18(%eax),%eax
80101281:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101284:	8b 41 18             	mov    0x18(%ecx),%eax
80101287:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010128a:	89 0c 24             	mov    %ecx,(%esp)
8010128d:	e8 1e 5e 00 00       	call   801070b0 <switchuvm>
  freevm(oldpgdir);
80101292:	89 3c 24             	mov    %edi,(%esp)
80101295:	e8 f6 61 00 00       	call   80107490 <freevm>
  return 0;
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	31 c0                	xor    %eax,%eax
8010129f:	e9 38 fd ff ff       	jmp    80100fdc <exec+0x6c>
    end_op();
801012a4:	e8 e7 1f 00 00       	call   80103290 <end_op>
    cprintf("exec: fail\n");
801012a9:	83 ec 0c             	sub    $0xc,%esp
801012ac:	68 19 79 10 80       	push   $0x80107919
801012b1:	e8 ea f3 ff ff       	call   801006a0 <cprintf>
    return -1;
801012b6:	83 c4 10             	add    $0x10,%esp
801012b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012be:	e9 19 fd ff ff       	jmp    80100fdc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012c3:	be 00 20 00 00       	mov    $0x2000,%esi
801012c8:	31 ff                	xor    %edi,%edi
801012ca:	e9 39 fe ff ff       	jmp    80101108 <exec+0x198>
801012cf:	90                   	nop

801012d0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012d6:	68 25 79 10 80       	push   $0x80107925
801012db:	68 80 01 11 80       	push   $0x80110180
801012e0:	e8 5b 36 00 00       	call   80104940 <initlock>
}
801012e5:	83 c4 10             	add    $0x10,%esp
801012e8:	c9                   	leave  
801012e9:	c3                   	ret    
801012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801012f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012f4:	bb b4 01 11 80       	mov    $0x801101b4,%ebx
{
801012f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801012fc:	68 80 01 11 80       	push   $0x80110180
80101301:	e8 0a 38 00 00       	call   80104b10 <acquire>
80101306:	83 c4 10             	add    $0x10,%esp
80101309:	eb 10                	jmp    8010131b <filealloc+0x2b>
8010130b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010130f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101310:	83 c3 18             	add    $0x18,%ebx
80101313:	81 fb 14 0b 11 80    	cmp    $0x80110b14,%ebx
80101319:	74 25                	je     80101340 <filealloc+0x50>
    if(f->ref == 0){
8010131b:	8b 43 04             	mov    0x4(%ebx),%eax
8010131e:	85 c0                	test   %eax,%eax
80101320:	75 ee                	jne    80101310 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101322:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101325:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010132c:	68 80 01 11 80       	push   $0x80110180
80101331:	e8 7a 37 00 00       	call   80104ab0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101336:	89 d8                	mov    %ebx,%eax
      return f;
80101338:	83 c4 10             	add    $0x10,%esp
}
8010133b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133e:	c9                   	leave  
8010133f:	c3                   	ret    
  release(&ftable.lock);
80101340:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101343:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101345:	68 80 01 11 80       	push   $0x80110180
8010134a:	e8 61 37 00 00       	call   80104ab0 <release>
}
8010134f:	89 d8                	mov    %ebx,%eax
  return 0;
80101351:	83 c4 10             	add    $0x10,%esp
}
80101354:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101357:	c9                   	leave  
80101358:	c3                   	ret    
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	53                   	push   %ebx
80101364:	83 ec 10             	sub    $0x10,%esp
80101367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010136a:	68 80 01 11 80       	push   $0x80110180
8010136f:	e8 9c 37 00 00       	call   80104b10 <acquire>
  if(f->ref < 1)
80101374:	8b 43 04             	mov    0x4(%ebx),%eax
80101377:	83 c4 10             	add    $0x10,%esp
8010137a:	85 c0                	test   %eax,%eax
8010137c:	7e 1a                	jle    80101398 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010137e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101381:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101384:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101387:	68 80 01 11 80       	push   $0x80110180
8010138c:	e8 1f 37 00 00       	call   80104ab0 <release>
  return f;
}
80101391:	89 d8                	mov    %ebx,%eax
80101393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101396:	c9                   	leave  
80101397:	c3                   	ret    
    panic("filedup");
80101398:	83 ec 0c             	sub    $0xc,%esp
8010139b:	68 2c 79 10 80       	push   $0x8010792c
801013a0:	e8 db ef ff ff       	call   80100380 <panic>
801013a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	83 ec 28             	sub    $0x28,%esp
801013b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013bc:	68 80 01 11 80       	push   $0x80110180
801013c1:	e8 4a 37 00 00       	call   80104b10 <acquire>
  if(f->ref < 1)
801013c6:	8b 53 04             	mov    0x4(%ebx),%edx
801013c9:	83 c4 10             	add    $0x10,%esp
801013cc:	85 d2                	test   %edx,%edx
801013ce:	0f 8e a5 00 00 00    	jle    80101479 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801013d4:	83 ea 01             	sub    $0x1,%edx
801013d7:	89 53 04             	mov    %edx,0x4(%ebx)
801013da:	75 44                	jne    80101420 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801013dc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801013e0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013e3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801013e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013eb:	8b 73 0c             	mov    0xc(%ebx),%esi
801013ee:	88 45 e7             	mov    %al,-0x19(%ebp)
801013f1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801013f4:	68 80 01 11 80       	push   $0x80110180
  ff = *f;
801013f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801013fc:	e8 af 36 00 00       	call   80104ab0 <release>

  if(ff.type == FD_PIPE)
80101401:	83 c4 10             	add    $0x10,%esp
80101404:	83 ff 01             	cmp    $0x1,%edi
80101407:	74 57                	je     80101460 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101409:	83 ff 02             	cmp    $0x2,%edi
8010140c:	74 2a                	je     80101438 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010140e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101411:	5b                   	pop    %ebx
80101412:	5e                   	pop    %esi
80101413:	5f                   	pop    %edi
80101414:	5d                   	pop    %ebp
80101415:	c3                   	ret    
80101416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010141d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101420:	c7 45 08 80 01 11 80 	movl   $0x80110180,0x8(%ebp)
}
80101427:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142a:	5b                   	pop    %ebx
8010142b:	5e                   	pop    %esi
8010142c:	5f                   	pop    %edi
8010142d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010142e:	e9 7d 36 00 00       	jmp    80104ab0 <release>
80101433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101437:	90                   	nop
    begin_op();
80101438:	e8 e3 1d 00 00       	call   80103220 <begin_op>
    iput(ff.ip);
8010143d:	83 ec 0c             	sub    $0xc,%esp
80101440:	ff 75 e0             	push   -0x20(%ebp)
80101443:	e8 28 09 00 00       	call   80101d70 <iput>
    end_op();
80101448:	83 c4 10             	add    $0x10,%esp
}
8010144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144e:	5b                   	pop    %ebx
8010144f:	5e                   	pop    %esi
80101450:	5f                   	pop    %edi
80101451:	5d                   	pop    %ebp
    end_op();
80101452:	e9 39 1e 00 00       	jmp    80103290 <end_op>
80101457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101460:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101464:	83 ec 08             	sub    $0x8,%esp
80101467:	53                   	push   %ebx
80101468:	56                   	push   %esi
80101469:	e8 82 25 00 00       	call   801039f0 <pipeclose>
8010146e:	83 c4 10             	add    $0x10,%esp
}
80101471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
    panic("fileclose");
80101479:	83 ec 0c             	sub    $0xc,%esp
8010147c:	68 34 79 10 80       	push   $0x80107934
80101481:	e8 fa ee ff ff       	call   80100380 <panic>
80101486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148d:	8d 76 00             	lea    0x0(%esi),%esi

80101490 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	83 ec 04             	sub    $0x4,%esp
80101497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010149a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010149d:	75 31                	jne    801014d0 <filestat+0x40>
    ilock(f->ip);
8010149f:	83 ec 0c             	sub    $0xc,%esp
801014a2:	ff 73 10             	push   0x10(%ebx)
801014a5:	e8 96 07 00 00       	call   80101c40 <ilock>
    stati(f->ip, st);
801014aa:	58                   	pop    %eax
801014ab:	5a                   	pop    %edx
801014ac:	ff 75 0c             	push   0xc(%ebp)
801014af:	ff 73 10             	push   0x10(%ebx)
801014b2:	e8 69 0a 00 00       	call   80101f20 <stati>
    iunlock(f->ip);
801014b7:	59                   	pop    %ecx
801014b8:	ff 73 10             	push   0x10(%ebx)
801014bb:	e8 60 08 00 00       	call   80101d20 <iunlock>
    return 0;
  }
  return -1;
}
801014c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801014c3:	83 c4 10             	add    $0x10,%esp
801014c6:	31 c0                	xor    %eax,%eax
}
801014c8:	c9                   	leave  
801014c9:	c3                   	ret    
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801014d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801014d8:	c9                   	leave  
801014d9:	c3                   	ret    
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	83 ec 0c             	sub    $0xc,%esp
801014e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801014ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801014f2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801014f6:	74 60                	je     80101558 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801014f8:	8b 03                	mov    (%ebx),%eax
801014fa:	83 f8 01             	cmp    $0x1,%eax
801014fd:	74 41                	je     80101540 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801014ff:	83 f8 02             	cmp    $0x2,%eax
80101502:	75 5b                	jne    8010155f <fileread+0x7f>
    ilock(f->ip);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	ff 73 10             	push   0x10(%ebx)
8010150a:	e8 31 07 00 00       	call   80101c40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010150f:	57                   	push   %edi
80101510:	ff 73 14             	push   0x14(%ebx)
80101513:	56                   	push   %esi
80101514:	ff 73 10             	push   0x10(%ebx)
80101517:	e8 34 0a 00 00       	call   80101f50 <readi>
8010151c:	83 c4 20             	add    $0x20,%esp
8010151f:	89 c6                	mov    %eax,%esi
80101521:	85 c0                	test   %eax,%eax
80101523:	7e 03                	jle    80101528 <fileread+0x48>
      f->off += r;
80101525:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101528:	83 ec 0c             	sub    $0xc,%esp
8010152b:	ff 73 10             	push   0x10(%ebx)
8010152e:	e8 ed 07 00 00       	call   80101d20 <iunlock>
    return r;
80101533:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101536:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101539:	89 f0                	mov    %esi,%eax
8010153b:	5b                   	pop    %ebx
8010153c:	5e                   	pop    %esi
8010153d:	5f                   	pop    %edi
8010153e:	5d                   	pop    %ebp
8010153f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101540:	8b 43 0c             	mov    0xc(%ebx),%eax
80101543:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101546:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101549:	5b                   	pop    %ebx
8010154a:	5e                   	pop    %esi
8010154b:	5f                   	pop    %edi
8010154c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010154d:	e9 3e 26 00 00       	jmp    80103b90 <piperead>
80101552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101558:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010155d:	eb d7                	jmp    80101536 <fileread+0x56>
  panic("fileread");
8010155f:	83 ec 0c             	sub    $0xc,%esp
80101562:	68 3e 79 10 80       	push   $0x8010793e
80101567:	e8 14 ee ff ff       	call   80100380 <panic>
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101570 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	83 ec 1c             	sub    $0x1c,%esp
80101579:	8b 45 0c             	mov    0xc(%ebp),%eax
8010157c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010157f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101582:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101585:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010158c:	0f 84 bd 00 00 00    	je     8010164f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101592:	8b 03                	mov    (%ebx),%eax
80101594:	83 f8 01             	cmp    $0x1,%eax
80101597:	0f 84 bf 00 00 00    	je     8010165c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010159d:	83 f8 02             	cmp    $0x2,%eax
801015a0:	0f 85 c8 00 00 00    	jne    8010166e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015a9:	31 f6                	xor    %esi,%esi
    while(i < n){
801015ab:	85 c0                	test   %eax,%eax
801015ad:	7f 30                	jg     801015df <filewrite+0x6f>
801015af:	e9 94 00 00 00       	jmp    80101648 <filewrite+0xd8>
801015b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801015b8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801015bb:	83 ec 0c             	sub    $0xc,%esp
801015be:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801015c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801015c4:	e8 57 07 00 00       	call   80101d20 <iunlock>
      end_op();
801015c9:	e8 c2 1c 00 00       	call   80103290 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801015ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015d1:	83 c4 10             	add    $0x10,%esp
801015d4:	39 c7                	cmp    %eax,%edi
801015d6:	75 5c                	jne    80101634 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801015d8:	01 fe                	add    %edi,%esi
    while(i < n){
801015da:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801015dd:	7e 69                	jle    80101648 <filewrite+0xd8>
      int n1 = n - i;
801015df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801015e2:	b8 00 06 00 00       	mov    $0x600,%eax
801015e7:	29 f7                	sub    %esi,%edi
801015e9:	39 c7                	cmp    %eax,%edi
801015eb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801015ee:	e8 2d 1c 00 00       	call   80103220 <begin_op>
      ilock(f->ip);
801015f3:	83 ec 0c             	sub    $0xc,%esp
801015f6:	ff 73 10             	push   0x10(%ebx)
801015f9:	e8 42 06 00 00       	call   80101c40 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801015fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101601:	57                   	push   %edi
80101602:	ff 73 14             	push   0x14(%ebx)
80101605:	01 f0                	add    %esi,%eax
80101607:	50                   	push   %eax
80101608:	ff 73 10             	push   0x10(%ebx)
8010160b:	e8 40 0a 00 00       	call   80102050 <writei>
80101610:	83 c4 20             	add    $0x20,%esp
80101613:	85 c0                	test   %eax,%eax
80101615:	7f a1                	jg     801015b8 <filewrite+0x48>
      iunlock(f->ip);
80101617:	83 ec 0c             	sub    $0xc,%esp
8010161a:	ff 73 10             	push   0x10(%ebx)
8010161d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101620:	e8 fb 06 00 00       	call   80101d20 <iunlock>
      end_op();
80101625:	e8 66 1c 00 00       	call   80103290 <end_op>
      if(r < 0)
8010162a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010162d:	83 c4 10             	add    $0x10,%esp
80101630:	85 c0                	test   %eax,%eax
80101632:	75 1b                	jne    8010164f <filewrite+0xdf>
        panic("short filewrite");
80101634:	83 ec 0c             	sub    $0xc,%esp
80101637:	68 47 79 10 80       	push   $0x80107947
8010163c:	e8 3f ed ff ff       	call   80100380 <panic>
80101641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101648:	89 f0                	mov    %esi,%eax
8010164a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010164d:	74 05                	je     80101654 <filewrite+0xe4>
8010164f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101654:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
8010165b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010165c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010165f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101662:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101665:	5b                   	pop    %ebx
80101666:	5e                   	pop    %esi
80101667:	5f                   	pop    %edi
80101668:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101669:	e9 22 24 00 00       	jmp    80103a90 <pipewrite>
  panic("filewrite");
8010166e:	83 ec 0c             	sub    $0xc,%esp
80101671:	68 4d 79 10 80       	push   $0x8010794d
80101676:	e8 05 ed ff ff       	call   80100380 <panic>
8010167b:	66 90                	xchg   %ax,%ax
8010167d:	66 90                	xchg   %ax,%ax
8010167f:	90                   	nop

80101680 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101680:	55                   	push   %ebp
80101681:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101683:	89 d0                	mov    %edx,%eax
80101685:	c1 e8 0c             	shr    $0xc,%eax
80101688:	03 05 ec 27 11 80    	add    0x801127ec,%eax
{
8010168e:	89 e5                	mov    %esp,%ebp
80101690:	56                   	push   %esi
80101691:	53                   	push   %ebx
80101692:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101694:	83 ec 08             	sub    $0x8,%esp
80101697:	50                   	push   %eax
80101698:	51                   	push   %ecx
80101699:	e8 32 ea ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010169e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801016a0:	c1 fb 03             	sar    $0x3,%ebx
801016a3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016a6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801016a8:	83 e1 07             	and    $0x7,%ecx
801016ab:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801016b0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801016b6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801016b8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801016bd:	85 c1                	test   %eax,%ecx
801016bf:	74 23                	je     801016e4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801016c1:	f7 d0                	not    %eax
  log_write(bp);
801016c3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801016c6:	21 c8                	and    %ecx,%eax
801016c8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801016cc:	56                   	push   %esi
801016cd:	e8 2e 1d 00 00       	call   80103400 <log_write>
  brelse(bp);
801016d2:	89 34 24             	mov    %esi,(%esp)
801016d5:	e8 16 eb ff ff       	call   801001f0 <brelse>
}
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e0:	5b                   	pop    %ebx
801016e1:	5e                   	pop    %esi
801016e2:	5d                   	pop    %ebp
801016e3:	c3                   	ret    
    panic("freeing free block");
801016e4:	83 ec 0c             	sub    $0xc,%esp
801016e7:	68 57 79 10 80       	push   $0x80107957
801016ec:	e8 8f ec ff ff       	call   80100380 <panic>
801016f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ff:	90                   	nop

80101700 <balloc>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101709:	8b 0d d4 27 11 80    	mov    0x801127d4,%ecx
{
8010170f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101712:	85 c9                	test   %ecx,%ecx
80101714:	0f 84 87 00 00 00    	je     801017a1 <balloc+0xa1>
8010171a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101721:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101724:	83 ec 08             	sub    $0x8,%esp
80101727:	89 f0                	mov    %esi,%eax
80101729:	c1 f8 0c             	sar    $0xc,%eax
8010172c:	03 05 ec 27 11 80    	add    0x801127ec,%eax
80101732:	50                   	push   %eax
80101733:	ff 75 d8             	push   -0x28(%ebp)
80101736:	e8 95 e9 ff ff       	call   801000d0 <bread>
8010173b:	83 c4 10             	add    $0x10,%esp
8010173e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101741:	a1 d4 27 11 80       	mov    0x801127d4,%eax
80101746:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101749:	31 c0                	xor    %eax,%eax
8010174b:	eb 2f                	jmp    8010177c <balloc+0x7c>
8010174d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101750:	89 c1                	mov    %eax,%ecx
80101752:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101757:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010175a:	83 e1 07             	and    $0x7,%ecx
8010175d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010175f:	89 c1                	mov    %eax,%ecx
80101761:	c1 f9 03             	sar    $0x3,%ecx
80101764:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101769:	89 fa                	mov    %edi,%edx
8010176b:	85 df                	test   %ebx,%edi
8010176d:	74 41                	je     801017b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010176f:	83 c0 01             	add    $0x1,%eax
80101772:	83 c6 01             	add    $0x1,%esi
80101775:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010177a:	74 05                	je     80101781 <balloc+0x81>
8010177c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010177f:	77 cf                	ja     80101750 <balloc+0x50>
    brelse(bp);
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	ff 75 e4             	push   -0x1c(%ebp)
80101787:	e8 64 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010178c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101793:	83 c4 10             	add    $0x10,%esp
80101796:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101799:	39 05 d4 27 11 80    	cmp    %eax,0x801127d4
8010179f:	77 80                	ja     80101721 <balloc+0x21>
  panic("balloc: out of blocks");
801017a1:	83 ec 0c             	sub    $0xc,%esp
801017a4:	68 6a 79 10 80       	push   $0x8010796a
801017a9:	e8 d2 eb ff ff       	call   80100380 <panic>
801017ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801017b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801017b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801017b6:	09 da                	or     %ebx,%edx
801017b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801017bc:	57                   	push   %edi
801017bd:	e8 3e 1c 00 00       	call   80103400 <log_write>
        brelse(bp);
801017c2:	89 3c 24             	mov    %edi,(%esp)
801017c5:	e8 26 ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801017ca:	58                   	pop    %eax
801017cb:	5a                   	pop    %edx
801017cc:	56                   	push   %esi
801017cd:	ff 75 d8             	push   -0x28(%ebp)
801017d0:	e8 fb e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801017d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017da:	8d 40 5c             	lea    0x5c(%eax),%eax
801017dd:	68 00 02 00 00       	push   $0x200
801017e2:	6a 00                	push   $0x0
801017e4:	50                   	push   %eax
801017e5:	e8 e6 33 00 00       	call   80104bd0 <memset>
  log_write(bp);
801017ea:	89 1c 24             	mov    %ebx,(%esp)
801017ed:	e8 0e 1c 00 00       	call   80103400 <log_write>
  brelse(bp);
801017f2:	89 1c 24             	mov    %ebx,(%esp)
801017f5:	e8 f6 e9 ff ff       	call   801001f0 <brelse>
}
801017fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fd:	89 f0                	mov    %esi,%eax
801017ff:	5b                   	pop    %ebx
80101800:	5e                   	pop    %esi
80101801:	5f                   	pop    %edi
80101802:	5d                   	pop    %ebp
80101803:	c3                   	ret    
80101804:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop

80101810 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	89 c7                	mov    %eax,%edi
80101816:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101817:	31 f6                	xor    %esi,%esi
{
80101819:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010181a:	bb b4 0b 11 80       	mov    $0x80110bb4,%ebx
{
8010181f:	83 ec 28             	sub    $0x28,%esp
80101822:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101825:	68 80 0b 11 80       	push   $0x80110b80
8010182a:	e8 e1 32 00 00       	call   80104b10 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101832:	83 c4 10             	add    $0x10,%esp
80101835:	eb 1b                	jmp    80101852 <iget+0x42>
80101837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101840:	39 3b                	cmp    %edi,(%ebx)
80101842:	74 6c                	je     801018b0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101844:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010184a:	81 fb d4 27 11 80    	cmp    $0x801127d4,%ebx
80101850:	73 26                	jae    80101878 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101852:	8b 43 08             	mov    0x8(%ebx),%eax
80101855:	85 c0                	test   %eax,%eax
80101857:	7f e7                	jg     80101840 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101859:	85 f6                	test   %esi,%esi
8010185b:	75 e7                	jne    80101844 <iget+0x34>
8010185d:	85 c0                	test   %eax,%eax
8010185f:	75 76                	jne    801018d7 <iget+0xc7>
80101861:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101863:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101869:	81 fb d4 27 11 80    	cmp    $0x801127d4,%ebx
8010186f:	72 e1                	jb     80101852 <iget+0x42>
80101871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101878:	85 f6                	test   %esi,%esi
8010187a:	74 79                	je     801018f5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010187c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010187f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101881:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101884:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010188b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101892:	68 80 0b 11 80       	push   $0x80110b80
80101897:	e8 14 32 00 00       	call   80104ab0 <release>

  return ip;
8010189c:	83 c4 10             	add    $0x10,%esp
}
8010189f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018a2:	89 f0                	mov    %esi,%eax
801018a4:	5b                   	pop    %ebx
801018a5:	5e                   	pop    %esi
801018a6:	5f                   	pop    %edi
801018a7:	5d                   	pop    %ebp
801018a8:	c3                   	ret    
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801018b3:	75 8f                	jne    80101844 <iget+0x34>
      release(&icache.lock);
801018b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801018b8:	83 c0 01             	add    $0x1,%eax
      return ip;
801018bb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801018bd:	68 80 0b 11 80       	push   $0x80110b80
      ip->ref++;
801018c2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801018c5:	e8 e6 31 00 00       	call   80104ab0 <release>
      return ip;
801018ca:	83 c4 10             	add    $0x10,%esp
}
801018cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018d0:	89 f0                	mov    %esi,%eax
801018d2:	5b                   	pop    %ebx
801018d3:	5e                   	pop    %esi
801018d4:	5f                   	pop    %edi
801018d5:	5d                   	pop    %ebp
801018d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018dd:	81 fb d4 27 11 80    	cmp    $0x801127d4,%ebx
801018e3:	73 10                	jae    801018f5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018e5:	8b 43 08             	mov    0x8(%ebx),%eax
801018e8:	85 c0                	test   %eax,%eax
801018ea:	0f 8f 50 ff ff ff    	jg     80101840 <iget+0x30>
801018f0:	e9 68 ff ff ff       	jmp    8010185d <iget+0x4d>
    panic("iget: no inodes");
801018f5:	83 ec 0c             	sub    $0xc,%esp
801018f8:	68 80 79 10 80       	push   $0x80107980
801018fd:	e8 7e ea ff ff       	call   80100380 <panic>
80101902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101910 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	89 c6                	mov    %eax,%esi
80101917:	53                   	push   %ebx
80101918:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010191b:	83 fa 0b             	cmp    $0xb,%edx
8010191e:	0f 86 8c 00 00 00    	jbe    801019b0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101924:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101927:	83 fb 7f             	cmp    $0x7f,%ebx
8010192a:	0f 87 a2 00 00 00    	ja     801019d2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101930:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101936:	85 c0                	test   %eax,%eax
80101938:	74 5e                	je     80101998 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010193a:	83 ec 08             	sub    $0x8,%esp
8010193d:	50                   	push   %eax
8010193e:	ff 36                	push   (%esi)
80101940:	e8 8b e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101945:	83 c4 10             	add    $0x10,%esp
80101948:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010194c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010194e:	8b 3b                	mov    (%ebx),%edi
80101950:	85 ff                	test   %edi,%edi
80101952:	74 1c                	je     80101970 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101954:	83 ec 0c             	sub    $0xc,%esp
80101957:	52                   	push   %edx
80101958:	e8 93 e8 ff ff       	call   801001f0 <brelse>
8010195d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101960:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101963:	89 f8                	mov    %edi,%eax
80101965:	5b                   	pop    %ebx
80101966:	5e                   	pop    %esi
80101967:	5f                   	pop    %edi
80101968:	5d                   	pop    %ebp
80101969:	c3                   	ret    
8010196a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101973:	8b 06                	mov    (%esi),%eax
80101975:	e8 86 fd ff ff       	call   80101700 <balloc>
      log_write(bp);
8010197a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010197d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101980:	89 03                	mov    %eax,(%ebx)
80101982:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101984:	52                   	push   %edx
80101985:	e8 76 1a 00 00       	call   80103400 <log_write>
8010198a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010198d:	83 c4 10             	add    $0x10,%esp
80101990:	eb c2                	jmp    80101954 <bmap+0x44>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101998:	8b 06                	mov    (%esi),%eax
8010199a:	e8 61 fd ff ff       	call   80101700 <balloc>
8010199f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801019a5:	eb 93                	jmp    8010193a <bmap+0x2a>
801019a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ae:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801019b0:	8d 5a 14             	lea    0x14(%edx),%ebx
801019b3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801019b7:	85 ff                	test   %edi,%edi
801019b9:	75 a5                	jne    80101960 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801019bb:	8b 00                	mov    (%eax),%eax
801019bd:	e8 3e fd ff ff       	call   80101700 <balloc>
801019c2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801019c6:	89 c7                	mov    %eax,%edi
}
801019c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cb:	5b                   	pop    %ebx
801019cc:	89 f8                	mov    %edi,%eax
801019ce:	5e                   	pop    %esi
801019cf:	5f                   	pop    %edi
801019d0:	5d                   	pop    %ebp
801019d1:	c3                   	ret    
  panic("bmap: out of range");
801019d2:	83 ec 0c             	sub    $0xc,%esp
801019d5:	68 90 79 10 80       	push   $0x80107990
801019da:	e8 a1 e9 ff ff       	call   80100380 <panic>
801019df:	90                   	nop

801019e0 <readsb>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	56                   	push   %esi
801019e4:	53                   	push   %ebx
801019e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801019e8:	83 ec 08             	sub    $0x8,%esp
801019eb:	6a 01                	push   $0x1
801019ed:	ff 75 08             	push   0x8(%ebp)
801019f0:	e8 db e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801019f5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801019f8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801019fa:	8d 40 5c             	lea    0x5c(%eax),%eax
801019fd:	6a 1c                	push   $0x1c
801019ff:	50                   	push   %eax
80101a00:	56                   	push   %esi
80101a01:	e8 6a 32 00 00       	call   80104c70 <memmove>
  brelse(bp);
80101a06:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a09:	83 c4 10             	add    $0x10,%esp
}
80101a0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a0f:	5b                   	pop    %ebx
80101a10:	5e                   	pop    %esi
80101a11:	5d                   	pop    %ebp
  brelse(bp);
80101a12:	e9 d9 e7 ff ff       	jmp    801001f0 <brelse>
80101a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1e:	66 90                	xchg   %ax,%ax

80101a20 <iinit>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	53                   	push   %ebx
80101a24:	bb c0 0b 11 80       	mov    $0x80110bc0,%ebx
80101a29:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a2c:	68 a3 79 10 80       	push   $0x801079a3
80101a31:	68 80 0b 11 80       	push   $0x80110b80
80101a36:	e8 05 2f 00 00       	call   80104940 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a40:	83 ec 08             	sub    $0x8,%esp
80101a43:	68 aa 79 10 80       	push   $0x801079aa
80101a48:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a49:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a4f:	e8 bc 2d 00 00       	call   80104810 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a54:	83 c4 10             	add    $0x10,%esp
80101a57:	81 fb e0 27 11 80    	cmp    $0x801127e0,%ebx
80101a5d:	75 e1                	jne    80101a40 <iinit+0x20>
  bp = bread(dev, 1);
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	6a 01                	push   $0x1
80101a64:	ff 75 08             	push   0x8(%ebp)
80101a67:	e8 64 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a6c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a6f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a71:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a74:	6a 1c                	push   $0x1c
80101a76:	50                   	push   %eax
80101a77:	68 d4 27 11 80       	push   $0x801127d4
80101a7c:	e8 ef 31 00 00       	call   80104c70 <memmove>
  brelse(bp);
80101a81:	89 1c 24             	mov    %ebx,(%esp)
80101a84:	e8 67 e7 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a89:	ff 35 ec 27 11 80    	push   0x801127ec
80101a8f:	ff 35 e8 27 11 80    	push   0x801127e8
80101a95:	ff 35 e4 27 11 80    	push   0x801127e4
80101a9b:	ff 35 e0 27 11 80    	push   0x801127e0
80101aa1:	ff 35 dc 27 11 80    	push   0x801127dc
80101aa7:	ff 35 d8 27 11 80    	push   0x801127d8
80101aad:	ff 35 d4 27 11 80    	push   0x801127d4
80101ab3:	68 10 7a 10 80       	push   $0x80107a10
80101ab8:	e8 e3 eb ff ff       	call   801006a0 <cprintf>
}
80101abd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ac0:	83 c4 30             	add    $0x30,%esp
80101ac3:	c9                   	leave  
80101ac4:	c3                   	ret    
80101ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ad0 <ialloc>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 1c             	sub    $0x1c,%esp
80101ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101adc:	83 3d dc 27 11 80 01 	cmpl   $0x1,0x801127dc
{
80101ae3:	8b 75 08             	mov    0x8(%ebp),%esi
80101ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101ae9:	0f 86 91 00 00 00    	jbe    80101b80 <ialloc+0xb0>
80101aef:	bf 01 00 00 00       	mov    $0x1,%edi
80101af4:	eb 21                	jmp    80101b17 <ialloc+0x47>
80101af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101b00:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b03:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b06:	53                   	push   %ebx
80101b07:	e8 e4 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b0c:	83 c4 10             	add    $0x10,%esp
80101b0f:	3b 3d dc 27 11 80    	cmp    0x801127dc,%edi
80101b15:	73 69                	jae    80101b80 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b17:	89 f8                	mov    %edi,%eax
80101b19:	83 ec 08             	sub    $0x8,%esp
80101b1c:	c1 e8 03             	shr    $0x3,%eax
80101b1f:	03 05 e8 27 11 80    	add    0x801127e8,%eax
80101b25:	50                   	push   %eax
80101b26:	56                   	push   %esi
80101b27:	e8 a4 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b2c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b2f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b31:	89 f8                	mov    %edi,%eax
80101b33:	83 e0 07             	and    $0x7,%eax
80101b36:	c1 e0 06             	shl    $0x6,%eax
80101b39:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b3d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b41:	75 bd                	jne    80101b00 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b43:	83 ec 04             	sub    $0x4,%esp
80101b46:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b49:	6a 40                	push   $0x40
80101b4b:	6a 00                	push   $0x0
80101b4d:	51                   	push   %ecx
80101b4e:	e8 7d 30 00 00       	call   80104bd0 <memset>
      dip->type = type;
80101b53:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b5a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b5d:	89 1c 24             	mov    %ebx,(%esp)
80101b60:	e8 9b 18 00 00       	call   80103400 <log_write>
      brelse(bp);
80101b65:	89 1c 24             	mov    %ebx,(%esp)
80101b68:	e8 83 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b6d:	83 c4 10             	add    $0x10,%esp
}
80101b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b73:	89 fa                	mov    %edi,%edx
}
80101b75:	5b                   	pop    %ebx
      return iget(dev, inum);
80101b76:	89 f0                	mov    %esi,%eax
}
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b7b:	e9 90 fc ff ff       	jmp    80101810 <iget>
  panic("ialloc: no inodes");
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	68 b0 79 10 80       	push   $0x801079b0
80101b88:	e8 f3 e7 ff ff       	call   80100380 <panic>
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi

80101b90 <iupdate>:
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	56                   	push   %esi
80101b94:	53                   	push   %ebx
80101b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b98:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b9b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b9e:	83 ec 08             	sub    $0x8,%esp
80101ba1:	c1 e8 03             	shr    $0x3,%eax
80101ba4:	03 05 e8 27 11 80    	add    0x801127e8,%eax
80101baa:	50                   	push   %eax
80101bab:	ff 73 a4             	push   -0x5c(%ebx)
80101bae:	e8 1d e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101bb3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bb7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bba:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bbc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101bbf:	83 e0 07             	and    $0x7,%eax
80101bc2:	c1 e0 06             	shl    $0x6,%eax
80101bc5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101bc9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101bcc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bd0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101bd3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101bd7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101bdb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101bdf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101be3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101be7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101bea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bed:	6a 34                	push   $0x34
80101bef:	53                   	push   %ebx
80101bf0:	50                   	push   %eax
80101bf1:	e8 7a 30 00 00       	call   80104c70 <memmove>
  log_write(bp);
80101bf6:	89 34 24             	mov    %esi,(%esp)
80101bf9:	e8 02 18 00 00       	call   80103400 <log_write>
  brelse(bp);
80101bfe:	89 75 08             	mov    %esi,0x8(%ebp)
80101c01:	83 c4 10             	add    $0x10,%esp
}
80101c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c07:	5b                   	pop    %ebx
80101c08:	5e                   	pop    %esi
80101c09:	5d                   	pop    %ebp
  brelse(bp);
80101c0a:	e9 e1 e5 ff ff       	jmp    801001f0 <brelse>
80101c0f:	90                   	nop

80101c10 <idup>:
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	53                   	push   %ebx
80101c14:	83 ec 10             	sub    $0x10,%esp
80101c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c1a:	68 80 0b 11 80       	push   $0x80110b80
80101c1f:	e8 ec 2e 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101c24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c28:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101c2f:	e8 7c 2e 00 00       	call   80104ab0 <release>
}
80101c34:	89 d8                	mov    %ebx,%eax
80101c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c39:	c9                   	leave  
80101c3a:	c3                   	ret    
80101c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c3f:	90                   	nop

80101c40 <ilock>:
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	56                   	push   %esi
80101c44:	53                   	push   %ebx
80101c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c48:	85 db                	test   %ebx,%ebx
80101c4a:	0f 84 b7 00 00 00    	je     80101d07 <ilock+0xc7>
80101c50:	8b 53 08             	mov    0x8(%ebx),%edx
80101c53:	85 d2                	test   %edx,%edx
80101c55:	0f 8e ac 00 00 00    	jle    80101d07 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c61:	50                   	push   %eax
80101c62:	e8 e9 2b 00 00       	call   80104850 <acquiresleep>
  if(ip->valid == 0){
80101c67:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101c6a:	83 c4 10             	add    $0x10,%esp
80101c6d:	85 c0                	test   %eax,%eax
80101c6f:	74 0f                	je     80101c80 <ilock+0x40>
}
80101c71:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c74:	5b                   	pop    %ebx
80101c75:	5e                   	pop    %esi
80101c76:	5d                   	pop    %ebp
80101c77:	c3                   	ret    
80101c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c7f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c80:	8b 43 04             	mov    0x4(%ebx),%eax
80101c83:	83 ec 08             	sub    $0x8,%esp
80101c86:	c1 e8 03             	shr    $0x3,%eax
80101c89:	03 05 e8 27 11 80    	add    0x801127e8,%eax
80101c8f:	50                   	push   %eax
80101c90:	ff 33                	push   (%ebx)
80101c92:	e8 39 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c97:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c9a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c9c:	8b 43 04             	mov    0x4(%ebx),%eax
80101c9f:	83 e0 07             	and    $0x7,%eax
80101ca2:	c1 e0 06             	shl    $0x6,%eax
80101ca5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ca9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101caf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cb3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101cb7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101cbb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101cbf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101cc3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101cc7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101ccb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101cce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cd1:	6a 34                	push   $0x34
80101cd3:	50                   	push   %eax
80101cd4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101cd7:	50                   	push   %eax
80101cd8:	e8 93 2f 00 00       	call   80104c70 <memmove>
    brelse(bp);
80101cdd:	89 34 24             	mov    %esi,(%esp)
80101ce0:	e8 0b e5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101ce5:	83 c4 10             	add    $0x10,%esp
80101ce8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101ced:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101cf4:	0f 85 77 ff ff ff    	jne    80101c71 <ilock+0x31>
      panic("ilock: no type");
80101cfa:	83 ec 0c             	sub    $0xc,%esp
80101cfd:	68 c8 79 10 80       	push   $0x801079c8
80101d02:	e8 79 e6 ff ff       	call   80100380 <panic>
    panic("ilock");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 c2 79 10 80       	push   $0x801079c2
80101d0f:	e8 6c e6 ff ff       	call   80100380 <panic>
80101d14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d1f:	90                   	nop

80101d20 <iunlock>:
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	56                   	push   %esi
80101d24:	53                   	push   %ebx
80101d25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d28:	85 db                	test   %ebx,%ebx
80101d2a:	74 28                	je     80101d54 <iunlock+0x34>
80101d2c:	83 ec 0c             	sub    $0xc,%esp
80101d2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d32:	56                   	push   %esi
80101d33:	e8 b8 2b 00 00       	call   801048f0 <holdingsleep>
80101d38:	83 c4 10             	add    $0x10,%esp
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 15                	je     80101d54 <iunlock+0x34>
80101d3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d42:	85 c0                	test   %eax,%eax
80101d44:	7e 0e                	jle    80101d54 <iunlock+0x34>
  releasesleep(&ip->lock);
80101d46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d4c:	5b                   	pop    %ebx
80101d4d:	5e                   	pop    %esi
80101d4e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d4f:	e9 5c 2b 00 00       	jmp    801048b0 <releasesleep>
    panic("iunlock");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 d7 79 10 80       	push   $0x801079d7
80101d5c:	e8 1f e6 ff ff       	call   80100380 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <iput>:
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	83 ec 28             	sub    $0x28,%esp
80101d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d7f:	57                   	push   %edi
80101d80:	e8 cb 2a 00 00       	call   80104850 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d88:	83 c4 10             	add    $0x10,%esp
80101d8b:	85 d2                	test   %edx,%edx
80101d8d:	74 07                	je     80101d96 <iput+0x26>
80101d8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101d94:	74 32                	je     80101dc8 <iput+0x58>
  releasesleep(&ip->lock);
80101d96:	83 ec 0c             	sub    $0xc,%esp
80101d99:	57                   	push   %edi
80101d9a:	e8 11 2b 00 00       	call   801048b0 <releasesleep>
  acquire(&icache.lock);
80101d9f:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101da6:	e8 65 2d 00 00       	call   80104b10 <acquire>
  ip->ref--;
80101dab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101daf:	83 c4 10             	add    $0x10,%esp
80101db2:	c7 45 08 80 0b 11 80 	movl   $0x80110b80,0x8(%ebp)
}
80101db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbc:	5b                   	pop    %ebx
80101dbd:	5e                   	pop    %esi
80101dbe:	5f                   	pop    %edi
80101dbf:	5d                   	pop    %ebp
  release(&icache.lock);
80101dc0:	e9 eb 2c 00 00       	jmp    80104ab0 <release>
80101dc5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	68 80 0b 11 80       	push   $0x80110b80
80101dd0:	e8 3b 2d 00 00       	call   80104b10 <acquire>
    int r = ip->ref;
80101dd5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101dd8:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101ddf:	e8 cc 2c 00 00       	call   80104ab0 <release>
    if(r == 1){
80101de4:	83 c4 10             	add    $0x10,%esp
80101de7:	83 fe 01             	cmp    $0x1,%esi
80101dea:	75 aa                	jne    80101d96 <iput+0x26>
80101dec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101df2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101df5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101df8:	89 cf                	mov    %ecx,%edi
80101dfa:	eb 0b                	jmp    80101e07 <iput+0x97>
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e00:	83 c6 04             	add    $0x4,%esi
80101e03:	39 fe                	cmp    %edi,%esi
80101e05:	74 19                	je     80101e20 <iput+0xb0>
    if(ip->addrs[i]){
80101e07:	8b 16                	mov    (%esi),%edx
80101e09:	85 d2                	test   %edx,%edx
80101e0b:	74 f3                	je     80101e00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101e0d:	8b 03                	mov    (%ebx),%eax
80101e0f:	e8 6c f8 ff ff       	call   80101680 <bfree>
      ip->addrs[i] = 0;
80101e14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e1a:	eb e4                	jmp    80101e00 <iput+0x90>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e29:	85 c0                	test   %eax,%eax
80101e2b:	75 2d                	jne    80101e5a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e2d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e37:	53                   	push   %ebx
80101e38:	e8 53 fd ff ff       	call   80101b90 <iupdate>
      ip->type = 0;
80101e3d:	31 c0                	xor    %eax,%eax
80101e3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e43:	89 1c 24             	mov    %ebx,(%esp)
80101e46:	e8 45 fd ff ff       	call   80101b90 <iupdate>
      ip->valid = 0;
80101e4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e52:	83 c4 10             	add    $0x10,%esp
80101e55:	e9 3c ff ff ff       	jmp    80101d96 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e5a:	83 ec 08             	sub    $0x8,%esp
80101e5d:	50                   	push   %eax
80101e5e:	ff 33                	push   (%ebx)
80101e60:	e8 6b e2 ff ff       	call   801000d0 <bread>
80101e65:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e68:	83 c4 10             	add    $0x10,%esp
80101e6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e74:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e77:	89 cf                	mov    %ecx,%edi
80101e79:	eb 0c                	jmp    80101e87 <iput+0x117>
80101e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e7f:	90                   	nop
80101e80:	83 c6 04             	add    $0x4,%esi
80101e83:	39 f7                	cmp    %esi,%edi
80101e85:	74 0f                	je     80101e96 <iput+0x126>
      if(a[j])
80101e87:	8b 16                	mov    (%esi),%edx
80101e89:	85 d2                	test   %edx,%edx
80101e8b:	74 f3                	je     80101e80 <iput+0x110>
        bfree(ip->dev, a[j]);
80101e8d:	8b 03                	mov    (%ebx),%eax
80101e8f:	e8 ec f7 ff ff       	call   80101680 <bfree>
80101e94:	eb ea                	jmp    80101e80 <iput+0x110>
    brelse(bp);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	ff 75 e4             	push   -0x1c(%ebp)
80101e9c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e9f:	e8 4c e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ea4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101eaa:	8b 03                	mov    (%ebx),%eax
80101eac:	e8 cf f7 ff ff       	call   80101680 <bfree>
    ip->addrs[NDIRECT] = 0;
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ebb:	00 00 00 
80101ebe:	e9 6a ff ff ff       	jmp    80101e2d <iput+0xbd>
80101ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ed0 <iunlockput>:
{
80101ed0:	55                   	push   %ebp
80101ed1:	89 e5                	mov    %esp,%ebp
80101ed3:	56                   	push   %esi
80101ed4:	53                   	push   %ebx
80101ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ed8:	85 db                	test   %ebx,%ebx
80101eda:	74 34                	je     80101f10 <iunlockput+0x40>
80101edc:	83 ec 0c             	sub    $0xc,%esp
80101edf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ee2:	56                   	push   %esi
80101ee3:	e8 08 2a 00 00       	call   801048f0 <holdingsleep>
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	74 21                	je     80101f10 <iunlockput+0x40>
80101eef:	8b 43 08             	mov    0x8(%ebx),%eax
80101ef2:	85 c0                	test   %eax,%eax
80101ef4:	7e 1a                	jle    80101f10 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ef6:	83 ec 0c             	sub    $0xc,%esp
80101ef9:	56                   	push   %esi
80101efa:	e8 b1 29 00 00       	call   801048b0 <releasesleep>
  iput(ip);
80101eff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f02:	83 c4 10             	add    $0x10,%esp
}
80101f05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f08:	5b                   	pop    %ebx
80101f09:	5e                   	pop    %esi
80101f0a:	5d                   	pop    %ebp
  iput(ip);
80101f0b:	e9 60 fe ff ff       	jmp    80101d70 <iput>
    panic("iunlock");
80101f10:	83 ec 0c             	sub    $0xc,%esp
80101f13:	68 d7 79 10 80       	push   $0x801079d7
80101f18:	e8 63 e4 ff ff       	call   80100380 <panic>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

80101f20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	8b 55 08             	mov    0x8(%ebp),%edx
80101f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f29:	8b 0a                	mov    (%edx),%ecx
80101f2b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f2e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f31:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f34:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f38:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f3b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f3f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f43:	8b 52 58             	mov    0x58(%edx),%edx
80101f46:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f49:	5d                   	pop    %ebp
80101f4a:	c3                   	ret    
80101f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f4f:	90                   	nop

80101f50 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 1c             	sub    $0x1c,%esp
80101f59:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5f:	8b 75 10             	mov    0x10(%ebp),%esi
80101f62:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f65:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f68:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f70:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101f73:	0f 84 a7 00 00 00    	je     80102020 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101f79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f7c:	8b 40 58             	mov    0x58(%eax),%eax
80101f7f:	39 c6                	cmp    %eax,%esi
80101f81:	0f 87 ba 00 00 00    	ja     80102041 <readi+0xf1>
80101f87:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101f8a:	31 c9                	xor    %ecx,%ecx
80101f8c:	89 da                	mov    %ebx,%edx
80101f8e:	01 f2                	add    %esi,%edx
80101f90:	0f 92 c1             	setb   %cl
80101f93:	89 cf                	mov    %ecx,%edi
80101f95:	0f 82 a6 00 00 00    	jb     80102041 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101f9b:	89 c1                	mov    %eax,%ecx
80101f9d:	29 f1                	sub    %esi,%ecx
80101f9f:	39 d0                	cmp    %edx,%eax
80101fa1:	0f 43 cb             	cmovae %ebx,%ecx
80101fa4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fa7:	85 c9                	test   %ecx,%ecx
80101fa9:	74 67                	je     80102012 <readi+0xc2>
80101fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101faf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101fb3:	89 f2                	mov    %esi,%edx
80101fb5:	c1 ea 09             	shr    $0x9,%edx
80101fb8:	89 d8                	mov    %ebx,%eax
80101fba:	e8 51 f9 ff ff       	call   80101910 <bmap>
80101fbf:	83 ec 08             	sub    $0x8,%esp
80101fc2:	50                   	push   %eax
80101fc3:	ff 33                	push   (%ebx)
80101fc5:	e8 06 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101fca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fcd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fd2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd4:	89 f0                	mov    %esi,%eax
80101fd6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fdb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fdd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101fe2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe6:	39 d9                	cmp    %ebx,%ecx
80101fe8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101feb:	83 c4 0c             	add    $0xc,%esp
80101fee:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fef:	01 df                	add    %ebx,%edi
80101ff1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ff3:	50                   	push   %eax
80101ff4:	ff 75 e0             	push   -0x20(%ebp)
80101ff7:	e8 74 2c 00 00       	call   80104c70 <memmove>
    brelse(bp);
80101ffc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fff:	89 14 24             	mov    %edx,(%esp)
80102002:	e8 e9 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102007:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010200a:	83 c4 10             	add    $0x10,%esp
8010200d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102010:	77 9e                	ja     80101fb0 <readi+0x60>
  }
  return n;
80102012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102015:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5f                   	pop    %edi
8010201b:	5d                   	pop    %ebp
8010201c:	c3                   	ret    
8010201d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102020:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102024:	66 83 f8 09          	cmp    $0x9,%ax
80102028:	77 17                	ja     80102041 <readi+0xf1>
8010202a:	8b 04 c5 20 0b 11 80 	mov    -0x7feef4e0(,%eax,8),%eax
80102031:	85 c0                	test   %eax,%eax
80102033:	74 0c                	je     80102041 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102035:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5f                   	pop    %edi
8010203e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010203f:	ff e0                	jmp    *%eax
      return -1;
80102041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102046:	eb cd                	jmp    80102015 <readi+0xc5>
80102048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010204f:	90                   	nop

80102050 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 1c             	sub    $0x1c,%esp
80102059:	8b 45 08             	mov    0x8(%ebp),%eax
8010205c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010205f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102062:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102067:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010206a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010206d:	8b 75 10             	mov    0x10(%ebp),%esi
80102070:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102073:	0f 84 b7 00 00 00    	je     80102130 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102079:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010207c:	3b 70 58             	cmp    0x58(%eax),%esi
8010207f:	0f 87 e7 00 00 00    	ja     8010216c <writei+0x11c>
80102085:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102088:	31 d2                	xor    %edx,%edx
8010208a:	89 f8                	mov    %edi,%eax
8010208c:	01 f0                	add    %esi,%eax
8010208e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102091:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102096:	0f 87 d0 00 00 00    	ja     8010216c <writei+0x11c>
8010209c:	85 d2                	test   %edx,%edx
8010209e:	0f 85 c8 00 00 00    	jne    8010216c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801020ab:	85 ff                	test   %edi,%edi
801020ad:	74 72                	je     80102121 <writei+0xd1>
801020af:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020b0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801020b3:	89 f2                	mov    %esi,%edx
801020b5:	c1 ea 09             	shr    $0x9,%edx
801020b8:	89 f8                	mov    %edi,%eax
801020ba:	e8 51 f8 ff ff       	call   80101910 <bmap>
801020bf:	83 ec 08             	sub    $0x8,%esp
801020c2:	50                   	push   %eax
801020c3:	ff 37                	push   (%edi)
801020c5:	e8 06 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020ca:	b9 00 02 00 00       	mov    $0x200,%ecx
801020cf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801020d2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020d5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020de:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801020e0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020e4:	39 d9                	cmp    %ebx,%ecx
801020e6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801020e9:	83 c4 0c             	add    $0xc,%esp
801020ec:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020ed:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801020ef:	ff 75 dc             	push   -0x24(%ebp)
801020f2:	50                   	push   %eax
801020f3:	e8 78 2b 00 00       	call   80104c70 <memmove>
    log_write(bp);
801020f8:	89 3c 24             	mov    %edi,(%esp)
801020fb:	e8 00 13 00 00       	call   80103400 <log_write>
    brelse(bp);
80102100:	89 3c 24             	mov    %edi,(%esp)
80102103:	e8 e8 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102108:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102111:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102114:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102117:	77 97                	ja     801020b0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102119:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010211c:	3b 70 58             	cmp    0x58(%eax),%esi
8010211f:	77 37                	ja     80102158 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102121:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102130:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102134:	66 83 f8 09          	cmp    $0x9,%ax
80102138:	77 32                	ja     8010216c <writei+0x11c>
8010213a:	8b 04 c5 24 0b 11 80 	mov    -0x7feef4dc(,%eax,8),%eax
80102141:	85 c0                	test   %eax,%eax
80102143:	74 27                	je     8010216c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102145:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214b:	5b                   	pop    %ebx
8010214c:	5e                   	pop    %esi
8010214d:	5f                   	pop    %edi
8010214e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010214f:	ff e0                	jmp    *%eax
80102151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102158:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010215b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010215e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102161:	50                   	push   %eax
80102162:	e8 29 fa ff ff       	call   80101b90 <iupdate>
80102167:	83 c4 10             	add    $0x10,%esp
8010216a:	eb b5                	jmp    80102121 <writei+0xd1>
      return -1;
8010216c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102171:	eb b1                	jmp    80102124 <writei+0xd4>
80102173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102180 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102186:	6a 0e                	push   $0xe
80102188:	ff 75 0c             	push   0xc(%ebp)
8010218b:	ff 75 08             	push   0x8(%ebp)
8010218e:	e8 4d 2b 00 00       	call   80104ce0 <strncmp>
}
80102193:	c9                   	leave  
80102194:	c3                   	ret    
80102195:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021a0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	57                   	push   %edi
801021a4:	56                   	push   %esi
801021a5:	53                   	push   %ebx
801021a6:	83 ec 1c             	sub    $0x1c,%esp
801021a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021b1:	0f 85 85 00 00 00    	jne    8010223c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021b7:	8b 53 58             	mov    0x58(%ebx),%edx
801021ba:	31 ff                	xor    %edi,%edi
801021bc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021bf:	85 d2                	test   %edx,%edx
801021c1:	74 3e                	je     80102201 <dirlookup+0x61>
801021c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c8:	6a 10                	push   $0x10
801021ca:	57                   	push   %edi
801021cb:	56                   	push   %esi
801021cc:	53                   	push   %ebx
801021cd:	e8 7e fd ff ff       	call   80101f50 <readi>
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	83 f8 10             	cmp    $0x10,%eax
801021d8:	75 55                	jne    8010222f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801021da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021df:	74 18                	je     801021f9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801021e1:	83 ec 04             	sub    $0x4,%esp
801021e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801021e7:	6a 0e                	push   $0xe
801021e9:	50                   	push   %eax
801021ea:	ff 75 0c             	push   0xc(%ebp)
801021ed:	e8 ee 2a 00 00       	call   80104ce0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801021f2:	83 c4 10             	add    $0x10,%esp
801021f5:	85 c0                	test   %eax,%eax
801021f7:	74 17                	je     80102210 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021f9:	83 c7 10             	add    $0x10,%edi
801021fc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021ff:	72 c7                	jb     801021c8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102204:	31 c0                	xor    %eax,%eax
}
80102206:	5b                   	pop    %ebx
80102207:	5e                   	pop    %esi
80102208:	5f                   	pop    %edi
80102209:	5d                   	pop    %ebp
8010220a:	c3                   	ret    
8010220b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010220f:	90                   	nop
      if(poff)
80102210:	8b 45 10             	mov    0x10(%ebp),%eax
80102213:	85 c0                	test   %eax,%eax
80102215:	74 05                	je     8010221c <dirlookup+0x7c>
        *poff = off;
80102217:	8b 45 10             	mov    0x10(%ebp),%eax
8010221a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010221c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102220:	8b 03                	mov    (%ebx),%eax
80102222:	e8 e9 f5 ff ff       	call   80101810 <iget>
}
80102227:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010222a:	5b                   	pop    %ebx
8010222b:	5e                   	pop    %esi
8010222c:	5f                   	pop    %edi
8010222d:	5d                   	pop    %ebp
8010222e:	c3                   	ret    
      panic("dirlookup read");
8010222f:	83 ec 0c             	sub    $0xc,%esp
80102232:	68 f1 79 10 80       	push   $0x801079f1
80102237:	e8 44 e1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010223c:	83 ec 0c             	sub    $0xc,%esp
8010223f:	68 df 79 10 80       	push   $0x801079df
80102244:	e8 37 e1 ff ff       	call   80100380 <panic>
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102250 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	89 c3                	mov    %eax,%ebx
80102258:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010225b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010225e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102261:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102264:	0f 84 64 01 00 00    	je     801023ce <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010226a:	e8 c1 1b 00 00       	call   80103e30 <myproc>
  acquire(&icache.lock);
8010226f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102272:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102275:	68 80 0b 11 80       	push   $0x80110b80
8010227a:	e8 91 28 00 00       	call   80104b10 <acquire>
  ip->ref++;
8010227f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102283:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
8010228a:	e8 21 28 00 00       	call   80104ab0 <release>
8010228f:	83 c4 10             	add    $0x10,%esp
80102292:	eb 07                	jmp    8010229b <namex+0x4b>
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102298:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010229b:	0f b6 03             	movzbl (%ebx),%eax
8010229e:	3c 2f                	cmp    $0x2f,%al
801022a0:	74 f6                	je     80102298 <namex+0x48>
  if(*path == 0)
801022a2:	84 c0                	test   %al,%al
801022a4:	0f 84 06 01 00 00    	je     801023b0 <namex+0x160>
  while(*path != '/' && *path != 0)
801022aa:	0f b6 03             	movzbl (%ebx),%eax
801022ad:	84 c0                	test   %al,%al
801022af:	0f 84 10 01 00 00    	je     801023c5 <namex+0x175>
801022b5:	89 df                	mov    %ebx,%edi
801022b7:	3c 2f                	cmp    $0x2f,%al
801022b9:	0f 84 06 01 00 00    	je     801023c5 <namex+0x175>
801022bf:	90                   	nop
801022c0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801022c4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801022c7:	3c 2f                	cmp    $0x2f,%al
801022c9:	74 04                	je     801022cf <namex+0x7f>
801022cb:	84 c0                	test   %al,%al
801022cd:	75 f1                	jne    801022c0 <namex+0x70>
  len = path - s;
801022cf:	89 f8                	mov    %edi,%eax
801022d1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801022d3:	83 f8 0d             	cmp    $0xd,%eax
801022d6:	0f 8e ac 00 00 00    	jle    80102388 <namex+0x138>
    memmove(name, s, DIRSIZ);
801022dc:	83 ec 04             	sub    $0x4,%esp
801022df:	6a 0e                	push   $0xe
801022e1:	53                   	push   %ebx
    path++;
801022e2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801022e4:	ff 75 e4             	push   -0x1c(%ebp)
801022e7:	e8 84 29 00 00       	call   80104c70 <memmove>
801022ec:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801022ef:	80 3f 2f             	cmpb   $0x2f,(%edi)
801022f2:	75 0c                	jne    80102300 <namex+0xb0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022f8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801022fb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801022fe:	74 f8                	je     801022f8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	56                   	push   %esi
80102304:	e8 37 f9 ff ff       	call   80101c40 <ilock>
    if(ip->type != T_DIR){
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102311:	0f 85 cd 00 00 00    	jne    801023e4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102317:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 09                	je     80102327 <namex+0xd7>
8010231e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102321:	0f 84 22 01 00 00    	je     80102449 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102327:	83 ec 04             	sub    $0x4,%esp
8010232a:	6a 00                	push   $0x0
8010232c:	ff 75 e4             	push   -0x1c(%ebp)
8010232f:	56                   	push   %esi
80102330:	e8 6b fe ff ff       	call   801021a0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102335:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102338:	83 c4 10             	add    $0x10,%esp
8010233b:	89 c7                	mov    %eax,%edi
8010233d:	85 c0                	test   %eax,%eax
8010233f:	0f 84 e1 00 00 00    	je     80102426 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102345:	83 ec 0c             	sub    $0xc,%esp
80102348:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010234b:	52                   	push   %edx
8010234c:	e8 9f 25 00 00       	call   801048f0 <holdingsleep>
80102351:	83 c4 10             	add    $0x10,%esp
80102354:	85 c0                	test   %eax,%eax
80102356:	0f 84 30 01 00 00    	je     8010248c <namex+0x23c>
8010235c:	8b 56 08             	mov    0x8(%esi),%edx
8010235f:	85 d2                	test   %edx,%edx
80102361:	0f 8e 25 01 00 00    	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102367:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010236a:	83 ec 0c             	sub    $0xc,%esp
8010236d:	52                   	push   %edx
8010236e:	e8 3d 25 00 00       	call   801048b0 <releasesleep>
  iput(ip);
80102373:	89 34 24             	mov    %esi,(%esp)
80102376:	89 fe                	mov    %edi,%esi
80102378:	e8 f3 f9 ff ff       	call   80101d70 <iput>
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	e9 16 ff ff ff       	jmp    8010229b <namex+0x4b>
80102385:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102388:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010238b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010238e:	83 ec 04             	sub    $0x4,%esp
80102391:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102394:	50                   	push   %eax
80102395:	53                   	push   %ebx
    name[len] = 0;
80102396:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102398:	ff 75 e4             	push   -0x1c(%ebp)
8010239b:	e8 d0 28 00 00       	call   80104c70 <memmove>
    name[len] = 0;
801023a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801023a3:	83 c4 10             	add    $0x10,%esp
801023a6:	c6 02 00             	movb   $0x0,(%edx)
801023a9:	e9 41 ff ff ff       	jmp    801022ef <namex+0x9f>
801023ae:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801023b3:	85 c0                	test   %eax,%eax
801023b5:	0f 85 be 00 00 00    	jne    80102479 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801023bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023be:	89 f0                	mov    %esi,%eax
801023c0:	5b                   	pop    %ebx
801023c1:	5e                   	pop    %esi
801023c2:	5f                   	pop    %edi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801023c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801023c8:	89 df                	mov    %ebx,%edi
801023ca:	31 c0                	xor    %eax,%eax
801023cc:	eb c0                	jmp    8010238e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801023ce:	ba 01 00 00 00       	mov    $0x1,%edx
801023d3:	b8 01 00 00 00       	mov    $0x1,%eax
801023d8:	e8 33 f4 ff ff       	call   80101810 <iget>
801023dd:	89 c6                	mov    %eax,%esi
801023df:	e9 b7 fe ff ff       	jmp    8010229b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801023e4:	83 ec 0c             	sub    $0xc,%esp
801023e7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801023ea:	53                   	push   %ebx
801023eb:	e8 00 25 00 00       	call   801048f0 <holdingsleep>
801023f0:	83 c4 10             	add    $0x10,%esp
801023f3:	85 c0                	test   %eax,%eax
801023f5:	0f 84 91 00 00 00    	je     8010248c <namex+0x23c>
801023fb:	8b 46 08             	mov    0x8(%esi),%eax
801023fe:	85 c0                	test   %eax,%eax
80102400:	0f 8e 86 00 00 00    	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102406:	83 ec 0c             	sub    $0xc,%esp
80102409:	53                   	push   %ebx
8010240a:	e8 a1 24 00 00       	call   801048b0 <releasesleep>
  iput(ip);
8010240f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102412:	31 f6                	xor    %esi,%esi
  iput(ip);
80102414:	e8 57 f9 ff ff       	call   80101d70 <iput>
      return 0;
80102419:	83 c4 10             	add    $0x10,%esp
}
8010241c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010241f:	89 f0                	mov    %esi,%eax
80102421:	5b                   	pop    %ebx
80102422:	5e                   	pop    %esi
80102423:	5f                   	pop    %edi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102426:	83 ec 0c             	sub    $0xc,%esp
80102429:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010242c:	52                   	push   %edx
8010242d:	e8 be 24 00 00       	call   801048f0 <holdingsleep>
80102432:	83 c4 10             	add    $0x10,%esp
80102435:	85 c0                	test   %eax,%eax
80102437:	74 53                	je     8010248c <namex+0x23c>
80102439:	8b 4e 08             	mov    0x8(%esi),%ecx
8010243c:	85 c9                	test   %ecx,%ecx
8010243e:	7e 4c                	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102443:	83 ec 0c             	sub    $0xc,%esp
80102446:	52                   	push   %edx
80102447:	eb c1                	jmp    8010240a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102449:	83 ec 0c             	sub    $0xc,%esp
8010244c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010244f:	53                   	push   %ebx
80102450:	e8 9b 24 00 00       	call   801048f0 <holdingsleep>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	85 c0                	test   %eax,%eax
8010245a:	74 30                	je     8010248c <namex+0x23c>
8010245c:	8b 7e 08             	mov    0x8(%esi),%edi
8010245f:	85 ff                	test   %edi,%edi
80102461:	7e 29                	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102463:	83 ec 0c             	sub    $0xc,%esp
80102466:	53                   	push   %ebx
80102467:	e8 44 24 00 00       	call   801048b0 <releasesleep>
}
8010246c:	83 c4 10             	add    $0x10,%esp
}
8010246f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102472:	89 f0                	mov    %esi,%eax
80102474:	5b                   	pop    %ebx
80102475:	5e                   	pop    %esi
80102476:	5f                   	pop    %edi
80102477:	5d                   	pop    %ebp
80102478:	c3                   	ret    
    iput(ip);
80102479:	83 ec 0c             	sub    $0xc,%esp
8010247c:	56                   	push   %esi
    return 0;
8010247d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010247f:	e8 ec f8 ff ff       	call   80101d70 <iput>
    return 0;
80102484:	83 c4 10             	add    $0x10,%esp
80102487:	e9 2f ff ff ff       	jmp    801023bb <namex+0x16b>
    panic("iunlock");
8010248c:	83 ec 0c             	sub    $0xc,%esp
8010248f:	68 d7 79 10 80       	push   $0x801079d7
80102494:	e8 e7 de ff ff       	call   80100380 <panic>
80102499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024a0 <dirlink>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	57                   	push   %edi
801024a4:	56                   	push   %esi
801024a5:	53                   	push   %ebx
801024a6:	83 ec 20             	sub    $0x20,%esp
801024a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801024ac:	6a 00                	push   $0x0
801024ae:	ff 75 0c             	push   0xc(%ebp)
801024b1:	53                   	push   %ebx
801024b2:	e8 e9 fc ff ff       	call   801021a0 <dirlookup>
801024b7:	83 c4 10             	add    $0x10,%esp
801024ba:	85 c0                	test   %eax,%eax
801024bc:	75 67                	jne    80102525 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801024be:	8b 7b 58             	mov    0x58(%ebx),%edi
801024c1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024c4:	85 ff                	test   %edi,%edi
801024c6:	74 29                	je     801024f1 <dirlink+0x51>
801024c8:	31 ff                	xor    %edi,%edi
801024ca:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024cd:	eb 09                	jmp    801024d8 <dirlink+0x38>
801024cf:	90                   	nop
801024d0:	83 c7 10             	add    $0x10,%edi
801024d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024d6:	73 19                	jae    801024f1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024d8:	6a 10                	push   $0x10
801024da:	57                   	push   %edi
801024db:	56                   	push   %esi
801024dc:	53                   	push   %ebx
801024dd:	e8 6e fa ff ff       	call   80101f50 <readi>
801024e2:	83 c4 10             	add    $0x10,%esp
801024e5:	83 f8 10             	cmp    $0x10,%eax
801024e8:	75 4e                	jne    80102538 <dirlink+0x98>
    if(de.inum == 0)
801024ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024ef:	75 df                	jne    801024d0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801024f1:	83 ec 04             	sub    $0x4,%esp
801024f4:	8d 45 da             	lea    -0x26(%ebp),%eax
801024f7:	6a 0e                	push   $0xe
801024f9:	ff 75 0c             	push   0xc(%ebp)
801024fc:	50                   	push   %eax
801024fd:	e8 2e 28 00 00       	call   80104d30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102502:	6a 10                	push   $0x10
  de.inum = inum;
80102504:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102507:	57                   	push   %edi
80102508:	56                   	push   %esi
80102509:	53                   	push   %ebx
  de.inum = inum;
8010250a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010250e:	e8 3d fb ff ff       	call   80102050 <writei>
80102513:	83 c4 20             	add    $0x20,%esp
80102516:	83 f8 10             	cmp    $0x10,%eax
80102519:	75 2a                	jne    80102545 <dirlink+0xa5>
  return 0;
8010251b:	31 c0                	xor    %eax,%eax
}
8010251d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102520:	5b                   	pop    %ebx
80102521:	5e                   	pop    %esi
80102522:	5f                   	pop    %edi
80102523:	5d                   	pop    %ebp
80102524:	c3                   	ret    
    iput(ip);
80102525:	83 ec 0c             	sub    $0xc,%esp
80102528:	50                   	push   %eax
80102529:	e8 42 f8 ff ff       	call   80101d70 <iput>
    return -1;
8010252e:	83 c4 10             	add    $0x10,%esp
80102531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102536:	eb e5                	jmp    8010251d <dirlink+0x7d>
      panic("dirlink read");
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	68 00 7a 10 80       	push   $0x80107a00
80102540:	e8 3b de ff ff       	call   80100380 <panic>
    panic("dirlink");
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	68 0a 80 10 80       	push   $0x8010800a
8010254d:	e8 2e de ff ff       	call   80100380 <panic>
80102552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102560 <namei>:

struct inode*
namei(char *path)
{
80102560:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102561:	31 d2                	xor    %edx,%edx
{
80102563:	89 e5                	mov    %esp,%ebp
80102565:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102568:	8b 45 08             	mov    0x8(%ebp),%eax
8010256b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010256e:	e8 dd fc ff ff       	call   80102250 <namex>
}
80102573:	c9                   	leave  
80102574:	c3                   	ret    
80102575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102580:	55                   	push   %ebp
  return namex(path, 1, name);
80102581:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102586:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102588:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010258b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010258e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010258f:	e9 bc fc ff ff       	jmp    80102250 <namex>
80102594:	66 90                	xchg   %ax,%ax
80102596:	66 90                	xchg   %ax,%ax
80102598:	66 90                	xchg   %ax,%ax
8010259a:	66 90                	xchg   %ax,%ax
8010259c:	66 90                	xchg   %ax,%ax
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	57                   	push   %edi
801025a4:	56                   	push   %esi
801025a5:	53                   	push   %ebx
801025a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801025a9:	85 c0                	test   %eax,%eax
801025ab:	0f 84 b4 00 00 00    	je     80102665 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025b1:	8b 70 08             	mov    0x8(%eax),%esi
801025b4:	89 c3                	mov    %eax,%ebx
801025b6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025bc:	0f 87 96 00 00 00    	ja     80102658 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ce:	66 90                	xchg   %ax,%ax
801025d0:	89 ca                	mov    %ecx,%edx
801025d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025d3:	83 e0 c0             	and    $0xffffffc0,%eax
801025d6:	3c 40                	cmp    $0x40,%al
801025d8:	75 f6                	jne    801025d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025da:	31 ff                	xor    %edi,%edi
801025dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025e1:	89 f8                	mov    %edi,%eax
801025e3:	ee                   	out    %al,(%dx)
801025e4:	b8 01 00 00 00       	mov    $0x1,%eax
801025e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025ee:	ee                   	out    %al,(%dx)
801025ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025f4:	89 f0                	mov    %esi,%eax
801025f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025f7:	89 f0                	mov    %esi,%eax
801025f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025fe:	c1 f8 08             	sar    $0x8,%eax
80102601:	ee                   	out    %al,(%dx)
80102602:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102607:	89 f8                	mov    %edi,%eax
80102609:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010260a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010260e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102613:	c1 e0 04             	shl    $0x4,%eax
80102616:	83 e0 10             	and    $0x10,%eax
80102619:	83 c8 e0             	or     $0xffffffe0,%eax
8010261c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010261d:	f6 03 04             	testb  $0x4,(%ebx)
80102620:	75 16                	jne    80102638 <idestart+0x98>
80102622:	b8 20 00 00 00       	mov    $0x20,%eax
80102627:	89 ca                	mov    %ecx,%edx
80102629:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010262a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010262d:	5b                   	pop    %ebx
8010262e:	5e                   	pop    %esi
8010262f:	5f                   	pop    %edi
80102630:	5d                   	pop    %ebp
80102631:	c3                   	ret    
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102638:	b8 30 00 00 00       	mov    $0x30,%eax
8010263d:	89 ca                	mov    %ecx,%edx
8010263f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102640:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102645:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102648:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010264d:	fc                   	cld    
8010264e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102650:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102653:	5b                   	pop    %ebx
80102654:	5e                   	pop    %esi
80102655:	5f                   	pop    %edi
80102656:	5d                   	pop    %ebp
80102657:	c3                   	ret    
    panic("incorrect blockno");
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	68 6c 7a 10 80       	push   $0x80107a6c
80102660:	e8 1b dd ff ff       	call   80100380 <panic>
    panic("idestart");
80102665:	83 ec 0c             	sub    $0xc,%esp
80102668:	68 63 7a 10 80       	push   $0x80107a63
8010266d:	e8 0e dd ff ff       	call   80100380 <panic>
80102672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102680 <ideinit>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102686:	68 7e 7a 10 80       	push   $0x80107a7e
8010268b:	68 20 28 11 80       	push   $0x80112820
80102690:	e8 ab 22 00 00       	call   80104940 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102695:	58                   	pop    %eax
80102696:	a1 a4 29 11 80       	mov    0x801129a4,%eax
8010269b:	5a                   	pop    %edx
8010269c:	83 e8 01             	sub    $0x1,%eax
8010269f:	50                   	push   %eax
801026a0:	6a 0e                	push   $0xe
801026a2:	e8 99 02 00 00       	call   80102940 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026a7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026aa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026af:	90                   	nop
801026b0:	ec                   	in     (%dx),%al
801026b1:	83 e0 c0             	and    $0xffffffc0,%eax
801026b4:	3c 40                	cmp    $0x40,%al
801026b6:	75 f8                	jne    801026b0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026bd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026c2:	ee                   	out    %al,(%dx)
801026c3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026cd:	eb 06                	jmp    801026d5 <ideinit+0x55>
801026cf:	90                   	nop
  for(i=0; i<1000; i++){
801026d0:	83 e9 01             	sub    $0x1,%ecx
801026d3:	74 0f                	je     801026e4 <ideinit+0x64>
801026d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026d6:	84 c0                	test   %al,%al
801026d8:	74 f6                	je     801026d0 <ideinit+0x50>
      havedisk1 = 1;
801026da:	c7 05 00 28 11 80 01 	movl   $0x1,0x80112800
801026e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026ee:	ee                   	out    %al,(%dx)
}
801026ef:	c9                   	leave  
801026f0:	c3                   	ret    
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop

80102700 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	57                   	push   %edi
80102704:	56                   	push   %esi
80102705:	53                   	push   %ebx
80102706:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102709:	68 20 28 11 80       	push   $0x80112820
8010270e:	e8 fd 23 00 00       	call   80104b10 <acquire>

  if((b = idequeue) == 0){
80102713:	8b 1d 04 28 11 80    	mov    0x80112804,%ebx
80102719:	83 c4 10             	add    $0x10,%esp
8010271c:	85 db                	test   %ebx,%ebx
8010271e:	74 63                	je     80102783 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102720:	8b 43 58             	mov    0x58(%ebx),%eax
80102723:	a3 04 28 11 80       	mov    %eax,0x80112804

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102728:	8b 33                	mov    (%ebx),%esi
8010272a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102730:	75 2f                	jne    80102761 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102732:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273e:	66 90                	xchg   %ax,%ax
80102740:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102741:	89 c1                	mov    %eax,%ecx
80102743:	83 e1 c0             	and    $0xffffffc0,%ecx
80102746:	80 f9 40             	cmp    $0x40,%cl
80102749:	75 f5                	jne    80102740 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010274b:	a8 21                	test   $0x21,%al
8010274d:	75 12                	jne    80102761 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010274f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102752:	b9 80 00 00 00       	mov    $0x80,%ecx
80102757:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010275c:	fc                   	cld    
8010275d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010275f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102761:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102764:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102767:	83 ce 02             	or     $0x2,%esi
8010276a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010276c:	53                   	push   %ebx
8010276d:	e8 4e 1e 00 00       	call   801045c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102772:	a1 04 28 11 80       	mov    0x80112804,%eax
80102777:	83 c4 10             	add    $0x10,%esp
8010277a:	85 c0                	test   %eax,%eax
8010277c:	74 05                	je     80102783 <ideintr+0x83>
    idestart(idequeue);
8010277e:	e8 1d fe ff ff       	call   801025a0 <idestart>
    release(&idelock);
80102783:	83 ec 0c             	sub    $0xc,%esp
80102786:	68 20 28 11 80       	push   $0x80112820
8010278b:	e8 20 23 00 00       	call   80104ab0 <release>

  release(&idelock);
}
80102790:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102793:	5b                   	pop    %ebx
80102794:	5e                   	pop    %esi
80102795:	5f                   	pop    %edi
80102796:	5d                   	pop    %ebp
80102797:	c3                   	ret    
80102798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279f:	90                   	nop

801027a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	53                   	push   %ebx
801027a4:	83 ec 10             	sub    $0x10,%esp
801027a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801027aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801027ad:	50                   	push   %eax
801027ae:	e8 3d 21 00 00       	call   801048f0 <holdingsleep>
801027b3:	83 c4 10             	add    $0x10,%esp
801027b6:	85 c0                	test   %eax,%eax
801027b8:	0f 84 c3 00 00 00    	je     80102881 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027be:	8b 03                	mov    (%ebx),%eax
801027c0:	83 e0 06             	and    $0x6,%eax
801027c3:	83 f8 02             	cmp    $0x2,%eax
801027c6:	0f 84 a8 00 00 00    	je     80102874 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027cc:	8b 53 04             	mov    0x4(%ebx),%edx
801027cf:	85 d2                	test   %edx,%edx
801027d1:	74 0d                	je     801027e0 <iderw+0x40>
801027d3:	a1 00 28 11 80       	mov    0x80112800,%eax
801027d8:	85 c0                	test   %eax,%eax
801027da:	0f 84 87 00 00 00    	je     80102867 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 20 28 11 80       	push   $0x80112820
801027e8:	e8 23 23 00 00       	call   80104b10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ed:	a1 04 28 11 80       	mov    0x80112804,%eax
  b->qnext = 0;
801027f2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027f9:	83 c4 10             	add    $0x10,%esp
801027fc:	85 c0                	test   %eax,%eax
801027fe:	74 60                	je     80102860 <iderw+0xc0>
80102800:	89 c2                	mov    %eax,%edx
80102802:	8b 40 58             	mov    0x58(%eax),%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	75 f7                	jne    80102800 <iderw+0x60>
80102809:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010280c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010280e:	39 1d 04 28 11 80    	cmp    %ebx,0x80112804
80102814:	74 3a                	je     80102850 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102816:	8b 03                	mov    (%ebx),%eax
80102818:	83 e0 06             	and    $0x6,%eax
8010281b:	83 f8 02             	cmp    $0x2,%eax
8010281e:	74 1b                	je     8010283b <iderw+0x9b>
    sleep(b, &idelock);
80102820:	83 ec 08             	sub    $0x8,%esp
80102823:	68 20 28 11 80       	push   $0x80112820
80102828:	53                   	push   %ebx
80102829:	e8 d2 1c 00 00       	call   80104500 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010282e:	8b 03                	mov    (%ebx),%eax
80102830:	83 c4 10             	add    $0x10,%esp
80102833:	83 e0 06             	and    $0x6,%eax
80102836:	83 f8 02             	cmp    $0x2,%eax
80102839:	75 e5                	jne    80102820 <iderw+0x80>
  }


  release(&idelock);
8010283b:	c7 45 08 20 28 11 80 	movl   $0x80112820,0x8(%ebp)
}
80102842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102845:	c9                   	leave  
  release(&idelock);
80102846:	e9 65 22 00 00       	jmp    80104ab0 <release>
8010284b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010284f:	90                   	nop
    idestart(b);
80102850:	89 d8                	mov    %ebx,%eax
80102852:	e8 49 fd ff ff       	call   801025a0 <idestart>
80102857:	eb bd                	jmp    80102816 <iderw+0x76>
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102860:	ba 04 28 11 80       	mov    $0x80112804,%edx
80102865:	eb a5                	jmp    8010280c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102867:	83 ec 0c             	sub    $0xc,%esp
8010286a:	68 ad 7a 10 80       	push   $0x80107aad
8010286f:	e8 0c db ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102874:	83 ec 0c             	sub    $0xc,%esp
80102877:	68 98 7a 10 80       	push   $0x80107a98
8010287c:	e8 ff da ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102881:	83 ec 0c             	sub    $0xc,%esp
80102884:	68 82 7a 10 80       	push   $0x80107a82
80102889:	e8 f2 da ff ff       	call   80100380 <panic>
8010288e:	66 90                	xchg   %ax,%ax

80102890 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102890:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102891:	c7 05 54 28 11 80 00 	movl   $0xfec00000,0x80112854
80102898:	00 c0 fe 
{
8010289b:	89 e5                	mov    %esp,%ebp
8010289d:	56                   	push   %esi
8010289e:	53                   	push   %ebx
  ioapic->reg = reg;
8010289f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028a6:	00 00 00 
  return ioapic->data;
801028a9:	8b 15 54 28 11 80    	mov    0x80112854,%edx
801028af:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801028b2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801028b8:	8b 0d 54 28 11 80    	mov    0x80112854,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801028be:	0f b6 15 a0 29 11 80 	movzbl 0x801129a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028c5:	c1 ee 10             	shr    $0x10,%esi
801028c8:	89 f0                	mov    %esi,%eax
801028ca:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028cd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801028d0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028d3:	39 c2                	cmp    %eax,%edx
801028d5:	74 16                	je     801028ed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028d7:	83 ec 0c             	sub    $0xc,%esp
801028da:	68 cc 7a 10 80       	push   $0x80107acc
801028df:	e8 bc dd ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
801028e4:	8b 0d 54 28 11 80    	mov    0x80112854,%ecx
801028ea:	83 c4 10             	add    $0x10,%esp
801028ed:	83 c6 21             	add    $0x21,%esi
{
801028f0:	ba 10 00 00 00       	mov    $0x10,%edx
801028f5:	b8 20 00 00 00       	mov    $0x20,%eax
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102900:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102902:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102904:	8b 0d 54 28 11 80    	mov    0x80112854,%ecx
  for(i = 0; i <= maxintr; i++){
8010290a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010290d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102913:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102916:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102919:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010291c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010291e:	8b 0d 54 28 11 80    	mov    0x80112854,%ecx
80102924:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010292b:	39 f0                	cmp    %esi,%eax
8010292d:	75 d1                	jne    80102900 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010292f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102932:	5b                   	pop    %ebx
80102933:	5e                   	pop    %esi
80102934:	5d                   	pop    %ebp
80102935:	c3                   	ret    
80102936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293d:	8d 76 00             	lea    0x0(%esi),%esi

80102940 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102940:	55                   	push   %ebp
  ioapic->reg = reg;
80102941:	8b 0d 54 28 11 80    	mov    0x80112854,%ecx
{
80102947:	89 e5                	mov    %esp,%ebp
80102949:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010294c:	8d 50 20             	lea    0x20(%eax),%edx
8010294f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102953:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102955:	8b 0d 54 28 11 80    	mov    0x80112854,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010295b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010295e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102961:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102964:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102966:	a1 54 28 11 80       	mov    0x80112854,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010296b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010296e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102971:	5d                   	pop    %ebp
80102972:	c3                   	ret    
80102973:	66 90                	xchg   %ax,%ax
80102975:	66 90                	xchg   %ax,%ax
80102977:	66 90                	xchg   %ax,%ax
80102979:	66 90                	xchg   %ax,%ax
8010297b:	66 90                	xchg   %ax,%ax
8010297d:	66 90                	xchg   %ax,%ax
8010297f:	90                   	nop

80102980 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	53                   	push   %ebx
80102984:	83 ec 04             	sub    $0x4,%esp
80102987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010298a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102990:	75 76                	jne    80102a08 <kfree+0x88>
80102992:	81 fb b0 fd 12 80    	cmp    $0x8012fdb0,%ebx
80102998:	72 6e                	jb     80102a08 <kfree+0x88>
8010299a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029a5:	77 61                	ja     80102a08 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801029a7:	83 ec 04             	sub    $0x4,%esp
801029aa:	68 00 10 00 00       	push   $0x1000
801029af:	6a 01                	push   $0x1
801029b1:	53                   	push   %ebx
801029b2:	e8 19 22 00 00       	call   80104bd0 <memset>

  if(kmem.use_lock)
801029b7:	8b 15 94 28 11 80    	mov    0x80112894,%edx
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	85 d2                	test   %edx,%edx
801029c2:	75 1c                	jne    801029e0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029c4:	a1 98 28 11 80       	mov    0x80112898,%eax
801029c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029cb:	a1 94 28 11 80       	mov    0x80112894,%eax
  kmem.freelist = r;
801029d0:	89 1d 98 28 11 80    	mov    %ebx,0x80112898
  if(kmem.use_lock)
801029d6:	85 c0                	test   %eax,%eax
801029d8:	75 1e                	jne    801029f8 <kfree+0x78>
    release(&kmem.lock);
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave  
801029de:	c3                   	ret    
801029df:	90                   	nop
    acquire(&kmem.lock);
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	68 60 28 11 80       	push   $0x80112860
801029e8:	e8 23 21 00 00       	call   80104b10 <acquire>
801029ed:	83 c4 10             	add    $0x10,%esp
801029f0:	eb d2                	jmp    801029c4 <kfree+0x44>
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029f8:	c7 45 08 60 28 11 80 	movl   $0x80112860,0x8(%ebp)
}
801029ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a02:	c9                   	leave  
    release(&kmem.lock);
80102a03:	e9 a8 20 00 00       	jmp    80104ab0 <release>
    panic("kfree");
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	68 fe 7a 10 80       	push   $0x80107afe
80102a10:	e8 6b d9 ff ff       	call   80100380 <panic>
80102a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <freerange>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a24:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a27:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a2a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a3d:	39 de                	cmp    %ebx,%esi
80102a3f:	72 23                	jb     80102a64 <freerange+0x44>
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a48:	83 ec 0c             	sub    $0xc,%esp
80102a4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a57:	50                   	push   %eax
80102a58:	e8 23 ff ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a5d:	83 c4 10             	add    $0x10,%esp
80102a60:	39 f3                	cmp    %esi,%ebx
80102a62:	76 e4                	jbe    80102a48 <freerange+0x28>
}
80102a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a67:	5b                   	pop    %ebx
80102a68:	5e                   	pop    %esi
80102a69:	5d                   	pop    %ebp
80102a6a:	c3                   	ret    
80102a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a6f:	90                   	nop

80102a70 <kinit2>:
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a74:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a77:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a7a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a7b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a81:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a87:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a8d:	39 de                	cmp    %ebx,%esi
80102a8f:	72 23                	jb     80102ab4 <kinit2+0x44>
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a98:	83 ec 0c             	sub    $0xc,%esp
80102a9b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102aa7:	50                   	push   %eax
80102aa8:	e8 d3 fe ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aad:	83 c4 10             	add    $0x10,%esp
80102ab0:	39 de                	cmp    %ebx,%esi
80102ab2:	73 e4                	jae    80102a98 <kinit2+0x28>
  kmem.use_lock = 1;
80102ab4:	c7 05 94 28 11 80 01 	movl   $0x1,0x80112894
80102abb:	00 00 00 
}
80102abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac1:	5b                   	pop    %ebx
80102ac2:	5e                   	pop    %esi
80102ac3:	5d                   	pop    %ebp
80102ac4:	c3                   	ret    
80102ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <kinit1>:
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
80102ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102ad8:	83 ec 08             	sub    $0x8,%esp
80102adb:	68 04 7b 10 80       	push   $0x80107b04
80102ae0:	68 60 28 11 80       	push   $0x80112860
80102ae5:	e8 56 1e 00 00       	call   80104940 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102aea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102af0:	c7 05 94 28 11 80 00 	movl   $0x0,0x80112894
80102af7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102afa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b0c:	39 de                	cmp    %ebx,%esi
80102b0e:	72 1c                	jb     80102b2c <kinit1+0x5c>
    kfree(p);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b1f:	50                   	push   %eax
80102b20:	e8 5b fe ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b25:	83 c4 10             	add    $0x10,%esp
80102b28:	39 de                	cmp    %ebx,%esi
80102b2a:	73 e4                	jae    80102b10 <kinit1+0x40>
}
80102b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b2f:	5b                   	pop    %ebx
80102b30:	5e                   	pop    %esi
80102b31:	5d                   	pop    %ebp
80102b32:	c3                   	ret    
80102b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b40 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102b40:	a1 94 28 11 80       	mov    0x80112894,%eax
80102b45:	85 c0                	test   %eax,%eax
80102b47:	75 1f                	jne    80102b68 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b49:	a1 98 28 11 80       	mov    0x80112898,%eax
  if(r)
80102b4e:	85 c0                	test   %eax,%eax
80102b50:	74 0e                	je     80102b60 <kalloc+0x20>
    kmem.freelist = r->next;
80102b52:	8b 10                	mov    (%eax),%edx
80102b54:	89 15 98 28 11 80    	mov    %edx,0x80112898
  if(kmem.use_lock)
80102b5a:	c3                   	ret    
80102b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b5f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b60:	c3                   	ret    
80102b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b68:	55                   	push   %ebp
80102b69:	89 e5                	mov    %esp,%ebp
80102b6b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b6e:	68 60 28 11 80       	push   $0x80112860
80102b73:	e8 98 1f 00 00       	call   80104b10 <acquire>
  r = kmem.freelist;
80102b78:	a1 98 28 11 80       	mov    0x80112898,%eax
  if(kmem.use_lock)
80102b7d:	8b 15 94 28 11 80    	mov    0x80112894,%edx
  if(r)
80102b83:	83 c4 10             	add    $0x10,%esp
80102b86:	85 c0                	test   %eax,%eax
80102b88:	74 08                	je     80102b92 <kalloc+0x52>
    kmem.freelist = r->next;
80102b8a:	8b 08                	mov    (%eax),%ecx
80102b8c:	89 0d 98 28 11 80    	mov    %ecx,0x80112898
  if(kmem.use_lock)
80102b92:	85 d2                	test   %edx,%edx
80102b94:	74 16                	je     80102bac <kalloc+0x6c>
    release(&kmem.lock);
80102b96:	83 ec 0c             	sub    $0xc,%esp
80102b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b9c:	68 60 28 11 80       	push   $0x80112860
80102ba1:	e8 0a 1f 00 00       	call   80104ab0 <release>
  return (char*)r;
80102ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102ba9:	83 c4 10             	add    $0x10,%esp
}
80102bac:	c9                   	leave  
80102bad:	c3                   	ret    
80102bae:	66 90                	xchg   %ax,%ax

80102bb0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb0:	ba 64 00 00 00       	mov    $0x64,%edx
80102bb5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102bb6:	a8 01                	test   $0x1,%al
80102bb8:	0f 84 c2 00 00 00    	je     80102c80 <kbdgetc+0xd0>
{
80102bbe:	55                   	push   %ebp
80102bbf:	ba 60 00 00 00       	mov    $0x60,%edx
80102bc4:	89 e5                	mov    %esp,%ebp
80102bc6:	53                   	push   %ebx
80102bc7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102bc8:	8b 1d 9c 28 11 80    	mov    0x8011289c,%ebx
  data = inb(KBDATAP);
80102bce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102bd1:	3c e0                	cmp    $0xe0,%al
80102bd3:	74 5b                	je     80102c30 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bd5:	89 da                	mov    %ebx,%edx
80102bd7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102bda:	84 c0                	test   %al,%al
80102bdc:	78 62                	js     80102c40 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bde:	85 d2                	test   %edx,%edx
80102be0:	74 09                	je     80102beb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102be2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102be5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102be8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102beb:	0f b6 91 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%edx
  shift ^= togglecode[data];
80102bf2:	0f b6 81 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%eax
  shift |= shiftcode[data];
80102bf9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102bfb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bfd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102bff:	89 15 9c 28 11 80    	mov    %edx,0x8011289c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c05:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c08:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c0b:	8b 04 85 20 7b 10 80 	mov    -0x7fef84e0(,%eax,4),%eax
80102c12:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102c16:	74 0b                	je     80102c23 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102c18:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c1b:	83 fa 19             	cmp    $0x19,%edx
80102c1e:	77 48                	ja     80102c68 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c20:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c26:	c9                   	leave  
80102c27:	c3                   	ret    
80102c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2f:	90                   	nop
    shift |= E0ESC;
80102c30:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c33:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c35:	89 1d 9c 28 11 80    	mov    %ebx,0x8011289c
}
80102c3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c3e:	c9                   	leave  
80102c3f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102c40:	83 e0 7f             	and    $0x7f,%eax
80102c43:	85 d2                	test   %edx,%edx
80102c45:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102c48:	0f b6 81 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%eax
80102c4f:	83 c8 40             	or     $0x40,%eax
80102c52:	0f b6 c0             	movzbl %al,%eax
80102c55:	f7 d0                	not    %eax
80102c57:	21 d8                	and    %ebx,%eax
}
80102c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102c5c:	a3 9c 28 11 80       	mov    %eax,0x8011289c
    return 0;
80102c61:	31 c0                	xor    %eax,%eax
}
80102c63:	c9                   	leave  
80102c64:	c3                   	ret    
80102c65:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102c68:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c6b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c71:	c9                   	leave  
      c += 'a' - 'A';
80102c72:	83 f9 1a             	cmp    $0x1a,%ecx
80102c75:	0f 42 c2             	cmovb  %edx,%eax
}
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c85:	c3                   	ret    
80102c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8d:	8d 76 00             	lea    0x0(%esi),%esi

80102c90 <kbdintr>:

void
kbdintr(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c96:	68 b0 2b 10 80       	push   $0x80102bb0
80102c9b:	e8 50 e0 ff ff       	call   80100cf0 <consoleintr>
}
80102ca0:	83 c4 10             	add    $0x10,%esp
80102ca3:	c9                   	leave  
80102ca4:	c3                   	ret    
80102ca5:	66 90                	xchg   %ax,%ax
80102ca7:	66 90                	xchg   %ax,%ax
80102ca9:	66 90                	xchg   %ax,%ax
80102cab:	66 90                	xchg   %ax,%ax
80102cad:	66 90                	xchg   %ax,%ax
80102caf:	90                   	nop

80102cb0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102cb0:	a1 a0 28 11 80       	mov    0x801128a0,%eax
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	0f 84 cb 00 00 00    	je     80102d88 <lapicinit+0xd8>
  lapic[index] = value;
80102cbd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102cc4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102cd1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cde:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ceb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cf8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cfe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d05:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d08:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d0b:	8b 50 30             	mov    0x30(%eax),%edx
80102d0e:	c1 ea 10             	shr    $0x10,%edx
80102d11:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102d17:	75 77                	jne    80102d90 <lapicinit+0xe0>
  lapic[index] = value;
80102d19:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d23:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d26:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d30:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d3d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d40:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d4d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d5a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d61:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d64:	8b 50 20             	mov    0x20(%eax),%edx
80102d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d70:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d76:	80 e6 10             	and    $0x10,%dh
80102d79:	75 f5                	jne    80102d70 <lapicinit+0xc0>
  lapic[index] = value;
80102d7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d82:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d85:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d88:	c3                   	ret    
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d90:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d97:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d9a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d9d:	e9 77 ff ff ff       	jmp    80102d19 <lapicinit+0x69>
80102da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102db0:	a1 a0 28 11 80       	mov    0x801128a0,%eax
80102db5:	85 c0                	test   %eax,%eax
80102db7:	74 07                	je     80102dc0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102db9:	8b 40 20             	mov    0x20(%eax),%eax
80102dbc:	c1 e8 18             	shr    $0x18,%eax
80102dbf:	c3                   	ret    
    return 0;
80102dc0:	31 c0                	xor    %eax,%eax
}
80102dc2:	c3                   	ret    
80102dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102dd0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102dd0:	a1 a0 28 11 80       	mov    0x801128a0,%eax
80102dd5:	85 c0                	test   %eax,%eax
80102dd7:	74 0d                	je     80102de6 <lapiceoi+0x16>
  lapic[index] = value;
80102dd9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102de0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102de3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102de6:	c3                   	ret    
80102de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102df0:	c3                   	ret    
80102df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop

80102e00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e06:	ba 70 00 00 00       	mov    $0x70,%edx
80102e0b:	89 e5                	mov    %esp,%ebp
80102e0d:	53                   	push   %ebx
80102e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e14:	ee                   	out    %al,(%dx)
80102e15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102e1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e20:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102e22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e2d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e30:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e32:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e3e:	a1 a0 28 11 80       	mov    0x801128a0,%eax
80102e43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e8d:	c9                   	leave  
80102e8e:	c3                   	ret    
80102e8f:	90                   	nop

80102e90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e90:	55                   	push   %ebp
80102e91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e96:	ba 70 00 00 00       	mov    $0x70,%edx
80102e9b:	89 e5                	mov    %esp,%ebp
80102e9d:	57                   	push   %edi
80102e9e:	56                   	push   %esi
80102e9f:	53                   	push   %ebx
80102ea0:	83 ec 4c             	sub    $0x4c,%esp
80102ea3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ea9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102eaa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ead:	bb 70 00 00 00       	mov    $0x70,%ebx
80102eb2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102eb5:	8d 76 00             	lea    0x0(%esi),%esi
80102eb8:	31 c0                	xor    %eax,%eax
80102eba:	89 da                	mov    %ebx,%edx
80102ebc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ebd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ec2:	89 ca                	mov    %ecx,%edx
80102ec4:	ec                   	in     (%dx),%al
80102ec5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec8:	89 da                	mov    %ebx,%edx
80102eca:	b8 02 00 00 00       	mov    $0x2,%eax
80102ecf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed0:	89 ca                	mov    %ecx,%edx
80102ed2:	ec                   	in     (%dx),%al
80102ed3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed6:	89 da                	mov    %ebx,%edx
80102ed8:	b8 04 00 00 00       	mov    $0x4,%eax
80102edd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ede:	89 ca                	mov    %ecx,%edx
80102ee0:	ec                   	in     (%dx),%al
80102ee1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee4:	89 da                	mov    %ebx,%edx
80102ee6:	b8 07 00 00 00       	mov    $0x7,%eax
80102eeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eec:	89 ca                	mov    %ecx,%edx
80102eee:	ec                   	in     (%dx),%al
80102eef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef2:	89 da                	mov    %ebx,%edx
80102ef4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ef9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efa:	89 ca                	mov    %ecx,%edx
80102efc:	ec                   	in     (%dx),%al
80102efd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eff:	89 da                	mov    %ebx,%edx
80102f01:	b8 09 00 00 00       	mov    $0x9,%eax
80102f06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f07:	89 ca                	mov    %ecx,%edx
80102f09:	ec                   	in     (%dx),%al
80102f0a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0c:	89 da                	mov    %ebx,%edx
80102f0e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f14:	89 ca                	mov    %ecx,%edx
80102f16:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f17:	84 c0                	test   %al,%al
80102f19:	78 9d                	js     80102eb8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102f1b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f1f:	89 fa                	mov    %edi,%edx
80102f21:	0f b6 fa             	movzbl %dl,%edi
80102f24:	89 f2                	mov    %esi,%edx
80102f26:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f29:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f2d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f30:	89 da                	mov    %ebx,%edx
80102f32:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f35:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f38:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f3c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f42:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f46:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f49:	31 c0                	xor    %eax,%eax
80102f4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f4c:	89 ca                	mov    %ecx,%edx
80102f4e:	ec                   	in     (%dx),%al
80102f4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f52:	89 da                	mov    %ebx,%edx
80102f54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f57:	b8 02 00 00 00       	mov    $0x2,%eax
80102f5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f5d:	89 ca                	mov    %ecx,%edx
80102f5f:	ec                   	in     (%dx),%al
80102f60:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f63:	89 da                	mov    %ebx,%edx
80102f65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f68:	b8 04 00 00 00       	mov    $0x4,%eax
80102f6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f6e:	89 ca                	mov    %ecx,%edx
80102f70:	ec                   	in     (%dx),%al
80102f71:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f74:	89 da                	mov    %ebx,%edx
80102f76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f79:	b8 07 00 00 00       	mov    $0x7,%eax
80102f7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f7f:	89 ca                	mov    %ecx,%edx
80102f81:	ec                   	in     (%dx),%al
80102f82:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f85:	89 da                	mov    %ebx,%edx
80102f87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f90:	89 ca                	mov    %ecx,%edx
80102f92:	ec                   	in     (%dx),%al
80102f93:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f96:	89 da                	mov    %ebx,%edx
80102f98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102fa0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fa1:	89 ca                	mov    %ecx,%edx
80102fa3:	ec                   	in     (%dx),%al
80102fa4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fa7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102faa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fad:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102fb0:	6a 18                	push   $0x18
80102fb2:	50                   	push   %eax
80102fb3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102fb6:	50                   	push   %eax
80102fb7:	e8 64 1c 00 00       	call   80104c20 <memcmp>
80102fbc:	83 c4 10             	add    $0x10,%esp
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	0f 85 f1 fe ff ff    	jne    80102eb8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102fc7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102fcb:	75 78                	jne    80103045 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fd0:	89 c2                	mov    %eax,%edx
80102fd2:	83 e0 0f             	and    $0xf,%eax
80102fd5:	c1 ea 04             	shr    $0x4,%edx
80102fd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fde:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fe1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fe4:	89 c2                	mov    %eax,%edx
80102fe6:	83 e0 0f             	and    $0xf,%eax
80102fe9:	c1 ea 04             	shr    $0x4,%edx
80102fec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ff5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ff8:	89 c2                	mov    %eax,%edx
80102ffa:	83 e0 0f             	and    $0xf,%eax
80102ffd:	c1 ea 04             	shr    $0x4,%edx
80103000:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103003:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103006:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103009:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010300c:	89 c2                	mov    %eax,%edx
8010300e:	83 e0 0f             	and    $0xf,%eax
80103011:	c1 ea 04             	shr    $0x4,%edx
80103014:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103017:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010301a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010301d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103020:	89 c2                	mov    %eax,%edx
80103022:	83 e0 0f             	and    $0xf,%eax
80103025:	c1 ea 04             	shr    $0x4,%edx
80103028:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010302b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010302e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103031:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103034:	89 c2                	mov    %eax,%edx
80103036:	83 e0 0f             	and    $0xf,%eax
80103039:	c1 ea 04             	shr    $0x4,%edx
8010303c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010303f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103042:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103045:	8b 75 08             	mov    0x8(%ebp),%esi
80103048:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010304b:	89 06                	mov    %eax,(%esi)
8010304d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103050:	89 46 04             	mov    %eax,0x4(%esi)
80103053:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103056:	89 46 08             	mov    %eax,0x8(%esi)
80103059:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010305c:	89 46 0c             	mov    %eax,0xc(%esi)
8010305f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103062:	89 46 10             	mov    %eax,0x10(%esi)
80103065:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103068:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010306b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103072:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103075:	5b                   	pop    %ebx
80103076:	5e                   	pop    %esi
80103077:	5f                   	pop    %edi
80103078:	5d                   	pop    %ebp
80103079:	c3                   	ret    
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103080:	8b 0d 08 29 11 80    	mov    0x80112908,%ecx
80103086:	85 c9                	test   %ecx,%ecx
80103088:	0f 8e 8a 00 00 00    	jle    80103118 <install_trans+0x98>
{
8010308e:	55                   	push   %ebp
8010308f:	89 e5                	mov    %esp,%ebp
80103091:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103092:	31 ff                	xor    %edi,%edi
{
80103094:	56                   	push   %esi
80103095:	53                   	push   %ebx
80103096:	83 ec 0c             	sub    $0xc,%esp
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030a0:	a1 f4 28 11 80       	mov    0x801128f4,%eax
801030a5:	83 ec 08             	sub    $0x8,%esp
801030a8:	01 f8                	add    %edi,%eax
801030aa:	83 c0 01             	add    $0x1,%eax
801030ad:	50                   	push   %eax
801030ae:	ff 35 04 29 11 80    	push   0x80112904
801030b4:	e8 17 d0 ff ff       	call   801000d0 <bread>
801030b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030bb:	58                   	pop    %eax
801030bc:	5a                   	pop    %edx
801030bd:	ff 34 bd 0c 29 11 80 	push   -0x7feed6f4(,%edi,4)
801030c4:	ff 35 04 29 11 80    	push   0x80112904
  for (tail = 0; tail < log.lh.n; tail++) {
801030ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030cd:	e8 fe cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030da:	68 00 02 00 00       	push   $0x200
801030df:	50                   	push   %eax
801030e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030e3:	50                   	push   %eax
801030e4:	e8 87 1b 00 00       	call   80104c70 <memmove>
    bwrite(dbuf);  // write dst to disk
801030e9:	89 1c 24             	mov    %ebx,(%esp)
801030ec:	e8 bf d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030f1:	89 34 24             	mov    %esi,(%esp)
801030f4:	e8 f7 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030f9:	89 1c 24             	mov    %ebx,(%esp)
801030fc:	e8 ef d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103101:	83 c4 10             	add    $0x10,%esp
80103104:	39 3d 08 29 11 80    	cmp    %edi,0x80112908
8010310a:	7f 94                	jg     801030a0 <install_trans+0x20>
  }
}
8010310c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010310f:	5b                   	pop    %ebx
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret    
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103118:	c3                   	ret    
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103120 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103127:	ff 35 f4 28 11 80    	push   0x801128f4
8010312d:	ff 35 04 29 11 80    	push   0x80112904
80103133:	e8 98 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103138:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010313b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010313d:	a1 08 29 11 80       	mov    0x80112908,%eax
80103142:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103145:	85 c0                	test   %eax,%eax
80103147:	7e 19                	jle    80103162 <write_head+0x42>
80103149:	31 d2                	xor    %edx,%edx
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103150:	8b 0c 95 0c 29 11 80 	mov    -0x7feed6f4(,%edx,4),%ecx
80103157:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010315b:	83 c2 01             	add    $0x1,%edx
8010315e:	39 d0                	cmp    %edx,%eax
80103160:	75 ee                	jne    80103150 <write_head+0x30>
  }
  bwrite(buf);
80103162:	83 ec 0c             	sub    $0xc,%esp
80103165:	53                   	push   %ebx
80103166:	e8 45 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010316b:	89 1c 24             	mov    %ebx,(%esp)
8010316e:	e8 7d d0 ff ff       	call   801001f0 <brelse>
}
80103173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	c9                   	leave  
8010317a:	c3                   	ret    
8010317b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <initlog>:
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	53                   	push   %ebx
80103184:	83 ec 2c             	sub    $0x2c,%esp
80103187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010318a:	68 40 7d 10 80       	push   $0x80107d40
8010318f:	68 c0 28 11 80       	push   $0x801128c0
80103194:	e8 a7 17 00 00       	call   80104940 <initlock>
  readsb(dev, &sb);
80103199:	58                   	pop    %eax
8010319a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010319d:	5a                   	pop    %edx
8010319e:	50                   	push   %eax
8010319f:	53                   	push   %ebx
801031a0:	e8 3b e8 ff ff       	call   801019e0 <readsb>
  log.start = sb.logstart;
801031a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031a8:	59                   	pop    %ecx
  log.dev = dev;
801031a9:	89 1d 04 29 11 80    	mov    %ebx,0x80112904
  log.size = sb.nlog;
801031af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031b2:	a3 f4 28 11 80       	mov    %eax,0x801128f4
  log.size = sb.nlog;
801031b7:	89 15 f8 28 11 80    	mov    %edx,0x801128f8
  struct buf *buf = bread(log.dev, log.start);
801031bd:	5a                   	pop    %edx
801031be:	50                   	push   %eax
801031bf:	53                   	push   %ebx
801031c0:	e8 0b cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031c5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031c8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801031cb:	89 1d 08 29 11 80    	mov    %ebx,0x80112908
  for (i = 0; i < log.lh.n; i++) {
801031d1:	85 db                	test   %ebx,%ebx
801031d3:	7e 1d                	jle    801031f2 <initlog+0x72>
801031d5:	31 d2                	xor    %edx,%edx
801031d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031de:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801031e0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801031e4:	89 0c 95 0c 29 11 80 	mov    %ecx,-0x7feed6f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031eb:	83 c2 01             	add    $0x1,%edx
801031ee:	39 d3                	cmp    %edx,%ebx
801031f0:	75 ee                	jne    801031e0 <initlog+0x60>
  brelse(buf);
801031f2:	83 ec 0c             	sub    $0xc,%esp
801031f5:	50                   	push   %eax
801031f6:	e8 f5 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031fb:	e8 80 fe ff ff       	call   80103080 <install_trans>
  log.lh.n = 0;
80103200:	c7 05 08 29 11 80 00 	movl   $0x0,0x80112908
80103207:	00 00 00 
  write_head(); // clear the log
8010320a:	e8 11 ff ff ff       	call   80103120 <write_head>
}
8010320f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103212:	83 c4 10             	add    $0x10,%esp
80103215:	c9                   	leave  
80103216:	c3                   	ret    
80103217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321e:	66 90                	xchg   %ax,%ax

80103220 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103226:	68 c0 28 11 80       	push   $0x801128c0
8010322b:	e8 e0 18 00 00       	call   80104b10 <acquire>
80103230:	83 c4 10             	add    $0x10,%esp
80103233:	eb 18                	jmp    8010324d <begin_op+0x2d>
80103235:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103238:	83 ec 08             	sub    $0x8,%esp
8010323b:	68 c0 28 11 80       	push   $0x801128c0
80103240:	68 c0 28 11 80       	push   $0x801128c0
80103245:	e8 b6 12 00 00       	call   80104500 <sleep>
8010324a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010324d:	a1 00 29 11 80       	mov    0x80112900,%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	75 e2                	jne    80103238 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103256:	a1 fc 28 11 80       	mov    0x801128fc,%eax
8010325b:	8b 15 08 29 11 80    	mov    0x80112908,%edx
80103261:	83 c0 01             	add    $0x1,%eax
80103264:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103267:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010326a:	83 fa 1e             	cmp    $0x1e,%edx
8010326d:	7f c9                	jg     80103238 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010326f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103272:	a3 fc 28 11 80       	mov    %eax,0x801128fc
      release(&log.lock);
80103277:	68 c0 28 11 80       	push   $0x801128c0
8010327c:	e8 2f 18 00 00       	call   80104ab0 <release>
      break;
    }
  }
}
80103281:	83 c4 10             	add    $0x10,%esp
80103284:	c9                   	leave  
80103285:	c3                   	ret    
80103286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010328d:	8d 76 00             	lea    0x0(%esi),%esi

80103290 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103299:	68 c0 28 11 80       	push   $0x801128c0
8010329e:	e8 6d 18 00 00       	call   80104b10 <acquire>
  log.outstanding -= 1;
801032a3:	a1 fc 28 11 80       	mov    0x801128fc,%eax
  if(log.committing)
801032a8:	8b 35 00 29 11 80    	mov    0x80112900,%esi
801032ae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032b4:	89 1d fc 28 11 80    	mov    %ebx,0x801128fc
  if(log.committing)
801032ba:	85 f6                	test   %esi,%esi
801032bc:	0f 85 22 01 00 00    	jne    801033e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032c2:	85 db                	test   %ebx,%ebx
801032c4:	0f 85 f6 00 00 00    	jne    801033c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032ca:	c7 05 00 29 11 80 01 	movl   $0x1,0x80112900
801032d1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032d4:	83 ec 0c             	sub    $0xc,%esp
801032d7:	68 c0 28 11 80       	push   $0x801128c0
801032dc:	e8 cf 17 00 00       	call   80104ab0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032e1:	8b 0d 08 29 11 80    	mov    0x80112908,%ecx
801032e7:	83 c4 10             	add    $0x10,%esp
801032ea:	85 c9                	test   %ecx,%ecx
801032ec:	7f 42                	jg     80103330 <end_op+0xa0>
    acquire(&log.lock);
801032ee:	83 ec 0c             	sub    $0xc,%esp
801032f1:	68 c0 28 11 80       	push   $0x801128c0
801032f6:	e8 15 18 00 00       	call   80104b10 <acquire>
    wakeup(&log);
801032fb:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
    log.committing = 0;
80103302:	c7 05 00 29 11 80 00 	movl   $0x0,0x80112900
80103309:	00 00 00 
    wakeup(&log);
8010330c:	e8 af 12 00 00       	call   801045c0 <wakeup>
    release(&log.lock);
80103311:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
80103318:	e8 93 17 00 00       	call   80104ab0 <release>
8010331d:	83 c4 10             	add    $0x10,%esp
}
80103320:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103323:	5b                   	pop    %ebx
80103324:	5e                   	pop    %esi
80103325:	5f                   	pop    %edi
80103326:	5d                   	pop    %ebp
80103327:	c3                   	ret    
80103328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103330:	a1 f4 28 11 80       	mov    0x801128f4,%eax
80103335:	83 ec 08             	sub    $0x8,%esp
80103338:	01 d8                	add    %ebx,%eax
8010333a:	83 c0 01             	add    $0x1,%eax
8010333d:	50                   	push   %eax
8010333e:	ff 35 04 29 11 80    	push   0x80112904
80103344:	e8 87 cd ff ff       	call   801000d0 <bread>
80103349:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010334b:	58                   	pop    %eax
8010334c:	5a                   	pop    %edx
8010334d:	ff 34 9d 0c 29 11 80 	push   -0x7feed6f4(,%ebx,4)
80103354:	ff 35 04 29 11 80    	push   0x80112904
  for (tail = 0; tail < log.lh.n; tail++) {
8010335a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010335d:	e8 6e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103362:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103365:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103367:	8d 40 5c             	lea    0x5c(%eax),%eax
8010336a:	68 00 02 00 00       	push   $0x200
8010336f:	50                   	push   %eax
80103370:	8d 46 5c             	lea    0x5c(%esi),%eax
80103373:	50                   	push   %eax
80103374:	e8 f7 18 00 00       	call   80104c70 <memmove>
    bwrite(to);  // write the log
80103379:	89 34 24             	mov    %esi,(%esp)
8010337c:	e8 2f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103381:	89 3c 24             	mov    %edi,(%esp)
80103384:	e8 67 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103389:	89 34 24             	mov    %esi,(%esp)
8010338c:	e8 5f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103391:	83 c4 10             	add    $0x10,%esp
80103394:	3b 1d 08 29 11 80    	cmp    0x80112908,%ebx
8010339a:	7c 94                	jl     80103330 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010339c:	e8 7f fd ff ff       	call   80103120 <write_head>
    install_trans(); // Now install writes to home locations
801033a1:	e8 da fc ff ff       	call   80103080 <install_trans>
    log.lh.n = 0;
801033a6:	c7 05 08 29 11 80 00 	movl   $0x0,0x80112908
801033ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801033b0:	e8 6b fd ff ff       	call   80103120 <write_head>
801033b5:	e9 34 ff ff ff       	jmp    801032ee <end_op+0x5e>
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 c0 28 11 80       	push   $0x801128c0
801033c8:	e8 f3 11 00 00       	call   801045c0 <wakeup>
  release(&log.lock);
801033cd:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
801033d4:	e8 d7 16 00 00       	call   80104ab0 <release>
801033d9:	83 c4 10             	add    $0x10,%esp
}
801033dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033df:	5b                   	pop    %ebx
801033e0:	5e                   	pop    %esi
801033e1:	5f                   	pop    %edi
801033e2:	5d                   	pop    %ebp
801033e3:	c3                   	ret    
    panic("log.committing");
801033e4:	83 ec 0c             	sub    $0xc,%esp
801033e7:	68 44 7d 10 80       	push   $0x80107d44
801033ec:	e8 8f cf ff ff       	call   80100380 <panic>
801033f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ff:	90                   	nop

80103400 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	53                   	push   %ebx
80103404:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103407:	8b 15 08 29 11 80    	mov    0x80112908,%edx
{
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103410:	83 fa 1d             	cmp    $0x1d,%edx
80103413:	0f 8f 85 00 00 00    	jg     8010349e <log_write+0x9e>
80103419:	a1 f8 28 11 80       	mov    0x801128f8,%eax
8010341e:	83 e8 01             	sub    $0x1,%eax
80103421:	39 c2                	cmp    %eax,%edx
80103423:	7d 79                	jge    8010349e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103425:	a1 fc 28 11 80       	mov    0x801128fc,%eax
8010342a:	85 c0                	test   %eax,%eax
8010342c:	7e 7d                	jle    801034ab <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010342e:	83 ec 0c             	sub    $0xc,%esp
80103431:	68 c0 28 11 80       	push   $0x801128c0
80103436:	e8 d5 16 00 00       	call   80104b10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010343b:	8b 15 08 29 11 80    	mov    0x80112908,%edx
80103441:	83 c4 10             	add    $0x10,%esp
80103444:	85 d2                	test   %edx,%edx
80103446:	7e 4a                	jle    80103492 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103448:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010344b:	31 c0                	xor    %eax,%eax
8010344d:	eb 08                	jmp    80103457 <log_write+0x57>
8010344f:	90                   	nop
80103450:	83 c0 01             	add    $0x1,%eax
80103453:	39 c2                	cmp    %eax,%edx
80103455:	74 29                	je     80103480 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103457:	39 0c 85 0c 29 11 80 	cmp    %ecx,-0x7feed6f4(,%eax,4)
8010345e:	75 f0                	jne    80103450 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103460:	89 0c 85 0c 29 11 80 	mov    %ecx,-0x7feed6f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103467:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010346a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010346d:	c7 45 08 c0 28 11 80 	movl   $0x801128c0,0x8(%ebp)
}
80103474:	c9                   	leave  
  release(&log.lock);
80103475:	e9 36 16 00 00       	jmp    80104ab0 <release>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103480:	89 0c 95 0c 29 11 80 	mov    %ecx,-0x7feed6f4(,%edx,4)
    log.lh.n++;
80103487:	83 c2 01             	add    $0x1,%edx
8010348a:	89 15 08 29 11 80    	mov    %edx,0x80112908
80103490:	eb d5                	jmp    80103467 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103492:	8b 43 08             	mov    0x8(%ebx),%eax
80103495:	a3 0c 29 11 80       	mov    %eax,0x8011290c
  if (i == log.lh.n)
8010349a:	75 cb                	jne    80103467 <log_write+0x67>
8010349c:	eb e9                	jmp    80103487 <log_write+0x87>
    panic("too big a transaction");
8010349e:	83 ec 0c             	sub    $0xc,%esp
801034a1:	68 53 7d 10 80       	push   $0x80107d53
801034a6:	e8 d5 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801034ab:	83 ec 0c             	sub    $0xc,%esp
801034ae:	68 69 7d 10 80       	push   $0x80107d69
801034b3:	e8 c8 ce ff ff       	call   80100380 <panic>
801034b8:	66 90                	xchg   %ax,%ax
801034ba:	66 90                	xchg   %ax,%ax
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034c7:	e8 44 09 00 00       	call   80103e10 <cpuid>
801034cc:	89 c3                	mov    %eax,%ebx
801034ce:	e8 3d 09 00 00       	call   80103e10 <cpuid>
801034d3:	83 ec 04             	sub    $0x4,%esp
801034d6:	53                   	push   %ebx
801034d7:	50                   	push   %eax
801034d8:	68 84 7d 10 80       	push   $0x80107d84
801034dd:	e8 be d1 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801034e2:	e8 c9 2a 00 00       	call   80105fb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034e7:	e8 c4 08 00 00       	call   80103db0 <mycpu>
801034ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ee:	b8 01 00 00 00       	mov    $0x1,%eax
801034f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034fa:	e8 f1 0b 00 00       	call   801040f0 <scheduler>
801034ff:	90                   	nop

80103500 <mpenter>:
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103506:	e8 95 3b 00 00       	call   801070a0 <switchkvm>
  seginit();
8010350b:	e8 00 3b 00 00       	call   80107010 <seginit>
  lapicinit();
80103510:	e8 9b f7 ff ff       	call   80102cb0 <lapicinit>
  mpmain();
80103515:	e8 a6 ff ff ff       	call   801034c0 <mpmain>
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <main>:
{
80103520:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103524:	83 e4 f0             	and    $0xfffffff0,%esp
80103527:	ff 71 fc             	push   -0x4(%ecx)
8010352a:	55                   	push   %ebp
8010352b:	89 e5                	mov    %esp,%ebp
8010352d:	53                   	push   %ebx
8010352e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010352f:	83 ec 08             	sub    $0x8,%esp
80103532:	68 00 00 40 80       	push   $0x80400000
80103537:	68 b0 fd 12 80       	push   $0x8012fdb0
8010353c:	e8 8f f5 ff ff       	call   80102ad0 <kinit1>
  kvmalloc();      // kernel page table
80103541:	e8 4a 40 00 00       	call   80107590 <kvmalloc>
  mpinit();        // detect other processors
80103546:	e8 85 01 00 00       	call   801036d0 <mpinit>
  lapicinit();     // interrupt controller
8010354b:	e8 60 f7 ff ff       	call   80102cb0 <lapicinit>
  seginit();       // segment descriptors
80103550:	e8 bb 3a 00 00       	call   80107010 <seginit>
  picinit();       // disable pic
80103555:	e8 76 03 00 00       	call   801038d0 <picinit>
  ioapicinit();    // another interrupt controller
8010355a:	e8 31 f3 ff ff       	call   80102890 <ioapicinit>
  consoleinit();   // console hardware
8010355f:	e8 bc d9 ff ff       	call   80100f20 <consoleinit>
  uartinit();      // serial port
80103564:	e8 37 2d 00 00       	call   801062a0 <uartinit>
  pinit();         // process table
80103569:	e8 22 08 00 00       	call   80103d90 <pinit>
  tvinit();        // trap vectors
8010356e:	e8 bd 29 00 00       	call   80105f30 <tvinit>
  binit();         // buffer cache
80103573:	e8 c8 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103578:	e8 53 dd ff ff       	call   801012d0 <fileinit>
  ideinit();       // disk 
8010357d:	e8 fe f0 ff ff       	call   80102680 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103582:	83 c4 0c             	add    $0xc,%esp
80103585:	68 8a 00 00 00       	push   $0x8a
8010358a:	68 8c b4 10 80       	push   $0x8010b48c
8010358f:	68 00 70 00 80       	push   $0x80007000
80103594:	e8 d7 16 00 00       	call   80104c70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	69 05 a4 29 11 80 b0 	imul   $0xb0,0x801129a4,%eax
801035a3:	00 00 00 
801035a6:	05 c0 29 11 80       	add    $0x801129c0,%eax
801035ab:	3d c0 29 11 80       	cmp    $0x801129c0,%eax
801035b0:	76 7e                	jbe    80103630 <main+0x110>
801035b2:	bb c0 29 11 80       	mov    $0x801129c0,%ebx
801035b7:	eb 20                	jmp    801035d9 <main+0xb9>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035c0:	69 05 a4 29 11 80 b0 	imul   $0xb0,0x801129a4,%eax
801035c7:	00 00 00 
801035ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035d0:	05 c0 29 11 80       	add    $0x801129c0,%eax
801035d5:	39 c3                	cmp    %eax,%ebx
801035d7:	73 57                	jae    80103630 <main+0x110>
    if(c == mycpu())  // We've started already.
801035d9:	e8 d2 07 00 00       	call   80103db0 <mycpu>
801035de:	39 c3                	cmp    %eax,%ebx
801035e0:	74 de                	je     801035c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035e2:	e8 59 f5 ff ff       	call   80102b40 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103500,0x80006ff8
801035f1:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035fe:	05 00 10 00 00       	add    $0x1000,%eax
80103603:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103608:	0f b6 03             	movzbl (%ebx),%eax
8010360b:	68 00 70 00 00       	push   $0x7000
80103610:	50                   	push   %eax
80103611:	e8 ea f7 ff ff       	call   80102e00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103620:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103626:	85 c0                	test   %eax,%eax
80103628:	74 f6                	je     80103620 <main+0x100>
8010362a:	eb 94                	jmp    801035c0 <main+0xa0>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103630:	83 ec 08             	sub    $0x8,%esp
80103633:	68 00 00 00 8e       	push   $0x8e000000
80103638:	68 00 00 40 80       	push   $0x80400000
8010363d:	e8 2e f4 ff ff       	call   80102a70 <kinit2>
  userinit();      // first user process
80103642:	e8 19 08 00 00       	call   80103e60 <userinit>
  mpmain();        // finish this processor's setup
80103647:	e8 74 fe ff ff       	call   801034c0 <mpmain>
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103655:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010365b:	53                   	push   %ebx
  e = addr+len;
8010365c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010365f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103662:	39 de                	cmp    %ebx,%esi
80103664:	72 10                	jb     80103676 <mpsearch1+0x26>
80103666:	eb 50                	jmp    801036b8 <mpsearch1+0x68>
80103668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010366f:	90                   	nop
80103670:	89 fe                	mov    %edi,%esi
80103672:	39 fb                	cmp    %edi,%ebx
80103674:	76 42                	jbe    801036b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103676:	83 ec 04             	sub    $0x4,%esp
80103679:	8d 7e 10             	lea    0x10(%esi),%edi
8010367c:	6a 04                	push   $0x4
8010367e:	68 98 7d 10 80       	push   $0x80107d98
80103683:	56                   	push   %esi
80103684:	e8 97 15 00 00       	call   80104c20 <memcmp>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	85 c0                	test   %eax,%eax
8010368e:	75 e0                	jne    80103670 <mpsearch1+0x20>
80103690:	89 f2                	mov    %esi,%edx
80103692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103698:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010369b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010369e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036a0:	39 fa                	cmp    %edi,%edx
801036a2:	75 f4                	jne    80103698 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036a4:	84 c0                	test   %al,%al
801036a6:	75 c8                	jne    80103670 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801036a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ab:	89 f0                	mov    %esi,%eax
801036ad:	5b                   	pop    %ebx
801036ae:	5e                   	pop    %esi
801036af:	5f                   	pop    %edi
801036b0:	5d                   	pop    %ebp
801036b1:	c3                   	ret    
801036b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036bb:	31 f6                	xor    %esi,%esi
}
801036bd:	5b                   	pop    %ebx
801036be:	89 f0                	mov    %esi,%eax
801036c0:	5e                   	pop    %esi
801036c1:	5f                   	pop    %edi
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
801036c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036cf:	90                   	nop

801036d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036e7:	c1 e0 08             	shl    $0x8,%eax
801036ea:	09 d0                	or     %edx,%eax
801036ec:	c1 e0 04             	shl    $0x4,%eax
801036ef:	75 1b                	jne    8010370c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036ff:	c1 e0 08             	shl    $0x8,%eax
80103702:	09 d0                	or     %edx,%eax
80103704:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103707:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010370c:	ba 00 04 00 00       	mov    $0x400,%edx
80103711:	e8 3a ff ff ff       	call   80103650 <mpsearch1>
80103716:	89 c3                	mov    %eax,%ebx
80103718:	85 c0                	test   %eax,%eax
8010371a:	0f 84 40 01 00 00    	je     80103860 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103720:	8b 73 04             	mov    0x4(%ebx),%esi
80103723:	85 f6                	test   %esi,%esi
80103725:	0f 84 25 01 00 00    	je     80103850 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010372b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010372e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103734:	6a 04                	push   $0x4
80103736:	68 9d 7d 10 80       	push   $0x80107d9d
8010373b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010373c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010373f:	e8 dc 14 00 00       	call   80104c20 <memcmp>
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	85 c0                	test   %eax,%eax
80103749:	0f 85 01 01 00 00    	jne    80103850 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010374f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103756:	3c 01                	cmp    $0x1,%al
80103758:	74 08                	je     80103762 <mpinit+0x92>
8010375a:	3c 04                	cmp    $0x4,%al
8010375c:	0f 85 ee 00 00 00    	jne    80103850 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103762:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103769:	66 85 d2             	test   %dx,%dx
8010376c:	74 22                	je     80103790 <mpinit+0xc0>
8010376e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103771:	89 f0                	mov    %esi,%eax
  sum = 0;
80103773:	31 d2                	xor    %edx,%edx
80103775:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103778:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010377f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103782:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103784:	39 c7                	cmp    %eax,%edi
80103786:	75 f0                	jne    80103778 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103788:	84 d2                	test   %dl,%dl
8010378a:	0f 85 c0 00 00 00    	jne    80103850 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103790:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103796:	a3 a0 28 11 80       	mov    %eax,0x801128a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010379b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801037a2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801037a8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037ad:	03 55 e4             	add    -0x1c(%ebp),%edx
801037b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801037b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037b7:	90                   	nop
801037b8:	39 d0                	cmp    %edx,%eax
801037ba:	73 15                	jae    801037d1 <mpinit+0x101>
    switch(*p){
801037bc:	0f b6 08             	movzbl (%eax),%ecx
801037bf:	80 f9 02             	cmp    $0x2,%cl
801037c2:	74 4c                	je     80103810 <mpinit+0x140>
801037c4:	77 3a                	ja     80103800 <mpinit+0x130>
801037c6:	84 c9                	test   %cl,%cl
801037c8:	74 56                	je     80103820 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037ca:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037cd:	39 d0                	cmp    %edx,%eax
801037cf:	72 eb                	jb     801037bc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801037d4:	85 f6                	test   %esi,%esi
801037d6:	0f 84 d9 00 00 00    	je     801038b5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037dc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801037e0:	74 15                	je     801037f7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037e2:	b8 70 00 00 00       	mov    $0x70,%eax
801037e7:	ba 22 00 00 00       	mov    $0x22,%edx
801037ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037ed:	ba 23 00 00 00       	mov    $0x23,%edx
801037f2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037f3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037f6:	ee                   	out    %al,(%dx)
  }
}
801037f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037fa:	5b                   	pop    %ebx
801037fb:	5e                   	pop    %esi
801037fc:	5f                   	pop    %edi
801037fd:	5d                   	pop    %ebp
801037fe:	c3                   	ret    
801037ff:	90                   	nop
    switch(*p){
80103800:	83 e9 03             	sub    $0x3,%ecx
80103803:	80 f9 01             	cmp    $0x1,%cl
80103806:	76 c2                	jbe    801037ca <mpinit+0xfa>
80103808:	31 f6                	xor    %esi,%esi
8010380a:	eb ac                	jmp    801037b8 <mpinit+0xe8>
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103810:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103814:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103817:	88 0d a0 29 11 80    	mov    %cl,0x801129a0
      continue;
8010381d:	eb 99                	jmp    801037b8 <mpinit+0xe8>
8010381f:	90                   	nop
      if(ncpu < NCPU) {
80103820:	8b 0d a4 29 11 80    	mov    0x801129a4,%ecx
80103826:	83 f9 07             	cmp    $0x7,%ecx
80103829:	7f 19                	jg     80103844 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010382b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103831:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103835:	83 c1 01             	add    $0x1,%ecx
80103838:	89 0d a4 29 11 80    	mov    %ecx,0x801129a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010383e:	88 9f c0 29 11 80    	mov    %bl,-0x7feed640(%edi)
      p += sizeof(struct mpproc);
80103844:	83 c0 14             	add    $0x14,%eax
      continue;
80103847:	e9 6c ff ff ff       	jmp    801037b8 <mpinit+0xe8>
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	68 a2 7d 10 80       	push   $0x80107da2
80103858:	e8 23 cb ff ff       	call   80100380 <panic>
8010385d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103860:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103865:	eb 13                	jmp    8010387a <mpinit+0x1aa>
80103867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010386e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103870:	89 f3                	mov    %esi,%ebx
80103872:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103878:	74 d6                	je     80103850 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010387a:	83 ec 04             	sub    $0x4,%esp
8010387d:	8d 73 10             	lea    0x10(%ebx),%esi
80103880:	6a 04                	push   $0x4
80103882:	68 98 7d 10 80       	push   $0x80107d98
80103887:	53                   	push   %ebx
80103888:	e8 93 13 00 00       	call   80104c20 <memcmp>
8010388d:	83 c4 10             	add    $0x10,%esp
80103890:	85 c0                	test   %eax,%eax
80103892:	75 dc                	jne    80103870 <mpinit+0x1a0>
80103894:	89 da                	mov    %ebx,%edx
80103896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801038a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801038a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801038a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801038a8:	39 d6                	cmp    %edx,%esi
801038aa:	75 f4                	jne    801038a0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038ac:	84 c0                	test   %al,%al
801038ae:	75 c0                	jne    80103870 <mpinit+0x1a0>
801038b0:	e9 6b fe ff ff       	jmp    80103720 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801038b5:	83 ec 0c             	sub    $0xc,%esp
801038b8:	68 bc 7d 10 80       	push   $0x80107dbc
801038bd:	e8 be ca ff ff       	call   80100380 <panic>
801038c2:	66 90                	xchg   %ax,%ax
801038c4:	66 90                	xchg   %ax,%ax
801038c6:	66 90                	xchg   %ax,%ax
801038c8:	66 90                	xchg   %ax,%ax
801038ca:	66 90                	xchg   %ax,%ax
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <picinit>:
801038d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038d5:	ba 21 00 00 00       	mov    $0x21,%edx
801038da:	ee                   	out    %al,(%dx)
801038db:	ba a1 00 00 00       	mov    $0xa1,%edx
801038e0:	ee                   	out    %al,(%dx)
801038e1:	c3                   	ret    
801038e2:	66 90                	xchg   %ax,%ax
801038e4:	66 90                	xchg   %ax,%ax
801038e6:	66 90                	xchg   %ax,%ax
801038e8:	66 90                	xchg   %ax,%ax
801038ea:	66 90                	xchg   %ax,%ax
801038ec:	66 90                	xchg   %ax,%ax
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103905:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010390b:	e8 e0 d9 ff ff       	call   801012f0 <filealloc>
80103910:	89 03                	mov    %eax,(%ebx)
80103912:	85 c0                	test   %eax,%eax
80103914:	0f 84 a8 00 00 00    	je     801039c2 <pipealloc+0xd2>
8010391a:	e8 d1 d9 ff ff       	call   801012f0 <filealloc>
8010391f:	89 06                	mov    %eax,(%esi)
80103921:	85 c0                	test   %eax,%eax
80103923:	0f 84 87 00 00 00    	je     801039b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103929:	e8 12 f2 ff ff       	call   80102b40 <kalloc>
8010392e:	89 c7                	mov    %eax,%edi
80103930:	85 c0                	test   %eax,%eax
80103932:	0f 84 b0 00 00 00    	je     801039e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103938:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010393f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103942:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103945:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010394c:	00 00 00 
  p->nwrite = 0;
8010394f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103956:	00 00 00 
  p->nread = 0;
80103959:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103960:	00 00 00 
  initlock(&p->lock, "pipe");
80103963:	68 db 7d 10 80       	push   $0x80107ddb
80103968:	50                   	push   %eax
80103969:	e8 d2 0f 00 00       	call   80104940 <initlock>
  (*f0)->type = FD_PIPE;
8010396e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103970:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103973:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103979:	8b 03                	mov    (%ebx),%eax
8010397b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010397f:	8b 03                	mov    (%ebx),%eax
80103981:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103985:	8b 03                	mov    (%ebx),%eax
80103987:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010398a:	8b 06                	mov    (%esi),%eax
8010398c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103992:	8b 06                	mov    (%esi),%eax
80103994:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103998:	8b 06                	mov    (%esi),%eax
8010399a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010399e:	8b 06                	mov    (%esi),%eax
801039a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801039a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039a6:	31 c0                	xor    %eax,%eax
}
801039a8:	5b                   	pop    %ebx
801039a9:	5e                   	pop    %esi
801039aa:	5f                   	pop    %edi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801039b0:	8b 03                	mov    (%ebx),%eax
801039b2:	85 c0                	test   %eax,%eax
801039b4:	74 1e                	je     801039d4 <pipealloc+0xe4>
    fileclose(*f0);
801039b6:	83 ec 0c             	sub    $0xc,%esp
801039b9:	50                   	push   %eax
801039ba:	e8 f1 d9 ff ff       	call   801013b0 <fileclose>
801039bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039c2:	8b 06                	mov    (%esi),%eax
801039c4:	85 c0                	test   %eax,%eax
801039c6:	74 0c                	je     801039d4 <pipealloc+0xe4>
    fileclose(*f1);
801039c8:	83 ec 0c             	sub    $0xc,%esp
801039cb:	50                   	push   %eax
801039cc:	e8 df d9 ff ff       	call   801013b0 <fileclose>
801039d1:	83 c4 10             	add    $0x10,%esp
}
801039d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039dc:	5b                   	pop    %ebx
801039dd:	5e                   	pop    %esi
801039de:	5f                   	pop    %edi
801039df:	5d                   	pop    %ebp
801039e0:	c3                   	ret    
801039e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039e8:	8b 03                	mov    (%ebx),%eax
801039ea:	85 c0                	test   %eax,%eax
801039ec:	75 c8                	jne    801039b6 <pipealloc+0xc6>
801039ee:	eb d2                	jmp    801039c2 <pipealloc+0xd2>

801039f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039fb:	83 ec 0c             	sub    $0xc,%esp
801039fe:	53                   	push   %ebx
801039ff:	e8 0c 11 00 00       	call   80104b10 <acquire>
  if(writable){
80103a04:	83 c4 10             	add    $0x10,%esp
80103a07:	85 f6                	test   %esi,%esi
80103a09:	74 65                	je     80103a70 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a0b:	83 ec 0c             	sub    $0xc,%esp
80103a0e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a14:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a1b:	00 00 00 
    wakeup(&p->nread);
80103a1e:	50                   	push   %eax
80103a1f:	e8 9c 0b 00 00       	call   801045c0 <wakeup>
80103a24:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a27:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a2d:	85 d2                	test   %edx,%edx
80103a2f:	75 0a                	jne    80103a3b <pipeclose+0x4b>
80103a31:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a37:	85 c0                	test   %eax,%eax
80103a39:	74 15                	je     80103a50 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a3b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a41:	5b                   	pop    %ebx
80103a42:	5e                   	pop    %esi
80103a43:	5d                   	pop    %ebp
    release(&p->lock);
80103a44:	e9 67 10 00 00       	jmp    80104ab0 <release>
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 57 10 00 00       	call   80104ab0 <release>
    kfree((char*)p);
80103a59:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a5c:	83 c4 10             	add    $0x10,%esp
}
80103a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a62:	5b                   	pop    %ebx
80103a63:	5e                   	pop    %esi
80103a64:	5d                   	pop    %ebp
    kfree((char*)p);
80103a65:	e9 16 ef ff ff       	jmp    80102980 <kfree>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a79:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a80:	00 00 00 
    wakeup(&p->nwrite);
80103a83:	50                   	push   %eax
80103a84:	e8 37 0b 00 00       	call   801045c0 <wakeup>
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	eb 99                	jmp    80103a27 <pipeclose+0x37>
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
80103a95:	53                   	push   %ebx
80103a96:	83 ec 28             	sub    $0x28,%esp
80103a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a9c:	53                   	push   %ebx
80103a9d:	e8 6e 10 00 00       	call   80104b10 <acquire>
  for(i = 0; i < n; i++){
80103aa2:	8b 45 10             	mov    0x10(%ebp),%eax
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	0f 8e c0 00 00 00    	jle    80103b70 <pipewrite+0xe0>
80103ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ab3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103ab9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103abf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ac2:	03 45 10             	add    0x10(%ebp),%eax
80103ac5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ac8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ace:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ad4:	89 ca                	mov    %ecx,%edx
80103ad6:	05 00 02 00 00       	add    $0x200,%eax
80103adb:	39 c1                	cmp    %eax,%ecx
80103add:	74 3f                	je     80103b1e <pipewrite+0x8e>
80103adf:	eb 67                	jmp    80103b48 <pipewrite+0xb8>
80103ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ae8:	e8 43 03 00 00       	call   80103e30 <myproc>
80103aed:	8b 48 24             	mov    0x24(%eax),%ecx
80103af0:	85 c9                	test   %ecx,%ecx
80103af2:	75 34                	jne    80103b28 <pipewrite+0x98>
      wakeup(&p->nread);
80103af4:	83 ec 0c             	sub    $0xc,%esp
80103af7:	57                   	push   %edi
80103af8:	e8 c3 0a 00 00       	call   801045c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103afd:	58                   	pop    %eax
80103afe:	5a                   	pop    %edx
80103aff:	53                   	push   %ebx
80103b00:	56                   	push   %esi
80103b01:	e8 fa 09 00 00       	call   80104500 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b06:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b0c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b12:	83 c4 10             	add    $0x10,%esp
80103b15:	05 00 02 00 00       	add    $0x200,%eax
80103b1a:	39 c2                	cmp    %eax,%edx
80103b1c:	75 2a                	jne    80103b48 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103b1e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b24:	85 c0                	test   %eax,%eax
80103b26:	75 c0                	jne    80103ae8 <pipewrite+0x58>
        release(&p->lock);
80103b28:	83 ec 0c             	sub    $0xc,%esp
80103b2b:	53                   	push   %ebx
80103b2c:	e8 7f 0f 00 00       	call   80104ab0 <release>
        return -1;
80103b31:	83 c4 10             	add    $0x10,%esp
80103b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b3c:	5b                   	pop    %ebx
80103b3d:	5e                   	pop    %esi
80103b3e:	5f                   	pop    %edi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
80103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b48:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b4b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b4e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b54:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b5a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103b5d:	83 c6 01             	add    $0x1,%esi
80103b60:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b63:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b67:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b6a:	0f 85 58 ff ff ff    	jne    80103ac8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b79:	50                   	push   %eax
80103b7a:	e8 41 0a 00 00       	call   801045c0 <wakeup>
  release(&p->lock);
80103b7f:	89 1c 24             	mov    %ebx,(%esp)
80103b82:	e8 29 0f 00 00       	call   80104ab0 <release>
  return n;
80103b87:	8b 45 10             	mov    0x10(%ebp),%eax
80103b8a:	83 c4 10             	add    $0x10,%esp
80103b8d:	eb aa                	jmp    80103b39 <pipewrite+0xa9>
80103b8f:	90                   	nop

80103b90 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 18             	sub    $0x18,%esp
80103b99:	8b 75 08             	mov    0x8(%ebp),%esi
80103b9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b9f:	56                   	push   %esi
80103ba0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103ba6:	e8 65 0f 00 00       	call   80104b10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bab:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bb1:	83 c4 10             	add    $0x10,%esp
80103bb4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103bba:	74 2f                	je     80103beb <piperead+0x5b>
80103bbc:	eb 37                	jmp    80103bf5 <piperead+0x65>
80103bbe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103bc0:	e8 6b 02 00 00       	call   80103e30 <myproc>
80103bc5:	8b 48 24             	mov    0x24(%eax),%ecx
80103bc8:	85 c9                	test   %ecx,%ecx
80103bca:	0f 85 80 00 00 00    	jne    80103c50 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bd0:	83 ec 08             	sub    $0x8,%esp
80103bd3:	56                   	push   %esi
80103bd4:	53                   	push   %ebx
80103bd5:	e8 26 09 00 00       	call   80104500 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bda:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103be0:	83 c4 10             	add    $0x10,%esp
80103be3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103be9:	75 0a                	jne    80103bf5 <piperead+0x65>
80103beb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103bf1:	85 c0                	test   %eax,%eax
80103bf3:	75 cb                	jne    80103bc0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bf5:	8b 55 10             	mov    0x10(%ebp),%edx
80103bf8:	31 db                	xor    %ebx,%ebx
80103bfa:	85 d2                	test   %edx,%edx
80103bfc:	7f 20                	jg     80103c1e <piperead+0x8e>
80103bfe:	eb 2c                	jmp    80103c2c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c00:	8d 48 01             	lea    0x1(%eax),%ecx
80103c03:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c08:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c0e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c13:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c16:	83 c3 01             	add    $0x1,%ebx
80103c19:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c1c:	74 0e                	je     80103c2c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103c1e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c2a:	75 d4                	jne    80103c00 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c2c:	83 ec 0c             	sub    $0xc,%esp
80103c2f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c35:	50                   	push   %eax
80103c36:	e8 85 09 00 00       	call   801045c0 <wakeup>
  release(&p->lock);
80103c3b:	89 34 24             	mov    %esi,(%esp)
80103c3e:	e8 6d 0e 00 00       	call   80104ab0 <release>
  return i;
80103c43:	83 c4 10             	add    $0x10,%esp
}
80103c46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c49:	89 d8                	mov    %ebx,%eax
80103c4b:	5b                   	pop    %ebx
80103c4c:	5e                   	pop    %esi
80103c4d:	5f                   	pop    %edi
80103c4e:	5d                   	pop    %ebp
80103c4f:	c3                   	ret    
      release(&p->lock);
80103c50:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c58:	56                   	push   %esi
80103c59:	e8 52 0e 00 00       	call   80104ab0 <release>
      return -1;
80103c5e:	83 c4 10             	add    $0x10,%esp
}
80103c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c64:	89 d8                	mov    %ebx,%eax
80103c66:	5b                   	pop    %ebx
80103c67:	5e                   	pop    %esi
80103c68:	5f                   	pop    %edi
80103c69:	5d                   	pop    %ebp
80103c6a:	c3                   	ret    
80103c6b:	66 90                	xchg   %ax,%ax
80103c6d:	66 90                	xchg   %ax,%ax
80103c6f:	90                   	nop

80103c70 <allocproc>:
//  If found, change state to EMBRYO and initialize
//  state required to run in the kernel.
//  Otherwise return 0.
static struct proc *
allocproc(void)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c74:	bb 34 c6 12 80       	mov    $0x8012c634,%ebx
{
80103c79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c7c:	68 00 c6 12 80       	push   $0x8012c600
80103c81:	e8 8a 0e 00 00       	call   80104b10 <acquire>
80103c86:	83 c4 10             	add    $0x10,%esp
80103c89:	eb 10                	jmp    80103c9b <allocproc+0x2b>
80103c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c90:	83 c3 7c             	add    $0x7c,%ebx
80103c93:	81 fb 34 e5 12 80    	cmp    $0x8012e534,%ebx
80103c99:	74 75                	je     80103d10 <allocproc+0xa0>
    if (p->state == UNUSED)
80103c9b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c9e:	85 c0                	test   %eax,%eax
80103ca0:	75 ee                	jne    80103c90 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ca2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103ca7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103caa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103cb1:	89 43 10             	mov    %eax,0x10(%ebx)
80103cb4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103cb7:	68 00 c6 12 80       	push   $0x8012c600
  p->pid = nextpid++;
80103cbc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103cc2:	e8 e9 0d 00 00       	call   80104ab0 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103cc7:	e8 74 ee ff ff       	call   80102b40 <kalloc>
80103ccc:	83 c4 10             	add    $0x10,%esp
80103ccf:	89 43 08             	mov    %eax,0x8(%ebx)
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	74 53                	je     80103d29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cd6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103cdc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cdf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ce4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103ce7:	c7 40 14 1f 5f 10 80 	movl   $0x80105f1f,0x14(%eax)
  p->context = (struct context *)sp;
80103cee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cf1:	6a 14                	push   $0x14
80103cf3:	6a 00                	push   $0x0
80103cf5:	50                   	push   %eax
80103cf6:	e8 d5 0e 00 00       	call   80104bd0 <memset>
  p->context->eip = (uint)forkret;
80103cfb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103cfe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103d01:	c7 40 10 40 3d 10 80 	movl   $0x80103d40,0x10(%eax)
}
80103d08:	89 d8                	mov    %ebx,%eax
80103d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0d:	c9                   	leave  
80103d0e:	c3                   	ret    
80103d0f:	90                   	nop
  release(&ptable.lock);
80103d10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d15:	68 00 c6 12 80       	push   $0x8012c600
80103d1a:	e8 91 0d 00 00       	call   80104ab0 <release>
}
80103d1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103d21:	83 c4 10             	add    $0x10,%esp
}
80103d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d27:	c9                   	leave  
80103d28:	c3                   	ret    
    p->state = UNUSED;
80103d29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d30:	31 db                	xor    %ebx,%ebx
}
80103d32:	89 d8                	mov    %ebx,%eax
80103d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d37:	c9                   	leave  
80103d38:	c3                   	ret    
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d40 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d46:	68 00 c6 12 80       	push   $0x8012c600
80103d4b:	e8 60 0d 00 00       	call   80104ab0 <release>

  if (first)
80103d50:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	85 c0                	test   %eax,%eax
80103d5a:	75 04                	jne    80103d60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d5c:	c9                   	leave  
80103d5d:	c3                   	ret    
80103d5e:	66 90                	xchg   %ax,%ax
    first = 0;
80103d60:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d67:	00 00 00 
    iinit(ROOTDEV);
80103d6a:	83 ec 0c             	sub    $0xc,%esp
80103d6d:	6a 01                	push   $0x1
80103d6f:	e8 ac dc ff ff       	call   80101a20 <iinit>
    initlog(ROOTDEV);
80103d74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d7b:	e8 00 f4 ff ff       	call   80103180 <initlog>
}
80103d80:	83 c4 10             	add    $0x10,%esp
80103d83:	c9                   	leave  
80103d84:	c3                   	ret    
80103d85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d90 <pinit>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d96:	68 e0 7d 10 80       	push   $0x80107de0
80103d9b:	68 00 c6 12 80       	push   $0x8012c600
80103da0:	e8 9b 0b 00 00       	call   80104940 <initlock>
}
80103da5:	83 c4 10             	add    $0x10,%esp
80103da8:	c9                   	leave  
80103da9:	c3                   	ret    
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103db0 <mycpu>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db5:	9c                   	pushf  
80103db6:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103db7:	f6 c4 02             	test   $0x2,%ah
80103dba:	75 46                	jne    80103e02 <mycpu+0x52>
  apicid = lapicid();
80103dbc:	e8 ef ef ff ff       	call   80102db0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103dc1:	8b 35 a4 29 11 80    	mov    0x801129a4,%esi
80103dc7:	85 f6                	test   %esi,%esi
80103dc9:	7e 2a                	jle    80103df5 <mycpu+0x45>
80103dcb:	31 d2                	xor    %edx,%edx
80103dcd:	eb 08                	jmp    80103dd7 <mycpu+0x27>
80103dcf:	90                   	nop
80103dd0:	83 c2 01             	add    $0x1,%edx
80103dd3:	39 f2                	cmp    %esi,%edx
80103dd5:	74 1e                	je     80103df5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103dd7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103ddd:	0f b6 99 c0 29 11 80 	movzbl -0x7feed640(%ecx),%ebx
80103de4:	39 c3                	cmp    %eax,%ebx
80103de6:	75 e8                	jne    80103dd0 <mycpu+0x20>
}
80103de8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103deb:	8d 81 c0 29 11 80    	lea    -0x7feed640(%ecx),%eax
}
80103df1:	5b                   	pop    %ebx
80103df2:	5e                   	pop    %esi
80103df3:	5d                   	pop    %ebp
80103df4:	c3                   	ret    
  panic("unknown apicid\n");
80103df5:	83 ec 0c             	sub    $0xc,%esp
80103df8:	68 e7 7d 10 80       	push   $0x80107de7
80103dfd:	e8 7e c5 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	68 cc 7e 10 80       	push   $0x80107ecc
80103e0a:	e8 71 c5 ff ff       	call   80100380 <panic>
80103e0f:	90                   	nop

80103e10 <cpuid>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103e16:	e8 95 ff ff ff       	call   80103db0 <mycpu>
}
80103e1b:	c9                   	leave  
  return mycpu() - cpus;
80103e1c:	2d c0 29 11 80       	sub    $0x801129c0,%eax
80103e21:	c1 f8 04             	sar    $0x4,%eax
80103e24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e2a:	c3                   	ret    
80103e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop

80103e30 <myproc>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e37:	e8 84 0b 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80103e3c:	e8 6f ff ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103e41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e47:	e8 c4 0b 00 00       	call   80104a10 <popcli>
}
80103e4c:	89 d8                	mov    %ebx,%eax
80103e4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e51:	c9                   	leave  
80103e52:	c3                   	ret    
80103e53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e60 <userinit>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e67:	e8 04 fe ff ff       	call   80103c70 <allocproc>
80103e6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e6e:	a3 34 e5 12 80       	mov    %eax,0x8012e534
  if ((p->pgdir = setupkvm()) == 0)
80103e73:	e8 98 36 00 00       	call   80107510 <setupkvm>
80103e78:	89 43 04             	mov    %eax,0x4(%ebx)
80103e7b:	85 c0                	test   %eax,%eax
80103e7d:	0f 84 bd 00 00 00    	je     80103f40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e83:	83 ec 04             	sub    $0x4,%esp
80103e86:	68 2c 00 00 00       	push   $0x2c
80103e8b:	68 60 b4 10 80       	push   $0x8010b460
80103e90:	50                   	push   %eax
80103e91:	e8 2a 33 00 00       	call   801071c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e9f:	6a 4c                	push   $0x4c
80103ea1:	6a 00                	push   $0x0
80103ea3:	ff 73 18             	push   0x18(%ebx)
80103ea6:	e8 25 0d 00 00       	call   80104bd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103eab:	8b 43 18             	mov    0x18(%ebx),%eax
80103eae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ebb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ebf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ec6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ecd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ed1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ed8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103edc:	8b 43 18             	mov    0x18(%ebx),%eax
80103edf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ee6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103ef0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103efa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103efd:	6a 10                	push   $0x10
80103eff:	68 10 7e 10 80       	push   $0x80107e10
80103f04:	50                   	push   %eax
80103f05:	e8 86 0e 00 00       	call   80104d90 <safestrcpy>
  p->cwd = namei("/");
80103f0a:	c7 04 24 19 7e 10 80 	movl   $0x80107e19,(%esp)
80103f11:	e8 4a e6 ff ff       	call   80102560 <namei>
80103f16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f19:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80103f20:	e8 eb 0b 00 00       	call   80104b10 <acquire>
  p->state = RUNNABLE;
80103f25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f2c:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80103f33:	e8 78 0b 00 00       	call   80104ab0 <release>
}
80103f38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3b:	83 c4 10             	add    $0x10,%esp
80103f3e:	c9                   	leave  
80103f3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	68 f7 7d 10 80       	push   $0x80107df7
80103f48:	e8 33 c4 ff ff       	call   80100380 <panic>
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi

80103f50 <growproc>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
80103f55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f58:	e8 63 0a 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80103f5d:	e8 4e fe ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103f62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f68:	e8 a3 0a 00 00       	call   80104a10 <popcli>
  sz = curproc->sz;
80103f6d:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103f6f:	85 f6                	test   %esi,%esi
80103f71:	7f 1d                	jg     80103f90 <growproc+0x40>
  else if (n < 0)
80103f73:	75 3b                	jne    80103fb0 <growproc+0x60>
  switchuvm(curproc);
80103f75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f7a:	53                   	push   %ebx
80103f7b:	e8 30 31 00 00       	call   801070b0 <switchuvm>
  return 0;
80103f80:	83 c4 10             	add    $0x10,%esp
80103f83:	31 c0                	xor    %eax,%eax
}
80103f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f88:	5b                   	pop    %ebx
80103f89:	5e                   	pop    %esi
80103f8a:	5d                   	pop    %ebp
80103f8b:	c3                   	ret    
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f90:	83 ec 04             	sub    $0x4,%esp
80103f93:	01 c6                	add    %eax,%esi
80103f95:	56                   	push   %esi
80103f96:	50                   	push   %eax
80103f97:	ff 73 04             	push   0x4(%ebx)
80103f9a:	e8 91 33 00 00       	call   80107330 <allocuvm>
80103f9f:	83 c4 10             	add    $0x10,%esp
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	75 cf                	jne    80103f75 <growproc+0x25>
      return -1;
80103fa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fab:	eb d8                	jmp    80103f85 <growproc+0x35>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fb0:	83 ec 04             	sub    $0x4,%esp
80103fb3:	01 c6                	add    %eax,%esi
80103fb5:	56                   	push   %esi
80103fb6:	50                   	push   %eax
80103fb7:	ff 73 04             	push   0x4(%ebx)
80103fba:	e8 a1 34 00 00       	call   80107460 <deallocuvm>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	75 af                	jne    80103f75 <growproc+0x25>
80103fc6:	eb de                	jmp    80103fa6 <growproc+0x56>
80103fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fcf:	90                   	nop

80103fd0 <fork>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fd9:	e8 e2 09 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80103fde:	e8 cd fd ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103fe3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe9:	e8 22 0a 00 00       	call   80104a10 <popcli>
  if ((np = allocproc()) == 0)
80103fee:	e8 7d fc ff ff       	call   80103c70 <allocproc>
80103ff3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	0f 84 b7 00 00 00    	je     801040b5 <fork+0xe5>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103ffe:	83 ec 08             	sub    $0x8,%esp
80104001:	ff 33                	push   (%ebx)
80104003:	89 c7                	mov    %eax,%edi
80104005:	ff 73 04             	push   0x4(%ebx)
80104008:	e8 f3 35 00 00       	call   80107600 <copyuvm>
8010400d:	83 c4 10             	add    $0x10,%esp
80104010:	89 47 04             	mov    %eax,0x4(%edi)
80104013:	85 c0                	test   %eax,%eax
80104015:	0f 84 a1 00 00 00    	je     801040bc <fork+0xec>
  np->sz = curproc->sz;
8010401b:	8b 03                	mov    (%ebx),%eax
8010401d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104020:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104022:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104025:	89 c8                	mov    %ecx,%eax
80104027:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010402a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010402f:	8b 73 18             	mov    0x18(%ebx),%esi
80104032:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80104034:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104036:	8b 40 18             	mov    0x18(%eax),%eax
80104039:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80104040:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104044:	85 c0                	test   %eax,%eax
80104046:	74 13                	je     8010405b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104048:	83 ec 0c             	sub    $0xc,%esp
8010404b:	50                   	push   %eax
8010404c:	e8 0f d3 ff ff       	call   80101360 <filedup>
80104051:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104054:	83 c4 10             	add    $0x10,%esp
80104057:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
8010405b:	83 c6 01             	add    $0x1,%esi
8010405e:	83 fe 10             	cmp    $0x10,%esi
80104061:	75 dd                	jne    80104040 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104063:	83 ec 0c             	sub    $0xc,%esp
80104066:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104069:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010406c:	e8 9f db ff ff       	call   80101c10 <idup>
80104071:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104074:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104077:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010407a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010407d:	6a 10                	push   $0x10
8010407f:	53                   	push   %ebx
80104080:	50                   	push   %eax
80104081:	e8 0a 0d 00 00       	call   80104d90 <safestrcpy>
  pid = np->pid;
80104086:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104089:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80104090:	e8 7b 0a 00 00       	call   80104b10 <acquire>
  np->state = RUNNABLE;
80104095:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010409c:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801040a3:	e8 08 0a 00 00       	call   80104ab0 <release>
  return pid;
801040a8:	83 c4 10             	add    $0x10,%esp
}
801040ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ae:	89 d8                	mov    %ebx,%eax
801040b0:	5b                   	pop    %ebx
801040b1:	5e                   	pop    %esi
801040b2:	5f                   	pop    %edi
801040b3:	5d                   	pop    %ebp
801040b4:	c3                   	ret    
    return -1;
801040b5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040ba:	eb ef                	jmp    801040ab <fork+0xdb>
    kfree(np->kstack);
801040bc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040bf:	83 ec 0c             	sub    $0xc,%esp
801040c2:	ff 73 08             	push   0x8(%ebx)
801040c5:	e8 b6 e8 ff ff       	call   80102980 <kfree>
    np->kstack = 0;
801040ca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040d1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040d4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040db:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040e0:	eb c9                	jmp    801040ab <fork+0xdb>
801040e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <scheduler>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801040f9:	e8 b2 fc ff ff       	call   80103db0 <mycpu>
  c->proc = 0;
801040fe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104105:	00 00 00 
  struct cpu *c = mycpu();
80104108:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010410a:	8d 78 04             	lea    0x4(%eax),%edi
8010410d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104110:	fb                   	sti    
    acquire(&ptable.lock);
80104111:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104114:	bb 34 c6 12 80       	mov    $0x8012c634,%ebx
    acquire(&ptable.lock);
80104119:	68 00 c6 12 80       	push   $0x8012c600
8010411e:	e8 ed 09 00 00       	call   80104b10 <acquire>
80104123:	83 c4 10             	add    $0x10,%esp
80104126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412d:	8d 76 00             	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE)
80104130:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104134:	75 33                	jne    80104169 <scheduler+0x79>
      switchuvm(p);
80104136:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104139:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010413f:	53                   	push   %ebx
80104140:	e8 6b 2f 00 00       	call   801070b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104145:	58                   	pop    %eax
80104146:	5a                   	pop    %edx
80104147:	ff 73 1c             	push   0x1c(%ebx)
8010414a:	57                   	push   %edi
      p->state = RUNNING;
8010414b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104152:	e8 94 0c 00 00       	call   80104deb <swtch>
      switchkvm();
80104157:	e8 44 2f 00 00       	call   801070a0 <switchkvm>
      c->proc = 0;
8010415c:	83 c4 10             	add    $0x10,%esp
8010415f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104166:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104169:	83 c3 7c             	add    $0x7c,%ebx
8010416c:	81 fb 34 e5 12 80    	cmp    $0x8012e534,%ebx
80104172:	75 bc                	jne    80104130 <scheduler+0x40>
    release(&ptable.lock);
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	68 00 c6 12 80       	push   $0x8012c600
8010417c:	e8 2f 09 00 00       	call   80104ab0 <release>
    sti();
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	eb 8a                	jmp    80104110 <scheduler+0x20>
80104186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418d:	8d 76 00             	lea    0x0(%esi),%esi

80104190 <sched>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
  pushcli();
80104195:	e8 26 08 00 00       	call   801049c0 <pushcli>
  c = mycpu();
8010419a:	e8 11 fc ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010419f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a5:	e8 66 08 00 00       	call   80104a10 <popcli>
  if (!holding(&ptable.lock))
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 00 c6 12 80       	push   $0x8012c600
801041b2:	e8 b9 08 00 00       	call   80104a70 <holding>
801041b7:	83 c4 10             	add    $0x10,%esp
801041ba:	85 c0                	test   %eax,%eax
801041bc:	74 4f                	je     8010420d <sched+0x7d>
  if (mycpu()->ncli != 1)
801041be:	e8 ed fb ff ff       	call   80103db0 <mycpu>
801041c3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ca:	75 68                	jne    80104234 <sched+0xa4>
  if (p->state == RUNNING)
801041cc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041d0:	74 55                	je     80104227 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041d2:	9c                   	pushf  
801041d3:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801041d4:	f6 c4 02             	test   $0x2,%ah
801041d7:	75 41                	jne    8010421a <sched+0x8a>
  intena = mycpu()->intena;
801041d9:	e8 d2 fb ff ff       	call   80103db0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041de:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041e1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041e7:	e8 c4 fb ff ff       	call   80103db0 <mycpu>
801041ec:	83 ec 08             	sub    $0x8,%esp
801041ef:	ff 70 04             	push   0x4(%eax)
801041f2:	53                   	push   %ebx
801041f3:	e8 f3 0b 00 00       	call   80104deb <swtch>
  mycpu()->intena = intena;
801041f8:	e8 b3 fb ff ff       	call   80103db0 <mycpu>
}
801041fd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104200:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104206:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104209:	5b                   	pop    %ebx
8010420a:	5e                   	pop    %esi
8010420b:	5d                   	pop    %ebp
8010420c:	c3                   	ret    
    panic("sched ptable.lock");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 1b 7e 10 80       	push   $0x80107e1b
80104215:	e8 66 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 47 7e 10 80       	push   $0x80107e47
80104222:	e8 59 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	68 39 7e 10 80       	push   $0x80107e39
8010422f:	e8 4c c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 2d 7e 10 80       	push   $0x80107e2d
8010423c:	e8 3f c1 ff ff       	call   80100380 <panic>
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop

80104250 <exit>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104259:	e8 d2 fb ff ff       	call   80103e30 <myproc>
  if (curproc == initproc)
8010425e:	39 05 34 e5 12 80    	cmp    %eax,0x8012e534
80104264:	0f 84 fd 00 00 00    	je     80104367 <exit+0x117>
8010426a:	89 c3                	mov    %eax,%ebx
8010426c:	8d 70 28             	lea    0x28(%eax),%esi
8010426f:	8d 78 68             	lea    0x68(%eax),%edi
80104272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80104278:	8b 06                	mov    (%esi),%eax
8010427a:	85 c0                	test   %eax,%eax
8010427c:	74 12                	je     80104290 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010427e:	83 ec 0c             	sub    $0xc,%esp
80104281:	50                   	push   %eax
80104282:	e8 29 d1 ff ff       	call   801013b0 <fileclose>
      curproc->ofile[fd] = 0;
80104287:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010428d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104290:	83 c6 04             	add    $0x4,%esi
80104293:	39 f7                	cmp    %esi,%edi
80104295:	75 e1                	jne    80104278 <exit+0x28>
  begin_op();
80104297:	e8 84 ef ff ff       	call   80103220 <begin_op>
  iput(curproc->cwd);
8010429c:	83 ec 0c             	sub    $0xc,%esp
8010429f:	ff 73 68             	push   0x68(%ebx)
801042a2:	e8 c9 da ff ff       	call   80101d70 <iput>
  end_op();
801042a7:	e8 e4 ef ff ff       	call   80103290 <end_op>
  curproc->cwd = 0;
801042ac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801042b3:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801042ba:	e8 51 08 00 00       	call   80104b10 <acquire>
  wakeup1(curproc->parent);
801042bf:	8b 53 14             	mov    0x14(%ebx),%edx
801042c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c5:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
801042ca:	eb 0e                	jmp    801042da <exit+0x8a>
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d0:	83 c0 7c             	add    $0x7c,%eax
801042d3:	3d 34 e5 12 80       	cmp    $0x8012e534,%eax
801042d8:	74 1c                	je     801042f6 <exit+0xa6>
    if (p->state == SLEEPING && p->chan == chan)
801042da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042de:	75 f0                	jne    801042d0 <exit+0x80>
801042e0:	3b 50 20             	cmp    0x20(%eax),%edx
801042e3:	75 eb                	jne    801042d0 <exit+0x80>
      p->state = RUNNABLE;
801042e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ec:	83 c0 7c             	add    $0x7c,%eax
801042ef:	3d 34 e5 12 80       	cmp    $0x8012e534,%eax
801042f4:	75 e4                	jne    801042da <exit+0x8a>
      p->parent = initproc;
801042f6:	8b 0d 34 e5 12 80    	mov    0x8012e534,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042fc:	ba 34 c6 12 80       	mov    $0x8012c634,%edx
80104301:	eb 10                	jmp    80104313 <exit+0xc3>
80104303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104307:	90                   	nop
80104308:	83 c2 7c             	add    $0x7c,%edx
8010430b:	81 fa 34 e5 12 80    	cmp    $0x8012e534,%edx
80104311:	74 3b                	je     8010434e <exit+0xfe>
    if (p->parent == curproc)
80104313:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104316:	75 f0                	jne    80104308 <exit+0xb8>
      if (p->state == ZOMBIE)
80104318:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010431c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010431f:	75 e7                	jne    80104308 <exit+0xb8>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104321:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
80104326:	eb 12                	jmp    8010433a <exit+0xea>
80104328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010432f:	90                   	nop
80104330:	83 c0 7c             	add    $0x7c,%eax
80104333:	3d 34 e5 12 80       	cmp    $0x8012e534,%eax
80104338:	74 ce                	je     80104308 <exit+0xb8>
    if (p->state == SLEEPING && p->chan == chan)
8010433a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010433e:	75 f0                	jne    80104330 <exit+0xe0>
80104340:	3b 48 20             	cmp    0x20(%eax),%ecx
80104343:	75 eb                	jne    80104330 <exit+0xe0>
      p->state = RUNNABLE;
80104345:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010434c:	eb e2                	jmp    80104330 <exit+0xe0>
  curproc->state = ZOMBIE;
8010434e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104355:	e8 36 fe ff ff       	call   80104190 <sched>
  panic("zombie exit");
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 68 7e 10 80       	push   $0x80107e68
80104362:	e8 19 c0 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	68 5b 7e 10 80       	push   $0x80107e5b
8010436f:	e8 0c c0 ff ff       	call   80100380 <panic>
80104374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop

80104380 <wait>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
  pushcli();
80104385:	e8 36 06 00 00       	call   801049c0 <pushcli>
  c = mycpu();
8010438a:	e8 21 fa ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010438f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104395:	e8 76 06 00 00       	call   80104a10 <popcli>
  acquire(&ptable.lock);
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 00 c6 12 80       	push   $0x8012c600
801043a2:	e8 69 07 00 00       	call   80104b10 <acquire>
801043a7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043aa:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ac:	bb 34 c6 12 80       	mov    $0x8012c634,%ebx
801043b1:	eb 10                	jmp    801043c3 <wait+0x43>
801043b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b7:	90                   	nop
801043b8:	83 c3 7c             	add    $0x7c,%ebx
801043bb:	81 fb 34 e5 12 80    	cmp    $0x8012e534,%ebx
801043c1:	74 1b                	je     801043de <wait+0x5e>
      if (p->parent != curproc)
801043c3:	39 73 14             	cmp    %esi,0x14(%ebx)
801043c6:	75 f0                	jne    801043b8 <wait+0x38>
      if (p->state == ZOMBIE)
801043c8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043cc:	74 62                	je     80104430 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ce:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801043d1:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d6:	81 fb 34 e5 12 80    	cmp    $0x8012e534,%ebx
801043dc:	75 e5                	jne    801043c3 <wait+0x43>
    if (!havekids || curproc->killed)
801043de:	85 c0                	test   %eax,%eax
801043e0:	0f 84 a0 00 00 00    	je     80104486 <wait+0x106>
801043e6:	8b 46 24             	mov    0x24(%esi),%eax
801043e9:	85 c0                	test   %eax,%eax
801043eb:	0f 85 95 00 00 00    	jne    80104486 <wait+0x106>
  pushcli();
801043f1:	e8 ca 05 00 00       	call   801049c0 <pushcli>
  c = mycpu();
801043f6:	e8 b5 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801043fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104401:	e8 0a 06 00 00       	call   80104a10 <popcli>
  if (p == 0)
80104406:	85 db                	test   %ebx,%ebx
80104408:	0f 84 8f 00 00 00    	je     8010449d <wait+0x11d>
  p->chan = chan;
8010440e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104411:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104418:	e8 73 fd ff ff       	call   80104190 <sched>
  p->chan = 0;
8010441d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104424:	eb 84                	jmp    801043aa <wait+0x2a>
80104426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104430:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104433:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104436:	ff 73 08             	push   0x8(%ebx)
80104439:	e8 42 e5 ff ff       	call   80102980 <kfree>
        p->kstack = 0;
8010443e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104445:	5a                   	pop    %edx
80104446:	ff 73 04             	push   0x4(%ebx)
80104449:	e8 42 30 00 00       	call   80107490 <freevm>
        p->pid = 0;
8010444e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104455:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010445c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104460:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104467:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010446e:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80104475:	e8 36 06 00 00       	call   80104ab0 <release>
        return pid;
8010447a:	83 c4 10             	add    $0x10,%esp
}
8010447d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104480:	89 f0                	mov    %esi,%eax
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret    
      release(&ptable.lock);
80104486:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104489:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010448e:	68 00 c6 12 80       	push   $0x8012c600
80104493:	e8 18 06 00 00       	call   80104ab0 <release>
      return -1;
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	eb e0                	jmp    8010447d <wait+0xfd>
    panic("sleep");
8010449d:	83 ec 0c             	sub    $0xc,%esp
801044a0:	68 74 7e 10 80       	push   $0x80107e74
801044a5:	e8 d6 be ff ff       	call   80100380 <panic>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <yield>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
801044b7:	68 00 c6 12 80       	push   $0x8012c600
801044bc:	e8 4f 06 00 00       	call   80104b10 <acquire>
  pushcli();
801044c1:	e8 fa 04 00 00       	call   801049c0 <pushcli>
  c = mycpu();
801044c6:	e8 e5 f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801044cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044d1:	e8 3a 05 00 00       	call   80104a10 <popcli>
  myproc()->state = RUNNABLE;
801044d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044dd:	e8 ae fc ff ff       	call   80104190 <sched>
  release(&ptable.lock);
801044e2:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801044e9:	e8 c2 05 00 00       	call   80104ab0 <release>
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	83 c4 10             	add    $0x10,%esp
801044f4:	c9                   	leave  
801044f5:	c3                   	ret    
801044f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044fd:	8d 76 00             	lea    0x0(%esi),%esi

80104500 <sleep>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	53                   	push   %ebx
80104506:	83 ec 0c             	sub    $0xc,%esp
80104509:	8b 7d 08             	mov    0x8(%ebp),%edi
8010450c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010450f:	e8 ac 04 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80104514:	e8 97 f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104519:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010451f:	e8 ec 04 00 00       	call   80104a10 <popcli>
  if (p == 0)
80104524:	85 db                	test   %ebx,%ebx
80104526:	0f 84 87 00 00 00    	je     801045b3 <sleep+0xb3>
  if (lk == 0)
8010452c:	85 f6                	test   %esi,%esi
8010452e:	74 76                	je     801045a6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104530:	81 fe 00 c6 12 80    	cmp    $0x8012c600,%esi
80104536:	74 50                	je     80104588 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 00 c6 12 80       	push   $0x8012c600
80104540:	e8 cb 05 00 00       	call   80104b10 <acquire>
    release(lk);
80104545:	89 34 24             	mov    %esi,(%esp)
80104548:	e8 63 05 00 00       	call   80104ab0 <release>
  p->chan = chan;
8010454d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104550:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104557:	e8 34 fc ff ff       	call   80104190 <sched>
  p->chan = 0;
8010455c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104563:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
8010456a:	e8 41 05 00 00       	call   80104ab0 <release>
    acquire(lk);
8010456f:	89 75 08             	mov    %esi,0x8(%ebp)
80104572:	83 c4 10             	add    $0x10,%esp
}
80104575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104578:	5b                   	pop    %ebx
80104579:	5e                   	pop    %esi
8010457a:	5f                   	pop    %edi
8010457b:	5d                   	pop    %ebp
    acquire(lk);
8010457c:	e9 8f 05 00 00       	jmp    80104b10 <acquire>
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104588:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010458b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104592:	e8 f9 fb ff ff       	call   80104190 <sched>
  p->chan = 0;
80104597:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010459e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a1:	5b                   	pop    %ebx
801045a2:	5e                   	pop    %esi
801045a3:	5f                   	pop    %edi
801045a4:	5d                   	pop    %ebp
801045a5:	c3                   	ret    
    panic("sleep without lk");
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	68 7a 7e 10 80       	push   $0x80107e7a
801045ae:	e8 cd bd ff ff       	call   80100380 <panic>
    panic("sleep");
801045b3:	83 ec 0c             	sub    $0xc,%esp
801045b6:	68 74 7e 10 80       	push   $0x80107e74
801045bb:	e8 c0 bd ff ff       	call   80100380 <panic>

801045c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 10             	sub    $0x10,%esp
801045c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045ca:	68 00 c6 12 80       	push   $0x8012c600
801045cf:	e8 3c 05 00 00       	call   80104b10 <acquire>
801045d4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045d7:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
801045dc:	eb 0c                	jmp    801045ea <wakeup+0x2a>
801045de:	66 90                	xchg   %ax,%ax
801045e0:	83 c0 7c             	add    $0x7c,%eax
801045e3:	3d 34 e5 12 80       	cmp    $0x8012e534,%eax
801045e8:	74 1c                	je     80104606 <wakeup+0x46>
    if (p->state == SLEEPING && p->chan == chan)
801045ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ee:	75 f0                	jne    801045e0 <wakeup+0x20>
801045f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801045f3:	75 eb                	jne    801045e0 <wakeup+0x20>
      p->state = RUNNABLE;
801045f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045fc:	83 c0 7c             	add    $0x7c,%eax
801045ff:	3d 34 e5 12 80       	cmp    $0x8012e534,%eax
80104604:	75 e4                	jne    801045ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104606:	c7 45 08 00 c6 12 80 	movl   $0x8012c600,0x8(%ebp)
}
8010460d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104610:	c9                   	leave  
  release(&ptable.lock);
80104611:	e9 9a 04 00 00       	jmp    80104ab0 <release>
80104616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461d:	8d 76 00             	lea    0x0(%esi),%esi

80104620 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 10             	sub    $0x10,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010462a:	68 00 c6 12 80       	push   $0x8012c600
8010462f:	e8 dc 04 00 00       	call   80104b10 <acquire>
80104634:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104637:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
8010463c:	eb 0c                	jmp    8010464a <kill+0x2a>
8010463e:	66 90                	xchg   %ax,%ax
80104640:	83 c0 7c             	add    $0x7c,%eax
80104643:	3d 34 e5 12 80       	cmp    $0x8012e534,%eax
80104648:	74 36                	je     80104680 <kill+0x60>
  {
    if (p->pid == pid)
8010464a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010464d:	75 f1                	jne    80104640 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
8010464f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104653:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
8010465a:	75 07                	jne    80104663 <kill+0x43>
        p->state = RUNNABLE;
8010465c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104663:	83 ec 0c             	sub    $0xc,%esp
80104666:	68 00 c6 12 80       	push   $0x8012c600
8010466b:	e8 40 04 00 00       	call   80104ab0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104673:	83 c4 10             	add    $0x10,%esp
80104676:	31 c0                	xor    %eax,%eax
}
80104678:	c9                   	leave  
80104679:	c3                   	ret    
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	68 00 c6 12 80       	push   $0x8012c600
80104688:	e8 23 04 00 00       	call   80104ab0 <release>
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104690:	83 c4 10             	add    $0x10,%esp
80104693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104698:	c9                   	leave  
80104699:	c3                   	ret    
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	56                   	push   %esi
801046a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046a8:	53                   	push   %ebx
801046a9:	bb a0 c6 12 80       	mov    $0x8012c6a0,%ebx
801046ae:	83 ec 3c             	sub    $0x3c,%esp
801046b1:	eb 24                	jmp    801046d7 <procdump+0x37>
801046b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b7:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 23 82 10 80       	push   $0x80108223
801046c0:	e8 db bf ff ff       	call   801006a0 <cprintf>
801046c5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c8:	83 c3 7c             	add    $0x7c,%ebx
801046cb:	81 fb a0 e5 12 80    	cmp    $0x8012e5a0,%ebx
801046d1:	0f 84 81 00 00 00    	je     80104758 <procdump+0xb8>
    if (p->state == UNUSED)
801046d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046da:	85 c0                	test   %eax,%eax
801046dc:	74 ea                	je     801046c8 <procdump+0x28>
      state = "???";
801046de:	ba 8b 7e 10 80       	mov    $0x80107e8b,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046e3:	83 f8 05             	cmp    $0x5,%eax
801046e6:	77 11                	ja     801046f9 <procdump+0x59>
801046e8:	8b 14 85 f4 7e 10 80 	mov    -0x7fef810c(,%eax,4),%edx
      state = "???";
801046ef:	b8 8b 7e 10 80       	mov    $0x80107e8b,%eax
801046f4:	85 d2                	test   %edx,%edx
801046f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046f9:	53                   	push   %ebx
801046fa:	52                   	push   %edx
801046fb:	ff 73 a4             	push   -0x5c(%ebx)
801046fe:	68 8f 7e 10 80       	push   $0x80107e8f
80104703:	e8 98 bf ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
80104708:	83 c4 10             	add    $0x10,%esp
8010470b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010470f:	75 a7                	jne    801046b8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104711:	83 ec 08             	sub    $0x8,%esp
80104714:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104717:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010471a:	50                   	push   %eax
8010471b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010471e:	8b 40 0c             	mov    0xc(%eax),%eax
80104721:	83 c0 08             	add    $0x8,%eax
80104724:	50                   	push   %eax
80104725:	e8 36 02 00 00       	call   80104960 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010472a:	83 c4 10             	add    $0x10,%esp
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	8b 17                	mov    (%edi),%edx
80104732:	85 d2                	test   %edx,%edx
80104734:	74 82                	je     801046b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104736:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104739:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010473c:	52                   	push   %edx
8010473d:	68 a1 78 10 80       	push   $0x801078a1
80104742:	e8 59 bf ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104747:	83 c4 10             	add    $0x10,%esp
8010474a:	39 fe                	cmp    %edi,%esi
8010474c:	75 e2                	jne    80104730 <procdump+0x90>
8010474e:	e9 65 ff ff ff       	jmp    801046b8 <procdump+0x18>
80104753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104757:	90                   	nop
  }
}
80104758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475b:	5b                   	pop    %ebx
8010475c:	5e                   	pop    %esi
8010475d:	5f                   	pop    %edi
8010475e:	5d                   	pop    %ebp
8010475f:	c3                   	ret    

80104760 <push_callerp>:
};

struct calling_process call_ps[26] = {0};

void push_callerp(int pid, int num)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	8b 45 0c             	mov    0xc(%ebp),%eax
  int this_size = call_ps[num].size;
80104767:	69 d0 a4 0f 00 00    	imul   $0xfa4,%eax,%edx
  call_ps[num].size++;
  call_ps[num].pids[this_size] = pid;
8010476d:	69 c0 e9 03 00 00    	imul   $0x3e9,%eax,%eax
  int this_size = call_ps[num].size;
80104773:	8b 8a e0 3e 11 80    	mov    -0x7feec120(%edx),%ecx
  call_ps[num].size++;
80104779:	8d 59 01             	lea    0x1(%ecx),%ebx
  call_ps[num].pids[this_size] = pid;
8010477c:	01 c8                	add    %ecx,%eax
  call_ps[num].size++;
8010477e:	89 9a e0 3e 11 80    	mov    %ebx,-0x7feec120(%edx)
  call_ps[num].pids[this_size] = pid;
80104784:	8b 55 08             	mov    0x8(%ebp),%edx
}
80104787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  call_ps[num].pids[this_size] = pid;
8010478a:	89 14 85 40 2f 11 80 	mov    %edx,-0x7feed0c0(,%eax,4)
}
80104791:	c9                   	leave  
80104792:	c3                   	ret    
80104793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <get_callers>:

void get_callers(int sys_call_number)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	53                   	push   %ebx
801047a6:	83 ec 0c             	sub    $0xc,%esp
  int size_of_callers = call_ps[sys_call_number].size;
801047a9:	69 75 08 a4 0f 00 00 	imul   $0xfa4,0x8(%ebp),%esi
  for (int i = 0; i < size_of_callers-1; i++)
801047b0:	8b 86 e0 3e 11 80    	mov    -0x7feec120(%esi),%eax
801047b6:	8d 58 ff             	lea    -0x1(%eax),%ebx
801047b9:	85 db                	test   %ebx,%ebx
801047bb:	7e 21                	jle    801047de <get_callers+0x3e>
801047bd:	31 ff                	xor    %edi,%edi
801047bf:	90                   	nop
  {
    cprintf("%d, ", call_ps[sys_call_number].pids[i]);
801047c0:	83 ec 08             	sub    $0x8,%esp
801047c3:	ff b4 be 40 2f 11 80 	push   -0x7feed0c0(%esi,%edi,4)
  for (int i = 0; i < size_of_callers-1; i++)
801047ca:	83 c7 01             	add    $0x1,%edi
    cprintf("%d, ", call_ps[sys_call_number].pids[i]);
801047cd:	68 98 7e 10 80       	push   $0x80107e98
801047d2:	e8 c9 be ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < size_of_callers-1; i++)
801047d7:	83 c4 10             	add    $0x10,%esp
801047da:	39 df                	cmp    %ebx,%edi
801047dc:	75 e2                	jne    801047c0 <get_callers+0x20>
  }
  cprintf("%d", call_ps[sys_call_number].pids[size_of_callers-1]);
801047de:	69 7d 08 e9 03 00 00 	imul   $0x3e9,0x8(%ebp),%edi
801047e5:	83 ec 08             	sub    $0x8,%esp
801047e8:	01 df                	add    %ebx,%edi
801047ea:	ff 34 bd 40 2f 11 80 	push   -0x7feed0c0(,%edi,4)
801047f1:	68 9d 7e 10 80       	push   $0x80107e9d
801047f6:	e8 a5 be ff ff       	call   801006a0 <cprintf>
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5f                   	pop    %edi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
80104806:	66 90                	xchg   %ax,%ax
80104808:	66 90                	xchg   %ax,%ax
8010480a:	66 90                	xchg   %ax,%ax
8010480c:	66 90                	xchg   %ax,%ax
8010480e:	66 90                	xchg   %ax,%ax

80104810 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010481a:	68 0c 7f 10 80       	push   $0x80107f0c
8010481f:	8d 43 04             	lea    0x4(%ebx),%eax
80104822:	50                   	push   %eax
80104823:	e8 18 01 00 00       	call   80104940 <initlock>
  lk->name = name;
80104828:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010482b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104831:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104834:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010483b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010483e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104841:	c9                   	leave  
80104842:	c3                   	ret    
80104843:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104858:	8d 73 04             	lea    0x4(%ebx),%esi
8010485b:	83 ec 0c             	sub    $0xc,%esp
8010485e:	56                   	push   %esi
8010485f:	e8 ac 02 00 00       	call   80104b10 <acquire>
  while (lk->locked) {
80104864:	8b 13                	mov    (%ebx),%edx
80104866:	83 c4 10             	add    $0x10,%esp
80104869:	85 d2                	test   %edx,%edx
8010486b:	74 16                	je     80104883 <acquiresleep+0x33>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104870:	83 ec 08             	sub    $0x8,%esp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	e8 86 fc ff ff       	call   80104500 <sleep>
  while (lk->locked) {
8010487a:	8b 03                	mov    (%ebx),%eax
8010487c:	83 c4 10             	add    $0x10,%esp
8010487f:	85 c0                	test   %eax,%eax
80104881:	75 ed                	jne    80104870 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104883:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104889:	e8 a2 f5 ff ff       	call   80103e30 <myproc>
8010488e:	8b 40 10             	mov    0x10(%eax),%eax
80104891:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104894:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104897:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
  release(&lk->lk);
8010489d:	e9 0e 02 00 00       	jmp    80104ab0 <release>
801048a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048b8:	8d 73 04             	lea    0x4(%ebx),%esi
801048bb:	83 ec 0c             	sub    $0xc,%esp
801048be:	56                   	push   %esi
801048bf:	e8 4c 02 00 00       	call   80104b10 <acquire>
  lk->locked = 0;
801048c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048d1:	89 1c 24             	mov    %ebx,(%esp)
801048d4:	e8 e7 fc ff ff       	call   801045c0 <wakeup>
  release(&lk->lk);
801048d9:	89 75 08             	mov    %esi,0x8(%ebp)
801048dc:	83 c4 10             	add    $0x10,%esp
}
801048df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
  release(&lk->lk);
801048e5:	e9 c6 01 00 00       	jmp    80104ab0 <release>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	31 ff                	xor    %edi,%edi
801048f6:	56                   	push   %esi
801048f7:	53                   	push   %ebx
801048f8:	83 ec 18             	sub    $0x18,%esp
801048fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104901:	56                   	push   %esi
80104902:	e8 09 02 00 00       	call   80104b10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104907:	8b 03                	mov    (%ebx),%eax
80104909:	83 c4 10             	add    $0x10,%esp
8010490c:	85 c0                	test   %eax,%eax
8010490e:	75 18                	jne    80104928 <holdingsleep+0x38>
  release(&lk->lk);
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	56                   	push   %esi
80104914:	e8 97 01 00 00       	call   80104ab0 <release>
  return r;
}
80104919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010491c:	89 f8                	mov    %edi,%eax
8010491e:	5b                   	pop    %ebx
8010491f:	5e                   	pop    %esi
80104920:	5f                   	pop    %edi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104927:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104928:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010492b:	e8 00 f5 ff ff       	call   80103e30 <myproc>
80104930:	39 58 10             	cmp    %ebx,0x10(%eax)
80104933:	0f 94 c0             	sete   %al
80104936:	0f b6 c0             	movzbl %al,%eax
80104939:	89 c7                	mov    %eax,%edi
8010493b:	eb d3                	jmp    80104910 <holdingsleep+0x20>
8010493d:	66 90                	xchg   %ax,%ax
8010493f:	90                   	nop

80104940 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104946:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010494f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    
8010495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop

80104960 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104960:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104961:	31 d2                	xor    %edx,%edx
{
80104963:	89 e5                	mov    %esp,%ebp
80104965:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104966:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010496c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010496f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104970:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104976:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010497c:	77 1a                	ja     80104998 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010497e:	8b 58 04             	mov    0x4(%eax),%ebx
80104981:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104984:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104987:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104989:	83 fa 0a             	cmp    $0xa,%edx
8010498c:	75 e2                	jne    80104970 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010498e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104991:	c9                   	leave  
80104992:	c3                   	ret    
80104993:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104997:	90                   	nop
  for(; i < 10; i++)
80104998:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010499b:	8d 51 28             	lea    0x28(%ecx),%edx
8010499e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801049a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049a6:	83 c0 04             	add    $0x4,%eax
801049a9:	39 d0                	cmp    %edx,%eax
801049ab:	75 f3                	jne    801049a0 <getcallerpcs+0x40>
}
801049ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b0:	c9                   	leave  
801049b1:	c3                   	ret    
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 04             	sub    $0x4,%esp
801049c7:	9c                   	pushf  
801049c8:	5b                   	pop    %ebx
  asm volatile("cli");
801049c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ca:	e8 e1 f3 ff ff       	call   80103db0 <mycpu>
801049cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049d5:	85 c0                	test   %eax,%eax
801049d7:	74 17                	je     801049f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801049d9:	e8 d2 f3 ff ff       	call   80103db0 <mycpu>
801049de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049e8:	c9                   	leave  
801049e9:	c3                   	ret    
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801049f0:	e8 bb f3 ff ff       	call   80103db0 <mycpu>
801049f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a01:	eb d6                	jmp    801049d9 <pushcli+0x19>
80104a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <popcli>:

void
popcli(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a16:	9c                   	pushf  
80104a17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a18:	f6 c4 02             	test   $0x2,%ah
80104a1b:	75 35                	jne    80104a52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a1d:	e8 8e f3 ff ff       	call   80103db0 <mycpu>
80104a22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a29:	78 34                	js     80104a5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a2b:	e8 80 f3 ff ff       	call   80103db0 <mycpu>
80104a30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a36:	85 d2                	test   %edx,%edx
80104a38:	74 06                	je     80104a40 <popcli+0x30>
    sti();
}
80104a3a:	c9                   	leave  
80104a3b:	c3                   	ret    
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a40:	e8 6b f3 ff ff       	call   80103db0 <mycpu>
80104a45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	74 eb                	je     80104a3a <popcli+0x2a>
  asm volatile("sti");
80104a4f:	fb                   	sti    
}
80104a50:	c9                   	leave  
80104a51:	c3                   	ret    
    panic("popcli - interruptible");
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	68 17 7f 10 80       	push   $0x80107f17
80104a5a:	e8 21 b9 ff ff       	call   80100380 <panic>
    panic("popcli");
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	68 2e 7f 10 80       	push   $0x80107f2e
80104a67:	e8 14 b9 ff ff       	call   80100380 <panic>
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <holding>:
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 75 08             	mov    0x8(%ebp),%esi
80104a78:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a7a:	e8 41 ff ff ff       	call   801049c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a7f:	8b 06                	mov    (%esi),%eax
80104a81:	85 c0                	test   %eax,%eax
80104a83:	75 0b                	jne    80104a90 <holding+0x20>
  popcli();
80104a85:	e8 86 ff ff ff       	call   80104a10 <popcli>
}
80104a8a:	89 d8                	mov    %ebx,%eax
80104a8c:	5b                   	pop    %ebx
80104a8d:	5e                   	pop    %esi
80104a8e:	5d                   	pop    %ebp
80104a8f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104a90:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a93:	e8 18 f3 ff ff       	call   80103db0 <mycpu>
80104a98:	39 c3                	cmp    %eax,%ebx
80104a9a:	0f 94 c3             	sete   %bl
  popcli();
80104a9d:	e8 6e ff ff ff       	call   80104a10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104aa2:	0f b6 db             	movzbl %bl,%ebx
}
80104aa5:	89 d8                	mov    %ebx,%eax
80104aa7:	5b                   	pop    %ebx
80104aa8:	5e                   	pop    %esi
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    
80104aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop

80104ab0 <release>:
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104ab8:	e8 03 ff ff ff       	call   801049c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104abd:	8b 03                	mov    (%ebx),%eax
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	75 15                	jne    80104ad8 <release+0x28>
  popcli();
80104ac3:	e8 48 ff ff ff       	call   80104a10 <popcli>
    panic("release");
80104ac8:	83 ec 0c             	sub    $0xc,%esp
80104acb:	68 35 7f 10 80       	push   $0x80107f35
80104ad0:	e8 ab b8 ff ff       	call   80100380 <panic>
80104ad5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ad8:	8b 73 08             	mov    0x8(%ebx),%esi
80104adb:	e8 d0 f2 ff ff       	call   80103db0 <mycpu>
80104ae0:	39 c6                	cmp    %eax,%esi
80104ae2:	75 df                	jne    80104ac3 <release+0x13>
  popcli();
80104ae4:	e8 27 ff ff ff       	call   80104a10 <popcli>
  lk->pcs[0] = 0;
80104ae9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104af0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104af7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104afc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5d                   	pop    %ebp
  popcli();
80104b08:	e9 03 ff ff ff       	jmp    80104a10 <popcli>
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi

80104b10 <acquire>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104b17:	e8 a4 fe ff ff       	call   801049c0 <pushcli>
  if(holding(lk))
80104b1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104b1f:	e8 9c fe ff ff       	call   801049c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b24:	8b 03                	mov    (%ebx),%eax
80104b26:	85 c0                	test   %eax,%eax
80104b28:	75 7e                	jne    80104ba8 <acquire+0x98>
  popcli();
80104b2a:	e8 e1 fe ff ff       	call   80104a10 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104b2f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104b38:	8b 55 08             	mov    0x8(%ebp),%edx
80104b3b:	89 c8                	mov    %ecx,%eax
80104b3d:	f0 87 02             	lock xchg %eax,(%edx)
80104b40:	85 c0                	test   %eax,%eax
80104b42:	75 f4                	jne    80104b38 <acquire+0x28>
  __sync_synchronize();
80104b44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b4c:	e8 5f f2 ff ff       	call   80103db0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b54:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104b56:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104b59:	31 c0                	xor    %eax,%eax
80104b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b6c:	77 1a                	ja     80104b88 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104b6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b71:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104b75:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104b78:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104b7a:	83 f8 0a             	cmp    $0xa,%eax
80104b7d:	75 e1                	jne    80104b60 <acquire+0x50>
}
80104b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b82:	c9                   	leave  
80104b83:	c3                   	ret    
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b88:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104b8c:	8d 51 34             	lea    0x34(%ecx),%edx
80104b8f:	90                   	nop
    pcs[i] = 0;
80104b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b96:	83 c0 04             	add    $0x4,%eax
80104b99:	39 c2                	cmp    %eax,%edx
80104b9b:	75 f3                	jne    80104b90 <acquire+0x80>
}
80104b9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba0:	c9                   	leave  
80104ba1:	c3                   	ret    
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ba8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104bab:	e8 00 f2 ff ff       	call   80103db0 <mycpu>
80104bb0:	39 c3                	cmp    %eax,%ebx
80104bb2:	0f 85 72 ff ff ff    	jne    80104b2a <acquire+0x1a>
  popcli();
80104bb8:	e8 53 fe ff ff       	call   80104a10 <popcli>
    panic("acquire");
80104bbd:	83 ec 0c             	sub    $0xc,%esp
80104bc0:	68 3d 7f 10 80       	push   $0x80107f3d
80104bc5:	e8 b6 b7 ff ff       	call   80100380 <panic>
80104bca:	66 90                	xchg   %ax,%ax
80104bcc:	66 90                	xchg   %ax,%ax
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <memset>:
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	8b 55 08             	mov    0x8(%ebp),%edx
80104bd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bda:	53                   	push   %ebx
80104bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bde:	89 d7                	mov    %edx,%edi
80104be0:	09 cf                	or     %ecx,%edi
80104be2:	83 e7 03             	and    $0x3,%edi
80104be5:	75 29                	jne    80104c10 <memset+0x40>
80104be7:	0f b6 f8             	movzbl %al,%edi
80104bea:	c1 e0 18             	shl    $0x18,%eax
80104bed:	89 fb                	mov    %edi,%ebx
80104bef:	c1 e9 02             	shr    $0x2,%ecx
80104bf2:	c1 e3 10             	shl    $0x10,%ebx
80104bf5:	09 d8                	or     %ebx,%eax
80104bf7:	09 f8                	or     %edi,%eax
80104bf9:	c1 e7 08             	shl    $0x8,%edi
80104bfc:	09 f8                	or     %edi,%eax
80104bfe:	89 d7                	mov    %edx,%edi
80104c00:	fc                   	cld    
80104c01:	f3 ab                	rep stos %eax,%es:(%edi)
80104c03:	5b                   	pop    %ebx
80104c04:	89 d0                	mov    %edx,%eax
80104c06:	5f                   	pop    %edi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c10:	89 d7                	mov    %edx,%edi
80104c12:	fc                   	cld    
80104c13:	f3 aa                	rep stos %al,%es:(%edi)
80104c15:	5b                   	pop    %ebx
80104c16:	89 d0                	mov    %edx,%eax
80104c18:	5f                   	pop    %edi
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c1f:	90                   	nop

80104c20 <memcmp>:
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	8b 75 10             	mov    0x10(%ebp),%esi
80104c27:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2a:	53                   	push   %ebx
80104c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c2e:	85 f6                	test   %esi,%esi
80104c30:	74 2e                	je     80104c60 <memcmp+0x40>
80104c32:	01 c6                	add    %eax,%esi
80104c34:	eb 14                	jmp    80104c4a <memcmp+0x2a>
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
80104c40:	83 c0 01             	add    $0x1,%eax
80104c43:	83 c2 01             	add    $0x1,%edx
80104c46:	39 f0                	cmp    %esi,%eax
80104c48:	74 16                	je     80104c60 <memcmp+0x40>
80104c4a:	0f b6 0a             	movzbl (%edx),%ecx
80104c4d:	0f b6 18             	movzbl (%eax),%ebx
80104c50:	38 d9                	cmp    %bl,%cl
80104c52:	74 ec                	je     80104c40 <memcmp+0x20>
80104c54:	0f b6 c1             	movzbl %cl,%eax
80104c57:	29 d8                	sub    %ebx,%eax
80104c59:	5b                   	pop    %ebx
80104c5a:	5e                   	pop    %esi
80104c5b:	5d                   	pop    %ebp
80104c5c:	c3                   	ret    
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	5b                   	pop    %ebx
80104c61:	31 c0                	xor    %eax,%eax
80104c63:	5e                   	pop    %esi
80104c64:	5d                   	pop    %ebp
80104c65:	c3                   	ret    
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <memmove>:
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	8b 55 08             	mov    0x8(%ebp),%edx
80104c77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c7a:	56                   	push   %esi
80104c7b:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c7e:	39 d6                	cmp    %edx,%esi
80104c80:	73 26                	jae    80104ca8 <memmove+0x38>
80104c82:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104c85:	39 fa                	cmp    %edi,%edx
80104c87:	73 1f                	jae    80104ca8 <memmove+0x38>
80104c89:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104c8c:	85 c9                	test   %ecx,%ecx
80104c8e:	74 0c                	je     80104c9c <memmove+0x2c>
80104c90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c94:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104c97:	83 e8 01             	sub    $0x1,%eax
80104c9a:	73 f4                	jae    80104c90 <memmove+0x20>
80104c9c:	5e                   	pop    %esi
80104c9d:	89 d0                	mov    %edx,%eax
80104c9f:	5f                   	pop    %edi
80104ca0:	5d                   	pop    %ebp
80104ca1:	c3                   	ret    
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104cab:	89 d7                	mov    %edx,%edi
80104cad:	85 c9                	test   %ecx,%ecx
80104caf:	74 eb                	je     80104c9c <memmove+0x2c>
80104cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104cb9:	39 c6                	cmp    %eax,%esi
80104cbb:	75 fb                	jne    80104cb8 <memmove+0x48>
80104cbd:	5e                   	pop    %esi
80104cbe:	89 d0                	mov    %edx,%eax
80104cc0:	5f                   	pop    %edi
80104cc1:	5d                   	pop    %ebp
80104cc2:	c3                   	ret    
80104cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cd0 <memcpy>:
80104cd0:	eb 9e                	jmp    80104c70 <memmove>
80104cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <strncmp>:
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cea:	53                   	push   %ebx
80104ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cee:	85 f6                	test   %esi,%esi
80104cf0:	74 2e                	je     80104d20 <strncmp+0x40>
80104cf2:	01 d6                	add    %edx,%esi
80104cf4:	eb 18                	jmp    80104d0e <strncmp+0x2e>
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
80104d00:	38 d8                	cmp    %bl,%al
80104d02:	75 14                	jne    80104d18 <strncmp+0x38>
80104d04:	83 c2 01             	add    $0x1,%edx
80104d07:	83 c1 01             	add    $0x1,%ecx
80104d0a:	39 f2                	cmp    %esi,%edx
80104d0c:	74 12                	je     80104d20 <strncmp+0x40>
80104d0e:	0f b6 01             	movzbl (%ecx),%eax
80104d11:	0f b6 1a             	movzbl (%edx),%ebx
80104d14:	84 c0                	test   %al,%al
80104d16:	75 e8                	jne    80104d00 <strncmp+0x20>
80104d18:	29 d8                	sub    %ebx,%eax
80104d1a:	5b                   	pop    %ebx
80104d1b:	5e                   	pop    %esi
80104d1c:	5d                   	pop    %ebp
80104d1d:	c3                   	ret    
80104d1e:	66 90                	xchg   %ax,%ax
80104d20:	5b                   	pop    %ebx
80104d21:	31 c0                	xor    %eax,%eax
80104d23:	5e                   	pop    %esi
80104d24:	5d                   	pop    %ebp
80104d25:	c3                   	ret    
80104d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2d:	8d 76 00             	lea    0x0(%esi),%esi

80104d30 <strncpy>:
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	8b 75 08             	mov    0x8(%ebp),%esi
80104d38:	53                   	push   %ebx
80104d39:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d3c:	89 f0                	mov    %esi,%eax
80104d3e:	eb 15                	jmp    80104d55 <strncpy+0x25>
80104d40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d47:	83 c0 01             	add    $0x1,%eax
80104d4a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104d4e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104d51:	84 d2                	test   %dl,%dl
80104d53:	74 09                	je     80104d5e <strncpy+0x2e>
80104d55:	89 cb                	mov    %ecx,%ebx
80104d57:	83 e9 01             	sub    $0x1,%ecx
80104d5a:	85 db                	test   %ebx,%ebx
80104d5c:	7f e2                	jg     80104d40 <strncpy+0x10>
80104d5e:	89 c2                	mov    %eax,%edx
80104d60:	85 c9                	test   %ecx,%ecx
80104d62:	7e 17                	jle    80104d7b <strncpy+0x4b>
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d68:	83 c2 01             	add    $0x1,%edx
80104d6b:	89 c1                	mov    %eax,%ecx
80104d6d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80104d71:	29 d1                	sub    %edx,%ecx
80104d73:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104d77:	85 c9                	test   %ecx,%ecx
80104d79:	7f ed                	jg     80104d68 <strncpy+0x38>
80104d7b:	5b                   	pop    %ebx
80104d7c:	89 f0                	mov    %esi,%eax
80104d7e:	5e                   	pop    %esi
80104d7f:	5f                   	pop    %edi
80104d80:	5d                   	pop    %ebp
80104d81:	c3                   	ret    
80104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d90 <safestrcpy>:
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	8b 55 10             	mov    0x10(%ebp),%edx
80104d97:	8b 75 08             	mov    0x8(%ebp),%esi
80104d9a:	53                   	push   %ebx
80104d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d9e:	85 d2                	test   %edx,%edx
80104da0:	7e 25                	jle    80104dc7 <safestrcpy+0x37>
80104da2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104da6:	89 f2                	mov    %esi,%edx
80104da8:	eb 16                	jmp    80104dc0 <safestrcpy+0x30>
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db0:	0f b6 08             	movzbl (%eax),%ecx
80104db3:	83 c0 01             	add    $0x1,%eax
80104db6:	83 c2 01             	add    $0x1,%edx
80104db9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104dbc:	84 c9                	test   %cl,%cl
80104dbe:	74 04                	je     80104dc4 <safestrcpy+0x34>
80104dc0:	39 d8                	cmp    %ebx,%eax
80104dc2:	75 ec                	jne    80104db0 <safestrcpy+0x20>
80104dc4:	c6 02 00             	movb   $0x0,(%edx)
80104dc7:	89 f0                	mov    %esi,%eax
80104dc9:	5b                   	pop    %ebx
80104dca:	5e                   	pop    %esi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi

80104dd0 <strlen>:
80104dd0:	55                   	push   %ebp
80104dd1:	31 c0                	xor    %eax,%eax
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ddb:	74 0c                	je     80104de9 <strlen+0x19>
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi
80104de0:	83 c0 01             	add    $0x1,%eax
80104de3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104de7:	75 f7                	jne    80104de0 <strlen+0x10>
80104de9:	5d                   	pop    %ebp
80104dea:	c3                   	ret    

80104deb <swtch>:
80104deb:	8b 44 24 04          	mov    0x4(%esp),%eax
80104def:	8b 54 24 08          	mov    0x8(%esp),%edx
80104df3:	55                   	push   %ebp
80104df4:	53                   	push   %ebx
80104df5:	56                   	push   %esi
80104df6:	57                   	push   %edi
80104df7:	89 20                	mov    %esp,(%eax)
80104df9:	89 d4                	mov    %edx,%esp
80104dfb:	5f                   	pop    %edi
80104dfc:	5e                   	pop    %esi
80104dfd:	5b                   	pop    %ebx
80104dfe:	5d                   	pop    %ebp
80104dff:	c3                   	ret    

80104e00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
80104e04:	83 ec 04             	sub    $0x4,%esp
80104e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e0a:	e8 21 f0 ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e0f:	8b 00                	mov    (%eax),%eax
80104e11:	39 d8                	cmp    %ebx,%eax
80104e13:	76 1b                	jbe    80104e30 <fetchint+0x30>
80104e15:	8d 53 04             	lea    0x4(%ebx),%edx
80104e18:	39 d0                	cmp    %edx,%eax
80104e1a:	72 14                	jb     80104e30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e1f:	8b 13                	mov    (%ebx),%edx
80104e21:	89 10                	mov    %edx,(%eax)
  return 0;
80104e23:	31 c0                	xor    %eax,%eax
}
80104e25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e28:	c9                   	leave  
80104e29:	c3                   	ret    
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e35:	eb ee                	jmp    80104e25 <fetchint+0x25>
80104e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	83 ec 04             	sub    $0x4,%esp
80104e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e4a:	e8 e1 ef ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz)
80104e4f:	39 18                	cmp    %ebx,(%eax)
80104e51:	76 2d                	jbe    80104e80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104e53:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e5a:	39 d3                	cmp    %edx,%ebx
80104e5c:	73 22                	jae    80104e80 <fetchstr+0x40>
80104e5e:	89 d8                	mov    %ebx,%eax
80104e60:	eb 0d                	jmp    80104e6f <fetchstr+0x2f>
80104e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e68:	83 c0 01             	add    $0x1,%eax
80104e6b:	39 c2                	cmp    %eax,%edx
80104e6d:	76 11                	jbe    80104e80 <fetchstr+0x40>
    if(*s == 0)
80104e6f:	80 38 00             	cmpb   $0x0,(%eax)
80104e72:	75 f4                	jne    80104e68 <fetchstr+0x28>
      return s - *pp;
80104e74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    
80104e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop
80104e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e88:	c9                   	leave  
80104e89:	c3                   	ret    
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e95:	e8 96 ef ff ff       	call   80103e30 <myproc>
80104e9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ea0:	8b 40 44             	mov    0x44(%eax),%eax
80104ea3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ea6:	e8 85 ef ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eae:	8b 00                	mov    (%eax),%eax
80104eb0:	39 c6                	cmp    %eax,%esi
80104eb2:	73 1c                	jae    80104ed0 <argint+0x40>
80104eb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104eb7:	39 d0                	cmp    %edx,%eax
80104eb9:	72 15                	jb     80104ed0 <argint+0x40>
  *ip = *(int*)(addr);
80104ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebe:	8b 53 04             	mov    0x4(%ebx),%edx
80104ec1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ec3:	31 c0                	xor    %eax,%eax
}
80104ec5:	5b                   	pop    %ebx
80104ec6:	5e                   	pop    %esi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ed5:	eb ee                	jmp    80104ec5 <argint+0x35>
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ee9:	e8 42 ef ff ff       	call   80103e30 <myproc>
80104eee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ef0:	e8 3b ef ff ff       	call   80103e30 <myproc>
80104ef5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ef8:	8b 40 18             	mov    0x18(%eax),%eax
80104efb:	8b 40 44             	mov    0x44(%eax),%eax
80104efe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f01:	e8 2a ef ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f09:	8b 00                	mov    (%eax),%eax
80104f0b:	39 c7                	cmp    %eax,%edi
80104f0d:	73 31                	jae    80104f40 <argptr+0x60>
80104f0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104f12:	39 c8                	cmp    %ecx,%eax
80104f14:	72 2a                	jb     80104f40 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104f19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f1c:	85 d2                	test   %edx,%edx
80104f1e:	78 20                	js     80104f40 <argptr+0x60>
80104f20:	8b 16                	mov    (%esi),%edx
80104f22:	39 c2                	cmp    %eax,%edx
80104f24:	76 1a                	jbe    80104f40 <argptr+0x60>
80104f26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f29:	01 c3                	add    %eax,%ebx
80104f2b:	39 da                	cmp    %ebx,%edx
80104f2d:	72 11                	jb     80104f40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f32:	89 02                	mov    %eax,(%edx)
  return 0;
80104f34:	31 c0                	xor    %eax,%eax
}
80104f36:	83 c4 0c             	add    $0xc,%esp
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5f                   	pop    %edi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb ef                	jmp    80104f36 <argptr+0x56>
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f55:	e8 d6 ee ff ff       	call   80103e30 <myproc>
80104f5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5d:	8b 40 18             	mov    0x18(%eax),%eax
80104f60:	8b 40 44             	mov    0x44(%eax),%eax
80104f63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f66:	e8 c5 ee ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f6e:	8b 00                	mov    (%eax),%eax
80104f70:	39 c6                	cmp    %eax,%esi
80104f72:	73 44                	jae    80104fb8 <argstr+0x68>
80104f74:	8d 53 08             	lea    0x8(%ebx),%edx
80104f77:	39 d0                	cmp    %edx,%eax
80104f79:	72 3d                	jb     80104fb8 <argstr+0x68>
  *ip = *(int*)(addr);
80104f7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104f7e:	e8 ad ee ff ff       	call   80103e30 <myproc>
  if(addr >= curproc->sz)
80104f83:	3b 18                	cmp    (%eax),%ebx
80104f85:	73 31                	jae    80104fb8 <argstr+0x68>
  *pp = (char*)addr;
80104f87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f8e:	39 d3                	cmp    %edx,%ebx
80104f90:	73 26                	jae    80104fb8 <argstr+0x68>
80104f92:	89 d8                	mov    %ebx,%eax
80104f94:	eb 11                	jmp    80104fa7 <argstr+0x57>
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
80104fa0:	83 c0 01             	add    $0x1,%eax
80104fa3:	39 c2                	cmp    %eax,%edx
80104fa5:	76 11                	jbe    80104fb8 <argstr+0x68>
    if(*s == 0)
80104fa7:	80 38 00             	cmpb   $0x0,(%eax)
80104faa:	75 f4                	jne    80104fa0 <argstr+0x50>
      return s - *pp;
80104fac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104fae:	5b                   	pop    %ebx
80104faf:	5e                   	pop    %esi
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    
80104fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fb8:	5b                   	pop    %ebx
    return -1;
80104fb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fbe:	5e                   	pop    %esi
80104fbf:	5d                   	pop    %ebp
80104fc0:	c3                   	ret    
80104fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop

80104fd0 <syscall>:
[SYS_get_callers] sys_get_callers,
};

void 
syscall(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104fd5:	e8 56 ee ff ff       	call   80103e30 <myproc>
80104fda:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104fdc:	8b 40 18             	mov    0x18(%eax),%eax
80104fdf:	8b 40 1c             	mov    0x1c(%eax),%eax
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
80104fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fe5:	83 fa 17             	cmp    $0x17,%edx
80104fe8:	77 2e                	ja     80105018 <syscall+0x48>
80104fea:	8b 34 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%esi
80104ff1:	85 f6                	test   %esi,%esi
80104ff3:	74 23                	je     80105018 <syscall+0x48>
  {
    push_callerp(curproc->pid, num);
80104ff5:	83 ec 08             	sub    $0x8,%esp
80104ff8:	50                   	push   %eax
80104ff9:	ff 73 10             	push   0x10(%ebx)
80104ffc:	e8 5f f7 ff ff       	call   80104760 <push_callerp>
    curproc->tf->eax = syscalls[num]();
80105001:	ff d6                	call   *%esi
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	89 c2                	mov    %eax,%edx
80105008:	8b 43 18             	mov    0x18(%ebx),%eax
8010500b:	89 50 1c             	mov    %edx,0x1c(%eax)
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
8010500e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5d                   	pop    %ebp
80105014:	c3                   	ret    
80105015:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105018:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105019:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010501c:	50                   	push   %eax
8010501d:	ff 73 10             	push   0x10(%ebx)
80105020:	68 45 7f 10 80       	push   $0x80107f45
80105025:	e8 76 b6 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
8010502a:	8b 43 18             	mov    0x18(%ebx),%eax
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80105037:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010503a:	5b                   	pop    %ebx
8010503b:	5e                   	pop    %esi
8010503c:	5d                   	pop    %ebp
8010503d:	c3                   	ret    
8010503e:	66 90                	xchg   %ax,%ax

80105040 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105045:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105048:	53                   	push   %ebx
80105049:	83 ec 34             	sub    $0x34,%esp
8010504c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010504f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105052:	57                   	push   %edi
80105053:	50                   	push   %eax
{
80105054:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105057:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010505a:	e8 21 d5 ff ff       	call   80102580 <nameiparent>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	0f 84 46 01 00 00    	je     801051b0 <create+0x170>
    return 0;
  ilock(dp);
8010506a:	83 ec 0c             	sub    $0xc,%esp
8010506d:	89 c3                	mov    %eax,%ebx
8010506f:	50                   	push   %eax
80105070:	e8 cb cb ff ff       	call   80101c40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105075:	83 c4 0c             	add    $0xc,%esp
80105078:	6a 00                	push   $0x0
8010507a:	57                   	push   %edi
8010507b:	53                   	push   %ebx
8010507c:	e8 1f d1 ff ff       	call   801021a0 <dirlookup>
80105081:	83 c4 10             	add    $0x10,%esp
80105084:	89 c6                	mov    %eax,%esi
80105086:	85 c0                	test   %eax,%eax
80105088:	74 56                	je     801050e0 <create+0xa0>
    iunlockput(dp);
8010508a:	83 ec 0c             	sub    $0xc,%esp
8010508d:	53                   	push   %ebx
8010508e:	e8 3d ce ff ff       	call   80101ed0 <iunlockput>
    ilock(ip);
80105093:	89 34 24             	mov    %esi,(%esp)
80105096:	e8 a5 cb ff ff       	call   80101c40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010509b:	83 c4 10             	add    $0x10,%esp
8010509e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801050a3:	75 1b                	jne    801050c0 <create+0x80>
801050a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801050aa:	75 14                	jne    801050c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050af:	89 f0                	mov    %esi,%eax
801050b1:	5b                   	pop    %ebx
801050b2:	5e                   	pop    %esi
801050b3:	5f                   	pop    %edi
801050b4:	5d                   	pop    %ebp
801050b5:	c3                   	ret    
801050b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	56                   	push   %esi
    return 0;
801050c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801050c6:	e8 05 ce ff ff       	call   80101ed0 <iunlockput>
    return 0;
801050cb:	83 c4 10             	add    $0x10,%esp
}
801050ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050d1:	89 f0                	mov    %esi,%eax
801050d3:	5b                   	pop    %ebx
801050d4:	5e                   	pop    %esi
801050d5:	5f                   	pop    %edi
801050d6:	5d                   	pop    %ebp
801050d7:	c3                   	ret    
801050d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801050e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801050e4:	83 ec 08             	sub    $0x8,%esp
801050e7:	50                   	push   %eax
801050e8:	ff 33                	push   (%ebx)
801050ea:	e8 e1 c9 ff ff       	call   80101ad0 <ialloc>
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	89 c6                	mov    %eax,%esi
801050f4:	85 c0                	test   %eax,%eax
801050f6:	0f 84 cd 00 00 00    	je     801051c9 <create+0x189>
  ilock(ip);
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	50                   	push   %eax
80105100:	e8 3b cb ff ff       	call   80101c40 <ilock>
  ip->major = major;
80105105:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105109:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010510d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105111:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105115:	b8 01 00 00 00       	mov    $0x1,%eax
8010511a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010511e:	89 34 24             	mov    %esi,(%esp)
80105121:	e8 6a ca ff ff       	call   80101b90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105126:	83 c4 10             	add    $0x10,%esp
80105129:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010512e:	74 30                	je     80105160 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105130:	83 ec 04             	sub    $0x4,%esp
80105133:	ff 76 04             	push   0x4(%esi)
80105136:	57                   	push   %edi
80105137:	53                   	push   %ebx
80105138:	e8 63 d3 ff ff       	call   801024a0 <dirlink>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	78 78                	js     801051bc <create+0x17c>
  iunlockput(dp);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	53                   	push   %ebx
80105148:	e8 83 cd ff ff       	call   80101ed0 <iunlockput>
  return ip;
8010514d:	83 c4 10             	add    $0x10,%esp
}
80105150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105153:	89 f0                	mov    %esi,%eax
80105155:	5b                   	pop    %ebx
80105156:	5e                   	pop    %esi
80105157:	5f                   	pop    %edi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105160:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105163:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105168:	53                   	push   %ebx
80105169:	e8 22 ca ff ff       	call   80101b90 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010516e:	83 c4 0c             	add    $0xc,%esp
80105171:	ff 76 04             	push   0x4(%esi)
80105174:	68 00 80 10 80       	push   $0x80108000
80105179:	56                   	push   %esi
8010517a:	e8 21 d3 ff ff       	call   801024a0 <dirlink>
8010517f:	83 c4 10             	add    $0x10,%esp
80105182:	85 c0                	test   %eax,%eax
80105184:	78 18                	js     8010519e <create+0x15e>
80105186:	83 ec 04             	sub    $0x4,%esp
80105189:	ff 73 04             	push   0x4(%ebx)
8010518c:	68 ff 7f 10 80       	push   $0x80107fff
80105191:	56                   	push   %esi
80105192:	e8 09 d3 ff ff       	call   801024a0 <dirlink>
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	85 c0                	test   %eax,%eax
8010519c:	79 92                	jns    80105130 <create+0xf0>
      panic("create dots");
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	68 f3 7f 10 80       	push   $0x80107ff3
801051a6:	e8 d5 b1 ff ff       	call   80100380 <panic>
801051ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051af:	90                   	nop
}
801051b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801051b3:	31 f6                	xor    %esi,%esi
}
801051b5:	5b                   	pop    %ebx
801051b6:	89 f0                	mov    %esi,%eax
801051b8:	5e                   	pop    %esi
801051b9:	5f                   	pop    %edi
801051ba:	5d                   	pop    %ebp
801051bb:	c3                   	ret    
    panic("create: dirlink");
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	68 02 80 10 80       	push   $0x80108002
801051c4:	e8 b7 b1 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	68 e4 7f 10 80       	push   $0x80107fe4
801051d1:	e8 aa b1 ff ff       	call   80100380 <panic>
801051d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dd:	8d 76 00             	lea    0x0(%esi),%esi

801051e0 <sys_dup>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051eb:	50                   	push   %eax
801051ec:	6a 00                	push   $0x0
801051ee:	e8 9d fc ff ff       	call   80104e90 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 36                	js     80105230 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051fe:	77 30                	ja     80105230 <sys_dup+0x50>
80105200:	e8 2b ec ff ff       	call   80103e30 <myproc>
80105205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105208:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010520c:	85 f6                	test   %esi,%esi
8010520e:	74 20                	je     80105230 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105210:	e8 1b ec ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105215:	31 db                	xor    %ebx,%ebx
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105220:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105224:	85 d2                	test   %edx,%edx
80105226:	74 18                	je     80105240 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105228:	83 c3 01             	add    $0x1,%ebx
8010522b:	83 fb 10             	cmp    $0x10,%ebx
8010522e:	75 f0                	jne    80105220 <sys_dup+0x40>
}
80105230:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105233:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105238:	89 d8                	mov    %ebx,%eax
8010523a:	5b                   	pop    %ebx
8010523b:	5e                   	pop    %esi
8010523c:	5d                   	pop    %ebp
8010523d:	c3                   	ret    
8010523e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105240:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105243:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105247:	56                   	push   %esi
80105248:	e8 13 c1 ff ff       	call   80101360 <filedup>
  return fd;
8010524d:	83 c4 10             	add    $0x10,%esp
}
80105250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105253:	89 d8                	mov    %ebx,%eax
80105255:	5b                   	pop    %ebx
80105256:	5e                   	pop    %esi
80105257:	5d                   	pop    %ebp
80105258:	c3                   	ret    
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_read>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105265:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105268:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010526b:	53                   	push   %ebx
8010526c:	6a 00                	push   $0x0
8010526e:	e8 1d fc ff ff       	call   80104e90 <argint>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 5e                	js     801052d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010527a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010527e:	77 58                	ja     801052d8 <sys_read+0x78>
80105280:	e8 ab eb ff ff       	call   80103e30 <myproc>
80105285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105288:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010528c:	85 f6                	test   %esi,%esi
8010528e:	74 48                	je     801052d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105290:	83 ec 08             	sub    $0x8,%esp
80105293:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105296:	50                   	push   %eax
80105297:	6a 02                	push   $0x2
80105299:	e8 f2 fb ff ff       	call   80104e90 <argint>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 33                	js     801052d8 <sys_read+0x78>
801052a5:	83 ec 04             	sub    $0x4,%esp
801052a8:	ff 75 f0             	push   -0x10(%ebp)
801052ab:	53                   	push   %ebx
801052ac:	6a 01                	push   $0x1
801052ae:	e8 2d fc ff ff       	call   80104ee0 <argptr>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	78 1e                	js     801052d8 <sys_read+0x78>
  return fileread(f, p, n);
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	ff 75 f0             	push   -0x10(%ebp)
801052c0:	ff 75 f4             	push   -0xc(%ebp)
801052c3:	56                   	push   %esi
801052c4:	e8 17 c2 ff ff       	call   801014e0 <fileread>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052cf:	5b                   	pop    %ebx
801052d0:	5e                   	pop    %esi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret    
801052d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d7:	90                   	nop
    return -1;
801052d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052dd:	eb ed                	jmp    801052cc <sys_read+0x6c>
801052df:	90                   	nop

801052e0 <sys_write>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801052e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052eb:	53                   	push   %ebx
801052ec:	6a 00                	push   $0x0
801052ee:	e8 9d fb ff ff       	call   80104e90 <argint>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 5e                	js     80105358 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052fe:	77 58                	ja     80105358 <sys_write+0x78>
80105300:	e8 2b eb ff ff       	call   80103e30 <myproc>
80105305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105308:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010530c:	85 f6                	test   %esi,%esi
8010530e:	74 48                	je     80105358 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105310:	83 ec 08             	sub    $0x8,%esp
80105313:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105316:	50                   	push   %eax
80105317:	6a 02                	push   $0x2
80105319:	e8 72 fb ff ff       	call   80104e90 <argint>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	78 33                	js     80105358 <sys_write+0x78>
80105325:	83 ec 04             	sub    $0x4,%esp
80105328:	ff 75 f0             	push   -0x10(%ebp)
8010532b:	53                   	push   %ebx
8010532c:	6a 01                	push   $0x1
8010532e:	e8 ad fb ff ff       	call   80104ee0 <argptr>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 1e                	js     80105358 <sys_write+0x78>
  return filewrite(f, p, n);
8010533a:	83 ec 04             	sub    $0x4,%esp
8010533d:	ff 75 f0             	push   -0x10(%ebp)
80105340:	ff 75 f4             	push   -0xc(%ebp)
80105343:	56                   	push   %esi
80105344:	e8 27 c2 ff ff       	call   80101570 <filewrite>
80105349:	83 c4 10             	add    $0x10,%esp
}
8010534c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010534f:	5b                   	pop    %ebx
80105350:	5e                   	pop    %esi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret    
80105353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105357:	90                   	nop
    return -1;
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	eb ed                	jmp    8010534c <sys_write+0x6c>
8010535f:	90                   	nop

80105360 <sys_close>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	56                   	push   %esi
80105364:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105365:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105368:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010536b:	50                   	push   %eax
8010536c:	6a 00                	push   $0x0
8010536e:	e8 1d fb ff ff       	call   80104e90 <argint>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	78 3e                	js     801053b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010537a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010537e:	77 38                	ja     801053b8 <sys_close+0x58>
80105380:	e8 ab ea ff ff       	call   80103e30 <myproc>
80105385:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105388:	8d 5a 08             	lea    0x8(%edx),%ebx
8010538b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010538f:	85 f6                	test   %esi,%esi
80105391:	74 25                	je     801053b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105393:	e8 98 ea ff ff       	call   80103e30 <myproc>
  fileclose(f);
80105398:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010539b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801053a2:	00 
  fileclose(f);
801053a3:	56                   	push   %esi
801053a4:	e8 07 c0 ff ff       	call   801013b0 <fileclose>
  return 0;
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5d                   	pop    %ebp
801053b4:	c3                   	ret    
801053b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bd:	eb ef                	jmp    801053ae <sys_close+0x4e>
801053bf:	90                   	nop

801053c0 <sys_fstat>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053cb:	53                   	push   %ebx
801053cc:	6a 00                	push   $0x0
801053ce:	e8 bd fa ff ff       	call   80104e90 <argint>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 46                	js     80105420 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053de:	77 40                	ja     80105420 <sys_fstat+0x60>
801053e0:	e8 4b ea ff ff       	call   80103e30 <myproc>
801053e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053ec:	85 f6                	test   %esi,%esi
801053ee:	74 30                	je     80105420 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053f0:	83 ec 04             	sub    $0x4,%esp
801053f3:	6a 14                	push   $0x14
801053f5:	53                   	push   %ebx
801053f6:	6a 01                	push   $0x1
801053f8:	e8 e3 fa ff ff       	call   80104ee0 <argptr>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	78 1c                	js     80105420 <sys_fstat+0x60>
  return filestat(f, st);
80105404:	83 ec 08             	sub    $0x8,%esp
80105407:	ff 75 f4             	push   -0xc(%ebp)
8010540a:	56                   	push   %esi
8010540b:	e8 80 c0 ff ff       	call   80101490 <filestat>
80105410:	83 c4 10             	add    $0x10,%esp
}
80105413:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105416:	5b                   	pop    %ebx
80105417:	5e                   	pop    %esi
80105418:	5d                   	pop    %ebp
80105419:	c3                   	ret    
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105425:	eb ec                	jmp    80105413 <sys_fstat+0x53>
80105427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542e:	66 90                	xchg   %ax,%ax

80105430 <sys_link>:
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105435:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105438:	53                   	push   %ebx
80105439:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 0c fb ff ff       	call   80104f50 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 fb 00 00 00    	js     8010554a <sys_link+0x11a>
8010544f:	83 ec 08             	sub    $0x8,%esp
80105452:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105455:	50                   	push   %eax
80105456:	6a 01                	push   $0x1
80105458:	e8 f3 fa ff ff       	call   80104f50 <argstr>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	0f 88 e2 00 00 00    	js     8010554a <sys_link+0x11a>
  begin_op();
80105468:	e8 b3 dd ff ff       	call   80103220 <begin_op>
  if((ip = namei(old)) == 0){
8010546d:	83 ec 0c             	sub    $0xc,%esp
80105470:	ff 75 d4             	push   -0x2c(%ebp)
80105473:	e8 e8 d0 ff ff       	call   80102560 <namei>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	89 c3                	mov    %eax,%ebx
8010547d:	85 c0                	test   %eax,%eax
8010547f:	0f 84 e4 00 00 00    	je     80105569 <sys_link+0x139>
  ilock(ip);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	50                   	push   %eax
80105489:	e8 b2 c7 ff ff       	call   80101c40 <ilock>
  if(ip->type == T_DIR){
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105496:	0f 84 b5 00 00 00    	je     80105551 <sys_link+0x121>
  iupdate(ip);
8010549c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010549f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801054a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054a7:	53                   	push   %ebx
801054a8:	e8 e3 c6 ff ff       	call   80101b90 <iupdate>
  iunlock(ip);
801054ad:	89 1c 24             	mov    %ebx,(%esp)
801054b0:	e8 6b c8 ff ff       	call   80101d20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054b5:	58                   	pop    %eax
801054b6:	5a                   	pop    %edx
801054b7:	57                   	push   %edi
801054b8:	ff 75 d0             	push   -0x30(%ebp)
801054bb:	e8 c0 d0 ff ff       	call   80102580 <nameiparent>
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	89 c6                	mov    %eax,%esi
801054c5:	85 c0                	test   %eax,%eax
801054c7:	74 5b                	je     80105524 <sys_link+0xf4>
  ilock(dp);
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	50                   	push   %eax
801054cd:	e8 6e c7 ff ff       	call   80101c40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054d2:	8b 03                	mov    (%ebx),%eax
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	39 06                	cmp    %eax,(%esi)
801054d9:	75 3d                	jne    80105518 <sys_link+0xe8>
801054db:	83 ec 04             	sub    $0x4,%esp
801054de:	ff 73 04             	push   0x4(%ebx)
801054e1:	57                   	push   %edi
801054e2:	56                   	push   %esi
801054e3:	e8 b8 cf ff ff       	call   801024a0 <dirlink>
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	85 c0                	test   %eax,%eax
801054ed:	78 29                	js     80105518 <sys_link+0xe8>
  iunlockput(dp);
801054ef:	83 ec 0c             	sub    $0xc,%esp
801054f2:	56                   	push   %esi
801054f3:	e8 d8 c9 ff ff       	call   80101ed0 <iunlockput>
  iput(ip);
801054f8:	89 1c 24             	mov    %ebx,(%esp)
801054fb:	e8 70 c8 ff ff       	call   80101d70 <iput>
  end_op();
80105500:	e8 8b dd ff ff       	call   80103290 <end_op>
  return 0;
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	31 c0                	xor    %eax,%eax
}
8010550a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010550d:	5b                   	pop    %ebx
8010550e:	5e                   	pop    %esi
8010550f:	5f                   	pop    %edi
80105510:	5d                   	pop    %ebp
80105511:	c3                   	ret    
80105512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105518:	83 ec 0c             	sub    $0xc,%esp
8010551b:	56                   	push   %esi
8010551c:	e8 af c9 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
80105521:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105524:	83 ec 0c             	sub    $0xc,%esp
80105527:	53                   	push   %ebx
80105528:	e8 13 c7 ff ff       	call   80101c40 <ilock>
  ip->nlink--;
8010552d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105532:	89 1c 24             	mov    %ebx,(%esp)
80105535:	e8 56 c6 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
8010553a:	89 1c 24             	mov    %ebx,(%esp)
8010553d:	e8 8e c9 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105542:	e8 49 dd ff ff       	call   80103290 <end_op>
  return -1;
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554f:	eb b9                	jmp    8010550a <sys_link+0xda>
    iunlockput(ip);
80105551:	83 ec 0c             	sub    $0xc,%esp
80105554:	53                   	push   %ebx
80105555:	e8 76 c9 ff ff       	call   80101ed0 <iunlockput>
    end_op();
8010555a:	e8 31 dd ff ff       	call   80103290 <end_op>
    return -1;
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105567:	eb a1                	jmp    8010550a <sys_link+0xda>
    end_op();
80105569:	e8 22 dd ff ff       	call   80103290 <end_op>
    return -1;
8010556e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105573:	eb 95                	jmp    8010550a <sys_link+0xda>
80105575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_unlink>:
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105585:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105588:	53                   	push   %ebx
80105589:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010558c:	50                   	push   %eax
8010558d:	6a 00                	push   $0x0
8010558f:	e8 bc f9 ff ff       	call   80104f50 <argstr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	0f 88 7a 01 00 00    	js     80105719 <sys_unlink+0x199>
  begin_op();
8010559f:	e8 7c dc ff ff       	call   80103220 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801055a7:	83 ec 08             	sub    $0x8,%esp
801055aa:	53                   	push   %ebx
801055ab:	ff 75 c0             	push   -0x40(%ebp)
801055ae:	e8 cd cf ff ff       	call   80102580 <nameiparent>
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801055b9:	85 c0                	test   %eax,%eax
801055bb:	0f 84 62 01 00 00    	je     80105723 <sys_unlink+0x1a3>
  ilock(dp);
801055c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801055c4:	83 ec 0c             	sub    $0xc,%esp
801055c7:	57                   	push   %edi
801055c8:	e8 73 c6 ff ff       	call   80101c40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055cd:	58                   	pop    %eax
801055ce:	5a                   	pop    %edx
801055cf:	68 00 80 10 80       	push   $0x80108000
801055d4:	53                   	push   %ebx
801055d5:	e8 a6 cb ff ff       	call   80102180 <namecmp>
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	85 c0                	test   %eax,%eax
801055df:	0f 84 fb 00 00 00    	je     801056e0 <sys_unlink+0x160>
801055e5:	83 ec 08             	sub    $0x8,%esp
801055e8:	68 ff 7f 10 80       	push   $0x80107fff
801055ed:	53                   	push   %ebx
801055ee:	e8 8d cb ff ff       	call   80102180 <namecmp>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	0f 84 e2 00 00 00    	je     801056e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801055fe:	83 ec 04             	sub    $0x4,%esp
80105601:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105604:	50                   	push   %eax
80105605:	53                   	push   %ebx
80105606:	57                   	push   %edi
80105607:	e8 94 cb ff ff       	call   801021a0 <dirlookup>
8010560c:	83 c4 10             	add    $0x10,%esp
8010560f:	89 c3                	mov    %eax,%ebx
80105611:	85 c0                	test   %eax,%eax
80105613:	0f 84 c7 00 00 00    	je     801056e0 <sys_unlink+0x160>
  ilock(ip);
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	50                   	push   %eax
8010561d:	e8 1e c6 ff ff       	call   80101c40 <ilock>
  if(ip->nlink < 1)
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010562a:	0f 8e 1c 01 00 00    	jle    8010574c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105630:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105635:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105638:	74 66                	je     801056a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010563a:	83 ec 04             	sub    $0x4,%esp
8010563d:	6a 10                	push   $0x10
8010563f:	6a 00                	push   $0x0
80105641:	57                   	push   %edi
80105642:	e8 89 f5 ff ff       	call   80104bd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105647:	6a 10                	push   $0x10
80105649:	ff 75 c4             	push   -0x3c(%ebp)
8010564c:	57                   	push   %edi
8010564d:	ff 75 b4             	push   -0x4c(%ebp)
80105650:	e8 fb c9 ff ff       	call   80102050 <writei>
80105655:	83 c4 20             	add    $0x20,%esp
80105658:	83 f8 10             	cmp    $0x10,%eax
8010565b:	0f 85 de 00 00 00    	jne    8010573f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105661:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105666:	0f 84 94 00 00 00    	je     80105700 <sys_unlink+0x180>
  iunlockput(dp);
8010566c:	83 ec 0c             	sub    $0xc,%esp
8010566f:	ff 75 b4             	push   -0x4c(%ebp)
80105672:	e8 59 c8 ff ff       	call   80101ed0 <iunlockput>
  ip->nlink--;
80105677:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010567c:	89 1c 24             	mov    %ebx,(%esp)
8010567f:	e8 0c c5 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
80105684:	89 1c 24             	mov    %ebx,(%esp)
80105687:	e8 44 c8 ff ff       	call   80101ed0 <iunlockput>
  end_op();
8010568c:	e8 ff db ff ff       	call   80103290 <end_op>
  return 0;
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	31 c0                	xor    %eax,%eax
}
80105696:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105699:	5b                   	pop    %ebx
8010569a:	5e                   	pop    %esi
8010569b:	5f                   	pop    %edi
8010569c:	5d                   	pop    %ebp
8010569d:	c3                   	ret    
8010569e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056a4:	76 94                	jbe    8010563a <sys_unlink+0xba>
801056a6:	be 20 00 00 00       	mov    $0x20,%esi
801056ab:	eb 0b                	jmp    801056b8 <sys_unlink+0x138>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
801056b0:	83 c6 10             	add    $0x10,%esi
801056b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801056b6:	73 82                	jae    8010563a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056b8:	6a 10                	push   $0x10
801056ba:	56                   	push   %esi
801056bb:	57                   	push   %edi
801056bc:	53                   	push   %ebx
801056bd:	e8 8e c8 ff ff       	call   80101f50 <readi>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	83 f8 10             	cmp    $0x10,%eax
801056c8:	75 68                	jne    80105732 <sys_unlink+0x1b2>
    if(de.inum != 0)
801056ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056cf:	74 df                	je     801056b0 <sys_unlink+0x130>
    iunlockput(ip);
801056d1:	83 ec 0c             	sub    $0xc,%esp
801056d4:	53                   	push   %ebx
801056d5:	e8 f6 c7 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	ff 75 b4             	push   -0x4c(%ebp)
801056e6:	e8 e5 c7 ff ff       	call   80101ed0 <iunlockput>
  end_op();
801056eb:	e8 a0 db ff ff       	call   80103290 <end_op>
  return -1;
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f8:	eb 9c                	jmp    80105696 <sys_unlink+0x116>
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105700:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105703:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105706:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010570b:	50                   	push   %eax
8010570c:	e8 7f c4 ff ff       	call   80101b90 <iupdate>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	e9 53 ff ff ff       	jmp    8010566c <sys_unlink+0xec>
    return -1;
80105719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571e:	e9 73 ff ff ff       	jmp    80105696 <sys_unlink+0x116>
    end_op();
80105723:	e8 68 db ff ff       	call   80103290 <end_op>
    return -1;
80105728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572d:	e9 64 ff ff ff       	jmp    80105696 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105732:	83 ec 0c             	sub    $0xc,%esp
80105735:	68 24 80 10 80       	push   $0x80108024
8010573a:	e8 41 ac ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010573f:	83 ec 0c             	sub    $0xc,%esp
80105742:	68 36 80 10 80       	push   $0x80108036
80105747:	e8 34 ac ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	68 12 80 10 80       	push   $0x80108012
80105754:	e8 27 ac ff ff       	call   80100380 <panic>
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_open>:

int
sys_open(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105765:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105768:	53                   	push   %ebx
80105769:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010576c:	50                   	push   %eax
8010576d:	6a 00                	push   $0x0
8010576f:	e8 dc f7 ff ff       	call   80104f50 <argstr>
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	85 c0                	test   %eax,%eax
80105779:	0f 88 8e 00 00 00    	js     8010580d <sys_open+0xad>
8010577f:	83 ec 08             	sub    $0x8,%esp
80105782:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105785:	50                   	push   %eax
80105786:	6a 01                	push   $0x1
80105788:	e8 03 f7 ff ff       	call   80104e90 <argint>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	78 79                	js     8010580d <sys_open+0xad>
    return -1;

  begin_op();
80105794:	e8 87 da ff ff       	call   80103220 <begin_op>

  if(omode & O_CREATE){
80105799:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010579d:	75 79                	jne    80105818 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010579f:	83 ec 0c             	sub    $0xc,%esp
801057a2:	ff 75 e0             	push   -0x20(%ebp)
801057a5:	e8 b6 cd ff ff       	call   80102560 <namei>
801057aa:	83 c4 10             	add    $0x10,%esp
801057ad:	89 c6                	mov    %eax,%esi
801057af:	85 c0                	test   %eax,%eax
801057b1:	0f 84 7e 00 00 00    	je     80105835 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	50                   	push   %eax
801057bb:	e8 80 c4 ff ff       	call   80101c40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057c0:	83 c4 10             	add    $0x10,%esp
801057c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057c8:	0f 84 c2 00 00 00    	je     80105890 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ce:	e8 1d bb ff ff       	call   801012f0 <filealloc>
801057d3:	89 c7                	mov    %eax,%edi
801057d5:	85 c0                	test   %eax,%eax
801057d7:	74 23                	je     801057fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801057d9:	e8 52 e6 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	74 60                	je     80105848 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801057e8:	83 c3 01             	add    $0x1,%ebx
801057eb:	83 fb 10             	cmp    $0x10,%ebx
801057ee:	75 f0                	jne    801057e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	57                   	push   %edi
801057f4:	e8 b7 bb ff ff       	call   801013b0 <fileclose>
801057f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	56                   	push   %esi
80105800:	e8 cb c6 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105805:	e8 86 da ff ff       	call   80103290 <end_op>
    return -1;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105812:	eb 6d                	jmp    80105881 <sys_open+0x121>
80105814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010581e:	31 c9                	xor    %ecx,%ecx
80105820:	ba 02 00 00 00       	mov    $0x2,%edx
80105825:	6a 00                	push   $0x0
80105827:	e8 14 f8 ff ff       	call   80105040 <create>
    if(ip == 0){
8010582c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010582f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105831:	85 c0                	test   %eax,%eax
80105833:	75 99                	jne    801057ce <sys_open+0x6e>
      end_op();
80105835:	e8 56 da ff ff       	call   80103290 <end_op>
      return -1;
8010583a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010583f:	eb 40                	jmp    80105881 <sys_open+0x121>
80105841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105848:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010584b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010584f:	56                   	push   %esi
80105850:	e8 cb c4 ff ff       	call   80101d20 <iunlock>
  end_op();
80105855:	e8 36 da ff ff       	call   80103290 <end_op>

  f->type = FD_INODE;
8010585a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105863:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105866:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105869:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010586b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105872:	f7 d0                	not    %eax
80105874:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105877:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010587a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010587d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105884:	89 d8                	mov    %ebx,%eax
80105886:	5b                   	pop    %ebx
80105887:	5e                   	pop    %esi
80105888:	5f                   	pop    %edi
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    
8010588b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105893:	85 c9                	test   %ecx,%ecx
80105895:	0f 84 33 ff ff ff    	je     801057ce <sys_open+0x6e>
8010589b:	e9 5c ff ff ff       	jmp    801057fc <sys_open+0x9c>

801058a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058a6:	e8 75 d9 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 97 f6 ff ff       	call   80104f50 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 30                	js     801058f0 <sys_mkdir+0x50>
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	31 c9                	xor    %ecx,%ecx
801058c8:	ba 01 00 00 00       	mov    $0x1,%edx
801058cd:	6a 00                	push   $0x0
801058cf:	e8 6c f7 ff ff       	call   80105040 <create>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	74 15                	je     801058f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058db:	83 ec 0c             	sub    $0xc,%esp
801058de:	50                   	push   %eax
801058df:	e8 ec c5 ff ff       	call   80101ed0 <iunlockput>
  end_op();
801058e4:	e8 a7 d9 ff ff       	call   80103290 <end_op>
  return 0;
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	31 c0                	xor    %eax,%eax
}
801058ee:	c9                   	leave  
801058ef:	c3                   	ret    
    end_op();
801058f0:	e8 9b d9 ff ff       	call   80103290 <end_op>
    return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058fa:	c9                   	leave  
801058fb:	c3                   	ret    
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_mknod>:

int
sys_mknod(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105906:	e8 15 d9 ff ff       	call   80103220 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010590b:	83 ec 08             	sub    $0x8,%esp
8010590e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105911:	50                   	push   %eax
80105912:	6a 00                	push   $0x0
80105914:	e8 37 f6 ff ff       	call   80104f50 <argstr>
80105919:	83 c4 10             	add    $0x10,%esp
8010591c:	85 c0                	test   %eax,%eax
8010591e:	78 60                	js     80105980 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105926:	50                   	push   %eax
80105927:	6a 01                	push   $0x1
80105929:	e8 62 f5 ff ff       	call   80104e90 <argint>
  if((argstr(0, &path)) < 0 ||
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	85 c0                	test   %eax,%eax
80105933:	78 4b                	js     80105980 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105935:	83 ec 08             	sub    $0x8,%esp
80105938:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593b:	50                   	push   %eax
8010593c:	6a 02                	push   $0x2
8010593e:	e8 4d f5 ff ff       	call   80104e90 <argint>
     argint(1, &major) < 0 ||
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 36                	js     80105980 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010594a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010594e:	83 ec 0c             	sub    $0xc,%esp
80105951:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105955:	ba 03 00 00 00       	mov    $0x3,%edx
8010595a:	50                   	push   %eax
8010595b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010595e:	e8 dd f6 ff ff       	call   80105040 <create>
     argint(2, &minor) < 0 ||
80105963:	83 c4 10             	add    $0x10,%esp
80105966:	85 c0                	test   %eax,%eax
80105968:	74 16                	je     80105980 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010596a:	83 ec 0c             	sub    $0xc,%esp
8010596d:	50                   	push   %eax
8010596e:	e8 5d c5 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105973:	e8 18 d9 ff ff       	call   80103290 <end_op>
  return 0;
80105978:	83 c4 10             	add    $0x10,%esp
8010597b:	31 c0                	xor    %eax,%eax
}
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    
8010597f:	90                   	nop
    end_op();
80105980:	e8 0b d9 ff ff       	call   80103290 <end_op>
    return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598a:	c9                   	leave  
8010598b:	c3                   	ret    
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_chdir>:

int
sys_chdir(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	56                   	push   %esi
80105994:	53                   	push   %ebx
80105995:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105998:	e8 93 e4 ff ff       	call   80103e30 <myproc>
8010599d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010599f:	e8 7c d8 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059aa:	50                   	push   %eax
801059ab:	6a 00                	push   $0x0
801059ad:	e8 9e f5 ff ff       	call   80104f50 <argstr>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 77                	js     80105a30 <sys_chdir+0xa0>
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	ff 75 f4             	push   -0xc(%ebp)
801059bf:	e8 9c cb ff ff       	call   80102560 <namei>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	89 c3                	mov    %eax,%ebx
801059c9:	85 c0                	test   %eax,%eax
801059cb:	74 63                	je     80105a30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	50                   	push   %eax
801059d1:	e8 6a c2 ff ff       	call   80101c40 <ilock>
  if(ip->type != T_DIR){
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059de:	75 30                	jne    80105a10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	53                   	push   %ebx
801059e4:	e8 37 c3 ff ff       	call   80101d20 <iunlock>
  iput(curproc->cwd);
801059e9:	58                   	pop    %eax
801059ea:	ff 76 68             	push   0x68(%esi)
801059ed:	e8 7e c3 ff ff       	call   80101d70 <iput>
  end_op();
801059f2:	e8 99 d8 ff ff       	call   80103290 <end_op>
  curproc->cwd = ip;
801059f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	31 c0                	xor    %eax,%eax
}
801059ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a02:	5b                   	pop    %ebx
80105a03:	5e                   	pop    %esi
80105a04:	5d                   	pop    %ebp
80105a05:	c3                   	ret    
80105a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	53                   	push   %ebx
80105a14:	e8 b7 c4 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105a19:	e8 72 d8 ff ff       	call   80103290 <end_op>
    return -1;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a26:	eb d7                	jmp    801059ff <sys_chdir+0x6f>
80105a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop
    end_op();
80105a30:	e8 5b d8 ff ff       	call   80103290 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb c3                	jmp    801059ff <sys_chdir+0x6f>
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_exec>:

int
sys_exec(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a45:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a4b:	53                   	push   %ebx
80105a4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a52:	50                   	push   %eax
80105a53:	6a 00                	push   $0x0
80105a55:	e8 f6 f4 ff ff       	call   80104f50 <argstr>
80105a5a:	83 c4 10             	add    $0x10,%esp
80105a5d:	85 c0                	test   %eax,%eax
80105a5f:	0f 88 87 00 00 00    	js     80105aec <sys_exec+0xac>
80105a65:	83 ec 08             	sub    $0x8,%esp
80105a68:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a6e:	50                   	push   %eax
80105a6f:	6a 01                	push   $0x1
80105a71:	e8 1a f4 ff ff       	call   80104e90 <argint>
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	78 6f                	js     80105aec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a7d:	83 ec 04             	sub    $0x4,%esp
80105a80:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105a86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a88:	68 80 00 00 00       	push   $0x80
80105a8d:	6a 00                	push   $0x0
80105a8f:	56                   	push   %esi
80105a90:	e8 3b f1 ff ff       	call   80104bd0 <memset>
80105a95:	83 c4 10             	add    $0x10,%esp
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105aa0:	83 ec 08             	sub    $0x8,%esp
80105aa3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105aa9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105ab0:	50                   	push   %eax
80105ab1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ab7:	01 f8                	add    %edi,%eax
80105ab9:	50                   	push   %eax
80105aba:	e8 41 f3 ff ff       	call   80104e00 <fetchint>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	78 26                	js     80105aec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105ac6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105acc:	85 c0                	test   %eax,%eax
80105ace:	74 30                	je     80105b00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105ad6:	52                   	push   %edx
80105ad7:	50                   	push   %eax
80105ad8:	e8 63 f3 ff ff       	call   80104e40 <fetchstr>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	78 08                	js     80105aec <sys_exec+0xac>
  for(i=0;; i++){
80105ae4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ae7:	83 fb 20             	cmp    $0x20,%ebx
80105aea:	75 b4                	jne    80105aa0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af4:	5b                   	pop    %ebx
80105af5:	5e                   	pop    %esi
80105af6:	5f                   	pop    %edi
80105af7:	5d                   	pop    %ebp
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105b00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b07:	00 00 00 00 
  return exec(path, argv);
80105b0b:	83 ec 08             	sub    $0x8,%esp
80105b0e:	56                   	push   %esi
80105b0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105b15:	e8 56 b4 ff ff       	call   80100f70 <exec>
80105b1a:	83 c4 10             	add    $0x10,%esp
}
80105b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b20:	5b                   	pop    %ebx
80105b21:	5e                   	pop    %esi
80105b22:	5f                   	pop    %edi
80105b23:	5d                   	pop    %ebp
80105b24:	c3                   	ret    
80105b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_pipe>:

int
sys_pipe(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b35:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b38:	53                   	push   %ebx
80105b39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b3c:	6a 08                	push   $0x8
80105b3e:	50                   	push   %eax
80105b3f:	6a 00                	push   $0x0
80105b41:	e8 9a f3 ff ff       	call   80104ee0 <argptr>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	78 4a                	js     80105b97 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b4d:	83 ec 08             	sub    $0x8,%esp
80105b50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b53:	50                   	push   %eax
80105b54:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b57:	50                   	push   %eax
80105b58:	e8 93 dd ff ff       	call   801038f0 <pipealloc>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	78 33                	js     80105b97 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b64:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b67:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b69:	e8 c2 e2 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105b70:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b74:	85 f6                	test   %esi,%esi
80105b76:	74 28                	je     80105ba0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105b78:	83 c3 01             	add    $0x1,%ebx
80105b7b:	83 fb 10             	cmp    $0x10,%ebx
80105b7e:	75 f0                	jne    80105b70 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	ff 75 e0             	push   -0x20(%ebp)
80105b86:	e8 25 b8 ff ff       	call   801013b0 <fileclose>
    fileclose(wf);
80105b8b:	58                   	pop    %eax
80105b8c:	ff 75 e4             	push   -0x1c(%ebp)
80105b8f:	e8 1c b8 ff ff       	call   801013b0 <fileclose>
    return -1;
80105b94:	83 c4 10             	add    $0x10,%esp
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	eb 53                	jmp    80105bf1 <sys_pipe+0xc1>
80105b9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ba0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ba3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ba7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105baa:	e8 81 e2 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105baf:	31 d2                	xor    %edx,%edx
80105bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bbc:	85 c9                	test   %ecx,%ecx
80105bbe:	74 20                	je     80105be0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105bc0:	83 c2 01             	add    $0x1,%edx
80105bc3:	83 fa 10             	cmp    $0x10,%edx
80105bc6:	75 f0                	jne    80105bb8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105bc8:	e8 63 e2 ff ff       	call   80103e30 <myproc>
80105bcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bd4:	00 
80105bd5:	eb a9                	jmp    80105b80 <sys_pipe+0x50>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105be0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105be4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105be7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105bef:	31 c0                	xor    %eax,%eax
}
80105bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf4:	5b                   	pop    %ebx
80105bf5:	5e                   	pop    %esi
80105bf6:	5f                   	pop    %edi
80105bf7:	5d                   	pop    %ebp
80105bf8:	c3                   	ret    
80105bf9:	66 90                	xchg   %ax,%ax
80105bfb:	66 90                	xchg   %ax,%ax
80105bfd:	66 90                	xchg   %ax,%ax
80105bff:	90                   	nop

80105c00 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105c00:	e9 cb e3 ff ff       	jmp    80103fd0 <fork>
80105c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_exit>:
}

int
sys_exit(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c16:	e8 35 e6 ff ff       	call   80104250 <exit>
  return 0;  // not reached
}
80105c1b:	31 c0                	xor    %eax,%eax
80105c1d:	c9                   	leave  
80105c1e:	c3                   	ret    
80105c1f:	90                   	nop

80105c20 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105c20:	e9 5b e7 ff ff       	jmp    80104380 <wait>
80105c25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_kill>:
}

int
sys_kill(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c39:	50                   	push   %eax
80105c3a:	6a 00                	push   $0x0
80105c3c:	e8 4f f2 ff ff       	call   80104e90 <argint>
80105c41:	83 c4 10             	add    $0x10,%esp
80105c44:	85 c0                	test   %eax,%eax
80105c46:	78 18                	js     80105c60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	ff 75 f4             	push   -0xc(%ebp)
80105c4e:	e8 cd e9 ff ff       	call   80104620 <kill>
80105c53:	83 c4 10             	add    $0x10,%esp
}
80105c56:	c9                   	leave  
80105c57:	c3                   	ret    
80105c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5f:	90                   	nop
80105c60:	c9                   	leave  
    return -1;
80105c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c66:	c3                   	ret    
80105c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <sys_getpid>:

int
sys_getpid(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c76:	e8 b5 e1 ff ff       	call   80103e30 <myproc>
80105c7b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c7e:	c9                   	leave  
80105c7f:	c3                   	ret    

80105c80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c8a:	50                   	push   %eax
80105c8b:	6a 00                	push   $0x0
80105c8d:	e8 fe f1 ff ff       	call   80104e90 <argint>
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	85 c0                	test   %eax,%eax
80105c97:	78 27                	js     80105cc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c99:	e8 92 e1 ff ff       	call   80103e30 <myproc>
  if(growproc(n) < 0)
80105c9e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ca1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ca3:	ff 75 f4             	push   -0xc(%ebp)
80105ca6:	e8 a5 e2 ff ff       	call   80103f50 <growproc>
80105cab:	83 c4 10             	add    $0x10,%esp
80105cae:	85 c0                	test   %eax,%eax
80105cb0:	78 0e                	js     80105cc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105cb2:	89 d8                	mov    %ebx,%eax
80105cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cb7:	c9                   	leave  
80105cb8:	c3                   	ret    
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cc5:	eb eb                	jmp    80105cb2 <sys_sbrk+0x32>
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <sys_sleep>:

int
sys_sleep(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cda:	50                   	push   %eax
80105cdb:	6a 00                	push   $0x0
80105cdd:	e8 ae f1 ff ff       	call   80104e90 <argint>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	0f 88 8a 00 00 00    	js     80105d77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ced:	83 ec 0c             	sub    $0xc,%esp
80105cf0:	68 60 e5 12 80       	push   $0x8012e560
80105cf5:	e8 16 ee ff ff       	call   80104b10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105cfd:	8b 1d 40 e5 12 80    	mov    0x8012e540,%ebx
  while(ticks - ticks0 < n){
80105d03:	83 c4 10             	add    $0x10,%esp
80105d06:	85 d2                	test   %edx,%edx
80105d08:	75 27                	jne    80105d31 <sys_sleep+0x61>
80105d0a:	eb 54                	jmp    80105d60 <sys_sleep+0x90>
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	68 60 e5 12 80       	push   $0x8012e560
80105d18:	68 40 e5 12 80       	push   $0x8012e540
80105d1d:	e8 de e7 ff ff       	call   80104500 <sleep>
  while(ticks - ticks0 < n){
80105d22:	a1 40 e5 12 80       	mov    0x8012e540,%eax
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	29 d8                	sub    %ebx,%eax
80105d2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d2f:	73 2f                	jae    80105d60 <sys_sleep+0x90>
    if(myproc()->killed){
80105d31:	e8 fa e0 ff ff       	call   80103e30 <myproc>
80105d36:	8b 40 24             	mov    0x24(%eax),%eax
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 d3                	je     80105d10 <sys_sleep+0x40>
      release(&tickslock);
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	68 60 e5 12 80       	push   $0x8012e560
80105d45:	e8 66 ed ff ff       	call   80104ab0 <release>
  }
  release(&tickslock);
  return 0;
}
80105d4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105d4d:	83 c4 10             	add    $0x10,%esp
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	68 60 e5 12 80       	push   $0x8012e560
80105d68:	e8 43 ed ff ff       	call   80104ab0 <release>
  return 0;
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	31 c0                	xor    %eax,%eax
}
80105d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    
    return -1;
80105d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7c:	eb f4                	jmp    80105d72 <sys_sleep+0xa2>
80105d7e:	66 90                	xchg   %ax,%ax

80105d80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	53                   	push   %ebx
80105d84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d87:	68 60 e5 12 80       	push   $0x8012e560
80105d8c:	e8 7f ed ff ff       	call   80104b10 <acquire>
  xticks = ticks;
80105d91:	8b 1d 40 e5 12 80    	mov    0x8012e540,%ebx
  release(&tickslock);
80105d97:	c7 04 24 60 e5 12 80 	movl   $0x8012e560,(%esp)
80105d9e:	e8 0d ed ff ff       	call   80104ab0 <release>
  return xticks;
}
80105da3:	89 d8                	mov    %ebx,%eax
80105da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da8:	c9                   	leave  
80105da9:	c3                   	ret    
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105db0 <sys_get_parent_pid>:

int
sys_get_parent_pid(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80105db6:	e8 75 e0 ff ff       	call   80103e30 <myproc>
80105dbb:	8b 40 14             	mov    0x14(%eax),%eax
80105dbe:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dc1:	c9                   	leave  
80105dc2:	c3                   	ret    
80105dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dd0 <sys_find_largest_prime_factor>:

int
sys_find_largest_prime_factor(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
80105dd6:	83 ec 0c             	sub    $0xc,%esp
  int n = myproc()->tf->edx;
80105dd9:	e8 52 e0 ff ff       	call   80103e30 <myproc>
80105dde:	8b 40 18             	mov    0x18(%eax),%eax
80105de1:	8b 48 14             	mov    0x14(%eax),%ecx
  // cprintf("sys_find_largest_prime_factor called with n=%d\n", n);
  
  int maxPrime = -1;
  while (n % 2 == 0) {
80105de4:	f6 c1 01             	test   $0x1,%cl
80105de7:	0f 85 d2 00 00 00    	jne    80105ebf <sys_find_largest_prime_factor+0xef>
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
      maxPrime = 2;
      n = n / 2;
80105df0:	89 c8                	mov    %ecx,%eax
80105df2:	c1 e8 1f             	shr    $0x1f,%eax
80105df5:	01 c8                	add    %ecx,%eax
80105df7:	89 c1                	mov    %eax,%ecx
80105df9:	d1 f9                	sar    %ecx
  while (n % 2 == 0) {
80105dfb:	a8 02                	test   $0x2,%al
80105dfd:	74 f1                	je     80105df0 <sys_find_largest_prime_factor+0x20>
      maxPrime = 2;
80105dff:	be 02 00 00 00       	mov    $0x2,%esi
  }
  while (n % 3 == 0) {
80105e04:	69 c1 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%eax
80105e0a:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
80105e0f:	3d 54 55 55 55       	cmp    $0x55555554,%eax
80105e14:	77 2e                	ja     80105e44 <sys_find_largest_prime_factor+0x74>
      maxPrime = 3;
      n = n / 3;
80105e16:	bb 56 55 55 55       	mov    $0x55555556,%ebx
80105e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e1f:	90                   	nop
80105e20:	89 c8                	mov    %ecx,%eax
80105e22:	f7 eb                	imul   %ebx
80105e24:	89 c8                	mov    %ecx,%eax
80105e26:	c1 f8 1f             	sar    $0x1f,%eax
80105e29:	29 c2                	sub    %eax,%edx
80105e2b:	69 c2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%eax
80105e31:	89 d1                	mov    %edx,%ecx
80105e33:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
  while (n % 3 == 0) {
80105e38:	3d 54 55 55 55       	cmp    $0x55555554,%eax
80105e3d:	76 e1                	jbe    80105e20 <sys_find_largest_prime_factor+0x50>
      maxPrime = 3;
80105e3f:	be 03 00 00 00       	mov    $0x3,%esi
  }

  for (int i = 5; i <= n/2; i += 6) {
80105e44:	bb 05 00 00 00       	mov    $0x5,%ebx
80105e49:	83 f9 09             	cmp    $0x9,%ecx
80105e4c:	7e 4b                	jle    80105e99 <sys_find_largest_prime_factor+0xc9>
80105e4e:	66 90                	xchg   %ax,%ax
      while (n % i == 0) {
80105e50:	89 c8                	mov    %ecx,%eax
80105e52:	89 f7                	mov    %esi,%edi
80105e54:	99                   	cltd   
80105e55:	f7 fb                	idiv   %ebx
80105e57:	85 d2                	test   %edx,%edx
80105e59:	75 15                	jne    80105e70 <sys_find_largest_prime_factor+0xa0>
80105e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop
          maxPrime = i;
          n = n / i;
80105e60:	89 c8                	mov    %ecx,%eax
80105e62:	99                   	cltd   
80105e63:	f7 fb                	idiv   %ebx
      while (n % i == 0) {
80105e65:	99                   	cltd   
          n = n / i;
80105e66:	89 c1                	mov    %eax,%ecx
      while (n % i == 0) {
80105e68:	f7 fb                	idiv   %ebx
80105e6a:	85 d2                	test   %edx,%edx
80105e6c:	74 f2                	je     80105e60 <sys_find_largest_prime_factor+0x90>
80105e6e:	89 df                	mov    %ebx,%edi
      }
      while (n % (i+2) == 0) {
80105e70:	89 c8                	mov    %ecx,%eax
80105e72:	8d 73 02             	lea    0x2(%ebx),%esi
80105e75:	99                   	cltd   
80105e76:	f7 fe                	idiv   %esi
80105e78:	85 d2                	test   %edx,%edx
80105e7a:	75 34                	jne    80105eb0 <sys_find_largest_prime_factor+0xe0>
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          maxPrime = i + 2;
          n = n / (i + 2);
80105e80:	89 c8                	mov    %ecx,%eax
80105e82:	99                   	cltd   
80105e83:	f7 fe                	idiv   %esi
      while (n % (i+2) == 0) {
80105e85:	99                   	cltd   
          n = n / (i + 2);
80105e86:	89 c1                	mov    %eax,%ecx
      while (n % (i+2) == 0) {
80105e88:	f7 fe                	idiv   %esi
80105e8a:	85 d2                	test   %edx,%edx
80105e8c:	74 f2                	je     80105e80 <sys_find_largest_prime_factor+0xb0>
  for (int i = 5; i <= n/2; i += 6) {
80105e8e:	89 c8                	mov    %ecx,%eax
80105e90:	83 c3 06             	add    $0x6,%ebx
80105e93:	d1 f8                	sar    %eax
80105e95:	39 d8                	cmp    %ebx,%eax
80105e97:	7d b7                	jge    80105e50 <sys_find_largest_prime_factor+0x80>
      }
  }

  if (n > 4) {
80105e99:	83 f9 05             	cmp    $0x5,%ecx
80105e9c:	0f 4d f1             	cmovge %ecx,%esi
      maxPrime = n;
  }

  // cprintf("sys_find_largest_prime_factor returning %d\n", maxPrime);
  return maxPrime;
}
80105e9f:	83 c4 0c             	add    $0xc,%esp
80105ea2:	5b                   	pop    %ebx
80105ea3:	89 f0                	mov    %esi,%eax
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
80105ea8:	c3                   	ret    
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 5; i <= n/2; i += 6) {
80105eb0:	89 c8                	mov    %ecx,%eax
80105eb2:	83 c3 06             	add    $0x6,%ebx
      while (n % (i+2) == 0) {
80105eb5:	89 fe                	mov    %edi,%esi
  for (int i = 5; i <= n/2; i += 6) {
80105eb7:	d1 f8                	sar    %eax
80105eb9:	39 d8                	cmp    %ebx,%eax
80105ebb:	7d 93                	jge    80105e50 <sys_find_largest_prime_factor+0x80>
80105ebd:	eb da                	jmp    80105e99 <sys_find_largest_prime_factor+0xc9>
  int maxPrime = -1;
80105ebf:	be ff ff ff ff       	mov    $0xffffffff,%esi
80105ec4:	e9 3b ff ff ff       	jmp    80105e04 <sys_find_largest_prime_factor+0x34>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <sys_get_callers>:

int 
sys_get_callers(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 20             	sub    $0x20,%esp
  int sys_call_number;
  if (argint(0, &sys_call_number) < 0)
80105ed6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed9:	50                   	push   %eax
80105eda:	6a 00                	push   $0x0
80105edc:	e8 af ef ff ff       	call   80104e90 <argint>
80105ee1:	83 c4 10             	add    $0x10,%esp
80105ee4:	85 c0                	test   %eax,%eax
80105ee6:	78 18                	js     80105f00 <sys_get_callers+0x30>
    return -1;

  get_callers(sys_call_number);
80105ee8:	83 ec 0c             	sub    $0xc,%esp
80105eeb:	ff 75 f4             	push   -0xc(%ebp)
80105eee:	e8 ad e8 ff ff       	call   801047a0 <get_callers>
  return 0;
80105ef3:	83 c4 10             	add    $0x10,%esp
80105ef6:	31 c0                	xor    %eax,%eax
}
80105ef8:	c9                   	leave  
80105ef9:	c3                   	ret    
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f00:	c9                   	leave  
    return -1;
80105f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f06:	c3                   	ret    

80105f07 <alltraps>:
80105f07:	1e                   	push   %ds
80105f08:	06                   	push   %es
80105f09:	0f a0                	push   %fs
80105f0b:	0f a8                	push   %gs
80105f0d:	60                   	pusha  
80105f0e:	66 b8 10 00          	mov    $0x10,%ax
80105f12:	8e d8                	mov    %eax,%ds
80105f14:	8e c0                	mov    %eax,%es
80105f16:	54                   	push   %esp
80105f17:	e8 c4 00 00 00       	call   80105fe0 <trap>
80105f1c:	83 c4 04             	add    $0x4,%esp

80105f1f <trapret>:
80105f1f:	61                   	popa   
80105f20:	0f a9                	pop    %gs
80105f22:	0f a1                	pop    %fs
80105f24:	07                   	pop    %es
80105f25:	1f                   	pop    %ds
80105f26:	83 c4 08             	add    $0x8,%esp
80105f29:	cf                   	iret   
80105f2a:	66 90                	xchg   %ax,%ax
80105f2c:	66 90                	xchg   %ax,%ax
80105f2e:	66 90                	xchg   %ax,%ax

80105f30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f31:	31 c0                	xor    %eax,%eax
{
80105f33:	89 e5                	mov    %esp,%ebp
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f40:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f47:	c7 04 c5 a2 e5 12 80 	movl   $0x8e000008,-0x7fed1a5e(,%eax,8)
80105f4e:	08 00 00 8e 
80105f52:	66 89 14 c5 a0 e5 12 	mov    %dx,-0x7fed1a60(,%eax,8)
80105f59:	80 
80105f5a:	c1 ea 10             	shr    $0x10,%edx
80105f5d:	66 89 14 c5 a6 e5 12 	mov    %dx,-0x7fed1a5a(,%eax,8)
80105f64:	80 
  for(i = 0; i < 256; i++)
80105f65:	83 c0 01             	add    $0x1,%eax
80105f68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f6d:	75 d1                	jne    80105f40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105f6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f72:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105f77:	c7 05 a2 e7 12 80 08 	movl   $0xef000008,0x8012e7a2
80105f7e:	00 00 ef 
  initlock(&tickslock, "time");
80105f81:	68 45 80 10 80       	push   $0x80108045
80105f86:	68 60 e5 12 80       	push   $0x8012e560
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f8b:	66 a3 a0 e7 12 80    	mov    %ax,0x8012e7a0
80105f91:	c1 e8 10             	shr    $0x10,%eax
80105f94:	66 a3 a6 e7 12 80    	mov    %ax,0x8012e7a6
  initlock(&tickslock, "time");
80105f9a:	e8 a1 e9 ff ff       	call   80104940 <initlock>
}
80105f9f:	83 c4 10             	add    $0x10,%esp
80105fa2:	c9                   	leave  
80105fa3:	c3                   	ret    
80105fa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105faf:	90                   	nop

80105fb0 <idtinit>:

void
idtinit(void)
{
80105fb0:	55                   	push   %ebp
  pd[0] = size-1;
80105fb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fb6:	89 e5                	mov    %esp,%ebp
80105fb8:	83 ec 10             	sub    $0x10,%esp
80105fbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fbf:	b8 a0 e5 12 80       	mov    $0x8012e5a0,%eax
80105fc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fc8:	c1 e8 10             	shr    $0x10,%eax
80105fcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	57                   	push   %edi
80105fe4:	56                   	push   %esi
80105fe5:	53                   	push   %ebx
80105fe6:	83 ec 1c             	sub    $0x1c,%esp
80105fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105fec:	8b 43 30             	mov    0x30(%ebx),%eax
80105fef:	83 f8 40             	cmp    $0x40,%eax
80105ff2:	0f 84 68 01 00 00    	je     80106160 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ff8:	83 e8 20             	sub    $0x20,%eax
80105ffb:	83 f8 1f             	cmp    $0x1f,%eax
80105ffe:	0f 87 8c 00 00 00    	ja     80106090 <trap+0xb0>
80106004:	ff 24 85 ec 80 10 80 	jmp    *-0x7fef7f14(,%eax,4)
8010600b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106010:	e8 eb c6 ff ff       	call   80102700 <ideintr>
    lapiceoi();
80106015:	e8 b6 cd ff ff       	call   80102dd0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010601a:	e8 11 de ff ff       	call   80103e30 <myproc>
8010601f:	85 c0                	test   %eax,%eax
80106021:	74 1d                	je     80106040 <trap+0x60>
80106023:	e8 08 de ff ff       	call   80103e30 <myproc>
80106028:	8b 50 24             	mov    0x24(%eax),%edx
8010602b:	85 d2                	test   %edx,%edx
8010602d:	74 11                	je     80106040 <trap+0x60>
8010602f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106033:	83 e0 03             	and    $0x3,%eax
80106036:	66 83 f8 03          	cmp    $0x3,%ax
8010603a:	0f 84 e8 01 00 00    	je     80106228 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106040:	e8 eb dd ff ff       	call   80103e30 <myproc>
80106045:	85 c0                	test   %eax,%eax
80106047:	74 0f                	je     80106058 <trap+0x78>
80106049:	e8 e2 dd ff ff       	call   80103e30 <myproc>
8010604e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106052:	0f 84 b8 00 00 00    	je     80106110 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106058:	e8 d3 dd ff ff       	call   80103e30 <myproc>
8010605d:	85 c0                	test   %eax,%eax
8010605f:	74 1d                	je     8010607e <trap+0x9e>
80106061:	e8 ca dd ff ff       	call   80103e30 <myproc>
80106066:	8b 40 24             	mov    0x24(%eax),%eax
80106069:	85 c0                	test   %eax,%eax
8010606b:	74 11                	je     8010607e <trap+0x9e>
8010606d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106071:	83 e0 03             	and    $0x3,%eax
80106074:	66 83 f8 03          	cmp    $0x3,%ax
80106078:	0f 84 0f 01 00 00    	je     8010618d <trap+0x1ad>
    exit();
}
8010607e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106081:	5b                   	pop    %ebx
80106082:	5e                   	pop    %esi
80106083:	5f                   	pop    %edi
80106084:	5d                   	pop    %ebp
80106085:	c3                   	ret    
80106086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106090:	e8 9b dd ff ff       	call   80103e30 <myproc>
80106095:	8b 7b 38             	mov    0x38(%ebx),%edi
80106098:	85 c0                	test   %eax,%eax
8010609a:	0f 84 a2 01 00 00    	je     80106242 <trap+0x262>
801060a0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060a4:	0f 84 98 01 00 00    	je     80106242 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060aa:	0f 20 d1             	mov    %cr2,%ecx
801060ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060b0:	e8 5b dd ff ff       	call   80103e10 <cpuid>
801060b5:	8b 73 30             	mov    0x30(%ebx),%esi
801060b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060bb:	8b 43 34             	mov    0x34(%ebx),%eax
801060be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801060c1:	e8 6a dd ff ff       	call   80103e30 <myproc>
801060c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060c9:	e8 62 dd ff ff       	call   80103e30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060d4:	51                   	push   %ecx
801060d5:	57                   	push   %edi
801060d6:	52                   	push   %edx
801060d7:	ff 75 e4             	push   -0x1c(%ebp)
801060da:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060db:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060de:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060e1:	56                   	push   %esi
801060e2:	ff 70 10             	push   0x10(%eax)
801060e5:	68 a8 80 10 80       	push   $0x801080a8
801060ea:	e8 b1 a5 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801060ef:	83 c4 20             	add    $0x20,%esp
801060f2:	e8 39 dd ff ff       	call   80103e30 <myproc>
801060f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060fe:	e8 2d dd ff ff       	call   80103e30 <myproc>
80106103:	85 c0                	test   %eax,%eax
80106105:	0f 85 18 ff ff ff    	jne    80106023 <trap+0x43>
8010610b:	e9 30 ff ff ff       	jmp    80106040 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106110:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106114:	0f 85 3e ff ff ff    	jne    80106058 <trap+0x78>
    yield();
8010611a:	e8 91 e3 ff ff       	call   801044b0 <yield>
8010611f:	e9 34 ff ff ff       	jmp    80106058 <trap+0x78>
80106124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106128:	8b 7b 38             	mov    0x38(%ebx),%edi
8010612b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010612f:	e8 dc dc ff ff       	call   80103e10 <cpuid>
80106134:	57                   	push   %edi
80106135:	56                   	push   %esi
80106136:	50                   	push   %eax
80106137:	68 50 80 10 80       	push   $0x80108050
8010613c:	e8 5f a5 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106141:	e8 8a cc ff ff       	call   80102dd0 <lapiceoi>
    break;
80106146:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106149:	e8 e2 dc ff ff       	call   80103e30 <myproc>
8010614e:	85 c0                	test   %eax,%eax
80106150:	0f 85 cd fe ff ff    	jne    80106023 <trap+0x43>
80106156:	e9 e5 fe ff ff       	jmp    80106040 <trap+0x60>
8010615b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010615f:	90                   	nop
    if(myproc()->killed)
80106160:	e8 cb dc ff ff       	call   80103e30 <myproc>
80106165:	8b 70 24             	mov    0x24(%eax),%esi
80106168:	85 f6                	test   %esi,%esi
8010616a:	0f 85 c8 00 00 00    	jne    80106238 <trap+0x258>
    myproc()->tf = tf;
80106170:	e8 bb dc ff ff       	call   80103e30 <myproc>
80106175:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106178:	e8 53 ee ff ff       	call   80104fd0 <syscall>
    if(myproc()->killed)
8010617d:	e8 ae dc ff ff       	call   80103e30 <myproc>
80106182:	8b 48 24             	mov    0x24(%eax),%ecx
80106185:	85 c9                	test   %ecx,%ecx
80106187:	0f 84 f1 fe ff ff    	je     8010607e <trap+0x9e>
}
8010618d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106190:	5b                   	pop    %ebx
80106191:	5e                   	pop    %esi
80106192:	5f                   	pop    %edi
80106193:	5d                   	pop    %ebp
      exit();
80106194:	e9 b7 e0 ff ff       	jmp    80104250 <exit>
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801061a0:	e8 3b 02 00 00       	call   801063e0 <uartintr>
    lapiceoi();
801061a5:	e8 26 cc ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061aa:	e8 81 dc ff ff       	call   80103e30 <myproc>
801061af:	85 c0                	test   %eax,%eax
801061b1:	0f 85 6c fe ff ff    	jne    80106023 <trap+0x43>
801061b7:	e9 84 fe ff ff       	jmp    80106040 <trap+0x60>
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801061c0:	e8 cb ca ff ff       	call   80102c90 <kbdintr>
    lapiceoi();
801061c5:	e8 06 cc ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ca:	e8 61 dc ff ff       	call   80103e30 <myproc>
801061cf:	85 c0                	test   %eax,%eax
801061d1:	0f 85 4c fe ff ff    	jne    80106023 <trap+0x43>
801061d7:	e9 64 fe ff ff       	jmp    80106040 <trap+0x60>
801061dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801061e0:	e8 2b dc ff ff       	call   80103e10 <cpuid>
801061e5:	85 c0                	test   %eax,%eax
801061e7:	0f 85 28 fe ff ff    	jne    80106015 <trap+0x35>
      acquire(&tickslock);
801061ed:	83 ec 0c             	sub    $0xc,%esp
801061f0:	68 60 e5 12 80       	push   $0x8012e560
801061f5:	e8 16 e9 ff ff       	call   80104b10 <acquire>
      wakeup(&ticks);
801061fa:	c7 04 24 40 e5 12 80 	movl   $0x8012e540,(%esp)
      ticks++;
80106201:	83 05 40 e5 12 80 01 	addl   $0x1,0x8012e540
      wakeup(&ticks);
80106208:	e8 b3 e3 ff ff       	call   801045c0 <wakeup>
      release(&tickslock);
8010620d:	c7 04 24 60 e5 12 80 	movl   $0x8012e560,(%esp)
80106214:	e8 97 e8 ff ff       	call   80104ab0 <release>
80106219:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010621c:	e9 f4 fd ff ff       	jmp    80106015 <trap+0x35>
80106221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106228:	e8 23 e0 ff ff       	call   80104250 <exit>
8010622d:	e9 0e fe ff ff       	jmp    80106040 <trap+0x60>
80106232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106238:	e8 13 e0 ff ff       	call   80104250 <exit>
8010623d:	e9 2e ff ff ff       	jmp    80106170 <trap+0x190>
80106242:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106245:	e8 c6 db ff ff       	call   80103e10 <cpuid>
8010624a:	83 ec 0c             	sub    $0xc,%esp
8010624d:	56                   	push   %esi
8010624e:	57                   	push   %edi
8010624f:	50                   	push   %eax
80106250:	ff 73 30             	push   0x30(%ebx)
80106253:	68 74 80 10 80       	push   $0x80108074
80106258:	e8 43 a4 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010625d:	83 c4 14             	add    $0x14,%esp
80106260:	68 4a 80 10 80       	push   $0x8010804a
80106265:	e8 16 a1 ff ff       	call   80100380 <panic>
8010626a:	66 90                	xchg   %ax,%ax
8010626c:	66 90                	xchg   %ax,%ax
8010626e:	66 90                	xchg   %ax,%ax

80106270 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106270:	a1 a0 ed 12 80       	mov    0x8012eda0,%eax
80106275:	85 c0                	test   %eax,%eax
80106277:	74 17                	je     80106290 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106279:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010627e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010627f:	a8 01                	test   $0x1,%al
80106281:	74 0d                	je     80106290 <uartgetc+0x20>
80106283:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106288:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106289:	0f b6 c0             	movzbl %al,%eax
8010628c:	c3                   	ret    
8010628d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106295:	c3                   	ret    
80106296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010629d:	8d 76 00             	lea    0x0(%esi),%esi

801062a0 <uartinit>:
{
801062a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062a1:	31 c9                	xor    %ecx,%ecx
801062a3:	89 c8                	mov    %ecx,%eax
801062a5:	89 e5                	mov    %esp,%ebp
801062a7:	57                   	push   %edi
801062a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801062ad:	56                   	push   %esi
801062ae:	89 fa                	mov    %edi,%edx
801062b0:	53                   	push   %ebx
801062b1:	83 ec 1c             	sub    $0x1c,%esp
801062b4:	ee                   	out    %al,(%dx)
801062b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801062ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062bf:	89 f2                	mov    %esi,%edx
801062c1:	ee                   	out    %al,(%dx)
801062c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062cc:	ee                   	out    %al,(%dx)
801062cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801062d2:	89 c8                	mov    %ecx,%eax
801062d4:	89 da                	mov    %ebx,%edx
801062d6:	ee                   	out    %al,(%dx)
801062d7:	b8 03 00 00 00       	mov    $0x3,%eax
801062dc:	89 f2                	mov    %esi,%edx
801062de:	ee                   	out    %al,(%dx)
801062df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062e4:	89 c8                	mov    %ecx,%eax
801062e6:	ee                   	out    %al,(%dx)
801062e7:	b8 01 00 00 00       	mov    $0x1,%eax
801062ec:	89 da                	mov    %ebx,%edx
801062ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801062f5:	3c ff                	cmp    $0xff,%al
801062f7:	74 78                	je     80106371 <uartinit+0xd1>
  uart = 1;
801062f9:	c7 05 a0 ed 12 80 01 	movl   $0x1,0x8012eda0
80106300:	00 00 00 
80106303:	89 fa                	mov    %edi,%edx
80106305:	ec                   	in     (%dx),%al
80106306:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010630c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010630f:	bf 6c 81 10 80       	mov    $0x8010816c,%edi
80106314:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106319:	6a 00                	push   $0x0
8010631b:	6a 04                	push   $0x4
8010631d:	e8 1e c6 ff ff       	call   80102940 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106322:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106326:	83 c4 10             	add    $0x10,%esp
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106330:	a1 a0 ed 12 80       	mov    0x8012eda0,%eax
80106335:	bb 80 00 00 00       	mov    $0x80,%ebx
8010633a:	85 c0                	test   %eax,%eax
8010633c:	75 14                	jne    80106352 <uartinit+0xb2>
8010633e:	eb 23                	jmp    80106363 <uartinit+0xc3>
    microdelay(10);
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	6a 0a                	push   $0xa
80106345:	e8 a6 ca ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	83 eb 01             	sub    $0x1,%ebx
80106350:	74 07                	je     80106359 <uartinit+0xb9>
80106352:	89 f2                	mov    %esi,%edx
80106354:	ec                   	in     (%dx),%al
80106355:	a8 20                	test   $0x20,%al
80106357:	74 e7                	je     80106340 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106359:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010635d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106362:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106363:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106367:	83 c7 01             	add    $0x1,%edi
8010636a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010636d:	84 c0                	test   %al,%al
8010636f:	75 bf                	jne    80106330 <uartinit+0x90>
}
80106371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106374:	5b                   	pop    %ebx
80106375:	5e                   	pop    %esi
80106376:	5f                   	pop    %edi
80106377:	5d                   	pop    %ebp
80106378:	c3                   	ret    
80106379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106380 <uartputc>:
  if(!uart)
80106380:	a1 a0 ed 12 80       	mov    0x8012eda0,%eax
80106385:	85 c0                	test   %eax,%eax
80106387:	74 47                	je     801063d0 <uartputc+0x50>
{
80106389:	55                   	push   %ebp
8010638a:	89 e5                	mov    %esp,%ebp
8010638c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010638d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106392:	53                   	push   %ebx
80106393:	bb 80 00 00 00       	mov    $0x80,%ebx
80106398:	eb 18                	jmp    801063b2 <uartputc+0x32>
8010639a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801063a0:	83 ec 0c             	sub    $0xc,%esp
801063a3:	6a 0a                	push   $0xa
801063a5:	e8 46 ca ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063aa:	83 c4 10             	add    $0x10,%esp
801063ad:	83 eb 01             	sub    $0x1,%ebx
801063b0:	74 07                	je     801063b9 <uartputc+0x39>
801063b2:	89 f2                	mov    %esi,%edx
801063b4:	ec                   	in     (%dx),%al
801063b5:	a8 20                	test   $0x20,%al
801063b7:	74 e7                	je     801063a0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063b9:	8b 45 08             	mov    0x8(%ebp),%eax
801063bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063c1:	ee                   	out    %al,(%dx)
}
801063c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063c5:	5b                   	pop    %ebx
801063c6:	5e                   	pop    %esi
801063c7:	5d                   	pop    %ebp
801063c8:	c3                   	ret    
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063d0:	c3                   	ret    
801063d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063df:	90                   	nop

801063e0 <uartintr>:

void
uartintr(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063e6:	68 70 62 10 80       	push   $0x80106270
801063eb:	e8 00 a9 ff ff       	call   80100cf0 <consoleintr>
}
801063f0:	83 c4 10             	add    $0x10,%esp
801063f3:	c9                   	leave  
801063f4:	c3                   	ret    

801063f5 <vector0>:
801063f5:	6a 00                	push   $0x0
801063f7:	6a 00                	push   $0x0
801063f9:	e9 09 fb ff ff       	jmp    80105f07 <alltraps>

801063fe <vector1>:
801063fe:	6a 00                	push   $0x0
80106400:	6a 01                	push   $0x1
80106402:	e9 00 fb ff ff       	jmp    80105f07 <alltraps>

80106407 <vector2>:
80106407:	6a 00                	push   $0x0
80106409:	6a 02                	push   $0x2
8010640b:	e9 f7 fa ff ff       	jmp    80105f07 <alltraps>

80106410 <vector3>:
80106410:	6a 00                	push   $0x0
80106412:	6a 03                	push   $0x3
80106414:	e9 ee fa ff ff       	jmp    80105f07 <alltraps>

80106419 <vector4>:
80106419:	6a 00                	push   $0x0
8010641b:	6a 04                	push   $0x4
8010641d:	e9 e5 fa ff ff       	jmp    80105f07 <alltraps>

80106422 <vector5>:
80106422:	6a 00                	push   $0x0
80106424:	6a 05                	push   $0x5
80106426:	e9 dc fa ff ff       	jmp    80105f07 <alltraps>

8010642b <vector6>:
8010642b:	6a 00                	push   $0x0
8010642d:	6a 06                	push   $0x6
8010642f:	e9 d3 fa ff ff       	jmp    80105f07 <alltraps>

80106434 <vector7>:
80106434:	6a 00                	push   $0x0
80106436:	6a 07                	push   $0x7
80106438:	e9 ca fa ff ff       	jmp    80105f07 <alltraps>

8010643d <vector8>:
8010643d:	6a 08                	push   $0x8
8010643f:	e9 c3 fa ff ff       	jmp    80105f07 <alltraps>

80106444 <vector9>:
80106444:	6a 00                	push   $0x0
80106446:	6a 09                	push   $0x9
80106448:	e9 ba fa ff ff       	jmp    80105f07 <alltraps>

8010644d <vector10>:
8010644d:	6a 0a                	push   $0xa
8010644f:	e9 b3 fa ff ff       	jmp    80105f07 <alltraps>

80106454 <vector11>:
80106454:	6a 0b                	push   $0xb
80106456:	e9 ac fa ff ff       	jmp    80105f07 <alltraps>

8010645b <vector12>:
8010645b:	6a 0c                	push   $0xc
8010645d:	e9 a5 fa ff ff       	jmp    80105f07 <alltraps>

80106462 <vector13>:
80106462:	6a 0d                	push   $0xd
80106464:	e9 9e fa ff ff       	jmp    80105f07 <alltraps>

80106469 <vector14>:
80106469:	6a 0e                	push   $0xe
8010646b:	e9 97 fa ff ff       	jmp    80105f07 <alltraps>

80106470 <vector15>:
80106470:	6a 00                	push   $0x0
80106472:	6a 0f                	push   $0xf
80106474:	e9 8e fa ff ff       	jmp    80105f07 <alltraps>

80106479 <vector16>:
80106479:	6a 00                	push   $0x0
8010647b:	6a 10                	push   $0x10
8010647d:	e9 85 fa ff ff       	jmp    80105f07 <alltraps>

80106482 <vector17>:
80106482:	6a 11                	push   $0x11
80106484:	e9 7e fa ff ff       	jmp    80105f07 <alltraps>

80106489 <vector18>:
80106489:	6a 00                	push   $0x0
8010648b:	6a 12                	push   $0x12
8010648d:	e9 75 fa ff ff       	jmp    80105f07 <alltraps>

80106492 <vector19>:
80106492:	6a 00                	push   $0x0
80106494:	6a 13                	push   $0x13
80106496:	e9 6c fa ff ff       	jmp    80105f07 <alltraps>

8010649b <vector20>:
8010649b:	6a 00                	push   $0x0
8010649d:	6a 14                	push   $0x14
8010649f:	e9 63 fa ff ff       	jmp    80105f07 <alltraps>

801064a4 <vector21>:
801064a4:	6a 00                	push   $0x0
801064a6:	6a 15                	push   $0x15
801064a8:	e9 5a fa ff ff       	jmp    80105f07 <alltraps>

801064ad <vector22>:
801064ad:	6a 00                	push   $0x0
801064af:	6a 16                	push   $0x16
801064b1:	e9 51 fa ff ff       	jmp    80105f07 <alltraps>

801064b6 <vector23>:
801064b6:	6a 00                	push   $0x0
801064b8:	6a 17                	push   $0x17
801064ba:	e9 48 fa ff ff       	jmp    80105f07 <alltraps>

801064bf <vector24>:
801064bf:	6a 00                	push   $0x0
801064c1:	6a 18                	push   $0x18
801064c3:	e9 3f fa ff ff       	jmp    80105f07 <alltraps>

801064c8 <vector25>:
801064c8:	6a 00                	push   $0x0
801064ca:	6a 19                	push   $0x19
801064cc:	e9 36 fa ff ff       	jmp    80105f07 <alltraps>

801064d1 <vector26>:
801064d1:	6a 00                	push   $0x0
801064d3:	6a 1a                	push   $0x1a
801064d5:	e9 2d fa ff ff       	jmp    80105f07 <alltraps>

801064da <vector27>:
801064da:	6a 00                	push   $0x0
801064dc:	6a 1b                	push   $0x1b
801064de:	e9 24 fa ff ff       	jmp    80105f07 <alltraps>

801064e3 <vector28>:
801064e3:	6a 00                	push   $0x0
801064e5:	6a 1c                	push   $0x1c
801064e7:	e9 1b fa ff ff       	jmp    80105f07 <alltraps>

801064ec <vector29>:
801064ec:	6a 00                	push   $0x0
801064ee:	6a 1d                	push   $0x1d
801064f0:	e9 12 fa ff ff       	jmp    80105f07 <alltraps>

801064f5 <vector30>:
801064f5:	6a 00                	push   $0x0
801064f7:	6a 1e                	push   $0x1e
801064f9:	e9 09 fa ff ff       	jmp    80105f07 <alltraps>

801064fe <vector31>:
801064fe:	6a 00                	push   $0x0
80106500:	6a 1f                	push   $0x1f
80106502:	e9 00 fa ff ff       	jmp    80105f07 <alltraps>

80106507 <vector32>:
80106507:	6a 00                	push   $0x0
80106509:	6a 20                	push   $0x20
8010650b:	e9 f7 f9 ff ff       	jmp    80105f07 <alltraps>

80106510 <vector33>:
80106510:	6a 00                	push   $0x0
80106512:	6a 21                	push   $0x21
80106514:	e9 ee f9 ff ff       	jmp    80105f07 <alltraps>

80106519 <vector34>:
80106519:	6a 00                	push   $0x0
8010651b:	6a 22                	push   $0x22
8010651d:	e9 e5 f9 ff ff       	jmp    80105f07 <alltraps>

80106522 <vector35>:
80106522:	6a 00                	push   $0x0
80106524:	6a 23                	push   $0x23
80106526:	e9 dc f9 ff ff       	jmp    80105f07 <alltraps>

8010652b <vector36>:
8010652b:	6a 00                	push   $0x0
8010652d:	6a 24                	push   $0x24
8010652f:	e9 d3 f9 ff ff       	jmp    80105f07 <alltraps>

80106534 <vector37>:
80106534:	6a 00                	push   $0x0
80106536:	6a 25                	push   $0x25
80106538:	e9 ca f9 ff ff       	jmp    80105f07 <alltraps>

8010653d <vector38>:
8010653d:	6a 00                	push   $0x0
8010653f:	6a 26                	push   $0x26
80106541:	e9 c1 f9 ff ff       	jmp    80105f07 <alltraps>

80106546 <vector39>:
80106546:	6a 00                	push   $0x0
80106548:	6a 27                	push   $0x27
8010654a:	e9 b8 f9 ff ff       	jmp    80105f07 <alltraps>

8010654f <vector40>:
8010654f:	6a 00                	push   $0x0
80106551:	6a 28                	push   $0x28
80106553:	e9 af f9 ff ff       	jmp    80105f07 <alltraps>

80106558 <vector41>:
80106558:	6a 00                	push   $0x0
8010655a:	6a 29                	push   $0x29
8010655c:	e9 a6 f9 ff ff       	jmp    80105f07 <alltraps>

80106561 <vector42>:
80106561:	6a 00                	push   $0x0
80106563:	6a 2a                	push   $0x2a
80106565:	e9 9d f9 ff ff       	jmp    80105f07 <alltraps>

8010656a <vector43>:
8010656a:	6a 00                	push   $0x0
8010656c:	6a 2b                	push   $0x2b
8010656e:	e9 94 f9 ff ff       	jmp    80105f07 <alltraps>

80106573 <vector44>:
80106573:	6a 00                	push   $0x0
80106575:	6a 2c                	push   $0x2c
80106577:	e9 8b f9 ff ff       	jmp    80105f07 <alltraps>

8010657c <vector45>:
8010657c:	6a 00                	push   $0x0
8010657e:	6a 2d                	push   $0x2d
80106580:	e9 82 f9 ff ff       	jmp    80105f07 <alltraps>

80106585 <vector46>:
80106585:	6a 00                	push   $0x0
80106587:	6a 2e                	push   $0x2e
80106589:	e9 79 f9 ff ff       	jmp    80105f07 <alltraps>

8010658e <vector47>:
8010658e:	6a 00                	push   $0x0
80106590:	6a 2f                	push   $0x2f
80106592:	e9 70 f9 ff ff       	jmp    80105f07 <alltraps>

80106597 <vector48>:
80106597:	6a 00                	push   $0x0
80106599:	6a 30                	push   $0x30
8010659b:	e9 67 f9 ff ff       	jmp    80105f07 <alltraps>

801065a0 <vector49>:
801065a0:	6a 00                	push   $0x0
801065a2:	6a 31                	push   $0x31
801065a4:	e9 5e f9 ff ff       	jmp    80105f07 <alltraps>

801065a9 <vector50>:
801065a9:	6a 00                	push   $0x0
801065ab:	6a 32                	push   $0x32
801065ad:	e9 55 f9 ff ff       	jmp    80105f07 <alltraps>

801065b2 <vector51>:
801065b2:	6a 00                	push   $0x0
801065b4:	6a 33                	push   $0x33
801065b6:	e9 4c f9 ff ff       	jmp    80105f07 <alltraps>

801065bb <vector52>:
801065bb:	6a 00                	push   $0x0
801065bd:	6a 34                	push   $0x34
801065bf:	e9 43 f9 ff ff       	jmp    80105f07 <alltraps>

801065c4 <vector53>:
801065c4:	6a 00                	push   $0x0
801065c6:	6a 35                	push   $0x35
801065c8:	e9 3a f9 ff ff       	jmp    80105f07 <alltraps>

801065cd <vector54>:
801065cd:	6a 00                	push   $0x0
801065cf:	6a 36                	push   $0x36
801065d1:	e9 31 f9 ff ff       	jmp    80105f07 <alltraps>

801065d6 <vector55>:
801065d6:	6a 00                	push   $0x0
801065d8:	6a 37                	push   $0x37
801065da:	e9 28 f9 ff ff       	jmp    80105f07 <alltraps>

801065df <vector56>:
801065df:	6a 00                	push   $0x0
801065e1:	6a 38                	push   $0x38
801065e3:	e9 1f f9 ff ff       	jmp    80105f07 <alltraps>

801065e8 <vector57>:
801065e8:	6a 00                	push   $0x0
801065ea:	6a 39                	push   $0x39
801065ec:	e9 16 f9 ff ff       	jmp    80105f07 <alltraps>

801065f1 <vector58>:
801065f1:	6a 00                	push   $0x0
801065f3:	6a 3a                	push   $0x3a
801065f5:	e9 0d f9 ff ff       	jmp    80105f07 <alltraps>

801065fa <vector59>:
801065fa:	6a 00                	push   $0x0
801065fc:	6a 3b                	push   $0x3b
801065fe:	e9 04 f9 ff ff       	jmp    80105f07 <alltraps>

80106603 <vector60>:
80106603:	6a 00                	push   $0x0
80106605:	6a 3c                	push   $0x3c
80106607:	e9 fb f8 ff ff       	jmp    80105f07 <alltraps>

8010660c <vector61>:
8010660c:	6a 00                	push   $0x0
8010660e:	6a 3d                	push   $0x3d
80106610:	e9 f2 f8 ff ff       	jmp    80105f07 <alltraps>

80106615 <vector62>:
80106615:	6a 00                	push   $0x0
80106617:	6a 3e                	push   $0x3e
80106619:	e9 e9 f8 ff ff       	jmp    80105f07 <alltraps>

8010661e <vector63>:
8010661e:	6a 00                	push   $0x0
80106620:	6a 3f                	push   $0x3f
80106622:	e9 e0 f8 ff ff       	jmp    80105f07 <alltraps>

80106627 <vector64>:
80106627:	6a 00                	push   $0x0
80106629:	6a 40                	push   $0x40
8010662b:	e9 d7 f8 ff ff       	jmp    80105f07 <alltraps>

80106630 <vector65>:
80106630:	6a 00                	push   $0x0
80106632:	6a 41                	push   $0x41
80106634:	e9 ce f8 ff ff       	jmp    80105f07 <alltraps>

80106639 <vector66>:
80106639:	6a 00                	push   $0x0
8010663b:	6a 42                	push   $0x42
8010663d:	e9 c5 f8 ff ff       	jmp    80105f07 <alltraps>

80106642 <vector67>:
80106642:	6a 00                	push   $0x0
80106644:	6a 43                	push   $0x43
80106646:	e9 bc f8 ff ff       	jmp    80105f07 <alltraps>

8010664b <vector68>:
8010664b:	6a 00                	push   $0x0
8010664d:	6a 44                	push   $0x44
8010664f:	e9 b3 f8 ff ff       	jmp    80105f07 <alltraps>

80106654 <vector69>:
80106654:	6a 00                	push   $0x0
80106656:	6a 45                	push   $0x45
80106658:	e9 aa f8 ff ff       	jmp    80105f07 <alltraps>

8010665d <vector70>:
8010665d:	6a 00                	push   $0x0
8010665f:	6a 46                	push   $0x46
80106661:	e9 a1 f8 ff ff       	jmp    80105f07 <alltraps>

80106666 <vector71>:
80106666:	6a 00                	push   $0x0
80106668:	6a 47                	push   $0x47
8010666a:	e9 98 f8 ff ff       	jmp    80105f07 <alltraps>

8010666f <vector72>:
8010666f:	6a 00                	push   $0x0
80106671:	6a 48                	push   $0x48
80106673:	e9 8f f8 ff ff       	jmp    80105f07 <alltraps>

80106678 <vector73>:
80106678:	6a 00                	push   $0x0
8010667a:	6a 49                	push   $0x49
8010667c:	e9 86 f8 ff ff       	jmp    80105f07 <alltraps>

80106681 <vector74>:
80106681:	6a 00                	push   $0x0
80106683:	6a 4a                	push   $0x4a
80106685:	e9 7d f8 ff ff       	jmp    80105f07 <alltraps>

8010668a <vector75>:
8010668a:	6a 00                	push   $0x0
8010668c:	6a 4b                	push   $0x4b
8010668e:	e9 74 f8 ff ff       	jmp    80105f07 <alltraps>

80106693 <vector76>:
80106693:	6a 00                	push   $0x0
80106695:	6a 4c                	push   $0x4c
80106697:	e9 6b f8 ff ff       	jmp    80105f07 <alltraps>

8010669c <vector77>:
8010669c:	6a 00                	push   $0x0
8010669e:	6a 4d                	push   $0x4d
801066a0:	e9 62 f8 ff ff       	jmp    80105f07 <alltraps>

801066a5 <vector78>:
801066a5:	6a 00                	push   $0x0
801066a7:	6a 4e                	push   $0x4e
801066a9:	e9 59 f8 ff ff       	jmp    80105f07 <alltraps>

801066ae <vector79>:
801066ae:	6a 00                	push   $0x0
801066b0:	6a 4f                	push   $0x4f
801066b2:	e9 50 f8 ff ff       	jmp    80105f07 <alltraps>

801066b7 <vector80>:
801066b7:	6a 00                	push   $0x0
801066b9:	6a 50                	push   $0x50
801066bb:	e9 47 f8 ff ff       	jmp    80105f07 <alltraps>

801066c0 <vector81>:
801066c0:	6a 00                	push   $0x0
801066c2:	6a 51                	push   $0x51
801066c4:	e9 3e f8 ff ff       	jmp    80105f07 <alltraps>

801066c9 <vector82>:
801066c9:	6a 00                	push   $0x0
801066cb:	6a 52                	push   $0x52
801066cd:	e9 35 f8 ff ff       	jmp    80105f07 <alltraps>

801066d2 <vector83>:
801066d2:	6a 00                	push   $0x0
801066d4:	6a 53                	push   $0x53
801066d6:	e9 2c f8 ff ff       	jmp    80105f07 <alltraps>

801066db <vector84>:
801066db:	6a 00                	push   $0x0
801066dd:	6a 54                	push   $0x54
801066df:	e9 23 f8 ff ff       	jmp    80105f07 <alltraps>

801066e4 <vector85>:
801066e4:	6a 00                	push   $0x0
801066e6:	6a 55                	push   $0x55
801066e8:	e9 1a f8 ff ff       	jmp    80105f07 <alltraps>

801066ed <vector86>:
801066ed:	6a 00                	push   $0x0
801066ef:	6a 56                	push   $0x56
801066f1:	e9 11 f8 ff ff       	jmp    80105f07 <alltraps>

801066f6 <vector87>:
801066f6:	6a 00                	push   $0x0
801066f8:	6a 57                	push   $0x57
801066fa:	e9 08 f8 ff ff       	jmp    80105f07 <alltraps>

801066ff <vector88>:
801066ff:	6a 00                	push   $0x0
80106701:	6a 58                	push   $0x58
80106703:	e9 ff f7 ff ff       	jmp    80105f07 <alltraps>

80106708 <vector89>:
80106708:	6a 00                	push   $0x0
8010670a:	6a 59                	push   $0x59
8010670c:	e9 f6 f7 ff ff       	jmp    80105f07 <alltraps>

80106711 <vector90>:
80106711:	6a 00                	push   $0x0
80106713:	6a 5a                	push   $0x5a
80106715:	e9 ed f7 ff ff       	jmp    80105f07 <alltraps>

8010671a <vector91>:
8010671a:	6a 00                	push   $0x0
8010671c:	6a 5b                	push   $0x5b
8010671e:	e9 e4 f7 ff ff       	jmp    80105f07 <alltraps>

80106723 <vector92>:
80106723:	6a 00                	push   $0x0
80106725:	6a 5c                	push   $0x5c
80106727:	e9 db f7 ff ff       	jmp    80105f07 <alltraps>

8010672c <vector93>:
8010672c:	6a 00                	push   $0x0
8010672e:	6a 5d                	push   $0x5d
80106730:	e9 d2 f7 ff ff       	jmp    80105f07 <alltraps>

80106735 <vector94>:
80106735:	6a 00                	push   $0x0
80106737:	6a 5e                	push   $0x5e
80106739:	e9 c9 f7 ff ff       	jmp    80105f07 <alltraps>

8010673e <vector95>:
8010673e:	6a 00                	push   $0x0
80106740:	6a 5f                	push   $0x5f
80106742:	e9 c0 f7 ff ff       	jmp    80105f07 <alltraps>

80106747 <vector96>:
80106747:	6a 00                	push   $0x0
80106749:	6a 60                	push   $0x60
8010674b:	e9 b7 f7 ff ff       	jmp    80105f07 <alltraps>

80106750 <vector97>:
80106750:	6a 00                	push   $0x0
80106752:	6a 61                	push   $0x61
80106754:	e9 ae f7 ff ff       	jmp    80105f07 <alltraps>

80106759 <vector98>:
80106759:	6a 00                	push   $0x0
8010675b:	6a 62                	push   $0x62
8010675d:	e9 a5 f7 ff ff       	jmp    80105f07 <alltraps>

80106762 <vector99>:
80106762:	6a 00                	push   $0x0
80106764:	6a 63                	push   $0x63
80106766:	e9 9c f7 ff ff       	jmp    80105f07 <alltraps>

8010676b <vector100>:
8010676b:	6a 00                	push   $0x0
8010676d:	6a 64                	push   $0x64
8010676f:	e9 93 f7 ff ff       	jmp    80105f07 <alltraps>

80106774 <vector101>:
80106774:	6a 00                	push   $0x0
80106776:	6a 65                	push   $0x65
80106778:	e9 8a f7 ff ff       	jmp    80105f07 <alltraps>

8010677d <vector102>:
8010677d:	6a 00                	push   $0x0
8010677f:	6a 66                	push   $0x66
80106781:	e9 81 f7 ff ff       	jmp    80105f07 <alltraps>

80106786 <vector103>:
80106786:	6a 00                	push   $0x0
80106788:	6a 67                	push   $0x67
8010678a:	e9 78 f7 ff ff       	jmp    80105f07 <alltraps>

8010678f <vector104>:
8010678f:	6a 00                	push   $0x0
80106791:	6a 68                	push   $0x68
80106793:	e9 6f f7 ff ff       	jmp    80105f07 <alltraps>

80106798 <vector105>:
80106798:	6a 00                	push   $0x0
8010679a:	6a 69                	push   $0x69
8010679c:	e9 66 f7 ff ff       	jmp    80105f07 <alltraps>

801067a1 <vector106>:
801067a1:	6a 00                	push   $0x0
801067a3:	6a 6a                	push   $0x6a
801067a5:	e9 5d f7 ff ff       	jmp    80105f07 <alltraps>

801067aa <vector107>:
801067aa:	6a 00                	push   $0x0
801067ac:	6a 6b                	push   $0x6b
801067ae:	e9 54 f7 ff ff       	jmp    80105f07 <alltraps>

801067b3 <vector108>:
801067b3:	6a 00                	push   $0x0
801067b5:	6a 6c                	push   $0x6c
801067b7:	e9 4b f7 ff ff       	jmp    80105f07 <alltraps>

801067bc <vector109>:
801067bc:	6a 00                	push   $0x0
801067be:	6a 6d                	push   $0x6d
801067c0:	e9 42 f7 ff ff       	jmp    80105f07 <alltraps>

801067c5 <vector110>:
801067c5:	6a 00                	push   $0x0
801067c7:	6a 6e                	push   $0x6e
801067c9:	e9 39 f7 ff ff       	jmp    80105f07 <alltraps>

801067ce <vector111>:
801067ce:	6a 00                	push   $0x0
801067d0:	6a 6f                	push   $0x6f
801067d2:	e9 30 f7 ff ff       	jmp    80105f07 <alltraps>

801067d7 <vector112>:
801067d7:	6a 00                	push   $0x0
801067d9:	6a 70                	push   $0x70
801067db:	e9 27 f7 ff ff       	jmp    80105f07 <alltraps>

801067e0 <vector113>:
801067e0:	6a 00                	push   $0x0
801067e2:	6a 71                	push   $0x71
801067e4:	e9 1e f7 ff ff       	jmp    80105f07 <alltraps>

801067e9 <vector114>:
801067e9:	6a 00                	push   $0x0
801067eb:	6a 72                	push   $0x72
801067ed:	e9 15 f7 ff ff       	jmp    80105f07 <alltraps>

801067f2 <vector115>:
801067f2:	6a 00                	push   $0x0
801067f4:	6a 73                	push   $0x73
801067f6:	e9 0c f7 ff ff       	jmp    80105f07 <alltraps>

801067fb <vector116>:
801067fb:	6a 00                	push   $0x0
801067fd:	6a 74                	push   $0x74
801067ff:	e9 03 f7 ff ff       	jmp    80105f07 <alltraps>

80106804 <vector117>:
80106804:	6a 00                	push   $0x0
80106806:	6a 75                	push   $0x75
80106808:	e9 fa f6 ff ff       	jmp    80105f07 <alltraps>

8010680d <vector118>:
8010680d:	6a 00                	push   $0x0
8010680f:	6a 76                	push   $0x76
80106811:	e9 f1 f6 ff ff       	jmp    80105f07 <alltraps>

80106816 <vector119>:
80106816:	6a 00                	push   $0x0
80106818:	6a 77                	push   $0x77
8010681a:	e9 e8 f6 ff ff       	jmp    80105f07 <alltraps>

8010681f <vector120>:
8010681f:	6a 00                	push   $0x0
80106821:	6a 78                	push   $0x78
80106823:	e9 df f6 ff ff       	jmp    80105f07 <alltraps>

80106828 <vector121>:
80106828:	6a 00                	push   $0x0
8010682a:	6a 79                	push   $0x79
8010682c:	e9 d6 f6 ff ff       	jmp    80105f07 <alltraps>

80106831 <vector122>:
80106831:	6a 00                	push   $0x0
80106833:	6a 7a                	push   $0x7a
80106835:	e9 cd f6 ff ff       	jmp    80105f07 <alltraps>

8010683a <vector123>:
8010683a:	6a 00                	push   $0x0
8010683c:	6a 7b                	push   $0x7b
8010683e:	e9 c4 f6 ff ff       	jmp    80105f07 <alltraps>

80106843 <vector124>:
80106843:	6a 00                	push   $0x0
80106845:	6a 7c                	push   $0x7c
80106847:	e9 bb f6 ff ff       	jmp    80105f07 <alltraps>

8010684c <vector125>:
8010684c:	6a 00                	push   $0x0
8010684e:	6a 7d                	push   $0x7d
80106850:	e9 b2 f6 ff ff       	jmp    80105f07 <alltraps>

80106855 <vector126>:
80106855:	6a 00                	push   $0x0
80106857:	6a 7e                	push   $0x7e
80106859:	e9 a9 f6 ff ff       	jmp    80105f07 <alltraps>

8010685e <vector127>:
8010685e:	6a 00                	push   $0x0
80106860:	6a 7f                	push   $0x7f
80106862:	e9 a0 f6 ff ff       	jmp    80105f07 <alltraps>

80106867 <vector128>:
80106867:	6a 00                	push   $0x0
80106869:	68 80 00 00 00       	push   $0x80
8010686e:	e9 94 f6 ff ff       	jmp    80105f07 <alltraps>

80106873 <vector129>:
80106873:	6a 00                	push   $0x0
80106875:	68 81 00 00 00       	push   $0x81
8010687a:	e9 88 f6 ff ff       	jmp    80105f07 <alltraps>

8010687f <vector130>:
8010687f:	6a 00                	push   $0x0
80106881:	68 82 00 00 00       	push   $0x82
80106886:	e9 7c f6 ff ff       	jmp    80105f07 <alltraps>

8010688b <vector131>:
8010688b:	6a 00                	push   $0x0
8010688d:	68 83 00 00 00       	push   $0x83
80106892:	e9 70 f6 ff ff       	jmp    80105f07 <alltraps>

80106897 <vector132>:
80106897:	6a 00                	push   $0x0
80106899:	68 84 00 00 00       	push   $0x84
8010689e:	e9 64 f6 ff ff       	jmp    80105f07 <alltraps>

801068a3 <vector133>:
801068a3:	6a 00                	push   $0x0
801068a5:	68 85 00 00 00       	push   $0x85
801068aa:	e9 58 f6 ff ff       	jmp    80105f07 <alltraps>

801068af <vector134>:
801068af:	6a 00                	push   $0x0
801068b1:	68 86 00 00 00       	push   $0x86
801068b6:	e9 4c f6 ff ff       	jmp    80105f07 <alltraps>

801068bb <vector135>:
801068bb:	6a 00                	push   $0x0
801068bd:	68 87 00 00 00       	push   $0x87
801068c2:	e9 40 f6 ff ff       	jmp    80105f07 <alltraps>

801068c7 <vector136>:
801068c7:	6a 00                	push   $0x0
801068c9:	68 88 00 00 00       	push   $0x88
801068ce:	e9 34 f6 ff ff       	jmp    80105f07 <alltraps>

801068d3 <vector137>:
801068d3:	6a 00                	push   $0x0
801068d5:	68 89 00 00 00       	push   $0x89
801068da:	e9 28 f6 ff ff       	jmp    80105f07 <alltraps>

801068df <vector138>:
801068df:	6a 00                	push   $0x0
801068e1:	68 8a 00 00 00       	push   $0x8a
801068e6:	e9 1c f6 ff ff       	jmp    80105f07 <alltraps>

801068eb <vector139>:
801068eb:	6a 00                	push   $0x0
801068ed:	68 8b 00 00 00       	push   $0x8b
801068f2:	e9 10 f6 ff ff       	jmp    80105f07 <alltraps>

801068f7 <vector140>:
801068f7:	6a 00                	push   $0x0
801068f9:	68 8c 00 00 00       	push   $0x8c
801068fe:	e9 04 f6 ff ff       	jmp    80105f07 <alltraps>

80106903 <vector141>:
80106903:	6a 00                	push   $0x0
80106905:	68 8d 00 00 00       	push   $0x8d
8010690a:	e9 f8 f5 ff ff       	jmp    80105f07 <alltraps>

8010690f <vector142>:
8010690f:	6a 00                	push   $0x0
80106911:	68 8e 00 00 00       	push   $0x8e
80106916:	e9 ec f5 ff ff       	jmp    80105f07 <alltraps>

8010691b <vector143>:
8010691b:	6a 00                	push   $0x0
8010691d:	68 8f 00 00 00       	push   $0x8f
80106922:	e9 e0 f5 ff ff       	jmp    80105f07 <alltraps>

80106927 <vector144>:
80106927:	6a 00                	push   $0x0
80106929:	68 90 00 00 00       	push   $0x90
8010692e:	e9 d4 f5 ff ff       	jmp    80105f07 <alltraps>

80106933 <vector145>:
80106933:	6a 00                	push   $0x0
80106935:	68 91 00 00 00       	push   $0x91
8010693a:	e9 c8 f5 ff ff       	jmp    80105f07 <alltraps>

8010693f <vector146>:
8010693f:	6a 00                	push   $0x0
80106941:	68 92 00 00 00       	push   $0x92
80106946:	e9 bc f5 ff ff       	jmp    80105f07 <alltraps>

8010694b <vector147>:
8010694b:	6a 00                	push   $0x0
8010694d:	68 93 00 00 00       	push   $0x93
80106952:	e9 b0 f5 ff ff       	jmp    80105f07 <alltraps>

80106957 <vector148>:
80106957:	6a 00                	push   $0x0
80106959:	68 94 00 00 00       	push   $0x94
8010695e:	e9 a4 f5 ff ff       	jmp    80105f07 <alltraps>

80106963 <vector149>:
80106963:	6a 00                	push   $0x0
80106965:	68 95 00 00 00       	push   $0x95
8010696a:	e9 98 f5 ff ff       	jmp    80105f07 <alltraps>

8010696f <vector150>:
8010696f:	6a 00                	push   $0x0
80106971:	68 96 00 00 00       	push   $0x96
80106976:	e9 8c f5 ff ff       	jmp    80105f07 <alltraps>

8010697b <vector151>:
8010697b:	6a 00                	push   $0x0
8010697d:	68 97 00 00 00       	push   $0x97
80106982:	e9 80 f5 ff ff       	jmp    80105f07 <alltraps>

80106987 <vector152>:
80106987:	6a 00                	push   $0x0
80106989:	68 98 00 00 00       	push   $0x98
8010698e:	e9 74 f5 ff ff       	jmp    80105f07 <alltraps>

80106993 <vector153>:
80106993:	6a 00                	push   $0x0
80106995:	68 99 00 00 00       	push   $0x99
8010699a:	e9 68 f5 ff ff       	jmp    80105f07 <alltraps>

8010699f <vector154>:
8010699f:	6a 00                	push   $0x0
801069a1:	68 9a 00 00 00       	push   $0x9a
801069a6:	e9 5c f5 ff ff       	jmp    80105f07 <alltraps>

801069ab <vector155>:
801069ab:	6a 00                	push   $0x0
801069ad:	68 9b 00 00 00       	push   $0x9b
801069b2:	e9 50 f5 ff ff       	jmp    80105f07 <alltraps>

801069b7 <vector156>:
801069b7:	6a 00                	push   $0x0
801069b9:	68 9c 00 00 00       	push   $0x9c
801069be:	e9 44 f5 ff ff       	jmp    80105f07 <alltraps>

801069c3 <vector157>:
801069c3:	6a 00                	push   $0x0
801069c5:	68 9d 00 00 00       	push   $0x9d
801069ca:	e9 38 f5 ff ff       	jmp    80105f07 <alltraps>

801069cf <vector158>:
801069cf:	6a 00                	push   $0x0
801069d1:	68 9e 00 00 00       	push   $0x9e
801069d6:	e9 2c f5 ff ff       	jmp    80105f07 <alltraps>

801069db <vector159>:
801069db:	6a 00                	push   $0x0
801069dd:	68 9f 00 00 00       	push   $0x9f
801069e2:	e9 20 f5 ff ff       	jmp    80105f07 <alltraps>

801069e7 <vector160>:
801069e7:	6a 00                	push   $0x0
801069e9:	68 a0 00 00 00       	push   $0xa0
801069ee:	e9 14 f5 ff ff       	jmp    80105f07 <alltraps>

801069f3 <vector161>:
801069f3:	6a 00                	push   $0x0
801069f5:	68 a1 00 00 00       	push   $0xa1
801069fa:	e9 08 f5 ff ff       	jmp    80105f07 <alltraps>

801069ff <vector162>:
801069ff:	6a 00                	push   $0x0
80106a01:	68 a2 00 00 00       	push   $0xa2
80106a06:	e9 fc f4 ff ff       	jmp    80105f07 <alltraps>

80106a0b <vector163>:
80106a0b:	6a 00                	push   $0x0
80106a0d:	68 a3 00 00 00       	push   $0xa3
80106a12:	e9 f0 f4 ff ff       	jmp    80105f07 <alltraps>

80106a17 <vector164>:
80106a17:	6a 00                	push   $0x0
80106a19:	68 a4 00 00 00       	push   $0xa4
80106a1e:	e9 e4 f4 ff ff       	jmp    80105f07 <alltraps>

80106a23 <vector165>:
80106a23:	6a 00                	push   $0x0
80106a25:	68 a5 00 00 00       	push   $0xa5
80106a2a:	e9 d8 f4 ff ff       	jmp    80105f07 <alltraps>

80106a2f <vector166>:
80106a2f:	6a 00                	push   $0x0
80106a31:	68 a6 00 00 00       	push   $0xa6
80106a36:	e9 cc f4 ff ff       	jmp    80105f07 <alltraps>

80106a3b <vector167>:
80106a3b:	6a 00                	push   $0x0
80106a3d:	68 a7 00 00 00       	push   $0xa7
80106a42:	e9 c0 f4 ff ff       	jmp    80105f07 <alltraps>

80106a47 <vector168>:
80106a47:	6a 00                	push   $0x0
80106a49:	68 a8 00 00 00       	push   $0xa8
80106a4e:	e9 b4 f4 ff ff       	jmp    80105f07 <alltraps>

80106a53 <vector169>:
80106a53:	6a 00                	push   $0x0
80106a55:	68 a9 00 00 00       	push   $0xa9
80106a5a:	e9 a8 f4 ff ff       	jmp    80105f07 <alltraps>

80106a5f <vector170>:
80106a5f:	6a 00                	push   $0x0
80106a61:	68 aa 00 00 00       	push   $0xaa
80106a66:	e9 9c f4 ff ff       	jmp    80105f07 <alltraps>

80106a6b <vector171>:
80106a6b:	6a 00                	push   $0x0
80106a6d:	68 ab 00 00 00       	push   $0xab
80106a72:	e9 90 f4 ff ff       	jmp    80105f07 <alltraps>

80106a77 <vector172>:
80106a77:	6a 00                	push   $0x0
80106a79:	68 ac 00 00 00       	push   $0xac
80106a7e:	e9 84 f4 ff ff       	jmp    80105f07 <alltraps>

80106a83 <vector173>:
80106a83:	6a 00                	push   $0x0
80106a85:	68 ad 00 00 00       	push   $0xad
80106a8a:	e9 78 f4 ff ff       	jmp    80105f07 <alltraps>

80106a8f <vector174>:
80106a8f:	6a 00                	push   $0x0
80106a91:	68 ae 00 00 00       	push   $0xae
80106a96:	e9 6c f4 ff ff       	jmp    80105f07 <alltraps>

80106a9b <vector175>:
80106a9b:	6a 00                	push   $0x0
80106a9d:	68 af 00 00 00       	push   $0xaf
80106aa2:	e9 60 f4 ff ff       	jmp    80105f07 <alltraps>

80106aa7 <vector176>:
80106aa7:	6a 00                	push   $0x0
80106aa9:	68 b0 00 00 00       	push   $0xb0
80106aae:	e9 54 f4 ff ff       	jmp    80105f07 <alltraps>

80106ab3 <vector177>:
80106ab3:	6a 00                	push   $0x0
80106ab5:	68 b1 00 00 00       	push   $0xb1
80106aba:	e9 48 f4 ff ff       	jmp    80105f07 <alltraps>

80106abf <vector178>:
80106abf:	6a 00                	push   $0x0
80106ac1:	68 b2 00 00 00       	push   $0xb2
80106ac6:	e9 3c f4 ff ff       	jmp    80105f07 <alltraps>

80106acb <vector179>:
80106acb:	6a 00                	push   $0x0
80106acd:	68 b3 00 00 00       	push   $0xb3
80106ad2:	e9 30 f4 ff ff       	jmp    80105f07 <alltraps>

80106ad7 <vector180>:
80106ad7:	6a 00                	push   $0x0
80106ad9:	68 b4 00 00 00       	push   $0xb4
80106ade:	e9 24 f4 ff ff       	jmp    80105f07 <alltraps>

80106ae3 <vector181>:
80106ae3:	6a 00                	push   $0x0
80106ae5:	68 b5 00 00 00       	push   $0xb5
80106aea:	e9 18 f4 ff ff       	jmp    80105f07 <alltraps>

80106aef <vector182>:
80106aef:	6a 00                	push   $0x0
80106af1:	68 b6 00 00 00       	push   $0xb6
80106af6:	e9 0c f4 ff ff       	jmp    80105f07 <alltraps>

80106afb <vector183>:
80106afb:	6a 00                	push   $0x0
80106afd:	68 b7 00 00 00       	push   $0xb7
80106b02:	e9 00 f4 ff ff       	jmp    80105f07 <alltraps>

80106b07 <vector184>:
80106b07:	6a 00                	push   $0x0
80106b09:	68 b8 00 00 00       	push   $0xb8
80106b0e:	e9 f4 f3 ff ff       	jmp    80105f07 <alltraps>

80106b13 <vector185>:
80106b13:	6a 00                	push   $0x0
80106b15:	68 b9 00 00 00       	push   $0xb9
80106b1a:	e9 e8 f3 ff ff       	jmp    80105f07 <alltraps>

80106b1f <vector186>:
80106b1f:	6a 00                	push   $0x0
80106b21:	68 ba 00 00 00       	push   $0xba
80106b26:	e9 dc f3 ff ff       	jmp    80105f07 <alltraps>

80106b2b <vector187>:
80106b2b:	6a 00                	push   $0x0
80106b2d:	68 bb 00 00 00       	push   $0xbb
80106b32:	e9 d0 f3 ff ff       	jmp    80105f07 <alltraps>

80106b37 <vector188>:
80106b37:	6a 00                	push   $0x0
80106b39:	68 bc 00 00 00       	push   $0xbc
80106b3e:	e9 c4 f3 ff ff       	jmp    80105f07 <alltraps>

80106b43 <vector189>:
80106b43:	6a 00                	push   $0x0
80106b45:	68 bd 00 00 00       	push   $0xbd
80106b4a:	e9 b8 f3 ff ff       	jmp    80105f07 <alltraps>

80106b4f <vector190>:
80106b4f:	6a 00                	push   $0x0
80106b51:	68 be 00 00 00       	push   $0xbe
80106b56:	e9 ac f3 ff ff       	jmp    80105f07 <alltraps>

80106b5b <vector191>:
80106b5b:	6a 00                	push   $0x0
80106b5d:	68 bf 00 00 00       	push   $0xbf
80106b62:	e9 a0 f3 ff ff       	jmp    80105f07 <alltraps>

80106b67 <vector192>:
80106b67:	6a 00                	push   $0x0
80106b69:	68 c0 00 00 00       	push   $0xc0
80106b6e:	e9 94 f3 ff ff       	jmp    80105f07 <alltraps>

80106b73 <vector193>:
80106b73:	6a 00                	push   $0x0
80106b75:	68 c1 00 00 00       	push   $0xc1
80106b7a:	e9 88 f3 ff ff       	jmp    80105f07 <alltraps>

80106b7f <vector194>:
80106b7f:	6a 00                	push   $0x0
80106b81:	68 c2 00 00 00       	push   $0xc2
80106b86:	e9 7c f3 ff ff       	jmp    80105f07 <alltraps>

80106b8b <vector195>:
80106b8b:	6a 00                	push   $0x0
80106b8d:	68 c3 00 00 00       	push   $0xc3
80106b92:	e9 70 f3 ff ff       	jmp    80105f07 <alltraps>

80106b97 <vector196>:
80106b97:	6a 00                	push   $0x0
80106b99:	68 c4 00 00 00       	push   $0xc4
80106b9e:	e9 64 f3 ff ff       	jmp    80105f07 <alltraps>

80106ba3 <vector197>:
80106ba3:	6a 00                	push   $0x0
80106ba5:	68 c5 00 00 00       	push   $0xc5
80106baa:	e9 58 f3 ff ff       	jmp    80105f07 <alltraps>

80106baf <vector198>:
80106baf:	6a 00                	push   $0x0
80106bb1:	68 c6 00 00 00       	push   $0xc6
80106bb6:	e9 4c f3 ff ff       	jmp    80105f07 <alltraps>

80106bbb <vector199>:
80106bbb:	6a 00                	push   $0x0
80106bbd:	68 c7 00 00 00       	push   $0xc7
80106bc2:	e9 40 f3 ff ff       	jmp    80105f07 <alltraps>

80106bc7 <vector200>:
80106bc7:	6a 00                	push   $0x0
80106bc9:	68 c8 00 00 00       	push   $0xc8
80106bce:	e9 34 f3 ff ff       	jmp    80105f07 <alltraps>

80106bd3 <vector201>:
80106bd3:	6a 00                	push   $0x0
80106bd5:	68 c9 00 00 00       	push   $0xc9
80106bda:	e9 28 f3 ff ff       	jmp    80105f07 <alltraps>

80106bdf <vector202>:
80106bdf:	6a 00                	push   $0x0
80106be1:	68 ca 00 00 00       	push   $0xca
80106be6:	e9 1c f3 ff ff       	jmp    80105f07 <alltraps>

80106beb <vector203>:
80106beb:	6a 00                	push   $0x0
80106bed:	68 cb 00 00 00       	push   $0xcb
80106bf2:	e9 10 f3 ff ff       	jmp    80105f07 <alltraps>

80106bf7 <vector204>:
80106bf7:	6a 00                	push   $0x0
80106bf9:	68 cc 00 00 00       	push   $0xcc
80106bfe:	e9 04 f3 ff ff       	jmp    80105f07 <alltraps>

80106c03 <vector205>:
80106c03:	6a 00                	push   $0x0
80106c05:	68 cd 00 00 00       	push   $0xcd
80106c0a:	e9 f8 f2 ff ff       	jmp    80105f07 <alltraps>

80106c0f <vector206>:
80106c0f:	6a 00                	push   $0x0
80106c11:	68 ce 00 00 00       	push   $0xce
80106c16:	e9 ec f2 ff ff       	jmp    80105f07 <alltraps>

80106c1b <vector207>:
80106c1b:	6a 00                	push   $0x0
80106c1d:	68 cf 00 00 00       	push   $0xcf
80106c22:	e9 e0 f2 ff ff       	jmp    80105f07 <alltraps>

80106c27 <vector208>:
80106c27:	6a 00                	push   $0x0
80106c29:	68 d0 00 00 00       	push   $0xd0
80106c2e:	e9 d4 f2 ff ff       	jmp    80105f07 <alltraps>

80106c33 <vector209>:
80106c33:	6a 00                	push   $0x0
80106c35:	68 d1 00 00 00       	push   $0xd1
80106c3a:	e9 c8 f2 ff ff       	jmp    80105f07 <alltraps>

80106c3f <vector210>:
80106c3f:	6a 00                	push   $0x0
80106c41:	68 d2 00 00 00       	push   $0xd2
80106c46:	e9 bc f2 ff ff       	jmp    80105f07 <alltraps>

80106c4b <vector211>:
80106c4b:	6a 00                	push   $0x0
80106c4d:	68 d3 00 00 00       	push   $0xd3
80106c52:	e9 b0 f2 ff ff       	jmp    80105f07 <alltraps>

80106c57 <vector212>:
80106c57:	6a 00                	push   $0x0
80106c59:	68 d4 00 00 00       	push   $0xd4
80106c5e:	e9 a4 f2 ff ff       	jmp    80105f07 <alltraps>

80106c63 <vector213>:
80106c63:	6a 00                	push   $0x0
80106c65:	68 d5 00 00 00       	push   $0xd5
80106c6a:	e9 98 f2 ff ff       	jmp    80105f07 <alltraps>

80106c6f <vector214>:
80106c6f:	6a 00                	push   $0x0
80106c71:	68 d6 00 00 00       	push   $0xd6
80106c76:	e9 8c f2 ff ff       	jmp    80105f07 <alltraps>

80106c7b <vector215>:
80106c7b:	6a 00                	push   $0x0
80106c7d:	68 d7 00 00 00       	push   $0xd7
80106c82:	e9 80 f2 ff ff       	jmp    80105f07 <alltraps>

80106c87 <vector216>:
80106c87:	6a 00                	push   $0x0
80106c89:	68 d8 00 00 00       	push   $0xd8
80106c8e:	e9 74 f2 ff ff       	jmp    80105f07 <alltraps>

80106c93 <vector217>:
80106c93:	6a 00                	push   $0x0
80106c95:	68 d9 00 00 00       	push   $0xd9
80106c9a:	e9 68 f2 ff ff       	jmp    80105f07 <alltraps>

80106c9f <vector218>:
80106c9f:	6a 00                	push   $0x0
80106ca1:	68 da 00 00 00       	push   $0xda
80106ca6:	e9 5c f2 ff ff       	jmp    80105f07 <alltraps>

80106cab <vector219>:
80106cab:	6a 00                	push   $0x0
80106cad:	68 db 00 00 00       	push   $0xdb
80106cb2:	e9 50 f2 ff ff       	jmp    80105f07 <alltraps>

80106cb7 <vector220>:
80106cb7:	6a 00                	push   $0x0
80106cb9:	68 dc 00 00 00       	push   $0xdc
80106cbe:	e9 44 f2 ff ff       	jmp    80105f07 <alltraps>

80106cc3 <vector221>:
80106cc3:	6a 00                	push   $0x0
80106cc5:	68 dd 00 00 00       	push   $0xdd
80106cca:	e9 38 f2 ff ff       	jmp    80105f07 <alltraps>

80106ccf <vector222>:
80106ccf:	6a 00                	push   $0x0
80106cd1:	68 de 00 00 00       	push   $0xde
80106cd6:	e9 2c f2 ff ff       	jmp    80105f07 <alltraps>

80106cdb <vector223>:
80106cdb:	6a 00                	push   $0x0
80106cdd:	68 df 00 00 00       	push   $0xdf
80106ce2:	e9 20 f2 ff ff       	jmp    80105f07 <alltraps>

80106ce7 <vector224>:
80106ce7:	6a 00                	push   $0x0
80106ce9:	68 e0 00 00 00       	push   $0xe0
80106cee:	e9 14 f2 ff ff       	jmp    80105f07 <alltraps>

80106cf3 <vector225>:
80106cf3:	6a 00                	push   $0x0
80106cf5:	68 e1 00 00 00       	push   $0xe1
80106cfa:	e9 08 f2 ff ff       	jmp    80105f07 <alltraps>

80106cff <vector226>:
80106cff:	6a 00                	push   $0x0
80106d01:	68 e2 00 00 00       	push   $0xe2
80106d06:	e9 fc f1 ff ff       	jmp    80105f07 <alltraps>

80106d0b <vector227>:
80106d0b:	6a 00                	push   $0x0
80106d0d:	68 e3 00 00 00       	push   $0xe3
80106d12:	e9 f0 f1 ff ff       	jmp    80105f07 <alltraps>

80106d17 <vector228>:
80106d17:	6a 00                	push   $0x0
80106d19:	68 e4 00 00 00       	push   $0xe4
80106d1e:	e9 e4 f1 ff ff       	jmp    80105f07 <alltraps>

80106d23 <vector229>:
80106d23:	6a 00                	push   $0x0
80106d25:	68 e5 00 00 00       	push   $0xe5
80106d2a:	e9 d8 f1 ff ff       	jmp    80105f07 <alltraps>

80106d2f <vector230>:
80106d2f:	6a 00                	push   $0x0
80106d31:	68 e6 00 00 00       	push   $0xe6
80106d36:	e9 cc f1 ff ff       	jmp    80105f07 <alltraps>

80106d3b <vector231>:
80106d3b:	6a 00                	push   $0x0
80106d3d:	68 e7 00 00 00       	push   $0xe7
80106d42:	e9 c0 f1 ff ff       	jmp    80105f07 <alltraps>

80106d47 <vector232>:
80106d47:	6a 00                	push   $0x0
80106d49:	68 e8 00 00 00       	push   $0xe8
80106d4e:	e9 b4 f1 ff ff       	jmp    80105f07 <alltraps>

80106d53 <vector233>:
80106d53:	6a 00                	push   $0x0
80106d55:	68 e9 00 00 00       	push   $0xe9
80106d5a:	e9 a8 f1 ff ff       	jmp    80105f07 <alltraps>

80106d5f <vector234>:
80106d5f:	6a 00                	push   $0x0
80106d61:	68 ea 00 00 00       	push   $0xea
80106d66:	e9 9c f1 ff ff       	jmp    80105f07 <alltraps>

80106d6b <vector235>:
80106d6b:	6a 00                	push   $0x0
80106d6d:	68 eb 00 00 00       	push   $0xeb
80106d72:	e9 90 f1 ff ff       	jmp    80105f07 <alltraps>

80106d77 <vector236>:
80106d77:	6a 00                	push   $0x0
80106d79:	68 ec 00 00 00       	push   $0xec
80106d7e:	e9 84 f1 ff ff       	jmp    80105f07 <alltraps>

80106d83 <vector237>:
80106d83:	6a 00                	push   $0x0
80106d85:	68 ed 00 00 00       	push   $0xed
80106d8a:	e9 78 f1 ff ff       	jmp    80105f07 <alltraps>

80106d8f <vector238>:
80106d8f:	6a 00                	push   $0x0
80106d91:	68 ee 00 00 00       	push   $0xee
80106d96:	e9 6c f1 ff ff       	jmp    80105f07 <alltraps>

80106d9b <vector239>:
80106d9b:	6a 00                	push   $0x0
80106d9d:	68 ef 00 00 00       	push   $0xef
80106da2:	e9 60 f1 ff ff       	jmp    80105f07 <alltraps>

80106da7 <vector240>:
80106da7:	6a 00                	push   $0x0
80106da9:	68 f0 00 00 00       	push   $0xf0
80106dae:	e9 54 f1 ff ff       	jmp    80105f07 <alltraps>

80106db3 <vector241>:
80106db3:	6a 00                	push   $0x0
80106db5:	68 f1 00 00 00       	push   $0xf1
80106dba:	e9 48 f1 ff ff       	jmp    80105f07 <alltraps>

80106dbf <vector242>:
80106dbf:	6a 00                	push   $0x0
80106dc1:	68 f2 00 00 00       	push   $0xf2
80106dc6:	e9 3c f1 ff ff       	jmp    80105f07 <alltraps>

80106dcb <vector243>:
80106dcb:	6a 00                	push   $0x0
80106dcd:	68 f3 00 00 00       	push   $0xf3
80106dd2:	e9 30 f1 ff ff       	jmp    80105f07 <alltraps>

80106dd7 <vector244>:
80106dd7:	6a 00                	push   $0x0
80106dd9:	68 f4 00 00 00       	push   $0xf4
80106dde:	e9 24 f1 ff ff       	jmp    80105f07 <alltraps>

80106de3 <vector245>:
80106de3:	6a 00                	push   $0x0
80106de5:	68 f5 00 00 00       	push   $0xf5
80106dea:	e9 18 f1 ff ff       	jmp    80105f07 <alltraps>

80106def <vector246>:
80106def:	6a 00                	push   $0x0
80106df1:	68 f6 00 00 00       	push   $0xf6
80106df6:	e9 0c f1 ff ff       	jmp    80105f07 <alltraps>

80106dfb <vector247>:
80106dfb:	6a 00                	push   $0x0
80106dfd:	68 f7 00 00 00       	push   $0xf7
80106e02:	e9 00 f1 ff ff       	jmp    80105f07 <alltraps>

80106e07 <vector248>:
80106e07:	6a 00                	push   $0x0
80106e09:	68 f8 00 00 00       	push   $0xf8
80106e0e:	e9 f4 f0 ff ff       	jmp    80105f07 <alltraps>

80106e13 <vector249>:
80106e13:	6a 00                	push   $0x0
80106e15:	68 f9 00 00 00       	push   $0xf9
80106e1a:	e9 e8 f0 ff ff       	jmp    80105f07 <alltraps>

80106e1f <vector250>:
80106e1f:	6a 00                	push   $0x0
80106e21:	68 fa 00 00 00       	push   $0xfa
80106e26:	e9 dc f0 ff ff       	jmp    80105f07 <alltraps>

80106e2b <vector251>:
80106e2b:	6a 00                	push   $0x0
80106e2d:	68 fb 00 00 00       	push   $0xfb
80106e32:	e9 d0 f0 ff ff       	jmp    80105f07 <alltraps>

80106e37 <vector252>:
80106e37:	6a 00                	push   $0x0
80106e39:	68 fc 00 00 00       	push   $0xfc
80106e3e:	e9 c4 f0 ff ff       	jmp    80105f07 <alltraps>

80106e43 <vector253>:
80106e43:	6a 00                	push   $0x0
80106e45:	68 fd 00 00 00       	push   $0xfd
80106e4a:	e9 b8 f0 ff ff       	jmp    80105f07 <alltraps>

80106e4f <vector254>:
80106e4f:	6a 00                	push   $0x0
80106e51:	68 fe 00 00 00       	push   $0xfe
80106e56:	e9 ac f0 ff ff       	jmp    80105f07 <alltraps>

80106e5b <vector255>:
80106e5b:	6a 00                	push   $0x0
80106e5d:	68 ff 00 00 00       	push   $0xff
80106e62:	e9 a0 f0 ff ff       	jmp    80105f07 <alltraps>
80106e67:	66 90                	xchg   %ax,%ax
80106e69:	66 90                	xchg   %ax,%ax
80106e6b:	66 90                	xchg   %ax,%ax
80106e6d:	66 90                	xchg   %ax,%ax
80106e6f:	90                   	nop

80106e70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106e7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e82:	83 ec 1c             	sub    $0x1c,%esp
80106e85:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e88:	39 d3                	cmp    %edx,%ebx
80106e8a:	73 49                	jae    80106ed5 <deallocuvm.part.0+0x65>
80106e8c:	89 c7                	mov    %eax,%edi
80106e8e:	eb 0c                	jmp    80106e9c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e90:	83 c0 01             	add    $0x1,%eax
80106e93:	c1 e0 16             	shl    $0x16,%eax
80106e96:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e98:	39 da                	cmp    %ebx,%edx
80106e9a:	76 39                	jbe    80106ed5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106e9c:	89 d8                	mov    %ebx,%eax
80106e9e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106ea1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106ea4:	f6 c1 01             	test   $0x1,%cl
80106ea7:	74 e7                	je     80106e90 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106ea9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106eab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106eb1:	c1 ee 0a             	shr    $0xa,%esi
80106eb4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106eba:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106ec1:	85 f6                	test   %esi,%esi
80106ec3:	74 cb                	je     80106e90 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ec5:	8b 06                	mov    (%esi),%eax
80106ec7:	a8 01                	test   $0x1,%al
80106ec9:	75 15                	jne    80106ee0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106ecb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ed1:	39 da                	cmp    %ebx,%edx
80106ed3:	77 c7                	ja     80106e9c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106edb:	5b                   	pop    %ebx
80106edc:	5e                   	pop    %esi
80106edd:	5f                   	pop    %edi
80106ede:	5d                   	pop    %ebp
80106edf:	c3                   	ret    
      if(pa == 0)
80106ee0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ee5:	74 25                	je     80106f0c <deallocuvm.part.0+0x9c>
      kfree(v);
80106ee7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106eea:	05 00 00 00 80       	add    $0x80000000,%eax
80106eef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ef2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ef8:	50                   	push   %eax
80106ef9:	e8 82 ba ff ff       	call   80102980 <kfree>
      *pte = 0;
80106efe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106f04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f07:	83 c4 10             	add    $0x10,%esp
80106f0a:	eb 8c                	jmp    80106e98 <deallocuvm.part.0+0x28>
        panic("kfree");
80106f0c:	83 ec 0c             	sub    $0xc,%esp
80106f0f:	68 fe 7a 10 80       	push   $0x80107afe
80106f14:	e8 67 94 ff ff       	call   80100380 <panic>
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f20 <mappages>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f26:	89 d3                	mov    %edx,%ebx
80106f28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f2e:	83 ec 1c             	sub    $0x1c,%esp
80106f31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f34:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f40:	8b 45 08             	mov    0x8(%ebp),%eax
80106f43:	29 d8                	sub    %ebx,%eax
80106f45:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f48:	eb 3d                	jmp    80106f87 <mappages+0x67>
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f50:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106f57:	c1 ea 0a             	shr    $0xa,%edx
80106f5a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f60:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f67:	85 c0                	test   %eax,%eax
80106f69:	74 75                	je     80106fe0 <mappages+0xc0>
    if(*pte & PTE_P)
80106f6b:	f6 00 01             	testb  $0x1,(%eax)
80106f6e:	0f 85 86 00 00 00    	jne    80106ffa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106f74:	0b 75 0c             	or     0xc(%ebp),%esi
80106f77:	83 ce 01             	or     $0x1,%esi
80106f7a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f7c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106f7f:	74 6f                	je     80106ff0 <mappages+0xd0>
    a += PGSIZE;
80106f81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106f87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106f8a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f8d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106f90:	89 d8                	mov    %ebx,%eax
80106f92:	c1 e8 16             	shr    $0x16,%eax
80106f95:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106f98:	8b 07                	mov    (%edi),%eax
80106f9a:	a8 01                	test   $0x1,%al
80106f9c:	75 b2                	jne    80106f50 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f9e:	e8 9d bb ff ff       	call   80102b40 <kalloc>
80106fa3:	85 c0                	test   %eax,%eax
80106fa5:	74 39                	je     80106fe0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106fa7:	83 ec 04             	sub    $0x4,%esp
80106faa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106fad:	68 00 10 00 00       	push   $0x1000
80106fb2:	6a 00                	push   $0x0
80106fb4:	50                   	push   %eax
80106fb5:	e8 16 dc ff ff       	call   80104bd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106fbd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fc0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106fc6:	83 c8 07             	or     $0x7,%eax
80106fc9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106fcb:	89 d8                	mov    %ebx,%eax
80106fcd:	c1 e8 0a             	shr    $0xa,%eax
80106fd0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fd5:	01 d0                	add    %edx,%eax
80106fd7:	eb 92                	jmp    80106f6b <mappages+0x4b>
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fe8:	5b                   	pop    %ebx
80106fe9:	5e                   	pop    %esi
80106fea:	5f                   	pop    %edi
80106feb:	5d                   	pop    %ebp
80106fec:	c3                   	ret    
80106fed:	8d 76 00             	lea    0x0(%esi),%esi
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ff3:	31 c0                	xor    %eax,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
      panic("remap");
80106ffa:	83 ec 0c             	sub    $0xc,%esp
80106ffd:	68 74 81 10 80       	push   $0x80108174
80107002:	e8 79 93 ff ff       	call   80100380 <panic>
80107007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700e:	66 90                	xchg   %ax,%ax

80107010 <seginit>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107016:	e8 f5 cd ff ff       	call   80103e10 <cpuid>
  pd[0] = size-1;
8010701b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107020:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107026:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010702a:	c7 80 38 2a 11 80 ff 	movl   $0xffff,-0x7feed5c8(%eax)
80107031:	ff 00 00 
80107034:	c7 80 3c 2a 11 80 00 	movl   $0xcf9a00,-0x7feed5c4(%eax)
8010703b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010703e:	c7 80 40 2a 11 80 ff 	movl   $0xffff,-0x7feed5c0(%eax)
80107045:	ff 00 00 
80107048:	c7 80 44 2a 11 80 00 	movl   $0xcf9200,-0x7feed5bc(%eax)
8010704f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107052:	c7 80 48 2a 11 80 ff 	movl   $0xffff,-0x7feed5b8(%eax)
80107059:	ff 00 00 
8010705c:	c7 80 4c 2a 11 80 00 	movl   $0xcffa00,-0x7feed5b4(%eax)
80107063:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107066:	c7 80 50 2a 11 80 ff 	movl   $0xffff,-0x7feed5b0(%eax)
8010706d:	ff 00 00 
80107070:	c7 80 54 2a 11 80 00 	movl   $0xcff200,-0x7feed5ac(%eax)
80107077:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010707a:	05 30 2a 11 80       	add    $0x80112a30,%eax
  pd[1] = (uint)p;
8010707f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107083:	c1 e8 10             	shr    $0x10,%eax
80107086:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010708a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010708d:	0f 01 10             	lgdtl  (%eax)
}
80107090:	c9                   	leave  
80107091:	c3                   	ret    
80107092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070a0:	a1 a4 ed 12 80       	mov    0x8012eda4,%eax
801070a5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070aa:	0f 22 d8             	mov    %eax,%cr3
}
801070ad:	c3                   	ret    
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <switchuvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 1c             	sub    $0x1c,%esp
801070b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801070bc:	85 f6                	test   %esi,%esi
801070be:	0f 84 cb 00 00 00    	je     8010718f <switchuvm+0xdf>
  if(p->kstack == 0)
801070c4:	8b 46 08             	mov    0x8(%esi),%eax
801070c7:	85 c0                	test   %eax,%eax
801070c9:	0f 84 da 00 00 00    	je     801071a9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801070cf:	8b 46 04             	mov    0x4(%esi),%eax
801070d2:	85 c0                	test   %eax,%eax
801070d4:	0f 84 c2 00 00 00    	je     8010719c <switchuvm+0xec>
  pushcli();
801070da:	e8 e1 d8 ff ff       	call   801049c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070df:	e8 cc cc ff ff       	call   80103db0 <mycpu>
801070e4:	89 c3                	mov    %eax,%ebx
801070e6:	e8 c5 cc ff ff       	call   80103db0 <mycpu>
801070eb:	89 c7                	mov    %eax,%edi
801070ed:	e8 be cc ff ff       	call   80103db0 <mycpu>
801070f2:	83 c7 08             	add    $0x8,%edi
801070f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070f8:	e8 b3 cc ff ff       	call   80103db0 <mycpu>
801070fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107100:	ba 67 00 00 00       	mov    $0x67,%edx
80107105:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010710c:	83 c0 08             	add    $0x8,%eax
8010710f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107116:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010711b:	83 c1 08             	add    $0x8,%ecx
8010711e:	c1 e8 18             	shr    $0x18,%eax
80107121:	c1 e9 10             	shr    $0x10,%ecx
80107124:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010712a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107130:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107135:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010713c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107141:	e8 6a cc ff ff       	call   80103db0 <mycpu>
80107146:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010714d:	e8 5e cc ff ff       	call   80103db0 <mycpu>
80107152:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107156:	8b 5e 08             	mov    0x8(%esi),%ebx
80107159:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010715f:	e8 4c cc ff ff       	call   80103db0 <mycpu>
80107164:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107167:	e8 44 cc ff ff       	call   80103db0 <mycpu>
8010716c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107170:	b8 28 00 00 00       	mov    $0x28,%eax
80107175:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107178:	8b 46 04             	mov    0x4(%esi),%eax
8010717b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107180:	0f 22 d8             	mov    %eax,%cr3
}
80107183:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107186:	5b                   	pop    %ebx
80107187:	5e                   	pop    %esi
80107188:	5f                   	pop    %edi
80107189:	5d                   	pop    %ebp
  popcli();
8010718a:	e9 81 d8 ff ff       	jmp    80104a10 <popcli>
    panic("switchuvm: no process");
8010718f:	83 ec 0c             	sub    $0xc,%esp
80107192:	68 7a 81 10 80       	push   $0x8010817a
80107197:	e8 e4 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010719c:	83 ec 0c             	sub    $0xc,%esp
8010719f:	68 a5 81 10 80       	push   $0x801081a5
801071a4:	e8 d7 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801071a9:	83 ec 0c             	sub    $0xc,%esp
801071ac:	68 90 81 10 80       	push   $0x80108190
801071b1:	e8 ca 91 ff ff       	call   80100380 <panic>
801071b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071bd:	8d 76 00             	lea    0x0(%esi),%esi

801071c0 <inituvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 1c             	sub    $0x1c,%esp
801071c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801071cc:	8b 75 10             	mov    0x10(%ebp),%esi
801071cf:	8b 7d 08             	mov    0x8(%ebp),%edi
801071d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801071d5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071db:	77 4b                	ja     80107228 <inituvm+0x68>
  mem = kalloc();
801071dd:	e8 5e b9 ff ff       	call   80102b40 <kalloc>
  memset(mem, 0, PGSIZE);
801071e2:	83 ec 04             	sub    $0x4,%esp
801071e5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801071ea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801071ec:	6a 00                	push   $0x0
801071ee:	50                   	push   %eax
801071ef:	e8 dc d9 ff ff       	call   80104bd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801071f4:	58                   	pop    %eax
801071f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071fb:	5a                   	pop    %edx
801071fc:	6a 06                	push   $0x6
801071fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107203:	31 d2                	xor    %edx,%edx
80107205:	50                   	push   %eax
80107206:	89 f8                	mov    %edi,%eax
80107208:	e8 13 fd ff ff       	call   80106f20 <mappages>
  memmove(mem, init, sz);
8010720d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107210:	89 75 10             	mov    %esi,0x10(%ebp)
80107213:	83 c4 10             	add    $0x10,%esp
80107216:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107219:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010721c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721f:	5b                   	pop    %ebx
80107220:	5e                   	pop    %esi
80107221:	5f                   	pop    %edi
80107222:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107223:	e9 48 da ff ff       	jmp    80104c70 <memmove>
    panic("inituvm: more than a page");
80107228:	83 ec 0c             	sub    $0xc,%esp
8010722b:	68 b9 81 10 80       	push   $0x801081b9
80107230:	e8 4b 91 ff ff       	call   80100380 <panic>
80107235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107240 <loaduvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 1c             	sub    $0x1c,%esp
80107249:	8b 45 0c             	mov    0xc(%ebp),%eax
8010724c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010724f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107254:	0f 85 bb 00 00 00    	jne    80107315 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010725a:	01 f0                	add    %esi,%eax
8010725c:	89 f3                	mov    %esi,%ebx
8010725e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107261:	8b 45 14             	mov    0x14(%ebp),%eax
80107264:	01 f0                	add    %esi,%eax
80107266:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107269:	85 f6                	test   %esi,%esi
8010726b:	0f 84 87 00 00 00    	je     801072f8 <loaduvm+0xb8>
80107271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010727b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010727e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107280:	89 c2                	mov    %eax,%edx
80107282:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107285:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107288:	f6 c2 01             	test   $0x1,%dl
8010728b:	75 13                	jne    801072a0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010728d:	83 ec 0c             	sub    $0xc,%esp
80107290:	68 d3 81 10 80       	push   $0x801081d3
80107295:	e8 e6 90 ff ff       	call   80100380 <panic>
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072b5:	85 c0                	test   %eax,%eax
801072b7:	74 d4                	je     8010728d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801072b9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801072be:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072c8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801072ce:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072d1:	29 d9                	sub    %ebx,%ecx
801072d3:	05 00 00 00 80       	add    $0x80000000,%eax
801072d8:	57                   	push   %edi
801072d9:	51                   	push   %ecx
801072da:	50                   	push   %eax
801072db:	ff 75 10             	push   0x10(%ebp)
801072de:	e8 6d ac ff ff       	call   80101f50 <readi>
801072e3:	83 c4 10             	add    $0x10,%esp
801072e6:	39 f8                	cmp    %edi,%eax
801072e8:	75 1e                	jne    80107308 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801072ea:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801072f0:	89 f0                	mov    %esi,%eax
801072f2:	29 d8                	sub    %ebx,%eax
801072f4:	39 c6                	cmp    %eax,%esi
801072f6:	77 80                	ja     80107278 <loaduvm+0x38>
}
801072f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072fb:	31 c0                	xor    %eax,%eax
}
801072fd:	5b                   	pop    %ebx
801072fe:	5e                   	pop    %esi
801072ff:	5f                   	pop    %edi
80107300:	5d                   	pop    %ebp
80107301:	c3                   	ret    
80107302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107308:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010730b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
80107314:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107315:	83 ec 0c             	sub    $0xc,%esp
80107318:	68 74 82 10 80       	push   $0x80108274
8010731d:	e8 5e 90 ff ff       	call   80100380 <panic>
80107322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107330 <allocuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107339:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010733c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010733f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107342:	85 c0                	test   %eax,%eax
80107344:	0f 88 b6 00 00 00    	js     80107400 <allocuvm+0xd0>
  if(newsz < oldsz)
8010734a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010734d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107350:	0f 82 9a 00 00 00    	jb     801073f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107356:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010735c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107362:	39 75 10             	cmp    %esi,0x10(%ebp)
80107365:	77 44                	ja     801073ab <allocuvm+0x7b>
80107367:	e9 87 00 00 00       	jmp    801073f3 <allocuvm+0xc3>
8010736c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107370:	83 ec 04             	sub    $0x4,%esp
80107373:	68 00 10 00 00       	push   $0x1000
80107378:	6a 00                	push   $0x0
8010737a:	50                   	push   %eax
8010737b:	e8 50 d8 ff ff       	call   80104bd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107380:	58                   	pop    %eax
80107381:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107387:	5a                   	pop    %edx
80107388:	6a 06                	push   $0x6
8010738a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010738f:	89 f2                	mov    %esi,%edx
80107391:	50                   	push   %eax
80107392:	89 f8                	mov    %edi,%eax
80107394:	e8 87 fb ff ff       	call   80106f20 <mappages>
80107399:	83 c4 10             	add    $0x10,%esp
8010739c:	85 c0                	test   %eax,%eax
8010739e:	78 78                	js     80107418 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801073a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073a9:	76 48                	jbe    801073f3 <allocuvm+0xc3>
    mem = kalloc();
801073ab:	e8 90 b7 ff ff       	call   80102b40 <kalloc>
801073b0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073b2:	85 c0                	test   %eax,%eax
801073b4:	75 ba                	jne    80107370 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073b6:	83 ec 0c             	sub    $0xc,%esp
801073b9:	68 f1 81 10 80       	push   $0x801081f1
801073be:	e8 dd 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801073c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c6:	83 c4 10             	add    $0x10,%esp
801073c9:	39 45 10             	cmp    %eax,0x10(%ebp)
801073cc:	74 32                	je     80107400 <allocuvm+0xd0>
801073ce:	8b 55 10             	mov    0x10(%ebp),%edx
801073d1:	89 c1                	mov    %eax,%ecx
801073d3:	89 f8                	mov    %edi,%eax
801073d5:	e8 96 fa ff ff       	call   80106e70 <deallocuvm.part.0>
      return 0;
801073da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801073e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e7:	5b                   	pop    %ebx
801073e8:	5e                   	pop    %esi
801073e9:	5f                   	pop    %edi
801073ea:	5d                   	pop    %ebp
801073eb:	c3                   	ret    
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801073f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801073f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f9:	5b                   	pop    %ebx
801073fa:	5e                   	pop    %esi
801073fb:	5f                   	pop    %edi
801073fc:	5d                   	pop    %ebp
801073fd:	c3                   	ret    
801073fe:	66 90                	xchg   %ax,%ax
    return 0;
80107400:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010740a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740d:	5b                   	pop    %ebx
8010740e:	5e                   	pop    %esi
8010740f:	5f                   	pop    %edi
80107410:	5d                   	pop    %ebp
80107411:	c3                   	ret    
80107412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107418:	83 ec 0c             	sub    $0xc,%esp
8010741b:	68 09 82 10 80       	push   $0x80108209
80107420:	e8 7b 92 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107425:	8b 45 0c             	mov    0xc(%ebp),%eax
80107428:	83 c4 10             	add    $0x10,%esp
8010742b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010742e:	74 0c                	je     8010743c <allocuvm+0x10c>
80107430:	8b 55 10             	mov    0x10(%ebp),%edx
80107433:	89 c1                	mov    %eax,%ecx
80107435:	89 f8                	mov    %edi,%eax
80107437:	e8 34 fa ff ff       	call   80106e70 <deallocuvm.part.0>
      kfree(mem);
8010743c:	83 ec 0c             	sub    $0xc,%esp
8010743f:	53                   	push   %ebx
80107440:	e8 3b b5 ff ff       	call   80102980 <kfree>
      return 0;
80107445:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010744c:	83 c4 10             	add    $0x10,%esp
}
8010744f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107452:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107455:	5b                   	pop    %ebx
80107456:	5e                   	pop    %esi
80107457:	5f                   	pop    %edi
80107458:	5d                   	pop    %ebp
80107459:	c3                   	ret    
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107460 <deallocuvm>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	8b 55 0c             	mov    0xc(%ebp),%edx
80107466:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107469:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010746c:	39 d1                	cmp    %edx,%ecx
8010746e:	73 10                	jae    80107480 <deallocuvm+0x20>
}
80107470:	5d                   	pop    %ebp
80107471:	e9 fa f9 ff ff       	jmp    80106e70 <deallocuvm.part.0>
80107476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747d:	8d 76 00             	lea    0x0(%esi),%esi
80107480:	89 d0                	mov    %edx,%eax
80107482:	5d                   	pop    %ebp
80107483:	c3                   	ret    
80107484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010748f:	90                   	nop

80107490 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 0c             	sub    $0xc,%esp
80107499:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010749c:	85 f6                	test   %esi,%esi
8010749e:	74 59                	je     801074f9 <freevm+0x69>
  if(newsz >= oldsz)
801074a0:	31 c9                	xor    %ecx,%ecx
801074a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074a7:	89 f0                	mov    %esi,%eax
801074a9:	89 f3                	mov    %esi,%ebx
801074ab:	e8 c0 f9 ff ff       	call   80106e70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074b6:	eb 0f                	jmp    801074c7 <freevm+0x37>
801074b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bf:	90                   	nop
801074c0:	83 c3 04             	add    $0x4,%ebx
801074c3:	39 df                	cmp    %ebx,%edi
801074c5:	74 23                	je     801074ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074c7:	8b 03                	mov    (%ebx),%eax
801074c9:	a8 01                	test   $0x1,%al
801074cb:	74 f3                	je     801074c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074dd:	50                   	push   %eax
801074de:	e8 9d b4 ff ff       	call   80102980 <kfree>
801074e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074e6:	39 df                	cmp    %ebx,%edi
801074e8:	75 dd                	jne    801074c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801074ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f0:	5b                   	pop    %ebx
801074f1:	5e                   	pop    %esi
801074f2:	5f                   	pop    %edi
801074f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074f4:	e9 87 b4 ff ff       	jmp    80102980 <kfree>
    panic("freevm: no pgdir");
801074f9:	83 ec 0c             	sub    $0xc,%esp
801074fc:	68 25 82 10 80       	push   $0x80108225
80107501:	e8 7a 8e ff ff       	call   80100380 <panic>
80107506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750d:	8d 76 00             	lea    0x0(%esi),%esi

80107510 <setupkvm>:
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	56                   	push   %esi
80107514:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107515:	e8 26 b6 ff ff       	call   80102b40 <kalloc>
8010751a:	89 c6                	mov    %eax,%esi
8010751c:	85 c0                	test   %eax,%eax
8010751e:	74 42                	je     80107562 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107520:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107523:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107528:	68 00 10 00 00       	push   $0x1000
8010752d:	6a 00                	push   $0x0
8010752f:	50                   	push   %eax
80107530:	e8 9b d6 ff ff       	call   80104bd0 <memset>
80107535:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107538:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010753b:	83 ec 08             	sub    $0x8,%esp
8010753e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107541:	ff 73 0c             	push   0xc(%ebx)
80107544:	8b 13                	mov    (%ebx),%edx
80107546:	50                   	push   %eax
80107547:	29 c1                	sub    %eax,%ecx
80107549:	89 f0                	mov    %esi,%eax
8010754b:	e8 d0 f9 ff ff       	call   80106f20 <mappages>
80107550:	83 c4 10             	add    $0x10,%esp
80107553:	85 c0                	test   %eax,%eax
80107555:	78 19                	js     80107570 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107557:	83 c3 10             	add    $0x10,%ebx
8010755a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107560:	75 d6                	jne    80107538 <setupkvm+0x28>
}
80107562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107565:	89 f0                	mov    %esi,%eax
80107567:	5b                   	pop    %ebx
80107568:	5e                   	pop    %esi
80107569:	5d                   	pop    %ebp
8010756a:	c3                   	ret    
8010756b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010756f:	90                   	nop
      freevm(pgdir);
80107570:	83 ec 0c             	sub    $0xc,%esp
80107573:	56                   	push   %esi
      return 0;
80107574:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107576:	e8 15 ff ff ff       	call   80107490 <freevm>
      return 0;
8010757b:	83 c4 10             	add    $0x10,%esp
}
8010757e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107581:	89 f0                	mov    %esi,%eax
80107583:	5b                   	pop    %ebx
80107584:	5e                   	pop    %esi
80107585:	5d                   	pop    %ebp
80107586:	c3                   	ret    
80107587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010758e:	66 90                	xchg   %ax,%ax

80107590 <kvmalloc>:
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107596:	e8 75 ff ff ff       	call   80107510 <setupkvm>
8010759b:	a3 a4 ed 12 80       	mov    %eax,0x8012eda4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075a0:	05 00 00 00 80       	add    $0x80000000,%eax
801075a5:	0f 22 d8             	mov    %eax,%cr3
}
801075a8:	c9                   	leave  
801075a9:	c3                   	ret    
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	83 ec 08             	sub    $0x8,%esp
801075b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075bc:	89 c1                	mov    %eax,%ecx
801075be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075c4:	f6 c2 01             	test   $0x1,%dl
801075c7:	75 17                	jne    801075e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	68 36 82 10 80       	push   $0x80108236
801075d1:	e8 aa 8d ff ff       	call   80100380 <panic>
801075d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075dd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801075e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801075e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801075ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801075f5:	85 c0                	test   %eax,%eax
801075f7:	74 d0                	je     801075c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801075f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075fc:	c9                   	leave  
801075fd:	c3                   	ret    
801075fe:	66 90                	xchg   %ax,%ax

80107600 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107609:	e8 02 ff ff ff       	call   80107510 <setupkvm>
8010760e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107611:	85 c0                	test   %eax,%eax
80107613:	0f 84 bd 00 00 00    	je     801076d6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107619:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010761c:	85 c9                	test   %ecx,%ecx
8010761e:	0f 84 b2 00 00 00    	je     801076d6 <copyuvm+0xd6>
80107624:	31 f6                	xor    %esi,%esi
80107626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107630:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107633:	89 f0                	mov    %esi,%eax
80107635:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107638:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010763b:	a8 01                	test   $0x1,%al
8010763d:	75 11                	jne    80107650 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010763f:	83 ec 0c             	sub    $0xc,%esp
80107642:	68 40 82 10 80       	push   $0x80108240
80107647:	e8 34 8d ff ff       	call   80100380 <panic>
8010764c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107650:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107652:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107657:	c1 ea 0a             	shr    $0xa,%edx
8010765a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107660:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107667:	85 c0                	test   %eax,%eax
80107669:	74 d4                	je     8010763f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010766b:	8b 00                	mov    (%eax),%eax
8010766d:	a8 01                	test   $0x1,%al
8010766f:	0f 84 9f 00 00 00    	je     80107714 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107675:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107677:	25 ff 0f 00 00       	and    $0xfff,%eax
8010767c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010767f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107685:	e8 b6 b4 ff ff       	call   80102b40 <kalloc>
8010768a:	89 c3                	mov    %eax,%ebx
8010768c:	85 c0                	test   %eax,%eax
8010768e:	74 64                	je     801076f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107690:	83 ec 04             	sub    $0x4,%esp
80107693:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107699:	68 00 10 00 00       	push   $0x1000
8010769e:	57                   	push   %edi
8010769f:	50                   	push   %eax
801076a0:	e8 cb d5 ff ff       	call   80104c70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076a5:	58                   	pop    %eax
801076a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076ac:	5a                   	pop    %edx
801076ad:	ff 75 e4             	push   -0x1c(%ebp)
801076b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076b5:	89 f2                	mov    %esi,%edx
801076b7:	50                   	push   %eax
801076b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076bb:	e8 60 f8 ff ff       	call   80106f20 <mappages>
801076c0:	83 c4 10             	add    $0x10,%esp
801076c3:	85 c0                	test   %eax,%eax
801076c5:	78 21                	js     801076e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801076c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076d0:	0f 87 5a ff ff ff    	ja     80107630 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801076d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076dc:	5b                   	pop    %ebx
801076dd:	5e                   	pop    %esi
801076de:	5f                   	pop    %edi
801076df:	5d                   	pop    %ebp
801076e0:	c3                   	ret    
801076e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801076e8:	83 ec 0c             	sub    $0xc,%esp
801076eb:	53                   	push   %ebx
801076ec:	e8 8f b2 ff ff       	call   80102980 <kfree>
      goto bad;
801076f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801076f4:	83 ec 0c             	sub    $0xc,%esp
801076f7:	ff 75 e0             	push   -0x20(%ebp)
801076fa:	e8 91 fd ff ff       	call   80107490 <freevm>
  return 0;
801076ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107706:	83 c4 10             	add    $0x10,%esp
}
80107709:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010770c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010770f:	5b                   	pop    %ebx
80107710:	5e                   	pop    %esi
80107711:	5f                   	pop    %edi
80107712:	5d                   	pop    %ebp
80107713:	c3                   	ret    
      panic("copyuvm: page not present");
80107714:	83 ec 0c             	sub    $0xc,%esp
80107717:	68 5a 82 10 80       	push   $0x8010825a
8010771c:	e8 5f 8c ff ff       	call   80100380 <panic>
80107721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772f:	90                   	nop

80107730 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107736:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107739:	89 c1                	mov    %eax,%ecx
8010773b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010773e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107741:	f6 c2 01             	test   $0x1,%dl
80107744:	0f 84 00 01 00 00    	je     8010784a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010774a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010774d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107753:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107754:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107759:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107760:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107762:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107767:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010776a:	05 00 00 00 80       	add    $0x80000000,%eax
8010776f:	83 fa 05             	cmp    $0x5,%edx
80107772:	ba 00 00 00 00       	mov    $0x0,%edx
80107777:	0f 45 c2             	cmovne %edx,%eax
}
8010777a:	c3                   	ret    
8010777b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010777f:	90                   	nop

80107780 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	53                   	push   %ebx
80107786:	83 ec 0c             	sub    $0xc,%esp
80107789:	8b 75 14             	mov    0x14(%ebp),%esi
8010778c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010778f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107792:	85 f6                	test   %esi,%esi
80107794:	75 51                	jne    801077e7 <copyout+0x67>
80107796:	e9 a5 00 00 00       	jmp    80107840 <copyout+0xc0>
8010779b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010779f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801077a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801077ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801077b2:	74 75                	je     80107829 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801077b4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077b6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801077b9:	29 c3                	sub    %eax,%ebx
801077bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077c1:	39 f3                	cmp    %esi,%ebx
801077c3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801077c6:	29 f8                	sub    %edi,%eax
801077c8:	83 ec 04             	sub    $0x4,%esp
801077cb:	01 c1                	add    %eax,%ecx
801077cd:	53                   	push   %ebx
801077ce:	52                   	push   %edx
801077cf:	51                   	push   %ecx
801077d0:	e8 9b d4 ff ff       	call   80104c70 <memmove>
    len -= n;
    buf += n;
801077d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801077d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801077de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801077e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801077e3:	29 de                	sub    %ebx,%esi
801077e5:	74 59                	je     80107840 <copyout+0xc0>
  if(*pde & PTE_P){
801077e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801077ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801077ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801077f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801077f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801077fa:	f6 c1 01             	test   $0x1,%cl
801077fd:	0f 84 4e 00 00 00    	je     80107851 <copyout.cold>
  return &pgtab[PTX(va)];
80107803:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107805:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010780b:	c1 eb 0c             	shr    $0xc,%ebx
8010780e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107814:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010781b:	89 d9                	mov    %ebx,%ecx
8010781d:	83 e1 05             	and    $0x5,%ecx
80107820:	83 f9 05             	cmp    $0x5,%ecx
80107823:	0f 84 77 ff ff ff    	je     801077a0 <copyout+0x20>
  }
  return 0;
}
80107829:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010782c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107831:	5b                   	pop    %ebx
80107832:	5e                   	pop    %esi
80107833:	5f                   	pop    %edi
80107834:	5d                   	pop    %ebp
80107835:	c3                   	ret    
80107836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010783d:	8d 76 00             	lea    0x0(%esi),%esi
80107840:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107843:	31 c0                	xor    %eax,%eax
}
80107845:	5b                   	pop    %ebx
80107846:	5e                   	pop    %esi
80107847:	5f                   	pop    %edi
80107848:	5d                   	pop    %ebp
80107849:	c3                   	ret    

8010784a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010784a:	a1 00 00 00 00       	mov    0x0,%eax
8010784f:	0f 0b                	ud2    

80107851 <copyout.cold>:
80107851:	a1 00 00 00 00       	mov    0x0,%eax
80107856:	0f 0b                	ud2    
