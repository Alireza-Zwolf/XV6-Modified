
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
80100028:	bc b0 fe 12 80       	mov    $0x8012feb0,%esp
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
8010004c:	68 c0 7c 10 80       	push   $0x80107cc0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 4c 00 00       	call   80104d40 <initlock>
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
80100092:	68 c7 7c 10 80       	push   $0x80107cc7
80100097:	50                   	push   %eax
80100098:	e8 73 4b 00 00       	call   80104c10 <initsleeplock>
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
801000e4:	e8 27 4e 00 00       	call   80104f10 <acquire>
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
80100162:	e8 49 4d 00 00       	call   80104eb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 4a 00 00       	call   80104c50 <acquiresleep>
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
801001a1:	68 ce 7c 10 80       	push   $0x80107cce
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
801001be:	e8 2d 4b 00 00       	call   80104cf0 <holdingsleep>
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
801001dc:	68 df 7c 10 80       	push   $0x80107cdf
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
801001ff:	e8 ec 4a 00 00       	call   80104cf0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 4a 00 00       	call   80104cb0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 f0 4c 00 00       	call   80104f10 <acquire>
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
8010026c:	e9 3f 4c 00 00       	jmp    80104eb0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 7c 10 80       	push   $0x80107ce6
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
801002a0:	e8 6b 4c 00 00       	call   80104f10 <acquire>
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
801002f6:	e8 b5 4b 00 00       	call   80104eb0 <release>
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
8010034c:	e8 5f 4b 00 00       	call   80104eb0 <release>
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
801003a2:	68 ed 7c 10 80       	push   $0x80107ced
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 0b 87 10 80 	movl   $0x8010870b,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 49 00 00       	call   80104d60 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 7d 10 80       	push   $0x80107d01
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
8010041a:	e8 b1 63 00 00       	call   801067d0 <uartputc>
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
80100505:	e8 c6 62 00 00       	call   801067d0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 62 00 00       	call   801067d0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 62 00 00       	call   801067d0 <uartputc>
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
80100551:	e8 1a 4b 00 00       	call   80105070 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 65 4a 00 00       	call   80104fd0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 7d 10 80       	push   $0x80107d05
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
801005ab:	e8 60 49 00 00       	call   80104f10 <acquire>
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
801005e4:	e8 c7 48 00 00       	call   80104eb0 <release>
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
80100636:	0f b6 92 68 7d 10 80 	movzbl -0x7fef8298(%edx),%edx
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
801007e8:	e8 23 47 00 00       	call   80104f10 <acquire>
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
80100838:	bf 18 7d 10 80       	mov    $0x80107d18,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 01 11 80       	push   $0x80110140
8010085b:	e8 50 46 00 00       	call   80104eb0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 7d 10 80       	push   $0x80107d1f
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
80100d03:	e8 08 42 00 00       	call   80104f10 <acquire>
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
80100d31:	ff 24 85 30 7d 10 80 	jmp    *-0x7fef82d0(,%eax,4)
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
80100e08:	e8 a3 40 00 00       	call   80104eb0 <release>
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
80100f26:	68 28 7d 10 80       	push   $0x80107d28
80100f2b:	68 40 01 11 80       	push   $0x80110140
80100f30:	e8 0b 3e 00 00       	call   80104d40 <initlock>

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
80100ff4:	e8 67 69 00 00       	call   80107960 <setupkvm>
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
80101063:	e8 18 67 00 00       	call   80107780 <allocuvm>
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
80101099:	e8 f2 65 00 00       	call   80107690 <loaduvm>
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
801010db:	e8 00 68 00 00       	call   801078e0 <freevm>
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
80101122:	e8 59 66 00 00       	call   80107780 <allocuvm>
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
80101143:	e8 b8 68 00 00       	call   80107a00 <clearpteu>
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
80101193:	e8 38 40 00 00       	call   801051d0 <strlen>
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
801011a7:	e8 24 40 00 00       	call   801051d0 <strlen>
801011ac:	83 c0 01             	add    $0x1,%eax
801011af:	50                   	push   %eax
801011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801011b3:	ff 34 b8             	push   (%eax,%edi,4)
801011b6:	53                   	push   %ebx
801011b7:	56                   	push   %esi
801011b8:	e8 13 6a 00 00       	call   80107bd0 <copyout>
801011bd:	83 c4 20             	add    $0x20,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	79 ac                	jns    80101170 <exec+0x200>
801011c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011d1:	e8 0a 67 00 00       	call   801078e0 <freevm>
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
80101223:	e8 a8 69 00 00       	call   80107bd0 <copyout>
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
80101261:	e8 2a 3f 00 00       	call   80105190 <safestrcpy>
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
8010128d:	e8 6e 62 00 00       	call   80107500 <switchuvm>
  freevm(oldpgdir);
80101292:	89 3c 24             	mov    %edi,(%esp)
80101295:	e8 46 66 00 00       	call   801078e0 <freevm>
  return 0;
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	31 c0                	xor    %eax,%eax
8010129f:	e9 38 fd ff ff       	jmp    80100fdc <exec+0x6c>
    end_op();
801012a4:	e8 e7 1f 00 00       	call   80103290 <end_op>
    cprintf("exec: fail\n");
801012a9:	83 ec 0c             	sub    $0xc,%esp
801012ac:	68 79 7d 10 80       	push   $0x80107d79
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
801012d6:	68 85 7d 10 80       	push   $0x80107d85
801012db:	68 80 01 11 80       	push   $0x80110180
801012e0:	e8 5b 3a 00 00       	call   80104d40 <initlock>
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
80101301:	e8 0a 3c 00 00       	call   80104f10 <acquire>
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
80101331:	e8 7a 3b 00 00       	call   80104eb0 <release>
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
8010134a:	e8 61 3b 00 00       	call   80104eb0 <release>
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
8010136f:	e8 9c 3b 00 00       	call   80104f10 <acquire>
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
8010138c:	e8 1f 3b 00 00       	call   80104eb0 <release>
  return f;
}
80101391:	89 d8                	mov    %ebx,%eax
80101393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101396:	c9                   	leave  
80101397:	c3                   	ret    
    panic("filedup");
80101398:	83 ec 0c             	sub    $0xc,%esp
8010139b:	68 8c 7d 10 80       	push   $0x80107d8c
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
801013c1:	e8 4a 3b 00 00       	call   80104f10 <acquire>
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
801013fc:	e8 af 3a 00 00       	call   80104eb0 <release>

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
8010142e:	e9 7d 3a 00 00       	jmp    80104eb0 <release>
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
8010147c:	68 94 7d 10 80       	push   $0x80107d94
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
80101562:	68 9e 7d 10 80       	push   $0x80107d9e
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
80101637:	68 a7 7d 10 80       	push   $0x80107da7
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
80101671:	68 ad 7d 10 80       	push   $0x80107dad
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
801016e7:	68 b7 7d 10 80       	push   $0x80107db7
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
801017a4:	68 ca 7d 10 80       	push   $0x80107dca
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
801017e5:	e8 e6 37 00 00       	call   80104fd0 <memset>
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
8010182a:	e8 e1 36 00 00       	call   80104f10 <acquire>
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
80101897:	e8 14 36 00 00       	call   80104eb0 <release>

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
801018c5:	e8 e6 35 00 00       	call   80104eb0 <release>
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
801018f8:	68 e0 7d 10 80       	push   $0x80107de0
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
801019d5:	68 f0 7d 10 80       	push   $0x80107df0
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
80101a01:	e8 6a 36 00 00       	call   80105070 <memmove>
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
80101a2c:	68 03 7e 10 80       	push   $0x80107e03
80101a31:	68 80 0b 11 80       	push   $0x80110b80
80101a36:	e8 05 33 00 00       	call   80104d40 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a40:	83 ec 08             	sub    $0x8,%esp
80101a43:	68 0a 7e 10 80       	push   $0x80107e0a
80101a48:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a49:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a4f:	e8 bc 31 00 00       	call   80104c10 <initsleeplock>
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
80101a7c:	e8 ef 35 00 00       	call   80105070 <memmove>
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
80101ab3:	68 70 7e 10 80       	push   $0x80107e70
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
80101b4e:	e8 7d 34 00 00       	call   80104fd0 <memset>
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
80101b83:	68 10 7e 10 80       	push   $0x80107e10
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
80101bf1:	e8 7a 34 00 00       	call   80105070 <memmove>
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
80101c1f:	e8 ec 32 00 00       	call   80104f10 <acquire>
  ip->ref++;
80101c24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c28:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101c2f:	e8 7c 32 00 00       	call   80104eb0 <release>
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
80101c62:	e8 e9 2f 00 00       	call   80104c50 <acquiresleep>
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
80101cd8:	e8 93 33 00 00       	call   80105070 <memmove>
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
80101cfd:	68 28 7e 10 80       	push   $0x80107e28
80101d02:	e8 79 e6 ff ff       	call   80100380 <panic>
    panic("ilock");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 22 7e 10 80       	push   $0x80107e22
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
80101d33:	e8 b8 2f 00 00       	call   80104cf0 <holdingsleep>
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
80101d4f:	e9 5c 2f 00 00       	jmp    80104cb0 <releasesleep>
    panic("iunlock");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 37 7e 10 80       	push   $0x80107e37
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
80101d80:	e8 cb 2e 00 00       	call   80104c50 <acquiresleep>
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
80101d9a:	e8 11 2f 00 00       	call   80104cb0 <releasesleep>
  acquire(&icache.lock);
80101d9f:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101da6:	e8 65 31 00 00       	call   80104f10 <acquire>
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
80101dc0:	e9 eb 30 00 00       	jmp    80104eb0 <release>
80101dc5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	68 80 0b 11 80       	push   $0x80110b80
80101dd0:	e8 3b 31 00 00       	call   80104f10 <acquire>
    int r = ip->ref;
80101dd5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101dd8:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101ddf:	e8 cc 30 00 00       	call   80104eb0 <release>
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
80101ee3:	e8 08 2e 00 00       	call   80104cf0 <holdingsleep>
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	74 21                	je     80101f10 <iunlockput+0x40>
80101eef:	8b 43 08             	mov    0x8(%ebx),%eax
80101ef2:	85 c0                	test   %eax,%eax
80101ef4:	7e 1a                	jle    80101f10 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ef6:	83 ec 0c             	sub    $0xc,%esp
80101ef9:	56                   	push   %esi
80101efa:	e8 b1 2d 00 00       	call   80104cb0 <releasesleep>
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
80101f13:	68 37 7e 10 80       	push   $0x80107e37
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
80101ff7:	e8 74 30 00 00       	call   80105070 <memmove>
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
801020f3:	e8 78 2f 00 00       	call   80105070 <memmove>
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
8010218e:	e8 4d 2f 00 00       	call   801050e0 <strncmp>
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
801021ed:	e8 ee 2e 00 00       	call   801050e0 <strncmp>
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
80102232:	68 51 7e 10 80       	push   $0x80107e51
80102237:	e8 44 e1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010223c:	83 ec 0c             	sub    $0xc,%esp
8010223f:	68 3f 7e 10 80       	push   $0x80107e3f
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
8010227a:	e8 91 2c 00 00       	call   80104f10 <acquire>
  ip->ref++;
8010227f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102283:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
8010228a:	e8 21 2c 00 00       	call   80104eb0 <release>
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
801022e7:	e8 84 2d 00 00       	call   80105070 <memmove>
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
8010234c:	e8 9f 29 00 00       	call   80104cf0 <holdingsleep>
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
8010236e:	e8 3d 29 00 00       	call   80104cb0 <releasesleep>
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
8010239b:	e8 d0 2c 00 00       	call   80105070 <memmove>
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
801023eb:	e8 00 29 00 00       	call   80104cf0 <holdingsleep>
801023f0:	83 c4 10             	add    $0x10,%esp
801023f3:	85 c0                	test   %eax,%eax
801023f5:	0f 84 91 00 00 00    	je     8010248c <namex+0x23c>
801023fb:	8b 46 08             	mov    0x8(%esi),%eax
801023fe:	85 c0                	test   %eax,%eax
80102400:	0f 8e 86 00 00 00    	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102406:	83 ec 0c             	sub    $0xc,%esp
80102409:	53                   	push   %ebx
8010240a:	e8 a1 28 00 00       	call   80104cb0 <releasesleep>
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
8010242d:	e8 be 28 00 00       	call   80104cf0 <holdingsleep>
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
80102450:	e8 9b 28 00 00       	call   80104cf0 <holdingsleep>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	85 c0                	test   %eax,%eax
8010245a:	74 30                	je     8010248c <namex+0x23c>
8010245c:	8b 7e 08             	mov    0x8(%esi),%edi
8010245f:	85 ff                	test   %edi,%edi
80102461:	7e 29                	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102463:	83 ec 0c             	sub    $0xc,%esp
80102466:	53                   	push   %ebx
80102467:	e8 44 28 00 00       	call   80104cb0 <releasesleep>
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
8010248f:	68 37 7e 10 80       	push   $0x80107e37
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
801024fd:	e8 2e 2c 00 00       	call   80105130 <strncpy>
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
8010253b:	68 60 7e 10 80       	push   $0x80107e60
80102540:	e8 3b de ff ff       	call   80100380 <panic>
    panic("dirlink");
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	68 f2 84 10 80       	push   $0x801084f2
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
8010265b:	68 cc 7e 10 80       	push   $0x80107ecc
80102660:	e8 1b dd ff ff       	call   80100380 <panic>
    panic("idestart");
80102665:	83 ec 0c             	sub    $0xc,%esp
80102668:	68 c3 7e 10 80       	push   $0x80107ec3
8010266d:	e8 0e dd ff ff       	call   80100380 <panic>
80102672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102680 <ideinit>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102686:	68 de 7e 10 80       	push   $0x80107ede
8010268b:	68 20 28 11 80       	push   $0x80112820
80102690:	e8 ab 26 00 00       	call   80104d40 <initlock>
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
8010270e:	e8 fd 27 00 00       	call   80104f10 <acquire>

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
8010278b:	e8 20 27 00 00       	call   80104eb0 <release>

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
801027ae:	e8 3d 25 00 00       	call   80104cf0 <holdingsleep>
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
801027e8:	e8 23 27 00 00       	call   80104f10 <acquire>

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
80102846:	e9 65 26 00 00       	jmp    80104eb0 <release>
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
8010286a:	68 0d 7f 10 80       	push   $0x80107f0d
8010286f:	e8 0c db ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102874:	83 ec 0c             	sub    $0xc,%esp
80102877:	68 f8 7e 10 80       	push   $0x80107ef8
8010287c:	e8 ff da ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102881:	83 ec 0c             	sub    $0xc,%esp
80102884:	68 e2 7e 10 80       	push   $0x80107ee2
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
801028da:	68 2c 7f 10 80       	push   $0x80107f2c
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
80102992:	81 fb b0 fe 12 80    	cmp    $0x8012feb0,%ebx
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
801029b2:	e8 19 26 00 00       	call   80104fd0 <memset>

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
801029e8:	e8 23 25 00 00       	call   80104f10 <acquire>
801029ed:	83 c4 10             	add    $0x10,%esp
801029f0:	eb d2                	jmp    801029c4 <kfree+0x44>
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029f8:	c7 45 08 60 28 11 80 	movl   $0x80112860,0x8(%ebp)
}
801029ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a02:	c9                   	leave  
    release(&kmem.lock);
80102a03:	e9 a8 24 00 00       	jmp    80104eb0 <release>
    panic("kfree");
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	68 5e 7f 10 80       	push   $0x80107f5e
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
80102adb:	68 64 7f 10 80       	push   $0x80107f64
80102ae0:	68 60 28 11 80       	push   $0x80112860
80102ae5:	e8 56 22 00 00       	call   80104d40 <initlock>
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
80102b73:	e8 98 23 00 00       	call   80104f10 <acquire>
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
80102ba1:	e8 0a 23 00 00       	call   80104eb0 <release>
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
80102beb:	0f b6 91 a0 80 10 80 	movzbl -0x7fef7f60(%ecx),%edx
  shift ^= togglecode[data];
80102bf2:	0f b6 81 a0 7f 10 80 	movzbl -0x7fef8060(%ecx),%eax
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
80102c0b:	8b 04 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%eax
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
80102c48:	0f b6 81 a0 80 10 80 	movzbl -0x7fef7f60(%ecx),%eax
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
80102fb7:	e8 64 20 00 00       	call   80105020 <memcmp>
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
801030e4:	e8 87 1f 00 00       	call   80105070 <memmove>
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
8010318a:	68 a0 81 10 80       	push   $0x801081a0
8010318f:	68 c0 28 11 80       	push   $0x801128c0
80103194:	e8 a7 1b 00 00       	call   80104d40 <initlock>
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
8010322b:	e8 e0 1c 00 00       	call   80104f10 <acquire>
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
8010327c:	e8 2f 1c 00 00       	call   80104eb0 <release>
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
8010329e:	e8 6d 1c 00 00       	call   80104f10 <acquire>
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
801032dc:	e8 cf 1b 00 00       	call   80104eb0 <release>
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
801032f6:	e8 15 1c 00 00       	call   80104f10 <acquire>
    wakeup(&log);
801032fb:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
    log.committing = 0;
80103302:	c7 05 00 29 11 80 00 	movl   $0x0,0x80112900
80103309:	00 00 00 
    wakeup(&log);
8010330c:	e8 af 12 00 00       	call   801045c0 <wakeup>
    release(&log.lock);
80103311:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
80103318:	e8 93 1b 00 00       	call   80104eb0 <release>
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
80103374:	e8 f7 1c 00 00       	call   80105070 <memmove>
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
801033d4:	e8 d7 1a 00 00       	call   80104eb0 <release>
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
801033e7:	68 a4 81 10 80       	push   $0x801081a4
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
80103436:	e8 d5 1a 00 00       	call   80104f10 <acquire>
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
80103475:	e9 36 1a 00 00       	jmp    80104eb0 <release>
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
801034a1:	68 b3 81 10 80       	push   $0x801081b3
801034a6:	e8 d5 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801034ab:	83 ec 0c             	sub    $0xc,%esp
801034ae:	68 c9 81 10 80       	push   $0x801081c9
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
801034d8:	68 e4 81 10 80       	push   $0x801081e4
801034dd:	e8 be d1 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801034e2:	e8 19 2f 00 00       	call   80106400 <idtinit>
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
80103506:	e8 e5 3f 00 00       	call   801074f0 <switchkvm>
  seginit();
8010350b:	e8 50 3f 00 00       	call   80107460 <seginit>
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
80103537:	68 b0 fe 12 80       	push   $0x8012feb0
8010353c:	e8 8f f5 ff ff       	call   80102ad0 <kinit1>
  kvmalloc();      // kernel page table
80103541:	e8 9a 44 00 00       	call   801079e0 <kvmalloc>
  mpinit();        // detect other processors
80103546:	e8 85 01 00 00       	call   801036d0 <mpinit>
  lapicinit();     // interrupt controller
8010354b:	e8 60 f7 ff ff       	call   80102cb0 <lapicinit>
  seginit();       // segment descriptors
80103550:	e8 0b 3f 00 00       	call   80107460 <seginit>
  picinit();       // disable pic
80103555:	e8 76 03 00 00       	call   801038d0 <picinit>
  ioapicinit();    // another interrupt controller
8010355a:	e8 31 f3 ff ff       	call   80102890 <ioapicinit>
  consoleinit();   // console hardware
8010355f:	e8 bc d9 ff ff       	call   80100f20 <consoleinit>
  uartinit();      // serial port
80103564:	e8 87 31 00 00       	call   801066f0 <uartinit>
  pinit();         // process table
80103569:	e8 22 08 00 00       	call   80103d90 <pinit>
  tvinit();        // trap vectors
8010356e:	e8 0d 2e 00 00       	call   80106380 <tvinit>
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
80103594:	e8 d7 1a 00 00       	call   80105070 <memmove>

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
8010367e:	68 f8 81 10 80       	push   $0x801081f8
80103683:	56                   	push   %esi
80103684:	e8 97 19 00 00       	call   80105020 <memcmp>
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
80103736:	68 fd 81 10 80       	push   $0x801081fd
8010373b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010373c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010373f:	e8 dc 18 00 00       	call   80105020 <memcmp>
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
80103853:	68 02 82 10 80       	push   $0x80108202
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
80103882:	68 f8 81 10 80       	push   $0x801081f8
80103887:	53                   	push   %ebx
80103888:	e8 93 17 00 00       	call   80105020 <memcmp>
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
801038b8:	68 1c 82 10 80       	push   $0x8010821c
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
80103963:	68 3b 82 10 80       	push   $0x8010823b
80103968:	50                   	push   %eax
80103969:	e8 d2 13 00 00       	call   80104d40 <initlock>
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
801039ff:	e8 0c 15 00 00       	call   80104f10 <acquire>
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
80103a44:	e9 67 14 00 00       	jmp    80104eb0 <release>
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 57 14 00 00       	call   80104eb0 <release>
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
80103a9d:	e8 6e 14 00 00       	call   80104f10 <acquire>
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
80103b2c:	e8 7f 13 00 00       	call   80104eb0 <release>
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
80103b82:	e8 29 13 00 00       	call   80104eb0 <release>
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
80103ba6:	e8 65 13 00 00       	call   80104f10 <acquire>
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
80103c3e:	e8 6d 12 00 00       	call   80104eb0 <release>
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
80103c59:	e8 52 12 00 00       	call   80104eb0 <release>
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
80103c81:	e8 8a 12 00 00       	call   80104f10 <acquire>
80103c86:	83 c4 10             	add    $0x10,%esp
80103c89:	eb 10                	jmp    80103c9b <allocproc+0x2b>
80103c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c90:	83 eb 80             	sub    $0xffffff80,%ebx
80103c93:	81 fb 34 e6 12 80    	cmp    $0x8012e634,%ebx
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
80103cc2:	e8 e9 11 00 00       	call   80104eb0 <release>

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
80103ce7:	c7 40 14 68 63 10 80 	movl   $0x80106368,0x14(%eax)
  p->context = (struct context *)sp;
80103cee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cf1:	6a 14                	push   $0x14
80103cf3:	6a 00                	push   $0x0
80103cf5:	50                   	push   %eax
80103cf6:	e8 d5 12 00 00       	call   80104fd0 <memset>
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
80103d1a:	e8 91 11 00 00       	call   80104eb0 <release>
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
80103d4b:	e8 60 11 00 00       	call   80104eb0 <release>

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
80103d96:	68 40 82 10 80       	push   $0x80108240
80103d9b:	68 00 c6 12 80       	push   $0x8012c600
80103da0:	e8 9b 0f 00 00       	call   80104d40 <initlock>
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
80103df8:	68 47 82 10 80       	push   $0x80108247
80103dfd:	e8 7e c5 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	68 98 83 10 80       	push   $0x80108398
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
80103e37:	e8 84 0f 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80103e3c:	e8 6f ff ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103e41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e47:	e8 c4 0f 00 00       	call   80104e10 <popcli>
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
80103e6e:	a3 34 e6 12 80       	mov    %eax,0x8012e634
  if ((p->pgdir = setupkvm()) == 0)
80103e73:	e8 e8 3a 00 00       	call   80107960 <setupkvm>
80103e78:	89 43 04             	mov    %eax,0x4(%ebx)
80103e7b:	85 c0                	test   %eax,%eax
80103e7d:	0f 84 bd 00 00 00    	je     80103f40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e83:	83 ec 04             	sub    $0x4,%esp
80103e86:	68 2c 00 00 00       	push   $0x2c
80103e8b:	68 60 b4 10 80       	push   $0x8010b460
80103e90:	50                   	push   %eax
80103e91:	e8 7a 37 00 00       	call   80107610 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e9f:	6a 4c                	push   $0x4c
80103ea1:	6a 00                	push   $0x0
80103ea3:	ff 73 18             	push   0x18(%ebx)
80103ea6:	e8 25 11 00 00       	call   80104fd0 <memset>
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
80103eff:	68 70 82 10 80       	push   $0x80108270
80103f04:	50                   	push   %eax
80103f05:	e8 86 12 00 00       	call   80105190 <safestrcpy>
  p->cwd = namei("/");
80103f0a:	c7 04 24 79 82 10 80 	movl   $0x80108279,(%esp)
80103f11:	e8 4a e6 ff ff       	call   80102560 <namei>
80103f16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f19:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80103f20:	e8 eb 0f 00 00       	call   80104f10 <acquire>
  p->state = RUNNABLE;
80103f25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f2c:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80103f33:	e8 78 0f 00 00       	call   80104eb0 <release>
}
80103f38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3b:	83 c4 10             	add    $0x10,%esp
80103f3e:	c9                   	leave  
80103f3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	68 57 82 10 80       	push   $0x80108257
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
80103f58:	e8 63 0e 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80103f5d:	e8 4e fe ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103f62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f68:	e8 a3 0e 00 00       	call   80104e10 <popcli>
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
80103f7b:	e8 80 35 00 00       	call   80107500 <switchuvm>
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
80103f9a:	e8 e1 37 00 00       	call   80107780 <allocuvm>
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
80103fba:	e8 f1 38 00 00       	call   801078b0 <deallocuvm>
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
80103fd9:	e8 e2 0d 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80103fde:	e8 cd fd ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103fe3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe9:	e8 22 0e 00 00       	call   80104e10 <popcli>
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
80104008:	e8 43 3a 00 00       	call   80107a50 <copyuvm>
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
80104081:	e8 0a 11 00 00       	call   80105190 <safestrcpy>
  pid = np->pid;
80104086:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104089:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80104090:	e8 7b 0e 00 00       	call   80104f10 <acquire>
  np->state = RUNNABLE;
80104095:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010409c:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801040a3:	e8 08 0e 00 00       	call   80104eb0 <release>
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
8010411e:	e8 ed 0d 00 00       	call   80104f10 <acquire>
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
80104140:	e8 bb 33 00 00       	call   80107500 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104145:	58                   	pop    %eax
80104146:	5a                   	pop    %edx
80104147:	ff 73 1c             	push   0x1c(%ebx)
8010414a:	57                   	push   %edi
      p->state = RUNNING;
8010414b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104152:	e8 94 10 00 00       	call   801051eb <swtch>
      switchkvm();
80104157:	e8 94 33 00 00       	call   801074f0 <switchkvm>
      c->proc = 0;
8010415c:	83 c4 10             	add    $0x10,%esp
8010415f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104166:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104169:	83 eb 80             	sub    $0xffffff80,%ebx
8010416c:	81 fb 34 e6 12 80    	cmp    $0x8012e634,%ebx
80104172:	75 bc                	jne    80104130 <scheduler+0x40>
    release(&ptable.lock);
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	68 00 c6 12 80       	push   $0x8012c600
8010417c:	e8 2f 0d 00 00       	call   80104eb0 <release>
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
80104195:	e8 26 0c 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
8010419a:	e8 11 fc ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010419f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a5:	e8 66 0c 00 00       	call   80104e10 <popcli>
  if (!holding(&ptable.lock))
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 00 c6 12 80       	push   $0x8012c600
801041b2:	e8 b9 0c 00 00       	call   80104e70 <holding>
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
801041f3:	e8 f3 0f 00 00       	call   801051eb <swtch>
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
80104210:	68 7b 82 10 80       	push   $0x8010827b
80104215:	e8 66 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 a7 82 10 80       	push   $0x801082a7
80104222:	e8 59 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	68 99 82 10 80       	push   $0x80108299
8010422f:	e8 4c c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 8d 82 10 80       	push   $0x8010828d
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
8010425e:	39 05 34 e6 12 80    	cmp    %eax,0x8012e634
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
801042ba:	e8 51 0c 00 00       	call   80104f10 <acquire>
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
801042d0:	83 e8 80             	sub    $0xffffff80,%eax
801042d3:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
801042d8:	74 1c                	je     801042f6 <exit+0xa6>
    if (p->state == SLEEPING && p->chan == chan)
801042da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042de:	75 f0                	jne    801042d0 <exit+0x80>
801042e0:	3b 50 20             	cmp    0x20(%eax),%edx
801042e3:	75 eb                	jne    801042d0 <exit+0x80>
      p->state = RUNNABLE;
801042e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ec:	83 e8 80             	sub    $0xffffff80,%eax
801042ef:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
801042f4:	75 e4                	jne    801042da <exit+0x8a>
      p->parent = initproc;
801042f6:	8b 0d 34 e6 12 80    	mov    0x8012e634,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042fc:	ba 34 c6 12 80       	mov    $0x8012c634,%edx
80104301:	eb 10                	jmp    80104313 <exit+0xc3>
80104303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104307:	90                   	nop
80104308:	83 ea 80             	sub    $0xffffff80,%edx
8010430b:	81 fa 34 e6 12 80    	cmp    $0x8012e634,%edx
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
80104330:	83 e8 80             	sub    $0xffffff80,%eax
80104333:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
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
8010435d:	68 c8 82 10 80       	push   $0x801082c8
80104362:	e8 19 c0 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	68 bb 82 10 80       	push   $0x801082bb
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
80104385:	e8 36 0a 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
8010438a:	e8 21 fa ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010438f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104395:	e8 76 0a 00 00       	call   80104e10 <popcli>
  acquire(&ptable.lock);
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 00 c6 12 80       	push   $0x8012c600
801043a2:	e8 69 0b 00 00       	call   80104f10 <acquire>
801043a7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043aa:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ac:	bb 34 c6 12 80       	mov    $0x8012c634,%ebx
801043b1:	eb 10                	jmp    801043c3 <wait+0x43>
801043b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b7:	90                   	nop
801043b8:	83 eb 80             	sub    $0xffffff80,%ebx
801043bb:	81 fb 34 e6 12 80    	cmp    $0x8012e634,%ebx
801043c1:	74 1b                	je     801043de <wait+0x5e>
      if (p->parent != curproc)
801043c3:	39 73 14             	cmp    %esi,0x14(%ebx)
801043c6:	75 f0                	jne    801043b8 <wait+0x38>
      if (p->state == ZOMBIE)
801043c8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043cc:	74 62                	je     80104430 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ce:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801043d1:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d6:	81 fb 34 e6 12 80    	cmp    $0x8012e634,%ebx
801043dc:	75 e5                	jne    801043c3 <wait+0x43>
    if (!havekids || curproc->killed)
801043de:	85 c0                	test   %eax,%eax
801043e0:	0f 84 a0 00 00 00    	je     80104486 <wait+0x106>
801043e6:	8b 46 24             	mov    0x24(%esi),%eax
801043e9:	85 c0                	test   %eax,%eax
801043eb:	0f 85 95 00 00 00    	jne    80104486 <wait+0x106>
  pushcli();
801043f1:	e8 ca 09 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
801043f6:	e8 b5 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801043fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104401:	e8 0a 0a 00 00       	call   80104e10 <popcli>
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
80104449:	e8 92 34 00 00       	call   801078e0 <freevm>
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
80104475:	e8 36 0a 00 00       	call   80104eb0 <release>
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
80104493:	e8 18 0a 00 00       	call   80104eb0 <release>
      return -1;
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	eb e0                	jmp    8010447d <wait+0xfd>
    panic("sleep");
8010449d:	83 ec 0c             	sub    $0xc,%esp
801044a0:	68 d4 82 10 80       	push   $0x801082d4
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
801044bc:	e8 4f 0a 00 00       	call   80104f10 <acquire>
  pushcli();
801044c1:	e8 fa 08 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
801044c6:	e8 e5 f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801044cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044d1:	e8 3a 09 00 00       	call   80104e10 <popcli>
  myproc()->state = RUNNABLE;
801044d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044dd:	e8 ae fc ff ff       	call   80104190 <sched>
  release(&ptable.lock);
801044e2:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801044e9:	e8 c2 09 00 00       	call   80104eb0 <release>
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
8010450f:	e8 ac 08 00 00       	call   80104dc0 <pushcli>
  c = mycpu();
