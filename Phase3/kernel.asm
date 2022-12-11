
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
8010004c:	68 40 7b 10 80       	push   $0x80107b40
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 4b 00 00       	call   80104c10 <initlock>
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
80100092:	68 47 7b 10 80       	push   $0x80107b47
80100097:	50                   	push   %eax
80100098:	e8 43 4a 00 00       	call   80104ae0 <initsleeplock>
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
801000e4:	e8 f7 4c 00 00       	call   80104de0 <acquire>
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
80100162:	e8 19 4c 00 00       	call   80104d80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 49 00 00       	call   80104b20 <acquiresleep>
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
801001a1:	68 4e 7b 10 80       	push   $0x80107b4e
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
801001be:	e8 fd 49 00 00       	call   80104bc0 <holdingsleep>
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
801001dc:	68 5f 7b 10 80       	push   $0x80107b5f
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
801001ff:	e8 bc 49 00 00       	call   80104bc0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 49 00 00       	call   80104b80 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 4b 00 00       	call   80104de0 <acquire>
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
8010026c:	e9 0f 4b 00 00       	jmp    80104d80 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 7b 10 80       	push   $0x80107b66
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
801002a0:	e8 3b 4b 00 00       	call   80104de0 <acquire>
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
801002f6:	e8 85 4a 00 00       	call   80104d80 <release>
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
8010034c:	e8 2f 4a 00 00       	call   80104d80 <release>
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
801003a2:	68 6d 7b 10 80       	push   $0x80107b6d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 47 85 10 80 	movl   $0x80108547,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 48 00 00       	call   80104c30 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 7b 10 80       	push   $0x80107b81
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
8010041a:	e8 41 62 00 00       	call   80106660 <uartputc>
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
80100505:	e8 56 61 00 00       	call   80106660 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 61 00 00       	call   80106660 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 61 00 00       	call   80106660 <uartputc>
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
80100551:	e8 ea 49 00 00       	call   80104f40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 49 00 00       	call   80104ea0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 7b 10 80       	push   $0x80107b85
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
801005ab:	e8 30 48 00 00       	call   80104de0 <acquire>
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
801005e4:	e8 97 47 00 00       	call   80104d80 <release>
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
80100636:	0f b6 92 e8 7b 10 80 	movzbl -0x7fef8418(%edx),%edx
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
801007e8:	e8 f3 45 00 00       	call   80104de0 <acquire>
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
80100838:	bf 98 7b 10 80       	mov    $0x80107b98,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 01 11 80       	push   $0x80110140
8010085b:	e8 20 45 00 00       	call   80104d80 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 7b 10 80       	push   $0x80107b9f
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
80100d03:	e8 d8 40 00 00       	call   80104de0 <acquire>
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
80100d31:	ff 24 85 b0 7b 10 80 	jmp    *-0x7fef8450(,%eax,4)
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
80100e08:	e8 73 3f 00 00       	call   80104d80 <release>
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
80100f26:	68 a8 7b 10 80       	push   $0x80107ba8
80100f2b:	68 40 01 11 80       	push   $0x80110140
80100f30:	e8 db 3c 00 00       	call   80104c10 <initlock>

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
80100ff4:	e8 f7 67 00 00       	call   801077f0 <setupkvm>
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
80101063:	e8 a8 65 00 00       	call   80107610 <allocuvm>
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
80101099:	e8 82 64 00 00       	call   80107520 <loaduvm>
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
801010db:	e8 90 66 00 00       	call   80107770 <freevm>
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
80101122:	e8 e9 64 00 00       	call   80107610 <allocuvm>
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
80101143:	e8 48 67 00 00       	call   80107890 <clearpteu>
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
80101193:	e8 08 3f 00 00       	call   801050a0 <strlen>
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
801011a7:	e8 f4 3e 00 00       	call   801050a0 <strlen>
801011ac:	83 c0 01             	add    $0x1,%eax
801011af:	50                   	push   %eax
801011b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801011b3:	ff 34 b8             	push   (%eax,%edi,4)
801011b6:	53                   	push   %ebx
801011b7:	56                   	push   %esi
801011b8:	e8 a3 68 00 00       	call   80107a60 <copyout>
801011bd:	83 c4 20             	add    $0x20,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	79 ac                	jns    80101170 <exec+0x200>
801011c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011d1:	e8 9a 65 00 00       	call   80107770 <freevm>
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
80101223:	e8 38 68 00 00       	call   80107a60 <copyout>
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
80101261:	e8 fa 3d 00 00       	call   80105060 <safestrcpy>
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
8010128d:	e8 fe 60 00 00       	call   80107390 <switchuvm>
  freevm(oldpgdir);
80101292:	89 3c 24             	mov    %edi,(%esp)
80101295:	e8 d6 64 00 00       	call   80107770 <freevm>
  return 0;
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	31 c0                	xor    %eax,%eax
8010129f:	e9 38 fd ff ff       	jmp    80100fdc <exec+0x6c>
    end_op();
801012a4:	e8 e7 1f 00 00       	call   80103290 <end_op>
    cprintf("exec: fail\n");
801012a9:	83 ec 0c             	sub    $0xc,%esp
801012ac:	68 f9 7b 10 80       	push   $0x80107bf9
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
801012d6:	68 05 7c 10 80       	push   $0x80107c05
801012db:	68 80 01 11 80       	push   $0x80110180
801012e0:	e8 2b 39 00 00       	call   80104c10 <initlock>
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
80101301:	e8 da 3a 00 00       	call   80104de0 <acquire>
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
80101331:	e8 4a 3a 00 00       	call   80104d80 <release>
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
8010134a:	e8 31 3a 00 00       	call   80104d80 <release>
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
8010136f:	e8 6c 3a 00 00       	call   80104de0 <acquire>
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
8010138c:	e8 ef 39 00 00       	call   80104d80 <release>
  return f;
}
80101391:	89 d8                	mov    %ebx,%eax
80101393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101396:	c9                   	leave  
80101397:	c3                   	ret    
    panic("filedup");
80101398:	83 ec 0c             	sub    $0xc,%esp
8010139b:	68 0c 7c 10 80       	push   $0x80107c0c
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
801013c1:	e8 1a 3a 00 00       	call   80104de0 <acquire>
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
801013fc:	e8 7f 39 00 00       	call   80104d80 <release>

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
8010142e:	e9 4d 39 00 00       	jmp    80104d80 <release>
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
8010147c:	68 14 7c 10 80       	push   $0x80107c14
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
80101562:	68 1e 7c 10 80       	push   $0x80107c1e
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
80101637:	68 27 7c 10 80       	push   $0x80107c27
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
80101671:	68 2d 7c 10 80       	push   $0x80107c2d
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
801016e7:	68 37 7c 10 80       	push   $0x80107c37
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
801017a4:	68 4a 7c 10 80       	push   $0x80107c4a
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
801017e5:	e8 b6 36 00 00       	call   80104ea0 <memset>
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
8010182a:	e8 b1 35 00 00       	call   80104de0 <acquire>
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
80101897:	e8 e4 34 00 00       	call   80104d80 <release>

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
801018c5:	e8 b6 34 00 00       	call   80104d80 <release>
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
801018f8:	68 60 7c 10 80       	push   $0x80107c60
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
801019d5:	68 70 7c 10 80       	push   $0x80107c70
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
80101a01:	e8 3a 35 00 00       	call   80104f40 <memmove>
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
80101a2c:	68 83 7c 10 80       	push   $0x80107c83
80101a31:	68 80 0b 11 80       	push   $0x80110b80
80101a36:	e8 d5 31 00 00       	call   80104c10 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a40:	83 ec 08             	sub    $0x8,%esp
80101a43:	68 8a 7c 10 80       	push   $0x80107c8a
80101a48:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a49:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a4f:	e8 8c 30 00 00       	call   80104ae0 <initsleeplock>
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
80101a7c:	e8 bf 34 00 00       	call   80104f40 <memmove>
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
80101ab3:	68 f0 7c 10 80       	push   $0x80107cf0
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
80101b4e:	e8 4d 33 00 00       	call   80104ea0 <memset>
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
80101b83:	68 90 7c 10 80       	push   $0x80107c90
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
80101bf1:	e8 4a 33 00 00       	call   80104f40 <memmove>
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
80101c1f:	e8 bc 31 00 00       	call   80104de0 <acquire>
  ip->ref++;
80101c24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c28:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101c2f:	e8 4c 31 00 00       	call   80104d80 <release>
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
80101c62:	e8 b9 2e 00 00       	call   80104b20 <acquiresleep>
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
80101cd8:	e8 63 32 00 00       	call   80104f40 <memmove>
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
80101cfd:	68 a8 7c 10 80       	push   $0x80107ca8
80101d02:	e8 79 e6 ff ff       	call   80100380 <panic>
    panic("ilock");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 a2 7c 10 80       	push   $0x80107ca2
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
80101d33:	e8 88 2e 00 00       	call   80104bc0 <holdingsleep>
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
80101d4f:	e9 2c 2e 00 00       	jmp    80104b80 <releasesleep>
    panic("iunlock");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 b7 7c 10 80       	push   $0x80107cb7
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
80101d80:	e8 9b 2d 00 00       	call   80104b20 <acquiresleep>
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
80101d9a:	e8 e1 2d 00 00       	call   80104b80 <releasesleep>
  acquire(&icache.lock);
80101d9f:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101da6:	e8 35 30 00 00       	call   80104de0 <acquire>
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
80101dc0:	e9 bb 2f 00 00       	jmp    80104d80 <release>
80101dc5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	68 80 0b 11 80       	push   $0x80110b80
80101dd0:	e8 0b 30 00 00       	call   80104de0 <acquire>
    int r = ip->ref;
80101dd5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101dd8:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
80101ddf:	e8 9c 2f 00 00       	call   80104d80 <release>
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
80101ee3:	e8 d8 2c 00 00       	call   80104bc0 <holdingsleep>
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	74 21                	je     80101f10 <iunlockput+0x40>
80101eef:	8b 43 08             	mov    0x8(%ebx),%eax
80101ef2:	85 c0                	test   %eax,%eax
80101ef4:	7e 1a                	jle    80101f10 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ef6:	83 ec 0c             	sub    $0xc,%esp
80101ef9:	56                   	push   %esi
80101efa:	e8 81 2c 00 00       	call   80104b80 <releasesleep>
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
80101f13:	68 b7 7c 10 80       	push   $0x80107cb7
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
80101ff7:	e8 44 2f 00 00       	call   80104f40 <memmove>
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
801020f3:	e8 48 2e 00 00       	call   80104f40 <memmove>
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
8010218e:	e8 1d 2e 00 00       	call   80104fb0 <strncmp>
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
801021ed:	e8 be 2d 00 00       	call   80104fb0 <strncmp>
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
80102232:	68 d1 7c 10 80       	push   $0x80107cd1
80102237:	e8 44 e1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010223c:	83 ec 0c             	sub    $0xc,%esp
8010223f:	68 bf 7c 10 80       	push   $0x80107cbf
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
8010227a:	e8 61 2b 00 00       	call   80104de0 <acquire>
  ip->ref++;
8010227f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102283:	c7 04 24 80 0b 11 80 	movl   $0x80110b80,(%esp)
8010228a:	e8 f1 2a 00 00       	call   80104d80 <release>
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
801022e7:	e8 54 2c 00 00       	call   80104f40 <memmove>
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
8010234c:	e8 6f 28 00 00       	call   80104bc0 <holdingsleep>
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
8010236e:	e8 0d 28 00 00       	call   80104b80 <releasesleep>
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
8010239b:	e8 a0 2b 00 00       	call   80104f40 <memmove>
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
801023eb:	e8 d0 27 00 00       	call   80104bc0 <holdingsleep>
801023f0:	83 c4 10             	add    $0x10,%esp
801023f3:	85 c0                	test   %eax,%eax
801023f5:	0f 84 91 00 00 00    	je     8010248c <namex+0x23c>
801023fb:	8b 46 08             	mov    0x8(%esi),%eax
801023fe:	85 c0                	test   %eax,%eax
80102400:	0f 8e 86 00 00 00    	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102406:	83 ec 0c             	sub    $0xc,%esp
80102409:	53                   	push   %ebx
8010240a:	e8 71 27 00 00       	call   80104b80 <releasesleep>
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
8010242d:	e8 8e 27 00 00       	call   80104bc0 <holdingsleep>
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
80102450:	e8 6b 27 00 00       	call   80104bc0 <holdingsleep>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	85 c0                	test   %eax,%eax
8010245a:	74 30                	je     8010248c <namex+0x23c>
8010245c:	8b 7e 08             	mov    0x8(%esi),%edi
8010245f:	85 ff                	test   %edi,%edi
80102461:	7e 29                	jle    8010248c <namex+0x23c>
  releasesleep(&ip->lock);
80102463:	83 ec 0c             	sub    $0xc,%esp
80102466:	53                   	push   %ebx
80102467:	e8 14 27 00 00       	call   80104b80 <releasesleep>
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
8010248f:	68 b7 7c 10 80       	push   $0x80107cb7
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
801024fd:	e8 fe 2a 00 00       	call   80105000 <strncpy>
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
8010253b:	68 e0 7c 10 80       	push   $0x80107ce0
80102540:	e8 3b de ff ff       	call   80100380 <panic>
    panic("dirlink");
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	68 2e 83 10 80       	push   $0x8010832e
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
8010265b:	68 4c 7d 10 80       	push   $0x80107d4c
80102660:	e8 1b dd ff ff       	call   80100380 <panic>
    panic("idestart");
80102665:	83 ec 0c             	sub    $0xc,%esp
80102668:	68 43 7d 10 80       	push   $0x80107d43
8010266d:	e8 0e dd ff ff       	call   80100380 <panic>
80102672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102680 <ideinit>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102686:	68 5e 7d 10 80       	push   $0x80107d5e
8010268b:	68 20 28 11 80       	push   $0x80112820
80102690:	e8 7b 25 00 00       	call   80104c10 <initlock>
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
8010270e:	e8 cd 26 00 00       	call   80104de0 <acquire>

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
8010278b:	e8 f0 25 00 00       	call   80104d80 <release>

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
801027ae:	e8 0d 24 00 00       	call   80104bc0 <holdingsleep>
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
801027e8:	e8 f3 25 00 00       	call   80104de0 <acquire>

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
80102846:	e9 35 25 00 00       	jmp    80104d80 <release>
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
8010286a:	68 8d 7d 10 80       	push   $0x80107d8d
8010286f:	e8 0c db ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102874:	83 ec 0c             	sub    $0xc,%esp
80102877:	68 78 7d 10 80       	push   $0x80107d78
8010287c:	e8 ff da ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102881:	83 ec 0c             	sub    $0xc,%esp
80102884:	68 62 7d 10 80       	push   $0x80107d62
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
801028da:	68 ac 7d 10 80       	push   $0x80107dac
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
801029b2:	e8 e9 24 00 00       	call   80104ea0 <memset>

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
801029e8:	e8 f3 23 00 00       	call   80104de0 <acquire>
801029ed:	83 c4 10             	add    $0x10,%esp
801029f0:	eb d2                	jmp    801029c4 <kfree+0x44>
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029f8:	c7 45 08 60 28 11 80 	movl   $0x80112860,0x8(%ebp)
}
801029ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a02:	c9                   	leave  
    release(&kmem.lock);
80102a03:	e9 78 23 00 00       	jmp    80104d80 <release>
    panic("kfree");
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	68 de 7d 10 80       	push   $0x80107dde
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
80102adb:	68 e4 7d 10 80       	push   $0x80107de4
80102ae0:	68 60 28 11 80       	push   $0x80112860
80102ae5:	e8 26 21 00 00       	call   80104c10 <initlock>
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
80102b73:	e8 68 22 00 00       	call   80104de0 <acquire>
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
80102ba1:	e8 da 21 00 00       	call   80104d80 <release>
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
80102beb:	0f b6 91 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%edx
  shift ^= togglecode[data];
80102bf2:	0f b6 81 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%eax
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
80102c0b:	8b 04 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%eax
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
80102c48:	0f b6 81 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%eax
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
80102fb7:	e8 34 1f 00 00       	call   80104ef0 <memcmp>
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
801030e4:	e8 57 1e 00 00       	call   80104f40 <memmove>
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
8010318a:	68 20 80 10 80       	push   $0x80108020
8010318f:	68 c0 28 11 80       	push   $0x801128c0
80103194:	e8 77 1a 00 00       	call   80104c10 <initlock>
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
8010322b:	e8 b0 1b 00 00       	call   80104de0 <acquire>
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
8010327c:	e8 ff 1a 00 00       	call   80104d80 <release>
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
8010329e:	e8 3d 1b 00 00       	call   80104de0 <acquire>
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
801032dc:	e8 9f 1a 00 00       	call   80104d80 <release>
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
801032f6:	e8 e5 1a 00 00       	call   80104de0 <acquire>
    wakeup(&log);
801032fb:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
    log.committing = 0;
80103302:	c7 05 00 29 11 80 00 	movl   $0x0,0x80112900
80103309:	00 00 00 
    wakeup(&log);
8010330c:	e8 af 12 00 00       	call   801045c0 <wakeup>
    release(&log.lock);
80103311:	c7 04 24 c0 28 11 80 	movl   $0x801128c0,(%esp)
80103318:	e8 63 1a 00 00       	call   80104d80 <release>
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
80103374:	e8 c7 1b 00 00       	call   80104f40 <memmove>
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
801033d4:	e8 a7 19 00 00       	call   80104d80 <release>
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
801033e7:	68 24 80 10 80       	push   $0x80108024
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
80103436:	e8 a5 19 00 00       	call   80104de0 <acquire>
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
80103475:	e9 06 19 00 00       	jmp    80104d80 <release>
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
801034a1:	68 33 80 10 80       	push   $0x80108033
801034a6:	e8 d5 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801034ab:	83 ec 0c             	sub    $0xc,%esp
801034ae:	68 49 80 10 80       	push   $0x80108049
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
801034d8:	68 64 80 10 80       	push   $0x80108064
801034dd:	e8 be d1 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801034e2:	e8 a9 2d 00 00       	call   80106290 <idtinit>
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
80103506:	e8 75 3e 00 00       	call   80107380 <switchkvm>
  seginit();
8010350b:	e8 e0 3d 00 00       	call   801072f0 <seginit>
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
80103541:	e8 2a 43 00 00       	call   80107870 <kvmalloc>
  mpinit();        // detect other processors
80103546:	e8 85 01 00 00       	call   801036d0 <mpinit>
  lapicinit();     // interrupt controller
8010354b:	e8 60 f7 ff ff       	call   80102cb0 <lapicinit>
  seginit();       // segment descriptors
80103550:	e8 9b 3d 00 00       	call   801072f0 <seginit>
  picinit();       // disable pic
80103555:	e8 76 03 00 00       	call   801038d0 <picinit>
  ioapicinit();    // another interrupt controller
8010355a:	e8 31 f3 ff ff       	call   80102890 <ioapicinit>
  consoleinit();   // console hardware
8010355f:	e8 bc d9 ff ff       	call   80100f20 <consoleinit>
  uartinit();      // serial port
80103564:	e8 17 30 00 00       	call   80106580 <uartinit>
  pinit();         // process table
80103569:	e8 22 08 00 00       	call   80103d90 <pinit>
  tvinit();        // trap vectors
8010356e:	e8 9d 2c 00 00       	call   80106210 <tvinit>
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
80103594:	e8 a7 19 00 00       	call   80104f40 <memmove>

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
8010367e:	68 78 80 10 80       	push   $0x80108078
80103683:	56                   	push   %esi
80103684:	e8 67 18 00 00       	call   80104ef0 <memcmp>
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
80103736:	68 7d 80 10 80       	push   $0x8010807d
8010373b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010373c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010373f:	e8 ac 17 00 00       	call   80104ef0 <memcmp>
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
80103853:	68 82 80 10 80       	push   $0x80108082
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
80103882:	68 78 80 10 80       	push   $0x80108078
80103887:	53                   	push   %ebx
80103888:	e8 63 16 00 00       	call   80104ef0 <memcmp>
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
801038b8:	68 9c 80 10 80       	push   $0x8010809c
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
80103963:	68 bb 80 10 80       	push   $0x801080bb
80103968:	50                   	push   %eax
80103969:	e8 a2 12 00 00       	call   80104c10 <initlock>
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
801039ff:	e8 dc 13 00 00       	call   80104de0 <acquire>
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
80103a44:	e9 37 13 00 00       	jmp    80104d80 <release>
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 27 13 00 00       	call   80104d80 <release>
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
80103a9d:	e8 3e 13 00 00       	call   80104de0 <acquire>
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
80103b2c:	e8 4f 12 00 00       	call   80104d80 <release>
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
80103b82:	e8 f9 11 00 00       	call   80104d80 <release>
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
80103ba6:	e8 35 12 00 00       	call   80104de0 <acquire>
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
80103c3e:	e8 3d 11 00 00       	call   80104d80 <release>
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
80103c59:	e8 22 11 00 00       	call   80104d80 <release>
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
80103c81:	e8 5a 11 00 00       	call   80104de0 <acquire>
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
80103cc2:	e8 b9 10 00 00       	call   80104d80 <release>

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
80103ce7:	c7 40 14 fd 61 10 80 	movl   $0x801061fd,0x14(%eax)
  p->context = (struct context *)sp;
80103cee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cf1:	6a 14                	push   $0x14
80103cf3:	6a 00                	push   $0x0
80103cf5:	50                   	push   %eax
80103cf6:	e8 a5 11 00 00       	call   80104ea0 <memset>
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
80103d1a:	e8 61 10 00 00       	call   80104d80 <release>
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
80103d4b:	e8 30 10 00 00       	call   80104d80 <release>

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
80103d96:	68 c0 80 10 80       	push   $0x801080c0
80103d9b:	68 00 c6 12 80       	push   $0x8012c600
80103da0:	e8 6b 0e 00 00       	call   80104c10 <initlock>
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
80103df8:	68 c7 80 10 80       	push   $0x801080c7
80103dfd:	e8 7e c5 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	68 ec 81 10 80       	push   $0x801081ec
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
80103e37:	e8 54 0e 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103e3c:	e8 6f ff ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103e41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e47:	e8 94 0e 00 00       	call   80104ce0 <popcli>
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
80103e73:	e8 78 39 00 00       	call   801077f0 <setupkvm>
80103e78:	89 43 04             	mov    %eax,0x4(%ebx)
80103e7b:	85 c0                	test   %eax,%eax
80103e7d:	0f 84 bd 00 00 00    	je     80103f40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e83:	83 ec 04             	sub    $0x4,%esp
80103e86:	68 2c 00 00 00       	push   $0x2c
80103e8b:	68 60 b4 10 80       	push   $0x8010b460
80103e90:	50                   	push   %eax
80103e91:	e8 0a 36 00 00       	call   801074a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e9f:	6a 4c                	push   $0x4c
80103ea1:	6a 00                	push   $0x0
80103ea3:	ff 73 18             	push   0x18(%ebx)
80103ea6:	e8 f5 0f 00 00       	call   80104ea0 <memset>
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
80103eff:	68 f0 80 10 80       	push   $0x801080f0
80103f04:	50                   	push   %eax
80103f05:	e8 56 11 00 00       	call   80105060 <safestrcpy>
  p->cwd = namei("/");
80103f0a:	c7 04 24 f9 80 10 80 	movl   $0x801080f9,(%esp)
80103f11:	e8 4a e6 ff ff       	call   80102560 <namei>
80103f16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f19:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80103f20:	e8 bb 0e 00 00       	call   80104de0 <acquire>
  p->state = RUNNABLE;
80103f25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f2c:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80103f33:	e8 48 0e 00 00       	call   80104d80 <release>
}
80103f38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3b:	83 c4 10             	add    $0x10,%esp
80103f3e:	c9                   	leave  
80103f3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	68 d7 80 10 80       	push   $0x801080d7
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
80103f58:	e8 33 0d 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103f5d:	e8 4e fe ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103f62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f68:	e8 73 0d 00 00       	call   80104ce0 <popcli>
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
80103f7b:	e8 10 34 00 00       	call   80107390 <switchuvm>
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
80103f9a:	e8 71 36 00 00       	call   80107610 <allocuvm>
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
80103fba:	e8 81 37 00 00       	call   80107740 <deallocuvm>
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
80103fd9:	e8 b2 0c 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103fde:	e8 cd fd ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103fe3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe9:	e8 f2 0c 00 00       	call   80104ce0 <popcli>
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
80104008:	e8 d3 38 00 00       	call   801078e0 <copyuvm>
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
80104081:	e8 da 0f 00 00       	call   80105060 <safestrcpy>
  pid = np->pid;
80104086:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104089:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
80104090:	e8 4b 0d 00 00       	call   80104de0 <acquire>
  np->state = RUNNABLE;
80104095:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010409c:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801040a3:	e8 d8 0c 00 00       	call   80104d80 <release>
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
8010411e:	e8 bd 0c 00 00       	call   80104de0 <acquire>
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
80104140:	e8 4b 32 00 00       	call   80107390 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104145:	58                   	pop    %eax
80104146:	5a                   	pop    %edx
80104147:	ff 73 1c             	push   0x1c(%ebx)
8010414a:	57                   	push   %edi
      p->state = RUNNING;
8010414b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104152:	e8 64 0f 00 00       	call   801050bb <swtch>
      switchkvm();
80104157:	e8 24 32 00 00       	call   80107380 <switchkvm>
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
8010417c:	e8 ff 0b 00 00       	call   80104d80 <release>
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
80104195:	e8 f6 0a 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010419a:	e8 11 fc ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010419f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a5:	e8 36 0b 00 00       	call   80104ce0 <popcli>
  if (!holding(&ptable.lock))
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 00 c6 12 80       	push   $0x8012c600
801041b2:	e8 89 0b 00 00       	call   80104d40 <holding>
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
801041f3:	e8 c3 0e 00 00       	call   801050bb <swtch>
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
80104210:	68 fb 80 10 80       	push   $0x801080fb
80104215:	e8 66 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 27 81 10 80       	push   $0x80108127
80104222:	e8 59 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	68 19 81 10 80       	push   $0x80108119
8010422f:	e8 4c c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 0d 81 10 80       	push   $0x8010810d
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
801042ba:	e8 21 0b 00 00       	call   80104de0 <acquire>
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
8010435d:	68 48 81 10 80       	push   $0x80108148
80104362:	e8 19 c0 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	68 3b 81 10 80       	push   $0x8010813b
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
80104385:	e8 06 09 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010438a:	e8 21 fa ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010438f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104395:	e8 46 09 00 00       	call   80104ce0 <popcli>
  acquire(&ptable.lock);
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 00 c6 12 80       	push   $0x8012c600
801043a2:	e8 39 0a 00 00       	call   80104de0 <acquire>
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
801043f1:	e8 9a 08 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801043f6:	e8 b5 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801043fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104401:	e8 da 08 00 00       	call   80104ce0 <popcli>
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
80104449:	e8 22 33 00 00       	call   80107770 <freevm>
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
80104475:	e8 06 09 00 00       	call   80104d80 <release>
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
80104493:	e8 e8 08 00 00       	call   80104d80 <release>
      return -1;
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	eb e0                	jmp    8010447d <wait+0xfd>
    panic("sleep");
8010449d:	83 ec 0c             	sub    $0xc,%esp
801044a0:	68 54 81 10 80       	push   $0x80108154
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
801044bc:	e8 1f 09 00 00       	call   80104de0 <acquire>
  pushcli();
801044c1:	e8 ca 07 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801044c6:	e8 e5 f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801044cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044d1:	e8 0a 08 00 00       	call   80104ce0 <popcli>
  myproc()->state = RUNNABLE;
801044d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044dd:	e8 ae fc ff ff       	call   80104190 <sched>
  release(&ptable.lock);
801044e2:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
801044e9:	e8 92 08 00 00       	call   80104d80 <release>
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
8010450f:	e8 7c 07 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104514:	e8 97 f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104519:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010451f:	e8 bc 07 00 00       	call   80104ce0 <popcli>
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
80104540:	e8 9b 08 00 00       	call   80104de0 <acquire>
    release(lk);
80104545:	89 34 24             	mov    %esi,(%esp)
80104548:	e8 33 08 00 00       	call   80104d80 <release>
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
8010456a:	e8 11 08 00 00       	call   80104d80 <release>
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
8010457c:	e9 5f 08 00 00       	jmp    80104de0 <acquire>
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
801045a9:	68 5a 81 10 80       	push   $0x8010815a
801045ae:	e8 cd bd ff ff       	call   80100380 <panic>
    panic("sleep");
