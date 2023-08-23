
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023a117          	auipc	sp,0x23a
    80000004:	c3010113          	addi	sp,sp,-976 # 80239c30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	157050ef          	jal	ra,8000596c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <ref_increase>:
} kmem;

// solution: 

void
ref_increase(void* pa){
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
    80000026:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000028:	00009517          	auipc	a0,0x9
    8000002c:	89850513          	addi	a0,a0,-1896 # 800088c0 <kmem>
    80000030:	00006097          	auipc	ra,0x6
    80000034:	33c080e7          	jalr	828(ra) # 8000636c <acquire>
  kmem.ref[(uint64)pa/PGSIZE]++;
    80000038:	00c4d793          	srli	a5,s1,0xc
    8000003c:	00009517          	auipc	a0,0x9
    80000040:	88450513          	addi	a0,a0,-1916 # 800088c0 <kmem>
    80000044:	07a1                	addi	a5,a5,8
    80000046:	078a                	slli	a5,a5,0x2
    80000048:	97aa                	add	a5,a5,a0
    8000004a:	4398                	lw	a4,0(a5)
    8000004c:	2705                	addiw	a4,a4,1
    8000004e:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000050:	00006097          	auipc	ra,0x6
    80000054:	3d0080e7          	jalr	976(ra) # 80006420 <release>
}
    80000058:	60e2                	ld	ra,24(sp)
    8000005a:	6442                	ld	s0,16(sp)
    8000005c:	64a2                	ld	s1,8(sp)
    8000005e:	6105                	addi	sp,sp,32
    80000060:	8082                	ret

0000000080000062 <ref_decrease>:

void
ref_decrease(void* pa){
    80000062:	1101                	addi	sp,sp,-32
    80000064:	ec06                	sd	ra,24(sp)
    80000066:	e822                	sd	s0,16(sp)
    80000068:	e426                	sd	s1,8(sp)
    8000006a:	1000                	addi	s0,sp,32
    8000006c:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    8000006e:	00009517          	auipc	a0,0x9
    80000072:	85250513          	addi	a0,a0,-1966 # 800088c0 <kmem>
    80000076:	00006097          	auipc	ra,0x6
    8000007a:	2f6080e7          	jalr	758(ra) # 8000636c <acquire>
  kmem.ref[(uint64)pa/PGSIZE]--;
    8000007e:	00c4d793          	srli	a5,s1,0xc
    80000082:	00009517          	auipc	a0,0x9
    80000086:	83e50513          	addi	a0,a0,-1986 # 800088c0 <kmem>
    8000008a:	07a1                	addi	a5,a5,8
    8000008c:	078a                	slli	a5,a5,0x2
    8000008e:	97aa                	add	a5,a5,a0
    80000090:	4398                	lw	a4,0(a5)
    80000092:	377d                	addiw	a4,a4,-1
    80000094:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000096:	00006097          	auipc	ra,0x6
    8000009a:	38a080e7          	jalr	906(ra) # 80006420 <release>
}
    8000009e:	60e2                	ld	ra,24(sp)
    800000a0:	6442                	ld	s0,16(sp)
    800000a2:	64a2                	ld	s1,8(sp)
    800000a4:	6105                	addi	sp,sp,32
    800000a6:	8082                	ret

00000000800000a8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800000a8:	1101                	addi	sp,sp,-32
    800000aa:	ec06                	sd	ra,24(sp)
    800000ac:	e822                	sd	s0,16(sp)
    800000ae:	e426                	sd	s1,8(sp)
    800000b0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800000b2:	03451793          	slli	a5,a0,0x34
    800000b6:	e3ad                	bnez	a5,80000118 <kfree+0x70>
    800000b8:	84aa                	mv	s1,a0
    800000ba:	00242797          	auipc	a5,0x242
    800000be:	c7678793          	addi	a5,a5,-906 # 80241d30 <end>
    800000c2:	04f56b63          	bltu	a0,a5,80000118 <kfree+0x70>
    800000c6:	47c5                	li	a5,17
    800000c8:	07ee                	slli	a5,a5,0x1b
    800000ca:	04f57763          	bgeu	a0,a5,80000118 <kfree+0x70>
    panic("kfree");

  // solution: ref decrease
  acquire(&kmem.lock);
    800000ce:	00008517          	auipc	a0,0x8
    800000d2:	7f250513          	addi	a0,a0,2034 # 800088c0 <kmem>
    800000d6:	00006097          	auipc	ra,0x6
    800000da:	296080e7          	jalr	662(ra) # 8000636c <acquire>
  kmem.ref[(uint64)pa/PGSIZE]--;
    800000de:	00c4d793          	srli	a5,s1,0xc
    800000e2:	07a1                	addi	a5,a5,8
    800000e4:	078a                	slli	a5,a5,0x2
    800000e6:	00008717          	auipc	a4,0x8
    800000ea:	7da70713          	addi	a4,a4,2010 # 800088c0 <kmem>
    800000ee:	97ba                	add	a5,a5,a4
    800000f0:	4398                	lw	a4,0(a5)
    800000f2:	377d                	addiw	a4,a4,-1
    800000f4:	0007069b          	sext.w	a3,a4
    800000f8:	c398                	sw	a4,0(a5)
  if(kmem.ref[(uint64)pa/PGSIZE] <= 0){
    800000fa:	02d05763          	blez	a3,80000128 <kfree+0x80>
    r = (struct run*)pa;

    r->next = kmem.freelist;
    kmem.freelist = r;
  }
  release(&kmem.lock);
    800000fe:	00008517          	auipc	a0,0x8
    80000102:	7c250513          	addi	a0,a0,1986 # 800088c0 <kmem>
    80000106:	00006097          	auipc	ra,0x6
    8000010a:	31a080e7          	jalr	794(ra) # 80006420 <release>
}
    8000010e:	60e2                	ld	ra,24(sp)
    80000110:	6442                	ld	s0,16(sp)
    80000112:	64a2                	ld	s1,8(sp)
    80000114:	6105                	addi	sp,sp,32
    80000116:	8082                	ret
    panic("kfree");
    80000118:	00008517          	auipc	a0,0x8
    8000011c:	ef850513          	addi	a0,a0,-264 # 80008010 <etext+0x10>
    80000120:	00006097          	auipc	ra,0x6
    80000124:	d02080e7          	jalr	-766(ra) # 80005e22 <panic>
    memset(pa, 1, PGSIZE);
    80000128:	6605                	lui	a2,0x1
    8000012a:	4585                	li	a1,1
    8000012c:	8526                	mv	a0,s1
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	23c080e7          	jalr	572(ra) # 8000036a <memset>
    r->next = kmem.freelist;
    80000136:	00008797          	auipc	a5,0x8
    8000013a:	78a78793          	addi	a5,a5,1930 # 800088c0 <kmem>
    8000013e:	6f98                	ld	a4,24(a5)
    80000140:	e098                	sd	a4,0(s1)
    kmem.freelist = r;
    80000142:	ef84                	sd	s1,24(a5)
    80000144:	bf6d                	j	800000fe <kfree+0x56>

0000000080000146 <freerange>:
{
    80000146:	7139                	addi	sp,sp,-64
    80000148:	fc06                	sd	ra,56(sp)
    8000014a:	f822                	sd	s0,48(sp)
    8000014c:	f426                	sd	s1,40(sp)
    8000014e:	f04a                	sd	s2,32(sp)
    80000150:	ec4e                	sd	s3,24(sp)
    80000152:	e852                	sd	s4,16(sp)
    80000154:	e456                	sd	s5,8(sp)
    80000156:	e05a                	sd	s6,0(sp)
    80000158:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000015a:	6785                	lui	a5,0x1
    8000015c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000160:	9526                	add	a0,a0,s1
    80000162:	74fd                	lui	s1,0xfffff
    80000164:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000166:	97a6                	add	a5,a5,s1
    80000168:	02f5eb63          	bltu	a1,a5,8000019e <freerange+0x58>
    8000016c:	892e                	mv	s2,a1
    kmem.ref[(uint64)p / PGSIZE]= 1;
    8000016e:	00008b17          	auipc	s6,0x8
    80000172:	752b0b13          	addi	s6,s6,1874 # 800088c0 <kmem>
    80000176:	4a85                	li	s5,1
    80000178:	6a05                	lui	s4,0x1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    8000017a:	6989                	lui	s3,0x2
    kmem.ref[(uint64)p / PGSIZE]= 1;
    8000017c:	00c4d793          	srli	a5,s1,0xc
    80000180:	07a1                	addi	a5,a5,8
    80000182:	078a                	slli	a5,a5,0x2
    80000184:	97da                	add	a5,a5,s6
    80000186:	0157a023          	sw	s5,0(a5)
    kfree(p);
    8000018a:	8526                	mv	a0,s1
    8000018c:	00000097          	auipc	ra,0x0
    80000190:	f1c080e7          	jalr	-228(ra) # 800000a8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000194:	87a6                	mv	a5,s1
    80000196:	94d2                	add	s1,s1,s4
    80000198:	97ce                	add	a5,a5,s3
    8000019a:	fef971e3          	bgeu	s2,a5,8000017c <freerange+0x36>
}
    8000019e:	70e2                	ld	ra,56(sp)
    800001a0:	7442                	ld	s0,48(sp)
    800001a2:	74a2                	ld	s1,40(sp)
    800001a4:	7902                	ld	s2,32(sp)
    800001a6:	69e2                	ld	s3,24(sp)
    800001a8:	6a42                	ld	s4,16(sp)
    800001aa:	6aa2                	ld	s5,8(sp)
    800001ac:	6b02                	ld	s6,0(sp)
    800001ae:	6121                	addi	sp,sp,64
    800001b0:	8082                	ret

00000000800001b2 <kinit>:
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001ba:	00008597          	auipc	a1,0x8
    800001be:	e5e58593          	addi	a1,a1,-418 # 80008018 <etext+0x18>
    800001c2:	00008517          	auipc	a0,0x8
    800001c6:	6fe50513          	addi	a0,a0,1790 # 800088c0 <kmem>
    800001ca:	00006097          	auipc	ra,0x6
    800001ce:	112080e7          	jalr	274(ra) # 800062dc <initlock>
  freerange(end, (void*)PHYSTOP);
    800001d2:	45c5                	li	a1,17
    800001d4:	05ee                	slli	a1,a1,0x1b
    800001d6:	00242517          	auipc	a0,0x242
    800001da:	b5a50513          	addi	a0,a0,-1190 # 80241d30 <end>
    800001de:	00000097          	auipc	ra,0x0
    800001e2:	f68080e7          	jalr	-152(ra) # 80000146 <freerange>
}
    800001e6:	60a2                	ld	ra,8(sp)
    800001e8:	6402                	ld	s0,0(sp)
    800001ea:	0141                	addi	sp,sp,16
    800001ec:	8082                	ret

00000000800001ee <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001ee:	1101                	addi	sp,sp,-32
    800001f0:	ec06                	sd	ra,24(sp)
    800001f2:	e822                	sd	s0,16(sp)
    800001f4:	e426                	sd	s1,8(sp)
    800001f6:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001f8:	00008517          	auipc	a0,0x8
    800001fc:	6c850513          	addi	a0,a0,1736 # 800088c0 <kmem>
    80000200:	00006097          	auipc	ra,0x6
    80000204:	16c080e7          	jalr	364(ra) # 8000636c <acquire>
  r = kmem.freelist;
    80000208:	00008497          	auipc	s1,0x8
    8000020c:	6d04b483          	ld	s1,1744(s1) # 800088d8 <kmem+0x18>
  if(r){
    80000210:	cc9d                	beqz	s1,8000024e <kalloc+0x60>
    kmem.freelist = r->next;
    80000212:	609c                	ld	a5,0(s1)
    80000214:	00008517          	auipc	a0,0x8
    80000218:	6ac50513          	addi	a0,a0,1708 # 800088c0 <kmem>
    8000021c:	ed1c                	sd	a5,24(a0)
    kmem.ref[(uint64)r/PGSIZE] = 1;// solution
    8000021e:	00c4d793          	srli	a5,s1,0xc
    80000222:	07a1                	addi	a5,a5,8
    80000224:	078a                	slli	a5,a5,0x2
    80000226:	97aa                	add	a5,a5,a0
    80000228:	4705                	li	a4,1
    8000022a:	c398                	sw	a4,0(a5)
  }
  release(&kmem.lock);
    8000022c:	00006097          	auipc	ra,0x6
    80000230:	1f4080e7          	jalr	500(ra) # 80006420 <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000234:	6605                	lui	a2,0x1
    80000236:	4595                	li	a1,5
    80000238:	8526                	mv	a0,s1
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	130080e7          	jalr	304(ra) # 8000036a <memset>
  }
  return (void*)r;
}
    80000242:	8526                	mv	a0,s1
    80000244:	60e2                	ld	ra,24(sp)
    80000246:	6442                	ld	s0,16(sp)
    80000248:	64a2                	ld	s1,8(sp)
    8000024a:	6105                	addi	sp,sp,32
    8000024c:	8082                	ret
  release(&kmem.lock);
    8000024e:	00008517          	auipc	a0,0x8
    80000252:	67250513          	addi	a0,a0,1650 # 800088c0 <kmem>
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	1ca080e7          	jalr	458(ra) # 80006420 <release>
  if(r){
    8000025e:	b7d5                	j	80000242 <kalloc+0x54>

0000000080000260 <cow_alloc>:
cow_alloc(pagetable_t pagetable, uint64 va){
    80000260:	7179                	addi	sp,sp,-48
    80000262:	f406                	sd	ra,40(sp)
    80000264:	f022                	sd	s0,32(sp)
    80000266:	ec26                	sd	s1,24(sp)
    80000268:	e84a                	sd	s2,16(sp)
    8000026a:	e44e                	sd	s3,8(sp)
    8000026c:	e052                	sd	s4,0(sp)
    8000026e:	1800                	addi	s0,sp,48
  if(va >= MAXVA){
    80000270:	57fd                	li	a5,-1
    80000272:	83e9                	srli	a5,a5,0x1a
    80000274:	0cb7ef63          	bltu	a5,a1,80000352 <cow_alloc+0xf2>
  pte = walk(pagetable, va ,0);
    80000278:	4601                	li	a2,0
    8000027a:	77fd                	lui	a5,0xfffff
    8000027c:	8dfd                	and	a1,a1,a5
    8000027e:	00000097          	auipc	ra,0x0
    80000282:	3d8080e7          	jalr	984(ra) # 80000656 <walk>
    80000286:	89aa                	mv	s3,a0
  if(pte == 0){
    80000288:	c579                	beqz	a0,80000356 <cow_alloc+0xf6>
  }else if( !(*pte & PTE_V)){
    8000028a:	610c                	ld	a1,0(a0)
  }else if( !(*pte & PTE_U)){
    8000028c:	0115f713          	andi	a4,a1,17
    80000290:	47c5                	li	a5,17
    80000292:	0cf71463          	bne	a4,a5,8000035a <cow_alloc+0xfa>
  flags = PTE_FLAGS(*pte);
    80000296:	0005879b          	sext.w	a5,a1
  if(flags & PTE_W){
    8000029a:	0047f713          	andi	a4,a5,4
    8000029e:	00070a1b          	sext.w	s4,a4
    800002a2:	ef55                	bnez	a4,8000035e <cow_alloc+0xfe>
  }else if((flags & PTE_COW) == 0){
    800002a4:	1007f793          	andi	a5,a5,256
    800002a8:	cfcd                	beqz	a5,80000362 <cow_alloc+0x102>
  pa = PTE2PA(*pte);
    800002aa:	81a9                	srli	a1,a1,0xa
    800002ac:	00c59913          	slli	s2,a1,0xc
  acquire(&kmem.lock);
    800002b0:	00008517          	auipc	a0,0x8
    800002b4:	61050513          	addi	a0,a0,1552 # 800088c0 <kmem>
    800002b8:	00006097          	auipc	ra,0x6
    800002bc:	0b4080e7          	jalr	180(ra) # 8000636c <acquire>
  if(kmem.ref[pa/PGSIZE] == 1){
    800002c0:	00a95793          	srli	a5,s2,0xa
    800002c4:	00008717          	auipc	a4,0x8
    800002c8:	61c70713          	addi	a4,a4,1564 # 800088e0 <kmem+0x20>
    800002cc:	97ba                	add	a5,a5,a4
    800002ce:	4398                	lw	a4,0(a5)
    800002d0:	4785                	li	a5,1
    800002d2:	04f70f63          	beq	a4,a5,80000330 <cow_alloc+0xd0>
  release(&kmem.lock);
    800002d6:	00008517          	auipc	a0,0x8
    800002da:	5ea50513          	addi	a0,a0,1514 # 800088c0 <kmem>
    800002de:	00006097          	auipc	ra,0x6
    800002e2:	142080e7          	jalr	322(ra) # 80006420 <release>
  if( (mem=(uint64)kalloc()) == 0){
    800002e6:	00000097          	auipc	ra,0x0
    800002ea:	f08080e7          	jalr	-248(ra) # 800001ee <kalloc>
    800002ee:	84aa                	mv	s1,a0
    800002f0:	c93d                	beqz	a0,80000366 <cow_alloc+0x106>
  memmove((void*)mem, (void*)pa, PGSIZE);
    800002f2:	6605                	lui	a2,0x1
    800002f4:	85ca                	mv	a1,s2
    800002f6:	00000097          	auipc	ra,0x0
    800002fa:	0d4080e7          	jalr	212(ra) # 800003ca <memmove>
  *pte = ((PA2PTE(mem) | PTE_FLAGS(*pte) | PTE_W) & (~PTE_COW));
    800002fe:	80b1                	srli	s1,s1,0xc
    80000300:	04aa                	slli	s1,s1,0xa
    80000302:	0009b783          	ld	a5,0(s3) # 2000 <_entry-0x7fffe000>
    80000306:	2fb7f793          	andi	a5,a5,763
    8000030a:	8cdd                	or	s1,s1,a5
    8000030c:	0044e493          	ori	s1,s1,4
    80000310:	0099b023          	sd	s1,0(s3)
  kfree((void *)pa);
    80000314:	854a                	mv	a0,s2
    80000316:	00000097          	auipc	ra,0x0
    8000031a:	d92080e7          	jalr	-622(ra) # 800000a8 <kfree>
}
    8000031e:	8552                	mv	a0,s4
    80000320:	70a2                	ld	ra,40(sp)
    80000322:	7402                	ld	s0,32(sp)
    80000324:	64e2                	ld	s1,24(sp)
    80000326:	6942                	ld	s2,16(sp)
    80000328:	69a2                	ld	s3,8(sp)
    8000032a:	6a02                	ld	s4,0(sp)
    8000032c:	6145                	addi	sp,sp,48
    8000032e:	8082                	ret
    *pte &= ~PTE_COW;
    80000330:	0009b783          	ld	a5,0(s3)
    80000334:	eff7f793          	andi	a5,a5,-257
    *pte |= PTE_W;
    80000338:	0047e793          	ori	a5,a5,4
    8000033c:	00f9b023          	sd	a5,0(s3)
    release(&kmem.lock);
    80000340:	00008517          	auipc	a0,0x8
    80000344:	58050513          	addi	a0,a0,1408 # 800088c0 <kmem>
    80000348:	00006097          	auipc	ra,0x6
    8000034c:	0d8080e7          	jalr	216(ra) # 80006420 <release>
    return 0;
    80000350:	b7f9                	j	8000031e <cow_alloc+0xbe>
    return -1;
    80000352:	5a7d                	li	s4,-1
    80000354:	b7e9                	j	8000031e <cow_alloc+0xbe>
    return -1;
    80000356:	5a7d                	li	s4,-1
    80000358:	b7d9                	j	8000031e <cow_alloc+0xbe>
    return -1;
    8000035a:	5a7d                	li	s4,-1
    8000035c:	b7c9                	j	8000031e <cow_alloc+0xbe>
    return 0;
    8000035e:	4a01                	li	s4,0
    80000360:	bf7d                	j	8000031e <cow_alloc+0xbe>
    return -1;// without cow bit
    80000362:	5a7d                	li	s4,-1
    80000364:	bf6d                	j	8000031e <cow_alloc+0xbe>
    return -1;// out of memory
    80000366:	5a7d                	li	s4,-1
    80000368:	bf5d                	j	8000031e <cow_alloc+0xbe>

000000008000036a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e422                	sd	s0,8(sp)
    8000036e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000370:	ce09                	beqz	a2,8000038a <memset+0x20>
    80000372:	87aa                	mv	a5,a0
    80000374:	fff6071b          	addiw	a4,a2,-1
    80000378:	1702                	slli	a4,a4,0x20
    8000037a:	9301                	srli	a4,a4,0x20
    8000037c:	0705                	addi	a4,a4,1
    8000037e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000380:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7fdbd2d0>
  for(i = 0; i < n; i++){
    80000384:	0785                	addi	a5,a5,1
    80000386:	fee79de3          	bne	a5,a4,80000380 <memset+0x16>
  }
  return dst;
}
    8000038a:	6422                	ld	s0,8(sp)
    8000038c:	0141                	addi	sp,sp,16
    8000038e:	8082                	ret

0000000080000390 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000390:	1141                	addi	sp,sp,-16
    80000392:	e422                	sd	s0,8(sp)
    80000394:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000396:	ca05                	beqz	a2,800003c6 <memcmp+0x36>
    80000398:	fff6069b          	addiw	a3,a2,-1
    8000039c:	1682                	slli	a3,a3,0x20
    8000039e:	9281                	srli	a3,a3,0x20
    800003a0:	0685                	addi	a3,a3,1
    800003a2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800003a4:	00054783          	lbu	a5,0(a0)
    800003a8:	0005c703          	lbu	a4,0(a1)
    800003ac:	00e79863          	bne	a5,a4,800003bc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800003b0:	0505                	addi	a0,a0,1
    800003b2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800003b4:	fed518e3          	bne	a0,a3,800003a4 <memcmp+0x14>
  }

  return 0;
    800003b8:	4501                	li	a0,0
    800003ba:	a019                	j	800003c0 <memcmp+0x30>
      return *s1 - *s2;
    800003bc:	40e7853b          	subw	a0,a5,a4
}
    800003c0:	6422                	ld	s0,8(sp)
    800003c2:	0141                	addi	sp,sp,16
    800003c4:	8082                	ret
  return 0;
    800003c6:	4501                	li	a0,0
    800003c8:	bfe5                	j	800003c0 <memcmp+0x30>

00000000800003ca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e422                	sd	s0,8(sp)
    800003ce:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800003d0:	ca0d                	beqz	a2,80000402 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800003d2:	00a5f963          	bgeu	a1,a0,800003e4 <memmove+0x1a>
    800003d6:	02061693          	slli	a3,a2,0x20
    800003da:	9281                	srli	a3,a3,0x20
    800003dc:	00d58733          	add	a4,a1,a3
    800003e0:	02e56463          	bltu	a0,a4,80000408 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800003e4:	fff6079b          	addiw	a5,a2,-1
    800003e8:	1782                	slli	a5,a5,0x20
    800003ea:	9381                	srli	a5,a5,0x20
    800003ec:	0785                	addi	a5,a5,1
    800003ee:	97ae                	add	a5,a5,a1
    800003f0:	872a                	mv	a4,a0
      *d++ = *s++;
    800003f2:	0585                	addi	a1,a1,1
    800003f4:	0705                	addi	a4,a4,1
    800003f6:	fff5c683          	lbu	a3,-1(a1)
    800003fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800003fe:	fef59ae3          	bne	a1,a5,800003f2 <memmove+0x28>

  return dst;
}
    80000402:	6422                	ld	s0,8(sp)
    80000404:	0141                	addi	sp,sp,16
    80000406:	8082                	ret
    d += n;
    80000408:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000040a:	fff6079b          	addiw	a5,a2,-1
    8000040e:	1782                	slli	a5,a5,0x20
    80000410:	9381                	srli	a5,a5,0x20
    80000412:	fff7c793          	not	a5,a5
    80000416:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000418:	177d                	addi	a4,a4,-1
    8000041a:	16fd                	addi	a3,a3,-1
    8000041c:	00074603          	lbu	a2,0(a4)
    80000420:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000424:	fef71ae3          	bne	a4,a5,80000418 <memmove+0x4e>
    80000428:	bfe9                	j	80000402 <memmove+0x38>

000000008000042a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000042a:	1141                	addi	sp,sp,-16
    8000042c:	e406                	sd	ra,8(sp)
    8000042e:	e022                	sd	s0,0(sp)
    80000430:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000432:	00000097          	auipc	ra,0x0
    80000436:	f98080e7          	jalr	-104(ra) # 800003ca <memmove>
}
    8000043a:	60a2                	ld	ra,8(sp)
    8000043c:	6402                	ld	s0,0(sp)
    8000043e:	0141                	addi	sp,sp,16
    80000440:	8082                	ret

0000000080000442 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000442:	1141                	addi	sp,sp,-16
    80000444:	e422                	sd	s0,8(sp)
    80000446:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000448:	ce11                	beqz	a2,80000464 <strncmp+0x22>
    8000044a:	00054783          	lbu	a5,0(a0)
    8000044e:	cf89                	beqz	a5,80000468 <strncmp+0x26>
    80000450:	0005c703          	lbu	a4,0(a1)
    80000454:	00f71a63          	bne	a4,a5,80000468 <strncmp+0x26>
    n--, p++, q++;
    80000458:	367d                	addiw	a2,a2,-1
    8000045a:	0505                	addi	a0,a0,1
    8000045c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000045e:	f675                	bnez	a2,8000044a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000460:	4501                	li	a0,0
    80000462:	a809                	j	80000474 <strncmp+0x32>
    80000464:	4501                	li	a0,0
    80000466:	a039                	j	80000474 <strncmp+0x32>
  if(n == 0)
    80000468:	ca09                	beqz	a2,8000047a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000046a:	00054503          	lbu	a0,0(a0)
    8000046e:	0005c783          	lbu	a5,0(a1)
    80000472:	9d1d                	subw	a0,a0,a5
}
    80000474:	6422                	ld	s0,8(sp)
    80000476:	0141                	addi	sp,sp,16
    80000478:	8082                	ret
    return 0;
    8000047a:	4501                	li	a0,0
    8000047c:	bfe5                	j	80000474 <strncmp+0x32>

000000008000047e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000047e:	1141                	addi	sp,sp,-16
    80000480:	e422                	sd	s0,8(sp)
    80000482:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000484:	872a                	mv	a4,a0
    80000486:	8832                	mv	a6,a2
    80000488:	367d                	addiw	a2,a2,-1
    8000048a:	01005963          	blez	a6,8000049c <strncpy+0x1e>
    8000048e:	0705                	addi	a4,a4,1
    80000490:	0005c783          	lbu	a5,0(a1)
    80000494:	fef70fa3          	sb	a5,-1(a4)
    80000498:	0585                	addi	a1,a1,1
    8000049a:	f7f5                	bnez	a5,80000486 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000049c:	00c05d63          	blez	a2,800004b6 <strncpy+0x38>
    800004a0:	86ba                	mv	a3,a4
    *s++ = 0;
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800004a8:	fff6c793          	not	a5,a3
    800004ac:	9fb9                	addw	a5,a5,a4
    800004ae:	010787bb          	addw	a5,a5,a6
    800004b2:	fef048e3          	bgtz	a5,800004a2 <strncpy+0x24>
  return os;
}
    800004b6:	6422                	ld	s0,8(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800004bc:	1141                	addi	sp,sp,-16
    800004be:	e422                	sd	s0,8(sp)
    800004c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800004c2:	02c05363          	blez	a2,800004e8 <safestrcpy+0x2c>
    800004c6:	fff6069b          	addiw	a3,a2,-1
    800004ca:	1682                	slli	a3,a3,0x20
    800004cc:	9281                	srli	a3,a3,0x20
    800004ce:	96ae                	add	a3,a3,a1
    800004d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800004d2:	00d58963          	beq	a1,a3,800004e4 <safestrcpy+0x28>
    800004d6:	0585                	addi	a1,a1,1
    800004d8:	0785                	addi	a5,a5,1
    800004da:	fff5c703          	lbu	a4,-1(a1)
    800004de:	fee78fa3          	sb	a4,-1(a5)
    800004e2:	fb65                	bnez	a4,800004d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800004e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800004e8:	6422                	ld	s0,8(sp)
    800004ea:	0141                	addi	sp,sp,16
    800004ec:	8082                	ret

00000000800004ee <strlen>:

int
strlen(const char *s)
{
    800004ee:	1141                	addi	sp,sp,-16
    800004f0:	e422                	sd	s0,8(sp)
    800004f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800004f4:	00054783          	lbu	a5,0(a0)
    800004f8:	cf91                	beqz	a5,80000514 <strlen+0x26>
    800004fa:	0505                	addi	a0,a0,1
    800004fc:	87aa                	mv	a5,a0
    800004fe:	4685                	li	a3,1
    80000500:	9e89                	subw	a3,a3,a0
    80000502:	00f6853b          	addw	a0,a3,a5
    80000506:	0785                	addi	a5,a5,1
    80000508:	fff7c703          	lbu	a4,-1(a5)
    8000050c:	fb7d                	bnez	a4,80000502 <strlen+0x14>
    ;
  return n;
}
    8000050e:	6422                	ld	s0,8(sp)
    80000510:	0141                	addi	sp,sp,16
    80000512:	8082                	ret
  for(n = 0; s[n]; n++)
    80000514:	4501                	li	a0,0
    80000516:	bfe5                	j	8000050e <strlen+0x20>

0000000080000518 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000518:	1141                	addi	sp,sp,-16
    8000051a:	e406                	sd	ra,8(sp)
    8000051c:	e022                	sd	s0,0(sp)
    8000051e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000520:	00001097          	auipc	ra,0x1
    80000524:	b00080e7          	jalr	-1280(ra) # 80001020 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000528:	00008717          	auipc	a4,0x8
    8000052c:	36870713          	addi	a4,a4,872 # 80008890 <started>
  if(cpuid() == 0){
    80000530:	c139                	beqz	a0,80000576 <main+0x5e>
    while(started == 0)
    80000532:	431c                	lw	a5,0(a4)
    80000534:	2781                	sext.w	a5,a5
    80000536:	dff5                	beqz	a5,80000532 <main+0x1a>
      ;
    __sync_synchronize();
    80000538:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000053c:	00001097          	auipc	ra,0x1
    80000540:	ae4080e7          	jalr	-1308(ra) # 80001020 <cpuid>
    80000544:	85aa                	mv	a1,a0
    80000546:	00008517          	auipc	a0,0x8
    8000054a:	af250513          	addi	a0,a0,-1294 # 80008038 <etext+0x38>
    8000054e:	00006097          	auipc	ra,0x6
    80000552:	91e080e7          	jalr	-1762(ra) # 80005e6c <printf>
    kvminithart();    // turn on paging
    80000556:	00000097          	auipc	ra,0x0
    8000055a:	0d8080e7          	jalr	216(ra) # 8000062e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000055e:	00001097          	auipc	ra,0x1
    80000562:	786080e7          	jalr	1926(ra) # 80001ce4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000566:	00005097          	auipc	ra,0x5
    8000056a:	d5a080e7          	jalr	-678(ra) # 800052c0 <plicinithart>
  }

  scheduler();        
    8000056e:	00001097          	auipc	ra,0x1
    80000572:	fd0080e7          	jalr	-48(ra) # 8000153e <scheduler>
    consoleinit();
    80000576:	00005097          	auipc	ra,0x5
    8000057a:	7be080e7          	jalr	1982(ra) # 80005d34 <consoleinit>
    printfinit();
    8000057e:	00006097          	auipc	ra,0x6
    80000582:	ad4080e7          	jalr	-1324(ra) # 80006052 <printfinit>
    printf("\n");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ac250513          	addi	a0,a0,-1342 # 80008048 <etext+0x48>
    8000058e:	00006097          	auipc	ra,0x6
    80000592:	8de080e7          	jalr	-1826(ra) # 80005e6c <printf>
    printf("xv6 kernel is booting\n");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	a8a50513          	addi	a0,a0,-1398 # 80008020 <etext+0x20>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	8ce080e7          	jalr	-1842(ra) # 80005e6c <printf>
    printf("\n");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	aa250513          	addi	a0,a0,-1374 # 80008048 <etext+0x48>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	8be080e7          	jalr	-1858(ra) # 80005e6c <printf>
    kinit();         // physical page allocator
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	bfc080e7          	jalr	-1028(ra) # 800001b2 <kinit>
    kvminit();       // create kernel page table
    800005be:	00000097          	auipc	ra,0x0
    800005c2:	326080e7          	jalr	806(ra) # 800008e4 <kvminit>
    kvminithart();   // turn on paging
    800005c6:	00000097          	auipc	ra,0x0
    800005ca:	068080e7          	jalr	104(ra) # 8000062e <kvminithart>
    procinit();      // process table
    800005ce:	00001097          	auipc	ra,0x1
    800005d2:	99e080e7          	jalr	-1634(ra) # 80000f6c <procinit>
    trapinit();      // trap vectors
    800005d6:	00001097          	auipc	ra,0x1
    800005da:	6e6080e7          	jalr	1766(ra) # 80001cbc <trapinit>
    trapinithart();  // install kernel trap vector
    800005de:	00001097          	auipc	ra,0x1
    800005e2:	706080e7          	jalr	1798(ra) # 80001ce4 <trapinithart>
    plicinit();      // set up interrupt controller
    800005e6:	00005097          	auipc	ra,0x5
    800005ea:	cc4080e7          	jalr	-828(ra) # 800052aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800005ee:	00005097          	auipc	ra,0x5
    800005f2:	cd2080e7          	jalr	-814(ra) # 800052c0 <plicinithart>
    binit();         // buffer cache
    800005f6:	00002097          	auipc	ra,0x2
    800005fa:	e7e080e7          	jalr	-386(ra) # 80002474 <binit>
    iinit();         // inode table
    800005fe:	00002097          	auipc	ra,0x2
    80000602:	522080e7          	jalr	1314(ra) # 80002b20 <iinit>
    fileinit();      // file table
    80000606:	00003097          	auipc	ra,0x3
    8000060a:	4c0080e7          	jalr	1216(ra) # 80003ac6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	dba080e7          	jalr	-582(ra) # 800053c8 <virtio_disk_init>
    userinit();      // first user process
    80000616:	00001097          	auipc	ra,0x1
    8000061a:	d0e080e7          	jalr	-754(ra) # 80001324 <userinit>
    __sync_synchronize();
    8000061e:	0ff0000f          	fence
    started = 1;
    80000622:	4785                	li	a5,1
    80000624:	00008717          	auipc	a4,0x8
    80000628:	26f72623          	sw	a5,620(a4) # 80008890 <started>
    8000062c:	b789                	j	8000056e <main+0x56>

000000008000062e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000062e:	1141                	addi	sp,sp,-16
    80000630:	e422                	sd	s0,8(sp)
    80000632:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000634:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000638:	00008797          	auipc	a5,0x8
    8000063c:	2607b783          	ld	a5,608(a5) # 80008898 <kernel_pagetable>
    80000640:	83b1                	srli	a5,a5,0xc
    80000642:	577d                	li	a4,-1
    80000644:	177e                	slli	a4,a4,0x3f
    80000646:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000648:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000064c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000650:	6422                	ld	s0,8(sp)
    80000652:	0141                	addi	sp,sp,16
    80000654:	8082                	ret

0000000080000656 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000656:	7139                	addi	sp,sp,-64
    80000658:	fc06                	sd	ra,56(sp)
    8000065a:	f822                	sd	s0,48(sp)
    8000065c:	f426                	sd	s1,40(sp)
    8000065e:	f04a                	sd	s2,32(sp)
    80000660:	ec4e                	sd	s3,24(sp)
    80000662:	e852                	sd	s4,16(sp)
    80000664:	e456                	sd	s5,8(sp)
    80000666:	e05a                	sd	s6,0(sp)
    80000668:	0080                	addi	s0,sp,64
    8000066a:	84aa                	mv	s1,a0
    8000066c:	89ae                	mv	s3,a1
    8000066e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000670:	57fd                	li	a5,-1
    80000672:	83e9                	srli	a5,a5,0x1a
    80000674:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000676:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000678:	04b7f263          	bgeu	a5,a1,800006bc <walk+0x66>
    panic("walk");
    8000067c:	00008517          	auipc	a0,0x8
    80000680:	9d450513          	addi	a0,a0,-1580 # 80008050 <etext+0x50>
    80000684:	00005097          	auipc	ra,0x5
    80000688:	79e080e7          	jalr	1950(ra) # 80005e22 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000068c:	060a8663          	beqz	s5,800006f8 <walk+0xa2>
    80000690:	00000097          	auipc	ra,0x0
    80000694:	b5e080e7          	jalr	-1186(ra) # 800001ee <kalloc>
    80000698:	84aa                	mv	s1,a0
    8000069a:	c529                	beqz	a0,800006e4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000069c:	6605                	lui	a2,0x1
    8000069e:	4581                	li	a1,0
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	cca080e7          	jalr	-822(ra) # 8000036a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800006a8:	00c4d793          	srli	a5,s1,0xc
    800006ac:	07aa                	slli	a5,a5,0xa
    800006ae:	0017e793          	ori	a5,a5,1
    800006b2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800006b6:	3a5d                	addiw	s4,s4,-9
    800006b8:	036a0063          	beq	s4,s6,800006d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800006bc:	0149d933          	srl	s2,s3,s4
    800006c0:	1ff97913          	andi	s2,s2,511
    800006c4:	090e                	slli	s2,s2,0x3
    800006c6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800006c8:	00093483          	ld	s1,0(s2)
    800006cc:	0014f793          	andi	a5,s1,1
    800006d0:	dfd5                	beqz	a5,8000068c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800006d2:	80a9                	srli	s1,s1,0xa
    800006d4:	04b2                	slli	s1,s1,0xc
    800006d6:	b7c5                	j	800006b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800006d8:	00c9d513          	srli	a0,s3,0xc
    800006dc:	1ff57513          	andi	a0,a0,511
    800006e0:	050e                	slli	a0,a0,0x3
    800006e2:	9526                	add	a0,a0,s1
}
    800006e4:	70e2                	ld	ra,56(sp)
    800006e6:	7442                	ld	s0,48(sp)
    800006e8:	74a2                	ld	s1,40(sp)
    800006ea:	7902                	ld	s2,32(sp)
    800006ec:	69e2                	ld	s3,24(sp)
    800006ee:	6a42                	ld	s4,16(sp)
    800006f0:	6aa2                	ld	s5,8(sp)
    800006f2:	6b02                	ld	s6,0(sp)
    800006f4:	6121                	addi	sp,sp,64
    800006f6:	8082                	ret
        return 0;
    800006f8:	4501                	li	a0,0
    800006fa:	b7ed                	j	800006e4 <walk+0x8e>

00000000800006fc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800006fc:	57fd                	li	a5,-1
    800006fe:	83e9                	srli	a5,a5,0x1a
    80000700:	00b7f463          	bgeu	a5,a1,80000708 <walkaddr+0xc>
    return 0;
    80000704:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000706:	8082                	ret
{
    80000708:	1141                	addi	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000710:	4601                	li	a2,0
    80000712:	00000097          	auipc	ra,0x0
    80000716:	f44080e7          	jalr	-188(ra) # 80000656 <walk>
  if(pte == 0)
    8000071a:	c105                	beqz	a0,8000073a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000071c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000071e:	0117f693          	andi	a3,a5,17
    80000722:	4745                	li	a4,17
    return 0;
    80000724:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000726:	00e68663          	beq	a3,a4,80000732 <walkaddr+0x36>
}
    8000072a:	60a2                	ld	ra,8(sp)
    8000072c:	6402                	ld	s0,0(sp)
    8000072e:	0141                	addi	sp,sp,16
    80000730:	8082                	ret
  pa = PTE2PA(*pte);
    80000732:	00a7d513          	srli	a0,a5,0xa
    80000736:	0532                	slli	a0,a0,0xc
  return pa;
    80000738:	bfcd                	j	8000072a <walkaddr+0x2e>
    return 0;
    8000073a:	4501                	li	a0,0
    8000073c:	b7fd                	j	8000072a <walkaddr+0x2e>

000000008000073e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000073e:	715d                	addi	sp,sp,-80
    80000740:	e486                	sd	ra,72(sp)
    80000742:	e0a2                	sd	s0,64(sp)
    80000744:	fc26                	sd	s1,56(sp)
    80000746:	f84a                	sd	s2,48(sp)
    80000748:	f44e                	sd	s3,40(sp)
    8000074a:	f052                	sd	s4,32(sp)
    8000074c:	ec56                	sd	s5,24(sp)
    8000074e:	e85a                	sd	s6,16(sp)
    80000750:	e45e                	sd	s7,8(sp)
    80000752:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000754:	c205                	beqz	a2,80000774 <mappages+0x36>
    80000756:	8aaa                	mv	s5,a0
    80000758:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000075a:	77fd                	lui	a5,0xfffff
    8000075c:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000760:	15fd                	addi	a1,a1,-1
    80000762:	00c589b3          	add	s3,a1,a2
    80000766:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000076a:	8952                	mv	s2,s4
    8000076c:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000770:	6b85                	lui	s7,0x1
    80000772:	a015                	j	80000796 <mappages+0x58>
    panic("mappages: size");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	8e450513          	addi	a0,a0,-1820 # 80008058 <etext+0x58>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	6a6080e7          	jalr	1702(ra) # 80005e22 <panic>
      panic("mappages: remap");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	8e450513          	addi	a0,a0,-1820 # 80008068 <etext+0x68>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	696080e7          	jalr	1686(ra) # 80005e22 <panic>
    a += PGSIZE;
    80000794:	995e                	add	s2,s2,s7
  for(;;){
    80000796:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000079a:	4605                	li	a2,1
    8000079c:	85ca                	mv	a1,s2
    8000079e:	8556                	mv	a0,s5
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	eb6080e7          	jalr	-330(ra) # 80000656 <walk>
    800007a8:	cd19                	beqz	a0,800007c6 <mappages+0x88>
    if(*pte & PTE_V)
    800007aa:	611c                	ld	a5,0(a0)
    800007ac:	8b85                	andi	a5,a5,1
    800007ae:	fbf9                	bnez	a5,80000784 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800007b0:	80b1                	srli	s1,s1,0xc
    800007b2:	04aa                	slli	s1,s1,0xa
    800007b4:	0164e4b3          	or	s1,s1,s6
    800007b8:	0014e493          	ori	s1,s1,1
    800007bc:	e104                	sd	s1,0(a0)
    if(a == last)
    800007be:	fd391be3          	bne	s2,s3,80000794 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800007c2:	4501                	li	a0,0
    800007c4:	a011                	j	800007c8 <mappages+0x8a>
      return -1;
    800007c6:	557d                	li	a0,-1
}
    800007c8:	60a6                	ld	ra,72(sp)
    800007ca:	6406                	ld	s0,64(sp)
    800007cc:	74e2                	ld	s1,56(sp)
    800007ce:	7942                	ld	s2,48(sp)
    800007d0:	79a2                	ld	s3,40(sp)
    800007d2:	7a02                	ld	s4,32(sp)
    800007d4:	6ae2                	ld	s5,24(sp)
    800007d6:	6b42                	ld	s6,16(sp)
    800007d8:	6ba2                	ld	s7,8(sp)
    800007da:	6161                	addi	sp,sp,80
    800007dc:	8082                	ret

00000000800007de <kvmmap>:
{
    800007de:	1141                	addi	sp,sp,-16
    800007e0:	e406                	sd	ra,8(sp)
    800007e2:	e022                	sd	s0,0(sp)
    800007e4:	0800                	addi	s0,sp,16
    800007e6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800007e8:	86b2                	mv	a3,a2
    800007ea:	863e                	mv	a2,a5
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	f52080e7          	jalr	-174(ra) # 8000073e <mappages>
    800007f4:	e509                	bnez	a0,800007fe <kvmmap+0x20>
}
    800007f6:	60a2                	ld	ra,8(sp)
    800007f8:	6402                	ld	s0,0(sp)
    800007fa:	0141                	addi	sp,sp,16
    800007fc:	8082                	ret
    panic("kvmmap");
    800007fe:	00008517          	auipc	a0,0x8
    80000802:	87a50513          	addi	a0,a0,-1926 # 80008078 <etext+0x78>
    80000806:	00005097          	auipc	ra,0x5
    8000080a:	61c080e7          	jalr	1564(ra) # 80005e22 <panic>

000000008000080e <kvmmake>:
{
    8000080e:	1101                	addi	sp,sp,-32
    80000810:	ec06                	sd	ra,24(sp)
    80000812:	e822                	sd	s0,16(sp)
    80000814:	e426                	sd	s1,8(sp)
    80000816:	e04a                	sd	s2,0(sp)
    80000818:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	9d4080e7          	jalr	-1580(ra) # 800001ee <kalloc>
    80000822:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	b42080e7          	jalr	-1214(ra) # 8000036a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000830:	4719                	li	a4,6
    80000832:	6685                	lui	a3,0x1
    80000834:	10000637          	lui	a2,0x10000
    80000838:	100005b7          	lui	a1,0x10000
    8000083c:	8526                	mv	a0,s1
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	fa0080e7          	jalr	-96(ra) # 800007de <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000846:	4719                	li	a4,6
    80000848:	6685                	lui	a3,0x1
    8000084a:	10001637          	lui	a2,0x10001
    8000084e:	100015b7          	lui	a1,0x10001
    80000852:	8526                	mv	a0,s1
    80000854:	00000097          	auipc	ra,0x0
    80000858:	f8a080e7          	jalr	-118(ra) # 800007de <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000085c:	4719                	li	a4,6
    8000085e:	004006b7          	lui	a3,0x400
    80000862:	0c000637          	lui	a2,0xc000
    80000866:	0c0005b7          	lui	a1,0xc000
    8000086a:	8526                	mv	a0,s1
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	f72080e7          	jalr	-142(ra) # 800007de <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000874:	00007917          	auipc	s2,0x7
    80000878:	78c90913          	addi	s2,s2,1932 # 80008000 <etext>
    8000087c:	4729                	li	a4,10
    8000087e:	80007697          	auipc	a3,0x80007
    80000882:	78268693          	addi	a3,a3,1922 # 8000 <_entry-0x7fff8000>
    80000886:	4605                	li	a2,1
    80000888:	067e                	slli	a2,a2,0x1f
    8000088a:	85b2                	mv	a1,a2
    8000088c:	8526                	mv	a0,s1
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	f50080e7          	jalr	-176(ra) # 800007de <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000896:	4719                	li	a4,6
    80000898:	46c5                	li	a3,17
    8000089a:	06ee                	slli	a3,a3,0x1b
    8000089c:	412686b3          	sub	a3,a3,s2
    800008a0:	864a                	mv	a2,s2
    800008a2:	85ca                	mv	a1,s2
    800008a4:	8526                	mv	a0,s1
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	f38080e7          	jalr	-200(ra) # 800007de <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800008ae:	4729                	li	a4,10
    800008b0:	6685                	lui	a3,0x1
    800008b2:	00006617          	auipc	a2,0x6
    800008b6:	74e60613          	addi	a2,a2,1870 # 80007000 <_trampoline>
    800008ba:	040005b7          	lui	a1,0x4000
    800008be:	15fd                	addi	a1,a1,-1
    800008c0:	05b2                	slli	a1,a1,0xc
    800008c2:	8526                	mv	a0,s1
    800008c4:	00000097          	auipc	ra,0x0
    800008c8:	f1a080e7          	jalr	-230(ra) # 800007de <kvmmap>
  proc_mapstacks(kpgtbl);
    800008cc:	8526                	mv	a0,s1
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	608080e7          	jalr	1544(ra) # 80000ed6 <proc_mapstacks>
}
    800008d6:	8526                	mv	a0,s1
    800008d8:	60e2                	ld	ra,24(sp)
    800008da:	6442                	ld	s0,16(sp)
    800008dc:	64a2                	ld	s1,8(sp)
    800008de:	6902                	ld	s2,0(sp)
    800008e0:	6105                	addi	sp,sp,32
    800008e2:	8082                	ret

00000000800008e4 <kvminit>:
{
    800008e4:	1141                	addi	sp,sp,-16
    800008e6:	e406                	sd	ra,8(sp)
    800008e8:	e022                	sd	s0,0(sp)
    800008ea:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800008ec:	00000097          	auipc	ra,0x0
    800008f0:	f22080e7          	jalr	-222(ra) # 8000080e <kvmmake>
    800008f4:	00008797          	auipc	a5,0x8
    800008f8:	faa7b223          	sd	a0,-92(a5) # 80008898 <kernel_pagetable>
}
    800008fc:	60a2                	ld	ra,8(sp)
    800008fe:	6402                	ld	s0,0(sp)
    80000900:	0141                	addi	sp,sp,16
    80000902:	8082                	ret

0000000080000904 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000904:	715d                	addi	sp,sp,-80
    80000906:	e486                	sd	ra,72(sp)
    80000908:	e0a2                	sd	s0,64(sp)
    8000090a:	fc26                	sd	s1,56(sp)
    8000090c:	f84a                	sd	s2,48(sp)
    8000090e:	f44e                	sd	s3,40(sp)
    80000910:	f052                	sd	s4,32(sp)
    80000912:	ec56                	sd	s5,24(sp)
    80000914:	e85a                	sd	s6,16(sp)
    80000916:	e45e                	sd	s7,8(sp)
    80000918:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000091a:	03459793          	slli	a5,a1,0x34
    8000091e:	e795                	bnez	a5,8000094a <uvmunmap+0x46>
    80000920:	8a2a                	mv	s4,a0
    80000922:	892e                	mv	s2,a1
    80000924:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000926:	0632                	slli	a2,a2,0xc
    80000928:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000092c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000092e:	6b05                	lui	s6,0x1
    80000930:	0735e863          	bltu	a1,s3,800009a0 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000934:	60a6                	ld	ra,72(sp)
    80000936:	6406                	ld	s0,64(sp)
    80000938:	74e2                	ld	s1,56(sp)
    8000093a:	7942                	ld	s2,48(sp)
    8000093c:	79a2                	ld	s3,40(sp)
    8000093e:	7a02                	ld	s4,32(sp)
    80000940:	6ae2                	ld	s5,24(sp)
    80000942:	6b42                	ld	s6,16(sp)
    80000944:	6ba2                	ld	s7,8(sp)
    80000946:	6161                	addi	sp,sp,80
    80000948:	8082                	ret
    panic("uvmunmap: not aligned");
    8000094a:	00007517          	auipc	a0,0x7
    8000094e:	73650513          	addi	a0,a0,1846 # 80008080 <etext+0x80>
    80000952:	00005097          	auipc	ra,0x5
    80000956:	4d0080e7          	jalr	1232(ra) # 80005e22 <panic>
      panic("uvmunmap: walk");
    8000095a:	00007517          	auipc	a0,0x7
    8000095e:	73e50513          	addi	a0,a0,1854 # 80008098 <etext+0x98>
    80000962:	00005097          	auipc	ra,0x5
    80000966:	4c0080e7          	jalr	1216(ra) # 80005e22 <panic>
      panic("uvmunmap: not mapped");
    8000096a:	00007517          	auipc	a0,0x7
    8000096e:	73e50513          	addi	a0,a0,1854 # 800080a8 <etext+0xa8>
    80000972:	00005097          	auipc	ra,0x5
    80000976:	4b0080e7          	jalr	1200(ra) # 80005e22 <panic>
      panic("uvmunmap: not a leaf");
    8000097a:	00007517          	auipc	a0,0x7
    8000097e:	74650513          	addi	a0,a0,1862 # 800080c0 <etext+0xc0>
    80000982:	00005097          	auipc	ra,0x5
    80000986:	4a0080e7          	jalr	1184(ra) # 80005e22 <panic>
      uint64 pa = PTE2PA(*pte);
    8000098a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000098c:	0532                	slli	a0,a0,0xc
    8000098e:	fffff097          	auipc	ra,0xfffff
    80000992:	71a080e7          	jalr	1818(ra) # 800000a8 <kfree>
    *pte = 0;
    80000996:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000099a:	995a                	add	s2,s2,s6
    8000099c:	f9397ce3          	bgeu	s2,s3,80000934 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800009a0:	4601                	li	a2,0
    800009a2:	85ca                	mv	a1,s2
    800009a4:	8552                	mv	a0,s4
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	cb0080e7          	jalr	-848(ra) # 80000656 <walk>
    800009ae:	84aa                	mv	s1,a0
    800009b0:	d54d                	beqz	a0,8000095a <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800009b2:	6108                	ld	a0,0(a0)
    800009b4:	00157793          	andi	a5,a0,1
    800009b8:	dbcd                	beqz	a5,8000096a <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800009ba:	3ff57793          	andi	a5,a0,1023
    800009be:	fb778ee3          	beq	a5,s7,8000097a <uvmunmap+0x76>
    if(do_free){
    800009c2:	fc0a8ae3          	beqz	s5,80000996 <uvmunmap+0x92>
    800009c6:	b7d1                	j	8000098a <uvmunmap+0x86>

00000000800009c8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800009c8:	1101                	addi	sp,sp,-32
    800009ca:	ec06                	sd	ra,24(sp)
    800009cc:	e822                	sd	s0,16(sp)
    800009ce:	e426                	sd	s1,8(sp)
    800009d0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	81c080e7          	jalr	-2020(ra) # 800001ee <kalloc>
    800009da:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800009dc:	c519                	beqz	a0,800009ea <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800009de:	6605                	lui	a2,0x1
    800009e0:	4581                	li	a1,0
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	988080e7          	jalr	-1656(ra) # 8000036a <memset>
  return pagetable;
}
    800009ea:	8526                	mv	a0,s1
    800009ec:	60e2                	ld	ra,24(sp)
    800009ee:	6442                	ld	s0,16(sp)
    800009f0:	64a2                	ld	s1,8(sp)
    800009f2:	6105                	addi	sp,sp,32
    800009f4:	8082                	ret

00000000800009f6 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800009f6:	7179                	addi	sp,sp,-48
    800009f8:	f406                	sd	ra,40(sp)
    800009fa:	f022                	sd	s0,32(sp)
    800009fc:	ec26                	sd	s1,24(sp)
    800009fe:	e84a                	sd	s2,16(sp)
    80000a00:	e44e                	sd	s3,8(sp)
    80000a02:	e052                	sd	s4,0(sp)
    80000a04:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000a06:	6785                	lui	a5,0x1
    80000a08:	04f67863          	bgeu	a2,a5,80000a58 <uvmfirst+0x62>
    80000a0c:	8a2a                	mv	s4,a0
    80000a0e:	89ae                	mv	s3,a1
    80000a10:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000a12:	fffff097          	auipc	ra,0xfffff
    80000a16:	7dc080e7          	jalr	2012(ra) # 800001ee <kalloc>
    80000a1a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a1c:	6605                	lui	a2,0x1
    80000a1e:	4581                	li	a1,0
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	94a080e7          	jalr	-1718(ra) # 8000036a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000a28:	4779                	li	a4,30
    80000a2a:	86ca                	mv	a3,s2
    80000a2c:	6605                	lui	a2,0x1
    80000a2e:	4581                	li	a1,0
    80000a30:	8552                	mv	a0,s4
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	d0c080e7          	jalr	-756(ra) # 8000073e <mappages>
  memmove(mem, src, sz);
    80000a3a:	8626                	mv	a2,s1
    80000a3c:	85ce                	mv	a1,s3
    80000a3e:	854a                	mv	a0,s2
    80000a40:	00000097          	auipc	ra,0x0
    80000a44:	98a080e7          	jalr	-1654(ra) # 800003ca <memmove>
}
    80000a48:	70a2                	ld	ra,40(sp)
    80000a4a:	7402                	ld	s0,32(sp)
    80000a4c:	64e2                	ld	s1,24(sp)
    80000a4e:	6942                	ld	s2,16(sp)
    80000a50:	69a2                	ld	s3,8(sp)
    80000a52:	6a02                	ld	s4,0(sp)
    80000a54:	6145                	addi	sp,sp,48
    80000a56:	8082                	ret
    panic("uvmfirst: more than a page");
    80000a58:	00007517          	auipc	a0,0x7
    80000a5c:	68050513          	addi	a0,a0,1664 # 800080d8 <etext+0xd8>
    80000a60:	00005097          	auipc	ra,0x5
    80000a64:	3c2080e7          	jalr	962(ra) # 80005e22 <panic>

0000000080000a68 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a68:	1101                	addi	sp,sp,-32
    80000a6a:	ec06                	sd	ra,24(sp)
    80000a6c:	e822                	sd	s0,16(sp)
    80000a6e:	e426                	sd	s1,8(sp)
    80000a70:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a72:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a74:	00b67d63          	bgeu	a2,a1,80000a8e <uvmdealloc+0x26>
    80000a78:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a7a:	6785                	lui	a5,0x1
    80000a7c:	17fd                	addi	a5,a5,-1
    80000a7e:	00f60733          	add	a4,a2,a5
    80000a82:	767d                	lui	a2,0xfffff
    80000a84:	8f71                	and	a4,a4,a2
    80000a86:	97ae                	add	a5,a5,a1
    80000a88:	8ff1                	and	a5,a5,a2
    80000a8a:	00f76863          	bltu	a4,a5,80000a9a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a8e:	8526                	mv	a0,s1
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6105                	addi	sp,sp,32
    80000a98:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a9a:	8f99                	sub	a5,a5,a4
    80000a9c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a9e:	4685                	li	a3,1
    80000aa0:	0007861b          	sext.w	a2,a5
    80000aa4:	85ba                	mv	a1,a4
    80000aa6:	00000097          	auipc	ra,0x0
    80000aaa:	e5e080e7          	jalr	-418(ra) # 80000904 <uvmunmap>
    80000aae:	b7c5                	j	80000a8e <uvmdealloc+0x26>

0000000080000ab0 <uvmalloc>:
  if(newsz < oldsz)
    80000ab0:	0ab66563          	bltu	a2,a1,80000b5a <uvmalloc+0xaa>
{
    80000ab4:	7139                	addi	sp,sp,-64
    80000ab6:	fc06                	sd	ra,56(sp)
    80000ab8:	f822                	sd	s0,48(sp)
    80000aba:	f426                	sd	s1,40(sp)
    80000abc:	f04a                	sd	s2,32(sp)
    80000abe:	ec4e                	sd	s3,24(sp)
    80000ac0:	e852                	sd	s4,16(sp)
    80000ac2:	e456                	sd	s5,8(sp)
    80000ac4:	e05a                	sd	s6,0(sp)
    80000ac6:	0080                	addi	s0,sp,64
    80000ac8:	8aaa                	mv	s5,a0
    80000aca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000acc:	6985                	lui	s3,0x1
    80000ace:	19fd                	addi	s3,s3,-1
    80000ad0:	95ce                	add	a1,a1,s3
    80000ad2:	79fd                	lui	s3,0xfffff
    80000ad4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000ad8:	08c9f363          	bgeu	s3,a2,80000b5e <uvmalloc+0xae>
    80000adc:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000ade:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000ae2:	fffff097          	auipc	ra,0xfffff
    80000ae6:	70c080e7          	jalr	1804(ra) # 800001ee <kalloc>
    80000aea:	84aa                	mv	s1,a0
    if(mem == 0){
    80000aec:	c51d                	beqz	a0,80000b1a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000aee:	6605                	lui	a2,0x1
    80000af0:	4581                	li	a1,0
    80000af2:	00000097          	auipc	ra,0x0
    80000af6:	878080e7          	jalr	-1928(ra) # 8000036a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000afa:	875a                	mv	a4,s6
    80000afc:	86a6                	mv	a3,s1
    80000afe:	6605                	lui	a2,0x1
    80000b00:	85ca                	mv	a1,s2
    80000b02:	8556                	mv	a0,s5
    80000b04:	00000097          	auipc	ra,0x0
    80000b08:	c3a080e7          	jalr	-966(ra) # 8000073e <mappages>
    80000b0c:	e90d                	bnez	a0,80000b3e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000b0e:	6785                	lui	a5,0x1
    80000b10:	993e                	add	s2,s2,a5
    80000b12:	fd4968e3          	bltu	s2,s4,80000ae2 <uvmalloc+0x32>
  return newsz;
    80000b16:	8552                	mv	a0,s4
    80000b18:	a809                	j	80000b2a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000b1a:	864e                	mv	a2,s3
    80000b1c:	85ca                	mv	a1,s2
    80000b1e:	8556                	mv	a0,s5
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	f48080e7          	jalr	-184(ra) # 80000a68 <uvmdealloc>
      return 0;
    80000b28:	4501                	li	a0,0
}
    80000b2a:	70e2                	ld	ra,56(sp)
    80000b2c:	7442                	ld	s0,48(sp)
    80000b2e:	74a2                	ld	s1,40(sp)
    80000b30:	7902                	ld	s2,32(sp)
    80000b32:	69e2                	ld	s3,24(sp)
    80000b34:	6a42                	ld	s4,16(sp)
    80000b36:	6aa2                	ld	s5,8(sp)
    80000b38:	6b02                	ld	s6,0(sp)
    80000b3a:	6121                	addi	sp,sp,64
    80000b3c:	8082                	ret
      kfree(mem);
    80000b3e:	8526                	mv	a0,s1
    80000b40:	fffff097          	auipc	ra,0xfffff
    80000b44:	568080e7          	jalr	1384(ra) # 800000a8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b48:	864e                	mv	a2,s3
    80000b4a:	85ca                	mv	a1,s2
    80000b4c:	8556                	mv	a0,s5
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	f1a080e7          	jalr	-230(ra) # 80000a68 <uvmdealloc>
      return 0;
    80000b56:	4501                	li	a0,0
    80000b58:	bfc9                	j	80000b2a <uvmalloc+0x7a>
    return oldsz;
    80000b5a:	852e                	mv	a0,a1
}
    80000b5c:	8082                	ret
  return newsz;
    80000b5e:	8532                	mv	a0,a2
    80000b60:	b7e9                	j	80000b2a <uvmalloc+0x7a>

0000000080000b62 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b62:	7179                	addi	sp,sp,-48
    80000b64:	f406                	sd	ra,40(sp)
    80000b66:	f022                	sd	s0,32(sp)
    80000b68:	ec26                	sd	s1,24(sp)
    80000b6a:	e84a                	sd	s2,16(sp)
    80000b6c:	e44e                	sd	s3,8(sp)
    80000b6e:	e052                	sd	s4,0(sp)
    80000b70:	1800                	addi	s0,sp,48
    80000b72:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b74:	84aa                	mv	s1,a0
    80000b76:	6905                	lui	s2,0x1
    80000b78:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b7a:	4985                	li	s3,1
    80000b7c:	a821                	j	80000b94 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b7e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000b80:	0532                	slli	a0,a0,0xc
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	fe0080e7          	jalr	-32(ra) # 80000b62 <freewalk>
      pagetable[i] = 0;
    80000b8a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b8e:	04a1                	addi	s1,s1,8
    80000b90:	03248163          	beq	s1,s2,80000bb2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b94:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b96:	00f57793          	andi	a5,a0,15
    80000b9a:	ff3782e3          	beq	a5,s3,80000b7e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b9e:	8905                	andi	a0,a0,1
    80000ba0:	d57d                	beqz	a0,80000b8e <freewalk+0x2c>
      panic("freewalk: leaf");
    80000ba2:	00007517          	auipc	a0,0x7
    80000ba6:	55650513          	addi	a0,a0,1366 # 800080f8 <etext+0xf8>
    80000baa:	00005097          	auipc	ra,0x5
    80000bae:	278080e7          	jalr	632(ra) # 80005e22 <panic>
    }
  }
  kfree((void*)pagetable);
    80000bb2:	8552                	mv	a0,s4
    80000bb4:	fffff097          	auipc	ra,0xfffff
    80000bb8:	4f4080e7          	jalr	1268(ra) # 800000a8 <kfree>
}
    80000bbc:	70a2                	ld	ra,40(sp)
    80000bbe:	7402                	ld	s0,32(sp)
    80000bc0:	64e2                	ld	s1,24(sp)
    80000bc2:	6942                	ld	s2,16(sp)
    80000bc4:	69a2                	ld	s3,8(sp)
    80000bc6:	6a02                	ld	s4,0(sp)
    80000bc8:	6145                	addi	sp,sp,48
    80000bca:	8082                	ret

0000000080000bcc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000bcc:	1101                	addi	sp,sp,-32
    80000bce:	ec06                	sd	ra,24(sp)
    80000bd0:	e822                	sd	s0,16(sp)
    80000bd2:	e426                	sd	s1,8(sp)
    80000bd4:	1000                	addi	s0,sp,32
    80000bd6:	84aa                	mv	s1,a0
  if(sz > 0)
    80000bd8:	e999                	bnez	a1,80000bee <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000bda:	8526                	mv	a0,s1
    80000bdc:	00000097          	auipc	ra,0x0
    80000be0:	f86080e7          	jalr	-122(ra) # 80000b62 <freewalk>
}
    80000be4:	60e2                	ld	ra,24(sp)
    80000be6:	6442                	ld	s0,16(sp)
    80000be8:	64a2                	ld	s1,8(sp)
    80000bea:	6105                	addi	sp,sp,32
    80000bec:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000bee:	6605                	lui	a2,0x1
    80000bf0:	167d                	addi	a2,a2,-1
    80000bf2:	962e                	add	a2,a2,a1
    80000bf4:	4685                	li	a3,1
    80000bf6:	8231                	srli	a2,a2,0xc
    80000bf8:	4581                	li	a1,0
    80000bfa:	00000097          	auipc	ra,0x0
    80000bfe:	d0a080e7          	jalr	-758(ra) # 80000904 <uvmunmap>
    80000c02:	bfe1                	j	80000bda <uvmfree+0xe>

0000000080000c04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  //char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000c04:	c271                	beqz	a2,80000cc8 <uvmcopy+0xc4>
{
    80000c06:	7139                	addi	sp,sp,-64
    80000c08:	fc06                	sd	ra,56(sp)
    80000c0a:	f822                	sd	s0,48(sp)
    80000c0c:	f426                	sd	s1,40(sp)
    80000c0e:	f04a                	sd	s2,32(sp)
    80000c10:	ec4e                	sd	s3,24(sp)
    80000c12:	e852                	sd	s4,16(sp)
    80000c14:	e456                	sd	s5,8(sp)
    80000c16:	e05a                	sd	s6,0(sp)
    80000c18:	0080                	addi	s0,sp,64
    80000c1a:	8b2a                	mv	s6,a0
    80000c1c:	8aae                	mv	s5,a1
    80000c1e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000c20:	4901                	li	s2,0
    80000c22:	a0b1                	j	80000c6e <uvmcopy+0x6a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000c24:	00007517          	auipc	a0,0x7
    80000c28:	4e450513          	addi	a0,a0,1252 # 80008108 <etext+0x108>
    80000c2c:	00005097          	auipc	ra,0x5
    80000c30:	1f6080e7          	jalr	502(ra) # 80005e22 <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000c34:	00007517          	auipc	a0,0x7
    80000c38:	4f450513          	addi	a0,a0,1268 # 80008128 <etext+0x128>
    80000c3c:	00005097          	auipc	ra,0x5
    80000c40:	1e6080e7          	jalr	486(ra) # 80005e22 <panic>
    //   *pte = PA2PTE(pa) | flags;
    // }
    if(*pte & PTE_W){
      *pte = (*pte & (~PTE_W)) | PTE_COW;
    }
    ref_increase((void*)pa);
    80000c44:	854e                	mv	a0,s3
    80000c46:	fffff097          	auipc	ra,0xfffff
    80000c4a:	3d6080e7          	jalr	982(ra) # 8000001c <ref_increase>
    flags = PTE_FLAGS(*pte);
    80000c4e:	6098                	ld	a4,0(s1)
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000c50:	3ff77713          	andi	a4,a4,1023
    80000c54:	86ce                	mv	a3,s3
    80000c56:	6605                	lui	a2,0x1
    80000c58:	85ca                	mv	a1,s2
    80000c5a:	8556                	mv	a0,s5
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	ae2080e7          	jalr	-1310(ra) # 8000073e <mappages>
    80000c64:	ed15                	bnez	a0,80000ca0 <uvmcopy+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
    80000c66:	6785                	lui	a5,0x1
    80000c68:	993e                	add	s2,s2,a5
    80000c6a:	05497563          	bgeu	s2,s4,80000cb4 <uvmcopy+0xb0>
    if((pte = walk(old, i, 0)) == 0)
    80000c6e:	4601                	li	a2,0
    80000c70:	85ca                	mv	a1,s2
    80000c72:	855a                	mv	a0,s6
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	9e2080e7          	jalr	-1566(ra) # 80000656 <walk>
    80000c7c:	84aa                	mv	s1,a0
    80000c7e:	d15d                	beqz	a0,80000c24 <uvmcopy+0x20>
    if((*pte & PTE_V) == 0)
    80000c80:	611c                	ld	a5,0(a0)
    80000c82:	0017f713          	andi	a4,a5,1
    80000c86:	d75d                	beqz	a4,80000c34 <uvmcopy+0x30>
    pa = PTE2PA(*pte);
    80000c88:	00a7d993          	srli	s3,a5,0xa
    80000c8c:	09b2                	slli	s3,s3,0xc
    if(*pte & PTE_W){
    80000c8e:	0047f713          	andi	a4,a5,4
    80000c92:	db4d                	beqz	a4,80000c44 <uvmcopy+0x40>
      *pte = (*pte & (~PTE_W)) | PTE_COW;
    80000c94:	efb7f793          	andi	a5,a5,-261
    80000c98:	1007e793          	ori	a5,a5,256
    80000c9c:	e11c                	sd	a5,0(a0)
    80000c9e:	b75d                	j	80000c44 <uvmcopy+0x40>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ca0:	4685                	li	a3,1
    80000ca2:	00c95613          	srli	a2,s2,0xc
    80000ca6:	4581                	li	a1,0
    80000ca8:	8556                	mv	a0,s5
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	c5a080e7          	jalr	-934(ra) # 80000904 <uvmunmap>
  return -1;
    80000cb2:	557d                	li	a0,-1
}
    80000cb4:	70e2                	ld	ra,56(sp)
    80000cb6:	7442                	ld	s0,48(sp)
    80000cb8:	74a2                	ld	s1,40(sp)
    80000cba:	7902                	ld	s2,32(sp)
    80000cbc:	69e2                	ld	s3,24(sp)
    80000cbe:	6a42                	ld	s4,16(sp)
    80000cc0:	6aa2                	ld	s5,8(sp)
    80000cc2:	6b02                	ld	s6,0(sp)
    80000cc4:	6121                	addi	sp,sp,64
    80000cc6:	8082                	ret
  return 0;
    80000cc8:	4501                	li	a0,0
}
    80000cca:	8082                	ret

0000000080000ccc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e406                	sd	ra,8(sp)
    80000cd0:	e022                	sd	s0,0(sp)
    80000cd2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000cd4:	4601                	li	a2,0
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	980080e7          	jalr	-1664(ra) # 80000656 <walk>
  if(pte == 0)
    80000cde:	c901                	beqz	a0,80000cee <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ce0:	611c                	ld	a5,0(a0)
    80000ce2:	9bbd                	andi	a5,a5,-17
    80000ce4:	e11c                	sd	a5,0(a0)
}
    80000ce6:	60a2                	ld	ra,8(sp)
    80000ce8:	6402                	ld	s0,0(sp)
    80000cea:	0141                	addi	sp,sp,16
    80000cec:	8082                	ret
    panic("uvmclear");
    80000cee:	00007517          	auipc	a0,0x7
    80000cf2:	45a50513          	addi	a0,a0,1114 # 80008148 <etext+0x148>
    80000cf6:	00005097          	auipc	ra,0x5
    80000cfa:	12c080e7          	jalr	300(ra) # 80005e22 <panic>

0000000080000cfe <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cfe:	cead                	beqz	a3,80000d78 <copyout+0x7a>
{
    80000d00:	715d                	addi	sp,sp,-80
    80000d02:	e486                	sd	ra,72(sp)
    80000d04:	e0a2                	sd	s0,64(sp)
    80000d06:	fc26                	sd	s1,56(sp)
    80000d08:	f84a                	sd	s2,48(sp)
    80000d0a:	f44e                	sd	s3,40(sp)
    80000d0c:	f052                	sd	s4,32(sp)
    80000d0e:	ec56                	sd	s5,24(sp)
    80000d10:	e85a                	sd	s6,16(sp)
    80000d12:	e45e                	sd	s7,8(sp)
    80000d14:	e062                	sd	s8,0(sp)
    80000d16:	0880                	addi	s0,sp,80
    80000d18:	8aaa                	mv	s5,a0
    80000d1a:	8c2e                	mv	s8,a1
    80000d1c:	8a32                	mv	s4,a2
    80000d1e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000d20:	7bfd                	lui	s7,0xfffff
    cow_alloc(pagetable, va0);// solution: copy on write
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000d22:	6b05                	lui	s6,0x1
    80000d24:	a015                	j	80000d48 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d26:	9562                	add	a0,a0,s8
    80000d28:	0004861b          	sext.w	a2,s1
    80000d2c:	85d2                	mv	a1,s4
    80000d2e:	41250533          	sub	a0,a0,s2
    80000d32:	fffff097          	auipc	ra,0xfffff
    80000d36:	698080e7          	jalr	1688(ra) # 800003ca <memmove>

    len -= n;
    80000d3a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000d3e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000d40:	01690c33          	add	s8,s2,s6
  while(len > 0){
    80000d44:	02098863          	beqz	s3,80000d74 <copyout+0x76>
    va0 = PGROUNDDOWN(dstva);
    80000d48:	017c7933          	and	s2,s8,s7
    cow_alloc(pagetable, va0);// solution: copy on write
    80000d4c:	85ca                	mv	a1,s2
    80000d4e:	8556                	mv	a0,s5
    80000d50:	fffff097          	auipc	ra,0xfffff
    80000d54:	510080e7          	jalr	1296(ra) # 80000260 <cow_alloc>
    pa0 = walkaddr(pagetable, va0);
    80000d58:	85ca                	mv	a1,s2
    80000d5a:	8556                	mv	a0,s5
    80000d5c:	00000097          	auipc	ra,0x0
    80000d60:	9a0080e7          	jalr	-1632(ra) # 800006fc <walkaddr>
    if(pa0 == 0)
    80000d64:	cd01                	beqz	a0,80000d7c <copyout+0x7e>
    n = PGSIZE - (dstva - va0);
    80000d66:	418904b3          	sub	s1,s2,s8
    80000d6a:	94da                	add	s1,s1,s6
    if(n > len)
    80000d6c:	fa99fde3          	bgeu	s3,s1,80000d26 <copyout+0x28>
    80000d70:	84ce                	mv	s1,s3
    80000d72:	bf55                	j	80000d26 <copyout+0x28>
  }
  return 0;
    80000d74:	4501                	li	a0,0
    80000d76:	a021                	j	80000d7e <copyout+0x80>
    80000d78:	4501                	li	a0,0
}
    80000d7a:	8082                	ret
      return -1;
    80000d7c:	557d                	li	a0,-1
}
    80000d7e:	60a6                	ld	ra,72(sp)
    80000d80:	6406                	ld	s0,64(sp)
    80000d82:	74e2                	ld	s1,56(sp)
    80000d84:	7942                	ld	s2,48(sp)
    80000d86:	79a2                	ld	s3,40(sp)
    80000d88:	7a02                	ld	s4,32(sp)
    80000d8a:	6ae2                	ld	s5,24(sp)
    80000d8c:	6b42                	ld	s6,16(sp)
    80000d8e:	6ba2                	ld	s7,8(sp)
    80000d90:	6c02                	ld	s8,0(sp)
    80000d92:	6161                	addi	sp,sp,80
    80000d94:	8082                	ret

0000000080000d96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d96:	c6bd                	beqz	a3,80000e04 <copyin+0x6e>
{
    80000d98:	715d                	addi	sp,sp,-80
    80000d9a:	e486                	sd	ra,72(sp)
    80000d9c:	e0a2                	sd	s0,64(sp)
    80000d9e:	fc26                	sd	s1,56(sp)
    80000da0:	f84a                	sd	s2,48(sp)
    80000da2:	f44e                	sd	s3,40(sp)
    80000da4:	f052                	sd	s4,32(sp)
    80000da6:	ec56                	sd	s5,24(sp)
    80000da8:	e85a                	sd	s6,16(sp)
    80000daa:	e45e                	sd	s7,8(sp)
    80000dac:	e062                	sd	s8,0(sp)
    80000dae:	0880                	addi	s0,sp,80
    80000db0:	8b2a                	mv	s6,a0
    80000db2:	8a2e                	mv	s4,a1
    80000db4:	8c32                	mv	s8,a2
    80000db6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000db8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dba:	6a85                	lui	s5,0x1
    80000dbc:	a015                	j	80000de0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000dbe:	9562                	add	a0,a0,s8
    80000dc0:	0004861b          	sext.w	a2,s1
    80000dc4:	412505b3          	sub	a1,a0,s2
    80000dc8:	8552                	mv	a0,s4
    80000dca:	fffff097          	auipc	ra,0xfffff
    80000dce:	600080e7          	jalr	1536(ra) # 800003ca <memmove>

    len -= n;
    80000dd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000dd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000dd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ddc:	02098263          	beqz	s3,80000e00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000de0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000de4:	85ca                	mv	a1,s2
    80000de6:	855a                	mv	a0,s6
    80000de8:	00000097          	auipc	ra,0x0
    80000dec:	914080e7          	jalr	-1772(ra) # 800006fc <walkaddr>
    if(pa0 == 0)
    80000df0:	cd01                	beqz	a0,80000e08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000df2:	418904b3          	sub	s1,s2,s8
    80000df6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000df8:	fc99f3e3          	bgeu	s3,s1,80000dbe <copyin+0x28>
    80000dfc:	84ce                	mv	s1,s3
    80000dfe:	b7c1                	j	80000dbe <copyin+0x28>
  }
  return 0;
    80000e00:	4501                	li	a0,0
    80000e02:	a021                	j	80000e0a <copyin+0x74>
    80000e04:	4501                	li	a0,0
}
    80000e06:	8082                	ret
      return -1;
    80000e08:	557d                	li	a0,-1
}
    80000e0a:	60a6                	ld	ra,72(sp)
    80000e0c:	6406                	ld	s0,64(sp)
    80000e0e:	74e2                	ld	s1,56(sp)
    80000e10:	7942                	ld	s2,48(sp)
    80000e12:	79a2                	ld	s3,40(sp)
    80000e14:	7a02                	ld	s4,32(sp)
    80000e16:	6ae2                	ld	s5,24(sp)
    80000e18:	6b42                	ld	s6,16(sp)
    80000e1a:	6ba2                	ld	s7,8(sp)
    80000e1c:	6c02                	ld	s8,0(sp)
    80000e1e:	6161                	addi	sp,sp,80
    80000e20:	8082                	ret

0000000080000e22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000e22:	c6c5                	beqz	a3,80000eca <copyinstr+0xa8>
{
    80000e24:	715d                	addi	sp,sp,-80
    80000e26:	e486                	sd	ra,72(sp)
    80000e28:	e0a2                	sd	s0,64(sp)
    80000e2a:	fc26                	sd	s1,56(sp)
    80000e2c:	f84a                	sd	s2,48(sp)
    80000e2e:	f44e                	sd	s3,40(sp)
    80000e30:	f052                	sd	s4,32(sp)
    80000e32:	ec56                	sd	s5,24(sp)
    80000e34:	e85a                	sd	s6,16(sp)
    80000e36:	e45e                	sd	s7,8(sp)
    80000e38:	0880                	addi	s0,sp,80
    80000e3a:	8a2a                	mv	s4,a0
    80000e3c:	8b2e                	mv	s6,a1
    80000e3e:	8bb2                	mv	s7,a2
    80000e40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e44:	6985                	lui	s3,0x1
    80000e46:	a035                	j	80000e72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000e48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000e4e:	0017b793          	seqz	a5,a5
    80000e52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e56:	60a6                	ld	ra,72(sp)
    80000e58:	6406                	ld	s0,64(sp)
    80000e5a:	74e2                	ld	s1,56(sp)
    80000e5c:	7942                	ld	s2,48(sp)
    80000e5e:	79a2                	ld	s3,40(sp)
    80000e60:	7a02                	ld	s4,32(sp)
    80000e62:	6ae2                	ld	s5,24(sp)
    80000e64:	6b42                	ld	s6,16(sp)
    80000e66:	6ba2                	ld	s7,8(sp)
    80000e68:	6161                	addi	sp,sp,80
    80000e6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e70:	c8a9                	beqz	s1,80000ec2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000e72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e76:	85ca                	mv	a1,s2
    80000e78:	8552                	mv	a0,s4
    80000e7a:	00000097          	auipc	ra,0x0
    80000e7e:	882080e7          	jalr	-1918(ra) # 800006fc <walkaddr>
    if(pa0 == 0)
    80000e82:	c131                	beqz	a0,80000ec6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000e84:	41790833          	sub	a6,s2,s7
    80000e88:	984e                	add	a6,a6,s3
    if(n > max)
    80000e8a:	0104f363          	bgeu	s1,a6,80000e90 <copyinstr+0x6e>
    80000e8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e90:	955e                	add	a0,a0,s7
    80000e92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e96:	fc080be3          	beqz	a6,80000e6c <copyinstr+0x4a>
    80000e9a:	985a                	add	a6,a6,s6
    80000e9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e9e:	41650633          	sub	a2,a0,s6
    80000ea2:	14fd                	addi	s1,s1,-1
    80000ea4:	9b26                	add	s6,s6,s1
    80000ea6:	00f60733          	add	a4,a2,a5
    80000eaa:	00074703          	lbu	a4,0(a4)
    80000eae:	df49                	beqz	a4,80000e48 <copyinstr+0x26>
        *dst = *p;
    80000eb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000eb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000eb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000eba:	ff0796e3          	bne	a5,a6,80000ea6 <copyinstr+0x84>
      dst++;
    80000ebe:	8b42                	mv	s6,a6
    80000ec0:	b775                	j	80000e6c <copyinstr+0x4a>
    80000ec2:	4781                	li	a5,0
    80000ec4:	b769                	j	80000e4e <copyinstr+0x2c>
      return -1;
    80000ec6:	557d                	li	a0,-1
    80000ec8:	b779                	j	80000e56 <copyinstr+0x34>
  int got_null = 0;
    80000eca:	4781                	li	a5,0
  if(got_null){
    80000ecc:	0017b793          	seqz	a5,a5
    80000ed0:	40f00533          	neg	a0,a5
}
    80000ed4:	8082                	ret

0000000080000ed6 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ed6:	7139                	addi	sp,sp,-64
    80000ed8:	fc06                	sd	ra,56(sp)
    80000eda:	f822                	sd	s0,48(sp)
    80000edc:	f426                	sd	s1,40(sp)
    80000ede:	f04a                	sd	s2,32(sp)
    80000ee0:	ec4e                	sd	s3,24(sp)
    80000ee2:	e852                	sd	s4,16(sp)
    80000ee4:	e456                	sd	s5,8(sp)
    80000ee6:	e05a                	sd	s6,0(sp)
    80000ee8:	0080                	addi	s0,sp,64
    80000eea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eec:	00228497          	auipc	s1,0x228
    80000ef0:	e2448493          	addi	s1,s1,-476 # 80228d10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ef4:	8b26                	mv	s6,s1
    80000ef6:	00007a97          	auipc	s5,0x7
    80000efa:	10aa8a93          	addi	s5,s5,266 # 80008000 <etext>
    80000efe:	04000937          	lui	s2,0x4000
    80000f02:	197d                	addi	s2,s2,-1
    80000f04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f06:	0022ea17          	auipc	s4,0x22e
    80000f0a:	80aa0a13          	addi	s4,s4,-2038 # 8022e710 <tickslock>
    char *pa = kalloc();
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	2e0080e7          	jalr	736(ra) # 800001ee <kalloc>
    80000f16:	862a                	mv	a2,a0
    if(pa == 0)
    80000f18:	c131                	beqz	a0,80000f5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f1a:	416485b3          	sub	a1,s1,s6
    80000f1e:	858d                	srai	a1,a1,0x3
    80000f20:	000ab783          	ld	a5,0(s5)
    80000f24:	02f585b3          	mul	a1,a1,a5
    80000f28:	2585                	addiw	a1,a1,1
    80000f2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f2e:	4719                	li	a4,6
    80000f30:	6685                	lui	a3,0x1
    80000f32:	40b905b3          	sub	a1,s2,a1
    80000f36:	854e                	mv	a0,s3
    80000f38:	00000097          	auipc	ra,0x0
    80000f3c:	8a6080e7          	jalr	-1882(ra) # 800007de <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f40:	16848493          	addi	s1,s1,360
    80000f44:	fd4495e3          	bne	s1,s4,80000f0e <proc_mapstacks+0x38>
  }
}
    80000f48:	70e2                	ld	ra,56(sp)
    80000f4a:	7442                	ld	s0,48(sp)
    80000f4c:	74a2                	ld	s1,40(sp)
    80000f4e:	7902                	ld	s2,32(sp)
    80000f50:	69e2                	ld	s3,24(sp)
    80000f52:	6a42                	ld	s4,16(sp)
    80000f54:	6aa2                	ld	s5,8(sp)
    80000f56:	6b02                	ld	s6,0(sp)
    80000f58:	6121                	addi	sp,sp,64
    80000f5a:	8082                	ret
      panic("kalloc");
    80000f5c:	00007517          	auipc	a0,0x7
    80000f60:	1fc50513          	addi	a0,a0,508 # 80008158 <etext+0x158>
    80000f64:	00005097          	auipc	ra,0x5
    80000f68:	ebe080e7          	jalr	-322(ra) # 80005e22 <panic>

0000000080000f6c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f6c:	7139                	addi	sp,sp,-64
    80000f6e:	fc06                	sd	ra,56(sp)
    80000f70:	f822                	sd	s0,48(sp)
    80000f72:	f426                	sd	s1,40(sp)
    80000f74:	f04a                	sd	s2,32(sp)
    80000f76:	ec4e                	sd	s3,24(sp)
    80000f78:	e852                	sd	s4,16(sp)
    80000f7a:	e456                	sd	s5,8(sp)
    80000f7c:	e05a                	sd	s6,0(sp)
    80000f7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f80:	00007597          	auipc	a1,0x7
    80000f84:	1e058593          	addi	a1,a1,480 # 80008160 <etext+0x160>
    80000f88:	00228517          	auipc	a0,0x228
    80000f8c:	95850513          	addi	a0,a0,-1704 # 802288e0 <pid_lock>
    80000f90:	00005097          	auipc	ra,0x5
    80000f94:	34c080e7          	jalr	844(ra) # 800062dc <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f98:	00007597          	auipc	a1,0x7
    80000f9c:	1d058593          	addi	a1,a1,464 # 80008168 <etext+0x168>
    80000fa0:	00228517          	auipc	a0,0x228
    80000fa4:	95850513          	addi	a0,a0,-1704 # 802288f8 <wait_lock>
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	334080e7          	jalr	820(ra) # 800062dc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb0:	00228497          	auipc	s1,0x228
    80000fb4:	d6048493          	addi	s1,s1,-672 # 80228d10 <proc>
      initlock(&p->lock, "proc");
    80000fb8:	00007b17          	auipc	s6,0x7
    80000fbc:	1c0b0b13          	addi	s6,s6,448 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000fc0:	8aa6                	mv	s5,s1
    80000fc2:	00007a17          	auipc	s4,0x7
    80000fc6:	03ea0a13          	addi	s4,s4,62 # 80008000 <etext>
    80000fca:	04000937          	lui	s2,0x4000
    80000fce:	197d                	addi	s2,s2,-1
    80000fd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd2:	0022d997          	auipc	s3,0x22d
    80000fd6:	73e98993          	addi	s3,s3,1854 # 8022e710 <tickslock>
      initlock(&p->lock, "proc");
    80000fda:	85da                	mv	a1,s6
    80000fdc:	8526                	mv	a0,s1
    80000fde:	00005097          	auipc	ra,0x5
    80000fe2:	2fe080e7          	jalr	766(ra) # 800062dc <initlock>
      p->state = UNUSED;
    80000fe6:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000fea:	415487b3          	sub	a5,s1,s5
    80000fee:	878d                	srai	a5,a5,0x3
    80000ff0:	000a3703          	ld	a4,0(s4)
    80000ff4:	02e787b3          	mul	a5,a5,a4
    80000ff8:	2785                	addiw	a5,a5,1
    80000ffa:	00d7979b          	slliw	a5,a5,0xd
    80000ffe:	40f907b3          	sub	a5,s2,a5
    80001002:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001004:	16848493          	addi	s1,s1,360
    80001008:	fd3499e3          	bne	s1,s3,80000fda <procinit+0x6e>
  }
}
    8000100c:	70e2                	ld	ra,56(sp)
    8000100e:	7442                	ld	s0,48(sp)
    80001010:	74a2                	ld	s1,40(sp)
    80001012:	7902                	ld	s2,32(sp)
    80001014:	69e2                	ld	s3,24(sp)
    80001016:	6a42                	ld	s4,16(sp)
    80001018:	6aa2                	ld	s5,8(sp)
    8000101a:	6b02                	ld	s6,0(sp)
    8000101c:	6121                	addi	sp,sp,64
    8000101e:	8082                	ret

0000000080001020 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001020:	1141                	addi	sp,sp,-16
    80001022:	e422                	sd	s0,8(sp)
    80001024:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001026:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001028:	2501                	sext.w	a0,a0
    8000102a:	6422                	ld	s0,8(sp)
    8000102c:	0141                	addi	sp,sp,16
    8000102e:	8082                	ret

0000000080001030 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001030:	1141                	addi	sp,sp,-16
    80001032:	e422                	sd	s0,8(sp)
    80001034:	0800                	addi	s0,sp,16
    80001036:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001038:	2781                	sext.w	a5,a5
    8000103a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000103c:	00228517          	auipc	a0,0x228
    80001040:	8d450513          	addi	a0,a0,-1836 # 80228910 <cpus>
    80001044:	953e                	add	a0,a0,a5
    80001046:	6422                	ld	s0,8(sp)
    80001048:	0141                	addi	sp,sp,16
    8000104a:	8082                	ret

000000008000104c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000104c:	1101                	addi	sp,sp,-32
    8000104e:	ec06                	sd	ra,24(sp)
    80001050:	e822                	sd	s0,16(sp)
    80001052:	e426                	sd	s1,8(sp)
    80001054:	1000                	addi	s0,sp,32
  push_off();
    80001056:	00005097          	auipc	ra,0x5
    8000105a:	2ca080e7          	jalr	714(ra) # 80006320 <push_off>
    8000105e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001060:	2781                	sext.w	a5,a5
    80001062:	079e                	slli	a5,a5,0x7
    80001064:	00228717          	auipc	a4,0x228
    80001068:	87c70713          	addi	a4,a4,-1924 # 802288e0 <pid_lock>
    8000106c:	97ba                	add	a5,a5,a4
    8000106e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001070:	00005097          	auipc	ra,0x5
    80001074:	350080e7          	jalr	848(ra) # 800063c0 <pop_off>
  return p;
}
    80001078:	8526                	mv	a0,s1
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6105                	addi	sp,sp,32
    80001082:	8082                	ret

0000000080001084 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001084:	1141                	addi	sp,sp,-16
    80001086:	e406                	sd	ra,8(sp)
    80001088:	e022                	sd	s0,0(sp)
    8000108a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000108c:	00000097          	auipc	ra,0x0
    80001090:	fc0080e7          	jalr	-64(ra) # 8000104c <myproc>
    80001094:	00005097          	auipc	ra,0x5
    80001098:	38c080e7          	jalr	908(ra) # 80006420 <release>

  if (first) {
    8000109c:	00007797          	auipc	a5,0x7
    800010a0:	7a47a783          	lw	a5,1956(a5) # 80008840 <first.1685>
    800010a4:	eb89                	bnez	a5,800010b6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010a6:	00001097          	auipc	ra,0x1
    800010aa:	c56080e7          	jalr	-938(ra) # 80001cfc <usertrapret>
}
    800010ae:	60a2                	ld	ra,8(sp)
    800010b0:	6402                	ld	s0,0(sp)
    800010b2:	0141                	addi	sp,sp,16
    800010b4:	8082                	ret
    first = 0;
    800010b6:	00007797          	auipc	a5,0x7
    800010ba:	7807a523          	sw	zero,1930(a5) # 80008840 <first.1685>
    fsinit(ROOTDEV);
    800010be:	4505                	li	a0,1
    800010c0:	00002097          	auipc	ra,0x2
    800010c4:	9e0080e7          	jalr	-1568(ra) # 80002aa0 <fsinit>
    800010c8:	bff9                	j	800010a6 <forkret+0x22>

00000000800010ca <allocpid>:
{
    800010ca:	1101                	addi	sp,sp,-32
    800010cc:	ec06                	sd	ra,24(sp)
    800010ce:	e822                	sd	s0,16(sp)
    800010d0:	e426                	sd	s1,8(sp)
    800010d2:	e04a                	sd	s2,0(sp)
    800010d4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010d6:	00228917          	auipc	s2,0x228
    800010da:	80a90913          	addi	s2,s2,-2038 # 802288e0 <pid_lock>
    800010de:	854a                	mv	a0,s2
    800010e0:	00005097          	auipc	ra,0x5
    800010e4:	28c080e7          	jalr	652(ra) # 8000636c <acquire>
  pid = nextpid;
    800010e8:	00007797          	auipc	a5,0x7
    800010ec:	75c78793          	addi	a5,a5,1884 # 80008844 <nextpid>
    800010f0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010f2:	0014871b          	addiw	a4,s1,1
    800010f6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010f8:	854a                	mv	a0,s2
    800010fa:	00005097          	auipc	ra,0x5
    800010fe:	326080e7          	jalr	806(ra) # 80006420 <release>
}
    80001102:	8526                	mv	a0,s1
    80001104:	60e2                	ld	ra,24(sp)
    80001106:	6442                	ld	s0,16(sp)
    80001108:	64a2                	ld	s1,8(sp)
    8000110a:	6902                	ld	s2,0(sp)
    8000110c:	6105                	addi	sp,sp,32
    8000110e:	8082                	ret

0000000080001110 <proc_pagetable>:
{
    80001110:	1101                	addi	sp,sp,-32
    80001112:	ec06                	sd	ra,24(sp)
    80001114:	e822                	sd	s0,16(sp)
    80001116:	e426                	sd	s1,8(sp)
    80001118:	e04a                	sd	s2,0(sp)
    8000111a:	1000                	addi	s0,sp,32
    8000111c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	8aa080e7          	jalr	-1878(ra) # 800009c8 <uvmcreate>
    80001126:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001128:	c121                	beqz	a0,80001168 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000112a:	4729                	li	a4,10
    8000112c:	00006697          	auipc	a3,0x6
    80001130:	ed468693          	addi	a3,a3,-300 # 80007000 <_trampoline>
    80001134:	6605                	lui	a2,0x1
    80001136:	040005b7          	lui	a1,0x4000
    8000113a:	15fd                	addi	a1,a1,-1
    8000113c:	05b2                	slli	a1,a1,0xc
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	600080e7          	jalr	1536(ra) # 8000073e <mappages>
    80001146:	02054863          	bltz	a0,80001176 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000114a:	4719                	li	a4,6
    8000114c:	05893683          	ld	a3,88(s2)
    80001150:	6605                	lui	a2,0x1
    80001152:	020005b7          	lui	a1,0x2000
    80001156:	15fd                	addi	a1,a1,-1
    80001158:	05b6                	slli	a1,a1,0xd
    8000115a:	8526                	mv	a0,s1
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	5e2080e7          	jalr	1506(ra) # 8000073e <mappages>
    80001164:	02054163          	bltz	a0,80001186 <proc_pagetable+0x76>
}
    80001168:	8526                	mv	a0,s1
    8000116a:	60e2                	ld	ra,24(sp)
    8000116c:	6442                	ld	s0,16(sp)
    8000116e:	64a2                	ld	s1,8(sp)
    80001170:	6902                	ld	s2,0(sp)
    80001172:	6105                	addi	sp,sp,32
    80001174:	8082                	ret
    uvmfree(pagetable, 0);
    80001176:	4581                	li	a1,0
    80001178:	8526                	mv	a0,s1
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	a52080e7          	jalr	-1454(ra) # 80000bcc <uvmfree>
    return 0;
    80001182:	4481                	li	s1,0
    80001184:	b7d5                	j	80001168 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001186:	4681                	li	a3,0
    80001188:	4605                	li	a2,1
    8000118a:	040005b7          	lui	a1,0x4000
    8000118e:	15fd                	addi	a1,a1,-1
    80001190:	05b2                	slli	a1,a1,0xc
    80001192:	8526                	mv	a0,s1
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	770080e7          	jalr	1904(ra) # 80000904 <uvmunmap>
    uvmfree(pagetable, 0);
    8000119c:	4581                	li	a1,0
    8000119e:	8526                	mv	a0,s1
    800011a0:	00000097          	auipc	ra,0x0
    800011a4:	a2c080e7          	jalr	-1492(ra) # 80000bcc <uvmfree>
    return 0;
    800011a8:	4481                	li	s1,0
    800011aa:	bf7d                	j	80001168 <proc_pagetable+0x58>

00000000800011ac <proc_freepagetable>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	e04a                	sd	s2,0(sp)
    800011b6:	1000                	addi	s0,sp,32
    800011b8:	84aa                	mv	s1,a0
    800011ba:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011bc:	4681                	li	a3,0
    800011be:	4605                	li	a2,1
    800011c0:	040005b7          	lui	a1,0x4000
    800011c4:	15fd                	addi	a1,a1,-1
    800011c6:	05b2                	slli	a1,a1,0xc
    800011c8:	fffff097          	auipc	ra,0xfffff
    800011cc:	73c080e7          	jalr	1852(ra) # 80000904 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011d0:	4681                	li	a3,0
    800011d2:	4605                	li	a2,1
    800011d4:	020005b7          	lui	a1,0x2000
    800011d8:	15fd                	addi	a1,a1,-1
    800011da:	05b6                	slli	a1,a1,0xd
    800011dc:	8526                	mv	a0,s1
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	726080e7          	jalr	1830(ra) # 80000904 <uvmunmap>
  uvmfree(pagetable, sz);
    800011e6:	85ca                	mv	a1,s2
    800011e8:	8526                	mv	a0,s1
    800011ea:	00000097          	auipc	ra,0x0
    800011ee:	9e2080e7          	jalr	-1566(ra) # 80000bcc <uvmfree>
}
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6902                	ld	s2,0(sp)
    800011fa:	6105                	addi	sp,sp,32
    800011fc:	8082                	ret

00000000800011fe <freeproc>:
{
    800011fe:	1101                	addi	sp,sp,-32
    80001200:	ec06                	sd	ra,24(sp)
    80001202:	e822                	sd	s0,16(sp)
    80001204:	e426                	sd	s1,8(sp)
    80001206:	1000                	addi	s0,sp,32
    80001208:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000120a:	6d28                	ld	a0,88(a0)
    8000120c:	c509                	beqz	a0,80001216 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	e9a080e7          	jalr	-358(ra) # 800000a8 <kfree>
  p->trapframe = 0;
    80001216:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000121a:	68a8                	ld	a0,80(s1)
    8000121c:	c511                	beqz	a0,80001228 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000121e:	64ac                	ld	a1,72(s1)
    80001220:	00000097          	auipc	ra,0x0
    80001224:	f8c080e7          	jalr	-116(ra) # 800011ac <proc_freepagetable>
  p->pagetable = 0;
    80001228:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000122c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001230:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001234:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001238:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000123c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001240:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001244:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001248:	0004ac23          	sw	zero,24(s1)
}
    8000124c:	60e2                	ld	ra,24(sp)
    8000124e:	6442                	ld	s0,16(sp)
    80001250:	64a2                	ld	s1,8(sp)
    80001252:	6105                	addi	sp,sp,32
    80001254:	8082                	ret

0000000080001256 <allocproc>:
{
    80001256:	1101                	addi	sp,sp,-32
    80001258:	ec06                	sd	ra,24(sp)
    8000125a:	e822                	sd	s0,16(sp)
    8000125c:	e426                	sd	s1,8(sp)
    8000125e:	e04a                	sd	s2,0(sp)
    80001260:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001262:	00228497          	auipc	s1,0x228
    80001266:	aae48493          	addi	s1,s1,-1362 # 80228d10 <proc>
    8000126a:	0022d917          	auipc	s2,0x22d
    8000126e:	4a690913          	addi	s2,s2,1190 # 8022e710 <tickslock>
    acquire(&p->lock);
    80001272:	8526                	mv	a0,s1
    80001274:	00005097          	auipc	ra,0x5
    80001278:	0f8080e7          	jalr	248(ra) # 8000636c <acquire>
    if(p->state == UNUSED) {
    8000127c:	4c9c                	lw	a5,24(s1)
    8000127e:	cf81                	beqz	a5,80001296 <allocproc+0x40>
      release(&p->lock);
    80001280:	8526                	mv	a0,s1
    80001282:	00005097          	auipc	ra,0x5
    80001286:	19e080e7          	jalr	414(ra) # 80006420 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000128a:	16848493          	addi	s1,s1,360
    8000128e:	ff2492e3          	bne	s1,s2,80001272 <allocproc+0x1c>
  return 0;
    80001292:	4481                	li	s1,0
    80001294:	a889                	j	800012e6 <allocproc+0x90>
  p->pid = allocpid();
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	e34080e7          	jalr	-460(ra) # 800010ca <allocpid>
    8000129e:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012a0:	4785                	li	a5,1
    800012a2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	f4a080e7          	jalr	-182(ra) # 800001ee <kalloc>
    800012ac:	892a                	mv	s2,a0
    800012ae:	eca8                	sd	a0,88(s1)
    800012b0:	c131                	beqz	a0,800012f4 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012b2:	8526                	mv	a0,s1
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	e5c080e7          	jalr	-420(ra) # 80001110 <proc_pagetable>
    800012bc:	892a                	mv	s2,a0
    800012be:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012c0:	c531                	beqz	a0,8000130c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012c2:	07000613          	li	a2,112
    800012c6:	4581                	li	a1,0
    800012c8:	06048513          	addi	a0,s1,96
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	09e080e7          	jalr	158(ra) # 8000036a <memset>
  p->context.ra = (uint64)forkret;
    800012d4:	00000797          	auipc	a5,0x0
    800012d8:	db078793          	addi	a5,a5,-592 # 80001084 <forkret>
    800012dc:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012de:	60bc                	ld	a5,64(s1)
    800012e0:	6705                	lui	a4,0x1
    800012e2:	97ba                	add	a5,a5,a4
    800012e4:	f4bc                	sd	a5,104(s1)
}
    800012e6:	8526                	mv	a0,s1
    800012e8:	60e2                	ld	ra,24(sp)
    800012ea:	6442                	ld	s0,16(sp)
    800012ec:	64a2                	ld	s1,8(sp)
    800012ee:	6902                	ld	s2,0(sp)
    800012f0:	6105                	addi	sp,sp,32
    800012f2:	8082                	ret
    freeproc(p);
    800012f4:	8526                	mv	a0,s1
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	f08080e7          	jalr	-248(ra) # 800011fe <freeproc>
    release(&p->lock);
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	120080e7          	jalr	288(ra) # 80006420 <release>
    return 0;
    80001308:	84ca                	mv	s1,s2
    8000130a:	bff1                	j	800012e6 <allocproc+0x90>
    freeproc(p);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	ef0080e7          	jalr	-272(ra) # 800011fe <freeproc>
    release(&p->lock);
    80001316:	8526                	mv	a0,s1
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	108080e7          	jalr	264(ra) # 80006420 <release>
    return 0;
    80001320:	84ca                	mv	s1,s2
    80001322:	b7d1                	j	800012e6 <allocproc+0x90>

0000000080001324 <userinit>:
{
    80001324:	1101                	addi	sp,sp,-32
    80001326:	ec06                	sd	ra,24(sp)
    80001328:	e822                	sd	s0,16(sp)
    8000132a:	e426                	sd	s1,8(sp)
    8000132c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000132e:	00000097          	auipc	ra,0x0
    80001332:	f28080e7          	jalr	-216(ra) # 80001256 <allocproc>
    80001336:	84aa                	mv	s1,a0
  initproc = p;
    80001338:	00007797          	auipc	a5,0x7
    8000133c:	56a7b423          	sd	a0,1384(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001340:	03400613          	li	a2,52
    80001344:	00007597          	auipc	a1,0x7
    80001348:	50c58593          	addi	a1,a1,1292 # 80008850 <initcode>
    8000134c:	6928                	ld	a0,80(a0)
    8000134e:	fffff097          	auipc	ra,0xfffff
    80001352:	6a8080e7          	jalr	1704(ra) # 800009f6 <uvmfirst>
  p->sz = PGSIZE;
    80001356:	6785                	lui	a5,0x1
    80001358:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000135a:	6cb8                	ld	a4,88(s1)
    8000135c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001360:	6cb8                	ld	a4,88(s1)
    80001362:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001364:	4641                	li	a2,16
    80001366:	00007597          	auipc	a1,0x7
    8000136a:	e1a58593          	addi	a1,a1,-486 # 80008180 <etext+0x180>
    8000136e:	15848513          	addi	a0,s1,344
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	14a080e7          	jalr	330(ra) # 800004bc <safestrcpy>
  p->cwd = namei("/");
    8000137a:	00007517          	auipc	a0,0x7
    8000137e:	e1650513          	addi	a0,a0,-490 # 80008190 <etext+0x190>
    80001382:	00002097          	auipc	ra,0x2
    80001386:	140080e7          	jalr	320(ra) # 800034c2 <namei>
    8000138a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000138e:	478d                	li	a5,3
    80001390:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001392:	8526                	mv	a0,s1
    80001394:	00005097          	auipc	ra,0x5
    80001398:	08c080e7          	jalr	140(ra) # 80006420 <release>
}
    8000139c:	60e2                	ld	ra,24(sp)
    8000139e:	6442                	ld	s0,16(sp)
    800013a0:	64a2                	ld	s1,8(sp)
    800013a2:	6105                	addi	sp,sp,32
    800013a4:	8082                	ret

00000000800013a6 <growproc>:
{
    800013a6:	1101                	addi	sp,sp,-32
    800013a8:	ec06                	sd	ra,24(sp)
    800013aa:	e822                	sd	s0,16(sp)
    800013ac:	e426                	sd	s1,8(sp)
    800013ae:	e04a                	sd	s2,0(sp)
    800013b0:	1000                	addi	s0,sp,32
    800013b2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	c98080e7          	jalr	-872(ra) # 8000104c <myproc>
    800013bc:	84aa                	mv	s1,a0
  sz = p->sz;
    800013be:	652c                	ld	a1,72(a0)
  if(n > 0){
    800013c0:	01204c63          	bgtz	s2,800013d8 <growproc+0x32>
  } else if(n < 0){
    800013c4:	02094663          	bltz	s2,800013f0 <growproc+0x4a>
  p->sz = sz;
    800013c8:	e4ac                	sd	a1,72(s1)
  return 0;
    800013ca:	4501                	li	a0,0
}
    800013cc:	60e2                	ld	ra,24(sp)
    800013ce:	6442                	ld	s0,16(sp)
    800013d0:	64a2                	ld	s1,8(sp)
    800013d2:	6902                	ld	s2,0(sp)
    800013d4:	6105                	addi	sp,sp,32
    800013d6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800013d8:	4691                	li	a3,4
    800013da:	00b90633          	add	a2,s2,a1
    800013de:	6928                	ld	a0,80(a0)
    800013e0:	fffff097          	auipc	ra,0xfffff
    800013e4:	6d0080e7          	jalr	1744(ra) # 80000ab0 <uvmalloc>
    800013e8:	85aa                	mv	a1,a0
    800013ea:	fd79                	bnez	a0,800013c8 <growproc+0x22>
      return -1;
    800013ec:	557d                	li	a0,-1
    800013ee:	bff9                	j	800013cc <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013f0:	00b90633          	add	a2,s2,a1
    800013f4:	6928                	ld	a0,80(a0)
    800013f6:	fffff097          	auipc	ra,0xfffff
    800013fa:	672080e7          	jalr	1650(ra) # 80000a68 <uvmdealloc>
    800013fe:	85aa                	mv	a1,a0
    80001400:	b7e1                	j	800013c8 <growproc+0x22>

0000000080001402 <fork>:
{
    80001402:	7179                	addi	sp,sp,-48
    80001404:	f406                	sd	ra,40(sp)
    80001406:	f022                	sd	s0,32(sp)
    80001408:	ec26                	sd	s1,24(sp)
    8000140a:	e84a                	sd	s2,16(sp)
    8000140c:	e44e                	sd	s3,8(sp)
    8000140e:	e052                	sd	s4,0(sp)
    80001410:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001412:	00000097          	auipc	ra,0x0
    80001416:	c3a080e7          	jalr	-966(ra) # 8000104c <myproc>
    8000141a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000141c:	00000097          	auipc	ra,0x0
    80001420:	e3a080e7          	jalr	-454(ra) # 80001256 <allocproc>
    80001424:	10050b63          	beqz	a0,8000153a <fork+0x138>
    80001428:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000142a:	04893603          	ld	a2,72(s2)
    8000142e:	692c                	ld	a1,80(a0)
    80001430:	05093503          	ld	a0,80(s2)
    80001434:	fffff097          	auipc	ra,0xfffff
    80001438:	7d0080e7          	jalr	2000(ra) # 80000c04 <uvmcopy>
    8000143c:	04054663          	bltz	a0,80001488 <fork+0x86>
  np->sz = p->sz;
    80001440:	04893783          	ld	a5,72(s2)
    80001444:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001448:	05893683          	ld	a3,88(s2)
    8000144c:	87b6                	mv	a5,a3
    8000144e:	0589b703          	ld	a4,88(s3)
    80001452:	12068693          	addi	a3,a3,288
    80001456:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000145a:	6788                	ld	a0,8(a5)
    8000145c:	6b8c                	ld	a1,16(a5)
    8000145e:	6f90                	ld	a2,24(a5)
    80001460:	01073023          	sd	a6,0(a4)
    80001464:	e708                	sd	a0,8(a4)
    80001466:	eb0c                	sd	a1,16(a4)
    80001468:	ef10                	sd	a2,24(a4)
    8000146a:	02078793          	addi	a5,a5,32
    8000146e:	02070713          	addi	a4,a4,32
    80001472:	fed792e3          	bne	a5,a3,80001456 <fork+0x54>
  np->trapframe->a0 = 0;
    80001476:	0589b783          	ld	a5,88(s3)
    8000147a:	0607b823          	sd	zero,112(a5)
    8000147e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001482:	15000a13          	li	s4,336
    80001486:	a03d                	j	800014b4 <fork+0xb2>
    freeproc(np);
    80001488:	854e                	mv	a0,s3
    8000148a:	00000097          	auipc	ra,0x0
    8000148e:	d74080e7          	jalr	-652(ra) # 800011fe <freeproc>
    release(&np->lock);
    80001492:	854e                	mv	a0,s3
    80001494:	00005097          	auipc	ra,0x5
    80001498:	f8c080e7          	jalr	-116(ra) # 80006420 <release>
    return -1;
    8000149c:	5a7d                	li	s4,-1
    8000149e:	a069                	j	80001528 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800014a0:	00002097          	auipc	ra,0x2
    800014a4:	6b8080e7          	jalr	1720(ra) # 80003b58 <filedup>
    800014a8:	009987b3          	add	a5,s3,s1
    800014ac:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014ae:	04a1                	addi	s1,s1,8
    800014b0:	01448763          	beq	s1,s4,800014be <fork+0xbc>
    if(p->ofile[i])
    800014b4:	009907b3          	add	a5,s2,s1
    800014b8:	6388                	ld	a0,0(a5)
    800014ba:	f17d                	bnez	a0,800014a0 <fork+0x9e>
    800014bc:	bfcd                	j	800014ae <fork+0xac>
  np->cwd = idup(p->cwd);
    800014be:	15093503          	ld	a0,336(s2)
    800014c2:	00002097          	auipc	ra,0x2
    800014c6:	81c080e7          	jalr	-2020(ra) # 80002cde <idup>
    800014ca:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014ce:	4641                	li	a2,16
    800014d0:	15890593          	addi	a1,s2,344
    800014d4:	15898513          	addi	a0,s3,344
    800014d8:	fffff097          	auipc	ra,0xfffff
    800014dc:	fe4080e7          	jalr	-28(ra) # 800004bc <safestrcpy>
  pid = np->pid;
    800014e0:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800014e4:	854e                	mv	a0,s3
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	f3a080e7          	jalr	-198(ra) # 80006420 <release>
  acquire(&wait_lock);
    800014ee:	00227497          	auipc	s1,0x227
    800014f2:	40a48493          	addi	s1,s1,1034 # 802288f8 <wait_lock>
    800014f6:	8526                	mv	a0,s1
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	e74080e7          	jalr	-396(ra) # 8000636c <acquire>
  np->parent = p;
    80001500:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001504:	8526                	mv	a0,s1
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	f1a080e7          	jalr	-230(ra) # 80006420 <release>
  acquire(&np->lock);
    8000150e:	854e                	mv	a0,s3
    80001510:	00005097          	auipc	ra,0x5
    80001514:	e5c080e7          	jalr	-420(ra) # 8000636c <acquire>
  np->state = RUNNABLE;
    80001518:	478d                	li	a5,3
    8000151a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000151e:	854e                	mv	a0,s3
    80001520:	00005097          	auipc	ra,0x5
    80001524:	f00080e7          	jalr	-256(ra) # 80006420 <release>
}
    80001528:	8552                	mv	a0,s4
    8000152a:	70a2                	ld	ra,40(sp)
    8000152c:	7402                	ld	s0,32(sp)
    8000152e:	64e2                	ld	s1,24(sp)
    80001530:	6942                	ld	s2,16(sp)
    80001532:	69a2                	ld	s3,8(sp)
    80001534:	6a02                	ld	s4,0(sp)
    80001536:	6145                	addi	sp,sp,48
    80001538:	8082                	ret
    return -1;
    8000153a:	5a7d                	li	s4,-1
    8000153c:	b7f5                	j	80001528 <fork+0x126>

000000008000153e <scheduler>:
{
    8000153e:	7139                	addi	sp,sp,-64
    80001540:	fc06                	sd	ra,56(sp)
    80001542:	f822                	sd	s0,48(sp)
    80001544:	f426                	sd	s1,40(sp)
    80001546:	f04a                	sd	s2,32(sp)
    80001548:	ec4e                	sd	s3,24(sp)
    8000154a:	e852                	sd	s4,16(sp)
    8000154c:	e456                	sd	s5,8(sp)
    8000154e:	e05a                	sd	s6,0(sp)
    80001550:	0080                	addi	s0,sp,64
    80001552:	8792                	mv	a5,tp
  int id = r_tp();
    80001554:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001556:	00779a93          	slli	s5,a5,0x7
    8000155a:	00227717          	auipc	a4,0x227
    8000155e:	38670713          	addi	a4,a4,902 # 802288e0 <pid_lock>
    80001562:	9756                	add	a4,a4,s5
    80001564:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001568:	00227717          	auipc	a4,0x227
    8000156c:	3b070713          	addi	a4,a4,944 # 80228918 <cpus+0x8>
    80001570:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001572:	498d                	li	s3,3
        p->state = RUNNING;
    80001574:	4b11                	li	s6,4
        c->proc = p;
    80001576:	079e                	slli	a5,a5,0x7
    80001578:	00227a17          	auipc	s4,0x227
    8000157c:	368a0a13          	addi	s4,s4,872 # 802288e0 <pid_lock>
    80001580:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001582:	0022d917          	auipc	s2,0x22d
    80001586:	18e90913          	addi	s2,s2,398 # 8022e710 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000158a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000158e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001592:	10079073          	csrw	sstatus,a5
    80001596:	00227497          	auipc	s1,0x227
    8000159a:	77a48493          	addi	s1,s1,1914 # 80228d10 <proc>
    8000159e:	a03d                	j	800015cc <scheduler+0x8e>
        p->state = RUNNING;
    800015a0:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015a4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015a8:	06048593          	addi	a1,s1,96
    800015ac:	8556                	mv	a0,s5
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	6a4080e7          	jalr	1700(ra) # 80001c52 <swtch>
        c->proc = 0;
    800015b6:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015ba:	8526                	mv	a0,s1
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	e64080e7          	jalr	-412(ra) # 80006420 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015c4:	16848493          	addi	s1,s1,360
    800015c8:	fd2481e3          	beq	s1,s2,8000158a <scheduler+0x4c>
      acquire(&p->lock);
    800015cc:	8526                	mv	a0,s1
    800015ce:	00005097          	auipc	ra,0x5
    800015d2:	d9e080e7          	jalr	-610(ra) # 8000636c <acquire>
      if(p->state == RUNNABLE) {
    800015d6:	4c9c                	lw	a5,24(s1)
    800015d8:	ff3791e3          	bne	a5,s3,800015ba <scheduler+0x7c>
    800015dc:	b7d1                	j	800015a0 <scheduler+0x62>

00000000800015de <sched>:
{
    800015de:	7179                	addi	sp,sp,-48
    800015e0:	f406                	sd	ra,40(sp)
    800015e2:	f022                	sd	s0,32(sp)
    800015e4:	ec26                	sd	s1,24(sp)
    800015e6:	e84a                	sd	s2,16(sp)
    800015e8:	e44e                	sd	s3,8(sp)
    800015ea:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	a60080e7          	jalr	-1440(ra) # 8000104c <myproc>
    800015f4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015f6:	00005097          	auipc	ra,0x5
    800015fa:	cfc080e7          	jalr	-772(ra) # 800062f2 <holding>
    800015fe:	c93d                	beqz	a0,80001674 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001600:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001602:	2781                	sext.w	a5,a5
    80001604:	079e                	slli	a5,a5,0x7
    80001606:	00227717          	auipc	a4,0x227
    8000160a:	2da70713          	addi	a4,a4,730 # 802288e0 <pid_lock>
    8000160e:	97ba                	add	a5,a5,a4
    80001610:	0a87a703          	lw	a4,168(a5)
    80001614:	4785                	li	a5,1
    80001616:	06f71763          	bne	a4,a5,80001684 <sched+0xa6>
  if(p->state == RUNNING)
    8000161a:	4c98                	lw	a4,24(s1)
    8000161c:	4791                	li	a5,4
    8000161e:	06f70b63          	beq	a4,a5,80001694 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001622:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001626:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001628:	efb5                	bnez	a5,800016a4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000162a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000162c:	00227917          	auipc	s2,0x227
    80001630:	2b490913          	addi	s2,s2,692 # 802288e0 <pid_lock>
    80001634:	2781                	sext.w	a5,a5
    80001636:	079e                	slli	a5,a5,0x7
    80001638:	97ca                	add	a5,a5,s2
    8000163a:	0ac7a983          	lw	s3,172(a5)
    8000163e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001640:	2781                	sext.w	a5,a5
    80001642:	079e                	slli	a5,a5,0x7
    80001644:	00227597          	auipc	a1,0x227
    80001648:	2d458593          	addi	a1,a1,724 # 80228918 <cpus+0x8>
    8000164c:	95be                	add	a1,a1,a5
    8000164e:	06048513          	addi	a0,s1,96
    80001652:	00000097          	auipc	ra,0x0
    80001656:	600080e7          	jalr	1536(ra) # 80001c52 <swtch>
    8000165a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000165c:	2781                	sext.w	a5,a5
    8000165e:	079e                	slli	a5,a5,0x7
    80001660:	97ca                	add	a5,a5,s2
    80001662:	0b37a623          	sw	s3,172(a5)
}
    80001666:	70a2                	ld	ra,40(sp)
    80001668:	7402                	ld	s0,32(sp)
    8000166a:	64e2                	ld	s1,24(sp)
    8000166c:	6942                	ld	s2,16(sp)
    8000166e:	69a2                	ld	s3,8(sp)
    80001670:	6145                	addi	sp,sp,48
    80001672:	8082                	ret
    panic("sched p->lock");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b2450513          	addi	a0,a0,-1244 # 80008198 <etext+0x198>
    8000167c:	00004097          	auipc	ra,0x4
    80001680:	7a6080e7          	jalr	1958(ra) # 80005e22 <panic>
    panic("sched locks");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	b2450513          	addi	a0,a0,-1244 # 800081a8 <etext+0x1a8>
    8000168c:	00004097          	auipc	ra,0x4
    80001690:	796080e7          	jalr	1942(ra) # 80005e22 <panic>
    panic("sched running");
    80001694:	00007517          	auipc	a0,0x7
    80001698:	b2450513          	addi	a0,a0,-1244 # 800081b8 <etext+0x1b8>
    8000169c:	00004097          	auipc	ra,0x4
    800016a0:	786080e7          	jalr	1926(ra) # 80005e22 <panic>
    panic("sched interruptible");
    800016a4:	00007517          	auipc	a0,0x7
    800016a8:	b2450513          	addi	a0,a0,-1244 # 800081c8 <etext+0x1c8>
    800016ac:	00004097          	auipc	ra,0x4
    800016b0:	776080e7          	jalr	1910(ra) # 80005e22 <panic>

00000000800016b4 <yield>:
{
    800016b4:	1101                	addi	sp,sp,-32
    800016b6:	ec06                	sd	ra,24(sp)
    800016b8:	e822                	sd	s0,16(sp)
    800016ba:	e426                	sd	s1,8(sp)
    800016bc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	98e080e7          	jalr	-1650(ra) # 8000104c <myproc>
    800016c6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	ca4080e7          	jalr	-860(ra) # 8000636c <acquire>
  p->state = RUNNABLE;
    800016d0:	478d                	li	a5,3
    800016d2:	cc9c                	sw	a5,24(s1)
  sched();
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	f0a080e7          	jalr	-246(ra) # 800015de <sched>
  release(&p->lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	d42080e7          	jalr	-702(ra) # 80006420 <release>
}
    800016e6:	60e2                	ld	ra,24(sp)
    800016e8:	6442                	ld	s0,16(sp)
    800016ea:	64a2                	ld	s1,8(sp)
    800016ec:	6105                	addi	sp,sp,32
    800016ee:	8082                	ret

00000000800016f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016f0:	7179                	addi	sp,sp,-48
    800016f2:	f406                	sd	ra,40(sp)
    800016f4:	f022                	sd	s0,32(sp)
    800016f6:	ec26                	sd	s1,24(sp)
    800016f8:	e84a                	sd	s2,16(sp)
    800016fa:	e44e                	sd	s3,8(sp)
    800016fc:	1800                	addi	s0,sp,48
    800016fe:	89aa                	mv	s3,a0
    80001700:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001702:	00000097          	auipc	ra,0x0
    80001706:	94a080e7          	jalr	-1718(ra) # 8000104c <myproc>
    8000170a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	c60080e7          	jalr	-928(ra) # 8000636c <acquire>
  release(lk);
    80001714:	854a                	mv	a0,s2
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	d0a080e7          	jalr	-758(ra) # 80006420 <release>

  // Go to sleep.
  p->chan = chan;
    8000171e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001722:	4789                	li	a5,2
    80001724:	cc9c                	sw	a5,24(s1)

  sched();
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	eb8080e7          	jalr	-328(ra) # 800015de <sched>

  // Tidy up.
  p->chan = 0;
    8000172e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	cec080e7          	jalr	-788(ra) # 80006420 <release>
  acquire(lk);
    8000173c:	854a                	mv	a0,s2
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	c2e080e7          	jalr	-978(ra) # 8000636c <acquire>
}
    80001746:	70a2                	ld	ra,40(sp)
    80001748:	7402                	ld	s0,32(sp)
    8000174a:	64e2                	ld	s1,24(sp)
    8000174c:	6942                	ld	s2,16(sp)
    8000174e:	69a2                	ld	s3,8(sp)
    80001750:	6145                	addi	sp,sp,48
    80001752:	8082                	ret

0000000080001754 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001754:	7139                	addi	sp,sp,-64
    80001756:	fc06                	sd	ra,56(sp)
    80001758:	f822                	sd	s0,48(sp)
    8000175a:	f426                	sd	s1,40(sp)
    8000175c:	f04a                	sd	s2,32(sp)
    8000175e:	ec4e                	sd	s3,24(sp)
    80001760:	e852                	sd	s4,16(sp)
    80001762:	e456                	sd	s5,8(sp)
    80001764:	0080                	addi	s0,sp,64
    80001766:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001768:	00227497          	auipc	s1,0x227
    8000176c:	5a848493          	addi	s1,s1,1448 # 80228d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001770:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001772:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001774:	0022d917          	auipc	s2,0x22d
    80001778:	f9c90913          	addi	s2,s2,-100 # 8022e710 <tickslock>
    8000177c:	a821                	j	80001794 <wakeup+0x40>
        p->state = RUNNABLE;
    8000177e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001782:	8526                	mv	a0,s1
    80001784:	00005097          	auipc	ra,0x5
    80001788:	c9c080e7          	jalr	-868(ra) # 80006420 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000178c:	16848493          	addi	s1,s1,360
    80001790:	03248463          	beq	s1,s2,800017b8 <wakeup+0x64>
    if(p != myproc()){
    80001794:	00000097          	auipc	ra,0x0
    80001798:	8b8080e7          	jalr	-1864(ra) # 8000104c <myproc>
    8000179c:	fea488e3          	beq	s1,a0,8000178c <wakeup+0x38>
      acquire(&p->lock);
    800017a0:	8526                	mv	a0,s1
    800017a2:	00005097          	auipc	ra,0x5
    800017a6:	bca080e7          	jalr	-1078(ra) # 8000636c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017aa:	4c9c                	lw	a5,24(s1)
    800017ac:	fd379be3          	bne	a5,s3,80001782 <wakeup+0x2e>
    800017b0:	709c                	ld	a5,32(s1)
    800017b2:	fd4798e3          	bne	a5,s4,80001782 <wakeup+0x2e>
    800017b6:	b7e1                	j	8000177e <wakeup+0x2a>
    }
  }
}
    800017b8:	70e2                	ld	ra,56(sp)
    800017ba:	7442                	ld	s0,48(sp)
    800017bc:	74a2                	ld	s1,40(sp)
    800017be:	7902                	ld	s2,32(sp)
    800017c0:	69e2                	ld	s3,24(sp)
    800017c2:	6a42                	ld	s4,16(sp)
    800017c4:	6aa2                	ld	s5,8(sp)
    800017c6:	6121                	addi	sp,sp,64
    800017c8:	8082                	ret

00000000800017ca <reparent>:
{
    800017ca:	7179                	addi	sp,sp,-48
    800017cc:	f406                	sd	ra,40(sp)
    800017ce:	f022                	sd	s0,32(sp)
    800017d0:	ec26                	sd	s1,24(sp)
    800017d2:	e84a                	sd	s2,16(sp)
    800017d4:	e44e                	sd	s3,8(sp)
    800017d6:	e052                	sd	s4,0(sp)
    800017d8:	1800                	addi	s0,sp,48
    800017da:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017dc:	00227497          	auipc	s1,0x227
    800017e0:	53448493          	addi	s1,s1,1332 # 80228d10 <proc>
      pp->parent = initproc;
    800017e4:	00007a17          	auipc	s4,0x7
    800017e8:	0bca0a13          	addi	s4,s4,188 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ec:	0022d997          	auipc	s3,0x22d
    800017f0:	f2498993          	addi	s3,s3,-220 # 8022e710 <tickslock>
    800017f4:	a029                	j	800017fe <reparent+0x34>
    800017f6:	16848493          	addi	s1,s1,360
    800017fa:	01348d63          	beq	s1,s3,80001814 <reparent+0x4a>
    if(pp->parent == p){
    800017fe:	7c9c                	ld	a5,56(s1)
    80001800:	ff279be3          	bne	a5,s2,800017f6 <reparent+0x2c>
      pp->parent = initproc;
    80001804:	000a3503          	ld	a0,0(s4)
    80001808:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000180a:	00000097          	auipc	ra,0x0
    8000180e:	f4a080e7          	jalr	-182(ra) # 80001754 <wakeup>
    80001812:	b7d5                	j	800017f6 <reparent+0x2c>
}
    80001814:	70a2                	ld	ra,40(sp)
    80001816:	7402                	ld	s0,32(sp)
    80001818:	64e2                	ld	s1,24(sp)
    8000181a:	6942                	ld	s2,16(sp)
    8000181c:	69a2                	ld	s3,8(sp)
    8000181e:	6a02                	ld	s4,0(sp)
    80001820:	6145                	addi	sp,sp,48
    80001822:	8082                	ret

0000000080001824 <exit>:
{
    80001824:	7179                	addi	sp,sp,-48
    80001826:	f406                	sd	ra,40(sp)
    80001828:	f022                	sd	s0,32(sp)
    8000182a:	ec26                	sd	s1,24(sp)
    8000182c:	e84a                	sd	s2,16(sp)
    8000182e:	e44e                	sd	s3,8(sp)
    80001830:	e052                	sd	s4,0(sp)
    80001832:	1800                	addi	s0,sp,48
    80001834:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	816080e7          	jalr	-2026(ra) # 8000104c <myproc>
    8000183e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001840:	00007797          	auipc	a5,0x7
    80001844:	0607b783          	ld	a5,96(a5) # 800088a0 <initproc>
    80001848:	0d050493          	addi	s1,a0,208
    8000184c:	15050913          	addi	s2,a0,336
    80001850:	02a79363          	bne	a5,a0,80001876 <exit+0x52>
    panic("init exiting");
    80001854:	00007517          	auipc	a0,0x7
    80001858:	98c50513          	addi	a0,a0,-1652 # 800081e0 <etext+0x1e0>
    8000185c:	00004097          	auipc	ra,0x4
    80001860:	5c6080e7          	jalr	1478(ra) # 80005e22 <panic>
      fileclose(f);
    80001864:	00002097          	auipc	ra,0x2
    80001868:	346080e7          	jalr	838(ra) # 80003baa <fileclose>
      p->ofile[fd] = 0;
    8000186c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001870:	04a1                	addi	s1,s1,8
    80001872:	01248563          	beq	s1,s2,8000187c <exit+0x58>
    if(p->ofile[fd]){
    80001876:	6088                	ld	a0,0(s1)
    80001878:	f575                	bnez	a0,80001864 <exit+0x40>
    8000187a:	bfdd                	j	80001870 <exit+0x4c>
  begin_op();
    8000187c:	00002097          	auipc	ra,0x2
    80001880:	e62080e7          	jalr	-414(ra) # 800036de <begin_op>
  iput(p->cwd);
    80001884:	1509b503          	ld	a0,336(s3)
    80001888:	00001097          	auipc	ra,0x1
    8000188c:	64e080e7          	jalr	1614(ra) # 80002ed6 <iput>
  end_op();
    80001890:	00002097          	auipc	ra,0x2
    80001894:	ece080e7          	jalr	-306(ra) # 8000375e <end_op>
  p->cwd = 0;
    80001898:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000189c:	00227497          	auipc	s1,0x227
    800018a0:	05c48493          	addi	s1,s1,92 # 802288f8 <wait_lock>
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	ac6080e7          	jalr	-1338(ra) # 8000636c <acquire>
  reparent(p);
    800018ae:	854e                	mv	a0,s3
    800018b0:	00000097          	auipc	ra,0x0
    800018b4:	f1a080e7          	jalr	-230(ra) # 800017ca <reparent>
  wakeup(p->parent);
    800018b8:	0389b503          	ld	a0,56(s3)
    800018bc:	00000097          	auipc	ra,0x0
    800018c0:	e98080e7          	jalr	-360(ra) # 80001754 <wakeup>
  acquire(&p->lock);
    800018c4:	854e                	mv	a0,s3
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	aa6080e7          	jalr	-1370(ra) # 8000636c <acquire>
  p->xstate = status;
    800018ce:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018d2:	4795                	li	a5,5
    800018d4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	b46080e7          	jalr	-1210(ra) # 80006420 <release>
  sched();
    800018e2:	00000097          	auipc	ra,0x0
    800018e6:	cfc080e7          	jalr	-772(ra) # 800015de <sched>
  panic("zombie exit");
    800018ea:	00007517          	auipc	a0,0x7
    800018ee:	90650513          	addi	a0,a0,-1786 # 800081f0 <etext+0x1f0>
    800018f2:	00004097          	auipc	ra,0x4
    800018f6:	530080e7          	jalr	1328(ra) # 80005e22 <panic>

00000000800018fa <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	1800                	addi	s0,sp,48
    80001908:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000190a:	00227497          	auipc	s1,0x227
    8000190e:	40648493          	addi	s1,s1,1030 # 80228d10 <proc>
    80001912:	0022d997          	auipc	s3,0x22d
    80001916:	dfe98993          	addi	s3,s3,-514 # 8022e710 <tickslock>
    acquire(&p->lock);
    8000191a:	8526                	mv	a0,s1
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	a50080e7          	jalr	-1456(ra) # 8000636c <acquire>
    if(p->pid == pid){
    80001924:	589c                	lw	a5,48(s1)
    80001926:	01278d63          	beq	a5,s2,80001940 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	af4080e7          	jalr	-1292(ra) # 80006420 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001934:	16848493          	addi	s1,s1,360
    80001938:	ff3491e3          	bne	s1,s3,8000191a <kill+0x20>
  }
  return -1;
    8000193c:	557d                	li	a0,-1
    8000193e:	a829                	j	80001958 <kill+0x5e>
      p->killed = 1;
    80001940:	4785                	li	a5,1
    80001942:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001944:	4c98                	lw	a4,24(s1)
    80001946:	4789                	li	a5,2
    80001948:	00f70f63          	beq	a4,a5,80001966 <kill+0x6c>
      release(&p->lock);
    8000194c:	8526                	mv	a0,s1
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	ad2080e7          	jalr	-1326(ra) # 80006420 <release>
      return 0;
    80001956:	4501                	li	a0,0
}
    80001958:	70a2                	ld	ra,40(sp)
    8000195a:	7402                	ld	s0,32(sp)
    8000195c:	64e2                	ld	s1,24(sp)
    8000195e:	6942                	ld	s2,16(sp)
    80001960:	69a2                	ld	s3,8(sp)
    80001962:	6145                	addi	sp,sp,48
    80001964:	8082                	ret
        p->state = RUNNABLE;
    80001966:	478d                	li	a5,3
    80001968:	cc9c                	sw	a5,24(s1)
    8000196a:	b7cd                	j	8000194c <kill+0x52>

000000008000196c <setkilled>:

void
setkilled(struct proc *p)
{
    8000196c:	1101                	addi	sp,sp,-32
    8000196e:	ec06                	sd	ra,24(sp)
    80001970:	e822                	sd	s0,16(sp)
    80001972:	e426                	sd	s1,8(sp)
    80001974:	1000                	addi	s0,sp,32
    80001976:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	9f4080e7          	jalr	-1548(ra) # 8000636c <acquire>
  p->killed = 1;
    80001980:	4785                	li	a5,1
    80001982:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001984:	8526                	mv	a0,s1
    80001986:	00005097          	auipc	ra,0x5
    8000198a:	a9a080e7          	jalr	-1382(ra) # 80006420 <release>
}
    8000198e:	60e2                	ld	ra,24(sp)
    80001990:	6442                	ld	s0,16(sp)
    80001992:	64a2                	ld	s1,8(sp)
    80001994:	6105                	addi	sp,sp,32
    80001996:	8082                	ret

0000000080001998 <killed>:

int
killed(struct proc *p)
{
    80001998:	1101                	addi	sp,sp,-32
    8000199a:	ec06                	sd	ra,24(sp)
    8000199c:	e822                	sd	s0,16(sp)
    8000199e:	e426                	sd	s1,8(sp)
    800019a0:	e04a                	sd	s2,0(sp)
    800019a2:	1000                	addi	s0,sp,32
    800019a4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019a6:	00005097          	auipc	ra,0x5
    800019aa:	9c6080e7          	jalr	-1594(ra) # 8000636c <acquire>
  k = p->killed;
    800019ae:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	a6c080e7          	jalr	-1428(ra) # 80006420 <release>
  return k;
}
    800019bc:	854a                	mv	a0,s2
    800019be:	60e2                	ld	ra,24(sp)
    800019c0:	6442                	ld	s0,16(sp)
    800019c2:	64a2                	ld	s1,8(sp)
    800019c4:	6902                	ld	s2,0(sp)
    800019c6:	6105                	addi	sp,sp,32
    800019c8:	8082                	ret

00000000800019ca <wait>:
{
    800019ca:	715d                	addi	sp,sp,-80
    800019cc:	e486                	sd	ra,72(sp)
    800019ce:	e0a2                	sd	s0,64(sp)
    800019d0:	fc26                	sd	s1,56(sp)
    800019d2:	f84a                	sd	s2,48(sp)
    800019d4:	f44e                	sd	s3,40(sp)
    800019d6:	f052                	sd	s4,32(sp)
    800019d8:	ec56                	sd	s5,24(sp)
    800019da:	e85a                	sd	s6,16(sp)
    800019dc:	e45e                	sd	s7,8(sp)
    800019de:	e062                	sd	s8,0(sp)
    800019e0:	0880                	addi	s0,sp,80
    800019e2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	668080e7          	jalr	1640(ra) # 8000104c <myproc>
    800019ec:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800019ee:	00227517          	auipc	a0,0x227
    800019f2:	f0a50513          	addi	a0,a0,-246 # 802288f8 <wait_lock>
    800019f6:	00005097          	auipc	ra,0x5
    800019fa:	976080e7          	jalr	-1674(ra) # 8000636c <acquire>
    havekids = 0;
    800019fe:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a00:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a02:	0022d997          	auipc	s3,0x22d
    80001a06:	d0e98993          	addi	s3,s3,-754 # 8022e710 <tickslock>
        havekids = 1;
    80001a0a:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a0c:	00227c17          	auipc	s8,0x227
    80001a10:	eecc0c13          	addi	s8,s8,-276 # 802288f8 <wait_lock>
    havekids = 0;
    80001a14:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a16:	00227497          	auipc	s1,0x227
    80001a1a:	2fa48493          	addi	s1,s1,762 # 80228d10 <proc>
    80001a1e:	a0bd                	j	80001a8c <wait+0xc2>
          pid = pp->pid;
    80001a20:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a24:	000b0e63          	beqz	s6,80001a40 <wait+0x76>
    80001a28:	4691                	li	a3,4
    80001a2a:	02c48613          	addi	a2,s1,44
    80001a2e:	85da                	mv	a1,s6
    80001a30:	05093503          	ld	a0,80(s2)
    80001a34:	fffff097          	auipc	ra,0xfffff
    80001a38:	2ca080e7          	jalr	714(ra) # 80000cfe <copyout>
    80001a3c:	02054563          	bltz	a0,80001a66 <wait+0x9c>
          freeproc(pp);
    80001a40:	8526                	mv	a0,s1
    80001a42:	fffff097          	auipc	ra,0xfffff
    80001a46:	7bc080e7          	jalr	1980(ra) # 800011fe <freeproc>
          release(&pp->lock);
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	00005097          	auipc	ra,0x5
    80001a50:	9d4080e7          	jalr	-1580(ra) # 80006420 <release>
          release(&wait_lock);
    80001a54:	00227517          	auipc	a0,0x227
    80001a58:	ea450513          	addi	a0,a0,-348 # 802288f8 <wait_lock>
    80001a5c:	00005097          	auipc	ra,0x5
    80001a60:	9c4080e7          	jalr	-1596(ra) # 80006420 <release>
          return pid;
    80001a64:	a0b5                	j	80001ad0 <wait+0x106>
            release(&pp->lock);
    80001a66:	8526                	mv	a0,s1
    80001a68:	00005097          	auipc	ra,0x5
    80001a6c:	9b8080e7          	jalr	-1608(ra) # 80006420 <release>
            release(&wait_lock);
    80001a70:	00227517          	auipc	a0,0x227
    80001a74:	e8850513          	addi	a0,a0,-376 # 802288f8 <wait_lock>
    80001a78:	00005097          	auipc	ra,0x5
    80001a7c:	9a8080e7          	jalr	-1624(ra) # 80006420 <release>
            return -1;
    80001a80:	59fd                	li	s3,-1
    80001a82:	a0b9                	j	80001ad0 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a84:	16848493          	addi	s1,s1,360
    80001a88:	03348463          	beq	s1,s3,80001ab0 <wait+0xe6>
      if(pp->parent == p){
    80001a8c:	7c9c                	ld	a5,56(s1)
    80001a8e:	ff279be3          	bne	a5,s2,80001a84 <wait+0xba>
        acquire(&pp->lock);
    80001a92:	8526                	mv	a0,s1
    80001a94:	00005097          	auipc	ra,0x5
    80001a98:	8d8080e7          	jalr	-1832(ra) # 8000636c <acquire>
        if(pp->state == ZOMBIE){
    80001a9c:	4c9c                	lw	a5,24(s1)
    80001a9e:	f94781e3          	beq	a5,s4,80001a20 <wait+0x56>
        release(&pp->lock);
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	00005097          	auipc	ra,0x5
    80001aa8:	97c080e7          	jalr	-1668(ra) # 80006420 <release>
        havekids = 1;
    80001aac:	8756                	mv	a4,s5
    80001aae:	bfd9                	j	80001a84 <wait+0xba>
    if(!havekids || killed(p)){
    80001ab0:	c719                	beqz	a4,80001abe <wait+0xf4>
    80001ab2:	854a                	mv	a0,s2
    80001ab4:	00000097          	auipc	ra,0x0
    80001ab8:	ee4080e7          	jalr	-284(ra) # 80001998 <killed>
    80001abc:	c51d                	beqz	a0,80001aea <wait+0x120>
      release(&wait_lock);
    80001abe:	00227517          	auipc	a0,0x227
    80001ac2:	e3a50513          	addi	a0,a0,-454 # 802288f8 <wait_lock>
    80001ac6:	00005097          	auipc	ra,0x5
    80001aca:	95a080e7          	jalr	-1702(ra) # 80006420 <release>
      return -1;
    80001ace:	59fd                	li	s3,-1
}
    80001ad0:	854e                	mv	a0,s3
    80001ad2:	60a6                	ld	ra,72(sp)
    80001ad4:	6406                	ld	s0,64(sp)
    80001ad6:	74e2                	ld	s1,56(sp)
    80001ad8:	7942                	ld	s2,48(sp)
    80001ada:	79a2                	ld	s3,40(sp)
    80001adc:	7a02                	ld	s4,32(sp)
    80001ade:	6ae2                	ld	s5,24(sp)
    80001ae0:	6b42                	ld	s6,16(sp)
    80001ae2:	6ba2                	ld	s7,8(sp)
    80001ae4:	6c02                	ld	s8,0(sp)
    80001ae6:	6161                	addi	sp,sp,80
    80001ae8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001aea:	85e2                	mv	a1,s8
    80001aec:	854a                	mv	a0,s2
    80001aee:	00000097          	auipc	ra,0x0
    80001af2:	c02080e7          	jalr	-1022(ra) # 800016f0 <sleep>
    havekids = 0;
    80001af6:	bf39                	j	80001a14 <wait+0x4a>

0000000080001af8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001af8:	7179                	addi	sp,sp,-48
    80001afa:	f406                	sd	ra,40(sp)
    80001afc:	f022                	sd	s0,32(sp)
    80001afe:	ec26                	sd	s1,24(sp)
    80001b00:	e84a                	sd	s2,16(sp)
    80001b02:	e44e                	sd	s3,8(sp)
    80001b04:	e052                	sd	s4,0(sp)
    80001b06:	1800                	addi	s0,sp,48
    80001b08:	84aa                	mv	s1,a0
    80001b0a:	892e                	mv	s2,a1
    80001b0c:	89b2                	mv	s3,a2
    80001b0e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	53c080e7          	jalr	1340(ra) # 8000104c <myproc>
  if(user_dst){
    80001b18:	c08d                	beqz	s1,80001b3a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b1a:	86d2                	mv	a3,s4
    80001b1c:	864e                	mv	a2,s3
    80001b1e:	85ca                	mv	a1,s2
    80001b20:	6928                	ld	a0,80(a0)
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	1dc080e7          	jalr	476(ra) # 80000cfe <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b2a:	70a2                	ld	ra,40(sp)
    80001b2c:	7402                	ld	s0,32(sp)
    80001b2e:	64e2                	ld	s1,24(sp)
    80001b30:	6942                	ld	s2,16(sp)
    80001b32:	69a2                	ld	s3,8(sp)
    80001b34:	6a02                	ld	s4,0(sp)
    80001b36:	6145                	addi	sp,sp,48
    80001b38:	8082                	ret
    memmove((char *)dst, src, len);
    80001b3a:	000a061b          	sext.w	a2,s4
    80001b3e:	85ce                	mv	a1,s3
    80001b40:	854a                	mv	a0,s2
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	888080e7          	jalr	-1912(ra) # 800003ca <memmove>
    return 0;
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	bff9                	j	80001b2a <either_copyout+0x32>

0000000080001b4e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b4e:	7179                	addi	sp,sp,-48
    80001b50:	f406                	sd	ra,40(sp)
    80001b52:	f022                	sd	s0,32(sp)
    80001b54:	ec26                	sd	s1,24(sp)
    80001b56:	e84a                	sd	s2,16(sp)
    80001b58:	e44e                	sd	s3,8(sp)
    80001b5a:	e052                	sd	s4,0(sp)
    80001b5c:	1800                	addi	s0,sp,48
    80001b5e:	892a                	mv	s2,a0
    80001b60:	84ae                	mv	s1,a1
    80001b62:	89b2                	mv	s3,a2
    80001b64:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b66:	fffff097          	auipc	ra,0xfffff
    80001b6a:	4e6080e7          	jalr	1254(ra) # 8000104c <myproc>
  if(user_src){
    80001b6e:	c08d                	beqz	s1,80001b90 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b70:	86d2                	mv	a3,s4
    80001b72:	864e                	mv	a2,s3
    80001b74:	85ca                	mv	a1,s2
    80001b76:	6928                	ld	a0,80(a0)
    80001b78:	fffff097          	auipc	ra,0xfffff
    80001b7c:	21e080e7          	jalr	542(ra) # 80000d96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b80:	70a2                	ld	ra,40(sp)
    80001b82:	7402                	ld	s0,32(sp)
    80001b84:	64e2                	ld	s1,24(sp)
    80001b86:	6942                	ld	s2,16(sp)
    80001b88:	69a2                	ld	s3,8(sp)
    80001b8a:	6a02                	ld	s4,0(sp)
    80001b8c:	6145                	addi	sp,sp,48
    80001b8e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b90:	000a061b          	sext.w	a2,s4
    80001b94:	85ce                	mv	a1,s3
    80001b96:	854a                	mv	a0,s2
    80001b98:	fffff097          	auipc	ra,0xfffff
    80001b9c:	832080e7          	jalr	-1998(ra) # 800003ca <memmove>
    return 0;
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	bff9                	j	80001b80 <either_copyin+0x32>

0000000080001ba4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ba4:	715d                	addi	sp,sp,-80
    80001ba6:	e486                	sd	ra,72(sp)
    80001ba8:	e0a2                	sd	s0,64(sp)
    80001baa:	fc26                	sd	s1,56(sp)
    80001bac:	f84a                	sd	s2,48(sp)
    80001bae:	f44e                	sd	s3,40(sp)
    80001bb0:	f052                	sd	s4,32(sp)
    80001bb2:	ec56                	sd	s5,24(sp)
    80001bb4:	e85a                	sd	s6,16(sp)
    80001bb6:	e45e                	sd	s7,8(sp)
    80001bb8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bba:	00006517          	auipc	a0,0x6
    80001bbe:	48e50513          	addi	a0,a0,1166 # 80008048 <etext+0x48>
    80001bc2:	00004097          	auipc	ra,0x4
    80001bc6:	2aa080e7          	jalr	682(ra) # 80005e6c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bca:	00227497          	auipc	s1,0x227
    80001bce:	29e48493          	addi	s1,s1,670 # 80228e68 <proc+0x158>
    80001bd2:	0022d917          	auipc	s2,0x22d
    80001bd6:	c9690913          	addi	s2,s2,-874 # 8022e868 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bda:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bdc:	00006997          	auipc	s3,0x6
    80001be0:	62498993          	addi	s3,s3,1572 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001be4:	00006a97          	auipc	s5,0x6
    80001be8:	624a8a93          	addi	s5,s5,1572 # 80008208 <etext+0x208>
    printf("\n");
    80001bec:	00006a17          	auipc	s4,0x6
    80001bf0:	45ca0a13          	addi	s4,s4,1116 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bf4:	00006b97          	auipc	s7,0x6
    80001bf8:	654b8b93          	addi	s7,s7,1620 # 80008248 <states.1729>
    80001bfc:	a00d                	j	80001c1e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bfe:	ed86a583          	lw	a1,-296(a3)
    80001c02:	8556                	mv	a0,s5
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	268080e7          	jalr	616(ra) # 80005e6c <printf>
    printf("\n");
    80001c0c:	8552                	mv	a0,s4
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	25e080e7          	jalr	606(ra) # 80005e6c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c16:	16848493          	addi	s1,s1,360
    80001c1a:	03248163          	beq	s1,s2,80001c3c <procdump+0x98>
    if(p->state == UNUSED)
    80001c1e:	86a6                	mv	a3,s1
    80001c20:	ec04a783          	lw	a5,-320(s1)
    80001c24:	dbed                	beqz	a5,80001c16 <procdump+0x72>
      state = "???";
    80001c26:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c28:	fcfb6be3          	bltu	s6,a5,80001bfe <procdump+0x5a>
    80001c2c:	1782                	slli	a5,a5,0x20
    80001c2e:	9381                	srli	a5,a5,0x20
    80001c30:	078e                	slli	a5,a5,0x3
    80001c32:	97de                	add	a5,a5,s7
    80001c34:	6390                	ld	a2,0(a5)
    80001c36:	f661                	bnez	a2,80001bfe <procdump+0x5a>
      state = "???";
    80001c38:	864e                	mv	a2,s3
    80001c3a:	b7d1                	j	80001bfe <procdump+0x5a>
  }
}
    80001c3c:	60a6                	ld	ra,72(sp)
    80001c3e:	6406                	ld	s0,64(sp)
    80001c40:	74e2                	ld	s1,56(sp)
    80001c42:	7942                	ld	s2,48(sp)
    80001c44:	79a2                	ld	s3,40(sp)
    80001c46:	7a02                	ld	s4,32(sp)
    80001c48:	6ae2                	ld	s5,24(sp)
    80001c4a:	6b42                	ld	s6,16(sp)
    80001c4c:	6ba2                	ld	s7,8(sp)
    80001c4e:	6161                	addi	sp,sp,80
    80001c50:	8082                	ret

0000000080001c52 <swtch>:
    80001c52:	00153023          	sd	ra,0(a0)
    80001c56:	00253423          	sd	sp,8(a0)
    80001c5a:	e900                	sd	s0,16(a0)
    80001c5c:	ed04                	sd	s1,24(a0)
    80001c5e:	03253023          	sd	s2,32(a0)
    80001c62:	03353423          	sd	s3,40(a0)
    80001c66:	03453823          	sd	s4,48(a0)
    80001c6a:	03553c23          	sd	s5,56(a0)
    80001c6e:	05653023          	sd	s6,64(a0)
    80001c72:	05753423          	sd	s7,72(a0)
    80001c76:	05853823          	sd	s8,80(a0)
    80001c7a:	05953c23          	sd	s9,88(a0)
    80001c7e:	07a53023          	sd	s10,96(a0)
    80001c82:	07b53423          	sd	s11,104(a0)
    80001c86:	0005b083          	ld	ra,0(a1)
    80001c8a:	0085b103          	ld	sp,8(a1)
    80001c8e:	6980                	ld	s0,16(a1)
    80001c90:	6d84                	ld	s1,24(a1)
    80001c92:	0205b903          	ld	s2,32(a1)
    80001c96:	0285b983          	ld	s3,40(a1)
    80001c9a:	0305ba03          	ld	s4,48(a1)
    80001c9e:	0385ba83          	ld	s5,56(a1)
    80001ca2:	0405bb03          	ld	s6,64(a1)
    80001ca6:	0485bb83          	ld	s7,72(a1)
    80001caa:	0505bc03          	ld	s8,80(a1)
    80001cae:	0585bc83          	ld	s9,88(a1)
    80001cb2:	0605bd03          	ld	s10,96(a1)
    80001cb6:	0685bd83          	ld	s11,104(a1)
    80001cba:	8082                	ret

0000000080001cbc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cbc:	1141                	addi	sp,sp,-16
    80001cbe:	e406                	sd	ra,8(sp)
    80001cc0:	e022                	sd	s0,0(sp)
    80001cc2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cc4:	00006597          	auipc	a1,0x6
    80001cc8:	5b458593          	addi	a1,a1,1460 # 80008278 <states.1729+0x30>
    80001ccc:	0022d517          	auipc	a0,0x22d
    80001cd0:	a4450513          	addi	a0,a0,-1468 # 8022e710 <tickslock>
    80001cd4:	00004097          	auipc	ra,0x4
    80001cd8:	608080e7          	jalr	1544(ra) # 800062dc <initlock>
}
    80001cdc:	60a2                	ld	ra,8(sp)
    80001cde:	6402                	ld	s0,0(sp)
    80001ce0:	0141                	addi	sp,sp,16
    80001ce2:	8082                	ret

0000000080001ce4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ce4:	1141                	addi	sp,sp,-16
    80001ce6:	e422                	sd	s0,8(sp)
    80001ce8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cea:	00003797          	auipc	a5,0x3
    80001cee:	50678793          	addi	a5,a5,1286 # 800051f0 <kernelvec>
    80001cf2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cf6:	6422                	ld	s0,8(sp)
    80001cf8:	0141                	addi	sp,sp,16
    80001cfa:	8082                	ret

0000000080001cfc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cfc:	1141                	addi	sp,sp,-16
    80001cfe:	e406                	sd	ra,8(sp)
    80001d00:	e022                	sd	s0,0(sp)
    80001d02:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	348080e7          	jalr	840(ra) # 8000104c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d10:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d12:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d16:	00005617          	auipc	a2,0x5
    80001d1a:	2ea60613          	addi	a2,a2,746 # 80007000 <_trampoline>
    80001d1e:	00005697          	auipc	a3,0x5
    80001d22:	2e268693          	addi	a3,a3,738 # 80007000 <_trampoline>
    80001d26:	8e91                	sub	a3,a3,a2
    80001d28:	040007b7          	lui	a5,0x4000
    80001d2c:	17fd                	addi	a5,a5,-1
    80001d2e:	07b2                	slli	a5,a5,0xc
    80001d30:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d32:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d36:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d38:	180026f3          	csrr	a3,satp
    80001d3c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d3e:	6d38                	ld	a4,88(a0)
    80001d40:	6134                	ld	a3,64(a0)
    80001d42:	6585                	lui	a1,0x1
    80001d44:	96ae                	add	a3,a3,a1
    80001d46:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d48:	6d38                	ld	a4,88(a0)
    80001d4a:	00000697          	auipc	a3,0x0
    80001d4e:	13068693          	addi	a3,a3,304 # 80001e7a <usertrap>
    80001d52:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d54:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d56:	8692                	mv	a3,tp
    80001d58:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d5e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d62:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d66:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d6a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d6c:	6f18                	ld	a4,24(a4)
    80001d6e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d72:	6928                	ld	a0,80(a0)
    80001d74:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d76:	00005717          	auipc	a4,0x5
    80001d7a:	32670713          	addi	a4,a4,806 # 8000709c <userret>
    80001d7e:	8f11                	sub	a4,a4,a2
    80001d80:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d82:	577d                	li	a4,-1
    80001d84:	177e                	slli	a4,a4,0x3f
    80001d86:	8d59                	or	a0,a0,a4
    80001d88:	9782                	jalr	a5
}
    80001d8a:	60a2                	ld	ra,8(sp)
    80001d8c:	6402                	ld	s0,0(sp)
    80001d8e:	0141                	addi	sp,sp,16
    80001d90:	8082                	ret

0000000080001d92 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d92:	1101                	addi	sp,sp,-32
    80001d94:	ec06                	sd	ra,24(sp)
    80001d96:	e822                	sd	s0,16(sp)
    80001d98:	e426                	sd	s1,8(sp)
    80001d9a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d9c:	0022d497          	auipc	s1,0x22d
    80001da0:	97448493          	addi	s1,s1,-1676 # 8022e710 <tickslock>
    80001da4:	8526                	mv	a0,s1
    80001da6:	00004097          	auipc	ra,0x4
    80001daa:	5c6080e7          	jalr	1478(ra) # 8000636c <acquire>
  ticks++;
    80001dae:	00007517          	auipc	a0,0x7
    80001db2:	afa50513          	addi	a0,a0,-1286 # 800088a8 <ticks>
    80001db6:	411c                	lw	a5,0(a0)
    80001db8:	2785                	addiw	a5,a5,1
    80001dba:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	998080e7          	jalr	-1640(ra) # 80001754 <wakeup>
  release(&tickslock);
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	65a080e7          	jalr	1626(ra) # 80006420 <release>
}
    80001dce:	60e2                	ld	ra,24(sp)
    80001dd0:	6442                	ld	s0,16(sp)
    80001dd2:	64a2                	ld	s1,8(sp)
    80001dd4:	6105                	addi	sp,sp,32
    80001dd6:	8082                	ret

0000000080001dd8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001dd8:	1101                	addi	sp,sp,-32
    80001dda:	ec06                	sd	ra,24(sp)
    80001ddc:	e822                	sd	s0,16(sp)
    80001dde:	e426                	sd	s1,8(sp)
    80001de0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001de6:	00074d63          	bltz	a4,80001e00 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001dea:	57fd                	li	a5,-1
    80001dec:	17fe                	slli	a5,a5,0x3f
    80001dee:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001df0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001df2:	06f70363          	beq	a4,a5,80001e58 <devintr+0x80>
  }
}
    80001df6:	60e2                	ld	ra,24(sp)
    80001df8:	6442                	ld	s0,16(sp)
    80001dfa:	64a2                	ld	s1,8(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret
     (scause & 0xff) == 9){
    80001e00:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001e04:	46a5                	li	a3,9
    80001e06:	fed792e3          	bne	a5,a3,80001dea <devintr+0x12>
    int irq = plic_claim();
    80001e0a:	00003097          	auipc	ra,0x3
    80001e0e:	4ee080e7          	jalr	1262(ra) # 800052f8 <plic_claim>
    80001e12:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e14:	47a9                	li	a5,10
    80001e16:	02f50763          	beq	a0,a5,80001e44 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e1a:	4785                	li	a5,1
    80001e1c:	02f50963          	beq	a0,a5,80001e4e <devintr+0x76>
    return 1;
    80001e20:	4505                	li	a0,1
    } else if(irq){
    80001e22:	d8f1                	beqz	s1,80001df6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e24:	85a6                	mv	a1,s1
    80001e26:	00006517          	auipc	a0,0x6
    80001e2a:	45a50513          	addi	a0,a0,1114 # 80008280 <states.1729+0x38>
    80001e2e:	00004097          	auipc	ra,0x4
    80001e32:	03e080e7          	jalr	62(ra) # 80005e6c <printf>
      plic_complete(irq);
    80001e36:	8526                	mv	a0,s1
    80001e38:	00003097          	auipc	ra,0x3
    80001e3c:	4e4080e7          	jalr	1252(ra) # 8000531c <plic_complete>
    return 1;
    80001e40:	4505                	li	a0,1
    80001e42:	bf55                	j	80001df6 <devintr+0x1e>
      uartintr();
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	448080e7          	jalr	1096(ra) # 8000628c <uartintr>
    80001e4c:	b7ed                	j	80001e36 <devintr+0x5e>
      virtio_disk_intr();
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	9f8080e7          	jalr	-1544(ra) # 80005846 <virtio_disk_intr>
    80001e56:	b7c5                	j	80001e36 <devintr+0x5e>
    if(cpuid() == 0){
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	1c8080e7          	jalr	456(ra) # 80001020 <cpuid>
    80001e60:	c901                	beqz	a0,80001e70 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e62:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e68:	14479073          	csrw	sip,a5
    return 2;
    80001e6c:	4509                	li	a0,2
    80001e6e:	b761                	j	80001df6 <devintr+0x1e>
      clockintr();
    80001e70:	00000097          	auipc	ra,0x0
    80001e74:	f22080e7          	jalr	-222(ra) # 80001d92 <clockintr>
    80001e78:	b7ed                	j	80001e62 <devintr+0x8a>

0000000080001e7a <usertrap>:
{
    80001e7a:	1101                	addi	sp,sp,-32
    80001e7c:	ec06                	sd	ra,24(sp)
    80001e7e:	e822                	sd	s0,16(sp)
    80001e80:	e426                	sd	s1,8(sp)
    80001e82:	e04a                	sd	s2,0(sp)
    80001e84:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e86:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e8a:	1007f793          	andi	a5,a5,256
    80001e8e:	e7a5                	bnez	a5,80001ef6 <usertrap+0x7c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e90:	00003797          	auipc	a5,0x3
    80001e94:	36078793          	addi	a5,a5,864 # 800051f0 <kernelvec>
    80001e98:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	1b0080e7          	jalr	432(ra) # 8000104c <myproc>
    80001ea4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ea6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea8:	14102773          	csrr	a4,sepc
    80001eac:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eae:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001eb2:	47a1                	li	a5,8
    80001eb4:	04f70963          	beq	a4,a5,80001f06 <usertrap+0x8c>
  } else if((which_dev = devintr()) != 0){
    80001eb8:	00000097          	auipc	ra,0x0
    80001ebc:	f20080e7          	jalr	-224(ra) # 80001dd8 <devintr>
    80001ec0:	892a                	mv	s2,a0
    80001ec2:	e175                	bnez	a0,80001fa6 <usertrap+0x12c>
    80001ec4:	14202773          	csrr	a4,scause
  } else if( (r_scause() == 15 || r_scause() == 13) )  {
    80001ec8:	47bd                	li	a5,15
    80001eca:	00f70763          	beq	a4,a5,80001ed8 <usertrap+0x5e>
    80001ece:	14202773          	csrr	a4,scause
    80001ed2:	47b5                	li	a5,13
    80001ed4:	08f71c63          	bne	a4,a5,80001f6c <usertrap+0xf2>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed8:	143025f3          	csrr	a1,stval
    if( va < PGROUNDDOWN(p->trapframe->sp) && 
    80001edc:	6cbc                	ld	a5,88(s1)
    80001ede:	7b98                	ld	a4,48(a5)
    80001ee0:	77fd                	lui	a5,0xfffff
    80001ee2:	8ff9                	and	a5,a5,a4
    80001ee4:	06f5fa63          	bgeu	a1,a5,80001f58 <usertrap+0xde>
        va >= PGROUNDDOWN(p->trapframe->sp)-PGSIZE){
    80001ee8:	777d                	lui	a4,0xfffff
    80001eea:	97ba                	add	a5,a5,a4
    if( va < PGROUNDDOWN(p->trapframe->sp) && 
    80001eec:	06f5e663          	bltu	a1,a5,80001f58 <usertrap+0xde>
          p->killed=1;
    80001ef0:	4785                	li	a5,1
    80001ef2:	d49c                	sw	a5,40(s1)
    80001ef4:	a825                	j	80001f2c <usertrap+0xb2>
    panic("usertrap: not from user mode");
    80001ef6:	00006517          	auipc	a0,0x6
    80001efa:	3aa50513          	addi	a0,a0,938 # 800082a0 <states.1729+0x58>
    80001efe:	00004097          	auipc	ra,0x4
    80001f02:	f24080e7          	jalr	-220(ra) # 80005e22 <panic>
    if(killed(p))
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	a92080e7          	jalr	-1390(ra) # 80001998 <killed>
    80001f0e:	ed1d                	bnez	a0,80001f4c <usertrap+0xd2>
    p->trapframe->epc += 4;
    80001f10:	6cb8                	ld	a4,88(s1)
    80001f12:	6f1c                	ld	a5,24(a4)
    80001f14:	0791                	addi	a5,a5,4
    80001f16:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f1c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f20:	10079073          	csrw	sstatus,a5
    syscall();
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	2f6080e7          	jalr	758(ra) # 8000221a <syscall>
  if(killed(p))
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	a6a080e7          	jalr	-1430(ra) # 80001998 <killed>
    80001f36:	ed3d                	bnez	a0,80001fb4 <usertrap+0x13a>
  usertrapret();
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	dc4080e7          	jalr	-572(ra) # 80001cfc <usertrapret>
}
    80001f40:	60e2                	ld	ra,24(sp)
    80001f42:	6442                	ld	s0,16(sp)
    80001f44:	64a2                	ld	s1,8(sp)
    80001f46:	6902                	ld	s2,0(sp)
    80001f48:	6105                	addi	sp,sp,32
    80001f4a:	8082                	ret
      exit(-1);
    80001f4c:	557d                	li	a0,-1
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	8d6080e7          	jalr	-1834(ra) # 80001824 <exit>
    80001f56:	bf6d                	j	80001f10 <usertrap+0x96>
      if( (ret = cow_alloc(p->pagetable, va)) < 0){
    80001f58:	68a8                	ld	a0,80(s1)
    80001f5a:	ffffe097          	auipc	ra,0xffffe
    80001f5e:	306080e7          	jalr	774(ra) # 80000260 <cow_alloc>
    80001f62:	fc0555e3          	bgez	a0,80001f2c <usertrap+0xb2>
        p->killed=1;
    80001f66:	4785                	li	a5,1
    80001f68:	d49c                	sw	a5,40(s1)
    80001f6a:	b7c9                	j	80001f2c <usertrap+0xb2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f6c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f70:	5890                	lw	a2,48(s1)
    80001f72:	00006517          	auipc	a0,0x6
    80001f76:	34e50513          	addi	a0,a0,846 # 800082c0 <states.1729+0x78>
    80001f7a:	00004097          	auipc	ra,0x4
    80001f7e:	ef2080e7          	jalr	-270(ra) # 80005e6c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f86:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f8a:	00006517          	auipc	a0,0x6
    80001f8e:	36650513          	addi	a0,a0,870 # 800082f0 <states.1729+0xa8>
    80001f92:	00004097          	auipc	ra,0x4
    80001f96:	eda080e7          	jalr	-294(ra) # 80005e6c <printf>
    setkilled(p);
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	9d0080e7          	jalr	-1584(ra) # 8000196c <setkilled>
    80001fa4:	b761                	j	80001f2c <usertrap+0xb2>
  if(killed(p))
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	9f0080e7          	jalr	-1552(ra) # 80001998 <killed>
    80001fb0:	c901                	beqz	a0,80001fc0 <usertrap+0x146>
    80001fb2:	a011                	j	80001fb6 <usertrap+0x13c>
    80001fb4:	4901                	li	s2,0
    exit(-1);
    80001fb6:	557d                	li	a0,-1
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	86c080e7          	jalr	-1940(ra) # 80001824 <exit>
  if(which_dev == 2)
    80001fc0:	4789                	li	a5,2
    80001fc2:	f6f91be3          	bne	s2,a5,80001f38 <usertrap+0xbe>
    yield();
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	6ee080e7          	jalr	1774(ra) # 800016b4 <yield>
    80001fce:	b7ad                	j	80001f38 <usertrap+0xbe>

0000000080001fd0 <kerneltrap>:
{
    80001fd0:	7179                	addi	sp,sp,-48
    80001fd2:	f406                	sd	ra,40(sp)
    80001fd4:	f022                	sd	s0,32(sp)
    80001fd6:	ec26                	sd	s1,24(sp)
    80001fd8:	e84a                	sd	s2,16(sp)
    80001fda:	e44e                	sd	s3,8(sp)
    80001fdc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fde:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fe6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fea:	1004f793          	andi	a5,s1,256
    80001fee:	cb85                	beqz	a5,8000201e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ff4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ff6:	ef85                	bnez	a5,8000202e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	de0080e7          	jalr	-544(ra) # 80001dd8 <devintr>
    80002000:	cd1d                	beqz	a0,8000203e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002002:	4789                	li	a5,2
    80002004:	06f50a63          	beq	a0,a5,80002078 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002008:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000200c:	10049073          	csrw	sstatus,s1
}
    80002010:	70a2                	ld	ra,40(sp)
    80002012:	7402                	ld	s0,32(sp)
    80002014:	64e2                	ld	s1,24(sp)
    80002016:	6942                	ld	s2,16(sp)
    80002018:	69a2                	ld	s3,8(sp)
    8000201a:	6145                	addi	sp,sp,48
    8000201c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000201e:	00006517          	auipc	a0,0x6
    80002022:	2f250513          	addi	a0,a0,754 # 80008310 <states.1729+0xc8>
    80002026:	00004097          	auipc	ra,0x4
    8000202a:	dfc080e7          	jalr	-516(ra) # 80005e22 <panic>
    panic("kerneltrap: interrupts enabled");
    8000202e:	00006517          	auipc	a0,0x6
    80002032:	30a50513          	addi	a0,a0,778 # 80008338 <states.1729+0xf0>
    80002036:	00004097          	auipc	ra,0x4
    8000203a:	dec080e7          	jalr	-532(ra) # 80005e22 <panic>
    printf("scause %p\n", scause);
    8000203e:	85ce                	mv	a1,s3
    80002040:	00006517          	auipc	a0,0x6
    80002044:	31850513          	addi	a0,a0,792 # 80008358 <states.1729+0x110>
    80002048:	00004097          	auipc	ra,0x4
    8000204c:	e24080e7          	jalr	-476(ra) # 80005e6c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002050:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002054:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002058:	00006517          	auipc	a0,0x6
    8000205c:	31050513          	addi	a0,a0,784 # 80008368 <states.1729+0x120>
    80002060:	00004097          	auipc	ra,0x4
    80002064:	e0c080e7          	jalr	-500(ra) # 80005e6c <printf>
    panic("kerneltrap");
    80002068:	00006517          	auipc	a0,0x6
    8000206c:	31850513          	addi	a0,a0,792 # 80008380 <states.1729+0x138>
    80002070:	00004097          	auipc	ra,0x4
    80002074:	db2080e7          	jalr	-590(ra) # 80005e22 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002078:	fffff097          	auipc	ra,0xfffff
    8000207c:	fd4080e7          	jalr	-44(ra) # 8000104c <myproc>
    80002080:	d541                	beqz	a0,80002008 <kerneltrap+0x38>
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	fca080e7          	jalr	-54(ra) # 8000104c <myproc>
    8000208a:	4d18                	lw	a4,24(a0)
    8000208c:	4791                	li	a5,4
    8000208e:	f6f71de3          	bne	a4,a5,80002008 <kerneltrap+0x38>
    yield();
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	622080e7          	jalr	1570(ra) # 800016b4 <yield>
    8000209a:	b7bd                	j	80002008 <kerneltrap+0x38>

000000008000209c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	e426                	sd	s1,8(sp)
    800020a4:	1000                	addi	s0,sp,32
    800020a6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	fa4080e7          	jalr	-92(ra) # 8000104c <myproc>
  switch (n) {
    800020b0:	4795                	li	a5,5
    800020b2:	0497e163          	bltu	a5,s1,800020f4 <argraw+0x58>
    800020b6:	048a                	slli	s1,s1,0x2
    800020b8:	00006717          	auipc	a4,0x6
    800020bc:	30070713          	addi	a4,a4,768 # 800083b8 <states.1729+0x170>
    800020c0:	94ba                	add	s1,s1,a4
    800020c2:	409c                	lw	a5,0(s1)
    800020c4:	97ba                	add	a5,a5,a4
    800020c6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020c8:	6d3c                	ld	a5,88(a0)
    800020ca:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	64a2                	ld	s1,8(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret
    return p->trapframe->a1;
    800020d6:	6d3c                	ld	a5,88(a0)
    800020d8:	7fa8                	ld	a0,120(a5)
    800020da:	bfcd                	j	800020cc <argraw+0x30>
    return p->trapframe->a2;
    800020dc:	6d3c                	ld	a5,88(a0)
    800020de:	63c8                	ld	a0,128(a5)
    800020e0:	b7f5                	j	800020cc <argraw+0x30>
    return p->trapframe->a3;
    800020e2:	6d3c                	ld	a5,88(a0)
    800020e4:	67c8                	ld	a0,136(a5)
    800020e6:	b7dd                	j	800020cc <argraw+0x30>
    return p->trapframe->a4;
    800020e8:	6d3c                	ld	a5,88(a0)
    800020ea:	6bc8                	ld	a0,144(a5)
    800020ec:	b7c5                	j	800020cc <argraw+0x30>
    return p->trapframe->a5;
    800020ee:	6d3c                	ld	a5,88(a0)
    800020f0:	6fc8                	ld	a0,152(a5)
    800020f2:	bfe9                	j	800020cc <argraw+0x30>
  panic("argraw");
    800020f4:	00006517          	auipc	a0,0x6
    800020f8:	29c50513          	addi	a0,a0,668 # 80008390 <states.1729+0x148>
    800020fc:	00004097          	auipc	ra,0x4
    80002100:	d26080e7          	jalr	-730(ra) # 80005e22 <panic>

0000000080002104 <fetchaddr>:
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	e426                	sd	s1,8(sp)
    8000210c:	e04a                	sd	s2,0(sp)
    8000210e:	1000                	addi	s0,sp,32
    80002110:	84aa                	mv	s1,a0
    80002112:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	f38080e7          	jalr	-200(ra) # 8000104c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000211c:	653c                	ld	a5,72(a0)
    8000211e:	02f4f863          	bgeu	s1,a5,8000214e <fetchaddr+0x4a>
    80002122:	00848713          	addi	a4,s1,8
    80002126:	02e7e663          	bltu	a5,a4,80002152 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000212a:	46a1                	li	a3,8
    8000212c:	8626                	mv	a2,s1
    8000212e:	85ca                	mv	a1,s2
    80002130:	6928                	ld	a0,80(a0)
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	c64080e7          	jalr	-924(ra) # 80000d96 <copyin>
    8000213a:	00a03533          	snez	a0,a0
    8000213e:	40a00533          	neg	a0,a0
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	64a2                	ld	s1,8(sp)
    80002148:	6902                	ld	s2,0(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret
    return -1;
    8000214e:	557d                	li	a0,-1
    80002150:	bfcd                	j	80002142 <fetchaddr+0x3e>
    80002152:	557d                	li	a0,-1
    80002154:	b7fd                	j	80002142 <fetchaddr+0x3e>

0000000080002156 <fetchstr>:
{
    80002156:	7179                	addi	sp,sp,-48
    80002158:	f406                	sd	ra,40(sp)
    8000215a:	f022                	sd	s0,32(sp)
    8000215c:	ec26                	sd	s1,24(sp)
    8000215e:	e84a                	sd	s2,16(sp)
    80002160:	e44e                	sd	s3,8(sp)
    80002162:	1800                	addi	s0,sp,48
    80002164:	892a                	mv	s2,a0
    80002166:	84ae                	mv	s1,a1
    80002168:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	ee2080e7          	jalr	-286(ra) # 8000104c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002172:	86ce                	mv	a3,s3
    80002174:	864a                	mv	a2,s2
    80002176:	85a6                	mv	a1,s1
    80002178:	6928                	ld	a0,80(a0)
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	ca8080e7          	jalr	-856(ra) # 80000e22 <copyinstr>
    80002182:	00054e63          	bltz	a0,8000219e <fetchstr+0x48>
  return strlen(buf);
    80002186:	8526                	mv	a0,s1
    80002188:	ffffe097          	auipc	ra,0xffffe
    8000218c:	366080e7          	jalr	870(ra) # 800004ee <strlen>
}
    80002190:	70a2                	ld	ra,40(sp)
    80002192:	7402                	ld	s0,32(sp)
    80002194:	64e2                	ld	s1,24(sp)
    80002196:	6942                	ld	s2,16(sp)
    80002198:	69a2                	ld	s3,8(sp)
    8000219a:	6145                	addi	sp,sp,48
    8000219c:	8082                	ret
    return -1;
    8000219e:	557d                	li	a0,-1
    800021a0:	bfc5                	j	80002190 <fetchstr+0x3a>

00000000800021a2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021a2:	1101                	addi	sp,sp,-32
    800021a4:	ec06                	sd	ra,24(sp)
    800021a6:	e822                	sd	s0,16(sp)
    800021a8:	e426                	sd	s1,8(sp)
    800021aa:	1000                	addi	s0,sp,32
    800021ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	eee080e7          	jalr	-274(ra) # 8000209c <argraw>
    800021b6:	c088                	sw	a0,0(s1)
}
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6105                	addi	sp,sp,32
    800021c0:	8082                	ret

00000000800021c2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	e426                	sd	s1,8(sp)
    800021ca:	1000                	addi	s0,sp,32
    800021cc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021ce:	00000097          	auipc	ra,0x0
    800021d2:	ece080e7          	jalr	-306(ra) # 8000209c <argraw>
    800021d6:	e088                	sd	a0,0(s1)
}
    800021d8:	60e2                	ld	ra,24(sp)
    800021da:	6442                	ld	s0,16(sp)
    800021dc:	64a2                	ld	s1,8(sp)
    800021de:	6105                	addi	sp,sp,32
    800021e0:	8082                	ret

00000000800021e2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021e2:	7179                	addi	sp,sp,-48
    800021e4:	f406                	sd	ra,40(sp)
    800021e6:	f022                	sd	s0,32(sp)
    800021e8:	ec26                	sd	s1,24(sp)
    800021ea:	e84a                	sd	s2,16(sp)
    800021ec:	1800                	addi	s0,sp,48
    800021ee:	84ae                	mv	s1,a1
    800021f0:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800021f2:	fd840593          	addi	a1,s0,-40
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	fcc080e7          	jalr	-52(ra) # 800021c2 <argaddr>
  return fetchstr(addr, buf, max);
    800021fe:	864a                	mv	a2,s2
    80002200:	85a6                	mv	a1,s1
    80002202:	fd843503          	ld	a0,-40(s0)
    80002206:	00000097          	auipc	ra,0x0
    8000220a:	f50080e7          	jalr	-176(ra) # 80002156 <fetchstr>
}
    8000220e:	70a2                	ld	ra,40(sp)
    80002210:	7402                	ld	s0,32(sp)
    80002212:	64e2                	ld	s1,24(sp)
    80002214:	6942                	ld	s2,16(sp)
    80002216:	6145                	addi	sp,sp,48
    80002218:	8082                	ret

000000008000221a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000221a:	1101                	addi	sp,sp,-32
    8000221c:	ec06                	sd	ra,24(sp)
    8000221e:	e822                	sd	s0,16(sp)
    80002220:	e426                	sd	s1,8(sp)
    80002222:	e04a                	sd	s2,0(sp)
    80002224:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	e26080e7          	jalr	-474(ra) # 8000104c <myproc>
    8000222e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002230:	05853903          	ld	s2,88(a0)
    80002234:	0a893783          	ld	a5,168(s2)
    80002238:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000223c:	37fd                	addiw	a5,a5,-1
    8000223e:	4751                	li	a4,20
    80002240:	00f76f63          	bltu	a4,a5,8000225e <syscall+0x44>
    80002244:	00369713          	slli	a4,a3,0x3
    80002248:	00006797          	auipc	a5,0x6
    8000224c:	18878793          	addi	a5,a5,392 # 800083d0 <syscalls>
    80002250:	97ba                	add	a5,a5,a4
    80002252:	639c                	ld	a5,0(a5)
    80002254:	c789                	beqz	a5,8000225e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002256:	9782                	jalr	a5
    80002258:	06a93823          	sd	a0,112(s2)
    8000225c:	a839                	j	8000227a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000225e:	15848613          	addi	a2,s1,344
    80002262:	588c                	lw	a1,48(s1)
    80002264:	00006517          	auipc	a0,0x6
    80002268:	13450513          	addi	a0,a0,308 # 80008398 <states.1729+0x150>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	c00080e7          	jalr	-1024(ra) # 80005e6c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002274:	6cbc                	ld	a5,88(s1)
    80002276:	577d                	li	a4,-1
    80002278:	fbb8                	sd	a4,112(a5)
  }
}
    8000227a:	60e2                	ld	ra,24(sp)
    8000227c:	6442                	ld	s0,16(sp)
    8000227e:	64a2                	ld	s1,8(sp)
    80002280:	6902                	ld	s2,0(sp)
    80002282:	6105                	addi	sp,sp,32
    80002284:	8082                	ret

0000000080002286 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002286:	1101                	addi	sp,sp,-32
    80002288:	ec06                	sd	ra,24(sp)
    8000228a:	e822                	sd	s0,16(sp)
    8000228c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000228e:	fec40593          	addi	a1,s0,-20
    80002292:	4501                	li	a0,0
    80002294:	00000097          	auipc	ra,0x0
    80002298:	f0e080e7          	jalr	-242(ra) # 800021a2 <argint>
  exit(n);
    8000229c:	fec42503          	lw	a0,-20(s0)
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	584080e7          	jalr	1412(ra) # 80001824 <exit>
  return 0;  // not reached
}
    800022a8:	4501                	li	a0,0
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022b2:	1141                	addi	sp,sp,-16
    800022b4:	e406                	sd	ra,8(sp)
    800022b6:	e022                	sd	s0,0(sp)
    800022b8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	d92080e7          	jalr	-622(ra) # 8000104c <myproc>
}
    800022c2:	5908                	lw	a0,48(a0)
    800022c4:	60a2                	ld	ra,8(sp)
    800022c6:	6402                	ld	s0,0(sp)
    800022c8:	0141                	addi	sp,sp,16
    800022ca:	8082                	ret

00000000800022cc <sys_fork>:

uint64
sys_fork(void)
{
    800022cc:	1141                	addi	sp,sp,-16
    800022ce:	e406                	sd	ra,8(sp)
    800022d0:	e022                	sd	s0,0(sp)
    800022d2:	0800                	addi	s0,sp,16
  return fork();
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	12e080e7          	jalr	302(ra) # 80001402 <fork>
}
    800022dc:	60a2                	ld	ra,8(sp)
    800022de:	6402                	ld	s0,0(sp)
    800022e0:	0141                	addi	sp,sp,16
    800022e2:	8082                	ret

00000000800022e4 <sys_wait>:

uint64
sys_wait(void)
{
    800022e4:	1101                	addi	sp,sp,-32
    800022e6:	ec06                	sd	ra,24(sp)
    800022e8:	e822                	sd	s0,16(sp)
    800022ea:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022ec:	fe840593          	addi	a1,s0,-24
    800022f0:	4501                	li	a0,0
    800022f2:	00000097          	auipc	ra,0x0
    800022f6:	ed0080e7          	jalr	-304(ra) # 800021c2 <argaddr>
  return wait(p);
    800022fa:	fe843503          	ld	a0,-24(s0)
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	6cc080e7          	jalr	1740(ra) # 800019ca <wait>
}
    80002306:	60e2                	ld	ra,24(sp)
    80002308:	6442                	ld	s0,16(sp)
    8000230a:	6105                	addi	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000230e:	7179                	addi	sp,sp,-48
    80002310:	f406                	sd	ra,40(sp)
    80002312:	f022                	sd	s0,32(sp)
    80002314:	ec26                	sd	s1,24(sp)
    80002316:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002318:	fdc40593          	addi	a1,s0,-36
    8000231c:	4501                	li	a0,0
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	e84080e7          	jalr	-380(ra) # 800021a2 <argint>
  addr = myproc()->sz;
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	d26080e7          	jalr	-730(ra) # 8000104c <myproc>
    8000232e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002330:	fdc42503          	lw	a0,-36(s0)
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	072080e7          	jalr	114(ra) # 800013a6 <growproc>
    8000233c:	00054863          	bltz	a0,8000234c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002340:	8526                	mv	a0,s1
    80002342:	70a2                	ld	ra,40(sp)
    80002344:	7402                	ld	s0,32(sp)
    80002346:	64e2                	ld	s1,24(sp)
    80002348:	6145                	addi	sp,sp,48
    8000234a:	8082                	ret
    return -1;
    8000234c:	54fd                	li	s1,-1
    8000234e:	bfcd                	j	80002340 <sys_sbrk+0x32>

0000000080002350 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002350:	7139                	addi	sp,sp,-64
    80002352:	fc06                	sd	ra,56(sp)
    80002354:	f822                	sd	s0,48(sp)
    80002356:	f426                	sd	s1,40(sp)
    80002358:	f04a                	sd	s2,32(sp)
    8000235a:	ec4e                	sd	s3,24(sp)
    8000235c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000235e:	fcc40593          	addi	a1,s0,-52
    80002362:	4501                	li	a0,0
    80002364:	00000097          	auipc	ra,0x0
    80002368:	e3e080e7          	jalr	-450(ra) # 800021a2 <argint>
  if(n < 0)
    8000236c:	fcc42783          	lw	a5,-52(s0)
    80002370:	0607cf63          	bltz	a5,800023ee <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002374:	0022c517          	auipc	a0,0x22c
    80002378:	39c50513          	addi	a0,a0,924 # 8022e710 <tickslock>
    8000237c:	00004097          	auipc	ra,0x4
    80002380:	ff0080e7          	jalr	-16(ra) # 8000636c <acquire>
  ticks0 = ticks;
    80002384:	00006917          	auipc	s2,0x6
    80002388:	52492903          	lw	s2,1316(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    8000238c:	fcc42783          	lw	a5,-52(s0)
    80002390:	cf9d                	beqz	a5,800023ce <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002392:	0022c997          	auipc	s3,0x22c
    80002396:	37e98993          	addi	s3,s3,894 # 8022e710 <tickslock>
    8000239a:	00006497          	auipc	s1,0x6
    8000239e:	50e48493          	addi	s1,s1,1294 # 800088a8 <ticks>
    if(killed(myproc())){
    800023a2:	fffff097          	auipc	ra,0xfffff
    800023a6:	caa080e7          	jalr	-854(ra) # 8000104c <myproc>
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	5ee080e7          	jalr	1518(ra) # 80001998 <killed>
    800023b2:	e129                	bnez	a0,800023f4 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800023b4:	85ce                	mv	a1,s3
    800023b6:	8526                	mv	a0,s1
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	338080e7          	jalr	824(ra) # 800016f0 <sleep>
  while(ticks - ticks0 < n){
    800023c0:	409c                	lw	a5,0(s1)
    800023c2:	412787bb          	subw	a5,a5,s2
    800023c6:	fcc42703          	lw	a4,-52(s0)
    800023ca:	fce7ece3          	bltu	a5,a4,800023a2 <sys_sleep+0x52>
  }
  release(&tickslock);
    800023ce:	0022c517          	auipc	a0,0x22c
    800023d2:	34250513          	addi	a0,a0,834 # 8022e710 <tickslock>
    800023d6:	00004097          	auipc	ra,0x4
    800023da:	04a080e7          	jalr	74(ra) # 80006420 <release>
  return 0;
    800023de:	4501                	li	a0,0
}
    800023e0:	70e2                	ld	ra,56(sp)
    800023e2:	7442                	ld	s0,48(sp)
    800023e4:	74a2                	ld	s1,40(sp)
    800023e6:	7902                	ld	s2,32(sp)
    800023e8:	69e2                	ld	s3,24(sp)
    800023ea:	6121                	addi	sp,sp,64
    800023ec:	8082                	ret
    n = 0;
    800023ee:	fc042623          	sw	zero,-52(s0)
    800023f2:	b749                	j	80002374 <sys_sleep+0x24>
      release(&tickslock);
    800023f4:	0022c517          	auipc	a0,0x22c
    800023f8:	31c50513          	addi	a0,a0,796 # 8022e710 <tickslock>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	024080e7          	jalr	36(ra) # 80006420 <release>
      return -1;
    80002404:	557d                	li	a0,-1
    80002406:	bfe9                	j	800023e0 <sys_sleep+0x90>

0000000080002408 <sys_kill>:

uint64
sys_kill(void)
{
    80002408:	1101                	addi	sp,sp,-32
    8000240a:	ec06                	sd	ra,24(sp)
    8000240c:	e822                	sd	s0,16(sp)
    8000240e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002410:	fec40593          	addi	a1,s0,-20
    80002414:	4501                	li	a0,0
    80002416:	00000097          	auipc	ra,0x0
    8000241a:	d8c080e7          	jalr	-628(ra) # 800021a2 <argint>
  return kill(pid);
    8000241e:	fec42503          	lw	a0,-20(s0)
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	4d8080e7          	jalr	1240(ra) # 800018fa <kill>
}
    8000242a:	60e2                	ld	ra,24(sp)
    8000242c:	6442                	ld	s0,16(sp)
    8000242e:	6105                	addi	sp,sp,32
    80002430:	8082                	ret

0000000080002432 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002432:	1101                	addi	sp,sp,-32
    80002434:	ec06                	sd	ra,24(sp)
    80002436:	e822                	sd	s0,16(sp)
    80002438:	e426                	sd	s1,8(sp)
    8000243a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000243c:	0022c517          	auipc	a0,0x22c
    80002440:	2d450513          	addi	a0,a0,724 # 8022e710 <tickslock>
    80002444:	00004097          	auipc	ra,0x4
    80002448:	f28080e7          	jalr	-216(ra) # 8000636c <acquire>
  xticks = ticks;
    8000244c:	00006497          	auipc	s1,0x6
    80002450:	45c4a483          	lw	s1,1116(s1) # 800088a8 <ticks>
  release(&tickslock);
    80002454:	0022c517          	auipc	a0,0x22c
    80002458:	2bc50513          	addi	a0,a0,700 # 8022e710 <tickslock>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	fc4080e7          	jalr	-60(ra) # 80006420 <release>
  return xticks;
}
    80002464:	02049513          	slli	a0,s1,0x20
    80002468:	9101                	srli	a0,a0,0x20
    8000246a:	60e2                	ld	ra,24(sp)
    8000246c:	6442                	ld	s0,16(sp)
    8000246e:	64a2                	ld	s1,8(sp)
    80002470:	6105                	addi	sp,sp,32
    80002472:	8082                	ret

0000000080002474 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002474:	7179                	addi	sp,sp,-48
    80002476:	f406                	sd	ra,40(sp)
    80002478:	f022                	sd	s0,32(sp)
    8000247a:	ec26                	sd	s1,24(sp)
    8000247c:	e84a                	sd	s2,16(sp)
    8000247e:	e44e                	sd	s3,8(sp)
    80002480:	e052                	sd	s4,0(sp)
    80002482:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002484:	00006597          	auipc	a1,0x6
    80002488:	ffc58593          	addi	a1,a1,-4 # 80008480 <syscalls+0xb0>
    8000248c:	0022c517          	auipc	a0,0x22c
    80002490:	29c50513          	addi	a0,a0,668 # 8022e728 <bcache>
    80002494:	00004097          	auipc	ra,0x4
    80002498:	e48080e7          	jalr	-440(ra) # 800062dc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000249c:	00234797          	auipc	a5,0x234
    800024a0:	28c78793          	addi	a5,a5,652 # 80236728 <bcache+0x8000>
    800024a4:	00234717          	auipc	a4,0x234
    800024a8:	4ec70713          	addi	a4,a4,1260 # 80236990 <bcache+0x8268>
    800024ac:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024b0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024b4:	0022c497          	auipc	s1,0x22c
    800024b8:	28c48493          	addi	s1,s1,652 # 8022e740 <bcache+0x18>
    b->next = bcache.head.next;
    800024bc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024be:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024c0:	00006a17          	auipc	s4,0x6
    800024c4:	fc8a0a13          	addi	s4,s4,-56 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    800024c8:	2b893783          	ld	a5,696(s2)
    800024cc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024ce:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024d2:	85d2                	mv	a1,s4
    800024d4:	01048513          	addi	a0,s1,16
    800024d8:	00001097          	auipc	ra,0x1
    800024dc:	4c4080e7          	jalr	1220(ra) # 8000399c <initsleeplock>
    bcache.head.next->prev = b;
    800024e0:	2b893783          	ld	a5,696(s2)
    800024e4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024e6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ea:	45848493          	addi	s1,s1,1112
    800024ee:	fd349de3          	bne	s1,s3,800024c8 <binit+0x54>
  }
}
    800024f2:	70a2                	ld	ra,40(sp)
    800024f4:	7402                	ld	s0,32(sp)
    800024f6:	64e2                	ld	s1,24(sp)
    800024f8:	6942                	ld	s2,16(sp)
    800024fa:	69a2                	ld	s3,8(sp)
    800024fc:	6a02                	ld	s4,0(sp)
    800024fe:	6145                	addi	sp,sp,48
    80002500:	8082                	ret

0000000080002502 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002502:	7179                	addi	sp,sp,-48
    80002504:	f406                	sd	ra,40(sp)
    80002506:	f022                	sd	s0,32(sp)
    80002508:	ec26                	sd	s1,24(sp)
    8000250a:	e84a                	sd	s2,16(sp)
    8000250c:	e44e                	sd	s3,8(sp)
    8000250e:	1800                	addi	s0,sp,48
    80002510:	89aa                	mv	s3,a0
    80002512:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002514:	0022c517          	auipc	a0,0x22c
    80002518:	21450513          	addi	a0,a0,532 # 8022e728 <bcache>
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	e50080e7          	jalr	-432(ra) # 8000636c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002524:	00234497          	auipc	s1,0x234
    80002528:	4bc4b483          	ld	s1,1212(s1) # 802369e0 <bcache+0x82b8>
    8000252c:	00234797          	auipc	a5,0x234
    80002530:	46478793          	addi	a5,a5,1124 # 80236990 <bcache+0x8268>
    80002534:	02f48f63          	beq	s1,a5,80002572 <bread+0x70>
    80002538:	873e                	mv	a4,a5
    8000253a:	a021                	j	80002542 <bread+0x40>
    8000253c:	68a4                	ld	s1,80(s1)
    8000253e:	02e48a63          	beq	s1,a4,80002572 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002542:	449c                	lw	a5,8(s1)
    80002544:	ff379ce3          	bne	a5,s3,8000253c <bread+0x3a>
    80002548:	44dc                	lw	a5,12(s1)
    8000254a:	ff2799e3          	bne	a5,s2,8000253c <bread+0x3a>
      b->refcnt++;
    8000254e:	40bc                	lw	a5,64(s1)
    80002550:	2785                	addiw	a5,a5,1
    80002552:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002554:	0022c517          	auipc	a0,0x22c
    80002558:	1d450513          	addi	a0,a0,468 # 8022e728 <bcache>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	ec4080e7          	jalr	-316(ra) # 80006420 <release>
      acquiresleep(&b->lock);
    80002564:	01048513          	addi	a0,s1,16
    80002568:	00001097          	auipc	ra,0x1
    8000256c:	46e080e7          	jalr	1134(ra) # 800039d6 <acquiresleep>
      return b;
    80002570:	a8b9                	j	800025ce <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002572:	00234497          	auipc	s1,0x234
    80002576:	4664b483          	ld	s1,1126(s1) # 802369d8 <bcache+0x82b0>
    8000257a:	00234797          	auipc	a5,0x234
    8000257e:	41678793          	addi	a5,a5,1046 # 80236990 <bcache+0x8268>
    80002582:	00f48863          	beq	s1,a5,80002592 <bread+0x90>
    80002586:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002588:	40bc                	lw	a5,64(s1)
    8000258a:	cf81                	beqz	a5,800025a2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000258c:	64a4                	ld	s1,72(s1)
    8000258e:	fee49de3          	bne	s1,a4,80002588 <bread+0x86>
  panic("bget: no buffers");
    80002592:	00006517          	auipc	a0,0x6
    80002596:	efe50513          	addi	a0,a0,-258 # 80008490 <syscalls+0xc0>
    8000259a:	00004097          	auipc	ra,0x4
    8000259e:	888080e7          	jalr	-1912(ra) # 80005e22 <panic>
      b->dev = dev;
    800025a2:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025a6:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025aa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025ae:	4785                	li	a5,1
    800025b0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025b2:	0022c517          	auipc	a0,0x22c
    800025b6:	17650513          	addi	a0,a0,374 # 8022e728 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	e66080e7          	jalr	-410(ra) # 80006420 <release>
      acquiresleep(&b->lock);
    800025c2:	01048513          	addi	a0,s1,16
    800025c6:	00001097          	auipc	ra,0x1
    800025ca:	410080e7          	jalr	1040(ra) # 800039d6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025ce:	409c                	lw	a5,0(s1)
    800025d0:	cb89                	beqz	a5,800025e2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025d2:	8526                	mv	a0,s1
    800025d4:	70a2                	ld	ra,40(sp)
    800025d6:	7402                	ld	s0,32(sp)
    800025d8:	64e2                	ld	s1,24(sp)
    800025da:	6942                	ld	s2,16(sp)
    800025dc:	69a2                	ld	s3,8(sp)
    800025de:	6145                	addi	sp,sp,48
    800025e0:	8082                	ret
    virtio_disk_rw(b, 0);
    800025e2:	4581                	li	a1,0
    800025e4:	8526                	mv	a0,s1
    800025e6:	00003097          	auipc	ra,0x3
    800025ea:	fd2080e7          	jalr	-46(ra) # 800055b8 <virtio_disk_rw>
    b->valid = 1;
    800025ee:	4785                	li	a5,1
    800025f0:	c09c                	sw	a5,0(s1)
  return b;
    800025f2:	b7c5                	j	800025d2 <bread+0xd0>

00000000800025f4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025f4:	1101                	addi	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	1000                	addi	s0,sp,32
    800025fe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002600:	0541                	addi	a0,a0,16
    80002602:	00001097          	auipc	ra,0x1
    80002606:	46e080e7          	jalr	1134(ra) # 80003a70 <holdingsleep>
    8000260a:	cd01                	beqz	a0,80002622 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000260c:	4585                	li	a1,1
    8000260e:	8526                	mv	a0,s1
    80002610:	00003097          	auipc	ra,0x3
    80002614:	fa8080e7          	jalr	-88(ra) # 800055b8 <virtio_disk_rw>
}
    80002618:	60e2                	ld	ra,24(sp)
    8000261a:	6442                	ld	s0,16(sp)
    8000261c:	64a2                	ld	s1,8(sp)
    8000261e:	6105                	addi	sp,sp,32
    80002620:	8082                	ret
    panic("bwrite");
    80002622:	00006517          	auipc	a0,0x6
    80002626:	e8650513          	addi	a0,a0,-378 # 800084a8 <syscalls+0xd8>
    8000262a:	00003097          	auipc	ra,0x3
    8000262e:	7f8080e7          	jalr	2040(ra) # 80005e22 <panic>

0000000080002632 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002632:	1101                	addi	sp,sp,-32
    80002634:	ec06                	sd	ra,24(sp)
    80002636:	e822                	sd	s0,16(sp)
    80002638:	e426                	sd	s1,8(sp)
    8000263a:	e04a                	sd	s2,0(sp)
    8000263c:	1000                	addi	s0,sp,32
    8000263e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002640:	01050913          	addi	s2,a0,16
    80002644:	854a                	mv	a0,s2
    80002646:	00001097          	auipc	ra,0x1
    8000264a:	42a080e7          	jalr	1066(ra) # 80003a70 <holdingsleep>
    8000264e:	c92d                	beqz	a0,800026c0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002650:	854a                	mv	a0,s2
    80002652:	00001097          	auipc	ra,0x1
    80002656:	3da080e7          	jalr	986(ra) # 80003a2c <releasesleep>

  acquire(&bcache.lock);
    8000265a:	0022c517          	auipc	a0,0x22c
    8000265e:	0ce50513          	addi	a0,a0,206 # 8022e728 <bcache>
    80002662:	00004097          	auipc	ra,0x4
    80002666:	d0a080e7          	jalr	-758(ra) # 8000636c <acquire>
  b->refcnt--;
    8000266a:	40bc                	lw	a5,64(s1)
    8000266c:	37fd                	addiw	a5,a5,-1
    8000266e:	0007871b          	sext.w	a4,a5
    80002672:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002674:	eb05                	bnez	a4,800026a4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002676:	68bc                	ld	a5,80(s1)
    80002678:	64b8                	ld	a4,72(s1)
    8000267a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000267c:	64bc                	ld	a5,72(s1)
    8000267e:	68b8                	ld	a4,80(s1)
    80002680:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002682:	00234797          	auipc	a5,0x234
    80002686:	0a678793          	addi	a5,a5,166 # 80236728 <bcache+0x8000>
    8000268a:	2b87b703          	ld	a4,696(a5)
    8000268e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002690:	00234717          	auipc	a4,0x234
    80002694:	30070713          	addi	a4,a4,768 # 80236990 <bcache+0x8268>
    80002698:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000269a:	2b87b703          	ld	a4,696(a5)
    8000269e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026a0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026a4:	0022c517          	auipc	a0,0x22c
    800026a8:	08450513          	addi	a0,a0,132 # 8022e728 <bcache>
    800026ac:	00004097          	auipc	ra,0x4
    800026b0:	d74080e7          	jalr	-652(ra) # 80006420 <release>
}
    800026b4:	60e2                	ld	ra,24(sp)
    800026b6:	6442                	ld	s0,16(sp)
    800026b8:	64a2                	ld	s1,8(sp)
    800026ba:	6902                	ld	s2,0(sp)
    800026bc:	6105                	addi	sp,sp,32
    800026be:	8082                	ret
    panic("brelse");
    800026c0:	00006517          	auipc	a0,0x6
    800026c4:	df050513          	addi	a0,a0,-528 # 800084b0 <syscalls+0xe0>
    800026c8:	00003097          	auipc	ra,0x3
    800026cc:	75a080e7          	jalr	1882(ra) # 80005e22 <panic>

00000000800026d0 <bpin>:

void
bpin(struct buf *b) {
    800026d0:	1101                	addi	sp,sp,-32
    800026d2:	ec06                	sd	ra,24(sp)
    800026d4:	e822                	sd	s0,16(sp)
    800026d6:	e426                	sd	s1,8(sp)
    800026d8:	1000                	addi	s0,sp,32
    800026da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026dc:	0022c517          	auipc	a0,0x22c
    800026e0:	04c50513          	addi	a0,a0,76 # 8022e728 <bcache>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	c88080e7          	jalr	-888(ra) # 8000636c <acquire>
  b->refcnt++;
    800026ec:	40bc                	lw	a5,64(s1)
    800026ee:	2785                	addiw	a5,a5,1
    800026f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026f2:	0022c517          	auipc	a0,0x22c
    800026f6:	03650513          	addi	a0,a0,54 # 8022e728 <bcache>
    800026fa:	00004097          	auipc	ra,0x4
    800026fe:	d26080e7          	jalr	-730(ra) # 80006420 <release>
}
    80002702:	60e2                	ld	ra,24(sp)
    80002704:	6442                	ld	s0,16(sp)
    80002706:	64a2                	ld	s1,8(sp)
    80002708:	6105                	addi	sp,sp,32
    8000270a:	8082                	ret

000000008000270c <bunpin>:

void
bunpin(struct buf *b) {
    8000270c:	1101                	addi	sp,sp,-32
    8000270e:	ec06                	sd	ra,24(sp)
    80002710:	e822                	sd	s0,16(sp)
    80002712:	e426                	sd	s1,8(sp)
    80002714:	1000                	addi	s0,sp,32
    80002716:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002718:	0022c517          	auipc	a0,0x22c
    8000271c:	01050513          	addi	a0,a0,16 # 8022e728 <bcache>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	c4c080e7          	jalr	-948(ra) # 8000636c <acquire>
  b->refcnt--;
    80002728:	40bc                	lw	a5,64(s1)
    8000272a:	37fd                	addiw	a5,a5,-1
    8000272c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000272e:	0022c517          	auipc	a0,0x22c
    80002732:	ffa50513          	addi	a0,a0,-6 # 8022e728 <bcache>
    80002736:	00004097          	auipc	ra,0x4
    8000273a:	cea080e7          	jalr	-790(ra) # 80006420 <release>
}
    8000273e:	60e2                	ld	ra,24(sp)
    80002740:	6442                	ld	s0,16(sp)
    80002742:	64a2                	ld	s1,8(sp)
    80002744:	6105                	addi	sp,sp,32
    80002746:	8082                	ret

0000000080002748 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002748:	1101                	addi	sp,sp,-32
    8000274a:	ec06                	sd	ra,24(sp)
    8000274c:	e822                	sd	s0,16(sp)
    8000274e:	e426                	sd	s1,8(sp)
    80002750:	e04a                	sd	s2,0(sp)
    80002752:	1000                	addi	s0,sp,32
    80002754:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002756:	00d5d59b          	srliw	a1,a1,0xd
    8000275a:	00234797          	auipc	a5,0x234
    8000275e:	6aa7a783          	lw	a5,1706(a5) # 80236e04 <sb+0x1c>
    80002762:	9dbd                	addw	a1,a1,a5
    80002764:	00000097          	auipc	ra,0x0
    80002768:	d9e080e7          	jalr	-610(ra) # 80002502 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000276c:	0074f713          	andi	a4,s1,7
    80002770:	4785                	li	a5,1
    80002772:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002776:	14ce                	slli	s1,s1,0x33
    80002778:	90d9                	srli	s1,s1,0x36
    8000277a:	00950733          	add	a4,a0,s1
    8000277e:	05874703          	lbu	a4,88(a4)
    80002782:	00e7f6b3          	and	a3,a5,a4
    80002786:	c69d                	beqz	a3,800027b4 <bfree+0x6c>
    80002788:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000278a:	94aa                	add	s1,s1,a0
    8000278c:	fff7c793          	not	a5,a5
    80002790:	8ff9                	and	a5,a5,a4
    80002792:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002796:	00001097          	auipc	ra,0x1
    8000279a:	120080e7          	jalr	288(ra) # 800038b6 <log_write>
  brelse(bp);
    8000279e:	854a                	mv	a0,s2
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	e92080e7          	jalr	-366(ra) # 80002632 <brelse>
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6902                	ld	s2,0(sp)
    800027b0:	6105                	addi	sp,sp,32
    800027b2:	8082                	ret
    panic("freeing free block");
    800027b4:	00006517          	auipc	a0,0x6
    800027b8:	d0450513          	addi	a0,a0,-764 # 800084b8 <syscalls+0xe8>
    800027bc:	00003097          	auipc	ra,0x3
    800027c0:	666080e7          	jalr	1638(ra) # 80005e22 <panic>

00000000800027c4 <balloc>:
{
    800027c4:	711d                	addi	sp,sp,-96
    800027c6:	ec86                	sd	ra,88(sp)
    800027c8:	e8a2                	sd	s0,80(sp)
    800027ca:	e4a6                	sd	s1,72(sp)
    800027cc:	e0ca                	sd	s2,64(sp)
    800027ce:	fc4e                	sd	s3,56(sp)
    800027d0:	f852                	sd	s4,48(sp)
    800027d2:	f456                	sd	s5,40(sp)
    800027d4:	f05a                	sd	s6,32(sp)
    800027d6:	ec5e                	sd	s7,24(sp)
    800027d8:	e862                	sd	s8,16(sp)
    800027da:	e466                	sd	s9,8(sp)
    800027dc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027de:	00234797          	auipc	a5,0x234
    800027e2:	60e7a783          	lw	a5,1550(a5) # 80236dec <sb+0x4>
    800027e6:	10078163          	beqz	a5,800028e8 <balloc+0x124>
    800027ea:	8baa                	mv	s7,a0
    800027ec:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027ee:	00234b17          	auipc	s6,0x234
    800027f2:	5fab0b13          	addi	s6,s6,1530 # 80236de8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027f6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027f8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fa:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027fc:	6c89                	lui	s9,0x2
    800027fe:	a061                	j	80002886 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002800:	974a                	add	a4,a4,s2
    80002802:	8fd5                	or	a5,a5,a3
    80002804:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002808:	854a                	mv	a0,s2
    8000280a:	00001097          	auipc	ra,0x1
    8000280e:	0ac080e7          	jalr	172(ra) # 800038b6 <log_write>
        brelse(bp);
    80002812:	854a                	mv	a0,s2
    80002814:	00000097          	auipc	ra,0x0
    80002818:	e1e080e7          	jalr	-482(ra) # 80002632 <brelse>
  bp = bread(dev, bno);
    8000281c:	85a6                	mv	a1,s1
    8000281e:	855e                	mv	a0,s7
    80002820:	00000097          	auipc	ra,0x0
    80002824:	ce2080e7          	jalr	-798(ra) # 80002502 <bread>
    80002828:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000282a:	40000613          	li	a2,1024
    8000282e:	4581                	li	a1,0
    80002830:	05850513          	addi	a0,a0,88
    80002834:	ffffe097          	auipc	ra,0xffffe
    80002838:	b36080e7          	jalr	-1226(ra) # 8000036a <memset>
  log_write(bp);
    8000283c:	854a                	mv	a0,s2
    8000283e:	00001097          	auipc	ra,0x1
    80002842:	078080e7          	jalr	120(ra) # 800038b6 <log_write>
  brelse(bp);
    80002846:	854a                	mv	a0,s2
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	dea080e7          	jalr	-534(ra) # 80002632 <brelse>
}
    80002850:	8526                	mv	a0,s1
    80002852:	60e6                	ld	ra,88(sp)
    80002854:	6446                	ld	s0,80(sp)
    80002856:	64a6                	ld	s1,72(sp)
    80002858:	6906                	ld	s2,64(sp)
    8000285a:	79e2                	ld	s3,56(sp)
    8000285c:	7a42                	ld	s4,48(sp)
    8000285e:	7aa2                	ld	s5,40(sp)
    80002860:	7b02                	ld	s6,32(sp)
    80002862:	6be2                	ld	s7,24(sp)
    80002864:	6c42                	ld	s8,16(sp)
    80002866:	6ca2                	ld	s9,8(sp)
    80002868:	6125                	addi	sp,sp,96
    8000286a:	8082                	ret
    brelse(bp);
    8000286c:	854a                	mv	a0,s2
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	dc4080e7          	jalr	-572(ra) # 80002632 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002876:	015c87bb          	addw	a5,s9,s5
    8000287a:	00078a9b          	sext.w	s5,a5
    8000287e:	004b2703          	lw	a4,4(s6)
    80002882:	06eaf363          	bgeu	s5,a4,800028e8 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002886:	41fad79b          	sraiw	a5,s5,0x1f
    8000288a:	0137d79b          	srliw	a5,a5,0x13
    8000288e:	015787bb          	addw	a5,a5,s5
    80002892:	40d7d79b          	sraiw	a5,a5,0xd
    80002896:	01cb2583          	lw	a1,28(s6)
    8000289a:	9dbd                	addw	a1,a1,a5
    8000289c:	855e                	mv	a0,s7
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	c64080e7          	jalr	-924(ra) # 80002502 <bread>
    800028a6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a8:	004b2503          	lw	a0,4(s6)
    800028ac:	000a849b          	sext.w	s1,s5
    800028b0:	8662                	mv	a2,s8
    800028b2:	faa4fde3          	bgeu	s1,a0,8000286c <balloc+0xa8>
      m = 1 << (bi % 8);
    800028b6:	41f6579b          	sraiw	a5,a2,0x1f
    800028ba:	01d7d69b          	srliw	a3,a5,0x1d
    800028be:	00c6873b          	addw	a4,a3,a2
    800028c2:	00777793          	andi	a5,a4,7
    800028c6:	9f95                	subw	a5,a5,a3
    800028c8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028cc:	4037571b          	sraiw	a4,a4,0x3
    800028d0:	00e906b3          	add	a3,s2,a4
    800028d4:	0586c683          	lbu	a3,88(a3)
    800028d8:	00d7f5b3          	and	a1,a5,a3
    800028dc:	d195                	beqz	a1,80002800 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028de:	2605                	addiw	a2,a2,1
    800028e0:	2485                	addiw	s1,s1,1
    800028e2:	fd4618e3          	bne	a2,s4,800028b2 <balloc+0xee>
    800028e6:	b759                	j	8000286c <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800028e8:	00006517          	auipc	a0,0x6
    800028ec:	be850513          	addi	a0,a0,-1048 # 800084d0 <syscalls+0x100>
    800028f0:	00003097          	auipc	ra,0x3
    800028f4:	57c080e7          	jalr	1404(ra) # 80005e6c <printf>
  return 0;
    800028f8:	4481                	li	s1,0
    800028fa:	bf99                	j	80002850 <balloc+0x8c>

00000000800028fc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800028fc:	7179                	addi	sp,sp,-48
    800028fe:	f406                	sd	ra,40(sp)
    80002900:	f022                	sd	s0,32(sp)
    80002902:	ec26                	sd	s1,24(sp)
    80002904:	e84a                	sd	s2,16(sp)
    80002906:	e44e                	sd	s3,8(sp)
    80002908:	e052                	sd	s4,0(sp)
    8000290a:	1800                	addi	s0,sp,48
    8000290c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000290e:	47ad                	li	a5,11
    80002910:	02b7e763          	bltu	a5,a1,8000293e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002914:	02059493          	slli	s1,a1,0x20
    80002918:	9081                	srli	s1,s1,0x20
    8000291a:	048a                	slli	s1,s1,0x2
    8000291c:	94aa                	add	s1,s1,a0
    8000291e:	0504a903          	lw	s2,80(s1)
    80002922:	06091e63          	bnez	s2,8000299e <bmap+0xa2>
      addr = balloc(ip->dev);
    80002926:	4108                	lw	a0,0(a0)
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	e9c080e7          	jalr	-356(ra) # 800027c4 <balloc>
    80002930:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002934:	06090563          	beqz	s2,8000299e <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002938:	0524a823          	sw	s2,80(s1)
    8000293c:	a08d                	j	8000299e <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000293e:	ff45849b          	addiw	s1,a1,-12
    80002942:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002946:	0ff00793          	li	a5,255
    8000294a:	08e7e563          	bltu	a5,a4,800029d4 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000294e:	08052903          	lw	s2,128(a0)
    80002952:	00091d63          	bnez	s2,8000296c <bmap+0x70>
      addr = balloc(ip->dev);
    80002956:	4108                	lw	a0,0(a0)
    80002958:	00000097          	auipc	ra,0x0
    8000295c:	e6c080e7          	jalr	-404(ra) # 800027c4 <balloc>
    80002960:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002964:	02090d63          	beqz	s2,8000299e <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002968:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000296c:	85ca                	mv	a1,s2
    8000296e:	0009a503          	lw	a0,0(s3)
    80002972:	00000097          	auipc	ra,0x0
    80002976:	b90080e7          	jalr	-1136(ra) # 80002502 <bread>
    8000297a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000297c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002980:	02049593          	slli	a1,s1,0x20
    80002984:	9181                	srli	a1,a1,0x20
    80002986:	058a                	slli	a1,a1,0x2
    80002988:	00b784b3          	add	s1,a5,a1
    8000298c:	0004a903          	lw	s2,0(s1)
    80002990:	02090063          	beqz	s2,800029b0 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002994:	8552                	mv	a0,s4
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	c9c080e7          	jalr	-868(ra) # 80002632 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000299e:	854a                	mv	a0,s2
    800029a0:	70a2                	ld	ra,40(sp)
    800029a2:	7402                	ld	s0,32(sp)
    800029a4:	64e2                	ld	s1,24(sp)
    800029a6:	6942                	ld	s2,16(sp)
    800029a8:	69a2                	ld	s3,8(sp)
    800029aa:	6a02                	ld	s4,0(sp)
    800029ac:	6145                	addi	sp,sp,48
    800029ae:	8082                	ret
      addr = balloc(ip->dev);
    800029b0:	0009a503          	lw	a0,0(s3)
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	e10080e7          	jalr	-496(ra) # 800027c4 <balloc>
    800029bc:	0005091b          	sext.w	s2,a0
      if(addr){
    800029c0:	fc090ae3          	beqz	s2,80002994 <bmap+0x98>
        a[bn] = addr;
    800029c4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800029c8:	8552                	mv	a0,s4
    800029ca:	00001097          	auipc	ra,0x1
    800029ce:	eec080e7          	jalr	-276(ra) # 800038b6 <log_write>
    800029d2:	b7c9                	j	80002994 <bmap+0x98>
  panic("bmap: out of range");
    800029d4:	00006517          	auipc	a0,0x6
    800029d8:	b1450513          	addi	a0,a0,-1260 # 800084e8 <syscalls+0x118>
    800029dc:	00003097          	auipc	ra,0x3
    800029e0:	446080e7          	jalr	1094(ra) # 80005e22 <panic>

00000000800029e4 <iget>:
{
    800029e4:	7179                	addi	sp,sp,-48
    800029e6:	f406                	sd	ra,40(sp)
    800029e8:	f022                	sd	s0,32(sp)
    800029ea:	ec26                	sd	s1,24(sp)
    800029ec:	e84a                	sd	s2,16(sp)
    800029ee:	e44e                	sd	s3,8(sp)
    800029f0:	e052                	sd	s4,0(sp)
    800029f2:	1800                	addi	s0,sp,48
    800029f4:	89aa                	mv	s3,a0
    800029f6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029f8:	00234517          	auipc	a0,0x234
    800029fc:	41050513          	addi	a0,a0,1040 # 80236e08 <itable>
    80002a00:	00004097          	auipc	ra,0x4
    80002a04:	96c080e7          	jalr	-1684(ra) # 8000636c <acquire>
  empty = 0;
    80002a08:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a0a:	00234497          	auipc	s1,0x234
    80002a0e:	41648493          	addi	s1,s1,1046 # 80236e20 <itable+0x18>
    80002a12:	00236697          	auipc	a3,0x236
    80002a16:	e9e68693          	addi	a3,a3,-354 # 802388b0 <log>
    80002a1a:	a039                	j	80002a28 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a1c:	02090b63          	beqz	s2,80002a52 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a20:	08848493          	addi	s1,s1,136
    80002a24:	02d48a63          	beq	s1,a3,80002a58 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a28:	449c                	lw	a5,8(s1)
    80002a2a:	fef059e3          	blez	a5,80002a1c <iget+0x38>
    80002a2e:	4098                	lw	a4,0(s1)
    80002a30:	ff3716e3          	bne	a4,s3,80002a1c <iget+0x38>
    80002a34:	40d8                	lw	a4,4(s1)
    80002a36:	ff4713e3          	bne	a4,s4,80002a1c <iget+0x38>
      ip->ref++;
    80002a3a:	2785                	addiw	a5,a5,1
    80002a3c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a3e:	00234517          	auipc	a0,0x234
    80002a42:	3ca50513          	addi	a0,a0,970 # 80236e08 <itable>
    80002a46:	00004097          	auipc	ra,0x4
    80002a4a:	9da080e7          	jalr	-1574(ra) # 80006420 <release>
      return ip;
    80002a4e:	8926                	mv	s2,s1
    80002a50:	a03d                	j	80002a7e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a52:	f7f9                	bnez	a5,80002a20 <iget+0x3c>
    80002a54:	8926                	mv	s2,s1
    80002a56:	b7e9                	j	80002a20 <iget+0x3c>
  if(empty == 0)
    80002a58:	02090c63          	beqz	s2,80002a90 <iget+0xac>
  ip->dev = dev;
    80002a5c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a60:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a64:	4785                	li	a5,1
    80002a66:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a6a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a6e:	00234517          	auipc	a0,0x234
    80002a72:	39a50513          	addi	a0,a0,922 # 80236e08 <itable>
    80002a76:	00004097          	auipc	ra,0x4
    80002a7a:	9aa080e7          	jalr	-1622(ra) # 80006420 <release>
}
    80002a7e:	854a                	mv	a0,s2
    80002a80:	70a2                	ld	ra,40(sp)
    80002a82:	7402                	ld	s0,32(sp)
    80002a84:	64e2                	ld	s1,24(sp)
    80002a86:	6942                	ld	s2,16(sp)
    80002a88:	69a2                	ld	s3,8(sp)
    80002a8a:	6a02                	ld	s4,0(sp)
    80002a8c:	6145                	addi	sp,sp,48
    80002a8e:	8082                	ret
    panic("iget: no inodes");
    80002a90:	00006517          	auipc	a0,0x6
    80002a94:	a7050513          	addi	a0,a0,-1424 # 80008500 <syscalls+0x130>
    80002a98:	00003097          	auipc	ra,0x3
    80002a9c:	38a080e7          	jalr	906(ra) # 80005e22 <panic>

0000000080002aa0 <fsinit>:
fsinit(int dev) {
    80002aa0:	7179                	addi	sp,sp,-48
    80002aa2:	f406                	sd	ra,40(sp)
    80002aa4:	f022                	sd	s0,32(sp)
    80002aa6:	ec26                	sd	s1,24(sp)
    80002aa8:	e84a                	sd	s2,16(sp)
    80002aaa:	e44e                	sd	s3,8(sp)
    80002aac:	1800                	addi	s0,sp,48
    80002aae:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ab0:	4585                	li	a1,1
    80002ab2:	00000097          	auipc	ra,0x0
    80002ab6:	a50080e7          	jalr	-1456(ra) # 80002502 <bread>
    80002aba:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002abc:	00234997          	auipc	s3,0x234
    80002ac0:	32c98993          	addi	s3,s3,812 # 80236de8 <sb>
    80002ac4:	02000613          	li	a2,32
    80002ac8:	05850593          	addi	a1,a0,88
    80002acc:	854e                	mv	a0,s3
    80002ace:	ffffe097          	auipc	ra,0xffffe
    80002ad2:	8fc080e7          	jalr	-1796(ra) # 800003ca <memmove>
  brelse(bp);
    80002ad6:	8526                	mv	a0,s1
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	b5a080e7          	jalr	-1190(ra) # 80002632 <brelse>
  if(sb.magic != FSMAGIC)
    80002ae0:	0009a703          	lw	a4,0(s3)
    80002ae4:	102037b7          	lui	a5,0x10203
    80002ae8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002aec:	02f71263          	bne	a4,a5,80002b10 <fsinit+0x70>
  initlog(dev, &sb);
    80002af0:	00234597          	auipc	a1,0x234
    80002af4:	2f858593          	addi	a1,a1,760 # 80236de8 <sb>
    80002af8:	854a                	mv	a0,s2
    80002afa:	00001097          	auipc	ra,0x1
    80002afe:	b40080e7          	jalr	-1216(ra) # 8000363a <initlog>
}
    80002b02:	70a2                	ld	ra,40(sp)
    80002b04:	7402                	ld	s0,32(sp)
    80002b06:	64e2                	ld	s1,24(sp)
    80002b08:	6942                	ld	s2,16(sp)
    80002b0a:	69a2                	ld	s3,8(sp)
    80002b0c:	6145                	addi	sp,sp,48
    80002b0e:	8082                	ret
    panic("invalid file system");
    80002b10:	00006517          	auipc	a0,0x6
    80002b14:	a0050513          	addi	a0,a0,-1536 # 80008510 <syscalls+0x140>
    80002b18:	00003097          	auipc	ra,0x3
    80002b1c:	30a080e7          	jalr	778(ra) # 80005e22 <panic>

0000000080002b20 <iinit>:
{
    80002b20:	7179                	addi	sp,sp,-48
    80002b22:	f406                	sd	ra,40(sp)
    80002b24:	f022                	sd	s0,32(sp)
    80002b26:	ec26                	sd	s1,24(sp)
    80002b28:	e84a                	sd	s2,16(sp)
    80002b2a:	e44e                	sd	s3,8(sp)
    80002b2c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b2e:	00006597          	auipc	a1,0x6
    80002b32:	9fa58593          	addi	a1,a1,-1542 # 80008528 <syscalls+0x158>
    80002b36:	00234517          	auipc	a0,0x234
    80002b3a:	2d250513          	addi	a0,a0,722 # 80236e08 <itable>
    80002b3e:	00003097          	auipc	ra,0x3
    80002b42:	79e080e7          	jalr	1950(ra) # 800062dc <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b46:	00234497          	auipc	s1,0x234
    80002b4a:	2ea48493          	addi	s1,s1,746 # 80236e30 <itable+0x28>
    80002b4e:	00236997          	auipc	s3,0x236
    80002b52:	d7298993          	addi	s3,s3,-654 # 802388c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b56:	00006917          	auipc	s2,0x6
    80002b5a:	9da90913          	addi	s2,s2,-1574 # 80008530 <syscalls+0x160>
    80002b5e:	85ca                	mv	a1,s2
    80002b60:	8526                	mv	a0,s1
    80002b62:	00001097          	auipc	ra,0x1
    80002b66:	e3a080e7          	jalr	-454(ra) # 8000399c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b6a:	08848493          	addi	s1,s1,136
    80002b6e:	ff3498e3          	bne	s1,s3,80002b5e <iinit+0x3e>
}
    80002b72:	70a2                	ld	ra,40(sp)
    80002b74:	7402                	ld	s0,32(sp)
    80002b76:	64e2                	ld	s1,24(sp)
    80002b78:	6942                	ld	s2,16(sp)
    80002b7a:	69a2                	ld	s3,8(sp)
    80002b7c:	6145                	addi	sp,sp,48
    80002b7e:	8082                	ret

0000000080002b80 <ialloc>:
{
    80002b80:	715d                	addi	sp,sp,-80
    80002b82:	e486                	sd	ra,72(sp)
    80002b84:	e0a2                	sd	s0,64(sp)
    80002b86:	fc26                	sd	s1,56(sp)
    80002b88:	f84a                	sd	s2,48(sp)
    80002b8a:	f44e                	sd	s3,40(sp)
    80002b8c:	f052                	sd	s4,32(sp)
    80002b8e:	ec56                	sd	s5,24(sp)
    80002b90:	e85a                	sd	s6,16(sp)
    80002b92:	e45e                	sd	s7,8(sp)
    80002b94:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b96:	00234717          	auipc	a4,0x234
    80002b9a:	25e72703          	lw	a4,606(a4) # 80236df4 <sb+0xc>
    80002b9e:	4785                	li	a5,1
    80002ba0:	04e7fa63          	bgeu	a5,a4,80002bf4 <ialloc+0x74>
    80002ba4:	8aaa                	mv	s5,a0
    80002ba6:	8bae                	mv	s7,a1
    80002ba8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002baa:	00234a17          	auipc	s4,0x234
    80002bae:	23ea0a13          	addi	s4,s4,574 # 80236de8 <sb>
    80002bb2:	00048b1b          	sext.w	s6,s1
    80002bb6:	0044d593          	srli	a1,s1,0x4
    80002bba:	018a2783          	lw	a5,24(s4)
    80002bbe:	9dbd                	addw	a1,a1,a5
    80002bc0:	8556                	mv	a0,s5
    80002bc2:	00000097          	auipc	ra,0x0
    80002bc6:	940080e7          	jalr	-1728(ra) # 80002502 <bread>
    80002bca:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bcc:	05850993          	addi	s3,a0,88
    80002bd0:	00f4f793          	andi	a5,s1,15
    80002bd4:	079a                	slli	a5,a5,0x6
    80002bd6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bd8:	00099783          	lh	a5,0(s3)
    80002bdc:	c3a1                	beqz	a5,80002c1c <ialloc+0x9c>
    brelse(bp);
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	a54080e7          	jalr	-1452(ra) # 80002632 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be6:	0485                	addi	s1,s1,1
    80002be8:	00ca2703          	lw	a4,12(s4)
    80002bec:	0004879b          	sext.w	a5,s1
    80002bf0:	fce7e1e3          	bltu	a5,a4,80002bb2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002bf4:	00006517          	auipc	a0,0x6
    80002bf8:	94450513          	addi	a0,a0,-1724 # 80008538 <syscalls+0x168>
    80002bfc:	00003097          	auipc	ra,0x3
    80002c00:	270080e7          	jalr	624(ra) # 80005e6c <printf>
  return 0;
    80002c04:	4501                	li	a0,0
}
    80002c06:	60a6                	ld	ra,72(sp)
    80002c08:	6406                	ld	s0,64(sp)
    80002c0a:	74e2                	ld	s1,56(sp)
    80002c0c:	7942                	ld	s2,48(sp)
    80002c0e:	79a2                	ld	s3,40(sp)
    80002c10:	7a02                	ld	s4,32(sp)
    80002c12:	6ae2                	ld	s5,24(sp)
    80002c14:	6b42                	ld	s6,16(sp)
    80002c16:	6ba2                	ld	s7,8(sp)
    80002c18:	6161                	addi	sp,sp,80
    80002c1a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c1c:	04000613          	li	a2,64
    80002c20:	4581                	li	a1,0
    80002c22:	854e                	mv	a0,s3
    80002c24:	ffffd097          	auipc	ra,0xffffd
    80002c28:	746080e7          	jalr	1862(ra) # 8000036a <memset>
      dip->type = type;
    80002c2c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c30:	854a                	mv	a0,s2
    80002c32:	00001097          	auipc	ra,0x1
    80002c36:	c84080e7          	jalr	-892(ra) # 800038b6 <log_write>
      brelse(bp);
    80002c3a:	854a                	mv	a0,s2
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	9f6080e7          	jalr	-1546(ra) # 80002632 <brelse>
      return iget(dev, inum);
    80002c44:	85da                	mv	a1,s6
    80002c46:	8556                	mv	a0,s5
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	d9c080e7          	jalr	-612(ra) # 800029e4 <iget>
    80002c50:	bf5d                	j	80002c06 <ialloc+0x86>

0000000080002c52 <iupdate>:
{
    80002c52:	1101                	addi	sp,sp,-32
    80002c54:	ec06                	sd	ra,24(sp)
    80002c56:	e822                	sd	s0,16(sp)
    80002c58:	e426                	sd	s1,8(sp)
    80002c5a:	e04a                	sd	s2,0(sp)
    80002c5c:	1000                	addi	s0,sp,32
    80002c5e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c60:	415c                	lw	a5,4(a0)
    80002c62:	0047d79b          	srliw	a5,a5,0x4
    80002c66:	00234597          	auipc	a1,0x234
    80002c6a:	19a5a583          	lw	a1,410(a1) # 80236e00 <sb+0x18>
    80002c6e:	9dbd                	addw	a1,a1,a5
    80002c70:	4108                	lw	a0,0(a0)
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	890080e7          	jalr	-1904(ra) # 80002502 <bread>
    80002c7a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c7c:	05850793          	addi	a5,a0,88
    80002c80:	40c8                	lw	a0,4(s1)
    80002c82:	893d                	andi	a0,a0,15
    80002c84:	051a                	slli	a0,a0,0x6
    80002c86:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c88:	04449703          	lh	a4,68(s1)
    80002c8c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c90:	04649703          	lh	a4,70(s1)
    80002c94:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c98:	04849703          	lh	a4,72(s1)
    80002c9c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ca0:	04a49703          	lh	a4,74(s1)
    80002ca4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ca8:	44f8                	lw	a4,76(s1)
    80002caa:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cac:	03400613          	li	a2,52
    80002cb0:	05048593          	addi	a1,s1,80
    80002cb4:	0531                	addi	a0,a0,12
    80002cb6:	ffffd097          	auipc	ra,0xffffd
    80002cba:	714080e7          	jalr	1812(ra) # 800003ca <memmove>
  log_write(bp);
    80002cbe:	854a                	mv	a0,s2
    80002cc0:	00001097          	auipc	ra,0x1
    80002cc4:	bf6080e7          	jalr	-1034(ra) # 800038b6 <log_write>
  brelse(bp);
    80002cc8:	854a                	mv	a0,s2
    80002cca:	00000097          	auipc	ra,0x0
    80002cce:	968080e7          	jalr	-1688(ra) # 80002632 <brelse>
}
    80002cd2:	60e2                	ld	ra,24(sp)
    80002cd4:	6442                	ld	s0,16(sp)
    80002cd6:	64a2                	ld	s1,8(sp)
    80002cd8:	6902                	ld	s2,0(sp)
    80002cda:	6105                	addi	sp,sp,32
    80002cdc:	8082                	ret

0000000080002cde <idup>:
{
    80002cde:	1101                	addi	sp,sp,-32
    80002ce0:	ec06                	sd	ra,24(sp)
    80002ce2:	e822                	sd	s0,16(sp)
    80002ce4:	e426                	sd	s1,8(sp)
    80002ce6:	1000                	addi	s0,sp,32
    80002ce8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cea:	00234517          	auipc	a0,0x234
    80002cee:	11e50513          	addi	a0,a0,286 # 80236e08 <itable>
    80002cf2:	00003097          	auipc	ra,0x3
    80002cf6:	67a080e7          	jalr	1658(ra) # 8000636c <acquire>
  ip->ref++;
    80002cfa:	449c                	lw	a5,8(s1)
    80002cfc:	2785                	addiw	a5,a5,1
    80002cfe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d00:	00234517          	auipc	a0,0x234
    80002d04:	10850513          	addi	a0,a0,264 # 80236e08 <itable>
    80002d08:	00003097          	auipc	ra,0x3
    80002d0c:	718080e7          	jalr	1816(ra) # 80006420 <release>
}
    80002d10:	8526                	mv	a0,s1
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6105                	addi	sp,sp,32
    80002d1a:	8082                	ret

0000000080002d1c <ilock>:
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	e04a                	sd	s2,0(sp)
    80002d26:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d28:	c115                	beqz	a0,80002d4c <ilock+0x30>
    80002d2a:	84aa                	mv	s1,a0
    80002d2c:	451c                	lw	a5,8(a0)
    80002d2e:	00f05f63          	blez	a5,80002d4c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d32:	0541                	addi	a0,a0,16
    80002d34:	00001097          	auipc	ra,0x1
    80002d38:	ca2080e7          	jalr	-862(ra) # 800039d6 <acquiresleep>
  if(ip->valid == 0){
    80002d3c:	40bc                	lw	a5,64(s1)
    80002d3e:	cf99                	beqz	a5,80002d5c <ilock+0x40>
}
    80002d40:	60e2                	ld	ra,24(sp)
    80002d42:	6442                	ld	s0,16(sp)
    80002d44:	64a2                	ld	s1,8(sp)
    80002d46:	6902                	ld	s2,0(sp)
    80002d48:	6105                	addi	sp,sp,32
    80002d4a:	8082                	ret
    panic("ilock");
    80002d4c:	00006517          	auipc	a0,0x6
    80002d50:	80450513          	addi	a0,a0,-2044 # 80008550 <syscalls+0x180>
    80002d54:	00003097          	auipc	ra,0x3
    80002d58:	0ce080e7          	jalr	206(ra) # 80005e22 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d5c:	40dc                	lw	a5,4(s1)
    80002d5e:	0047d79b          	srliw	a5,a5,0x4
    80002d62:	00234597          	auipc	a1,0x234
    80002d66:	09e5a583          	lw	a1,158(a1) # 80236e00 <sb+0x18>
    80002d6a:	9dbd                	addw	a1,a1,a5
    80002d6c:	4088                	lw	a0,0(s1)
    80002d6e:	fffff097          	auipc	ra,0xfffff
    80002d72:	794080e7          	jalr	1940(ra) # 80002502 <bread>
    80002d76:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d78:	05850593          	addi	a1,a0,88
    80002d7c:	40dc                	lw	a5,4(s1)
    80002d7e:	8bbd                	andi	a5,a5,15
    80002d80:	079a                	slli	a5,a5,0x6
    80002d82:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d84:	00059783          	lh	a5,0(a1)
    80002d88:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d8c:	00259783          	lh	a5,2(a1)
    80002d90:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d94:	00459783          	lh	a5,4(a1)
    80002d98:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d9c:	00659783          	lh	a5,6(a1)
    80002da0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002da4:	459c                	lw	a5,8(a1)
    80002da6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002da8:	03400613          	li	a2,52
    80002dac:	05b1                	addi	a1,a1,12
    80002dae:	05048513          	addi	a0,s1,80
    80002db2:	ffffd097          	auipc	ra,0xffffd
    80002db6:	618080e7          	jalr	1560(ra) # 800003ca <memmove>
    brelse(bp);
    80002dba:	854a                	mv	a0,s2
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	876080e7          	jalr	-1930(ra) # 80002632 <brelse>
    ip->valid = 1;
    80002dc4:	4785                	li	a5,1
    80002dc6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dc8:	04449783          	lh	a5,68(s1)
    80002dcc:	fbb5                	bnez	a5,80002d40 <ilock+0x24>
      panic("ilock: no type");
    80002dce:	00005517          	auipc	a0,0x5
    80002dd2:	78a50513          	addi	a0,a0,1930 # 80008558 <syscalls+0x188>
    80002dd6:	00003097          	auipc	ra,0x3
    80002dda:	04c080e7          	jalr	76(ra) # 80005e22 <panic>

0000000080002dde <iunlock>:
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	e04a                	sd	s2,0(sp)
    80002de8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dea:	c905                	beqz	a0,80002e1a <iunlock+0x3c>
    80002dec:	84aa                	mv	s1,a0
    80002dee:	01050913          	addi	s2,a0,16
    80002df2:	854a                	mv	a0,s2
    80002df4:	00001097          	auipc	ra,0x1
    80002df8:	c7c080e7          	jalr	-900(ra) # 80003a70 <holdingsleep>
    80002dfc:	cd19                	beqz	a0,80002e1a <iunlock+0x3c>
    80002dfe:	449c                	lw	a5,8(s1)
    80002e00:	00f05d63          	blez	a5,80002e1a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e04:	854a                	mv	a0,s2
    80002e06:	00001097          	auipc	ra,0x1
    80002e0a:	c26080e7          	jalr	-986(ra) # 80003a2c <releasesleep>
}
    80002e0e:	60e2                	ld	ra,24(sp)
    80002e10:	6442                	ld	s0,16(sp)
    80002e12:	64a2                	ld	s1,8(sp)
    80002e14:	6902                	ld	s2,0(sp)
    80002e16:	6105                	addi	sp,sp,32
    80002e18:	8082                	ret
    panic("iunlock");
    80002e1a:	00005517          	auipc	a0,0x5
    80002e1e:	74e50513          	addi	a0,a0,1870 # 80008568 <syscalls+0x198>
    80002e22:	00003097          	auipc	ra,0x3
    80002e26:	000080e7          	jalr	ra # 80005e22 <panic>

0000000080002e2a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e2a:	7179                	addi	sp,sp,-48
    80002e2c:	f406                	sd	ra,40(sp)
    80002e2e:	f022                	sd	s0,32(sp)
    80002e30:	ec26                	sd	s1,24(sp)
    80002e32:	e84a                	sd	s2,16(sp)
    80002e34:	e44e                	sd	s3,8(sp)
    80002e36:	e052                	sd	s4,0(sp)
    80002e38:	1800                	addi	s0,sp,48
    80002e3a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e3c:	05050493          	addi	s1,a0,80
    80002e40:	08050913          	addi	s2,a0,128
    80002e44:	a021                	j	80002e4c <itrunc+0x22>
    80002e46:	0491                	addi	s1,s1,4
    80002e48:	01248d63          	beq	s1,s2,80002e62 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e4c:	408c                	lw	a1,0(s1)
    80002e4e:	dde5                	beqz	a1,80002e46 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e50:	0009a503          	lw	a0,0(s3)
    80002e54:	00000097          	auipc	ra,0x0
    80002e58:	8f4080e7          	jalr	-1804(ra) # 80002748 <bfree>
      ip->addrs[i] = 0;
    80002e5c:	0004a023          	sw	zero,0(s1)
    80002e60:	b7dd                	j	80002e46 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e62:	0809a583          	lw	a1,128(s3)
    80002e66:	e185                	bnez	a1,80002e86 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e68:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e6c:	854e                	mv	a0,s3
    80002e6e:	00000097          	auipc	ra,0x0
    80002e72:	de4080e7          	jalr	-540(ra) # 80002c52 <iupdate>
}
    80002e76:	70a2                	ld	ra,40(sp)
    80002e78:	7402                	ld	s0,32(sp)
    80002e7a:	64e2                	ld	s1,24(sp)
    80002e7c:	6942                	ld	s2,16(sp)
    80002e7e:	69a2                	ld	s3,8(sp)
    80002e80:	6a02                	ld	s4,0(sp)
    80002e82:	6145                	addi	sp,sp,48
    80002e84:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e86:	0009a503          	lw	a0,0(s3)
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	678080e7          	jalr	1656(ra) # 80002502 <bread>
    80002e92:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e94:	05850493          	addi	s1,a0,88
    80002e98:	45850913          	addi	s2,a0,1112
    80002e9c:	a811                	j	80002eb0 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e9e:	0009a503          	lw	a0,0(s3)
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	8a6080e7          	jalr	-1882(ra) # 80002748 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002eaa:	0491                	addi	s1,s1,4
    80002eac:	01248563          	beq	s1,s2,80002eb6 <itrunc+0x8c>
      if(a[j])
    80002eb0:	408c                	lw	a1,0(s1)
    80002eb2:	dde5                	beqz	a1,80002eaa <itrunc+0x80>
    80002eb4:	b7ed                	j	80002e9e <itrunc+0x74>
    brelse(bp);
    80002eb6:	8552                	mv	a0,s4
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	77a080e7          	jalr	1914(ra) # 80002632 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ec0:	0809a583          	lw	a1,128(s3)
    80002ec4:	0009a503          	lw	a0,0(s3)
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	880080e7          	jalr	-1920(ra) # 80002748 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ed0:	0809a023          	sw	zero,128(s3)
    80002ed4:	bf51                	j	80002e68 <itrunc+0x3e>

0000000080002ed6 <iput>:
{
    80002ed6:	1101                	addi	sp,sp,-32
    80002ed8:	ec06                	sd	ra,24(sp)
    80002eda:	e822                	sd	s0,16(sp)
    80002edc:	e426                	sd	s1,8(sp)
    80002ede:	e04a                	sd	s2,0(sp)
    80002ee0:	1000                	addi	s0,sp,32
    80002ee2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ee4:	00234517          	auipc	a0,0x234
    80002ee8:	f2450513          	addi	a0,a0,-220 # 80236e08 <itable>
    80002eec:	00003097          	auipc	ra,0x3
    80002ef0:	480080e7          	jalr	1152(ra) # 8000636c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ef4:	4498                	lw	a4,8(s1)
    80002ef6:	4785                	li	a5,1
    80002ef8:	02f70363          	beq	a4,a5,80002f1e <iput+0x48>
  ip->ref--;
    80002efc:	449c                	lw	a5,8(s1)
    80002efe:	37fd                	addiw	a5,a5,-1
    80002f00:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f02:	00234517          	auipc	a0,0x234
    80002f06:	f0650513          	addi	a0,a0,-250 # 80236e08 <itable>
    80002f0a:	00003097          	auipc	ra,0x3
    80002f0e:	516080e7          	jalr	1302(ra) # 80006420 <release>
}
    80002f12:	60e2                	ld	ra,24(sp)
    80002f14:	6442                	ld	s0,16(sp)
    80002f16:	64a2                	ld	s1,8(sp)
    80002f18:	6902                	ld	s2,0(sp)
    80002f1a:	6105                	addi	sp,sp,32
    80002f1c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f1e:	40bc                	lw	a5,64(s1)
    80002f20:	dff1                	beqz	a5,80002efc <iput+0x26>
    80002f22:	04a49783          	lh	a5,74(s1)
    80002f26:	fbf9                	bnez	a5,80002efc <iput+0x26>
    acquiresleep(&ip->lock);
    80002f28:	01048913          	addi	s2,s1,16
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	00001097          	auipc	ra,0x1
    80002f32:	aa8080e7          	jalr	-1368(ra) # 800039d6 <acquiresleep>
    release(&itable.lock);
    80002f36:	00234517          	auipc	a0,0x234
    80002f3a:	ed250513          	addi	a0,a0,-302 # 80236e08 <itable>
    80002f3e:	00003097          	auipc	ra,0x3
    80002f42:	4e2080e7          	jalr	1250(ra) # 80006420 <release>
    itrunc(ip);
    80002f46:	8526                	mv	a0,s1
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	ee2080e7          	jalr	-286(ra) # 80002e2a <itrunc>
    ip->type = 0;
    80002f50:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f54:	8526                	mv	a0,s1
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	cfc080e7          	jalr	-772(ra) # 80002c52 <iupdate>
    ip->valid = 0;
    80002f5e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f62:	854a                	mv	a0,s2
    80002f64:	00001097          	auipc	ra,0x1
    80002f68:	ac8080e7          	jalr	-1336(ra) # 80003a2c <releasesleep>
    acquire(&itable.lock);
    80002f6c:	00234517          	auipc	a0,0x234
    80002f70:	e9c50513          	addi	a0,a0,-356 # 80236e08 <itable>
    80002f74:	00003097          	auipc	ra,0x3
    80002f78:	3f8080e7          	jalr	1016(ra) # 8000636c <acquire>
    80002f7c:	b741                	j	80002efc <iput+0x26>

0000000080002f7e <iunlockput>:
{
    80002f7e:	1101                	addi	sp,sp,-32
    80002f80:	ec06                	sd	ra,24(sp)
    80002f82:	e822                	sd	s0,16(sp)
    80002f84:	e426                	sd	s1,8(sp)
    80002f86:	1000                	addi	s0,sp,32
    80002f88:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	e54080e7          	jalr	-428(ra) # 80002dde <iunlock>
  iput(ip);
    80002f92:	8526                	mv	a0,s1
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	f42080e7          	jalr	-190(ra) # 80002ed6 <iput>
}
    80002f9c:	60e2                	ld	ra,24(sp)
    80002f9e:	6442                	ld	s0,16(sp)
    80002fa0:	64a2                	ld	s1,8(sp)
    80002fa2:	6105                	addi	sp,sp,32
    80002fa4:	8082                	ret

0000000080002fa6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fa6:	1141                	addi	sp,sp,-16
    80002fa8:	e422                	sd	s0,8(sp)
    80002faa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fac:	411c                	lw	a5,0(a0)
    80002fae:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fb0:	415c                	lw	a5,4(a0)
    80002fb2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fb4:	04451783          	lh	a5,68(a0)
    80002fb8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fbc:	04a51783          	lh	a5,74(a0)
    80002fc0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fc4:	04c56783          	lwu	a5,76(a0)
    80002fc8:	e99c                	sd	a5,16(a1)
}
    80002fca:	6422                	ld	s0,8(sp)
    80002fcc:	0141                	addi	sp,sp,16
    80002fce:	8082                	ret

0000000080002fd0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fd0:	457c                	lw	a5,76(a0)
    80002fd2:	0ed7e963          	bltu	a5,a3,800030c4 <readi+0xf4>
{
    80002fd6:	7159                	addi	sp,sp,-112
    80002fd8:	f486                	sd	ra,104(sp)
    80002fda:	f0a2                	sd	s0,96(sp)
    80002fdc:	eca6                	sd	s1,88(sp)
    80002fde:	e8ca                	sd	s2,80(sp)
    80002fe0:	e4ce                	sd	s3,72(sp)
    80002fe2:	e0d2                	sd	s4,64(sp)
    80002fe4:	fc56                	sd	s5,56(sp)
    80002fe6:	f85a                	sd	s6,48(sp)
    80002fe8:	f45e                	sd	s7,40(sp)
    80002fea:	f062                	sd	s8,32(sp)
    80002fec:	ec66                	sd	s9,24(sp)
    80002fee:	e86a                	sd	s10,16(sp)
    80002ff0:	e46e                	sd	s11,8(sp)
    80002ff2:	1880                	addi	s0,sp,112
    80002ff4:	8b2a                	mv	s6,a0
    80002ff6:	8bae                	mv	s7,a1
    80002ff8:	8a32                	mv	s4,a2
    80002ffa:	84b6                	mv	s1,a3
    80002ffc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ffe:	9f35                	addw	a4,a4,a3
    return 0;
    80003000:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003002:	0ad76063          	bltu	a4,a3,800030a2 <readi+0xd2>
  if(off + n > ip->size)
    80003006:	00e7f463          	bgeu	a5,a4,8000300e <readi+0x3e>
    n = ip->size - off;
    8000300a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000300e:	0a0a8963          	beqz	s5,800030c0 <readi+0xf0>
    80003012:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003014:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003018:	5c7d                	li	s8,-1
    8000301a:	a82d                	j	80003054 <readi+0x84>
    8000301c:	020d1d93          	slli	s11,s10,0x20
    80003020:	020ddd93          	srli	s11,s11,0x20
    80003024:	05890613          	addi	a2,s2,88
    80003028:	86ee                	mv	a3,s11
    8000302a:	963a                	add	a2,a2,a4
    8000302c:	85d2                	mv	a1,s4
    8000302e:	855e                	mv	a0,s7
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	ac8080e7          	jalr	-1336(ra) # 80001af8 <either_copyout>
    80003038:	05850d63          	beq	a0,s8,80003092 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000303c:	854a                	mv	a0,s2
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	5f4080e7          	jalr	1524(ra) # 80002632 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003046:	013d09bb          	addw	s3,s10,s3
    8000304a:	009d04bb          	addw	s1,s10,s1
    8000304e:	9a6e                	add	s4,s4,s11
    80003050:	0559f763          	bgeu	s3,s5,8000309e <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003054:	00a4d59b          	srliw	a1,s1,0xa
    80003058:	855a                	mv	a0,s6
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	8a2080e7          	jalr	-1886(ra) # 800028fc <bmap>
    80003062:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003066:	cd85                	beqz	a1,8000309e <readi+0xce>
    bp = bread(ip->dev, addr);
    80003068:	000b2503          	lw	a0,0(s6)
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	496080e7          	jalr	1174(ra) # 80002502 <bread>
    80003074:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003076:	3ff4f713          	andi	a4,s1,1023
    8000307a:	40ec87bb          	subw	a5,s9,a4
    8000307e:	413a86bb          	subw	a3,s5,s3
    80003082:	8d3e                	mv	s10,a5
    80003084:	2781                	sext.w	a5,a5
    80003086:	0006861b          	sext.w	a2,a3
    8000308a:	f8f679e3          	bgeu	a2,a5,8000301c <readi+0x4c>
    8000308e:	8d36                	mv	s10,a3
    80003090:	b771                	j	8000301c <readi+0x4c>
      brelse(bp);
    80003092:	854a                	mv	a0,s2
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	59e080e7          	jalr	1438(ra) # 80002632 <brelse>
      tot = -1;
    8000309c:	59fd                	li	s3,-1
  }
  return tot;
    8000309e:	0009851b          	sext.w	a0,s3
}
    800030a2:	70a6                	ld	ra,104(sp)
    800030a4:	7406                	ld	s0,96(sp)
    800030a6:	64e6                	ld	s1,88(sp)
    800030a8:	6946                	ld	s2,80(sp)
    800030aa:	69a6                	ld	s3,72(sp)
    800030ac:	6a06                	ld	s4,64(sp)
    800030ae:	7ae2                	ld	s5,56(sp)
    800030b0:	7b42                	ld	s6,48(sp)
    800030b2:	7ba2                	ld	s7,40(sp)
    800030b4:	7c02                	ld	s8,32(sp)
    800030b6:	6ce2                	ld	s9,24(sp)
    800030b8:	6d42                	ld	s10,16(sp)
    800030ba:	6da2                	ld	s11,8(sp)
    800030bc:	6165                	addi	sp,sp,112
    800030be:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030c0:	89d6                	mv	s3,s5
    800030c2:	bff1                	j	8000309e <readi+0xce>
    return 0;
    800030c4:	4501                	li	a0,0
}
    800030c6:	8082                	ret

00000000800030c8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030c8:	457c                	lw	a5,76(a0)
    800030ca:	10d7e863          	bltu	a5,a3,800031da <writei+0x112>
{
    800030ce:	7159                	addi	sp,sp,-112
    800030d0:	f486                	sd	ra,104(sp)
    800030d2:	f0a2                	sd	s0,96(sp)
    800030d4:	eca6                	sd	s1,88(sp)
    800030d6:	e8ca                	sd	s2,80(sp)
    800030d8:	e4ce                	sd	s3,72(sp)
    800030da:	e0d2                	sd	s4,64(sp)
    800030dc:	fc56                	sd	s5,56(sp)
    800030de:	f85a                	sd	s6,48(sp)
    800030e0:	f45e                	sd	s7,40(sp)
    800030e2:	f062                	sd	s8,32(sp)
    800030e4:	ec66                	sd	s9,24(sp)
    800030e6:	e86a                	sd	s10,16(sp)
    800030e8:	e46e                	sd	s11,8(sp)
    800030ea:	1880                	addi	s0,sp,112
    800030ec:	8aaa                	mv	s5,a0
    800030ee:	8bae                	mv	s7,a1
    800030f0:	8a32                	mv	s4,a2
    800030f2:	8936                	mv	s2,a3
    800030f4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030f6:	00e687bb          	addw	a5,a3,a4
    800030fa:	0ed7e263          	bltu	a5,a3,800031de <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030fe:	00043737          	lui	a4,0x43
    80003102:	0ef76063          	bltu	a4,a5,800031e2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003106:	0c0b0863          	beqz	s6,800031d6 <writei+0x10e>
    8000310a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000310c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003110:	5c7d                	li	s8,-1
    80003112:	a091                	j	80003156 <writei+0x8e>
    80003114:	020d1d93          	slli	s11,s10,0x20
    80003118:	020ddd93          	srli	s11,s11,0x20
    8000311c:	05848513          	addi	a0,s1,88
    80003120:	86ee                	mv	a3,s11
    80003122:	8652                	mv	a2,s4
    80003124:	85de                	mv	a1,s7
    80003126:	953a                	add	a0,a0,a4
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	a26080e7          	jalr	-1498(ra) # 80001b4e <either_copyin>
    80003130:	07850263          	beq	a0,s8,80003194 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003134:	8526                	mv	a0,s1
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	780080e7          	jalr	1920(ra) # 800038b6 <log_write>
    brelse(bp);
    8000313e:	8526                	mv	a0,s1
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	4f2080e7          	jalr	1266(ra) # 80002632 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003148:	013d09bb          	addw	s3,s10,s3
    8000314c:	012d093b          	addw	s2,s10,s2
    80003150:	9a6e                	add	s4,s4,s11
    80003152:	0569f663          	bgeu	s3,s6,8000319e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003156:	00a9559b          	srliw	a1,s2,0xa
    8000315a:	8556                	mv	a0,s5
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	7a0080e7          	jalr	1952(ra) # 800028fc <bmap>
    80003164:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003168:	c99d                	beqz	a1,8000319e <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000316a:	000aa503          	lw	a0,0(s5)
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	394080e7          	jalr	916(ra) # 80002502 <bread>
    80003176:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003178:	3ff97713          	andi	a4,s2,1023
    8000317c:	40ec87bb          	subw	a5,s9,a4
    80003180:	413b06bb          	subw	a3,s6,s3
    80003184:	8d3e                	mv	s10,a5
    80003186:	2781                	sext.w	a5,a5
    80003188:	0006861b          	sext.w	a2,a3
    8000318c:	f8f674e3          	bgeu	a2,a5,80003114 <writei+0x4c>
    80003190:	8d36                	mv	s10,a3
    80003192:	b749                	j	80003114 <writei+0x4c>
      brelse(bp);
    80003194:	8526                	mv	a0,s1
    80003196:	fffff097          	auipc	ra,0xfffff
    8000319a:	49c080e7          	jalr	1180(ra) # 80002632 <brelse>
  }

  if(off > ip->size)
    8000319e:	04caa783          	lw	a5,76(s5)
    800031a2:	0127f463          	bgeu	a5,s2,800031aa <writei+0xe2>
    ip->size = off;
    800031a6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031aa:	8556                	mv	a0,s5
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	aa6080e7          	jalr	-1370(ra) # 80002c52 <iupdate>

  return tot;
    800031b4:	0009851b          	sext.w	a0,s3
}
    800031b8:	70a6                	ld	ra,104(sp)
    800031ba:	7406                	ld	s0,96(sp)
    800031bc:	64e6                	ld	s1,88(sp)
    800031be:	6946                	ld	s2,80(sp)
    800031c0:	69a6                	ld	s3,72(sp)
    800031c2:	6a06                	ld	s4,64(sp)
    800031c4:	7ae2                	ld	s5,56(sp)
    800031c6:	7b42                	ld	s6,48(sp)
    800031c8:	7ba2                	ld	s7,40(sp)
    800031ca:	7c02                	ld	s8,32(sp)
    800031cc:	6ce2                	ld	s9,24(sp)
    800031ce:	6d42                	ld	s10,16(sp)
    800031d0:	6da2                	ld	s11,8(sp)
    800031d2:	6165                	addi	sp,sp,112
    800031d4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d6:	89da                	mv	s3,s6
    800031d8:	bfc9                	j	800031aa <writei+0xe2>
    return -1;
    800031da:	557d                	li	a0,-1
}
    800031dc:	8082                	ret
    return -1;
    800031de:	557d                	li	a0,-1
    800031e0:	bfe1                	j	800031b8 <writei+0xf0>
    return -1;
    800031e2:	557d                	li	a0,-1
    800031e4:	bfd1                	j	800031b8 <writei+0xf0>

00000000800031e6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031e6:	1141                	addi	sp,sp,-16
    800031e8:	e406                	sd	ra,8(sp)
    800031ea:	e022                	sd	s0,0(sp)
    800031ec:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031ee:	4639                	li	a2,14
    800031f0:	ffffd097          	auipc	ra,0xffffd
    800031f4:	252080e7          	jalr	594(ra) # 80000442 <strncmp>
}
    800031f8:	60a2                	ld	ra,8(sp)
    800031fa:	6402                	ld	s0,0(sp)
    800031fc:	0141                	addi	sp,sp,16
    800031fe:	8082                	ret

0000000080003200 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003200:	7139                	addi	sp,sp,-64
    80003202:	fc06                	sd	ra,56(sp)
    80003204:	f822                	sd	s0,48(sp)
    80003206:	f426                	sd	s1,40(sp)
    80003208:	f04a                	sd	s2,32(sp)
    8000320a:	ec4e                	sd	s3,24(sp)
    8000320c:	e852                	sd	s4,16(sp)
    8000320e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003210:	04451703          	lh	a4,68(a0)
    80003214:	4785                	li	a5,1
    80003216:	00f71a63          	bne	a4,a5,8000322a <dirlookup+0x2a>
    8000321a:	892a                	mv	s2,a0
    8000321c:	89ae                	mv	s3,a1
    8000321e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003220:	457c                	lw	a5,76(a0)
    80003222:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003224:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003226:	e79d                	bnez	a5,80003254 <dirlookup+0x54>
    80003228:	a8a5                	j	800032a0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000322a:	00005517          	auipc	a0,0x5
    8000322e:	34650513          	addi	a0,a0,838 # 80008570 <syscalls+0x1a0>
    80003232:	00003097          	auipc	ra,0x3
    80003236:	bf0080e7          	jalr	-1040(ra) # 80005e22 <panic>
      panic("dirlookup read");
    8000323a:	00005517          	auipc	a0,0x5
    8000323e:	34e50513          	addi	a0,a0,846 # 80008588 <syscalls+0x1b8>
    80003242:	00003097          	auipc	ra,0x3
    80003246:	be0080e7          	jalr	-1056(ra) # 80005e22 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000324a:	24c1                	addiw	s1,s1,16
    8000324c:	04c92783          	lw	a5,76(s2)
    80003250:	04f4f763          	bgeu	s1,a5,8000329e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003254:	4741                	li	a4,16
    80003256:	86a6                	mv	a3,s1
    80003258:	fc040613          	addi	a2,s0,-64
    8000325c:	4581                	li	a1,0
    8000325e:	854a                	mv	a0,s2
    80003260:	00000097          	auipc	ra,0x0
    80003264:	d70080e7          	jalr	-656(ra) # 80002fd0 <readi>
    80003268:	47c1                	li	a5,16
    8000326a:	fcf518e3          	bne	a0,a5,8000323a <dirlookup+0x3a>
    if(de.inum == 0)
    8000326e:	fc045783          	lhu	a5,-64(s0)
    80003272:	dfe1                	beqz	a5,8000324a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003274:	fc240593          	addi	a1,s0,-62
    80003278:	854e                	mv	a0,s3
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	f6c080e7          	jalr	-148(ra) # 800031e6 <namecmp>
    80003282:	f561                	bnez	a0,8000324a <dirlookup+0x4a>
      if(poff)
    80003284:	000a0463          	beqz	s4,8000328c <dirlookup+0x8c>
        *poff = off;
    80003288:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000328c:	fc045583          	lhu	a1,-64(s0)
    80003290:	00092503          	lw	a0,0(s2)
    80003294:	fffff097          	auipc	ra,0xfffff
    80003298:	750080e7          	jalr	1872(ra) # 800029e4 <iget>
    8000329c:	a011                	j	800032a0 <dirlookup+0xa0>
  return 0;
    8000329e:	4501                	li	a0,0
}
    800032a0:	70e2                	ld	ra,56(sp)
    800032a2:	7442                	ld	s0,48(sp)
    800032a4:	74a2                	ld	s1,40(sp)
    800032a6:	7902                	ld	s2,32(sp)
    800032a8:	69e2                	ld	s3,24(sp)
    800032aa:	6a42                	ld	s4,16(sp)
    800032ac:	6121                	addi	sp,sp,64
    800032ae:	8082                	ret

00000000800032b0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032b0:	711d                	addi	sp,sp,-96
    800032b2:	ec86                	sd	ra,88(sp)
    800032b4:	e8a2                	sd	s0,80(sp)
    800032b6:	e4a6                	sd	s1,72(sp)
    800032b8:	e0ca                	sd	s2,64(sp)
    800032ba:	fc4e                	sd	s3,56(sp)
    800032bc:	f852                	sd	s4,48(sp)
    800032be:	f456                	sd	s5,40(sp)
    800032c0:	f05a                	sd	s6,32(sp)
    800032c2:	ec5e                	sd	s7,24(sp)
    800032c4:	e862                	sd	s8,16(sp)
    800032c6:	e466                	sd	s9,8(sp)
    800032c8:	1080                	addi	s0,sp,96
    800032ca:	84aa                	mv	s1,a0
    800032cc:	8b2e                	mv	s6,a1
    800032ce:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032d0:	00054703          	lbu	a4,0(a0)
    800032d4:	02f00793          	li	a5,47
    800032d8:	02f70363          	beq	a4,a5,800032fe <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	d70080e7          	jalr	-656(ra) # 8000104c <myproc>
    800032e4:	15053503          	ld	a0,336(a0)
    800032e8:	00000097          	auipc	ra,0x0
    800032ec:	9f6080e7          	jalr	-1546(ra) # 80002cde <idup>
    800032f0:	89aa                	mv	s3,a0
  while(*path == '/')
    800032f2:	02f00913          	li	s2,47
  len = path - s;
    800032f6:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032f8:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032fa:	4c05                	li	s8,1
    800032fc:	a865                	j	800033b4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032fe:	4585                	li	a1,1
    80003300:	4505                	li	a0,1
    80003302:	fffff097          	auipc	ra,0xfffff
    80003306:	6e2080e7          	jalr	1762(ra) # 800029e4 <iget>
    8000330a:	89aa                	mv	s3,a0
    8000330c:	b7dd                	j	800032f2 <namex+0x42>
      iunlockput(ip);
    8000330e:	854e                	mv	a0,s3
    80003310:	00000097          	auipc	ra,0x0
    80003314:	c6e080e7          	jalr	-914(ra) # 80002f7e <iunlockput>
      return 0;
    80003318:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000331a:	854e                	mv	a0,s3
    8000331c:	60e6                	ld	ra,88(sp)
    8000331e:	6446                	ld	s0,80(sp)
    80003320:	64a6                	ld	s1,72(sp)
    80003322:	6906                	ld	s2,64(sp)
    80003324:	79e2                	ld	s3,56(sp)
    80003326:	7a42                	ld	s4,48(sp)
    80003328:	7aa2                	ld	s5,40(sp)
    8000332a:	7b02                	ld	s6,32(sp)
    8000332c:	6be2                	ld	s7,24(sp)
    8000332e:	6c42                	ld	s8,16(sp)
    80003330:	6ca2                	ld	s9,8(sp)
    80003332:	6125                	addi	sp,sp,96
    80003334:	8082                	ret
      iunlock(ip);
    80003336:	854e                	mv	a0,s3
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	aa6080e7          	jalr	-1370(ra) # 80002dde <iunlock>
      return ip;
    80003340:	bfe9                	j	8000331a <namex+0x6a>
      iunlockput(ip);
    80003342:	854e                	mv	a0,s3
    80003344:	00000097          	auipc	ra,0x0
    80003348:	c3a080e7          	jalr	-966(ra) # 80002f7e <iunlockput>
      return 0;
    8000334c:	89d2                	mv	s3,s4
    8000334e:	b7f1                	j	8000331a <namex+0x6a>
  len = path - s;
    80003350:	40b48633          	sub	a2,s1,a1
    80003354:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003358:	094cd463          	bge	s9,s4,800033e0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000335c:	4639                	li	a2,14
    8000335e:	8556                	mv	a0,s5
    80003360:	ffffd097          	auipc	ra,0xffffd
    80003364:	06a080e7          	jalr	106(ra) # 800003ca <memmove>
  while(*path == '/')
    80003368:	0004c783          	lbu	a5,0(s1)
    8000336c:	01279763          	bne	a5,s2,8000337a <namex+0xca>
    path++;
    80003370:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003372:	0004c783          	lbu	a5,0(s1)
    80003376:	ff278de3          	beq	a5,s2,80003370 <namex+0xc0>
    ilock(ip);
    8000337a:	854e                	mv	a0,s3
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	9a0080e7          	jalr	-1632(ra) # 80002d1c <ilock>
    if(ip->type != T_DIR){
    80003384:	04499783          	lh	a5,68(s3)
    80003388:	f98793e3          	bne	a5,s8,8000330e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000338c:	000b0563          	beqz	s6,80003396 <namex+0xe6>
    80003390:	0004c783          	lbu	a5,0(s1)
    80003394:	d3cd                	beqz	a5,80003336 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003396:	865e                	mv	a2,s7
    80003398:	85d6                	mv	a1,s5
    8000339a:	854e                	mv	a0,s3
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	e64080e7          	jalr	-412(ra) # 80003200 <dirlookup>
    800033a4:	8a2a                	mv	s4,a0
    800033a6:	dd51                	beqz	a0,80003342 <namex+0x92>
    iunlockput(ip);
    800033a8:	854e                	mv	a0,s3
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	bd4080e7          	jalr	-1068(ra) # 80002f7e <iunlockput>
    ip = next;
    800033b2:	89d2                	mv	s3,s4
  while(*path == '/')
    800033b4:	0004c783          	lbu	a5,0(s1)
    800033b8:	05279763          	bne	a5,s2,80003406 <namex+0x156>
    path++;
    800033bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033be:	0004c783          	lbu	a5,0(s1)
    800033c2:	ff278de3          	beq	a5,s2,800033bc <namex+0x10c>
  if(*path == 0)
    800033c6:	c79d                	beqz	a5,800033f4 <namex+0x144>
    path++;
    800033c8:	85a6                	mv	a1,s1
  len = path - s;
    800033ca:	8a5e                	mv	s4,s7
    800033cc:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ce:	01278963          	beq	a5,s2,800033e0 <namex+0x130>
    800033d2:	dfbd                	beqz	a5,80003350 <namex+0xa0>
    path++;
    800033d4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033d6:	0004c783          	lbu	a5,0(s1)
    800033da:	ff279ce3          	bne	a5,s2,800033d2 <namex+0x122>
    800033de:	bf8d                	j	80003350 <namex+0xa0>
    memmove(name, s, len);
    800033e0:	2601                	sext.w	a2,a2
    800033e2:	8556                	mv	a0,s5
    800033e4:	ffffd097          	auipc	ra,0xffffd
    800033e8:	fe6080e7          	jalr	-26(ra) # 800003ca <memmove>
    name[len] = 0;
    800033ec:	9a56                	add	s4,s4,s5
    800033ee:	000a0023          	sb	zero,0(s4)
    800033f2:	bf9d                	j	80003368 <namex+0xb8>
  if(nameiparent){
    800033f4:	f20b03e3          	beqz	s6,8000331a <namex+0x6a>
    iput(ip);
    800033f8:	854e                	mv	a0,s3
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	adc080e7          	jalr	-1316(ra) # 80002ed6 <iput>
    return 0;
    80003402:	4981                	li	s3,0
    80003404:	bf19                	j	8000331a <namex+0x6a>
  if(*path == 0)
    80003406:	d7fd                	beqz	a5,800033f4 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003408:	0004c783          	lbu	a5,0(s1)
    8000340c:	85a6                	mv	a1,s1
    8000340e:	b7d1                	j	800033d2 <namex+0x122>

0000000080003410 <dirlink>:
{
    80003410:	7139                	addi	sp,sp,-64
    80003412:	fc06                	sd	ra,56(sp)
    80003414:	f822                	sd	s0,48(sp)
    80003416:	f426                	sd	s1,40(sp)
    80003418:	f04a                	sd	s2,32(sp)
    8000341a:	ec4e                	sd	s3,24(sp)
    8000341c:	e852                	sd	s4,16(sp)
    8000341e:	0080                	addi	s0,sp,64
    80003420:	892a                	mv	s2,a0
    80003422:	8a2e                	mv	s4,a1
    80003424:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003426:	4601                	li	a2,0
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	dd8080e7          	jalr	-552(ra) # 80003200 <dirlookup>
    80003430:	e93d                	bnez	a0,800034a6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003432:	04c92483          	lw	s1,76(s2)
    80003436:	c49d                	beqz	s1,80003464 <dirlink+0x54>
    80003438:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000343a:	4741                	li	a4,16
    8000343c:	86a6                	mv	a3,s1
    8000343e:	fc040613          	addi	a2,s0,-64
    80003442:	4581                	li	a1,0
    80003444:	854a                	mv	a0,s2
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	b8a080e7          	jalr	-1142(ra) # 80002fd0 <readi>
    8000344e:	47c1                	li	a5,16
    80003450:	06f51163          	bne	a0,a5,800034b2 <dirlink+0xa2>
    if(de.inum == 0)
    80003454:	fc045783          	lhu	a5,-64(s0)
    80003458:	c791                	beqz	a5,80003464 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000345a:	24c1                	addiw	s1,s1,16
    8000345c:	04c92783          	lw	a5,76(s2)
    80003460:	fcf4ede3          	bltu	s1,a5,8000343a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003464:	4639                	li	a2,14
    80003466:	85d2                	mv	a1,s4
    80003468:	fc240513          	addi	a0,s0,-62
    8000346c:	ffffd097          	auipc	ra,0xffffd
    80003470:	012080e7          	jalr	18(ra) # 8000047e <strncpy>
  de.inum = inum;
    80003474:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003478:	4741                	li	a4,16
    8000347a:	86a6                	mv	a3,s1
    8000347c:	fc040613          	addi	a2,s0,-64
    80003480:	4581                	li	a1,0
    80003482:	854a                	mv	a0,s2
    80003484:	00000097          	auipc	ra,0x0
    80003488:	c44080e7          	jalr	-956(ra) # 800030c8 <writei>
    8000348c:	1541                	addi	a0,a0,-16
    8000348e:	00a03533          	snez	a0,a0
    80003492:	40a00533          	neg	a0,a0
}
    80003496:	70e2                	ld	ra,56(sp)
    80003498:	7442                	ld	s0,48(sp)
    8000349a:	74a2                	ld	s1,40(sp)
    8000349c:	7902                	ld	s2,32(sp)
    8000349e:	69e2                	ld	s3,24(sp)
    800034a0:	6a42                	ld	s4,16(sp)
    800034a2:	6121                	addi	sp,sp,64
    800034a4:	8082                	ret
    iput(ip);
    800034a6:	00000097          	auipc	ra,0x0
    800034aa:	a30080e7          	jalr	-1488(ra) # 80002ed6 <iput>
    return -1;
    800034ae:	557d                	li	a0,-1
    800034b0:	b7dd                	j	80003496 <dirlink+0x86>
      panic("dirlink read");
    800034b2:	00005517          	auipc	a0,0x5
    800034b6:	0e650513          	addi	a0,a0,230 # 80008598 <syscalls+0x1c8>
    800034ba:	00003097          	auipc	ra,0x3
    800034be:	968080e7          	jalr	-1688(ra) # 80005e22 <panic>

00000000800034c2 <namei>:

struct inode*
namei(char *path)
{
    800034c2:	1101                	addi	sp,sp,-32
    800034c4:	ec06                	sd	ra,24(sp)
    800034c6:	e822                	sd	s0,16(sp)
    800034c8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034ca:	fe040613          	addi	a2,s0,-32
    800034ce:	4581                	li	a1,0
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	de0080e7          	jalr	-544(ra) # 800032b0 <namex>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	6105                	addi	sp,sp,32
    800034de:	8082                	ret

00000000800034e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e0:	1141                	addi	sp,sp,-16
    800034e2:	e406                	sd	ra,8(sp)
    800034e4:	e022                	sd	s0,0(sp)
    800034e6:	0800                	addi	s0,sp,16
    800034e8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034ea:	4585                	li	a1,1
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	dc4080e7          	jalr	-572(ra) # 800032b0 <namex>
}
    800034f4:	60a2                	ld	ra,8(sp)
    800034f6:	6402                	ld	s0,0(sp)
    800034f8:	0141                	addi	sp,sp,16
    800034fa:	8082                	ret

00000000800034fc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	e426                	sd	s1,8(sp)
    80003504:	e04a                	sd	s2,0(sp)
    80003506:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003508:	00235917          	auipc	s2,0x235
    8000350c:	3a890913          	addi	s2,s2,936 # 802388b0 <log>
    80003510:	01892583          	lw	a1,24(s2)
    80003514:	02892503          	lw	a0,40(s2)
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	fea080e7          	jalr	-22(ra) # 80002502 <bread>
    80003520:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003522:	02c92683          	lw	a3,44(s2)
    80003526:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003528:	02d05763          	blez	a3,80003556 <write_head+0x5a>
    8000352c:	00235797          	auipc	a5,0x235
    80003530:	3b478793          	addi	a5,a5,948 # 802388e0 <log+0x30>
    80003534:	05c50713          	addi	a4,a0,92
    80003538:	36fd                	addiw	a3,a3,-1
    8000353a:	1682                	slli	a3,a3,0x20
    8000353c:	9281                	srli	a3,a3,0x20
    8000353e:	068a                	slli	a3,a3,0x2
    80003540:	00235617          	auipc	a2,0x235
    80003544:	3a460613          	addi	a2,a2,932 # 802388e4 <log+0x34>
    80003548:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000354a:	4390                	lw	a2,0(a5)
    8000354c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000354e:	0791                	addi	a5,a5,4
    80003550:	0711                	addi	a4,a4,4
    80003552:	fed79ce3          	bne	a5,a3,8000354a <write_head+0x4e>
  }
  bwrite(buf);
    80003556:	8526                	mv	a0,s1
    80003558:	fffff097          	auipc	ra,0xfffff
    8000355c:	09c080e7          	jalr	156(ra) # 800025f4 <bwrite>
  brelse(buf);
    80003560:	8526                	mv	a0,s1
    80003562:	fffff097          	auipc	ra,0xfffff
    80003566:	0d0080e7          	jalr	208(ra) # 80002632 <brelse>
}
    8000356a:	60e2                	ld	ra,24(sp)
    8000356c:	6442                	ld	s0,16(sp)
    8000356e:	64a2                	ld	s1,8(sp)
    80003570:	6902                	ld	s2,0(sp)
    80003572:	6105                	addi	sp,sp,32
    80003574:	8082                	ret

0000000080003576 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003576:	00235797          	auipc	a5,0x235
    8000357a:	3667a783          	lw	a5,870(a5) # 802388dc <log+0x2c>
    8000357e:	0af05d63          	blez	a5,80003638 <install_trans+0xc2>
{
    80003582:	7139                	addi	sp,sp,-64
    80003584:	fc06                	sd	ra,56(sp)
    80003586:	f822                	sd	s0,48(sp)
    80003588:	f426                	sd	s1,40(sp)
    8000358a:	f04a                	sd	s2,32(sp)
    8000358c:	ec4e                	sd	s3,24(sp)
    8000358e:	e852                	sd	s4,16(sp)
    80003590:	e456                	sd	s5,8(sp)
    80003592:	e05a                	sd	s6,0(sp)
    80003594:	0080                	addi	s0,sp,64
    80003596:	8b2a                	mv	s6,a0
    80003598:	00235a97          	auipc	s5,0x235
    8000359c:	348a8a93          	addi	s5,s5,840 # 802388e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a2:	00235997          	auipc	s3,0x235
    800035a6:	30e98993          	addi	s3,s3,782 # 802388b0 <log>
    800035aa:	a035                	j	800035d6 <install_trans+0x60>
      bunpin(dbuf);
    800035ac:	8526                	mv	a0,s1
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	15e080e7          	jalr	350(ra) # 8000270c <bunpin>
    brelse(lbuf);
    800035b6:	854a                	mv	a0,s2
    800035b8:	fffff097          	auipc	ra,0xfffff
    800035bc:	07a080e7          	jalr	122(ra) # 80002632 <brelse>
    brelse(dbuf);
    800035c0:	8526                	mv	a0,s1
    800035c2:	fffff097          	auipc	ra,0xfffff
    800035c6:	070080e7          	jalr	112(ra) # 80002632 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ca:	2a05                	addiw	s4,s4,1
    800035cc:	0a91                	addi	s5,s5,4
    800035ce:	02c9a783          	lw	a5,44(s3)
    800035d2:	04fa5963          	bge	s4,a5,80003624 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d6:	0189a583          	lw	a1,24(s3)
    800035da:	014585bb          	addw	a1,a1,s4
    800035de:	2585                	addiw	a1,a1,1
    800035e0:	0289a503          	lw	a0,40(s3)
    800035e4:	fffff097          	auipc	ra,0xfffff
    800035e8:	f1e080e7          	jalr	-226(ra) # 80002502 <bread>
    800035ec:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035ee:	000aa583          	lw	a1,0(s5)
    800035f2:	0289a503          	lw	a0,40(s3)
    800035f6:	fffff097          	auipc	ra,0xfffff
    800035fa:	f0c080e7          	jalr	-244(ra) # 80002502 <bread>
    800035fe:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003600:	40000613          	li	a2,1024
    80003604:	05890593          	addi	a1,s2,88
    80003608:	05850513          	addi	a0,a0,88
    8000360c:	ffffd097          	auipc	ra,0xffffd
    80003610:	dbe080e7          	jalr	-578(ra) # 800003ca <memmove>
    bwrite(dbuf);  // write dst to disk
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	fde080e7          	jalr	-34(ra) # 800025f4 <bwrite>
    if(recovering == 0)
    8000361e:	f80b1ce3          	bnez	s6,800035b6 <install_trans+0x40>
    80003622:	b769                	j	800035ac <install_trans+0x36>
}
    80003624:	70e2                	ld	ra,56(sp)
    80003626:	7442                	ld	s0,48(sp)
    80003628:	74a2                	ld	s1,40(sp)
    8000362a:	7902                	ld	s2,32(sp)
    8000362c:	69e2                	ld	s3,24(sp)
    8000362e:	6a42                	ld	s4,16(sp)
    80003630:	6aa2                	ld	s5,8(sp)
    80003632:	6b02                	ld	s6,0(sp)
    80003634:	6121                	addi	sp,sp,64
    80003636:	8082                	ret
    80003638:	8082                	ret

000000008000363a <initlog>:
{
    8000363a:	7179                	addi	sp,sp,-48
    8000363c:	f406                	sd	ra,40(sp)
    8000363e:	f022                	sd	s0,32(sp)
    80003640:	ec26                	sd	s1,24(sp)
    80003642:	e84a                	sd	s2,16(sp)
    80003644:	e44e                	sd	s3,8(sp)
    80003646:	1800                	addi	s0,sp,48
    80003648:	892a                	mv	s2,a0
    8000364a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000364c:	00235497          	auipc	s1,0x235
    80003650:	26448493          	addi	s1,s1,612 # 802388b0 <log>
    80003654:	00005597          	auipc	a1,0x5
    80003658:	f5458593          	addi	a1,a1,-172 # 800085a8 <syscalls+0x1d8>
    8000365c:	8526                	mv	a0,s1
    8000365e:	00003097          	auipc	ra,0x3
    80003662:	c7e080e7          	jalr	-898(ra) # 800062dc <initlock>
  log.start = sb->logstart;
    80003666:	0149a583          	lw	a1,20(s3)
    8000366a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000366c:	0109a783          	lw	a5,16(s3)
    80003670:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003672:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003676:	854a                	mv	a0,s2
    80003678:	fffff097          	auipc	ra,0xfffff
    8000367c:	e8a080e7          	jalr	-374(ra) # 80002502 <bread>
  log.lh.n = lh->n;
    80003680:	4d3c                	lw	a5,88(a0)
    80003682:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003684:	02f05563          	blez	a5,800036ae <initlog+0x74>
    80003688:	05c50713          	addi	a4,a0,92
    8000368c:	00235697          	auipc	a3,0x235
    80003690:	25468693          	addi	a3,a3,596 # 802388e0 <log+0x30>
    80003694:	37fd                	addiw	a5,a5,-1
    80003696:	1782                	slli	a5,a5,0x20
    80003698:	9381                	srli	a5,a5,0x20
    8000369a:	078a                	slli	a5,a5,0x2
    8000369c:	06050613          	addi	a2,a0,96
    800036a0:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036a2:	4310                	lw	a2,0(a4)
    800036a4:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036a6:	0711                	addi	a4,a4,4
    800036a8:	0691                	addi	a3,a3,4
    800036aa:	fef71ce3          	bne	a4,a5,800036a2 <initlog+0x68>
  brelse(buf);
    800036ae:	fffff097          	auipc	ra,0xfffff
    800036b2:	f84080e7          	jalr	-124(ra) # 80002632 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036b6:	4505                	li	a0,1
    800036b8:	00000097          	auipc	ra,0x0
    800036bc:	ebe080e7          	jalr	-322(ra) # 80003576 <install_trans>
  log.lh.n = 0;
    800036c0:	00235797          	auipc	a5,0x235
    800036c4:	2007ae23          	sw	zero,540(a5) # 802388dc <log+0x2c>
  write_head(); // clear the log
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	e34080e7          	jalr	-460(ra) # 800034fc <write_head>
}
    800036d0:	70a2                	ld	ra,40(sp)
    800036d2:	7402                	ld	s0,32(sp)
    800036d4:	64e2                	ld	s1,24(sp)
    800036d6:	6942                	ld	s2,16(sp)
    800036d8:	69a2                	ld	s3,8(sp)
    800036da:	6145                	addi	sp,sp,48
    800036dc:	8082                	ret

00000000800036de <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036de:	1101                	addi	sp,sp,-32
    800036e0:	ec06                	sd	ra,24(sp)
    800036e2:	e822                	sd	s0,16(sp)
    800036e4:	e426                	sd	s1,8(sp)
    800036e6:	e04a                	sd	s2,0(sp)
    800036e8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036ea:	00235517          	auipc	a0,0x235
    800036ee:	1c650513          	addi	a0,a0,454 # 802388b0 <log>
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	c7a080e7          	jalr	-902(ra) # 8000636c <acquire>
  while(1){
    if(log.committing){
    800036fa:	00235497          	auipc	s1,0x235
    800036fe:	1b648493          	addi	s1,s1,438 # 802388b0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003702:	4979                	li	s2,30
    80003704:	a039                	j	80003712 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003706:	85a6                	mv	a1,s1
    80003708:	8526                	mv	a0,s1
    8000370a:	ffffe097          	auipc	ra,0xffffe
    8000370e:	fe6080e7          	jalr	-26(ra) # 800016f0 <sleep>
    if(log.committing){
    80003712:	50dc                	lw	a5,36(s1)
    80003714:	fbed                	bnez	a5,80003706 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003716:	509c                	lw	a5,32(s1)
    80003718:	0017871b          	addiw	a4,a5,1
    8000371c:	0007069b          	sext.w	a3,a4
    80003720:	0027179b          	slliw	a5,a4,0x2
    80003724:	9fb9                	addw	a5,a5,a4
    80003726:	0017979b          	slliw	a5,a5,0x1
    8000372a:	54d8                	lw	a4,44(s1)
    8000372c:	9fb9                	addw	a5,a5,a4
    8000372e:	00f95963          	bge	s2,a5,80003740 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003732:	85a6                	mv	a1,s1
    80003734:	8526                	mv	a0,s1
    80003736:	ffffe097          	auipc	ra,0xffffe
    8000373a:	fba080e7          	jalr	-70(ra) # 800016f0 <sleep>
    8000373e:	bfd1                	j	80003712 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003740:	00235517          	auipc	a0,0x235
    80003744:	17050513          	addi	a0,a0,368 # 802388b0 <log>
    80003748:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	cd6080e7          	jalr	-810(ra) # 80006420 <release>
      break;
    }
  }
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6902                	ld	s2,0(sp)
    8000375a:	6105                	addi	sp,sp,32
    8000375c:	8082                	ret

000000008000375e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000375e:	7139                	addi	sp,sp,-64
    80003760:	fc06                	sd	ra,56(sp)
    80003762:	f822                	sd	s0,48(sp)
    80003764:	f426                	sd	s1,40(sp)
    80003766:	f04a                	sd	s2,32(sp)
    80003768:	ec4e                	sd	s3,24(sp)
    8000376a:	e852                	sd	s4,16(sp)
    8000376c:	e456                	sd	s5,8(sp)
    8000376e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003770:	00235497          	auipc	s1,0x235
    80003774:	14048493          	addi	s1,s1,320 # 802388b0 <log>
    80003778:	8526                	mv	a0,s1
    8000377a:	00003097          	auipc	ra,0x3
    8000377e:	bf2080e7          	jalr	-1038(ra) # 8000636c <acquire>
  log.outstanding -= 1;
    80003782:	509c                	lw	a5,32(s1)
    80003784:	37fd                	addiw	a5,a5,-1
    80003786:	0007891b          	sext.w	s2,a5
    8000378a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000378c:	50dc                	lw	a5,36(s1)
    8000378e:	efb9                	bnez	a5,800037ec <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003790:	06091663          	bnez	s2,800037fc <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003794:	00235497          	auipc	s1,0x235
    80003798:	11c48493          	addi	s1,s1,284 # 802388b0 <log>
    8000379c:	4785                	li	a5,1
    8000379e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037a0:	8526                	mv	a0,s1
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	c7e080e7          	jalr	-898(ra) # 80006420 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037aa:	54dc                	lw	a5,44(s1)
    800037ac:	06f04763          	bgtz	a5,8000381a <end_op+0xbc>
    acquire(&log.lock);
    800037b0:	00235497          	auipc	s1,0x235
    800037b4:	10048493          	addi	s1,s1,256 # 802388b0 <log>
    800037b8:	8526                	mv	a0,s1
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	bb2080e7          	jalr	-1102(ra) # 8000636c <acquire>
    log.committing = 0;
    800037c2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037c6:	8526                	mv	a0,s1
    800037c8:	ffffe097          	auipc	ra,0xffffe
    800037cc:	f8c080e7          	jalr	-116(ra) # 80001754 <wakeup>
    release(&log.lock);
    800037d0:	8526                	mv	a0,s1
    800037d2:	00003097          	auipc	ra,0x3
    800037d6:	c4e080e7          	jalr	-946(ra) # 80006420 <release>
}
    800037da:	70e2                	ld	ra,56(sp)
    800037dc:	7442                	ld	s0,48(sp)
    800037de:	74a2                	ld	s1,40(sp)
    800037e0:	7902                	ld	s2,32(sp)
    800037e2:	69e2                	ld	s3,24(sp)
    800037e4:	6a42                	ld	s4,16(sp)
    800037e6:	6aa2                	ld	s5,8(sp)
    800037e8:	6121                	addi	sp,sp,64
    800037ea:	8082                	ret
    panic("log.committing");
    800037ec:	00005517          	auipc	a0,0x5
    800037f0:	dc450513          	addi	a0,a0,-572 # 800085b0 <syscalls+0x1e0>
    800037f4:	00002097          	auipc	ra,0x2
    800037f8:	62e080e7          	jalr	1582(ra) # 80005e22 <panic>
    wakeup(&log);
    800037fc:	00235497          	auipc	s1,0x235
    80003800:	0b448493          	addi	s1,s1,180 # 802388b0 <log>
    80003804:	8526                	mv	a0,s1
    80003806:	ffffe097          	auipc	ra,0xffffe
    8000380a:	f4e080e7          	jalr	-178(ra) # 80001754 <wakeup>
  release(&log.lock);
    8000380e:	8526                	mv	a0,s1
    80003810:	00003097          	auipc	ra,0x3
    80003814:	c10080e7          	jalr	-1008(ra) # 80006420 <release>
  if(do_commit){
    80003818:	b7c9                	j	800037da <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000381a:	00235a97          	auipc	s5,0x235
    8000381e:	0c6a8a93          	addi	s5,s5,198 # 802388e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003822:	00235a17          	auipc	s4,0x235
    80003826:	08ea0a13          	addi	s4,s4,142 # 802388b0 <log>
    8000382a:	018a2583          	lw	a1,24(s4)
    8000382e:	012585bb          	addw	a1,a1,s2
    80003832:	2585                	addiw	a1,a1,1
    80003834:	028a2503          	lw	a0,40(s4)
    80003838:	fffff097          	auipc	ra,0xfffff
    8000383c:	cca080e7          	jalr	-822(ra) # 80002502 <bread>
    80003840:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003842:	000aa583          	lw	a1,0(s5)
    80003846:	028a2503          	lw	a0,40(s4)
    8000384a:	fffff097          	auipc	ra,0xfffff
    8000384e:	cb8080e7          	jalr	-840(ra) # 80002502 <bread>
    80003852:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003854:	40000613          	li	a2,1024
    80003858:	05850593          	addi	a1,a0,88
    8000385c:	05848513          	addi	a0,s1,88
    80003860:	ffffd097          	auipc	ra,0xffffd
    80003864:	b6a080e7          	jalr	-1174(ra) # 800003ca <memmove>
    bwrite(to);  // write the log
    80003868:	8526                	mv	a0,s1
    8000386a:	fffff097          	auipc	ra,0xfffff
    8000386e:	d8a080e7          	jalr	-630(ra) # 800025f4 <bwrite>
    brelse(from);
    80003872:	854e                	mv	a0,s3
    80003874:	fffff097          	auipc	ra,0xfffff
    80003878:	dbe080e7          	jalr	-578(ra) # 80002632 <brelse>
    brelse(to);
    8000387c:	8526                	mv	a0,s1
    8000387e:	fffff097          	auipc	ra,0xfffff
    80003882:	db4080e7          	jalr	-588(ra) # 80002632 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003886:	2905                	addiw	s2,s2,1
    80003888:	0a91                	addi	s5,s5,4
    8000388a:	02ca2783          	lw	a5,44(s4)
    8000388e:	f8f94ee3          	blt	s2,a5,8000382a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003892:	00000097          	auipc	ra,0x0
    80003896:	c6a080e7          	jalr	-918(ra) # 800034fc <write_head>
    install_trans(0); // Now install writes to home locations
    8000389a:	4501                	li	a0,0
    8000389c:	00000097          	auipc	ra,0x0
    800038a0:	cda080e7          	jalr	-806(ra) # 80003576 <install_trans>
    log.lh.n = 0;
    800038a4:	00235797          	auipc	a5,0x235
    800038a8:	0207ac23          	sw	zero,56(a5) # 802388dc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038ac:	00000097          	auipc	ra,0x0
    800038b0:	c50080e7          	jalr	-944(ra) # 800034fc <write_head>
    800038b4:	bdf5                	j	800037b0 <end_op+0x52>

00000000800038b6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038b6:	1101                	addi	sp,sp,-32
    800038b8:	ec06                	sd	ra,24(sp)
    800038ba:	e822                	sd	s0,16(sp)
    800038bc:	e426                	sd	s1,8(sp)
    800038be:	e04a                	sd	s2,0(sp)
    800038c0:	1000                	addi	s0,sp,32
    800038c2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038c4:	00235917          	auipc	s2,0x235
    800038c8:	fec90913          	addi	s2,s2,-20 # 802388b0 <log>
    800038cc:	854a                	mv	a0,s2
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	a9e080e7          	jalr	-1378(ra) # 8000636c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038d6:	02c92603          	lw	a2,44(s2)
    800038da:	47f5                	li	a5,29
    800038dc:	06c7c563          	blt	a5,a2,80003946 <log_write+0x90>
    800038e0:	00235797          	auipc	a5,0x235
    800038e4:	fec7a783          	lw	a5,-20(a5) # 802388cc <log+0x1c>
    800038e8:	37fd                	addiw	a5,a5,-1
    800038ea:	04f65e63          	bge	a2,a5,80003946 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038ee:	00235797          	auipc	a5,0x235
    800038f2:	fe27a783          	lw	a5,-30(a5) # 802388d0 <log+0x20>
    800038f6:	06f05063          	blez	a5,80003956 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038fa:	4781                	li	a5,0
    800038fc:	06c05563          	blez	a2,80003966 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003900:	44cc                	lw	a1,12(s1)
    80003902:	00235717          	auipc	a4,0x235
    80003906:	fde70713          	addi	a4,a4,-34 # 802388e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000390a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000390c:	4314                	lw	a3,0(a4)
    8000390e:	04b68c63          	beq	a3,a1,80003966 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003912:	2785                	addiw	a5,a5,1
    80003914:	0711                	addi	a4,a4,4
    80003916:	fef61be3          	bne	a2,a5,8000390c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000391a:	0621                	addi	a2,a2,8
    8000391c:	060a                	slli	a2,a2,0x2
    8000391e:	00235797          	auipc	a5,0x235
    80003922:	f9278793          	addi	a5,a5,-110 # 802388b0 <log>
    80003926:	963e                	add	a2,a2,a5
    80003928:	44dc                	lw	a5,12(s1)
    8000392a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000392c:	8526                	mv	a0,s1
    8000392e:	fffff097          	auipc	ra,0xfffff
    80003932:	da2080e7          	jalr	-606(ra) # 800026d0 <bpin>
    log.lh.n++;
    80003936:	00235717          	auipc	a4,0x235
    8000393a:	f7a70713          	addi	a4,a4,-134 # 802388b0 <log>
    8000393e:	575c                	lw	a5,44(a4)
    80003940:	2785                	addiw	a5,a5,1
    80003942:	d75c                	sw	a5,44(a4)
    80003944:	a835                	j	80003980 <log_write+0xca>
    panic("too big a transaction");
    80003946:	00005517          	auipc	a0,0x5
    8000394a:	c7a50513          	addi	a0,a0,-902 # 800085c0 <syscalls+0x1f0>
    8000394e:	00002097          	auipc	ra,0x2
    80003952:	4d4080e7          	jalr	1236(ra) # 80005e22 <panic>
    panic("log_write outside of trans");
    80003956:	00005517          	auipc	a0,0x5
    8000395a:	c8250513          	addi	a0,a0,-894 # 800085d8 <syscalls+0x208>
    8000395e:	00002097          	auipc	ra,0x2
    80003962:	4c4080e7          	jalr	1220(ra) # 80005e22 <panic>
  log.lh.block[i] = b->blockno;
    80003966:	00878713          	addi	a4,a5,8
    8000396a:	00271693          	slli	a3,a4,0x2
    8000396e:	00235717          	auipc	a4,0x235
    80003972:	f4270713          	addi	a4,a4,-190 # 802388b0 <log>
    80003976:	9736                	add	a4,a4,a3
    80003978:	44d4                	lw	a3,12(s1)
    8000397a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000397c:	faf608e3          	beq	a2,a5,8000392c <log_write+0x76>
  }
  release(&log.lock);
    80003980:	00235517          	auipc	a0,0x235
    80003984:	f3050513          	addi	a0,a0,-208 # 802388b0 <log>
    80003988:	00003097          	auipc	ra,0x3
    8000398c:	a98080e7          	jalr	-1384(ra) # 80006420 <release>
}
    80003990:	60e2                	ld	ra,24(sp)
    80003992:	6442                	ld	s0,16(sp)
    80003994:	64a2                	ld	s1,8(sp)
    80003996:	6902                	ld	s2,0(sp)
    80003998:	6105                	addi	sp,sp,32
    8000399a:	8082                	ret

000000008000399c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000399c:	1101                	addi	sp,sp,-32
    8000399e:	ec06                	sd	ra,24(sp)
    800039a0:	e822                	sd	s0,16(sp)
    800039a2:	e426                	sd	s1,8(sp)
    800039a4:	e04a                	sd	s2,0(sp)
    800039a6:	1000                	addi	s0,sp,32
    800039a8:	84aa                	mv	s1,a0
    800039aa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039ac:	00005597          	auipc	a1,0x5
    800039b0:	c4c58593          	addi	a1,a1,-948 # 800085f8 <syscalls+0x228>
    800039b4:	0521                	addi	a0,a0,8
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	926080e7          	jalr	-1754(ra) # 800062dc <initlock>
  lk->name = name;
    800039be:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039c2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039c6:	0204a423          	sw	zero,40(s1)
}
    800039ca:	60e2                	ld	ra,24(sp)
    800039cc:	6442                	ld	s0,16(sp)
    800039ce:	64a2                	ld	s1,8(sp)
    800039d0:	6902                	ld	s2,0(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret

00000000800039d6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039d6:	1101                	addi	sp,sp,-32
    800039d8:	ec06                	sd	ra,24(sp)
    800039da:	e822                	sd	s0,16(sp)
    800039dc:	e426                	sd	s1,8(sp)
    800039de:	e04a                	sd	s2,0(sp)
    800039e0:	1000                	addi	s0,sp,32
    800039e2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039e4:	00850913          	addi	s2,a0,8
    800039e8:	854a                	mv	a0,s2
    800039ea:	00003097          	auipc	ra,0x3
    800039ee:	982080e7          	jalr	-1662(ra) # 8000636c <acquire>
  while (lk->locked) {
    800039f2:	409c                	lw	a5,0(s1)
    800039f4:	cb89                	beqz	a5,80003a06 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039f6:	85ca                	mv	a1,s2
    800039f8:	8526                	mv	a0,s1
    800039fa:	ffffe097          	auipc	ra,0xffffe
    800039fe:	cf6080e7          	jalr	-778(ra) # 800016f0 <sleep>
  while (lk->locked) {
    80003a02:	409c                	lw	a5,0(s1)
    80003a04:	fbed                	bnez	a5,800039f6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a06:	4785                	li	a5,1
    80003a08:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a0a:	ffffd097          	auipc	ra,0xffffd
    80003a0e:	642080e7          	jalr	1602(ra) # 8000104c <myproc>
    80003a12:	591c                	lw	a5,48(a0)
    80003a14:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a16:	854a                	mv	a0,s2
    80003a18:	00003097          	auipc	ra,0x3
    80003a1c:	a08080e7          	jalr	-1528(ra) # 80006420 <release>
}
    80003a20:	60e2                	ld	ra,24(sp)
    80003a22:	6442                	ld	s0,16(sp)
    80003a24:	64a2                	ld	s1,8(sp)
    80003a26:	6902                	ld	s2,0(sp)
    80003a28:	6105                	addi	sp,sp,32
    80003a2a:	8082                	ret

0000000080003a2c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a2c:	1101                	addi	sp,sp,-32
    80003a2e:	ec06                	sd	ra,24(sp)
    80003a30:	e822                	sd	s0,16(sp)
    80003a32:	e426                	sd	s1,8(sp)
    80003a34:	e04a                	sd	s2,0(sp)
    80003a36:	1000                	addi	s0,sp,32
    80003a38:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a3a:	00850913          	addi	s2,a0,8
    80003a3e:	854a                	mv	a0,s2
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	92c080e7          	jalr	-1748(ra) # 8000636c <acquire>
  lk->locked = 0;
    80003a48:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a4c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a50:	8526                	mv	a0,s1
    80003a52:	ffffe097          	auipc	ra,0xffffe
    80003a56:	d02080e7          	jalr	-766(ra) # 80001754 <wakeup>
  release(&lk->lk);
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	9c4080e7          	jalr	-1596(ra) # 80006420 <release>
}
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6902                	ld	s2,0(sp)
    80003a6c:	6105                	addi	sp,sp,32
    80003a6e:	8082                	ret

0000000080003a70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a70:	7179                	addi	sp,sp,-48
    80003a72:	f406                	sd	ra,40(sp)
    80003a74:	f022                	sd	s0,32(sp)
    80003a76:	ec26                	sd	s1,24(sp)
    80003a78:	e84a                	sd	s2,16(sp)
    80003a7a:	e44e                	sd	s3,8(sp)
    80003a7c:	1800                	addi	s0,sp,48
    80003a7e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a80:	00850913          	addi	s2,a0,8
    80003a84:	854a                	mv	a0,s2
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	8e6080e7          	jalr	-1818(ra) # 8000636c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a8e:	409c                	lw	a5,0(s1)
    80003a90:	ef99                	bnez	a5,80003aae <holdingsleep+0x3e>
    80003a92:	4481                	li	s1,0
  release(&lk->lk);
    80003a94:	854a                	mv	a0,s2
    80003a96:	00003097          	auipc	ra,0x3
    80003a9a:	98a080e7          	jalr	-1654(ra) # 80006420 <release>
  return r;
}
    80003a9e:	8526                	mv	a0,s1
    80003aa0:	70a2                	ld	ra,40(sp)
    80003aa2:	7402                	ld	s0,32(sp)
    80003aa4:	64e2                	ld	s1,24(sp)
    80003aa6:	6942                	ld	s2,16(sp)
    80003aa8:	69a2                	ld	s3,8(sp)
    80003aaa:	6145                	addi	sp,sp,48
    80003aac:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aae:	0284a983          	lw	s3,40(s1)
    80003ab2:	ffffd097          	auipc	ra,0xffffd
    80003ab6:	59a080e7          	jalr	1434(ra) # 8000104c <myproc>
    80003aba:	5904                	lw	s1,48(a0)
    80003abc:	413484b3          	sub	s1,s1,s3
    80003ac0:	0014b493          	seqz	s1,s1
    80003ac4:	bfc1                	j	80003a94 <holdingsleep+0x24>

0000000080003ac6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ac6:	1141                	addi	sp,sp,-16
    80003ac8:	e406                	sd	ra,8(sp)
    80003aca:	e022                	sd	s0,0(sp)
    80003acc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ace:	00005597          	auipc	a1,0x5
    80003ad2:	b3a58593          	addi	a1,a1,-1222 # 80008608 <syscalls+0x238>
    80003ad6:	00235517          	auipc	a0,0x235
    80003ada:	f2250513          	addi	a0,a0,-222 # 802389f8 <ftable>
    80003ade:	00002097          	auipc	ra,0x2
    80003ae2:	7fe080e7          	jalr	2046(ra) # 800062dc <initlock>
}
    80003ae6:	60a2                	ld	ra,8(sp)
    80003ae8:	6402                	ld	s0,0(sp)
    80003aea:	0141                	addi	sp,sp,16
    80003aec:	8082                	ret

0000000080003aee <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003aee:	1101                	addi	sp,sp,-32
    80003af0:	ec06                	sd	ra,24(sp)
    80003af2:	e822                	sd	s0,16(sp)
    80003af4:	e426                	sd	s1,8(sp)
    80003af6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003af8:	00235517          	auipc	a0,0x235
    80003afc:	f0050513          	addi	a0,a0,-256 # 802389f8 <ftable>
    80003b00:	00003097          	auipc	ra,0x3
    80003b04:	86c080e7          	jalr	-1940(ra) # 8000636c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b08:	00235497          	auipc	s1,0x235
    80003b0c:	f0848493          	addi	s1,s1,-248 # 80238a10 <ftable+0x18>
    80003b10:	00236717          	auipc	a4,0x236
    80003b14:	ea070713          	addi	a4,a4,-352 # 802399b0 <disk>
    if(f->ref == 0){
    80003b18:	40dc                	lw	a5,4(s1)
    80003b1a:	cf99                	beqz	a5,80003b38 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b1c:	02848493          	addi	s1,s1,40
    80003b20:	fee49ce3          	bne	s1,a4,80003b18 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b24:	00235517          	auipc	a0,0x235
    80003b28:	ed450513          	addi	a0,a0,-300 # 802389f8 <ftable>
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	8f4080e7          	jalr	-1804(ra) # 80006420 <release>
  return 0;
    80003b34:	4481                	li	s1,0
    80003b36:	a819                	j	80003b4c <filealloc+0x5e>
      f->ref = 1;
    80003b38:	4785                	li	a5,1
    80003b3a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b3c:	00235517          	auipc	a0,0x235
    80003b40:	ebc50513          	addi	a0,a0,-324 # 802389f8 <ftable>
    80003b44:	00003097          	auipc	ra,0x3
    80003b48:	8dc080e7          	jalr	-1828(ra) # 80006420 <release>
}
    80003b4c:	8526                	mv	a0,s1
    80003b4e:	60e2                	ld	ra,24(sp)
    80003b50:	6442                	ld	s0,16(sp)
    80003b52:	64a2                	ld	s1,8(sp)
    80003b54:	6105                	addi	sp,sp,32
    80003b56:	8082                	ret

0000000080003b58 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b58:	1101                	addi	sp,sp,-32
    80003b5a:	ec06                	sd	ra,24(sp)
    80003b5c:	e822                	sd	s0,16(sp)
    80003b5e:	e426                	sd	s1,8(sp)
    80003b60:	1000                	addi	s0,sp,32
    80003b62:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b64:	00235517          	auipc	a0,0x235
    80003b68:	e9450513          	addi	a0,a0,-364 # 802389f8 <ftable>
    80003b6c:	00003097          	auipc	ra,0x3
    80003b70:	800080e7          	jalr	-2048(ra) # 8000636c <acquire>
  if(f->ref < 1)
    80003b74:	40dc                	lw	a5,4(s1)
    80003b76:	02f05263          	blez	a5,80003b9a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b7a:	2785                	addiw	a5,a5,1
    80003b7c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b7e:	00235517          	auipc	a0,0x235
    80003b82:	e7a50513          	addi	a0,a0,-390 # 802389f8 <ftable>
    80003b86:	00003097          	auipc	ra,0x3
    80003b8a:	89a080e7          	jalr	-1894(ra) # 80006420 <release>
  return f;
}
    80003b8e:	8526                	mv	a0,s1
    80003b90:	60e2                	ld	ra,24(sp)
    80003b92:	6442                	ld	s0,16(sp)
    80003b94:	64a2                	ld	s1,8(sp)
    80003b96:	6105                	addi	sp,sp,32
    80003b98:	8082                	ret
    panic("filedup");
    80003b9a:	00005517          	auipc	a0,0x5
    80003b9e:	a7650513          	addi	a0,a0,-1418 # 80008610 <syscalls+0x240>
    80003ba2:	00002097          	auipc	ra,0x2
    80003ba6:	280080e7          	jalr	640(ra) # 80005e22 <panic>

0000000080003baa <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003baa:	7139                	addi	sp,sp,-64
    80003bac:	fc06                	sd	ra,56(sp)
    80003bae:	f822                	sd	s0,48(sp)
    80003bb0:	f426                	sd	s1,40(sp)
    80003bb2:	f04a                	sd	s2,32(sp)
    80003bb4:	ec4e                	sd	s3,24(sp)
    80003bb6:	e852                	sd	s4,16(sp)
    80003bb8:	e456                	sd	s5,8(sp)
    80003bba:	0080                	addi	s0,sp,64
    80003bbc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bbe:	00235517          	auipc	a0,0x235
    80003bc2:	e3a50513          	addi	a0,a0,-454 # 802389f8 <ftable>
    80003bc6:	00002097          	auipc	ra,0x2
    80003bca:	7a6080e7          	jalr	1958(ra) # 8000636c <acquire>
  if(f->ref < 1)
    80003bce:	40dc                	lw	a5,4(s1)
    80003bd0:	06f05163          	blez	a5,80003c32 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bd4:	37fd                	addiw	a5,a5,-1
    80003bd6:	0007871b          	sext.w	a4,a5
    80003bda:	c0dc                	sw	a5,4(s1)
    80003bdc:	06e04363          	bgtz	a4,80003c42 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003be0:	0004a903          	lw	s2,0(s1)
    80003be4:	0094ca83          	lbu	s5,9(s1)
    80003be8:	0104ba03          	ld	s4,16(s1)
    80003bec:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bf0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bf4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bf8:	00235517          	auipc	a0,0x235
    80003bfc:	e0050513          	addi	a0,a0,-512 # 802389f8 <ftable>
    80003c00:	00003097          	auipc	ra,0x3
    80003c04:	820080e7          	jalr	-2016(ra) # 80006420 <release>

  if(ff.type == FD_PIPE){
    80003c08:	4785                	li	a5,1
    80003c0a:	04f90d63          	beq	s2,a5,80003c64 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c0e:	3979                	addiw	s2,s2,-2
    80003c10:	4785                	li	a5,1
    80003c12:	0527e063          	bltu	a5,s2,80003c52 <fileclose+0xa8>
    begin_op();
    80003c16:	00000097          	auipc	ra,0x0
    80003c1a:	ac8080e7          	jalr	-1336(ra) # 800036de <begin_op>
    iput(ff.ip);
    80003c1e:	854e                	mv	a0,s3
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	2b6080e7          	jalr	694(ra) # 80002ed6 <iput>
    end_op();
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	b36080e7          	jalr	-1226(ra) # 8000375e <end_op>
    80003c30:	a00d                	j	80003c52 <fileclose+0xa8>
    panic("fileclose");
    80003c32:	00005517          	auipc	a0,0x5
    80003c36:	9e650513          	addi	a0,a0,-1562 # 80008618 <syscalls+0x248>
    80003c3a:	00002097          	auipc	ra,0x2
    80003c3e:	1e8080e7          	jalr	488(ra) # 80005e22 <panic>
    release(&ftable.lock);
    80003c42:	00235517          	auipc	a0,0x235
    80003c46:	db650513          	addi	a0,a0,-586 # 802389f8 <ftable>
    80003c4a:	00002097          	auipc	ra,0x2
    80003c4e:	7d6080e7          	jalr	2006(ra) # 80006420 <release>
  }
}
    80003c52:	70e2                	ld	ra,56(sp)
    80003c54:	7442                	ld	s0,48(sp)
    80003c56:	74a2                	ld	s1,40(sp)
    80003c58:	7902                	ld	s2,32(sp)
    80003c5a:	69e2                	ld	s3,24(sp)
    80003c5c:	6a42                	ld	s4,16(sp)
    80003c5e:	6aa2                	ld	s5,8(sp)
    80003c60:	6121                	addi	sp,sp,64
    80003c62:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c64:	85d6                	mv	a1,s5
    80003c66:	8552                	mv	a0,s4
    80003c68:	00000097          	auipc	ra,0x0
    80003c6c:	34c080e7          	jalr	844(ra) # 80003fb4 <pipeclose>
    80003c70:	b7cd                	j	80003c52 <fileclose+0xa8>

0000000080003c72 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c72:	715d                	addi	sp,sp,-80
    80003c74:	e486                	sd	ra,72(sp)
    80003c76:	e0a2                	sd	s0,64(sp)
    80003c78:	fc26                	sd	s1,56(sp)
    80003c7a:	f84a                	sd	s2,48(sp)
    80003c7c:	f44e                	sd	s3,40(sp)
    80003c7e:	0880                	addi	s0,sp,80
    80003c80:	84aa                	mv	s1,a0
    80003c82:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c84:	ffffd097          	auipc	ra,0xffffd
    80003c88:	3c8080e7          	jalr	968(ra) # 8000104c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c8c:	409c                	lw	a5,0(s1)
    80003c8e:	37f9                	addiw	a5,a5,-2
    80003c90:	4705                	li	a4,1
    80003c92:	04f76763          	bltu	a4,a5,80003ce0 <filestat+0x6e>
    80003c96:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c98:	6c88                	ld	a0,24(s1)
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	082080e7          	jalr	130(ra) # 80002d1c <ilock>
    stati(f->ip, &st);
    80003ca2:	fb840593          	addi	a1,s0,-72
    80003ca6:	6c88                	ld	a0,24(s1)
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	2fe080e7          	jalr	766(ra) # 80002fa6 <stati>
    iunlock(f->ip);
    80003cb0:	6c88                	ld	a0,24(s1)
    80003cb2:	fffff097          	auipc	ra,0xfffff
    80003cb6:	12c080e7          	jalr	300(ra) # 80002dde <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cba:	46e1                	li	a3,24
    80003cbc:	fb840613          	addi	a2,s0,-72
    80003cc0:	85ce                	mv	a1,s3
    80003cc2:	05093503          	ld	a0,80(s2)
    80003cc6:	ffffd097          	auipc	ra,0xffffd
    80003cca:	038080e7          	jalr	56(ra) # 80000cfe <copyout>
    80003cce:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cd2:	60a6                	ld	ra,72(sp)
    80003cd4:	6406                	ld	s0,64(sp)
    80003cd6:	74e2                	ld	s1,56(sp)
    80003cd8:	7942                	ld	s2,48(sp)
    80003cda:	79a2                	ld	s3,40(sp)
    80003cdc:	6161                	addi	sp,sp,80
    80003cde:	8082                	ret
  return -1;
    80003ce0:	557d                	li	a0,-1
    80003ce2:	bfc5                	j	80003cd2 <filestat+0x60>

0000000080003ce4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ce4:	7179                	addi	sp,sp,-48
    80003ce6:	f406                	sd	ra,40(sp)
    80003ce8:	f022                	sd	s0,32(sp)
    80003cea:	ec26                	sd	s1,24(sp)
    80003cec:	e84a                	sd	s2,16(sp)
    80003cee:	e44e                	sd	s3,8(sp)
    80003cf0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cf2:	00854783          	lbu	a5,8(a0)
    80003cf6:	c3d5                	beqz	a5,80003d9a <fileread+0xb6>
    80003cf8:	84aa                	mv	s1,a0
    80003cfa:	89ae                	mv	s3,a1
    80003cfc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cfe:	411c                	lw	a5,0(a0)
    80003d00:	4705                	li	a4,1
    80003d02:	04e78963          	beq	a5,a4,80003d54 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d06:	470d                	li	a4,3
    80003d08:	04e78d63          	beq	a5,a4,80003d62 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d0c:	4709                	li	a4,2
    80003d0e:	06e79e63          	bne	a5,a4,80003d8a <fileread+0xa6>
    ilock(f->ip);
    80003d12:	6d08                	ld	a0,24(a0)
    80003d14:	fffff097          	auipc	ra,0xfffff
    80003d18:	008080e7          	jalr	8(ra) # 80002d1c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d1c:	874a                	mv	a4,s2
    80003d1e:	5094                	lw	a3,32(s1)
    80003d20:	864e                	mv	a2,s3
    80003d22:	4585                	li	a1,1
    80003d24:	6c88                	ld	a0,24(s1)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	2aa080e7          	jalr	682(ra) # 80002fd0 <readi>
    80003d2e:	892a                	mv	s2,a0
    80003d30:	00a05563          	blez	a0,80003d3a <fileread+0x56>
      f->off += r;
    80003d34:	509c                	lw	a5,32(s1)
    80003d36:	9fa9                	addw	a5,a5,a0
    80003d38:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d3a:	6c88                	ld	a0,24(s1)
    80003d3c:	fffff097          	auipc	ra,0xfffff
    80003d40:	0a2080e7          	jalr	162(ra) # 80002dde <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d44:	854a                	mv	a0,s2
    80003d46:	70a2                	ld	ra,40(sp)
    80003d48:	7402                	ld	s0,32(sp)
    80003d4a:	64e2                	ld	s1,24(sp)
    80003d4c:	6942                	ld	s2,16(sp)
    80003d4e:	69a2                	ld	s3,8(sp)
    80003d50:	6145                	addi	sp,sp,48
    80003d52:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d54:	6908                	ld	a0,16(a0)
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	3ce080e7          	jalr	974(ra) # 80004124 <piperead>
    80003d5e:	892a                	mv	s2,a0
    80003d60:	b7d5                	j	80003d44 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d62:	02451783          	lh	a5,36(a0)
    80003d66:	03079693          	slli	a3,a5,0x30
    80003d6a:	92c1                	srli	a3,a3,0x30
    80003d6c:	4725                	li	a4,9
    80003d6e:	02d76863          	bltu	a4,a3,80003d9e <fileread+0xba>
    80003d72:	0792                	slli	a5,a5,0x4
    80003d74:	00235717          	auipc	a4,0x235
    80003d78:	be470713          	addi	a4,a4,-1052 # 80238958 <devsw>
    80003d7c:	97ba                	add	a5,a5,a4
    80003d7e:	639c                	ld	a5,0(a5)
    80003d80:	c38d                	beqz	a5,80003da2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d82:	4505                	li	a0,1
    80003d84:	9782                	jalr	a5
    80003d86:	892a                	mv	s2,a0
    80003d88:	bf75                	j	80003d44 <fileread+0x60>
    panic("fileread");
    80003d8a:	00005517          	auipc	a0,0x5
    80003d8e:	89e50513          	addi	a0,a0,-1890 # 80008628 <syscalls+0x258>
    80003d92:	00002097          	auipc	ra,0x2
    80003d96:	090080e7          	jalr	144(ra) # 80005e22 <panic>
    return -1;
    80003d9a:	597d                	li	s2,-1
    80003d9c:	b765                	j	80003d44 <fileread+0x60>
      return -1;
    80003d9e:	597d                	li	s2,-1
    80003da0:	b755                	j	80003d44 <fileread+0x60>
    80003da2:	597d                	li	s2,-1
    80003da4:	b745                	j	80003d44 <fileread+0x60>

0000000080003da6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003da6:	715d                	addi	sp,sp,-80
    80003da8:	e486                	sd	ra,72(sp)
    80003daa:	e0a2                	sd	s0,64(sp)
    80003dac:	fc26                	sd	s1,56(sp)
    80003dae:	f84a                	sd	s2,48(sp)
    80003db0:	f44e                	sd	s3,40(sp)
    80003db2:	f052                	sd	s4,32(sp)
    80003db4:	ec56                	sd	s5,24(sp)
    80003db6:	e85a                	sd	s6,16(sp)
    80003db8:	e45e                	sd	s7,8(sp)
    80003dba:	e062                	sd	s8,0(sp)
    80003dbc:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dbe:	00954783          	lbu	a5,9(a0)
    80003dc2:	10078663          	beqz	a5,80003ece <filewrite+0x128>
    80003dc6:	892a                	mv	s2,a0
    80003dc8:	8aae                	mv	s5,a1
    80003dca:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dcc:	411c                	lw	a5,0(a0)
    80003dce:	4705                	li	a4,1
    80003dd0:	02e78263          	beq	a5,a4,80003df4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dd4:	470d                	li	a4,3
    80003dd6:	02e78663          	beq	a5,a4,80003e02 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dda:	4709                	li	a4,2
    80003ddc:	0ee79163          	bne	a5,a4,80003ebe <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de0:	0ac05d63          	blez	a2,80003e9a <filewrite+0xf4>
    int i = 0;
    80003de4:	4981                	li	s3,0
    80003de6:	6b05                	lui	s6,0x1
    80003de8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dec:	6b85                	lui	s7,0x1
    80003dee:	c00b8b9b          	addiw	s7,s7,-1024
    80003df2:	a861                	j	80003e8a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003df4:	6908                	ld	a0,16(a0)
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	22e080e7          	jalr	558(ra) # 80004024 <pipewrite>
    80003dfe:	8a2a                	mv	s4,a0
    80003e00:	a045                	j	80003ea0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e02:	02451783          	lh	a5,36(a0)
    80003e06:	03079693          	slli	a3,a5,0x30
    80003e0a:	92c1                	srli	a3,a3,0x30
    80003e0c:	4725                	li	a4,9
    80003e0e:	0cd76263          	bltu	a4,a3,80003ed2 <filewrite+0x12c>
    80003e12:	0792                	slli	a5,a5,0x4
    80003e14:	00235717          	auipc	a4,0x235
    80003e18:	b4470713          	addi	a4,a4,-1212 # 80238958 <devsw>
    80003e1c:	97ba                	add	a5,a5,a4
    80003e1e:	679c                	ld	a5,8(a5)
    80003e20:	cbdd                	beqz	a5,80003ed6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e22:	4505                	li	a0,1
    80003e24:	9782                	jalr	a5
    80003e26:	8a2a                	mv	s4,a0
    80003e28:	a8a5                	j	80003ea0 <filewrite+0xfa>
    80003e2a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	8b0080e7          	jalr	-1872(ra) # 800036de <begin_op>
      ilock(f->ip);
    80003e36:	01893503          	ld	a0,24(s2)
    80003e3a:	fffff097          	auipc	ra,0xfffff
    80003e3e:	ee2080e7          	jalr	-286(ra) # 80002d1c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e42:	8762                	mv	a4,s8
    80003e44:	02092683          	lw	a3,32(s2)
    80003e48:	01598633          	add	a2,s3,s5
    80003e4c:	4585                	li	a1,1
    80003e4e:	01893503          	ld	a0,24(s2)
    80003e52:	fffff097          	auipc	ra,0xfffff
    80003e56:	276080e7          	jalr	630(ra) # 800030c8 <writei>
    80003e5a:	84aa                	mv	s1,a0
    80003e5c:	00a05763          	blez	a0,80003e6a <filewrite+0xc4>
        f->off += r;
    80003e60:	02092783          	lw	a5,32(s2)
    80003e64:	9fa9                	addw	a5,a5,a0
    80003e66:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e6a:	01893503          	ld	a0,24(s2)
    80003e6e:	fffff097          	auipc	ra,0xfffff
    80003e72:	f70080e7          	jalr	-144(ra) # 80002dde <iunlock>
      end_op();
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	8e8080e7          	jalr	-1816(ra) # 8000375e <end_op>

      if(r != n1){
    80003e7e:	009c1f63          	bne	s8,s1,80003e9c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e82:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e86:	0149db63          	bge	s3,s4,80003e9c <filewrite+0xf6>
      int n1 = n - i;
    80003e8a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e8e:	84be                	mv	s1,a5
    80003e90:	2781                	sext.w	a5,a5
    80003e92:	f8fb5ce3          	bge	s6,a5,80003e2a <filewrite+0x84>
    80003e96:	84de                	mv	s1,s7
    80003e98:	bf49                	j	80003e2a <filewrite+0x84>
    int i = 0;
    80003e9a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e9c:	013a1f63          	bne	s4,s3,80003eba <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ea0:	8552                	mv	a0,s4
    80003ea2:	60a6                	ld	ra,72(sp)
    80003ea4:	6406                	ld	s0,64(sp)
    80003ea6:	74e2                	ld	s1,56(sp)
    80003ea8:	7942                	ld	s2,48(sp)
    80003eaa:	79a2                	ld	s3,40(sp)
    80003eac:	7a02                	ld	s4,32(sp)
    80003eae:	6ae2                	ld	s5,24(sp)
    80003eb0:	6b42                	ld	s6,16(sp)
    80003eb2:	6ba2                	ld	s7,8(sp)
    80003eb4:	6c02                	ld	s8,0(sp)
    80003eb6:	6161                	addi	sp,sp,80
    80003eb8:	8082                	ret
    ret = (i == n ? n : -1);
    80003eba:	5a7d                	li	s4,-1
    80003ebc:	b7d5                	j	80003ea0 <filewrite+0xfa>
    panic("filewrite");
    80003ebe:	00004517          	auipc	a0,0x4
    80003ec2:	77a50513          	addi	a0,a0,1914 # 80008638 <syscalls+0x268>
    80003ec6:	00002097          	auipc	ra,0x2
    80003eca:	f5c080e7          	jalr	-164(ra) # 80005e22 <panic>
    return -1;
    80003ece:	5a7d                	li	s4,-1
    80003ed0:	bfc1                	j	80003ea0 <filewrite+0xfa>
      return -1;
    80003ed2:	5a7d                	li	s4,-1
    80003ed4:	b7f1                	j	80003ea0 <filewrite+0xfa>
    80003ed6:	5a7d                	li	s4,-1
    80003ed8:	b7e1                	j	80003ea0 <filewrite+0xfa>

0000000080003eda <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003eda:	7179                	addi	sp,sp,-48
    80003edc:	f406                	sd	ra,40(sp)
    80003ede:	f022                	sd	s0,32(sp)
    80003ee0:	ec26                	sd	s1,24(sp)
    80003ee2:	e84a                	sd	s2,16(sp)
    80003ee4:	e44e                	sd	s3,8(sp)
    80003ee6:	e052                	sd	s4,0(sp)
    80003ee8:	1800                	addi	s0,sp,48
    80003eea:	84aa                	mv	s1,a0
    80003eec:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003eee:	0005b023          	sd	zero,0(a1)
    80003ef2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	bf8080e7          	jalr	-1032(ra) # 80003aee <filealloc>
    80003efe:	e088                	sd	a0,0(s1)
    80003f00:	c551                	beqz	a0,80003f8c <pipealloc+0xb2>
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	bec080e7          	jalr	-1044(ra) # 80003aee <filealloc>
    80003f0a:	00aa3023          	sd	a0,0(s4)
    80003f0e:	c92d                	beqz	a0,80003f80 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f10:	ffffc097          	auipc	ra,0xffffc
    80003f14:	2de080e7          	jalr	734(ra) # 800001ee <kalloc>
    80003f18:	892a                	mv	s2,a0
    80003f1a:	c125                	beqz	a0,80003f7a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f1c:	4985                	li	s3,1
    80003f1e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f22:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f26:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f2a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f2e:	00004597          	auipc	a1,0x4
    80003f32:	71a58593          	addi	a1,a1,1818 # 80008648 <syscalls+0x278>
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	3a6080e7          	jalr	934(ra) # 800062dc <initlock>
  (*f0)->type = FD_PIPE;
    80003f3e:	609c                	ld	a5,0(s1)
    80003f40:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f44:	609c                	ld	a5,0(s1)
    80003f46:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f4a:	609c                	ld	a5,0(s1)
    80003f4c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f50:	609c                	ld	a5,0(s1)
    80003f52:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f56:	000a3783          	ld	a5,0(s4)
    80003f5a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f5e:	000a3783          	ld	a5,0(s4)
    80003f62:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f66:	000a3783          	ld	a5,0(s4)
    80003f6a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f6e:	000a3783          	ld	a5,0(s4)
    80003f72:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f76:	4501                	li	a0,0
    80003f78:	a025                	j	80003fa0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f7a:	6088                	ld	a0,0(s1)
    80003f7c:	e501                	bnez	a0,80003f84 <pipealloc+0xaa>
    80003f7e:	a039                	j	80003f8c <pipealloc+0xb2>
    80003f80:	6088                	ld	a0,0(s1)
    80003f82:	c51d                	beqz	a0,80003fb0 <pipealloc+0xd6>
    fileclose(*f0);
    80003f84:	00000097          	auipc	ra,0x0
    80003f88:	c26080e7          	jalr	-986(ra) # 80003baa <fileclose>
  if(*f1)
    80003f8c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f90:	557d                	li	a0,-1
  if(*f1)
    80003f92:	c799                	beqz	a5,80003fa0 <pipealloc+0xc6>
    fileclose(*f1);
    80003f94:	853e                	mv	a0,a5
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	c14080e7          	jalr	-1004(ra) # 80003baa <fileclose>
  return -1;
    80003f9e:	557d                	li	a0,-1
}
    80003fa0:	70a2                	ld	ra,40(sp)
    80003fa2:	7402                	ld	s0,32(sp)
    80003fa4:	64e2                	ld	s1,24(sp)
    80003fa6:	6942                	ld	s2,16(sp)
    80003fa8:	69a2                	ld	s3,8(sp)
    80003faa:	6a02                	ld	s4,0(sp)
    80003fac:	6145                	addi	sp,sp,48
    80003fae:	8082                	ret
  return -1;
    80003fb0:	557d                	li	a0,-1
    80003fb2:	b7fd                	j	80003fa0 <pipealloc+0xc6>

0000000080003fb4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fb4:	1101                	addi	sp,sp,-32
    80003fb6:	ec06                	sd	ra,24(sp)
    80003fb8:	e822                	sd	s0,16(sp)
    80003fba:	e426                	sd	s1,8(sp)
    80003fbc:	e04a                	sd	s2,0(sp)
    80003fbe:	1000                	addi	s0,sp,32
    80003fc0:	84aa                	mv	s1,a0
    80003fc2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	3a8080e7          	jalr	936(ra) # 8000636c <acquire>
  if(writable){
    80003fcc:	02090d63          	beqz	s2,80004006 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fd0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fd4:	21848513          	addi	a0,s1,536
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	77c080e7          	jalr	1916(ra) # 80001754 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fe0:	2204b783          	ld	a5,544(s1)
    80003fe4:	eb95                	bnez	a5,80004018 <pipeclose+0x64>
    release(&pi->lock);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	00002097          	auipc	ra,0x2
    80003fec:	438080e7          	jalr	1080(ra) # 80006420 <release>
    kfree((char*)pi);
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	ffffc097          	auipc	ra,0xffffc
    80003ff6:	0b6080e7          	jalr	182(ra) # 800000a8 <kfree>
  } else
    release(&pi->lock);
}
    80003ffa:	60e2                	ld	ra,24(sp)
    80003ffc:	6442                	ld	s0,16(sp)
    80003ffe:	64a2                	ld	s1,8(sp)
    80004000:	6902                	ld	s2,0(sp)
    80004002:	6105                	addi	sp,sp,32
    80004004:	8082                	ret
    pi->readopen = 0;
    80004006:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000400a:	21c48513          	addi	a0,s1,540
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	746080e7          	jalr	1862(ra) # 80001754 <wakeup>
    80004016:	b7e9                	j	80003fe0 <pipeclose+0x2c>
    release(&pi->lock);
    80004018:	8526                	mv	a0,s1
    8000401a:	00002097          	auipc	ra,0x2
    8000401e:	406080e7          	jalr	1030(ra) # 80006420 <release>
}
    80004022:	bfe1                	j	80003ffa <pipeclose+0x46>

0000000080004024 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004024:	7159                	addi	sp,sp,-112
    80004026:	f486                	sd	ra,104(sp)
    80004028:	f0a2                	sd	s0,96(sp)
    8000402a:	eca6                	sd	s1,88(sp)
    8000402c:	e8ca                	sd	s2,80(sp)
    8000402e:	e4ce                	sd	s3,72(sp)
    80004030:	e0d2                	sd	s4,64(sp)
    80004032:	fc56                	sd	s5,56(sp)
    80004034:	f85a                	sd	s6,48(sp)
    80004036:	f45e                	sd	s7,40(sp)
    80004038:	f062                	sd	s8,32(sp)
    8000403a:	ec66                	sd	s9,24(sp)
    8000403c:	1880                	addi	s0,sp,112
    8000403e:	84aa                	mv	s1,a0
    80004040:	8aae                	mv	s5,a1
    80004042:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	008080e7          	jalr	8(ra) # 8000104c <myproc>
    8000404c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000404e:	8526                	mv	a0,s1
    80004050:	00002097          	auipc	ra,0x2
    80004054:	31c080e7          	jalr	796(ra) # 8000636c <acquire>
  while(i < n){
    80004058:	0d405463          	blez	s4,80004120 <pipewrite+0xfc>
    8000405c:	8ba6                	mv	s7,s1
  int i = 0;
    8000405e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004060:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004062:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004066:	21c48c13          	addi	s8,s1,540
    8000406a:	a08d                	j	800040cc <pipewrite+0xa8>
      release(&pi->lock);
    8000406c:	8526                	mv	a0,s1
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	3b2080e7          	jalr	946(ra) # 80006420 <release>
      return -1;
    80004076:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004078:	854a                	mv	a0,s2
    8000407a:	70a6                	ld	ra,104(sp)
    8000407c:	7406                	ld	s0,96(sp)
    8000407e:	64e6                	ld	s1,88(sp)
    80004080:	6946                	ld	s2,80(sp)
    80004082:	69a6                	ld	s3,72(sp)
    80004084:	6a06                	ld	s4,64(sp)
    80004086:	7ae2                	ld	s5,56(sp)
    80004088:	7b42                	ld	s6,48(sp)
    8000408a:	7ba2                	ld	s7,40(sp)
    8000408c:	7c02                	ld	s8,32(sp)
    8000408e:	6ce2                	ld	s9,24(sp)
    80004090:	6165                	addi	sp,sp,112
    80004092:	8082                	ret
      wakeup(&pi->nread);
    80004094:	8566                	mv	a0,s9
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	6be080e7          	jalr	1726(ra) # 80001754 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000409e:	85de                	mv	a1,s7
    800040a0:	8562                	mv	a0,s8
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	64e080e7          	jalr	1614(ra) # 800016f0 <sleep>
    800040aa:	a839                	j	800040c8 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040ac:	21c4a783          	lw	a5,540(s1)
    800040b0:	0017871b          	addiw	a4,a5,1
    800040b4:	20e4ae23          	sw	a4,540(s1)
    800040b8:	1ff7f793          	andi	a5,a5,511
    800040bc:	97a6                	add	a5,a5,s1
    800040be:	f9f44703          	lbu	a4,-97(s0)
    800040c2:	00e78c23          	sb	a4,24(a5)
      i++;
    800040c6:	2905                	addiw	s2,s2,1
  while(i < n){
    800040c8:	05495063          	bge	s2,s4,80004108 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    800040cc:	2204a783          	lw	a5,544(s1)
    800040d0:	dfd1                	beqz	a5,8000406c <pipewrite+0x48>
    800040d2:	854e                	mv	a0,s3
    800040d4:	ffffe097          	auipc	ra,0xffffe
    800040d8:	8c4080e7          	jalr	-1852(ra) # 80001998 <killed>
    800040dc:	f941                	bnez	a0,8000406c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040de:	2184a783          	lw	a5,536(s1)
    800040e2:	21c4a703          	lw	a4,540(s1)
    800040e6:	2007879b          	addiw	a5,a5,512
    800040ea:	faf705e3          	beq	a4,a5,80004094 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ee:	4685                	li	a3,1
    800040f0:	01590633          	add	a2,s2,s5
    800040f4:	f9f40593          	addi	a1,s0,-97
    800040f8:	0509b503          	ld	a0,80(s3)
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	c9a080e7          	jalr	-870(ra) # 80000d96 <copyin>
    80004104:	fb6514e3          	bne	a0,s6,800040ac <pipewrite+0x88>
  wakeup(&pi->nread);
    80004108:	21848513          	addi	a0,s1,536
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	648080e7          	jalr	1608(ra) # 80001754 <wakeup>
  release(&pi->lock);
    80004114:	8526                	mv	a0,s1
    80004116:	00002097          	auipc	ra,0x2
    8000411a:	30a080e7          	jalr	778(ra) # 80006420 <release>
  return i;
    8000411e:	bfa9                	j	80004078 <pipewrite+0x54>
  int i = 0;
    80004120:	4901                	li	s2,0
    80004122:	b7dd                	j	80004108 <pipewrite+0xe4>

0000000080004124 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004124:	715d                	addi	sp,sp,-80
    80004126:	e486                	sd	ra,72(sp)
    80004128:	e0a2                	sd	s0,64(sp)
    8000412a:	fc26                	sd	s1,56(sp)
    8000412c:	f84a                	sd	s2,48(sp)
    8000412e:	f44e                	sd	s3,40(sp)
    80004130:	f052                	sd	s4,32(sp)
    80004132:	ec56                	sd	s5,24(sp)
    80004134:	e85a                	sd	s6,16(sp)
    80004136:	0880                	addi	s0,sp,80
    80004138:	84aa                	mv	s1,a0
    8000413a:	892e                	mv	s2,a1
    8000413c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	f0e080e7          	jalr	-242(ra) # 8000104c <myproc>
    80004146:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004148:	8b26                	mv	s6,s1
    8000414a:	8526                	mv	a0,s1
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	220080e7          	jalr	544(ra) # 8000636c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004154:	2184a703          	lw	a4,536(s1)
    80004158:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000415c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004160:	02f71763          	bne	a4,a5,8000418e <piperead+0x6a>
    80004164:	2244a783          	lw	a5,548(s1)
    80004168:	c39d                	beqz	a5,8000418e <piperead+0x6a>
    if(killed(pr)){
    8000416a:	8552                	mv	a0,s4
    8000416c:	ffffe097          	auipc	ra,0xffffe
    80004170:	82c080e7          	jalr	-2004(ra) # 80001998 <killed>
    80004174:	e941                	bnez	a0,80004204 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004176:	85da                	mv	a1,s6
    80004178:	854e                	mv	a0,s3
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	576080e7          	jalr	1398(ra) # 800016f0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004182:	2184a703          	lw	a4,536(s1)
    80004186:	21c4a783          	lw	a5,540(s1)
    8000418a:	fcf70de3          	beq	a4,a5,80004164 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000418e:	09505263          	blez	s5,80004212 <piperead+0xee>
    80004192:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004194:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004196:	2184a783          	lw	a5,536(s1)
    8000419a:	21c4a703          	lw	a4,540(s1)
    8000419e:	02f70d63          	beq	a4,a5,800041d8 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041a2:	0017871b          	addiw	a4,a5,1
    800041a6:	20e4ac23          	sw	a4,536(s1)
    800041aa:	1ff7f793          	andi	a5,a5,511
    800041ae:	97a6                	add	a5,a5,s1
    800041b0:	0187c783          	lbu	a5,24(a5)
    800041b4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041b8:	4685                	li	a3,1
    800041ba:	fbf40613          	addi	a2,s0,-65
    800041be:	85ca                	mv	a1,s2
    800041c0:	050a3503          	ld	a0,80(s4)
    800041c4:	ffffd097          	auipc	ra,0xffffd
    800041c8:	b3a080e7          	jalr	-1222(ra) # 80000cfe <copyout>
    800041cc:	01650663          	beq	a0,s6,800041d8 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041d0:	2985                	addiw	s3,s3,1
    800041d2:	0905                	addi	s2,s2,1
    800041d4:	fd3a91e3          	bne	s5,s3,80004196 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041d8:	21c48513          	addi	a0,s1,540
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	578080e7          	jalr	1400(ra) # 80001754 <wakeup>
  release(&pi->lock);
    800041e4:	8526                	mv	a0,s1
    800041e6:	00002097          	auipc	ra,0x2
    800041ea:	23a080e7          	jalr	570(ra) # 80006420 <release>
  return i;
}
    800041ee:	854e                	mv	a0,s3
    800041f0:	60a6                	ld	ra,72(sp)
    800041f2:	6406                	ld	s0,64(sp)
    800041f4:	74e2                	ld	s1,56(sp)
    800041f6:	7942                	ld	s2,48(sp)
    800041f8:	79a2                	ld	s3,40(sp)
    800041fa:	7a02                	ld	s4,32(sp)
    800041fc:	6ae2                	ld	s5,24(sp)
    800041fe:	6b42                	ld	s6,16(sp)
    80004200:	6161                	addi	sp,sp,80
    80004202:	8082                	ret
      release(&pi->lock);
    80004204:	8526                	mv	a0,s1
    80004206:	00002097          	auipc	ra,0x2
    8000420a:	21a080e7          	jalr	538(ra) # 80006420 <release>
      return -1;
    8000420e:	59fd                	li	s3,-1
    80004210:	bff9                	j	800041ee <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004212:	4981                	li	s3,0
    80004214:	b7d1                	j	800041d8 <piperead+0xb4>

0000000080004216 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004216:	1141                	addi	sp,sp,-16
    80004218:	e422                	sd	s0,8(sp)
    8000421a:	0800                	addi	s0,sp,16
    8000421c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000421e:	8905                	andi	a0,a0,1
    80004220:	c111                	beqz	a0,80004224 <flags2perm+0xe>
      perm = PTE_X;
    80004222:	4521                	li	a0,8
    if(flags & 0x2)
    80004224:	8b89                	andi	a5,a5,2
    80004226:	c399                	beqz	a5,8000422c <flags2perm+0x16>
      perm |= PTE_W;
    80004228:	00456513          	ori	a0,a0,4
    return perm;
}
    8000422c:	6422                	ld	s0,8(sp)
    8000422e:	0141                	addi	sp,sp,16
    80004230:	8082                	ret

0000000080004232 <exec>:

int
exec(char *path, char **argv)
{
    80004232:	df010113          	addi	sp,sp,-528
    80004236:	20113423          	sd	ra,520(sp)
    8000423a:	20813023          	sd	s0,512(sp)
    8000423e:	ffa6                	sd	s1,504(sp)
    80004240:	fbca                	sd	s2,496(sp)
    80004242:	f7ce                	sd	s3,488(sp)
    80004244:	f3d2                	sd	s4,480(sp)
    80004246:	efd6                	sd	s5,472(sp)
    80004248:	ebda                	sd	s6,464(sp)
    8000424a:	e7de                	sd	s7,456(sp)
    8000424c:	e3e2                	sd	s8,448(sp)
    8000424e:	ff66                	sd	s9,440(sp)
    80004250:	fb6a                	sd	s10,432(sp)
    80004252:	f76e                	sd	s11,424(sp)
    80004254:	0c00                	addi	s0,sp,528
    80004256:	84aa                	mv	s1,a0
    80004258:	dea43c23          	sd	a0,-520(s0)
    8000425c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004260:	ffffd097          	auipc	ra,0xffffd
    80004264:	dec080e7          	jalr	-532(ra) # 8000104c <myproc>
    80004268:	892a                	mv	s2,a0

  begin_op();
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	474080e7          	jalr	1140(ra) # 800036de <begin_op>

  if((ip = namei(path)) == 0){
    80004272:	8526                	mv	a0,s1
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	24e080e7          	jalr	590(ra) # 800034c2 <namei>
    8000427c:	c92d                	beqz	a0,800042ee <exec+0xbc>
    8000427e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	a9c080e7          	jalr	-1380(ra) # 80002d1c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004288:	04000713          	li	a4,64
    8000428c:	4681                	li	a3,0
    8000428e:	e5040613          	addi	a2,s0,-432
    80004292:	4581                	li	a1,0
    80004294:	8526                	mv	a0,s1
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	d3a080e7          	jalr	-710(ra) # 80002fd0 <readi>
    8000429e:	04000793          	li	a5,64
    800042a2:	00f51a63          	bne	a0,a5,800042b6 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042a6:	e5042703          	lw	a4,-432(s0)
    800042aa:	464c47b7          	lui	a5,0x464c4
    800042ae:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042b2:	04f70463          	beq	a4,a5,800042fa <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042b6:	8526                	mv	a0,s1
    800042b8:	fffff097          	auipc	ra,0xfffff
    800042bc:	cc6080e7          	jalr	-826(ra) # 80002f7e <iunlockput>
    end_op();
    800042c0:	fffff097          	auipc	ra,0xfffff
    800042c4:	49e080e7          	jalr	1182(ra) # 8000375e <end_op>
  }
  return -1;
    800042c8:	557d                	li	a0,-1
}
    800042ca:	20813083          	ld	ra,520(sp)
    800042ce:	20013403          	ld	s0,512(sp)
    800042d2:	74fe                	ld	s1,504(sp)
    800042d4:	795e                	ld	s2,496(sp)
    800042d6:	79be                	ld	s3,488(sp)
    800042d8:	7a1e                	ld	s4,480(sp)
    800042da:	6afe                	ld	s5,472(sp)
    800042dc:	6b5e                	ld	s6,464(sp)
    800042de:	6bbe                	ld	s7,456(sp)
    800042e0:	6c1e                	ld	s8,448(sp)
    800042e2:	7cfa                	ld	s9,440(sp)
    800042e4:	7d5a                	ld	s10,432(sp)
    800042e6:	7dba                	ld	s11,424(sp)
    800042e8:	21010113          	addi	sp,sp,528
    800042ec:	8082                	ret
    end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	470080e7          	jalr	1136(ra) # 8000375e <end_op>
    return -1;
    800042f6:	557d                	li	a0,-1
    800042f8:	bfc9                	j	800042ca <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042fa:	854a                	mv	a0,s2
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	e14080e7          	jalr	-492(ra) # 80001110 <proc_pagetable>
    80004304:	8baa                	mv	s7,a0
    80004306:	d945                	beqz	a0,800042b6 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004308:	e7042983          	lw	s3,-400(s0)
    8000430c:	e8845783          	lhu	a5,-376(s0)
    80004310:	c7ad                	beqz	a5,8000437a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004312:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004314:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004316:	6c85                	lui	s9,0x1
    80004318:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000431c:	def43823          	sd	a5,-528(s0)
    80004320:	ac0d                	j	80004552 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004322:	00004517          	auipc	a0,0x4
    80004326:	32e50513          	addi	a0,a0,814 # 80008650 <syscalls+0x280>
    8000432a:	00002097          	auipc	ra,0x2
    8000432e:	af8080e7          	jalr	-1288(ra) # 80005e22 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004332:	8756                	mv	a4,s5
    80004334:	012d86bb          	addw	a3,s11,s2
    80004338:	4581                	li	a1,0
    8000433a:	8526                	mv	a0,s1
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	c94080e7          	jalr	-876(ra) # 80002fd0 <readi>
    80004344:	2501                	sext.w	a0,a0
    80004346:	1aaa9a63          	bne	s5,a0,800044fa <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000434a:	6785                	lui	a5,0x1
    8000434c:	0127893b          	addw	s2,a5,s2
    80004350:	77fd                	lui	a5,0xfffff
    80004352:	01478a3b          	addw	s4,a5,s4
    80004356:	1f897563          	bgeu	s2,s8,80004540 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000435a:	02091593          	slli	a1,s2,0x20
    8000435e:	9181                	srli	a1,a1,0x20
    80004360:	95ea                	add	a1,a1,s10
    80004362:	855e                	mv	a0,s7
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	398080e7          	jalr	920(ra) # 800006fc <walkaddr>
    8000436c:	862a                	mv	a2,a0
    if(pa == 0)
    8000436e:	d955                	beqz	a0,80004322 <exec+0xf0>
      n = PGSIZE;
    80004370:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004372:	fd9a70e3          	bgeu	s4,s9,80004332 <exec+0x100>
      n = sz - i;
    80004376:	8ad2                	mv	s5,s4
    80004378:	bf6d                	j	80004332 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000437a:	4a01                	li	s4,0
  iunlockput(ip);
    8000437c:	8526                	mv	a0,s1
    8000437e:	fffff097          	auipc	ra,0xfffff
    80004382:	c00080e7          	jalr	-1024(ra) # 80002f7e <iunlockput>
  end_op();
    80004386:	fffff097          	auipc	ra,0xfffff
    8000438a:	3d8080e7          	jalr	984(ra) # 8000375e <end_op>
  p = myproc();
    8000438e:	ffffd097          	auipc	ra,0xffffd
    80004392:	cbe080e7          	jalr	-834(ra) # 8000104c <myproc>
    80004396:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004398:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000439c:	6785                	lui	a5,0x1
    8000439e:	17fd                	addi	a5,a5,-1
    800043a0:	9a3e                	add	s4,s4,a5
    800043a2:	757d                	lui	a0,0xfffff
    800043a4:	00aa77b3          	and	a5,s4,a0
    800043a8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043ac:	4691                	li	a3,4
    800043ae:	6609                	lui	a2,0x2
    800043b0:	963e                	add	a2,a2,a5
    800043b2:	85be                	mv	a1,a5
    800043b4:	855e                	mv	a0,s7
    800043b6:	ffffc097          	auipc	ra,0xffffc
    800043ba:	6fa080e7          	jalr	1786(ra) # 80000ab0 <uvmalloc>
    800043be:	8b2a                	mv	s6,a0
  ip = 0;
    800043c0:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043c2:	12050c63          	beqz	a0,800044fa <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043c6:	75f9                	lui	a1,0xffffe
    800043c8:	95aa                	add	a1,a1,a0
    800043ca:	855e                	mv	a0,s7
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	900080e7          	jalr	-1792(ra) # 80000ccc <uvmclear>
  stackbase = sp - PGSIZE;
    800043d4:	7c7d                	lui	s8,0xfffff
    800043d6:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043d8:	e0043783          	ld	a5,-512(s0)
    800043dc:	6388                	ld	a0,0(a5)
    800043de:	c535                	beqz	a0,8000444a <exec+0x218>
    800043e0:	e9040993          	addi	s3,s0,-368
    800043e4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043e8:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043ea:	ffffc097          	auipc	ra,0xffffc
    800043ee:	104080e7          	jalr	260(ra) # 800004ee <strlen>
    800043f2:	2505                	addiw	a0,a0,1
    800043f4:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043f8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043fc:	13896663          	bltu	s2,s8,80004528 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004400:	e0043d83          	ld	s11,-512(s0)
    80004404:	000dba03          	ld	s4,0(s11)
    80004408:	8552                	mv	a0,s4
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	0e4080e7          	jalr	228(ra) # 800004ee <strlen>
    80004412:	0015069b          	addiw	a3,a0,1
    80004416:	8652                	mv	a2,s4
    80004418:	85ca                	mv	a1,s2
    8000441a:	855e                	mv	a0,s7
    8000441c:	ffffd097          	auipc	ra,0xffffd
    80004420:	8e2080e7          	jalr	-1822(ra) # 80000cfe <copyout>
    80004424:	10054663          	bltz	a0,80004530 <exec+0x2fe>
    ustack[argc] = sp;
    80004428:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000442c:	0485                	addi	s1,s1,1
    8000442e:	008d8793          	addi	a5,s11,8
    80004432:	e0f43023          	sd	a5,-512(s0)
    80004436:	008db503          	ld	a0,8(s11)
    8000443a:	c911                	beqz	a0,8000444e <exec+0x21c>
    if(argc >= MAXARG)
    8000443c:	09a1                	addi	s3,s3,8
    8000443e:	fb3c96e3          	bne	s9,s3,800043ea <exec+0x1b8>
  sz = sz1;
    80004442:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004446:	4481                	li	s1,0
    80004448:	a84d                	j	800044fa <exec+0x2c8>
  sp = sz;
    8000444a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000444c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000444e:	00349793          	slli	a5,s1,0x3
    80004452:	f9040713          	addi	a4,s0,-112
    80004456:	97ba                	add	a5,a5,a4
    80004458:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000445c:	00148693          	addi	a3,s1,1
    80004460:	068e                	slli	a3,a3,0x3
    80004462:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004466:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000446a:	01897663          	bgeu	s2,s8,80004476 <exec+0x244>
  sz = sz1;
    8000446e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004472:	4481                	li	s1,0
    80004474:	a059                	j	800044fa <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004476:	e9040613          	addi	a2,s0,-368
    8000447a:	85ca                	mv	a1,s2
    8000447c:	855e                	mv	a0,s7
    8000447e:	ffffd097          	auipc	ra,0xffffd
    80004482:	880080e7          	jalr	-1920(ra) # 80000cfe <copyout>
    80004486:	0a054963          	bltz	a0,80004538 <exec+0x306>
  p->trapframe->a1 = sp;
    8000448a:	058ab783          	ld	a5,88(s5)
    8000448e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004492:	df843783          	ld	a5,-520(s0)
    80004496:	0007c703          	lbu	a4,0(a5)
    8000449a:	cf11                	beqz	a4,800044b6 <exec+0x284>
    8000449c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000449e:	02f00693          	li	a3,47
    800044a2:	a039                	j	800044b0 <exec+0x27e>
      last = s+1;
    800044a4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044a8:	0785                	addi	a5,a5,1
    800044aa:	fff7c703          	lbu	a4,-1(a5)
    800044ae:	c701                	beqz	a4,800044b6 <exec+0x284>
    if(*s == '/')
    800044b0:	fed71ce3          	bne	a4,a3,800044a8 <exec+0x276>
    800044b4:	bfc5                	j	800044a4 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800044b6:	4641                	li	a2,16
    800044b8:	df843583          	ld	a1,-520(s0)
    800044bc:	158a8513          	addi	a0,s5,344
    800044c0:	ffffc097          	auipc	ra,0xffffc
    800044c4:	ffc080e7          	jalr	-4(ra) # 800004bc <safestrcpy>
  oldpagetable = p->pagetable;
    800044c8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800044cc:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800044d0:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044d4:	058ab783          	ld	a5,88(s5)
    800044d8:	e6843703          	ld	a4,-408(s0)
    800044dc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044de:	058ab783          	ld	a5,88(s5)
    800044e2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044e6:	85ea                	mv	a1,s10
    800044e8:	ffffd097          	auipc	ra,0xffffd
    800044ec:	cc4080e7          	jalr	-828(ra) # 800011ac <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044f0:	0004851b          	sext.w	a0,s1
    800044f4:	bbd9                	j	800042ca <exec+0x98>
    800044f6:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044fa:	e0843583          	ld	a1,-504(s0)
    800044fe:	855e                	mv	a0,s7
    80004500:	ffffd097          	auipc	ra,0xffffd
    80004504:	cac080e7          	jalr	-852(ra) # 800011ac <proc_freepagetable>
  if(ip){
    80004508:	da0497e3          	bnez	s1,800042b6 <exec+0x84>
  return -1;
    8000450c:	557d                	li	a0,-1
    8000450e:	bb75                	j	800042ca <exec+0x98>
    80004510:	e1443423          	sd	s4,-504(s0)
    80004514:	b7dd                	j	800044fa <exec+0x2c8>
    80004516:	e1443423          	sd	s4,-504(s0)
    8000451a:	b7c5                	j	800044fa <exec+0x2c8>
    8000451c:	e1443423          	sd	s4,-504(s0)
    80004520:	bfe9                	j	800044fa <exec+0x2c8>
    80004522:	e1443423          	sd	s4,-504(s0)
    80004526:	bfd1                	j	800044fa <exec+0x2c8>
  sz = sz1;
    80004528:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000452c:	4481                	li	s1,0
    8000452e:	b7f1                	j	800044fa <exec+0x2c8>
  sz = sz1;
    80004530:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004534:	4481                	li	s1,0
    80004536:	b7d1                	j	800044fa <exec+0x2c8>
  sz = sz1;
    80004538:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000453c:	4481                	li	s1,0
    8000453e:	bf75                	j	800044fa <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004540:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004544:	2b05                	addiw	s6,s6,1
    80004546:	0389899b          	addiw	s3,s3,56
    8000454a:	e8845783          	lhu	a5,-376(s0)
    8000454e:	e2fb57e3          	bge	s6,a5,8000437c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004552:	2981                	sext.w	s3,s3
    80004554:	03800713          	li	a4,56
    80004558:	86ce                	mv	a3,s3
    8000455a:	e1840613          	addi	a2,s0,-488
    8000455e:	4581                	li	a1,0
    80004560:	8526                	mv	a0,s1
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	a6e080e7          	jalr	-1426(ra) # 80002fd0 <readi>
    8000456a:	03800793          	li	a5,56
    8000456e:	f8f514e3          	bne	a0,a5,800044f6 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004572:	e1842783          	lw	a5,-488(s0)
    80004576:	4705                	li	a4,1
    80004578:	fce796e3          	bne	a5,a4,80004544 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000457c:	e4043903          	ld	s2,-448(s0)
    80004580:	e3843783          	ld	a5,-456(s0)
    80004584:	f8f966e3          	bltu	s2,a5,80004510 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004588:	e2843783          	ld	a5,-472(s0)
    8000458c:	993e                	add	s2,s2,a5
    8000458e:	f8f964e3          	bltu	s2,a5,80004516 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004592:	df043703          	ld	a4,-528(s0)
    80004596:	8ff9                	and	a5,a5,a4
    80004598:	f3d1                	bnez	a5,8000451c <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000459a:	e1c42503          	lw	a0,-484(s0)
    8000459e:	00000097          	auipc	ra,0x0
    800045a2:	c78080e7          	jalr	-904(ra) # 80004216 <flags2perm>
    800045a6:	86aa                	mv	a3,a0
    800045a8:	864a                	mv	a2,s2
    800045aa:	85d2                	mv	a1,s4
    800045ac:	855e                	mv	a0,s7
    800045ae:	ffffc097          	auipc	ra,0xffffc
    800045b2:	502080e7          	jalr	1282(ra) # 80000ab0 <uvmalloc>
    800045b6:	e0a43423          	sd	a0,-504(s0)
    800045ba:	d525                	beqz	a0,80004522 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045bc:	e2843d03          	ld	s10,-472(s0)
    800045c0:	e2042d83          	lw	s11,-480(s0)
    800045c4:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045c8:	f60c0ce3          	beqz	s8,80004540 <exec+0x30e>
    800045cc:	8a62                	mv	s4,s8
    800045ce:	4901                	li	s2,0
    800045d0:	b369                	j	8000435a <exec+0x128>

00000000800045d2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045d2:	7179                	addi	sp,sp,-48
    800045d4:	f406                	sd	ra,40(sp)
    800045d6:	f022                	sd	s0,32(sp)
    800045d8:	ec26                	sd	s1,24(sp)
    800045da:	e84a                	sd	s2,16(sp)
    800045dc:	1800                	addi	s0,sp,48
    800045de:	892e                	mv	s2,a1
    800045e0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045e2:	fdc40593          	addi	a1,s0,-36
    800045e6:	ffffe097          	auipc	ra,0xffffe
    800045ea:	bbc080e7          	jalr	-1092(ra) # 800021a2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ee:	fdc42703          	lw	a4,-36(s0)
    800045f2:	47bd                	li	a5,15
    800045f4:	02e7eb63          	bltu	a5,a4,8000462a <argfd+0x58>
    800045f8:	ffffd097          	auipc	ra,0xffffd
    800045fc:	a54080e7          	jalr	-1452(ra) # 8000104c <myproc>
    80004600:	fdc42703          	lw	a4,-36(s0)
    80004604:	01a70793          	addi	a5,a4,26
    80004608:	078e                	slli	a5,a5,0x3
    8000460a:	953e                	add	a0,a0,a5
    8000460c:	611c                	ld	a5,0(a0)
    8000460e:	c385                	beqz	a5,8000462e <argfd+0x5c>
    return -1;
  if(pfd)
    80004610:	00090463          	beqz	s2,80004618 <argfd+0x46>
    *pfd = fd;
    80004614:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004618:	4501                	li	a0,0
  if(pf)
    8000461a:	c091                	beqz	s1,8000461e <argfd+0x4c>
    *pf = f;
    8000461c:	e09c                	sd	a5,0(s1)
}
    8000461e:	70a2                	ld	ra,40(sp)
    80004620:	7402                	ld	s0,32(sp)
    80004622:	64e2                	ld	s1,24(sp)
    80004624:	6942                	ld	s2,16(sp)
    80004626:	6145                	addi	sp,sp,48
    80004628:	8082                	ret
    return -1;
    8000462a:	557d                	li	a0,-1
    8000462c:	bfcd                	j	8000461e <argfd+0x4c>
    8000462e:	557d                	li	a0,-1
    80004630:	b7fd                	j	8000461e <argfd+0x4c>

0000000080004632 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004632:	1101                	addi	sp,sp,-32
    80004634:	ec06                	sd	ra,24(sp)
    80004636:	e822                	sd	s0,16(sp)
    80004638:	e426                	sd	s1,8(sp)
    8000463a:	1000                	addi	s0,sp,32
    8000463c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000463e:	ffffd097          	auipc	ra,0xffffd
    80004642:	a0e080e7          	jalr	-1522(ra) # 8000104c <myproc>
    80004646:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004648:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdbd3a0>
    8000464c:	4501                	li	a0,0
    8000464e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004650:	6398                	ld	a4,0(a5)
    80004652:	cb19                	beqz	a4,80004668 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004654:	2505                	addiw	a0,a0,1
    80004656:	07a1                	addi	a5,a5,8
    80004658:	fed51ce3          	bne	a0,a3,80004650 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000465c:	557d                	li	a0,-1
}
    8000465e:	60e2                	ld	ra,24(sp)
    80004660:	6442                	ld	s0,16(sp)
    80004662:	64a2                	ld	s1,8(sp)
    80004664:	6105                	addi	sp,sp,32
    80004666:	8082                	ret
      p->ofile[fd] = f;
    80004668:	01a50793          	addi	a5,a0,26
    8000466c:	078e                	slli	a5,a5,0x3
    8000466e:	963e                	add	a2,a2,a5
    80004670:	e204                	sd	s1,0(a2)
      return fd;
    80004672:	b7f5                	j	8000465e <fdalloc+0x2c>

0000000080004674 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004674:	715d                	addi	sp,sp,-80
    80004676:	e486                	sd	ra,72(sp)
    80004678:	e0a2                	sd	s0,64(sp)
    8000467a:	fc26                	sd	s1,56(sp)
    8000467c:	f84a                	sd	s2,48(sp)
    8000467e:	f44e                	sd	s3,40(sp)
    80004680:	f052                	sd	s4,32(sp)
    80004682:	ec56                	sd	s5,24(sp)
    80004684:	e85a                	sd	s6,16(sp)
    80004686:	0880                	addi	s0,sp,80
    80004688:	8b2e                	mv	s6,a1
    8000468a:	89b2                	mv	s3,a2
    8000468c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000468e:	fb040593          	addi	a1,s0,-80
    80004692:	fffff097          	auipc	ra,0xfffff
    80004696:	e4e080e7          	jalr	-434(ra) # 800034e0 <nameiparent>
    8000469a:	84aa                	mv	s1,a0
    8000469c:	16050063          	beqz	a0,800047fc <create+0x188>
    return 0;

  ilock(dp);
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	67c080e7          	jalr	1660(ra) # 80002d1c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046a8:	4601                	li	a2,0
    800046aa:	fb040593          	addi	a1,s0,-80
    800046ae:	8526                	mv	a0,s1
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	b50080e7          	jalr	-1200(ra) # 80003200 <dirlookup>
    800046b8:	8aaa                	mv	s5,a0
    800046ba:	c931                	beqz	a0,8000470e <create+0x9a>
    iunlockput(dp);
    800046bc:	8526                	mv	a0,s1
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	8c0080e7          	jalr	-1856(ra) # 80002f7e <iunlockput>
    ilock(ip);
    800046c6:	8556                	mv	a0,s5
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	654080e7          	jalr	1620(ra) # 80002d1c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046d0:	000b059b          	sext.w	a1,s6
    800046d4:	4789                	li	a5,2
    800046d6:	02f59563          	bne	a1,a5,80004700 <create+0x8c>
    800046da:	044ad783          	lhu	a5,68(s5)
    800046de:	37f9                	addiw	a5,a5,-2
    800046e0:	17c2                	slli	a5,a5,0x30
    800046e2:	93c1                	srli	a5,a5,0x30
    800046e4:	4705                	li	a4,1
    800046e6:	00f76d63          	bltu	a4,a5,80004700 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046ea:	8556                	mv	a0,s5
    800046ec:	60a6                	ld	ra,72(sp)
    800046ee:	6406                	ld	s0,64(sp)
    800046f0:	74e2                	ld	s1,56(sp)
    800046f2:	7942                	ld	s2,48(sp)
    800046f4:	79a2                	ld	s3,40(sp)
    800046f6:	7a02                	ld	s4,32(sp)
    800046f8:	6ae2                	ld	s5,24(sp)
    800046fa:	6b42                	ld	s6,16(sp)
    800046fc:	6161                	addi	sp,sp,80
    800046fe:	8082                	ret
    iunlockput(ip);
    80004700:	8556                	mv	a0,s5
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	87c080e7          	jalr	-1924(ra) # 80002f7e <iunlockput>
    return 0;
    8000470a:	4a81                	li	s5,0
    8000470c:	bff9                	j	800046ea <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000470e:	85da                	mv	a1,s6
    80004710:	4088                	lw	a0,0(s1)
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	46e080e7          	jalr	1134(ra) # 80002b80 <ialloc>
    8000471a:	8a2a                	mv	s4,a0
    8000471c:	c921                	beqz	a0,8000476c <create+0xf8>
  ilock(ip);
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	5fe080e7          	jalr	1534(ra) # 80002d1c <ilock>
  ip->major = major;
    80004726:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000472a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000472e:	4785                	li	a5,1
    80004730:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004734:	8552                	mv	a0,s4
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	51c080e7          	jalr	1308(ra) # 80002c52 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000473e:	000b059b          	sext.w	a1,s6
    80004742:	4785                	li	a5,1
    80004744:	02f58b63          	beq	a1,a5,8000477a <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004748:	004a2603          	lw	a2,4(s4)
    8000474c:	fb040593          	addi	a1,s0,-80
    80004750:	8526                	mv	a0,s1
    80004752:	fffff097          	auipc	ra,0xfffff
    80004756:	cbe080e7          	jalr	-834(ra) # 80003410 <dirlink>
    8000475a:	06054f63          	bltz	a0,800047d8 <create+0x164>
  iunlockput(dp);
    8000475e:	8526                	mv	a0,s1
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	81e080e7          	jalr	-2018(ra) # 80002f7e <iunlockput>
  return ip;
    80004768:	8ad2                	mv	s5,s4
    8000476a:	b741                	j	800046ea <create+0x76>
    iunlockput(dp);
    8000476c:	8526                	mv	a0,s1
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	810080e7          	jalr	-2032(ra) # 80002f7e <iunlockput>
    return 0;
    80004776:	8ad2                	mv	s5,s4
    80004778:	bf8d                	j	800046ea <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000477a:	004a2603          	lw	a2,4(s4)
    8000477e:	00004597          	auipc	a1,0x4
    80004782:	ef258593          	addi	a1,a1,-270 # 80008670 <syscalls+0x2a0>
    80004786:	8552                	mv	a0,s4
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	c88080e7          	jalr	-888(ra) # 80003410 <dirlink>
    80004790:	04054463          	bltz	a0,800047d8 <create+0x164>
    80004794:	40d0                	lw	a2,4(s1)
    80004796:	00004597          	auipc	a1,0x4
    8000479a:	ee258593          	addi	a1,a1,-286 # 80008678 <syscalls+0x2a8>
    8000479e:	8552                	mv	a0,s4
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	c70080e7          	jalr	-912(ra) # 80003410 <dirlink>
    800047a8:	02054863          	bltz	a0,800047d8 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800047ac:	004a2603          	lw	a2,4(s4)
    800047b0:	fb040593          	addi	a1,s0,-80
    800047b4:	8526                	mv	a0,s1
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	c5a080e7          	jalr	-934(ra) # 80003410 <dirlink>
    800047be:	00054d63          	bltz	a0,800047d8 <create+0x164>
    dp->nlink++;  // for ".."
    800047c2:	04a4d783          	lhu	a5,74(s1)
    800047c6:	2785                	addiw	a5,a5,1
    800047c8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047cc:	8526                	mv	a0,s1
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	484080e7          	jalr	1156(ra) # 80002c52 <iupdate>
    800047d6:	b761                	j	8000475e <create+0xea>
  ip->nlink = 0;
    800047d8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047dc:	8552                	mv	a0,s4
    800047de:	ffffe097          	auipc	ra,0xffffe
    800047e2:	474080e7          	jalr	1140(ra) # 80002c52 <iupdate>
  iunlockput(ip);
    800047e6:	8552                	mv	a0,s4
    800047e8:	ffffe097          	auipc	ra,0xffffe
    800047ec:	796080e7          	jalr	1942(ra) # 80002f7e <iunlockput>
  iunlockput(dp);
    800047f0:	8526                	mv	a0,s1
    800047f2:	ffffe097          	auipc	ra,0xffffe
    800047f6:	78c080e7          	jalr	1932(ra) # 80002f7e <iunlockput>
  return 0;
    800047fa:	bdc5                	j	800046ea <create+0x76>
    return 0;
    800047fc:	8aaa                	mv	s5,a0
    800047fe:	b5f5                	j	800046ea <create+0x76>

0000000080004800 <sys_dup>:
{
    80004800:	7179                	addi	sp,sp,-48
    80004802:	f406                	sd	ra,40(sp)
    80004804:	f022                	sd	s0,32(sp)
    80004806:	ec26                	sd	s1,24(sp)
    80004808:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000480a:	fd840613          	addi	a2,s0,-40
    8000480e:	4581                	li	a1,0
    80004810:	4501                	li	a0,0
    80004812:	00000097          	auipc	ra,0x0
    80004816:	dc0080e7          	jalr	-576(ra) # 800045d2 <argfd>
    return -1;
    8000481a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000481c:	02054363          	bltz	a0,80004842 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004820:	fd843503          	ld	a0,-40(s0)
    80004824:	00000097          	auipc	ra,0x0
    80004828:	e0e080e7          	jalr	-498(ra) # 80004632 <fdalloc>
    8000482c:	84aa                	mv	s1,a0
    return -1;
    8000482e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004830:	00054963          	bltz	a0,80004842 <sys_dup+0x42>
  filedup(f);
    80004834:	fd843503          	ld	a0,-40(s0)
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	320080e7          	jalr	800(ra) # 80003b58 <filedup>
  return fd;
    80004840:	87a6                	mv	a5,s1
}
    80004842:	853e                	mv	a0,a5
    80004844:	70a2                	ld	ra,40(sp)
    80004846:	7402                	ld	s0,32(sp)
    80004848:	64e2                	ld	s1,24(sp)
    8000484a:	6145                	addi	sp,sp,48
    8000484c:	8082                	ret

000000008000484e <sys_read>:
{
    8000484e:	7179                	addi	sp,sp,-48
    80004850:	f406                	sd	ra,40(sp)
    80004852:	f022                	sd	s0,32(sp)
    80004854:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004856:	fd840593          	addi	a1,s0,-40
    8000485a:	4505                	li	a0,1
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	966080e7          	jalr	-1690(ra) # 800021c2 <argaddr>
  argint(2, &n);
    80004864:	fe440593          	addi	a1,s0,-28
    80004868:	4509                	li	a0,2
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	938080e7          	jalr	-1736(ra) # 800021a2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004872:	fe840613          	addi	a2,s0,-24
    80004876:	4581                	li	a1,0
    80004878:	4501                	li	a0,0
    8000487a:	00000097          	auipc	ra,0x0
    8000487e:	d58080e7          	jalr	-680(ra) # 800045d2 <argfd>
    80004882:	87aa                	mv	a5,a0
    return -1;
    80004884:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004886:	0007cc63          	bltz	a5,8000489e <sys_read+0x50>
  return fileread(f, p, n);
    8000488a:	fe442603          	lw	a2,-28(s0)
    8000488e:	fd843583          	ld	a1,-40(s0)
    80004892:	fe843503          	ld	a0,-24(s0)
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	44e080e7          	jalr	1102(ra) # 80003ce4 <fileread>
}
    8000489e:	70a2                	ld	ra,40(sp)
    800048a0:	7402                	ld	s0,32(sp)
    800048a2:	6145                	addi	sp,sp,48
    800048a4:	8082                	ret

00000000800048a6 <sys_write>:
{
    800048a6:	7179                	addi	sp,sp,-48
    800048a8:	f406                	sd	ra,40(sp)
    800048aa:	f022                	sd	s0,32(sp)
    800048ac:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048ae:	fd840593          	addi	a1,s0,-40
    800048b2:	4505                	li	a0,1
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	90e080e7          	jalr	-1778(ra) # 800021c2 <argaddr>
  argint(2, &n);
    800048bc:	fe440593          	addi	a1,s0,-28
    800048c0:	4509                	li	a0,2
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	8e0080e7          	jalr	-1824(ra) # 800021a2 <argint>
  if(argfd(0, 0, &f) < 0)
    800048ca:	fe840613          	addi	a2,s0,-24
    800048ce:	4581                	li	a1,0
    800048d0:	4501                	li	a0,0
    800048d2:	00000097          	auipc	ra,0x0
    800048d6:	d00080e7          	jalr	-768(ra) # 800045d2 <argfd>
    800048da:	87aa                	mv	a5,a0
    return -1;
    800048dc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048de:	0007cc63          	bltz	a5,800048f6 <sys_write+0x50>
  return filewrite(f, p, n);
    800048e2:	fe442603          	lw	a2,-28(s0)
    800048e6:	fd843583          	ld	a1,-40(s0)
    800048ea:	fe843503          	ld	a0,-24(s0)
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	4b8080e7          	jalr	1208(ra) # 80003da6 <filewrite>
}
    800048f6:	70a2                	ld	ra,40(sp)
    800048f8:	7402                	ld	s0,32(sp)
    800048fa:	6145                	addi	sp,sp,48
    800048fc:	8082                	ret

00000000800048fe <sys_close>:
{
    800048fe:	1101                	addi	sp,sp,-32
    80004900:	ec06                	sd	ra,24(sp)
    80004902:	e822                	sd	s0,16(sp)
    80004904:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004906:	fe040613          	addi	a2,s0,-32
    8000490a:	fec40593          	addi	a1,s0,-20
    8000490e:	4501                	li	a0,0
    80004910:	00000097          	auipc	ra,0x0
    80004914:	cc2080e7          	jalr	-830(ra) # 800045d2 <argfd>
    return -1;
    80004918:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000491a:	02054463          	bltz	a0,80004942 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000491e:	ffffc097          	auipc	ra,0xffffc
    80004922:	72e080e7          	jalr	1838(ra) # 8000104c <myproc>
    80004926:	fec42783          	lw	a5,-20(s0)
    8000492a:	07e9                	addi	a5,a5,26
    8000492c:	078e                	slli	a5,a5,0x3
    8000492e:	97aa                	add	a5,a5,a0
    80004930:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004934:	fe043503          	ld	a0,-32(s0)
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	272080e7          	jalr	626(ra) # 80003baa <fileclose>
  return 0;
    80004940:	4781                	li	a5,0
}
    80004942:	853e                	mv	a0,a5
    80004944:	60e2                	ld	ra,24(sp)
    80004946:	6442                	ld	s0,16(sp)
    80004948:	6105                	addi	sp,sp,32
    8000494a:	8082                	ret

000000008000494c <sys_fstat>:
{
    8000494c:	1101                	addi	sp,sp,-32
    8000494e:	ec06                	sd	ra,24(sp)
    80004950:	e822                	sd	s0,16(sp)
    80004952:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004954:	fe040593          	addi	a1,s0,-32
    80004958:	4505                	li	a0,1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	868080e7          	jalr	-1944(ra) # 800021c2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004962:	fe840613          	addi	a2,s0,-24
    80004966:	4581                	li	a1,0
    80004968:	4501                	li	a0,0
    8000496a:	00000097          	auipc	ra,0x0
    8000496e:	c68080e7          	jalr	-920(ra) # 800045d2 <argfd>
    80004972:	87aa                	mv	a5,a0
    return -1;
    80004974:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004976:	0007ca63          	bltz	a5,8000498a <sys_fstat+0x3e>
  return filestat(f, st);
    8000497a:	fe043583          	ld	a1,-32(s0)
    8000497e:	fe843503          	ld	a0,-24(s0)
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	2f0080e7          	jalr	752(ra) # 80003c72 <filestat>
}
    8000498a:	60e2                	ld	ra,24(sp)
    8000498c:	6442                	ld	s0,16(sp)
    8000498e:	6105                	addi	sp,sp,32
    80004990:	8082                	ret

0000000080004992 <sys_link>:
{
    80004992:	7169                	addi	sp,sp,-304
    80004994:	f606                	sd	ra,296(sp)
    80004996:	f222                	sd	s0,288(sp)
    80004998:	ee26                	sd	s1,280(sp)
    8000499a:	ea4a                	sd	s2,272(sp)
    8000499c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499e:	08000613          	li	a2,128
    800049a2:	ed040593          	addi	a1,s0,-304
    800049a6:	4501                	li	a0,0
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	83a080e7          	jalr	-1990(ra) # 800021e2 <argstr>
    return -1;
    800049b0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049b2:	10054e63          	bltz	a0,80004ace <sys_link+0x13c>
    800049b6:	08000613          	li	a2,128
    800049ba:	f5040593          	addi	a1,s0,-176
    800049be:	4505                	li	a0,1
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	822080e7          	jalr	-2014(ra) # 800021e2 <argstr>
    return -1;
    800049c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ca:	10054263          	bltz	a0,80004ace <sys_link+0x13c>
  begin_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	d10080e7          	jalr	-752(ra) # 800036de <begin_op>
  if((ip = namei(old)) == 0){
    800049d6:	ed040513          	addi	a0,s0,-304
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	ae8080e7          	jalr	-1304(ra) # 800034c2 <namei>
    800049e2:	84aa                	mv	s1,a0
    800049e4:	c551                	beqz	a0,80004a70 <sys_link+0xde>
  ilock(ip);
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	336080e7          	jalr	822(ra) # 80002d1c <ilock>
  if(ip->type == T_DIR){
    800049ee:	04449703          	lh	a4,68(s1)
    800049f2:	4785                	li	a5,1
    800049f4:	08f70463          	beq	a4,a5,80004a7c <sys_link+0xea>
  ip->nlink++;
    800049f8:	04a4d783          	lhu	a5,74(s1)
    800049fc:	2785                	addiw	a5,a5,1
    800049fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	24e080e7          	jalr	590(ra) # 80002c52 <iupdate>
  iunlock(ip);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	3d0080e7          	jalr	976(ra) # 80002dde <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a16:	fd040593          	addi	a1,s0,-48
    80004a1a:	f5040513          	addi	a0,s0,-176
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	ac2080e7          	jalr	-1342(ra) # 800034e0 <nameiparent>
    80004a26:	892a                	mv	s2,a0
    80004a28:	c935                	beqz	a0,80004a9c <sys_link+0x10a>
  ilock(dp);
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	2f2080e7          	jalr	754(ra) # 80002d1c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a32:	00092703          	lw	a4,0(s2)
    80004a36:	409c                	lw	a5,0(s1)
    80004a38:	04f71d63          	bne	a4,a5,80004a92 <sys_link+0x100>
    80004a3c:	40d0                	lw	a2,4(s1)
    80004a3e:	fd040593          	addi	a1,s0,-48
    80004a42:	854a                	mv	a0,s2
    80004a44:	fffff097          	auipc	ra,0xfffff
    80004a48:	9cc080e7          	jalr	-1588(ra) # 80003410 <dirlink>
    80004a4c:	04054363          	bltz	a0,80004a92 <sys_link+0x100>
  iunlockput(dp);
    80004a50:	854a                	mv	a0,s2
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	52c080e7          	jalr	1324(ra) # 80002f7e <iunlockput>
  iput(ip);
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	47a080e7          	jalr	1146(ra) # 80002ed6 <iput>
  end_op();
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	cfa080e7          	jalr	-774(ra) # 8000375e <end_op>
  return 0;
    80004a6c:	4781                	li	a5,0
    80004a6e:	a085                	j	80004ace <sys_link+0x13c>
    end_op();
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	cee080e7          	jalr	-786(ra) # 8000375e <end_op>
    return -1;
    80004a78:	57fd                	li	a5,-1
    80004a7a:	a891                	j	80004ace <sys_link+0x13c>
    iunlockput(ip);
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	500080e7          	jalr	1280(ra) # 80002f7e <iunlockput>
    end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	cd8080e7          	jalr	-808(ra) # 8000375e <end_op>
    return -1;
    80004a8e:	57fd                	li	a5,-1
    80004a90:	a83d                	j	80004ace <sys_link+0x13c>
    iunlockput(dp);
    80004a92:	854a                	mv	a0,s2
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	4ea080e7          	jalr	1258(ra) # 80002f7e <iunlockput>
  ilock(ip);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	27e080e7          	jalr	638(ra) # 80002d1c <ilock>
  ip->nlink--;
    80004aa6:	04a4d783          	lhu	a5,74(s1)
    80004aaa:	37fd                	addiw	a5,a5,-1
    80004aac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	1a0080e7          	jalr	416(ra) # 80002c52 <iupdate>
  iunlockput(ip);
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	4c2080e7          	jalr	1218(ra) # 80002f7e <iunlockput>
  end_op();
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	c9a080e7          	jalr	-870(ra) # 8000375e <end_op>
  return -1;
    80004acc:	57fd                	li	a5,-1
}
    80004ace:	853e                	mv	a0,a5
    80004ad0:	70b2                	ld	ra,296(sp)
    80004ad2:	7412                	ld	s0,288(sp)
    80004ad4:	64f2                	ld	s1,280(sp)
    80004ad6:	6952                	ld	s2,272(sp)
    80004ad8:	6155                	addi	sp,sp,304
    80004ada:	8082                	ret

0000000080004adc <sys_unlink>:
{
    80004adc:	7151                	addi	sp,sp,-240
    80004ade:	f586                	sd	ra,232(sp)
    80004ae0:	f1a2                	sd	s0,224(sp)
    80004ae2:	eda6                	sd	s1,216(sp)
    80004ae4:	e9ca                	sd	s2,208(sp)
    80004ae6:	e5ce                	sd	s3,200(sp)
    80004ae8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aea:	08000613          	li	a2,128
    80004aee:	f3040593          	addi	a1,s0,-208
    80004af2:	4501                	li	a0,0
    80004af4:	ffffd097          	auipc	ra,0xffffd
    80004af8:	6ee080e7          	jalr	1774(ra) # 800021e2 <argstr>
    80004afc:	18054163          	bltz	a0,80004c7e <sys_unlink+0x1a2>
  begin_op();
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	bde080e7          	jalr	-1058(ra) # 800036de <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b08:	fb040593          	addi	a1,s0,-80
    80004b0c:	f3040513          	addi	a0,s0,-208
    80004b10:	fffff097          	auipc	ra,0xfffff
    80004b14:	9d0080e7          	jalr	-1584(ra) # 800034e0 <nameiparent>
    80004b18:	84aa                	mv	s1,a0
    80004b1a:	c979                	beqz	a0,80004bf0 <sys_unlink+0x114>
  ilock(dp);
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	200080e7          	jalr	512(ra) # 80002d1c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b24:	00004597          	auipc	a1,0x4
    80004b28:	b4c58593          	addi	a1,a1,-1204 # 80008670 <syscalls+0x2a0>
    80004b2c:	fb040513          	addi	a0,s0,-80
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	6b6080e7          	jalr	1718(ra) # 800031e6 <namecmp>
    80004b38:	14050a63          	beqz	a0,80004c8c <sys_unlink+0x1b0>
    80004b3c:	00004597          	auipc	a1,0x4
    80004b40:	b3c58593          	addi	a1,a1,-1220 # 80008678 <syscalls+0x2a8>
    80004b44:	fb040513          	addi	a0,s0,-80
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	69e080e7          	jalr	1694(ra) # 800031e6 <namecmp>
    80004b50:	12050e63          	beqz	a0,80004c8c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b54:	f2c40613          	addi	a2,s0,-212
    80004b58:	fb040593          	addi	a1,s0,-80
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	6a2080e7          	jalr	1698(ra) # 80003200 <dirlookup>
    80004b66:	892a                	mv	s2,a0
    80004b68:	12050263          	beqz	a0,80004c8c <sys_unlink+0x1b0>
  ilock(ip);
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	1b0080e7          	jalr	432(ra) # 80002d1c <ilock>
  if(ip->nlink < 1)
    80004b74:	04a91783          	lh	a5,74(s2)
    80004b78:	08f05263          	blez	a5,80004bfc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b7c:	04491703          	lh	a4,68(s2)
    80004b80:	4785                	li	a5,1
    80004b82:	08f70563          	beq	a4,a5,80004c0c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b86:	4641                	li	a2,16
    80004b88:	4581                	li	a1,0
    80004b8a:	fc040513          	addi	a0,s0,-64
    80004b8e:	ffffb097          	auipc	ra,0xffffb
    80004b92:	7dc080e7          	jalr	2012(ra) # 8000036a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b96:	4741                	li	a4,16
    80004b98:	f2c42683          	lw	a3,-212(s0)
    80004b9c:	fc040613          	addi	a2,s0,-64
    80004ba0:	4581                	li	a1,0
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	524080e7          	jalr	1316(ra) # 800030c8 <writei>
    80004bac:	47c1                	li	a5,16
    80004bae:	0af51563          	bne	a0,a5,80004c58 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bb2:	04491703          	lh	a4,68(s2)
    80004bb6:	4785                	li	a5,1
    80004bb8:	0af70863          	beq	a4,a5,80004c68 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	3c0080e7          	jalr	960(ra) # 80002f7e <iunlockput>
  ip->nlink--;
    80004bc6:	04a95783          	lhu	a5,74(s2)
    80004bca:	37fd                	addiw	a5,a5,-1
    80004bcc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bd0:	854a                	mv	a0,s2
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	080080e7          	jalr	128(ra) # 80002c52 <iupdate>
  iunlockput(ip);
    80004bda:	854a                	mv	a0,s2
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	3a2080e7          	jalr	930(ra) # 80002f7e <iunlockput>
  end_op();
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	b7a080e7          	jalr	-1158(ra) # 8000375e <end_op>
  return 0;
    80004bec:	4501                	li	a0,0
    80004bee:	a84d                	j	80004ca0 <sys_unlink+0x1c4>
    end_op();
    80004bf0:	fffff097          	auipc	ra,0xfffff
    80004bf4:	b6e080e7          	jalr	-1170(ra) # 8000375e <end_op>
    return -1;
    80004bf8:	557d                	li	a0,-1
    80004bfa:	a05d                	j	80004ca0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bfc:	00004517          	auipc	a0,0x4
    80004c00:	a8450513          	addi	a0,a0,-1404 # 80008680 <syscalls+0x2b0>
    80004c04:	00001097          	auipc	ra,0x1
    80004c08:	21e080e7          	jalr	542(ra) # 80005e22 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c0c:	04c92703          	lw	a4,76(s2)
    80004c10:	02000793          	li	a5,32
    80004c14:	f6e7f9e3          	bgeu	a5,a4,80004b86 <sys_unlink+0xaa>
    80004c18:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c1c:	4741                	li	a4,16
    80004c1e:	86ce                	mv	a3,s3
    80004c20:	f1840613          	addi	a2,s0,-232
    80004c24:	4581                	li	a1,0
    80004c26:	854a                	mv	a0,s2
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	3a8080e7          	jalr	936(ra) # 80002fd0 <readi>
    80004c30:	47c1                	li	a5,16
    80004c32:	00f51b63          	bne	a0,a5,80004c48 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c36:	f1845783          	lhu	a5,-232(s0)
    80004c3a:	e7a1                	bnez	a5,80004c82 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c3c:	29c1                	addiw	s3,s3,16
    80004c3e:	04c92783          	lw	a5,76(s2)
    80004c42:	fcf9ede3          	bltu	s3,a5,80004c1c <sys_unlink+0x140>
    80004c46:	b781                	j	80004b86 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c48:	00004517          	auipc	a0,0x4
    80004c4c:	a5050513          	addi	a0,a0,-1456 # 80008698 <syscalls+0x2c8>
    80004c50:	00001097          	auipc	ra,0x1
    80004c54:	1d2080e7          	jalr	466(ra) # 80005e22 <panic>
    panic("unlink: writei");
    80004c58:	00004517          	auipc	a0,0x4
    80004c5c:	a5850513          	addi	a0,a0,-1448 # 800086b0 <syscalls+0x2e0>
    80004c60:	00001097          	auipc	ra,0x1
    80004c64:	1c2080e7          	jalr	450(ra) # 80005e22 <panic>
    dp->nlink--;
    80004c68:	04a4d783          	lhu	a5,74(s1)
    80004c6c:	37fd                	addiw	a5,a5,-1
    80004c6e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c72:	8526                	mv	a0,s1
    80004c74:	ffffe097          	auipc	ra,0xffffe
    80004c78:	fde080e7          	jalr	-34(ra) # 80002c52 <iupdate>
    80004c7c:	b781                	j	80004bbc <sys_unlink+0xe0>
    return -1;
    80004c7e:	557d                	li	a0,-1
    80004c80:	a005                	j	80004ca0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c82:	854a                	mv	a0,s2
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	2fa080e7          	jalr	762(ra) # 80002f7e <iunlockput>
  iunlockput(dp);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	ffffe097          	auipc	ra,0xffffe
    80004c92:	2f0080e7          	jalr	752(ra) # 80002f7e <iunlockput>
  end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	ac8080e7          	jalr	-1336(ra) # 8000375e <end_op>
  return -1;
    80004c9e:	557d                	li	a0,-1
}
    80004ca0:	70ae                	ld	ra,232(sp)
    80004ca2:	740e                	ld	s0,224(sp)
    80004ca4:	64ee                	ld	s1,216(sp)
    80004ca6:	694e                	ld	s2,208(sp)
    80004ca8:	69ae                	ld	s3,200(sp)
    80004caa:	616d                	addi	sp,sp,240
    80004cac:	8082                	ret

0000000080004cae <sys_open>:

uint64
sys_open(void)
{
    80004cae:	7131                	addi	sp,sp,-192
    80004cb0:	fd06                	sd	ra,184(sp)
    80004cb2:	f922                	sd	s0,176(sp)
    80004cb4:	f526                	sd	s1,168(sp)
    80004cb6:	f14a                	sd	s2,160(sp)
    80004cb8:	ed4e                	sd	s3,152(sp)
    80004cba:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cbc:	f4c40593          	addi	a1,s0,-180
    80004cc0:	4505                	li	a0,1
    80004cc2:	ffffd097          	auipc	ra,0xffffd
    80004cc6:	4e0080e7          	jalr	1248(ra) # 800021a2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cca:	08000613          	li	a2,128
    80004cce:	f5040593          	addi	a1,s0,-176
    80004cd2:	4501                	li	a0,0
    80004cd4:	ffffd097          	auipc	ra,0xffffd
    80004cd8:	50e080e7          	jalr	1294(ra) # 800021e2 <argstr>
    80004cdc:	87aa                	mv	a5,a0
    return -1;
    80004cde:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ce0:	0a07c963          	bltz	a5,80004d92 <sys_open+0xe4>

  begin_op();
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	9fa080e7          	jalr	-1542(ra) # 800036de <begin_op>

  if(omode & O_CREATE){
    80004cec:	f4c42783          	lw	a5,-180(s0)
    80004cf0:	2007f793          	andi	a5,a5,512
    80004cf4:	cfc5                	beqz	a5,80004dac <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cf6:	4681                	li	a3,0
    80004cf8:	4601                	li	a2,0
    80004cfa:	4589                	li	a1,2
    80004cfc:	f5040513          	addi	a0,s0,-176
    80004d00:	00000097          	auipc	ra,0x0
    80004d04:	974080e7          	jalr	-1676(ra) # 80004674 <create>
    80004d08:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d0a:	c959                	beqz	a0,80004da0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d0c:	04449703          	lh	a4,68(s1)
    80004d10:	478d                	li	a5,3
    80004d12:	00f71763          	bne	a4,a5,80004d20 <sys_open+0x72>
    80004d16:	0464d703          	lhu	a4,70(s1)
    80004d1a:	47a5                	li	a5,9
    80004d1c:	0ce7ed63          	bltu	a5,a4,80004df6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	dce080e7          	jalr	-562(ra) # 80003aee <filealloc>
    80004d28:	89aa                	mv	s3,a0
    80004d2a:	10050363          	beqz	a0,80004e30 <sys_open+0x182>
    80004d2e:	00000097          	auipc	ra,0x0
    80004d32:	904080e7          	jalr	-1788(ra) # 80004632 <fdalloc>
    80004d36:	892a                	mv	s2,a0
    80004d38:	0e054763          	bltz	a0,80004e26 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d3c:	04449703          	lh	a4,68(s1)
    80004d40:	478d                	li	a5,3
    80004d42:	0cf70563          	beq	a4,a5,80004e0c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d46:	4789                	li	a5,2
    80004d48:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d4c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d50:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d54:	f4c42783          	lw	a5,-180(s0)
    80004d58:	0017c713          	xori	a4,a5,1
    80004d5c:	8b05                	andi	a4,a4,1
    80004d5e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d62:	0037f713          	andi	a4,a5,3
    80004d66:	00e03733          	snez	a4,a4
    80004d6a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d6e:	4007f793          	andi	a5,a5,1024
    80004d72:	c791                	beqz	a5,80004d7e <sys_open+0xd0>
    80004d74:	04449703          	lh	a4,68(s1)
    80004d78:	4789                	li	a5,2
    80004d7a:	0af70063          	beq	a4,a5,80004e1a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	05e080e7          	jalr	94(ra) # 80002dde <iunlock>
  end_op();
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	9d6080e7          	jalr	-1578(ra) # 8000375e <end_op>

  return fd;
    80004d90:	854a                	mv	a0,s2
}
    80004d92:	70ea                	ld	ra,184(sp)
    80004d94:	744a                	ld	s0,176(sp)
    80004d96:	74aa                	ld	s1,168(sp)
    80004d98:	790a                	ld	s2,160(sp)
    80004d9a:	69ea                	ld	s3,152(sp)
    80004d9c:	6129                	addi	sp,sp,192
    80004d9e:	8082                	ret
      end_op();
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	9be080e7          	jalr	-1602(ra) # 8000375e <end_op>
      return -1;
    80004da8:	557d                	li	a0,-1
    80004daa:	b7e5                	j	80004d92 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dac:	f5040513          	addi	a0,s0,-176
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	712080e7          	jalr	1810(ra) # 800034c2 <namei>
    80004db8:	84aa                	mv	s1,a0
    80004dba:	c905                	beqz	a0,80004dea <sys_open+0x13c>
    ilock(ip);
    80004dbc:	ffffe097          	auipc	ra,0xffffe
    80004dc0:	f60080e7          	jalr	-160(ra) # 80002d1c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dc4:	04449703          	lh	a4,68(s1)
    80004dc8:	4785                	li	a5,1
    80004dca:	f4f711e3          	bne	a4,a5,80004d0c <sys_open+0x5e>
    80004dce:	f4c42783          	lw	a5,-180(s0)
    80004dd2:	d7b9                	beqz	a5,80004d20 <sys_open+0x72>
      iunlockput(ip);
    80004dd4:	8526                	mv	a0,s1
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	1a8080e7          	jalr	424(ra) # 80002f7e <iunlockput>
      end_op();
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	980080e7          	jalr	-1664(ra) # 8000375e <end_op>
      return -1;
    80004de6:	557d                	li	a0,-1
    80004de8:	b76d                	j	80004d92 <sys_open+0xe4>
      end_op();
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	974080e7          	jalr	-1676(ra) # 8000375e <end_op>
      return -1;
    80004df2:	557d                	li	a0,-1
    80004df4:	bf79                	j	80004d92 <sys_open+0xe4>
    iunlockput(ip);
    80004df6:	8526                	mv	a0,s1
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	186080e7          	jalr	390(ra) # 80002f7e <iunlockput>
    end_op();
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	95e080e7          	jalr	-1698(ra) # 8000375e <end_op>
    return -1;
    80004e08:	557d                	li	a0,-1
    80004e0a:	b761                	j	80004d92 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e0c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e10:	04649783          	lh	a5,70(s1)
    80004e14:	02f99223          	sh	a5,36(s3)
    80004e18:	bf25                	j	80004d50 <sys_open+0xa2>
    itrunc(ip);
    80004e1a:	8526                	mv	a0,s1
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	00e080e7          	jalr	14(ra) # 80002e2a <itrunc>
    80004e24:	bfa9                	j	80004d7e <sys_open+0xd0>
      fileclose(f);
    80004e26:	854e                	mv	a0,s3
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	d82080e7          	jalr	-638(ra) # 80003baa <fileclose>
    iunlockput(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	14c080e7          	jalr	332(ra) # 80002f7e <iunlockput>
    end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	924080e7          	jalr	-1756(ra) # 8000375e <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	b7b9                	j	80004d92 <sys_open+0xe4>

0000000080004e46 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e46:	7175                	addi	sp,sp,-144
    80004e48:	e506                	sd	ra,136(sp)
    80004e4a:	e122                	sd	s0,128(sp)
    80004e4c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e4e:	fffff097          	auipc	ra,0xfffff
    80004e52:	890080e7          	jalr	-1904(ra) # 800036de <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e56:	08000613          	li	a2,128
    80004e5a:	f7040593          	addi	a1,s0,-144
    80004e5e:	4501                	li	a0,0
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	382080e7          	jalr	898(ra) # 800021e2 <argstr>
    80004e68:	02054963          	bltz	a0,80004e9a <sys_mkdir+0x54>
    80004e6c:	4681                	li	a3,0
    80004e6e:	4601                	li	a2,0
    80004e70:	4585                	li	a1,1
    80004e72:	f7040513          	addi	a0,s0,-144
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	7fe080e7          	jalr	2046(ra) # 80004674 <create>
    80004e7e:	cd11                	beqz	a0,80004e9a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	0fe080e7          	jalr	254(ra) # 80002f7e <iunlockput>
  end_op();
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	8d6080e7          	jalr	-1834(ra) # 8000375e <end_op>
  return 0;
    80004e90:	4501                	li	a0,0
}
    80004e92:	60aa                	ld	ra,136(sp)
    80004e94:	640a                	ld	s0,128(sp)
    80004e96:	6149                	addi	sp,sp,144
    80004e98:	8082                	ret
    end_op();
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	8c4080e7          	jalr	-1852(ra) # 8000375e <end_op>
    return -1;
    80004ea2:	557d                	li	a0,-1
    80004ea4:	b7fd                	j	80004e92 <sys_mkdir+0x4c>

0000000080004ea6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ea6:	7135                	addi	sp,sp,-160
    80004ea8:	ed06                	sd	ra,152(sp)
    80004eaa:	e922                	sd	s0,144(sp)
    80004eac:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	830080e7          	jalr	-2000(ra) # 800036de <begin_op>
  argint(1, &major);
    80004eb6:	f6c40593          	addi	a1,s0,-148
    80004eba:	4505                	li	a0,1
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	2e6080e7          	jalr	742(ra) # 800021a2 <argint>
  argint(2, &minor);
    80004ec4:	f6840593          	addi	a1,s0,-152
    80004ec8:	4509                	li	a0,2
    80004eca:	ffffd097          	auipc	ra,0xffffd
    80004ece:	2d8080e7          	jalr	728(ra) # 800021a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ed2:	08000613          	li	a2,128
    80004ed6:	f7040593          	addi	a1,s0,-144
    80004eda:	4501                	li	a0,0
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	306080e7          	jalr	774(ra) # 800021e2 <argstr>
    80004ee4:	02054b63          	bltz	a0,80004f1a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ee8:	f6841683          	lh	a3,-152(s0)
    80004eec:	f6c41603          	lh	a2,-148(s0)
    80004ef0:	458d                	li	a1,3
    80004ef2:	f7040513          	addi	a0,s0,-144
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	77e080e7          	jalr	1918(ra) # 80004674 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004efe:	cd11                	beqz	a0,80004f1a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	07e080e7          	jalr	126(ra) # 80002f7e <iunlockput>
  end_op();
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	856080e7          	jalr	-1962(ra) # 8000375e <end_op>
  return 0;
    80004f10:	4501                	li	a0,0
}
    80004f12:	60ea                	ld	ra,152(sp)
    80004f14:	644a                	ld	s0,144(sp)
    80004f16:	610d                	addi	sp,sp,160
    80004f18:	8082                	ret
    end_op();
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	844080e7          	jalr	-1980(ra) # 8000375e <end_op>
    return -1;
    80004f22:	557d                	li	a0,-1
    80004f24:	b7fd                	j	80004f12 <sys_mknod+0x6c>

0000000080004f26 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f26:	7135                	addi	sp,sp,-160
    80004f28:	ed06                	sd	ra,152(sp)
    80004f2a:	e922                	sd	s0,144(sp)
    80004f2c:	e526                	sd	s1,136(sp)
    80004f2e:	e14a                	sd	s2,128(sp)
    80004f30:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f32:	ffffc097          	auipc	ra,0xffffc
    80004f36:	11a080e7          	jalr	282(ra) # 8000104c <myproc>
    80004f3a:	892a                	mv	s2,a0
  
  begin_op();
    80004f3c:	ffffe097          	auipc	ra,0xffffe
    80004f40:	7a2080e7          	jalr	1954(ra) # 800036de <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f44:	08000613          	li	a2,128
    80004f48:	f6040593          	addi	a1,s0,-160
    80004f4c:	4501                	li	a0,0
    80004f4e:	ffffd097          	auipc	ra,0xffffd
    80004f52:	294080e7          	jalr	660(ra) # 800021e2 <argstr>
    80004f56:	04054b63          	bltz	a0,80004fac <sys_chdir+0x86>
    80004f5a:	f6040513          	addi	a0,s0,-160
    80004f5e:	ffffe097          	auipc	ra,0xffffe
    80004f62:	564080e7          	jalr	1380(ra) # 800034c2 <namei>
    80004f66:	84aa                	mv	s1,a0
    80004f68:	c131                	beqz	a0,80004fac <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	db2080e7          	jalr	-590(ra) # 80002d1c <ilock>
  if(ip->type != T_DIR){
    80004f72:	04449703          	lh	a4,68(s1)
    80004f76:	4785                	li	a5,1
    80004f78:	04f71063          	bne	a4,a5,80004fb8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f7c:	8526                	mv	a0,s1
    80004f7e:	ffffe097          	auipc	ra,0xffffe
    80004f82:	e60080e7          	jalr	-416(ra) # 80002dde <iunlock>
  iput(p->cwd);
    80004f86:	15093503          	ld	a0,336(s2)
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	f4c080e7          	jalr	-180(ra) # 80002ed6 <iput>
  end_op();
    80004f92:	ffffe097          	auipc	ra,0xffffe
    80004f96:	7cc080e7          	jalr	1996(ra) # 8000375e <end_op>
  p->cwd = ip;
    80004f9a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f9e:	4501                	li	a0,0
}
    80004fa0:	60ea                	ld	ra,152(sp)
    80004fa2:	644a                	ld	s0,144(sp)
    80004fa4:	64aa                	ld	s1,136(sp)
    80004fa6:	690a                	ld	s2,128(sp)
    80004fa8:	610d                	addi	sp,sp,160
    80004faa:	8082                	ret
    end_op();
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	7b2080e7          	jalr	1970(ra) # 8000375e <end_op>
    return -1;
    80004fb4:	557d                	li	a0,-1
    80004fb6:	b7ed                	j	80004fa0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fb8:	8526                	mv	a0,s1
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	fc4080e7          	jalr	-60(ra) # 80002f7e <iunlockput>
    end_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	79c080e7          	jalr	1948(ra) # 8000375e <end_op>
    return -1;
    80004fca:	557d                	li	a0,-1
    80004fcc:	bfd1                	j	80004fa0 <sys_chdir+0x7a>

0000000080004fce <sys_exec>:

uint64
sys_exec(void)
{
    80004fce:	7145                	addi	sp,sp,-464
    80004fd0:	e786                	sd	ra,456(sp)
    80004fd2:	e3a2                	sd	s0,448(sp)
    80004fd4:	ff26                	sd	s1,440(sp)
    80004fd6:	fb4a                	sd	s2,432(sp)
    80004fd8:	f74e                	sd	s3,424(sp)
    80004fda:	f352                	sd	s4,416(sp)
    80004fdc:	ef56                	sd	s5,408(sp)
    80004fde:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fe0:	e3840593          	addi	a1,s0,-456
    80004fe4:	4505                	li	a0,1
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	1dc080e7          	jalr	476(ra) # 800021c2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004fee:	08000613          	li	a2,128
    80004ff2:	f4040593          	addi	a1,s0,-192
    80004ff6:	4501                	li	a0,0
    80004ff8:	ffffd097          	auipc	ra,0xffffd
    80004ffc:	1ea080e7          	jalr	490(ra) # 800021e2 <argstr>
    80005000:	87aa                	mv	a5,a0
    return -1;
    80005002:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005004:	0c07c263          	bltz	a5,800050c8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005008:	10000613          	li	a2,256
    8000500c:	4581                	li	a1,0
    8000500e:	e4040513          	addi	a0,s0,-448
    80005012:	ffffb097          	auipc	ra,0xffffb
    80005016:	358080e7          	jalr	856(ra) # 8000036a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000501a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000501e:	89a6                	mv	s3,s1
    80005020:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005022:	02000a13          	li	s4,32
    80005026:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000502a:	00391513          	slli	a0,s2,0x3
    8000502e:	e3040593          	addi	a1,s0,-464
    80005032:	e3843783          	ld	a5,-456(s0)
    80005036:	953e                	add	a0,a0,a5
    80005038:	ffffd097          	auipc	ra,0xffffd
    8000503c:	0cc080e7          	jalr	204(ra) # 80002104 <fetchaddr>
    80005040:	02054a63          	bltz	a0,80005074 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005044:	e3043783          	ld	a5,-464(s0)
    80005048:	c3b9                	beqz	a5,8000508e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000504a:	ffffb097          	auipc	ra,0xffffb
    8000504e:	1a4080e7          	jalr	420(ra) # 800001ee <kalloc>
    80005052:	85aa                	mv	a1,a0
    80005054:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005058:	cd11                	beqz	a0,80005074 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000505a:	6605                	lui	a2,0x1
    8000505c:	e3043503          	ld	a0,-464(s0)
    80005060:	ffffd097          	auipc	ra,0xffffd
    80005064:	0f6080e7          	jalr	246(ra) # 80002156 <fetchstr>
    80005068:	00054663          	bltz	a0,80005074 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    8000506c:	0905                	addi	s2,s2,1
    8000506e:	09a1                	addi	s3,s3,8
    80005070:	fb491be3          	bne	s2,s4,80005026 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005074:	10048913          	addi	s2,s1,256
    80005078:	6088                	ld	a0,0(s1)
    8000507a:	c531                	beqz	a0,800050c6 <sys_exec+0xf8>
    kfree(argv[i]);
    8000507c:	ffffb097          	auipc	ra,0xffffb
    80005080:	02c080e7          	jalr	44(ra) # 800000a8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005084:	04a1                	addi	s1,s1,8
    80005086:	ff2499e3          	bne	s1,s2,80005078 <sys_exec+0xaa>
  return -1;
    8000508a:	557d                	li	a0,-1
    8000508c:	a835                	j	800050c8 <sys_exec+0xfa>
      argv[i] = 0;
    8000508e:	0a8e                	slli	s5,s5,0x3
    80005090:	fc040793          	addi	a5,s0,-64
    80005094:	9abe                	add	s5,s5,a5
    80005096:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000509a:	e4040593          	addi	a1,s0,-448
    8000509e:	f4040513          	addi	a0,s0,-192
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	190080e7          	jalr	400(ra) # 80004232 <exec>
    800050aa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ac:	10048993          	addi	s3,s1,256
    800050b0:	6088                	ld	a0,0(s1)
    800050b2:	c901                	beqz	a0,800050c2 <sys_exec+0xf4>
    kfree(argv[i]);
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	ff4080e7          	jalr	-12(ra) # 800000a8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050bc:	04a1                	addi	s1,s1,8
    800050be:	ff3499e3          	bne	s1,s3,800050b0 <sys_exec+0xe2>
  return ret;
    800050c2:	854a                	mv	a0,s2
    800050c4:	a011                	j	800050c8 <sys_exec+0xfa>
  return -1;
    800050c6:	557d                	li	a0,-1
}
    800050c8:	60be                	ld	ra,456(sp)
    800050ca:	641e                	ld	s0,448(sp)
    800050cc:	74fa                	ld	s1,440(sp)
    800050ce:	795a                	ld	s2,432(sp)
    800050d0:	79ba                	ld	s3,424(sp)
    800050d2:	7a1a                	ld	s4,416(sp)
    800050d4:	6afa                	ld	s5,408(sp)
    800050d6:	6179                	addi	sp,sp,464
    800050d8:	8082                	ret

00000000800050da <sys_pipe>:

uint64
sys_pipe(void)
{
    800050da:	7139                	addi	sp,sp,-64
    800050dc:	fc06                	sd	ra,56(sp)
    800050de:	f822                	sd	s0,48(sp)
    800050e0:	f426                	sd	s1,40(sp)
    800050e2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	f68080e7          	jalr	-152(ra) # 8000104c <myproc>
    800050ec:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050ee:	fd840593          	addi	a1,s0,-40
    800050f2:	4501                	li	a0,0
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	0ce080e7          	jalr	206(ra) # 800021c2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050fc:	fc840593          	addi	a1,s0,-56
    80005100:	fd040513          	addi	a0,s0,-48
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	dd6080e7          	jalr	-554(ra) # 80003eda <pipealloc>
    return -1;
    8000510c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000510e:	0c054463          	bltz	a0,800051d6 <sys_pipe+0xfc>
  fd0 = -1;
    80005112:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005116:	fd043503          	ld	a0,-48(s0)
    8000511a:	fffff097          	auipc	ra,0xfffff
    8000511e:	518080e7          	jalr	1304(ra) # 80004632 <fdalloc>
    80005122:	fca42223          	sw	a0,-60(s0)
    80005126:	08054b63          	bltz	a0,800051bc <sys_pipe+0xe2>
    8000512a:	fc843503          	ld	a0,-56(s0)
    8000512e:	fffff097          	auipc	ra,0xfffff
    80005132:	504080e7          	jalr	1284(ra) # 80004632 <fdalloc>
    80005136:	fca42023          	sw	a0,-64(s0)
    8000513a:	06054863          	bltz	a0,800051aa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000513e:	4691                	li	a3,4
    80005140:	fc440613          	addi	a2,s0,-60
    80005144:	fd843583          	ld	a1,-40(s0)
    80005148:	68a8                	ld	a0,80(s1)
    8000514a:	ffffc097          	auipc	ra,0xffffc
    8000514e:	bb4080e7          	jalr	-1100(ra) # 80000cfe <copyout>
    80005152:	02054063          	bltz	a0,80005172 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005156:	4691                	li	a3,4
    80005158:	fc040613          	addi	a2,s0,-64
    8000515c:	fd843583          	ld	a1,-40(s0)
    80005160:	0591                	addi	a1,a1,4
    80005162:	68a8                	ld	a0,80(s1)
    80005164:	ffffc097          	auipc	ra,0xffffc
    80005168:	b9a080e7          	jalr	-1126(ra) # 80000cfe <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000516c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000516e:	06055463          	bgez	a0,800051d6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005172:	fc442783          	lw	a5,-60(s0)
    80005176:	07e9                	addi	a5,a5,26
    80005178:	078e                	slli	a5,a5,0x3
    8000517a:	97a6                	add	a5,a5,s1
    8000517c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005180:	fc042503          	lw	a0,-64(s0)
    80005184:	0569                	addi	a0,a0,26
    80005186:	050e                	slli	a0,a0,0x3
    80005188:	94aa                	add	s1,s1,a0
    8000518a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000518e:	fd043503          	ld	a0,-48(s0)
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	a18080e7          	jalr	-1512(ra) # 80003baa <fileclose>
    fileclose(wf);
    8000519a:	fc843503          	ld	a0,-56(s0)
    8000519e:	fffff097          	auipc	ra,0xfffff
    800051a2:	a0c080e7          	jalr	-1524(ra) # 80003baa <fileclose>
    return -1;
    800051a6:	57fd                	li	a5,-1
    800051a8:	a03d                	j	800051d6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051aa:	fc442783          	lw	a5,-60(s0)
    800051ae:	0007c763          	bltz	a5,800051bc <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051b2:	07e9                	addi	a5,a5,26
    800051b4:	078e                	slli	a5,a5,0x3
    800051b6:	94be                	add	s1,s1,a5
    800051b8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051bc:	fd043503          	ld	a0,-48(s0)
    800051c0:	fffff097          	auipc	ra,0xfffff
    800051c4:	9ea080e7          	jalr	-1558(ra) # 80003baa <fileclose>
    fileclose(wf);
    800051c8:	fc843503          	ld	a0,-56(s0)
    800051cc:	fffff097          	auipc	ra,0xfffff
    800051d0:	9de080e7          	jalr	-1570(ra) # 80003baa <fileclose>
    return -1;
    800051d4:	57fd                	li	a5,-1
}
    800051d6:	853e                	mv	a0,a5
    800051d8:	70e2                	ld	ra,56(sp)
    800051da:	7442                	ld	s0,48(sp)
    800051dc:	74a2                	ld	s1,40(sp)
    800051de:	6121                	addi	sp,sp,64
    800051e0:	8082                	ret
	...

00000000800051f0 <kernelvec>:
    800051f0:	7111                	addi	sp,sp,-256
    800051f2:	e006                	sd	ra,0(sp)
    800051f4:	e40a                	sd	sp,8(sp)
    800051f6:	e80e                	sd	gp,16(sp)
    800051f8:	ec12                	sd	tp,24(sp)
    800051fa:	f016                	sd	t0,32(sp)
    800051fc:	f41a                	sd	t1,40(sp)
    800051fe:	f81e                	sd	t2,48(sp)
    80005200:	fc22                	sd	s0,56(sp)
    80005202:	e0a6                	sd	s1,64(sp)
    80005204:	e4aa                	sd	a0,72(sp)
    80005206:	e8ae                	sd	a1,80(sp)
    80005208:	ecb2                	sd	a2,88(sp)
    8000520a:	f0b6                	sd	a3,96(sp)
    8000520c:	f4ba                	sd	a4,104(sp)
    8000520e:	f8be                	sd	a5,112(sp)
    80005210:	fcc2                	sd	a6,120(sp)
    80005212:	e146                	sd	a7,128(sp)
    80005214:	e54a                	sd	s2,136(sp)
    80005216:	e94e                	sd	s3,144(sp)
    80005218:	ed52                	sd	s4,152(sp)
    8000521a:	f156                	sd	s5,160(sp)
    8000521c:	f55a                	sd	s6,168(sp)
    8000521e:	f95e                	sd	s7,176(sp)
    80005220:	fd62                	sd	s8,184(sp)
    80005222:	e1e6                	sd	s9,192(sp)
    80005224:	e5ea                	sd	s10,200(sp)
    80005226:	e9ee                	sd	s11,208(sp)
    80005228:	edf2                	sd	t3,216(sp)
    8000522a:	f1f6                	sd	t4,224(sp)
    8000522c:	f5fa                	sd	t5,232(sp)
    8000522e:	f9fe                	sd	t6,240(sp)
    80005230:	da1fc0ef          	jal	ra,80001fd0 <kerneltrap>
    80005234:	6082                	ld	ra,0(sp)
    80005236:	6122                	ld	sp,8(sp)
    80005238:	61c2                	ld	gp,16(sp)
    8000523a:	7282                	ld	t0,32(sp)
    8000523c:	7322                	ld	t1,40(sp)
    8000523e:	73c2                	ld	t2,48(sp)
    80005240:	7462                	ld	s0,56(sp)
    80005242:	6486                	ld	s1,64(sp)
    80005244:	6526                	ld	a0,72(sp)
    80005246:	65c6                	ld	a1,80(sp)
    80005248:	6666                	ld	a2,88(sp)
    8000524a:	7686                	ld	a3,96(sp)
    8000524c:	7726                	ld	a4,104(sp)
    8000524e:	77c6                	ld	a5,112(sp)
    80005250:	7866                	ld	a6,120(sp)
    80005252:	688a                	ld	a7,128(sp)
    80005254:	692a                	ld	s2,136(sp)
    80005256:	69ca                	ld	s3,144(sp)
    80005258:	6a6a                	ld	s4,152(sp)
    8000525a:	7a8a                	ld	s5,160(sp)
    8000525c:	7b2a                	ld	s6,168(sp)
    8000525e:	7bca                	ld	s7,176(sp)
    80005260:	7c6a                	ld	s8,184(sp)
    80005262:	6c8e                	ld	s9,192(sp)
    80005264:	6d2e                	ld	s10,200(sp)
    80005266:	6dce                	ld	s11,208(sp)
    80005268:	6e6e                	ld	t3,216(sp)
    8000526a:	7e8e                	ld	t4,224(sp)
    8000526c:	7f2e                	ld	t5,232(sp)
    8000526e:	7fce                	ld	t6,240(sp)
    80005270:	6111                	addi	sp,sp,256
    80005272:	10200073          	sret
    80005276:	00000013          	nop
    8000527a:	00000013          	nop
    8000527e:	0001                	nop

0000000080005280 <timervec>:
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	e10c                	sd	a1,0(a0)
    80005286:	e510                	sd	a2,8(a0)
    80005288:	e914                	sd	a3,16(a0)
    8000528a:	6d0c                	ld	a1,24(a0)
    8000528c:	7110                	ld	a2,32(a0)
    8000528e:	6194                	ld	a3,0(a1)
    80005290:	96b2                	add	a3,a3,a2
    80005292:	e194                	sd	a3,0(a1)
    80005294:	4589                	li	a1,2
    80005296:	14459073          	csrw	sip,a1
    8000529a:	6914                	ld	a3,16(a0)
    8000529c:	6510                	ld	a2,8(a0)
    8000529e:	610c                	ld	a1,0(a0)
    800052a0:	34051573          	csrrw	a0,mscratch,a0
    800052a4:	30200073          	mret
	...

00000000800052aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052aa:	1141                	addi	sp,sp,-16
    800052ac:	e422                	sd	s0,8(sp)
    800052ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052b0:	0c0007b7          	lui	a5,0xc000
    800052b4:	4705                	li	a4,1
    800052b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052b8:	c3d8                	sw	a4,4(a5)
}
    800052ba:	6422                	ld	s0,8(sp)
    800052bc:	0141                	addi	sp,sp,16
    800052be:	8082                	ret

00000000800052c0 <plicinithart>:

void
plicinithart(void)
{
    800052c0:	1141                	addi	sp,sp,-16
    800052c2:	e406                	sd	ra,8(sp)
    800052c4:	e022                	sd	s0,0(sp)
    800052c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	d58080e7          	jalr	-680(ra) # 80001020 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052d0:	0085171b          	slliw	a4,a0,0x8
    800052d4:	0c0027b7          	lui	a5,0xc002
    800052d8:	97ba                	add	a5,a5,a4
    800052da:	40200713          	li	a4,1026
    800052de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052e2:	00d5151b          	slliw	a0,a0,0xd
    800052e6:	0c2017b7          	lui	a5,0xc201
    800052ea:	953e                	add	a0,a0,a5
    800052ec:	00052023          	sw	zero,0(a0)
}
    800052f0:	60a2                	ld	ra,8(sp)
    800052f2:	6402                	ld	s0,0(sp)
    800052f4:	0141                	addi	sp,sp,16
    800052f6:	8082                	ret

00000000800052f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052f8:	1141                	addi	sp,sp,-16
    800052fa:	e406                	sd	ra,8(sp)
    800052fc:	e022                	sd	s0,0(sp)
    800052fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005300:	ffffc097          	auipc	ra,0xffffc
    80005304:	d20080e7          	jalr	-736(ra) # 80001020 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005308:	00d5179b          	slliw	a5,a0,0xd
    8000530c:	0c201537          	lui	a0,0xc201
    80005310:	953e                	add	a0,a0,a5
  return irq;
}
    80005312:	4148                	lw	a0,4(a0)
    80005314:	60a2                	ld	ra,8(sp)
    80005316:	6402                	ld	s0,0(sp)
    80005318:	0141                	addi	sp,sp,16
    8000531a:	8082                	ret

000000008000531c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000531c:	1101                	addi	sp,sp,-32
    8000531e:	ec06                	sd	ra,24(sp)
    80005320:	e822                	sd	s0,16(sp)
    80005322:	e426                	sd	s1,8(sp)
    80005324:	1000                	addi	s0,sp,32
    80005326:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	cf8080e7          	jalr	-776(ra) # 80001020 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005330:	00d5151b          	slliw	a0,a0,0xd
    80005334:	0c2017b7          	lui	a5,0xc201
    80005338:	97aa                	add	a5,a5,a0
    8000533a:	c3c4                	sw	s1,4(a5)
}
    8000533c:	60e2                	ld	ra,24(sp)
    8000533e:	6442                	ld	s0,16(sp)
    80005340:	64a2                	ld	s1,8(sp)
    80005342:	6105                	addi	sp,sp,32
    80005344:	8082                	ret

0000000080005346 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005346:	1141                	addi	sp,sp,-16
    80005348:	e406                	sd	ra,8(sp)
    8000534a:	e022                	sd	s0,0(sp)
    8000534c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000534e:	479d                	li	a5,7
    80005350:	04a7cc63          	blt	a5,a0,800053a8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005354:	00234797          	auipc	a5,0x234
    80005358:	65c78793          	addi	a5,a5,1628 # 802399b0 <disk>
    8000535c:	97aa                	add	a5,a5,a0
    8000535e:	0187c783          	lbu	a5,24(a5)
    80005362:	ebb9                	bnez	a5,800053b8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005364:	00451613          	slli	a2,a0,0x4
    80005368:	00234797          	auipc	a5,0x234
    8000536c:	64878793          	addi	a5,a5,1608 # 802399b0 <disk>
    80005370:	6394                	ld	a3,0(a5)
    80005372:	96b2                	add	a3,a3,a2
    80005374:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005378:	6398                	ld	a4,0(a5)
    8000537a:	9732                	add	a4,a4,a2
    8000537c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005380:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005384:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005388:	953e                	add	a0,a0,a5
    8000538a:	4785                	li	a5,1
    8000538c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005390:	00234517          	auipc	a0,0x234
    80005394:	63850513          	addi	a0,a0,1592 # 802399c8 <disk+0x18>
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	3bc080e7          	jalr	956(ra) # 80001754 <wakeup>
}
    800053a0:	60a2                	ld	ra,8(sp)
    800053a2:	6402                	ld	s0,0(sp)
    800053a4:	0141                	addi	sp,sp,16
    800053a6:	8082                	ret
    panic("free_desc 1");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	31850513          	addi	a0,a0,792 # 800086c0 <syscalls+0x2f0>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	a72080e7          	jalr	-1422(ra) # 80005e22 <panic>
    panic("free_desc 2");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	31850513          	addi	a0,a0,792 # 800086d0 <syscalls+0x300>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	a62080e7          	jalr	-1438(ra) # 80005e22 <panic>

00000000800053c8 <virtio_disk_init>:
{
    800053c8:	1101                	addi	sp,sp,-32
    800053ca:	ec06                	sd	ra,24(sp)
    800053cc:	e822                	sd	s0,16(sp)
    800053ce:	e426                	sd	s1,8(sp)
    800053d0:	e04a                	sd	s2,0(sp)
    800053d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053d4:	00003597          	auipc	a1,0x3
    800053d8:	30c58593          	addi	a1,a1,780 # 800086e0 <syscalls+0x310>
    800053dc:	00234517          	auipc	a0,0x234
    800053e0:	6fc50513          	addi	a0,a0,1788 # 80239ad8 <disk+0x128>
    800053e4:	00001097          	auipc	ra,0x1
    800053e8:	ef8080e7          	jalr	-264(ra) # 800062dc <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053ec:	100017b7          	lui	a5,0x10001
    800053f0:	4398                	lw	a4,0(a5)
    800053f2:	2701                	sext.w	a4,a4
    800053f4:	747277b7          	lui	a5,0x74727
    800053f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053fc:	14f71e63          	bne	a4,a5,80005558 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005400:	100017b7          	lui	a5,0x10001
    80005404:	43dc                	lw	a5,4(a5)
    80005406:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005408:	4709                	li	a4,2
    8000540a:	14e79763          	bne	a5,a4,80005558 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000540e:	100017b7          	lui	a5,0x10001
    80005412:	479c                	lw	a5,8(a5)
    80005414:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005416:	14e79163          	bne	a5,a4,80005558 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000541a:	100017b7          	lui	a5,0x10001
    8000541e:	47d8                	lw	a4,12(a5)
    80005420:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005422:	554d47b7          	lui	a5,0x554d4
    80005426:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000542a:	12f71763          	bne	a4,a5,80005558 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542e:	100017b7          	lui	a5,0x10001
    80005432:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005436:	4705                	li	a4,1
    80005438:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000543a:	470d                	li	a4,3
    8000543c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000543e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005440:	c7ffe737          	lui	a4,0xc7ffe
    80005444:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbca2f>
    80005448:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000544a:	2701                	sext.w	a4,a4
    8000544c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544e:	472d                	li	a4,11
    80005450:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005452:	0707a903          	lw	s2,112(a5)
    80005456:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005458:	00897793          	andi	a5,s2,8
    8000545c:	10078663          	beqz	a5,80005568 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005460:	100017b7          	lui	a5,0x10001
    80005464:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005468:	43fc                	lw	a5,68(a5)
    8000546a:	2781                	sext.w	a5,a5
    8000546c:	10079663          	bnez	a5,80005578 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005470:	100017b7          	lui	a5,0x10001
    80005474:	5bdc                	lw	a5,52(a5)
    80005476:	2781                	sext.w	a5,a5
  if(max == 0)
    80005478:	10078863          	beqz	a5,80005588 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000547c:	471d                	li	a4,7
    8000547e:	10f77d63          	bgeu	a4,a5,80005598 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005482:	ffffb097          	auipc	ra,0xffffb
    80005486:	d6c080e7          	jalr	-660(ra) # 800001ee <kalloc>
    8000548a:	00234497          	auipc	s1,0x234
    8000548e:	52648493          	addi	s1,s1,1318 # 802399b0 <disk>
    80005492:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005494:	ffffb097          	auipc	ra,0xffffb
    80005498:	d5a080e7          	jalr	-678(ra) # 800001ee <kalloc>
    8000549c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000549e:	ffffb097          	auipc	ra,0xffffb
    800054a2:	d50080e7          	jalr	-688(ra) # 800001ee <kalloc>
    800054a6:	87aa                	mv	a5,a0
    800054a8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054aa:	6088                	ld	a0,0(s1)
    800054ac:	cd75                	beqz	a0,800055a8 <virtio_disk_init+0x1e0>
    800054ae:	00234717          	auipc	a4,0x234
    800054b2:	50a73703          	ld	a4,1290(a4) # 802399b8 <disk+0x8>
    800054b6:	cb6d                	beqz	a4,800055a8 <virtio_disk_init+0x1e0>
    800054b8:	cbe5                	beqz	a5,800055a8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800054ba:	6605                	lui	a2,0x1
    800054bc:	4581                	li	a1,0
    800054be:	ffffb097          	auipc	ra,0xffffb
    800054c2:	eac080e7          	jalr	-340(ra) # 8000036a <memset>
  memset(disk.avail, 0, PGSIZE);
    800054c6:	00234497          	auipc	s1,0x234
    800054ca:	4ea48493          	addi	s1,s1,1258 # 802399b0 <disk>
    800054ce:	6605                	lui	a2,0x1
    800054d0:	4581                	li	a1,0
    800054d2:	6488                	ld	a0,8(s1)
    800054d4:	ffffb097          	auipc	ra,0xffffb
    800054d8:	e96080e7          	jalr	-362(ra) # 8000036a <memset>
  memset(disk.used, 0, PGSIZE);
    800054dc:	6605                	lui	a2,0x1
    800054de:	4581                	li	a1,0
    800054e0:	6888                	ld	a0,16(s1)
    800054e2:	ffffb097          	auipc	ra,0xffffb
    800054e6:	e88080e7          	jalr	-376(ra) # 8000036a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054ea:	100017b7          	lui	a5,0x10001
    800054ee:	4721                	li	a4,8
    800054f0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054f2:	4098                	lw	a4,0(s1)
    800054f4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054f8:	40d8                	lw	a4,4(s1)
    800054fa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054fe:	6498                	ld	a4,8(s1)
    80005500:	0007069b          	sext.w	a3,a4
    80005504:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005508:	9701                	srai	a4,a4,0x20
    8000550a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000550e:	6898                	ld	a4,16(s1)
    80005510:	0007069b          	sext.w	a3,a4
    80005514:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005518:	9701                	srai	a4,a4,0x20
    8000551a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000551e:	4685                	li	a3,1
    80005520:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005522:	4705                	li	a4,1
    80005524:	00d48c23          	sb	a3,24(s1)
    80005528:	00e48ca3          	sb	a4,25(s1)
    8000552c:	00e48d23          	sb	a4,26(s1)
    80005530:	00e48da3          	sb	a4,27(s1)
    80005534:	00e48e23          	sb	a4,28(s1)
    80005538:	00e48ea3          	sb	a4,29(s1)
    8000553c:	00e48f23          	sb	a4,30(s1)
    80005540:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005544:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005548:	0727a823          	sw	s2,112(a5)
}
    8000554c:	60e2                	ld	ra,24(sp)
    8000554e:	6442                	ld	s0,16(sp)
    80005550:	64a2                	ld	s1,8(sp)
    80005552:	6902                	ld	s2,0(sp)
    80005554:	6105                	addi	sp,sp,32
    80005556:	8082                	ret
    panic("could not find virtio disk");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	19850513          	addi	a0,a0,408 # 800086f0 <syscalls+0x320>
    80005560:	00001097          	auipc	ra,0x1
    80005564:	8c2080e7          	jalr	-1854(ra) # 80005e22 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005568:	00003517          	auipc	a0,0x3
    8000556c:	1a850513          	addi	a0,a0,424 # 80008710 <syscalls+0x340>
    80005570:	00001097          	auipc	ra,0x1
    80005574:	8b2080e7          	jalr	-1870(ra) # 80005e22 <panic>
    panic("virtio disk should not be ready");
    80005578:	00003517          	auipc	a0,0x3
    8000557c:	1b850513          	addi	a0,a0,440 # 80008730 <syscalls+0x360>
    80005580:	00001097          	auipc	ra,0x1
    80005584:	8a2080e7          	jalr	-1886(ra) # 80005e22 <panic>
    panic("virtio disk has no queue 0");
    80005588:	00003517          	auipc	a0,0x3
    8000558c:	1c850513          	addi	a0,a0,456 # 80008750 <syscalls+0x380>
    80005590:	00001097          	auipc	ra,0x1
    80005594:	892080e7          	jalr	-1902(ra) # 80005e22 <panic>
    panic("virtio disk max queue too short");
    80005598:	00003517          	auipc	a0,0x3
    8000559c:	1d850513          	addi	a0,a0,472 # 80008770 <syscalls+0x3a0>
    800055a0:	00001097          	auipc	ra,0x1
    800055a4:	882080e7          	jalr	-1918(ra) # 80005e22 <panic>
    panic("virtio disk kalloc");
    800055a8:	00003517          	auipc	a0,0x3
    800055ac:	1e850513          	addi	a0,a0,488 # 80008790 <syscalls+0x3c0>
    800055b0:	00001097          	auipc	ra,0x1
    800055b4:	872080e7          	jalr	-1934(ra) # 80005e22 <panic>

00000000800055b8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055b8:	7159                	addi	sp,sp,-112
    800055ba:	f486                	sd	ra,104(sp)
    800055bc:	f0a2                	sd	s0,96(sp)
    800055be:	eca6                	sd	s1,88(sp)
    800055c0:	e8ca                	sd	s2,80(sp)
    800055c2:	e4ce                	sd	s3,72(sp)
    800055c4:	e0d2                	sd	s4,64(sp)
    800055c6:	fc56                	sd	s5,56(sp)
    800055c8:	f85a                	sd	s6,48(sp)
    800055ca:	f45e                	sd	s7,40(sp)
    800055cc:	f062                	sd	s8,32(sp)
    800055ce:	ec66                	sd	s9,24(sp)
    800055d0:	e86a                	sd	s10,16(sp)
    800055d2:	1880                	addi	s0,sp,112
    800055d4:	892a                	mv	s2,a0
    800055d6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055d8:	00c52c83          	lw	s9,12(a0)
    800055dc:	001c9c9b          	slliw	s9,s9,0x1
    800055e0:	1c82                	slli	s9,s9,0x20
    800055e2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055e6:	00234517          	auipc	a0,0x234
    800055ea:	4f250513          	addi	a0,a0,1266 # 80239ad8 <disk+0x128>
    800055ee:	00001097          	auipc	ra,0x1
    800055f2:	d7e080e7          	jalr	-642(ra) # 8000636c <acquire>
  for(int i = 0; i < 3; i++){
    800055f6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055f8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800055fa:	00234b17          	auipc	s6,0x234
    800055fe:	3b6b0b13          	addi	s6,s6,950 # 802399b0 <disk>
  for(int i = 0; i < 3; i++){
    80005602:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005604:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005606:	00234c17          	auipc	s8,0x234
    8000560a:	4d2c0c13          	addi	s8,s8,1234 # 80239ad8 <disk+0x128>
    8000560e:	a8b5                	j	8000568a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005610:	00fb06b3          	add	a3,s6,a5
    80005614:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005618:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000561a:	0207c563          	bltz	a5,80005644 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000561e:	2485                	addiw	s1,s1,1
    80005620:	0711                	addi	a4,a4,4
    80005622:	1f548a63          	beq	s1,s5,80005816 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005626:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005628:	00234697          	auipc	a3,0x234
    8000562c:	38868693          	addi	a3,a3,904 # 802399b0 <disk>
    80005630:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005632:	0186c583          	lbu	a1,24(a3)
    80005636:	fde9                	bnez	a1,80005610 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005638:	2785                	addiw	a5,a5,1
    8000563a:	0685                	addi	a3,a3,1
    8000563c:	ff779be3          	bne	a5,s7,80005632 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005640:	57fd                	li	a5,-1
    80005642:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005644:	02905a63          	blez	s1,80005678 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005648:	f9042503          	lw	a0,-112(s0)
    8000564c:	00000097          	auipc	ra,0x0
    80005650:	cfa080e7          	jalr	-774(ra) # 80005346 <free_desc>
      for(int j = 0; j < i; j++)
    80005654:	4785                	li	a5,1
    80005656:	0297d163          	bge	a5,s1,80005678 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000565a:	f9442503          	lw	a0,-108(s0)
    8000565e:	00000097          	auipc	ra,0x0
    80005662:	ce8080e7          	jalr	-792(ra) # 80005346 <free_desc>
      for(int j = 0; j < i; j++)
    80005666:	4789                	li	a5,2
    80005668:	0097d863          	bge	a5,s1,80005678 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000566c:	f9842503          	lw	a0,-104(s0)
    80005670:	00000097          	auipc	ra,0x0
    80005674:	cd6080e7          	jalr	-810(ra) # 80005346 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005678:	85e2                	mv	a1,s8
    8000567a:	00234517          	auipc	a0,0x234
    8000567e:	34e50513          	addi	a0,a0,846 # 802399c8 <disk+0x18>
    80005682:	ffffc097          	auipc	ra,0xffffc
    80005686:	06e080e7          	jalr	110(ra) # 800016f0 <sleep>
  for(int i = 0; i < 3; i++){
    8000568a:	f9040713          	addi	a4,s0,-112
    8000568e:	84ce                	mv	s1,s3
    80005690:	bf59                	j	80005626 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005692:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005696:	00479693          	slli	a3,a5,0x4
    8000569a:	00234797          	auipc	a5,0x234
    8000569e:	31678793          	addi	a5,a5,790 # 802399b0 <disk>
    800056a2:	97b6                	add	a5,a5,a3
    800056a4:	4685                	li	a3,1
    800056a6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056a8:	00234597          	auipc	a1,0x234
    800056ac:	30858593          	addi	a1,a1,776 # 802399b0 <disk>
    800056b0:	00a60793          	addi	a5,a2,10
    800056b4:	0792                	slli	a5,a5,0x4
    800056b6:	97ae                	add	a5,a5,a1
    800056b8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800056bc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056c0:	f6070693          	addi	a3,a4,-160
    800056c4:	619c                	ld	a5,0(a1)
    800056c6:	97b6                	add	a5,a5,a3
    800056c8:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056ca:	6188                	ld	a0,0(a1)
    800056cc:	96aa                	add	a3,a3,a0
    800056ce:	47c1                	li	a5,16
    800056d0:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056d2:	4785                	li	a5,1
    800056d4:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800056d8:	f9442783          	lw	a5,-108(s0)
    800056dc:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056e0:	0792                	slli	a5,a5,0x4
    800056e2:	953e                	add	a0,a0,a5
    800056e4:	05890693          	addi	a3,s2,88
    800056e8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800056ea:	6188                	ld	a0,0(a1)
    800056ec:	97aa                	add	a5,a5,a0
    800056ee:	40000693          	li	a3,1024
    800056f2:	c794                	sw	a3,8(a5)
  if(write)
    800056f4:	100d0d63          	beqz	s10,8000580e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056f8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056fc:	00c7d683          	lhu	a3,12(a5)
    80005700:	0016e693          	ori	a3,a3,1
    80005704:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005708:	f9842583          	lw	a1,-104(s0)
    8000570c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005710:	00234697          	auipc	a3,0x234
    80005714:	2a068693          	addi	a3,a3,672 # 802399b0 <disk>
    80005718:	00260793          	addi	a5,a2,2
    8000571c:	0792                	slli	a5,a5,0x4
    8000571e:	97b6                	add	a5,a5,a3
    80005720:	587d                	li	a6,-1
    80005722:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005726:	0592                	slli	a1,a1,0x4
    80005728:	952e                	add	a0,a0,a1
    8000572a:	f9070713          	addi	a4,a4,-112
    8000572e:	9736                	add	a4,a4,a3
    80005730:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005732:	6298                	ld	a4,0(a3)
    80005734:	972e                	add	a4,a4,a1
    80005736:	4585                	li	a1,1
    80005738:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000573a:	4509                	li	a0,2
    8000573c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005740:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005744:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005748:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000574c:	6698                	ld	a4,8(a3)
    8000574e:	00275783          	lhu	a5,2(a4)
    80005752:	8b9d                	andi	a5,a5,7
    80005754:	0786                	slli	a5,a5,0x1
    80005756:	97ba                	add	a5,a5,a4
    80005758:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000575c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005760:	6698                	ld	a4,8(a3)
    80005762:	00275783          	lhu	a5,2(a4)
    80005766:	2785                	addiw	a5,a5,1
    80005768:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000576c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005770:	100017b7          	lui	a5,0x10001
    80005774:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005778:	00492703          	lw	a4,4(s2)
    8000577c:	4785                	li	a5,1
    8000577e:	02f71163          	bne	a4,a5,800057a0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005782:	00234997          	auipc	s3,0x234
    80005786:	35698993          	addi	s3,s3,854 # 80239ad8 <disk+0x128>
  while(b->disk == 1) {
    8000578a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000578c:	85ce                	mv	a1,s3
    8000578e:	854a                	mv	a0,s2
    80005790:	ffffc097          	auipc	ra,0xffffc
    80005794:	f60080e7          	jalr	-160(ra) # 800016f0 <sleep>
  while(b->disk == 1) {
    80005798:	00492783          	lw	a5,4(s2)
    8000579c:	fe9788e3          	beq	a5,s1,8000578c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800057a0:	f9042903          	lw	s2,-112(s0)
    800057a4:	00290793          	addi	a5,s2,2
    800057a8:	00479713          	slli	a4,a5,0x4
    800057ac:	00234797          	auipc	a5,0x234
    800057b0:	20478793          	addi	a5,a5,516 # 802399b0 <disk>
    800057b4:	97ba                	add	a5,a5,a4
    800057b6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ba:	00234997          	auipc	s3,0x234
    800057be:	1f698993          	addi	s3,s3,502 # 802399b0 <disk>
    800057c2:	00491713          	slli	a4,s2,0x4
    800057c6:	0009b783          	ld	a5,0(s3)
    800057ca:	97ba                	add	a5,a5,a4
    800057cc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057d0:	854a                	mv	a0,s2
    800057d2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057d6:	00000097          	auipc	ra,0x0
    800057da:	b70080e7          	jalr	-1168(ra) # 80005346 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057de:	8885                	andi	s1,s1,1
    800057e0:	f0ed                	bnez	s1,800057c2 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057e2:	00234517          	auipc	a0,0x234
    800057e6:	2f650513          	addi	a0,a0,758 # 80239ad8 <disk+0x128>
    800057ea:	00001097          	auipc	ra,0x1
    800057ee:	c36080e7          	jalr	-970(ra) # 80006420 <release>
}
    800057f2:	70a6                	ld	ra,104(sp)
    800057f4:	7406                	ld	s0,96(sp)
    800057f6:	64e6                	ld	s1,88(sp)
    800057f8:	6946                	ld	s2,80(sp)
    800057fa:	69a6                	ld	s3,72(sp)
    800057fc:	6a06                	ld	s4,64(sp)
    800057fe:	7ae2                	ld	s5,56(sp)
    80005800:	7b42                	ld	s6,48(sp)
    80005802:	7ba2                	ld	s7,40(sp)
    80005804:	7c02                	ld	s8,32(sp)
    80005806:	6ce2                	ld	s9,24(sp)
    80005808:	6d42                	ld	s10,16(sp)
    8000580a:	6165                	addi	sp,sp,112
    8000580c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000580e:	4689                	li	a3,2
    80005810:	00d79623          	sh	a3,12(a5)
    80005814:	b5e5                	j	800056fc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005816:	f9042603          	lw	a2,-112(s0)
    8000581a:	00a60713          	addi	a4,a2,10
    8000581e:	0712                	slli	a4,a4,0x4
    80005820:	00234517          	auipc	a0,0x234
    80005824:	19850513          	addi	a0,a0,408 # 802399b8 <disk+0x8>
    80005828:	953a                	add	a0,a0,a4
  if(write)
    8000582a:	e60d14e3          	bnez	s10,80005692 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000582e:	00a60793          	addi	a5,a2,10
    80005832:	00479693          	slli	a3,a5,0x4
    80005836:	00234797          	auipc	a5,0x234
    8000583a:	17a78793          	addi	a5,a5,378 # 802399b0 <disk>
    8000583e:	97b6                	add	a5,a5,a3
    80005840:	0007a423          	sw	zero,8(a5)
    80005844:	b595                	j	800056a8 <virtio_disk_rw+0xf0>

0000000080005846 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005846:	1101                	addi	sp,sp,-32
    80005848:	ec06                	sd	ra,24(sp)
    8000584a:	e822                	sd	s0,16(sp)
    8000584c:	e426                	sd	s1,8(sp)
    8000584e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005850:	00234497          	auipc	s1,0x234
    80005854:	16048493          	addi	s1,s1,352 # 802399b0 <disk>
    80005858:	00234517          	auipc	a0,0x234
    8000585c:	28050513          	addi	a0,a0,640 # 80239ad8 <disk+0x128>
    80005860:	00001097          	auipc	ra,0x1
    80005864:	b0c080e7          	jalr	-1268(ra) # 8000636c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005868:	10001737          	lui	a4,0x10001
    8000586c:	533c                	lw	a5,96(a4)
    8000586e:	8b8d                	andi	a5,a5,3
    80005870:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005872:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005876:	689c                	ld	a5,16(s1)
    80005878:	0204d703          	lhu	a4,32(s1)
    8000587c:	0027d783          	lhu	a5,2(a5)
    80005880:	04f70863          	beq	a4,a5,800058d0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005884:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005888:	6898                	ld	a4,16(s1)
    8000588a:	0204d783          	lhu	a5,32(s1)
    8000588e:	8b9d                	andi	a5,a5,7
    80005890:	078e                	slli	a5,a5,0x3
    80005892:	97ba                	add	a5,a5,a4
    80005894:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005896:	00278713          	addi	a4,a5,2
    8000589a:	0712                	slli	a4,a4,0x4
    8000589c:	9726                	add	a4,a4,s1
    8000589e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800058a2:	e721                	bnez	a4,800058ea <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058a4:	0789                	addi	a5,a5,2
    800058a6:	0792                	slli	a5,a5,0x4
    800058a8:	97a6                	add	a5,a5,s1
    800058aa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058ac:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058b0:	ffffc097          	auipc	ra,0xffffc
    800058b4:	ea4080e7          	jalr	-348(ra) # 80001754 <wakeup>

    disk.used_idx += 1;
    800058b8:	0204d783          	lhu	a5,32(s1)
    800058bc:	2785                	addiw	a5,a5,1
    800058be:	17c2                	slli	a5,a5,0x30
    800058c0:	93c1                	srli	a5,a5,0x30
    800058c2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058c6:	6898                	ld	a4,16(s1)
    800058c8:	00275703          	lhu	a4,2(a4)
    800058cc:	faf71ce3          	bne	a4,a5,80005884 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058d0:	00234517          	auipc	a0,0x234
    800058d4:	20850513          	addi	a0,a0,520 # 80239ad8 <disk+0x128>
    800058d8:	00001097          	auipc	ra,0x1
    800058dc:	b48080e7          	jalr	-1208(ra) # 80006420 <release>
}
    800058e0:	60e2                	ld	ra,24(sp)
    800058e2:	6442                	ld	s0,16(sp)
    800058e4:	64a2                	ld	s1,8(sp)
    800058e6:	6105                	addi	sp,sp,32
    800058e8:	8082                	ret
      panic("virtio_disk_intr status");
    800058ea:	00003517          	auipc	a0,0x3
    800058ee:	ebe50513          	addi	a0,a0,-322 # 800087a8 <syscalls+0x3d8>
    800058f2:	00000097          	auipc	ra,0x0
    800058f6:	530080e7          	jalr	1328(ra) # 80005e22 <panic>

00000000800058fa <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058fa:	1141                	addi	sp,sp,-16
    800058fc:	e422                	sd	s0,8(sp)
    800058fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005900:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005904:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005908:	0037979b          	slliw	a5,a5,0x3
    8000590c:	02004737          	lui	a4,0x2004
    80005910:	97ba                	add	a5,a5,a4
    80005912:	0200c737          	lui	a4,0x200c
    80005916:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000591a:	000f4637          	lui	a2,0xf4
    8000591e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005922:	95b2                	add	a1,a1,a2
    80005924:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005926:	00269713          	slli	a4,a3,0x2
    8000592a:	9736                	add	a4,a4,a3
    8000592c:	00371693          	slli	a3,a4,0x3
    80005930:	00234717          	auipc	a4,0x234
    80005934:	1c070713          	addi	a4,a4,448 # 80239af0 <timer_scratch>
    80005938:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000593a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000593c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000593e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005942:	00000797          	auipc	a5,0x0
    80005946:	93e78793          	addi	a5,a5,-1730 # 80005280 <timervec>
    8000594a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000594e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005952:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005956:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000595a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000595e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005962:	30479073          	csrw	mie,a5
}
    80005966:	6422                	ld	s0,8(sp)
    80005968:	0141                	addi	sp,sp,16
    8000596a:	8082                	ret

000000008000596c <start>:
{
    8000596c:	1141                	addi	sp,sp,-16
    8000596e:	e406                	sd	ra,8(sp)
    80005970:	e022                	sd	s0,0(sp)
    80005972:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005974:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005978:	7779                	lui	a4,0xffffe
    8000597a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbcacf>
    8000597e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005980:	6705                	lui	a4,0x1
    80005982:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005986:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005988:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000598c:	ffffb797          	auipc	a5,0xffffb
    80005990:	b8c78793          	addi	a5,a5,-1140 # 80000518 <main>
    80005994:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005998:	4781                	li	a5,0
    8000599a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000599e:	67c1                	lui	a5,0x10
    800059a0:	17fd                	addi	a5,a5,-1
    800059a2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059a6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059aa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059ae:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059b2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059b6:	57fd                	li	a5,-1
    800059b8:	83a9                	srli	a5,a5,0xa
    800059ba:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059be:	47bd                	li	a5,15
    800059c0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	f36080e7          	jalr	-202(ra) # 800058fa <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059d0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800059d4:	30200073          	mret
}
    800059d8:	60a2                	ld	ra,8(sp)
    800059da:	6402                	ld	s0,0(sp)
    800059dc:	0141                	addi	sp,sp,16
    800059de:	8082                	ret

00000000800059e0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059e0:	715d                	addi	sp,sp,-80
    800059e2:	e486                	sd	ra,72(sp)
    800059e4:	e0a2                	sd	s0,64(sp)
    800059e6:	fc26                	sd	s1,56(sp)
    800059e8:	f84a                	sd	s2,48(sp)
    800059ea:	f44e                	sd	s3,40(sp)
    800059ec:	f052                	sd	s4,32(sp)
    800059ee:	ec56                	sd	s5,24(sp)
    800059f0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059f2:	04c05663          	blez	a2,80005a3e <consolewrite+0x5e>
    800059f6:	8a2a                	mv	s4,a0
    800059f8:	84ae                	mv	s1,a1
    800059fa:	89b2                	mv	s3,a2
    800059fc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059fe:	5afd                	li	s5,-1
    80005a00:	4685                	li	a3,1
    80005a02:	8626                	mv	a2,s1
    80005a04:	85d2                	mv	a1,s4
    80005a06:	fbf40513          	addi	a0,s0,-65
    80005a0a:	ffffc097          	auipc	ra,0xffffc
    80005a0e:	144080e7          	jalr	324(ra) # 80001b4e <either_copyin>
    80005a12:	01550c63          	beq	a0,s5,80005a2a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a16:	fbf44503          	lbu	a0,-65(s0)
    80005a1a:	00000097          	auipc	ra,0x0
    80005a1e:	794080e7          	jalr	1940(ra) # 800061ae <uartputc>
  for(i = 0; i < n; i++){
    80005a22:	2905                	addiw	s2,s2,1
    80005a24:	0485                	addi	s1,s1,1
    80005a26:	fd299de3          	bne	s3,s2,80005a00 <consolewrite+0x20>
  }

  return i;
}
    80005a2a:	854a                	mv	a0,s2
    80005a2c:	60a6                	ld	ra,72(sp)
    80005a2e:	6406                	ld	s0,64(sp)
    80005a30:	74e2                	ld	s1,56(sp)
    80005a32:	7942                	ld	s2,48(sp)
    80005a34:	79a2                	ld	s3,40(sp)
    80005a36:	7a02                	ld	s4,32(sp)
    80005a38:	6ae2                	ld	s5,24(sp)
    80005a3a:	6161                	addi	sp,sp,80
    80005a3c:	8082                	ret
  for(i = 0; i < n; i++){
    80005a3e:	4901                	li	s2,0
    80005a40:	b7ed                	j	80005a2a <consolewrite+0x4a>

0000000080005a42 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a42:	7119                	addi	sp,sp,-128
    80005a44:	fc86                	sd	ra,120(sp)
    80005a46:	f8a2                	sd	s0,112(sp)
    80005a48:	f4a6                	sd	s1,104(sp)
    80005a4a:	f0ca                	sd	s2,96(sp)
    80005a4c:	ecce                	sd	s3,88(sp)
    80005a4e:	e8d2                	sd	s4,80(sp)
    80005a50:	e4d6                	sd	s5,72(sp)
    80005a52:	e0da                	sd	s6,64(sp)
    80005a54:	fc5e                	sd	s7,56(sp)
    80005a56:	f862                	sd	s8,48(sp)
    80005a58:	f466                	sd	s9,40(sp)
    80005a5a:	f06a                	sd	s10,32(sp)
    80005a5c:	ec6e                	sd	s11,24(sp)
    80005a5e:	0100                	addi	s0,sp,128
    80005a60:	8b2a                	mv	s6,a0
    80005a62:	8aae                	mv	s5,a1
    80005a64:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a66:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a6a:	0023c517          	auipc	a0,0x23c
    80005a6e:	1c650513          	addi	a0,a0,454 # 80241c30 <cons>
    80005a72:	00001097          	auipc	ra,0x1
    80005a76:	8fa080e7          	jalr	-1798(ra) # 8000636c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a7a:	0023c497          	auipc	s1,0x23c
    80005a7e:	1b648493          	addi	s1,s1,438 # 80241c30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a82:	89a6                	mv	s3,s1
    80005a84:	0023c917          	auipc	s2,0x23c
    80005a88:	24490913          	addi	s2,s2,580 # 80241cc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005a8c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a8e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a90:	4da9                	li	s11,10
  while(n > 0){
    80005a92:	07405b63          	blez	s4,80005b08 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005a96:	0984a783          	lw	a5,152(s1)
    80005a9a:	09c4a703          	lw	a4,156(s1)
    80005a9e:	02f71763          	bne	a4,a5,80005acc <consoleread+0x8a>
      if(killed(myproc())){
    80005aa2:	ffffb097          	auipc	ra,0xffffb
    80005aa6:	5aa080e7          	jalr	1450(ra) # 8000104c <myproc>
    80005aaa:	ffffc097          	auipc	ra,0xffffc
    80005aae:	eee080e7          	jalr	-274(ra) # 80001998 <killed>
    80005ab2:	e535                	bnez	a0,80005b1e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005ab4:	85ce                	mv	a1,s3
    80005ab6:	854a                	mv	a0,s2
    80005ab8:	ffffc097          	auipc	ra,0xffffc
    80005abc:	c38080e7          	jalr	-968(ra) # 800016f0 <sleep>
    while(cons.r == cons.w){
    80005ac0:	0984a783          	lw	a5,152(s1)
    80005ac4:	09c4a703          	lw	a4,156(s1)
    80005ac8:	fcf70de3          	beq	a4,a5,80005aa2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005acc:	0017871b          	addiw	a4,a5,1
    80005ad0:	08e4ac23          	sw	a4,152(s1)
    80005ad4:	07f7f713          	andi	a4,a5,127
    80005ad8:	9726                	add	a4,a4,s1
    80005ada:	01874703          	lbu	a4,24(a4)
    80005ade:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ae2:	079c0663          	beq	s8,s9,80005b4e <consoleread+0x10c>
    cbuf = c;
    80005ae6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aea:	4685                	li	a3,1
    80005aec:	f8f40613          	addi	a2,s0,-113
    80005af0:	85d6                	mv	a1,s5
    80005af2:	855a                	mv	a0,s6
    80005af4:	ffffc097          	auipc	ra,0xffffc
    80005af8:	004080e7          	jalr	4(ra) # 80001af8 <either_copyout>
    80005afc:	01a50663          	beq	a0,s10,80005b08 <consoleread+0xc6>
    dst++;
    80005b00:	0a85                	addi	s5,s5,1
    --n;
    80005b02:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b04:	f9bc17e3          	bne	s8,s11,80005a92 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b08:	0023c517          	auipc	a0,0x23c
    80005b0c:	12850513          	addi	a0,a0,296 # 80241c30 <cons>
    80005b10:	00001097          	auipc	ra,0x1
    80005b14:	910080e7          	jalr	-1776(ra) # 80006420 <release>

  return target - n;
    80005b18:	414b853b          	subw	a0,s7,s4
    80005b1c:	a811                	j	80005b30 <consoleread+0xee>
        release(&cons.lock);
    80005b1e:	0023c517          	auipc	a0,0x23c
    80005b22:	11250513          	addi	a0,a0,274 # 80241c30 <cons>
    80005b26:	00001097          	auipc	ra,0x1
    80005b2a:	8fa080e7          	jalr	-1798(ra) # 80006420 <release>
        return -1;
    80005b2e:	557d                	li	a0,-1
}
    80005b30:	70e6                	ld	ra,120(sp)
    80005b32:	7446                	ld	s0,112(sp)
    80005b34:	74a6                	ld	s1,104(sp)
    80005b36:	7906                	ld	s2,96(sp)
    80005b38:	69e6                	ld	s3,88(sp)
    80005b3a:	6a46                	ld	s4,80(sp)
    80005b3c:	6aa6                	ld	s5,72(sp)
    80005b3e:	6b06                	ld	s6,64(sp)
    80005b40:	7be2                	ld	s7,56(sp)
    80005b42:	7c42                	ld	s8,48(sp)
    80005b44:	7ca2                	ld	s9,40(sp)
    80005b46:	7d02                	ld	s10,32(sp)
    80005b48:	6de2                	ld	s11,24(sp)
    80005b4a:	6109                	addi	sp,sp,128
    80005b4c:	8082                	ret
      if(n < target){
    80005b4e:	000a071b          	sext.w	a4,s4
    80005b52:	fb777be3          	bgeu	a4,s7,80005b08 <consoleread+0xc6>
        cons.r--;
    80005b56:	0023c717          	auipc	a4,0x23c
    80005b5a:	16f72923          	sw	a5,370(a4) # 80241cc8 <cons+0x98>
    80005b5e:	b76d                	j	80005b08 <consoleread+0xc6>

0000000080005b60 <consputc>:
{
    80005b60:	1141                	addi	sp,sp,-16
    80005b62:	e406                	sd	ra,8(sp)
    80005b64:	e022                	sd	s0,0(sp)
    80005b66:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b68:	10000793          	li	a5,256
    80005b6c:	00f50a63          	beq	a0,a5,80005b80 <consputc+0x20>
    uartputc_sync(c);
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	564080e7          	jalr	1380(ra) # 800060d4 <uartputc_sync>
}
    80005b78:	60a2                	ld	ra,8(sp)
    80005b7a:	6402                	ld	s0,0(sp)
    80005b7c:	0141                	addi	sp,sp,16
    80005b7e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b80:	4521                	li	a0,8
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	552080e7          	jalr	1362(ra) # 800060d4 <uartputc_sync>
    80005b8a:	02000513          	li	a0,32
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	546080e7          	jalr	1350(ra) # 800060d4 <uartputc_sync>
    80005b96:	4521                	li	a0,8
    80005b98:	00000097          	auipc	ra,0x0
    80005b9c:	53c080e7          	jalr	1340(ra) # 800060d4 <uartputc_sync>
    80005ba0:	bfe1                	j	80005b78 <consputc+0x18>

0000000080005ba2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ba2:	1101                	addi	sp,sp,-32
    80005ba4:	ec06                	sd	ra,24(sp)
    80005ba6:	e822                	sd	s0,16(sp)
    80005ba8:	e426                	sd	s1,8(sp)
    80005baa:	e04a                	sd	s2,0(sp)
    80005bac:	1000                	addi	s0,sp,32
    80005bae:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bb0:	0023c517          	auipc	a0,0x23c
    80005bb4:	08050513          	addi	a0,a0,128 # 80241c30 <cons>
    80005bb8:	00000097          	auipc	ra,0x0
    80005bbc:	7b4080e7          	jalr	1972(ra) # 8000636c <acquire>

  switch(c){
    80005bc0:	47d5                	li	a5,21
    80005bc2:	0af48663          	beq	s1,a5,80005c6e <consoleintr+0xcc>
    80005bc6:	0297ca63          	blt	a5,s1,80005bfa <consoleintr+0x58>
    80005bca:	47a1                	li	a5,8
    80005bcc:	0ef48763          	beq	s1,a5,80005cba <consoleintr+0x118>
    80005bd0:	47c1                	li	a5,16
    80005bd2:	10f49a63          	bne	s1,a5,80005ce6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bd6:	ffffc097          	auipc	ra,0xffffc
    80005bda:	fce080e7          	jalr	-50(ra) # 80001ba4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bde:	0023c517          	auipc	a0,0x23c
    80005be2:	05250513          	addi	a0,a0,82 # 80241c30 <cons>
    80005be6:	00001097          	auipc	ra,0x1
    80005bea:	83a080e7          	jalr	-1990(ra) # 80006420 <release>
}
    80005bee:	60e2                	ld	ra,24(sp)
    80005bf0:	6442                	ld	s0,16(sp)
    80005bf2:	64a2                	ld	s1,8(sp)
    80005bf4:	6902                	ld	s2,0(sp)
    80005bf6:	6105                	addi	sp,sp,32
    80005bf8:	8082                	ret
  switch(c){
    80005bfa:	07f00793          	li	a5,127
    80005bfe:	0af48e63          	beq	s1,a5,80005cba <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c02:	0023c717          	auipc	a4,0x23c
    80005c06:	02e70713          	addi	a4,a4,46 # 80241c30 <cons>
    80005c0a:	0a072783          	lw	a5,160(a4)
    80005c0e:	09872703          	lw	a4,152(a4)
    80005c12:	9f99                	subw	a5,a5,a4
    80005c14:	07f00713          	li	a4,127
    80005c18:	fcf763e3          	bltu	a4,a5,80005bde <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c1c:	47b5                	li	a5,13
    80005c1e:	0cf48763          	beq	s1,a5,80005cec <consoleintr+0x14a>
      consputc(c);
    80005c22:	8526                	mv	a0,s1
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	f3c080e7          	jalr	-196(ra) # 80005b60 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c2c:	0023c797          	auipc	a5,0x23c
    80005c30:	00478793          	addi	a5,a5,4 # 80241c30 <cons>
    80005c34:	0a07a683          	lw	a3,160(a5)
    80005c38:	0016871b          	addiw	a4,a3,1
    80005c3c:	0007061b          	sext.w	a2,a4
    80005c40:	0ae7a023          	sw	a4,160(a5)
    80005c44:	07f6f693          	andi	a3,a3,127
    80005c48:	97b6                	add	a5,a5,a3
    80005c4a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c4e:	47a9                	li	a5,10
    80005c50:	0cf48563          	beq	s1,a5,80005d1a <consoleintr+0x178>
    80005c54:	4791                	li	a5,4
    80005c56:	0cf48263          	beq	s1,a5,80005d1a <consoleintr+0x178>
    80005c5a:	0023c797          	auipc	a5,0x23c
    80005c5e:	06e7a783          	lw	a5,110(a5) # 80241cc8 <cons+0x98>
    80005c62:	9f1d                	subw	a4,a4,a5
    80005c64:	08000793          	li	a5,128
    80005c68:	f6f71be3          	bne	a4,a5,80005bde <consoleintr+0x3c>
    80005c6c:	a07d                	j	80005d1a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c6e:	0023c717          	auipc	a4,0x23c
    80005c72:	fc270713          	addi	a4,a4,-62 # 80241c30 <cons>
    80005c76:	0a072783          	lw	a5,160(a4)
    80005c7a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c7e:	0023c497          	auipc	s1,0x23c
    80005c82:	fb248493          	addi	s1,s1,-78 # 80241c30 <cons>
    while(cons.e != cons.w &&
    80005c86:	4929                	li	s2,10
    80005c88:	f4f70be3          	beq	a4,a5,80005bde <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c8c:	37fd                	addiw	a5,a5,-1
    80005c8e:	07f7f713          	andi	a4,a5,127
    80005c92:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c94:	01874703          	lbu	a4,24(a4)
    80005c98:	f52703e3          	beq	a4,s2,80005bde <consoleintr+0x3c>
      cons.e--;
    80005c9c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ca0:	10000513          	li	a0,256
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	ebc080e7          	jalr	-324(ra) # 80005b60 <consputc>
    while(cons.e != cons.w &&
    80005cac:	0a04a783          	lw	a5,160(s1)
    80005cb0:	09c4a703          	lw	a4,156(s1)
    80005cb4:	fcf71ce3          	bne	a4,a5,80005c8c <consoleintr+0xea>
    80005cb8:	b71d                	j	80005bde <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cba:	0023c717          	auipc	a4,0x23c
    80005cbe:	f7670713          	addi	a4,a4,-138 # 80241c30 <cons>
    80005cc2:	0a072783          	lw	a5,160(a4)
    80005cc6:	09c72703          	lw	a4,156(a4)
    80005cca:	f0f70ae3          	beq	a4,a5,80005bde <consoleintr+0x3c>
      cons.e--;
    80005cce:	37fd                	addiw	a5,a5,-1
    80005cd0:	0023c717          	auipc	a4,0x23c
    80005cd4:	00f72023          	sw	a5,0(a4) # 80241cd0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cd8:	10000513          	li	a0,256
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	e84080e7          	jalr	-380(ra) # 80005b60 <consputc>
    80005ce4:	bded                	j	80005bde <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ce6:	ee048ce3          	beqz	s1,80005bde <consoleintr+0x3c>
    80005cea:	bf21                	j	80005c02 <consoleintr+0x60>
      consputc(c);
    80005cec:	4529                	li	a0,10
    80005cee:	00000097          	auipc	ra,0x0
    80005cf2:	e72080e7          	jalr	-398(ra) # 80005b60 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cf6:	0023c797          	auipc	a5,0x23c
    80005cfa:	f3a78793          	addi	a5,a5,-198 # 80241c30 <cons>
    80005cfe:	0a07a703          	lw	a4,160(a5)
    80005d02:	0017069b          	addiw	a3,a4,1
    80005d06:	0006861b          	sext.w	a2,a3
    80005d0a:	0ad7a023          	sw	a3,160(a5)
    80005d0e:	07f77713          	andi	a4,a4,127
    80005d12:	97ba                	add	a5,a5,a4
    80005d14:	4729                	li	a4,10
    80005d16:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d1a:	0023c797          	auipc	a5,0x23c
    80005d1e:	fac7a923          	sw	a2,-78(a5) # 80241ccc <cons+0x9c>
        wakeup(&cons.r);
    80005d22:	0023c517          	auipc	a0,0x23c
    80005d26:	fa650513          	addi	a0,a0,-90 # 80241cc8 <cons+0x98>
    80005d2a:	ffffc097          	auipc	ra,0xffffc
    80005d2e:	a2a080e7          	jalr	-1494(ra) # 80001754 <wakeup>
    80005d32:	b575                	j	80005bde <consoleintr+0x3c>

0000000080005d34 <consoleinit>:

void
consoleinit(void)
{
    80005d34:	1141                	addi	sp,sp,-16
    80005d36:	e406                	sd	ra,8(sp)
    80005d38:	e022                	sd	s0,0(sp)
    80005d3a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d3c:	00003597          	auipc	a1,0x3
    80005d40:	a8458593          	addi	a1,a1,-1404 # 800087c0 <syscalls+0x3f0>
    80005d44:	0023c517          	auipc	a0,0x23c
    80005d48:	eec50513          	addi	a0,a0,-276 # 80241c30 <cons>
    80005d4c:	00000097          	auipc	ra,0x0
    80005d50:	590080e7          	jalr	1424(ra) # 800062dc <initlock>

  uartinit();
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	330080e7          	jalr	816(ra) # 80006084 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d5c:	00233797          	auipc	a5,0x233
    80005d60:	bfc78793          	addi	a5,a5,-1028 # 80238958 <devsw>
    80005d64:	00000717          	auipc	a4,0x0
    80005d68:	cde70713          	addi	a4,a4,-802 # 80005a42 <consoleread>
    80005d6c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d6e:	00000717          	auipc	a4,0x0
    80005d72:	c7270713          	addi	a4,a4,-910 # 800059e0 <consolewrite>
    80005d76:	ef98                	sd	a4,24(a5)
}
    80005d78:	60a2                	ld	ra,8(sp)
    80005d7a:	6402                	ld	s0,0(sp)
    80005d7c:	0141                	addi	sp,sp,16
    80005d7e:	8082                	ret

0000000080005d80 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d80:	7179                	addi	sp,sp,-48
    80005d82:	f406                	sd	ra,40(sp)
    80005d84:	f022                	sd	s0,32(sp)
    80005d86:	ec26                	sd	s1,24(sp)
    80005d88:	e84a                	sd	s2,16(sp)
    80005d8a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d8c:	c219                	beqz	a2,80005d92 <printint+0x12>
    80005d8e:	08054663          	bltz	a0,80005e1a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d92:	2501                	sext.w	a0,a0
    80005d94:	4881                	li	a7,0
    80005d96:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d9a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d9c:	2581                	sext.w	a1,a1
    80005d9e:	00003617          	auipc	a2,0x3
    80005da2:	a5260613          	addi	a2,a2,-1454 # 800087f0 <digits>
    80005da6:	883a                	mv	a6,a4
    80005da8:	2705                	addiw	a4,a4,1
    80005daa:	02b577bb          	remuw	a5,a0,a1
    80005dae:	1782                	slli	a5,a5,0x20
    80005db0:	9381                	srli	a5,a5,0x20
    80005db2:	97b2                	add	a5,a5,a2
    80005db4:	0007c783          	lbu	a5,0(a5)
    80005db8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dbc:	0005079b          	sext.w	a5,a0
    80005dc0:	02b5553b          	divuw	a0,a0,a1
    80005dc4:	0685                	addi	a3,a3,1
    80005dc6:	feb7f0e3          	bgeu	a5,a1,80005da6 <printint+0x26>

  if(sign)
    80005dca:	00088b63          	beqz	a7,80005de0 <printint+0x60>
    buf[i++] = '-';
    80005dce:	fe040793          	addi	a5,s0,-32
    80005dd2:	973e                	add	a4,a4,a5
    80005dd4:	02d00793          	li	a5,45
    80005dd8:	fef70823          	sb	a5,-16(a4)
    80005ddc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005de0:	02e05763          	blez	a4,80005e0e <printint+0x8e>
    80005de4:	fd040793          	addi	a5,s0,-48
    80005de8:	00e784b3          	add	s1,a5,a4
    80005dec:	fff78913          	addi	s2,a5,-1
    80005df0:	993a                	add	s2,s2,a4
    80005df2:	377d                	addiw	a4,a4,-1
    80005df4:	1702                	slli	a4,a4,0x20
    80005df6:	9301                	srli	a4,a4,0x20
    80005df8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dfc:	fff4c503          	lbu	a0,-1(s1)
    80005e00:	00000097          	auipc	ra,0x0
    80005e04:	d60080e7          	jalr	-672(ra) # 80005b60 <consputc>
  while(--i >= 0)
    80005e08:	14fd                	addi	s1,s1,-1
    80005e0a:	ff2499e3          	bne	s1,s2,80005dfc <printint+0x7c>
}
    80005e0e:	70a2                	ld	ra,40(sp)
    80005e10:	7402                	ld	s0,32(sp)
    80005e12:	64e2                	ld	s1,24(sp)
    80005e14:	6942                	ld	s2,16(sp)
    80005e16:	6145                	addi	sp,sp,48
    80005e18:	8082                	ret
    x = -xx;
    80005e1a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e1e:	4885                	li	a7,1
    x = -xx;
    80005e20:	bf9d                	j	80005d96 <printint+0x16>

0000000080005e22 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e22:	1101                	addi	sp,sp,-32
    80005e24:	ec06                	sd	ra,24(sp)
    80005e26:	e822                	sd	s0,16(sp)
    80005e28:	e426                	sd	s1,8(sp)
    80005e2a:	1000                	addi	s0,sp,32
    80005e2c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e2e:	0023c797          	auipc	a5,0x23c
    80005e32:	ec07a123          	sw	zero,-318(a5) # 80241cf0 <pr+0x18>
  printf("panic: ");
    80005e36:	00003517          	auipc	a0,0x3
    80005e3a:	99250513          	addi	a0,a0,-1646 # 800087c8 <syscalls+0x3f8>
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	02e080e7          	jalr	46(ra) # 80005e6c <printf>
  printf(s);
    80005e46:	8526                	mv	a0,s1
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	024080e7          	jalr	36(ra) # 80005e6c <printf>
  printf("\n");
    80005e50:	00002517          	auipc	a0,0x2
    80005e54:	1f850513          	addi	a0,a0,504 # 80008048 <etext+0x48>
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	014080e7          	jalr	20(ra) # 80005e6c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e60:	4785                	li	a5,1
    80005e62:	00003717          	auipc	a4,0x3
    80005e66:	a4f72523          	sw	a5,-1462(a4) # 800088ac <panicked>
  for(;;)
    80005e6a:	a001                	j	80005e6a <panic+0x48>

0000000080005e6c <printf>:
{
    80005e6c:	7131                	addi	sp,sp,-192
    80005e6e:	fc86                	sd	ra,120(sp)
    80005e70:	f8a2                	sd	s0,112(sp)
    80005e72:	f4a6                	sd	s1,104(sp)
    80005e74:	f0ca                	sd	s2,96(sp)
    80005e76:	ecce                	sd	s3,88(sp)
    80005e78:	e8d2                	sd	s4,80(sp)
    80005e7a:	e4d6                	sd	s5,72(sp)
    80005e7c:	e0da                	sd	s6,64(sp)
    80005e7e:	fc5e                	sd	s7,56(sp)
    80005e80:	f862                	sd	s8,48(sp)
    80005e82:	f466                	sd	s9,40(sp)
    80005e84:	f06a                	sd	s10,32(sp)
    80005e86:	ec6e                	sd	s11,24(sp)
    80005e88:	0100                	addi	s0,sp,128
    80005e8a:	8a2a                	mv	s4,a0
    80005e8c:	e40c                	sd	a1,8(s0)
    80005e8e:	e810                	sd	a2,16(s0)
    80005e90:	ec14                	sd	a3,24(s0)
    80005e92:	f018                	sd	a4,32(s0)
    80005e94:	f41c                	sd	a5,40(s0)
    80005e96:	03043823          	sd	a6,48(s0)
    80005e9a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e9e:	0023cd97          	auipc	s11,0x23c
    80005ea2:	e52dad83          	lw	s11,-430(s11) # 80241cf0 <pr+0x18>
  if(locking)
    80005ea6:	020d9b63          	bnez	s11,80005edc <printf+0x70>
  if (fmt == 0)
    80005eaa:	040a0263          	beqz	s4,80005eee <printf+0x82>
  va_start(ap, fmt);
    80005eae:	00840793          	addi	a5,s0,8
    80005eb2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eb6:	000a4503          	lbu	a0,0(s4)
    80005eba:	16050263          	beqz	a0,8000601e <printf+0x1b2>
    80005ebe:	4481                	li	s1,0
    if(c != '%'){
    80005ec0:	02500a93          	li	s5,37
    switch(c){
    80005ec4:	07000b13          	li	s6,112
  consputc('x');
    80005ec8:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eca:	00003b97          	auipc	s7,0x3
    80005ece:	926b8b93          	addi	s7,s7,-1754 # 800087f0 <digits>
    switch(c){
    80005ed2:	07300c93          	li	s9,115
    80005ed6:	06400c13          	li	s8,100
    80005eda:	a82d                	j	80005f14 <printf+0xa8>
    acquire(&pr.lock);
    80005edc:	0023c517          	auipc	a0,0x23c
    80005ee0:	dfc50513          	addi	a0,a0,-516 # 80241cd8 <pr>
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	488080e7          	jalr	1160(ra) # 8000636c <acquire>
    80005eec:	bf7d                	j	80005eaa <printf+0x3e>
    panic("null fmt");
    80005eee:	00003517          	auipc	a0,0x3
    80005ef2:	8ea50513          	addi	a0,a0,-1814 # 800087d8 <syscalls+0x408>
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	f2c080e7          	jalr	-212(ra) # 80005e22 <panic>
      consputc(c);
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	c62080e7          	jalr	-926(ra) # 80005b60 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f06:	2485                	addiw	s1,s1,1
    80005f08:	009a07b3          	add	a5,s4,s1
    80005f0c:	0007c503          	lbu	a0,0(a5)
    80005f10:	10050763          	beqz	a0,8000601e <printf+0x1b2>
    if(c != '%'){
    80005f14:	ff5515e3          	bne	a0,s5,80005efe <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f18:	2485                	addiw	s1,s1,1
    80005f1a:	009a07b3          	add	a5,s4,s1
    80005f1e:	0007c783          	lbu	a5,0(a5)
    80005f22:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f26:	cfe5                	beqz	a5,8000601e <printf+0x1b2>
    switch(c){
    80005f28:	05678a63          	beq	a5,s6,80005f7c <printf+0x110>
    80005f2c:	02fb7663          	bgeu	s6,a5,80005f58 <printf+0xec>
    80005f30:	09978963          	beq	a5,s9,80005fc2 <printf+0x156>
    80005f34:	07800713          	li	a4,120
    80005f38:	0ce79863          	bne	a5,a4,80006008 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f3c:	f8843783          	ld	a5,-120(s0)
    80005f40:	00878713          	addi	a4,a5,8
    80005f44:	f8e43423          	sd	a4,-120(s0)
    80005f48:	4605                	li	a2,1
    80005f4a:	85ea                	mv	a1,s10
    80005f4c:	4388                	lw	a0,0(a5)
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	e32080e7          	jalr	-462(ra) # 80005d80 <printint>
      break;
    80005f56:	bf45                	j	80005f06 <printf+0x9a>
    switch(c){
    80005f58:	0b578263          	beq	a5,s5,80005ffc <printf+0x190>
    80005f5c:	0b879663          	bne	a5,s8,80006008 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f60:	f8843783          	ld	a5,-120(s0)
    80005f64:	00878713          	addi	a4,a5,8
    80005f68:	f8e43423          	sd	a4,-120(s0)
    80005f6c:	4605                	li	a2,1
    80005f6e:	45a9                	li	a1,10
    80005f70:	4388                	lw	a0,0(a5)
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	e0e080e7          	jalr	-498(ra) # 80005d80 <printint>
      break;
    80005f7a:	b771                	j	80005f06 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f7c:	f8843783          	ld	a5,-120(s0)
    80005f80:	00878713          	addi	a4,a5,8
    80005f84:	f8e43423          	sd	a4,-120(s0)
    80005f88:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f8c:	03000513          	li	a0,48
    80005f90:	00000097          	auipc	ra,0x0
    80005f94:	bd0080e7          	jalr	-1072(ra) # 80005b60 <consputc>
  consputc('x');
    80005f98:	07800513          	li	a0,120
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	bc4080e7          	jalr	-1084(ra) # 80005b60 <consputc>
    80005fa4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fa6:	03c9d793          	srli	a5,s3,0x3c
    80005faa:	97de                	add	a5,a5,s7
    80005fac:	0007c503          	lbu	a0,0(a5)
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	bb0080e7          	jalr	-1104(ra) # 80005b60 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fb8:	0992                	slli	s3,s3,0x4
    80005fba:	397d                	addiw	s2,s2,-1
    80005fbc:	fe0915e3          	bnez	s2,80005fa6 <printf+0x13a>
    80005fc0:	b799                	j	80005f06 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fc2:	f8843783          	ld	a5,-120(s0)
    80005fc6:	00878713          	addi	a4,a5,8
    80005fca:	f8e43423          	sd	a4,-120(s0)
    80005fce:	0007b903          	ld	s2,0(a5)
    80005fd2:	00090e63          	beqz	s2,80005fee <printf+0x182>
      for(; *s; s++)
    80005fd6:	00094503          	lbu	a0,0(s2)
    80005fda:	d515                	beqz	a0,80005f06 <printf+0x9a>
        consputc(*s);
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	b84080e7          	jalr	-1148(ra) # 80005b60 <consputc>
      for(; *s; s++)
    80005fe4:	0905                	addi	s2,s2,1
    80005fe6:	00094503          	lbu	a0,0(s2)
    80005fea:	f96d                	bnez	a0,80005fdc <printf+0x170>
    80005fec:	bf29                	j	80005f06 <printf+0x9a>
        s = "(null)";
    80005fee:	00002917          	auipc	s2,0x2
    80005ff2:	7e290913          	addi	s2,s2,2018 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005ff6:	02800513          	li	a0,40
    80005ffa:	b7cd                	j	80005fdc <printf+0x170>
      consputc('%');
    80005ffc:	8556                	mv	a0,s5
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	b62080e7          	jalr	-1182(ra) # 80005b60 <consputc>
      break;
    80006006:	b701                	j	80005f06 <printf+0x9a>
      consputc('%');
    80006008:	8556                	mv	a0,s5
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	b56080e7          	jalr	-1194(ra) # 80005b60 <consputc>
      consputc(c);
    80006012:	854a                	mv	a0,s2
    80006014:	00000097          	auipc	ra,0x0
    80006018:	b4c080e7          	jalr	-1204(ra) # 80005b60 <consputc>
      break;
    8000601c:	b5ed                	j	80005f06 <printf+0x9a>
  if(locking)
    8000601e:	020d9163          	bnez	s11,80006040 <printf+0x1d4>
}
    80006022:	70e6                	ld	ra,120(sp)
    80006024:	7446                	ld	s0,112(sp)
    80006026:	74a6                	ld	s1,104(sp)
    80006028:	7906                	ld	s2,96(sp)
    8000602a:	69e6                	ld	s3,88(sp)
    8000602c:	6a46                	ld	s4,80(sp)
    8000602e:	6aa6                	ld	s5,72(sp)
    80006030:	6b06                	ld	s6,64(sp)
    80006032:	7be2                	ld	s7,56(sp)
    80006034:	7c42                	ld	s8,48(sp)
    80006036:	7ca2                	ld	s9,40(sp)
    80006038:	7d02                	ld	s10,32(sp)
    8000603a:	6de2                	ld	s11,24(sp)
    8000603c:	6129                	addi	sp,sp,192
    8000603e:	8082                	ret
    release(&pr.lock);
    80006040:	0023c517          	auipc	a0,0x23c
    80006044:	c9850513          	addi	a0,a0,-872 # 80241cd8 <pr>
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	3d8080e7          	jalr	984(ra) # 80006420 <release>
}
    80006050:	bfc9                	j	80006022 <printf+0x1b6>

0000000080006052 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006052:	1101                	addi	sp,sp,-32
    80006054:	ec06                	sd	ra,24(sp)
    80006056:	e822                	sd	s0,16(sp)
    80006058:	e426                	sd	s1,8(sp)
    8000605a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000605c:	0023c497          	auipc	s1,0x23c
    80006060:	c7c48493          	addi	s1,s1,-900 # 80241cd8 <pr>
    80006064:	00002597          	auipc	a1,0x2
    80006068:	78458593          	addi	a1,a1,1924 # 800087e8 <syscalls+0x418>
    8000606c:	8526                	mv	a0,s1
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	26e080e7          	jalr	622(ra) # 800062dc <initlock>
  pr.locking = 1;
    80006076:	4785                	li	a5,1
    80006078:	cc9c                	sw	a5,24(s1)
}
    8000607a:	60e2                	ld	ra,24(sp)
    8000607c:	6442                	ld	s0,16(sp)
    8000607e:	64a2                	ld	s1,8(sp)
    80006080:	6105                	addi	sp,sp,32
    80006082:	8082                	ret

0000000080006084 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006084:	1141                	addi	sp,sp,-16
    80006086:	e406                	sd	ra,8(sp)
    80006088:	e022                	sd	s0,0(sp)
    8000608a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000608c:	100007b7          	lui	a5,0x10000
    80006090:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006094:	f8000713          	li	a4,-128
    80006098:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000609c:	470d                	li	a4,3
    8000609e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060a2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060a6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060aa:	469d                	li	a3,7
    800060ac:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060b0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060b4:	00002597          	auipc	a1,0x2
    800060b8:	75458593          	addi	a1,a1,1876 # 80008808 <digits+0x18>
    800060bc:	0023c517          	auipc	a0,0x23c
    800060c0:	c3c50513          	addi	a0,a0,-964 # 80241cf8 <uart_tx_lock>
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	218080e7          	jalr	536(ra) # 800062dc <initlock>
}
    800060cc:	60a2                	ld	ra,8(sp)
    800060ce:	6402                	ld	s0,0(sp)
    800060d0:	0141                	addi	sp,sp,16
    800060d2:	8082                	ret

00000000800060d4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060d4:	1101                	addi	sp,sp,-32
    800060d6:	ec06                	sd	ra,24(sp)
    800060d8:	e822                	sd	s0,16(sp)
    800060da:	e426                	sd	s1,8(sp)
    800060dc:	1000                	addi	s0,sp,32
    800060de:	84aa                	mv	s1,a0
  push_off();
    800060e0:	00000097          	auipc	ra,0x0
    800060e4:	240080e7          	jalr	576(ra) # 80006320 <push_off>

  if(panicked){
    800060e8:	00002797          	auipc	a5,0x2
    800060ec:	7c47a783          	lw	a5,1988(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060f0:	10000737          	lui	a4,0x10000
  if(panicked){
    800060f4:	c391                	beqz	a5,800060f8 <uartputc_sync+0x24>
    for(;;)
    800060f6:	a001                	j	800060f6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060f8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060fc:	0ff7f793          	andi	a5,a5,255
    80006100:	0207f793          	andi	a5,a5,32
    80006104:	dbf5                	beqz	a5,800060f8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006106:	0ff4f793          	andi	a5,s1,255
    8000610a:	10000737          	lui	a4,0x10000
    8000610e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006112:	00000097          	auipc	ra,0x0
    80006116:	2ae080e7          	jalr	686(ra) # 800063c0 <pop_off>
}
    8000611a:	60e2                	ld	ra,24(sp)
    8000611c:	6442                	ld	s0,16(sp)
    8000611e:	64a2                	ld	s1,8(sp)
    80006120:	6105                	addi	sp,sp,32
    80006122:	8082                	ret

0000000080006124 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006124:	00002717          	auipc	a4,0x2
    80006128:	78c73703          	ld	a4,1932(a4) # 800088b0 <uart_tx_r>
    8000612c:	00002797          	auipc	a5,0x2
    80006130:	78c7b783          	ld	a5,1932(a5) # 800088b8 <uart_tx_w>
    80006134:	06e78c63          	beq	a5,a4,800061ac <uartstart+0x88>
{
    80006138:	7139                	addi	sp,sp,-64
    8000613a:	fc06                	sd	ra,56(sp)
    8000613c:	f822                	sd	s0,48(sp)
    8000613e:	f426                	sd	s1,40(sp)
    80006140:	f04a                	sd	s2,32(sp)
    80006142:	ec4e                	sd	s3,24(sp)
    80006144:	e852                	sd	s4,16(sp)
    80006146:	e456                	sd	s5,8(sp)
    80006148:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000614a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000614e:	0023ca17          	auipc	s4,0x23c
    80006152:	baaa0a13          	addi	s4,s4,-1110 # 80241cf8 <uart_tx_lock>
    uart_tx_r += 1;
    80006156:	00002497          	auipc	s1,0x2
    8000615a:	75a48493          	addi	s1,s1,1882 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000615e:	00002997          	auipc	s3,0x2
    80006162:	75a98993          	addi	s3,s3,1882 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006166:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000616a:	0ff7f793          	andi	a5,a5,255
    8000616e:	0207f793          	andi	a5,a5,32
    80006172:	c785                	beqz	a5,8000619a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006174:	01f77793          	andi	a5,a4,31
    80006178:	97d2                	add	a5,a5,s4
    8000617a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000617e:	0705                	addi	a4,a4,1
    80006180:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006182:	8526                	mv	a0,s1
    80006184:	ffffb097          	auipc	ra,0xffffb
    80006188:	5d0080e7          	jalr	1488(ra) # 80001754 <wakeup>
    
    WriteReg(THR, c);
    8000618c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006190:	6098                	ld	a4,0(s1)
    80006192:	0009b783          	ld	a5,0(s3)
    80006196:	fce798e3          	bne	a5,a4,80006166 <uartstart+0x42>
  }
}
    8000619a:	70e2                	ld	ra,56(sp)
    8000619c:	7442                	ld	s0,48(sp)
    8000619e:	74a2                	ld	s1,40(sp)
    800061a0:	7902                	ld	s2,32(sp)
    800061a2:	69e2                	ld	s3,24(sp)
    800061a4:	6a42                	ld	s4,16(sp)
    800061a6:	6aa2                	ld	s5,8(sp)
    800061a8:	6121                	addi	sp,sp,64
    800061aa:	8082                	ret
    800061ac:	8082                	ret

00000000800061ae <uartputc>:
{
    800061ae:	7179                	addi	sp,sp,-48
    800061b0:	f406                	sd	ra,40(sp)
    800061b2:	f022                	sd	s0,32(sp)
    800061b4:	ec26                	sd	s1,24(sp)
    800061b6:	e84a                	sd	s2,16(sp)
    800061b8:	e44e                	sd	s3,8(sp)
    800061ba:	e052                	sd	s4,0(sp)
    800061bc:	1800                	addi	s0,sp,48
    800061be:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061c0:	0023c517          	auipc	a0,0x23c
    800061c4:	b3850513          	addi	a0,a0,-1224 # 80241cf8 <uart_tx_lock>
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	1a4080e7          	jalr	420(ra) # 8000636c <acquire>
  if(panicked){
    800061d0:	00002797          	auipc	a5,0x2
    800061d4:	6dc7a783          	lw	a5,1756(a5) # 800088ac <panicked>
    800061d8:	e7c9                	bnez	a5,80006262 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061da:	00002797          	auipc	a5,0x2
    800061de:	6de7b783          	ld	a5,1758(a5) # 800088b8 <uart_tx_w>
    800061e2:	00002717          	auipc	a4,0x2
    800061e6:	6ce73703          	ld	a4,1742(a4) # 800088b0 <uart_tx_r>
    800061ea:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800061ee:	0023ca17          	auipc	s4,0x23c
    800061f2:	b0aa0a13          	addi	s4,s4,-1270 # 80241cf8 <uart_tx_lock>
    800061f6:	00002497          	auipc	s1,0x2
    800061fa:	6ba48493          	addi	s1,s1,1722 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061fe:	00002917          	auipc	s2,0x2
    80006202:	6ba90913          	addi	s2,s2,1722 # 800088b8 <uart_tx_w>
    80006206:	00f71f63          	bne	a4,a5,80006224 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000620a:	85d2                	mv	a1,s4
    8000620c:	8526                	mv	a0,s1
    8000620e:	ffffb097          	auipc	ra,0xffffb
    80006212:	4e2080e7          	jalr	1250(ra) # 800016f0 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006216:	00093783          	ld	a5,0(s2)
    8000621a:	6098                	ld	a4,0(s1)
    8000621c:	02070713          	addi	a4,a4,32
    80006220:	fef705e3          	beq	a4,a5,8000620a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006224:	0023c497          	auipc	s1,0x23c
    80006228:	ad448493          	addi	s1,s1,-1324 # 80241cf8 <uart_tx_lock>
    8000622c:	01f7f713          	andi	a4,a5,31
    80006230:	9726                	add	a4,a4,s1
    80006232:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006236:	0785                	addi	a5,a5,1
    80006238:	00002717          	auipc	a4,0x2
    8000623c:	68f73023          	sd	a5,1664(a4) # 800088b8 <uart_tx_w>
  uartstart();
    80006240:	00000097          	auipc	ra,0x0
    80006244:	ee4080e7          	jalr	-284(ra) # 80006124 <uartstart>
  release(&uart_tx_lock);
    80006248:	8526                	mv	a0,s1
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	1d6080e7          	jalr	470(ra) # 80006420 <release>
}
    80006252:	70a2                	ld	ra,40(sp)
    80006254:	7402                	ld	s0,32(sp)
    80006256:	64e2                	ld	s1,24(sp)
    80006258:	6942                	ld	s2,16(sp)
    8000625a:	69a2                	ld	s3,8(sp)
    8000625c:	6a02                	ld	s4,0(sp)
    8000625e:	6145                	addi	sp,sp,48
    80006260:	8082                	ret
    for(;;)
    80006262:	a001                	j	80006262 <uartputc+0xb4>

0000000080006264 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006264:	1141                	addi	sp,sp,-16
    80006266:	e422                	sd	s0,8(sp)
    80006268:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000626a:	100007b7          	lui	a5,0x10000
    8000626e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006272:	8b85                	andi	a5,a5,1
    80006274:	cb91                	beqz	a5,80006288 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006276:	100007b7          	lui	a5,0x10000
    8000627a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000627e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006282:	6422                	ld	s0,8(sp)
    80006284:	0141                	addi	sp,sp,16
    80006286:	8082                	ret
    return -1;
    80006288:	557d                	li	a0,-1
    8000628a:	bfe5                	j	80006282 <uartgetc+0x1e>

000000008000628c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000628c:	1101                	addi	sp,sp,-32
    8000628e:	ec06                	sd	ra,24(sp)
    80006290:	e822                	sd	s0,16(sp)
    80006292:	e426                	sd	s1,8(sp)
    80006294:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006296:	54fd                	li	s1,-1
    int c = uartgetc();
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	fcc080e7          	jalr	-52(ra) # 80006264 <uartgetc>
    if(c == -1)
    800062a0:	00950763          	beq	a0,s1,800062ae <uartintr+0x22>
      break;
    consoleintr(c);
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	8fe080e7          	jalr	-1794(ra) # 80005ba2 <consoleintr>
  while(1){
    800062ac:	b7f5                	j	80006298 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062ae:	0023c497          	auipc	s1,0x23c
    800062b2:	a4a48493          	addi	s1,s1,-1462 # 80241cf8 <uart_tx_lock>
    800062b6:	8526                	mv	a0,s1
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	0b4080e7          	jalr	180(ra) # 8000636c <acquire>
  uartstart();
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	e64080e7          	jalr	-412(ra) # 80006124 <uartstart>
  release(&uart_tx_lock);
    800062c8:	8526                	mv	a0,s1
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	156080e7          	jalr	342(ra) # 80006420 <release>
}
    800062d2:	60e2                	ld	ra,24(sp)
    800062d4:	6442                	ld	s0,16(sp)
    800062d6:	64a2                	ld	s1,8(sp)
    800062d8:	6105                	addi	sp,sp,32
    800062da:	8082                	ret

00000000800062dc <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062dc:	1141                	addi	sp,sp,-16
    800062de:	e422                	sd	s0,8(sp)
    800062e0:	0800                	addi	s0,sp,16
  lk->name = name;
    800062e2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062e4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062e8:	00053823          	sd	zero,16(a0)
}
    800062ec:	6422                	ld	s0,8(sp)
    800062ee:	0141                	addi	sp,sp,16
    800062f0:	8082                	ret

00000000800062f2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062f2:	411c                	lw	a5,0(a0)
    800062f4:	e399                	bnez	a5,800062fa <holding+0x8>
    800062f6:	4501                	li	a0,0
  return r;
}
    800062f8:	8082                	ret
{
    800062fa:	1101                	addi	sp,sp,-32
    800062fc:	ec06                	sd	ra,24(sp)
    800062fe:	e822                	sd	s0,16(sp)
    80006300:	e426                	sd	s1,8(sp)
    80006302:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006304:	6904                	ld	s1,16(a0)
    80006306:	ffffb097          	auipc	ra,0xffffb
    8000630a:	d2a080e7          	jalr	-726(ra) # 80001030 <mycpu>
    8000630e:	40a48533          	sub	a0,s1,a0
    80006312:	00153513          	seqz	a0,a0
}
    80006316:	60e2                	ld	ra,24(sp)
    80006318:	6442                	ld	s0,16(sp)
    8000631a:	64a2                	ld	s1,8(sp)
    8000631c:	6105                	addi	sp,sp,32
    8000631e:	8082                	ret

0000000080006320 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006320:	1101                	addi	sp,sp,-32
    80006322:	ec06                	sd	ra,24(sp)
    80006324:	e822                	sd	s0,16(sp)
    80006326:	e426                	sd	s1,8(sp)
    80006328:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000632a:	100024f3          	csrr	s1,sstatus
    8000632e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006332:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006334:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006338:	ffffb097          	auipc	ra,0xffffb
    8000633c:	cf8080e7          	jalr	-776(ra) # 80001030 <mycpu>
    80006340:	5d3c                	lw	a5,120(a0)
    80006342:	cf89                	beqz	a5,8000635c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006344:	ffffb097          	auipc	ra,0xffffb
    80006348:	cec080e7          	jalr	-788(ra) # 80001030 <mycpu>
    8000634c:	5d3c                	lw	a5,120(a0)
    8000634e:	2785                	addiw	a5,a5,1
    80006350:	dd3c                	sw	a5,120(a0)
}
    80006352:	60e2                	ld	ra,24(sp)
    80006354:	6442                	ld	s0,16(sp)
    80006356:	64a2                	ld	s1,8(sp)
    80006358:	6105                	addi	sp,sp,32
    8000635a:	8082                	ret
    mycpu()->intena = old;
    8000635c:	ffffb097          	auipc	ra,0xffffb
    80006360:	cd4080e7          	jalr	-812(ra) # 80001030 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006364:	8085                	srli	s1,s1,0x1
    80006366:	8885                	andi	s1,s1,1
    80006368:	dd64                	sw	s1,124(a0)
    8000636a:	bfe9                	j	80006344 <push_off+0x24>

000000008000636c <acquire>:
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	1000                	addi	s0,sp,32
    80006376:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	fa8080e7          	jalr	-88(ra) # 80006320 <push_off>
  if(holding(lk))
    80006380:	8526                	mv	a0,s1
    80006382:	00000097          	auipc	ra,0x0
    80006386:	f70080e7          	jalr	-144(ra) # 800062f2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000638a:	4705                	li	a4,1
  if(holding(lk))
    8000638c:	e115                	bnez	a0,800063b0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000638e:	87ba                	mv	a5,a4
    80006390:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006394:	2781                	sext.w	a5,a5
    80006396:	ffe5                	bnez	a5,8000638e <acquire+0x22>
  __sync_synchronize();
    80006398:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000639c:	ffffb097          	auipc	ra,0xffffb
    800063a0:	c94080e7          	jalr	-876(ra) # 80001030 <mycpu>
    800063a4:	e888                	sd	a0,16(s1)
}
    800063a6:	60e2                	ld	ra,24(sp)
    800063a8:	6442                	ld	s0,16(sp)
    800063aa:	64a2                	ld	s1,8(sp)
    800063ac:	6105                	addi	sp,sp,32
    800063ae:	8082                	ret
    panic("acquire");
    800063b0:	00002517          	auipc	a0,0x2
    800063b4:	46050513          	addi	a0,a0,1120 # 80008810 <digits+0x20>
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	a6a080e7          	jalr	-1430(ra) # 80005e22 <panic>

00000000800063c0 <pop_off>:

void
pop_off(void)
{
    800063c0:	1141                	addi	sp,sp,-16
    800063c2:	e406                	sd	ra,8(sp)
    800063c4:	e022                	sd	s0,0(sp)
    800063c6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063c8:	ffffb097          	auipc	ra,0xffffb
    800063cc:	c68080e7          	jalr	-920(ra) # 80001030 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063d0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063d4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063d6:	e78d                	bnez	a5,80006400 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063d8:	5d3c                	lw	a5,120(a0)
    800063da:	02f05b63          	blez	a5,80006410 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063de:	37fd                	addiw	a5,a5,-1
    800063e0:	0007871b          	sext.w	a4,a5
    800063e4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063e6:	eb09                	bnez	a4,800063f8 <pop_off+0x38>
    800063e8:	5d7c                	lw	a5,124(a0)
    800063ea:	c799                	beqz	a5,800063f8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063f4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063f8:	60a2                	ld	ra,8(sp)
    800063fa:	6402                	ld	s0,0(sp)
    800063fc:	0141                	addi	sp,sp,16
    800063fe:	8082                	ret
    panic("pop_off - interruptible");
    80006400:	00002517          	auipc	a0,0x2
    80006404:	41850513          	addi	a0,a0,1048 # 80008818 <digits+0x28>
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	a1a080e7          	jalr	-1510(ra) # 80005e22 <panic>
    panic("pop_off");
    80006410:	00002517          	auipc	a0,0x2
    80006414:	42050513          	addi	a0,a0,1056 # 80008830 <digits+0x40>
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	a0a080e7          	jalr	-1526(ra) # 80005e22 <panic>

0000000080006420 <release>:
{
    80006420:	1101                	addi	sp,sp,-32
    80006422:	ec06                	sd	ra,24(sp)
    80006424:	e822                	sd	s0,16(sp)
    80006426:	e426                	sd	s1,8(sp)
    80006428:	1000                	addi	s0,sp,32
    8000642a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000642c:	00000097          	auipc	ra,0x0
    80006430:	ec6080e7          	jalr	-314(ra) # 800062f2 <holding>
    80006434:	c115                	beqz	a0,80006458 <release+0x38>
  lk->cpu = 0;
    80006436:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000643a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000643e:	0f50000f          	fence	iorw,ow
    80006442:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006446:	00000097          	auipc	ra,0x0
    8000644a:	f7a080e7          	jalr	-134(ra) # 800063c0 <pop_off>
}
    8000644e:	60e2                	ld	ra,24(sp)
    80006450:	6442                	ld	s0,16(sp)
    80006452:	64a2                	ld	s1,8(sp)
    80006454:	6105                	addi	sp,sp,32
    80006456:	8082                	ret
    panic("release");
    80006458:	00002517          	auipc	a0,0x2
    8000645c:	3e050513          	addi	a0,a0,992 # 80008838 <digits+0x48>
    80006460:	00000097          	auipc	ra,0x0
    80006464:	9c2080e7          	jalr	-1598(ra) # 80005e22 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