80104514:	e8 97 f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104519:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010451f:	e8 ec 08 00 00       	call   80104e10 <popcli>
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
80104540:	e8 cb 09 00 00       	call   80104f10 <acquire>
    release(lk);
80104545:	89 34 24             	mov    %esi,(%esp)
80104548:	e8 63 09 00 00       	call   80104eb0 <release>
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
8010456a:	e8 41 09 00 00       	call   80104eb0 <release>
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
8010457c:	e9 8f 09 00 00       	jmp    80104f10 <acquire>
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
801045a9:	68 da 82 10 80       	push   $0x801082da
801045ae:	e8 cd bd ff ff       	call   80100380 <panic>
    panic("sleep");
801045b3:	83 ec 0c             	sub    $0xc,%esp
801045b6:	68 d4 82 10 80       	push   $0x801082d4
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
801045cf:	e8 3c 09 00 00       	call   80104f10 <acquire>
801045d4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045d7:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
801045dc:	eb 0c                	jmp    801045ea <wakeup+0x2a>
801045de:	66 90                	xchg   %ax,%ax
801045e0:	83 e8 80             	sub    $0xffffff80,%eax
801045e3:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
801045e8:	74 1c                	je     80104606 <wakeup+0x46>
    if (p->state == SLEEPING && p->chan == chan)
801045ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ee:	75 f0                	jne    801045e0 <wakeup+0x20>
801045f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801045f3:	75 eb                	jne    801045e0 <wakeup+0x20>
      p->state = RUNNABLE;
801045f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045fc:	83 e8 80             	sub    $0xffffff80,%eax
801045ff:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
80104604:	75 e4                	jne    801045ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104606:	c7 45 08 00 c6 12 80 	movl   $0x8012c600,0x8(%ebp)
}
8010460d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104610:	c9                   	leave  
  release(&ptable.lock);
80104611:	e9 9a 08 00 00       	jmp    80104eb0 <release>
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
8010462f:	e8 dc 08 00 00       	call   80104f10 <acquire>
80104634:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104637:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
8010463c:	eb 0c                	jmp    8010464a <kill+0x2a>
8010463e:	66 90                	xchg   %ax,%ax
80104640:	83 e8 80             	sub    $0xffffff80,%eax
80104643:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
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
8010466b:	e8 40 08 00 00       	call   80104eb0 <release>
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
80104688:	e8 23 08 00 00       	call   80104eb0 <release>
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
801046bb:	68 0b 87 10 80       	push   $0x8010870b
801046c0:	e8 db bf ff ff       	call   801006a0 <cprintf>
801046c5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c8:	83 eb 80             	sub    $0xffffff80,%ebx
801046cb:	81 fb a0 e6 12 80    	cmp    $0x8012e6a0,%ebx
801046d1:	0f 84 81 00 00 00    	je     80104758 <procdump+0xb8>
    if (p->state == UNUSED)
801046d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046da:	85 c0                	test   %eax,%eax
801046dc:	74 ea                	je     801046c8 <procdump+0x28>
      state = "???";
801046de:	ba eb 82 10 80       	mov    $0x801082eb,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046e3:	83 f8 05             	cmp    $0x5,%eax
801046e6:	77 11                	ja     801046f9 <procdump+0x59>
801046e8:	8b 14 85 d8 83 10 80 	mov    -0x7fef7c28(,%eax,4),%edx
      state = "???";
801046ef:	b8 eb 82 10 80       	mov    $0x801082eb,%eax
801046f4:	85 d2                	test   %edx,%edx
801046f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046f9:	53                   	push   %ebx
801046fa:	52                   	push   %edx
801046fb:	ff 73 a4             	push   -0x5c(%ebx)
801046fe:	68 ef 82 10 80       	push   $0x801082ef
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
80104725:	e8 36 06 00 00       	call   80104d60 <getcallerpcs>
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
8010473d:	68 01 7d 10 80       	push   $0x80107d01
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
801047cd:	68 f8 82 10 80       	push   $0x801082f8
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
801047f1:	68 fd 82 10 80       	push   $0x801082fd
801047f6:	e8 a5 be ff ff       	call   801006a0 <cprintf>
}
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5f                   	pop    %edi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
80104806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480d:	8d 76 00             	lea    0x0(%esi),%esi

80104810 <get_state_name>:

char* get_state_name(int state)
{
80104810:	55                   	push   %ebp
80104811:	b8 0c 87 10 80       	mov    $0x8010870c,%eax
80104816:	89 e5                	mov    %esp,%ebp
80104818:	8b 55 08             	mov    0x8(%ebp),%edx
8010481b:	83 fa 05             	cmp    $0x5,%edx
8010481e:	77 07                	ja     80104827 <get_state_name+0x17>
80104820:	8b 04 95 c0 83 10 80 	mov    -0x7fef7c40(,%edx,4),%eax
  else if (state == 5) 
    return "ZOMBIE";
  
  else 
    return "";
}
80104827:	5d                   	pop    %ebp
80104828:	c3                   	ret    
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <get_queue_name>:

char* get_queue_name(int level)
{
80104830:	55                   	push   %ebp
  if (level == 1)
    return "RoundRobin";
80104831:	b8 00 83 10 80       	mov    $0x80108300,%eax
{
80104836:	89 e5                	mov    %esp,%ebp
80104838:	8b 55 08             	mov    0x8(%ebp),%edx
  if (level == 1)
8010483b:	83 fa 01             	cmp    $0x1,%edx
8010483e:	74 1a                	je     8010485a <get_queue_name+0x2a>

  else if (level == 2)
    return "Lottery";
80104840:	b8 0b 83 10 80       	mov    $0x8010830b,%eax
  else if (level == 2)
80104845:	83 fa 02             	cmp    $0x2,%edx
80104848:	74 10                	je     8010485a <get_queue_name+0x2a>

  else if (level == 3)
    return "BJF"; 

  else
    return "Undefined";
8010484a:	83 fa 03             	cmp    $0x3,%edx
8010484d:	b8 13 83 10 80       	mov    $0x80108313,%eax
80104852:	ba 17 83 10 80       	mov    $0x80108317,%edx
80104857:	0f 45 c2             	cmovne %edx,%eax
}
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <get_num_len>:

int get_num_len(int number)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	8b 55 08             	mov    0x8(%ebp),%edx
80104867:	53                   	push   %ebx
  int len = 0;
80104868:	31 db                	xor    %ebx,%ebx
  while (number > 0)
8010486a:	85 d2                	test   %edx,%edx
8010486c:	7e 1b                	jle    80104889 <get_num_len+0x29>
  {
    len++;
    number = number / 10;
8010486e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
80104878:	89 d0                	mov    %edx,%eax
8010487a:	89 d1                	mov    %edx,%ecx
    len++;
8010487c:	83 c3 01             	add    $0x1,%ebx
    number = number / 10;
8010487f:	f7 e6                	mul    %esi
80104881:	c1 ea 03             	shr    $0x3,%edx
  while (number > 0)
80104884:	83 f9 09             	cmp    $0x9,%ecx
80104887:	7f ef                	jg     80104878 <get_num_len+0x18>
  }
  return len;
}
80104889:	89 d8                	mov    %ebx,%eax
8010488b:	5b                   	pop    %ebx
8010488c:	5e                   	pop    %esi
8010488d:	5d                   	pop    %ebp
8010488e:	c3                   	ret    
8010488f:	90                   	nop

80104890 <print_all_procs_status>:


void print_all_procs_status()
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	53                   	push   %ebx
  struct proc *p;

  cprintf("name");
80104896:	bb 0a 00 00 00       	mov    $0xa,%ebx
{
8010489b:	83 ec 28             	sub    $0x28,%esp
  cprintf("name");
8010489e:	68 21 83 10 80       	push   $0x80108321
801048a3:	e8 f8 bd ff ff       	call   801006a0 <cprintf>
801048a8:	83 c4 10             	add    $0x10,%esp
  for (int i = 0 ; i < 10 ; i++)
    cprintf(" ");
801048ab:	83 ec 0c             	sub    $0xc,%esp
801048ae:	68 8e 83 10 80       	push   $0x8010838e
801048b3:	e8 e8 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 10 ; i++)
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	83 eb 01             	sub    $0x1,%ebx
801048be:	75 eb                	jne    801048ab <print_all_procs_status+0x1b>

  cprintf("pid");
801048c0:	83 ec 0c             	sub    $0xc,%esp
801048c3:	bb 06 00 00 00       	mov    $0x6,%ebx
801048c8:	68 26 83 10 80       	push   $0x80108326
801048cd:	e8 ce bd ff ff       	call   801006a0 <cprintf>
801048d2:	83 c4 10             	add    $0x10,%esp
  for (int i = 0 ; i < 6 ; i++)
    cprintf(" ");
801048d5:	83 ec 0c             	sub    $0xc,%esp
801048d8:	68 8e 83 10 80       	push   $0x8010838e
801048dd:	e8 be bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 6 ; i++)
801048e2:	83 c4 10             	add    $0x10,%esp
801048e5:	83 eb 01             	sub    $0x1,%ebx
801048e8:	75 eb                	jne    801048d5 <print_all_procs_status+0x45>

  cprintf("state");
801048ea:	83 ec 0c             	sub    $0xc,%esp
801048ed:	bb 08 00 00 00       	mov    $0x8,%ebx
801048f2:	68 2a 83 10 80       	push   $0x8010832a
801048f7:	e8 a4 bd ff ff       	call   801006a0 <cprintf>
801048fc:	83 c4 10             	add    $0x10,%esp
  for (int i = 0 ; i < 8 ; i++)
    cprintf(" ");
801048ff:	83 ec 0c             	sub    $0xc,%esp
80104902:	68 8e 83 10 80       	push   $0x8010838e
80104907:	e8 94 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 8 ; i++)
8010490c:	83 c4 10             	add    $0x10,%esp
8010490f:	83 eb 01             	sub    $0x1,%ebx
80104912:	75 eb                	jne    801048ff <print_all_procs_status+0x6f>

  cprintf("queue_level");
80104914:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0 ; i < 5 ; i++)
    cprintf(" ");

  cprintf("\n");
80104917:	bb 32 00 00 00       	mov    $0x32,%ebx
  cprintf("queue_level");
8010491c:	68 30 83 10 80       	push   $0x80108330
80104921:	e8 7a bd ff ff       	call   801006a0 <cprintf>
    cprintf(" ");
80104926:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
8010492d:	e8 6e bd ff ff       	call   801006a0 <cprintf>
80104932:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
80104939:	e8 62 bd ff ff       	call   801006a0 <cprintf>
8010493e:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
80104945:	e8 56 bd ff ff       	call   801006a0 <cprintf>
8010494a:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
80104951:	e8 4a bd ff ff       	call   801006a0 <cprintf>
80104956:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
8010495d:	e8 3e bd ff ff       	call   801006a0 <cprintf>
  cprintf("\n");
80104962:	c7 04 24 0b 87 10 80 	movl   $0x8010870b,(%esp)
80104969:	e8 32 bd ff ff       	call   801006a0 <cprintf>
8010496e:	83 c4 10             	add    $0x10,%esp
80104971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 0 ; i < 50 ; i++)
    cprintf("-");
80104978:	83 ec 0c             	sub    $0xc,%esp
8010497b:	68 3c 83 10 80       	push   $0x8010833c
80104980:	e8 1b bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 50 ; i++)
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	83 eb 01             	sub    $0x1,%ebx
8010498b:	75 eb                	jne    80104978 <print_all_procs_status+0xe8>
  cprintf("\n");
8010498d:	83 ec 0c             	sub    $0xc,%esp
80104990:	bf a0 c6 12 80       	mov    $0x8012c6a0,%edi
80104995:	68 0b 87 10 80       	push   $0x8010870b
8010499a:	e8 01 bd ff ff       	call   801006a0 <cprintf>

  acquire(&ptable.lock);                                                  // Lock procs table to get current information (in order to stop procs table changing)
8010499f:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801049a6:	e8 65 05 00 00       	call   80104f10 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
801049ab:	83 c4 10             	add    $0x10,%esp
801049ae:	eb 10                	jmp    801049c0 <print_all_procs_status+0x130>
801049b0:	83 ef 80             	sub    $0xffffff80,%edi
801049b3:	b8 a0 e6 12 80       	mov    $0x8012e6a0,%eax
801049b8:	39 f8                	cmp    %edi,%eax
801049ba:	0f 84 e3 01 00 00    	je     80104ba3 <print_all_procs_status+0x313>
    if (p->state == UNUSED)
801049c0:	8b 47 a0             	mov    -0x60(%edi),%eax
801049c3:	85 c0                	test   %eax,%eax
801049c5:	74 e9                	je     801049b0 <print_all_procs_status+0x120>
      continue;

    cprintf(p->name);
801049c7:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
801049ca:	31 db                	xor    %ebx,%ebx
801049cc:	be 0f 00 00 00       	mov    $0xf,%esi
    cprintf(p->name);
801049d1:	57                   	push   %edi
801049d2:	e8 c9 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
801049d7:	83 c4 10             	add    $0x10,%esp
801049da:	eb 17                	jmp    801049f3 <print_all_procs_status+0x163>
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" ");
801049e0:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
801049e3:	83 c3 01             	add    $0x1,%ebx
      cprintf(" ");
801049e6:	68 8e 83 10 80       	push   $0x8010838e
801049eb:	e8 b0 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
801049f0:	83 c4 10             	add    $0x10,%esp
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	57                   	push   %edi
801049f7:	e8 d4 07 00 00       	call   801051d0 <strlen>
801049fc:	83 c4 10             	add    $0x10,%esp
801049ff:	89 c2                	mov    %eax,%edx
80104a01:	89 f0                	mov    %esi,%eax
80104a03:	29 d0                	sub    %edx,%eax
80104a05:	39 d8                	cmp    %ebx,%eax
80104a07:	7f d7                	jg     801049e0 <print_all_procs_status+0x150>

    cprintf("%d", p->pid);
80104a09:	83 ec 08             	sub    $0x8,%esp
80104a0c:	ff 77 a4             	push   -0x5c(%edi)
    number = number / 10;
80104a0f:	be cd cc cc cc       	mov    $0xcccccccd,%esi
    cprintf("%d", p->pid);
80104a14:	68 fd 82 10 80       	push   $0x801082fd
80104a19:	e8 82 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 7 - get_num_len(p->pid) ; i++)
80104a1e:	31 c0                	xor    %eax,%eax
80104a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104a23:	83 c4 10             	add    $0x10,%esp
80104a26:	89 c7                	mov    %eax,%edi
80104a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a2b:	8b 50 a4             	mov    -0x5c(%eax),%edx
  while (number > 0)
80104a2e:	85 d2                	test   %edx,%edx
80104a30:	7e 47                	jle    80104a79 <print_all_procs_status+0x1e9>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int len = 0;
80104a38:	31 db                	xor    %ebx,%ebx
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    number = number / 10;
80104a40:	89 d0                	mov    %edx,%eax
80104a42:	89 d1                	mov    %edx,%ecx
    len++;
80104a44:	83 c3 01             	add    $0x1,%ebx
    number = number / 10;
80104a47:	f7 e6                	mul    %esi
80104a49:	c1 ea 03             	shr    $0x3,%edx
  while (number > 0)
80104a4c:	83 f9 09             	cmp    $0x9,%ecx
80104a4f:	7f ef                	jg     80104a40 <print_all_procs_status+0x1b0>
    for (int i = 0 ; i < 7 - get_num_len(p->pid) ; i++)
80104a51:	b8 07 00 00 00       	mov    $0x7,%eax
80104a56:	29 d8                	sub    %ebx,%eax
80104a58:	39 c7                	cmp    %eax,%edi
80104a5a:	7d 2c                	jge    80104a88 <print_all_procs_status+0x1f8>
      cprintf(" ");
80104a5c:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 7 - get_num_len(p->pid) ; i++)
80104a5f:	83 c7 01             	add    $0x1,%edi
      cprintf(" ");
80104a62:	68 8e 83 10 80       	push   $0x8010838e
80104a67:	e8 34 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 7 - get_num_len(p->pid) ; i++)
80104a6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	8b 50 a4             	mov    -0x5c(%eax),%edx
  while (number > 0)
80104a75:	85 d2                	test   %edx,%edx
80104a77:	7f bf                	jg     80104a38 <print_all_procs_status+0x1a8>
80104a79:	b8 07 00 00 00       	mov    $0x7,%eax
    for (int i = 0 ; i < 7 - get_num_len(p->pid) ; i++)
80104a7e:	39 c7                	cmp    %eax,%edi
80104a80:	7c da                	jl     80104a5c <print_all_procs_status+0x1cc>
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    cprintf(get_state_name(p->state));
80104a88:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104a8b:	b8 0c 87 10 80       	mov    $0x8010870c,%eax
80104a90:	8b 57 a0             	mov    -0x60(%edi),%edx
  if (state == 0)
80104a93:	83 fa 05             	cmp    $0x5,%edx
80104a96:	77 07                	ja     80104a9f <print_all_procs_status+0x20f>
80104a98:	8b 04 95 c0 83 10 80 	mov    -0x7fef7c40(,%edx,4),%eax
    cprintf(get_state_name(p->state));
80104a9f:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104aa2:	31 db                	xor    %ebx,%ebx
80104aa4:	be 0f 00 00 00       	mov    $0xf,%esi
    cprintf(get_state_name(p->state));
80104aa9:	50                   	push   %eax
80104aaa:	e8 f1 bb ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104aaf:	83 c4 10             	add    $0x10,%esp
80104ab2:	eb 17                	jmp    80104acb <print_all_procs_status+0x23b>
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" "); 
80104ab8:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104abb:	83 c3 01             	add    $0x1,%ebx
      cprintf(" "); 
80104abe:	68 8e 83 10 80       	push   $0x8010838e
80104ac3:	e8 d8 bb ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104ac8:	83 c4 10             	add    $0x10,%esp
80104acb:	8b 57 a0             	mov    -0x60(%edi),%edx
80104ace:	b8 0c 87 10 80       	mov    $0x8010870c,%eax
80104ad3:	83 fa 05             	cmp    $0x5,%edx
80104ad6:	77 07                	ja     80104adf <print_all_procs_status+0x24f>
80104ad8:	8b 04 95 c0 83 10 80 	mov    -0x7fef7c40(,%edx,4),%eax
80104adf:	83 ec 0c             	sub    $0xc,%esp
80104ae2:	50                   	push   %eax
80104ae3:	e8 e8 06 00 00       	call   801051d0 <strlen>
80104ae8:	83 c4 10             	add    $0x10,%esp
80104aeb:	89 c2                	mov    %eax,%edx
80104aed:	89 f0                	mov    %esi,%eax
80104aef:	29 d0                	sub    %edx,%eax
80104af1:	39 d8                	cmp    %ebx,%eax
80104af3:	7f c3                	jg     80104ab8 <print_all_procs_status+0x228>

    cprintf(get_queue_name(p->queue));
80104af5:	8b 57 10             	mov    0x10(%edi),%edx
    return "RoundRobin";
80104af8:	b8 00 83 10 80       	mov    $0x80108300,%eax
  if (level == 1)
80104afd:	83 fa 01             	cmp    $0x1,%edx
80104b00:	74 1a                	je     80104b1c <print_all_procs_status+0x28c>
    return "Lottery";
80104b02:	b8 0b 83 10 80       	mov    $0x8010830b,%eax
  else if (level == 2)
80104b07:	83 fa 02             	cmp    $0x2,%edx
80104b0a:	74 10                	je     80104b1c <print_all_procs_status+0x28c>
    return "Undefined";
80104b0c:	83 fa 03             	cmp    $0x3,%edx
80104b0f:	b8 13 83 10 80       	mov    $0x80108313,%eax
80104b14:	ba 17 83 10 80       	mov    $0x80108317,%edx
80104b19:	0f 45 c2             	cmovne %edx,%eax
    cprintf(get_queue_name(p->queue));
80104b1c:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(get_queue_name(p->state)) ; i++)
80104b1f:	31 db                	xor    %ebx,%ebx
    cprintf(get_queue_name(p->queue));
80104b21:	50                   	push   %eax
80104b22:	e8 79 bb ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(get_queue_name(p->state)) ; i++)
80104b27:	83 c4 10             	add    $0x10,%esp
80104b2a:	eb 17                	jmp    80104b43 <print_all_procs_status+0x2b3>
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" "); 
80104b30:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(get_queue_name(p->state)) ; i++)
80104b33:	83 c3 01             	add    $0x1,%ebx
      cprintf(" "); 
80104b36:	68 8e 83 10 80       	push   $0x8010838e
80104b3b:	e8 60 bb ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(get_queue_name(p->state)) ; i++)
80104b40:	83 c4 10             	add    $0x10,%esp
80104b43:	8b 57 a0             	mov    -0x60(%edi),%edx
    return "RoundRobin";
80104b46:	b8 00 83 10 80       	mov    $0x80108300,%eax
  if (level == 1)
80104b4b:	83 fa 01             	cmp    $0x1,%edx
80104b4e:	74 1a                	je     80104b6a <print_all_procs_status+0x2da>
    return "Lottery";
80104b50:	b8 0b 83 10 80       	mov    $0x8010830b,%eax
  else if (level == 2)
80104b55:	83 fa 02             	cmp    $0x2,%edx
80104b58:	74 10                	je     80104b6a <print_all_procs_status+0x2da>
    return "Undefined";
80104b5a:	83 fa 03             	cmp    $0x3,%edx
80104b5d:	b8 13 83 10 80       	mov    $0x80108313,%eax
80104b62:	ba 17 83 10 80       	mov    $0x80108317,%edx
80104b67:	0f 45 c2             	cmovne %edx,%eax
    for (int i = 0 ; i < 15 - strlen(get_queue_name(p->state)) ; i++)
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	50                   	push   %eax
80104b6e:	e8 5d 06 00 00       	call   801051d0 <strlen>
80104b73:	83 c4 10             	add    $0x10,%esp
80104b76:	89 c2                	mov    %eax,%edx
80104b78:	b8 0f 00 00 00       	mov    $0xf,%eax
80104b7d:	29 d0                	sub    %edx,%eax
80104b7f:	39 d8                	cmp    %ebx,%eax
80104b81:	7f ad                	jg     80104b30 <print_all_procs_status+0x2a0>

    cprintf("\n");
80104b83:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104b86:	83 ef 80             	sub    $0xffffff80,%edi
    cprintf("\n");
80104b89:	68 0b 87 10 80       	push   $0x8010870b
80104b8e:	e8 0d bb ff ff       	call   801006a0 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104b93:	b8 a0 e6 12 80       	mov    $0x8012e6a0,%eax
    cprintf("\n");
80104b98:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104b9b:	39 f8                	cmp    %edi,%eax
80104b9d:	0f 85 1d fe ff ff    	jne    801049c0 <print_all_procs_status+0x130>
  }
  release(&ptable.lock);
80104ba3:	83 ec 0c             	sub    $0xc,%esp
80104ba6:	68 00 c6 12 80       	push   $0x8012c600
80104bab:	e8 00 03 00 00       	call   80104eb0 <release>

}
80104bb0:	83 c4 10             	add    $0x10,%esp
80104bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb6:	5b                   	pop    %ebx
80104bb7:	5e                   	pop    %esi
80104bb8:	5f                   	pop    %edi
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop

80104bc0 <set_proc_queue>:

void set_proc_queue(int pid, int queue_level)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 75 0c             	mov    0xc(%ebp),%esi
80104bc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104bcb:	83 ec 0c             	sub    $0xc,%esp
80104bce:	68 00 c6 12 80       	push   $0x8012c600
80104bd3:	e8 38 03 00 00       	call   80104f10 <acquire>
80104bd8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bdb:	b8 34 c6 12 80       	mov    $0x8012c634,%eax
    if (p->pid == pid)
80104be0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104be3:	75 03                	jne    80104be8 <set_proc_queue+0x28>
      p->queue = queue_level;
80104be5:	89 70 7c             	mov    %esi,0x7c(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be8:	83 e8 80             	sub    $0xffffff80,%eax
80104beb:	3d 34 e6 12 80       	cmp    $0x8012e634,%eax
80104bf0:	75 ee                	jne    80104be0 <set_proc_queue+0x20>

  release(&ptable.lock);
80104bf2:	c7 45 08 00 c6 12 80 	movl   $0x8012c600,0x8(%ebp)
80104bf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bfc:	5b                   	pop    %ebx
80104bfd:	5e                   	pop    %esi
80104bfe:	5d                   	pop    %ebp
  release(&ptable.lock);
80104bff:	e9 ac 02 00 00       	jmp    80104eb0 <release>
80104c04:	66 90                	xchg   %ax,%ax
80104c06:	66 90                	xchg   %ax,%ax
80104c08:	66 90                	xchg   %ax,%ax
80104c0a:	66 90                	xchg   %ax,%ax
80104c0c:	66 90                	xchg   %ax,%ax
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c1a:	68 f0 83 10 80       	push   $0x801083f0
80104c1f:	8d 43 04             	lea    0x4(%ebx),%eax
80104c22:	50                   	push   %eax
80104c23:	e8 18 01 00 00       	call   80104d40 <initlock>
  lk->name = name;
80104c28:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c2b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c31:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c34:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c3b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c41:	c9                   	leave  
80104c42:	c3                   	ret    
80104c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c50 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c58:	8d 73 04             	lea    0x4(%ebx),%esi
80104c5b:	83 ec 0c             	sub    $0xc,%esp
80104c5e:	56                   	push   %esi
80104c5f:	e8 ac 02 00 00       	call   80104f10 <acquire>
  while (lk->locked) {
80104c64:	8b 13                	mov    (%ebx),%edx
80104c66:	83 c4 10             	add    $0x10,%esp
80104c69:	85 d2                	test   %edx,%edx
80104c6b:	74 16                	je     80104c83 <acquiresleep+0x33>
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c70:	83 ec 08             	sub    $0x8,%esp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	e8 86 f8 ff ff       	call   80104500 <sleep>
  while (lk->locked) {
80104c7a:	8b 03                	mov    (%ebx),%eax
80104c7c:	83 c4 10             	add    $0x10,%esp
80104c7f:	85 c0                	test   %eax,%eax
80104c81:	75 ed                	jne    80104c70 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c83:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c89:	e8 a2 f1 ff ff       	call   80103e30 <myproc>
80104c8e:	8b 40 10             	mov    0x10(%eax),%eax
80104c91:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c94:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c9a:	5b                   	pop    %ebx
80104c9b:	5e                   	pop    %esi
80104c9c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c9d:	e9 0e 02 00 00       	jmp    80104eb0 <release>
80104ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cb0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
80104cb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cb8:	8d 73 04             	lea    0x4(%ebx),%esi
80104cbb:	83 ec 0c             	sub    $0xc,%esp
80104cbe:	56                   	push   %esi
80104cbf:	e8 4c 02 00 00       	call   80104f10 <acquire>
  lk->locked = 0;
80104cc4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104cd1:	89 1c 24             	mov    %ebx,(%esp)
80104cd4:	e8 e7 f8 ff ff       	call   801045c0 <wakeup>
  release(&lk->lk);
80104cd9:	89 75 08             	mov    %esi,0x8(%ebp)
80104cdc:	83 c4 10             	add    $0x10,%esp
}
80104cdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce2:	5b                   	pop    %ebx
80104ce3:	5e                   	pop    %esi
80104ce4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ce5:	e9 c6 01 00 00       	jmp    80104eb0 <release>
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cf0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	31 ff                	xor    %edi,%edi
80104cf6:	56                   	push   %esi
80104cf7:	53                   	push   %ebx
80104cf8:	83 ec 18             	sub    $0x18,%esp
80104cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104cfe:	8d 73 04             	lea    0x4(%ebx),%esi
80104d01:	56                   	push   %esi
80104d02:	e8 09 02 00 00       	call   80104f10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d07:	8b 03                	mov    (%ebx),%eax
80104d09:	83 c4 10             	add    $0x10,%esp
80104d0c:	85 c0                	test   %eax,%eax
80104d0e:	75 18                	jne    80104d28 <holdingsleep+0x38>
  release(&lk->lk);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	56                   	push   %esi
80104d14:	e8 97 01 00 00       	call   80104eb0 <release>
  return r;
}
80104d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d1c:	89 f8                	mov    %edi,%eax
80104d1e:	5b                   	pop    %ebx
80104d1f:	5e                   	pop    %esi
80104d20:	5f                   	pop    %edi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d27:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104d28:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d2b:	e8 00 f1 ff ff       	call   80103e30 <myproc>
80104d30:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d33:	0f 94 c0             	sete   %al
80104d36:	0f b6 c0             	movzbl %al,%eax
80104d39:	89 c7                	mov    %eax,%edi
80104d3b:	eb d3                	jmp    80104d10 <holdingsleep+0x20>
80104d3d:	66 90                	xchg   %ax,%ax
80104d3f:	90                   	nop

80104d40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d59:	5d                   	pop    %ebp
80104d5a:	c3                   	ret    
80104d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop

80104d60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d61:	31 d2                	xor    %edx,%edx
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d6c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104d6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d7c:	77 1a                	ja     80104d98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d89:	83 fa 0a             	cmp    $0xa,%edx
80104d8c:	75 e2                	jne    80104d70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d91:	c9                   	leave  
80104d92:	c3                   	ret    
80104d93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d97:	90                   	nop
  for(; i < 10; i++)
80104d98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d9b:	8d 51 28             	lea    0x28(%ecx),%edx
80104d9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104da6:	83 c0 04             	add    $0x4,%eax
80104da9:	39 d0                	cmp    %edx,%eax
80104dab:	75 f3                	jne    80104da0 <getcallerpcs+0x40>
}
80104dad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db0:	c9                   	leave  
80104db1:	c3                   	ret    
80104db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
80104dc4:	83 ec 04             	sub    $0x4,%esp
80104dc7:	9c                   	pushf  
80104dc8:	5b                   	pop    %ebx
  asm volatile("cli");
80104dc9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104dca:	e8 e1 ef ff ff       	call   80103db0 <mycpu>
80104dcf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	74 17                	je     80104df0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104dd9:	e8 d2 ef ff ff       	call   80103db0 <mycpu>
80104dde:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de8:	c9                   	leave  
80104de9:	c3                   	ret    
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104df0:	e8 bb ef ff ff       	call   80103db0 <mycpu>
80104df5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104dfb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104e01:	eb d6                	jmp    80104dd9 <pushcli+0x19>
80104e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e10 <popcli>:

void
popcli(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e16:	9c                   	pushf  
80104e17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e18:	f6 c4 02             	test   $0x2,%ah
80104e1b:	75 35                	jne    80104e52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e1d:	e8 8e ef ff ff       	call   80103db0 <mycpu>
80104e22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e29:	78 34                	js     80104e5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e2b:	e8 80 ef ff ff       	call   80103db0 <mycpu>
80104e30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e36:	85 d2                	test   %edx,%edx
80104e38:	74 06                	je     80104e40 <popcli+0x30>
    sti();
}
80104e3a:	c9                   	leave  
80104e3b:	c3                   	ret    
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e40:	e8 6b ef ff ff       	call   80103db0 <mycpu>
80104e45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e4b:	85 c0                	test   %eax,%eax
80104e4d:	74 eb                	je     80104e3a <popcli+0x2a>
  asm volatile("sti");
80104e4f:	fb                   	sti    
}
80104e50:	c9                   	leave  
80104e51:	c3                   	ret    
    panic("popcli - interruptible");
80104e52:	83 ec 0c             	sub    $0xc,%esp
80104e55:	68 fb 83 10 80       	push   $0x801083fb
80104e5a:	e8 21 b5 ff ff       	call   80100380 <panic>
    panic("popcli");