801045b3:	83 ec 0c             	sub    $0xc,%esp
801045b6:	68 54 81 10 80       	push   $0x80108154
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
801045cf:	e8 0c 08 00 00       	call   80104de0 <acquire>
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
80104611:	e9 6a 07 00 00       	jmp    80104d80 <release>
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
8010462f:	e8 ac 07 00 00       	call   80104de0 <acquire>
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
8010466b:	e8 10 07 00 00       	call   80104d80 <release>
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
80104688:	e8 f3 06 00 00       	call   80104d80 <release>
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
801046bb:	68 47 85 10 80       	push   $0x80108547
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
801046de:	ba 6b 81 10 80       	mov    $0x8010816b,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046e3:	83 f8 05             	cmp    $0x5,%eax
801046e6:	77 11                	ja     801046f9 <procdump+0x59>
801046e8:	8b 14 85 2c 82 10 80 	mov    -0x7fef7dd4(,%eax,4),%edx
      state = "???";
801046ef:	b8 6b 81 10 80       	mov    $0x8010816b,%eax
801046f4:	85 d2                	test   %edx,%edx
801046f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046f9:	53                   	push   %ebx
801046fa:	52                   	push   %edx
801046fb:	ff 73 a4             	push   -0x5c(%ebx)
801046fe:	68 6f 81 10 80       	push   $0x8010816f
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
80104725:	e8 06 05 00 00       	call   80104c30 <getcallerpcs>
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
8010473d:	68 81 7b 10 80       	push   $0x80107b81
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
801047cd:	68 78 81 10 80       	push   $0x80108178
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
801047f1:	68 7d 81 10 80       	push   $0x8010817d
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

char*
get_state_name(int state)
{
80104810:	55                   	push   %ebp
80104811:	b8 48 85 10 80       	mov    $0x80108548,%eax
80104816:	89 e5                	mov    %esp,%ebp
80104818:	8b 55 08             	mov    0x8(%ebp),%edx
8010481b:	83 fa 05             	cmp    $0x5,%edx
8010481e:	77 07                	ja     80104827 <get_state_name+0x17>
80104820:	8b 04 95 14 82 10 80 	mov    -0x7fef7dec(,%edx,4),%eax
    return "ZOMBIE";
  }
  else {
    return "";
  }
}
80104827:	5d                   	pop    %ebp
80104828:	c3                   	ret    
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <get_num_len>:


int get_num_len(int number)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	8b 55 08             	mov    0x8(%ebp),%edx
80104837:	53                   	push   %ebx
  int len = 0;
80104838:	31 db                	xor    %ebx,%ebx
  while (number > 0) {
8010483a:	85 d2                	test   %edx,%edx
8010483c:	7e 1b                	jle    80104859 <get_num_len+0x29>
    len++;
    number = number / 10;
8010483e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104847:	90                   	nop
80104848:	89 d0                	mov    %edx,%eax
8010484a:	89 d1                	mov    %edx,%ecx
    len++;
8010484c:	83 c3 01             	add    $0x1,%ebx
    number = number / 10;
8010484f:	f7 e6                	mul    %esi
80104851:	c1 ea 03             	shr    $0x3,%edx
  while (number > 0) {
80104854:	83 f9 09             	cmp    $0x9,%ecx
80104857:	7f ef                	jg     80104848 <get_num_len+0x18>
  }
  return len;
}
80104859:	89 d8                	mov    %ebx,%eax
8010485b:	5b                   	pop    %ebx
8010485c:	5e                   	pop    %esi
8010485d:	5d                   	pop    %ebp
8010485e:	c3                   	ret    
8010485f:	90                   	nop

80104860 <print_all_procs_status>:

void print_all_procs_status()
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	56                   	push   %esi
80104865:	53                   	push   %ebx
  struct proc *p;

  cprintf("name");
80104866:	bb 0a 00 00 00       	mov    $0xa,%ebx
{
8010486b:	83 ec 28             	sub    $0x28,%esp
  cprintf("name");
8010486e:	68 80 81 10 80       	push   $0x80108180
80104873:	e8 28 be ff ff       	call   801006a0 <cprintf>
80104878:	83 c4 10             	add    $0x10,%esp
  for (int i = 0 ; i < 10 ; i++)
    cprintf(" ");
8010487b:	83 ec 0c             	sub    $0xc,%esp
8010487e:	68 e1 81 10 80       	push   $0x801081e1
80104883:	e8 18 be ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 10 ; i++)
80104888:	83 c4 10             	add    $0x10,%esp
8010488b:	83 eb 01             	sub    $0x1,%ebx
8010488e:	75 eb                	jne    8010487b <print_all_procs_status+0x1b>

  cprintf("pid");
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	bb 0d 00 00 00       	mov    $0xd,%ebx
80104898:	68 85 81 10 80       	push   $0x80108185
8010489d:	e8 fe bd ff ff       	call   801006a0 <cprintf>
801048a2:	83 c4 10             	add    $0x10,%esp
  for (int i = 0 ; i < 13 ; i++)
    cprintf(" ");
801048a5:	83 ec 0c             	sub    $0xc,%esp
801048a8:	68 e1 81 10 80       	push   $0x801081e1
801048ad:	e8 ee bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 13 ; i++)
801048b2:	83 c4 10             	add    $0x10,%esp
801048b5:	83 eb 01             	sub    $0x1,%ebx
801048b8:	75 eb                	jne    801048a5 <print_all_procs_status+0x45>

  cprintf("state");
801048ba:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0 ; i < 5 ; i++)
    cprintf(" ");

  cprintf("\n");
801048bd:	bb 26 00 00 00       	mov    $0x26,%ebx
  cprintf("state");
801048c2:	68 89 81 10 80       	push   $0x80108189
801048c7:	e8 d4 bd ff ff       	call   801006a0 <cprintf>
    cprintf(" ");
801048cc:	c7 04 24 e1 81 10 80 	movl   $0x801081e1,(%esp)
801048d3:	e8 c8 bd ff ff       	call   801006a0 <cprintf>
801048d8:	c7 04 24 e1 81 10 80 	movl   $0x801081e1,(%esp)
801048df:	e8 bc bd ff ff       	call   801006a0 <cprintf>
801048e4:	c7 04 24 e1 81 10 80 	movl   $0x801081e1,(%esp)
801048eb:	e8 b0 bd ff ff       	call   801006a0 <cprintf>
801048f0:	c7 04 24 e1 81 10 80 	movl   $0x801081e1,(%esp)
801048f7:	e8 a4 bd ff ff       	call   801006a0 <cprintf>
801048fc:	c7 04 24 e1 81 10 80 	movl   $0x801081e1,(%esp)
80104903:	e8 98 bd ff ff       	call   801006a0 <cprintf>
  cprintf("\n");
80104908:	c7 04 24 47 85 10 80 	movl   $0x80108547,(%esp)
8010490f:	e8 8c bd ff ff       	call   801006a0 <cprintf>
80104914:	83 c4 10             	add    $0x10,%esp
80104917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491e:	66 90                	xchg   %ax,%ax
  for (int i = 0 ; i < 38 ; i++)
    cprintf("-");
80104920:	83 ec 0c             	sub    $0xc,%esp
80104923:	68 8f 81 10 80       	push   $0x8010818f
80104928:	e8 73 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0 ; i < 38 ; i++)
8010492d:	83 c4 10             	add    $0x10,%esp
80104930:	83 eb 01             	sub    $0x1,%ebx
80104933:	75 eb                	jne    80104920 <print_all_procs_status+0xc0>
  cprintf("\n");
80104935:	83 ec 0c             	sub    $0xc,%esp
80104938:	bf a0 c6 12 80       	mov    $0x8012c6a0,%edi
8010493d:	68 47 85 10 80       	push   $0x80108547
80104942:	e8 59 bd ff ff       	call   801006a0 <cprintf>


  acquire(&ptable.lock);
80104947:	c7 04 24 00 c6 12 80 	movl   $0x8012c600,(%esp)
8010494e:	e8 8d 04 00 00       	call   80104de0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104953:	83 c4 10             	add    $0x10,%esp
80104956:	eb 18                	jmp    80104970 <print_all_procs_status+0x110>
80104958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop
80104960:	83 c7 7c             	add    $0x7c,%edi
80104963:	b8 a0 e5 12 80       	mov    $0x8012e5a0,%eax
80104968:	39 f8                	cmp    %edi,%eax
8010496a:	0f 84 55 01 00 00    	je     80104ac5 <print_all_procs_status+0x265>
    if (p->state == UNUSED)
80104970:	8b 47 a0             	mov    -0x60(%edi),%eax
80104973:	85 c0                	test   %eax,%eax
80104975:	74 e9                	je     80104960 <print_all_procs_status+0x100>
      continue;

    cprintf(p->name);
80104977:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
8010497a:	31 db                	xor    %ebx,%ebx
8010497c:	be 0f 00 00 00       	mov    $0xf,%esi
    cprintf(p->name);
80104981:	57                   	push   %edi
80104982:	e8 19 bd ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
80104987:	83 c4 10             	add    $0x10,%esp
8010498a:	eb 17                	jmp    801049a3 <print_all_procs_status+0x143>
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" ");
80104990:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
80104993:	83 c3 01             	add    $0x1,%ebx
      cprintf(" ");
80104996:	68 e1 81 10 80       	push   $0x801081e1
8010499b:	e8 00 bd ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(p->name) ; i++)
801049a0:	83 c4 10             	add    $0x10,%esp
801049a3:	83 ec 0c             	sub    $0xc,%esp
801049a6:	57                   	push   %edi
801049a7:	e8 f4 06 00 00       	call   801050a0 <strlen>
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	89 c2                	mov    %eax,%edx
801049b1:	89 f0                	mov    %esi,%eax
801049b3:	29 d0                	sub    %edx,%eax
801049b5:	39 d8                	cmp    %ebx,%eax
801049b7:	7f d7                	jg     80104990 <print_all_procs_status+0x130>

    cprintf("%d", p->pid);
801049b9:	83 ec 08             	sub    $0x8,%esp
801049bc:	ff 77 a4             	push   -0x5c(%edi)
    number = number / 10;
801049bf:	be cd cc cc cc       	mov    $0xcccccccd,%esi
    cprintf("%d", p->pid);
801049c4:	68 7d 81 10 80       	push   $0x8010817d
801049c9:	e8 d2 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - get_num_len(p->pid) ; i++)
801049ce:	31 c0                	xor    %eax,%eax
801049d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801049d3:	83 c4 10             	add    $0x10,%esp
801049d6:	89 c7                	mov    %eax,%edi
801049d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801049db:	8b 50 a4             	mov    -0x5c(%eax),%edx
  while (number > 0) {
801049de:	85 d2                	test   %edx,%edx
801049e0:	7e 47                	jle    80104a29 <print_all_procs_status+0x1c9>
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int len = 0;
801049e8:	31 db                	xor    %ebx,%ebx
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    number = number / 10;
801049f0:	89 d0                	mov    %edx,%eax
801049f2:	89 d1                	mov    %edx,%ecx
    len++;
801049f4:	83 c3 01             	add    $0x1,%ebx
    number = number / 10;
801049f7:	f7 e6                	mul    %esi
801049f9:	c1 ea 03             	shr    $0x3,%edx
  while (number > 0) {
801049fc:	83 f9 09             	cmp    $0x9,%ecx
801049ff:	7f ef                	jg     801049f0 <print_all_procs_status+0x190>
    for (int i = 0 ; i < 15 - get_num_len(p->pid) ; i++)
80104a01:	b8 0f 00 00 00       	mov    $0xf,%eax
80104a06:	29 d8                	sub    %ebx,%eax
80104a08:	39 f8                	cmp    %edi,%eax
80104a0a:	7e 2c                	jle    80104a38 <print_all_procs_status+0x1d8>
      cprintf(" ");
80104a0c:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - get_num_len(p->pid) ; i++)
80104a0f:	83 c7 01             	add    $0x1,%edi
      cprintf(" ");
80104a12:	68 e1 81 10 80       	push   $0x801081e1
80104a17:	e8 84 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - get_num_len(p->pid) ; i++)
80104a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a1f:	83 c4 10             	add    $0x10,%esp
80104a22:	8b 50 a4             	mov    -0x5c(%eax),%edx
  while (number > 0) {
80104a25:	85 d2                	test   %edx,%edx
80104a27:	7f bf                	jg     801049e8 <print_all_procs_status+0x188>
80104a29:	b8 0f 00 00 00       	mov    $0xf,%eax
    for (int i = 0 ; i < 15 - get_num_len(p->pid) ; i++)
80104a2e:	39 f8                	cmp    %edi,%eax
80104a30:	7f da                	jg     80104a0c <print_all_procs_status+0x1ac>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    cprintf(get_state_name(p->state));
80104a38:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104a3b:	b8 48 85 10 80       	mov    $0x80108548,%eax
80104a40:	8b 57 a0             	mov    -0x60(%edi),%edx
  if (state == 0) {
80104a43:	83 fa 05             	cmp    $0x5,%edx
80104a46:	77 07                	ja     80104a4f <print_all_procs_status+0x1ef>
80104a48:	8b 04 95 14 82 10 80 	mov    -0x7fef7dec(,%edx,4),%eax
    cprintf(get_state_name(p->state));
80104a4f:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104a52:	31 db                	xor    %ebx,%ebx
80104a54:	be 0f 00 00 00       	mov    $0xf,%esi
    cprintf(get_state_name(p->state));
80104a59:	50                   	push   %eax
80104a5a:	e8 41 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104a5f:	83 c4 10             	add    $0x10,%esp
80104a62:	eb 17                	jmp    80104a7b <print_all_procs_status+0x21b>
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf(" "); 
80104a68:	83 ec 0c             	sub    $0xc,%esp
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104a6b:	83 c3 01             	add    $0x1,%ebx
      cprintf(" "); 
80104a6e:	68 e1 81 10 80       	push   $0x801081e1
80104a73:	e8 28 bc ff ff       	call   801006a0 <cprintf>
    for (int i = 0 ; i < 15 - strlen(get_state_name(p->state)) ; i++)
80104a78:	83 c4 10             	add    $0x10,%esp
80104a7b:	8b 57 a0             	mov    -0x60(%edi),%edx
80104a7e:	b8 48 85 10 80       	mov    $0x80108548,%eax
80104a83:	83 fa 05             	cmp    $0x5,%edx
80104a86:	77 07                	ja     80104a8f <print_all_procs_status+0x22f>
80104a88:	8b 04 95 14 82 10 80 	mov    -0x7fef7dec(,%edx,4),%eax
80104a8f:	83 ec 0c             	sub    $0xc,%esp
80104a92:	50                   	push   %eax
80104a93:	e8 08 06 00 00       	call   801050a0 <strlen>
80104a98:	83 c4 10             	add    $0x10,%esp
80104a9b:	89 c2                	mov    %eax,%edx
80104a9d:	89 f0                	mov    %esi,%eax
80104a9f:	29 d0                	sub    %edx,%eax
80104aa1:	39 d8                	cmp    %ebx,%eax
80104aa3:	7f c3                	jg     80104a68 <print_all_procs_status+0x208>

    cprintf("\n");
80104aa5:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104aa8:	83 c7 7c             	add    $0x7c,%edi
    cprintf("\n");
80104aab:	68 47 85 10 80       	push   $0x80108547
80104ab0:	e8 eb bb ff ff       	call   801006a0 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104ab5:	b8 a0 e5 12 80       	mov    $0x8012e5a0,%eax
    cprintf("\n");
80104aba:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){ 
80104abd:	39 f8                	cmp    %edi,%eax
80104abf:	0f 85 ab fe ff ff    	jne    80104970 <print_all_procs_status+0x110>
  }
  release(&ptable.lock);
80104ac5:	83 ec 0c             	sub    $0xc,%esp
80104ac8:	68 00 c6 12 80       	push   $0x8012c600
80104acd:	e8 ae 02 00 00       	call   80104d80 <release>

80104ad2:	83 c4 10             	add    $0x10,%esp
80104ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ad8:	5b                   	pop    %ebx
80104ad9:	5e                   	pop    %esi
80104ada:	5f                   	pop    %edi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	66 90                	xchg   %ax,%ax
80104adf:	90                   	nop

80104ae0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104aea:	68 44 82 10 80       	push   $0x80108244
80104aef:	8d 43 04             	lea    0x4(%ebx),%eax
80104af2:	50                   	push   %eax
80104af3:	e8 18 01 00 00       	call   80104c10 <initlock>
  lk->name = name;
80104af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104afb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b01:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b0b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b11:	c9                   	leave  
80104b12:	c3                   	ret    
80104b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b28:	8d 73 04             	lea    0x4(%ebx),%esi
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	56                   	push   %esi
80104b2f:	e8 ac 02 00 00       	call   80104de0 <acquire>
  while (lk->locked) {
80104b34:	8b 13                	mov    (%ebx),%edx
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 d2                	test   %edx,%edx
80104b3b:	74 16                	je     80104b53 <acquiresleep+0x33>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104b40:	83 ec 08             	sub    $0x8,%esp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
80104b45:	e8 b6 f9 ff ff       	call   80104500 <sleep>
  while (lk->locked) {
80104b4a:	8b 03                	mov    (%ebx),%eax
80104b4c:	83 c4 10             	add    $0x10,%esp
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	75 ed                	jne    80104b40 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b59:	e8 d2 f2 ff ff       	call   80103e30 <myproc>
80104b5e:	8b 40 10             	mov    0x10(%eax),%eax
80104b61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b6a:	5b                   	pop    %ebx
80104b6b:	5e                   	pop    %esi
80104b6c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b6d:	e9 0e 02 00 00       	jmp    80104d80 <release>
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b88:	8d 73 04             	lea    0x4(%ebx),%esi
80104b8b:	83 ec 0c             	sub    $0xc,%esp
80104b8e:	56                   	push   %esi
80104b8f:	e8 4c 02 00 00       	call   80104de0 <acquire>
  lk->locked = 0;
80104b94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ba1:	89 1c 24             	mov    %ebx,(%esp)
80104ba4:	e8 17 fa ff ff       	call   801045c0 <wakeup>
  release(&lk->lk);
80104ba9:	89 75 08             	mov    %esi,0x8(%ebp)
80104bac:	83 c4 10             	add    $0x10,%esp
}
80104baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bb5:	e9 c6 01 00 00       	jmp    80104d80 <release>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	31 ff                	xor    %edi,%edi
80104bc6:	56                   	push   %esi
80104bc7:	53                   	push   %ebx
80104bc8:	83 ec 18             	sub    $0x18,%esp
80104bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bce:	8d 73 04             	lea    0x4(%ebx),%esi
80104bd1:	56                   	push   %esi
80104bd2:	e8 09 02 00 00       	call   80104de0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bd7:	8b 03                	mov    (%ebx),%eax
80104bd9:	83 c4 10             	add    $0x10,%esp
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	75 18                	jne    80104bf8 <holdingsleep+0x38>
  release(&lk->lk);
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	56                   	push   %esi
80104be4:	e8 97 01 00 00       	call   80104d80 <release>
  return r;
}
80104be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bec:	89 f8                	mov    %edi,%eax
80104bee:	5b                   	pop    %ebx
80104bef:	5e                   	pop    %esi
80104bf0:	5f                   	pop    %edi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret    
80104bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104bf8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bfb:	e8 30 f2 ff ff       	call   80103e30 <myproc>
80104c00:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c03:	0f 94 c0             	sete   %al
80104c06:	0f b6 c0             	movzbl %al,%eax
80104c09:	89 c7                	mov    %eax,%edi
80104c0b:	eb d3                	jmp    80104be0 <holdingsleep+0x20>
80104c0d:	66 90                	xchg   %ax,%ax
80104c0f:	90                   	nop

80104c10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c30:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c31:	31 d2                	xor    %edx,%edx
{
80104c33:	89 e5                	mov    %esp,%ebp
80104c35:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c36:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c3c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c4c:	77 1a                	ja     80104c68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104c51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c54:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c57:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c59:	83 fa 0a             	cmp    $0xa,%edx
80104c5c:	75 e2                	jne    80104c40 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c61:	c9                   	leave  
80104c62:	c3                   	ret    
80104c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c67:	90                   	nop
  for(; i < 10; i++)
80104c68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c6b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c76:	83 c0 04             	add    $0x4,%eax
80104c79:	39 d0                	cmp    %edx,%eax
80104c7b:	75 f3                	jne    80104c70 <getcallerpcs+0x40>
}
80104c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c80:	c9                   	leave  
80104c81:	c3                   	ret    
80104c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	9c                   	pushf  
80104c98:	5b                   	pop    %ebx
  asm volatile("cli");
80104c99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c9a:	e8 11 f1 ff ff       	call   80103db0 <mycpu>
80104c9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	74 17                	je     80104cc0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104ca9:	e8 02 f1 ff ff       	call   80103db0 <mycpu>
80104cae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb8:	c9                   	leave  
80104cb9:	c3                   	ret    
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104cc0:	e8 eb f0 ff ff       	call   80103db0 <mycpu>
80104cc5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ccb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104cd1:	eb d6                	jmp    80104ca9 <pushcli+0x19>
80104cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <popcli>:

void
popcli(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ce6:	9c                   	pushf  
80104ce7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ce8:	f6 c4 02             	test   $0x2,%ah
80104ceb:	75 35                	jne    80104d22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ced:	e8 be f0 ff ff       	call   80103db0 <mycpu>
80104cf2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cf9:	78 34                	js     80104d2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cfb:	e8 b0 f0 ff ff       	call   80103db0 <mycpu>
80104d00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d06:	85 d2                	test   %edx,%edx
80104d08:	74 06                	je     80104d10 <popcli+0x30>
    sti();
}
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d10:	e8 9b f0 ff ff       	call   80103db0 <mycpu>
80104d15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	74 eb                	je     80104d0a <popcli+0x2a>
  asm volatile("sti");
80104d1f:	fb                   	sti    
}
80104d20:	c9                   	leave  
80104d21:	c3                   	ret    
    panic("popcli - interruptible");
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	68 4f 82 10 80       	push   $0x8010824f
80104d2a:	e8 51 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	68 66 82 10 80       	push   $0x80108266
80104d37:	e8 44 b6 ff ff       	call   80100380 <panic>
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <holding>:
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 75 08             	mov    0x8(%ebp),%esi
80104d48:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d4a:	e8 41 ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d4f:	8b 06                	mov    (%esi),%eax
80104d51:	85 c0                	test   %eax,%eax
80104d53:	75 0b                	jne    80104d60 <holding+0x20>
  popcli();
80104d55:	e8 86 ff ff ff       	call   80104ce0 <popcli>
}
80104d5a:	89 d8                	mov    %ebx,%eax
80104d5c:	5b                   	pop    %ebx
80104d5d:	5e                   	pop    %esi
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d60:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d63:	e8 48 f0 ff ff       	call   80103db0 <mycpu>
80104d68:	39 c3                	cmp    %eax,%ebx
80104d6a:	0f 94 c3             	sete   %bl
  popcli();
80104d6d:	e8 6e ff ff ff       	call   80104ce0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d72:	0f b6 db             	movzbl %bl,%ebx
}
80104d75:	89 d8                	mov    %ebx,%eax
80104d77:	5b                   	pop    %ebx
80104d78:	5e                   	pop    %esi
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop

80104d80 <release>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d88:	e8 03 ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d8d:	8b 03                	mov    (%ebx),%eax
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	75 15                	jne    80104da8 <release+0x28>
  popcli();
80104d93:	e8 48 ff ff ff       	call   80104ce0 <popcli>
    panic("release");
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	68 6d 82 10 80       	push   $0x8010826d
80104da0:	e8 db b5 ff ff       	call   80100380 <panic>
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104da8:	8b 73 08             	mov    0x8(%ebx),%esi
80104dab:	e8 00 f0 ff ff       	call   80103db0 <mycpu>
80104db0:	39 c6                	cmp    %eax,%esi
80104db2:	75 df                	jne    80104d93 <release+0x13>
  popcli();
80104db4:	e8 27 ff ff ff       	call   80104ce0 <popcli>
  lk->pcs[0] = 0;
80104db9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104dc0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104dc7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dcc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
  popcli();
80104dd8:	e9 03 ff ff ff       	jmp    80104ce0 <popcli>
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <acquire>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104de7:	e8 a4 fe ff ff       	call   80104c90 <pushcli>
  if(holding(lk))
80104dec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104def:	e8 9c fe ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104df4:	8b 03                	mov    (%ebx),%eax
80104df6:	85 c0                	test   %eax,%eax
80104df8:	75 7e                	jne    80104e78 <acquire+0x98>
  popcli();
80104dfa:	e8 e1 fe ff ff       	call   80104ce0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104dff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104e08:	8b 55 08             	mov    0x8(%ebp),%edx
80104e0b:	89 c8                	mov    %ecx,%eax
80104e0d:	f0 87 02             	lock xchg %eax,(%edx)
80104e10:	85 c0                	test   %eax,%eax
80104e12:	75 f4                	jne    80104e08 <acquire+0x28>
  __sync_synchronize();
80104e14:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e1c:	e8 8f ef ff ff       	call   80103db0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e24:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104e26:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104e29:	31 c0                	xor    %eax,%eax
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e30:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104e36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e3c:	77 1a                	ja     80104e58 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104e3e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104e41:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104e45:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104e48:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104e4a:	83 f8 0a             	cmp    $0xa,%eax
80104e4d:	75 e1                	jne    80104e30 <acquire+0x50>
}
80104e4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e52:	c9                   	leave  
80104e53:	c3                   	ret    
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e58:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104e5c:	8d 51 34             	lea    0x34(%ecx),%edx
80104e5f:	90                   	nop
    pcs[i] = 0;
80104e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e66:	83 c0 04             	add    $0x4,%eax
80104e69:	39 c2                	cmp    %eax,%edx
80104e6b:	75 f3                	jne    80104e60 <acquire+0x80>
}
80104e6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e70:	c9                   	leave  
80104e71:	c3                   	ret    
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e78:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104e7b:	e8 30 ef ff ff       	call   80103db0 <mycpu>
80104e80:	39 c3                	cmp    %eax,%ebx
80104e82:	0f 85 72 ff ff ff    	jne    80104dfa <acquire+0x1a>
  popcli();
80104e88:	e8 53 fe ff ff       	call   80104ce0 <popcli>
    panic("acquire");
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	68 75 82 10 80       	push   $0x80108275
80104e95:	e8 e6 b4 ff ff       	call   80100380 <panic>
80104e9a:	66 90                	xchg   %ax,%ax
80104e9c:	66 90                	xchg   %ax,%ax
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <memset>:
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eaa:	53                   	push   %ebx
80104eab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eae:	89 d7                	mov    %edx,%edi
80104eb0:	09 cf                	or     %ecx,%edi
80104eb2:	83 e7 03             	and    $0x3,%edi
80104eb5:	75 29                	jne    80104ee0 <memset+0x40>
80104eb7:	0f b6 f8             	movzbl %al,%edi
80104eba:	c1 e0 18             	shl    $0x18,%eax
80104ebd:	89 fb                	mov    %edi,%ebx
80104ebf:	c1 e9 02             	shr    $0x2,%ecx
80104ec2:	c1 e3 10             	shl    $0x10,%ebx
80104ec5:	09 d8                	or     %ebx,%eax
80104ec7:	09 f8                	or     %edi,%eax
80104ec9:	c1 e7 08             	shl    $0x8,%edi
80104ecc:	09 f8                	or     %edi,%eax
80104ece:	89 d7                	mov    %edx,%edi
80104ed0:	fc                   	cld    
80104ed1:	f3 ab                	rep stos %eax,%es:(%edi)
80104ed3:	5b                   	pop    %ebx
80104ed4:	89 d0                	mov    %edx,%eax
80104ed6:	5f                   	pop    %edi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee0:	89 d7                	mov    %edx,%edi
80104ee2:	fc                   	cld    
80104ee3:	f3 aa                	rep stos %al,%es:(%edi)
80104ee5:	5b                   	pop    %ebx
80104ee6:	89 d0                	mov    %edx,%eax
80104ee8:	5f                   	pop    %edi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <memcmp>:
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ef7:	8b 55 08             	mov    0x8(%ebp),%edx
80104efa:	53                   	push   %ebx
80104efb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104efe:	85 f6                	test   %esi,%esi
80104f00:	74 2e                	je     80104f30 <memcmp+0x40>
80104f02:	01 c6                	add    %eax,%esi
80104f04:	eb 14                	jmp    80104f1a <memcmp+0x2a>
80104f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	83 c0 01             	add    $0x1,%eax
80104f13:	83 c2 01             	add    $0x1,%edx
80104f16:	39 f0                	cmp    %esi,%eax
80104f18:	74 16                	je     80104f30 <memcmp+0x40>
80104f1a:	0f b6 0a             	movzbl (%edx),%ecx
80104f1d:	0f b6 18             	movzbl (%eax),%ebx
80104f20:	38 d9                	cmp    %bl,%cl
80104f22:	74 ec                	je     80104f10 <memcmp+0x20>
80104f24:	0f b6 c1             	movzbl %cl,%eax
80104f27:	29 d8                	sub    %ebx,%eax
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	5b                   	pop    %ebx
80104f31:	31 c0                	xor    %eax,%eax
80104f33:	5e                   	pop    %esi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