80104e5f:	83 ec 0c             	sub    $0xc,%esp
80104e62:	68 12 84 10 80       	push   $0x80108412
80104e67:	e8 14 b5 ff ff       	call   80100380 <panic>
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e70 <holding>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
80104e75:	8b 75 08             	mov    0x8(%ebp),%esi
80104e78:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e7a:	e8 41 ff ff ff       	call   80104dc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e7f:	8b 06                	mov    (%esi),%eax
80104e81:	85 c0                	test   %eax,%eax
80104e83:	75 0b                	jne    80104e90 <holding+0x20>
  popcli();
80104e85:	e8 86 ff ff ff       	call   80104e10 <popcli>
}
80104e8a:	89 d8                	mov    %ebx,%eax
80104e8c:	5b                   	pop    %ebx
80104e8d:	5e                   	pop    %esi
80104e8e:	5d                   	pop    %ebp
80104e8f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104e90:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e93:	e8 18 ef ff ff       	call   80103db0 <mycpu>
80104e98:	39 c3                	cmp    %eax,%ebx
80104e9a:	0f 94 c3             	sete   %bl
  popcli();
80104e9d:	e8 6e ff ff ff       	call   80104e10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104ea2:	0f b6 db             	movzbl %bl,%ebx
}
80104ea5:	89 d8                	mov    %ebx,%eax
80104ea7:	5b                   	pop    %ebx
80104ea8:	5e                   	pop    %esi
80104ea9:	5d                   	pop    %ebp
80104eaa:	c3                   	ret    
80104eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eaf:	90                   	nop

80104eb0 <release>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
80104eb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104eb8:	e8 03 ff ff ff       	call   80104dc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ebd:	8b 03                	mov    (%ebx),%eax
80104ebf:	85 c0                	test   %eax,%eax
80104ec1:	75 15                	jne    80104ed8 <release+0x28>
  popcli();
80104ec3:	e8 48 ff ff ff       	call   80104e10 <popcli>
    panic("release");
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	68 19 84 10 80       	push   $0x80108419
80104ed0:	e8 ab b4 ff ff       	call   80100380 <panic>
80104ed5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ed8:	8b 73 08             	mov    0x8(%ebx),%esi
80104edb:	e8 d0 ee ff ff       	call   80103db0 <mycpu>
80104ee0:	39 c6                	cmp    %eax,%esi
80104ee2:	75 df                	jne    80104ec3 <release+0x13>
  popcli();
80104ee4:	e8 27 ff ff ff       	call   80104e10 <popcli>
  lk->pcs[0] = 0;
80104ee9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ef0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ef7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104efc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f05:	5b                   	pop    %ebx
80104f06:	5e                   	pop    %esi
80104f07:	5d                   	pop    %ebp
  popcli();
80104f08:	e9 03 ff ff ff       	jmp    80104e10 <popcli>
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi

80104f10 <acquire>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f17:	e8 a4 fe ff ff       	call   80104dc0 <pushcli>
  if(holding(lk))
80104f1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104f1f:	e8 9c fe ff ff       	call   80104dc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f24:	8b 03                	mov    (%ebx),%eax
80104f26:	85 c0                	test   %eax,%eax
80104f28:	75 7e                	jne    80104fa8 <acquire+0x98>
  popcli();
80104f2a:	e8 e1 fe ff ff       	call   80104e10 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104f2f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104f38:	8b 55 08             	mov    0x8(%ebp),%edx
80104f3b:	89 c8                	mov    %ecx,%eax
80104f3d:	f0 87 02             	lock xchg %eax,(%edx)
80104f40:	85 c0                	test   %eax,%eax
80104f42:	75 f4                	jne    80104f38 <acquire+0x28>
  __sync_synchronize();
80104f44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f4c:	e8 5f ee ff ff       	call   80103db0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104f51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f54:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104f56:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104f59:	31 c0                	xor    %eax,%eax
80104f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104f66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f6c:	77 1a                	ja     80104f88 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104f6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104f71:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104f75:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104f78:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104f7a:	83 f8 0a             	cmp    $0xa,%eax
80104f7d:	75 e1                	jne    80104f60 <acquire+0x50>
}
80104f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f82:	c9                   	leave  
80104f83:	c3                   	ret    
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104f88:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104f8c:	8d 51 34             	lea    0x34(%ecx),%edx
80104f8f:	90                   	nop
    pcs[i] = 0;
80104f90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f96:	83 c0 04             	add    $0x4,%eax
80104f99:	39 c2                	cmp    %eax,%edx
80104f9b:	75 f3                	jne    80104f90 <acquire+0x80>
}
80104f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fa0:	c9                   	leave  
80104fa1:	c3                   	ret    
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104fa8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104fab:	e8 00 ee ff ff       	call   80103db0 <mycpu>
80104fb0:	39 c3                	cmp    %eax,%ebx
80104fb2:	0f 85 72 ff ff ff    	jne    80104f2a <acquire+0x1a>
  popcli();
80104fb8:	e8 53 fe ff ff       	call   80104e10 <popcli>
    panic("acquire");
80104fbd:	83 ec 0c             	sub    $0xc,%esp
80104fc0:	68 21 84 10 80       	push   $0x80108421
80104fc5:	e8 b6 b3 ff ff       	call   80100380 <panic>
80104fca:	66 90                	xchg   %ax,%ax
80104fcc:	66 90                	xchg   %ax,%ax
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <memset>:
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	8b 55 08             	mov    0x8(%ebp),%edx
80104fd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fda:	53                   	push   %ebx
80104fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fde:	89 d7                	mov    %edx,%edi
80104fe0:	09 cf                	or     %ecx,%edi
80104fe2:	83 e7 03             	and    $0x3,%edi
80104fe5:	75 29                	jne    80105010 <memset+0x40>
80104fe7:	0f b6 f8             	movzbl %al,%edi
80104fea:	c1 e0 18             	shl    $0x18,%eax
80104fed:	89 fb                	mov    %edi,%ebx
80104fef:	c1 e9 02             	shr    $0x2,%ecx
80104ff2:	c1 e3 10             	shl    $0x10,%ebx
80104ff5:	09 d8                	or     %ebx,%eax
80104ff7:	09 f8                	or     %edi,%eax
80104ff9:	c1 e7 08             	shl    $0x8,%edi
80104ffc:	09 f8                	or     %edi,%eax
80104ffe:	89 d7                	mov    %edx,%edi
80105000:	fc                   	cld    
80105001:	f3 ab                	rep stos %eax,%es:(%edi)
80105003:	5b                   	pop    %ebx
80105004:	89 d0                	mov    %edx,%eax
80105006:	5f                   	pop    %edi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105010:	89 d7                	mov    %edx,%edi
80105012:	fc                   	cld    
80105013:	f3 aa                	rep stos %al,%es:(%edi)
80105015:	5b                   	pop    %ebx
80105016:	89 d0                	mov    %edx,%eax
80105018:	5f                   	pop    %edi
80105019:	5d                   	pop    %ebp
8010501a:	c3                   	ret    
8010501b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010501f:	90                   	nop

80105020 <memcmp>:
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	8b 75 10             	mov    0x10(%ebp),%esi
80105027:	8b 55 08             	mov    0x8(%ebp),%edx
8010502a:	53                   	push   %ebx
8010502b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502e:	85 f6                	test   %esi,%esi
80105030:	74 2e                	je     80105060 <memcmp+0x40>
80105032:	01 c6                	add    %eax,%esi
80105034:	eb 14                	jmp    8010504a <memcmp+0x2a>
80105036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
80105040:	83 c0 01             	add    $0x1,%eax
80105043:	83 c2 01             	add    $0x1,%edx
80105046:	39 f0                	cmp    %esi,%eax
80105048:	74 16                	je     80105060 <memcmp+0x40>
8010504a:	0f b6 0a             	movzbl (%edx),%ecx
8010504d:	0f b6 18             	movzbl (%eax),%ebx
80105050:	38 d9                	cmp    %bl,%cl
80105052:	74 ec                	je     80105040 <memcmp+0x20>
80105054:	0f b6 c1             	movzbl %cl,%eax
80105057:	29 d8                	sub    %ebx,%eax
80105059:	5b                   	pop    %ebx
8010505a:	5e                   	pop    %esi
8010505b:	5d                   	pop    %ebp
8010505c:	c3                   	ret    
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
80105060:	5b                   	pop    %ebx
80105061:	31 c0                	xor    %eax,%eax
80105063:	5e                   	pop    %esi
80105064:	5d                   	pop    %ebp
80105065:	c3                   	ret    
80105066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506d:	8d 76 00             	lea    0x0(%esi),%esi

80105070 <memmove>:
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	8b 55 08             	mov    0x8(%ebp),%edx
80105077:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010507a:	56                   	push   %esi
8010507b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010507e:	39 d6                	cmp    %edx,%esi
80105080:	73 26                	jae    801050a8 <memmove+0x38>
80105082:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105085:	39 fa                	cmp    %edi,%edx
80105087:	73 1f                	jae    801050a8 <memmove+0x38>
80105089:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010508c:	85 c9                	test   %ecx,%ecx
8010508e:	74 0c                	je     8010509c <memmove+0x2c>
80105090:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105094:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80105097:	83 e8 01             	sub    $0x1,%eax
8010509a:	73 f4                	jae    80105090 <memmove+0x20>
8010509c:	5e                   	pop    %esi
8010509d:	89 d0                	mov    %edx,%eax
8010509f:	5f                   	pop    %edi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret    
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050a8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801050ab:	89 d7                	mov    %edx,%edi
801050ad:	85 c9                	test   %ecx,%ecx
801050af:	74 eb                	je     8010509c <memmove+0x2c>
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
801050b9:	39 c6                	cmp    %eax,%esi
801050bb:	75 fb                	jne    801050b8 <memmove+0x48>
801050bd:	5e                   	pop    %esi
801050be:	89 d0                	mov    %edx,%eax
801050c0:	5f                   	pop    %edi
801050c1:	5d                   	pop    %ebp
801050c2:	c3                   	ret    
801050c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050d0 <memcpy>:
801050d0:	eb 9e                	jmp    80105070 <memmove>
801050d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050e0 <strncmp>:
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	8b 75 10             	mov    0x10(%ebp),%esi
801050e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050ea:	53                   	push   %ebx
801050eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ee:	85 f6                	test   %esi,%esi
801050f0:	74 2e                	je     80105120 <strncmp+0x40>
801050f2:	01 d6                	add    %edx,%esi
801050f4:	eb 18                	jmp    8010510e <strncmp+0x2e>
801050f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
80105100:	38 d8                	cmp    %bl,%al
80105102:	75 14                	jne    80105118 <strncmp+0x38>
80105104:	83 c2 01             	add    $0x1,%edx
80105107:	83 c1 01             	add    $0x1,%ecx
8010510a:	39 f2                	cmp    %esi,%edx
8010510c:	74 12                	je     80105120 <strncmp+0x40>
8010510e:	0f b6 01             	movzbl (%ecx),%eax
80105111:	0f b6 1a             	movzbl (%edx),%ebx
80105114:	84 c0                	test   %al,%al
80105116:	75 e8                	jne    80105100 <strncmp+0x20>
80105118:	29 d8                	sub    %ebx,%eax
8010511a:	5b                   	pop    %ebx
8010511b:	5e                   	pop    %esi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax
80105120:	5b                   	pop    %ebx
80105121:	31 c0                	xor    %eax,%eax
80105123:	5e                   	pop    %esi
80105124:	5d                   	pop    %ebp
80105125:	c3                   	ret    
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi

80105130 <strncpy>:
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	8b 75 08             	mov    0x8(%ebp),%esi
80105138:	53                   	push   %ebx
80105139:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010513c:	89 f0                	mov    %esi,%eax
8010513e:	eb 15                	jmp    80105155 <strncpy+0x25>
80105140:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105144:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105147:	83 c0 01             	add    $0x1,%eax
8010514a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010514e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105151:	84 d2                	test   %dl,%dl
80105153:	74 09                	je     8010515e <strncpy+0x2e>
80105155:	89 cb                	mov    %ecx,%ebx
80105157:	83 e9 01             	sub    $0x1,%ecx
8010515a:	85 db                	test   %ebx,%ebx
8010515c:	7f e2                	jg     80105140 <strncpy+0x10>
8010515e:	89 c2                	mov    %eax,%edx
80105160:	85 c9                	test   %ecx,%ecx
80105162:	7e 17                	jle    8010517b <strncpy+0x4b>
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105168:	83 c2 01             	add    $0x1,%edx
8010516b:	89 c1                	mov    %eax,%ecx
8010516d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80105171:	29 d1                	sub    %edx,%ecx
80105173:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105177:	85 c9                	test   %ecx,%ecx
80105179:	7f ed                	jg     80105168 <strncpy+0x38>
8010517b:	5b                   	pop    %ebx
8010517c:	89 f0                	mov    %esi,%eax
8010517e:	5e                   	pop    %esi
8010517f:	5f                   	pop    %edi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret    
80105182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105190 <safestrcpy>:
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	8b 55 10             	mov    0x10(%ebp),%edx
80105197:	8b 75 08             	mov    0x8(%ebp),%esi
8010519a:	53                   	push   %ebx
8010519b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519e:	85 d2                	test   %edx,%edx
801051a0:	7e 25                	jle    801051c7 <safestrcpy+0x37>
801051a2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801051a6:	89 f2                	mov    %esi,%edx
801051a8:	eb 16                	jmp    801051c0 <safestrcpy+0x30>
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051b0:	0f b6 08             	movzbl (%eax),%ecx
801051b3:	83 c0 01             	add    $0x1,%eax
801051b6:	83 c2 01             	add    $0x1,%edx
801051b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801051bc:	84 c9                	test   %cl,%cl
801051be:	74 04                	je     801051c4 <safestrcpy+0x34>
801051c0:	39 d8                	cmp    %ebx,%eax
801051c2:	75 ec                	jne    801051b0 <safestrcpy+0x20>
801051c4:	c6 02 00             	movb   $0x0,(%edx)
801051c7:	89 f0                	mov    %esi,%eax
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi

801051d0 <strlen>:
801051d0:	55                   	push   %ebp
801051d1:	31 c0                	xor    %eax,%eax
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	8b 55 08             	mov    0x8(%ebp),%edx
801051d8:	80 3a 00             	cmpb   $0x0,(%edx)
801051db:	74 0c                	je     801051e9 <strlen+0x19>
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
801051e0:	83 c0 01             	add    $0x1,%eax
801051e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051e7:	75 f7                	jne    801051e0 <strlen+0x10>
801051e9:	5d                   	pop    %ebp
801051ea:	c3                   	ret    

801051eb <swtch>:
801051eb:	8b 44 24 04          	mov    0x4(%esp),%eax
801051ef:	8b 54 24 08          	mov    0x8(%esp),%edx
801051f3:	55                   	push   %ebp
801051f4:	53                   	push   %ebx
801051f5:	56                   	push   %esi
801051f6:	57                   	push   %edi
801051f7:	89 20                	mov    %esp,(%eax)
801051f9:	89 d4                	mov    %edx,%esp
801051fb:	5f                   	pop    %edi
801051fc:	5e                   	pop    %esi
801051fd:	5b                   	pop    %ebx
801051fe:	5d                   	pop    %ebp
801051ff:	c3                   	ret    

80105200 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	53                   	push   %ebx
80105204:	83 ec 04             	sub    $0x4,%esp
80105207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010520a:	e8 21 ec ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010520f:	8b 00                	mov    (%eax),%eax
80105211:	39 d8                	cmp    %ebx,%eax
80105213:	76 1b                	jbe    80105230 <fetchint+0x30>
80105215:	8d 53 04             	lea    0x4(%ebx),%edx
80105218:	39 d0                	cmp    %edx,%eax
8010521a:	72 14                	jb     80105230 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010521c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521f:	8b 13                	mov    (%ebx),%edx
80105221:	89 10                	mov    %edx,(%eax)
  return 0;
80105223:	31 c0                	xor    %eax,%eax
}
80105225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105228:	c9                   	leave  
80105229:	c3                   	ret    
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105235:	eb ee                	jmp    80105225 <fetchint+0x25>
80105237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523e:	66 90                	xchg   %ax,%ax

80105240 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	53                   	push   %ebx
80105244:	83 ec 04             	sub    $0x4,%esp
80105247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010524a:	e8 e1 eb ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz)
8010524f:	39 18                	cmp    %ebx,(%eax)
80105251:	76 2d                	jbe    80105280 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105253:	8b 55 0c             	mov    0xc(%ebp),%edx
80105256:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105258:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010525a:	39 d3                	cmp    %edx,%ebx
8010525c:	73 22                	jae    80105280 <fetchstr+0x40>
8010525e:	89 d8                	mov    %ebx,%eax
80105260:	eb 0d                	jmp    8010526f <fetchstr+0x2f>
80105262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105268:	83 c0 01             	add    $0x1,%eax
8010526b:	39 c2                	cmp    %eax,%edx
8010526d:	76 11                	jbe    80105280 <fetchstr+0x40>
    if(*s == 0)
8010526f:	80 38 00             	cmpb   $0x0,(%eax)
80105272:	75 f4                	jne    80105268 <fetchstr+0x28>
      return s - *pp;
80105274:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105279:	c9                   	leave  
8010527a:	c3                   	ret    
8010527b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010527f:	90                   	nop
80105280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105288:	c9                   	leave  
80105289:	c3                   	ret    
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105290 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105295:	e8 96 eb ff ff       	call   80103e30 <myproc>
8010529a:	8b 55 08             	mov    0x8(%ebp),%edx
8010529d:	8b 40 18             	mov    0x18(%eax),%eax
801052a0:	8b 40 44             	mov    0x44(%eax),%eax
801052a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801052a6:	e8 85 eb ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052ae:	8b 00                	mov    (%eax),%eax
801052b0:	39 c6                	cmp    %eax,%esi
801052b2:	73 1c                	jae    801052d0 <argint+0x40>
801052b4:	8d 53 08             	lea    0x8(%ebx),%edx
801052b7:	39 d0                	cmp    %edx,%eax
801052b9:	72 15                	jb     801052d0 <argint+0x40>
  *ip = *(int*)(addr);
801052bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801052be:	8b 53 04             	mov    0x4(%ebx),%edx
801052c1:	89 10                	mov    %edx,(%eax)
  return 0;
801052c3:	31 c0                	xor    %eax,%eax
}
801052c5:	5b                   	pop    %ebx
801052c6:	5e                   	pop    %esi
801052c7:	5d                   	pop    %ebp
801052c8:	c3                   	ret    
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052d5:	eb ee                	jmp    801052c5 <argint+0x35>
801052d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052de:	66 90                	xchg   %ax,%ax

801052e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
801052e6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801052e9:	e8 42 eb ff ff       	call   80103e30 <myproc>
801052ee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052f0:	e8 3b eb ff ff       	call   80103e30 <myproc>
801052f5:	8b 55 08             	mov    0x8(%ebp),%edx
801052f8:	8b 40 18             	mov    0x18(%eax),%eax
801052fb:	8b 40 44             	mov    0x44(%eax),%eax
801052fe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105301:	e8 2a eb ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105306:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105309:	8b 00                	mov    (%eax),%eax
8010530b:	39 c7                	cmp    %eax,%edi
8010530d:	73 31                	jae    80105340 <argptr+0x60>
8010530f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105312:	39 c8                	cmp    %ecx,%eax
80105314:	72 2a                	jb     80105340 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105316:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105319:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010531c:	85 d2                	test   %edx,%edx
8010531e:	78 20                	js     80105340 <argptr+0x60>
80105320:	8b 16                	mov    (%esi),%edx
80105322:	39 c2                	cmp    %eax,%edx
80105324:	76 1a                	jbe    80105340 <argptr+0x60>
80105326:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105329:	01 c3                	add    %eax,%ebx
8010532b:	39 da                	cmp    %ebx,%edx
8010532d:	72 11                	jb     80105340 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010532f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105332:	89 02                	mov    %eax,(%edx)
  return 0;
80105334:	31 c0                	xor    %eax,%eax
}
80105336:	83 c4 0c             	add    $0xc,%esp
80105339:	5b                   	pop    %ebx
8010533a:	5e                   	pop    %esi
8010533b:	5f                   	pop    %edi
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105345:	eb ef                	jmp    80105336 <argptr+0x56>
80105347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534e:	66 90                	xchg   %ax,%ax

80105350 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105355:	e8 d6 ea ff ff       	call   80103e30 <myproc>
8010535a:	8b 55 08             	mov    0x8(%ebp),%edx
8010535d:	8b 40 18             	mov    0x18(%eax),%eax
80105360:	8b 40 44             	mov    0x44(%eax),%eax
80105363:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105366:	e8 c5 ea ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010536b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010536e:	8b 00                	mov    (%eax),%eax
80105370:	39 c6                	cmp    %eax,%esi
80105372:	73 44                	jae    801053b8 <argstr+0x68>
80105374:	8d 53 08             	lea    0x8(%ebx),%edx
80105377:	39 d0                	cmp    %edx,%eax
80105379:	72 3d                	jb     801053b8 <argstr+0x68>
  *ip = *(int*)(addr);
8010537b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010537e:	e8 ad ea ff ff       	call   80103e30 <myproc>
  if(addr >= curproc->sz)
80105383:	3b 18                	cmp    (%eax),%ebx
80105385:	73 31                	jae    801053b8 <argstr+0x68>
  *pp = (char*)addr;
80105387:	8b 55 0c             	mov    0xc(%ebp),%edx
8010538a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010538c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010538e:	39 d3                	cmp    %edx,%ebx
80105390:	73 26                	jae    801053b8 <argstr+0x68>
80105392:	89 d8                	mov    %ebx,%eax
80105394:	eb 11                	jmp    801053a7 <argstr+0x57>
80105396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
801053a0:	83 c0 01             	add    $0x1,%eax
801053a3:	39 c2                	cmp    %eax,%edx
801053a5:	76 11                	jbe    801053b8 <argstr+0x68>
    if(*s == 0)
801053a7:	80 38 00             	cmpb   $0x0,(%eax)
801053aa:	75 f4                	jne    801053a0 <argstr+0x50>
      return s - *pp;
801053ac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801053ae:	5b                   	pop    %ebx
801053af:	5e                   	pop    %esi
801053b0:	5d                   	pop    %ebp
801053b1:	c3                   	ret    
801053b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053b8:	5b                   	pop    %ebx
    return -1;
801053b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053be:	5e                   	pop    %esi
801053bf:	5d                   	pop    %ebp
801053c0:	c3                   	ret    
801053c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop

801053d0 <syscall>:
[SYS_set_proc_queue] sys_set_proc_queue,
};

void 
syscall(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801053d5:	e8 56 ea ff ff       	call   80103e30 <myproc>
801053da:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801053dc:	8b 40 18             	mov    0x18(%eax),%eax
801053df:	8b 40 1c             	mov    0x1c(%eax),%eax
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
801053e2:	8d 50 ff             	lea    -0x1(%eax),%edx
801053e5:	83 fa 19             	cmp    $0x19,%edx
801053e8:	77 2e                	ja     80105418 <syscall+0x48>
801053ea:	8b 34 85 60 84 10 80 	mov    -0x7fef7ba0(,%eax,4),%esi
801053f1:	85 f6                	test   %esi,%esi
801053f3:	74 23                	je     80105418 <syscall+0x48>
  {
    push_callerp(curproc->pid, num);
801053f5:	83 ec 08             	sub    $0x8,%esp
801053f8:	50                   	push   %eax
801053f9:	ff 73 10             	push   0x10(%ebx)
801053fc:	e8 5f f3 ff ff       	call   80104760 <push_callerp>
    curproc->tf->eax = syscalls[num]();
80105401:	ff d6                	call   *%esi
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	89 c2                	mov    %eax,%edx
80105408:	8b 43 18             	mov    0x18(%ebx),%eax
8010540b:	89 50 1c             	mov    %edx,0x1c(%eax)
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
8010540e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105411:	5b                   	pop    %ebx
80105412:	5e                   	pop    %esi
80105413:	5d                   	pop    %ebp
80105414:	c3                   	ret    
80105415:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105418:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105419:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010541c:	50                   	push   %eax
8010541d:	ff 73 10             	push   0x10(%ebx)
80105420:	68 29 84 10 80       	push   $0x80108429
80105425:	e8 76 b2 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
8010542a:	8b 43 18             	mov    0x18(%ebx),%eax
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80105437:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010543a:	5b                   	pop    %ebx
8010543b:	5e                   	pop    %esi
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax

80105440 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105445:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105448:	53                   	push   %ebx
80105449:	83 ec 34             	sub    $0x34,%esp
8010544c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010544f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105452:	57                   	push   %edi
80105453:	50                   	push   %eax
{
80105454:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105457:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010545a:	e8 21 d1 ff ff       	call   80102580 <nameiparent>
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	85 c0                	test   %eax,%eax
80105464:	0f 84 46 01 00 00    	je     801055b0 <create+0x170>
    return 0;
  ilock(dp);
8010546a:	83 ec 0c             	sub    $0xc,%esp
8010546d:	89 c3                	mov    %eax,%ebx
8010546f:	50                   	push   %eax
80105470:	e8 cb c7 ff ff       	call   80101c40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105475:	83 c4 0c             	add    $0xc,%esp
80105478:	6a 00                	push   $0x0
8010547a:	57                   	push   %edi
8010547b:	53                   	push   %ebx
8010547c:	e8 1f cd ff ff       	call   801021a0 <dirlookup>
80105481:	83 c4 10             	add    $0x10,%esp
80105484:	89 c6                	mov    %eax,%esi
80105486:	85 c0                	test   %eax,%eax
80105488:	74 56                	je     801054e0 <create+0xa0>
    iunlockput(dp);
8010548a:	83 ec 0c             	sub    $0xc,%esp
8010548d:	53                   	push   %ebx
8010548e:	e8 3d ca ff ff       	call   80101ed0 <iunlockput>
    ilock(ip);
80105493:	89 34 24             	mov    %esi,(%esp)
80105496:	e8 a5 c7 ff ff       	call   80101c40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010549b:	83 c4 10             	add    $0x10,%esp
8010549e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801054a3:	75 1b                	jne    801054c0 <create+0x80>
801054a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801054aa:	75 14                	jne    801054c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801054ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054af:	89 f0                	mov    %esi,%eax
801054b1:	5b                   	pop    %ebx
801054b2:	5e                   	pop    %esi
801054b3:	5f                   	pop    %edi
801054b4:	5d                   	pop    %ebp
801054b5:	c3                   	ret    
801054b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	56                   	push   %esi
    return 0;
801054c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801054c6:	e8 05 ca ff ff       	call   80101ed0 <iunlockput>
    return 0;
801054cb:	83 c4 10             	add    $0x10,%esp
}
801054ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d1:	89 f0                	mov    %esi,%eax
801054d3:	5b                   	pop    %ebx
801054d4:	5e                   	pop    %esi
801054d5:	5f                   	pop    %edi
801054d6:	5d                   	pop    %ebp
801054d7:	c3                   	ret    
801054d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801054e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801054e4:	83 ec 08             	sub    $0x8,%esp
801054e7:	50                   	push   %eax
801054e8:	ff 33                	push   (%ebx)
801054ea:	e8 e1 c5 ff ff       	call   80101ad0 <ialloc>
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	89 c6                	mov    %eax,%esi
801054f4:	85 c0                	test   %eax,%eax
801054f6:	0f 84 cd 00 00 00    	je     801055c9 <create+0x189>
  ilock(ip);
801054fc:	83 ec 0c             	sub    $0xc,%esp
801054ff:	50                   	push   %eax
80105500:	e8 3b c7 ff ff       	call   80101c40 <ilock>
  ip->major = major;
80105505:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105509:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010550d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105511:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105515:	b8 01 00 00 00       	mov    $0x1,%eax
8010551a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010551e:	89 34 24             	mov    %esi,(%esp)
80105521:	e8 6a c6 ff ff       	call   80101b90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010552e:	74 30                	je     80105560 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105530:	83 ec 04             	sub    $0x4,%esp
80105533:	ff 76 04             	push   0x4(%esi)
80105536:	57                   	push   %edi
80105537:	53                   	push   %ebx
80105538:	e8 63 cf ff ff       	call   801024a0 <dirlink>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 78                	js     801055bc <create+0x17c>
  iunlockput(dp);
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	53                   	push   %ebx
80105548:	e8 83 c9 ff ff       	call   80101ed0 <iunlockput>
  return ip;
8010554d:	83 c4 10             	add    $0x10,%esp
}
80105550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105553:	89 f0                	mov    %esi,%eax
80105555:	5b                   	pop    %ebx
80105556:	5e                   	pop    %esi
80105557:	5f                   	pop    %edi
80105558:	5d                   	pop    %ebp
80105559:	c3                   	ret    
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105560:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105563:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105568:	53                   	push   %ebx
80105569:	e8 22 c6 ff ff       	call   80101b90 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010556e:	83 c4 0c             	add    $0xc,%esp
80105571:	ff 76 04             	push   0x4(%esi)
80105574:	68 e8 84 10 80       	push   $0x801084e8
80105579:	56                   	push   %esi
8010557a:	e8 21 cf ff ff       	call   801024a0 <dirlink>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	85 c0                	test   %eax,%eax
80105584:	78 18                	js     8010559e <create+0x15e>
80105586:	83 ec 04             	sub    $0x4,%esp
80105589:	ff 73 04             	push   0x4(%ebx)
8010558c:	68 e7 84 10 80       	push   $0x801084e7
80105591:	56                   	push   %esi
80105592:	e8 09 cf ff ff       	call   801024a0 <dirlink>
80105597:	83 c4 10             	add    $0x10,%esp
8010559a:	85 c0                	test   %eax,%eax
8010559c:	79 92                	jns    80105530 <create+0xf0>
      panic("create dots");
8010559e:	83 ec 0c             	sub    $0xc,%esp
801055a1:	68 db 84 10 80       	push   $0x801084db
801055a6:	e8 d5 ad ff ff       	call   80100380 <panic>
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
}
801055b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801055b3:	31 f6                	xor    %esi,%esi
}
801055b5:	5b                   	pop    %ebx
801055b6:	89 f0                	mov    %esi,%eax
801055b8:	5e                   	pop    %esi
801055b9:	5f                   	pop    %edi
801055ba:	5d                   	pop    %ebp
801055bb:	c3                   	ret    
    panic("create: dirlink");
801055bc:	83 ec 0c             	sub    $0xc,%esp
801055bf:	68 ea 84 10 80       	push   $0x801084ea
801055c4:	e8 b7 ad ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	68 cc 84 10 80       	push   $0x801084cc
801055d1:	e8 aa ad ff ff       	call   80100380 <panic>
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi

801055e0 <sys_dup>:
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055eb:	50                   	push   %eax
801055ec:	6a 00                	push   $0x0
801055ee:	e8 9d fc ff ff       	call   80105290 <argint>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	78 36                	js     80105630 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055fe:	77 30                	ja     80105630 <sys_dup+0x50>
80105600:	e8 2b e8 ff ff       	call   80103e30 <myproc>
80105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105608:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010560c:	85 f6                	test   %esi,%esi
8010560e:	74 20                	je     80105630 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105610:	e8 1b e8 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105615:	31 db                	xor    %ebx,%ebx
80105617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105620:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105624:	85 d2                	test   %edx,%edx
80105626:	74 18                	je     80105640 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105628:	83 c3 01             	add    $0x1,%ebx
8010562b:	83 fb 10             	cmp    $0x10,%ebx
8010562e:	75 f0                	jne    80105620 <sys_dup+0x40>
}
80105630:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105633:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105638:	89 d8                	mov    %ebx,%eax
8010563a:	5b                   	pop    %ebx
8010563b:	5e                   	pop    %esi
8010563c:	5d                   	pop    %ebp
8010563d:	c3                   	ret    
8010563e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105640:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105643:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105647:	56                   	push   %esi
80105648:	e8 13 bd ff ff       	call   80101360 <filedup>
  return fd;
8010564d:	83 c4 10             	add    $0x10,%esp
}
80105650:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105653:	89 d8                	mov    %ebx,%eax
80105655:	5b                   	pop    %ebx
80105656:	5e                   	pop    %esi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_read>:
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105665:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105668:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010566b:	53                   	push   %ebx
8010566c:	6a 00                	push   $0x0
8010566e:	e8 1d fc ff ff       	call   80105290 <argint>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	78 5e                	js     801056d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010567a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010567e:	77 58                	ja     801056d8 <sys_read+0x78>
80105680:	e8 ab e7 ff ff       	call   80103e30 <myproc>
80105685:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105688:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010568c:	85 f6                	test   %esi,%esi
8010568e:	74 48                	je     801056d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105690:	83 ec 08             	sub    $0x8,%esp
80105693:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105696:	50                   	push   %eax
80105697:	6a 02                	push   $0x2
80105699:	e8 f2 fb ff ff       	call   80105290 <argint>
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	85 c0                	test   %eax,%eax
801056a3:	78 33                	js     801056d8 <sys_read+0x78>
801056a5:	83 ec 04             	sub    $0x4,%esp
801056a8:	ff 75 f0             	push   -0x10(%ebp)
801056ab:	53                   	push   %ebx
801056ac:	6a 01                	push   $0x1
801056ae:	e8 2d fc ff ff       	call   801052e0 <argptr>
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	85 c0                	test   %eax,%eax
801056b8:	78 1e                	js     801056d8 <sys_read+0x78>
  return fileread(f, p, n);
801056ba:	83 ec 04             	sub    $0x4,%esp
801056bd:	ff 75 f0             	push   -0x10(%ebp)
801056c0:	ff 75 f4             	push   -0xc(%ebp)
801056c3:	56                   	push   %esi
801056c4:	e8 17 be ff ff       	call   801014e0 <fileread>
801056c9:	83 c4 10             	add    $0x10,%esp
}
801056cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056cf:	5b                   	pop    %ebx
801056d0:	5e                   	pop    %esi
801056d1:	5d                   	pop    %ebp
801056d2:	c3                   	ret    
801056d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056d7:	90                   	nop
    return -1;
801056d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056dd:	eb ed                	jmp    801056cc <sys_read+0x6c>
801056df:	90                   	nop

801056e0 <sys_write>:
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	56                   	push   %esi
801056e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801056e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801056e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056eb:	53                   	push   %ebx
801056ec:	6a 00                	push   $0x0
801056ee:	e8 9d fb ff ff       	call   80105290 <argint>
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	78 5e                	js     80105758 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056fe:	77 58                	ja     80105758 <sys_write+0x78>
80105700:	e8 2b e7 ff ff       	call   80103e30 <myproc>
80105705:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105708:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010570c:	85 f6                	test   %esi,%esi
8010570e:	74 48                	je     80105758 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105710:	83 ec 08             	sub    $0x8,%esp
80105713:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105716:	50                   	push   %eax
80105717:	6a 02                	push   $0x2
80105719:	e8 72 fb ff ff       	call   80105290 <argint>
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	85 c0                	test   %eax,%eax
80105723:	78 33                	js     80105758 <sys_write+0x78>
80105725:	83 ec 04             	sub    $0x4,%esp
80105728:	ff 75 f0             	push   -0x10(%ebp)
8010572b:	53                   	push   %ebx
8010572c:	6a 01                	push   $0x1
8010572e:	e8 ad fb ff ff       	call   801052e0 <argptr>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	78 1e                	js     80105758 <sys_write+0x78>
  return filewrite(f, p, n);
8010573a:	83 ec 04             	sub    $0x4,%esp
8010573d:	ff 75 f0             	push   -0x10(%ebp)
80105740:	ff 75 f4             	push   -0xc(%ebp)
80105743:	56                   	push   %esi
80105744:	e8 27 be ff ff       	call   80101570 <filewrite>
80105749:	83 c4 10             	add    $0x10,%esp
}
8010574c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010574f:	5b                   	pop    %ebx
80105750:	5e                   	pop    %esi
80105751:	5d                   	pop    %ebp
80105752:	c3                   	ret    
80105753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105757:	90                   	nop
    return -1;
80105758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575d:	eb ed                	jmp    8010574c <sys_write+0x6c>
8010575f:	90                   	nop

80105760 <sys_close>:
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105765:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105768:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010576b:	50                   	push   %eax
8010576c:	6a 00                	push   $0x0
8010576e:	e8 1d fb ff ff       	call   80105290 <argint>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	78 3e                	js     801057b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010577a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010577e:	77 38                	ja     801057b8 <sys_close+0x58>
80105780:	e8 ab e6 ff ff       	call   80103e30 <myproc>
80105785:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105788:	8d 5a 08             	lea    0x8(%edx),%ebx
8010578b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010578f:	85 f6                	test   %esi,%esi
80105791:	74 25                	je     801057b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105793:	e8 98 e6 ff ff       	call   80103e30 <myproc>
  fileclose(f);
80105798:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010579b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801057a2:	00 
  fileclose(f);
801057a3:	56                   	push   %esi
801057a4:	e8 07 bc ff ff       	call   801013b0 <fileclose>
  return 0;
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	31 c0                	xor    %eax,%eax
}
801057ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057b1:	5b                   	pop    %ebx
801057b2:	5e                   	pop    %esi
801057b3:	5d                   	pop    %ebp
801057b4:	c3                   	ret    
801057b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bd:	eb ef                	jmp    801057ae <sys_close+0x4e>
801057bf:	90                   	nop

801057c0 <sys_fstat>:
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801057c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801057c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057cb:	53                   	push   %ebx
801057cc:	6a 00                	push   $0x0
801057ce:	e8 bd fa ff ff       	call   80105290 <argint>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 46                	js     80105820 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057de:	77 40                	ja     80105820 <sys_fstat+0x60>
801057e0:	e8 4b e6 ff ff       	call   80103e30 <myproc>
801057e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801057ec:	85 f6                	test   %esi,%esi
801057ee:	74 30                	je     80105820 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057f0:	83 ec 04             	sub    $0x4,%esp
801057f3:	6a 14                	push   $0x14
801057f5:	53                   	push   %ebx
801057f6:	6a 01                	push   $0x1
801057f8:	e8 e3 fa ff ff       	call   801052e0 <argptr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	78 1c                	js     80105820 <sys_fstat+0x60>
  return filestat(f, st);
80105804:	83 ec 08             	sub    $0x8,%esp
80105807:	ff 75 f4             	push   -0xc(%ebp)
8010580a:	56                   	push   %esi
8010580b:	e8 80 bc ff ff       	call   80101490 <filestat>
80105810:	83 c4 10             	add    $0x10,%esp
}
80105813:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105816:	5b                   	pop    %ebx
80105817:	5e                   	pop    %esi
80105818:	5d                   	pop    %ebp
80105819:	c3                   	ret    
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105825:	eb ec                	jmp    80105813 <sys_fstat+0x53>
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <sys_link>:
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105838:	53                   	push   %ebx
80105839:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010583c:	50                   	push   %eax
8010583d:	6a 00                	push   $0x0
8010583f:	e8 0c fb ff ff       	call   80105350 <argstr>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
80105849:	0f 88 fb 00 00 00    	js     8010594a <sys_link+0x11a>
8010584f:	83 ec 08             	sub    $0x8,%esp
80105852:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105855:	50                   	push   %eax
80105856:	6a 01                	push   $0x1
80105858:	e8 f3 fa ff ff       	call   80105350 <argstr>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	0f 88 e2 00 00 00    	js     8010594a <sys_link+0x11a>
  begin_op();
80105868:	e8 b3 d9 ff ff       	call   80103220 <begin_op>
  if((ip = namei(old)) == 0){
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	ff 75 d4             	push   -0x2c(%ebp)
80105873:	e8 e8 cc ff ff       	call   80102560 <namei>
80105878:	83 c4 10             	add    $0x10,%esp
8010587b:	89 c3                	mov    %eax,%ebx
8010587d:	85 c0                	test   %eax,%eax
8010587f:	0f 84 e4 00 00 00    	je     80105969 <sys_link+0x139>
  ilock(ip);
80105885:	83 ec 0c             	sub    $0xc,%esp
80105888:	50                   	push   %eax
80105889:	e8 b2 c3 ff ff       	call   80101c40 <ilock>
  if(ip->type == T_DIR){
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105896:	0f 84 b5 00 00 00    	je     80105951 <sys_link+0x121>
  iupdate(ip);
8010589c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010589f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801058a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801058a7:	53                   	push   %ebx
801058a8:	e8 e3 c2 ff ff       	call   80101b90 <iupdate>
  iunlock(ip);
801058ad:	89 1c 24             	mov    %ebx,(%esp)
801058b0:	e8 6b c4 ff ff       	call   80101d20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801058b5:	58                   	pop    %eax
801058b6:	5a                   	pop    %edx
801058b7:	57                   	push   %edi
801058b8:	ff 75 d0             	push   -0x30(%ebp)
801058bb:	e8 c0 cc ff ff       	call   80102580 <nameiparent>
801058c0:	83 c4 10             	add    $0x10,%esp
801058c3:	89 c6                	mov    %eax,%esi
801058c5:	85 c0                	test   %eax,%eax
801058c7:	74 5b                	je     80105924 <sys_link+0xf4>
  ilock(dp);
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	50                   	push   %eax
801058cd:	e8 6e c3 ff ff       	call   80101c40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801058d2:	8b 03                	mov    (%ebx),%eax
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	39 06                	cmp    %eax,(%esi)
801058d9:	75 3d                	jne    80105918 <sys_link+0xe8>
801058db:	83 ec 04             	sub    $0x4,%esp
801058de:	ff 73 04             	push   0x4(%ebx)
801058e1:	57                   	push   %edi
801058e2:	56                   	push   %esi
801058e3:	e8 b8 cb ff ff       	call   801024a0 <dirlink>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	78 29                	js     80105918 <sys_link+0xe8>
  iunlockput(dp);
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	56                   	push   %esi
801058f3:	e8 d8 c5 ff ff       	call   80101ed0 <iunlockput>
  iput(ip);
801058f8:	89 1c 24             	mov    %ebx,(%esp)
801058fb:	e8 70 c4 ff ff       	call   80101d70 <iput>
  end_op();
80105900:	e8 8b d9 ff ff       	call   80103290 <end_op>
  return 0;
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	31 c0                	xor    %eax,%eax
}
8010590a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010590d:	5b                   	pop    %ebx
8010590e:	5e                   	pop    %esi
8010590f:	5f                   	pop    %edi
80105910:	5d                   	pop    %ebp
80105911:	c3                   	ret    
80105912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	56                   	push   %esi
8010591c:	e8 af c5 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
80105921:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105924:	83 ec 0c             	sub    $0xc,%esp
80105927:	53                   	push   %ebx
80105928:	e8 13 c3 ff ff       	call   80101c40 <ilock>
  ip->nlink--;
8010592d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105932:	89 1c 24             	mov    %ebx,(%esp)
80105935:	e8 56 c2 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
8010593a:	89 1c 24             	mov    %ebx,(%esp)
8010593d:	e8 8e c5 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105942:	e8 49 d9 ff ff       	call   80103290 <end_op>
  return -1;
80105947:	83 c4 10             	add    $0x10,%esp
8010594a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594f:	eb b9                	jmp    8010590a <sys_link+0xda>
    iunlockput(ip);
80105951:	83 ec 0c             	sub    $0xc,%esp
80105954:	53                   	push   %ebx
80105955:	e8 76 c5 ff ff       	call   80101ed0 <iunlockput>
    end_op();
8010595a:	e8 31 d9 ff ff       	call   80103290 <end_op>
    return -1;
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105967:	eb a1                	jmp    8010590a <sys_link+0xda>
    end_op();
80105969:	e8 22 d9 ff ff       	call   80103290 <end_op>
    return -1;
8010596e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105973:	eb 95                	jmp    8010590a <sys_link+0xda>
80105975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_unlink>:
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	57                   	push   %edi
80105984:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105985:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105988:	53                   	push   %ebx
80105989:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010598c:	50                   	push   %eax
8010598d:	6a 00                	push   $0x0
8010598f:	e8 bc f9 ff ff       	call   80105350 <argstr>
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 88 7a 01 00 00    	js     80105b19 <sys_unlink+0x199>
  begin_op();
8010599f:	e8 7c d8 ff ff       	call   80103220 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801059a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801059a7:	83 ec 08             	sub    $0x8,%esp
801059aa:	53                   	push   %ebx
801059ab:	ff 75 c0             	push   -0x40(%ebp)
801059ae:	e8 cd cb ff ff       	call   80102580 <nameiparent>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801059b9:	85 c0                	test   %eax,%eax
801059bb:	0f 84 62 01 00 00    	je     80105b23 <sys_unlink+0x1a3>
  ilock(dp);
801059c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801059c4:	83 ec 0c             	sub    $0xc,%esp
801059c7:	57                   	push   %edi
801059c8:	e8 73 c2 ff ff       	call   80101c40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801059cd:	58                   	pop    %eax
801059ce:	5a                   	pop    %edx
801059cf:	68 e8 84 10 80       	push   $0x801084e8
801059d4:	53                   	push   %ebx
801059d5:	e8 a6 c7 ff ff       	call   80102180 <namecmp>
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	85 c0                	test   %eax,%eax
801059df:	0f 84 fb 00 00 00    	je     80105ae0 <sys_unlink+0x160>
801059e5:	83 ec 08             	sub    $0x8,%esp
801059e8:	68 e7 84 10 80       	push   $0x801084e7
801059ed:	53                   	push   %ebx
801059ee:	e8 8d c7 ff ff       	call   80102180 <namecmp>
801059f3:	83 c4 10             	add    $0x10,%esp
801059f6:	85 c0                	test   %eax,%eax
801059f8:	0f 84 e2 00 00 00    	je     80105ae0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801059fe:	83 ec 04             	sub    $0x4,%esp
80105a01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105a04:	50                   	push   %eax
80105a05:	53                   	push   %ebx
80105a06:	57                   	push   %edi
80105a07:	e8 94 c7 ff ff       	call   801021a0 <dirlookup>
80105a0c:	83 c4 10             	add    $0x10,%esp
80105a0f:	89 c3                	mov    %eax,%ebx
80105a11:	85 c0                	test   %eax,%eax
80105a13:	0f 84 c7 00 00 00    	je     80105ae0 <sys_unlink+0x160>
  ilock(ip);
80105a19:	83 ec 0c             	sub    $0xc,%esp
80105a1c:	50                   	push   %eax
80105a1d:	e8 1e c2 ff ff       	call   80101c40 <ilock>
  if(ip->nlink < 1)
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105a2a:	0f 8e 1c 01 00 00    	jle    80105b4c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a35:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105a38:	74 66                	je     80105aa0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105a3a:	83 ec 04             	sub    $0x4,%esp
80105a3d:	6a 10                	push   $0x10
80105a3f:	6a 00                	push   $0x0
80105a41:	57                   	push   %edi
80105a42:	e8 89 f5 ff ff       	call   80104fd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a47:	6a 10                	push   $0x10
80105a49:	ff 75 c4             	push   -0x3c(%ebp)
80105a4c:	57                   	push   %edi
80105a4d:	ff 75 b4             	push   -0x4c(%ebp)
80105a50:	e8 fb c5 ff ff       	call   80102050 <writei>
80105a55:	83 c4 20             	add    $0x20,%esp
80105a58:	83 f8 10             	cmp    $0x10,%eax
80105a5b:	0f 85 de 00 00 00    	jne    80105b3f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105a61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a66:	0f 84 94 00 00 00    	je     80105b00 <sys_unlink+0x180>
  iunlockput(dp);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	ff 75 b4             	push   -0x4c(%ebp)
80105a72:	e8 59 c4 ff ff       	call   80101ed0 <iunlockput>
  ip->nlink--;
80105a77:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a7c:	89 1c 24             	mov    %ebx,(%esp)
80105a7f:	e8 0c c1 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
80105a84:	89 1c 24             	mov    %ebx,(%esp)
80105a87:	e8 44 c4 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105a8c:	e8 ff d7 ff ff       	call   80103290 <end_op>
  return 0;
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	31 c0                	xor    %eax,%eax
}
80105a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a99:	5b                   	pop    %ebx
80105a9a:	5e                   	pop    %esi
80105a9b:	5f                   	pop    %edi
80105a9c:	5d                   	pop    %ebp
80105a9d:	c3                   	ret    
80105a9e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105aa0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105aa4:	76 94                	jbe    80105a3a <sys_unlink+0xba>
80105aa6:	be 20 00 00 00       	mov    $0x20,%esi
80105aab:	eb 0b                	jmp    80105ab8 <sys_unlink+0x138>
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
80105ab0:	83 c6 10             	add    $0x10,%esi
80105ab3:	3b 73 58             	cmp    0x58(%ebx),%esi
80105ab6:	73 82                	jae    80105a3a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ab8:	6a 10                	push   $0x10
80105aba:	56                   	push   %esi
80105abb:	57                   	push   %edi
80105abc:	53                   	push   %ebx
80105abd:	e8 8e c4 ff ff       	call   80101f50 <readi>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	83 f8 10             	cmp    $0x10,%eax
80105ac8:	75 68                	jne    80105b32 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105aca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105acf:	74 df                	je     80105ab0 <sys_unlink+0x130>
    iunlockput(ip);
80105ad1:	83 ec 0c             	sub    $0xc,%esp
80105ad4:	53                   	push   %ebx
80105ad5:	e8 f6 c3 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	ff 75 b4             	push   -0x4c(%ebp)
80105ae6:	e8 e5 c3 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105aeb:	e8 a0 d7 ff ff       	call   80103290 <end_op>
  return -1;
80105af0:	83 c4 10             	add    $0x10,%esp
80105af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af8:	eb 9c                	jmp    80105a96 <sys_unlink+0x116>
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105b00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105b03:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105b06:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105b0b:	50                   	push   %eax
80105b0c:	e8 7f c0 ff ff       	call   80101b90 <iupdate>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	e9 53 ff ff ff       	jmp    80105a6c <sys_unlink+0xec>
    return -1;
80105b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1e:	e9 73 ff ff ff       	jmp    80105a96 <sys_unlink+0x116>
    end_op();
80105b23:	e8 68 d7 ff ff       	call   80103290 <end_op>
    return -1;
80105b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2d:	e9 64 ff ff ff       	jmp    80105a96 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105b32:	83 ec 0c             	sub    $0xc,%esp
80105b35:	68 0c 85 10 80       	push   $0x8010850c
80105b3a:	e8 41 a8 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105b3f:	83 ec 0c             	sub    $0xc,%esp
80105b42:	68 1e 85 10 80       	push   $0x8010851e
80105b47:	e8 34 a8 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	68 fa 84 10 80       	push   $0x801084fa
80105b54:	e8 27 a8 ff ff       	call   80100380 <panic>
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_open>:

int
sys_open(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b65:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b68:	53                   	push   %ebx
80105b69:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b6c:	50                   	push   %eax
80105b6d:	6a 00                	push   $0x0
80105b6f:	e8 dc f7 ff ff       	call   80105350 <argstr>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 88 8e 00 00 00    	js     80105c0d <sys_open+0xad>
80105b7f:	83 ec 08             	sub    $0x8,%esp
80105b82:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b85:	50                   	push   %eax
80105b86:	6a 01                	push   $0x1
80105b88:	e8 03 f7 ff ff       	call   80105290 <argint>
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	85 c0                	test   %eax,%eax
80105b92:	78 79                	js     80105c0d <sys_open+0xad>
    return -1;

  begin_op();
80105b94:	e8 87 d6 ff ff       	call   80103220 <begin_op>

  if(omode & O_CREATE){
80105b99:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b9d:	75 79                	jne    80105c18 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b9f:	83 ec 0c             	sub    $0xc,%esp
80105ba2:	ff 75 e0             	push   -0x20(%ebp)
80105ba5:	e8 b6 c9 ff ff       	call   80102560 <namei>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	89 c6                	mov    %eax,%esi
80105baf:	85 c0                	test   %eax,%eax
80105bb1:	0f 84 7e 00 00 00    	je     80105c35 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105bb7:	83 ec 0c             	sub    $0xc,%esp
80105bba:	50                   	push   %eax
80105bbb:	e8 80 c0 ff ff       	call   80101c40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bc0:	83 c4 10             	add    $0x10,%esp
80105bc3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105bc8:	0f 84 c2 00 00 00    	je     80105c90 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105bce:	e8 1d b7 ff ff       	call   801012f0 <filealloc>
80105bd3:	89 c7                	mov    %eax,%edi
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	74 23                	je     80105bfc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105bd9:	e8 52 e2 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bde:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105be0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105be4:	85 d2                	test   %edx,%edx
80105be6:	74 60                	je     80105c48 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105be8:	83 c3 01             	add    $0x1,%ebx
80105beb:	83 fb 10             	cmp    $0x10,%ebx
80105bee:	75 f0                	jne    80105be0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	57                   	push   %edi
80105bf4:	e8 b7 b7 ff ff       	call   801013b0 <fileclose>
80105bf9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105bfc:	83 ec 0c             	sub    $0xc,%esp
80105bff:	56                   	push   %esi
80105c00:	e8 cb c2 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105c05:	e8 86 d6 ff ff       	call   80103290 <end_op>
    return -1;
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c12:	eb 6d                	jmp    80105c81 <sys_open+0x121>
80105c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105c18:	83 ec 0c             	sub    $0xc,%esp
80105c1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c1e:	31 c9                	xor    %ecx,%ecx
80105c20:	ba 02 00 00 00       	mov    $0x2,%edx
80105c25:	6a 00                	push   $0x0
80105c27:	e8 14 f8 ff ff       	call   80105440 <create>
    if(ip == 0){
80105c2c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105c2f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c31:	85 c0                	test   %eax,%eax
80105c33:	75 99                	jne    80105bce <sys_open+0x6e>
      end_op();
80105c35:	e8 56 d6 ff ff       	call   80103290 <end_op>
      return -1;
80105c3a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c3f:	eb 40                	jmp    80105c81 <sys_open+0x121>
80105c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105c48:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105c4b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105c4f:	56                   	push   %esi
80105c50:	e8 cb c0 ff ff       	call   80101d20 <iunlock>
  end_op();
80105c55:	e8 36 d6 ff ff       	call   80103290 <end_op>

  f->type = FD_INODE;
80105c5a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105c60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c63:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105c66:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105c69:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105c6b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105c72:	f7 d0                	not    %eax
80105c74:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c77:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105c7a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105c7d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c84:	89 d8                	mov    %ebx,%eax
80105c86:	5b                   	pop    %ebx
80105c87:	5e                   	pop    %esi
80105c88:	5f                   	pop    %edi
80105c89:	5d                   	pop    %ebp
80105c8a:	c3                   	ret    
80105c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c93:	85 c9                	test   %ecx,%ecx
80105c95:	0f 84 33 ff ff ff    	je     80105bce <sys_open+0x6e>
80105c9b:	e9 5c ff ff ff       	jmp    80105bfc <sys_open+0x9c>

80105ca0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ca6:	e8 75 d5 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105cab:	83 ec 08             	sub    $0x8,%esp
80105cae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cb1:	50                   	push   %eax
80105cb2:	6a 00                	push   $0x0
80105cb4:	e8 97 f6 ff ff       	call   80105350 <argstr>
80105cb9:	83 c4 10             	add    $0x10,%esp
80105cbc:	85 c0                	test   %eax,%eax
80105cbe:	78 30                	js     80105cf0 <sys_mkdir+0x50>
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc6:	31 c9                	xor    %ecx,%ecx
80105cc8:	ba 01 00 00 00       	mov    $0x1,%edx
80105ccd:	6a 00                	push   $0x0
80105ccf:	e8 6c f7 ff ff       	call   80105440 <create>
80105cd4:	83 c4 10             	add    $0x10,%esp
80105cd7:	85 c0                	test   %eax,%eax
80105cd9:	74 15                	je     80105cf0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cdb:	83 ec 0c             	sub    $0xc,%esp
80105cde:	50                   	push   %eax
80105cdf:	e8 ec c1 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105ce4:	e8 a7 d5 ff ff       	call   80103290 <end_op>
  return 0;
80105ce9:	83 c4 10             	add    $0x10,%esp
80105cec:	31 c0                	xor    %eax,%eax
}
80105cee:	c9                   	leave  
80105cef:	c3                   	ret    
    end_op();
80105cf0:	e8 9b d5 ff ff       	call   80103290 <end_op>
    return -1;
80105cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cfa:	c9                   	leave  
80105cfb:	c3                   	ret    
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_mknod>:

int
sys_mknod(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d06:	e8 15 d5 ff ff       	call   80103220 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d0b:	83 ec 08             	sub    $0x8,%esp
80105d0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d11:	50                   	push   %eax
80105d12:	6a 00                	push   $0x0
80105d14:	e8 37 f6 ff ff       	call   80105350 <argstr>
80105d19:	83 c4 10             	add    $0x10,%esp
80105d1c:	85 c0                	test   %eax,%eax
80105d1e:	78 60                	js     80105d80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105d20:	83 ec 08             	sub    $0x8,%esp
80105d23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d26:	50                   	push   %eax
80105d27:	6a 01                	push   $0x1
80105d29:	e8 62 f5 ff ff       	call   80105290 <argint>
  if((argstr(0, &path)) < 0 ||
80105d2e:	83 c4 10             	add    $0x10,%esp
80105d31:	85 c0                	test   %eax,%eax
80105d33:	78 4b                	js     80105d80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d3b:	50                   	push   %eax
80105d3c:	6a 02                	push   $0x2
80105d3e:	e8 4d f5 ff ff       	call   80105290 <argint>
     argint(1, &major) < 0 ||
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	78 36                	js     80105d80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105d4e:	83 ec 0c             	sub    $0xc,%esp
80105d51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105d55:	ba 03 00 00 00       	mov    $0x3,%edx
80105d5a:	50                   	push   %eax
80105d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d5e:	e8 dd f6 ff ff       	call   80105440 <create>
     argint(2, &minor) < 0 ||
80105d63:	83 c4 10             	add    $0x10,%esp
80105d66:	85 c0                	test   %eax,%eax
80105d68:	74 16                	je     80105d80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d6a:	83 ec 0c             	sub    $0xc,%esp
80105d6d:	50                   	push   %eax
80105d6e:	e8 5d c1 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105d73:	e8 18 d5 ff ff       	call   80103290 <end_op>
  return 0;
80105d78:	83 c4 10             	add    $0x10,%esp
80105d7b:	31 c0                	xor    %eax,%eax
}
80105d7d:	c9                   	leave  
80105d7e:	c3                   	ret    
80105d7f:	90                   	nop
    end_op();
80105d80:	e8 0b d5 ff ff       	call   80103290 <end_op>
    return -1;
80105d85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d8a:	c9                   	leave  
80105d8b:	c3                   	ret    
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d90 <sys_chdir>:

int
sys_chdir(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	56                   	push   %esi
80105d94:	53                   	push   %ebx
80105d95:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d98:	e8 93 e0 ff ff       	call   80103e30 <myproc>
80105d9d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d9f:	e8 7c d4 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105da4:	83 ec 08             	sub    $0x8,%esp
80105da7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105daa:	50                   	push   %eax
80105dab:	6a 00                	push   $0x0
80105dad:	e8 9e f5 ff ff       	call   80105350 <argstr>
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	78 77                	js     80105e30 <sys_chdir+0xa0>
80105db9:	83 ec 0c             	sub    $0xc,%esp
80105dbc:	ff 75 f4             	push   -0xc(%ebp)
80105dbf:	e8 9c c7 ff ff       	call   80102560 <namei>
80105dc4:	83 c4 10             	add    $0x10,%esp
80105dc7:	89 c3                	mov    %eax,%ebx
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	74 63                	je     80105e30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105dcd:	83 ec 0c             	sub    $0xc,%esp
80105dd0:	50                   	push   %eax
80105dd1:	e8 6a be ff ff       	call   80101c40 <ilock>
  if(ip->type != T_DIR){
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dde:	75 30                	jne    80105e10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105de0:	83 ec 0c             	sub    $0xc,%esp
80105de3:	53                   	push   %ebx
80105de4:	e8 37 bf ff ff       	call   80101d20 <iunlock>
  iput(curproc->cwd);
80105de9:	58                   	pop    %eax
80105dea:	ff 76 68             	push   0x68(%esi)
80105ded:	e8 7e bf ff ff       	call   80101d70 <iput>
  end_op();
80105df2:	e8 99 d4 ff ff       	call   80103290 <end_op>
  curproc->cwd = ip;
80105df7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dfa:	83 c4 10             	add    $0x10,%esp
80105dfd:	31 c0                	xor    %eax,%eax
}
80105dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e02:	5b                   	pop    %ebx
80105e03:	5e                   	pop    %esi
80105e04:	5d                   	pop    %ebp
80105e05:	c3                   	ret    
80105e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	53                   	push   %ebx
80105e14:	e8 b7 c0 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105e19:	e8 72 d4 ff ff       	call   80103290 <end_op>
    return -1;
80105e1e:	83 c4 10             	add    $0x10,%esp
80105e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e26:	eb d7                	jmp    80105dff <sys_chdir+0x6f>
80105e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
    end_op();
80105e30:	e8 5b d4 ff ff       	call   80103290 <end_op>
    return -1;
80105e35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3a:	eb c3                	jmp    80105dff <sys_chdir+0x6f>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e40 <sys_exec>:

int
sys_exec(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	57                   	push   %edi
80105e44:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e45:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e4b:	53                   	push   %ebx
80105e4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e52:	50                   	push   %eax
80105e53:	6a 00                	push   $0x0
80105e55:	e8 f6 f4 ff ff       	call   80105350 <argstr>
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	0f 88 87 00 00 00    	js     80105eec <sys_exec+0xac>
80105e65:	83 ec 08             	sub    $0x8,%esp
80105e68:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e6e:	50                   	push   %eax
80105e6f:	6a 01                	push   $0x1
80105e71:	e8 1a f4 ff ff       	call   80105290 <argint>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	78 6f                	js     80105eec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e7d:	83 ec 04             	sub    $0x4,%esp
80105e80:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105e86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e88:	68 80 00 00 00       	push   $0x80
80105e8d:	6a 00                	push   $0x0
80105e8f:	56                   	push   %esi
80105e90:	e8 3b f1 ff ff       	call   80104fd0 <memset>
80105e95:	83 c4 10             	add    $0x10,%esp
80105e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ea0:	83 ec 08             	sub    $0x8,%esp
80105ea3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ea9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105eb0:	50                   	push   %eax
80105eb1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105eb7:	01 f8                	add    %edi,%eax
80105eb9:	50                   	push   %eax
80105eba:	e8 41 f3 ff ff       	call   80105200 <fetchint>
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	85 c0                	test   %eax,%eax
80105ec4:	78 26                	js     80105eec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105ec6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ecc:	85 c0                	test   %eax,%eax
80105ece:	74 30                	je     80105f00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ed0:	83 ec 08             	sub    $0x8,%esp
80105ed3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105ed6:	52                   	push   %edx
80105ed7:	50                   	push   %eax
80105ed8:	e8 63 f3 ff ff       	call   80105240 <fetchstr>
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	85 c0                	test   %eax,%eax
80105ee2:	78 08                	js     80105eec <sys_exec+0xac>
  for(i=0;; i++){
80105ee4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ee7:	83 fb 20             	cmp    $0x20,%ebx
80105eea:	75 b4                	jne    80105ea0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef4:	5b                   	pop    %ebx
80105ef5:	5e                   	pop    %esi
80105ef6:	5f                   	pop    %edi
80105ef7:	5d                   	pop    %ebp
80105ef8:	c3                   	ret    
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105f00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f07:	00 00 00 00 
  return exec(path, argv);
80105f0b:	83 ec 08             	sub    $0x8,%esp
80105f0e:	56                   	push   %esi
80105f0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105f15:	e8 56 b0 ff ff       	call   80100f70 <exec>
80105f1a:	83 c4 10             	add    $0x10,%esp
}
80105f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f20:	5b                   	pop    %ebx
80105f21:	5e                   	pop    %esi
80105f22:	5f                   	pop    %edi
80105f23:	5d                   	pop    %ebp
80105f24:	c3                   	ret    
80105f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_pipe>:

int
sys_pipe(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	57                   	push   %edi
80105f34:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f35:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105f38:	53                   	push   %ebx
80105f39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f3c:	6a 08                	push   $0x8
80105f3e:	50                   	push   %eax
80105f3f:	6a 00                	push   $0x0
80105f41:	e8 9a f3 ff ff       	call   801052e0 <argptr>
80105f46:	83 c4 10             	add    $0x10,%esp
80105f49:	85 c0                	test   %eax,%eax
80105f4b:	78 4a                	js     80105f97 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f4d:	83 ec 08             	sub    $0x8,%esp
80105f50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f53:	50                   	push   %eax
80105f54:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f57:	50                   	push   %eax
80105f58:	e8 93 d9 ff ff       	call   801038f0 <pipealloc>
80105f5d:	83 c4 10             	add    $0x10,%esp
80105f60:	85 c0                	test   %eax,%eax
80105f62:	78 33                	js     80105f97 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f64:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f67:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f69:	e8 c2 de ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105f70:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f74:	85 f6                	test   %esi,%esi
80105f76:	74 28                	je     80105fa0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105f78:	83 c3 01             	add    $0x1,%ebx
80105f7b:	83 fb 10             	cmp    $0x10,%ebx
80105f7e:	75 f0                	jne    80105f70 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	ff 75 e0             	push   -0x20(%ebp)
80105f86:	e8 25 b4 ff ff       	call   801013b0 <fileclose>
    fileclose(wf);
80105f8b:	58                   	pop    %eax
80105f8c:	ff 75 e4             	push   -0x1c(%ebp)
80105f8f:	e8 1c b4 ff ff       	call   801013b0 <fileclose>
    return -1;
80105f94:	83 c4 10             	add    $0x10,%esp
80105f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f9c:	eb 53                	jmp    80105ff1 <sys_pipe+0xc1>
80105f9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105fa0:	8d 73 08             	lea    0x8(%ebx),%esi
80105fa3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fa7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105faa:	e8 81 de ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105faf:	31 d2                	xor    %edx,%edx
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105fb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105fbc:	85 c9                	test   %ecx,%ecx
80105fbe:	74 20                	je     80105fe0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105fc0:	83 c2 01             	add    $0x1,%edx
80105fc3:	83 fa 10             	cmp    $0x10,%edx
80105fc6:	75 f0                	jne    80105fb8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105fc8:	e8 63 de ff ff       	call   80103e30 <myproc>
80105fcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fd4:	00 
80105fd5:	eb a9                	jmp    80105f80 <sys_pipe+0x50>
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105fe0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105fe4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fe7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105fe9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105fef:	31 c0                	xor    %eax,%eax
}
80105ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff4:	5b                   	pop    %ebx
80105ff5:	5e                   	pop    %esi
80105ff6:	5f                   	pop    %edi
80105ff7:	5d                   	pop    %ebp
80105ff8:	c3                   	ret    
80105ff9:	66 90                	xchg   %ax,%ax
80105ffb:	66 90                	xchg   %ax,%ax
80105ffd:	66 90                	xchg   %ax,%ax
80105fff:	90                   	nop

80106000 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106000:	e9 cb df ff ff       	jmp    80103fd0 <fork>
80106005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106010 <sys_exit>:
}

int
sys_exit(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 08             	sub    $0x8,%esp
  exit();
80106016:	e8 35 e2 ff ff       	call   80104250 <exit>
  return 0;  // not reached
}
8010601b:	31 c0                	xor    %eax,%eax
8010601d:	c9                   	leave  
8010601e:	c3                   	ret    
8010601f:	90                   	nop

80106020 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106020:	e9 5b e3 ff ff       	jmp    80104380 <wait>
80106025:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106030 <sys_kill>:
}

int
sys_kill(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106036:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106039:	50                   	push   %eax
8010603a:	6a 00                	push   $0x0
8010603c:	e8 4f f2 ff ff       	call   80105290 <argint>
80106041:	83 c4 10             	add    $0x10,%esp
80106044:	85 c0                	test   %eax,%eax
80106046:	78 18                	js     80106060 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106048:	83 ec 0c             	sub    $0xc,%esp
8010604b:	ff 75 f4             	push   -0xc(%ebp)
8010604e:	e8 cd e5 ff ff       	call   80104620 <kill>
80106053:	83 c4 10             	add    $0x10,%esp
}
80106056:	c9                   	leave  
80106057:	c3                   	ret    
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop
80106060:	c9                   	leave  
    return -1;
80106061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106066:	c3                   	ret    
80106067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606e:	66 90                	xchg   %ax,%ax

80106070 <sys_getpid>:

int
sys_getpid(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106076:	e8 b5 dd ff ff       	call   80103e30 <myproc>
8010607b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010607e:	c9                   	leave  
8010607f:	c3                   	ret    

80106080 <sys_sbrk>:

int
sys_sbrk(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106084:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106087:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010608a:	50                   	push   %eax
8010608b:	6a 00                	push   $0x0
8010608d:	e8 fe f1 ff ff       	call   80105290 <argint>
80106092:	83 c4 10             	add    $0x10,%esp
80106095:	85 c0                	test   %eax,%eax
80106097:	78 27                	js     801060c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106099:	e8 92 dd ff ff       	call   80103e30 <myproc>
  if(growproc(n) < 0)
8010609e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801060a1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801060a3:	ff 75 f4             	push   -0xc(%ebp)
801060a6:	e8 a5 de ff ff       	call   80103f50 <growproc>
801060ab:	83 c4 10             	add    $0x10,%esp
801060ae:	85 c0                	test   %eax,%eax
801060b0:	78 0e                	js     801060c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801060b2:	89 d8                	mov    %ebx,%eax
801060b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060b7:	c9                   	leave  
801060b8:	c3                   	ret    
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060c5:	eb eb                	jmp    801060b2 <sys_sbrk+0x32>
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <sys_sleep>:

int
sys_sleep(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801060d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060da:	50                   	push   %eax
801060db:	6a 00                	push   $0x0
801060dd:	e8 ae f1 ff ff       	call   80105290 <argint>
801060e2:	83 c4 10             	add    $0x10,%esp
801060e5:	85 c0                	test   %eax,%eax
801060e7:	0f 88 8a 00 00 00    	js     80106177 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	68 60 e6 12 80       	push   $0x8012e660
801060f5:	e8 16 ee ff ff       	call   80104f10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801060fd:	8b 1d 40 e6 12 80    	mov    0x8012e640,%ebx
  while(ticks - ticks0 < n){
80106103:	83 c4 10             	add    $0x10,%esp
80106106:	85 d2                	test   %edx,%edx
80106108:	75 27                	jne    80106131 <sys_sleep+0x61>
8010610a:	eb 54                	jmp    80106160 <sys_sleep+0x90>
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106110:	83 ec 08             	sub    $0x8,%esp
80106113:	68 60 e6 12 80       	push   $0x8012e660
80106118:	68 40 e6 12 80       	push   $0x8012e640
8010611d:	e8 de e3 ff ff       	call   80104500 <sleep>
  while(ticks - ticks0 < n){
80106122:	a1 40 e6 12 80       	mov    0x8012e640,%eax
80106127:	83 c4 10             	add    $0x10,%esp
8010612a:	29 d8                	sub    %ebx,%eax
8010612c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010612f:	73 2f                	jae    80106160 <sys_sleep+0x90>
    if(myproc()->killed){
80106131:	e8 fa dc ff ff       	call   80103e30 <myproc>
80106136:	8b 40 24             	mov    0x24(%eax),%eax
80106139:	85 c0                	test   %eax,%eax
8010613b:	74 d3                	je     80106110 <sys_sleep+0x40>
      release(&tickslock);
8010613d:	83 ec 0c             	sub    $0xc,%esp
80106140:	68 60 e6 12 80       	push   $0x8012e660
80106145:	e8 66 ed ff ff       	call   80104eb0 <release>
  }
  release(&tickslock);
  return 0;
}
8010614a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106155:	c9                   	leave  
80106156:	c3                   	ret    
80106157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	68 60 e6 12 80       	push   $0x8012e660
80106168:	e8 43 ed ff ff       	call   80104eb0 <release>
  return 0;
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	31 c0                	xor    %eax,%eax
}
80106172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106175:	c9                   	leave  
80106176:	c3                   	ret    
    return -1;
80106177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617c:	eb f4                	jmp    80106172 <sys_sleep+0xa2>
8010617e:	66 90                	xchg   %ax,%ax

80106180 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	53                   	push   %ebx
80106184:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106187:	68 60 e6 12 80       	push   $0x8012e660
8010618c:	e8 7f ed ff ff       	call   80104f10 <acquire>
  xticks = ticks;
80106191:	8b 1d 40 e6 12 80    	mov    0x8012e640,%ebx
  release(&tickslock);
80106197:	c7 04 24 60 e6 12 80 	movl   $0x8012e660,(%esp)
8010619e:	e8 0d ed ff ff       	call   80104eb0 <release>
  return xticks;
}
801061a3:	89 d8                	mov    %ebx,%eax
801061a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061a8:	c9                   	leave  
801061a9:	c3                   	ret    
801061aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061b0 <sys_get_parent_pid>:

int
sys_get_parent_pid(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
801061b6:	e8 75 dc ff ff       	call   80103e30 <myproc>
801061bb:	8b 40 14             	mov    0x14(%eax),%eax
801061be:	8b 40 10             	mov    0x10(%eax),%eax
}
801061c1:	c9                   	leave  
801061c2:	c3                   	ret    
801061c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061d0 <sys_find_largest_prime_factor>:

int
sys_find_largest_prime_factor(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	57                   	push   %edi
801061d4:	56                   	push   %esi
801061d5:	53                   	push   %ebx
801061d6:	83 ec 0c             	sub    $0xc,%esp
  int n = myproc()->tf->edx;
801061d9:	e8 52 dc ff ff       	call   80103e30 <myproc>
801061de:	8b 40 18             	mov    0x18(%eax),%eax
801061e1:	8b 48 14             	mov    0x14(%eax),%ecx
  // cprintf("sys_find_largest_prime_factor called with n=%d\n", n);
  
  int maxPrime = -1;
  while (n % 2 == 0) {
801061e4:	f6 c1 01             	test   $0x1,%cl
801061e7:	0f 85 d2 00 00 00    	jne    801062bf <sys_find_largest_prime_factor+0xef>
801061ed:	8d 76 00             	lea    0x0(%esi),%esi
      maxPrime = 2;
      n = n / 2;
801061f0:	89 c8                	mov    %ecx,%eax
801061f2:	c1 e8 1f             	shr    $0x1f,%eax
801061f5:	01 c8                	add    %ecx,%eax
801061f7:	89 c1                	mov    %eax,%ecx
801061f9:	d1 f9                	sar    %ecx
  while (n % 2 == 0) {
801061fb:	a8 02                	test   $0x2,%al
801061fd:	74 f1                	je     801061f0 <sys_find_largest_prime_factor+0x20>
      maxPrime = 2;
801061ff:	be 02 00 00 00       	mov    $0x2,%esi
  }
  while (n % 3 == 0) {
80106204:	69 c1 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%eax
8010620a:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
8010620f:	3d 54 55 55 55       	cmp    $0x55555554,%eax
80106214:	77 2e                	ja     80106244 <sys_find_largest_prime_factor+0x74>
      maxPrime = 3;
      n = n / 3;
80106216:	bb 56 55 55 55       	mov    $0x55555556,%ebx
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop
80106220:	89 c8                	mov    %ecx,%eax
80106222:	f7 eb                	imul   %ebx
80106224:	89 c8                	mov    %ecx,%eax
80106226:	c1 f8 1f             	sar    $0x1f,%eax
80106229:	29 c2                	sub    %eax,%edx
8010622b:	69 c2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%eax
80106231:	89 d1                	mov    %edx,%ecx
80106233:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
  while (n % 3 == 0) {
80106238:	3d 54 55 55 55       	cmp    $0x55555554,%eax
8010623d:	76 e1                	jbe    80106220 <sys_find_largest_prime_factor+0x50>
      maxPrime = 3;
8010623f:	be 03 00 00 00       	mov    $0x3,%esi
  }

  for (int i = 5; i <= n/2; i += 6) {
80106244:	bb 05 00 00 00       	mov    $0x5,%ebx
80106249:	83 f9 09             	cmp    $0x9,%ecx
8010624c:	7e 4b                	jle    80106299 <sys_find_largest_prime_factor+0xc9>
8010624e:	66 90                	xchg   %ax,%ax
      while (n % i == 0) {
80106250:	89 c8                	mov    %ecx,%eax
80106252:	89 f7                	mov    %esi,%edi
80106254:	99                   	cltd   
80106255:	f7 fb                	idiv   %ebx
80106257:	85 d2                	test   %edx,%edx
80106259:	75 15                	jne    80106270 <sys_find_largest_prime_factor+0xa0>
8010625b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010625f:	90                   	nop
          maxPrime = i;
          n = n / i;
80106260:	89 c8                	mov    %ecx,%eax
80106262:	99                   	cltd   
80106263:	f7 fb                	idiv   %ebx
      while (n % i == 0) {
80106265:	99                   	cltd   
          n = n / i;
80106266:	89 c1                	mov    %eax,%ecx
      while (n % i == 0) {
80106268:	f7 fb                	idiv   %ebx
8010626a:	85 d2                	test   %edx,%edx
8010626c:	74 f2                	je     80106260 <sys_find_largest_prime_factor+0x90>
8010626e:	89 df                	mov    %ebx,%edi
      }
      while (n % (i+2) == 0) {
80106270:	89 c8                	mov    %ecx,%eax
80106272:	8d 73 02             	lea    0x2(%ebx),%esi
80106275:	99                   	cltd   
80106276:	f7 fe                	idiv   %esi
80106278:	85 d2                	test   %edx,%edx
8010627a:	75 34                	jne    801062b0 <sys_find_largest_prime_factor+0xe0>
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          maxPrime = i + 2;
          n = n / (i + 2);
80106280:	89 c8                	mov    %ecx,%eax
80106282:	99                   	cltd   
80106283:	f7 fe                	idiv   %esi
      while (n % (i+2) == 0) {
80106285:	99                   	cltd   
          n = n / (i + 2);
80106286:	89 c1                	mov    %eax,%ecx
      while (n % (i+2) == 0) {
80106288:	f7 fe                	idiv   %esi
8010628a:	85 d2                	test   %edx,%edx
8010628c:	74 f2                	je     80106280 <sys_find_largest_prime_factor+0xb0>
  for (int i = 5; i <= n/2; i += 6) {
8010628e:	89 c8                	mov    %ecx,%eax
80106290:	83 c3 06             	add    $0x6,%ebx
80106293:	d1 f8                	sar    %eax
80106295:	39 d8                	cmp    %ebx,%eax
80106297:	7d b7                	jge    80106250 <sys_find_largest_prime_factor+0x80>
      }
  }

  if (n > 4) {
80106299:	83 f9 05             	cmp    $0x5,%ecx
8010629c:	0f 4d f1             	cmovge %ecx,%esi
      maxPrime = n;
  }

  // cprintf("sys_find_largest_prime_factor returning %d\n", maxPrime);
  return maxPrime;
}
8010629f:	83 c4 0c             	add    $0xc,%esp
801062a2:	5b                   	pop    %ebx
801062a3:	89 f0                	mov    %esi,%eax
801062a5:	5e                   	pop    %esi
801062a6:	5f                   	pop    %edi
801062a7:	5d                   	pop    %ebp
801062a8:	c3                   	ret    
801062a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 5; i <= n/2; i += 6) {
801062b0:	89 c8                	mov    %ecx,%eax
801062b2:	83 c3 06             	add    $0x6,%ebx
      while (n % (i+2) == 0) {
801062b5:	89 fe                	mov    %edi,%esi
  for (int i = 5; i <= n/2; i += 6) {
801062b7:	d1 f8                	sar    %eax
801062b9:	39 d8                	cmp    %ebx,%eax
801062bb:	7d 93                	jge    80106250 <sys_find_largest_prime_factor+0x80>
801062bd:	eb da                	jmp    80106299 <sys_find_largest_prime_factor+0xc9>
  int maxPrime = -1;
801062bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
801062c4:	e9 3b ff ff ff       	jmp    80106204 <sys_find_largest_prime_factor+0x34>
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_get_callers>:

int 
sys_get_callers(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 20             	sub    $0x20,%esp
  int sys_call_number;
  if (argint(0, &sys_call_number) < 0)
801062d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062d9:	50                   	push   %eax
801062da:	6a 00                	push   $0x0
801062dc:	e8 af ef ff ff       	call   80105290 <argint>
801062e1:	83 c4 10             	add    $0x10,%esp
801062e4:	85 c0                	test   %eax,%eax
801062e6:	78 18                	js     80106300 <sys_get_callers+0x30>
    return -1;

  get_callers(sys_call_number);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	ff 75 f4             	push   -0xc(%ebp)
801062ee:	e8 ad e4 ff ff       	call   801047a0 <get_callers>
  return 0;
801062f3:	83 c4 10             	add    $0x10,%esp
801062f6:	31 c0                	xor    %eax,%eax
}
801062f8:	c9                   	leave  
801062f9:	c3                   	ret    
801062fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106300:	c9                   	leave  
    return -1;
80106301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106306:	c3                   	ret    
80106307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630e:	66 90                	xchg   %ax,%ax

80106310 <sys_print_all_procs_status>:

void
sys_print_all_procs_status(void)
{
  print_all_procs_status();
80106310:	e9 7b e5 ff ff       	jmp    80104890 <print_all_procs_status>
80106315:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106320 <sys_set_proc_queue>:
}


void
sys_set_proc_queue(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 20             	sub    $0x20,%esp
  int pid, queue_level;
  argint(0, &pid);
80106326:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106329:	50                   	push   %eax
8010632a:	6a 00                	push   $0x0
8010632c:	e8 5f ef ff ff       	call   80105290 <argint>
  argint(1, &queue_level);
80106331:	58                   	pop    %eax
80106332:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106335:	5a                   	pop    %edx
80106336:	50                   	push   %eax
80106337:	6a 01                	push   $0x1
80106339:	e8 52 ef ff ff       	call   80105290 <argint>
  set_proc_queue(pid, queue_level);
8010633e:	59                   	pop    %ecx
8010633f:	58                   	pop    %eax
80106340:	ff 75 f4             	push   -0xc(%ebp)
80106343:	ff 75 f0             	push   -0x10(%ebp)
80106346:	e8 75 e8 ff ff       	call   80104bc0 <set_proc_queue>
8010634b:	83 c4 10             	add    $0x10,%esp
8010634e:	c9                   	leave  
8010634f:	c3                   	ret    

80106350 <alltraps>:
80106350:	1e                   	push   %ds
80106351:	06                   	push   %es
80106352:	0f a0                	push   %fs
80106354:	0f a8                	push   %gs
80106356:	60                   	pusha  
80106357:	66 b8 10 00          	mov    $0x10,%ax
8010635b:	8e d8                	mov    %eax,%ds
8010635d:	8e c0                	mov    %eax,%es
8010635f:	54                   	push   %esp
80106360:	e8 cb 00 00 00       	call   80106430 <trap>
80106365:	83 c4 04             	add    $0x4,%esp

80106368 <trapret>:
80106368:	61                   	popa   
80106369:	0f a9                	pop    %gs
8010636b:	0f a1                	pop    %fs
8010636d:	07                   	pop    %es
8010636e:	1f                   	pop    %ds
8010636f:	83 c4 08             	add    $0x8,%esp
80106372:	cf                   	iret   
80106373:	66 90                	xchg   %ax,%ax
80106375:	66 90                	xchg   %ax,%ax
80106377:	66 90                	xchg   %ax,%ax
80106379:	66 90                	xchg   %ax,%ax
8010637b:	66 90                	xchg   %ax,%ax
8010637d:	66 90                	xchg   %ax,%ax
8010637f:	90                   	nop

80106380 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106380:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106381:	31 c0                	xor    %eax,%eax
{
80106383:	89 e5                	mov    %esp,%ebp
80106385:	83 ec 08             	sub    $0x8,%esp
80106388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010638f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106390:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106397:	c7 04 c5 a2 e6 12 80 	movl   $0x8e000008,-0x7fed195e(,%eax,8)
8010639e:	08 00 00 8e 
801063a2:	66 89 14 c5 a0 e6 12 	mov    %dx,-0x7fed1960(,%eax,8)
801063a9:	80 
801063aa:	c1 ea 10             	shr    $0x10,%edx
801063ad:	66 89 14 c5 a6 e6 12 	mov    %dx,-0x7fed195a(,%eax,8)
801063b4:	80 
  for(i = 0; i < 256; i++)
801063b5:	83 c0 01             	add    $0x1,%eax
801063b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801063bd:	75 d1                	jne    80106390 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801063bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063c2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801063c7:	c7 05 a2 e8 12 80 08 	movl   $0xef000008,0x8012e8a2
801063ce:	00 00 ef 
  initlock(&tickslock, "time");
801063d1:	68 2d 85 10 80       	push   $0x8010852d
801063d6:	68 60 e6 12 80       	push   $0x8012e660
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801063db:	66 a3 a0 e8 12 80    	mov    %ax,0x8012e8a0
801063e1:	c1 e8 10             	shr    $0x10,%eax
801063e4:	66 a3 a6 e8 12 80    	mov    %ax,0x8012e8a6
  initlock(&tickslock, "time");
801063ea:	e8 51 e9 ff ff       	call   80104d40 <initlock>
}
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	c9                   	leave  
801063f3:	c3                   	ret    
801063f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ff:	90                   	nop

80106400 <idtinit>:

void
idtinit(void)
{
80106400:	55                   	push   %ebp
  pd[0] = size-1;
80106401:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106406:	89 e5                	mov    %esp,%ebp
80106408:	83 ec 10             	sub    $0x10,%esp
8010640b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010640f:	b8 a0 e6 12 80       	mov    $0x8012e6a0,%eax
80106414:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106418:	c1 e8 10             	shr    $0x10,%eax
8010641b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010641f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106422:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax

80106430 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	56                   	push   %esi
80106435:	53                   	push   %ebx
80106436:	83 ec 1c             	sub    $0x1c,%esp
80106439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010643c:	8b 43 30             	mov    0x30(%ebx),%eax
8010643f:	83 f8 40             	cmp    $0x40,%eax
80106442:	0f 84 68 01 00 00    	je     801065b0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106448:	83 e8 20             	sub    $0x20,%eax
8010644b:	83 f8 1f             	cmp    $0x1f,%eax
8010644e:	0f 87 8c 00 00 00    	ja     801064e0 <trap+0xb0>
80106454:	ff 24 85 d4 85 10 80 	jmp    *-0x7fef7a2c(,%eax,4)
8010645b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010645f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106460:	e8 9b c2 ff ff       	call   80102700 <ideintr>
    lapiceoi();
80106465:	e8 66 c9 ff ff       	call   80102dd0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010646a:	e8 c1 d9 ff ff       	call   80103e30 <myproc>
8010646f:	85 c0                	test   %eax,%eax
80106471:	74 1d                	je     80106490 <trap+0x60>
80106473:	e8 b8 d9 ff ff       	call   80103e30 <myproc>
80106478:	8b 50 24             	mov    0x24(%eax),%edx
8010647b:	85 d2                	test   %edx,%edx
8010647d:	74 11                	je     80106490 <trap+0x60>
8010647f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106483:	83 e0 03             	and    $0x3,%eax
80106486:	66 83 f8 03          	cmp    $0x3,%ax
8010648a:	0f 84 e8 01 00 00    	je     80106678 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106490:	e8 9b d9 ff ff       	call   80103e30 <myproc>
80106495:	85 c0                	test   %eax,%eax
80106497:	74 0f                	je     801064a8 <trap+0x78>
80106499:	e8 92 d9 ff ff       	call   80103e30 <myproc>
8010649e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801064a2:	0f 84 b8 00 00 00    	je     80106560 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064a8:	e8 83 d9 ff ff       	call   80103e30 <myproc>
801064ad:	85 c0                	test   %eax,%eax
801064af:	74 1d                	je     801064ce <trap+0x9e>
801064b1:	e8 7a d9 ff ff       	call   80103e30 <myproc>
801064b6:	8b 40 24             	mov    0x24(%eax),%eax
801064b9:	85 c0                	test   %eax,%eax
801064bb:	74 11                	je     801064ce <trap+0x9e>
801064bd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064c1:	83 e0 03             	and    $0x3,%eax
801064c4:	66 83 f8 03          	cmp    $0x3,%ax
801064c8:	0f 84 0f 01 00 00    	je     801065dd <trap+0x1ad>
    exit();
}
801064ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d1:	5b                   	pop    %ebx
801064d2:	5e                   	pop    %esi
801064d3:	5f                   	pop    %edi
801064d4:	5d                   	pop    %ebp
801064d5:	c3                   	ret    
801064d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801064e0:	e8 4b d9 ff ff       	call   80103e30 <myproc>
801064e5:	8b 7b 38             	mov    0x38(%ebx),%edi
801064e8:	85 c0                	test   %eax,%eax
801064ea:	0f 84 a2 01 00 00    	je     80106692 <trap+0x262>
801064f0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801064f4:	0f 84 98 01 00 00    	je     80106692 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801064fa:	0f 20 d1             	mov    %cr2,%ecx
801064fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106500:	e8 0b d9 ff ff       	call   80103e10 <cpuid>
80106505:	8b 73 30             	mov    0x30(%ebx),%esi
80106508:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010650b:	8b 43 34             	mov    0x34(%ebx),%eax
8010650e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106511:	e8 1a d9 ff ff       	call   80103e30 <myproc>
80106516:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106519:	e8 12 d9 ff ff       	call   80103e30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010651e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106521:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106524:	51                   	push   %ecx
80106525:	57                   	push   %edi
80106526:	52                   	push   %edx
80106527:	ff 75 e4             	push   -0x1c(%ebp)
8010652a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010652b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010652e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106531:	56                   	push   %esi
80106532:	ff 70 10             	push   0x10(%eax)
80106535:	68 90 85 10 80       	push   $0x80108590
8010653a:	e8 61 a1 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010653f:	83 c4 20             	add    $0x20,%esp
80106542:	e8 e9 d8 ff ff       	call   80103e30 <myproc>
80106547:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010654e:	e8 dd d8 ff ff       	call   80103e30 <myproc>
80106553:	85 c0                	test   %eax,%eax
80106555:	0f 85 18 ff ff ff    	jne    80106473 <trap+0x43>
8010655b:	e9 30 ff ff ff       	jmp    80106490 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106560:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106564:	0f 85 3e ff ff ff    	jne    801064a8 <trap+0x78>
    yield();
8010656a:	e8 41 df ff ff       	call   801044b0 <yield>
8010656f:	e9 34 ff ff ff       	jmp    801064a8 <trap+0x78>
80106574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106578:	8b 7b 38             	mov    0x38(%ebx),%edi
8010657b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010657f:	e8 8c d8 ff ff       	call   80103e10 <cpuid>
80106584:	57                   	push   %edi
80106585:	56                   	push   %esi
80106586:	50                   	push   %eax
80106587:	68 38 85 10 80       	push   $0x80108538
8010658c:	e8 0f a1 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106591:	e8 3a c8 ff ff       	call   80102dd0 <lapiceoi>
    break;
80106596:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106599:	e8 92 d8 ff ff       	call   80103e30 <myproc>
8010659e:	85 c0                	test   %eax,%eax
801065a0:	0f 85 cd fe ff ff    	jne    80106473 <trap+0x43>
801065a6:	e9 e5 fe ff ff       	jmp    80106490 <trap+0x60>
801065ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065af:	90                   	nop
    if(myproc()->killed)
801065b0:	e8 7b d8 ff ff       	call   80103e30 <myproc>
801065b5:	8b 70 24             	mov    0x24(%eax),%esi
801065b8:	85 f6                	test   %esi,%esi
801065ba:	0f 85 c8 00 00 00    	jne    80106688 <trap+0x258>
    myproc()->tf = tf;
801065c0:	e8 6b d8 ff ff       	call   80103e30 <myproc>
801065c5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801065c8:	e8 03 ee ff ff       	call   801053d0 <syscall>
    if(myproc()->killed)
801065cd:	e8 5e d8 ff ff       	call   80103e30 <myproc>
801065d2:	8b 48 24             	mov    0x24(%eax),%ecx
801065d5:	85 c9                	test   %ecx,%ecx
801065d7:	0f 84 f1 fe ff ff    	je     801064ce <trap+0x9e>
}
801065dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065e0:	5b                   	pop    %ebx
801065e1:	5e                   	pop    %esi
801065e2:	5f                   	pop    %edi
801065e3:	5d                   	pop    %ebp
      exit();
801065e4:	e9 67 dc ff ff       	jmp    80104250 <exit>
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801065f0:	e8 3b 02 00 00       	call   80106830 <uartintr>
    lapiceoi();
801065f5:	e8 d6 c7 ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065fa:	e8 31 d8 ff ff       	call   80103e30 <myproc>
801065ff:	85 c0                	test   %eax,%eax
80106601:	0f 85 6c fe ff ff    	jne    80106473 <trap+0x43>
80106607:	e9 84 fe ff ff       	jmp    80106490 <trap+0x60>
8010660c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106610:	e8 7b c6 ff ff       	call   80102c90 <kbdintr>
    lapiceoi();
80106615:	e8 b6 c7 ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010661a:	e8 11 d8 ff ff       	call   80103e30 <myproc>
8010661f:	85 c0                	test   %eax,%eax
80106621:	0f 85 4c fe ff ff    	jne    80106473 <trap+0x43>
80106627:	e9 64 fe ff ff       	jmp    80106490 <trap+0x60>
8010662c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106630:	e8 db d7 ff ff       	call   80103e10 <cpuid>
80106635:	85 c0                	test   %eax,%eax
80106637:	0f 85 28 fe ff ff    	jne    80106465 <trap+0x35>
      acquire(&tickslock);
8010663d:	83 ec 0c             	sub    $0xc,%esp
80106640:	68 60 e6 12 80       	push   $0x8012e660
80106645:	e8 c6 e8 ff ff       	call   80104f10 <acquire>
      wakeup(&ticks);
8010664a:	c7 04 24 40 e6 12 80 	movl   $0x8012e640,(%esp)
      ticks++;
80106651:	83 05 40 e6 12 80 01 	addl   $0x1,0x8012e640
      wakeup(&ticks);
80106658:	e8 63 df ff ff       	call   801045c0 <wakeup>
      release(&tickslock);
8010665d:	c7 04 24 60 e6 12 80 	movl   $0x8012e660,(%esp)
80106664:	e8 47 e8 ff ff       	call   80104eb0 <release>
80106669:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010666c:	e9 f4 fd ff ff       	jmp    80106465 <trap+0x35>
80106671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106678:	e8 d3 db ff ff       	call   80104250 <exit>
8010667d:	e9 0e fe ff ff       	jmp    80106490 <trap+0x60>
80106682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106688:	e8 c3 db ff ff       	call   80104250 <exit>
8010668d:	e9 2e ff ff ff       	jmp    801065c0 <trap+0x190>
80106692:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106695:	e8 76 d7 ff ff       	call   80103e10 <cpuid>
8010669a:	83 ec 0c             	sub    $0xc,%esp
8010669d:	56                   	push   %esi
8010669e:	57                   	push   %edi
8010669f:	50                   	push   %eax
801066a0:	ff 73 30             	push   0x30(%ebx)
801066a3:	68 5c 85 10 80       	push   $0x8010855c
801066a8:	e8 f3 9f ff ff       	call   801006a0 <cprintf>
      panic("trap");
801066ad:	83 c4 14             	add    $0x14,%esp
801066b0:	68 32 85 10 80       	push   $0x80108532
801066b5:	e8 c6 9c ff ff       	call   80100380 <panic>
801066ba:	66 90                	xchg   %ax,%ax
801066bc:	66 90                	xchg   %ax,%ax
801066be:	66 90                	xchg   %ax,%ax

801066c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801066c0:	a1 a0 ee 12 80       	mov    0x8012eea0,%eax
801066c5:	85 c0                	test   %eax,%eax
801066c7:	74 17                	je     801066e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066c9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066ce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801066cf:	a8 01                	test   $0x1,%al
801066d1:	74 0d                	je     801066e0 <uartgetc+0x20>
801066d3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801066d9:	0f b6 c0             	movzbl %al,%eax
801066dc:	c3                   	ret    
801066dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801066e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066e5:	c3                   	ret    
801066e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ed:	8d 76 00             	lea    0x0(%esi),%esi

801066f0 <uartinit>:
{
801066f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066f1:	31 c9                	xor    %ecx,%ecx
801066f3:	89 c8                	mov    %ecx,%eax
801066f5:	89 e5                	mov    %esp,%ebp
801066f7:	57                   	push   %edi
801066f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801066fd:	56                   	push   %esi
801066fe:	89 fa                	mov    %edi,%edx
80106700:	53                   	push   %ebx
80106701:	83 ec 1c             	sub    $0x1c,%esp
80106704:	ee                   	out    %al,(%dx)
80106705:	be fb 03 00 00       	mov    $0x3fb,%esi
8010670a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010670f:	89 f2                	mov    %esi,%edx
80106711:	ee                   	out    %al,(%dx)
80106712:	b8 0c 00 00 00       	mov    $0xc,%eax
80106717:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010671c:	ee                   	out    %al,(%dx)
8010671d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106722:	89 c8                	mov    %ecx,%eax
80106724:	89 da                	mov    %ebx,%edx
80106726:	ee                   	out    %al,(%dx)
80106727:	b8 03 00 00 00       	mov    $0x3,%eax
8010672c:	89 f2                	mov    %esi,%edx
8010672e:	ee                   	out    %al,(%dx)
8010672f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106734:	89 c8                	mov    %ecx,%eax
80106736:	ee                   	out    %al,(%dx)
80106737:	b8 01 00 00 00       	mov    $0x1,%eax
8010673c:	89 da                	mov    %ebx,%edx
8010673e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010673f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106744:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106745:	3c ff                	cmp    $0xff,%al
80106747:	74 78                	je     801067c1 <uartinit+0xd1>
  uart = 1;
80106749:	c7 05 a0 ee 12 80 01 	movl   $0x1,0x8012eea0
80106750:	00 00 00 
80106753:	89 fa                	mov    %edi,%edx
80106755:	ec                   	in     (%dx),%al
80106756:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010675b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010675c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010675f:	bf 54 86 10 80       	mov    $0x80108654,%edi
80106764:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106769:	6a 00                	push   $0x0
8010676b:	6a 04                	push   $0x4
8010676d:	e8 ce c1 ff ff       	call   80102940 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106772:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106776:	83 c4 10             	add    $0x10,%esp
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106780:	a1 a0 ee 12 80       	mov    0x8012eea0,%eax
80106785:	bb 80 00 00 00       	mov    $0x80,%ebx
8010678a:	85 c0                	test   %eax,%eax
8010678c:	75 14                	jne    801067a2 <uartinit+0xb2>
8010678e:	eb 23                	jmp    801067b3 <uartinit+0xc3>
    microdelay(10);
80106790:	83 ec 0c             	sub    $0xc,%esp
80106793:	6a 0a                	push   $0xa
80106795:	e8 56 c6 ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010679a:	83 c4 10             	add    $0x10,%esp
8010679d:	83 eb 01             	sub    $0x1,%ebx
801067a0:	74 07                	je     801067a9 <uartinit+0xb9>
801067a2:	89 f2                	mov    %esi,%edx
801067a4:	ec                   	in     (%dx),%al
801067a5:	a8 20                	test   $0x20,%al
801067a7:	74 e7                	je     80106790 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067a9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801067ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067b2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801067b3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801067b7:	83 c7 01             	add    $0x1,%edi
801067ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801067bd:	84 c0                	test   %al,%al
801067bf:	75 bf                	jne    80106780 <uartinit+0x90>
}
801067c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067c4:	5b                   	pop    %ebx
801067c5:	5e                   	pop    %esi
801067c6:	5f                   	pop    %edi
801067c7:	5d                   	pop    %ebp
801067c8:	c3                   	ret    
801067c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067d0 <uartputc>:
  if(!uart)
801067d0:	a1 a0 ee 12 80       	mov    0x8012eea0,%eax
801067d5:	85 c0                	test   %eax,%eax
801067d7:	74 47                	je     80106820 <uartputc+0x50>
{
801067d9:	55                   	push   %ebp
801067da:	89 e5                	mov    %esp,%ebp
801067dc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801067e2:	53                   	push   %ebx
801067e3:	bb 80 00 00 00       	mov    $0x80,%ebx
801067e8:	eb 18                	jmp    80106802 <uartputc+0x32>
801067ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	6a 0a                	push   $0xa
801067f5:	e8 f6 c5 ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801067fa:	83 c4 10             	add    $0x10,%esp
801067fd:	83 eb 01             	sub    $0x1,%ebx
80106800:	74 07                	je     80106809 <uartputc+0x39>
80106802:	89 f2                	mov    %esi,%edx
80106804:	ec                   	in     (%dx),%al
80106805:	a8 20                	test   $0x20,%al
80106807:	74 e7                	je     801067f0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106809:	8b 45 08             	mov    0x8(%ebp),%eax
8010680c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106811:	ee                   	out    %al,(%dx)
}
80106812:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106815:	5b                   	pop    %ebx
80106816:	5e                   	pop    %esi
80106817:	5d                   	pop    %ebp
80106818:	c3                   	ret    
80106819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106820:	c3                   	ret    
80106821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682f:	90                   	nop

80106830 <uartintr>:

void
uartintr(void)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106836:	68 c0 66 10 80       	push   $0x801066c0
8010683b:	e8 b0 a4 ff ff       	call   80100cf0 <consoleintr>
}
80106840:	83 c4 10             	add    $0x10,%esp
80106843:	c9                   	leave  
80106844:	c3                   	ret    

80106845 <vector0>:
80106845:	6a 00                	push   $0x0
80106847:	6a 00                	push   $0x0
80106849:	e9 02 fb ff ff       	jmp    80106350 <alltraps>

8010684e <vector1>:
8010684e:	6a 00                	push   $0x0
80106850:	6a 01                	push   $0x1
80106852:	e9 f9 fa ff ff       	jmp    80106350 <alltraps>

80106857 <vector2>:
80106857:	6a 00                	push   $0x0
80106859:	6a 02                	push   $0x2
8010685b:	e9 f0 fa ff ff       	jmp    80106350 <alltraps>

80106860 <vector3>:
80106860:	6a 00                	push   $0x0
80106862:	6a 03                	push   $0x3
80106864:	e9 e7 fa ff ff       	jmp    80106350 <alltraps>

80106869 <vector4>:
80106869:	6a 00                	push   $0x0
8010686b:	6a 04                	push   $0x4
8010686d:	e9 de fa ff ff       	jmp    80106350 <alltraps>

80106872 <vector5>:
80106872:	6a 00                	push   $0x0
80106874:	6a 05                	push   $0x5
80106876:	e9 d5 fa ff ff       	jmp    80106350 <alltraps>

8010687b <vector6>:
8010687b:	6a 00                	push   $0x0
8010687d:	6a 06                	push   $0x6
8010687f:	e9 cc fa ff ff       	jmp    80106350 <alltraps>

80106884 <vector7>:
80106884:	6a 00                	push   $0x0
80106886:	6a 07                	push   $0x7
80106888:	e9 c3 fa ff ff       	jmp    80106350 <alltraps>

8010688d <vector8>:
8010688d:	6a 08                	push   $0x8
8010688f:	e9 bc fa ff ff       	jmp    80106350 <alltraps>

80106894 <vector9>:
80106894:	6a 00                	push   $0x0
80106896:	6a 09                	push   $0x9
80106898:	e9 b3 fa ff ff       	jmp    80106350 <alltraps>

8010689d <vector10>:
8010689d:	6a 0a                	push   $0xa
8010689f:	e9 ac fa ff ff       	jmp    80106350 <alltraps>

801068a4 <vector11>:
801068a4:	6a 0b                	push   $0xb
801068a6:	e9 a5 fa ff ff       	jmp    80106350 <alltraps>

801068ab <vector12>:
801068ab:	6a 0c                	push   $0xc
801068ad:	e9 9e fa ff ff       	jmp    80106350 <alltraps>

801068b2 <vector13>:
801068b2:	6a 0d                	push   $0xd
801068b4:	e9 97 fa ff ff       	jmp    80106350 <alltraps>

801068b9 <vector14>:
801068b9:	6a 0e                	push   $0xe
801068bb:	e9 90 fa ff ff       	jmp    80106350 <alltraps>

801068c0 <vector15>:
801068c0:	6a 00                	push   $0x0
801068c2:	6a 0f                	push   $0xf
801068c4:	e9 87 fa ff ff       	jmp    80106350 <alltraps>

801068c9 <vector16>:
801068c9:	6a 00                	push   $0x0
801068cb:	6a 10                	push   $0x10
801068cd:	e9 7e fa ff ff       	jmp    80106350 <alltraps>

801068d2 <vector17>:
801068d2:	6a 11                	push   $0x11
801068d4:	e9 77 fa ff ff       	jmp    80106350 <alltraps>

801068d9 <vector18>:
801068d9:	6a 00                	push   $0x0
801068db:	6a 12                	push   $0x12
801068dd:	e9 6e fa ff ff       	jmp    80106350 <alltraps>

801068e2 <vector19>:
801068e2:	6a 00                	push   $0x0
801068e4:	6a 13                	push   $0x13
801068e6:	e9 65 fa ff ff       	jmp    80106350 <alltraps>

801068eb <vector20>:
801068eb:	6a 00                	push   $0x0
801068ed:	6a 14                	push   $0x14
801068ef:	e9 5c fa ff ff       	jmp    80106350 <alltraps>

801068f4 <vector21>:
801068f4:	6a 00                	push   $0x0
801068f6:	6a 15                	push   $0x15
801068f8:	e9 53 fa ff ff       	jmp    80106350 <alltraps>

801068fd <vector22>:
801068fd:	6a 00                	push   $0x0
801068ff:	6a 16                	push   $0x16
80106901:	e9 4a fa ff ff       	jmp    80106350 <alltraps>

80106906 <vector23>:
80106906:	6a 00                	push   $0x0
80106908:	6a 17                	push   $0x17
8010690a:	e9 41 fa ff ff       	jmp    80106350 <alltraps>

8010690f <vector24>:
8010690f:	6a 00                	push   $0x0
80106911:	6a 18                	push   $0x18
80106913:	e9 38 fa ff ff       	jmp    80106350 <alltraps>

80106918 <vector25>:
80106918:	6a 00                	push   $0x0
8010691a:	6a 19                	push   $0x19
8010691c:	e9 2f fa ff ff       	jmp    80106350 <alltraps>

80106921 <vector26>:
80106921:	6a 00                	push   $0x0
80106923:	6a 1a                	push   $0x1a
80106925:	e9 26 fa ff ff       	jmp    80106350 <alltraps>

8010692a <vector27>:
8010692a:	6a 00                	push   $0x0
8010692c:	6a 1b                	push   $0x1b
8010692e:	e9 1d fa ff ff       	jmp    80106350 <alltraps>

80106933 <vector28>:
80106933:	6a 00                	push   $0x0
80106935:	6a 1c                	push   $0x1c
80106937:	e9 14 fa ff ff       	jmp    80106350 <alltraps>

8010693c <vector29>:
8010693c:	6a 00                	push   $0x0
8010693e:	6a 1d                	push   $0x1d
80106940:	e9 0b fa ff ff       	jmp    80106350 <alltraps>

80106945 <vector30>:
80106945:	6a 00                	push   $0x0
80106947:	6a 1e                	push   $0x1e
80106949:	e9 02 fa ff ff       	jmp    80106350 <alltraps>

8010694e <vector31>:
8010694e:	6a 00                	push   $0x0
80106950:	6a 1f                	push   $0x1f
80106952:	e9 f9 f9 ff ff       	jmp    80106350 <alltraps>

80106957 <vector32>:
80106957:	6a 00                	push   $0x0
80106959:	6a 20                	push   $0x20
8010695b:	e9 f0 f9 ff ff       	jmp    80106350 <alltraps>

80106960 <vector33>:
80106960:	6a 00                	push   $0x0
80106962:	6a 21                	push   $0x21
80106964:	e9 e7 f9 ff ff       	jmp    80106350 <alltraps>

80106969 <vector34>:
80106969:	6a 00                	push   $0x0
8010696b:	6a 22                	push   $0x22
8010696d:	e9 de f9 ff ff       	jmp    80106350 <alltraps>

80106972 <vector35>:
80106972:	6a 00                	push   $0x0
80106974:	6a 23                	push   $0x23
80106976:	e9 d5 f9 ff ff       	jmp    80106350 <alltraps>

8010697b <vector36>:
8010697b:	6a 00                	push   $0x0
8010697d:	6a 24                	push   $0x24
8010697f:	e9 cc f9 ff ff       	jmp    80106350 <alltraps>

80106984 <vector37>:
80106984:	6a 00                	push   $0x0
80106986:	6a 25                	push   $0x25
80106988:	e9 c3 f9 ff ff       	jmp    80106350 <alltraps>

8010698d <vector38>:
8010698d:	6a 00                	push   $0x0
8010698f:	6a 26                	push   $0x26
80106991:	e9 ba f9 ff ff       	jmp    80106350 <alltraps>

80106996 <vector39>:
80106996:	6a 00                	push   $0x0
80106998:	6a 27                	push   $0x27
8010699a:	e9 b1 f9 ff ff       	jmp    80106350 <alltraps>

8010699f <vector40>:
8010699f:	6a 00                	push   $0x0
801069a1:	6a 28                	push   $0x28
801069a3:	e9 a8 f9 ff ff       	jmp    80106350 <alltraps>

801069a8 <vector41>:
801069a8:	6a 00                	push   $0x0
801069aa:	6a 29                	push   $0x29
801069ac:	e9 9f f9 ff ff       	jmp    80106350 <alltraps>

801069b1 <vector42>:
801069b1:	6a 00                	push   $0x0
801069b3:	6a 2a                	push   $0x2a
801069b5:	e9 96 f9 ff ff       	jmp    80106350 <alltraps>

801069ba <vector43>:
801069ba:	6a 00                	push   $0x0
801069bc:	6a 2b                	push   $0x2b
801069be:	e9 8d f9 ff ff       	jmp    80106350 <alltraps>

801069c3 <vector44>:
801069c3:	6a 00                	push   $0x0
801069c5:	6a 2c                	push   $0x2c
801069c7:	e9 84 f9 ff ff       	jmp    80106350 <alltraps>

801069cc <vector45>:
801069cc:	6a 00                	push   $0x0
801069ce:	6a 2d                	push   $0x2d
801069d0:	e9 7b f9 ff ff       	jmp    80106350 <alltraps>

801069d5 <vector46>:
801069d5:	6a 00                	push   $0x0
801069d7:	6a 2e                	push   $0x2e
801069d9:	e9 72 f9 ff ff       	jmp    80106350 <alltraps>

801069de <vector47>:
801069de:	6a 00                	push   $0x0
801069e0:	6a 2f                	push   $0x2f
801069e2:	e9 69 f9 ff ff       	jmp    80106350 <alltraps>

801069e7 <vector48>:
801069e7:	6a 00                	push   $0x0
801069e9:	6a 30                	push   $0x30
801069eb:	e9 60 f9 ff ff       	jmp    80106350 <alltraps>

801069f0 <vector49>:
801069f0:	6a 00                	push   $0x0
801069f2:	6a 31                	push   $0x31
801069f4:	e9 57 f9 ff ff       	jmp    80106350 <alltraps>

801069f9 <vector50>:
801069f9:	6a 00                	push   $0x0
801069fb:	6a 32                	push   $0x32
801069fd:	e9 4e f9 ff ff       	jmp    80106350 <alltraps>

80106a02 <vector51>:
80106a02:	6a 00                	push   $0x0
80106a04:	6a 33                	push   $0x33
80106a06:	e9 45 f9 ff ff       	jmp    80106350 <alltraps>

80106a0b <vector52>:
80106a0b:	6a 00                	push   $0x0
80106a0d:	6a 34                	push   $0x34
80106a0f:	e9 3c f9 ff ff       	jmp    80106350 <alltraps>

80106a14 <vector53>:
80106a14:	6a 00                	push   $0x0
80106a16:	6a 35                	push   $0x35
80106a18:	e9 33 f9 ff ff       	jmp    80106350 <alltraps>

80106a1d <vector54>:
80106a1d:	6a 00                	push   $0x0
80106a1f:	6a 36                	push   $0x36
80106a21:	e9 2a f9 ff ff       	jmp    80106350 <alltraps>

80106a26 <vector55>:
80106a26:	6a 00                	push   $0x0
80106a28:	6a 37                	push   $0x37
80106a2a:	e9 21 f9 ff ff       	jmp    80106350 <alltraps>

80106a2f <vector56>:
80106a2f:	6a 00                	push   $0x0
80106a31:	6a 38                	push   $0x38
80106a33:	e9 18 f9 ff ff       	jmp    80106350 <alltraps>

80106a38 <vector57>:
80106a38:	6a 00                	push   $0x0
80106a3a:	6a 39                	push   $0x39
80106a3c:	e9 0f f9 ff ff       	jmp    80106350 <alltraps>

80106a41 <vector58>:
80106a41:	6a 00                	push   $0x0
80106a43:	6a 3a                	push   $0x3a
80106a45:	e9 06 f9 ff ff       	jmp    80106350 <alltraps>

80106a4a <vector59>:
80106a4a:	6a 00                	push   $0x0
80106a4c:	6a 3b                	push   $0x3b
80106a4e:	e9 fd f8 ff ff       	jmp    80106350 <alltraps>

80106a53 <vector60>:
80106a53:	6a 00                	push   $0x0
80106a55:	6a 3c                	push   $0x3c
80106a57:	e9 f4 f8 ff ff       	jmp    80106350 <alltraps>

80106a5c <vector61>:
80106a5c:	6a 00                	push   $0x0
80106a5e:	6a 3d                	push   $0x3d
80106a60:	e9 eb f8 ff ff       	jmp    80106350 <alltraps>

80106a65 <vector62>:
80106a65:	6a 00                	push   $0x0
80106a67:	6a 3e                	push   $0x3e
80106a69:	e9 e2 f8 ff ff       	jmp    80106350 <alltraps>

80106a6e <vector63>:
80106a6e:	6a 00                	push   $0x0
80106a70:	6a 3f                	push   $0x3f
80106a72:	e9 d9 f8 ff ff       	jmp    80106350 <alltraps>

80106a77 <vector64>:
80106a77:	6a 00                	push   $0x0
80106a79:	6a 40                	push   $0x40
80106a7b:	e9 d0 f8 ff ff       	jmp    80106350 <alltraps>

80106a80 <vector65>:
80106a80:	6a 00                	push   $0x0
80106a82:	6a 41                	push   $0x41
80106a84:	e9 c7 f8 ff ff       	jmp    80106350 <alltraps>

80106a89 <vector66>:
80106a89:	6a 00                	push   $0x0
80106a8b:	6a 42                	push   $0x42
80106a8d:	e9 be f8 ff ff       	jmp    80106350 <alltraps>

80106a92 <vector67>:
80106a92:	6a 00                	push   $0x0
80106a94:	6a 43                	push   $0x43
80106a96:	e9 b5 f8 ff ff       	jmp    80106350 <alltraps>

80106a9b <vector68>:
80106a9b:	6a 00                	push   $0x0
80106a9d:	6a 44                	push   $0x44
80106a9f:	e9 ac f8 ff ff       	jmp    80106350 <alltraps>

80106aa4 <vector69>:
80106aa4:	6a 00                	push   $0x0
80106aa6:	6a 45                	push   $0x45
80106aa8:	e9 a3 f8 ff ff       	jmp    80106350 <alltraps>

80106aad <vector70>:
80106aad:	6a 00                	push   $0x0
80106aaf:	6a 46                	push   $0x46
80106ab1:	e9 9a f8 ff ff       	jmp    80106350 <alltraps>

80106ab6 <vector71>:
80106ab6:	6a 00                	push   $0x0
80106ab8:	6a 47                	push   $0x47
80106aba:	e9 91 f8 ff ff       	jmp    80106350 <alltraps>

80106abf <vector72>:
80106abf:	6a 00                	push   $0x0
80106ac1:	6a 48                	push   $0x48
80106ac3:	e9 88 f8 ff ff       	jmp    80106350 <alltraps>

80106ac8 <vector73>:
80106ac8:	6a 00                	push   $0x0
80106aca:	6a 49                	push   $0x49
80106acc:	e9 7f f8 ff ff       	jmp    80106350 <alltraps>

80106ad1 <vector74>:
80106ad1:	6a 00                	push   $0x0
80106ad3:	6a 4a                	push   $0x4a
80106ad5:	e9 76 f8 ff ff       	jmp    80106350 <alltraps>

80106ada <vector75>:
80106ada:	6a 00                	push   $0x0
80106adc:	6a 4b                	push   $0x4b
80106ade:	e9 6d f8 ff ff       	jmp    80106350 <alltraps>

80106ae3 <vector76>:
80106ae3:	6a 00                	push   $0x0
80106ae5:	6a 4c                	push   $0x4c
80106ae7:	e9 64 f8 ff ff       	jmp    80106350 <alltraps>

80106aec <vector77>:
80106aec:	6a 00                	push   $0x0
80106aee:	6a 4d                	push   $0x4d
80106af0:	e9 5b f8 ff ff       	jmp    80106350 <alltraps>

80106af5 <vector78>:
80106af5:	6a 00                	push   $0x0
80106af7:	6a 4e                	push   $0x4e
80106af9:	e9 52 f8 ff ff       	jmp    80106350 <alltraps>

80106afe <vector79>:
80106afe:	6a 00                	push   $0x0
80106b00:	6a 4f                	push   $0x4f
80106b02:	e9 49 f8 ff ff       	jmp    80106350 <alltraps>

80106b07 <vector80>:
80106b07:	6a 00                	push   $0x0
80106b09:	6a 50                	push   $0x50
80106b0b:	e9 40 f8 ff ff       	jmp    80106350 <alltraps>

80106b10 <vector81>:
80106b10:	6a 00                	push   $0x0
80106b12:	6a 51                	push   $0x51
80106b14:	e9 37 f8 ff ff       	jmp    80106350 <alltraps>

80106b19 <vector82>:
80106b19:	6a 00                	push   $0x0
80106b1b:	6a 52                	push   $0x52
80106b1d:	e9 2e f8 ff ff       	jmp    80106350 <alltraps>

80106b22 <vector83>:
80106b22:	6a 00                	push   $0x0
80106b24:	6a 53                	push   $0x53
80106b26:	e9 25 f8 ff ff       	jmp    80106350 <alltraps>

80106b2b <vector84>:
80106b2b:	6a 00                	push   $0x0
80106b2d:	6a 54                	push   $0x54
80106b2f:	e9 1c f8 ff ff       	jmp    80106350 <alltraps>

80106b34 <vector85>:
80106b34:	6a 00                	push   $0x0
80106b36:	6a 55                	push   $0x55
80106b38:	e9 13 f8 ff ff       	jmp    80106350 <alltraps>

80106b3d <vector86>:
80106b3d:	6a 00                	push   $0x0
80106b3f:	6a 56                	push   $0x56
80106b41:	e9 0a f8 ff ff       	jmp    80106350 <alltraps>

80106b46 <vector87>:
80106b46:	6a 00                	push   $0x0
80106b48:	6a 57                	push   $0x57
80106b4a:	e9 01 f8 ff ff       	jmp    80106350 <alltraps>

80106b4f <vector88>:
80106b4f:	6a 00                	push   $0x0
80106b51:	6a 58                	push   $0x58
80106b53:	e9 f8 f7 ff ff       	jmp    80106350 <alltraps>

80106b58 <vector89>:
80106b58:	6a 00                	push   $0x0
80106b5a:	6a 59                	push   $0x59
80106b5c:	e9 ef f7 ff ff       	jmp    80106350 <alltraps>

80106b61 <vector90>:
80106b61:	6a 00                	push   $0x0
80106b63:	6a 5a                	push   $0x5a
80106b65:	e9 e6 f7 ff ff       	jmp    80106350 <alltraps>

80106b6a <vector91>:
80106b6a:	6a 00                	push   $0x0
80106b6c:	6a 5b                	push   $0x5b
80106b6e:	e9 dd f7 ff ff       	jmp    80106350 <alltraps>

80106b73 <vector92>:
80106b73:	6a 00                	push   $0x0
80106b75:	6a 5c                	push   $0x5c
80106b77:	e9 d4 f7 ff ff       	jmp    80106350 <alltraps>

80106b7c <vector93>:
80106b7c:	6a 00                	push   $0x0
80106b7e:	6a 5d                	push   $0x5d
80106b80:	e9 cb f7 ff ff       	jmp    80106350 <alltraps>

80106b85 <vector94>:
80106b85:	6a 00                	push   $0x0
80106b87:	6a 5e                	push   $0x5e
80106b89:	e9 c2 f7 ff ff       	jmp    80106350 <alltraps>

80106b8e <vector95>:
80106b8e:	6a 00                	push   $0x0
80106b90:	6a 5f                	push   $0x5f
80106b92:	e9 b9 f7 ff ff       	jmp    80106350 <alltraps>

80106b97 <vector96>:
80106b97:	6a 00                	push   $0x0
80106b99:	6a 60                	push   $0x60
80106b9b:	e9 b0 f7 ff ff       	jmp    80106350 <alltraps>

80106ba0 <vector97>:
80106ba0:	6a 00                	push   $0x0
80106ba2:	6a 61                	push   $0x61
80106ba4:	e9 a7 f7 ff ff       	jmp    80106350 <alltraps>

80106ba9 <vector98>:
80106ba9:	6a 00                	push   $0x0
80106bab:	6a 62                	push   $0x62
80106bad:	e9 9e f7 ff ff       	jmp    80106350 <alltraps>

80106bb2 <vector99>:
80106bb2:	6a 00                	push   $0x0
80106bb4:	6a 63                	push   $0x63
80106bb6:	e9 95 f7 ff ff       	jmp    80106350 <alltraps>

80106bbb <vector100>:
80106bbb:	6a 00                	push   $0x0
80106bbd:	6a 64                	push   $0x64
80106bbf:	e9 8c f7 ff ff       	jmp    80106350 <alltraps>

80106bc4 <vector101>:
80106bc4:	6a 00                	push   $0x0
80106bc6:	6a 65                	push   $0x65
80106bc8:	e9 83 f7 ff ff       	jmp    80106350 <alltraps>

80106bcd <vector102>:
80106bcd:	6a 00                	push   $0x0
80106bcf:	6a 66                	push   $0x66
80106bd1:	e9 7a f7 ff ff       	jmp    80106350 <alltraps>

80106bd6 <vector103>:
80106bd6:	6a 00                	push   $0x0
80106bd8:	6a 67                	push   $0x67
80106bda:	e9 71 f7 ff ff       	jmp    80106350 <alltraps>

80106bdf <vector104>:
80106bdf:	6a 00                	push   $0x0
80106be1:	6a 68                	push   $0x68
80106be3:	e9 68 f7 ff ff       	jmp    80106350 <alltraps>

80106be8 <vector105>:
80106be8:	6a 00                	push   $0x0
80106bea:	6a 69                	push   $0x69
80106bec:	e9 5f f7 ff ff       	jmp    80106350 <alltraps>

80106bf1 <vector106>:
80106bf1:	6a 00                	push   $0x0
80106bf3:	6a 6a                	push   $0x6a
80106bf5:	e9 56 f7 ff ff       	jmp    80106350 <alltraps>

80106bfa <vector107>:
80106bfa:	6a 00                	push   $0x0
80106bfc:	6a 6b                	push   $0x6b
80106bfe:	e9 4d f7 ff ff       	jmp    80106350 <alltraps>

80106c03 <vector108>:
80106c03:	6a 00                	push   $0x0
80106c05:	6a 6c                	push   $0x6c
80106c07:	e9 44 f7 ff ff       	jmp    80106350 <alltraps>

80106c0c <vector109>:
80106c0c:	6a 00                	push   $0x0
80106c0e:	6a 6d                	push   $0x6d
80106c10:	e9 3b f7 ff ff       	jmp    80106350 <alltraps>

80106c15 <vector110>:
80106c15:	6a 00                	push   $0x0
80106c17:	6a 6e                	push   $0x6e
80106c19:	e9 32 f7 ff ff       	jmp    80106350 <alltraps>

80106c1e <vector111>:
80106c1e:	6a 00                	push   $0x0
80106c20:	6a 6f                	push   $0x6f
80106c22:	e9 29 f7 ff ff       	jmp    80106350 <alltraps>

80106c27 <vector112>:
80106c27:	6a 00                	push   $0x0
80106c29:	6a 70                	push   $0x70
80106c2b:	e9 20 f7 ff ff       	jmp    80106350 <alltraps>

80106c30 <vector113>:
80106c30:	6a 00                	push   $0x0
80106c32:	6a 71                	push   $0x71
80106c34:	e9 17 f7 ff ff       	jmp    80106350 <alltraps>

80106c39 <vector114>:
80106c39:	6a 00                	push   $0x0
80106c3b:	6a 72                	push   $0x72
80106c3d:	e9 0e f7 ff ff       	jmp    80106350 <alltraps>

80106c42 <vector115>:
80106c42:	6a 00                	push   $0x0
80106c44:	6a 73                	push   $0x73
80106c46:	e9 05 f7 ff ff       	jmp    80106350 <alltraps>

80106c4b <vector116>:
80106c4b:	6a 00                	push   $0x0
80106c4d:	6a 74                	push   $0x74
80106c4f:	e9 fc f6 ff ff       	jmp    80106350 <alltraps>

80106c54 <vector117>:
80106c54:	6a 00                	push   $0x0
80106c56:	6a 75                	push   $0x75
80106c58:	e9 f3 f6 ff ff       	jmp    80106350 <alltraps>

80106c5d <vector118>:
80106c5d:	6a 00                	push   $0x0
80106c5f:	6a 76                	push   $0x76
80106c61:	e9 ea f6 ff ff       	jmp    80106350 <alltraps>

80106c66 <vector119>:
80106c66:	6a 00                	push   $0x0
80106c68:	6a 77                	push   $0x77
80106c6a:	e9 e1 f6 ff ff       	jmp    80106350 <alltraps>

80106c6f <vector120>:
80106c6f:	6a 00                	push   $0x0
80106c71:	6a 78                	push   $0x78
80106c73:	e9 d8 f6 ff ff       	jmp    80106350 <alltraps>

80106c78 <vector121>:
80106c78:	6a 00                	push   $0x0
80106c7a:	6a 79                	push   $0x79
80106c7c:	e9 cf f6 ff ff       	jmp    80106350 <alltraps>

80106c81 <vector122>:
80106c81:	6a 00                	push   $0x0
80106c83:	6a 7a                	push   $0x7a
80106c85:	e9 c6 f6 ff ff       	jmp    80106350 <alltraps>

80106c8a <vector123>:
80106c8a:	6a 00                	push   $0x0
80106c8c:	6a 7b                	push   $0x7b
80106c8e:	e9 bd f6 ff ff       	jmp    80106350 <alltraps>

80106c93 <vector124>:
80106c93:	6a 00                	push   $0x0
80106c95:	6a 7c                	push   $0x7c
80106c97:	e9 b4 f6 ff ff       	jmp    80106350 <alltraps>

80106c9c <vector125>:
80106c9c:	6a 00                	push   $0x0
80106c9e:	6a 7d                	push   $0x7d
80106ca0:	e9 ab f6 ff ff       	jmp    80106350 <alltraps>

80106ca5 <vector126>:
80106ca5:	6a 00                	push   $0x0
80106ca7:	6a 7e                	push   $0x7e
80106ca9:	e9 a2 f6 ff ff       	jmp    80106350 <alltraps>

80106cae <vector127>:
80106cae:	6a 00                	push   $0x0
80106cb0:	6a 7f                	push   $0x7f
80106cb2:	e9 99 f6 ff ff       	jmp    80106350 <alltraps>

80106cb7 <vector128>:
80106cb7:	6a 00                	push   $0x0
80106cb9:	68 80 00 00 00       	push   $0x80
80106cbe:	e9 8d f6 ff ff       	jmp    80106350 <alltraps>

80106cc3 <vector129>:
80106cc3:	6a 00                	push   $0x0
80106cc5:	68 81 00 00 00       	push   $0x81
80106cca:	e9 81 f6 ff ff       	jmp    80106350 <alltraps>

80106ccf <vector130>:
80106ccf:	6a 00                	push   $0x0
80106cd1:	68 82 00 00 00       	push   $0x82
80106cd6:	e9 75 f6 ff ff       	jmp    80106350 <alltraps>

80106cdb <vector131>:
80106cdb:	6a 00                	push   $0x0
80106cdd:	68 83 00 00 00       	push   $0x83
80106ce2:	e9 69 f6 ff ff       	jmp    80106350 <alltraps>

80106ce7 <vector132>:
80106ce7:	6a 00                	push   $0x0
80106ce9:	68 84 00 00 00       	push   $0x84
80106cee:	e9 5d f6 ff ff       	jmp    80106350 <alltraps>

80106cf3 <vector133>:
80106cf3:	6a 00                	push   $0x0
80106cf5:	68 85 00 00 00       	push   $0x85
80106cfa:	e9 51 f6 ff ff       	jmp    80106350 <alltraps>

80106cff <vector134>:
80106cff:	6a 00                	push   $0x0
80106d01:	68 86 00 00 00       	push   $0x86
80106d06:	e9 45 f6 ff ff       	jmp    80106350 <alltraps>

80106d0b <vector135>:
80106d0b:	6a 00                	push   $0x0
80106d0d:	68 87 00 00 00       	push   $0x87
80106d12:	e9 39 f6 ff ff       	jmp    80106350 <alltraps>

80106d17 <vector136>:
80106d17:	6a 00                	push   $0x0
80106d19:	68 88 00 00 00       	push   $0x88
80106d1e:	e9 2d f6 ff ff       	jmp    80106350 <alltraps>

80106d23 <vector137>:
80106d23:	6a 00                	push   $0x0
80106d25:	68 89 00 00 00       	push   $0x89
80106d2a:	e9 21 f6 ff ff       	jmp    80106350 <alltraps>

80106d2f <vector138>:
80106d2f:	6a 00                	push   $0x0
80106d31:	68 8a 00 00 00       	push   $0x8a
80106d36:	e9 15 f6 ff ff       	jmp    80106350 <alltraps>

80106d3b <vector139>:
80106d3b:	6a 00                	push   $0x0
80106d3d:	68 8b 00 00 00       	push   $0x8b
80106d42:	e9 09 f6 ff ff       	jmp    80106350 <alltraps>

80106d47 <vector140>:
80106d47:	6a 00                	push   $0x0
80106d49:	68 8c 00 00 00       	push   $0x8c
80106d4e:	e9 fd f5 ff ff       	jmp    80106350 <alltraps>

80106d53 <vector141>:
80106d53:	6a 00                	push   $0x0
80106d55:	68 8d 00 00 00       	push   $0x8d
80106d5a:	e9 f1 f5 ff ff       	jmp    80106350 <alltraps>

80106d5f <vector142>:
80106d5f:	6a 00                	push   $0x0
80106d61:	68 8e 00 00 00       	push   $0x8e
80106d66:	e9 e5 f5 ff ff       	jmp    80106350 <alltraps>

80106d6b <vector143>:
80106d6b:	6a 00                	push   $0x0
80106d6d:	68 8f 00 00 00       	push   $0x8f
80106d72:	e9 d9 f5 ff ff       	jmp    80106350 <alltraps>

80106d77 <vector144>:
80106d77:	6a 00                	push   $0x0
80106d79:	68 90 00 00 00       	push   $0x90
80106d7e:	e9 cd f5 ff ff       	jmp    80106350 <alltraps>

80106d83 <vector145>:
80106d83:	6a 00                	push   $0x0
80106d85:	68 91 00 00 00       	push   $0x91
80106d8a:	e9 c1 f5 ff ff       	jmp    80106350 <alltraps>

80106d8f <vector146>:
80106d8f:	6a 00                	push   $0x0
80106d91:	68 92 00 00 00       	push   $0x92
80106d96:	e9 b5 f5 ff ff       	jmp    80106350 <alltraps>

80106d9b <vector147>:
80106d9b:	6a 00                	push   $0x0
80106d9d:	68 93 00 00 00       	push   $0x93
80106da2:	e9 a9 f5 ff ff       	jmp    80106350 <alltraps>

80106da7 <vector148>:
80106da7:	6a 00                	push   $0x0
80106da9:	68 94 00 00 00       	push   $0x94
80106dae:	e9 9d f5 ff ff       	jmp    80106350 <alltraps>

80106db3 <vector149>:
80106db3:	6a 00                	push   $0x0
80106db5:	68 95 00 00 00       	push   $0x95
80106dba:	e9 91 f5 ff ff       	jmp    80106350 <alltraps>

80106dbf <vector150>:
80106dbf:	6a 00                	push   $0x0
80106dc1:	68 96 00 00 00       	push   $0x96
80106dc6:	e9 85 f5 ff ff       	jmp    80106350 <alltraps>

80106dcb <vector151>:
80106dcb:	6a 00                	push   $0x0
80106dcd:	68 97 00 00 00       	push   $0x97
80106dd2:	e9 79 f5 ff ff       	jmp    80106350 <alltraps>

80106dd7 <vector152>:
80106dd7:	6a 00                	push   $0x0
80106dd9:	68 98 00 00 00       	push   $0x98
80106dde:	e9 6d f5 ff ff       	jmp    80106350 <alltraps>

80106de3 <vector153>:
80106de3:	6a 00                	push   $0x0
80106de5:	68 99 00 00 00       	push   $0x99
80106dea:	e9 61 f5 ff ff       	jmp    80106350 <alltraps>

80106def <vector154>:
80106def:	6a 00                	push   $0x0
80106df1:	68 9a 00 00 00       	push   $0x9a
80106df6:	e9 55 f5 ff ff       	jmp    80106350 <alltraps>

80106dfb <vector155>:
80106dfb:	6a 00                	push   $0x0
80106dfd:	68 9b 00 00 00       	push   $0x9b
80106e02:	e9 49 f5 ff ff       	jmp    80106350 <alltraps>

80106e07 <vector156>:
80106e07:	6a 00                	push   $0x0
80106e09:	68 9c 00 00 00       	push   $0x9c
80106e0e:	e9 3d f5 ff ff       	jmp    80106350 <alltraps>

80106e13 <vector157>:
80106e13:	6a 00                	push   $0x0
80106e15:	68 9d 00 00 00       	push   $0x9d
80106e1a:	e9 31 f5 ff ff       	jmp    80106350 <alltraps>

80106e1f <vector158>:
80106e1f:	6a 00                	push   $0x0
80106e21:	68 9e 00 00 00       	push   $0x9e
80106e26:	e9 25 f5 ff ff       	jmp    80106350 <alltraps>

80106e2b <vector159>:
80106e2b:	6a 00                	push   $0x0
80106e2d:	68 9f 00 00 00       	push   $0x9f
80106e32:	e9 19 f5 ff ff       	jmp    80106350 <alltraps>

80106e37 <vector160>:
80106e37:	6a 00                	push   $0x0
80106e39:	68 a0 00 00 00       	push   $0xa0
80106e3e:	e9 0d f5 ff ff       	jmp    80106350 <alltraps>

80106e43 <vector161>:
80106e43:	6a 00                	push   $0x0
80106e45:	68 a1 00 00 00       	push   $0xa1
80106e4a:	e9 01 f5 ff ff       	jmp    80106350 <alltraps>

80106e4f <vector162>:
80106e4f:	6a 00                	push   $0x0
80106e51:	68 a2 00 00 00       	push   $0xa2
80106e56:	e9 f5 f4 ff ff       	jmp    80106350 <alltraps>

80106e5b <vector163>:
80106e5b:	6a 00                	push   $0x0
80106e5d:	68 a3 00 00 00       	push   $0xa3
80106e62:	e9 e9 f4 ff ff       	jmp    80106350 <alltraps>

80106e67 <vector164>:
80106e67:	6a 00                	push   $0x0
80106e69:	68 a4 00 00 00       	push   $0xa4
80106e6e:	e9 dd f4 ff ff       	jmp    80106350 <alltraps>

80106e73 <vector165>:
80106e73:	6a 00                	push   $0x0
80106e75:	68 a5 00 00 00       	push   $0xa5
80106e7a:	e9 d1 f4 ff ff       	jmp    80106350 <alltraps>

80106e7f <vector166>:
80106e7f:	6a 00                	push   $0x0
80106e81:	68 a6 00 00 00       	push   $0xa6
80106e86:	e9 c5 f4 ff ff       	jmp    80106350 <alltraps>

80106e8b <vector167>:
80106e8b:	6a 00                	push   $0x0
80106e8d:	68 a7 00 00 00       	push   $0xa7
80106e92:	e9 b9 f4 ff ff       	jmp    80106350 <alltraps>

80106e97 <vector168>:
80106e97:	6a 00                	push   $0x0
80106e99:	68 a8 00 00 00       	push   $0xa8
80106e9e:	e9 ad f4 ff ff       	jmp    80106350 <alltraps>

80106ea3 <vector169>:
80106ea3:	6a 00                	push   $0x0
80106ea5:	68 a9 00 00 00       	push   $0xa9
80106eaa:	e9 a1 f4 ff ff       	jmp    80106350 <alltraps>

80106eaf <vector170>:
80106eaf:	6a 00                	push   $0x0
80106eb1:	68 aa 00 00 00       	push   $0xaa
80106eb6:	e9 95 f4 ff ff       	jmp    80106350 <alltraps>

80106ebb <vector171>:
80106ebb:	6a 00                	push   $0x0
80106ebd:	68 ab 00 00 00       	push   $0xab
80106ec2:	e9 89 f4 ff ff       	jmp    80106350 <alltraps>

80106ec7 <vector172>:
80106ec7:	6a 00                	push   $0x0
80106ec9:	68 ac 00 00 00       	push   $0xac
80106ece:	e9 7d f4 ff ff       	jmp    80106350 <alltraps>

80106ed3 <vector173>:
80106ed3:	6a 00                	push   $0x0
80106ed5:	68 ad 00 00 00       	push   $0xad
80106eda:	e9 71 f4 ff ff       	jmp    80106350 <alltraps>

80106edf <vector174>:
80106edf:	6a 00                	push   $0x0
80106ee1:	68 ae 00 00 00       	push   $0xae
80106ee6:	e9 65 f4 ff ff       	jmp    80106350 <alltraps>

80106eeb <vector175>:
80106eeb:	6a 00                	push   $0x0
80106eed:	68 af 00 00 00       	push   $0xaf
80106ef2:	e9 59 f4 ff ff       	jmp    80106350 <alltraps>

80106ef7 <vector176>:
80106ef7:	6a 00                	push   $0x0
80106ef9:	68 b0 00 00 00       	push   $0xb0
80106efe:	e9 4d f4 ff ff       	jmp    80106350 <alltraps>

80106f03 <vector177>:
80106f03:	6a 00                	push   $0x0
80106f05:	68 b1 00 00 00       	push   $0xb1
80106f0a:	e9 41 f4 ff ff       	jmp    80106350 <alltraps>

80106f0f <vector178>:
80106f0f:	6a 00                	push   $0x0
80106f11:	68 b2 00 00 00       	push   $0xb2
80106f16:	e9 35 f4 ff ff       	jmp    80106350 <alltraps>

80106f1b <vector179>:
80106f1b:	6a 00                	push   $0x0
80106f1d:	68 b3 00 00 00       	push   $0xb3
80106f22:	e9 29 f4 ff ff       	jmp    80106350 <alltraps>

80106f27 <vector180>:
80106f27:	6a 00                	push   $0x0
80106f29:	68 b4 00 00 00       	push   $0xb4
80106f2e:	e9 1d f4 ff ff       	jmp    80106350 <alltraps>

80106f33 <vector181>:
80106f33:	6a 00                	push   $0x0
80106f35:	68 b5 00 00 00       	push   $0xb5
80106f3a:	e9 11 f4 ff ff       	jmp    80106350 <alltraps>

80106f3f <vector182>:
80106f3f:	6a 00                	push   $0x0
80106f41:	68 b6 00 00 00       	push   $0xb6
80106f46:	e9 05 f4 ff ff       	jmp    80106350 <alltraps>

80106f4b <vector183>:
80106f4b:	6a 00                	push   $0x0
80106f4d:	68 b7 00 00 00       	push   $0xb7
80106f52:	e9 f9 f3 ff ff       	jmp    80106350 <alltraps>

80106f57 <vector184>:
80106f57:	6a 00                	push   $0x0
80106f59:	68 b8 00 00 00       	push   $0xb8
80106f5e:	e9 ed f3 ff ff       	jmp    80106350 <alltraps>

80106f63 <vector185>:
80106f63:	6a 00                	push   $0x0
80106f65:	68 b9 00 00 00       	push   $0xb9
80106f6a:	e9 e1 f3 ff ff       	jmp    80106350 <alltraps>

80106f6f <vector186>:
80106f6f:	6a 00                	push   $0x0
80106f71:	68 ba 00 00 00       	push   $0xba
80106f76:	e9 d5 f3 ff ff       	jmp    80106350 <alltraps>

80106f7b <vector187>:
80106f7b:	6a 00                	push   $0x0
80106f7d:	68 bb 00 00 00       	push   $0xbb
80106f82:	e9 c9 f3 ff ff       	jmp    80106350 <alltraps>

80106f87 <vector188>:
80106f87:	6a 00                	push   $0x0
80106f89:	68 bc 00 00 00       	push   $0xbc
80106f8e:	e9 bd f3 ff ff       	jmp    80106350 <alltraps>

80106f93 <vector189>:
80106f93:	6a 00                	push   $0x0
80106f95:	68 bd 00 00 00       	push   $0xbd
80106f9a:	e9 b1 f3 ff ff       	jmp    80106350 <alltraps>

80106f9f <vector190>:
80106f9f:	6a 00                	push   $0x0
80106fa1:	68 be 00 00 00       	push   $0xbe
80106fa6:	e9 a5 f3 ff ff       	jmp    80106350 <alltraps>

80106fab <vector191>:
80106fab:	6a 00                	push   $0x0
80106fad:	68 bf 00 00 00       	push   $0xbf
80106fb2:	e9 99 f3 ff ff       	jmp    80106350 <alltraps>

80106fb7 <vector192>:
80106fb7:	6a 00                	push   $0x0
80106fb9:	68 c0 00 00 00       	push   $0xc0
80106fbe:	e9 8d f3 ff ff       	jmp    80106350 <alltraps>

80106fc3 <vector193>:
80106fc3:	6a 00                	push   $0x0
80106fc5:	68 c1 00 00 00       	push   $0xc1
80106fca:	e9 81 f3 ff ff       	jmp    80106350 <alltraps>

80106fcf <vector194>:
80106fcf:	6a 00                	push   $0x0
80106fd1:	68 c2 00 00 00       	push   $0xc2
80106fd6:	e9 75 f3 ff ff       	jmp    80106350 <alltraps>

80106fdb <vector195>:
80106fdb:	6a 00                	push   $0x0
80106fdd:	68 c3 00 00 00       	push   $0xc3
80106fe2:	e9 69 f3 ff ff       	jmp    80106350 <alltraps>

80106fe7 <vector196>:
80106fe7:	6a 00                	push   $0x0
80106fe9:	68 c4 00 00 00       	push   $0xc4
80106fee:	e9 5d f3 ff ff       	jmp    80106350 <alltraps>

80106ff3 <vector197>:
80106ff3:	6a 00                	push   $0x0
80106ff5:	68 c5 00 00 00       	push   $0xc5
80106ffa:	e9 51 f3 ff ff       	jmp    80106350 <alltraps>

80106fff <vector198>:
80106fff:	6a 00                	push   $0x0
80107001:	68 c6 00 00 00       	push   $0xc6
80107006:	e9 45 f3 ff ff       	jmp    80106350 <alltraps>

8010700b <vector199>:
8010700b:	6a 00                	push   $0x0
8010700d:	68 c7 00 00 00       	push   $0xc7
80107012:	e9 39 f3 ff ff       	jmp    80106350 <alltraps>

80107017 <vector200>:
80107017:	6a 00                	push   $0x0
80107019:	68 c8 00 00 00       	push   $0xc8
8010701e:	e9 2d f3 ff ff       	jmp    80106350 <alltraps>

80107023 <vector201>:
80107023:	6a 00                	push   $0x0
80107025:	68 c9 00 00 00       	push   $0xc9
8010702a:	e9 21 f3 ff ff       	jmp    80106350 <alltraps>

8010702f <vector202>:
8010702f:	6a 00                	push   $0x0
80107031:	68 ca 00 00 00       	push   $0xca
80107036:	e9 15 f3 ff ff       	jmp    80106350 <alltraps>

8010703b <vector203>:
8010703b:	6a 00                	push   $0x0
8010703d:	68 cb 00 00 00       	push   $0xcb
80107042:	e9 09 f3 ff ff       	jmp    80106350 <alltraps>

80107047 <vector204>:
80107047:	6a 00                	push   $0x0
80107049:	68 cc 00 00 00       	push   $0xcc
8010704e:	e9 fd f2 ff ff       	jmp    80106350 <alltraps>

80107053 <vector205>:
80107053:	6a 00                	push   $0x0
80107055:	68 cd 00 00 00       	push   $0xcd
8010705a:	e9 f1 f2 ff ff       	jmp    80106350 <alltraps>

8010705f <vector206>:
8010705f:	6a 00                	push   $0x0
80107061:	68 ce 00 00 00       	push   $0xce
80107066:	e9 e5 f2 ff ff       	jmp    80106350 <alltraps>

8010706b <vector207>:
8010706b:	6a 00                	push   $0x0
8010706d:	68 cf 00 00 00       	push   $0xcf
80107072:	e9 d9 f2 ff ff       	jmp    80106350 <alltraps>

80107077 <vector208>:
80107077:	6a 00                	push   $0x0
80107079:	68 d0 00 00 00       	push   $0xd0
8010707e:	e9 cd f2 ff ff       	jmp    80106350 <alltraps>

80107083 <vector209>:
80107083:	6a 00                	push   $0x0
80107085:	68 d1 00 00 00       	push   $0xd1
8010708a:	e9 c1 f2 ff ff       	jmp    80106350 <alltraps>

8010708f <vector210>:
8010708f:	6a 00                	push   $0x0
80107091:	68 d2 00 00 00       	push   $0xd2
80107096:	e9 b5 f2 ff ff       	jmp    80106350 <alltraps>

8010709b <vector211>:
8010709b:	6a 00                	push   $0x0
8010709d:	68 d3 00 00 00       	push   $0xd3
801070a2:	e9 a9 f2 ff ff       	jmp    80106350 <alltraps>

801070a7 <vector212>:
801070a7:	6a 00                	push   $0x0
801070a9:	68 d4 00 00 00       	push   $0xd4
801070ae:	e9 9d f2 ff ff       	jmp    80106350 <alltraps>

801070b3 <vector213>:
801070b3:	6a 00                	push   $0x0
801070b5:	68 d5 00 00 00       	push   $0xd5
801070ba:	e9 91 f2 ff ff       	jmp    80106350 <alltraps>

801070bf <vector214>:
801070bf:	6a 00                	push   $0x0
801070c1:	68 d6 00 00 00       	push   $0xd6
801070c6:	e9 85 f2 ff ff       	jmp    80106350 <alltraps>

801070cb <vector215>:
801070cb:	6a 00                	push   $0x0
801070cd:	68 d7 00 00 00       	push   $0xd7
801070d2:	e9 79 f2 ff ff       	jmp    80106350 <alltraps>

801070d7 <vector216>:
801070d7:	6a 00                	push   $0x0
801070d9:	68 d8 00 00 00       	push   $0xd8
801070de:	e9 6d f2 ff ff       	jmp    80106350 <alltraps>

801070e3 <vector217>:
801070e3:	6a 00                	push   $0x0
801070e5:	68 d9 00 00 00       	push   $0xd9
801070ea:	e9 61 f2 ff ff       	jmp    80106350 <alltraps>

801070ef <vector218>:
801070ef:	6a 00                	push   $0x0
801070f1:	68 da 00 00 00       	push   $0xda
801070f6:	e9 55 f2 ff ff       	jmp    80106350 <alltraps>

801070fb <vector219>:
801070fb:	6a 00                	push   $0x0
801070fd:	68 db 00 00 00       	push   $0xdb
80107102:	e9 49 f2 ff ff       	jmp    80106350 <alltraps>

80107107 <vector220>:
80107107:	6a 00                	push   $0x0
80107109:	68 dc 00 00 00       	push   $0xdc
8010710e:	e9 3d f2 ff ff       	jmp    80106350 <alltraps>

80107113 <vector221>:
80107113:	6a 00                	push   $0x0
80107115:	68 dd 00 00 00       	push   $0xdd
8010711a:	e9 31 f2 ff ff       	jmp    80106350 <alltraps>

8010711f <vector222>:
8010711f:	6a 00                	push   $0x0
80107121:	68 de 00 00 00       	push   $0xde
80107126:	e9 25 f2 ff ff       	jmp    80106350 <alltraps>

8010712b <vector223>:
8010712b:	6a 00                	push   $0x0
8010712d:	68 df 00 00 00       	push   $0xdf
80107132:	e9 19 f2 ff ff       	jmp    80106350 <alltraps>

80107137 <vector224>:
80107137:	6a 00                	push   $0x0
80107139:	68 e0 00 00 00       	push   $0xe0
8010713e:	e9 0d f2 ff ff       	jmp    80106350 <alltraps>

80107143 <vector225>:
80107143:	6a 00                	push   $0x0
80107145:	68 e1 00 00 00       	push   $0xe1
8010714a:	e9 01 f2 ff ff       	jmp    80106350 <alltraps>

8010714f <vector226>:
8010714f:	6a 00                	push   $0x0
80107151:	68 e2 00 00 00       	push   $0xe2
80107156:	e9 f5 f1 ff ff       	jmp    80106350 <alltraps>

8010715b <vector227>:
8010715b:	6a 00                	push   $0x0
8010715d:	68 e3 00 00 00       	push   $0xe3
80107162:	e9 e9 f1 ff ff       	jmp    80106350 <alltraps>

80107167 <vector228>:
80107167:	6a 00                	push   $0x0
80107169:	68 e4 00 00 00       	push   $0xe4
8010716e:	e9 dd f1 ff ff       	jmp    80106350 <alltraps>

80107173 <vector229>:
80107173:	6a 00                	push   $0x0
80107175:	68 e5 00 00 00       	push   $0xe5
8010717a:	e9 d1 f1 ff ff       	jmp    80106350 <alltraps>

8010717f <vector230>:
8010717f:	6a 00                	push   $0x0
80107181:	68 e6 00 00 00       	push   $0xe6
80107186:	e9 c5 f1 ff ff       	jmp    80106350 <alltraps>

8010718b <vector231>:
8010718b:	6a 00                	push   $0x0
8010718d:	68 e7 00 00 00       	push   $0xe7
80107192:	e9 b9 f1 ff ff       	jmp    80106350 <alltraps>

80107197 <vector232>:
80107197:	6a 00                	push   $0x0
80107199:	68 e8 00 00 00       	push   $0xe8
8010719e:	e9 ad f1 ff ff       	jmp    80106350 <alltraps>

801071a3 <vector233>:
801071a3:	6a 00                	push   $0x0
801071a5:	68 e9 00 00 00       	push   $0xe9
801071aa:	e9 a1 f1 ff ff       	jmp    80106350 <alltraps>

801071af <vector234>:
801071af:	6a 00                	push   $0x0
801071b1:	68 ea 00 00 00       	push   $0xea
801071b6:	e9 95 f1 ff ff       	jmp    80106350 <alltraps>

801071bb <vector235>:
801071bb:	6a 00                	push   $0x0
801071bd:	68 eb 00 00 00       	push   $0xeb
801071c2:	e9 89 f1 ff ff       	jmp    80106350 <alltraps>

801071c7 <vector236>:
801071c7:	6a 00                	push   $0x0
801071c9:	68 ec 00 00 00       	push   $0xec
801071ce:	e9 7d f1 ff ff       	jmp    80106350 <alltraps>

801071d3 <vector237>:
801071d3:	6a 00                	push   $0x0
801071d5:	68 ed 00 00 00       	push   $0xed
801071da:	e9 71 f1 ff ff       	jmp    80106350 <alltraps>

801071df <vector238>:
801071df:	6a 00                	push   $0x0
801071e1:	68 ee 00 00 00       	push   $0xee
801071e6:	e9 65 f1 ff ff       	jmp    80106350 <alltraps>

801071eb <vector239>:
801071eb:	6a 00                	push   $0x0
801071ed:	68 ef 00 00 00       	push   $0xef
801071f2:	e9 59 f1 ff ff       	jmp    80106350 <alltraps>

801071f7 <vector240>:
801071f7:	6a 00                	push   $0x0
801071f9:	68 f0 00 00 00       	push   $0xf0
801071fe:	e9 4d f1 ff ff       	jmp    80106350 <alltraps>

80107203 <vector241>:
80107203:	6a 00                	push   $0x0
80107205:	68 f1 00 00 00       	push   $0xf1
8010720a:	e9 41 f1 ff ff       	jmp    80106350 <alltraps>

8010720f <vector242>:
8010720f:	6a 00                	push   $0x0
80107211:	68 f2 00 00 00       	push   $0xf2
80107216:	e9 35 f1 ff ff       	jmp    80106350 <alltraps>

8010721b <vector243>:
8010721b:	6a 00                	push   $0x0
8010721d:	68 f3 00 00 00       	push   $0xf3
80107222:	e9 29 f1 ff ff       	jmp    80106350 <alltraps>

80107227 <vector244>:
80107227:	6a 00                	push   $0x0
80107229:	68 f4 00 00 00       	push   $0xf4
8010722e:	e9 1d f1 ff ff       	jmp    80106350 <alltraps>

80107233 <vector245>:
80107233:	6a 00                	push   $0x0
80107235:	68 f5 00 00 00       	push   $0xf5
8010723a:	e9 11 f1 ff ff       	jmp    80106350 <alltraps>

8010723f <vector246>:
8010723f:	6a 00                	push   $0x0
80107241:	68 f6 00 00 00       	push   $0xf6
80107246:	e9 05 f1 ff ff       	jmp    80106350 <alltraps>

8010724b <vector247>:
8010724b:	6a 00                	push   $0x0
8010724d:	68 f7 00 00 00       	push   $0xf7
80107252:	e9 f9 f0 ff ff       	jmp    80106350 <alltraps>

80107257 <vector248>:
80107257:	6a 00                	push   $0x0
80107259:	68 f8 00 00 00       	push   $0xf8
8010725e:	e9 ed f0 ff ff       	jmp    80106350 <alltraps>

80107263 <vector249>:
80107263:	6a 00                	push   $0x0
80107265:	68 f9 00 00 00       	push   $0xf9
8010726a:	e9 e1 f0 ff ff       	jmp    80106350 <alltraps>

8010726f <vector250>:
8010726f:	6a 00                	push   $0x0
80107271:	68 fa 00 00 00       	push   $0xfa
80107276:	e9 d5 f0 ff ff       	jmp    80106350 <alltraps>

8010727b <vector251>:
8010727b:	6a 00                	push   $0x0
8010727d:	68 fb 00 00 00       	push   $0xfb
80107282:	e9 c9 f0 ff ff       	jmp    80106350 <alltraps>

80107287 <vector252>:
80107287:	6a 00                	push   $0x0
80107289:	68 fc 00 00 00       	push   $0xfc
8010728e:	e9 bd f0 ff ff       	jmp    80106350 <alltraps>

80107293 <vector253>:
80107293:	6a 00                	push   $0x0
80107295:	68 fd 00 00 00       	push   $0xfd
8010729a:	e9 b1 f0 ff ff       	jmp    80106350 <alltraps>

8010729f <vector254>:
8010729f:	6a 00                	push   $0x0
801072a1:	68 fe 00 00 00       	push   $0xfe
801072a6:	e9 a5 f0 ff ff       	jmp    80106350 <alltraps>

801072ab <vector255>:
801072ab:	6a 00                	push   $0x0
801072ad:	68 ff 00 00 00       	push   $0xff
801072b2:	e9 99 f0 ff ff       	jmp    80106350 <alltraps>
801072b7:	66 90                	xchg   %ax,%ax
801072b9:	66 90                	xchg   %ax,%ax
801072bb:	66 90                	xchg   %ax,%ax
801072bd:	66 90                	xchg   %ax,%ax
801072bf:	90                   	nop

801072c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801072c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801072cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801072d2:	83 ec 1c             	sub    $0x1c,%esp
801072d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801072d8:	39 d3                	cmp    %edx,%ebx
801072da:	73 49                	jae    80107325 <deallocuvm.part.0+0x65>
801072dc:	89 c7                	mov    %eax,%edi
801072de:	eb 0c                	jmp    801072ec <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801072e0:	83 c0 01             	add    $0x1,%eax
801072e3:	c1 e0 16             	shl    $0x16,%eax
801072e6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801072e8:	39 da                	cmp    %ebx,%edx
801072ea:	76 39                	jbe    80107325 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801072ec:	89 d8                	mov    %ebx,%eax
801072ee:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072f1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801072f4:	f6 c1 01             	test   $0x1,%cl
801072f7:	74 e7                	je     801072e0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801072f9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072fb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107301:	c1 ee 0a             	shr    $0xa,%esi
80107304:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010730a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107311:	85 f6                	test   %esi,%esi
80107313:	74 cb                	je     801072e0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107315:	8b 06                	mov    (%esi),%eax
80107317:	a8 01                	test   $0x1,%al
80107319:	75 15                	jne    80107330 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010731b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107321:	39 da                	cmp    %ebx,%edx
80107323:	77 c7                	ja     801072ec <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107325:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107328:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010732b:	5b                   	pop    %ebx
8010732c:	5e                   	pop    %esi
8010732d:	5f                   	pop    %edi
8010732e:	5d                   	pop    %ebp
8010732f:	c3                   	ret    
      if(pa == 0)
80107330:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107335:	74 25                	je     8010735c <deallocuvm.part.0+0x9c>
      kfree(v);
80107337:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010733a:	05 00 00 00 80       	add    $0x80000000,%eax
8010733f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107342:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107348:	50                   	push   %eax
80107349:	e8 32 b6 ff ff       	call   80102980 <kfree>
      *pte = 0;
8010734e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107354:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107357:	83 c4 10             	add    $0x10,%esp
8010735a:	eb 8c                	jmp    801072e8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010735c:	83 ec 0c             	sub    $0xc,%esp
8010735f:	68 5e 7f 10 80       	push   $0x80107f5e
80107364:	e8 17 90 ff ff       	call   80100380 <panic>
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107370 <mappages>:
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107376:	89 d3                	mov    %edx,%ebx
80107378:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010737e:	83 ec 1c             	sub    $0x1c,%esp
80107381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107384:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107388:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010738d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107390:	8b 45 08             	mov    0x8(%ebp),%eax
80107393:	29 d8                	sub    %ebx,%eax
80107395:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107398:	eb 3d                	jmp    801073d7 <mappages+0x67>
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801073a0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801073a7:	c1 ea 0a             	shr    $0xa,%edx
801073aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801073b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801073b7:	85 c0                	test   %eax,%eax
801073b9:	74 75                	je     80107430 <mappages+0xc0>
    if(*pte & PTE_P)
801073bb:	f6 00 01             	testb  $0x1,(%eax)
801073be:	0f 85 86 00 00 00    	jne    8010744a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801073c4:	0b 75 0c             	or     0xc(%ebp),%esi
801073c7:	83 ce 01             	or     $0x1,%esi
801073ca:	89 30                	mov    %esi,(%eax)
    if(a == last)
801073cc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801073cf:	74 6f                	je     80107440 <mappages+0xd0>
    a += PGSIZE;
801073d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801073d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801073da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073dd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801073e0:	89 d8                	mov    %ebx,%eax
801073e2:	c1 e8 16             	shr    $0x16,%eax
801073e5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801073e8:	8b 07                	mov    (%edi),%eax
801073ea:	a8 01                	test   $0x1,%al
801073ec:	75 b2                	jne    801073a0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801073ee:	e8 4d b7 ff ff       	call   80102b40 <kalloc>
801073f3:	85 c0                	test   %eax,%eax
801073f5:	74 39                	je     80107430 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801073f7:	83 ec 04             	sub    $0x4,%esp
801073fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801073fd:	68 00 10 00 00       	push   $0x1000
80107402:	6a 00                	push   $0x0
80107404:	50                   	push   %eax
80107405:	e8 c6 db ff ff       	call   80104fd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010740a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010740d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107410:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107416:	83 c8 07             	or     $0x7,%eax
80107419:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010741b:	89 d8                	mov    %ebx,%eax
8010741d:	c1 e8 0a             	shr    $0xa,%eax
80107420:	25 fc 0f 00 00       	and    $0xffc,%eax
80107425:	01 d0                	add    %edx,%eax
80107427:	eb 92                	jmp    801073bb <mappages+0x4b>
80107429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107430:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107438:	5b                   	pop    %ebx
80107439:	5e                   	pop    %esi
8010743a:	5f                   	pop    %edi
8010743b:	5d                   	pop    %ebp
8010743c:	c3                   	ret    
8010743d:	8d 76 00             	lea    0x0(%esi),%esi
80107440:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107443:	31 c0                	xor    %eax,%eax
}
80107445:	5b                   	pop    %ebx
80107446:	5e                   	pop    %esi
80107447:	5f                   	pop    %edi
80107448:	5d                   	pop    %ebp
80107449:	c3                   	ret    
      panic("remap");
8010744a:	83 ec 0c             	sub    $0xc,%esp
8010744d:	68 5c 86 10 80       	push   $0x8010865c
80107452:	e8 29 8f ff ff       	call   80100380 <panic>
80107457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745e:	66 90                	xchg   %ax,%ax

80107460 <seginit>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107466:	e8 a5 c9 ff ff       	call   80103e10 <cpuid>
  pd[0] = size-1;
8010746b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107470:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107476:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010747a:	c7 80 38 2a 11 80 ff 	movl   $0xffff,-0x7feed5c8(%eax)
80107481:	ff 00 00 
80107484:	c7 80 3c 2a 11 80 00 	movl   $0xcf9a00,-0x7feed5c4(%eax)
8010748b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010748e:	c7 80 40 2a 11 80 ff 	movl   $0xffff,-0x7feed5c0(%eax)
80107495:	ff 00 00 
80107498:	c7 80 44 2a 11 80 00 	movl   $0xcf9200,-0x7feed5bc(%eax)
8010749f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801074a2:	c7 80 48 2a 11 80 ff 	movl   $0xffff,-0x7feed5b8(%eax)
801074a9:	ff 00 00 
801074ac:	c7 80 4c 2a 11 80 00 	movl   $0xcffa00,-0x7feed5b4(%eax)
801074b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074b6:	c7 80 50 2a 11 80 ff 	movl   $0xffff,-0x7feed5b0(%eax)
801074bd:	ff 00 00 
801074c0:	c7 80 54 2a 11 80 00 	movl   $0xcff200,-0x7feed5ac(%eax)
801074c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801074ca:	05 30 2a 11 80       	add    $0x80112a30,%eax
  pd[1] = (uint)p;
801074cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801074d3:	c1 e8 10             	shr    $0x10,%eax
801074d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801074da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801074dd:	0f 01 10             	lgdtl  (%eax)
}
801074e0:	c9                   	leave  
801074e1:	c3                   	ret    
801074e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074f0:	a1 a4 ee 12 80       	mov    0x8012eea4,%eax
801074f5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074fa:	0f 22 d8             	mov    %eax,%cr3
}
801074fd:	c3                   	ret    
801074fe:	66 90                	xchg   %ax,%ax

80107500 <switchuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
80107509:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010750c:	85 f6                	test   %esi,%esi
8010750e:	0f 84 cb 00 00 00    	je     801075df <switchuvm+0xdf>
  if(p->kstack == 0)
80107514:	8b 46 08             	mov    0x8(%esi),%eax
80107517:	85 c0                	test   %eax,%eax
80107519:	0f 84 da 00 00 00    	je     801075f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010751f:	8b 46 04             	mov    0x4(%esi),%eax
80107522:	85 c0                	test   %eax,%eax
80107524:	0f 84 c2 00 00 00    	je     801075ec <switchuvm+0xec>
  pushcli();
8010752a:	e8 91 d8 ff ff       	call   80104dc0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010752f:	e8 7c c8 ff ff       	call   80103db0 <mycpu>
80107534:	89 c3                	mov    %eax,%ebx
80107536:	e8 75 c8 ff ff       	call   80103db0 <mycpu>
8010753b:	89 c7                	mov    %eax,%edi
8010753d:	e8 6e c8 ff ff       	call   80103db0 <mycpu>
80107542:	83 c7 08             	add    $0x8,%edi
80107545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107548:	e8 63 c8 ff ff       	call   80103db0 <mycpu>
8010754d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107550:	ba 67 00 00 00       	mov    $0x67,%edx
80107555:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010755c:	83 c0 08             	add    $0x8,%eax
8010755f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107566:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010756b:	83 c1 08             	add    $0x8,%ecx
8010756e:	c1 e8 18             	shr    $0x18,%eax
80107571:	c1 e9 10             	shr    $0x10,%ecx
80107574:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010757a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107580:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107585:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010758c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107591:	e8 1a c8 ff ff       	call   80103db0 <mycpu>
80107596:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010759d:	e8 0e c8 ff ff       	call   80103db0 <mycpu>
801075a2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801075a6:	8b 5e 08             	mov    0x8(%esi),%ebx
801075a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075af:	e8 fc c7 ff ff       	call   80103db0 <mycpu>
801075b4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801075b7:	e8 f4 c7 ff ff       	call   80103db0 <mycpu>
801075bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801075c0:	b8 28 00 00 00       	mov    $0x28,%eax
801075c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801075c8:	8b 46 04             	mov    0x4(%esi),%eax
801075cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075d0:	0f 22 d8             	mov    %eax,%cr3
}
801075d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075d6:	5b                   	pop    %ebx
801075d7:	5e                   	pop    %esi
801075d8:	5f                   	pop    %edi
801075d9:	5d                   	pop    %ebp
  popcli();
801075da:	e9 31 d8 ff ff       	jmp    80104e10 <popcli>
    panic("switchuvm: no process");
801075df:	83 ec 0c             	sub    $0xc,%esp
801075e2:	68 62 86 10 80       	push   $0x80108662
801075e7:	e8 94 8d ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801075ec:	83 ec 0c             	sub    $0xc,%esp
801075ef:	68 8d 86 10 80       	push   $0x8010868d
801075f4:	e8 87 8d ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801075f9:	83 ec 0c             	sub    $0xc,%esp
801075fc:	68 78 86 10 80       	push   $0x80108678
80107601:	e8 7a 8d ff ff       	call   80100380 <panic>
80107606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760d:	8d 76 00             	lea    0x0(%esi),%esi

80107610 <inituvm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 1c             	sub    $0x1c,%esp
80107619:	8b 45 0c             	mov    0xc(%ebp),%eax
8010761c:	8b 75 10             	mov    0x10(%ebp),%esi
8010761f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107625:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010762b:	77 4b                	ja     80107678 <inituvm+0x68>
  mem = kalloc();
8010762d:	e8 0e b5 ff ff       	call   80102b40 <kalloc>
  memset(mem, 0, PGSIZE);
80107632:	83 ec 04             	sub    $0x4,%esp
80107635:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010763a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010763c:	6a 00                	push   $0x0
8010763e:	50                   	push   %eax
8010763f:	e8 8c d9 ff ff       	call   80104fd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107644:	58                   	pop    %eax
80107645:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010764b:	5a                   	pop    %edx
8010764c:	6a 06                	push   $0x6
8010764e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107653:	31 d2                	xor    %edx,%edx
80107655:	50                   	push   %eax
80107656:	89 f8                	mov    %edi,%eax
80107658:	e8 13 fd ff ff       	call   80107370 <mappages>
  memmove(mem, init, sz);
8010765d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107660:	89 75 10             	mov    %esi,0x10(%ebp)
80107663:	83 c4 10             	add    $0x10,%esp
80107666:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107669:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010766c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010766f:	5b                   	pop    %ebx
80107670:	5e                   	pop    %esi
80107671:	5f                   	pop    %edi
80107672:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107673:	e9 f8 d9 ff ff       	jmp    80105070 <memmove>
    panic("inituvm: more than a page");
80107678:	83 ec 0c             	sub    $0xc,%esp
8010767b:	68 a1 86 10 80       	push   $0x801086a1
80107680:	e8 fb 8c ff ff       	call   80100380 <panic>
80107685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107690 <loaduvm>:
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	57                   	push   %edi
80107694:	56                   	push   %esi
80107695:	53                   	push   %ebx
80107696:	83 ec 1c             	sub    $0x1c,%esp
80107699:	8b 45 0c             	mov    0xc(%ebp),%eax
8010769c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010769f:	a9 ff 0f 00 00       	test   $0xfff,%eax
801076a4:	0f 85 bb 00 00 00    	jne    80107765 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801076aa:	01 f0                	add    %esi,%eax
801076ac:	89 f3                	mov    %esi,%ebx
801076ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076b1:	8b 45 14             	mov    0x14(%ebp),%eax
801076b4:	01 f0                	add    %esi,%eax
801076b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801076b9:	85 f6                	test   %esi,%esi
801076bb:	0f 84 87 00 00 00    	je     80107748 <loaduvm+0xb8>
801076c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801076c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801076cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801076ce:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801076d0:	89 c2                	mov    %eax,%edx
801076d2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801076d5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801076d8:	f6 c2 01             	test   $0x1,%dl
801076db:	75 13                	jne    801076f0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801076dd:	83 ec 0c             	sub    $0xc,%esp
801076e0:	68 bb 86 10 80       	push   $0x801086bb
801076e5:	e8 96 8c ff ff       	call   80100380 <panic>
801076ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801076f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801076f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801076fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107705:	85 c0                	test   %eax,%eax
80107707:	74 d4                	je     801076dd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107709:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010770b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010770e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107713:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107718:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010771e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107721:	29 d9                	sub    %ebx,%ecx
80107723:	05 00 00 00 80       	add    $0x80000000,%eax
80107728:	57                   	push   %edi
80107729:	51                   	push   %ecx
8010772a:	50                   	push   %eax
8010772b:	ff 75 10             	push   0x10(%ebp)
8010772e:	e8 1d a8 ff ff       	call   80101f50 <readi>
80107733:	83 c4 10             	add    $0x10,%esp
80107736:	39 f8                	cmp    %edi,%eax
80107738:	75 1e                	jne    80107758 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010773a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107740:	89 f0                	mov    %esi,%eax
80107742:	29 d8                	sub    %ebx,%eax
80107744:	39 c6                	cmp    %eax,%esi
80107746:	77 80                	ja     801076c8 <loaduvm+0x38>
}
80107748:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010774b:	31 c0                	xor    %eax,%eax
}
8010774d:	5b                   	pop    %ebx
8010774e:	5e                   	pop    %esi
8010774f:	5f                   	pop    %edi
80107750:	5d                   	pop    %ebp
80107751:	c3                   	ret    
80107752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107758:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010775b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107760:	5b                   	pop    %ebx
80107761:	5e                   	pop    %esi
80107762:	5f                   	pop    %edi
80107763:	5d                   	pop    %ebp
80107764:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107765:	83 ec 0c             	sub    $0xc,%esp
80107768:	68 5c 87 10 80       	push   $0x8010875c
8010776d:	e8 0e 8c ff ff       	call   80100380 <panic>
80107772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107780 <allocuvm>:
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	53                   	push   %ebx
80107786:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107789:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010778c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010778f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107792:	85 c0                	test   %eax,%eax
80107794:	0f 88 b6 00 00 00    	js     80107850 <allocuvm+0xd0>
  if(newsz < oldsz)
8010779a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010779d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801077a0:	0f 82 9a 00 00 00    	jb     80107840 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801077a6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801077ac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801077b2:	39 75 10             	cmp    %esi,0x10(%ebp)
801077b5:	77 44                	ja     801077fb <allocuvm+0x7b>
801077b7:	e9 87 00 00 00       	jmp    80107843 <allocuvm+0xc3>
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801077c0:	83 ec 04             	sub    $0x4,%esp
801077c3:	68 00 10 00 00       	push   $0x1000
801077c8:	6a 00                	push   $0x0
801077ca:	50                   	push   %eax
801077cb:	e8 00 d8 ff ff       	call   80104fd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801077d0:	58                   	pop    %eax
801077d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077d7:	5a                   	pop    %edx
801077d8:	6a 06                	push   $0x6
801077da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077df:	89 f2                	mov    %esi,%edx
801077e1:	50                   	push   %eax
801077e2:	89 f8                	mov    %edi,%eax
801077e4:	e8 87 fb ff ff       	call   80107370 <mappages>
801077e9:	83 c4 10             	add    $0x10,%esp
801077ec:	85 c0                	test   %eax,%eax
801077ee:	78 78                	js     80107868 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801077f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801077f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801077f9:	76 48                	jbe    80107843 <allocuvm+0xc3>
    mem = kalloc();
801077fb:	e8 40 b3 ff ff       	call   80102b40 <kalloc>
80107800:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107802:	85 c0                	test   %eax,%eax
80107804:	75 ba                	jne    801077c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107806:	83 ec 0c             	sub    $0xc,%esp
80107809:	68 d9 86 10 80       	push   $0x801086d9
8010780e:	e8 8d 8e ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107813:	8b 45 0c             	mov    0xc(%ebp),%eax
80107816:	83 c4 10             	add    $0x10,%esp
80107819:	39 45 10             	cmp    %eax,0x10(%ebp)
8010781c:	74 32                	je     80107850 <allocuvm+0xd0>
8010781e:	8b 55 10             	mov    0x10(%ebp),%edx
80107821:	89 c1                	mov    %eax,%ecx
80107823:	89 f8                	mov    %edi,%eax
80107825:	e8 96 fa ff ff       	call   801072c0 <deallocuvm.part.0>
      return 0;
8010782a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107834:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107837:	5b                   	pop    %ebx
80107838:	5e                   	pop    %esi
80107839:	5f                   	pop    %edi
8010783a:	5d                   	pop    %ebp
8010783b:	c3                   	ret    
8010783c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107846:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107849:	5b                   	pop    %ebx
8010784a:	5e                   	pop    %esi
8010784b:	5f                   	pop    %edi
8010784c:	5d                   	pop    %ebp
8010784d:	c3                   	ret    
8010784e:	66 90                	xchg   %ax,%ax
    return 0;
80107850:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010785a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010785d:	5b                   	pop    %ebx
8010785e:	5e                   	pop    %esi
8010785f:	5f                   	pop    %edi
80107860:	5d                   	pop    %ebp
80107861:	c3                   	ret    
80107862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107868:	83 ec 0c             	sub    $0xc,%esp
8010786b:	68 f1 86 10 80       	push   $0x801086f1
80107870:	e8 2b 8e ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107875:	8b 45 0c             	mov    0xc(%ebp),%eax
80107878:	83 c4 10             	add    $0x10,%esp
8010787b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010787e:	74 0c                	je     8010788c <allocuvm+0x10c>
80107880:	8b 55 10             	mov    0x10(%ebp),%edx
80107883:	89 c1                	mov    %eax,%ecx
80107885:	89 f8                	mov    %edi,%eax
80107887:	e8 34 fa ff ff       	call   801072c0 <deallocuvm.part.0>
      kfree(mem);
8010788c:	83 ec 0c             	sub    $0xc,%esp
8010788f:	53                   	push   %ebx
80107890:	e8 eb b0 ff ff       	call   80102980 <kfree>
      return 0;
80107895:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010789c:	83 c4 10             	add    $0x10,%esp
}
8010789f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a5:	5b                   	pop    %ebx
801078a6:	5e                   	pop    %esi
801078a7:	5f                   	pop    %edi
801078a8:	5d                   	pop    %ebp
801078a9:	c3                   	ret    
801078aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078b0 <deallocuvm>:
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801078b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801078b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801078bc:	39 d1                	cmp    %edx,%ecx
801078be:	73 10                	jae    801078d0 <deallocuvm+0x20>
}
801078c0:	5d                   	pop    %ebp
801078c1:	e9 fa f9 ff ff       	jmp    801072c0 <deallocuvm.part.0>
801078c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078cd:	8d 76 00             	lea    0x0(%esi),%esi
801078d0:	89 d0                	mov    %edx,%eax
801078d2:	5d                   	pop    %ebp
801078d3:	c3                   	ret    
801078d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078df:	90                   	nop

801078e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 0c             	sub    $0xc,%esp
801078e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801078ec:	85 f6                	test   %esi,%esi
801078ee:	74 59                	je     80107949 <freevm+0x69>
  if(newsz >= oldsz)
801078f0:	31 c9                	xor    %ecx,%ecx
801078f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801078f7:	89 f0                	mov    %esi,%eax
801078f9:	89 f3                	mov    %esi,%ebx
801078fb:	e8 c0 f9 ff ff       	call   801072c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107900:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107906:	eb 0f                	jmp    80107917 <freevm+0x37>
80107908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790f:	90                   	nop
80107910:	83 c3 04             	add    $0x4,%ebx
80107913:	39 df                	cmp    %ebx,%edi
80107915:	74 23                	je     8010793a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107917:	8b 03                	mov    (%ebx),%eax
80107919:	a8 01                	test   $0x1,%al
8010791b:	74 f3                	je     80107910 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010791d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107922:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107925:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107928:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010792d:	50                   	push   %eax
8010792e:	e8 4d b0 ff ff       	call   80102980 <kfree>
80107933:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107936:	39 df                	cmp    %ebx,%edi
80107938:	75 dd                	jne    80107917 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010793a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010793d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107940:	5b                   	pop    %ebx
80107941:	5e                   	pop    %esi
80107942:	5f                   	pop    %edi
80107943:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107944:	e9 37 b0 ff ff       	jmp    80102980 <kfree>
    panic("freevm: no pgdir");
80107949:	83 ec 0c             	sub    $0xc,%esp
8010794c:	68 0d 87 10 80       	push   $0x8010870d
80107951:	e8 2a 8a ff ff       	call   80100380 <panic>
80107956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010795d:	8d 76 00             	lea    0x0(%esi),%esi

80107960 <setupkvm>:
{
80107960:	55                   	push   %ebp
80107961:	89 e5                	mov    %esp,%ebp
80107963:	56                   	push   %esi
80107964:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107965:	e8 d6 b1 ff ff       	call   80102b40 <kalloc>
8010796a:	89 c6                	mov    %eax,%esi
8010796c:	85 c0                	test   %eax,%eax
8010796e:	74 42                	je     801079b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107970:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107973:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107978:	68 00 10 00 00       	push   $0x1000
8010797d:	6a 00                	push   $0x0
8010797f:	50                   	push   %eax
80107980:	e8 4b d6 ff ff       	call   80104fd0 <memset>
80107985:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107988:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010798b:	83 ec 08             	sub    $0x8,%esp
8010798e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107991:	ff 73 0c             	push   0xc(%ebx)
80107994:	8b 13                	mov    (%ebx),%edx
80107996:	50                   	push   %eax
80107997:	29 c1                	sub    %eax,%ecx
80107999:	89 f0                	mov    %esi,%eax
8010799b:	e8 d0 f9 ff ff       	call   80107370 <mappages>
801079a0:	83 c4 10             	add    $0x10,%esp
801079a3:	85 c0                	test   %eax,%eax
801079a5:	78 19                	js     801079c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079a7:	83 c3 10             	add    $0x10,%ebx
801079aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801079b0:	75 d6                	jne    80107988 <setupkvm+0x28>
}
801079b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079b5:	89 f0                	mov    %esi,%eax
801079b7:	5b                   	pop    %ebx
801079b8:	5e                   	pop    %esi
801079b9:	5d                   	pop    %ebp
801079ba:	c3                   	ret    
801079bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079bf:	90                   	nop
      freevm(pgdir);
801079c0:	83 ec 0c             	sub    $0xc,%esp
801079c3:	56                   	push   %esi
      return 0;
801079c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801079c6:	e8 15 ff ff ff       	call   801078e0 <freevm>
      return 0;
801079cb:	83 c4 10             	add    $0x10,%esp
}
801079ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079d1:	89 f0                	mov    %esi,%eax
801079d3:	5b                   	pop    %ebx
801079d4:	5e                   	pop    %esi
801079d5:	5d                   	pop    %ebp
801079d6:	c3                   	ret    
801079d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079de:	66 90                	xchg   %ax,%ax

801079e0 <kvmalloc>:
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801079e6:	e8 75 ff ff ff       	call   80107960 <setupkvm>
801079eb:	a3 a4 ee 12 80       	mov    %eax,0x8012eea4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079f0:	05 00 00 00 80       	add    $0x80000000,%eax
801079f5:	0f 22 d8             	mov    %eax,%cr3
}
801079f8:	c9                   	leave  
801079f9:	c3                   	ret    
801079fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	83 ec 08             	sub    $0x8,%esp
80107a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107a09:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107a0c:	89 c1                	mov    %eax,%ecx
80107a0e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107a11:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107a14:	f6 c2 01             	test   $0x1,%dl
80107a17:	75 17                	jne    80107a30 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107a19:	83 ec 0c             	sub    $0xc,%esp
80107a1c:	68 1e 87 10 80       	push   $0x8010871e
80107a21:	e8 5a 89 ff ff       	call   80100380 <panic>
80107a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a2d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107a30:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a33:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107a39:	25 fc 0f 00 00       	and    $0xffc,%eax
80107a3e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107a45:	85 c0                	test   %eax,%eax
80107a47:	74 d0                	je     80107a19 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107a49:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107a4c:	c9                   	leave  
80107a4d:	c3                   	ret    
80107a4e:	66 90                	xchg   %ax,%ax

80107a50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	53                   	push   %ebx
80107a56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a59:	e8 02 ff ff ff       	call   80107960 <setupkvm>
80107a5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a61:	85 c0                	test   %eax,%eax
80107a63:	0f 84 bd 00 00 00    	je     80107b26 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a6c:	85 c9                	test   %ecx,%ecx
80107a6e:	0f 84 b2 00 00 00    	je     80107b26 <copyuvm+0xd6>
80107a74:	31 f6                	xor    %esi,%esi
80107a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a7d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107a83:	89 f0                	mov    %esi,%eax
80107a85:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107a88:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107a8b:	a8 01                	test   $0x1,%al
80107a8d:	75 11                	jne    80107aa0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107a8f:	83 ec 0c             	sub    $0xc,%esp
80107a92:	68 28 87 10 80       	push   $0x80108728
80107a97:	e8 e4 88 ff ff       	call   80100380 <panic>
80107a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107aa0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107aa7:	c1 ea 0a             	shr    $0xa,%edx
80107aaa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107ab0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ab7:	85 c0                	test   %eax,%eax
80107ab9:	74 d4                	je     80107a8f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107abb:	8b 00                	mov    (%eax),%eax
80107abd:	a8 01                	test   $0x1,%al
80107abf:	0f 84 9f 00 00 00    	je     80107b64 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107ac5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107ac7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107acc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107acf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107ad5:	e8 66 b0 ff ff       	call   80102b40 <kalloc>
80107ada:	89 c3                	mov    %eax,%ebx
80107adc:	85 c0                	test   %eax,%eax
80107ade:	74 64                	je     80107b44 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107ae0:	83 ec 04             	sub    $0x4,%esp
80107ae3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107ae9:	68 00 10 00 00       	push   $0x1000
80107aee:	57                   	push   %edi
80107aef:	50                   	push   %eax
80107af0:	e8 7b d5 ff ff       	call   80105070 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107af5:	58                   	pop    %eax
80107af6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107afc:	5a                   	pop    %edx
80107afd:	ff 75 e4             	push   -0x1c(%ebp)
80107b00:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b05:	89 f2                	mov    %esi,%edx
80107b07:	50                   	push   %eax
80107b08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b0b:	e8 60 f8 ff ff       	call   80107370 <mappages>
80107b10:	83 c4 10             	add    $0x10,%esp
80107b13:	85 c0                	test   %eax,%eax
80107b15:	78 21                	js     80107b38 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107b17:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b1d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b20:	0f 87 5a ff ff ff    	ja     80107a80 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b2c:	5b                   	pop    %ebx
80107b2d:	5e                   	pop    %esi
80107b2e:	5f                   	pop    %edi
80107b2f:	5d                   	pop    %ebp
80107b30:	c3                   	ret    
80107b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107b38:	83 ec 0c             	sub    $0xc,%esp
80107b3b:	53                   	push   %ebx
80107b3c:	e8 3f ae ff ff       	call   80102980 <kfree>
      goto bad;
80107b41:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107b44:	83 ec 0c             	sub    $0xc,%esp
80107b47:	ff 75 e0             	push   -0x20(%ebp)
80107b4a:	e8 91 fd ff ff       	call   801078e0 <freevm>
  return 0;
80107b4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107b56:	83 c4 10             	add    $0x10,%esp
}
80107b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b5f:	5b                   	pop    %ebx
80107b60:	5e                   	pop    %esi
80107b61:	5f                   	pop    %edi
80107b62:	5d                   	pop    %ebp
80107b63:	c3                   	ret    
      panic("copyuvm: page not present");
80107b64:	83 ec 0c             	sub    $0xc,%esp
80107b67:	68 42 87 10 80       	push   $0x80108742
80107b6c:	e8 0f 88 ff ff       	call   80100380 <panic>
80107b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b7f:	90                   	nop

80107b80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b80:	55                   	push   %ebp
80107b81:	89 e5                	mov    %esp,%ebp
80107b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107b86:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107b89:	89 c1                	mov    %eax,%ecx
80107b8b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107b8e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107b91:	f6 c2 01             	test   $0x1,%dl
80107b94:	0f 84 00 01 00 00    	je     80107c9a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107b9a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b9d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ba3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107ba4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107ba9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107bb0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107bb7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107bba:	05 00 00 00 80       	add    $0x80000000,%eax
80107bbf:	83 fa 05             	cmp    $0x5,%edx
80107bc2:	ba 00 00 00 00       	mov    $0x0,%edx
80107bc7:	0f 45 c2             	cmovne %edx,%eax
}
80107bca:	c3                   	ret    
80107bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bcf:	90                   	nop

80107bd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	57                   	push   %edi
80107bd4:	56                   	push   %esi
80107bd5:	53                   	push   %ebx
80107bd6:	83 ec 0c             	sub    $0xc,%esp
80107bd9:	8b 75 14             	mov    0x14(%ebp),%esi
80107bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bdf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107be2:	85 f6                	test   %esi,%esi
80107be4:	75 51                	jne    80107c37 <copyout+0x67>
80107be6:	e9 a5 00 00 00       	jmp    80107c90 <copyout+0xc0>
80107beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bef:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107bf0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107bf6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107bfc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107c02:	74 75                	je     80107c79 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107c04:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107c06:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107c09:	29 c3                	sub    %eax,%ebx
80107c0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c11:	39 f3                	cmp    %esi,%ebx
80107c13:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107c16:	29 f8                	sub    %edi,%eax
80107c18:	83 ec 04             	sub    $0x4,%esp
80107c1b:	01 c1                	add    %eax,%ecx
80107c1d:	53                   	push   %ebx
80107c1e:	52                   	push   %edx
80107c1f:	51                   	push   %ecx
80107c20:	e8 4b d4 ff ff       	call   80105070 <memmove>
    len -= n;
    buf += n;
80107c25:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107c28:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107c2e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107c31:	01 da                	add    %ebx,%edx
  while(len > 0){
80107c33:	29 de                	sub    %ebx,%esi
80107c35:	74 59                	je     80107c90 <copyout+0xc0>
  if(*pde & PTE_P){
80107c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107c3a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107c3c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107c3e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107c41:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107c47:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107c4a:	f6 c1 01             	test   $0x1,%cl
80107c4d:	0f 84 4e 00 00 00    	je     80107ca1 <copyout.cold>
  return &pgtab[PTX(va)];
80107c53:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c55:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107c5b:	c1 eb 0c             	shr    $0xc,%ebx
80107c5e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107c64:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107c6b:	89 d9                	mov    %ebx,%ecx
80107c6d:	83 e1 05             	and    $0x5,%ecx
80107c70:	83 f9 05             	cmp    $0x5,%ecx
80107c73:	0f 84 77 ff ff ff    	je     80107bf0 <copyout+0x20>
  }
  return 0;
}
80107c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c81:	5b                   	pop    %ebx
80107c82:	5e                   	pop    %esi
80107c83:	5f                   	pop    %edi
80107c84:	5d                   	pop    %ebp
80107c85:	c3                   	ret    
80107c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c8d:	8d 76 00             	lea    0x0(%esi),%esi
80107c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c93:	31 c0                	xor    %eax,%eax
}
80107c95:	5b                   	pop    %ebx
80107c96:	5e                   	pop    %esi
80107c97:	5f                   	pop    %edi
80107c98:	5d                   	pop    %ebp
80107c99:	c3                   	ret    

80107c9a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107c9a:	a1 00 00 00 00       	mov    0x0,%eax
80107c9f:	0f 0b                	ud2    

80107ca1 <copyout.cold>:
80107ca1:	a1 00 00 00 00       	mov    0x0,%eax
80107ca6:	0f 0b                	ud2    