80104f40 <memmove>:
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	8b 55 08             	mov    0x8(%ebp),%edx
80104f47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f4a:	56                   	push   %esi
80104f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
80104f4e:	39 d6                	cmp    %edx,%esi
80104f50:	73 26                	jae    80104f78 <memmove+0x38>
80104f52:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f55:	39 fa                	cmp    %edi,%edx
80104f57:	73 1f                	jae    80104f78 <memmove+0x38>
80104f59:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104f5c:	85 c9                	test   %ecx,%ecx
80104f5e:	74 0c                	je     80104f6c <memmove+0x2c>
80104f60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f64:	88 0c 02             	mov    %cl,(%edx,%eax,1)
80104f67:	83 e8 01             	sub    $0x1,%eax
80104f6a:	73 f4                	jae    80104f60 <memmove+0x20>
80104f6c:	5e                   	pop    %esi
80104f6d:	89 d0                	mov    %edx,%eax
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f78:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f7b:	89 d7                	mov    %edx,%edi
80104f7d:	85 c9                	test   %ecx,%ecx
80104f7f:	74 eb                	je     80104f6c <memmove+0x2c>
80104f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f88:	a4                   	movsb  %ds:(%esi),%es:(%edi)
80104f89:	39 c6                	cmp    %eax,%esi
80104f8b:	75 fb                	jne    80104f88 <memmove+0x48>
80104f8d:	5e                   	pop    %esi
80104f8e:	89 d0                	mov    %edx,%eax
80104f90:	5f                   	pop    %edi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fa0 <memcpy>:
80104fa0:	eb 9e                	jmp    80104f40 <memmove>
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <strncmp>:
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	8b 75 10             	mov    0x10(%ebp),%esi
80104fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fba:	53                   	push   %ebx
80104fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fbe:	85 f6                	test   %esi,%esi
80104fc0:	74 2e                	je     80104ff0 <strncmp+0x40>
80104fc2:	01 d6                	add    %edx,%esi
80104fc4:	eb 18                	jmp    80104fde <strncmp+0x2e>
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
80104fd0:	38 d8                	cmp    %bl,%al
80104fd2:	75 14                	jne    80104fe8 <strncmp+0x38>
80104fd4:	83 c2 01             	add    $0x1,%edx
80104fd7:	83 c1 01             	add    $0x1,%ecx
80104fda:	39 f2                	cmp    %esi,%edx
80104fdc:	74 12                	je     80104ff0 <strncmp+0x40>
80104fde:	0f b6 01             	movzbl (%ecx),%eax
80104fe1:	0f b6 1a             	movzbl (%edx),%ebx
80104fe4:	84 c0                	test   %al,%al
80104fe6:	75 e8                	jne    80104fd0 <strncmp+0x20>
80104fe8:	29 d8                	sub    %ebx,%eax
80104fea:	5b                   	pop    %ebx
80104feb:	5e                   	pop    %esi
80104fec:	5d                   	pop    %ebp
80104fed:	c3                   	ret    
80104fee:	66 90                	xchg   %ax,%ax
80104ff0:	5b                   	pop    %ebx
80104ff1:	31 c0                	xor    %eax,%eax
80104ff3:	5e                   	pop    %esi
80104ff4:	5d                   	pop    %ebp
80104ff5:	c3                   	ret    
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <strncpy>:
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	8b 75 08             	mov    0x8(%ebp),%esi
80105008:	53                   	push   %ebx
80105009:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010500c:	89 f0                	mov    %esi,%eax
8010500e:	eb 15                	jmp    80105025 <strncpy+0x25>
80105010:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105014:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105017:	83 c0 01             	add    $0x1,%eax
8010501a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010501e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105021:	84 d2                	test   %dl,%dl
80105023:	74 09                	je     8010502e <strncpy+0x2e>
80105025:	89 cb                	mov    %ecx,%ebx
80105027:	83 e9 01             	sub    $0x1,%ecx
8010502a:	85 db                	test   %ebx,%ebx
8010502c:	7f e2                	jg     80105010 <strncpy+0x10>
8010502e:	89 c2                	mov    %eax,%edx
80105030:	85 c9                	test   %ecx,%ecx
80105032:	7e 17                	jle    8010504b <strncpy+0x4b>
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105038:	83 c2 01             	add    $0x1,%edx
8010503b:	89 c1                	mov    %eax,%ecx
8010503d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
80105041:	29 d1                	sub    %edx,%ecx
80105043:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105047:	85 c9                	test   %ecx,%ecx
80105049:	7f ed                	jg     80105038 <strncpy+0x38>
8010504b:	5b                   	pop    %ebx
8010504c:	89 f0                	mov    %esi,%eax
8010504e:	5e                   	pop    %esi
8010504f:	5f                   	pop    %edi
80105050:	5d                   	pop    %ebp
80105051:	c3                   	ret    
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105060 <safestrcpy>:
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	8b 55 10             	mov    0x10(%ebp),%edx
80105067:	8b 75 08             	mov    0x8(%ebp),%esi
8010506a:	53                   	push   %ebx
8010506b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506e:	85 d2                	test   %edx,%edx
80105070:	7e 25                	jle    80105097 <safestrcpy+0x37>
80105072:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105076:	89 f2                	mov    %esi,%edx
80105078:	eb 16                	jmp    80105090 <safestrcpy+0x30>
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105080:	0f b6 08             	movzbl (%eax),%ecx
80105083:	83 c0 01             	add    $0x1,%eax
80105086:	83 c2 01             	add    $0x1,%edx
80105089:	88 4a ff             	mov    %cl,-0x1(%edx)
8010508c:	84 c9                	test   %cl,%cl
8010508e:	74 04                	je     80105094 <safestrcpy+0x34>
80105090:	39 d8                	cmp    %ebx,%eax
80105092:	75 ec                	jne    80105080 <safestrcpy+0x20>
80105094:	c6 02 00             	movb   $0x0,(%edx)
80105097:	89 f0                	mov    %esi,%eax
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi

801050a0 <strlen>:
801050a0:	55                   	push   %ebp
801050a1:	31 c0                	xor    %eax,%eax
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	8b 55 08             	mov    0x8(%ebp),%edx
801050a8:	80 3a 00             	cmpb   $0x0,(%edx)
801050ab:	74 0c                	je     801050b9 <strlen+0x19>
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
801050b0:	83 c0 01             	add    $0x1,%eax
801050b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050b7:	75 f7                	jne    801050b0 <strlen+0x10>
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    

801050bb <swtch>:
801050bb:	8b 44 24 04          	mov    0x4(%esp),%eax
801050bf:	8b 54 24 08          	mov    0x8(%esp),%edx
801050c3:	55                   	push   %ebp
801050c4:	53                   	push   %ebx
801050c5:	56                   	push   %esi
801050c6:	57                   	push   %edi
801050c7:	89 20                	mov    %esp,(%eax)
801050c9:	89 d4                	mov    %edx,%esp
801050cb:	5f                   	pop    %edi
801050cc:	5e                   	pop    %esi
801050cd:	5b                   	pop    %ebx
801050ce:	5d                   	pop    %ebp
801050cf:	c3                   	ret    

801050d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	53                   	push   %ebx
801050d4:	83 ec 04             	sub    $0x4,%esp
801050d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050da:	e8 51 ed ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050df:	8b 00                	mov    (%eax),%eax
801050e1:	39 d8                	cmp    %ebx,%eax
801050e3:	76 1b                	jbe    80105100 <fetchint+0x30>
801050e5:	8d 53 04             	lea    0x4(%ebx),%edx
801050e8:	39 d0                	cmp    %edx,%eax
801050ea:	72 14                	jb     80105100 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ef:	8b 13                	mov    (%ebx),%edx
801050f1:	89 10                	mov    %edx,(%eax)
  return 0;
801050f3:	31 c0                	xor    %eax,%eax
}
801050f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f8:	c9                   	leave  
801050f9:	c3                   	ret    
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105105:	eb ee                	jmp    801050f5 <fetchint+0x25>
80105107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510e:	66 90                	xchg   %ax,%ax

80105110 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 04             	sub    $0x4,%esp
80105117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010511a:	e8 11 ed ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz)
8010511f:	39 18                	cmp    %ebx,(%eax)
80105121:	76 2d                	jbe    80105150 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105123:	8b 55 0c             	mov    0xc(%ebp),%edx
80105126:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105128:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010512a:	39 d3                	cmp    %edx,%ebx
8010512c:	73 22                	jae    80105150 <fetchstr+0x40>
8010512e:	89 d8                	mov    %ebx,%eax
80105130:	eb 0d                	jmp    8010513f <fetchstr+0x2f>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105138:	83 c0 01             	add    $0x1,%eax
8010513b:	39 c2                	cmp    %eax,%edx
8010513d:	76 11                	jbe    80105150 <fetchstr+0x40>
    if(*s == 0)
8010513f:	80 38 00             	cmpb   $0x0,(%eax)
80105142:	75 f4                	jne    80105138 <fetchstr+0x28>
      return s - *pp;
80105144:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105149:	c9                   	leave  
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
80105150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105158:	c9                   	leave  
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105165:	e8 c6 ec ff ff       	call   80103e30 <myproc>
8010516a:	8b 55 08             	mov    0x8(%ebp),%edx
8010516d:	8b 40 18             	mov    0x18(%eax),%eax
80105170:	8b 40 44             	mov    0x44(%eax),%eax
80105173:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105176:	e8 b5 ec ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010517b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010517e:	8b 00                	mov    (%eax),%eax
80105180:	39 c6                	cmp    %eax,%esi
80105182:	73 1c                	jae    801051a0 <argint+0x40>
80105184:	8d 53 08             	lea    0x8(%ebx),%edx
80105187:	39 d0                	cmp    %edx,%eax
80105189:	72 15                	jb     801051a0 <argint+0x40>
  *ip = *(int*)(addr);
8010518b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518e:	8b 53 04             	mov    0x4(%ebx),%edx
80105191:	89 10                	mov    %edx,(%eax)
  return 0;
80105193:	31 c0                	xor    %eax,%eax
}
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5d                   	pop    %ebp
80105198:	c3                   	ret    
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051a5:	eb ee                	jmp    80105195 <argint+0x35>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801051b9:	e8 72 ec ff ff       	call   80103e30 <myproc>
801051be:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051c0:	e8 6b ec ff ff       	call   80103e30 <myproc>
801051c5:	8b 55 08             	mov    0x8(%ebp),%edx
801051c8:	8b 40 18             	mov    0x18(%eax),%eax
801051cb:	8b 40 44             	mov    0x44(%eax),%eax
801051ce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051d1:	e8 5a ec ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051d9:	8b 00                	mov    (%eax),%eax
801051db:	39 c7                	cmp    %eax,%edi
801051dd:	73 31                	jae    80105210 <argptr+0x60>
801051df:	8d 4b 08             	lea    0x8(%ebx),%ecx
801051e2:	39 c8                	cmp    %ecx,%eax
801051e4:	72 2a                	jb     80105210 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051e6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801051e9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051ec:	85 d2                	test   %edx,%edx
801051ee:	78 20                	js     80105210 <argptr+0x60>
801051f0:	8b 16                	mov    (%esi),%edx
801051f2:	39 c2                	cmp    %eax,%edx
801051f4:	76 1a                	jbe    80105210 <argptr+0x60>
801051f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801051f9:	01 c3                	add    %eax,%ebx
801051fb:	39 da                	cmp    %ebx,%edx
801051fd:	72 11                	jb     80105210 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801051ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105202:	89 02                	mov    %eax,(%edx)
  return 0;
80105204:	31 c0                	xor    %eax,%eax
}
80105206:	83 c4 0c             	add    $0xc,%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5f                   	pop    %edi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105215:	eb ef                	jmp    80105206 <argptr+0x56>
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax

80105220 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105225:	e8 06 ec ff ff       	call   80103e30 <myproc>
8010522a:	8b 55 08             	mov    0x8(%ebp),%edx
8010522d:	8b 40 18             	mov    0x18(%eax),%eax
80105230:	8b 40 44             	mov    0x44(%eax),%eax
80105233:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105236:	e8 f5 eb ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010523b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010523e:	8b 00                	mov    (%eax),%eax
80105240:	39 c6                	cmp    %eax,%esi
80105242:	73 44                	jae    80105288 <argstr+0x68>
80105244:	8d 53 08             	lea    0x8(%ebx),%edx
80105247:	39 d0                	cmp    %edx,%eax
80105249:	72 3d                	jb     80105288 <argstr+0x68>
  *ip = *(int*)(addr);
8010524b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010524e:	e8 dd eb ff ff       	call   80103e30 <myproc>
  if(addr >= curproc->sz)
80105253:	3b 18                	cmp    (%eax),%ebx
80105255:	73 31                	jae    80105288 <argstr+0x68>
  *pp = (char*)addr;
80105257:	8b 55 0c             	mov    0xc(%ebp),%edx
8010525a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010525c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010525e:	39 d3                	cmp    %edx,%ebx
80105260:	73 26                	jae    80105288 <argstr+0x68>
80105262:	89 d8                	mov    %ebx,%eax
80105264:	eb 11                	jmp    80105277 <argstr+0x57>
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	83 c0 01             	add    $0x1,%eax
80105273:	39 c2                	cmp    %eax,%edx
80105275:	76 11                	jbe    80105288 <argstr+0x68>
    if(*s == 0)
80105277:	80 38 00             	cmpb   $0x0,(%eax)
8010527a:	75 f4                	jne    80105270 <argstr+0x50>
      return s - *pp;
8010527c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010527e:	5b                   	pop    %ebx
8010527f:	5e                   	pop    %esi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105288:	5b                   	pop    %ebx
    return -1;
80105289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010528e:	5e                   	pop    %esi
8010528f:	5d                   	pop    %ebp
80105290:	c3                   	ret    
80105291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop

801052a0 <syscall>:
[SYS_print_all_procs_status]  sys_print_all_procs_status,
};

void 
syscall(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801052a5:	e8 86 eb ff ff       	call   80103e30 <myproc>
801052aa:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052ac:	8b 40 18             	mov    0x18(%eax),%eax
801052af:	8b 40 1c             	mov    0x1c(%eax),%eax
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
801052b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b5:	83 fa 18             	cmp    $0x18,%edx
801052b8:	77 2e                	ja     801052e8 <syscall+0x48>
801052ba:	8b 34 85 a0 82 10 80 	mov    -0x7fef7d60(,%eax,4),%esi
801052c1:	85 f6                	test   %esi,%esi
801052c3:	74 23                	je     801052e8 <syscall+0x48>
  {
    push_callerp(curproc->pid, num);
801052c5:	83 ec 08             	sub    $0x8,%esp
801052c8:	50                   	push   %eax
801052c9:	ff 73 10             	push   0x10(%ebx)
801052cc:	e8 8f f4 ff ff       	call   80104760 <push_callerp>
    curproc->tf->eax = syscalls[num]();
801052d1:	ff d6                	call   *%esi
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	89 c2                	mov    %eax,%edx
801052d8:	8b 43 18             	mov    0x18(%ebx),%eax
801052db:	89 50 1c             	mov    %edx,0x1c(%eax)
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
801052de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e1:	5b                   	pop    %ebx
801052e2:	5e                   	pop    %esi
801052e3:	5d                   	pop    %ebp
801052e4:	c3                   	ret    
801052e5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801052e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052ec:	50                   	push   %eax
801052ed:	ff 73 10             	push   0x10(%ebx)
801052f0:	68 7d 82 10 80       	push   $0x8010827d
801052f5:	e8 a6 b3 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801052fa:	8b 43 18             	mov    0x18(%ebx),%eax
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80105307:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010530a:	5b                   	pop    %ebx
8010530b:	5e                   	pop    %esi
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    
8010530e:	66 90                	xchg   %ax,%ax

80105310 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105315:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105318:	53                   	push   %ebx
80105319:	83 ec 34             	sub    $0x34,%esp
8010531c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010531f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105322:	57                   	push   %edi
80105323:	50                   	push   %eax
{
80105324:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105327:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010532a:	e8 51 d2 ff ff       	call   80102580 <nameiparent>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	0f 84 46 01 00 00    	je     80105480 <create+0x170>
    return 0;
  ilock(dp);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	50                   	push   %eax
80105340:	e8 fb c8 ff ff       	call   80101c40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105345:	83 c4 0c             	add    $0xc,%esp
80105348:	6a 00                	push   $0x0
8010534a:	57                   	push   %edi
8010534b:	53                   	push   %ebx
8010534c:	e8 4f ce ff ff       	call   801021a0 <dirlookup>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	89 c6                	mov    %eax,%esi
80105356:	85 c0                	test   %eax,%eax
80105358:	74 56                	je     801053b0 <create+0xa0>
    iunlockput(dp);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	53                   	push   %ebx
8010535e:	e8 6d cb ff ff       	call   80101ed0 <iunlockput>
    ilock(ip);
80105363:	89 34 24             	mov    %esi,(%esp)
80105366:	e8 d5 c8 ff ff       	call   80101c40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010536b:	83 c4 10             	add    $0x10,%esp
8010536e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105373:	75 1b                	jne    80105390 <create+0x80>
80105375:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010537a:	75 14                	jne    80105390 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010537c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537f:	89 f0                	mov    %esi,%eax
80105381:	5b                   	pop    %ebx
80105382:	5e                   	pop    %esi
80105383:	5f                   	pop    %edi
80105384:	5d                   	pop    %ebp
80105385:	c3                   	ret    
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	56                   	push   %esi
    return 0;
80105394:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105396:	e8 35 cb ff ff       	call   80101ed0 <iunlockput>
    return 0;
8010539b:	83 c4 10             	add    $0x10,%esp
}
8010539e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a1:	89 f0                	mov    %esi,%eax
801053a3:	5b                   	pop    %ebx
801053a4:	5e                   	pop    %esi
801053a5:	5f                   	pop    %edi
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    
801053a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053b4:	83 ec 08             	sub    $0x8,%esp
801053b7:	50                   	push   %eax
801053b8:	ff 33                	push   (%ebx)
801053ba:	e8 11 c7 ff ff       	call   80101ad0 <ialloc>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	89 c6                	mov    %eax,%esi
801053c4:	85 c0                	test   %eax,%eax
801053c6:	0f 84 cd 00 00 00    	je     80105499 <create+0x189>
  ilock(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	50                   	push   %eax
801053d0:	e8 6b c8 ff ff       	call   80101c40 <ilock>
  ip->major = major;
801053d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053d9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053e1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053e5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053ee:	89 34 24             	mov    %esi,(%esp)
801053f1:	e8 9a c7 ff ff       	call   80101b90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053fe:	74 30                	je     80105430 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105400:	83 ec 04             	sub    $0x4,%esp
80105403:	ff 76 04             	push   0x4(%esi)
80105406:	57                   	push   %edi
80105407:	53                   	push   %ebx
80105408:	e8 93 d0 ff ff       	call   801024a0 <dirlink>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 78                	js     8010548c <create+0x17c>
  iunlockput(dp);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	53                   	push   %ebx
80105418:	e8 b3 ca ff ff       	call   80101ed0 <iunlockput>
  return ip;
8010541d:	83 c4 10             	add    $0x10,%esp
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105423:	89 f0                	mov    %esi,%eax
80105425:	5b                   	pop    %ebx
80105426:	5e                   	pop    %esi
80105427:	5f                   	pop    %edi
80105428:	5d                   	pop    %ebp
80105429:	c3                   	ret    
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105433:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105438:	53                   	push   %ebx
80105439:	e8 52 c7 ff ff       	call   80101b90 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010543e:	83 c4 0c             	add    $0xc,%esp
80105441:	ff 76 04             	push   0x4(%esi)
80105444:	68 24 83 10 80       	push   $0x80108324
80105449:	56                   	push   %esi
8010544a:	e8 51 d0 ff ff       	call   801024a0 <dirlink>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	78 18                	js     8010546e <create+0x15e>
80105456:	83 ec 04             	sub    $0x4,%esp
80105459:	ff 73 04             	push   0x4(%ebx)
8010545c:	68 23 83 10 80       	push   $0x80108323
80105461:	56                   	push   %esi
80105462:	e8 39 d0 ff ff       	call   801024a0 <dirlink>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	85 c0                	test   %eax,%eax
8010546c:	79 92                	jns    80105400 <create+0xf0>
      panic("create dots");
8010546e:	83 ec 0c             	sub    $0xc,%esp
80105471:	68 17 83 10 80       	push   $0x80108317
80105476:	e8 05 af ff ff       	call   80100380 <panic>
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105483:	31 f6                	xor    %esi,%esi
}
80105485:	5b                   	pop    %ebx
80105486:	89 f0                	mov    %esi,%eax
80105488:	5e                   	pop    %esi
80105489:	5f                   	pop    %edi
8010548a:	5d                   	pop    %ebp
8010548b:	c3                   	ret    
    panic("create: dirlink");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 26 83 10 80       	push   $0x80108326
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	68 08 83 10 80       	push   $0x80108308
801054a1:	e8 da ae ff ff       	call   80100380 <panic>
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi

801054b0 <sys_dup>:
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054bb:	50                   	push   %eax
801054bc:	6a 00                	push   $0x0
801054be:	e8 9d fc ff ff       	call   80105160 <argint>
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 36                	js     80105500 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ce:	77 30                	ja     80105500 <sys_dup+0x50>
801054d0:	e8 5b e9 ff ff       	call   80103e30 <myproc>
801054d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801054dc:	85 f6                	test   %esi,%esi
801054de:	74 20                	je     80105500 <sys_dup+0x50>
  struct proc *curproc = myproc();
801054e0:	e8 4b e9 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054e5:	31 db                	xor    %ebx,%ebx
801054e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054f4:	85 d2                	test   %edx,%edx
801054f6:	74 18                	je     80105510 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	75 f0                	jne    801054f0 <sys_dup+0x40>
}
80105500:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105503:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105508:	89 d8                	mov    %ebx,%eax
8010550a:	5b                   	pop    %ebx
8010550b:	5e                   	pop    %esi
8010550c:	5d                   	pop    %ebp
8010550d:	c3                   	ret    
8010550e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105510:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105513:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105517:	56                   	push   %esi
80105518:	e8 43 be ff ff       	call   80101360 <filedup>
  return fd;
8010551d:	83 c4 10             	add    $0x10,%esp
}
80105520:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105523:	89 d8                	mov    %ebx,%eax
80105525:	5b                   	pop    %ebx
80105526:	5e                   	pop    %esi
80105527:	5d                   	pop    %ebp
80105528:	c3                   	ret    
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_read>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105535:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105538:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010553b:	53                   	push   %ebx
8010553c:	6a 00                	push   $0x0
8010553e:	e8 1d fc ff ff       	call   80105160 <argint>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	78 5e                	js     801055a8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010554a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010554e:	77 58                	ja     801055a8 <sys_read+0x78>
80105550:	e8 db e8 ff ff       	call   80103e30 <myproc>
80105555:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105558:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010555c:	85 f6                	test   %esi,%esi
8010555e:	74 48                	je     801055a8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105566:	50                   	push   %eax
80105567:	6a 02                	push   $0x2
80105569:	e8 f2 fb ff ff       	call   80105160 <argint>
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
80105573:	78 33                	js     801055a8 <sys_read+0x78>
80105575:	83 ec 04             	sub    $0x4,%esp
80105578:	ff 75 f0             	push   -0x10(%ebp)
8010557b:	53                   	push   %ebx
8010557c:	6a 01                	push   $0x1
8010557e:	e8 2d fc ff ff       	call   801051b0 <argptr>
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 1e                	js     801055a8 <sys_read+0x78>
  return fileread(f, p, n);
8010558a:	83 ec 04             	sub    $0x4,%esp
8010558d:	ff 75 f0             	push   -0x10(%ebp)
80105590:	ff 75 f4             	push   -0xc(%ebp)
80105593:	56                   	push   %esi
80105594:	e8 47 bf ff ff       	call   801014e0 <fileread>
80105599:	83 c4 10             	add    $0x10,%esp
}
8010559c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010559f:	5b                   	pop    %ebx
801055a0:	5e                   	pop    %esi
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret    
801055a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a7:	90                   	nop
    return -1;
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	eb ed                	jmp    8010559c <sys_read+0x6c>
801055af:	90                   	nop

801055b0 <sys_write>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055bb:	53                   	push   %ebx
801055bc:	6a 00                	push   $0x0
801055be:	e8 9d fb ff ff       	call   80105160 <argint>
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	78 5e                	js     80105628 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ce:	77 58                	ja     80105628 <sys_write+0x78>
801055d0:	e8 5b e8 ff ff       	call   80103e30 <myproc>
801055d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801055dc:	85 f6                	test   %esi,%esi
801055de:	74 48                	je     80105628 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 02                	push   $0x2
801055e9:	e8 72 fb ff ff       	call   80105160 <argint>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 33                	js     80105628 <sys_write+0x78>
801055f5:	83 ec 04             	sub    $0x4,%esp
801055f8:	ff 75 f0             	push   -0x10(%ebp)
801055fb:	53                   	push   %ebx
801055fc:	6a 01                	push   $0x1
801055fe:	e8 ad fb ff ff       	call   801051b0 <argptr>
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 1e                	js     80105628 <sys_write+0x78>
  return filewrite(f, p, n);
8010560a:	83 ec 04             	sub    $0x4,%esp
8010560d:	ff 75 f0             	push   -0x10(%ebp)
80105610:	ff 75 f4             	push   -0xc(%ebp)
80105613:	56                   	push   %esi
80105614:	e8 57 bf ff ff       	call   80101570 <filewrite>
80105619:	83 c4 10             	add    $0x10,%esp
}
8010561c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010561f:	5b                   	pop    %ebx
80105620:	5e                   	pop    %esi
80105621:	5d                   	pop    %ebp
80105622:	c3                   	ret    
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb ed                	jmp    8010561c <sys_write+0x6c>
8010562f:	90                   	nop

80105630 <sys_close>:
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105635:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105638:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010563b:	50                   	push   %eax
8010563c:	6a 00                	push   $0x0
8010563e:	e8 1d fb ff ff       	call   80105160 <argint>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 3e                	js     80105688 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010564a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010564e:	77 38                	ja     80105688 <sys_close+0x58>
80105650:	e8 db e7 ff ff       	call   80103e30 <myproc>
80105655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105658:	8d 5a 08             	lea    0x8(%edx),%ebx
8010565b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010565f:	85 f6                	test   %esi,%esi
80105661:	74 25                	je     80105688 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105663:	e8 c8 e7 ff ff       	call   80103e30 <myproc>
  fileclose(f);
80105668:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010566b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105672:	00 
  fileclose(f);
80105673:	56                   	push   %esi
80105674:	e8 37 bd ff ff       	call   801013b0 <fileclose>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105681:	5b                   	pop    %ebx
80105682:	5e                   	pop    %esi
80105683:	5d                   	pop    %ebp
80105684:	c3                   	ret    
80105685:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb ef                	jmp    8010567e <sys_close+0x4e>
8010568f:	90                   	nop

80105690 <sys_fstat>:
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105695:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105698:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010569b:	53                   	push   %ebx
8010569c:	6a 00                	push   $0x0
8010569e:	e8 bd fa ff ff       	call   80105160 <argint>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 46                	js     801056f0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056ae:	77 40                	ja     801056f0 <sys_fstat+0x60>
801056b0:	e8 7b e7 ff ff       	call   80103e30 <myproc>
801056b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801056bc:	85 f6                	test   %esi,%esi
801056be:	74 30                	je     801056f0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056c0:	83 ec 04             	sub    $0x4,%esp
801056c3:	6a 14                	push   $0x14
801056c5:	53                   	push   %ebx
801056c6:	6a 01                	push   $0x1
801056c8:	e8 e3 fa ff ff       	call   801051b0 <argptr>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 1c                	js     801056f0 <sys_fstat+0x60>
  return filestat(f, st);
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	ff 75 f4             	push   -0xc(%ebp)
801056da:	56                   	push   %esi
801056db:	e8 b0 bd ff ff       	call   80101490 <filestat>
801056e0:	83 c4 10             	add    $0x10,%esp
}
801056e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e6:	5b                   	pop    %ebx
801056e7:	5e                   	pop    %esi
801056e8:	5d                   	pop    %ebp
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f5:	eb ec                	jmp    801056e3 <sys_fstat+0x53>
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax

80105700 <sys_link>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105705:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 0c fb ff ff       	call   80105220 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 fb 00 00 00    	js     8010581a <sys_link+0x11a>
8010571f:	83 ec 08             	sub    $0x8,%esp
80105722:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105725:	50                   	push   %eax
80105726:	6a 01                	push   $0x1
80105728:	e8 f3 fa ff ff       	call   80105220 <argstr>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	0f 88 e2 00 00 00    	js     8010581a <sys_link+0x11a>
  begin_op();
80105738:	e8 e3 da ff ff       	call   80103220 <begin_op>
  if((ip = namei(old)) == 0){
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	ff 75 d4             	push   -0x2c(%ebp)
80105743:	e8 18 ce ff ff       	call   80102560 <namei>
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	89 c3                	mov    %eax,%ebx
8010574d:	85 c0                	test   %eax,%eax
8010574f:	0f 84 e4 00 00 00    	je     80105839 <sys_link+0x139>
  ilock(ip);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	50                   	push   %eax
80105759:	e8 e2 c4 ff ff       	call   80101c40 <ilock>
  if(ip->type == T_DIR){
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105766:	0f 84 b5 00 00 00    	je     80105821 <sys_link+0x121>
  iupdate(ip);
8010576c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010576f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105774:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105777:	53                   	push   %ebx
80105778:	e8 13 c4 ff ff       	call   80101b90 <iupdate>
  iunlock(ip);
8010577d:	89 1c 24             	mov    %ebx,(%esp)
80105780:	e8 9b c5 ff ff       	call   80101d20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105785:	58                   	pop    %eax
80105786:	5a                   	pop    %edx
80105787:	57                   	push   %edi
80105788:	ff 75 d0             	push   -0x30(%ebp)
8010578b:	e8 f0 cd ff ff       	call   80102580 <nameiparent>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	89 c6                	mov    %eax,%esi
80105795:	85 c0                	test   %eax,%eax
80105797:	74 5b                	je     801057f4 <sys_link+0xf4>
  ilock(dp);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 9e c4 ff ff       	call   80101c40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057a2:	8b 03                	mov    (%ebx),%eax
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	39 06                	cmp    %eax,(%esi)
801057a9:	75 3d                	jne    801057e8 <sys_link+0xe8>
801057ab:	83 ec 04             	sub    $0x4,%esp
801057ae:	ff 73 04             	push   0x4(%ebx)
801057b1:	57                   	push   %edi
801057b2:	56                   	push   %esi
801057b3:	e8 e8 cc ff ff       	call   801024a0 <dirlink>
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	85 c0                	test   %eax,%eax
801057bd:	78 29                	js     801057e8 <sys_link+0xe8>
  iunlockput(dp);
801057bf:	83 ec 0c             	sub    $0xc,%esp
801057c2:	56                   	push   %esi
801057c3:	e8 08 c7 ff ff       	call   80101ed0 <iunlockput>
  iput(ip);
801057c8:	89 1c 24             	mov    %ebx,(%esp)
801057cb:	e8 a0 c5 ff ff       	call   80101d70 <iput>
  end_op();
801057d0:	e8 bb da ff ff       	call   80103290 <end_op>
  return 0;
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	31 c0                	xor    %eax,%eax
}
801057da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057dd:	5b                   	pop    %ebx
801057de:	5e                   	pop    %esi
801057df:	5f                   	pop    %edi
801057e0:	5d                   	pop    %ebp
801057e1:	c3                   	ret    
801057e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	56                   	push   %esi
801057ec:	e8 df c6 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
801057f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	53                   	push   %ebx
801057f8:	e8 43 c4 ff ff       	call   80101c40 <ilock>
  ip->nlink--;
801057fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105802:	89 1c 24             	mov    %ebx,(%esp)
80105805:	e8 86 c3 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
8010580a:	89 1c 24             	mov    %ebx,(%esp)
8010580d:	e8 be c6 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105812:	e8 79 da ff ff       	call   80103290 <end_op>
  return -1;
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581f:	eb b9                	jmp    801057da <sys_link+0xda>
    iunlockput(ip);
80105821:	83 ec 0c             	sub    $0xc,%esp
80105824:	53                   	push   %ebx
80105825:	e8 a6 c6 ff ff       	call   80101ed0 <iunlockput>
    end_op();
8010582a:	e8 61 da ff ff       	call   80103290 <end_op>
    return -1;
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105837:	eb a1                	jmp    801057da <sys_link+0xda>
    end_op();
80105839:	e8 52 da ff ff       	call   80103290 <end_op>
    return -1;
8010583e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105843:	eb 95                	jmp    801057da <sys_link+0xda>
80105845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_unlink>:
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105855:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105858:	53                   	push   %ebx
80105859:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010585c:	50                   	push   %eax
8010585d:	6a 00                	push   $0x0
8010585f:	e8 bc f9 ff ff       	call   80105220 <argstr>
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	85 c0                	test   %eax,%eax
80105869:	0f 88 7a 01 00 00    	js     801059e9 <sys_unlink+0x199>
  begin_op();
8010586f:	e8 ac d9 ff ff       	call   80103220 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105874:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	53                   	push   %ebx
8010587b:	ff 75 c0             	push   -0x40(%ebp)
8010587e:	e8 fd cc ff ff       	call   80102580 <nameiparent>
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105889:	85 c0                	test   %eax,%eax
8010588b:	0f 84 62 01 00 00    	je     801059f3 <sys_unlink+0x1a3>
  ilock(dp);
80105891:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105894:	83 ec 0c             	sub    $0xc,%esp
80105897:	57                   	push   %edi
80105898:	e8 a3 c3 ff ff       	call   80101c40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010589d:	58                   	pop    %eax
8010589e:	5a                   	pop    %edx
8010589f:	68 24 83 10 80       	push   $0x80108324
801058a4:	53                   	push   %ebx
801058a5:	e8 d6 c8 ff ff       	call   80102180 <namecmp>
801058aa:	83 c4 10             	add    $0x10,%esp
801058ad:	85 c0                	test   %eax,%eax
801058af:	0f 84 fb 00 00 00    	je     801059b0 <sys_unlink+0x160>
801058b5:	83 ec 08             	sub    $0x8,%esp
801058b8:	68 23 83 10 80       	push   $0x80108323
801058bd:	53                   	push   %ebx
801058be:	e8 bd c8 ff ff       	call   80102180 <namecmp>
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	0f 84 e2 00 00 00    	je     801059b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058ce:	83 ec 04             	sub    $0x4,%esp
801058d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058d4:	50                   	push   %eax
801058d5:	53                   	push   %ebx
801058d6:	57                   	push   %edi
801058d7:	e8 c4 c8 ff ff       	call   801021a0 <dirlookup>
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	89 c3                	mov    %eax,%ebx
801058e1:	85 c0                	test   %eax,%eax
801058e3:	0f 84 c7 00 00 00    	je     801059b0 <sys_unlink+0x160>
  ilock(ip);
801058e9:	83 ec 0c             	sub    $0xc,%esp
801058ec:	50                   	push   %eax
801058ed:	e8 4e c3 ff ff       	call   80101c40 <ilock>
  if(ip->nlink < 1)
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058fa:	0f 8e 1c 01 00 00    	jle    80105a1c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105900:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105905:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105908:	74 66                	je     80105970 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010590a:	83 ec 04             	sub    $0x4,%esp
8010590d:	6a 10                	push   $0x10
8010590f:	6a 00                	push   $0x0
80105911:	57                   	push   %edi
80105912:	e8 89 f5 ff ff       	call   80104ea0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105917:	6a 10                	push   $0x10
80105919:	ff 75 c4             	push   -0x3c(%ebp)
8010591c:	57                   	push   %edi
8010591d:	ff 75 b4             	push   -0x4c(%ebp)
80105920:	e8 2b c7 ff ff       	call   80102050 <writei>
80105925:	83 c4 20             	add    $0x20,%esp
80105928:	83 f8 10             	cmp    $0x10,%eax
8010592b:	0f 85 de 00 00 00    	jne    80105a0f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105931:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105936:	0f 84 94 00 00 00    	je     801059d0 <sys_unlink+0x180>
  iunlockput(dp);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	ff 75 b4             	push   -0x4c(%ebp)
80105942:	e8 89 c5 ff ff       	call   80101ed0 <iunlockput>
  ip->nlink--;
80105947:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010594c:	89 1c 24             	mov    %ebx,(%esp)
8010594f:	e8 3c c2 ff ff       	call   80101b90 <iupdate>
  iunlockput(ip);
80105954:	89 1c 24             	mov    %ebx,(%esp)
80105957:	e8 74 c5 ff ff       	call   80101ed0 <iunlockput>
  end_op();
8010595c:	e8 2f d9 ff ff       	call   80103290 <end_op>
  return 0;
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	31 c0                	xor    %eax,%eax
}
80105966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105969:	5b                   	pop    %ebx
8010596a:	5e                   	pop    %esi
8010596b:	5f                   	pop    %edi
8010596c:	5d                   	pop    %ebp
8010596d:	c3                   	ret    
8010596e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105970:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105974:	76 94                	jbe    8010590a <sys_unlink+0xba>
80105976:	be 20 00 00 00       	mov    $0x20,%esi
8010597b:	eb 0b                	jmp    80105988 <sys_unlink+0x138>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
80105980:	83 c6 10             	add    $0x10,%esi
80105983:	3b 73 58             	cmp    0x58(%ebx),%esi
80105986:	73 82                	jae    8010590a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105988:	6a 10                	push   $0x10
8010598a:	56                   	push   %esi
8010598b:	57                   	push   %edi
8010598c:	53                   	push   %ebx
8010598d:	e8 be c5 ff ff       	call   80101f50 <readi>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	83 f8 10             	cmp    $0x10,%eax
80105998:	75 68                	jne    80105a02 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010599a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010599f:	74 df                	je     80105980 <sys_unlink+0x130>
    iunlockput(ip);
801059a1:	83 ec 0c             	sub    $0xc,%esp
801059a4:	53                   	push   %ebx
801059a5:	e8 26 c5 ff ff       	call   80101ed0 <iunlockput>
    goto bad;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	ff 75 b4             	push   -0x4c(%ebp)
801059b6:	e8 15 c5 ff ff       	call   80101ed0 <iunlockput>
  end_op();
801059bb:	e8 d0 d8 ff ff       	call   80103290 <end_op>
  return -1;
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c8:	eb 9c                	jmp    80105966 <sys_unlink+0x116>
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801059d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801059d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801059db:	50                   	push   %eax
801059dc:	e8 af c1 ff ff       	call   80101b90 <iupdate>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	e9 53 ff ff ff       	jmp    8010593c <sys_unlink+0xec>
    return -1;
801059e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ee:	e9 73 ff ff ff       	jmp    80105966 <sys_unlink+0x116>
    end_op();
801059f3:	e8 98 d8 ff ff       	call   80103290 <end_op>
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fd:	e9 64 ff ff ff       	jmp    80105966 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105a02:	83 ec 0c             	sub    $0xc,%esp
80105a05:	68 48 83 10 80       	push   $0x80108348
80105a0a:	e8 71 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	68 5a 83 10 80       	push   $0x8010835a
80105a17:	e8 64 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	68 36 83 10 80       	push   $0x80108336
80105a24:	e8 57 a9 ff ff       	call   80100380 <panic>
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_open>:

int
sys_open(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a35:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a38:	53                   	push   %ebx
80105a39:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a3c:	50                   	push   %eax
80105a3d:	6a 00                	push   $0x0
80105a3f:	e8 dc f7 ff ff       	call   80105220 <argstr>
80105a44:	83 c4 10             	add    $0x10,%esp
80105a47:	85 c0                	test   %eax,%eax
80105a49:	0f 88 8e 00 00 00    	js     80105add <sys_open+0xad>
80105a4f:	83 ec 08             	sub    $0x8,%esp
80105a52:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a55:	50                   	push   %eax
80105a56:	6a 01                	push   $0x1
80105a58:	e8 03 f7 ff ff       	call   80105160 <argint>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	85 c0                	test   %eax,%eax
80105a62:	78 79                	js     80105add <sys_open+0xad>
    return -1;

  begin_op();
80105a64:	e8 b7 d7 ff ff       	call   80103220 <begin_op>

  if(omode & O_CREATE){
80105a69:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a6d:	75 79                	jne    80105ae8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	ff 75 e0             	push   -0x20(%ebp)
80105a75:	e8 e6 ca ff ff       	call   80102560 <namei>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	89 c6                	mov    %eax,%esi
80105a7f:	85 c0                	test   %eax,%eax
80105a81:	0f 84 7e 00 00 00    	je     80105b05 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a87:	83 ec 0c             	sub    $0xc,%esp
80105a8a:	50                   	push   %eax
80105a8b:	e8 b0 c1 ff ff       	call   80101c40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a90:	83 c4 10             	add    $0x10,%esp
80105a93:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a98:	0f 84 c2 00 00 00    	je     80105b60 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a9e:	e8 4d b8 ff ff       	call   801012f0 <filealloc>
80105aa3:	89 c7                	mov    %eax,%edi
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 23                	je     80105acc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105aa9:	e8 82 e3 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ab0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ab4:	85 d2                	test   %edx,%edx
80105ab6:	74 60                	je     80105b18 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ab8:	83 c3 01             	add    $0x1,%ebx
80105abb:	83 fb 10             	cmp    $0x10,%ebx
80105abe:	75 f0                	jne    80105ab0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	57                   	push   %edi
80105ac4:	e8 e7 b8 ff ff       	call   801013b0 <fileclose>
80105ac9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105acc:	83 ec 0c             	sub    $0xc,%esp
80105acf:	56                   	push   %esi
80105ad0:	e8 fb c3 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105ad5:	e8 b6 d7 ff ff       	call   80103290 <end_op>
    return -1;
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ae2:	eb 6d                	jmp    80105b51 <sys_open+0x121>
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aee:	31 c9                	xor    %ecx,%ecx
80105af0:	ba 02 00 00 00       	mov    $0x2,%edx
80105af5:	6a 00                	push   $0x0
80105af7:	e8 14 f8 ff ff       	call   80105310 <create>
    if(ip == 0){
80105afc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105aff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b01:	85 c0                	test   %eax,%eax
80105b03:	75 99                	jne    80105a9e <sys_open+0x6e>
      end_op();
80105b05:	e8 86 d7 ff ff       	call   80103290 <end_op>
      return -1;
80105b0a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b0f:	eb 40                	jmp    80105b51 <sys_open+0x121>
80105b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b18:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b1b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b1f:	56                   	push   %esi
80105b20:	e8 fb c1 ff ff       	call   80101d20 <iunlock>
  end_op();
80105b25:	e8 66 d7 ff ff       	call   80103290 <end_op>

  f->type = FD_INODE;
80105b2a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b33:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b36:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b39:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b3b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b42:	f7 d0                	not    %eax
80105b44:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b47:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b4a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b4d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b54:	89 d8                	mov    %ebx,%eax
80105b56:	5b                   	pop    %ebx
80105b57:	5e                   	pop    %esi
80105b58:	5f                   	pop    %edi
80105b59:	5d                   	pop    %ebp
80105b5a:	c3                   	ret    
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b63:	85 c9                	test   %ecx,%ecx
80105b65:	0f 84 33 ff ff ff    	je     80105a9e <sys_open+0x6e>
80105b6b:	e9 5c ff ff ff       	jmp    80105acc <sys_open+0x9c>

80105b70 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b76:	e8 a5 d6 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b7b:	83 ec 08             	sub    $0x8,%esp
80105b7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b81:	50                   	push   %eax
80105b82:	6a 00                	push   $0x0
80105b84:	e8 97 f6 ff ff       	call   80105220 <argstr>
80105b89:	83 c4 10             	add    $0x10,%esp
80105b8c:	85 c0                	test   %eax,%eax
80105b8e:	78 30                	js     80105bc0 <sys_mkdir+0x50>
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b96:	31 c9                	xor    %ecx,%ecx
80105b98:	ba 01 00 00 00       	mov    $0x1,%edx
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 6c f7 ff ff       	call   80105310 <create>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	74 15                	je     80105bc0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bab:	83 ec 0c             	sub    $0xc,%esp
80105bae:	50                   	push   %eax
80105baf:	e8 1c c3 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105bb4:	e8 d7 d6 ff ff       	call   80103290 <end_op>
  return 0;
80105bb9:	83 c4 10             	add    $0x10,%esp
80105bbc:	31 c0                	xor    %eax,%eax
}
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    
    end_op();
80105bc0:	e8 cb d6 ff ff       	call   80103290 <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bca:	c9                   	leave  
80105bcb:	c3                   	ret    
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_mknod>:

int
sys_mknod(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bd6:	e8 45 d6 ff ff       	call   80103220 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bdb:	83 ec 08             	sub    $0x8,%esp
80105bde:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be1:	50                   	push   %eax
80105be2:	6a 00                	push   $0x0
80105be4:	e8 37 f6 ff ff       	call   80105220 <argstr>
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	85 c0                	test   %eax,%eax
80105bee:	78 60                	js     80105c50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf6:	50                   	push   %eax
80105bf7:	6a 01                	push   $0x1
80105bf9:	e8 62 f5 ff ff       	call   80105160 <argint>
  if((argstr(0, &path)) < 0 ||
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	78 4b                	js     80105c50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c05:	83 ec 08             	sub    $0x8,%esp
80105c08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0b:	50                   	push   %eax
80105c0c:	6a 02                	push   $0x2
80105c0e:	e8 4d f5 ff ff       	call   80105160 <argint>
     argint(1, &major) < 0 ||
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	78 36                	js     80105c50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c1a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c25:	ba 03 00 00 00       	mov    $0x3,%edx
80105c2a:	50                   	push   %eax
80105c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c2e:	e8 dd f6 ff ff       	call   80105310 <create>
     argint(2, &minor) < 0 ||
80105c33:	83 c4 10             	add    $0x10,%esp
80105c36:	85 c0                	test   %eax,%eax
80105c38:	74 16                	je     80105c50 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c3a:	83 ec 0c             	sub    $0xc,%esp
80105c3d:	50                   	push   %eax
80105c3e:	e8 8d c2 ff ff       	call   80101ed0 <iunlockput>
  end_op();
80105c43:	e8 48 d6 ff ff       	call   80103290 <end_op>
  return 0;
80105c48:	83 c4 10             	add    $0x10,%esp
80105c4b:	31 c0                	xor    %eax,%eax
}
80105c4d:	c9                   	leave  
80105c4e:	c3                   	ret    
80105c4f:	90                   	nop
    end_op();
80105c50:	e8 3b d6 ff ff       	call   80103290 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_chdir>:

int
sys_chdir(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	56                   	push   %esi
80105c64:	53                   	push   %ebx
80105c65:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c68:	e8 c3 e1 ff ff       	call   80103e30 <myproc>
80105c6d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c6f:	e8 ac d5 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 9e f5 ff ff       	call   80105220 <argstr>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 77                	js     80105d00 <sys_chdir+0xa0>
80105c89:	83 ec 0c             	sub    $0xc,%esp
80105c8c:	ff 75 f4             	push   -0xc(%ebp)
80105c8f:	e8 cc c8 ff ff       	call   80102560 <namei>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	89 c3                	mov    %eax,%ebx
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 63                	je     80105d00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c9d:	83 ec 0c             	sub    $0xc,%esp
80105ca0:	50                   	push   %eax
80105ca1:	e8 9a bf ff ff       	call   80101c40 <ilock>
  if(ip->type != T_DIR){
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cae:	75 30                	jne    80105ce0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	53                   	push   %ebx
80105cb4:	e8 67 c0 ff ff       	call   80101d20 <iunlock>
  iput(curproc->cwd);
80105cb9:	58                   	pop    %eax
80105cba:	ff 76 68             	push   0x68(%esi)
80105cbd:	e8 ae c0 ff ff       	call   80101d70 <iput>
  end_op();
80105cc2:	e8 c9 d5 ff ff       	call   80103290 <end_op>
  curproc->cwd = ip;
80105cc7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	31 c0                	xor    %eax,%eax
}
80105ccf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cd2:	5b                   	pop    %ebx
80105cd3:	5e                   	pop    %esi
80105cd4:	5d                   	pop    %ebp
80105cd5:	c3                   	ret    
80105cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	53                   	push   %ebx
80105ce4:	e8 e7 c1 ff ff       	call   80101ed0 <iunlockput>
    end_op();
80105ce9:	e8 a2 d5 ff ff       	call   80103290 <end_op>
    return -1;
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf6:	eb d7                	jmp    80105ccf <sys_chdir+0x6f>
80105cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
    end_op();
80105d00:	e8 8b d5 ff ff       	call   80103290 <end_op>
    return -1;
80105d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0a:	eb c3                	jmp    80105ccf <sys_chdir+0x6f>
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d10 <sys_exec>:

int
sys_exec(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d15:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d1b:	53                   	push   %ebx
80105d1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d22:	50                   	push   %eax
80105d23:	6a 00                	push   $0x0
80105d25:	e8 f6 f4 ff ff       	call   80105220 <argstr>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	0f 88 87 00 00 00    	js     80105dbc <sys_exec+0xac>
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d3e:	50                   	push   %eax
80105d3f:	6a 01                	push   $0x1
80105d41:	e8 1a f4 ff ff       	call   80105160 <argint>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	78 6f                	js     80105dbc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d4d:	83 ec 04             	sub    $0x4,%esp
80105d50:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105d56:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d58:	68 80 00 00 00       	push   $0x80
80105d5d:	6a 00                	push   $0x0
80105d5f:	56                   	push   %esi
80105d60:	e8 3b f1 ff ff       	call   80104ea0 <memset>
80105d65:	83 c4 10             	add    $0x10,%esp
80105d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d79:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105d80:	50                   	push   %eax
80105d81:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d87:	01 f8                	add    %edi,%eax
80105d89:	50                   	push   %eax
80105d8a:	e8 41 f3 ff ff       	call   801050d0 <fetchint>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	85 c0                	test   %eax,%eax
80105d94:	78 26                	js     80105dbc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d96:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d9c:	85 c0                	test   %eax,%eax
80105d9e:	74 30                	je     80105dd0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105da0:	83 ec 08             	sub    $0x8,%esp
80105da3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105da6:	52                   	push   %edx
80105da7:	50                   	push   %eax
80105da8:	e8 63 f3 ff ff       	call   80105110 <fetchstr>
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	85 c0                	test   %eax,%eax
80105db2:	78 08                	js     80105dbc <sys_exec+0xac>
  for(i=0;; i++){
80105db4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105db7:	83 fb 20             	cmp    $0x20,%ebx
80105dba:	75 b4                	jne    80105d70 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc4:	5b                   	pop    %ebx
80105dc5:	5e                   	pop    %esi
80105dc6:	5f                   	pop    %edi
80105dc7:	5d                   	pop    %ebp
80105dc8:	c3                   	ret    
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105dd0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dd7:	00 00 00 00 
  return exec(path, argv);
80105ddb:	83 ec 08             	sub    $0x8,%esp
80105dde:	56                   	push   %esi
80105ddf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105de5:	e8 86 b1 ff ff       	call   80100f70 <exec>
80105dea:	83 c4 10             	add    $0x10,%esp
}
80105ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df0:	5b                   	pop    %ebx
80105df1:	5e                   	pop    %esi
80105df2:	5f                   	pop    %edi
80105df3:	5d                   	pop    %ebp
80105df4:	c3                   	ret    
80105df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_pipe>:

int
sys_pipe(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e05:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e08:	53                   	push   %ebx
80105e09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e0c:	6a 08                	push   $0x8
80105e0e:	50                   	push   %eax
80105e0f:	6a 00                	push   $0x0
80105e11:	e8 9a f3 ff ff       	call   801051b0 <argptr>
80105e16:	83 c4 10             	add    $0x10,%esp
80105e19:	85 c0                	test   %eax,%eax
80105e1b:	78 4a                	js     80105e67 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e1d:	83 ec 08             	sub    $0x8,%esp
80105e20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e23:	50                   	push   %eax
80105e24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e27:	50                   	push   %eax
80105e28:	e8 c3 da ff ff       	call   801038f0 <pipealloc>
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	85 c0                	test   %eax,%eax
80105e32:	78 33                	js     80105e67 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e34:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e37:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e39:	e8 f2 df ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105e40:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e44:	85 f6                	test   %esi,%esi
80105e46:	74 28                	je     80105e70 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105e48:	83 c3 01             	add    $0x1,%ebx
80105e4b:	83 fb 10             	cmp    $0x10,%ebx
80105e4e:	75 f0                	jne    80105e40 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	ff 75 e0             	push   -0x20(%ebp)
80105e56:	e8 55 b5 ff ff       	call   801013b0 <fileclose>
    fileclose(wf);
80105e5b:	58                   	pop    %eax
80105e5c:	ff 75 e4             	push   -0x1c(%ebp)
80105e5f:	e8 4c b5 ff ff       	call   801013b0 <fileclose>
    return -1;
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	eb 53                	jmp    80105ec1 <sys_pipe+0xc1>
80105e6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e70:	8d 73 08             	lea    0x8(%ebx),%esi
80105e73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e7a:	e8 b1 df ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e7f:	31 d2                	xor    %edx,%edx
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e8c:	85 c9                	test   %ecx,%ecx
80105e8e:	74 20                	je     80105eb0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e90:	83 c2 01             	add    $0x1,%edx
80105e93:	83 fa 10             	cmp    $0x10,%edx
80105e96:	75 f0                	jne    80105e88 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e98:	e8 93 df ff ff       	call   80103e30 <myproc>
80105e9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ea4:	00 
80105ea5:	eb a9                	jmp    80105e50 <sys_pipe+0x50>
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105eb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ebc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ebf:	31 c0                	xor    %eax,%eax
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	66 90                	xchg   %ax,%ax
80105ecb:	66 90                	xchg   %ax,%ax
80105ecd:	66 90                	xchg   %ax,%ax
80105ecf:	90                   	nop

80105ed0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ed0:	e9 fb e0 ff ff       	jmp    80103fd0 <fork>
80105ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_exit>:
}

int
sys_exit(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ee6:	e8 65 e3 ff ff       	call   80104250 <exit>
  return 0;  // not reached
}
80105eeb:	31 c0                	xor    %eax,%eax
80105eed:	c9                   	leave  
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ef0:	e9 8b e4 ff ff       	jmp    80104380 <wait>
80105ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_kill>:
}

int
sys_kill(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f09:	50                   	push   %eax
80105f0a:	6a 00                	push   $0x0
80105f0c:	e8 4f f2 ff ff       	call   80105160 <argint>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	78 18                	js     80105f30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f18:	83 ec 0c             	sub    $0xc,%esp
80105f1b:	ff 75 f4             	push   -0xc(%ebp)
80105f1e:	e8 fd e6 ff ff       	call   80104620 <kill>
80105f23:	83 c4 10             	add    $0x10,%esp
}
80105f26:	c9                   	leave  
80105f27:	c3                   	ret    
80105f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop
80105f30:	c9                   	leave  
    return -1;
80105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f36:	c3                   	ret    
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_getpid>:

int
sys_getpid(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f46:	e8 e5 de ff ff       	call   80103e30 <myproc>
80105f4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f4e:	c9                   	leave  
80105f4f:	c3                   	ret    

80105f50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f5a:	50                   	push   %eax
80105f5b:	6a 00                	push   $0x0
80105f5d:	e8 fe f1 ff ff       	call   80105160 <argint>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	85 c0                	test   %eax,%eax
80105f67:	78 27                	js     80105f90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f69:	e8 c2 de ff ff       	call   80103e30 <myproc>
  if(growproc(n) < 0)
80105f6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f73:	ff 75 f4             	push   -0xc(%ebp)
80105f76:	e8 d5 df ff ff       	call   80103f50 <growproc>
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	78 0e                	js     80105f90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f82:	89 d8                	mov    %ebx,%eax
80105f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f87:	c9                   	leave  
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f95:	eb eb                	jmp    80105f82 <sys_sbrk+0x32>
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_sleep>:

int
sys_sleep(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105faa:	50                   	push   %eax
80105fab:	6a 00                	push   $0x0
80105fad:	e8 ae f1 ff ff       	call   80105160 <argint>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	0f 88 8a 00 00 00    	js     80106047 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
80105fc0:	68 60 e5 12 80       	push   $0x8012e560
80105fc5:	e8 16 ee ff ff       	call   80104de0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105fcd:	8b 1d 40 e5 12 80    	mov    0x8012e540,%ebx
  while(ticks - ticks0 < n){
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 d2                	test   %edx,%edx
80105fd8:	75 27                	jne    80106001 <sys_sleep+0x61>
80105fda:	eb 54                	jmp    80106030 <sys_sleep+0x90>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fe0:	83 ec 08             	sub    $0x8,%esp
80105fe3:	68 60 e5 12 80       	push   $0x8012e560
80105fe8:	68 40 e5 12 80       	push   $0x8012e540
80105fed:	e8 0e e5 ff ff       	call   80104500 <sleep>
  while(ticks - ticks0 < n){
80105ff2:	a1 40 e5 12 80       	mov    0x8012e540,%eax
80105ff7:	83 c4 10             	add    $0x10,%esp
80105ffa:	29 d8                	sub    %ebx,%eax
80105ffc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fff:	73 2f                	jae    80106030 <sys_sleep+0x90>
    if(myproc()->killed){
80106001:	e8 2a de ff ff       	call   80103e30 <myproc>
80106006:	8b 40 24             	mov    0x24(%eax),%eax
80106009:	85 c0                	test   %eax,%eax
8010600b:	74 d3                	je     80105fe0 <sys_sleep+0x40>
      release(&tickslock);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	68 60 e5 12 80       	push   $0x8012e560
80106015:	e8 66 ed ff ff       	call   80104d80 <release>
  }
  release(&tickslock);
  return 0;
}
8010601a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010601d:	83 c4 10             	add    $0x10,%esp
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106025:	c9                   	leave  
80106026:	c3                   	ret    
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	68 60 e5 12 80       	push   $0x8012e560
80106038:	e8 43 ed ff ff       	call   80104d80 <release>
  return 0;
8010603d:	83 c4 10             	add    $0x10,%esp
80106040:	31 c0                	xor    %eax,%eax
}
80106042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106045:	c9                   	leave  
80106046:	c3                   	ret    
    return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604c:	eb f4                	jmp    80106042 <sys_sleep+0xa2>
8010604e:	66 90                	xchg   %ax,%ax

80106050 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	53                   	push   %ebx
80106054:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106057:	68 60 e5 12 80       	push   $0x8012e560
8010605c:	e8 7f ed ff ff       	call   80104de0 <acquire>
  xticks = ticks;
80106061:	8b 1d 40 e5 12 80    	mov    0x8012e540,%ebx
  release(&tickslock);
80106067:	c7 04 24 60 e5 12 80 	movl   $0x8012e560,(%esp)
8010606e:	e8 0d ed ff ff       	call   80104d80 <release>
  return xticks;
}
80106073:	89 d8                	mov    %ebx,%eax
80106075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106078:	c9                   	leave  
80106079:	c3                   	ret    
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106080 <sys_get_parent_pid>:

int
sys_get_parent_pid(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80106086:	e8 a5 dd ff ff       	call   80103e30 <myproc>
8010608b:	8b 40 14             	mov    0x14(%eax),%eax
8010608e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106091:	c9                   	leave  
80106092:	c3                   	ret    
80106093:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060a0 <sys_find_largest_prime_factor>:

int
sys_find_largest_prime_factor(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
801060a6:	83 ec 0c             	sub    $0xc,%esp
  int n = myproc()->tf->edx;
801060a9:	e8 82 dd ff ff       	call   80103e30 <myproc>
801060ae:	8b 40 18             	mov    0x18(%eax),%eax
801060b1:	8b 48 14             	mov    0x14(%eax),%ecx
  // cprintf("sys_find_largest_prime_factor called with n=%d\n", n);
  
  int maxPrime = -1;
  while (n % 2 == 0) {
801060b4:	f6 c1 01             	test   $0x1,%cl
801060b7:	0f 85 d2 00 00 00    	jne    8010618f <sys_find_largest_prime_factor+0xef>
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
      maxPrime = 2;
      n = n / 2;
801060c0:	89 c8                	mov    %ecx,%eax
801060c2:	c1 e8 1f             	shr    $0x1f,%eax
801060c5:	01 c8                	add    %ecx,%eax
801060c7:	89 c1                	mov    %eax,%ecx
801060c9:	d1 f9                	sar    %ecx
  while (n % 2 == 0) {
801060cb:	a8 02                	test   $0x2,%al
801060cd:	74 f1                	je     801060c0 <sys_find_largest_prime_factor+0x20>
      maxPrime = 2;
801060cf:	be 02 00 00 00       	mov    $0x2,%esi
  }
  while (n % 3 == 0) {
801060d4:	69 c1 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%eax
801060da:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
801060df:	3d 54 55 55 55       	cmp    $0x55555554,%eax
801060e4:	77 2e                	ja     80106114 <sys_find_largest_prime_factor+0x74>
      maxPrime = 3;
      n = n / 3;
801060e6:	bb 56 55 55 55       	mov    $0x55555556,%ebx
801060eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060ef:	90                   	nop
801060f0:	89 c8                	mov    %ecx,%eax
801060f2:	f7 eb                	imul   %ebx
801060f4:	89 c8                	mov    %ecx,%eax
801060f6:	c1 f8 1f             	sar    $0x1f,%eax
801060f9:	29 c2                	sub    %eax,%edx
801060fb:	69 c2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%eax
80106101:	89 d1                	mov    %edx,%ecx
80106103:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
  while (n % 3 == 0) {
80106108:	3d 54 55 55 55       	cmp    $0x55555554,%eax
8010610d:	76 e1                	jbe    801060f0 <sys_find_largest_prime_factor+0x50>
      maxPrime = 3;
8010610f:	be 03 00 00 00       	mov    $0x3,%esi
  }

  for (int i = 5; i <= n/2; i += 6) {
80106114:	bb 05 00 00 00       	mov    $0x5,%ebx
80106119:	83 f9 09             	cmp    $0x9,%ecx
8010611c:	7e 4b                	jle    80106169 <sys_find_largest_prime_factor+0xc9>
8010611e:	66 90                	xchg   %ax,%ax
      while (n % i == 0) {
80106120:	89 c8                	mov    %ecx,%eax
80106122:	89 f7                	mov    %esi,%edi
80106124:	99                   	cltd   
80106125:	f7 fb                	idiv   %ebx
80106127:	85 d2                	test   %edx,%edx
80106129:	75 15                	jne    80106140 <sys_find_largest_prime_factor+0xa0>
8010612b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010612f:	90                   	nop
          maxPrime = i;
          n = n / i;
80106130:	89 c8                	mov    %ecx,%eax
80106132:	99                   	cltd   
80106133:	f7 fb                	idiv   %ebx
      while (n % i == 0) {
80106135:	99                   	cltd   
          n = n / i;
80106136:	89 c1                	mov    %eax,%ecx
      while (n % i == 0) {
80106138:	f7 fb                	idiv   %ebx
8010613a:	85 d2                	test   %edx,%edx
8010613c:	74 f2                	je     80106130 <sys_find_largest_prime_factor+0x90>
8010613e:	89 df                	mov    %ebx,%edi
      }
      while (n % (i+2) == 0) {
80106140:	89 c8                	mov    %ecx,%eax
80106142:	8d 73 02             	lea    0x2(%ebx),%esi
80106145:	99                   	cltd   
80106146:	f7 fe                	idiv   %esi
80106148:	85 d2                	test   %edx,%edx
8010614a:	75 34                	jne    80106180 <sys_find_largest_prime_factor+0xe0>
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          maxPrime = i + 2;
          n = n / (i + 2);
80106150:	89 c8                	mov    %ecx,%eax
80106152:	99                   	cltd   
80106153:	f7 fe                	idiv   %esi
      while (n % (i+2) == 0) {
80106155:	99                   	cltd   
          n = n / (i + 2);
80106156:	89 c1                	mov    %eax,%ecx
      while (n % (i+2) == 0) {
80106158:	f7 fe                	idiv   %esi
8010615a:	85 d2                	test   %edx,%edx
8010615c:	74 f2                	je     80106150 <sys_find_largest_prime_factor+0xb0>
  for (int i = 5; i <= n/2; i += 6) {
8010615e:	89 c8                	mov    %ecx,%eax
80106160:	83 c3 06             	add    $0x6,%ebx
80106163:	d1 f8                	sar    %eax
80106165:	39 d8                	cmp    %ebx,%eax
80106167:	7d b7                	jge    80106120 <sys_find_largest_prime_factor+0x80>
      }
  }

  if (n > 4) {
80106169:	83 f9 05             	cmp    $0x5,%ecx
8010616c:	0f 4d f1             	cmovge %ecx,%esi
      maxPrime = n;
  }

  // cprintf("sys_find_largest_prime_factor returning %d\n", maxPrime);
  return maxPrime;
}
8010616f:	83 c4 0c             	add    $0xc,%esp
80106172:	5b                   	pop    %ebx
80106173:	89 f0                	mov    %esi,%eax
80106175:	5e                   	pop    %esi
80106176:	5f                   	pop    %edi
80106177:	5d                   	pop    %ebp
80106178:	c3                   	ret    
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = 5; i <= n/2; i += 6) {
80106180:	89 c8                	mov    %ecx,%eax
80106182:	83 c3 06             	add    $0x6,%ebx
      while (n % (i+2) == 0) {
80106185:	89 fe                	mov    %edi,%esi
  for (int i = 5; i <= n/2; i += 6) {
80106187:	d1 f8                	sar    %eax
80106189:	39 d8                	cmp    %ebx,%eax
8010618b:	7d 93                	jge    80106120 <sys_find_largest_prime_factor+0x80>
8010618d:	eb da                	jmp    80106169 <sys_find_largest_prime_factor+0xc9>
  int maxPrime = -1;
8010618f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80106194:	e9 3b ff ff ff       	jmp    801060d4 <sys_find_largest_prime_factor+0x34>
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <sys_get_callers>:

int 
sys_get_callers(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 20             	sub    $0x20,%esp
  int sys_call_number;
  if (argint(0, &sys_call_number) < 0)
801061a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061a9:	50                   	push   %eax
801061aa:	6a 00                	push   $0x0
801061ac:	e8 af ef ff ff       	call   80105160 <argint>
801061b1:	83 c4 10             	add    $0x10,%esp
801061b4:	85 c0                	test   %eax,%eax
801061b6:	78 18                	js     801061d0 <sys_get_callers+0x30>
    return -1;

  get_callers(sys_call_number);
801061b8:	83 ec 0c             	sub    $0xc,%esp
801061bb:	ff 75 f4             	push   -0xc(%ebp)
801061be:	e8 dd e5 ff ff       	call   801047a0 <get_callers>
  return 0;
801061c3:	83 c4 10             	add    $0x10,%esp
801061c6:	31 c0                	xor    %eax,%eax
}
801061c8:	c9                   	leave  
801061c9:	c3                   	ret    
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061d0:	c9                   	leave  
    return -1;
801061d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061d6:	c3                   	ret    
801061d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061de:	66 90                	xchg   %ax,%ax

801061e0 <sys_print_all_procs_status>:

void
sys_print_all_procs_status(void)
{
  print_all_procs_status();
801061e0:	e9 7b e6 ff ff       	jmp    80104860 <print_all_procs_status>

801061e5 <alltraps>:
801061e5:	1e                   	push   %ds
801061e6:	06                   	push   %es
801061e7:	0f a0                	push   %fs
801061e9:	0f a8                	push   %gs
801061eb:	60                   	pusha  
801061ec:	66 b8 10 00          	mov    $0x10,%ax
801061f0:	8e d8                	mov    %eax,%ds
801061f2:	8e c0                	mov    %eax,%es
801061f4:	54                   	push   %esp
801061f5:	e8 c6 00 00 00       	call   801062c0 <trap>
801061fa:	83 c4 04             	add    $0x4,%esp

801061fd <trapret>:
801061fd:	61                   	popa   
801061fe:	0f a9                	pop    %gs
80106200:	0f a1                	pop    %fs
80106202:	07                   	pop    %es
80106203:	1f                   	pop    %ds
80106204:	83 c4 08             	add    $0x8,%esp
80106207:	cf                   	iret   
80106208:	66 90                	xchg   %ax,%ax
8010620a:	66 90                	xchg   %ax,%ax
8010620c:	66 90                	xchg   %ax,%ax
8010620e:	66 90                	xchg   %ax,%ax

80106210 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106210:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106211:	31 c0                	xor    %eax,%eax
{
80106213:	89 e5                	mov    %esp,%ebp
80106215:	83 ec 08             	sub    $0x8,%esp
80106218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106220:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106227:	c7 04 c5 a2 e5 12 80 	movl   $0x8e000008,-0x7fed1a5e(,%eax,8)
8010622e:	08 00 00 8e 
80106232:	66 89 14 c5 a0 e5 12 	mov    %dx,-0x7fed1a60(,%eax,8)
80106239:	80 
8010623a:	c1 ea 10             	shr    $0x10,%edx
8010623d:	66 89 14 c5 a6 e5 12 	mov    %dx,-0x7fed1a5a(,%eax,8)
80106244:	80 
  for(i = 0; i < 256; i++)
80106245:	83 c0 01             	add    $0x1,%eax
80106248:	3d 00 01 00 00       	cmp    $0x100,%eax
8010624d:	75 d1                	jne    80106220 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010624f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106252:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106257:	c7 05 a2 e7 12 80 08 	movl   $0xef000008,0x8012e7a2
8010625e:	00 00 ef 
  initlock(&tickslock, "time");
80106261:	68 69 83 10 80       	push   $0x80108369
80106266:	68 60 e5 12 80       	push   $0x8012e560
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010626b:	66 a3 a0 e7 12 80    	mov    %ax,0x8012e7a0
80106271:	c1 e8 10             	shr    $0x10,%eax
80106274:	66 a3 a6 e7 12 80    	mov    %ax,0x8012e7a6
  initlock(&tickslock, "time");
8010627a:	e8 91 e9 ff ff       	call   80104c10 <initlock>
}
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	c9                   	leave  
80106283:	c3                   	ret    
80106284:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010628f:	90                   	nop

80106290 <idtinit>:

void
idtinit(void)
{
80106290:	55                   	push   %ebp
  pd[0] = size-1;
80106291:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106296:	89 e5                	mov    %esp,%ebp
80106298:	83 ec 10             	sub    $0x10,%esp
8010629b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010629f:	b8 a0 e5 12 80       	mov    $0x8012e5a0,%eax
801062a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062a8:	c1 e8 10             	shr    $0x10,%eax
801062ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801062af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    
801062b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062be:	66 90                	xchg   %ax,%ax

801062c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
801062c6:	83 ec 1c             	sub    $0x1c,%esp
801062c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801062cc:	8b 43 30             	mov    0x30(%ebx),%eax
801062cf:	83 f8 40             	cmp    $0x40,%eax
801062d2:	0f 84 68 01 00 00    	je     80106440 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062d8:	83 e8 20             	sub    $0x20,%eax
801062db:	83 f8 1f             	cmp    $0x1f,%eax
801062de:	0f 87 8c 00 00 00    	ja     80106370 <trap+0xb0>
801062e4:	ff 24 85 10 84 10 80 	jmp    *-0x7fef7bf0(,%eax,4)
801062eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062ef:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801062f0:	e8 0b c4 ff ff       	call   80102700 <ideintr>
    lapiceoi();
801062f5:	e8 d6 ca ff ff       	call   80102dd0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062fa:	e8 31 db ff ff       	call   80103e30 <myproc>
801062ff:	85 c0                	test   %eax,%eax
80106301:	74 1d                	je     80106320 <trap+0x60>
80106303:	e8 28 db ff ff       	call   80103e30 <myproc>
80106308:	8b 50 24             	mov    0x24(%eax),%edx
8010630b:	85 d2                	test   %edx,%edx
8010630d:	74 11                	je     80106320 <trap+0x60>
8010630f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106313:	83 e0 03             	and    $0x3,%eax
80106316:	66 83 f8 03          	cmp    $0x3,%ax
8010631a:	0f 84 e8 01 00 00    	je     80106508 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106320:	e8 0b db ff ff       	call   80103e30 <myproc>
80106325:	85 c0                	test   %eax,%eax
80106327:	74 0f                	je     80106338 <trap+0x78>
80106329:	e8 02 db ff ff       	call   80103e30 <myproc>
8010632e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106332:	0f 84 b8 00 00 00    	je     801063f0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106338:	e8 f3 da ff ff       	call   80103e30 <myproc>
8010633d:	85 c0                	test   %eax,%eax
8010633f:	74 1d                	je     8010635e <trap+0x9e>
80106341:	e8 ea da ff ff       	call   80103e30 <myproc>
80106346:	8b 40 24             	mov    0x24(%eax),%eax
80106349:	85 c0                	test   %eax,%eax
8010634b:	74 11                	je     8010635e <trap+0x9e>
8010634d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106351:	83 e0 03             	and    $0x3,%eax
80106354:	66 83 f8 03          	cmp    $0x3,%ax
80106358:	0f 84 0f 01 00 00    	je     8010646d <trap+0x1ad>
    exit();
}
8010635e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106361:	5b                   	pop    %ebx
80106362:	5e                   	pop    %esi
80106363:	5f                   	pop    %edi
80106364:	5d                   	pop    %ebp
80106365:	c3                   	ret    
80106366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010636d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106370:	e8 bb da ff ff       	call   80103e30 <myproc>
80106375:	8b 7b 38             	mov    0x38(%ebx),%edi
80106378:	85 c0                	test   %eax,%eax
8010637a:	0f 84 a2 01 00 00    	je     80106522 <trap+0x262>
80106380:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106384:	0f 84 98 01 00 00    	je     80106522 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010638a:	0f 20 d1             	mov    %cr2,%ecx
8010638d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106390:	e8 7b da ff ff       	call   80103e10 <cpuid>
80106395:	8b 73 30             	mov    0x30(%ebx),%esi
80106398:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010639b:	8b 43 34             	mov    0x34(%ebx),%eax
8010639e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801063a1:	e8 8a da ff ff       	call   80103e30 <myproc>
801063a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063a9:	e8 82 da ff ff       	call   80103e30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063b4:	51                   	push   %ecx
801063b5:	57                   	push   %edi
801063b6:	52                   	push   %edx
801063b7:	ff 75 e4             	push   -0x1c(%ebp)
801063ba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063bb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063be:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063c1:	56                   	push   %esi
801063c2:	ff 70 10             	push   0x10(%eax)
801063c5:	68 cc 83 10 80       	push   $0x801083cc
801063ca:	e8 d1 a2 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801063cf:	83 c4 20             	add    $0x20,%esp
801063d2:	e8 59 da ff ff       	call   80103e30 <myproc>
801063d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063de:	e8 4d da ff ff       	call   80103e30 <myproc>
801063e3:	85 c0                	test   %eax,%eax
801063e5:	0f 85 18 ff ff ff    	jne    80106303 <trap+0x43>
801063eb:	e9 30 ff ff ff       	jmp    80106320 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801063f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063f4:	0f 85 3e ff ff ff    	jne    80106338 <trap+0x78>
    yield();
801063fa:	e8 b1 e0 ff ff       	call   801044b0 <yield>
801063ff:	e9 34 ff ff ff       	jmp    80106338 <trap+0x78>
80106404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106408:	8b 7b 38             	mov    0x38(%ebx),%edi
8010640b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010640f:	e8 fc d9 ff ff       	call   80103e10 <cpuid>
80106414:	57                   	push   %edi
80106415:	56                   	push   %esi
80106416:	50                   	push   %eax
80106417:	68 74 83 10 80       	push   $0x80108374
8010641c:	e8 7f a2 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106421:	e8 aa c9 ff ff       	call   80102dd0 <lapiceoi>
    break;
80106426:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106429:	e8 02 da ff ff       	call   80103e30 <myproc>
8010642e:	85 c0                	test   %eax,%eax
80106430:	0f 85 cd fe ff ff    	jne    80106303 <trap+0x43>
80106436:	e9 e5 fe ff ff       	jmp    80106320 <trap+0x60>
8010643b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010643f:	90                   	nop
    if(myproc()->killed)
80106440:	e8 eb d9 ff ff       	call   80103e30 <myproc>
80106445:	8b 70 24             	mov    0x24(%eax),%esi
80106448:	85 f6                	test   %esi,%esi
8010644a:	0f 85 c8 00 00 00    	jne    80106518 <trap+0x258>
    myproc()->tf = tf;
80106450:	e8 db d9 ff ff       	call   80103e30 <myproc>
80106455:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106458:	e8 43 ee ff ff       	call   801052a0 <syscall>
    if(myproc()->killed)
8010645d:	e8 ce d9 ff ff       	call   80103e30 <myproc>
80106462:	8b 48 24             	mov    0x24(%eax),%ecx
80106465:	85 c9                	test   %ecx,%ecx
80106467:	0f 84 f1 fe ff ff    	je     8010635e <trap+0x9e>
}
8010646d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106470:	5b                   	pop    %ebx
80106471:	5e                   	pop    %esi
80106472:	5f                   	pop    %edi
80106473:	5d                   	pop    %ebp
      exit();
80106474:	e9 d7 dd ff ff       	jmp    80104250 <exit>
80106479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106480:	e8 3b 02 00 00       	call   801066c0 <uartintr>
    lapiceoi();
80106485:	e8 46 c9 ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010648a:	e8 a1 d9 ff ff       	call   80103e30 <myproc>
8010648f:	85 c0                	test   %eax,%eax
80106491:	0f 85 6c fe ff ff    	jne    80106303 <trap+0x43>
80106497:	e9 84 fe ff ff       	jmp    80106320 <trap+0x60>
8010649c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801064a0:	e8 eb c7 ff ff       	call   80102c90 <kbdintr>
    lapiceoi();
801064a5:	e8 26 c9 ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064aa:	e8 81 d9 ff ff       	call   80103e30 <myproc>
801064af:	85 c0                	test   %eax,%eax
801064b1:	0f 85 4c fe ff ff    	jne    80106303 <trap+0x43>
801064b7:	e9 64 fe ff ff       	jmp    80106320 <trap+0x60>
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801064c0:	e8 4b d9 ff ff       	call   80103e10 <cpuid>
801064c5:	85 c0                	test   %eax,%eax
801064c7:	0f 85 28 fe ff ff    	jne    801062f5 <trap+0x35>
      acquire(&tickslock);
801064cd:	83 ec 0c             	sub    $0xc,%esp
801064d0:	68 60 e5 12 80       	push   $0x8012e560
801064d5:	e8 06 e9 ff ff       	call   80104de0 <acquire>
      wakeup(&ticks);
801064da:	c7 04 24 40 e5 12 80 	movl   $0x8012e540,(%esp)
      ticks++;
801064e1:	83 05 40 e5 12 80 01 	addl   $0x1,0x8012e540
      wakeup(&ticks);
801064e8:	e8 d3 e0 ff ff       	call   801045c0 <wakeup>
      release(&tickslock);
801064ed:	c7 04 24 60 e5 12 80 	movl   $0x8012e560,(%esp)
801064f4:	e8 87 e8 ff ff       	call   80104d80 <release>
801064f9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801064fc:	e9 f4 fd ff ff       	jmp    801062f5 <trap+0x35>
80106501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106508:	e8 43 dd ff ff       	call   80104250 <exit>
8010650d:	e9 0e fe ff ff       	jmp    80106320 <trap+0x60>
80106512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106518:	e8 33 dd ff ff       	call   80104250 <exit>
8010651d:	e9 2e ff ff ff       	jmp    80106450 <trap+0x190>
80106522:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106525:	e8 e6 d8 ff ff       	call   80103e10 <cpuid>
8010652a:	83 ec 0c             	sub    $0xc,%esp
8010652d:	56                   	push   %esi
8010652e:	57                   	push   %edi
8010652f:	50                   	push   %eax
80106530:	ff 73 30             	push   0x30(%ebx)
80106533:	68 98 83 10 80       	push   $0x80108398
80106538:	e8 63 a1 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010653d:	83 c4 14             	add    $0x14,%esp
80106540:	68 6e 83 10 80       	push   $0x8010836e
80106545:	e8 36 9e ff ff       	call   80100380 <panic>
8010654a:	66 90                	xchg   %ax,%ax
8010654c:	66 90                	xchg   %ax,%ax
8010654e:	66 90                	xchg   %ax,%ax

80106550 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106550:	a1 a0 ed 12 80       	mov    0x8012eda0,%eax
80106555:	85 c0                	test   %eax,%eax
80106557:	74 17                	je     80106570 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106559:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010655e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010655f:	a8 01                	test   $0x1,%al
80106561:	74 0d                	je     80106570 <uartgetc+0x20>
80106563:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106568:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106569:	0f b6 c0             	movzbl %al,%eax
8010656c:	c3                   	ret    
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106575:	c3                   	ret    
80106576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657d:	8d 76 00             	lea    0x0(%esi),%esi

80106580 <uartinit>:
{
80106580:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106581:	31 c9                	xor    %ecx,%ecx
80106583:	89 c8                	mov    %ecx,%eax
80106585:	89 e5                	mov    %esp,%ebp
80106587:	57                   	push   %edi
80106588:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010658d:	56                   	push   %esi
8010658e:	89 fa                	mov    %edi,%edx
80106590:	53                   	push   %ebx
80106591:	83 ec 1c             	sub    $0x1c,%esp
80106594:	ee                   	out    %al,(%dx)
80106595:	be fb 03 00 00       	mov    $0x3fb,%esi
8010659a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010659f:	89 f2                	mov    %esi,%edx
801065a1:	ee                   	out    %al,(%dx)
801065a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ac:	ee                   	out    %al,(%dx)
801065ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801065b2:	89 c8                	mov    %ecx,%eax
801065b4:	89 da                	mov    %ebx,%edx
801065b6:	ee                   	out    %al,(%dx)
801065b7:	b8 03 00 00 00       	mov    $0x3,%eax
801065bc:	89 f2                	mov    %esi,%edx
801065be:	ee                   	out    %al,(%dx)
801065bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065c4:	89 c8                	mov    %ecx,%eax
801065c6:	ee                   	out    %al,(%dx)
801065c7:	b8 01 00 00 00       	mov    $0x1,%eax
801065cc:	89 da                	mov    %ebx,%edx
801065ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801065d5:	3c ff                	cmp    $0xff,%al
801065d7:	74 78                	je     80106651 <uartinit+0xd1>
  uart = 1;
801065d9:	c7 05 a0 ed 12 80 01 	movl   $0x1,0x8012eda0
801065e0:	00 00 00 
801065e3:	89 fa                	mov    %edi,%edx
801065e5:	ec                   	in     (%dx),%al
801065e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801065ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801065ef:	bf 90 84 10 80       	mov    $0x80108490,%edi
801065f4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801065f9:	6a 00                	push   $0x0
801065fb:	6a 04                	push   $0x4
801065fd:	e8 3e c3 ff ff       	call   80102940 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106602:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106606:	83 c4 10             	add    $0x10,%esp
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106610:	a1 a0 ed 12 80       	mov    0x8012eda0,%eax
80106615:	bb 80 00 00 00       	mov    $0x80,%ebx
8010661a:	85 c0                	test   %eax,%eax
8010661c:	75 14                	jne    80106632 <uartinit+0xb2>
8010661e:	eb 23                	jmp    80106643 <uartinit+0xc3>
    microdelay(10);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	6a 0a                	push   $0xa
80106625:	e8 c6 c7 ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	83 eb 01             	sub    $0x1,%ebx
80106630:	74 07                	je     80106639 <uartinit+0xb9>
80106632:	89 f2                	mov    %esi,%edx
80106634:	ec                   	in     (%dx),%al
80106635:	a8 20                	test   $0x20,%al
80106637:	74 e7                	je     80106620 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106639:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010663d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106642:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106643:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106647:	83 c7 01             	add    $0x1,%edi
8010664a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010664d:	84 c0                	test   %al,%al
8010664f:	75 bf                	jne    80106610 <uartinit+0x90>
}
80106651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106654:	5b                   	pop    %ebx
80106655:	5e                   	pop    %esi
80106656:	5f                   	pop    %edi
80106657:	5d                   	pop    %ebp
80106658:	c3                   	ret    
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106660 <uartputc>:
  if(!uart)
80106660:	a1 a0 ed 12 80       	mov    0x8012eda0,%eax
80106665:	85 c0                	test   %eax,%eax
80106667:	74 47                	je     801066b0 <uartputc+0x50>
{
80106669:	55                   	push   %ebp
8010666a:	89 e5                	mov    %esp,%ebp
8010666c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010666d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106672:	53                   	push   %ebx
80106673:	bb 80 00 00 00       	mov    $0x80,%ebx
80106678:	eb 18                	jmp    80106692 <uartputc+0x32>
8010667a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106680:	83 ec 0c             	sub    $0xc,%esp
80106683:	6a 0a                	push   $0xa
80106685:	e8 66 c7 ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010668a:	83 c4 10             	add    $0x10,%esp
8010668d:	83 eb 01             	sub    $0x1,%ebx
80106690:	74 07                	je     80106699 <uartputc+0x39>
80106692:	89 f2                	mov    %esi,%edx
80106694:	ec                   	in     (%dx),%al
80106695:	a8 20                	test   $0x20,%al
80106697:	74 e7                	je     80106680 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106699:	8b 45 08             	mov    0x8(%ebp),%eax
8010669c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066a1:	ee                   	out    %al,(%dx)
}
801066a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801066a5:	5b                   	pop    %ebx
801066a6:	5e                   	pop    %esi
801066a7:	5d                   	pop    %ebp
801066a8:	c3                   	ret    
801066a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066b0:	c3                   	ret    
801066b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066bf:	90                   	nop

801066c0 <uartintr>:

void
uartintr(void)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801066c6:	68 50 65 10 80       	push   $0x80106550
801066cb:	e8 20 a6 ff ff       	call   80100cf0 <consoleintr>
}
801066d0:	83 c4 10             	add    $0x10,%esp
801066d3:	c9                   	leave  
801066d4:	c3                   	ret    

801066d5 <vector0>:
801066d5:	6a 00                	push   $0x0
801066d7:	6a 00                	push   $0x0
801066d9:	e9 07 fb ff ff       	jmp    801061e5 <alltraps>

801066de <vector1>:
801066de:	6a 00                	push   $0x0
801066e0:	6a 01                	push   $0x1
801066e2:	e9 fe fa ff ff       	jmp    801061e5 <alltraps>

801066e7 <vector2>:
801066e7:	6a 00                	push   $0x0
801066e9:	6a 02                	push   $0x2
801066eb:	e9 f5 fa ff ff       	jmp    801061e5 <alltraps>

801066f0 <vector3>:
801066f0:	6a 00                	push   $0x0
801066f2:	6a 03                	push   $0x3
801066f4:	e9 ec fa ff ff       	jmp    801061e5 <alltraps>

801066f9 <vector4>:
801066f9:	6a 00                	push   $0x0
801066fb:	6a 04                	push   $0x4
801066fd:	e9 e3 fa ff ff       	jmp    801061e5 <alltraps>

80106702 <vector5>:
80106702:	6a 00                	push   $0x0
80106704:	6a 05                	push   $0x5
80106706:	e9 da fa ff ff       	jmp    801061e5 <alltraps>

8010670b <vector6>:
8010670b:	6a 00                	push   $0x0
8010670d:	6a 06                	push   $0x6
8010670f:	e9 d1 fa ff ff       	jmp    801061e5 <alltraps>

80106714 <vector7>:
80106714:	6a 00                	push   $0x0
80106716:	6a 07                	push   $0x7
80106718:	e9 c8 fa ff ff       	jmp    801061e5 <alltraps>

8010671d <vector8>:
8010671d:	6a 08                	push   $0x8
8010671f:	e9 c1 fa ff ff       	jmp    801061e5 <alltraps>

80106724 <vector9>:
80106724:	6a 00                	push   $0x0
80106726:	6a 09                	push   $0x9
80106728:	e9 b8 fa ff ff       	jmp    801061e5 <alltraps>

8010672d <vector10>:
8010672d:	6a 0a                	push   $0xa
8010672f:	e9 b1 fa ff ff       	jmp    801061e5 <alltraps>

80106734 <vector11>:
80106734:	6a 0b                	push   $0xb
80106736:	e9 aa fa ff ff       	jmp    801061e5 <alltraps>

8010673b <vector12>:
8010673b:	6a 0c                	push   $0xc
8010673d:	e9 a3 fa ff ff       	jmp    801061e5 <alltraps>

80106742 <vector13>:
80106742:	6a 0d                	push   $0xd
80106744:	e9 9c fa ff ff       	jmp    801061e5 <alltraps>

80106749 <vector14>:
80106749:	6a 0e                	push   $0xe
8010674b:	e9 95 fa ff ff       	jmp    801061e5 <alltraps>

80106750 <vector15>:
80106750:	6a 00                	push   $0x0
80106752:	6a 0f                	push   $0xf
80106754:	e9 8c fa ff ff       	jmp    801061e5 <alltraps>

80106759 <vector16>:
80106759:	6a 00                	push   $0x0
8010675b:	6a 10                	push   $0x10
8010675d:	e9 83 fa ff ff       	jmp    801061e5 <alltraps>

80106762 <vector17>:
80106762:	6a 11                	push   $0x11
80106764:	e9 7c fa ff ff       	jmp    801061e5 <alltraps>

80106769 <vector18>:
80106769:	6a 00                	push   $0x0
8010676b:	6a 12                	push   $0x12
8010676d:	e9 73 fa ff ff       	jmp    801061e5 <alltraps>

80106772 <vector19>:
80106772:	6a 00                	push   $0x0
80106774:	6a 13                	push   $0x13
80106776:	e9 6a fa ff ff       	jmp    801061e5 <alltraps>

8010677b <vector20>:
8010677b:	6a 00                	push   $0x0
8010677d:	6a 14                	push   $0x14
8010677f:	e9 61 fa ff ff       	jmp    801061e5 <alltraps>

80106784 <vector21>:
80106784:	6a 00                	push   $0x0
80106786:	6a 15                	push   $0x15
80106788:	e9 58 fa ff ff       	jmp    801061e5 <alltraps>

8010678d <vector22>:
8010678d:	6a 00                	push   $0x0
8010678f:	6a 16                	push   $0x16
80106791:	e9 4f fa ff ff       	jmp    801061e5 <alltraps>

80106796 <vector23>:
80106796:	6a 00                	push   $0x0
80106798:	6a 17                	push   $0x17
8010679a:	e9 46 fa ff ff       	jmp    801061e5 <alltraps>

8010679f <vector24>:
8010679f:	6a 00                	push   $0x0
801067a1:	6a 18                	push   $0x18
801067a3:	e9 3d fa ff ff       	jmp    801061e5 <alltraps>

801067a8 <vector25>:
801067a8:	6a 00                	push   $0x0
801067aa:	6a 19                	push   $0x19
801067ac:	e9 34 fa ff ff       	jmp    801061e5 <alltraps>

801067b1 <vector26>:
801067b1:	6a 00                	push   $0x0
801067b3:	6a 1a                	push   $0x1a
801067b5:	e9 2b fa ff ff       	jmp    801061e5 <alltraps>

801067ba <vector27>:
801067ba:	6a 00                	push   $0x0
801067bc:	6a 1b                	push   $0x1b
801067be:	e9 22 fa ff ff       	jmp    801061e5 <alltraps>

801067c3 <vector28>:
801067c3:	6a 00                	push   $0x0
801067c5:	6a 1c                	push   $0x1c
801067c7:	e9 19 fa ff ff       	jmp    801061e5 <alltraps>

801067cc <vector29>:
801067cc:	6a 00                	push   $0x0
801067ce:	6a 1d                	push   $0x1d
801067d0:	e9 10 fa ff ff       	jmp    801061e5 <alltraps>

801067d5 <vector30>:
801067d5:	6a 00                	push   $0x0
801067d7:	6a 1e                	push   $0x1e
801067d9:	e9 07 fa ff ff       	jmp    801061e5 <alltraps>

801067de <vector31>:
801067de:	6a 00                	push   $0x0
801067e0:	6a 1f                	push   $0x1f
801067e2:	e9 fe f9 ff ff       	jmp    801061e5 <alltraps>

801067e7 <vector32>:
801067e7:	6a 00                	push   $0x0
801067e9:	6a 20                	push   $0x20
801067eb:	e9 f5 f9 ff ff       	jmp    801061e5 <alltraps>

801067f0 <vector33>:
801067f0:	6a 00                	push   $0x0
801067f2:	6a 21                	push   $0x21
801067f4:	e9 ec f9 ff ff       	jmp    801061e5 <alltraps>

801067f9 <vector34>:
801067f9:	6a 00                	push   $0x0
801067fb:	6a 22                	push   $0x22
801067fd:	e9 e3 f9 ff ff       	jmp    801061e5 <alltraps>

80106802 <vector35>:
80106802:	6a 00                	push   $0x0
80106804:	6a 23                	push   $0x23
80106806:	e9 da f9 ff ff       	jmp    801061e5 <alltraps>

8010680b <vector36>:
8010680b:	6a 00                	push   $0x0
8010680d:	6a 24                	push   $0x24
8010680f:	e9 d1 f9 ff ff       	jmp    801061e5 <alltraps>

80106814 <vector37>:
80106814:	6a 00                	push   $0x0
80106816:	6a 25                	push   $0x25
80106818:	e9 c8 f9 ff ff       	jmp    801061e5 <alltraps>

8010681d <vector38>:
8010681d:	6a 00                	push   $0x0
8010681f:	6a 26                	push   $0x26
80106821:	e9 bf f9 ff ff       	jmp    801061e5 <alltraps>

80106826 <vector39>:
80106826:	6a 00                	push   $0x0
80106828:	6a 27                	push   $0x27
8010682a:	e9 b6 f9 ff ff       	jmp    801061e5 <alltraps>

8010682f <vector40>:
8010682f:	6a 00                	push   $0x0
80106831:	6a 28                	push   $0x28
80106833:	e9 ad f9 ff ff       	jmp    801061e5 <alltraps>

80106838 <vector41>:
80106838:	6a 00                	push   $0x0
8010683a:	6a 29                	push   $0x29
8010683c:	e9 a4 f9 ff ff       	jmp    801061e5 <alltraps>

80106841 <vector42>:
80106841:	6a 00                	push   $0x0
80106843:	6a 2a                	push   $0x2a
80106845:	e9 9b f9 ff ff       	jmp    801061e5 <alltraps>

8010684a <vector43>:
8010684a:	6a 00                	push   $0x0
8010684c:	6a 2b                	push   $0x2b
8010684e:	e9 92 f9 ff ff       	jmp    801061e5 <alltraps>

80106853 <vector44>:
80106853:	6a 00                	push   $0x0
80106855:	6a 2c                	push   $0x2c
80106857:	e9 89 f9 ff ff       	jmp    801061e5 <alltraps>

8010685c <vector45>:
8010685c:	6a 00                	push   $0x0
8010685e:	6a 2d                	push   $0x2d
80106860:	e9 80 f9 ff ff       	jmp    801061e5 <alltraps>

80106865 <vector46>:
80106865:	6a 00                	push   $0x0
80106867:	6a 2e                	push   $0x2e
80106869:	e9 77 f9 ff ff       	jmp    801061e5 <alltraps>

8010686e <vector47>:
8010686e:	6a 00                	push   $0x0
80106870:	6a 2f                	push   $0x2f
80106872:	e9 6e f9 ff ff       	jmp    801061e5 <alltraps>

80106877 <vector48>:
80106877:	6a 00                	push   $0x0
80106879:	6a 30                	push   $0x30
8010687b:	e9 65 f9 ff ff       	jmp    801061e5 <alltraps>

80106880 <vector49>:
80106880:	6a 00                	push   $0x0
80106882:	6a 31                	push   $0x31
80106884:	e9 5c f9 ff ff       	jmp    801061e5 <alltraps>

80106889 <vector50>:
80106889:	6a 00                	push   $0x0
8010688b:	6a 32                	push   $0x32
8010688d:	e9 53 f9 ff ff       	jmp    801061e5 <alltraps>

80106892 <vector51>:
80106892:	6a 00                	push   $0x0
80106894:	6a 33                	push   $0x33
80106896:	e9 4a f9 ff ff       	jmp    801061e5 <alltraps>

8010689b <vector52>:
8010689b:	6a 00                	push   $0x0
8010689d:	6a 34                	push   $0x34
8010689f:	e9 41 f9 ff ff       	jmp    801061e5 <alltraps>

801068a4 <vector53>:
801068a4:	6a 00                	push   $0x0
801068a6:	6a 35                	push   $0x35
801068a8:	e9 38 f9 ff ff       	jmp    801061e5 <alltraps>

801068ad <vector54>:
801068ad:	6a 00                	push   $0x0
801068af:	6a 36                	push   $0x36
801068b1:	e9 2f f9 ff ff       	jmp    801061e5 <alltraps>

801068b6 <vector55>:
801068b6:	6a 00                	push   $0x0
801068b8:	6a 37                	push   $0x37
801068ba:	e9 26 f9 ff ff       	jmp    801061e5 <alltraps>

801068bf <vector56>:
801068bf:	6a 00                	push   $0x0
801068c1:	6a 38                	push   $0x38
801068c3:	e9 1d f9 ff ff       	jmp    801061e5 <alltraps>

801068c8 <vector57>:
801068c8:	6a 00                	push   $0x0
801068ca:	6a 39                	push   $0x39
801068cc:	e9 14 f9 ff ff       	jmp    801061e5 <alltraps>

801068d1 <vector58>:
801068d1:	6a 00                	push   $0x0
801068d3:	6a 3a                	push   $0x3a
801068d5:	e9 0b f9 ff ff       	jmp    801061e5 <alltraps>

801068da <vector59>:
801068da:	6a 00                	push   $0x0
801068dc:	6a 3b                	push   $0x3b
801068de:	e9 02 f9 ff ff       	jmp    801061e5 <alltraps>

801068e3 <vector60>:
801068e3:	6a 00                	push   $0x0
801068e5:	6a 3c                	push   $0x3c
801068e7:	e9 f9 f8 ff ff       	jmp    801061e5 <alltraps>

801068ec <vector61>:
801068ec:	6a 00                	push   $0x0
801068ee:	6a 3d                	push   $0x3d
801068f0:	e9 f0 f8 ff ff       	jmp    801061e5 <alltraps>

801068f5 <vector62>:
801068f5:	6a 00                	push   $0x0
801068f7:	6a 3e                	push   $0x3e
801068f9:	e9 e7 f8 ff ff       	jmp    801061e5 <alltraps>

801068fe <vector63>:
801068fe:	6a 00                	push   $0x0
80106900:	6a 3f                	push   $0x3f
80106902:	e9 de f8 ff ff       	jmp    801061e5 <alltraps>

80106907 <vector64>:
80106907:	6a 00                	push   $0x0
80106909:	6a 40                	push   $0x40
8010690b:	e9 d5 f8 ff ff       	jmp    801061e5 <alltraps>

80106910 <vector65>:
80106910:	6a 00                	push   $0x0
80106912:	6a 41                	push   $0x41
80106914:	e9 cc f8 ff ff       	jmp    801061e5 <alltraps>

80106919 <vector66>:
80106919:	6a 00                	push   $0x0
8010691b:	6a 42                	push   $0x42
8010691d:	e9 c3 f8 ff ff       	jmp    801061e5 <alltraps>

80106922 <vector67>:
80106922:	6a 00                	push   $0x0
80106924:	6a 43                	push   $0x43
80106926:	e9 ba f8 ff ff       	jmp    801061e5 <alltraps>

8010692b <vector68>:
8010692b:	6a 00                	push   $0x0
8010692d:	6a 44                	push   $0x44
8010692f:	e9 b1 f8 ff ff       	jmp    801061e5 <alltraps>

80106934 <vector69>:
80106934:	6a 00                	push   $0x0
80106936:	6a 45                	push   $0x45
80106938:	e9 a8 f8 ff ff       	jmp    801061e5 <alltraps>

8010693d <vector70>:
8010693d:	6a 00                	push   $0x0
8010693f:	6a 46                	push   $0x46
80106941:	e9 9f f8 ff ff       	jmp    801061e5 <alltraps>

80106946 <vector71>:
80106946:	6a 00                	push   $0x0
80106948:	6a 47                	push   $0x47
8010694a:	e9 96 f8 ff ff       	jmp    801061e5 <alltraps>

8010694f <vector72>:
8010694f:	6a 00                	push   $0x0
80106951:	6a 48                	push   $0x48
80106953:	e9 8d f8 ff ff       	jmp    801061e5 <alltraps>

80106958 <vector73>:
80106958:	6a 00                	push   $0x0
8010695a:	6a 49                	push   $0x49
8010695c:	e9 84 f8 ff ff       	jmp    801061e5 <alltraps>

80106961 <vector74>:
80106961:	6a 00                	push   $0x0
80106963:	6a 4a                	push   $0x4a
80106965:	e9 7b f8 ff ff       	jmp    801061e5 <alltraps>

8010696a <vector75>:
8010696a:	6a 00                	push   $0x0
8010696c:	6a 4b                	push   $0x4b
8010696e:	e9 72 f8 ff ff       	jmp    801061e5 <alltraps>

80106973 <vector76>:
80106973:	6a 00                	push   $0x0
80106975:	6a 4c                	push   $0x4c
80106977:	e9 69 f8 ff ff       	jmp    801061e5 <alltraps>

8010697c <vector77>:
8010697c:	6a 00                	push   $0x0
8010697e:	6a 4d                	push   $0x4d
80106980:	e9 60 f8 ff ff       	jmp    801061e5 <alltraps>

80106985 <vector78>:
80106985:	6a 00                	push   $0x0
80106987:	6a 4e                	push   $0x4e
80106989:	e9 57 f8 ff ff       	jmp    801061e5 <alltraps>

8010698e <vector79>:
8010698e:	6a 00                	push   $0x0
80106990:	6a 4f                	push   $0x4f
80106992:	e9 4e f8 ff ff       	jmp    801061e5 <alltraps>

80106997 <vector80>:
80106997:	6a 00                	push   $0x0
80106999:	6a 50                	push   $0x50
8010699b:	e9 45 f8 ff ff       	jmp    801061e5 <alltraps>

801069a0 <vector81>:
801069a0:	6a 00                	push   $0x0
801069a2:	6a 51                	push   $0x51
801069a4:	e9 3c f8 ff ff       	jmp    801061e5 <alltraps>

801069a9 <vector82>:
801069a9:	6a 00                	push   $0x0
801069ab:	6a 52                	push   $0x52
801069ad:	e9 33 f8 ff ff       	jmp    801061e5 <alltraps>

801069b2 <vector83>:
801069b2:	6a 00                	push   $0x0
801069b4:	6a 53                	push   $0x53
801069b6:	e9 2a f8 ff ff       	jmp    801061e5 <alltraps>

801069bb <vector84>:
801069bb:	6a 00                	push   $0x0
801069bd:	6a 54                	push   $0x54
801069bf:	e9 21 f8 ff ff       	jmp    801061e5 <alltraps>

801069c4 <vector85>:
801069c4:	6a 00                	push   $0x0
801069c6:	6a 55                	push   $0x55
801069c8:	e9 18 f8 ff ff       	jmp    801061e5 <alltraps>

801069cd <vector86>:
801069cd:	6a 00                	push   $0x0
801069cf:	6a 56                	push   $0x56
801069d1:	e9 0f f8 ff ff       	jmp    801061e5 <alltraps>

801069d6 <vector87>:
801069d6:	6a 00                	push   $0x0
801069d8:	6a 57                	push   $0x57
801069da:	e9 06 f8 ff ff       	jmp    801061e5 <alltraps>

801069df <vector88>:
801069df:	6a 00                	push   $0x0
801069e1:	6a 58                	push   $0x58
801069e3:	e9 fd f7 ff ff       	jmp    801061e5 <alltraps>

801069e8 <vector89>:
801069e8:	6a 00                	push   $0x0
801069ea:	6a 59                	push   $0x59
801069ec:	e9 f4 f7 ff ff       	jmp    801061e5 <alltraps>

801069f1 <vector90>:
801069f1:	6a 00                	push   $0x0
801069f3:	6a 5a                	push   $0x5a
801069f5:	e9 eb f7 ff ff       	jmp    801061e5 <alltraps>

801069fa <vector91>:
801069fa:	6a 00                	push   $0x0
801069fc:	6a 5b                	push   $0x5b
801069fe:	e9 e2 f7 ff ff       	jmp    801061e5 <alltraps>

80106a03 <vector92>:
80106a03:	6a 00                	push   $0x0
80106a05:	6a 5c                	push   $0x5c
80106a07:	e9 d9 f7 ff ff       	jmp    801061e5 <alltraps>

80106a0c <vector93>:
80106a0c:	6a 00                	push   $0x0
80106a0e:	6a 5d                	push   $0x5d
80106a10:	e9 d0 f7 ff ff       	jmp    801061e5 <alltraps>

80106a15 <vector94>:
80106a15:	6a 00                	push   $0x0
80106a17:	6a 5e                	push   $0x5e
80106a19:	e9 c7 f7 ff ff       	jmp    801061e5 <alltraps>

80106a1e <vector95>:
80106a1e:	6a 00                	push   $0x0
80106a20:	6a 5f                	push   $0x5f
80106a22:	e9 be f7 ff ff       	jmp    801061e5 <alltraps>

80106a27 <vector96>:
80106a27:	6a 00                	push   $0x0
80106a29:	6a 60                	push   $0x60
80106a2b:	e9 b5 f7 ff ff       	jmp    801061e5 <alltraps>

80106a30 <vector97>:
80106a30:	6a 00                	push   $0x0
80106a32:	6a 61                	push   $0x61
80106a34:	e9 ac f7 ff ff       	jmp    801061e5 <alltraps>

80106a39 <vector98>:
80106a39:	6a 00                	push   $0x0
80106a3b:	6a 62                	push   $0x62
80106a3d:	e9 a3 f7 ff ff       	jmp    801061e5 <alltraps>

80106a42 <vector99>:
80106a42:	6a 00                	push   $0x0
80106a44:	6a 63                	push   $0x63
80106a46:	e9 9a f7 ff ff       	jmp    801061e5 <alltraps>

80106a4b <vector100>:
80106a4b:	6a 00                	push   $0x0
80106a4d:	6a 64                	push   $0x64
80106a4f:	e9 91 f7 ff ff       	jmp    801061e5 <alltraps>

80106a54 <vector101>:
80106a54:	6a 00                	push   $0x0
80106a56:	6a 65                	push   $0x65
80106a58:	e9 88 f7 ff ff       	jmp    801061e5 <alltraps>

80106a5d <vector102>:
80106a5d:	6a 00                	push   $0x0
80106a5f:	6a 66                	push   $0x66
80106a61:	e9 7f f7 ff ff       	jmp    801061e5 <alltraps>

80106a66 <vector103>:
80106a66:	6a 00                	push   $0x0
80106a68:	6a 67                	push   $0x67
80106a6a:	e9 76 f7 ff ff       	jmp    801061e5 <alltraps>

80106a6f <vector104>:
80106a6f:	6a 00                	push   $0x0
80106a71:	6a 68                	push   $0x68
80106a73:	e9 6d f7 ff ff       	jmp    801061e5 <alltraps>

80106a78 <vector105>:
80106a78:	6a 00                	push   $0x0
80106a7a:	6a 69                	push   $0x69
80106a7c:	e9 64 f7 ff ff       	jmp    801061e5 <alltraps>

80106a81 <vector106>:
80106a81:	6a 00                	push   $0x0
80106a83:	6a 6a                	push   $0x6a
80106a85:	e9 5b f7 ff ff       	jmp    801061e5 <alltraps>

80106a8a <vector107>:
80106a8a:	6a 00                	push   $0x0
80106a8c:	6a 6b                	push   $0x6b
80106a8e:	e9 52 f7 ff ff       	jmp    801061e5 <alltraps>

80106a93 <vector108>:
80106a93:	6a 00                	push   $0x0
80106a95:	6a 6c                	push   $0x6c
80106a97:	e9 49 f7 ff ff       	jmp    801061e5 <alltraps>

80106a9c <vector109>:
80106a9c:	6a 00                	push   $0x0
80106a9e:	6a 6d                	push   $0x6d
80106aa0:	e9 40 f7 ff ff       	jmp    801061e5 <alltraps>

80106aa5 <vector110>:
80106aa5:	6a 00                	push   $0x0
80106aa7:	6a 6e                	push   $0x6e
80106aa9:	e9 37 f7 ff ff       	jmp    801061e5 <alltraps>

80106aae <vector111>:
80106aae:	6a 00                	push   $0x0
80106ab0:	6a 6f                	push   $0x6f
80106ab2:	e9 2e f7 ff ff       	jmp    801061e5 <alltraps>

80106ab7 <vector112>:
80106ab7:	6a 00                	push   $0x0
80106ab9:	6a 70                	push   $0x70
80106abb:	e9 25 f7 ff ff       	jmp    801061e5 <alltraps>

80106ac0 <vector113>:
80106ac0:	6a 00                	push   $0x0
80106ac2:	6a 71                	push   $0x71
80106ac4:	e9 1c f7 ff ff       	jmp    801061e5 <alltraps>

80106ac9 <vector114>:
80106ac9:	6a 00                	push   $0x0
80106acb:	6a 72                	push   $0x72
80106acd:	e9 13 f7 ff ff       	jmp    801061e5 <alltraps>

80106ad2 <vector115>:
80106ad2:	6a 00                	push   $0x0
80106ad4:	6a 73                	push   $0x73
80106ad6:	e9 0a f7 ff ff       	jmp    801061e5 <alltraps>

80106adb <vector116>:
80106adb:	6a 00                	push   $0x0
80106add:	6a 74                	push   $0x74
80106adf:	e9 01 f7 ff ff       	jmp    801061e5 <alltraps>

80106ae4 <vector117>:
80106ae4:	6a 00                	push   $0x0
80106ae6:	6a 75                	push   $0x75
80106ae8:	e9 f8 f6 ff ff       	jmp    801061e5 <alltraps>

80106aed <vector118>:
80106aed:	6a 00                	push   $0x0
80106aef:	6a 76                	push   $0x76
80106af1:	e9 ef f6 ff ff       	jmp    801061e5 <alltraps>

80106af6 <vector119>:
80106af6:	6a 00                	push   $0x0
80106af8:	6a 77                	push   $0x77
80106afa:	e9 e6 f6 ff ff       	jmp    801061e5 <alltraps>

80106aff <vector120>:
80106aff:	6a 00                	push   $0x0
80106b01:	6a 78                	push   $0x78
80106b03:	e9 dd f6 ff ff       	jmp    801061e5 <alltraps>

80106b08 <vector121>:
80106b08:	6a 00                	push   $0x0
80106b0a:	6a 79                	push   $0x79
80106b0c:	e9 d4 f6 ff ff       	jmp    801061e5 <alltraps>

80106b11 <vector122>:
80106b11:	6a 00                	push   $0x0
80106b13:	6a 7a                	push   $0x7a
80106b15:	e9 cb f6 ff ff       	jmp    801061e5 <alltraps>

80106b1a <vector123>:
80106b1a:	6a 00                	push   $0x0
80106b1c:	6a 7b                	push   $0x7b
80106b1e:	e9 c2 f6 ff ff       	jmp    801061e5 <alltraps>

80106b23 <vector124>:
80106b23:	6a 00                	push   $0x0
80106b25:	6a 7c                	push   $0x7c
80106b27:	e9 b9 f6 ff ff       	jmp    801061e5 <alltraps>

80106b2c <vector125>:
80106b2c:	6a 00                	push   $0x0
80106b2e:	6a 7d                	push   $0x7d
80106b30:	e9 b0 f6 ff ff       	jmp    801061e5 <alltraps>

80106b35 <vector126>:
80106b35:	6a 00                	push   $0x0
80106b37:	6a 7e                	push   $0x7e
80106b39:	e9 a7 f6 ff ff       	jmp    801061e5 <alltraps>

80106b3e <vector127>:
80106b3e:	6a 00                	push   $0x0
80106b40:	6a 7f                	push   $0x7f
80106b42:	e9 9e f6 ff ff       	jmp    801061e5 <alltraps>

80106b47 <vector128>:
80106b47:	6a 00                	push   $0x0
80106b49:	68 80 00 00 00       	push   $0x80
80106b4e:	e9 92 f6 ff ff       	jmp    801061e5 <alltraps>

80106b53 <vector129>:
80106b53:	6a 00                	push   $0x0
80106b55:	68 81 00 00 00       	push   $0x81
80106b5a:	e9 86 f6 ff ff       	jmp    801061e5 <alltraps>

80106b5f <vector130>:
80106b5f:	6a 00                	push   $0x0
80106b61:	68 82 00 00 00       	push   $0x82
80106b66:	e9 7a f6 ff ff       	jmp    801061e5 <alltraps>

80106b6b <vector131>:
80106b6b:	6a 00                	push   $0x0
80106b6d:	68 83 00 00 00       	push   $0x83
80106b72:	e9 6e f6 ff ff       	jmp    801061e5 <alltraps>

80106b77 <vector132>:
80106b77:	6a 00                	push   $0x0
80106b79:	68 84 00 00 00       	push   $0x84
80106b7e:	e9 62 f6 ff ff       	jmp    801061e5 <alltraps>

80106b83 <vector133>:
80106b83:	6a 00                	push   $0x0
80106b85:	68 85 00 00 00       	push   $0x85
80106b8a:	e9 56 f6 ff ff       	jmp    801061e5 <alltraps>

80106b8f <vector134>:
80106b8f:	6a 00                	push   $0x0
80106b91:	68 86 00 00 00       	push   $0x86
80106b96:	e9 4a f6 ff ff       	jmp    801061e5 <alltraps>

80106b9b <vector135>:
80106b9b:	6a 00                	push   $0x0
80106b9d:	68 87 00 00 00       	push   $0x87
80106ba2:	e9 3e f6 ff ff       	jmp    801061e5 <alltraps>

80106ba7 <vector136>:
80106ba7:	6a 00                	push   $0x0
80106ba9:	68 88 00 00 00       	push   $0x88
80106bae:	e9 32 f6 ff ff       	jmp    801061e5 <alltraps>

80106bb3 <vector137>:
80106bb3:	6a 00                	push   $0x0
80106bb5:	68 89 00 00 00       	push   $0x89
80106bba:	e9 26 f6 ff ff       	jmp    801061e5 <alltraps>

80106bbf <vector138>:
80106bbf:	6a 00                	push   $0x0
80106bc1:	68 8a 00 00 00       	push   $0x8a
80106bc6:	e9 1a f6 ff ff       	jmp    801061e5 <alltraps>

80106bcb <vector139>:
80106bcb:	6a 00                	push   $0x0
80106bcd:	68 8b 00 00 00       	push   $0x8b
80106bd2:	e9 0e f6 ff ff       	jmp    801061e5 <alltraps>

80106bd7 <vector140>:
80106bd7:	6a 00                	push   $0x0
80106bd9:	68 8c 00 00 00       	push   $0x8c
80106bde:	e9 02 f6 ff ff       	jmp    801061e5 <alltraps>

80106be3 <vector141>:
80106be3:	6a 00                	push   $0x0
80106be5:	68 8d 00 00 00       	push   $0x8d
80106bea:	e9 f6 f5 ff ff       	jmp    801061e5 <alltraps>

80106bef <vector142>:
80106bef:	6a 00                	push   $0x0
80106bf1:	68 8e 00 00 00       	push   $0x8e
80106bf6:	e9 ea f5 ff ff       	jmp    801061e5 <alltraps>

80106bfb <vector143>:
80106bfb:	6a 00                	push   $0x0
80106bfd:	68 8f 00 00 00       	push   $0x8f
80106c02:	e9 de f5 ff ff       	jmp    801061e5 <alltraps>

80106c07 <vector144>:
80106c07:	6a 00                	push   $0x0
80106c09:	68 90 00 00 00       	push   $0x90
80106c0e:	e9 d2 f5 ff ff       	jmp    801061e5 <alltraps>

80106c13 <vector145>:
80106c13:	6a 00                	push   $0x0
80106c15:	68 91 00 00 00       	push   $0x91
80106c1a:	e9 c6 f5 ff ff       	jmp    801061e5 <alltraps>

80106c1f <vector146>:
80106c1f:	6a 00                	push   $0x0
80106c21:	68 92 00 00 00       	push   $0x92
80106c26:	e9 ba f5 ff ff       	jmp    801061e5 <alltraps>

80106c2b <vector147>:
80106c2b:	6a 00                	push   $0x0
80106c2d:	68 93 00 00 00       	push   $0x93
80106c32:	e9 ae f5 ff ff       	jmp    801061e5 <alltraps>

80106c37 <vector148>:
80106c37:	6a 00                	push   $0x0
80106c39:	68 94 00 00 00       	push   $0x94
80106c3e:	e9 a2 f5 ff ff       	jmp    801061e5 <alltraps>

80106c43 <vector149>:
80106c43:	6a 00                	push   $0x0
80106c45:	68 95 00 00 00       	push   $0x95
80106c4a:	e9 96 f5 ff ff       	jmp    801061e5 <alltraps>

80106c4f <vector150>:
80106c4f:	6a 00                	push   $0x0
80106c51:	68 96 00 00 00       	push   $0x96
80106c56:	e9 8a f5 ff ff       	jmp    801061e5 <alltraps>

80106c5b <vector151>:
80106c5b:	6a 00                	push   $0x0
80106c5d:	68 97 00 00 00       	push   $0x97
80106c62:	e9 7e f5 ff ff       	jmp    801061e5 <alltraps>

80106c67 <vector152>:
80106c67:	6a 00                	push   $0x0
80106c69:	68 98 00 00 00       	push   $0x98
80106c6e:	e9 72 f5 ff ff       	jmp    801061e5 <alltraps>

80106c73 <vector153>:
80106c73:	6a 00                	push   $0x0
80106c75:	68 99 00 00 00       	push   $0x99
80106c7a:	e9 66 f5 ff ff       	jmp    801061e5 <alltraps>

80106c7f <vector154>:
80106c7f:	6a 00                	push   $0x0
80106c81:	68 9a 00 00 00       	push   $0x9a
80106c86:	e9 5a f5 ff ff       	jmp    801061e5 <alltraps>

80106c8b <vector155>:
80106c8b:	6a 00                	push   $0x0
80106c8d:	68 9b 00 00 00       	push   $0x9b
80106c92:	e9 4e f5 ff ff       	jmp    801061e5 <alltraps>

80106c97 <vector156>:
80106c97:	6a 00                	push   $0x0
80106c99:	68 9c 00 00 00       	push   $0x9c
80106c9e:	e9 42 f5 ff ff       	jmp    801061e5 <alltraps>

80106ca3 <vector157>:
80106ca3:	6a 00                	push   $0x0
80106ca5:	68 9d 00 00 00       	push   $0x9d
80106caa:	e9 36 f5 ff ff       	jmp    801061e5 <alltraps>

80106caf <vector158>:
80106caf:	6a 00                	push   $0x0
80106cb1:	68 9e 00 00 00       	push   $0x9e
80106cb6:	e9 2a f5 ff ff       	jmp    801061e5 <alltraps>

80106cbb <vector159>:
80106cbb:	6a 00                	push   $0x0
80106cbd:	68 9f 00 00 00       	push   $0x9f
80106cc2:	e9 1e f5 ff ff       	jmp    801061e5 <alltraps>

80106cc7 <vector160>:
80106cc7:	6a 00                	push   $0x0
80106cc9:	68 a0 00 00 00       	push   $0xa0
80106cce:	e9 12 f5 ff ff       	jmp    801061e5 <alltraps>

80106cd3 <vector161>:
80106cd3:	6a 00                	push   $0x0
80106cd5:	68 a1 00 00 00       	push   $0xa1
80106cda:	e9 06 f5 ff ff       	jmp    801061e5 <alltraps>

80106cdf <vector162>:
80106cdf:	6a 00                	push   $0x0
80106ce1:	68 a2 00 00 00       	push   $0xa2
80106ce6:	e9 fa f4 ff ff       	jmp    801061e5 <alltraps>

80106ceb <vector163>:
80106ceb:	6a 00                	push   $0x0
80106ced:	68 a3 00 00 00       	push   $0xa3
80106cf2:	e9 ee f4 ff ff       	jmp    801061e5 <alltraps>

80106cf7 <vector164>:
80106cf7:	6a 00                	push   $0x0
80106cf9:	68 a4 00 00 00       	push   $0xa4
80106cfe:	e9 e2 f4 ff ff       	jmp    801061e5 <alltraps>

80106d03 <vector165>:
80106d03:	6a 00                	push   $0x0
80106d05:	68 a5 00 00 00       	push   $0xa5
80106d0a:	e9 d6 f4 ff ff       	jmp    801061e5 <alltraps>

80106d0f <vector166>:
80106d0f:	6a 00                	push   $0x0
80106d11:	68 a6 00 00 00       	push   $0xa6
80106d16:	e9 ca f4 ff ff       	jmp    801061e5 <alltraps>

80106d1b <vector167>:
80106d1b:	6a 00                	push   $0x0
80106d1d:	68 a7 00 00 00       	push   $0xa7
80106d22:	e9 be f4 ff ff       	jmp    801061e5 <alltraps>

80106d27 <vector168>:
80106d27:	6a 00                	push   $0x0
80106d29:	68 a8 00 00 00       	push   $0xa8
80106d2e:	e9 b2 f4 ff ff       	jmp    801061e5 <alltraps>

80106d33 <vector169>:
80106d33:	6a 00                	push   $0x0
80106d35:	68 a9 00 00 00       	push   $0xa9
80106d3a:	e9 a6 f4 ff ff       	jmp    801061e5 <alltraps>

80106d3f <vector170>:
80106d3f:	6a 00                	push   $0x0
80106d41:	68 aa 00 00 00       	push   $0xaa
80106d46:	e9 9a f4 ff ff       	jmp    801061e5 <alltraps>

80106d4b <vector171>:
80106d4b:	6a 00                	push   $0x0
80106d4d:	68 ab 00 00 00       	push   $0xab
80106d52:	e9 8e f4 ff ff       	jmp    801061e5 <alltraps>

80106d57 <vector172>:
80106d57:	6a 00                	push   $0x0
80106d59:	68 ac 00 00 00       	push   $0xac
80106d5e:	e9 82 f4 ff ff       	jmp    801061e5 <alltraps>

80106d63 <vector173>:
80106d63:	6a 00                	push   $0x0
80106d65:	68 ad 00 00 00       	push   $0xad
80106d6a:	e9 76 f4 ff ff       	jmp    801061e5 <alltraps>

80106d6f <vector174>:
80106d6f:	6a 00                	push   $0x0
80106d71:	68 ae 00 00 00       	push   $0xae
80106d76:	e9 6a f4 ff ff       	jmp    801061e5 <alltraps>

80106d7b <vector175>:
80106d7b:	6a 00                	push   $0x0
80106d7d:	68 af 00 00 00       	push   $0xaf
80106d82:	e9 5e f4 ff ff       	jmp    801061e5 <alltraps>

80106d87 <vector176>:
80106d87:	6a 00                	push   $0x0
80106d89:	68 b0 00 00 00       	push   $0xb0
80106d8e:	e9 52 f4 ff ff       	jmp    801061e5 <alltraps>

80106d93 <vector177>:
80106d93:	6a 00                	push   $0x0
80106d95:	68 b1 00 00 00       	push   $0xb1
80106d9a:	e9 46 f4 ff ff       	jmp    801061e5 <alltraps>

80106d9f <vector178>:
80106d9f:	6a 00                	push   $0x0
80106da1:	68 b2 00 00 00       	push   $0xb2
80106da6:	e9 3a f4 ff ff       	jmp    801061e5 <alltraps>

80106dab <vector179>:
80106dab:	6a 00                	push   $0x0
80106dad:	68 b3 00 00 00       	push   $0xb3
80106db2:	e9 2e f4 ff ff       	jmp    801061e5 <alltraps>

80106db7 <vector180>:
80106db7:	6a 00                	push   $0x0
80106db9:	68 b4 00 00 00       	push   $0xb4
80106dbe:	e9 22 f4 ff ff       	jmp    801061e5 <alltraps>

80106dc3 <vector181>:
80106dc3:	6a 00                	push   $0x0
80106dc5:	68 b5 00 00 00       	push   $0xb5
80106dca:	e9 16 f4 ff ff       	jmp    801061e5 <alltraps>

80106dcf <vector182>:
80106dcf:	6a 00                	push   $0x0
80106dd1:	68 b6 00 00 00       	push   $0xb6
80106dd6:	e9 0a f4 ff ff       	jmp    801061e5 <alltraps>

80106ddb <vector183>:
80106ddb:	6a 00                	push   $0x0
80106ddd:	68 b7 00 00 00       	push   $0xb7
80106de2:	e9 fe f3 ff ff       	jmp    801061e5 <alltraps>

80106de7 <vector184>:
80106de7:	6a 00                	push   $0x0
80106de9:	68 b8 00 00 00       	push   $0xb8
80106dee:	e9 f2 f3 ff ff       	jmp    801061e5 <alltraps>

80106df3 <vector185>:
80106df3:	6a 00                	push   $0x0
80106df5:	68 b9 00 00 00       	push   $0xb9
80106dfa:	e9 e6 f3 ff ff       	jmp    801061e5 <alltraps>

80106dff <vector186>:
80106dff:	6a 00                	push   $0x0
80106e01:	68 ba 00 00 00       	push   $0xba
80106e06:	e9 da f3 ff ff       	jmp    801061e5 <alltraps>

80106e0b <vector187>:
80106e0b:	6a 00                	push   $0x0
80106e0d:	68 bb 00 00 00       	push   $0xbb
80106e12:	e9 ce f3 ff ff       	jmp    801061e5 <alltraps>

80106e17 <vector188>:
80106e17:	6a 00                	push   $0x0
80106e19:	68 bc 00 00 00       	push   $0xbc
80106e1e:	e9 c2 f3 ff ff       	jmp    801061e5 <alltraps>

80106e23 <vector189>:
80106e23:	6a 00                	push   $0x0
80106e25:	68 bd 00 00 00       	push   $0xbd
80106e2a:	e9 b6 f3 ff ff       	jmp    801061e5 <alltraps>

80106e2f <vector190>:
80106e2f:	6a 00                	push   $0x0
80106e31:	68 be 00 00 00       	push   $0xbe
80106e36:	e9 aa f3 ff ff       	jmp    801061e5 <alltraps>

80106e3b <vector191>:
80106e3b:	6a 00                	push   $0x0
80106e3d:	68 bf 00 00 00       	push   $0xbf
80106e42:	e9 9e f3 ff ff       	jmp    801061e5 <alltraps>

80106e47 <vector192>:
80106e47:	6a 00                	push   $0x0
80106e49:	68 c0 00 00 00       	push   $0xc0
80106e4e:	e9 92 f3 ff ff       	jmp    801061e5 <alltraps>

80106e53 <vector193>:
80106e53:	6a 00                	push   $0x0
80106e55:	68 c1 00 00 00       	push   $0xc1
80106e5a:	e9 86 f3 ff ff       	jmp    801061e5 <alltraps>

80106e5f <vector194>:
80106e5f:	6a 00                	push   $0x0
80106e61:	68 c2 00 00 00       	push   $0xc2
80106e66:	e9 7a f3 ff ff       	jmp    801061e5 <alltraps>

80106e6b <vector195>:
80106e6b:	6a 00                	push   $0x0
80106e6d:	68 c3 00 00 00       	push   $0xc3
80106e72:	e9 6e f3 ff ff       	jmp    801061e5 <alltraps>

80106e77 <vector196>:
80106e77:	6a 00                	push   $0x0
80106e79:	68 c4 00 00 00       	push   $0xc4
80106e7e:	e9 62 f3 ff ff       	jmp    801061e5 <alltraps>

80106e83 <vector197>:
80106e83:	6a 00                	push   $0x0
80106e85:	68 c5 00 00 00       	push   $0xc5
80106e8a:	e9 56 f3 ff ff       	jmp    801061e5 <alltraps>

80106e8f <vector198>:
80106e8f:	6a 00                	push   $0x0
80106e91:	68 c6 00 00 00       	push   $0xc6
80106e96:	e9 4a f3 ff ff       	jmp    801061e5 <alltraps>

80106e9b <vector199>:
80106e9b:	6a 00                	push   $0x0
80106e9d:	68 c7 00 00 00       	push   $0xc7
80106ea2:	e9 3e f3 ff ff       	jmp    801061e5 <alltraps>

80106ea7 <vector200>:
80106ea7:	6a 00                	push   $0x0
80106ea9:	68 c8 00 00 00       	push   $0xc8
80106eae:	e9 32 f3 ff ff       	jmp    801061e5 <alltraps>

80106eb3 <vector201>:
80106eb3:	6a 00                	push   $0x0
80106eb5:	68 c9 00 00 00       	push   $0xc9
80106eba:	e9 26 f3 ff ff       	jmp    801061e5 <alltraps>

80106ebf <vector202>:
80106ebf:	6a 00                	push   $0x0
80106ec1:	68 ca 00 00 00       	push   $0xca
80106ec6:	e9 1a f3 ff ff       	jmp    801061e5 <alltraps>

80106ecb <vector203>:
80106ecb:	6a 00                	push   $0x0
80106ecd:	68 cb 00 00 00       	push   $0xcb
80106ed2:	e9 0e f3 ff ff       	jmp    801061e5 <alltraps>

80106ed7 <vector204>:
80106ed7:	6a 00                	push   $0x0
80106ed9:	68 cc 00 00 00       	push   $0xcc
80106ede:	e9 02 f3 ff ff       	jmp    801061e5 <alltraps>

80106ee3 <vector205>:
80106ee3:	6a 00                	push   $0x0
80106ee5:	68 cd 00 00 00       	push   $0xcd
80106eea:	e9 f6 f2 ff ff       	jmp    801061e5 <alltraps>

80106eef <vector206>:
80106eef:	6a 00                	push   $0x0
80106ef1:	68 ce 00 00 00       	push   $0xce
80106ef6:	e9 ea f2 ff ff       	jmp    801061e5 <alltraps>

80106efb <vector207>:
80106efb:	6a 00                	push   $0x0
80106efd:	68 cf 00 00 00       	push   $0xcf
80106f02:	e9 de f2 ff ff       	jmp    801061e5 <alltraps>

80106f07 <vector208>:
80106f07:	6a 00                	push   $0x0
80106f09:	68 d0 00 00 00       	push   $0xd0
80106f0e:	e9 d2 f2 ff ff       	jmp    801061e5 <alltraps>

80106f13 <vector209>:
80106f13:	6a 00                	push   $0x0
80106f15:	68 d1 00 00 00       	push   $0xd1
80106f1a:	e9 c6 f2 ff ff       	jmp    801061e5 <alltraps>

80106f1f <vector210>:
80106f1f:	6a 00                	push   $0x0
80106f21:	68 d2 00 00 00       	push   $0xd2
80106f26:	e9 ba f2 ff ff       	jmp    801061e5 <alltraps>

80106f2b <vector211>:
80106f2b:	6a 00                	push   $0x0
80106f2d:	68 d3 00 00 00       	push   $0xd3
80106f32:	e9 ae f2 ff ff       	jmp    801061e5 <alltraps>

80106f37 <vector212>:
80106f37:	6a 00                	push   $0x0
80106f39:	68 d4 00 00 00       	push   $0xd4
80106f3e:	e9 a2 f2 ff ff       	jmp    801061e5 <alltraps>

80106f43 <vector213>:
80106f43:	6a 00                	push   $0x0
80106f45:	68 d5 00 00 00       	push   $0xd5
80106f4a:	e9 96 f2 ff ff       	jmp    801061e5 <alltraps>

80106f4f <vector214>:
80106f4f:	6a 00                	push   $0x0
80106f51:	68 d6 00 00 00       	push   $0xd6
80106f56:	e9 8a f2 ff ff       	jmp    801061e5 <alltraps>

80106f5b <vector215>:
80106f5b:	6a 00                	push   $0x0
80106f5d:	68 d7 00 00 00       	push   $0xd7
80106f62:	e9 7e f2 ff ff       	jmp    801061e5 <alltraps>

80106f67 <vector216>:
80106f67:	6a 00                	push   $0x0
80106f69:	68 d8 00 00 00       	push   $0xd8
80106f6e:	e9 72 f2 ff ff       	jmp    801061e5 <alltraps>

80106f73 <vector217>:
80106f73:	6a 00                	push   $0x0
80106f75:	68 d9 00 00 00       	push   $0xd9
80106f7a:	e9 66 f2 ff ff       	jmp    801061e5 <alltraps>

80106f7f <vector218>:
80106f7f:	6a 00                	push   $0x0
80106f81:	68 da 00 00 00       	push   $0xda
80106f86:	e9 5a f2 ff ff       	jmp    801061e5 <alltraps>

80106f8b <vector219>:
80106f8b:	6a 00                	push   $0x0
80106f8d:	68 db 00 00 00       	push   $0xdb
80106f92:	e9 4e f2 ff ff       	jmp    801061e5 <alltraps>

80106f97 <vector220>:
80106f97:	6a 00                	push   $0x0
80106f99:	68 dc 00 00 00       	push   $0xdc
80106f9e:	e9 42 f2 ff ff       	jmp    801061e5 <alltraps>

80106fa3 <vector221>:
80106fa3:	6a 00                	push   $0x0
80106fa5:	68 dd 00 00 00       	push   $0xdd
80106faa:	e9 36 f2 ff ff       	jmp    801061e5 <alltraps>

80106faf <vector222>:
80106faf:	6a 00                	push   $0x0
80106fb1:	68 de 00 00 00       	push   $0xde
80106fb6:	e9 2a f2 ff ff       	jmp    801061e5 <alltraps>

80106fbb <vector223>:
80106fbb:	6a 00                	push   $0x0
80106fbd:	68 df 00 00 00       	push   $0xdf
80106fc2:	e9 1e f2 ff ff       	jmp    801061e5 <alltraps>

80106fc7 <vector224>:
80106fc7:	6a 00                	push   $0x0
80106fc9:	68 e0 00 00 00       	push   $0xe0
80106fce:	e9 12 f2 ff ff       	jmp    801061e5 <alltraps>

80106fd3 <vector225>:
80106fd3:	6a 00                	push   $0x0
80106fd5:	68 e1 00 00 00       	push   $0xe1
80106fda:	e9 06 f2 ff ff       	jmp    801061e5 <alltraps>

80106fdf <vector226>:
80106fdf:	6a 00                	push   $0x0
80106fe1:	68 e2 00 00 00       	push   $0xe2
80106fe6:	e9 fa f1 ff ff       	jmp    801061e5 <alltraps>

80106feb <vector227>:
80106feb:	6a 00                	push   $0x0
80106fed:	68 e3 00 00 00       	push   $0xe3
80106ff2:	e9 ee f1 ff ff       	jmp    801061e5 <alltraps>

80106ff7 <vector228>:
80106ff7:	6a 00                	push   $0x0
80106ff9:	68 e4 00 00 00       	push   $0xe4
80106ffe:	e9 e2 f1 ff ff       	jmp    801061e5 <alltraps>

80107003 <vector229>:
80107003:	6a 00                	push   $0x0
80107005:	68 e5 00 00 00       	push   $0xe5
8010700a:	e9 d6 f1 ff ff       	jmp    801061e5 <alltraps>

8010700f <vector230>:
8010700f:	6a 00                	push   $0x0
80107011:	68 e6 00 00 00       	push   $0xe6
80107016:	e9 ca f1 ff ff       	jmp    801061e5 <alltraps>

8010701b <vector231>:
8010701b:	6a 00                	push   $0x0
8010701d:	68 e7 00 00 00       	push   $0xe7
80107022:	e9 be f1 ff ff       	jmp    801061e5 <alltraps>

80107027 <vector232>:
80107027:	6a 00                	push   $0x0
80107029:	68 e8 00 00 00       	push   $0xe8
8010702e:	e9 b2 f1 ff ff       	jmp    801061e5 <alltraps>

80107033 <vector233>:
80107033:	6a 00                	push   $0x0
80107035:	68 e9 00 00 00       	push   $0xe9
8010703a:	e9 a6 f1 ff ff       	jmp    801061e5 <alltraps>

8010703f <vector234>:
8010703f:	6a 00                	push   $0x0
80107041:	68 ea 00 00 00       	push   $0xea
80107046:	e9 9a f1 ff ff       	jmp    801061e5 <alltraps>

8010704b <vector235>:
8010704b:	6a 00                	push   $0x0
8010704d:	68 eb 00 00 00       	push   $0xeb
80107052:	e9 8e f1 ff ff       	jmp    801061e5 <alltraps>

80107057 <vector236>:
80107057:	6a 00                	push   $0x0
80107059:	68 ec 00 00 00       	push   $0xec
8010705e:	e9 82 f1 ff ff       	jmp    801061e5 <alltraps>

80107063 <vector237>:
80107063:	6a 00                	push   $0x0
80107065:	68 ed 00 00 00       	push   $0xed
8010706a:	e9 76 f1 ff ff       	jmp    801061e5 <alltraps>

8010706f <vector238>:
8010706f:	6a 00                	push   $0x0
80107071:	68 ee 00 00 00       	push   $0xee
80107076:	e9 6a f1 ff ff       	jmp    801061e5 <alltraps>

8010707b <vector239>:
8010707b:	6a 00                	push   $0x0
8010707d:	68 ef 00 00 00       	push   $0xef
80107082:	e9 5e f1 ff ff       	jmp    801061e5 <alltraps>

80107087 <vector240>:
80107087:	6a 00                	push   $0x0
80107089:	68 f0 00 00 00       	push   $0xf0
8010708e:	e9 52 f1 ff ff       	jmp    801061e5 <alltraps>

80107093 <vector241>:
80107093:	6a 00                	push   $0x0
80107095:	68 f1 00 00 00       	push   $0xf1
8010709a:	e9 46 f1 ff ff       	jmp    801061e5 <alltraps>

8010709f <vector242>:
8010709f:	6a 00                	push   $0x0
801070a1:	68 f2 00 00 00       	push   $0xf2
801070a6:	e9 3a f1 ff ff       	jmp    801061e5 <alltraps>

801070ab <vector243>:
801070ab:	6a 00                	push   $0x0
801070ad:	68 f3 00 00 00       	push   $0xf3
801070b2:	e9 2e f1 ff ff       	jmp    801061e5 <alltraps>

801070b7 <vector244>:
801070b7:	6a 00                	push   $0x0
801070b9:	68 f4 00 00 00       	push   $0xf4
801070be:	e9 22 f1 ff ff       	jmp    801061e5 <alltraps>

801070c3 <vector245>:
801070c3:	6a 00                	push   $0x0
801070c5:	68 f5 00 00 00       	push   $0xf5
801070ca:	e9 16 f1 ff ff       	jmp    801061e5 <alltraps>

801070cf <vector246>:
801070cf:	6a 00                	push   $0x0
801070d1:	68 f6 00 00 00       	push   $0xf6
801070d6:	e9 0a f1 ff ff       	jmp    801061e5 <alltraps>

801070db <vector247>:
801070db:	6a 00                	push   $0x0
801070dd:	68 f7 00 00 00       	push   $0xf7
801070e2:	e9 fe f0 ff ff       	jmp    801061e5 <alltraps>

801070e7 <vector248>:
801070e7:	6a 00                	push   $0x0
801070e9:	68 f8 00 00 00       	push   $0xf8
801070ee:	e9 f2 f0 ff ff       	jmp    801061e5 <alltraps>

801070f3 <vector249>:
801070f3:	6a 00                	push   $0x0
801070f5:	68 f9 00 00 00       	push   $0xf9
801070fa:	e9 e6 f0 ff ff       	jmp    801061e5 <alltraps>

801070ff <vector250>:
801070ff:	6a 00                	push   $0x0
80107101:	68 fa 00 00 00       	push   $0xfa
80107106:	e9 da f0 ff ff       	jmp    801061e5 <alltraps>

8010710b <vector251>:
8010710b:	6a 00                	push   $0x0
8010710d:	68 fb 00 00 00       	push   $0xfb
80107112:	e9 ce f0 ff ff       	jmp    801061e5 <alltraps>

80107117 <vector252>:
80107117:	6a 00                	push   $0x0
80107119:	68 fc 00 00 00       	push   $0xfc
8010711e:	e9 c2 f0 ff ff       	jmp    801061e5 <alltraps>

80107123 <vector253>:
80107123:	6a 00                	push   $0x0
80107125:	68 fd 00 00 00       	push   $0xfd
8010712a:	e9 b6 f0 ff ff       	jmp    801061e5 <alltraps>

8010712f <vector254>:
8010712f:	6a 00                	push   $0x0
80107131:	68 fe 00 00 00       	push   $0xfe
80107136:	e9 aa f0 ff ff       	jmp    801061e5 <alltraps>

8010713b <vector255>:
8010713b:	6a 00                	push   $0x0
8010713d:	68 ff 00 00 00       	push   $0xff
80107142:	e9 9e f0 ff ff       	jmp    801061e5 <alltraps>
80107147:	66 90                	xchg   %ax,%ax
80107149:	66 90                	xchg   %ax,%ax
8010714b:	66 90                	xchg   %ax,%ax
8010714d:	66 90                	xchg   %ax,%ax
8010714f:	90                   	nop

80107150 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107156:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010715c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107162:	83 ec 1c             	sub    $0x1c,%esp
80107165:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107168:	39 d3                	cmp    %edx,%ebx
8010716a:	73 49                	jae    801071b5 <deallocuvm.part.0+0x65>
8010716c:	89 c7                	mov    %eax,%edi
8010716e:	eb 0c                	jmp    8010717c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107170:	83 c0 01             	add    $0x1,%eax
80107173:	c1 e0 16             	shl    $0x16,%eax
80107176:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107178:	39 da                	cmp    %ebx,%edx
8010717a:	76 39                	jbe    801071b5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010717c:	89 d8                	mov    %ebx,%eax
8010717e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107181:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107184:	f6 c1 01             	test   $0x1,%cl
80107187:	74 e7                	je     80107170 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107189:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010718b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107191:	c1 ee 0a             	shr    $0xa,%esi
80107194:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010719a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801071a1:	85 f6                	test   %esi,%esi
801071a3:	74 cb                	je     80107170 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801071a5:	8b 06                	mov    (%esi),%eax
801071a7:	a8 01                	test   $0x1,%al
801071a9:	75 15                	jne    801071c0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801071ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071b1:	39 da                	cmp    %ebx,%edx
801071b3:	77 c7                	ja     8010717c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801071b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071bb:	5b                   	pop    %ebx
801071bc:	5e                   	pop    %esi
801071bd:	5f                   	pop    %edi
801071be:	5d                   	pop    %ebp
801071bf:	c3                   	ret    
      if(pa == 0)
801071c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071c5:	74 25                	je     801071ec <deallocuvm.part.0+0x9c>
      kfree(v);
801071c7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071ca:	05 00 00 00 80       	add    $0x80000000,%eax
801071cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801071d8:	50                   	push   %eax
801071d9:	e8 a2 b7 ff ff       	call   80102980 <kfree>
      *pte = 0;
801071de:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801071e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071e7:	83 c4 10             	add    $0x10,%esp
801071ea:	eb 8c                	jmp    80107178 <deallocuvm.part.0+0x28>
        panic("kfree");
801071ec:	83 ec 0c             	sub    $0xc,%esp
801071ef:	68 de 7d 10 80       	push   $0x80107dde
801071f4:	e8 87 91 ff ff       	call   80100380 <panic>
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107200 <mappages>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107206:	89 d3                	mov    %edx,%ebx
80107208:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010720e:	83 ec 1c             	sub    $0x1c,%esp
80107211:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107214:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010721d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107220:	8b 45 08             	mov    0x8(%ebp),%eax
80107223:	29 d8                	sub    %ebx,%eax
80107225:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107228:	eb 3d                	jmp    80107267 <mappages+0x67>
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107230:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107232:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107237:	c1 ea 0a             	shr    $0xa,%edx
8010723a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107240:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107247:	85 c0                	test   %eax,%eax
80107249:	74 75                	je     801072c0 <mappages+0xc0>
    if(*pte & PTE_P)
8010724b:	f6 00 01             	testb  $0x1,(%eax)
8010724e:	0f 85 86 00 00 00    	jne    801072da <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107254:	0b 75 0c             	or     0xc(%ebp),%esi
80107257:	83 ce 01             	or     $0x1,%esi
8010725a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010725c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010725f:	74 6f                	je     801072d0 <mappages+0xd0>
    a += PGSIZE;
80107261:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010726a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010726d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107270:	89 d8                	mov    %ebx,%eax
80107272:	c1 e8 16             	shr    $0x16,%eax
80107275:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107278:	8b 07                	mov    (%edi),%eax
8010727a:	a8 01                	test   $0x1,%al
8010727c:	75 b2                	jne    80107230 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010727e:	e8 bd b8 ff ff       	call   80102b40 <kalloc>
80107283:	85 c0                	test   %eax,%eax
80107285:	74 39                	je     801072c0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107287:	83 ec 04             	sub    $0x4,%esp
8010728a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010728d:	68 00 10 00 00       	push   $0x1000
80107292:	6a 00                	push   $0x0
80107294:	50                   	push   %eax
80107295:	e8 06 dc ff ff       	call   80104ea0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010729a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010729d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072a0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801072a6:	83 c8 07             	or     $0x7,%eax
801072a9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801072ab:	89 d8                	mov    %ebx,%eax
801072ad:	c1 e8 0a             	shr    $0xa,%eax
801072b0:	25 fc 0f 00 00       	and    $0xffc,%eax
801072b5:	01 d0                	add    %edx,%eax
801072b7:	eb 92                	jmp    8010724b <mappages+0x4b>
801072b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072c8:	5b                   	pop    %ebx
801072c9:	5e                   	pop    %esi
801072ca:	5f                   	pop    %edi
801072cb:	5d                   	pop    %ebp
801072cc:	c3                   	ret    
801072cd:	8d 76 00             	lea    0x0(%esi),%esi
801072d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072d3:	31 c0                	xor    %eax,%eax
}
801072d5:	5b                   	pop    %ebx
801072d6:	5e                   	pop    %esi
801072d7:	5f                   	pop    %edi
801072d8:	5d                   	pop    %ebp
801072d9:	c3                   	ret    
      panic("remap");
801072da:	83 ec 0c             	sub    $0xc,%esp
801072dd:	68 98 84 10 80       	push   $0x80108498
801072e2:	e8 99 90 ff ff       	call   80100380 <panic>
801072e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ee:	66 90                	xchg   %ax,%ax

801072f0 <seginit>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801072f6:	e8 15 cb ff ff       	call   80103e10 <cpuid>
  pd[0] = size-1;
801072fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107300:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107306:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010730a:	c7 80 38 2a 11 80 ff 	movl   $0xffff,-0x7feed5c8(%eax)
80107311:	ff 00 00 
80107314:	c7 80 3c 2a 11 80 00 	movl   $0xcf9a00,-0x7feed5c4(%eax)
8010731b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010731e:	c7 80 40 2a 11 80 ff 	movl   $0xffff,-0x7feed5c0(%eax)
80107325:	ff 00 00 
80107328:	c7 80 44 2a 11 80 00 	movl   $0xcf9200,-0x7feed5bc(%eax)
8010732f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107332:	c7 80 48 2a 11 80 ff 	movl   $0xffff,-0x7feed5b8(%eax)
80107339:	ff 00 00 
8010733c:	c7 80 4c 2a 11 80 00 	movl   $0xcffa00,-0x7feed5b4(%eax)
80107343:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107346:	c7 80 50 2a 11 80 ff 	movl   $0xffff,-0x7feed5b0(%eax)
8010734d:	ff 00 00 
80107350:	c7 80 54 2a 11 80 00 	movl   $0xcff200,-0x7feed5ac(%eax)
80107357:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010735a:	05 30 2a 11 80       	add    $0x80112a30,%eax
  pd[1] = (uint)p;
8010735f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107363:	c1 e8 10             	shr    $0x10,%eax
80107366:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010736a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010736d:	0f 01 10             	lgdtl  (%eax)
}
80107370:	c9                   	leave  
80107371:	c3                   	ret    
80107372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107380 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107380:	a1 a4 ed 12 80       	mov    0x8012eda4,%eax
80107385:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010738a:	0f 22 d8             	mov    %eax,%cr3
}
8010738d:	c3                   	ret    
8010738e:	66 90                	xchg   %ax,%ax

80107390 <switchuvm>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 1c             	sub    $0x1c,%esp
80107399:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010739c:	85 f6                	test   %esi,%esi
8010739e:	0f 84 cb 00 00 00    	je     8010746f <switchuvm+0xdf>
  if(p->kstack == 0)
801073a4:	8b 46 08             	mov    0x8(%esi),%eax
801073a7:	85 c0                	test   %eax,%eax
801073a9:	0f 84 da 00 00 00    	je     80107489 <switchuvm+0xf9>
  if(p->pgdir == 0)
801073af:	8b 46 04             	mov    0x4(%esi),%eax
801073b2:	85 c0                	test   %eax,%eax
801073b4:	0f 84 c2 00 00 00    	je     8010747c <switchuvm+0xec>
  pushcli();
801073ba:	e8 d1 d8 ff ff       	call   80104c90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073bf:	e8 ec c9 ff ff       	call   80103db0 <mycpu>
801073c4:	89 c3                	mov    %eax,%ebx
801073c6:	e8 e5 c9 ff ff       	call   80103db0 <mycpu>
801073cb:	89 c7                	mov    %eax,%edi
801073cd:	e8 de c9 ff ff       	call   80103db0 <mycpu>
801073d2:	83 c7 08             	add    $0x8,%edi
801073d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073d8:	e8 d3 c9 ff ff       	call   80103db0 <mycpu>
801073dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801073e0:	ba 67 00 00 00       	mov    $0x67,%edx
801073e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801073ec:	83 c0 08             	add    $0x8,%eax
801073ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073fb:	83 c1 08             	add    $0x8,%ecx
801073fe:	c1 e8 18             	shr    $0x18,%eax
80107401:	c1 e9 10             	shr    $0x10,%ecx
80107404:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010740a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107410:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107415:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010741c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107421:	e8 8a c9 ff ff       	call   80103db0 <mycpu>
80107426:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010742d:	e8 7e c9 ff ff       	call   80103db0 <mycpu>
80107432:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107436:	8b 5e 08             	mov    0x8(%esi),%ebx
80107439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010743f:	e8 6c c9 ff ff       	call   80103db0 <mycpu>
80107444:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107447:	e8 64 c9 ff ff       	call   80103db0 <mycpu>
8010744c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107450:	b8 28 00 00 00       	mov    $0x28,%eax
80107455:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107458:	8b 46 04             	mov    0x4(%esi),%eax
8010745b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107460:	0f 22 d8             	mov    %eax,%cr3
}
80107463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107466:	5b                   	pop    %ebx
80107467:	5e                   	pop    %esi
80107468:	5f                   	pop    %edi
80107469:	5d                   	pop    %ebp
  popcli();
8010746a:	e9 71 d8 ff ff       	jmp    80104ce0 <popcli>
    panic("switchuvm: no process");
8010746f:	83 ec 0c             	sub    $0xc,%esp
80107472:	68 9e 84 10 80       	push   $0x8010849e
80107477:	e8 04 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010747c:	83 ec 0c             	sub    $0xc,%esp
8010747f:	68 c9 84 10 80       	push   $0x801084c9
80107484:	e8 f7 8e ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107489:	83 ec 0c             	sub    $0xc,%esp
8010748c:	68 b4 84 10 80       	push   $0x801084b4
80107491:	e8 ea 8e ff ff       	call   80100380 <panic>
80107496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749d:	8d 76 00             	lea    0x0(%esi),%esi

801074a0 <inituvm>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
801074a6:	83 ec 1c             	sub    $0x1c,%esp
801074a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074ac:	8b 75 10             	mov    0x10(%ebp),%esi
801074af:	8b 7d 08             	mov    0x8(%ebp),%edi
801074b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801074b5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074bb:	77 4b                	ja     80107508 <inituvm+0x68>
  mem = kalloc();
801074bd:	e8 7e b6 ff ff       	call   80102b40 <kalloc>
  memset(mem, 0, PGSIZE);
801074c2:	83 ec 04             	sub    $0x4,%esp
801074c5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801074ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801074cc:	6a 00                	push   $0x0
801074ce:	50                   	push   %eax
801074cf:	e8 cc d9 ff ff       	call   80104ea0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801074d4:	58                   	pop    %eax
801074d5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074db:	5a                   	pop    %edx
801074dc:	6a 06                	push   $0x6
801074de:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074e3:	31 d2                	xor    %edx,%edx
801074e5:	50                   	push   %eax
801074e6:	89 f8                	mov    %edi,%eax
801074e8:	e8 13 fd ff ff       	call   80107200 <mappages>
  memmove(mem, init, sz);
801074ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074f0:	89 75 10             	mov    %esi,0x10(%ebp)
801074f3:	83 c4 10             	add    $0x10,%esp
801074f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801074f9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801074fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ff:	5b                   	pop    %ebx
80107500:	5e                   	pop    %esi
80107501:	5f                   	pop    %edi
80107502:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107503:	e9 38 da ff ff       	jmp    80104f40 <memmove>
    panic("inituvm: more than a page");
80107508:	83 ec 0c             	sub    $0xc,%esp
8010750b:	68 dd 84 10 80       	push   $0x801084dd
80107510:	e8 6b 8e ff ff       	call   80100380 <panic>
80107515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107520 <loaduvm>:
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 1c             	sub    $0x1c,%esp
80107529:	8b 45 0c             	mov    0xc(%ebp),%eax
8010752c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010752f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107534:	0f 85 bb 00 00 00    	jne    801075f5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010753a:	01 f0                	add    %esi,%eax
8010753c:	89 f3                	mov    %esi,%ebx
8010753e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107541:	8b 45 14             	mov    0x14(%ebp),%eax
80107544:	01 f0                	add    %esi,%eax
80107546:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107549:	85 f6                	test   %esi,%esi
8010754b:	0f 84 87 00 00 00    	je     801075d8 <loaduvm+0xb8>
80107551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010755b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010755e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107560:	89 c2                	mov    %eax,%edx
80107562:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107565:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107568:	f6 c2 01             	test   $0x1,%dl
8010756b:	75 13                	jne    80107580 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010756d:	83 ec 0c             	sub    $0xc,%esp
80107570:	68 f7 84 10 80       	push   $0x801084f7
80107575:	e8 06 8e ff ff       	call   80100380 <panic>
8010757a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107580:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107583:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107589:	25 fc 0f 00 00       	and    $0xffc,%eax
8010758e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107595:	85 c0                	test   %eax,%eax
80107597:	74 d4                	je     8010756d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107599:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010759b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010759e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801075a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801075ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075b1:	29 d9                	sub    %ebx,%ecx
801075b3:	05 00 00 00 80       	add    $0x80000000,%eax
801075b8:	57                   	push   %edi
801075b9:	51                   	push   %ecx
801075ba:	50                   	push   %eax
801075bb:	ff 75 10             	push   0x10(%ebp)
801075be:	e8 8d a9 ff ff       	call   80101f50 <readi>
801075c3:	83 c4 10             	add    $0x10,%esp
801075c6:	39 f8                	cmp    %edi,%eax
801075c8:	75 1e                	jne    801075e8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801075ca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801075d0:	89 f0                	mov    %esi,%eax
801075d2:	29 d8                	sub    %ebx,%eax
801075d4:	39 c6                	cmp    %eax,%esi
801075d6:	77 80                	ja     80107558 <loaduvm+0x38>
}
801075d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075db:	31 c0                	xor    %eax,%eax
}
801075dd:	5b                   	pop    %ebx
801075de:	5e                   	pop    %esi
801075df:	5f                   	pop    %edi
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret    
801075e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075f0:	5b                   	pop    %ebx
801075f1:	5e                   	pop    %esi
801075f2:	5f                   	pop    %edi
801075f3:	5d                   	pop    %ebp
801075f4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801075f5:	83 ec 0c             	sub    $0xc,%esp
801075f8:	68 98 85 10 80       	push   $0x80108598
801075fd:	e8 7e 8d ff ff       	call   80100380 <panic>
80107602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107610 <allocuvm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107619:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010761c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010761f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107622:	85 c0                	test   %eax,%eax
80107624:	0f 88 b6 00 00 00    	js     801076e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010762a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010762d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107630:	0f 82 9a 00 00 00    	jb     801076d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107636:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010763c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107642:	39 75 10             	cmp    %esi,0x10(%ebp)
80107645:	77 44                	ja     8010768b <allocuvm+0x7b>
80107647:	e9 87 00 00 00       	jmp    801076d3 <allocuvm+0xc3>
8010764c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107650:	83 ec 04             	sub    $0x4,%esp
80107653:	68 00 10 00 00       	push   $0x1000
80107658:	6a 00                	push   $0x0
8010765a:	50                   	push   %eax
8010765b:	e8 40 d8 ff ff       	call   80104ea0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107660:	58                   	pop    %eax
80107661:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107667:	5a                   	pop    %edx
80107668:	6a 06                	push   $0x6
8010766a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010766f:	89 f2                	mov    %esi,%edx
80107671:	50                   	push   %eax
80107672:	89 f8                	mov    %edi,%eax
80107674:	e8 87 fb ff ff       	call   80107200 <mappages>
80107679:	83 c4 10             	add    $0x10,%esp
8010767c:	85 c0                	test   %eax,%eax
8010767e:	78 78                	js     801076f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107680:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107686:	39 75 10             	cmp    %esi,0x10(%ebp)
80107689:	76 48                	jbe    801076d3 <allocuvm+0xc3>
    mem = kalloc();
8010768b:	e8 b0 b4 ff ff       	call   80102b40 <kalloc>
80107690:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107692:	85 c0                	test   %eax,%eax
80107694:	75 ba                	jne    80107650 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107696:	83 ec 0c             	sub    $0xc,%esp
80107699:	68 15 85 10 80       	push   $0x80108515
8010769e:	e8 fd 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801076a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801076a6:	83 c4 10             	add    $0x10,%esp
801076a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801076ac:	74 32                	je     801076e0 <allocuvm+0xd0>
801076ae:	8b 55 10             	mov    0x10(%ebp),%edx
801076b1:	89 c1                	mov    %eax,%ecx
801076b3:	89 f8                	mov    %edi,%eax
801076b5:	e8 96 fa ff ff       	call   80107150 <deallocuvm.part.0>
      return 0;
801076ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c7:	5b                   	pop    %ebx
801076c8:	5e                   	pop    %esi
801076c9:	5f                   	pop    %edi
801076ca:	5d                   	pop    %ebp
801076cb:	c3                   	ret    
801076cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801076d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801076d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d9:	5b                   	pop    %ebx
801076da:	5e                   	pop    %esi
801076db:	5f                   	pop    %edi
801076dc:	5d                   	pop    %ebp
801076dd:	c3                   	ret    
801076de:	66 90                	xchg   %ax,%ax
    return 0;
801076e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ed:	5b                   	pop    %ebx
801076ee:	5e                   	pop    %esi
801076ef:	5f                   	pop    %edi
801076f0:	5d                   	pop    %ebp
801076f1:	c3                   	ret    
801076f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801076f8:	83 ec 0c             	sub    $0xc,%esp
801076fb:	68 2d 85 10 80       	push   $0x8010852d
80107700:	e8 9b 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107705:	8b 45 0c             	mov    0xc(%ebp),%eax
80107708:	83 c4 10             	add    $0x10,%esp
8010770b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010770e:	74 0c                	je     8010771c <allocuvm+0x10c>
80107710:	8b 55 10             	mov    0x10(%ebp),%edx
80107713:	89 c1                	mov    %eax,%ecx
80107715:	89 f8                	mov    %edi,%eax
80107717:	e8 34 fa ff ff       	call   80107150 <deallocuvm.part.0>
      kfree(mem);
8010771c:	83 ec 0c             	sub    $0xc,%esp
8010771f:	53                   	push   %ebx
80107720:	e8 5b b2 ff ff       	call   80102980 <kfree>
      return 0;
80107725:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010772c:	83 c4 10             	add    $0x10,%esp
}
8010772f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107732:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107735:	5b                   	pop    %ebx
80107736:	5e                   	pop    %esi
80107737:	5f                   	pop    %edi
80107738:	5d                   	pop    %ebp
80107739:	c3                   	ret    
8010773a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107740 <deallocuvm>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	8b 55 0c             	mov    0xc(%ebp),%edx
80107746:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107749:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010774c:	39 d1                	cmp    %edx,%ecx
8010774e:	73 10                	jae    80107760 <deallocuvm+0x20>
}
80107750:	5d                   	pop    %ebp
80107751:	e9 fa f9 ff ff       	jmp    80107150 <deallocuvm.part.0>
80107756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010775d:	8d 76 00             	lea    0x0(%esi),%esi
80107760:	89 d0                	mov    %edx,%eax
80107762:	5d                   	pop    %ebp
80107763:	c3                   	ret    
80107764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010776b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010776f:	90                   	nop

80107770 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	57                   	push   %edi
80107774:	56                   	push   %esi
80107775:	53                   	push   %ebx
80107776:	83 ec 0c             	sub    $0xc,%esp
80107779:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010777c:	85 f6                	test   %esi,%esi
8010777e:	74 59                	je     801077d9 <freevm+0x69>
  if(newsz >= oldsz)
80107780:	31 c9                	xor    %ecx,%ecx
80107782:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107787:	89 f0                	mov    %esi,%eax
80107789:	89 f3                	mov    %esi,%ebx
8010778b:	e8 c0 f9 ff ff       	call   80107150 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107790:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107796:	eb 0f                	jmp    801077a7 <freevm+0x37>
80107798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779f:	90                   	nop
801077a0:	83 c3 04             	add    $0x4,%ebx
801077a3:	39 df                	cmp    %ebx,%edi
801077a5:	74 23                	je     801077ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077a7:	8b 03                	mov    (%ebx),%eax
801077a9:	a8 01                	test   $0x1,%al
801077ab:	74 f3                	je     801077a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801077b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801077bd:	50                   	push   %eax
801077be:	e8 bd b1 ff ff       	call   80102980 <kfree>
801077c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077c6:	39 df                	cmp    %ebx,%edi
801077c8:	75 dd                	jne    801077a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801077ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d0:	5b                   	pop    %ebx
801077d1:	5e                   	pop    %esi
801077d2:	5f                   	pop    %edi
801077d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801077d4:	e9 a7 b1 ff ff       	jmp    80102980 <kfree>
    panic("freevm: no pgdir");
801077d9:	83 ec 0c             	sub    $0xc,%esp
801077dc:	68 49 85 10 80       	push   $0x80108549
801077e1:	e8 9a 8b ff ff       	call   80100380 <panic>
801077e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ed:	8d 76 00             	lea    0x0(%esi),%esi

801077f0 <setupkvm>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	56                   	push   %esi
801077f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077f5:	e8 46 b3 ff ff       	call   80102b40 <kalloc>
801077fa:	89 c6                	mov    %eax,%esi
801077fc:	85 c0                	test   %eax,%eax
801077fe:	74 42                	je     80107842 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107800:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107803:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107808:	68 00 10 00 00       	push   $0x1000
8010780d:	6a 00                	push   $0x0
8010780f:	50                   	push   %eax
80107810:	e8 8b d6 ff ff       	call   80104ea0 <memset>
80107815:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107818:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010781b:	83 ec 08             	sub    $0x8,%esp
8010781e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107821:	ff 73 0c             	push   0xc(%ebx)
80107824:	8b 13                	mov    (%ebx),%edx
80107826:	50                   	push   %eax
80107827:	29 c1                	sub    %eax,%ecx
80107829:	89 f0                	mov    %esi,%eax
8010782b:	e8 d0 f9 ff ff       	call   80107200 <mappages>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	78 19                	js     80107850 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107837:	83 c3 10             	add    $0x10,%ebx
8010783a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107840:	75 d6                	jne    80107818 <setupkvm+0x28>
}
80107842:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107845:	89 f0                	mov    %esi,%eax
80107847:	5b                   	pop    %ebx
80107848:	5e                   	pop    %esi
80107849:	5d                   	pop    %ebp
8010784a:	c3                   	ret    
8010784b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010784f:	90                   	nop
      freevm(pgdir);
80107850:	83 ec 0c             	sub    $0xc,%esp
80107853:	56                   	push   %esi
      return 0;
80107854:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107856:	e8 15 ff ff ff       	call   80107770 <freevm>
      return 0;
8010785b:	83 c4 10             	add    $0x10,%esp
}
8010785e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107861:	89 f0                	mov    %esi,%eax
80107863:	5b                   	pop    %ebx
80107864:	5e                   	pop    %esi
80107865:	5d                   	pop    %ebp
80107866:	c3                   	ret    
80107867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786e:	66 90                	xchg   %ax,%ax

80107870 <kvmalloc>:
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107876:	e8 75 ff ff ff       	call   801077f0 <setupkvm>
8010787b:	a3 a4 ed 12 80       	mov    %eax,0x8012eda4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107880:	05 00 00 00 80       	add    $0x80000000,%eax
80107885:	0f 22 d8             	mov    %eax,%cr3
}
80107888:	c9                   	leave  
80107889:	c3                   	ret    
8010788a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107890 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	83 ec 08             	sub    $0x8,%esp
80107896:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107899:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010789c:	89 c1                	mov    %eax,%ecx
8010789e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078a4:	f6 c2 01             	test   $0x1,%dl
801078a7:	75 17                	jne    801078c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801078a9:	83 ec 0c             	sub    $0xc,%esp
801078ac:	68 5a 85 10 80       	push   $0x8010855a
801078b1:	e8 ca 8a ff ff       	call   80100380 <panic>
801078b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801078c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801078c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801078ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801078d5:	85 c0                	test   %eax,%eax
801078d7:	74 d0                	je     801078a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801078d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078dc:	c9                   	leave  
801078dd:	c3                   	ret    
801078de:	66 90                	xchg   %ax,%ax

801078e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801078e9:	e8 02 ff ff ff       	call   801077f0 <setupkvm>
801078ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078f1:	85 c0                	test   %eax,%eax
801078f3:	0f 84 bd 00 00 00    	je     801079b6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078fc:	85 c9                	test   %ecx,%ecx
801078fe:	0f 84 b2 00 00 00    	je     801079b6 <copyuvm+0xd6>
80107904:	31 f6                	xor    %esi,%esi
80107906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107910:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107913:	89 f0                	mov    %esi,%eax
80107915:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107918:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010791b:	a8 01                	test   $0x1,%al
8010791d:	75 11                	jne    80107930 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010791f:	83 ec 0c             	sub    $0xc,%esp
80107922:	68 64 85 10 80       	push   $0x80108564
80107927:	e8 54 8a ff ff       	call   80100380 <panic>
8010792c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107930:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107937:	c1 ea 0a             	shr    $0xa,%edx
8010793a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107940:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107947:	85 c0                	test   %eax,%eax
80107949:	74 d4                	je     8010791f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010794b:	8b 00                	mov    (%eax),%eax
8010794d:	a8 01                	test   $0x1,%al
8010794f:	0f 84 9f 00 00 00    	je     801079f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107955:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107957:	25 ff 0f 00 00       	and    $0xfff,%eax
8010795c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010795f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107965:	e8 d6 b1 ff ff       	call   80102b40 <kalloc>
8010796a:	89 c3                	mov    %eax,%ebx
8010796c:	85 c0                	test   %eax,%eax
8010796e:	74 64                	je     801079d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107970:	83 ec 04             	sub    $0x4,%esp
80107973:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107979:	68 00 10 00 00       	push   $0x1000
8010797e:	57                   	push   %edi
8010797f:	50                   	push   %eax
80107980:	e8 bb d5 ff ff       	call   80104f40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107985:	58                   	pop    %eax
80107986:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010798c:	5a                   	pop    %edx
8010798d:	ff 75 e4             	push   -0x1c(%ebp)
80107990:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107995:	89 f2                	mov    %esi,%edx
80107997:	50                   	push   %eax
80107998:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010799b:	e8 60 f8 ff ff       	call   80107200 <mappages>
801079a0:	83 c4 10             	add    $0x10,%esp
801079a3:	85 c0                	test   %eax,%eax
801079a5:	78 21                	js     801079c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801079a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
801079b0:	0f 87 5a ff ff ff    	ja     80107910 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801079b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bc:	5b                   	pop    %ebx
801079bd:	5e                   	pop    %esi
801079be:	5f                   	pop    %edi
801079bf:	5d                   	pop    %ebp
801079c0:	c3                   	ret    
801079c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801079c8:	83 ec 0c             	sub    $0xc,%esp
801079cb:	53                   	push   %ebx
801079cc:	e8 af af ff ff       	call   80102980 <kfree>
      goto bad;
801079d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801079d4:	83 ec 0c             	sub    $0xc,%esp
801079d7:	ff 75 e0             	push   -0x20(%ebp)
801079da:	e8 91 fd ff ff       	call   80107770 <freevm>
  return 0;
801079df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801079e6:	83 c4 10             	add    $0x10,%esp
}
801079e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ef:	5b                   	pop    %ebx
801079f0:	5e                   	pop    %esi
801079f1:	5f                   	pop    %edi
801079f2:	5d                   	pop    %ebp
801079f3:	c3                   	ret    
      panic("copyuvm: page not present");
801079f4:	83 ec 0c             	sub    $0xc,%esp
801079f7:	68 7e 85 10 80       	push   $0x8010857e
801079fc:	e8 7f 89 ff ff       	call   80100380 <panic>
80107a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0f:	90                   	nop

80107a10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107a16:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107a19:	89 c1                	mov    %eax,%ecx
80107a1b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107a1e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107a21:	f6 c2 01             	test   $0x1,%dl
80107a24:	0f 84 00 01 00 00    	je     80107b2a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107a2a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a2d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a33:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107a34:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107a39:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107a40:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a47:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a4a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a4f:	83 fa 05             	cmp    $0x5,%edx
80107a52:	ba 00 00 00 00       	mov    $0x0,%edx
80107a57:	0f 45 c2             	cmovne %edx,%eax
}
80107a5a:	c3                   	ret    
80107a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a5f:	90                   	nop

80107a60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	57                   	push   %edi
80107a64:	56                   	push   %esi
80107a65:	53                   	push   %ebx
80107a66:	83 ec 0c             	sub    $0xc,%esp
80107a69:	8b 75 14             	mov    0x14(%ebp),%esi
80107a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a6f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a72:	85 f6                	test   %esi,%esi
80107a74:	75 51                	jne    80107ac7 <copyout+0x67>
80107a76:	e9 a5 00 00 00       	jmp    80107b20 <copyout+0xc0>
80107a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a7f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107a80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a86:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107a8c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a92:	74 75                	je     80107b09 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a94:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a96:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a99:	29 c3                	sub    %eax,%ebx
80107a9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107aa1:	39 f3                	cmp    %esi,%ebx
80107aa3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107aa6:	29 f8                	sub    %edi,%eax
80107aa8:	83 ec 04             	sub    $0x4,%esp
80107aab:	01 c1                	add    %eax,%ecx
80107aad:	53                   	push   %ebx
80107aae:	52                   	push   %edx
80107aaf:	51                   	push   %ecx
80107ab0:	e8 8b d4 ff ff       	call   80104f40 <memmove>
    len -= n;
    buf += n;
80107ab5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107ab8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107abe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107ac1:	01 da                	add    %ebx,%edx
  while(len > 0){
80107ac3:	29 de                	sub    %ebx,%esi
80107ac5:	74 59                	je     80107b20 <copyout+0xc0>
  if(*pde & PTE_P){
80107ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107aca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107acc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107ace:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107ad1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107ad7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107ada:	f6 c1 01             	test   $0x1,%cl
80107add:	0f 84 4e 00 00 00    	je     80107b31 <copyout.cold>
  return &pgtab[PTX(va)];
80107ae3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ae5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107aeb:	c1 eb 0c             	shr    $0xc,%ebx
80107aee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107af4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107afb:	89 d9                	mov    %ebx,%ecx
80107afd:	83 e1 05             	and    $0x5,%ecx
80107b00:	83 f9 05             	cmp    $0x5,%ecx
80107b03:	0f 84 77 ff ff ff    	je     80107a80 <copyout+0x20>
  }
  return 0;
}
80107b09:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b11:	5b                   	pop    %ebx
80107b12:	5e                   	pop    %esi
80107b13:	5f                   	pop    %edi
80107b14:	5d                   	pop    %ebp
80107b15:	c3                   	ret    
80107b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b1d:	8d 76 00             	lea    0x0(%esi),%esi
80107b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b23:	31 c0                	xor    %eax,%eax
}
80107b25:	5b                   	pop    %ebx
80107b26:	5e                   	pop    %esi
80107b27:	5f                   	pop    %edi
80107b28:	5d                   	pop    %ebp
80107b29:	c3                   	ret    

80107b2a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107b2a:	a1 00 00 00 00       	mov    0x0,%eax
80107b2f:	0f 0b                	ud2    

80107b31 <copyout.cold>:
80107b31:	a1 00 00 00 00       	mov    0x0,%eax
80107b36:	0f 0b                	ud2    
