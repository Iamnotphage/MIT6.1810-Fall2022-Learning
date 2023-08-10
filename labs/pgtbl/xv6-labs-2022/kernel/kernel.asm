
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	66010113          	addi	sp,sp,1632 # 8001a660 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	037050ef          	jal	ra,8000584c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	73078793          	addi	a5,a5,1840 # 80022760 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	8a090913          	addi	s2,s2,-1888 # 800088f0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	254080e7          	jalr	596(ra) # 800062ae <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2f4080e7          	jalr	756(ra) # 80006362 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d04080e7          	jalr	-764(ra) # 80005d8e <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	80450513          	addi	a0,a0,-2044 # 800088f0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	12a080e7          	jalr	298(ra) # 8000621e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	66050513          	addi	a0,a0,1632 # 80022760 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7ce48493          	addi	s1,s1,1998 # 800088f0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	182080e7          	jalr	386(ra) # 800062ae <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7b650513          	addi	a0,a0,1974 # 800088f0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	21e080e7          	jalr	542(ra) # 80006362 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	78a50513          	addi	a0,a0,1930 # 800088f0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	1f4080e7          	jalr	500(ra) # 80006362 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	afe080e7          	jalr	-1282(ra) # 80000e2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	58a70713          	addi	a4,a4,1418 # 800088c0 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ae2080e7          	jalr	-1310(ra) # 80000e2c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	a84080e7          	jalr	-1404(ra) # 80005de0 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7c4080e7          	jalr	1988(ra) # 80001b30 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	e2c080e7          	jalr	-468(ra) # 800051a0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	00e080e7          	jalr	14(ra) # 8000138a <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	890080e7          	jalr	-1904(ra) # 80005c14 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	976080e7          	jalr	-1674(ra) # 80005d02 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a44080e7          	jalr	-1468(ra) # 80005de0 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a34080e7          	jalr	-1484(ra) # 80005de0 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a24080e7          	jalr	-1500(ra) # 80005de0 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	99c080e7          	jalr	-1636(ra) # 80000d78 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	724080e7          	jalr	1828(ra) # 80001b08 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	744080e7          	jalr	1860(ra) # 80001b30 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d96080e7          	jalr	-618(ra) # 8000518a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	da4080e7          	jalr	-604(ra) # 800051a0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f52080e7          	jalr	-174(ra) # 80002356 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5f6080e7          	jalr	1526(ra) # 80002a02 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	594080e7          	jalr	1428(ra) # 800039a8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e8c080e7          	jalr	-372(ra) # 800052a8 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d4c080e7          	jalr	-692(ra) # 80001170 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	48f72723          	sw	a5,1166(a4) # 800088c0 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	4827b783          	ld	a5,1154(a5) # 800088c8 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	8fc080e7          	jalr	-1796(ra) # 80005d8e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	804080e7          	jalr	-2044(ra) # 80005d8e <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	7f4080e7          	jalr	2036(ra) # 80005d8e <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00005097          	auipc	ra,0x5
    80000618:	77a080e7          	jalr	1914(ra) # 80005d8e <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	606080e7          	jalr	1542(ra) # 80000ce2 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	1ca7b323          	sd	a0,454(a5) # 800088c8 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6b05                	lui	s6,0x1
    8000073e:	0735e863          	bltu	a1,s3,800007ae <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	62e080e7          	jalr	1582(ra) # 80005d8e <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	61e080e7          	jalr	1566(ra) # 80005d8e <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	60e080e7          	jalr	1550(ra) # 80005d8e <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	5fe080e7          	jalr	1534(ra) # 80005d8e <panic>
      uint64 pa = PTE2PA(*pte);
    80000798:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000079a:	0532                	slli	a0,a0,0xc
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	880080e7          	jalr	-1920(ra) # 8000001c <kfree>
    *pte = 0;
    800007a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a8:	995a                	add	s2,s2,s6
    800007aa:	f9397ce3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ae:	4601                	li	a2,0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	8552                	mv	a0,s4
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	cb0080e7          	jalr	-848(ra) # 80000464 <walk>
    800007bc:	84aa                	mv	s1,a0
    800007be:	d54d                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007c0:	6108                	ld	a0,0(a0)
    800007c2:	00157793          	andi	a5,a0,1
    800007c6:	dbcd                	beqz	a5,80000778 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c8:	3ff57793          	andi	a5,a0,1023
    800007cc:	fb778ee3          	beq	a5,s7,80000788 <uvmunmap+0x76>
    if(do_free){
    800007d0:	fc0a8ae3          	beqz	s5,800007a4 <uvmunmap+0x92>
    800007d4:	b7d1                	j	80000798 <uvmunmap+0x86>

00000000800007d6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	938080e7          	jalr	-1736(ra) # 80000118 <kalloc>
    800007e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007ea:	c519                	beqz	a0,800007f8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ec:	6605                	lui	a2,0x1
    800007ee:	4581                	li	a1,0
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  return pagetable;
}
    800007f8:	8526                	mv	a0,s1
    800007fa:	60e2                	ld	ra,24(sp)
    800007fc:	6442                	ld	s0,16(sp)
    800007fe:	64a2                	ld	s1,8(sp)
    80000800:	6105                	addi	sp,sp,32
    80000802:	8082                	ret

0000000080000804 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000804:	7179                	addi	sp,sp,-48
    80000806:	f406                	sd	ra,40(sp)
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	ec26                	sd	s1,24(sp)
    8000080c:	e84a                	sd	s2,16(sp)
    8000080e:	e44e                	sd	s3,8(sp)
    80000810:	e052                	sd	s4,0(sp)
    80000812:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000814:	6785                	lui	a5,0x1
    80000816:	04f67863          	bgeu	a2,a5,80000866 <uvmfirst+0x62>
    8000081a:	8a2a                	mv	s4,a0
    8000081c:	89ae                	mv	s3,a1
    8000081e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8f8080e7          	jalr	-1800(ra) # 80000118 <kalloc>
    80000828:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	94a080e7          	jalr	-1718(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000836:	4779                	li	a4,30
    80000838:	86ca                	mv	a3,s2
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	8552                	mv	a0,s4
    80000840:	00000097          	auipc	ra,0x0
    80000844:	d0c080e7          	jalr	-756(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    80000848:	8626                	mv	a2,s1
    8000084a:	85ce                	mv	a1,s3
    8000084c:	854a                	mv	a0,s2
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
}
    80000856:	70a2                	ld	ra,40(sp)
    80000858:	7402                	ld	s0,32(sp)
    8000085a:	64e2                	ld	s1,24(sp)
    8000085c:	6942                	ld	s2,16(sp)
    8000085e:	69a2                	ld	s3,8(sp)
    80000860:	6a02                	ld	s4,0(sp)
    80000862:	6145                	addi	sp,sp,48
    80000864:	8082                	ret
    panic("uvmfirst: more than a page");
    80000866:	00008517          	auipc	a0,0x8
    8000086a:	87250513          	addi	a0,a0,-1934 # 800080d8 <etext+0xd8>
    8000086e:	00005097          	auipc	ra,0x5
    80000872:	520080e7          	jalr	1312(ra) # 80005d8e <panic>

0000000080000876 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000876:	1101                	addi	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000880:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000882:	00b67d63          	bgeu	a2,a1,8000089c <uvmdealloc+0x26>
    80000886:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000888:	6785                	lui	a5,0x1
    8000088a:	17fd                	addi	a5,a5,-1
    8000088c:	00f60733          	add	a4,a2,a5
    80000890:	767d                	lui	a2,0xfffff
    80000892:	8f71                	and	a4,a4,a2
    80000894:	97ae                	add	a5,a5,a1
    80000896:	8ff1                	and	a5,a5,a2
    80000898:	00f76863          	bltu	a4,a5,800008a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089c:	8526                	mv	a0,s1
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a8:	8f99                	sub	a5,a5,a4
    800008aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ac:	4685                	li	a3,1
    800008ae:	0007861b          	sext.w	a2,a5
    800008b2:	85ba                	mv	a1,a4
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	e5e080e7          	jalr	-418(ra) # 80000712 <uvmunmap>
    800008bc:	b7c5                	j	8000089c <uvmdealloc+0x26>

00000000800008be <uvmalloc>:
  if(newsz < oldsz)
    800008be:	0ab66563          	bltu	a2,a1,80000968 <uvmalloc+0xaa>
{
    800008c2:	7139                	addi	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	e05a                	sd	s6,0(sp)
    800008d4:	0080                	addi	s0,sp,64
    800008d6:	8aaa                	mv	s5,a0
    800008d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008da:	6985                	lui	s3,0x1
    800008dc:	19fd                	addi	s3,s3,-1
    800008de:	95ce                	add	a1,a1,s3
    800008e0:	79fd                	lui	s3,0xfffff
    800008e2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e6:	08c9f363          	bgeu	s3,a2,8000096c <uvmalloc+0xae>
    800008ea:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ec:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	828080e7          	jalr	-2008(ra) # 80000118 <kalloc>
    800008f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008fa:	c51d                	beqz	a0,80000928 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008fc:	6605                	lui	a2,0x1
    800008fe:	4581                	li	a1,0
    80000900:	00000097          	auipc	ra,0x0
    80000904:	878080e7          	jalr	-1928(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	875a                	mv	a4,s6
    8000090a:	86a6                	mv	a3,s1
    8000090c:	6605                	lui	a2,0x1
    8000090e:	85ca                	mv	a1,s2
    80000910:	8556                	mv	a0,s5
    80000912:	00000097          	auipc	ra,0x0
    80000916:	c3a080e7          	jalr	-966(ra) # 8000054c <mappages>
    8000091a:	e90d                	bnez	a0,8000094c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000091c:	6785                	lui	a5,0x1
    8000091e:	993e                	add	s2,s2,a5
    80000920:	fd4968e3          	bltu	s2,s4,800008f0 <uvmalloc+0x32>
  return newsz;
    80000924:	8552                	mv	a0,s4
    80000926:	a809                	j	80000938 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000928:	864e                	mv	a2,s3
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	f48080e7          	jalr	-184(ra) # 80000876 <uvmdealloc>
      return 0;
    80000936:	4501                	li	a0,0
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	74a2                	ld	s1,40(sp)
    8000093e:	7902                	ld	s2,32(sp)
    80000940:	69e2                	ld	s3,24(sp)
    80000942:	6a42                	ld	s4,16(sp)
    80000944:	6aa2                	ld	s5,8(sp)
    80000946:	6b02                	ld	s6,0(sp)
    80000948:	6121                	addi	sp,sp,64
    8000094a:	8082                	ret
      kfree(mem);
    8000094c:	8526                	mv	a0,s1
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	6ce080e7          	jalr	1742(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000956:	864e                	mv	a2,s3
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f1a080e7          	jalr	-230(ra) # 80000876 <uvmdealloc>
      return 0;
    80000964:	4501                	li	a0,0
    80000966:	bfc9                	j	80000938 <uvmalloc+0x7a>
    return oldsz;
    80000968:	852e                	mv	a0,a1
}
    8000096a:	8082                	ret
  return newsz;
    8000096c:	8532                	mv	a0,a2
    8000096e:	b7e9                	j	80000938 <uvmalloc+0x7a>

0000000080000970 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000970:	7179                	addi	sp,sp,-48
    80000972:	f406                	sd	ra,40(sp)
    80000974:	f022                	sd	s0,32(sp)
    80000976:	ec26                	sd	s1,24(sp)
    80000978:	e84a                	sd	s2,16(sp)
    8000097a:	e44e                	sd	s3,8(sp)
    8000097c:	e052                	sd	s4,0(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000982:	84aa                	mv	s1,a0
    80000984:	6905                	lui	s2,0x1
    80000986:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000988:	4985                	li	s3,1
    8000098a:	a821                	j	800009a2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000098e:	0532                	slli	a0,a0,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fe0080e7          	jalr	-32(ra) # 80000970 <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009a2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f57793          	andi	a5,a0,15
    800009a8:	ff3782e3          	beq	a5,s3,8000098c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8905                	andi	a0,a0,1
    800009ae:	d57d                	beqz	a0,8000099c <freewalk+0x2c>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	3d6080e7          	jalr	982(ra) # 80005d8e <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f86080e7          	jalr	-122(ra) # 80000970 <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	167d                	addi	a2,a2,-1
    80000a00:	962e                	add	a2,a2,a1
    80000a02:	4685                	li	a3,1
    80000a04:	8231                	srli	a2,a2,0xc
    80000a06:	4581                	li	a1,0
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	d0a080e7          	jalr	-758(ra) # 80000712 <uvmunmap>
    80000a10:	bfe1                	j	800009e8 <uvmfree+0xe>

0000000080000a12 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a12:	c679                	beqz	a2,80000ae0 <uvmcopy+0xce>
{
    80000a14:	715d                	addi	sp,sp,-80
    80000a16:	e486                	sd	ra,72(sp)
    80000a18:	e0a2                	sd	s0,64(sp)
    80000a1a:	fc26                	sd	s1,56(sp)
    80000a1c:	f84a                	sd	s2,48(sp)
    80000a1e:	f44e                	sd	s3,40(sp)
    80000a20:	f052                	sd	s4,32(sp)
    80000a22:	ec56                	sd	s5,24(sp)
    80000a24:	e85a                	sd	s6,16(sp)
    80000a26:	e45e                	sd	s7,8(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8aae                	mv	s5,a1
    80000a2e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a30:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85ce                	mv	a1,s3
    80000a36:	855a                	mv	a0,s6
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a2c080e7          	jalr	-1492(ra) # 80000464 <walk>
    80000a40:	c531                	beqz	a0,80000a8c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	cbb1                	beqz	a5,80000a9c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	892a                	mv	s2,a0
    80000a60:	c939                	beqz	a0,80000ab6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	8726                	mv	a4,s1
    80000a70:	86ca                	mv	a3,s2
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85ce                	mv	a1,s3
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad4080e7          	jalr	-1324(ra) # 8000054c <mappages>
    80000a80:	e515                	bnez	a0,80000aac <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a82:	6785                	lui	a5,0x1
    80000a84:	99be                	add	s3,s3,a5
    80000a86:	fb49e6e3          	bltu	s3,s4,80000a32 <uvmcopy+0x20>
    80000a8a:	a081                	j	80000aca <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	2fa080e7          	jalr	762(ra) # 80005d8e <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	2ea080e7          	jalr	746(ra) # 80005d8e <panic>
      kfree(mem);
    80000aac:	854a                	mv	a0,s2
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	56e080e7          	jalr	1390(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab6:	4685                	li	a3,1
    80000ab8:	00c9d613          	srli	a2,s3,0xc
    80000abc:	4581                	li	a1,0
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	c52080e7          	jalr	-942(ra) # 80000712 <uvmunmap>
  return -1;
    80000ac8:	557d                	li	a0,-1
}
    80000aca:	60a6                	ld	ra,72(sp)
    80000acc:	6406                	ld	s0,64(sp)
    80000ace:	74e2                	ld	s1,56(sp)
    80000ad0:	7942                	ld	s2,48(sp)
    80000ad2:	79a2                	ld	s3,40(sp)
    80000ad4:	7a02                	ld	s4,32(sp)
    80000ad6:	6ae2                	ld	s5,24(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
    80000ada:	6ba2                	ld	s7,8(sp)
    80000adc:	6161                	addi	sp,sp,80
    80000ade:	8082                	ret
  return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	8082                	ret

0000000080000ae4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aec:	4601                	li	a2,0
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	976080e7          	jalr	-1674(ra) # 80000464 <walk>
  if(pte == 0)
    80000af6:	c901                	beqz	a0,80000b06 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af8:	611c                	ld	a5,0(a0)
    80000afa:	9bbd                	andi	a5,a5,-17
    80000afc:	e11c                	sd	a5,0(a0)
}
    80000afe:	60a2                	ld	ra,8(sp)
    80000b00:	6402                	ld	s0,0(sp)
    80000b02:	0141                	addi	sp,sp,16
    80000b04:	8082                	ret
    panic("uvmclear");
    80000b06:	00007517          	auipc	a0,0x7
    80000b0a:	64250513          	addi	a0,a0,1602 # 80008148 <etext+0x148>
    80000b0e:	00005097          	auipc	ra,0x5
    80000b12:	280080e7          	jalr	640(ra) # 80005d8e <panic>

0000000080000b16 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b16:	c6bd                	beqz	a3,80000b84 <copyout+0x6e>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	e062                	sd	s8,0(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8c2e                	mv	s8,a1
    80000b34:	8a32                	mv	s4,a2
    80000b36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b64:	85ca                	mv	a1,s2
    80000b66:	855a                	mv	a0,s6
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9a2080e7          	jalr	-1630(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b70:	cd01                	beqz	a0,80000b88 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b72:	418904b3          	sub	s1,s2,s8
    80000b76:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b78:	fc99f3e3          	bgeu	s3,s1,80000b3e <copyout+0x28>
    80000b7c:	84ce                	mv	s1,s3
    80000b7e:	b7c1                	j	80000b3e <copyout+0x28>
  }
  return 0;
    80000b80:	4501                	li	a0,0
    80000b82:	a021                	j	80000b8a <copyout+0x74>
    80000b84:	4501                	li	a0,0
}
    80000b86:	8082                	ret
      return -1;
    80000b88:	557d                	li	a0,-1
}
    80000b8a:	60a6                	ld	ra,72(sp)
    80000b8c:	6406                	ld	s0,64(sp)
    80000b8e:	74e2                	ld	s1,56(sp)
    80000b90:	7942                	ld	s2,48(sp)
    80000b92:	79a2                	ld	s3,40(sp)
    80000b94:	7a02                	ld	s4,32(sp)
    80000b96:	6ae2                	ld	s5,24(sp)
    80000b98:	6b42                	ld	s6,16(sp)
    80000b9a:	6ba2                	ld	s7,8(sp)
    80000b9c:	6c02                	ld	s8,0(sp)
    80000b9e:	6161                	addi	sp,sp,80
    80000ba0:	8082                	ret

0000000080000ba2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba2:	c6bd                	beqz	a3,80000c10 <copyin+0x6e>
{
    80000ba4:	715d                	addi	sp,sp,-80
    80000ba6:	e486                	sd	ra,72(sp)
    80000ba8:	e0a2                	sd	s0,64(sp)
    80000baa:	fc26                	sd	s1,56(sp)
    80000bac:	f84a                	sd	s2,48(sp)
    80000bae:	f44e                	sd	s3,40(sp)
    80000bb0:	f052                	sd	s4,32(sp)
    80000bb2:	ec56                	sd	s5,24(sp)
    80000bb4:	e85a                	sd	s6,16(sp)
    80000bb6:	e45e                	sd	s7,8(sp)
    80000bb8:	e062                	sd	s8,0(sp)
    80000bba:	0880                	addi	s0,sp,80
    80000bbc:	8b2a                	mv	s6,a0
    80000bbe:	8a2e                	mv	s4,a1
    80000bc0:	8c32                	mv	s8,a2
    80000bc2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc6:	6a85                	lui	s5,0x1
    80000bc8:	a015                	j	80000bec <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bca:	9562                	add	a0,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412505b3          	sub	a1,a0,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	602080e7          	jalr	1538(ra) # 800001d8 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	916080e7          	jalr	-1770(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c04:	fc99f3e3          	bgeu	s3,s1,80000bca <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	b7c1                	j	80000bca <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x74>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c6c5                	beqz	a3,80000cd6 <copyinstr+0xa8>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a035                	j	80000c7e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	0017b793          	seqz	a5,a5
    80000c5e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c78:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7c:	c8a9                	beqz	s1,80000cce <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c7e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85ca                	mv	a1,s2
    80000c84:	8552                	mv	a0,s4
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	884080e7          	jalr	-1916(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c8e:	c131                	beqz	a0,80000cd2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c90:	41790833          	sub	a6,s2,s7
    80000c94:	984e                	add	a6,a6,s3
    if(n > max)
    80000c96:	0104f363          	bgeu	s1,a6,80000c9c <copyinstr+0x6e>
    80000c9a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9c:	955e                	add	a0,a0,s7
    80000c9e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca2:	fc080be3          	beqz	a6,80000c78 <copyinstr+0x4a>
    80000ca6:	985a                	add	a6,a6,s6
    80000ca8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000caa:	41650633          	sub	a2,a0,s6
    80000cae:	14fd                	addi	s1,s1,-1
    80000cb0:	9b26                	add	s6,s6,s1
    80000cb2:	00f60733          	add	a4,a2,a5
    80000cb6:	00074703          	lbu	a4,0(a4)
    80000cba:	df49                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cbc:	00e78023          	sb	a4,0(a5)
      --max;
    80000cc0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cc4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc6:	ff0796e3          	bne	a5,a6,80000cb2 <copyinstr+0x84>
      dst++;
    80000cca:	8b42                	mv	s6,a6
    80000ccc:	b775                	j	80000c78 <copyinstr+0x4a>
    80000cce:	4781                	li	a5,0
    80000cd0:	b769                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd2:	557d                	li	a0,-1
    80000cd4:	b779                	j	80000c62 <copyinstr+0x34>
  int got_null = 0;
    80000cd6:	4781                	li	a5,0
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
}
    80000ce0:	8082                	ret

0000000080000ce2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ce2:	7139                	addi	sp,sp,-64
    80000ce4:	fc06                	sd	ra,56(sp)
    80000ce6:	f822                	sd	s0,48(sp)
    80000ce8:	f426                	sd	s1,40(sp)
    80000cea:	f04a                	sd	s2,32(sp)
    80000cec:	ec4e                	sd	s3,24(sp)
    80000cee:	e852                	sd	s4,16(sp)
    80000cf0:	e456                	sd	s5,8(sp)
    80000cf2:	e05a                	sd	s6,0(sp)
    80000cf4:	0080                	addi	s0,sp,64
    80000cf6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	00008497          	auipc	s1,0x8
    80000cfc:	04848493          	addi	s1,s1,72 # 80008d40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	8b26                	mv	s6,s1
    80000d02:	00007a97          	auipc	s5,0x7
    80000d06:	2fea8a93          	addi	s5,s5,766 # 80008000 <etext>
    80000d0a:	04000937          	lui	s2,0x4000
    80000d0e:	197d                	addi	s2,s2,-1
    80000d10:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000ea17          	auipc	s4,0xe
    80000d16:	42ea0a13          	addi	s4,s4,1070 # 8000f140 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	3fe080e7          	jalr	1022(ra) # 80000118 <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c131                	beqz	a0,80000d68 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	8591                	srai	a1,a1,0x4
    80000d2c:	000ab783          	ld	a5,0(s5)
    80000d30:	02f585b3          	mul	a1,a1,a5
    80000d34:	2585                	addiw	a1,a1,1
    80000d36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d3a:	4719                	li	a4,6
    80000d3c:	6685                	lui	a3,0x1
    80000d3e:	40b905b3          	sub	a1,s2,a1
    80000d42:	854e                	mv	a0,s3
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	8a8080e7          	jalr	-1880(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	19048493          	addi	s1,s1,400
    80000d50:	fd4495e3          	bne	s1,s4,80000d1a <proc_mapstacks+0x38>
  }
}
    80000d54:	70e2                	ld	ra,56(sp)
    80000d56:	7442                	ld	s0,48(sp)
    80000d58:	74a2                	ld	s1,40(sp)
    80000d5a:	7902                	ld	s2,32(sp)
    80000d5c:	69e2                	ld	s3,24(sp)
    80000d5e:	6a42                	ld	s4,16(sp)
    80000d60:	6aa2                	ld	s5,8(sp)
    80000d62:	6b02                	ld	s6,0(sp)
    80000d64:	6121                	addi	sp,sp,64
    80000d66:	8082                	ret
      panic("kalloc");
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	3f050513          	addi	a0,a0,1008 # 80008158 <etext+0x158>
    80000d70:	00005097          	auipc	ra,0x5
    80000d74:	01e080e7          	jalr	30(ra) # 80005d8e <panic>

0000000080000d78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d78:	7139                	addi	sp,sp,-64
    80000d7a:	fc06                	sd	ra,56(sp)
    80000d7c:	f822                	sd	s0,48(sp)
    80000d7e:	f426                	sd	s1,40(sp)
    80000d80:	f04a                	sd	s2,32(sp)
    80000d82:	ec4e                	sd	s3,24(sp)
    80000d84:	e852                	sd	s4,16(sp)
    80000d86:	e456                	sd	s5,8(sp)
    80000d88:	e05a                	sd	s6,0(sp)
    80000d8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8c:	00007597          	auipc	a1,0x7
    80000d90:	3d458593          	addi	a1,a1,980 # 80008160 <etext+0x160>
    80000d94:	00008517          	auipc	a0,0x8
    80000d98:	b7c50513          	addi	a0,a0,-1156 # 80008910 <pid_lock>
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	482080e7          	jalr	1154(ra) # 8000621e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3c458593          	addi	a1,a1,964 # 80008168 <etext+0x168>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	b7c50513          	addi	a0,a0,-1156 # 80008928 <wait_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	46a080e7          	jalr	1130(ra) # 8000621e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbc:	00008497          	auipc	s1,0x8
    80000dc0:	f8448493          	addi	s1,s1,-124 # 80008d40 <proc>
      initlock(&p->lock, "proc");
    80000dc4:	00007b17          	auipc	s6,0x7
    80000dc8:	3b4b0b13          	addi	s6,s6,948 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	8aa6                	mv	s5,s1
    80000dce:	00007a17          	auipc	s4,0x7
    80000dd2:	232a0a13          	addi	s4,s4,562 # 80008000 <etext>
    80000dd6:	04000937          	lui	s2,0x4000
    80000dda:	197d                	addi	s2,s2,-1
    80000ddc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dde:	0000e997          	auipc	s3,0xe
    80000de2:	36298993          	addi	s3,s3,866 # 8000f140 <tickslock>
      initlock(&p->lock, "proc");
    80000de6:	85da                	mv	a1,s6
    80000de8:	8526                	mv	a0,s1
    80000dea:	00005097          	auipc	ra,0x5
    80000dee:	434080e7          	jalr	1076(ra) # 8000621e <initlock>
      p->state = UNUSED;
    80000df2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	415487b3          	sub	a5,s1,s5
    80000dfa:	8791                	srai	a5,a5,0x4
    80000dfc:	000a3703          	ld	a4,0(s4)
    80000e00:	02e787b3          	mul	a5,a5,a4
    80000e04:	2785                	addiw	a5,a5,1
    80000e06:	00d7979b          	slliw	a5,a5,0xd
    80000e0a:	40f907b3          	sub	a5,s2,a5
    80000e0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	19048493          	addi	s1,s1,400
    80000e14:	fd3499e3          	bne	s1,s3,80000de6 <procinit+0x6e>
  }
}
    80000e18:	70e2                	ld	ra,56(sp)
    80000e1a:	7442                	ld	s0,48(sp)
    80000e1c:	74a2                	ld	s1,40(sp)
    80000e1e:	7902                	ld	s2,32(sp)
    80000e20:	69e2                	ld	s3,24(sp)
    80000e22:	6a42                	ld	s4,16(sp)
    80000e24:	6aa2                	ld	s5,8(sp)
    80000e26:	6b02                	ld	s6,0(sp)
    80000e28:	6121                	addi	sp,sp,64
    80000e2a:	8082                	ret

0000000080000e2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e34:	2501                	sext.w	a0,a0
    80000e36:	6422                	ld	s0,8(sp)
    80000e38:	0141                	addi	sp,sp,16
    80000e3a:	8082                	ret

0000000080000e3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	addi	s0,sp,16
    80000e42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e44:	2781                	sext.w	a5,a5
    80000e46:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e48:	00008517          	auipc	a0,0x8
    80000e4c:	af850513          	addi	a0,a0,-1288 # 80008940 <cpus>
    80000e50:	953e                	add	a0,a0,a5
    80000e52:	6422                	ld	s0,8(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e58:	1101                	addi	sp,sp,-32
    80000e5a:	ec06                	sd	ra,24(sp)
    80000e5c:	e822                	sd	s0,16(sp)
    80000e5e:	e426                	sd	s1,8(sp)
    80000e60:	1000                	addi	s0,sp,32
  push_off();
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	400080e7          	jalr	1024(ra) # 80006262 <push_off>
    80000e6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e6c:	2781                	sext.w	a5,a5
    80000e6e:	079e                	slli	a5,a5,0x7
    80000e70:	00008717          	auipc	a4,0x8
    80000e74:	aa070713          	addi	a4,a4,-1376 # 80008910 <pid_lock>
    80000e78:	97ba                	add	a5,a5,a4
    80000e7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e7c:	00005097          	auipc	ra,0x5
    80000e80:	486080e7          	jalr	1158(ra) # 80006302 <pop_off>
  return p;
}
    80000e84:	8526                	mv	a0,s1
    80000e86:	60e2                	ld	ra,24(sp)
    80000e88:	6442                	ld	s0,16(sp)
    80000e8a:	64a2                	ld	s1,8(sp)
    80000e8c:	6105                	addi	sp,sp,32
    80000e8e:	8082                	ret

0000000080000e90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e90:	1141                	addi	sp,sp,-16
    80000e92:	e406                	sd	ra,8(sp)
    80000e94:	e022                	sd	s0,0(sp)
    80000e96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e98:	00000097          	auipc	ra,0x0
    80000e9c:	fc0080e7          	jalr	-64(ra) # 80000e58 <myproc>
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	4c2080e7          	jalr	1218(ra) # 80006362 <release>

  if (first) {
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	9c87a783          	lw	a5,-1592(a5) # 80008870 <first.1688>
    80000eb0:	eb89                	bnez	a5,80000ec2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	c96080e7          	jalr	-874(ra) # 80001b48 <usertrapret>
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
    first = 0;
    80000ec2:	00008797          	auipc	a5,0x8
    80000ec6:	9a07a723          	sw	zero,-1618(a5) # 80008870 <first.1688>
    fsinit(ROOTDEV);
    80000eca:	4505                	li	a0,1
    80000ecc:	00002097          	auipc	ra,0x2
    80000ed0:	ab6080e7          	jalr	-1354(ra) # 80002982 <fsinit>
    80000ed4:	bff9                	j	80000eb2 <forkret+0x22>

0000000080000ed6 <allocpid>:
{
    80000ed6:	1101                	addi	sp,sp,-32
    80000ed8:	ec06                	sd	ra,24(sp)
    80000eda:	e822                	sd	s0,16(sp)
    80000edc:	e426                	sd	s1,8(sp)
    80000ede:	e04a                	sd	s2,0(sp)
    80000ee0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee2:	00008917          	auipc	s2,0x8
    80000ee6:	a2e90913          	addi	s2,s2,-1490 # 80008910 <pid_lock>
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	3c2080e7          	jalr	962(ra) # 800062ae <acquire>
  pid = nextpid;
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	98078793          	addi	a5,a5,-1664 # 80008874 <nextpid>
    80000efc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efe:	0014871b          	addiw	a4,s1,1
    80000f02:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f04:	854a                	mv	a0,s2
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	45c080e7          	jalr	1116(ra) # 80006362 <release>
}
    80000f0e:	8526                	mv	a0,s1
    80000f10:	60e2                	ld	ra,24(sp)
    80000f12:	6442                	ld	s0,16(sp)
    80000f14:	64a2                	ld	s1,8(sp)
    80000f16:	6902                	ld	s2,0(sp)
    80000f18:	6105                	addi	sp,sp,32
    80000f1a:	8082                	ret

0000000080000f1c <proc_pagetable>:
{
    80000f1c:	1101                	addi	sp,sp,-32
    80000f1e:	ec06                	sd	ra,24(sp)
    80000f20:	e822                	sd	s0,16(sp)
    80000f22:	e426                	sd	s1,8(sp)
    80000f24:	e04a                	sd	s2,0(sp)
    80000f26:	1000                	addi	s0,sp,32
    80000f28:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f2a:	00000097          	auipc	ra,0x0
    80000f2e:	8ac080e7          	jalr	-1876(ra) # 800007d6 <uvmcreate>
    80000f32:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f34:	c121                	beqz	a0,80000f74 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f36:	4729                	li	a4,10
    80000f38:	00006697          	auipc	a3,0x6
    80000f3c:	0c868693          	addi	a3,a3,200 # 80007000 <_trampoline>
    80000f40:	6605                	lui	a2,0x1
    80000f42:	040005b7          	lui	a1,0x4000
    80000f46:	15fd                	addi	a1,a1,-1
    80000f48:	05b2                	slli	a1,a1,0xc
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	602080e7          	jalr	1538(ra) # 8000054c <mappages>
    80000f52:	02054863          	bltz	a0,80000f82 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f56:	4719                	li	a4,6
    80000f58:	05893683          	ld	a3,88(s2)
    80000f5c:	6605                	lui	a2,0x1
    80000f5e:	020005b7          	lui	a1,0x2000
    80000f62:	15fd                	addi	a1,a1,-1
    80000f64:	05b6                	slli	a1,a1,0xd
    80000f66:	8526                	mv	a0,s1
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	5e4080e7          	jalr	1508(ra) # 8000054c <mappages>
    80000f70:	02054163          	bltz	a0,80000f92 <proc_pagetable+0x76>
}
    80000f74:	8526                	mv	a0,s1
    80000f76:	60e2                	ld	ra,24(sp)
    80000f78:	6442                	ld	s0,16(sp)
    80000f7a:	64a2                	ld	s1,8(sp)
    80000f7c:	6902                	ld	s2,0(sp)
    80000f7e:	6105                	addi	sp,sp,32
    80000f80:	8082                	ret
    uvmfree(pagetable, 0);
    80000f82:	4581                	li	a1,0
    80000f84:	8526                	mv	a0,s1
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	a54080e7          	jalr	-1452(ra) # 800009da <uvmfree>
    return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	b7d5                	j	80000f74 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f92:	4681                	li	a3,0
    80000f94:	4605                	li	a2,1
    80000f96:	040005b7          	lui	a1,0x4000
    80000f9a:	15fd                	addi	a1,a1,-1
    80000f9c:	05b2                	slli	a1,a1,0xc
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	772080e7          	jalr	1906(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa8:	4581                	li	a1,0
    80000faa:	8526                	mv	a0,s1
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	a2e080e7          	jalr	-1490(ra) # 800009da <uvmfree>
    return 0;
    80000fb4:	4481                	li	s1,0
    80000fb6:	bf7d                	j	80000f74 <proc_pagetable+0x58>

0000000080000fb8 <proc_freepagetable>:
{
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	e04a                	sd	s2,0(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
    80000fc6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	73e080e7          	jalr	1854(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	020005b7          	lui	a1,0x2000
    80000fe4:	15fd                	addi	a1,a1,-1
    80000fe6:	05b6                	slli	a1,a1,0xd
    80000fe8:	8526                	mv	a0,s1
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	728080e7          	jalr	1832(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ff2:	85ca                	mv	a1,s2
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	9e4080e7          	jalr	-1564(ra) # 800009da <uvmfree>
}
    80000ffe:	60e2                	ld	ra,24(sp)
    80001000:	6442                	ld	s0,16(sp)
    80001002:	64a2                	ld	s1,8(sp)
    80001004:	6902                	ld	s2,0(sp)
    80001006:	6105                	addi	sp,sp,32
    80001008:	8082                	ret

000000008000100a <freeproc>:
{
    8000100a:	1101                	addi	sp,sp,-32
    8000100c:	ec06                	sd	ra,24(sp)
    8000100e:	e822                	sd	s0,16(sp)
    80001010:	e426                	sd	s1,8(sp)
    80001012:	1000                	addi	s0,sp,32
    80001014:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001016:	6d28                	ld	a0,88(a0)
    80001018:	c509                	beqz	a0,80001022 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001022:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001026:	68a8                	ld	a0,80(s1)
    80001028:	c511                	beqz	a0,80001034 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102a:	64ac                	ld	a1,72(s1)
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	f8c080e7          	jalr	-116(ra) # 80000fb8 <proc_freepagetable>
  p->pagetable = 0;
    80001034:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001038:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000103c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001040:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001044:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001048:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000104c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001050:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001054:	0004ac23          	sw	zero,24(s1)
  p->passed_ticks = 0;
    80001058:	1604ac23          	sw	zero,376(s1)
  p->interval = 0;
    8000105c:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80001060:	1604b823          	sd	zero,368(s1)
  if(p->trapframe_backup)
    80001064:	1804b503          	ld	a0,384(s1)
    80001068:	c509                	beqz	a0,80001072 <freeproc+0x68>
    kfree((void*)p->trapframe_backup);
    8000106a:	fffff097          	auipc	ra,0xfffff
    8000106e:	fb2080e7          	jalr	-78(ra) # 8000001c <kfree>
  p->trapframe_backup = 0;
    80001072:	1804b023          	sd	zero,384(s1)
  p->ret_flag = 0;
    80001076:	1804a423          	sw	zero,392(s1)
}
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6105                	addi	sp,sp,32
    80001082:	8082                	ret

0000000080001084 <allocproc>:
{
    80001084:	1101                	addi	sp,sp,-32
    80001086:	ec06                	sd	ra,24(sp)
    80001088:	e822                	sd	s0,16(sp)
    8000108a:	e426                	sd	s1,8(sp)
    8000108c:	e04a                	sd	s2,0(sp)
    8000108e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	00008497          	auipc	s1,0x8
    80001094:	cb048493          	addi	s1,s1,-848 # 80008d40 <proc>
    80001098:	0000e917          	auipc	s2,0xe
    8000109c:	0a890913          	addi	s2,s2,168 # 8000f140 <tickslock>
    acquire(&p->lock);
    800010a0:	8526                	mv	a0,s1
    800010a2:	00005097          	auipc	ra,0x5
    800010a6:	20c080e7          	jalr	524(ra) # 800062ae <acquire>
    if(p->state == UNUSED) {
    800010aa:	4c9c                	lw	a5,24(s1)
    800010ac:	cf81                	beqz	a5,800010c4 <allocproc+0x40>
      release(&p->lock);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00005097          	auipc	ra,0x5
    800010b4:	2b2080e7          	jalr	690(ra) # 80006362 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b8:	19048493          	addi	s1,s1,400
    800010bc:	ff2492e3          	bne	s1,s2,800010a0 <allocproc+0x1c>
  return 0;
    800010c0:	4481                	li	s1,0
    800010c2:	a885                	j	80001132 <allocproc+0xae>
  p->pid = allocpid();
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	e12080e7          	jalr	-494(ra) # 80000ed6 <allocpid>
    800010cc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ce:	4785                	li	a5,1
    800010d0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d2:	fffff097          	auipc	ra,0xfffff
    800010d6:	046080e7          	jalr	70(ra) # 80000118 <kalloc>
    800010da:	892a                	mv	s2,a0
    800010dc:	eca8                	sd	a0,88(s1)
    800010de:	c12d                	beqz	a0,80001140 <allocproc+0xbc>
  p->pagetable = proc_pagetable(p);
    800010e0:	8526                	mv	a0,s1
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	e3a080e7          	jalr	-454(ra) # 80000f1c <proc_pagetable>
    800010ea:	892a                	mv	s2,a0
    800010ec:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010ee:	c52d                	beqz	a0,80001158 <allocproc+0xd4>
  memset(&p->context, 0, sizeof(p->context));
    800010f0:	07000613          	li	a2,112
    800010f4:	4581                	li	a1,0
    800010f6:	06048513          	addi	a0,s1,96
    800010fa:	fffff097          	auipc	ra,0xfffff
    800010fe:	07e080e7          	jalr	126(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001102:	00000797          	auipc	a5,0x0
    80001106:	d8e78793          	addi	a5,a5,-626 # 80000e90 <forkret>
    8000110a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000110c:	60bc                	ld	a5,64(s1)
    8000110e:	6705                	lui	a4,0x1
    80001110:	97ba                	add	a5,a5,a4
    80001112:	f4bc                	sd	a5,104(s1)
  p->passed_ticks = 0;
    80001114:	1604ac23          	sw	zero,376(s1)
  p->interval = 0;
    80001118:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    8000111c:	1604b823          	sd	zero,368(s1)
  p->trapframe_backup = (struct trapframe*)kalloc();
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	ff8080e7          	jalr	-8(ra) # 80000118 <kalloc>
    80001128:	18a4b023          	sd	a0,384(s1)
  p->ret_flag = 1;
    8000112c:	4785                	li	a5,1
    8000112e:	18f4a423          	sw	a5,392(s1)
}
    80001132:	8526                	mv	a0,s1
    80001134:	60e2                	ld	ra,24(sp)
    80001136:	6442                	ld	s0,16(sp)
    80001138:	64a2                	ld	s1,8(sp)
    8000113a:	6902                	ld	s2,0(sp)
    8000113c:	6105                	addi	sp,sp,32
    8000113e:	8082                	ret
    freeproc(p);
    80001140:	8526                	mv	a0,s1
    80001142:	00000097          	auipc	ra,0x0
    80001146:	ec8080e7          	jalr	-312(ra) # 8000100a <freeproc>
    release(&p->lock);
    8000114a:	8526                	mv	a0,s1
    8000114c:	00005097          	auipc	ra,0x5
    80001150:	216080e7          	jalr	534(ra) # 80006362 <release>
    return 0;
    80001154:	84ca                	mv	s1,s2
    80001156:	bff1                	j	80001132 <allocproc+0xae>
    freeproc(p);
    80001158:	8526                	mv	a0,s1
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	eb0080e7          	jalr	-336(ra) # 8000100a <freeproc>
    release(&p->lock);
    80001162:	8526                	mv	a0,s1
    80001164:	00005097          	auipc	ra,0x5
    80001168:	1fe080e7          	jalr	510(ra) # 80006362 <release>
    return 0;
    8000116c:	84ca                	mv	s1,s2
    8000116e:	b7d1                	j	80001132 <allocproc+0xae>

0000000080001170 <userinit>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	1000                	addi	s0,sp,32
  p = allocproc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	f0a080e7          	jalr	-246(ra) # 80001084 <allocproc>
    80001182:	84aa                	mv	s1,a0
  initproc = p;
    80001184:	00007797          	auipc	a5,0x7
    80001188:	74a7b623          	sd	a0,1868(a5) # 800088d0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000118c:	03400613          	li	a2,52
    80001190:	00007597          	auipc	a1,0x7
    80001194:	6f058593          	addi	a1,a1,1776 # 80008880 <initcode>
    80001198:	6928                	ld	a0,80(a0)
    8000119a:	fffff097          	auipc	ra,0xfffff
    8000119e:	66a080e7          	jalr	1642(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    800011a2:	6785                	lui	a5,0x1
    800011a4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a6:	6cb8                	ld	a4,88(s1)
    800011a8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011ac:	6cb8                	ld	a4,88(s1)
    800011ae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b0:	4641                	li	a2,16
    800011b2:	00007597          	auipc	a1,0x7
    800011b6:	fce58593          	addi	a1,a1,-50 # 80008180 <etext+0x180>
    800011ba:	15848513          	addi	a0,s1,344
    800011be:	fffff097          	auipc	ra,0xfffff
    800011c2:	10c080e7          	jalr	268(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011c6:	00007517          	auipc	a0,0x7
    800011ca:	fca50513          	addi	a0,a0,-54 # 80008190 <etext+0x190>
    800011ce:	00002097          	auipc	ra,0x2
    800011d2:	1d6080e7          	jalr	470(ra) # 800033a4 <namei>
    800011d6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011da:	478d                	li	a5,3
    800011dc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	00005097          	auipc	ra,0x5
    800011e4:	182080e7          	jalr	386(ra) # 80006362 <release>
}
    800011e8:	60e2                	ld	ra,24(sp)
    800011ea:	6442                	ld	s0,16(sp)
    800011ec:	64a2                	ld	s1,8(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret

00000000800011f2 <growproc>:
{
    800011f2:	1101                	addi	sp,sp,-32
    800011f4:	ec06                	sd	ra,24(sp)
    800011f6:	e822                	sd	s0,16(sp)
    800011f8:	e426                	sd	s1,8(sp)
    800011fa:	e04a                	sd	s2,0(sp)
    800011fc:	1000                	addi	s0,sp,32
    800011fe:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001200:	00000097          	auipc	ra,0x0
    80001204:	c58080e7          	jalr	-936(ra) # 80000e58 <myproc>
    80001208:	84aa                	mv	s1,a0
  sz = p->sz;
    8000120a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000120c:	01204c63          	bgtz	s2,80001224 <growproc+0x32>
  } else if(n < 0){
    80001210:	02094663          	bltz	s2,8000123c <growproc+0x4a>
  p->sz = sz;
    80001214:	e4ac                	sd	a1,72(s1)
  return 0;
    80001216:	4501                	li	a0,0
}
    80001218:	60e2                	ld	ra,24(sp)
    8000121a:	6442                	ld	s0,16(sp)
    8000121c:	64a2                	ld	s1,8(sp)
    8000121e:	6902                	ld	s2,0(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001224:	4691                	li	a3,4
    80001226:	00b90633          	add	a2,s2,a1
    8000122a:	6928                	ld	a0,80(a0)
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	692080e7          	jalr	1682(ra) # 800008be <uvmalloc>
    80001234:	85aa                	mv	a1,a0
    80001236:	fd79                	bnez	a0,80001214 <growproc+0x22>
      return -1;
    80001238:	557d                	li	a0,-1
    8000123a:	bff9                	j	80001218 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000123c:	00b90633          	add	a2,s2,a1
    80001240:	6928                	ld	a0,80(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	634080e7          	jalr	1588(ra) # 80000876 <uvmdealloc>
    8000124a:	85aa                	mv	a1,a0
    8000124c:	b7e1                	j	80001214 <growproc+0x22>

000000008000124e <fork>:
{
    8000124e:	7179                	addi	sp,sp,-48
    80001250:	f406                	sd	ra,40(sp)
    80001252:	f022                	sd	s0,32(sp)
    80001254:	ec26                	sd	s1,24(sp)
    80001256:	e84a                	sd	s2,16(sp)
    80001258:	e44e                	sd	s3,8(sp)
    8000125a:	e052                	sd	s4,0(sp)
    8000125c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000125e:	00000097          	auipc	ra,0x0
    80001262:	bfa080e7          	jalr	-1030(ra) # 80000e58 <myproc>
    80001266:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	e1c080e7          	jalr	-484(ra) # 80001084 <allocproc>
    80001270:	10050b63          	beqz	a0,80001386 <fork+0x138>
    80001274:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001276:	04893603          	ld	a2,72(s2)
    8000127a:	692c                	ld	a1,80(a0)
    8000127c:	05093503          	ld	a0,80(s2)
    80001280:	fffff097          	auipc	ra,0xfffff
    80001284:	792080e7          	jalr	1938(ra) # 80000a12 <uvmcopy>
    80001288:	04054663          	bltz	a0,800012d4 <fork+0x86>
  np->sz = p->sz;
    8000128c:	04893783          	ld	a5,72(s2)
    80001290:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001294:	05893683          	ld	a3,88(s2)
    80001298:	87b6                	mv	a5,a3
    8000129a:	0589b703          	ld	a4,88(s3)
    8000129e:	12068693          	addi	a3,a3,288
    800012a2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a6:	6788                	ld	a0,8(a5)
    800012a8:	6b8c                	ld	a1,16(a5)
    800012aa:	6f90                	ld	a2,24(a5)
    800012ac:	01073023          	sd	a6,0(a4)
    800012b0:	e708                	sd	a0,8(a4)
    800012b2:	eb0c                	sd	a1,16(a4)
    800012b4:	ef10                	sd	a2,24(a4)
    800012b6:	02078793          	addi	a5,a5,32
    800012ba:	02070713          	addi	a4,a4,32
    800012be:	fed792e3          	bne	a5,a3,800012a2 <fork+0x54>
  np->trapframe->a0 = 0;
    800012c2:	0589b783          	ld	a5,88(s3)
    800012c6:	0607b823          	sd	zero,112(a5)
    800012ca:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012ce:	15000a13          	li	s4,336
    800012d2:	a03d                	j	80001300 <fork+0xb2>
    freeproc(np);
    800012d4:	854e                	mv	a0,s3
    800012d6:	00000097          	auipc	ra,0x0
    800012da:	d34080e7          	jalr	-716(ra) # 8000100a <freeproc>
    release(&np->lock);
    800012de:	854e                	mv	a0,s3
    800012e0:	00005097          	auipc	ra,0x5
    800012e4:	082080e7          	jalr	130(ra) # 80006362 <release>
    return -1;
    800012e8:	5a7d                	li	s4,-1
    800012ea:	a069                	j	80001374 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ec:	00002097          	auipc	ra,0x2
    800012f0:	74e080e7          	jalr	1870(ra) # 80003a3a <filedup>
    800012f4:	009987b3          	add	a5,s3,s1
    800012f8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012fa:	04a1                	addi	s1,s1,8
    800012fc:	01448763          	beq	s1,s4,8000130a <fork+0xbc>
    if(p->ofile[i])
    80001300:	009907b3          	add	a5,s2,s1
    80001304:	6388                	ld	a0,0(a5)
    80001306:	f17d                	bnez	a0,800012ec <fork+0x9e>
    80001308:	bfcd                	j	800012fa <fork+0xac>
  np->cwd = idup(p->cwd);
    8000130a:	15093503          	ld	a0,336(s2)
    8000130e:	00002097          	auipc	ra,0x2
    80001312:	8b2080e7          	jalr	-1870(ra) # 80002bc0 <idup>
    80001316:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131a:	4641                	li	a2,16
    8000131c:	15890593          	addi	a1,s2,344
    80001320:	15898513          	addi	a0,s3,344
    80001324:	fffff097          	auipc	ra,0xfffff
    80001328:	fa6080e7          	jalr	-90(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000132c:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001330:	854e                	mv	a0,s3
    80001332:	00005097          	auipc	ra,0x5
    80001336:	030080e7          	jalr	48(ra) # 80006362 <release>
  acquire(&wait_lock);
    8000133a:	00007497          	auipc	s1,0x7
    8000133e:	5ee48493          	addi	s1,s1,1518 # 80008928 <wait_lock>
    80001342:	8526                	mv	a0,s1
    80001344:	00005097          	auipc	ra,0x5
    80001348:	f6a080e7          	jalr	-150(ra) # 800062ae <acquire>
  np->parent = p;
    8000134c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001350:	8526                	mv	a0,s1
    80001352:	00005097          	auipc	ra,0x5
    80001356:	010080e7          	jalr	16(ra) # 80006362 <release>
  acquire(&np->lock);
    8000135a:	854e                	mv	a0,s3
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	f52080e7          	jalr	-174(ra) # 800062ae <acquire>
  np->state = RUNNABLE;
    80001364:	478d                	li	a5,3
    80001366:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000136a:	854e                	mv	a0,s3
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	ff6080e7          	jalr	-10(ra) # 80006362 <release>
}
    80001374:	8552                	mv	a0,s4
    80001376:	70a2                	ld	ra,40(sp)
    80001378:	7402                	ld	s0,32(sp)
    8000137a:	64e2                	ld	s1,24(sp)
    8000137c:	6942                	ld	s2,16(sp)
    8000137e:	69a2                	ld	s3,8(sp)
    80001380:	6a02                	ld	s4,0(sp)
    80001382:	6145                	addi	sp,sp,48
    80001384:	8082                	ret
    return -1;
    80001386:	5a7d                	li	s4,-1
    80001388:	b7f5                	j	80001374 <fork+0x126>

000000008000138a <scheduler>:
{
    8000138a:	7139                	addi	sp,sp,-64
    8000138c:	fc06                	sd	ra,56(sp)
    8000138e:	f822                	sd	s0,48(sp)
    80001390:	f426                	sd	s1,40(sp)
    80001392:	f04a                	sd	s2,32(sp)
    80001394:	ec4e                	sd	s3,24(sp)
    80001396:	e852                	sd	s4,16(sp)
    80001398:	e456                	sd	s5,8(sp)
    8000139a:	e05a                	sd	s6,0(sp)
    8000139c:	0080                	addi	s0,sp,64
    8000139e:	8792                	mv	a5,tp
  int id = r_tp();
    800013a0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a2:	00779a93          	slli	s5,a5,0x7
    800013a6:	00007717          	auipc	a4,0x7
    800013aa:	56a70713          	addi	a4,a4,1386 # 80008910 <pid_lock>
    800013ae:	9756                	add	a4,a4,s5
    800013b0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b4:	00007717          	auipc	a4,0x7
    800013b8:	59470713          	addi	a4,a4,1428 # 80008948 <cpus+0x8>
    800013bc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013be:	498d                	li	s3,3
        p->state = RUNNING;
    800013c0:	4b11                	li	s6,4
        c->proc = p;
    800013c2:	079e                	slli	a5,a5,0x7
    800013c4:	00007a17          	auipc	s4,0x7
    800013c8:	54ca0a13          	addi	s4,s4,1356 # 80008910 <pid_lock>
    800013cc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ce:	0000e917          	auipc	s2,0xe
    800013d2:	d7290913          	addi	s2,s2,-654 # 8000f140 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013d6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013de:	10079073          	csrw	sstatus,a5
    800013e2:	00008497          	auipc	s1,0x8
    800013e6:	95e48493          	addi	s1,s1,-1698 # 80008d40 <proc>
    800013ea:	a03d                	j	80001418 <scheduler+0x8e>
        p->state = RUNNING;
    800013ec:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013f0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f4:	06048593          	addi	a1,s1,96
    800013f8:	8556                	mv	a0,s5
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	6a4080e7          	jalr	1700(ra) # 80001a9e <swtch>
        c->proc = 0;
    80001402:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	f5a080e7          	jalr	-166(ra) # 80006362 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001410:	19048493          	addi	s1,s1,400
    80001414:	fd2481e3          	beq	s1,s2,800013d6 <scheduler+0x4c>
      acquire(&p->lock);
    80001418:	8526                	mv	a0,s1
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	e94080e7          	jalr	-364(ra) # 800062ae <acquire>
      if(p->state == RUNNABLE) {
    80001422:	4c9c                	lw	a5,24(s1)
    80001424:	ff3791e3          	bne	a5,s3,80001406 <scheduler+0x7c>
    80001428:	b7d1                	j	800013ec <scheduler+0x62>

000000008000142a <sched>:
{
    8000142a:	7179                	addi	sp,sp,-48
    8000142c:	f406                	sd	ra,40(sp)
    8000142e:	f022                	sd	s0,32(sp)
    80001430:	ec26                	sd	s1,24(sp)
    80001432:	e84a                	sd	s2,16(sp)
    80001434:	e44e                	sd	s3,8(sp)
    80001436:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	a20080e7          	jalr	-1504(ra) # 80000e58 <myproc>
    80001440:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001442:	00005097          	auipc	ra,0x5
    80001446:	df2080e7          	jalr	-526(ra) # 80006234 <holding>
    8000144a:	c93d                	beqz	a0,800014c0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000144e:	2781                	sext.w	a5,a5
    80001450:	079e                	slli	a5,a5,0x7
    80001452:	00007717          	auipc	a4,0x7
    80001456:	4be70713          	addi	a4,a4,1214 # 80008910 <pid_lock>
    8000145a:	97ba                	add	a5,a5,a4
    8000145c:	0a87a703          	lw	a4,168(a5)
    80001460:	4785                	li	a5,1
    80001462:	06f71763          	bne	a4,a5,800014d0 <sched+0xa6>
  if(p->state == RUNNING)
    80001466:	4c98                	lw	a4,24(s1)
    80001468:	4791                	li	a5,4
    8000146a:	06f70b63          	beq	a4,a5,800014e0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000146e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001472:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001474:	efb5                	bnez	a5,800014f0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001476:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001478:	00007917          	auipc	s2,0x7
    8000147c:	49890913          	addi	s2,s2,1176 # 80008910 <pid_lock>
    80001480:	2781                	sext.w	a5,a5
    80001482:	079e                	slli	a5,a5,0x7
    80001484:	97ca                	add	a5,a5,s2
    80001486:	0ac7a983          	lw	s3,172(a5)
    8000148a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000148c:	2781                	sext.w	a5,a5
    8000148e:	079e                	slli	a5,a5,0x7
    80001490:	00007597          	auipc	a1,0x7
    80001494:	4b858593          	addi	a1,a1,1208 # 80008948 <cpus+0x8>
    80001498:	95be                	add	a1,a1,a5
    8000149a:	06048513          	addi	a0,s1,96
    8000149e:	00000097          	auipc	ra,0x0
    800014a2:	600080e7          	jalr	1536(ra) # 80001a9e <swtch>
    800014a6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014a8:	2781                	sext.w	a5,a5
    800014aa:	079e                	slli	a5,a5,0x7
    800014ac:	97ca                	add	a5,a5,s2
    800014ae:	0b37a623          	sw	s3,172(a5)
}
    800014b2:	70a2                	ld	ra,40(sp)
    800014b4:	7402                	ld	s0,32(sp)
    800014b6:	64e2                	ld	s1,24(sp)
    800014b8:	6942                	ld	s2,16(sp)
    800014ba:	69a2                	ld	s3,8(sp)
    800014bc:	6145                	addi	sp,sp,48
    800014be:	8082                	ret
    panic("sched p->lock");
    800014c0:	00007517          	auipc	a0,0x7
    800014c4:	cd850513          	addi	a0,a0,-808 # 80008198 <etext+0x198>
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	8c6080e7          	jalr	-1850(ra) # 80005d8e <panic>
    panic("sched locks");
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	cd850513          	addi	a0,a0,-808 # 800081a8 <etext+0x1a8>
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	8b6080e7          	jalr	-1866(ra) # 80005d8e <panic>
    panic("sched running");
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	cd850513          	addi	a0,a0,-808 # 800081b8 <etext+0x1b8>
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	8a6080e7          	jalr	-1882(ra) # 80005d8e <panic>
    panic("sched interruptible");
    800014f0:	00007517          	auipc	a0,0x7
    800014f4:	cd850513          	addi	a0,a0,-808 # 800081c8 <etext+0x1c8>
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	896080e7          	jalr	-1898(ra) # 80005d8e <panic>

0000000080001500 <yield>:
{
    80001500:	1101                	addi	sp,sp,-32
    80001502:	ec06                	sd	ra,24(sp)
    80001504:	e822                	sd	s0,16(sp)
    80001506:	e426                	sd	s1,8(sp)
    80001508:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000150a:	00000097          	auipc	ra,0x0
    8000150e:	94e080e7          	jalr	-1714(ra) # 80000e58 <myproc>
    80001512:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001514:	00005097          	auipc	ra,0x5
    80001518:	d9a080e7          	jalr	-614(ra) # 800062ae <acquire>
  p->state = RUNNABLE;
    8000151c:	478d                	li	a5,3
    8000151e:	cc9c                	sw	a5,24(s1)
  sched();
    80001520:	00000097          	auipc	ra,0x0
    80001524:	f0a080e7          	jalr	-246(ra) # 8000142a <sched>
  release(&p->lock);
    80001528:	8526                	mv	a0,s1
    8000152a:	00005097          	auipc	ra,0x5
    8000152e:	e38080e7          	jalr	-456(ra) # 80006362 <release>
}
    80001532:	60e2                	ld	ra,24(sp)
    80001534:	6442                	ld	s0,16(sp)
    80001536:	64a2                	ld	s1,8(sp)
    80001538:	6105                	addi	sp,sp,32
    8000153a:	8082                	ret

000000008000153c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000153c:	7179                	addi	sp,sp,-48
    8000153e:	f406                	sd	ra,40(sp)
    80001540:	f022                	sd	s0,32(sp)
    80001542:	ec26                	sd	s1,24(sp)
    80001544:	e84a                	sd	s2,16(sp)
    80001546:	e44e                	sd	s3,8(sp)
    80001548:	1800                	addi	s0,sp,48
    8000154a:	89aa                	mv	s3,a0
    8000154c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	90a080e7          	jalr	-1782(ra) # 80000e58 <myproc>
    80001556:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	d56080e7          	jalr	-682(ra) # 800062ae <acquire>
  release(lk);
    80001560:	854a                	mv	a0,s2
    80001562:	00005097          	auipc	ra,0x5
    80001566:	e00080e7          	jalr	-512(ra) # 80006362 <release>

  // Go to sleep.
  p->chan = chan;
    8000156a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000156e:	4789                	li	a5,2
    80001570:	cc9c                	sw	a5,24(s1)

  sched();
    80001572:	00000097          	auipc	ra,0x0
    80001576:	eb8080e7          	jalr	-328(ra) # 8000142a <sched>

  // Tidy up.
  p->chan = 0;
    8000157a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000157e:	8526                	mv	a0,s1
    80001580:	00005097          	auipc	ra,0x5
    80001584:	de2080e7          	jalr	-542(ra) # 80006362 <release>
  acquire(lk);
    80001588:	854a                	mv	a0,s2
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	d24080e7          	jalr	-732(ra) # 800062ae <acquire>
}
    80001592:	70a2                	ld	ra,40(sp)
    80001594:	7402                	ld	s0,32(sp)
    80001596:	64e2                	ld	s1,24(sp)
    80001598:	6942                	ld	s2,16(sp)
    8000159a:	69a2                	ld	s3,8(sp)
    8000159c:	6145                	addi	sp,sp,48
    8000159e:	8082                	ret

00000000800015a0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015a0:	7139                	addi	sp,sp,-64
    800015a2:	fc06                	sd	ra,56(sp)
    800015a4:	f822                	sd	s0,48(sp)
    800015a6:	f426                	sd	s1,40(sp)
    800015a8:	f04a                	sd	s2,32(sp)
    800015aa:	ec4e                	sd	s3,24(sp)
    800015ac:	e852                	sd	s4,16(sp)
    800015ae:	e456                	sd	s5,8(sp)
    800015b0:	0080                	addi	s0,sp,64
    800015b2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015b4:	00007497          	auipc	s1,0x7
    800015b8:	78c48493          	addi	s1,s1,1932 # 80008d40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015bc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015be:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015c0:	0000e917          	auipc	s2,0xe
    800015c4:	b8090913          	addi	s2,s2,-1152 # 8000f140 <tickslock>
    800015c8:	a821                	j	800015e0 <wakeup+0x40>
        p->state = RUNNABLE;
    800015ca:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	00005097          	auipc	ra,0x5
    800015d4:	d92080e7          	jalr	-622(ra) # 80006362 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d8:	19048493          	addi	s1,s1,400
    800015dc:	03248463          	beq	s1,s2,80001604 <wakeup+0x64>
    if(p != myproc()){
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	878080e7          	jalr	-1928(ra) # 80000e58 <myproc>
    800015e8:	fea488e3          	beq	s1,a0,800015d8 <wakeup+0x38>
      acquire(&p->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	cc0080e7          	jalr	-832(ra) # 800062ae <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015f6:	4c9c                	lw	a5,24(s1)
    800015f8:	fd379be3          	bne	a5,s3,800015ce <wakeup+0x2e>
    800015fc:	709c                	ld	a5,32(s1)
    800015fe:	fd4798e3          	bne	a5,s4,800015ce <wakeup+0x2e>
    80001602:	b7e1                	j	800015ca <wakeup+0x2a>
    }
  }
}
    80001604:	70e2                	ld	ra,56(sp)
    80001606:	7442                	ld	s0,48(sp)
    80001608:	74a2                	ld	s1,40(sp)
    8000160a:	7902                	ld	s2,32(sp)
    8000160c:	69e2                	ld	s3,24(sp)
    8000160e:	6a42                	ld	s4,16(sp)
    80001610:	6aa2                	ld	s5,8(sp)
    80001612:	6121                	addi	sp,sp,64
    80001614:	8082                	ret

0000000080001616 <reparent>:
{
    80001616:	7179                	addi	sp,sp,-48
    80001618:	f406                	sd	ra,40(sp)
    8000161a:	f022                	sd	s0,32(sp)
    8000161c:	ec26                	sd	s1,24(sp)
    8000161e:	e84a                	sd	s2,16(sp)
    80001620:	e44e                	sd	s3,8(sp)
    80001622:	e052                	sd	s4,0(sp)
    80001624:	1800                	addi	s0,sp,48
    80001626:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001628:	00007497          	auipc	s1,0x7
    8000162c:	71848493          	addi	s1,s1,1816 # 80008d40 <proc>
      pp->parent = initproc;
    80001630:	00007a17          	auipc	s4,0x7
    80001634:	2a0a0a13          	addi	s4,s4,672 # 800088d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001638:	0000e997          	auipc	s3,0xe
    8000163c:	b0898993          	addi	s3,s3,-1272 # 8000f140 <tickslock>
    80001640:	a029                	j	8000164a <reparent+0x34>
    80001642:	19048493          	addi	s1,s1,400
    80001646:	01348d63          	beq	s1,s3,80001660 <reparent+0x4a>
    if(pp->parent == p){
    8000164a:	7c9c                	ld	a5,56(s1)
    8000164c:	ff279be3          	bne	a5,s2,80001642 <reparent+0x2c>
      pp->parent = initproc;
    80001650:	000a3503          	ld	a0,0(s4)
    80001654:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	f4a080e7          	jalr	-182(ra) # 800015a0 <wakeup>
    8000165e:	b7d5                	j	80001642 <reparent+0x2c>
}
    80001660:	70a2                	ld	ra,40(sp)
    80001662:	7402                	ld	s0,32(sp)
    80001664:	64e2                	ld	s1,24(sp)
    80001666:	6942                	ld	s2,16(sp)
    80001668:	69a2                	ld	s3,8(sp)
    8000166a:	6a02                	ld	s4,0(sp)
    8000166c:	6145                	addi	sp,sp,48
    8000166e:	8082                	ret

0000000080001670 <exit>:
{
    80001670:	7179                	addi	sp,sp,-48
    80001672:	f406                	sd	ra,40(sp)
    80001674:	f022                	sd	s0,32(sp)
    80001676:	ec26                	sd	s1,24(sp)
    80001678:	e84a                	sd	s2,16(sp)
    8000167a:	e44e                	sd	s3,8(sp)
    8000167c:	e052                	sd	s4,0(sp)
    8000167e:	1800                	addi	s0,sp,48
    80001680:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001682:	fffff097          	auipc	ra,0xfffff
    80001686:	7d6080e7          	jalr	2006(ra) # 80000e58 <myproc>
    8000168a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000168c:	00007797          	auipc	a5,0x7
    80001690:	2447b783          	ld	a5,580(a5) # 800088d0 <initproc>
    80001694:	0d050493          	addi	s1,a0,208
    80001698:	15050913          	addi	s2,a0,336
    8000169c:	02a79363          	bne	a5,a0,800016c2 <exit+0x52>
    panic("init exiting");
    800016a0:	00007517          	auipc	a0,0x7
    800016a4:	b4050513          	addi	a0,a0,-1216 # 800081e0 <etext+0x1e0>
    800016a8:	00004097          	auipc	ra,0x4
    800016ac:	6e6080e7          	jalr	1766(ra) # 80005d8e <panic>
      fileclose(f);
    800016b0:	00002097          	auipc	ra,0x2
    800016b4:	3dc080e7          	jalr	988(ra) # 80003a8c <fileclose>
      p->ofile[fd] = 0;
    800016b8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016bc:	04a1                	addi	s1,s1,8
    800016be:	01248563          	beq	s1,s2,800016c8 <exit+0x58>
    if(p->ofile[fd]){
    800016c2:	6088                	ld	a0,0(s1)
    800016c4:	f575                	bnez	a0,800016b0 <exit+0x40>
    800016c6:	bfdd                	j	800016bc <exit+0x4c>
  begin_op();
    800016c8:	00002097          	auipc	ra,0x2
    800016cc:	ef8080e7          	jalr	-264(ra) # 800035c0 <begin_op>
  iput(p->cwd);
    800016d0:	1509b503          	ld	a0,336(s3)
    800016d4:	00001097          	auipc	ra,0x1
    800016d8:	6e4080e7          	jalr	1764(ra) # 80002db8 <iput>
  end_op();
    800016dc:	00002097          	auipc	ra,0x2
    800016e0:	f64080e7          	jalr	-156(ra) # 80003640 <end_op>
  p->cwd = 0;
    800016e4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016e8:	00007497          	auipc	s1,0x7
    800016ec:	24048493          	addi	s1,s1,576 # 80008928 <wait_lock>
    800016f0:	8526                	mv	a0,s1
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	bbc080e7          	jalr	-1092(ra) # 800062ae <acquire>
  reparent(p);
    800016fa:	854e                	mv	a0,s3
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	f1a080e7          	jalr	-230(ra) # 80001616 <reparent>
  wakeup(p->parent);
    80001704:	0389b503          	ld	a0,56(s3)
    80001708:	00000097          	auipc	ra,0x0
    8000170c:	e98080e7          	jalr	-360(ra) # 800015a0 <wakeup>
  acquire(&p->lock);
    80001710:	854e                	mv	a0,s3
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b9c080e7          	jalr	-1124(ra) # 800062ae <acquire>
  p->xstate = status;
    8000171a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000171e:	4795                	li	a5,5
    80001720:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	c3c080e7          	jalr	-964(ra) # 80006362 <release>
  sched();
    8000172e:	00000097          	auipc	ra,0x0
    80001732:	cfc080e7          	jalr	-772(ra) # 8000142a <sched>
  panic("zombie exit");
    80001736:	00007517          	auipc	a0,0x7
    8000173a:	aba50513          	addi	a0,a0,-1350 # 800081f0 <etext+0x1f0>
    8000173e:	00004097          	auipc	ra,0x4
    80001742:	650080e7          	jalr	1616(ra) # 80005d8e <panic>

0000000080001746 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001746:	7179                	addi	sp,sp,-48
    80001748:	f406                	sd	ra,40(sp)
    8000174a:	f022                	sd	s0,32(sp)
    8000174c:	ec26                	sd	s1,24(sp)
    8000174e:	e84a                	sd	s2,16(sp)
    80001750:	e44e                	sd	s3,8(sp)
    80001752:	1800                	addi	s0,sp,48
    80001754:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001756:	00007497          	auipc	s1,0x7
    8000175a:	5ea48493          	addi	s1,s1,1514 # 80008d40 <proc>
    8000175e:	0000e997          	auipc	s3,0xe
    80001762:	9e298993          	addi	s3,s3,-1566 # 8000f140 <tickslock>
    acquire(&p->lock);
    80001766:	8526                	mv	a0,s1
    80001768:	00005097          	auipc	ra,0x5
    8000176c:	b46080e7          	jalr	-1210(ra) # 800062ae <acquire>
    if(p->pid == pid){
    80001770:	589c                	lw	a5,48(s1)
    80001772:	01278d63          	beq	a5,s2,8000178c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001776:	8526                	mv	a0,s1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	bea080e7          	jalr	-1046(ra) # 80006362 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001780:	19048493          	addi	s1,s1,400
    80001784:	ff3491e3          	bne	s1,s3,80001766 <kill+0x20>
  }
  return -1;
    80001788:	557d                	li	a0,-1
    8000178a:	a829                	j	800017a4 <kill+0x5e>
      p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001790:	4c98                	lw	a4,24(s1)
    80001792:	4789                	li	a5,2
    80001794:	00f70f63          	beq	a4,a5,800017b2 <kill+0x6c>
      release(&p->lock);
    80001798:	8526                	mv	a0,s1
    8000179a:	00005097          	auipc	ra,0x5
    8000179e:	bc8080e7          	jalr	-1080(ra) # 80006362 <release>
      return 0;
    800017a2:	4501                	li	a0,0
}
    800017a4:	70a2                	ld	ra,40(sp)
    800017a6:	7402                	ld	s0,32(sp)
    800017a8:	64e2                	ld	s1,24(sp)
    800017aa:	6942                	ld	s2,16(sp)
    800017ac:	69a2                	ld	s3,8(sp)
    800017ae:	6145                	addi	sp,sp,48
    800017b0:	8082                	ret
        p->state = RUNNABLE;
    800017b2:	478d                	li	a5,3
    800017b4:	cc9c                	sw	a5,24(s1)
    800017b6:	b7cd                	j	80001798 <kill+0x52>

00000000800017b8 <setkilled>:

void
setkilled(struct proc *p)
{
    800017b8:	1101                	addi	sp,sp,-32
    800017ba:	ec06                	sd	ra,24(sp)
    800017bc:	e822                	sd	s0,16(sp)
    800017be:	e426                	sd	s1,8(sp)
    800017c0:	1000                	addi	s0,sp,32
    800017c2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017c4:	00005097          	auipc	ra,0x5
    800017c8:	aea080e7          	jalr	-1302(ra) # 800062ae <acquire>
  p->killed = 1;
    800017cc:	4785                	li	a5,1
    800017ce:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017d0:	8526                	mv	a0,s1
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	b90080e7          	jalr	-1136(ra) # 80006362 <release>
}
    800017da:	60e2                	ld	ra,24(sp)
    800017dc:	6442                	ld	s0,16(sp)
    800017de:	64a2                	ld	s1,8(sp)
    800017e0:	6105                	addi	sp,sp,32
    800017e2:	8082                	ret

00000000800017e4 <killed>:

int
killed(struct proc *p)
{
    800017e4:	1101                	addi	sp,sp,-32
    800017e6:	ec06                	sd	ra,24(sp)
    800017e8:	e822                	sd	s0,16(sp)
    800017ea:	e426                	sd	s1,8(sp)
    800017ec:	e04a                	sd	s2,0(sp)
    800017ee:	1000                	addi	s0,sp,32
    800017f0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	abc080e7          	jalr	-1348(ra) # 800062ae <acquire>
  k = p->killed;
    800017fa:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017fe:	8526                	mv	a0,s1
    80001800:	00005097          	auipc	ra,0x5
    80001804:	b62080e7          	jalr	-1182(ra) # 80006362 <release>
  return k;
}
    80001808:	854a                	mv	a0,s2
    8000180a:	60e2                	ld	ra,24(sp)
    8000180c:	6442                	ld	s0,16(sp)
    8000180e:	64a2                	ld	s1,8(sp)
    80001810:	6902                	ld	s2,0(sp)
    80001812:	6105                	addi	sp,sp,32
    80001814:	8082                	ret

0000000080001816 <wait>:
{
    80001816:	715d                	addi	sp,sp,-80
    80001818:	e486                	sd	ra,72(sp)
    8000181a:	e0a2                	sd	s0,64(sp)
    8000181c:	fc26                	sd	s1,56(sp)
    8000181e:	f84a                	sd	s2,48(sp)
    80001820:	f44e                	sd	s3,40(sp)
    80001822:	f052                	sd	s4,32(sp)
    80001824:	ec56                	sd	s5,24(sp)
    80001826:	e85a                	sd	s6,16(sp)
    80001828:	e45e                	sd	s7,8(sp)
    8000182a:	e062                	sd	s8,0(sp)
    8000182c:	0880                	addi	s0,sp,80
    8000182e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001830:	fffff097          	auipc	ra,0xfffff
    80001834:	628080e7          	jalr	1576(ra) # 80000e58 <myproc>
    80001838:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000183a:	00007517          	auipc	a0,0x7
    8000183e:	0ee50513          	addi	a0,a0,238 # 80008928 <wait_lock>
    80001842:	00005097          	auipc	ra,0x5
    80001846:	a6c080e7          	jalr	-1428(ra) # 800062ae <acquire>
    havekids = 0;
    8000184a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000184c:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000184e:	0000e997          	auipc	s3,0xe
    80001852:	8f298993          	addi	s3,s3,-1806 # 8000f140 <tickslock>
        havekids = 1;
    80001856:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001858:	00007c17          	auipc	s8,0x7
    8000185c:	0d0c0c13          	addi	s8,s8,208 # 80008928 <wait_lock>
    havekids = 0;
    80001860:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001862:	00007497          	auipc	s1,0x7
    80001866:	4de48493          	addi	s1,s1,1246 # 80008d40 <proc>
    8000186a:	a0bd                	j	800018d8 <wait+0xc2>
          pid = pp->pid;
    8000186c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001870:	000b0e63          	beqz	s6,8000188c <wait+0x76>
    80001874:	4691                	li	a3,4
    80001876:	02c48613          	addi	a2,s1,44
    8000187a:	85da                	mv	a1,s6
    8000187c:	05093503          	ld	a0,80(s2)
    80001880:	fffff097          	auipc	ra,0xfffff
    80001884:	296080e7          	jalr	662(ra) # 80000b16 <copyout>
    80001888:	02054563          	bltz	a0,800018b2 <wait+0x9c>
          freeproc(pp);
    8000188c:	8526                	mv	a0,s1
    8000188e:	fffff097          	auipc	ra,0xfffff
    80001892:	77c080e7          	jalr	1916(ra) # 8000100a <freeproc>
          release(&pp->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	aca080e7          	jalr	-1334(ra) # 80006362 <release>
          release(&wait_lock);
    800018a0:	00007517          	auipc	a0,0x7
    800018a4:	08850513          	addi	a0,a0,136 # 80008928 <wait_lock>
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	aba080e7          	jalr	-1350(ra) # 80006362 <release>
          return pid;
    800018b0:	a0b5                	j	8000191c <wait+0x106>
            release(&pp->lock);
    800018b2:	8526                	mv	a0,s1
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	aae080e7          	jalr	-1362(ra) # 80006362 <release>
            release(&wait_lock);
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	06c50513          	addi	a0,a0,108 # 80008928 <wait_lock>
    800018c4:	00005097          	auipc	ra,0x5
    800018c8:	a9e080e7          	jalr	-1378(ra) # 80006362 <release>
            return -1;
    800018cc:	59fd                	li	s3,-1
    800018ce:	a0b9                	j	8000191c <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018d0:	19048493          	addi	s1,s1,400
    800018d4:	03348463          	beq	s1,s3,800018fc <wait+0xe6>
      if(pp->parent == p){
    800018d8:	7c9c                	ld	a5,56(s1)
    800018da:	ff279be3          	bne	a5,s2,800018d0 <wait+0xba>
        acquire(&pp->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	9ce080e7          	jalr	-1586(ra) # 800062ae <acquire>
        if(pp->state == ZOMBIE){
    800018e8:	4c9c                	lw	a5,24(s1)
    800018ea:	f94781e3          	beq	a5,s4,8000186c <wait+0x56>
        release(&pp->lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a72080e7          	jalr	-1422(ra) # 80006362 <release>
        havekids = 1;
    800018f8:	8756                	mv	a4,s5
    800018fa:	bfd9                	j	800018d0 <wait+0xba>
    if(!havekids || killed(p)){
    800018fc:	c719                	beqz	a4,8000190a <wait+0xf4>
    800018fe:	854a                	mv	a0,s2
    80001900:	00000097          	auipc	ra,0x0
    80001904:	ee4080e7          	jalr	-284(ra) # 800017e4 <killed>
    80001908:	c51d                	beqz	a0,80001936 <wait+0x120>
      release(&wait_lock);
    8000190a:	00007517          	auipc	a0,0x7
    8000190e:	01e50513          	addi	a0,a0,30 # 80008928 <wait_lock>
    80001912:	00005097          	auipc	ra,0x5
    80001916:	a50080e7          	jalr	-1456(ra) # 80006362 <release>
      return -1;
    8000191a:	59fd                	li	s3,-1
}
    8000191c:	854e                	mv	a0,s3
    8000191e:	60a6                	ld	ra,72(sp)
    80001920:	6406                	ld	s0,64(sp)
    80001922:	74e2                	ld	s1,56(sp)
    80001924:	7942                	ld	s2,48(sp)
    80001926:	79a2                	ld	s3,40(sp)
    80001928:	7a02                	ld	s4,32(sp)
    8000192a:	6ae2                	ld	s5,24(sp)
    8000192c:	6b42                	ld	s6,16(sp)
    8000192e:	6ba2                	ld	s7,8(sp)
    80001930:	6c02                	ld	s8,0(sp)
    80001932:	6161                	addi	sp,sp,80
    80001934:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001936:	85e2                	mv	a1,s8
    80001938:	854a                	mv	a0,s2
    8000193a:	00000097          	auipc	ra,0x0
    8000193e:	c02080e7          	jalr	-1022(ra) # 8000153c <sleep>
    havekids = 0;
    80001942:	bf39                	j	80001860 <wait+0x4a>

0000000080001944 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001944:	7179                	addi	sp,sp,-48
    80001946:	f406                	sd	ra,40(sp)
    80001948:	f022                	sd	s0,32(sp)
    8000194a:	ec26                	sd	s1,24(sp)
    8000194c:	e84a                	sd	s2,16(sp)
    8000194e:	e44e                	sd	s3,8(sp)
    80001950:	e052                	sd	s4,0(sp)
    80001952:	1800                	addi	s0,sp,48
    80001954:	84aa                	mv	s1,a0
    80001956:	892e                	mv	s2,a1
    80001958:	89b2                	mv	s3,a2
    8000195a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	4fc080e7          	jalr	1276(ra) # 80000e58 <myproc>
  if(user_dst){
    80001964:	c08d                	beqz	s1,80001986 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001966:	86d2                	mv	a3,s4
    80001968:	864e                	mv	a2,s3
    8000196a:	85ca                	mv	a1,s2
    8000196c:	6928                	ld	a0,80(a0)
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	1a8080e7          	jalr	424(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001976:	70a2                	ld	ra,40(sp)
    80001978:	7402                	ld	s0,32(sp)
    8000197a:	64e2                	ld	s1,24(sp)
    8000197c:	6942                	ld	s2,16(sp)
    8000197e:	69a2                	ld	s3,8(sp)
    80001980:	6a02                	ld	s4,0(sp)
    80001982:	6145                	addi	sp,sp,48
    80001984:	8082                	ret
    memmove((char *)dst, src, len);
    80001986:	000a061b          	sext.w	a2,s4
    8000198a:	85ce                	mv	a1,s3
    8000198c:	854a                	mv	a0,s2
    8000198e:	fffff097          	auipc	ra,0xfffff
    80001992:	84a080e7          	jalr	-1974(ra) # 800001d8 <memmove>
    return 0;
    80001996:	8526                	mv	a0,s1
    80001998:	bff9                	j	80001976 <either_copyout+0x32>

000000008000199a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000199a:	7179                	addi	sp,sp,-48
    8000199c:	f406                	sd	ra,40(sp)
    8000199e:	f022                	sd	s0,32(sp)
    800019a0:	ec26                	sd	s1,24(sp)
    800019a2:	e84a                	sd	s2,16(sp)
    800019a4:	e44e                	sd	s3,8(sp)
    800019a6:	e052                	sd	s4,0(sp)
    800019a8:	1800                	addi	s0,sp,48
    800019aa:	892a                	mv	s2,a0
    800019ac:	84ae                	mv	s1,a1
    800019ae:	89b2                	mv	s3,a2
    800019b0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	4a6080e7          	jalr	1190(ra) # 80000e58 <myproc>
  if(user_src){
    800019ba:	c08d                	beqz	s1,800019dc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019bc:	86d2                	mv	a3,s4
    800019be:	864e                	mv	a2,s3
    800019c0:	85ca                	mv	a1,s2
    800019c2:	6928                	ld	a0,80(a0)
    800019c4:	fffff097          	auipc	ra,0xfffff
    800019c8:	1de080e7          	jalr	478(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019cc:	70a2                	ld	ra,40(sp)
    800019ce:	7402                	ld	s0,32(sp)
    800019d0:	64e2                	ld	s1,24(sp)
    800019d2:	6942                	ld	s2,16(sp)
    800019d4:	69a2                	ld	s3,8(sp)
    800019d6:	6a02                	ld	s4,0(sp)
    800019d8:	6145                	addi	sp,sp,48
    800019da:	8082                	ret
    memmove(dst, (char*)src, len);
    800019dc:	000a061b          	sext.w	a2,s4
    800019e0:	85ce                	mv	a1,s3
    800019e2:	854a                	mv	a0,s2
    800019e4:	ffffe097          	auipc	ra,0xffffe
    800019e8:	7f4080e7          	jalr	2036(ra) # 800001d8 <memmove>
    return 0;
    800019ec:	8526                	mv	a0,s1
    800019ee:	bff9                	j	800019cc <either_copyin+0x32>

00000000800019f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019f0:	715d                	addi	sp,sp,-80
    800019f2:	e486                	sd	ra,72(sp)
    800019f4:	e0a2                	sd	s0,64(sp)
    800019f6:	fc26                	sd	s1,56(sp)
    800019f8:	f84a                	sd	s2,48(sp)
    800019fa:	f44e                	sd	s3,40(sp)
    800019fc:	f052                	sd	s4,32(sp)
    800019fe:	ec56                	sd	s5,24(sp)
    80001a00:	e85a                	sd	s6,16(sp)
    80001a02:	e45e                	sd	s7,8(sp)
    80001a04:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a06:	00006517          	auipc	a0,0x6
    80001a0a:	64250513          	addi	a0,a0,1602 # 80008048 <etext+0x48>
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	3d2080e7          	jalr	978(ra) # 80005de0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a16:	00007497          	auipc	s1,0x7
    80001a1a:	48248493          	addi	s1,s1,1154 # 80008e98 <proc+0x158>
    80001a1e:	0000e917          	auipc	s2,0xe
    80001a22:	87a90913          	addi	s2,s2,-1926 # 8000f298 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a26:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a28:	00006997          	auipc	s3,0x6
    80001a2c:	7d898993          	addi	s3,s3,2008 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a30:	00006a97          	auipc	s5,0x6
    80001a34:	7d8a8a93          	addi	s5,s5,2008 # 80008208 <etext+0x208>
    printf("\n");
    80001a38:	00006a17          	auipc	s4,0x6
    80001a3c:	610a0a13          	addi	s4,s4,1552 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a40:	00007b97          	auipc	s7,0x7
    80001a44:	808b8b93          	addi	s7,s7,-2040 # 80008248 <states.1732>
    80001a48:	a00d                	j	80001a6a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a4a:	ed86a583          	lw	a1,-296(a3)
    80001a4e:	8556                	mv	a0,s5
    80001a50:	00004097          	auipc	ra,0x4
    80001a54:	390080e7          	jalr	912(ra) # 80005de0 <printf>
    printf("\n");
    80001a58:	8552                	mv	a0,s4
    80001a5a:	00004097          	auipc	ra,0x4
    80001a5e:	386080e7          	jalr	902(ra) # 80005de0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a62:	19048493          	addi	s1,s1,400
    80001a66:	03248163          	beq	s1,s2,80001a88 <procdump+0x98>
    if(p->state == UNUSED)
    80001a6a:	86a6                	mv	a3,s1
    80001a6c:	ec04a783          	lw	a5,-320(s1)
    80001a70:	dbed                	beqz	a5,80001a62 <procdump+0x72>
      state = "???";
    80001a72:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a74:	fcfb6be3          	bltu	s6,a5,80001a4a <procdump+0x5a>
    80001a78:	1782                	slli	a5,a5,0x20
    80001a7a:	9381                	srli	a5,a5,0x20
    80001a7c:	078e                	slli	a5,a5,0x3
    80001a7e:	97de                	add	a5,a5,s7
    80001a80:	6390                	ld	a2,0(a5)
    80001a82:	f661                	bnez	a2,80001a4a <procdump+0x5a>
      state = "???";
    80001a84:	864e                	mv	a2,s3
    80001a86:	b7d1                	j	80001a4a <procdump+0x5a>
  }
}
    80001a88:	60a6                	ld	ra,72(sp)
    80001a8a:	6406                	ld	s0,64(sp)
    80001a8c:	74e2                	ld	s1,56(sp)
    80001a8e:	7942                	ld	s2,48(sp)
    80001a90:	79a2                	ld	s3,40(sp)
    80001a92:	7a02                	ld	s4,32(sp)
    80001a94:	6ae2                	ld	s5,24(sp)
    80001a96:	6b42                	ld	s6,16(sp)
    80001a98:	6ba2                	ld	s7,8(sp)
    80001a9a:	6161                	addi	sp,sp,80
    80001a9c:	8082                	ret

0000000080001a9e <swtch>:
    80001a9e:	00153023          	sd	ra,0(a0)
    80001aa2:	00253423          	sd	sp,8(a0)
    80001aa6:	e900                	sd	s0,16(a0)
    80001aa8:	ed04                	sd	s1,24(a0)
    80001aaa:	03253023          	sd	s2,32(a0)
    80001aae:	03353423          	sd	s3,40(a0)
    80001ab2:	03453823          	sd	s4,48(a0)
    80001ab6:	03553c23          	sd	s5,56(a0)
    80001aba:	05653023          	sd	s6,64(a0)
    80001abe:	05753423          	sd	s7,72(a0)
    80001ac2:	05853823          	sd	s8,80(a0)
    80001ac6:	05953c23          	sd	s9,88(a0)
    80001aca:	07a53023          	sd	s10,96(a0)
    80001ace:	07b53423          	sd	s11,104(a0)
    80001ad2:	0005b083          	ld	ra,0(a1)
    80001ad6:	0085b103          	ld	sp,8(a1)
    80001ada:	6980                	ld	s0,16(a1)
    80001adc:	6d84                	ld	s1,24(a1)
    80001ade:	0205b903          	ld	s2,32(a1)
    80001ae2:	0285b983          	ld	s3,40(a1)
    80001ae6:	0305ba03          	ld	s4,48(a1)
    80001aea:	0385ba83          	ld	s5,56(a1)
    80001aee:	0405bb03          	ld	s6,64(a1)
    80001af2:	0485bb83          	ld	s7,72(a1)
    80001af6:	0505bc03          	ld	s8,80(a1)
    80001afa:	0585bc83          	ld	s9,88(a1)
    80001afe:	0605bd03          	ld	s10,96(a1)
    80001b02:	0685bd83          	ld	s11,104(a1)
    80001b06:	8082                	ret

0000000080001b08 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b08:	1141                	addi	sp,sp,-16
    80001b0a:	e406                	sd	ra,8(sp)
    80001b0c:	e022                	sd	s0,0(sp)
    80001b0e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b10:	00006597          	auipc	a1,0x6
    80001b14:	76858593          	addi	a1,a1,1896 # 80008278 <states.1732+0x30>
    80001b18:	0000d517          	auipc	a0,0xd
    80001b1c:	62850513          	addi	a0,a0,1576 # 8000f140 <tickslock>
    80001b20:	00004097          	auipc	ra,0x4
    80001b24:	6fe080e7          	jalr	1790(ra) # 8000621e <initlock>
}
    80001b28:	60a2                	ld	ra,8(sp)
    80001b2a:	6402                	ld	s0,0(sp)
    80001b2c:	0141                	addi	sp,sp,16
    80001b2e:	8082                	ret

0000000080001b30 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b30:	1141                	addi	sp,sp,-16
    80001b32:	e422                	sd	s0,8(sp)
    80001b34:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b36:	00003797          	auipc	a5,0x3
    80001b3a:	59a78793          	addi	a5,a5,1434 # 800050d0 <kernelvec>
    80001b3e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b42:	6422                	ld	s0,8(sp)
    80001b44:	0141                	addi	sp,sp,16
    80001b46:	8082                	ret

0000000080001b48 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b48:	1141                	addi	sp,sp,-16
    80001b4a:	e406                	sd	ra,8(sp)
    80001b4c:	e022                	sd	s0,0(sp)
    80001b4e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b50:	fffff097          	auipc	ra,0xfffff
    80001b54:	308080e7          	jalr	776(ra) # 80000e58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b5c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b62:	00005617          	auipc	a2,0x5
    80001b66:	49e60613          	addi	a2,a2,1182 # 80007000 <_trampoline>
    80001b6a:	00005697          	auipc	a3,0x5
    80001b6e:	49668693          	addi	a3,a3,1174 # 80007000 <_trampoline>
    80001b72:	8e91                	sub	a3,a3,a2
    80001b74:	040007b7          	lui	a5,0x4000
    80001b78:	17fd                	addi	a5,a5,-1
    80001b7a:	07b2                	slli	a5,a5,0xc
    80001b7c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b7e:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b82:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b84:	180026f3          	csrr	a3,satp
    80001b88:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b8a:	6d38                	ld	a4,88(a0)
    80001b8c:	6134                	ld	a3,64(a0)
    80001b8e:	6585                	lui	a1,0x1
    80001b90:	96ae                	add	a3,a3,a1
    80001b92:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b94:	6d38                	ld	a4,88(a0)
    80001b96:	00000697          	auipc	a3,0x0
    80001b9a:	13068693          	addi	a3,a3,304 # 80001cc6 <usertrap>
    80001b9e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ba0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ba2:	8692                	mv	a3,tp
    80001ba4:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba6:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001baa:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bae:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bb6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bb8:	6f18                	ld	a4,24(a4)
    80001bba:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bbe:	6928                	ld	a0,80(a0)
    80001bc0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bc2:	00005717          	auipc	a4,0x5
    80001bc6:	4da70713          	addi	a4,a4,1242 # 8000709c <userret>
    80001bca:	8f11                	sub	a4,a4,a2
    80001bcc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001bce:	577d                	li	a4,-1
    80001bd0:	177e                	slli	a4,a4,0x3f
    80001bd2:	8d59                	or	a0,a0,a4
    80001bd4:	9782                	jalr	a5
}
    80001bd6:	60a2                	ld	ra,8(sp)
    80001bd8:	6402                	ld	s0,0(sp)
    80001bda:	0141                	addi	sp,sp,16
    80001bdc:	8082                	ret

0000000080001bde <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bde:	1101                	addi	sp,sp,-32
    80001be0:	ec06                	sd	ra,24(sp)
    80001be2:	e822                	sd	s0,16(sp)
    80001be4:	e426                	sd	s1,8(sp)
    80001be6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001be8:	0000d497          	auipc	s1,0xd
    80001bec:	55848493          	addi	s1,s1,1368 # 8000f140 <tickslock>
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	00004097          	auipc	ra,0x4
    80001bf6:	6bc080e7          	jalr	1724(ra) # 800062ae <acquire>
  ticks++;
    80001bfa:	00007517          	auipc	a0,0x7
    80001bfe:	cde50513          	addi	a0,a0,-802 # 800088d8 <ticks>
    80001c02:	411c                	lw	a5,0(a0)
    80001c04:	2785                	addiw	a5,a5,1
    80001c06:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c08:	00000097          	auipc	ra,0x0
    80001c0c:	998080e7          	jalr	-1640(ra) # 800015a0 <wakeup>
  release(&tickslock);
    80001c10:	8526                	mv	a0,s1
    80001c12:	00004097          	auipc	ra,0x4
    80001c16:	750080e7          	jalr	1872(ra) # 80006362 <release>
}
    80001c1a:	60e2                	ld	ra,24(sp)
    80001c1c:	6442                	ld	s0,16(sp)
    80001c1e:	64a2                	ld	s1,8(sp)
    80001c20:	6105                	addi	sp,sp,32
    80001c22:	8082                	ret

0000000080001c24 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c2e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c32:	00074d63          	bltz	a4,80001c4c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c36:	57fd                	li	a5,-1
    80001c38:	17fe                	slli	a5,a5,0x3f
    80001c3a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c3c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c3e:	06f70363          	beq	a4,a5,80001ca4 <devintr+0x80>
  }
}
    80001c42:	60e2                	ld	ra,24(sp)
    80001c44:	6442                	ld	s0,16(sp)
    80001c46:	64a2                	ld	s1,8(sp)
    80001c48:	6105                	addi	sp,sp,32
    80001c4a:	8082                	ret
     (scause & 0xff) == 9){
    80001c4c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c50:	46a5                	li	a3,9
    80001c52:	fed792e3          	bne	a5,a3,80001c36 <devintr+0x12>
    int irq = plic_claim();
    80001c56:	00003097          	auipc	ra,0x3
    80001c5a:	582080e7          	jalr	1410(ra) # 800051d8 <plic_claim>
    80001c5e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c60:	47a9                	li	a5,10
    80001c62:	02f50763          	beq	a0,a5,80001c90 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c66:	4785                	li	a5,1
    80001c68:	02f50963          	beq	a0,a5,80001c9a <devintr+0x76>
    return 1;
    80001c6c:	4505                	li	a0,1
    } else if(irq){
    80001c6e:	d8f1                	beqz	s1,80001c42 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c70:	85a6                	mv	a1,s1
    80001c72:	00006517          	auipc	a0,0x6
    80001c76:	60e50513          	addi	a0,a0,1550 # 80008280 <states.1732+0x38>
    80001c7a:	00004097          	auipc	ra,0x4
    80001c7e:	166080e7          	jalr	358(ra) # 80005de0 <printf>
      plic_complete(irq);
    80001c82:	8526                	mv	a0,s1
    80001c84:	00003097          	auipc	ra,0x3
    80001c88:	578080e7          	jalr	1400(ra) # 800051fc <plic_complete>
    return 1;
    80001c8c:	4505                	li	a0,1
    80001c8e:	bf55                	j	80001c42 <devintr+0x1e>
      uartintr();
    80001c90:	00004097          	auipc	ra,0x4
    80001c94:	53e080e7          	jalr	1342(ra) # 800061ce <uartintr>
    80001c98:	b7ed                	j	80001c82 <devintr+0x5e>
      virtio_disk_intr();
    80001c9a:	00004097          	auipc	ra,0x4
    80001c9e:	a8c080e7          	jalr	-1396(ra) # 80005726 <virtio_disk_intr>
    80001ca2:	b7c5                	j	80001c82 <devintr+0x5e>
    if(cpuid() == 0){
    80001ca4:	fffff097          	auipc	ra,0xfffff
    80001ca8:	188080e7          	jalr	392(ra) # 80000e2c <cpuid>
    80001cac:	c901                	beqz	a0,80001cbc <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cae:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cb2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cb4:	14479073          	csrw	sip,a5
    return 2;
    80001cb8:	4509                	li	a0,2
    80001cba:	b761                	j	80001c42 <devintr+0x1e>
      clockintr();
    80001cbc:	00000097          	auipc	ra,0x0
    80001cc0:	f22080e7          	jalr	-222(ra) # 80001bde <clockintr>
    80001cc4:	b7ed                	j	80001cae <devintr+0x8a>

0000000080001cc6 <usertrap>:
{
    80001cc6:	1101                	addi	sp,sp,-32
    80001cc8:	ec06                	sd	ra,24(sp)
    80001cca:	e822                	sd	s0,16(sp)
    80001ccc:	e426                	sd	s1,8(sp)
    80001cce:	e04a                	sd	s2,0(sp)
    80001cd0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cd6:	1007f793          	andi	a5,a5,256
    80001cda:	e3b1                	bnez	a5,80001d1e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cdc:	00003797          	auipc	a5,0x3
    80001ce0:	3f478793          	addi	a5,a5,1012 # 800050d0 <kernelvec>
    80001ce4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ce8:	fffff097          	auipc	ra,0xfffff
    80001cec:	170080e7          	jalr	368(ra) # 80000e58 <myproc>
    80001cf0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cf2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf4:	14102773          	csrr	a4,sepc
    80001cf8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cfa:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cfe:	47a1                	li	a5,8
    80001d00:	02f70763          	beq	a4,a5,80001d2e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	f20080e7          	jalr	-224(ra) # 80001c24 <devintr>
    80001d0c:	892a                	mv	s2,a0
    80001d0e:	c92d                	beqz	a0,80001d80 <usertrap+0xba>
  if(killed(p))
    80001d10:	8526                	mv	a0,s1
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	ad2080e7          	jalr	-1326(ra) # 800017e4 <killed>
    80001d1a:	c555                	beqz	a0,80001dc6 <usertrap+0x100>
    80001d1c:	a045                	j	80001dbc <usertrap+0xf6>
    panic("usertrap: not from user mode");
    80001d1e:	00006517          	auipc	a0,0x6
    80001d22:	58250513          	addi	a0,a0,1410 # 800082a0 <states.1732+0x58>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	068080e7          	jalr	104(ra) # 80005d8e <panic>
    if(killed(p))
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	ab6080e7          	jalr	-1354(ra) # 800017e4 <killed>
    80001d36:	ed1d                	bnez	a0,80001d74 <usertrap+0xae>
    p->trapframe->epc += 4;
    80001d38:	6cb8                	ld	a4,88(s1)
    80001d3a:	6f1c                	ld	a5,24(a4)
    80001d3c:	0791                	addi	a5,a5,4
    80001d3e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d40:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d44:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d48:	10079073          	csrw	sstatus,a5
    syscall();
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	31c080e7          	jalr	796(ra) # 80002068 <syscall>
  if(killed(p))
    80001d54:	8526                	mv	a0,s1
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	a8e080e7          	jalr	-1394(ra) # 800017e4 <killed>
    80001d5e:	ed31                	bnez	a0,80001dba <usertrap+0xf4>
  usertrapret();
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	de8080e7          	jalr	-536(ra) # 80001b48 <usertrapret>
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6902                	ld	s2,0(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret
      exit(-1);
    80001d74:	557d                	li	a0,-1
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	8fa080e7          	jalr	-1798(ra) # 80001670 <exit>
    80001d7e:	bf6d                	j	80001d38 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d80:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d84:	5890                	lw	a2,48(s1)
    80001d86:	00006517          	auipc	a0,0x6
    80001d8a:	53a50513          	addi	a0,a0,1338 # 800082c0 <states.1732+0x78>
    80001d8e:	00004097          	auipc	ra,0x4
    80001d92:	052080e7          	jalr	82(ra) # 80005de0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d96:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d9a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d9e:	00006517          	auipc	a0,0x6
    80001da2:	55250513          	addi	a0,a0,1362 # 800082f0 <states.1732+0xa8>
    80001da6:	00004097          	auipc	ra,0x4
    80001daa:	03a080e7          	jalr	58(ra) # 80005de0 <printf>
    setkilled(p);
    80001dae:	8526                	mv	a0,s1
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	a08080e7          	jalr	-1528(ra) # 800017b8 <setkilled>
    80001db8:	bf71                	j	80001d54 <usertrap+0x8e>
  if(killed(p))
    80001dba:	4901                	li	s2,0
    exit(-1);
    80001dbc:	557d                	li	a0,-1
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	8b2080e7          	jalr	-1870(ra) # 80001670 <exit>
  if(which_dev == 2){
    80001dc6:	4789                	li	a5,2
    80001dc8:	f8f91ce3          	bne	s2,a5,80001d60 <usertrap+0x9a>
    p->passed_ticks++;
    80001dcc:	1784a783          	lw	a5,376(s1)
    80001dd0:	2785                	addiw	a5,a5,1
    80001dd2:	0007871b          	sext.w	a4,a5
    80001dd6:	16f4ac23          	sw	a5,376(s1)
    if( p->interval > 0 && p->passed_ticks >= p->interval && p->ret_flag == 1){
    80001dda:	1684a783          	lw	a5,360(s1)
    80001dde:	00f05963          	blez	a5,80001df0 <usertrap+0x12a>
    80001de2:	00f74763          	blt	a4,a5,80001df0 <usertrap+0x12a>
    80001de6:	1884a703          	lw	a4,392(s1)
    80001dea:	4785                	li	a5,1
    80001dec:	00f70763          	beq	a4,a5,80001dfa <usertrap+0x134>
    yield();
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	710080e7          	jalr	1808(ra) # 80001500 <yield>
    80001df8:	b7a5                	j	80001d60 <usertrap+0x9a>
      memmove(p->trapframe_backup, p->trapframe, sizeof(struct trapframe));
    80001dfa:	12000613          	li	a2,288
    80001dfe:	6cac                	ld	a1,88(s1)
    80001e00:	1804b503          	ld	a0,384(s1)
    80001e04:	ffffe097          	auipc	ra,0xffffe
    80001e08:	3d4080e7          	jalr	980(ra) # 800001d8 <memmove>
      p->passed_ticks = 0;
    80001e0c:	1604ac23          	sw	zero,376(s1)
      p->trapframe->epc = p->handler;
    80001e10:	6cbc                	ld	a5,88(s1)
    80001e12:	1704b703          	ld	a4,368(s1)
    80001e16:	ef98                	sd	a4,24(a5)
      p->ret_flag = 0;
    80001e18:	1804a423          	sw	zero,392(s1)
    80001e1c:	bfd1                	j	80001df0 <usertrap+0x12a>

0000000080001e1e <kerneltrap>:
{
    80001e1e:	7179                	addi	sp,sp,-48
    80001e20:	f406                	sd	ra,40(sp)
    80001e22:	f022                	sd	s0,32(sp)
    80001e24:	ec26                	sd	s1,24(sp)
    80001e26:	e84a                	sd	s2,16(sp)
    80001e28:	e44e                	sd	s3,8(sp)
    80001e2a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e30:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e34:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e38:	1004f793          	andi	a5,s1,256
    80001e3c:	cb85                	beqz	a5,80001e6c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e42:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e44:	ef85                	bnez	a5,80001e7c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	dde080e7          	jalr	-546(ra) # 80001c24 <devintr>
    80001e4e:	cd1d                	beqz	a0,80001e8c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e50:	4789                	li	a5,2
    80001e52:	06f50a63          	beq	a0,a5,80001ec6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e56:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5a:	10049073          	csrw	sstatus,s1
}
    80001e5e:	70a2                	ld	ra,40(sp)
    80001e60:	7402                	ld	s0,32(sp)
    80001e62:	64e2                	ld	s1,24(sp)
    80001e64:	6942                	ld	s2,16(sp)
    80001e66:	69a2                	ld	s3,8(sp)
    80001e68:	6145                	addi	sp,sp,48
    80001e6a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e6c:	00006517          	auipc	a0,0x6
    80001e70:	4a450513          	addi	a0,a0,1188 # 80008310 <states.1732+0xc8>
    80001e74:	00004097          	auipc	ra,0x4
    80001e78:	f1a080e7          	jalr	-230(ra) # 80005d8e <panic>
    panic("kerneltrap: interrupts enabled");
    80001e7c:	00006517          	auipc	a0,0x6
    80001e80:	4bc50513          	addi	a0,a0,1212 # 80008338 <states.1732+0xf0>
    80001e84:	00004097          	auipc	ra,0x4
    80001e88:	f0a080e7          	jalr	-246(ra) # 80005d8e <panic>
    printf("scause %p\n", scause);
    80001e8c:	85ce                	mv	a1,s3
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	4ca50513          	addi	a0,a0,1226 # 80008358 <states.1732+0x110>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	f4a080e7          	jalr	-182(ra) # 80005de0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e9e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ea2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea6:	00006517          	auipc	a0,0x6
    80001eaa:	4c250513          	addi	a0,a0,1218 # 80008368 <states.1732+0x120>
    80001eae:	00004097          	auipc	ra,0x4
    80001eb2:	f32080e7          	jalr	-206(ra) # 80005de0 <printf>
    panic("kerneltrap");
    80001eb6:	00006517          	auipc	a0,0x6
    80001eba:	4ca50513          	addi	a0,a0,1226 # 80008380 <states.1732+0x138>
    80001ebe:	00004097          	auipc	ra,0x4
    80001ec2:	ed0080e7          	jalr	-304(ra) # 80005d8e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	f92080e7          	jalr	-110(ra) # 80000e58 <myproc>
    80001ece:	d541                	beqz	a0,80001e56 <kerneltrap+0x38>
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	f88080e7          	jalr	-120(ra) # 80000e58 <myproc>
    80001ed8:	4d18                	lw	a4,24(a0)
    80001eda:	4791                	li	a5,4
    80001edc:	f6f71de3          	bne	a4,a5,80001e56 <kerneltrap+0x38>
    yield();
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	620080e7          	jalr	1568(ra) # 80001500 <yield>
    80001ee8:	b7bd                	j	80001e56 <kerneltrap+0x38>

0000000080001eea <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	e426                	sd	s1,8(sp)
    80001ef2:	1000                	addi	s0,sp,32
    80001ef4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	f62080e7          	jalr	-158(ra) # 80000e58 <myproc>
  switch (n) {
    80001efe:	4795                	li	a5,5
    80001f00:	0497e163          	bltu	a5,s1,80001f42 <argraw+0x58>
    80001f04:	048a                	slli	s1,s1,0x2
    80001f06:	00006717          	auipc	a4,0x6
    80001f0a:	4b270713          	addi	a4,a4,1202 # 800083b8 <states.1732+0x170>
    80001f0e:	94ba                	add	s1,s1,a4
    80001f10:	409c                	lw	a5,0(s1)
    80001f12:	97ba                	add	a5,a5,a4
    80001f14:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f16:	6d3c                	ld	a5,88(a0)
    80001f18:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f1a:	60e2                	ld	ra,24(sp)
    80001f1c:	6442                	ld	s0,16(sp)
    80001f1e:	64a2                	ld	s1,8(sp)
    80001f20:	6105                	addi	sp,sp,32
    80001f22:	8082                	ret
    return p->trapframe->a1;
    80001f24:	6d3c                	ld	a5,88(a0)
    80001f26:	7fa8                	ld	a0,120(a5)
    80001f28:	bfcd                	j	80001f1a <argraw+0x30>
    return p->trapframe->a2;
    80001f2a:	6d3c                	ld	a5,88(a0)
    80001f2c:	63c8                	ld	a0,128(a5)
    80001f2e:	b7f5                	j	80001f1a <argraw+0x30>
    return p->trapframe->a3;
    80001f30:	6d3c                	ld	a5,88(a0)
    80001f32:	67c8                	ld	a0,136(a5)
    80001f34:	b7dd                	j	80001f1a <argraw+0x30>
    return p->trapframe->a4;
    80001f36:	6d3c                	ld	a5,88(a0)
    80001f38:	6bc8                	ld	a0,144(a5)
    80001f3a:	b7c5                	j	80001f1a <argraw+0x30>
    return p->trapframe->a5;
    80001f3c:	6d3c                	ld	a5,88(a0)
    80001f3e:	6fc8                	ld	a0,152(a5)
    80001f40:	bfe9                	j	80001f1a <argraw+0x30>
  panic("argraw");
    80001f42:	00006517          	auipc	a0,0x6
    80001f46:	44e50513          	addi	a0,a0,1102 # 80008390 <states.1732+0x148>
    80001f4a:	00004097          	auipc	ra,0x4
    80001f4e:	e44080e7          	jalr	-444(ra) # 80005d8e <panic>

0000000080001f52 <fetchaddr>:
{
    80001f52:	1101                	addi	sp,sp,-32
    80001f54:	ec06                	sd	ra,24(sp)
    80001f56:	e822                	sd	s0,16(sp)
    80001f58:	e426                	sd	s1,8(sp)
    80001f5a:	e04a                	sd	s2,0(sp)
    80001f5c:	1000                	addi	s0,sp,32
    80001f5e:	84aa                	mv	s1,a0
    80001f60:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	ef6080e7          	jalr	-266(ra) # 80000e58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f6a:	653c                	ld	a5,72(a0)
    80001f6c:	02f4f863          	bgeu	s1,a5,80001f9c <fetchaddr+0x4a>
    80001f70:	00848713          	addi	a4,s1,8
    80001f74:	02e7e663          	bltu	a5,a4,80001fa0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f78:	46a1                	li	a3,8
    80001f7a:	8626                	mv	a2,s1
    80001f7c:	85ca                	mv	a1,s2
    80001f7e:	6928                	ld	a0,80(a0)
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	c22080e7          	jalr	-990(ra) # 80000ba2 <copyin>
    80001f88:	00a03533          	snez	a0,a0
    80001f8c:	40a00533          	neg	a0,a0
}
    80001f90:	60e2                	ld	ra,24(sp)
    80001f92:	6442                	ld	s0,16(sp)
    80001f94:	64a2                	ld	s1,8(sp)
    80001f96:	6902                	ld	s2,0(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret
    return -1;
    80001f9c:	557d                	li	a0,-1
    80001f9e:	bfcd                	j	80001f90 <fetchaddr+0x3e>
    80001fa0:	557d                	li	a0,-1
    80001fa2:	b7fd                	j	80001f90 <fetchaddr+0x3e>

0000000080001fa4 <fetchstr>:
{
    80001fa4:	7179                	addi	sp,sp,-48
    80001fa6:	f406                	sd	ra,40(sp)
    80001fa8:	f022                	sd	s0,32(sp)
    80001faa:	ec26                	sd	s1,24(sp)
    80001fac:	e84a                	sd	s2,16(sp)
    80001fae:	e44e                	sd	s3,8(sp)
    80001fb0:	1800                	addi	s0,sp,48
    80001fb2:	892a                	mv	s2,a0
    80001fb4:	84ae                	mv	s1,a1
    80001fb6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	ea0080e7          	jalr	-352(ra) # 80000e58 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fc0:	86ce                	mv	a3,s3
    80001fc2:	864a                	mv	a2,s2
    80001fc4:	85a6                	mv	a1,s1
    80001fc6:	6928                	ld	a0,80(a0)
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	c66080e7          	jalr	-922(ra) # 80000c2e <copyinstr>
    80001fd0:	00054e63          	bltz	a0,80001fec <fetchstr+0x48>
  return strlen(buf);
    80001fd4:	8526                	mv	a0,s1
    80001fd6:	ffffe097          	auipc	ra,0xffffe
    80001fda:	326080e7          	jalr	806(ra) # 800002fc <strlen>
}
    80001fde:	70a2                	ld	ra,40(sp)
    80001fe0:	7402                	ld	s0,32(sp)
    80001fe2:	64e2                	ld	s1,24(sp)
    80001fe4:	6942                	ld	s2,16(sp)
    80001fe6:	69a2                	ld	s3,8(sp)
    80001fe8:	6145                	addi	sp,sp,48
    80001fea:	8082                	ret
    return -1;
    80001fec:	557d                	li	a0,-1
    80001fee:	bfc5                	j	80001fde <fetchstr+0x3a>

0000000080001ff0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	1000                	addi	s0,sp,32
    80001ffa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	eee080e7          	jalr	-274(ra) # 80001eea <argraw>
    80002004:	c088                	sw	a0,0(s1)
}
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	64a2                	ld	s1,8(sp)
    8000200c:	6105                	addi	sp,sp,32
    8000200e:	8082                	ret

0000000080002010 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002010:	1101                	addi	sp,sp,-32
    80002012:	ec06                	sd	ra,24(sp)
    80002014:	e822                	sd	s0,16(sp)
    80002016:	e426                	sd	s1,8(sp)
    80002018:	1000                	addi	s0,sp,32
    8000201a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	ece080e7          	jalr	-306(ra) # 80001eea <argraw>
    80002024:	e088                	sd	a0,0(s1)
}
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002030:	7179                	addi	sp,sp,-48
    80002032:	f406                	sd	ra,40(sp)
    80002034:	f022                	sd	s0,32(sp)
    80002036:	ec26                	sd	s1,24(sp)
    80002038:	e84a                	sd	s2,16(sp)
    8000203a:	1800                	addi	s0,sp,48
    8000203c:	84ae                	mv	s1,a1
    8000203e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002040:	fd840593          	addi	a1,s0,-40
    80002044:	00000097          	auipc	ra,0x0
    80002048:	fcc080e7          	jalr	-52(ra) # 80002010 <argaddr>
  return fetchstr(addr, buf, max);
    8000204c:	864a                	mv	a2,s2
    8000204e:	85a6                	mv	a1,s1
    80002050:	fd843503          	ld	a0,-40(s0)
    80002054:	00000097          	auipc	ra,0x0
    80002058:	f50080e7          	jalr	-176(ra) # 80001fa4 <fetchstr>
}
    8000205c:	70a2                	ld	ra,40(sp)
    8000205e:	7402                	ld	s0,32(sp)
    80002060:	64e2                	ld	s1,24(sp)
    80002062:	6942                	ld	s2,16(sp)
    80002064:	6145                	addi	sp,sp,48
    80002066:	8082                	ret

0000000080002068 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	e04a                	sd	s2,0(sp)
    80002072:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	de4080e7          	jalr	-540(ra) # 80000e58 <myproc>
    8000207c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000207e:	05853903          	ld	s2,88(a0)
    80002082:	0a893783          	ld	a5,168(s2)
    80002086:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000208a:	37fd                	addiw	a5,a5,-1
    8000208c:	4759                	li	a4,22
    8000208e:	00f76f63          	bltu	a4,a5,800020ac <syscall+0x44>
    80002092:	00369713          	slli	a4,a3,0x3
    80002096:	00006797          	auipc	a5,0x6
    8000209a:	33a78793          	addi	a5,a5,826 # 800083d0 <syscalls>
    8000209e:	97ba                	add	a5,a5,a4
    800020a0:	639c                	ld	a5,0(a5)
    800020a2:	c789                	beqz	a5,800020ac <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020a4:	9782                	jalr	a5
    800020a6:	06a93823          	sd	a0,112(s2)
    800020aa:	a839                	j	800020c8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ac:	15848613          	addi	a2,s1,344
    800020b0:	588c                	lw	a1,48(s1)
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	2e650513          	addi	a0,a0,742 # 80008398 <states.1732+0x150>
    800020ba:	00004097          	auipc	ra,0x4
    800020be:	d26080e7          	jalr	-730(ra) # 80005de0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020c2:	6cbc                	ld	a5,88(s1)
    800020c4:	577d                	li	a4,-1
    800020c6:	fbb8                	sd	a4,112(a5)
  }
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6902                	ld	s2,0(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020dc:	fec40593          	addi	a1,s0,-20
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	f0e080e7          	jalr	-242(ra) # 80001ff0 <argint>
  exit(n);
    800020ea:	fec42503          	lw	a0,-20(s0)
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	582080e7          	jalr	1410(ra) # 80001670 <exit>
  return 0;  // not reached
}
    800020f6:	4501                	li	a0,0
    800020f8:	60e2                	ld	ra,24(sp)
    800020fa:	6442                	ld	s0,16(sp)
    800020fc:	6105                	addi	sp,sp,32
    800020fe:	8082                	ret

0000000080002100 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002100:	1141                	addi	sp,sp,-16
    80002102:	e406                	sd	ra,8(sp)
    80002104:	e022                	sd	s0,0(sp)
    80002106:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	d50080e7          	jalr	-688(ra) # 80000e58 <myproc>
}
    80002110:	5908                	lw	a0,48(a0)
    80002112:	60a2                	ld	ra,8(sp)
    80002114:	6402                	ld	s0,0(sp)
    80002116:	0141                	addi	sp,sp,16
    80002118:	8082                	ret

000000008000211a <sys_fork>:

uint64
sys_fork(void)
{
    8000211a:	1141                	addi	sp,sp,-16
    8000211c:	e406                	sd	ra,8(sp)
    8000211e:	e022                	sd	s0,0(sp)
    80002120:	0800                	addi	s0,sp,16
  return fork();
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	12c080e7          	jalr	300(ra) # 8000124e <fork>
}
    8000212a:	60a2                	ld	ra,8(sp)
    8000212c:	6402                	ld	s0,0(sp)
    8000212e:	0141                	addi	sp,sp,16
    80002130:	8082                	ret

0000000080002132 <sys_wait>:

uint64
sys_wait(void)
{
    80002132:	1101                	addi	sp,sp,-32
    80002134:	ec06                	sd	ra,24(sp)
    80002136:	e822                	sd	s0,16(sp)
    80002138:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000213a:	fe840593          	addi	a1,s0,-24
    8000213e:	4501                	li	a0,0
    80002140:	00000097          	auipc	ra,0x0
    80002144:	ed0080e7          	jalr	-304(ra) # 80002010 <argaddr>
  return wait(p);
    80002148:	fe843503          	ld	a0,-24(s0)
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	6ca080e7          	jalr	1738(ra) # 80001816 <wait>
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	6105                	addi	sp,sp,32
    8000215a:	8082                	ret

000000008000215c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000215c:	7179                	addi	sp,sp,-48
    8000215e:	f406                	sd	ra,40(sp)
    80002160:	f022                	sd	s0,32(sp)
    80002162:	ec26                	sd	s1,24(sp)
    80002164:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002166:	fdc40593          	addi	a1,s0,-36
    8000216a:	4501                	li	a0,0
    8000216c:	00000097          	auipc	ra,0x0
    80002170:	e84080e7          	jalr	-380(ra) # 80001ff0 <argint>
  addr = myproc()->sz;
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	ce4080e7          	jalr	-796(ra) # 80000e58 <myproc>
    8000217c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000217e:	fdc42503          	lw	a0,-36(s0)
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	070080e7          	jalr	112(ra) # 800011f2 <growproc>
    8000218a:	00054863          	bltz	a0,8000219a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000218e:	8526                	mv	a0,s1
    80002190:	70a2                	ld	ra,40(sp)
    80002192:	7402                	ld	s0,32(sp)
    80002194:	64e2                	ld	s1,24(sp)
    80002196:	6145                	addi	sp,sp,48
    80002198:	8082                	ret
    return -1;
    8000219a:	54fd                	li	s1,-1
    8000219c:	bfcd                	j	8000218e <sys_sbrk+0x32>

000000008000219e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000219e:	7139                	addi	sp,sp,-64
    800021a0:	fc06                	sd	ra,56(sp)
    800021a2:	f822                	sd	s0,48(sp)
    800021a4:	f426                	sd	s1,40(sp)
    800021a6:	f04a                	sd	s2,32(sp)
    800021a8:	ec4e                	sd	s3,24(sp)
    800021aa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021ac:	fcc40593          	addi	a1,s0,-52
    800021b0:	4501                	li	a0,0
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	e3e080e7          	jalr	-450(ra) # 80001ff0 <argint>
  if(n < 0)
    800021ba:	fcc42783          	lw	a5,-52(s0)
    800021be:	0807c363          	bltz	a5,80002244 <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    800021c2:	0000d517          	auipc	a0,0xd
    800021c6:	f7e50513          	addi	a0,a0,-130 # 8000f140 <tickslock>
    800021ca:	00004097          	auipc	ra,0x4
    800021ce:	0e4080e7          	jalr	228(ra) # 800062ae <acquire>
  ticks0 = ticks;
    800021d2:	00006917          	auipc	s2,0x6
    800021d6:	70692903          	lw	s2,1798(s2) # 800088d8 <ticks>
  while(ticks - ticks0 < n){
    800021da:	fcc42783          	lw	a5,-52(s0)
    800021de:	cf9d                	beqz	a5,8000221c <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e0:	0000d997          	auipc	s3,0xd
    800021e4:	f6098993          	addi	s3,s3,-160 # 8000f140 <tickslock>
    800021e8:	00006497          	auipc	s1,0x6
    800021ec:	6f048493          	addi	s1,s1,1776 # 800088d8 <ticks>
    if(killed(myproc())){
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	c68080e7          	jalr	-920(ra) # 80000e58 <myproc>
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	5ec080e7          	jalr	1516(ra) # 800017e4 <killed>
    80002200:	e529                	bnez	a0,8000224a <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    80002202:	85ce                	mv	a1,s3
    80002204:	8526                	mv	a0,s1
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	336080e7          	jalr	822(ra) # 8000153c <sleep>
  while(ticks - ticks0 < n){
    8000220e:	409c                	lw	a5,0(s1)
    80002210:	412787bb          	subw	a5,a5,s2
    80002214:	fcc42703          	lw	a4,-52(s0)
    80002218:	fce7ece3          	bltu	a5,a4,800021f0 <sys_sleep+0x52>
  }
  backtrace(); // solution: insert a call
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	b18080e7          	jalr	-1256(ra) # 80005d34 <backtrace>
  release(&tickslock);
    80002224:	0000d517          	auipc	a0,0xd
    80002228:	f1c50513          	addi	a0,a0,-228 # 8000f140 <tickslock>
    8000222c:	00004097          	auipc	ra,0x4
    80002230:	136080e7          	jalr	310(ra) # 80006362 <release>
  return 0;
    80002234:	4501                	li	a0,0
}
    80002236:	70e2                	ld	ra,56(sp)
    80002238:	7442                	ld	s0,48(sp)
    8000223a:	74a2                	ld	s1,40(sp)
    8000223c:	7902                	ld	s2,32(sp)
    8000223e:	69e2                	ld	s3,24(sp)
    80002240:	6121                	addi	sp,sp,64
    80002242:	8082                	ret
    n = 0;
    80002244:	fc042623          	sw	zero,-52(s0)
    80002248:	bfad                	j	800021c2 <sys_sleep+0x24>
      release(&tickslock);
    8000224a:	0000d517          	auipc	a0,0xd
    8000224e:	ef650513          	addi	a0,a0,-266 # 8000f140 <tickslock>
    80002252:	00004097          	auipc	ra,0x4
    80002256:	110080e7          	jalr	272(ra) # 80006362 <release>
      return -1;
    8000225a:	557d                	li	a0,-1
    8000225c:	bfe9                	j	80002236 <sys_sleep+0x98>

000000008000225e <sys_kill>:

uint64
sys_kill(void)
{
    8000225e:	1101                	addi	sp,sp,-32
    80002260:	ec06                	sd	ra,24(sp)
    80002262:	e822                	sd	s0,16(sp)
    80002264:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002266:	fec40593          	addi	a1,s0,-20
    8000226a:	4501                	li	a0,0
    8000226c:	00000097          	auipc	ra,0x0
    80002270:	d84080e7          	jalr	-636(ra) # 80001ff0 <argint>
  return kill(pid);
    80002274:	fec42503          	lw	a0,-20(s0)
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	4ce080e7          	jalr	1230(ra) # 80001746 <kill>
}
    80002280:	60e2                	ld	ra,24(sp)
    80002282:	6442                	ld	s0,16(sp)
    80002284:	6105                	addi	sp,sp,32
    80002286:	8082                	ret

0000000080002288 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002288:	1101                	addi	sp,sp,-32
    8000228a:	ec06                	sd	ra,24(sp)
    8000228c:	e822                	sd	s0,16(sp)
    8000228e:	e426                	sd	s1,8(sp)
    80002290:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002292:	0000d517          	auipc	a0,0xd
    80002296:	eae50513          	addi	a0,a0,-338 # 8000f140 <tickslock>
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	014080e7          	jalr	20(ra) # 800062ae <acquire>
  xticks = ticks;
    800022a2:	00006497          	auipc	s1,0x6
    800022a6:	6364a483          	lw	s1,1590(s1) # 800088d8 <ticks>
  release(&tickslock);
    800022aa:	0000d517          	auipc	a0,0xd
    800022ae:	e9650513          	addi	a0,a0,-362 # 8000f140 <tickslock>
    800022b2:	00004097          	auipc	ra,0x4
    800022b6:	0b0080e7          	jalr	176(ra) # 80006362 <release>
  return xticks;
}
    800022ba:	02049513          	slli	a0,s1,0x20
    800022be:	9101                	srli	a0,a0,0x20
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	64a2                	ld	s1,8(sp)
    800022c6:	6105                	addi	sp,sp,32
    800022c8:	8082                	ret

00000000800022ca <sys_sigalarm>:

// solution: sys_sigalarm & sys_sigreturn

uint64
sys_sigalarm(void)
{
    800022ca:	1101                	addi	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	1000                	addi	s0,sp,32
  // should store the alarm interval and the pointer
  // to the handler function in the proc structure
  uint64 fn = 0;
    800022d2:	fe043423          	sd	zero,-24(s0)
  int interval = 0;
    800022d6:	fe042223          	sw	zero,-28(s0)

  argint(0, &interval);
    800022da:	fe440593          	addi	a1,s0,-28
    800022de:	4501                	li	a0,0
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	d10080e7          	jalr	-752(ra) # 80001ff0 <argint>
  argaddr(1, &fn);
    800022e8:	fe840593          	addi	a1,s0,-24
    800022ec:	4505                	li	a0,1
    800022ee:	00000097          	auipc	ra,0x0
    800022f2:	d22080e7          	jalr	-734(ra) # 80002010 <argaddr>

  struct proc* p = myproc();
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	b62080e7          	jalr	-1182(ra) # 80000e58 <myproc>

  p->passed_ticks = 0;
    800022fe:	16052c23          	sw	zero,376(a0)
  p->interval = interval;
    80002302:	fe442783          	lw	a5,-28(s0)
    80002306:	16f52423          	sw	a5,360(a0)
  p->handler = fn;
    8000230a:	fe843783          	ld	a5,-24(s0)
    8000230e:	16f53823          	sd	a5,368(a0)

  return 0;
}
    80002312:	4501                	li	a0,0
    80002314:	60e2                	ld	ra,24(sp)
    80002316:	6442                	ld	s0,16(sp)
    80002318:	6105                	addi	sp,sp,32
    8000231a:	8082                	ret

000000008000231c <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    8000231c:	1101                	addi	sp,sp,-32
    8000231e:	ec06                	sd	ra,24(sp)
    80002320:	e822                	sd	s0,16(sp)
    80002322:	e426                	sd	s1,8(sp)
    80002324:	1000                	addi	s0,sp,32
  struct proc* p = myproc();
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	b32080e7          	jalr	-1230(ra) # 80000e58 <myproc>
    8000232e:	84aa                	mv	s1,a0
  p->ret_flag = 1;
    80002330:	4785                	li	a5,1
    80002332:	18f52423          	sw	a5,392(a0)
  memmove(p->trapframe, p->trapframe_backup, sizeof(struct trapframe));
    80002336:	12000613          	li	a2,288
    8000233a:	18053583          	ld	a1,384(a0)
    8000233e:	6d28                	ld	a0,88(a0)
    80002340:	ffffe097          	auipc	ra,0xffffe
    80002344:	e98080e7          	jalr	-360(ra) # 800001d8 <memmove>
  return p->trapframe->a0;
    80002348:	6cbc                	ld	a5,88(s1)
    8000234a:	7ba8                	ld	a0,112(a5)
    8000234c:	60e2                	ld	ra,24(sp)
    8000234e:	6442                	ld	s0,16(sp)
    80002350:	64a2                	ld	s1,8(sp)
    80002352:	6105                	addi	sp,sp,32
    80002354:	8082                	ret

0000000080002356 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002356:	7179                	addi	sp,sp,-48
    80002358:	f406                	sd	ra,40(sp)
    8000235a:	f022                	sd	s0,32(sp)
    8000235c:	ec26                	sd	s1,24(sp)
    8000235e:	e84a                	sd	s2,16(sp)
    80002360:	e44e                	sd	s3,8(sp)
    80002362:	e052                	sd	s4,0(sp)
    80002364:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002366:	00006597          	auipc	a1,0x6
    8000236a:	12a58593          	addi	a1,a1,298 # 80008490 <syscalls+0xc0>
    8000236e:	0000d517          	auipc	a0,0xd
    80002372:	dea50513          	addi	a0,a0,-534 # 8000f158 <bcache>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	ea8080e7          	jalr	-344(ra) # 8000621e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000237e:	00015797          	auipc	a5,0x15
    80002382:	dda78793          	addi	a5,a5,-550 # 80017158 <bcache+0x8000>
    80002386:	00015717          	auipc	a4,0x15
    8000238a:	03a70713          	addi	a4,a4,58 # 800173c0 <bcache+0x8268>
    8000238e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002392:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002396:	0000d497          	auipc	s1,0xd
    8000239a:	dda48493          	addi	s1,s1,-550 # 8000f170 <bcache+0x18>
    b->next = bcache.head.next;
    8000239e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a2:	00006a17          	auipc	s4,0x6
    800023a6:	0f6a0a13          	addi	s4,s4,246 # 80008498 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023aa:	2b893783          	ld	a5,696(s2)
    800023ae:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b4:	85d2                	mv	a1,s4
    800023b6:	01048513          	addi	a0,s1,16
    800023ba:	00001097          	auipc	ra,0x1
    800023be:	4c4080e7          	jalr	1220(ra) # 8000387e <initsleeplock>
    bcache.head.next->prev = b;
    800023c2:	2b893783          	ld	a5,696(s2)
    800023c6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023c8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023cc:	45848493          	addi	s1,s1,1112
    800023d0:	fd349de3          	bne	s1,s3,800023aa <binit+0x54>
  }
}
    800023d4:	70a2                	ld	ra,40(sp)
    800023d6:	7402                	ld	s0,32(sp)
    800023d8:	64e2                	ld	s1,24(sp)
    800023da:	6942                	ld	s2,16(sp)
    800023dc:	69a2                	ld	s3,8(sp)
    800023de:	6a02                	ld	s4,0(sp)
    800023e0:	6145                	addi	sp,sp,48
    800023e2:	8082                	ret

00000000800023e4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e4:	7179                	addi	sp,sp,-48
    800023e6:	f406                	sd	ra,40(sp)
    800023e8:	f022                	sd	s0,32(sp)
    800023ea:	ec26                	sd	s1,24(sp)
    800023ec:	e84a                	sd	s2,16(sp)
    800023ee:	e44e                	sd	s3,8(sp)
    800023f0:	1800                	addi	s0,sp,48
    800023f2:	89aa                	mv	s3,a0
    800023f4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023f6:	0000d517          	auipc	a0,0xd
    800023fa:	d6250513          	addi	a0,a0,-670 # 8000f158 <bcache>
    800023fe:	00004097          	auipc	ra,0x4
    80002402:	eb0080e7          	jalr	-336(ra) # 800062ae <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002406:	00015497          	auipc	s1,0x15
    8000240a:	00a4b483          	ld	s1,10(s1) # 80017410 <bcache+0x82b8>
    8000240e:	00015797          	auipc	a5,0x15
    80002412:	fb278793          	addi	a5,a5,-78 # 800173c0 <bcache+0x8268>
    80002416:	02f48f63          	beq	s1,a5,80002454 <bread+0x70>
    8000241a:	873e                	mv	a4,a5
    8000241c:	a021                	j	80002424 <bread+0x40>
    8000241e:	68a4                	ld	s1,80(s1)
    80002420:	02e48a63          	beq	s1,a4,80002454 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002424:	449c                	lw	a5,8(s1)
    80002426:	ff379ce3          	bne	a5,s3,8000241e <bread+0x3a>
    8000242a:	44dc                	lw	a5,12(s1)
    8000242c:	ff2799e3          	bne	a5,s2,8000241e <bread+0x3a>
      b->refcnt++;
    80002430:	40bc                	lw	a5,64(s1)
    80002432:	2785                	addiw	a5,a5,1
    80002434:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002436:	0000d517          	auipc	a0,0xd
    8000243a:	d2250513          	addi	a0,a0,-734 # 8000f158 <bcache>
    8000243e:	00004097          	auipc	ra,0x4
    80002442:	f24080e7          	jalr	-220(ra) # 80006362 <release>
      acquiresleep(&b->lock);
    80002446:	01048513          	addi	a0,s1,16
    8000244a:	00001097          	auipc	ra,0x1
    8000244e:	46e080e7          	jalr	1134(ra) # 800038b8 <acquiresleep>
      return b;
    80002452:	a8b9                	j	800024b0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002454:	00015497          	auipc	s1,0x15
    80002458:	fb44b483          	ld	s1,-76(s1) # 80017408 <bcache+0x82b0>
    8000245c:	00015797          	auipc	a5,0x15
    80002460:	f6478793          	addi	a5,a5,-156 # 800173c0 <bcache+0x8268>
    80002464:	00f48863          	beq	s1,a5,80002474 <bread+0x90>
    80002468:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000246a:	40bc                	lw	a5,64(s1)
    8000246c:	cf81                	beqz	a5,80002484 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246e:	64a4                	ld	s1,72(s1)
    80002470:	fee49de3          	bne	s1,a4,8000246a <bread+0x86>
  panic("bget: no buffers");
    80002474:	00006517          	auipc	a0,0x6
    80002478:	02c50513          	addi	a0,a0,44 # 800084a0 <syscalls+0xd0>
    8000247c:	00004097          	auipc	ra,0x4
    80002480:	912080e7          	jalr	-1774(ra) # 80005d8e <panic>
      b->dev = dev;
    80002484:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002488:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000248c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002490:	4785                	li	a5,1
    80002492:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002494:	0000d517          	auipc	a0,0xd
    80002498:	cc450513          	addi	a0,a0,-828 # 8000f158 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	ec6080e7          	jalr	-314(ra) # 80006362 <release>
      acquiresleep(&b->lock);
    800024a4:	01048513          	addi	a0,s1,16
    800024a8:	00001097          	auipc	ra,0x1
    800024ac:	410080e7          	jalr	1040(ra) # 800038b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b0:	409c                	lw	a5,0(s1)
    800024b2:	cb89                	beqz	a5,800024c4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b4:	8526                	mv	a0,s1
    800024b6:	70a2                	ld	ra,40(sp)
    800024b8:	7402                	ld	s0,32(sp)
    800024ba:	64e2                	ld	s1,24(sp)
    800024bc:	6942                	ld	s2,16(sp)
    800024be:	69a2                	ld	s3,8(sp)
    800024c0:	6145                	addi	sp,sp,48
    800024c2:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c4:	4581                	li	a1,0
    800024c6:	8526                	mv	a0,s1
    800024c8:	00003097          	auipc	ra,0x3
    800024cc:	fd0080e7          	jalr	-48(ra) # 80005498 <virtio_disk_rw>
    b->valid = 1;
    800024d0:	4785                	li	a5,1
    800024d2:	c09c                	sw	a5,0(s1)
  return b;
    800024d4:	b7c5                	j	800024b4 <bread+0xd0>

00000000800024d6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d6:	1101                	addi	sp,sp,-32
    800024d8:	ec06                	sd	ra,24(sp)
    800024da:	e822                	sd	s0,16(sp)
    800024dc:	e426                	sd	s1,8(sp)
    800024de:	1000                	addi	s0,sp,32
    800024e0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e2:	0541                	addi	a0,a0,16
    800024e4:	00001097          	auipc	ra,0x1
    800024e8:	46e080e7          	jalr	1134(ra) # 80003952 <holdingsleep>
    800024ec:	cd01                	beqz	a0,80002504 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ee:	4585                	li	a1,1
    800024f0:	8526                	mv	a0,s1
    800024f2:	00003097          	auipc	ra,0x3
    800024f6:	fa6080e7          	jalr	-90(ra) # 80005498 <virtio_disk_rw>
}
    800024fa:	60e2                	ld	ra,24(sp)
    800024fc:	6442                	ld	s0,16(sp)
    800024fe:	64a2                	ld	s1,8(sp)
    80002500:	6105                	addi	sp,sp,32
    80002502:	8082                	ret
    panic("bwrite");
    80002504:	00006517          	auipc	a0,0x6
    80002508:	fb450513          	addi	a0,a0,-76 # 800084b8 <syscalls+0xe8>
    8000250c:	00004097          	auipc	ra,0x4
    80002510:	882080e7          	jalr	-1918(ra) # 80005d8e <panic>

0000000080002514 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002514:	1101                	addi	sp,sp,-32
    80002516:	ec06                	sd	ra,24(sp)
    80002518:	e822                	sd	s0,16(sp)
    8000251a:	e426                	sd	s1,8(sp)
    8000251c:	e04a                	sd	s2,0(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002522:	01050913          	addi	s2,a0,16
    80002526:	854a                	mv	a0,s2
    80002528:	00001097          	auipc	ra,0x1
    8000252c:	42a080e7          	jalr	1066(ra) # 80003952 <holdingsleep>
    80002530:	c92d                	beqz	a0,800025a2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002532:	854a                	mv	a0,s2
    80002534:	00001097          	auipc	ra,0x1
    80002538:	3da080e7          	jalr	986(ra) # 8000390e <releasesleep>

  acquire(&bcache.lock);
    8000253c:	0000d517          	auipc	a0,0xd
    80002540:	c1c50513          	addi	a0,a0,-996 # 8000f158 <bcache>
    80002544:	00004097          	auipc	ra,0x4
    80002548:	d6a080e7          	jalr	-662(ra) # 800062ae <acquire>
  b->refcnt--;
    8000254c:	40bc                	lw	a5,64(s1)
    8000254e:	37fd                	addiw	a5,a5,-1
    80002550:	0007871b          	sext.w	a4,a5
    80002554:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002556:	eb05                	bnez	a4,80002586 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002558:	68bc                	ld	a5,80(s1)
    8000255a:	64b8                	ld	a4,72(s1)
    8000255c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000255e:	64bc                	ld	a5,72(s1)
    80002560:	68b8                	ld	a4,80(s1)
    80002562:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002564:	00015797          	auipc	a5,0x15
    80002568:	bf478793          	addi	a5,a5,-1036 # 80017158 <bcache+0x8000>
    8000256c:	2b87b703          	ld	a4,696(a5)
    80002570:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002572:	00015717          	auipc	a4,0x15
    80002576:	e4e70713          	addi	a4,a4,-434 # 800173c0 <bcache+0x8268>
    8000257a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000257c:	2b87b703          	ld	a4,696(a5)
    80002580:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002582:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002586:	0000d517          	auipc	a0,0xd
    8000258a:	bd250513          	addi	a0,a0,-1070 # 8000f158 <bcache>
    8000258e:	00004097          	auipc	ra,0x4
    80002592:	dd4080e7          	jalr	-556(ra) # 80006362 <release>
}
    80002596:	60e2                	ld	ra,24(sp)
    80002598:	6442                	ld	s0,16(sp)
    8000259a:	64a2                	ld	s1,8(sp)
    8000259c:	6902                	ld	s2,0(sp)
    8000259e:	6105                	addi	sp,sp,32
    800025a0:	8082                	ret
    panic("brelse");
    800025a2:	00006517          	auipc	a0,0x6
    800025a6:	f1e50513          	addi	a0,a0,-226 # 800084c0 <syscalls+0xf0>
    800025aa:	00003097          	auipc	ra,0x3
    800025ae:	7e4080e7          	jalr	2020(ra) # 80005d8e <panic>

00000000800025b2 <bpin>:

void
bpin(struct buf *b) {
    800025b2:	1101                	addi	sp,sp,-32
    800025b4:	ec06                	sd	ra,24(sp)
    800025b6:	e822                	sd	s0,16(sp)
    800025b8:	e426                	sd	s1,8(sp)
    800025ba:	1000                	addi	s0,sp,32
    800025bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025be:	0000d517          	auipc	a0,0xd
    800025c2:	b9a50513          	addi	a0,a0,-1126 # 8000f158 <bcache>
    800025c6:	00004097          	auipc	ra,0x4
    800025ca:	ce8080e7          	jalr	-792(ra) # 800062ae <acquire>
  b->refcnt++;
    800025ce:	40bc                	lw	a5,64(s1)
    800025d0:	2785                	addiw	a5,a5,1
    800025d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d4:	0000d517          	auipc	a0,0xd
    800025d8:	b8450513          	addi	a0,a0,-1148 # 8000f158 <bcache>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	d86080e7          	jalr	-634(ra) # 80006362 <release>
}
    800025e4:	60e2                	ld	ra,24(sp)
    800025e6:	6442                	ld	s0,16(sp)
    800025e8:	64a2                	ld	s1,8(sp)
    800025ea:	6105                	addi	sp,sp,32
    800025ec:	8082                	ret

00000000800025ee <bunpin>:

void
bunpin(struct buf *b) {
    800025ee:	1101                	addi	sp,sp,-32
    800025f0:	ec06                	sd	ra,24(sp)
    800025f2:	e822                	sd	s0,16(sp)
    800025f4:	e426                	sd	s1,8(sp)
    800025f6:	1000                	addi	s0,sp,32
    800025f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fa:	0000d517          	auipc	a0,0xd
    800025fe:	b5e50513          	addi	a0,a0,-1186 # 8000f158 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	cac080e7          	jalr	-852(ra) # 800062ae <acquire>
  b->refcnt--;
    8000260a:	40bc                	lw	a5,64(s1)
    8000260c:	37fd                	addiw	a5,a5,-1
    8000260e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002610:	0000d517          	auipc	a0,0xd
    80002614:	b4850513          	addi	a0,a0,-1208 # 8000f158 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	d4a080e7          	jalr	-694(ra) # 80006362 <release>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret

000000008000262a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000262a:	1101                	addi	sp,sp,-32
    8000262c:	ec06                	sd	ra,24(sp)
    8000262e:	e822                	sd	s0,16(sp)
    80002630:	e426                	sd	s1,8(sp)
    80002632:	e04a                	sd	s2,0(sp)
    80002634:	1000                	addi	s0,sp,32
    80002636:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002638:	00d5d59b          	srliw	a1,a1,0xd
    8000263c:	00015797          	auipc	a5,0x15
    80002640:	1f87a783          	lw	a5,504(a5) # 80017834 <sb+0x1c>
    80002644:	9dbd                	addw	a1,a1,a5
    80002646:	00000097          	auipc	ra,0x0
    8000264a:	d9e080e7          	jalr	-610(ra) # 800023e4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000264e:	0074f713          	andi	a4,s1,7
    80002652:	4785                	li	a5,1
    80002654:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002658:	14ce                	slli	s1,s1,0x33
    8000265a:	90d9                	srli	s1,s1,0x36
    8000265c:	00950733          	add	a4,a0,s1
    80002660:	05874703          	lbu	a4,88(a4)
    80002664:	00e7f6b3          	and	a3,a5,a4
    80002668:	c69d                	beqz	a3,80002696 <bfree+0x6c>
    8000266a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000266c:	94aa                	add	s1,s1,a0
    8000266e:	fff7c793          	not	a5,a5
    80002672:	8ff9                	and	a5,a5,a4
    80002674:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002678:	00001097          	auipc	ra,0x1
    8000267c:	120080e7          	jalr	288(ra) # 80003798 <log_write>
  brelse(bp);
    80002680:	854a                	mv	a0,s2
    80002682:	00000097          	auipc	ra,0x0
    80002686:	e92080e7          	jalr	-366(ra) # 80002514 <brelse>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6902                	ld	s2,0(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret
    panic("freeing free block");
    80002696:	00006517          	auipc	a0,0x6
    8000269a:	e3250513          	addi	a0,a0,-462 # 800084c8 <syscalls+0xf8>
    8000269e:	00003097          	auipc	ra,0x3
    800026a2:	6f0080e7          	jalr	1776(ra) # 80005d8e <panic>

00000000800026a6 <balloc>:
{
    800026a6:	711d                	addi	sp,sp,-96
    800026a8:	ec86                	sd	ra,88(sp)
    800026aa:	e8a2                	sd	s0,80(sp)
    800026ac:	e4a6                	sd	s1,72(sp)
    800026ae:	e0ca                	sd	s2,64(sp)
    800026b0:	fc4e                	sd	s3,56(sp)
    800026b2:	f852                	sd	s4,48(sp)
    800026b4:	f456                	sd	s5,40(sp)
    800026b6:	f05a                	sd	s6,32(sp)
    800026b8:	ec5e                	sd	s7,24(sp)
    800026ba:	e862                	sd	s8,16(sp)
    800026bc:	e466                	sd	s9,8(sp)
    800026be:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026c0:	00015797          	auipc	a5,0x15
    800026c4:	15c7a783          	lw	a5,348(a5) # 8001781c <sb+0x4>
    800026c8:	10078163          	beqz	a5,800027ca <balloc+0x124>
    800026cc:	8baa                	mv	s7,a0
    800026ce:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026d0:	00015b17          	auipc	s6,0x15
    800026d4:	148b0b13          	addi	s6,s6,328 # 80017818 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026da:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026dc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026de:	6c89                	lui	s9,0x2
    800026e0:	a061                	j	80002768 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026e2:	974a                	add	a4,a4,s2
    800026e4:	8fd5                	or	a5,a5,a3
    800026e6:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026ea:	854a                	mv	a0,s2
    800026ec:	00001097          	auipc	ra,0x1
    800026f0:	0ac080e7          	jalr	172(ra) # 80003798 <log_write>
        brelse(bp);
    800026f4:	854a                	mv	a0,s2
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	e1e080e7          	jalr	-482(ra) # 80002514 <brelse>
  bp = bread(dev, bno);
    800026fe:	85a6                	mv	a1,s1
    80002700:	855e                	mv	a0,s7
    80002702:	00000097          	auipc	ra,0x0
    80002706:	ce2080e7          	jalr	-798(ra) # 800023e4 <bread>
    8000270a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000270c:	40000613          	li	a2,1024
    80002710:	4581                	li	a1,0
    80002712:	05850513          	addi	a0,a0,88
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	a62080e7          	jalr	-1438(ra) # 80000178 <memset>
  log_write(bp);
    8000271e:	854a                	mv	a0,s2
    80002720:	00001097          	auipc	ra,0x1
    80002724:	078080e7          	jalr	120(ra) # 80003798 <log_write>
  brelse(bp);
    80002728:	854a                	mv	a0,s2
    8000272a:	00000097          	auipc	ra,0x0
    8000272e:	dea080e7          	jalr	-534(ra) # 80002514 <brelse>
}
    80002732:	8526                	mv	a0,s1
    80002734:	60e6                	ld	ra,88(sp)
    80002736:	6446                	ld	s0,80(sp)
    80002738:	64a6                	ld	s1,72(sp)
    8000273a:	6906                	ld	s2,64(sp)
    8000273c:	79e2                	ld	s3,56(sp)
    8000273e:	7a42                	ld	s4,48(sp)
    80002740:	7aa2                	ld	s5,40(sp)
    80002742:	7b02                	ld	s6,32(sp)
    80002744:	6be2                	ld	s7,24(sp)
    80002746:	6c42                	ld	s8,16(sp)
    80002748:	6ca2                	ld	s9,8(sp)
    8000274a:	6125                	addi	sp,sp,96
    8000274c:	8082                	ret
    brelse(bp);
    8000274e:	854a                	mv	a0,s2
    80002750:	00000097          	auipc	ra,0x0
    80002754:	dc4080e7          	jalr	-572(ra) # 80002514 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002758:	015c87bb          	addw	a5,s9,s5
    8000275c:	00078a9b          	sext.w	s5,a5
    80002760:	004b2703          	lw	a4,4(s6)
    80002764:	06eaf363          	bgeu	s5,a4,800027ca <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002768:	41fad79b          	sraiw	a5,s5,0x1f
    8000276c:	0137d79b          	srliw	a5,a5,0x13
    80002770:	015787bb          	addw	a5,a5,s5
    80002774:	40d7d79b          	sraiw	a5,a5,0xd
    80002778:	01cb2583          	lw	a1,28(s6)
    8000277c:	9dbd                	addw	a1,a1,a5
    8000277e:	855e                	mv	a0,s7
    80002780:	00000097          	auipc	ra,0x0
    80002784:	c64080e7          	jalr	-924(ra) # 800023e4 <bread>
    80002788:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000278a:	004b2503          	lw	a0,4(s6)
    8000278e:	000a849b          	sext.w	s1,s5
    80002792:	8662                	mv	a2,s8
    80002794:	faa4fde3          	bgeu	s1,a0,8000274e <balloc+0xa8>
      m = 1 << (bi % 8);
    80002798:	41f6579b          	sraiw	a5,a2,0x1f
    8000279c:	01d7d69b          	srliw	a3,a5,0x1d
    800027a0:	00c6873b          	addw	a4,a3,a2
    800027a4:	00777793          	andi	a5,a4,7
    800027a8:	9f95                	subw	a5,a5,a3
    800027aa:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027ae:	4037571b          	sraiw	a4,a4,0x3
    800027b2:	00e906b3          	add	a3,s2,a4
    800027b6:	0586c683          	lbu	a3,88(a3)
    800027ba:	00d7f5b3          	and	a1,a5,a3
    800027be:	d195                	beqz	a1,800026e2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c0:	2605                	addiw	a2,a2,1
    800027c2:	2485                	addiw	s1,s1,1
    800027c4:	fd4618e3          	bne	a2,s4,80002794 <balloc+0xee>
    800027c8:	b759                	j	8000274e <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800027ca:	00006517          	auipc	a0,0x6
    800027ce:	d1650513          	addi	a0,a0,-746 # 800084e0 <syscalls+0x110>
    800027d2:	00003097          	auipc	ra,0x3
    800027d6:	60e080e7          	jalr	1550(ra) # 80005de0 <printf>
  return 0;
    800027da:	4481                	li	s1,0
    800027dc:	bf99                	j	80002732 <balloc+0x8c>

00000000800027de <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027de:	7179                	addi	sp,sp,-48
    800027e0:	f406                	sd	ra,40(sp)
    800027e2:	f022                	sd	s0,32(sp)
    800027e4:	ec26                	sd	s1,24(sp)
    800027e6:	e84a                	sd	s2,16(sp)
    800027e8:	e44e                	sd	s3,8(sp)
    800027ea:	e052                	sd	s4,0(sp)
    800027ec:	1800                	addi	s0,sp,48
    800027ee:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027f0:	47ad                	li	a5,11
    800027f2:	02b7e763          	bltu	a5,a1,80002820 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027f6:	02059493          	slli	s1,a1,0x20
    800027fa:	9081                	srli	s1,s1,0x20
    800027fc:	048a                	slli	s1,s1,0x2
    800027fe:	94aa                	add	s1,s1,a0
    80002800:	0504a903          	lw	s2,80(s1)
    80002804:	06091e63          	bnez	s2,80002880 <bmap+0xa2>
      addr = balloc(ip->dev);
    80002808:	4108                	lw	a0,0(a0)
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	e9c080e7          	jalr	-356(ra) # 800026a6 <balloc>
    80002812:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002816:	06090563          	beqz	s2,80002880 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    8000281a:	0524a823          	sw	s2,80(s1)
    8000281e:	a08d                	j	80002880 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002820:	ff45849b          	addiw	s1,a1,-12
    80002824:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002828:	0ff00793          	li	a5,255
    8000282c:	08e7e563          	bltu	a5,a4,800028b6 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002830:	08052903          	lw	s2,128(a0)
    80002834:	00091d63          	bnez	s2,8000284e <bmap+0x70>
      addr = balloc(ip->dev);
    80002838:	4108                	lw	a0,0(a0)
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	e6c080e7          	jalr	-404(ra) # 800026a6 <balloc>
    80002842:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002846:	02090d63          	beqz	s2,80002880 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000284a:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000284e:	85ca                	mv	a1,s2
    80002850:	0009a503          	lw	a0,0(s3)
    80002854:	00000097          	auipc	ra,0x0
    80002858:	b90080e7          	jalr	-1136(ra) # 800023e4 <bread>
    8000285c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000285e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002862:	02049593          	slli	a1,s1,0x20
    80002866:	9181                	srli	a1,a1,0x20
    80002868:	058a                	slli	a1,a1,0x2
    8000286a:	00b784b3          	add	s1,a5,a1
    8000286e:	0004a903          	lw	s2,0(s1)
    80002872:	02090063          	beqz	s2,80002892 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002876:	8552                	mv	a0,s4
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	c9c080e7          	jalr	-868(ra) # 80002514 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002880:	854a                	mv	a0,s2
    80002882:	70a2                	ld	ra,40(sp)
    80002884:	7402                	ld	s0,32(sp)
    80002886:	64e2                	ld	s1,24(sp)
    80002888:	6942                	ld	s2,16(sp)
    8000288a:	69a2                	ld	s3,8(sp)
    8000288c:	6a02                	ld	s4,0(sp)
    8000288e:	6145                	addi	sp,sp,48
    80002890:	8082                	ret
      addr = balloc(ip->dev);
    80002892:	0009a503          	lw	a0,0(s3)
    80002896:	00000097          	auipc	ra,0x0
    8000289a:	e10080e7          	jalr	-496(ra) # 800026a6 <balloc>
    8000289e:	0005091b          	sext.w	s2,a0
      if(addr){
    800028a2:	fc090ae3          	beqz	s2,80002876 <bmap+0x98>
        a[bn] = addr;
    800028a6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028aa:	8552                	mv	a0,s4
    800028ac:	00001097          	auipc	ra,0x1
    800028b0:	eec080e7          	jalr	-276(ra) # 80003798 <log_write>
    800028b4:	b7c9                	j	80002876 <bmap+0x98>
  panic("bmap: out of range");
    800028b6:	00006517          	auipc	a0,0x6
    800028ba:	c4250513          	addi	a0,a0,-958 # 800084f8 <syscalls+0x128>
    800028be:	00003097          	auipc	ra,0x3
    800028c2:	4d0080e7          	jalr	1232(ra) # 80005d8e <panic>

00000000800028c6 <iget>:
{
    800028c6:	7179                	addi	sp,sp,-48
    800028c8:	f406                	sd	ra,40(sp)
    800028ca:	f022                	sd	s0,32(sp)
    800028cc:	ec26                	sd	s1,24(sp)
    800028ce:	e84a                	sd	s2,16(sp)
    800028d0:	e44e                	sd	s3,8(sp)
    800028d2:	e052                	sd	s4,0(sp)
    800028d4:	1800                	addi	s0,sp,48
    800028d6:	89aa                	mv	s3,a0
    800028d8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028da:	00015517          	auipc	a0,0x15
    800028de:	f5e50513          	addi	a0,a0,-162 # 80017838 <itable>
    800028e2:	00004097          	auipc	ra,0x4
    800028e6:	9cc080e7          	jalr	-1588(ra) # 800062ae <acquire>
  empty = 0;
    800028ea:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ec:	00015497          	auipc	s1,0x15
    800028f0:	f6448493          	addi	s1,s1,-156 # 80017850 <itable+0x18>
    800028f4:	00017697          	auipc	a3,0x17
    800028f8:	9ec68693          	addi	a3,a3,-1556 # 800192e0 <log>
    800028fc:	a039                	j	8000290a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fe:	02090b63          	beqz	s2,80002934 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002902:	08848493          	addi	s1,s1,136
    80002906:	02d48a63          	beq	s1,a3,8000293a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000290a:	449c                	lw	a5,8(s1)
    8000290c:	fef059e3          	blez	a5,800028fe <iget+0x38>
    80002910:	4098                	lw	a4,0(s1)
    80002912:	ff3716e3          	bne	a4,s3,800028fe <iget+0x38>
    80002916:	40d8                	lw	a4,4(s1)
    80002918:	ff4713e3          	bne	a4,s4,800028fe <iget+0x38>
      ip->ref++;
    8000291c:	2785                	addiw	a5,a5,1
    8000291e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002920:	00015517          	auipc	a0,0x15
    80002924:	f1850513          	addi	a0,a0,-232 # 80017838 <itable>
    80002928:	00004097          	auipc	ra,0x4
    8000292c:	a3a080e7          	jalr	-1478(ra) # 80006362 <release>
      return ip;
    80002930:	8926                	mv	s2,s1
    80002932:	a03d                	j	80002960 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002934:	f7f9                	bnez	a5,80002902 <iget+0x3c>
    80002936:	8926                	mv	s2,s1
    80002938:	b7e9                	j	80002902 <iget+0x3c>
  if(empty == 0)
    8000293a:	02090c63          	beqz	s2,80002972 <iget+0xac>
  ip->dev = dev;
    8000293e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002942:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002946:	4785                	li	a5,1
    80002948:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000294c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002950:	00015517          	auipc	a0,0x15
    80002954:	ee850513          	addi	a0,a0,-280 # 80017838 <itable>
    80002958:	00004097          	auipc	ra,0x4
    8000295c:	a0a080e7          	jalr	-1526(ra) # 80006362 <release>
}
    80002960:	854a                	mv	a0,s2
    80002962:	70a2                	ld	ra,40(sp)
    80002964:	7402                	ld	s0,32(sp)
    80002966:	64e2                	ld	s1,24(sp)
    80002968:	6942                	ld	s2,16(sp)
    8000296a:	69a2                	ld	s3,8(sp)
    8000296c:	6a02                	ld	s4,0(sp)
    8000296e:	6145                	addi	sp,sp,48
    80002970:	8082                	ret
    panic("iget: no inodes");
    80002972:	00006517          	auipc	a0,0x6
    80002976:	b9e50513          	addi	a0,a0,-1122 # 80008510 <syscalls+0x140>
    8000297a:	00003097          	auipc	ra,0x3
    8000297e:	414080e7          	jalr	1044(ra) # 80005d8e <panic>

0000000080002982 <fsinit>:
fsinit(int dev) {
    80002982:	7179                	addi	sp,sp,-48
    80002984:	f406                	sd	ra,40(sp)
    80002986:	f022                	sd	s0,32(sp)
    80002988:	ec26                	sd	s1,24(sp)
    8000298a:	e84a                	sd	s2,16(sp)
    8000298c:	e44e                	sd	s3,8(sp)
    8000298e:	1800                	addi	s0,sp,48
    80002990:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002992:	4585                	li	a1,1
    80002994:	00000097          	auipc	ra,0x0
    80002998:	a50080e7          	jalr	-1456(ra) # 800023e4 <bread>
    8000299c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000299e:	00015997          	auipc	s3,0x15
    800029a2:	e7a98993          	addi	s3,s3,-390 # 80017818 <sb>
    800029a6:	02000613          	li	a2,32
    800029aa:	05850593          	addi	a1,a0,88
    800029ae:	854e                	mv	a0,s3
    800029b0:	ffffe097          	auipc	ra,0xffffe
    800029b4:	828080e7          	jalr	-2008(ra) # 800001d8 <memmove>
  brelse(bp);
    800029b8:	8526                	mv	a0,s1
    800029ba:	00000097          	auipc	ra,0x0
    800029be:	b5a080e7          	jalr	-1190(ra) # 80002514 <brelse>
  if(sb.magic != FSMAGIC)
    800029c2:	0009a703          	lw	a4,0(s3)
    800029c6:	102037b7          	lui	a5,0x10203
    800029ca:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ce:	02f71263          	bne	a4,a5,800029f2 <fsinit+0x70>
  initlog(dev, &sb);
    800029d2:	00015597          	auipc	a1,0x15
    800029d6:	e4658593          	addi	a1,a1,-442 # 80017818 <sb>
    800029da:	854a                	mv	a0,s2
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	b40080e7          	jalr	-1216(ra) # 8000351c <initlog>
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6145                	addi	sp,sp,48
    800029f0:	8082                	ret
    panic("invalid file system");
    800029f2:	00006517          	auipc	a0,0x6
    800029f6:	b2e50513          	addi	a0,a0,-1234 # 80008520 <syscalls+0x150>
    800029fa:	00003097          	auipc	ra,0x3
    800029fe:	394080e7          	jalr	916(ra) # 80005d8e <panic>

0000000080002a02 <iinit>:
{
    80002a02:	7179                	addi	sp,sp,-48
    80002a04:	f406                	sd	ra,40(sp)
    80002a06:	f022                	sd	s0,32(sp)
    80002a08:	ec26                	sd	s1,24(sp)
    80002a0a:	e84a                	sd	s2,16(sp)
    80002a0c:	e44e                	sd	s3,8(sp)
    80002a0e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a10:	00006597          	auipc	a1,0x6
    80002a14:	b2858593          	addi	a1,a1,-1240 # 80008538 <syscalls+0x168>
    80002a18:	00015517          	auipc	a0,0x15
    80002a1c:	e2050513          	addi	a0,a0,-480 # 80017838 <itable>
    80002a20:	00003097          	auipc	ra,0x3
    80002a24:	7fe080e7          	jalr	2046(ra) # 8000621e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a28:	00015497          	auipc	s1,0x15
    80002a2c:	e3848493          	addi	s1,s1,-456 # 80017860 <itable+0x28>
    80002a30:	00017997          	auipc	s3,0x17
    80002a34:	8c098993          	addi	s3,s3,-1856 # 800192f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a38:	00006917          	auipc	s2,0x6
    80002a3c:	b0890913          	addi	s2,s2,-1272 # 80008540 <syscalls+0x170>
    80002a40:	85ca                	mv	a1,s2
    80002a42:	8526                	mv	a0,s1
    80002a44:	00001097          	auipc	ra,0x1
    80002a48:	e3a080e7          	jalr	-454(ra) # 8000387e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a4c:	08848493          	addi	s1,s1,136
    80002a50:	ff3498e3          	bne	s1,s3,80002a40 <iinit+0x3e>
}
    80002a54:	70a2                	ld	ra,40(sp)
    80002a56:	7402                	ld	s0,32(sp)
    80002a58:	64e2                	ld	s1,24(sp)
    80002a5a:	6942                	ld	s2,16(sp)
    80002a5c:	69a2                	ld	s3,8(sp)
    80002a5e:	6145                	addi	sp,sp,48
    80002a60:	8082                	ret

0000000080002a62 <ialloc>:
{
    80002a62:	715d                	addi	sp,sp,-80
    80002a64:	e486                	sd	ra,72(sp)
    80002a66:	e0a2                	sd	s0,64(sp)
    80002a68:	fc26                	sd	s1,56(sp)
    80002a6a:	f84a                	sd	s2,48(sp)
    80002a6c:	f44e                	sd	s3,40(sp)
    80002a6e:	f052                	sd	s4,32(sp)
    80002a70:	ec56                	sd	s5,24(sp)
    80002a72:	e85a                	sd	s6,16(sp)
    80002a74:	e45e                	sd	s7,8(sp)
    80002a76:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a78:	00015717          	auipc	a4,0x15
    80002a7c:	dac72703          	lw	a4,-596(a4) # 80017824 <sb+0xc>
    80002a80:	4785                	li	a5,1
    80002a82:	04e7fa63          	bgeu	a5,a4,80002ad6 <ialloc+0x74>
    80002a86:	8aaa                	mv	s5,a0
    80002a88:	8bae                	mv	s7,a1
    80002a8a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a8c:	00015a17          	auipc	s4,0x15
    80002a90:	d8ca0a13          	addi	s4,s4,-628 # 80017818 <sb>
    80002a94:	00048b1b          	sext.w	s6,s1
    80002a98:	0044d593          	srli	a1,s1,0x4
    80002a9c:	018a2783          	lw	a5,24(s4)
    80002aa0:	9dbd                	addw	a1,a1,a5
    80002aa2:	8556                	mv	a0,s5
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	940080e7          	jalr	-1728(ra) # 800023e4 <bread>
    80002aac:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aae:	05850993          	addi	s3,a0,88
    80002ab2:	00f4f793          	andi	a5,s1,15
    80002ab6:	079a                	slli	a5,a5,0x6
    80002ab8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aba:	00099783          	lh	a5,0(s3)
    80002abe:	c3a1                	beqz	a5,80002afe <ialloc+0x9c>
    brelse(bp);
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	a54080e7          	jalr	-1452(ra) # 80002514 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac8:	0485                	addi	s1,s1,1
    80002aca:	00ca2703          	lw	a4,12(s4)
    80002ace:	0004879b          	sext.w	a5,s1
    80002ad2:	fce7e1e3          	bltu	a5,a4,80002a94 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002ad6:	00006517          	auipc	a0,0x6
    80002ada:	a7250513          	addi	a0,a0,-1422 # 80008548 <syscalls+0x178>
    80002ade:	00003097          	auipc	ra,0x3
    80002ae2:	302080e7          	jalr	770(ra) # 80005de0 <printf>
  return 0;
    80002ae6:	4501                	li	a0,0
}
    80002ae8:	60a6                	ld	ra,72(sp)
    80002aea:	6406                	ld	s0,64(sp)
    80002aec:	74e2                	ld	s1,56(sp)
    80002aee:	7942                	ld	s2,48(sp)
    80002af0:	79a2                	ld	s3,40(sp)
    80002af2:	7a02                	ld	s4,32(sp)
    80002af4:	6ae2                	ld	s5,24(sp)
    80002af6:	6b42                	ld	s6,16(sp)
    80002af8:	6ba2                	ld	s7,8(sp)
    80002afa:	6161                	addi	sp,sp,80
    80002afc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002afe:	04000613          	li	a2,64
    80002b02:	4581                	li	a1,0
    80002b04:	854e                	mv	a0,s3
    80002b06:	ffffd097          	auipc	ra,0xffffd
    80002b0a:	672080e7          	jalr	1650(ra) # 80000178 <memset>
      dip->type = type;
    80002b0e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b12:	854a                	mv	a0,s2
    80002b14:	00001097          	auipc	ra,0x1
    80002b18:	c84080e7          	jalr	-892(ra) # 80003798 <log_write>
      brelse(bp);
    80002b1c:	854a                	mv	a0,s2
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	9f6080e7          	jalr	-1546(ra) # 80002514 <brelse>
      return iget(dev, inum);
    80002b26:	85da                	mv	a1,s6
    80002b28:	8556                	mv	a0,s5
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	d9c080e7          	jalr	-612(ra) # 800028c6 <iget>
    80002b32:	bf5d                	j	80002ae8 <ialloc+0x86>

0000000080002b34 <iupdate>:
{
    80002b34:	1101                	addi	sp,sp,-32
    80002b36:	ec06                	sd	ra,24(sp)
    80002b38:	e822                	sd	s0,16(sp)
    80002b3a:	e426                	sd	s1,8(sp)
    80002b3c:	e04a                	sd	s2,0(sp)
    80002b3e:	1000                	addi	s0,sp,32
    80002b40:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b42:	415c                	lw	a5,4(a0)
    80002b44:	0047d79b          	srliw	a5,a5,0x4
    80002b48:	00015597          	auipc	a1,0x15
    80002b4c:	ce85a583          	lw	a1,-792(a1) # 80017830 <sb+0x18>
    80002b50:	9dbd                	addw	a1,a1,a5
    80002b52:	4108                	lw	a0,0(a0)
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	890080e7          	jalr	-1904(ra) # 800023e4 <bread>
    80002b5c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b5e:	05850793          	addi	a5,a0,88
    80002b62:	40c8                	lw	a0,4(s1)
    80002b64:	893d                	andi	a0,a0,15
    80002b66:	051a                	slli	a0,a0,0x6
    80002b68:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b6a:	04449703          	lh	a4,68(s1)
    80002b6e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b72:	04649703          	lh	a4,70(s1)
    80002b76:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b7a:	04849703          	lh	a4,72(s1)
    80002b7e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b82:	04a49703          	lh	a4,74(s1)
    80002b86:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b8a:	44f8                	lw	a4,76(s1)
    80002b8c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b8e:	03400613          	li	a2,52
    80002b92:	05048593          	addi	a1,s1,80
    80002b96:	0531                	addi	a0,a0,12
    80002b98:	ffffd097          	auipc	ra,0xffffd
    80002b9c:	640080e7          	jalr	1600(ra) # 800001d8 <memmove>
  log_write(bp);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00001097          	auipc	ra,0x1
    80002ba6:	bf6080e7          	jalr	-1034(ra) # 80003798 <log_write>
  brelse(bp);
    80002baa:	854a                	mv	a0,s2
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	968080e7          	jalr	-1688(ra) # 80002514 <brelse>
}
    80002bb4:	60e2                	ld	ra,24(sp)
    80002bb6:	6442                	ld	s0,16(sp)
    80002bb8:	64a2                	ld	s1,8(sp)
    80002bba:	6902                	ld	s2,0(sp)
    80002bbc:	6105                	addi	sp,sp,32
    80002bbe:	8082                	ret

0000000080002bc0 <idup>:
{
    80002bc0:	1101                	addi	sp,sp,-32
    80002bc2:	ec06                	sd	ra,24(sp)
    80002bc4:	e822                	sd	s0,16(sp)
    80002bc6:	e426                	sd	s1,8(sp)
    80002bc8:	1000                	addi	s0,sp,32
    80002bca:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bcc:	00015517          	auipc	a0,0x15
    80002bd0:	c6c50513          	addi	a0,a0,-916 # 80017838 <itable>
    80002bd4:	00003097          	auipc	ra,0x3
    80002bd8:	6da080e7          	jalr	1754(ra) # 800062ae <acquire>
  ip->ref++;
    80002bdc:	449c                	lw	a5,8(s1)
    80002bde:	2785                	addiw	a5,a5,1
    80002be0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002be2:	00015517          	auipc	a0,0x15
    80002be6:	c5650513          	addi	a0,a0,-938 # 80017838 <itable>
    80002bea:	00003097          	auipc	ra,0x3
    80002bee:	778080e7          	jalr	1912(ra) # 80006362 <release>
}
    80002bf2:	8526                	mv	a0,s1
    80002bf4:	60e2                	ld	ra,24(sp)
    80002bf6:	6442                	ld	s0,16(sp)
    80002bf8:	64a2                	ld	s1,8(sp)
    80002bfa:	6105                	addi	sp,sp,32
    80002bfc:	8082                	ret

0000000080002bfe <ilock>:
{
    80002bfe:	1101                	addi	sp,sp,-32
    80002c00:	ec06                	sd	ra,24(sp)
    80002c02:	e822                	sd	s0,16(sp)
    80002c04:	e426                	sd	s1,8(sp)
    80002c06:	e04a                	sd	s2,0(sp)
    80002c08:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c0a:	c115                	beqz	a0,80002c2e <ilock+0x30>
    80002c0c:	84aa                	mv	s1,a0
    80002c0e:	451c                	lw	a5,8(a0)
    80002c10:	00f05f63          	blez	a5,80002c2e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c14:	0541                	addi	a0,a0,16
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	ca2080e7          	jalr	-862(ra) # 800038b8 <acquiresleep>
  if(ip->valid == 0){
    80002c1e:	40bc                	lw	a5,64(s1)
    80002c20:	cf99                	beqz	a5,80002c3e <ilock+0x40>
}
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6902                	ld	s2,0(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret
    panic("ilock");
    80002c2e:	00006517          	auipc	a0,0x6
    80002c32:	93250513          	addi	a0,a0,-1742 # 80008560 <syscalls+0x190>
    80002c36:	00003097          	auipc	ra,0x3
    80002c3a:	158080e7          	jalr	344(ra) # 80005d8e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3e:	40dc                	lw	a5,4(s1)
    80002c40:	0047d79b          	srliw	a5,a5,0x4
    80002c44:	00015597          	auipc	a1,0x15
    80002c48:	bec5a583          	lw	a1,-1044(a1) # 80017830 <sb+0x18>
    80002c4c:	9dbd                	addw	a1,a1,a5
    80002c4e:	4088                	lw	a0,0(s1)
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	794080e7          	jalr	1940(ra) # 800023e4 <bread>
    80002c58:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c5a:	05850593          	addi	a1,a0,88
    80002c5e:	40dc                	lw	a5,4(s1)
    80002c60:	8bbd                	andi	a5,a5,15
    80002c62:	079a                	slli	a5,a5,0x6
    80002c64:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c66:	00059783          	lh	a5,0(a1)
    80002c6a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c6e:	00259783          	lh	a5,2(a1)
    80002c72:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c76:	00459783          	lh	a5,4(a1)
    80002c7a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c7e:	00659783          	lh	a5,6(a1)
    80002c82:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c86:	459c                	lw	a5,8(a1)
    80002c88:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c8a:	03400613          	li	a2,52
    80002c8e:	05b1                	addi	a1,a1,12
    80002c90:	05048513          	addi	a0,s1,80
    80002c94:	ffffd097          	auipc	ra,0xffffd
    80002c98:	544080e7          	jalr	1348(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00000097          	auipc	ra,0x0
    80002ca2:	876080e7          	jalr	-1930(ra) # 80002514 <brelse>
    ip->valid = 1;
    80002ca6:	4785                	li	a5,1
    80002ca8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002caa:	04449783          	lh	a5,68(s1)
    80002cae:	fbb5                	bnez	a5,80002c22 <ilock+0x24>
      panic("ilock: no type");
    80002cb0:	00006517          	auipc	a0,0x6
    80002cb4:	8b850513          	addi	a0,a0,-1864 # 80008568 <syscalls+0x198>
    80002cb8:	00003097          	auipc	ra,0x3
    80002cbc:	0d6080e7          	jalr	214(ra) # 80005d8e <panic>

0000000080002cc0 <iunlock>:
{
    80002cc0:	1101                	addi	sp,sp,-32
    80002cc2:	ec06                	sd	ra,24(sp)
    80002cc4:	e822                	sd	s0,16(sp)
    80002cc6:	e426                	sd	s1,8(sp)
    80002cc8:	e04a                	sd	s2,0(sp)
    80002cca:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ccc:	c905                	beqz	a0,80002cfc <iunlock+0x3c>
    80002cce:	84aa                	mv	s1,a0
    80002cd0:	01050913          	addi	s2,a0,16
    80002cd4:	854a                	mv	a0,s2
    80002cd6:	00001097          	auipc	ra,0x1
    80002cda:	c7c080e7          	jalr	-900(ra) # 80003952 <holdingsleep>
    80002cde:	cd19                	beqz	a0,80002cfc <iunlock+0x3c>
    80002ce0:	449c                	lw	a5,8(s1)
    80002ce2:	00f05d63          	blez	a5,80002cfc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ce6:	854a                	mv	a0,s2
    80002ce8:	00001097          	auipc	ra,0x1
    80002cec:	c26080e7          	jalr	-986(ra) # 8000390e <releasesleep>
}
    80002cf0:	60e2                	ld	ra,24(sp)
    80002cf2:	6442                	ld	s0,16(sp)
    80002cf4:	64a2                	ld	s1,8(sp)
    80002cf6:	6902                	ld	s2,0(sp)
    80002cf8:	6105                	addi	sp,sp,32
    80002cfa:	8082                	ret
    panic("iunlock");
    80002cfc:	00006517          	auipc	a0,0x6
    80002d00:	87c50513          	addi	a0,a0,-1924 # 80008578 <syscalls+0x1a8>
    80002d04:	00003097          	auipc	ra,0x3
    80002d08:	08a080e7          	jalr	138(ra) # 80005d8e <panic>

0000000080002d0c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d0c:	7179                	addi	sp,sp,-48
    80002d0e:	f406                	sd	ra,40(sp)
    80002d10:	f022                	sd	s0,32(sp)
    80002d12:	ec26                	sd	s1,24(sp)
    80002d14:	e84a                	sd	s2,16(sp)
    80002d16:	e44e                	sd	s3,8(sp)
    80002d18:	e052                	sd	s4,0(sp)
    80002d1a:	1800                	addi	s0,sp,48
    80002d1c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d1e:	05050493          	addi	s1,a0,80
    80002d22:	08050913          	addi	s2,a0,128
    80002d26:	a021                	j	80002d2e <itrunc+0x22>
    80002d28:	0491                	addi	s1,s1,4
    80002d2a:	01248d63          	beq	s1,s2,80002d44 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d2e:	408c                	lw	a1,0(s1)
    80002d30:	dde5                	beqz	a1,80002d28 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d32:	0009a503          	lw	a0,0(s3)
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	8f4080e7          	jalr	-1804(ra) # 8000262a <bfree>
      ip->addrs[i] = 0;
    80002d3e:	0004a023          	sw	zero,0(s1)
    80002d42:	b7dd                	j	80002d28 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d44:	0809a583          	lw	a1,128(s3)
    80002d48:	e185                	bnez	a1,80002d68 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d4a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d4e:	854e                	mv	a0,s3
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	de4080e7          	jalr	-540(ra) # 80002b34 <iupdate>
}
    80002d58:	70a2                	ld	ra,40(sp)
    80002d5a:	7402                	ld	s0,32(sp)
    80002d5c:	64e2                	ld	s1,24(sp)
    80002d5e:	6942                	ld	s2,16(sp)
    80002d60:	69a2                	ld	s3,8(sp)
    80002d62:	6a02                	ld	s4,0(sp)
    80002d64:	6145                	addi	sp,sp,48
    80002d66:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d68:	0009a503          	lw	a0,0(s3)
    80002d6c:	fffff097          	auipc	ra,0xfffff
    80002d70:	678080e7          	jalr	1656(ra) # 800023e4 <bread>
    80002d74:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d76:	05850493          	addi	s1,a0,88
    80002d7a:	45850913          	addi	s2,a0,1112
    80002d7e:	a811                	j	80002d92 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d80:	0009a503          	lw	a0,0(s3)
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	8a6080e7          	jalr	-1882(ra) # 8000262a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d8c:	0491                	addi	s1,s1,4
    80002d8e:	01248563          	beq	s1,s2,80002d98 <itrunc+0x8c>
      if(a[j])
    80002d92:	408c                	lw	a1,0(s1)
    80002d94:	dde5                	beqz	a1,80002d8c <itrunc+0x80>
    80002d96:	b7ed                	j	80002d80 <itrunc+0x74>
    brelse(bp);
    80002d98:	8552                	mv	a0,s4
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	77a080e7          	jalr	1914(ra) # 80002514 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002da2:	0809a583          	lw	a1,128(s3)
    80002da6:	0009a503          	lw	a0,0(s3)
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	880080e7          	jalr	-1920(ra) # 8000262a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002db2:	0809a023          	sw	zero,128(s3)
    80002db6:	bf51                	j	80002d4a <itrunc+0x3e>

0000000080002db8 <iput>:
{
    80002db8:	1101                	addi	sp,sp,-32
    80002dba:	ec06                	sd	ra,24(sp)
    80002dbc:	e822                	sd	s0,16(sp)
    80002dbe:	e426                	sd	s1,8(sp)
    80002dc0:	e04a                	sd	s2,0(sp)
    80002dc2:	1000                	addi	s0,sp,32
    80002dc4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc6:	00015517          	auipc	a0,0x15
    80002dca:	a7250513          	addi	a0,a0,-1422 # 80017838 <itable>
    80002dce:	00003097          	auipc	ra,0x3
    80002dd2:	4e0080e7          	jalr	1248(ra) # 800062ae <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd6:	4498                	lw	a4,8(s1)
    80002dd8:	4785                	li	a5,1
    80002dda:	02f70363          	beq	a4,a5,80002e00 <iput+0x48>
  ip->ref--;
    80002dde:	449c                	lw	a5,8(s1)
    80002de0:	37fd                	addiw	a5,a5,-1
    80002de2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de4:	00015517          	auipc	a0,0x15
    80002de8:	a5450513          	addi	a0,a0,-1452 # 80017838 <itable>
    80002dec:	00003097          	auipc	ra,0x3
    80002df0:	576080e7          	jalr	1398(ra) # 80006362 <release>
}
    80002df4:	60e2                	ld	ra,24(sp)
    80002df6:	6442                	ld	s0,16(sp)
    80002df8:	64a2                	ld	s1,8(sp)
    80002dfa:	6902                	ld	s2,0(sp)
    80002dfc:	6105                	addi	sp,sp,32
    80002dfe:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e00:	40bc                	lw	a5,64(s1)
    80002e02:	dff1                	beqz	a5,80002dde <iput+0x26>
    80002e04:	04a49783          	lh	a5,74(s1)
    80002e08:	fbf9                	bnez	a5,80002dde <iput+0x26>
    acquiresleep(&ip->lock);
    80002e0a:	01048913          	addi	s2,s1,16
    80002e0e:	854a                	mv	a0,s2
    80002e10:	00001097          	auipc	ra,0x1
    80002e14:	aa8080e7          	jalr	-1368(ra) # 800038b8 <acquiresleep>
    release(&itable.lock);
    80002e18:	00015517          	auipc	a0,0x15
    80002e1c:	a2050513          	addi	a0,a0,-1504 # 80017838 <itable>
    80002e20:	00003097          	auipc	ra,0x3
    80002e24:	542080e7          	jalr	1346(ra) # 80006362 <release>
    itrunc(ip);
    80002e28:	8526                	mv	a0,s1
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	ee2080e7          	jalr	-286(ra) # 80002d0c <itrunc>
    ip->type = 0;
    80002e32:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e36:	8526                	mv	a0,s1
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	cfc080e7          	jalr	-772(ra) # 80002b34 <iupdate>
    ip->valid = 0;
    80002e40:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e44:	854a                	mv	a0,s2
    80002e46:	00001097          	auipc	ra,0x1
    80002e4a:	ac8080e7          	jalr	-1336(ra) # 8000390e <releasesleep>
    acquire(&itable.lock);
    80002e4e:	00015517          	auipc	a0,0x15
    80002e52:	9ea50513          	addi	a0,a0,-1558 # 80017838 <itable>
    80002e56:	00003097          	auipc	ra,0x3
    80002e5a:	458080e7          	jalr	1112(ra) # 800062ae <acquire>
    80002e5e:	b741                	j	80002dde <iput+0x26>

0000000080002e60 <iunlockput>:
{
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	e426                	sd	s1,8(sp)
    80002e68:	1000                	addi	s0,sp,32
    80002e6a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e6c:	00000097          	auipc	ra,0x0
    80002e70:	e54080e7          	jalr	-428(ra) # 80002cc0 <iunlock>
  iput(ip);
    80002e74:	8526                	mv	a0,s1
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	f42080e7          	jalr	-190(ra) # 80002db8 <iput>
}
    80002e7e:	60e2                	ld	ra,24(sp)
    80002e80:	6442                	ld	s0,16(sp)
    80002e82:	64a2                	ld	s1,8(sp)
    80002e84:	6105                	addi	sp,sp,32
    80002e86:	8082                	ret

0000000080002e88 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e88:	1141                	addi	sp,sp,-16
    80002e8a:	e422                	sd	s0,8(sp)
    80002e8c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e8e:	411c                	lw	a5,0(a0)
    80002e90:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e92:	415c                	lw	a5,4(a0)
    80002e94:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e96:	04451783          	lh	a5,68(a0)
    80002e9a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e9e:	04a51783          	lh	a5,74(a0)
    80002ea2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ea6:	04c56783          	lwu	a5,76(a0)
    80002eaa:	e99c                	sd	a5,16(a1)
}
    80002eac:	6422                	ld	s0,8(sp)
    80002eae:	0141                	addi	sp,sp,16
    80002eb0:	8082                	ret

0000000080002eb2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eb2:	457c                	lw	a5,76(a0)
    80002eb4:	0ed7e963          	bltu	a5,a3,80002fa6 <readi+0xf4>
{
    80002eb8:	7159                	addi	sp,sp,-112
    80002eba:	f486                	sd	ra,104(sp)
    80002ebc:	f0a2                	sd	s0,96(sp)
    80002ebe:	eca6                	sd	s1,88(sp)
    80002ec0:	e8ca                	sd	s2,80(sp)
    80002ec2:	e4ce                	sd	s3,72(sp)
    80002ec4:	e0d2                	sd	s4,64(sp)
    80002ec6:	fc56                	sd	s5,56(sp)
    80002ec8:	f85a                	sd	s6,48(sp)
    80002eca:	f45e                	sd	s7,40(sp)
    80002ecc:	f062                	sd	s8,32(sp)
    80002ece:	ec66                	sd	s9,24(sp)
    80002ed0:	e86a                	sd	s10,16(sp)
    80002ed2:	e46e                	sd	s11,8(sp)
    80002ed4:	1880                	addi	s0,sp,112
    80002ed6:	8b2a                	mv	s6,a0
    80002ed8:	8bae                	mv	s7,a1
    80002eda:	8a32                	mv	s4,a2
    80002edc:	84b6                	mv	s1,a3
    80002ede:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ee0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ee2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ee4:	0ad76063          	bltu	a4,a3,80002f84 <readi+0xd2>
  if(off + n > ip->size)
    80002ee8:	00e7f463          	bgeu	a5,a4,80002ef0 <readi+0x3e>
    n = ip->size - off;
    80002eec:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef0:	0a0a8963          	beqz	s5,80002fa2 <readi+0xf0>
    80002ef4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef6:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002efa:	5c7d                	li	s8,-1
    80002efc:	a82d                	j	80002f36 <readi+0x84>
    80002efe:	020d1d93          	slli	s11,s10,0x20
    80002f02:	020ddd93          	srli	s11,s11,0x20
    80002f06:	05890613          	addi	a2,s2,88
    80002f0a:	86ee                	mv	a3,s11
    80002f0c:	963a                	add	a2,a2,a4
    80002f0e:	85d2                	mv	a1,s4
    80002f10:	855e                	mv	a0,s7
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	a32080e7          	jalr	-1486(ra) # 80001944 <either_copyout>
    80002f1a:	05850d63          	beq	a0,s8,80002f74 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f1e:	854a                	mv	a0,s2
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	5f4080e7          	jalr	1524(ra) # 80002514 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f28:	013d09bb          	addw	s3,s10,s3
    80002f2c:	009d04bb          	addw	s1,s10,s1
    80002f30:	9a6e                	add	s4,s4,s11
    80002f32:	0559f763          	bgeu	s3,s5,80002f80 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f36:	00a4d59b          	srliw	a1,s1,0xa
    80002f3a:	855a                	mv	a0,s6
    80002f3c:	00000097          	auipc	ra,0x0
    80002f40:	8a2080e7          	jalr	-1886(ra) # 800027de <bmap>
    80002f44:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f48:	cd85                	beqz	a1,80002f80 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f4a:	000b2503          	lw	a0,0(s6)
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	496080e7          	jalr	1174(ra) # 800023e4 <bread>
    80002f56:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f58:	3ff4f713          	andi	a4,s1,1023
    80002f5c:	40ec87bb          	subw	a5,s9,a4
    80002f60:	413a86bb          	subw	a3,s5,s3
    80002f64:	8d3e                	mv	s10,a5
    80002f66:	2781                	sext.w	a5,a5
    80002f68:	0006861b          	sext.w	a2,a3
    80002f6c:	f8f679e3          	bgeu	a2,a5,80002efe <readi+0x4c>
    80002f70:	8d36                	mv	s10,a3
    80002f72:	b771                	j	80002efe <readi+0x4c>
      brelse(bp);
    80002f74:	854a                	mv	a0,s2
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	59e080e7          	jalr	1438(ra) # 80002514 <brelse>
      tot = -1;
    80002f7e:	59fd                	li	s3,-1
  }
  return tot;
    80002f80:	0009851b          	sext.w	a0,s3
}
    80002f84:	70a6                	ld	ra,104(sp)
    80002f86:	7406                	ld	s0,96(sp)
    80002f88:	64e6                	ld	s1,88(sp)
    80002f8a:	6946                	ld	s2,80(sp)
    80002f8c:	69a6                	ld	s3,72(sp)
    80002f8e:	6a06                	ld	s4,64(sp)
    80002f90:	7ae2                	ld	s5,56(sp)
    80002f92:	7b42                	ld	s6,48(sp)
    80002f94:	7ba2                	ld	s7,40(sp)
    80002f96:	7c02                	ld	s8,32(sp)
    80002f98:	6ce2                	ld	s9,24(sp)
    80002f9a:	6d42                	ld	s10,16(sp)
    80002f9c:	6da2                	ld	s11,8(sp)
    80002f9e:	6165                	addi	sp,sp,112
    80002fa0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa2:	89d6                	mv	s3,s5
    80002fa4:	bff1                	j	80002f80 <readi+0xce>
    return 0;
    80002fa6:	4501                	li	a0,0
}
    80002fa8:	8082                	ret

0000000080002faa <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002faa:	457c                	lw	a5,76(a0)
    80002fac:	10d7e863          	bltu	a5,a3,800030bc <writei+0x112>
{
    80002fb0:	7159                	addi	sp,sp,-112
    80002fb2:	f486                	sd	ra,104(sp)
    80002fb4:	f0a2                	sd	s0,96(sp)
    80002fb6:	eca6                	sd	s1,88(sp)
    80002fb8:	e8ca                	sd	s2,80(sp)
    80002fba:	e4ce                	sd	s3,72(sp)
    80002fbc:	e0d2                	sd	s4,64(sp)
    80002fbe:	fc56                	sd	s5,56(sp)
    80002fc0:	f85a                	sd	s6,48(sp)
    80002fc2:	f45e                	sd	s7,40(sp)
    80002fc4:	f062                	sd	s8,32(sp)
    80002fc6:	ec66                	sd	s9,24(sp)
    80002fc8:	e86a                	sd	s10,16(sp)
    80002fca:	e46e                	sd	s11,8(sp)
    80002fcc:	1880                	addi	s0,sp,112
    80002fce:	8aaa                	mv	s5,a0
    80002fd0:	8bae                	mv	s7,a1
    80002fd2:	8a32                	mv	s4,a2
    80002fd4:	8936                	mv	s2,a3
    80002fd6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fd8:	00e687bb          	addw	a5,a3,a4
    80002fdc:	0ed7e263          	bltu	a5,a3,800030c0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fe0:	00043737          	lui	a4,0x43
    80002fe4:	0ef76063          	bltu	a4,a5,800030c4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe8:	0c0b0863          	beqz	s6,800030b8 <writei+0x10e>
    80002fec:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fee:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ff2:	5c7d                	li	s8,-1
    80002ff4:	a091                	j	80003038 <writei+0x8e>
    80002ff6:	020d1d93          	slli	s11,s10,0x20
    80002ffa:	020ddd93          	srli	s11,s11,0x20
    80002ffe:	05848513          	addi	a0,s1,88
    80003002:	86ee                	mv	a3,s11
    80003004:	8652                	mv	a2,s4
    80003006:	85de                	mv	a1,s7
    80003008:	953a                	add	a0,a0,a4
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	990080e7          	jalr	-1648(ra) # 8000199a <either_copyin>
    80003012:	07850263          	beq	a0,s8,80003076 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003016:	8526                	mv	a0,s1
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	780080e7          	jalr	1920(ra) # 80003798 <log_write>
    brelse(bp);
    80003020:	8526                	mv	a0,s1
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	4f2080e7          	jalr	1266(ra) # 80002514 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000302a:	013d09bb          	addw	s3,s10,s3
    8000302e:	012d093b          	addw	s2,s10,s2
    80003032:	9a6e                	add	s4,s4,s11
    80003034:	0569f663          	bgeu	s3,s6,80003080 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003038:	00a9559b          	srliw	a1,s2,0xa
    8000303c:	8556                	mv	a0,s5
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	7a0080e7          	jalr	1952(ra) # 800027de <bmap>
    80003046:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000304a:	c99d                	beqz	a1,80003080 <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000304c:	000aa503          	lw	a0,0(s5)
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	394080e7          	jalr	916(ra) # 800023e4 <bread>
    80003058:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000305a:	3ff97713          	andi	a4,s2,1023
    8000305e:	40ec87bb          	subw	a5,s9,a4
    80003062:	413b06bb          	subw	a3,s6,s3
    80003066:	8d3e                	mv	s10,a5
    80003068:	2781                	sext.w	a5,a5
    8000306a:	0006861b          	sext.w	a2,a3
    8000306e:	f8f674e3          	bgeu	a2,a5,80002ff6 <writei+0x4c>
    80003072:	8d36                	mv	s10,a3
    80003074:	b749                	j	80002ff6 <writei+0x4c>
      brelse(bp);
    80003076:	8526                	mv	a0,s1
    80003078:	fffff097          	auipc	ra,0xfffff
    8000307c:	49c080e7          	jalr	1180(ra) # 80002514 <brelse>
  }

  if(off > ip->size)
    80003080:	04caa783          	lw	a5,76(s5)
    80003084:	0127f463          	bgeu	a5,s2,8000308c <writei+0xe2>
    ip->size = off;
    80003088:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000308c:	8556                	mv	a0,s5
    8000308e:	00000097          	auipc	ra,0x0
    80003092:	aa6080e7          	jalr	-1370(ra) # 80002b34 <iupdate>

  return tot;
    80003096:	0009851b          	sext.w	a0,s3
}
    8000309a:	70a6                	ld	ra,104(sp)
    8000309c:	7406                	ld	s0,96(sp)
    8000309e:	64e6                	ld	s1,88(sp)
    800030a0:	6946                	ld	s2,80(sp)
    800030a2:	69a6                	ld	s3,72(sp)
    800030a4:	6a06                	ld	s4,64(sp)
    800030a6:	7ae2                	ld	s5,56(sp)
    800030a8:	7b42                	ld	s6,48(sp)
    800030aa:	7ba2                	ld	s7,40(sp)
    800030ac:	7c02                	ld	s8,32(sp)
    800030ae:	6ce2                	ld	s9,24(sp)
    800030b0:	6d42                	ld	s10,16(sp)
    800030b2:	6da2                	ld	s11,8(sp)
    800030b4:	6165                	addi	sp,sp,112
    800030b6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b8:	89da                	mv	s3,s6
    800030ba:	bfc9                	j	8000308c <writei+0xe2>
    return -1;
    800030bc:	557d                	li	a0,-1
}
    800030be:	8082                	ret
    return -1;
    800030c0:	557d                	li	a0,-1
    800030c2:	bfe1                	j	8000309a <writei+0xf0>
    return -1;
    800030c4:	557d                	li	a0,-1
    800030c6:	bfd1                	j	8000309a <writei+0xf0>

00000000800030c8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030c8:	1141                	addi	sp,sp,-16
    800030ca:	e406                	sd	ra,8(sp)
    800030cc:	e022                	sd	s0,0(sp)
    800030ce:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030d0:	4639                	li	a2,14
    800030d2:	ffffd097          	auipc	ra,0xffffd
    800030d6:	17e080e7          	jalr	382(ra) # 80000250 <strncmp>
}
    800030da:	60a2                	ld	ra,8(sp)
    800030dc:	6402                	ld	s0,0(sp)
    800030de:	0141                	addi	sp,sp,16
    800030e0:	8082                	ret

00000000800030e2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030e2:	7139                	addi	sp,sp,-64
    800030e4:	fc06                	sd	ra,56(sp)
    800030e6:	f822                	sd	s0,48(sp)
    800030e8:	f426                	sd	s1,40(sp)
    800030ea:	f04a                	sd	s2,32(sp)
    800030ec:	ec4e                	sd	s3,24(sp)
    800030ee:	e852                	sd	s4,16(sp)
    800030f0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030f2:	04451703          	lh	a4,68(a0)
    800030f6:	4785                	li	a5,1
    800030f8:	00f71a63          	bne	a4,a5,8000310c <dirlookup+0x2a>
    800030fc:	892a                	mv	s2,a0
    800030fe:	89ae                	mv	s3,a1
    80003100:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003102:	457c                	lw	a5,76(a0)
    80003104:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003106:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003108:	e79d                	bnez	a5,80003136 <dirlookup+0x54>
    8000310a:	a8a5                	j	80003182 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	47450513          	addi	a0,a0,1140 # 80008580 <syscalls+0x1b0>
    80003114:	00003097          	auipc	ra,0x3
    80003118:	c7a080e7          	jalr	-902(ra) # 80005d8e <panic>
      panic("dirlookup read");
    8000311c:	00005517          	auipc	a0,0x5
    80003120:	47c50513          	addi	a0,a0,1148 # 80008598 <syscalls+0x1c8>
    80003124:	00003097          	auipc	ra,0x3
    80003128:	c6a080e7          	jalr	-918(ra) # 80005d8e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000312c:	24c1                	addiw	s1,s1,16
    8000312e:	04c92783          	lw	a5,76(s2)
    80003132:	04f4f763          	bgeu	s1,a5,80003180 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003136:	4741                	li	a4,16
    80003138:	86a6                	mv	a3,s1
    8000313a:	fc040613          	addi	a2,s0,-64
    8000313e:	4581                	li	a1,0
    80003140:	854a                	mv	a0,s2
    80003142:	00000097          	auipc	ra,0x0
    80003146:	d70080e7          	jalr	-656(ra) # 80002eb2 <readi>
    8000314a:	47c1                	li	a5,16
    8000314c:	fcf518e3          	bne	a0,a5,8000311c <dirlookup+0x3a>
    if(de.inum == 0)
    80003150:	fc045783          	lhu	a5,-64(s0)
    80003154:	dfe1                	beqz	a5,8000312c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003156:	fc240593          	addi	a1,s0,-62
    8000315a:	854e                	mv	a0,s3
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	f6c080e7          	jalr	-148(ra) # 800030c8 <namecmp>
    80003164:	f561                	bnez	a0,8000312c <dirlookup+0x4a>
      if(poff)
    80003166:	000a0463          	beqz	s4,8000316e <dirlookup+0x8c>
        *poff = off;
    8000316a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000316e:	fc045583          	lhu	a1,-64(s0)
    80003172:	00092503          	lw	a0,0(s2)
    80003176:	fffff097          	auipc	ra,0xfffff
    8000317a:	750080e7          	jalr	1872(ra) # 800028c6 <iget>
    8000317e:	a011                	j	80003182 <dirlookup+0xa0>
  return 0;
    80003180:	4501                	li	a0,0
}
    80003182:	70e2                	ld	ra,56(sp)
    80003184:	7442                	ld	s0,48(sp)
    80003186:	74a2                	ld	s1,40(sp)
    80003188:	7902                	ld	s2,32(sp)
    8000318a:	69e2                	ld	s3,24(sp)
    8000318c:	6a42                	ld	s4,16(sp)
    8000318e:	6121                	addi	sp,sp,64
    80003190:	8082                	ret

0000000080003192 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003192:	711d                	addi	sp,sp,-96
    80003194:	ec86                	sd	ra,88(sp)
    80003196:	e8a2                	sd	s0,80(sp)
    80003198:	e4a6                	sd	s1,72(sp)
    8000319a:	e0ca                	sd	s2,64(sp)
    8000319c:	fc4e                	sd	s3,56(sp)
    8000319e:	f852                	sd	s4,48(sp)
    800031a0:	f456                	sd	s5,40(sp)
    800031a2:	f05a                	sd	s6,32(sp)
    800031a4:	ec5e                	sd	s7,24(sp)
    800031a6:	e862                	sd	s8,16(sp)
    800031a8:	e466                	sd	s9,8(sp)
    800031aa:	1080                	addi	s0,sp,96
    800031ac:	84aa                	mv	s1,a0
    800031ae:	8b2e                	mv	s6,a1
    800031b0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031b2:	00054703          	lbu	a4,0(a0)
    800031b6:	02f00793          	li	a5,47
    800031ba:	02f70363          	beq	a4,a5,800031e0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031be:	ffffe097          	auipc	ra,0xffffe
    800031c2:	c9a080e7          	jalr	-870(ra) # 80000e58 <myproc>
    800031c6:	15053503          	ld	a0,336(a0)
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	9f6080e7          	jalr	-1546(ra) # 80002bc0 <idup>
    800031d2:	89aa                	mv	s3,a0
  while(*path == '/')
    800031d4:	02f00913          	li	s2,47
  len = path - s;
    800031d8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031da:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031dc:	4c05                	li	s8,1
    800031de:	a865                	j	80003296 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031e0:	4585                	li	a1,1
    800031e2:	4505                	li	a0,1
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	6e2080e7          	jalr	1762(ra) # 800028c6 <iget>
    800031ec:	89aa                	mv	s3,a0
    800031ee:	b7dd                	j	800031d4 <namex+0x42>
      iunlockput(ip);
    800031f0:	854e                	mv	a0,s3
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	c6e080e7          	jalr	-914(ra) # 80002e60 <iunlockput>
      return 0;
    800031fa:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031fc:	854e                	mv	a0,s3
    800031fe:	60e6                	ld	ra,88(sp)
    80003200:	6446                	ld	s0,80(sp)
    80003202:	64a6                	ld	s1,72(sp)
    80003204:	6906                	ld	s2,64(sp)
    80003206:	79e2                	ld	s3,56(sp)
    80003208:	7a42                	ld	s4,48(sp)
    8000320a:	7aa2                	ld	s5,40(sp)
    8000320c:	7b02                	ld	s6,32(sp)
    8000320e:	6be2                	ld	s7,24(sp)
    80003210:	6c42                	ld	s8,16(sp)
    80003212:	6ca2                	ld	s9,8(sp)
    80003214:	6125                	addi	sp,sp,96
    80003216:	8082                	ret
      iunlock(ip);
    80003218:	854e                	mv	a0,s3
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	aa6080e7          	jalr	-1370(ra) # 80002cc0 <iunlock>
      return ip;
    80003222:	bfe9                	j	800031fc <namex+0x6a>
      iunlockput(ip);
    80003224:	854e                	mv	a0,s3
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	c3a080e7          	jalr	-966(ra) # 80002e60 <iunlockput>
      return 0;
    8000322e:	89d2                	mv	s3,s4
    80003230:	b7f1                	j	800031fc <namex+0x6a>
  len = path - s;
    80003232:	40b48633          	sub	a2,s1,a1
    80003236:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000323a:	094cd463          	bge	s9,s4,800032c2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000323e:	4639                	li	a2,14
    80003240:	8556                	mv	a0,s5
    80003242:	ffffd097          	auipc	ra,0xffffd
    80003246:	f96080e7          	jalr	-106(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	01279763          	bne	a5,s2,8000325c <namex+0xca>
    path++;
    80003252:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003254:	0004c783          	lbu	a5,0(s1)
    80003258:	ff278de3          	beq	a5,s2,80003252 <namex+0xc0>
    ilock(ip);
    8000325c:	854e                	mv	a0,s3
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	9a0080e7          	jalr	-1632(ra) # 80002bfe <ilock>
    if(ip->type != T_DIR){
    80003266:	04499783          	lh	a5,68(s3)
    8000326a:	f98793e3          	bne	a5,s8,800031f0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000326e:	000b0563          	beqz	s6,80003278 <namex+0xe6>
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	d3cd                	beqz	a5,80003218 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003278:	865e                	mv	a2,s7
    8000327a:	85d6                	mv	a1,s5
    8000327c:	854e                	mv	a0,s3
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e64080e7          	jalr	-412(ra) # 800030e2 <dirlookup>
    80003286:	8a2a                	mv	s4,a0
    80003288:	dd51                	beqz	a0,80003224 <namex+0x92>
    iunlockput(ip);
    8000328a:	854e                	mv	a0,s3
    8000328c:	00000097          	auipc	ra,0x0
    80003290:	bd4080e7          	jalr	-1068(ra) # 80002e60 <iunlockput>
    ip = next;
    80003294:	89d2                	mv	s3,s4
  while(*path == '/')
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	05279763          	bne	a5,s2,800032e8 <namex+0x156>
    path++;
    8000329e:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032a0:	0004c783          	lbu	a5,0(s1)
    800032a4:	ff278de3          	beq	a5,s2,8000329e <namex+0x10c>
  if(*path == 0)
    800032a8:	c79d                	beqz	a5,800032d6 <namex+0x144>
    path++;
    800032aa:	85a6                	mv	a1,s1
  len = path - s;
    800032ac:	8a5e                	mv	s4,s7
    800032ae:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032b0:	01278963          	beq	a5,s2,800032c2 <namex+0x130>
    800032b4:	dfbd                	beqz	a5,80003232 <namex+0xa0>
    path++;
    800032b6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032b8:	0004c783          	lbu	a5,0(s1)
    800032bc:	ff279ce3          	bne	a5,s2,800032b4 <namex+0x122>
    800032c0:	bf8d                	j	80003232 <namex+0xa0>
    memmove(name, s, len);
    800032c2:	2601                	sext.w	a2,a2
    800032c4:	8556                	mv	a0,s5
    800032c6:	ffffd097          	auipc	ra,0xffffd
    800032ca:	f12080e7          	jalr	-238(ra) # 800001d8 <memmove>
    name[len] = 0;
    800032ce:	9a56                	add	s4,s4,s5
    800032d0:	000a0023          	sb	zero,0(s4)
    800032d4:	bf9d                	j	8000324a <namex+0xb8>
  if(nameiparent){
    800032d6:	f20b03e3          	beqz	s6,800031fc <namex+0x6a>
    iput(ip);
    800032da:	854e                	mv	a0,s3
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	adc080e7          	jalr	-1316(ra) # 80002db8 <iput>
    return 0;
    800032e4:	4981                	li	s3,0
    800032e6:	bf19                	j	800031fc <namex+0x6a>
  if(*path == 0)
    800032e8:	d7fd                	beqz	a5,800032d6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	85a6                	mv	a1,s1
    800032f0:	b7d1                	j	800032b4 <namex+0x122>

00000000800032f2 <dirlink>:
{
    800032f2:	7139                	addi	sp,sp,-64
    800032f4:	fc06                	sd	ra,56(sp)
    800032f6:	f822                	sd	s0,48(sp)
    800032f8:	f426                	sd	s1,40(sp)
    800032fa:	f04a                	sd	s2,32(sp)
    800032fc:	ec4e                	sd	s3,24(sp)
    800032fe:	e852                	sd	s4,16(sp)
    80003300:	0080                	addi	s0,sp,64
    80003302:	892a                	mv	s2,a0
    80003304:	8a2e                	mv	s4,a1
    80003306:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003308:	4601                	li	a2,0
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	dd8080e7          	jalr	-552(ra) # 800030e2 <dirlookup>
    80003312:	e93d                	bnez	a0,80003388 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003314:	04c92483          	lw	s1,76(s2)
    80003318:	c49d                	beqz	s1,80003346 <dirlink+0x54>
    8000331a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331c:	4741                	li	a4,16
    8000331e:	86a6                	mv	a3,s1
    80003320:	fc040613          	addi	a2,s0,-64
    80003324:	4581                	li	a1,0
    80003326:	854a                	mv	a0,s2
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	b8a080e7          	jalr	-1142(ra) # 80002eb2 <readi>
    80003330:	47c1                	li	a5,16
    80003332:	06f51163          	bne	a0,a5,80003394 <dirlink+0xa2>
    if(de.inum == 0)
    80003336:	fc045783          	lhu	a5,-64(s0)
    8000333a:	c791                	beqz	a5,80003346 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000333c:	24c1                	addiw	s1,s1,16
    8000333e:	04c92783          	lw	a5,76(s2)
    80003342:	fcf4ede3          	bltu	s1,a5,8000331c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003346:	4639                	li	a2,14
    80003348:	85d2                	mv	a1,s4
    8000334a:	fc240513          	addi	a0,s0,-62
    8000334e:	ffffd097          	auipc	ra,0xffffd
    80003352:	f3e080e7          	jalr	-194(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003356:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335a:	4741                	li	a4,16
    8000335c:	86a6                	mv	a3,s1
    8000335e:	fc040613          	addi	a2,s0,-64
    80003362:	4581                	li	a1,0
    80003364:	854a                	mv	a0,s2
    80003366:	00000097          	auipc	ra,0x0
    8000336a:	c44080e7          	jalr	-956(ra) # 80002faa <writei>
    8000336e:	1541                	addi	a0,a0,-16
    80003370:	00a03533          	snez	a0,a0
    80003374:	40a00533          	neg	a0,a0
}
    80003378:	70e2                	ld	ra,56(sp)
    8000337a:	7442                	ld	s0,48(sp)
    8000337c:	74a2                	ld	s1,40(sp)
    8000337e:	7902                	ld	s2,32(sp)
    80003380:	69e2                	ld	s3,24(sp)
    80003382:	6a42                	ld	s4,16(sp)
    80003384:	6121                	addi	sp,sp,64
    80003386:	8082                	ret
    iput(ip);
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	a30080e7          	jalr	-1488(ra) # 80002db8 <iput>
    return -1;
    80003390:	557d                	li	a0,-1
    80003392:	b7dd                	j	80003378 <dirlink+0x86>
      panic("dirlink read");
    80003394:	00005517          	auipc	a0,0x5
    80003398:	21450513          	addi	a0,a0,532 # 800085a8 <syscalls+0x1d8>
    8000339c:	00003097          	auipc	ra,0x3
    800033a0:	9f2080e7          	jalr	-1550(ra) # 80005d8e <panic>

00000000800033a4 <namei>:

struct inode*
namei(char *path)
{
    800033a4:	1101                	addi	sp,sp,-32
    800033a6:	ec06                	sd	ra,24(sp)
    800033a8:	e822                	sd	s0,16(sp)
    800033aa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ac:	fe040613          	addi	a2,s0,-32
    800033b0:	4581                	li	a1,0
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	de0080e7          	jalr	-544(ra) # 80003192 <namex>
}
    800033ba:	60e2                	ld	ra,24(sp)
    800033bc:	6442                	ld	s0,16(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret

00000000800033c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033c2:	1141                	addi	sp,sp,-16
    800033c4:	e406                	sd	ra,8(sp)
    800033c6:	e022                	sd	s0,0(sp)
    800033c8:	0800                	addi	s0,sp,16
    800033ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033cc:	4585                	li	a1,1
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	dc4080e7          	jalr	-572(ra) # 80003192 <namex>
}
    800033d6:	60a2                	ld	ra,8(sp)
    800033d8:	6402                	ld	s0,0(sp)
    800033da:	0141                	addi	sp,sp,16
    800033dc:	8082                	ret

00000000800033de <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033de:	1101                	addi	sp,sp,-32
    800033e0:	ec06                	sd	ra,24(sp)
    800033e2:	e822                	sd	s0,16(sp)
    800033e4:	e426                	sd	s1,8(sp)
    800033e6:	e04a                	sd	s2,0(sp)
    800033e8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033ea:	00016917          	auipc	s2,0x16
    800033ee:	ef690913          	addi	s2,s2,-266 # 800192e0 <log>
    800033f2:	01892583          	lw	a1,24(s2)
    800033f6:	02892503          	lw	a0,40(s2)
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	fea080e7          	jalr	-22(ra) # 800023e4 <bread>
    80003402:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003404:	02c92683          	lw	a3,44(s2)
    80003408:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000340a:	02d05763          	blez	a3,80003438 <write_head+0x5a>
    8000340e:	00016797          	auipc	a5,0x16
    80003412:	f0278793          	addi	a5,a5,-254 # 80019310 <log+0x30>
    80003416:	05c50713          	addi	a4,a0,92
    8000341a:	36fd                	addiw	a3,a3,-1
    8000341c:	1682                	slli	a3,a3,0x20
    8000341e:	9281                	srli	a3,a3,0x20
    80003420:	068a                	slli	a3,a3,0x2
    80003422:	00016617          	auipc	a2,0x16
    80003426:	ef260613          	addi	a2,a2,-270 # 80019314 <log+0x34>
    8000342a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000342c:	4390                	lw	a2,0(a5)
    8000342e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003430:	0791                	addi	a5,a5,4
    80003432:	0711                	addi	a4,a4,4
    80003434:	fed79ce3          	bne	a5,a3,8000342c <write_head+0x4e>
  }
  bwrite(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	09c080e7          	jalr	156(ra) # 800024d6 <bwrite>
  brelse(buf);
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	0d0080e7          	jalr	208(ra) # 80002514 <brelse>
}
    8000344c:	60e2                	ld	ra,24(sp)
    8000344e:	6442                	ld	s0,16(sp)
    80003450:	64a2                	ld	s1,8(sp)
    80003452:	6902                	ld	s2,0(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003458:	00016797          	auipc	a5,0x16
    8000345c:	eb47a783          	lw	a5,-332(a5) # 8001930c <log+0x2c>
    80003460:	0af05d63          	blez	a5,8000351a <install_trans+0xc2>
{
    80003464:	7139                	addi	sp,sp,-64
    80003466:	fc06                	sd	ra,56(sp)
    80003468:	f822                	sd	s0,48(sp)
    8000346a:	f426                	sd	s1,40(sp)
    8000346c:	f04a                	sd	s2,32(sp)
    8000346e:	ec4e                	sd	s3,24(sp)
    80003470:	e852                	sd	s4,16(sp)
    80003472:	e456                	sd	s5,8(sp)
    80003474:	e05a                	sd	s6,0(sp)
    80003476:	0080                	addi	s0,sp,64
    80003478:	8b2a                	mv	s6,a0
    8000347a:	00016a97          	auipc	s5,0x16
    8000347e:	e96a8a93          	addi	s5,s5,-362 # 80019310 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003482:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003484:	00016997          	auipc	s3,0x16
    80003488:	e5c98993          	addi	s3,s3,-420 # 800192e0 <log>
    8000348c:	a035                	j	800034b8 <install_trans+0x60>
      bunpin(dbuf);
    8000348e:	8526                	mv	a0,s1
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	15e080e7          	jalr	350(ra) # 800025ee <bunpin>
    brelse(lbuf);
    80003498:	854a                	mv	a0,s2
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	07a080e7          	jalr	122(ra) # 80002514 <brelse>
    brelse(dbuf);
    800034a2:	8526                	mv	a0,s1
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	070080e7          	jalr	112(ra) # 80002514 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ac:	2a05                	addiw	s4,s4,1
    800034ae:	0a91                	addi	s5,s5,4
    800034b0:	02c9a783          	lw	a5,44(s3)
    800034b4:	04fa5963          	bge	s4,a5,80003506 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b8:	0189a583          	lw	a1,24(s3)
    800034bc:	014585bb          	addw	a1,a1,s4
    800034c0:	2585                	addiw	a1,a1,1
    800034c2:	0289a503          	lw	a0,40(s3)
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	f1e080e7          	jalr	-226(ra) # 800023e4 <bread>
    800034ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034d0:	000aa583          	lw	a1,0(s5)
    800034d4:	0289a503          	lw	a0,40(s3)
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	f0c080e7          	jalr	-244(ra) # 800023e4 <bread>
    800034e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034e2:	40000613          	li	a2,1024
    800034e6:	05890593          	addi	a1,s2,88
    800034ea:	05850513          	addi	a0,a0,88
    800034ee:	ffffd097          	auipc	ra,0xffffd
    800034f2:	cea080e7          	jalr	-790(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034f6:	8526                	mv	a0,s1
    800034f8:	fffff097          	auipc	ra,0xfffff
    800034fc:	fde080e7          	jalr	-34(ra) # 800024d6 <bwrite>
    if(recovering == 0)
    80003500:	f80b1ce3          	bnez	s6,80003498 <install_trans+0x40>
    80003504:	b769                	j	8000348e <install_trans+0x36>
}
    80003506:	70e2                	ld	ra,56(sp)
    80003508:	7442                	ld	s0,48(sp)
    8000350a:	74a2                	ld	s1,40(sp)
    8000350c:	7902                	ld	s2,32(sp)
    8000350e:	69e2                	ld	s3,24(sp)
    80003510:	6a42                	ld	s4,16(sp)
    80003512:	6aa2                	ld	s5,8(sp)
    80003514:	6b02                	ld	s6,0(sp)
    80003516:	6121                	addi	sp,sp,64
    80003518:	8082                	ret
    8000351a:	8082                	ret

000000008000351c <initlog>:
{
    8000351c:	7179                	addi	sp,sp,-48
    8000351e:	f406                	sd	ra,40(sp)
    80003520:	f022                	sd	s0,32(sp)
    80003522:	ec26                	sd	s1,24(sp)
    80003524:	e84a                	sd	s2,16(sp)
    80003526:	e44e                	sd	s3,8(sp)
    80003528:	1800                	addi	s0,sp,48
    8000352a:	892a                	mv	s2,a0
    8000352c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000352e:	00016497          	auipc	s1,0x16
    80003532:	db248493          	addi	s1,s1,-590 # 800192e0 <log>
    80003536:	00005597          	auipc	a1,0x5
    8000353a:	08258593          	addi	a1,a1,130 # 800085b8 <syscalls+0x1e8>
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	cde080e7          	jalr	-802(ra) # 8000621e <initlock>
  log.start = sb->logstart;
    80003548:	0149a583          	lw	a1,20(s3)
    8000354c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000354e:	0109a783          	lw	a5,16(s3)
    80003552:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003554:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003558:	854a                	mv	a0,s2
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	e8a080e7          	jalr	-374(ra) # 800023e4 <bread>
  log.lh.n = lh->n;
    80003562:	4d3c                	lw	a5,88(a0)
    80003564:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	02f05563          	blez	a5,80003590 <initlog+0x74>
    8000356a:	05c50713          	addi	a4,a0,92
    8000356e:	00016697          	auipc	a3,0x16
    80003572:	da268693          	addi	a3,a3,-606 # 80019310 <log+0x30>
    80003576:	37fd                	addiw	a5,a5,-1
    80003578:	1782                	slli	a5,a5,0x20
    8000357a:	9381                	srli	a5,a5,0x20
    8000357c:	078a                	slli	a5,a5,0x2
    8000357e:	06050613          	addi	a2,a0,96
    80003582:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003584:	4310                	lw	a2,0(a4)
    80003586:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003588:	0711                	addi	a4,a4,4
    8000358a:	0691                	addi	a3,a3,4
    8000358c:	fef71ce3          	bne	a4,a5,80003584 <initlog+0x68>
  brelse(buf);
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	f84080e7          	jalr	-124(ra) # 80002514 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003598:	4505                	li	a0,1
    8000359a:	00000097          	auipc	ra,0x0
    8000359e:	ebe080e7          	jalr	-322(ra) # 80003458 <install_trans>
  log.lh.n = 0;
    800035a2:	00016797          	auipc	a5,0x16
    800035a6:	d607a523          	sw	zero,-662(a5) # 8001930c <log+0x2c>
  write_head(); // clear the log
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	e34080e7          	jalr	-460(ra) # 800033de <write_head>
}
    800035b2:	70a2                	ld	ra,40(sp)
    800035b4:	7402                	ld	s0,32(sp)
    800035b6:	64e2                	ld	s1,24(sp)
    800035b8:	6942                	ld	s2,16(sp)
    800035ba:	69a2                	ld	s3,8(sp)
    800035bc:	6145                	addi	sp,sp,48
    800035be:	8082                	ret

00000000800035c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035c0:	1101                	addi	sp,sp,-32
    800035c2:	ec06                	sd	ra,24(sp)
    800035c4:	e822                	sd	s0,16(sp)
    800035c6:	e426                	sd	s1,8(sp)
    800035c8:	e04a                	sd	s2,0(sp)
    800035ca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035cc:	00016517          	auipc	a0,0x16
    800035d0:	d1450513          	addi	a0,a0,-748 # 800192e0 <log>
    800035d4:	00003097          	auipc	ra,0x3
    800035d8:	cda080e7          	jalr	-806(ra) # 800062ae <acquire>
  while(1){
    if(log.committing){
    800035dc:	00016497          	auipc	s1,0x16
    800035e0:	d0448493          	addi	s1,s1,-764 # 800192e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e4:	4979                	li	s2,30
    800035e6:	a039                	j	800035f4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035e8:	85a6                	mv	a1,s1
    800035ea:	8526                	mv	a0,s1
    800035ec:	ffffe097          	auipc	ra,0xffffe
    800035f0:	f50080e7          	jalr	-176(ra) # 8000153c <sleep>
    if(log.committing){
    800035f4:	50dc                	lw	a5,36(s1)
    800035f6:	fbed                	bnez	a5,800035e8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f8:	509c                	lw	a5,32(s1)
    800035fa:	0017871b          	addiw	a4,a5,1
    800035fe:	0007069b          	sext.w	a3,a4
    80003602:	0027179b          	slliw	a5,a4,0x2
    80003606:	9fb9                	addw	a5,a5,a4
    80003608:	0017979b          	slliw	a5,a5,0x1
    8000360c:	54d8                	lw	a4,44(s1)
    8000360e:	9fb9                	addw	a5,a5,a4
    80003610:	00f95963          	bge	s2,a5,80003622 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003614:	85a6                	mv	a1,s1
    80003616:	8526                	mv	a0,s1
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	f24080e7          	jalr	-220(ra) # 8000153c <sleep>
    80003620:	bfd1                	j	800035f4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003622:	00016517          	auipc	a0,0x16
    80003626:	cbe50513          	addi	a0,a0,-834 # 800192e0 <log>
    8000362a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	d36080e7          	jalr	-714(ra) # 80006362 <release>
      break;
    }
  }
}
    80003634:	60e2                	ld	ra,24(sp)
    80003636:	6442                	ld	s0,16(sp)
    80003638:	64a2                	ld	s1,8(sp)
    8000363a:	6902                	ld	s2,0(sp)
    8000363c:	6105                	addi	sp,sp,32
    8000363e:	8082                	ret

0000000080003640 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003640:	7139                	addi	sp,sp,-64
    80003642:	fc06                	sd	ra,56(sp)
    80003644:	f822                	sd	s0,48(sp)
    80003646:	f426                	sd	s1,40(sp)
    80003648:	f04a                	sd	s2,32(sp)
    8000364a:	ec4e                	sd	s3,24(sp)
    8000364c:	e852                	sd	s4,16(sp)
    8000364e:	e456                	sd	s5,8(sp)
    80003650:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003652:	00016497          	auipc	s1,0x16
    80003656:	c8e48493          	addi	s1,s1,-882 # 800192e0 <log>
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	c52080e7          	jalr	-942(ra) # 800062ae <acquire>
  log.outstanding -= 1;
    80003664:	509c                	lw	a5,32(s1)
    80003666:	37fd                	addiw	a5,a5,-1
    80003668:	0007891b          	sext.w	s2,a5
    8000366c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000366e:	50dc                	lw	a5,36(s1)
    80003670:	efb9                	bnez	a5,800036ce <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003672:	06091663          	bnez	s2,800036de <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003676:	00016497          	auipc	s1,0x16
    8000367a:	c6a48493          	addi	s1,s1,-918 # 800192e0 <log>
    8000367e:	4785                	li	a5,1
    80003680:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	cde080e7          	jalr	-802(ra) # 80006362 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000368c:	54dc                	lw	a5,44(s1)
    8000368e:	06f04763          	bgtz	a5,800036fc <end_op+0xbc>
    acquire(&log.lock);
    80003692:	00016497          	auipc	s1,0x16
    80003696:	c4e48493          	addi	s1,s1,-946 # 800192e0 <log>
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	c12080e7          	jalr	-1006(ra) # 800062ae <acquire>
    log.committing = 0;
    800036a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	ef6080e7          	jalr	-266(ra) # 800015a0 <wakeup>
    release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	cae080e7          	jalr	-850(ra) # 80006362 <release>
}
    800036bc:	70e2                	ld	ra,56(sp)
    800036be:	7442                	ld	s0,48(sp)
    800036c0:	74a2                	ld	s1,40(sp)
    800036c2:	7902                	ld	s2,32(sp)
    800036c4:	69e2                	ld	s3,24(sp)
    800036c6:	6a42                	ld	s4,16(sp)
    800036c8:	6aa2                	ld	s5,8(sp)
    800036ca:	6121                	addi	sp,sp,64
    800036cc:	8082                	ret
    panic("log.committing");
    800036ce:	00005517          	auipc	a0,0x5
    800036d2:	ef250513          	addi	a0,a0,-270 # 800085c0 <syscalls+0x1f0>
    800036d6:	00002097          	auipc	ra,0x2
    800036da:	6b8080e7          	jalr	1720(ra) # 80005d8e <panic>
    wakeup(&log);
    800036de:	00016497          	auipc	s1,0x16
    800036e2:	c0248493          	addi	s1,s1,-1022 # 800192e0 <log>
    800036e6:	8526                	mv	a0,s1
    800036e8:	ffffe097          	auipc	ra,0xffffe
    800036ec:	eb8080e7          	jalr	-328(ra) # 800015a0 <wakeup>
  release(&log.lock);
    800036f0:	8526                	mv	a0,s1
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	c70080e7          	jalr	-912(ra) # 80006362 <release>
  if(do_commit){
    800036fa:	b7c9                	j	800036bc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036fc:	00016a97          	auipc	s5,0x16
    80003700:	c14a8a93          	addi	s5,s5,-1004 # 80019310 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003704:	00016a17          	auipc	s4,0x16
    80003708:	bdca0a13          	addi	s4,s4,-1060 # 800192e0 <log>
    8000370c:	018a2583          	lw	a1,24(s4)
    80003710:	012585bb          	addw	a1,a1,s2
    80003714:	2585                	addiw	a1,a1,1
    80003716:	028a2503          	lw	a0,40(s4)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	cca080e7          	jalr	-822(ra) # 800023e4 <bread>
    80003722:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	028a2503          	lw	a0,40(s4)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	cb8080e7          	jalr	-840(ra) # 800023e4 <bread>
    80003734:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003736:	40000613          	li	a2,1024
    8000373a:	05850593          	addi	a1,a0,88
    8000373e:	05848513          	addi	a0,s1,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	a96080e7          	jalr	-1386(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	d8a080e7          	jalr	-630(ra) # 800024d6 <bwrite>
    brelse(from);
    80003754:	854e                	mv	a0,s3
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dbe080e7          	jalr	-578(ra) # 80002514 <brelse>
    brelse(to);
    8000375e:	8526                	mv	a0,s1
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	db4080e7          	jalr	-588(ra) # 80002514 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003768:	2905                	addiw	s2,s2,1
    8000376a:	0a91                	addi	s5,s5,4
    8000376c:	02ca2783          	lw	a5,44(s4)
    80003770:	f8f94ee3          	blt	s2,a5,8000370c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c6a080e7          	jalr	-918(ra) # 800033de <write_head>
    install_trans(0); // Now install writes to home locations
    8000377c:	4501                	li	a0,0
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	cda080e7          	jalr	-806(ra) # 80003458 <install_trans>
    log.lh.n = 0;
    80003786:	00016797          	auipc	a5,0x16
    8000378a:	b807a323          	sw	zero,-1146(a5) # 8001930c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	c50080e7          	jalr	-944(ra) # 800033de <write_head>
    80003796:	bdf5                	j	80003692 <end_op+0x52>

0000000080003798 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a6:	00016917          	auipc	s2,0x16
    800037aa:	b3a90913          	addi	s2,s2,-1222 # 800192e0 <log>
    800037ae:	854a                	mv	a0,s2
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	afe080e7          	jalr	-1282(ra) # 800062ae <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b8:	02c92603          	lw	a2,44(s2)
    800037bc:	47f5                	li	a5,29
    800037be:	06c7c563          	blt	a5,a2,80003828 <log_write+0x90>
    800037c2:	00016797          	auipc	a5,0x16
    800037c6:	b3a7a783          	lw	a5,-1222(a5) # 800192fc <log+0x1c>
    800037ca:	37fd                	addiw	a5,a5,-1
    800037cc:	04f65e63          	bge	a2,a5,80003828 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037d0:	00016797          	auipc	a5,0x16
    800037d4:	b307a783          	lw	a5,-1232(a5) # 80019300 <log+0x20>
    800037d8:	06f05063          	blez	a5,80003838 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037dc:	4781                	li	a5,0
    800037de:	06c05563          	blez	a2,80003848 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e2:	44cc                	lw	a1,12(s1)
    800037e4:	00016717          	auipc	a4,0x16
    800037e8:	b2c70713          	addi	a4,a4,-1236 # 80019310 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ee:	4314                	lw	a3,0(a4)
    800037f0:	04b68c63          	beq	a3,a1,80003848 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037f4:	2785                	addiw	a5,a5,1
    800037f6:	0711                	addi	a4,a4,4
    800037f8:	fef61be3          	bne	a2,a5,800037ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037fc:	0621                	addi	a2,a2,8
    800037fe:	060a                	slli	a2,a2,0x2
    80003800:	00016797          	auipc	a5,0x16
    80003804:	ae078793          	addi	a5,a5,-1312 # 800192e0 <log>
    80003808:	963e                	add	a2,a2,a5
    8000380a:	44dc                	lw	a5,12(s1)
    8000380c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000380e:	8526                	mv	a0,s1
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	da2080e7          	jalr	-606(ra) # 800025b2 <bpin>
    log.lh.n++;
    80003818:	00016717          	auipc	a4,0x16
    8000381c:	ac870713          	addi	a4,a4,-1336 # 800192e0 <log>
    80003820:	575c                	lw	a5,44(a4)
    80003822:	2785                	addiw	a5,a5,1
    80003824:	d75c                	sw	a5,44(a4)
    80003826:	a835                	j	80003862 <log_write+0xca>
    panic("too big a transaction");
    80003828:	00005517          	auipc	a0,0x5
    8000382c:	da850513          	addi	a0,a0,-600 # 800085d0 <syscalls+0x200>
    80003830:	00002097          	auipc	ra,0x2
    80003834:	55e080e7          	jalr	1374(ra) # 80005d8e <panic>
    panic("log_write outside of trans");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	db050513          	addi	a0,a0,-592 # 800085e8 <syscalls+0x218>
    80003840:	00002097          	auipc	ra,0x2
    80003844:	54e080e7          	jalr	1358(ra) # 80005d8e <panic>
  log.lh.block[i] = b->blockno;
    80003848:	00878713          	addi	a4,a5,8
    8000384c:	00271693          	slli	a3,a4,0x2
    80003850:	00016717          	auipc	a4,0x16
    80003854:	a9070713          	addi	a4,a4,-1392 # 800192e0 <log>
    80003858:	9736                	add	a4,a4,a3
    8000385a:	44d4                	lw	a3,12(s1)
    8000385c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000385e:	faf608e3          	beq	a2,a5,8000380e <log_write+0x76>
  }
  release(&log.lock);
    80003862:	00016517          	auipc	a0,0x16
    80003866:	a7e50513          	addi	a0,a0,-1410 # 800192e0 <log>
    8000386a:	00003097          	auipc	ra,0x3
    8000386e:	af8080e7          	jalr	-1288(ra) # 80006362 <release>
}
    80003872:	60e2                	ld	ra,24(sp)
    80003874:	6442                	ld	s0,16(sp)
    80003876:	64a2                	ld	s1,8(sp)
    80003878:	6902                	ld	s2,0(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret

000000008000387e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000387e:	1101                	addi	sp,sp,-32
    80003880:	ec06                	sd	ra,24(sp)
    80003882:	e822                	sd	s0,16(sp)
    80003884:	e426                	sd	s1,8(sp)
    80003886:	e04a                	sd	s2,0(sp)
    80003888:	1000                	addi	s0,sp,32
    8000388a:	84aa                	mv	s1,a0
    8000388c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000388e:	00005597          	auipc	a1,0x5
    80003892:	d7a58593          	addi	a1,a1,-646 # 80008608 <syscalls+0x238>
    80003896:	0521                	addi	a0,a0,8
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	986080e7          	jalr	-1658(ra) # 8000621e <initlock>
  lk->name = name;
    800038a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a8:	0204a423          	sw	zero,40(s1)
}
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6902                	ld	s2,0(sp)
    800038b4:	6105                	addi	sp,sp,32
    800038b6:	8082                	ret

00000000800038b8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c6:	00850913          	addi	s2,a0,8
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	9e2080e7          	jalr	-1566(ra) # 800062ae <acquire>
  while (lk->locked) {
    800038d4:	409c                	lw	a5,0(s1)
    800038d6:	cb89                	beqz	a5,800038e8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d8:	85ca                	mv	a1,s2
    800038da:	8526                	mv	a0,s1
    800038dc:	ffffe097          	auipc	ra,0xffffe
    800038e0:	c60080e7          	jalr	-928(ra) # 8000153c <sleep>
  while (lk->locked) {
    800038e4:	409c                	lw	a5,0(s1)
    800038e6:	fbed                	bnez	a5,800038d8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e8:	4785                	li	a5,1
    800038ea:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ec:	ffffd097          	auipc	ra,0xffffd
    800038f0:	56c080e7          	jalr	1388(ra) # 80000e58 <myproc>
    800038f4:	591c                	lw	a5,48(a0)
    800038f6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038f8:	854a                	mv	a0,s2
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	a68080e7          	jalr	-1432(ra) # 80006362 <release>
}
    80003902:	60e2                	ld	ra,24(sp)
    80003904:	6442                	ld	s0,16(sp)
    80003906:	64a2                	ld	s1,8(sp)
    80003908:	6902                	ld	s2,0(sp)
    8000390a:	6105                	addi	sp,sp,32
    8000390c:	8082                	ret

000000008000390e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000390e:	1101                	addi	sp,sp,-32
    80003910:	ec06                	sd	ra,24(sp)
    80003912:	e822                	sd	s0,16(sp)
    80003914:	e426                	sd	s1,8(sp)
    80003916:	e04a                	sd	s2,0(sp)
    80003918:	1000                	addi	s0,sp,32
    8000391a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000391c:	00850913          	addi	s2,a0,8
    80003920:	854a                	mv	a0,s2
    80003922:	00003097          	auipc	ra,0x3
    80003926:	98c080e7          	jalr	-1652(ra) # 800062ae <acquire>
  lk->locked = 0;
    8000392a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000392e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003932:	8526                	mv	a0,s1
    80003934:	ffffe097          	auipc	ra,0xffffe
    80003938:	c6c080e7          	jalr	-916(ra) # 800015a0 <wakeup>
  release(&lk->lk);
    8000393c:	854a                	mv	a0,s2
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	a24080e7          	jalr	-1500(ra) # 80006362 <release>
}
    80003946:	60e2                	ld	ra,24(sp)
    80003948:	6442                	ld	s0,16(sp)
    8000394a:	64a2                	ld	s1,8(sp)
    8000394c:	6902                	ld	s2,0(sp)
    8000394e:	6105                	addi	sp,sp,32
    80003950:	8082                	ret

0000000080003952 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003952:	7179                	addi	sp,sp,-48
    80003954:	f406                	sd	ra,40(sp)
    80003956:	f022                	sd	s0,32(sp)
    80003958:	ec26                	sd	s1,24(sp)
    8000395a:	e84a                	sd	s2,16(sp)
    8000395c:	e44e                	sd	s3,8(sp)
    8000395e:	1800                	addi	s0,sp,48
    80003960:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003962:	00850913          	addi	s2,a0,8
    80003966:	854a                	mv	a0,s2
    80003968:	00003097          	auipc	ra,0x3
    8000396c:	946080e7          	jalr	-1722(ra) # 800062ae <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003970:	409c                	lw	a5,0(s1)
    80003972:	ef99                	bnez	a5,80003990 <holdingsleep+0x3e>
    80003974:	4481                	li	s1,0
  release(&lk->lk);
    80003976:	854a                	mv	a0,s2
    80003978:	00003097          	auipc	ra,0x3
    8000397c:	9ea080e7          	jalr	-1558(ra) # 80006362 <release>
  return r;
}
    80003980:	8526                	mv	a0,s1
    80003982:	70a2                	ld	ra,40(sp)
    80003984:	7402                	ld	s0,32(sp)
    80003986:	64e2                	ld	s1,24(sp)
    80003988:	6942                	ld	s2,16(sp)
    8000398a:	69a2                	ld	s3,8(sp)
    8000398c:	6145                	addi	sp,sp,48
    8000398e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003990:	0284a983          	lw	s3,40(s1)
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	4c4080e7          	jalr	1220(ra) # 80000e58 <myproc>
    8000399c:	5904                	lw	s1,48(a0)
    8000399e:	413484b3          	sub	s1,s1,s3
    800039a2:	0014b493          	seqz	s1,s1
    800039a6:	bfc1                	j	80003976 <holdingsleep+0x24>

00000000800039a8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039a8:	1141                	addi	sp,sp,-16
    800039aa:	e406                	sd	ra,8(sp)
    800039ac:	e022                	sd	s0,0(sp)
    800039ae:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039b0:	00005597          	auipc	a1,0x5
    800039b4:	c6858593          	addi	a1,a1,-920 # 80008618 <syscalls+0x248>
    800039b8:	00016517          	auipc	a0,0x16
    800039bc:	a7050513          	addi	a0,a0,-1424 # 80019428 <ftable>
    800039c0:	00003097          	auipc	ra,0x3
    800039c4:	85e080e7          	jalr	-1954(ra) # 8000621e <initlock>
}
    800039c8:	60a2                	ld	ra,8(sp)
    800039ca:	6402                	ld	s0,0(sp)
    800039cc:	0141                	addi	sp,sp,16
    800039ce:	8082                	ret

00000000800039d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039d0:	1101                	addi	sp,sp,-32
    800039d2:	ec06                	sd	ra,24(sp)
    800039d4:	e822                	sd	s0,16(sp)
    800039d6:	e426                	sd	s1,8(sp)
    800039d8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039da:	00016517          	auipc	a0,0x16
    800039de:	a4e50513          	addi	a0,a0,-1458 # 80019428 <ftable>
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	8cc080e7          	jalr	-1844(ra) # 800062ae <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ea:	00016497          	auipc	s1,0x16
    800039ee:	a5648493          	addi	s1,s1,-1450 # 80019440 <ftable+0x18>
    800039f2:	00017717          	auipc	a4,0x17
    800039f6:	9ee70713          	addi	a4,a4,-1554 # 8001a3e0 <disk>
    if(f->ref == 0){
    800039fa:	40dc                	lw	a5,4(s1)
    800039fc:	cf99                	beqz	a5,80003a1a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039fe:	02848493          	addi	s1,s1,40
    80003a02:	fee49ce3          	bne	s1,a4,800039fa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a06:	00016517          	auipc	a0,0x16
    80003a0a:	a2250513          	addi	a0,a0,-1502 # 80019428 <ftable>
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	954080e7          	jalr	-1708(ra) # 80006362 <release>
  return 0;
    80003a16:	4481                	li	s1,0
    80003a18:	a819                	j	80003a2e <filealloc+0x5e>
      f->ref = 1;
    80003a1a:	4785                	li	a5,1
    80003a1c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a1e:	00016517          	auipc	a0,0x16
    80003a22:	a0a50513          	addi	a0,a0,-1526 # 80019428 <ftable>
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	93c080e7          	jalr	-1732(ra) # 80006362 <release>
}
    80003a2e:	8526                	mv	a0,s1
    80003a30:	60e2                	ld	ra,24(sp)
    80003a32:	6442                	ld	s0,16(sp)
    80003a34:	64a2                	ld	s1,8(sp)
    80003a36:	6105                	addi	sp,sp,32
    80003a38:	8082                	ret

0000000080003a3a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a3a:	1101                	addi	sp,sp,-32
    80003a3c:	ec06                	sd	ra,24(sp)
    80003a3e:	e822                	sd	s0,16(sp)
    80003a40:	e426                	sd	s1,8(sp)
    80003a42:	1000                	addi	s0,sp,32
    80003a44:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a46:	00016517          	auipc	a0,0x16
    80003a4a:	9e250513          	addi	a0,a0,-1566 # 80019428 <ftable>
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	860080e7          	jalr	-1952(ra) # 800062ae <acquire>
  if(f->ref < 1)
    80003a56:	40dc                	lw	a5,4(s1)
    80003a58:	02f05263          	blez	a5,80003a7c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a5c:	2785                	addiw	a5,a5,1
    80003a5e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a60:	00016517          	auipc	a0,0x16
    80003a64:	9c850513          	addi	a0,a0,-1592 # 80019428 <ftable>
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	8fa080e7          	jalr	-1798(ra) # 80006362 <release>
  return f;
}
    80003a70:	8526                	mv	a0,s1
    80003a72:	60e2                	ld	ra,24(sp)
    80003a74:	6442                	ld	s0,16(sp)
    80003a76:	64a2                	ld	s1,8(sp)
    80003a78:	6105                	addi	sp,sp,32
    80003a7a:	8082                	ret
    panic("filedup");
    80003a7c:	00005517          	auipc	a0,0x5
    80003a80:	ba450513          	addi	a0,a0,-1116 # 80008620 <syscalls+0x250>
    80003a84:	00002097          	auipc	ra,0x2
    80003a88:	30a080e7          	jalr	778(ra) # 80005d8e <panic>

0000000080003a8c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a8c:	7139                	addi	sp,sp,-64
    80003a8e:	fc06                	sd	ra,56(sp)
    80003a90:	f822                	sd	s0,48(sp)
    80003a92:	f426                	sd	s1,40(sp)
    80003a94:	f04a                	sd	s2,32(sp)
    80003a96:	ec4e                	sd	s3,24(sp)
    80003a98:	e852                	sd	s4,16(sp)
    80003a9a:	e456                	sd	s5,8(sp)
    80003a9c:	0080                	addi	s0,sp,64
    80003a9e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aa0:	00016517          	auipc	a0,0x16
    80003aa4:	98850513          	addi	a0,a0,-1656 # 80019428 <ftable>
    80003aa8:	00003097          	auipc	ra,0x3
    80003aac:	806080e7          	jalr	-2042(ra) # 800062ae <acquire>
  if(f->ref < 1)
    80003ab0:	40dc                	lw	a5,4(s1)
    80003ab2:	06f05163          	blez	a5,80003b14 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ab6:	37fd                	addiw	a5,a5,-1
    80003ab8:	0007871b          	sext.w	a4,a5
    80003abc:	c0dc                	sw	a5,4(s1)
    80003abe:	06e04363          	bgtz	a4,80003b24 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ac2:	0004a903          	lw	s2,0(s1)
    80003ac6:	0094ca83          	lbu	s5,9(s1)
    80003aca:	0104ba03          	ld	s4,16(s1)
    80003ace:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ad2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ad6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ada:	00016517          	auipc	a0,0x16
    80003ade:	94e50513          	addi	a0,a0,-1714 # 80019428 <ftable>
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	880080e7          	jalr	-1920(ra) # 80006362 <release>

  if(ff.type == FD_PIPE){
    80003aea:	4785                	li	a5,1
    80003aec:	04f90d63          	beq	s2,a5,80003b46 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003af0:	3979                	addiw	s2,s2,-2
    80003af2:	4785                	li	a5,1
    80003af4:	0527e063          	bltu	a5,s2,80003b34 <fileclose+0xa8>
    begin_op();
    80003af8:	00000097          	auipc	ra,0x0
    80003afc:	ac8080e7          	jalr	-1336(ra) # 800035c0 <begin_op>
    iput(ff.ip);
    80003b00:	854e                	mv	a0,s3
    80003b02:	fffff097          	auipc	ra,0xfffff
    80003b06:	2b6080e7          	jalr	694(ra) # 80002db8 <iput>
    end_op();
    80003b0a:	00000097          	auipc	ra,0x0
    80003b0e:	b36080e7          	jalr	-1226(ra) # 80003640 <end_op>
    80003b12:	a00d                	j	80003b34 <fileclose+0xa8>
    panic("fileclose");
    80003b14:	00005517          	auipc	a0,0x5
    80003b18:	b1450513          	addi	a0,a0,-1260 # 80008628 <syscalls+0x258>
    80003b1c:	00002097          	auipc	ra,0x2
    80003b20:	272080e7          	jalr	626(ra) # 80005d8e <panic>
    release(&ftable.lock);
    80003b24:	00016517          	auipc	a0,0x16
    80003b28:	90450513          	addi	a0,a0,-1788 # 80019428 <ftable>
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	836080e7          	jalr	-1994(ra) # 80006362 <release>
  }
}
    80003b34:	70e2                	ld	ra,56(sp)
    80003b36:	7442                	ld	s0,48(sp)
    80003b38:	74a2                	ld	s1,40(sp)
    80003b3a:	7902                	ld	s2,32(sp)
    80003b3c:	69e2                	ld	s3,24(sp)
    80003b3e:	6a42                	ld	s4,16(sp)
    80003b40:	6aa2                	ld	s5,8(sp)
    80003b42:	6121                	addi	sp,sp,64
    80003b44:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b46:	85d6                	mv	a1,s5
    80003b48:	8552                	mv	a0,s4
    80003b4a:	00000097          	auipc	ra,0x0
    80003b4e:	34c080e7          	jalr	844(ra) # 80003e96 <pipeclose>
    80003b52:	b7cd                	j	80003b34 <fileclose+0xa8>

0000000080003b54 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b54:	715d                	addi	sp,sp,-80
    80003b56:	e486                	sd	ra,72(sp)
    80003b58:	e0a2                	sd	s0,64(sp)
    80003b5a:	fc26                	sd	s1,56(sp)
    80003b5c:	f84a                	sd	s2,48(sp)
    80003b5e:	f44e                	sd	s3,40(sp)
    80003b60:	0880                	addi	s0,sp,80
    80003b62:	84aa                	mv	s1,a0
    80003b64:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b66:	ffffd097          	auipc	ra,0xffffd
    80003b6a:	2f2080e7          	jalr	754(ra) # 80000e58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b6e:	409c                	lw	a5,0(s1)
    80003b70:	37f9                	addiw	a5,a5,-2
    80003b72:	4705                	li	a4,1
    80003b74:	04f76763          	bltu	a4,a5,80003bc2 <filestat+0x6e>
    80003b78:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b7a:	6c88                	ld	a0,24(s1)
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	082080e7          	jalr	130(ra) # 80002bfe <ilock>
    stati(f->ip, &st);
    80003b84:	fb840593          	addi	a1,s0,-72
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	2fe080e7          	jalr	766(ra) # 80002e88 <stati>
    iunlock(f->ip);
    80003b92:	6c88                	ld	a0,24(s1)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	12c080e7          	jalr	300(ra) # 80002cc0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b9c:	46e1                	li	a3,24
    80003b9e:	fb840613          	addi	a2,s0,-72
    80003ba2:	85ce                	mv	a1,s3
    80003ba4:	05093503          	ld	a0,80(s2)
    80003ba8:	ffffd097          	auipc	ra,0xffffd
    80003bac:	f6e080e7          	jalr	-146(ra) # 80000b16 <copyout>
    80003bb0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bb4:	60a6                	ld	ra,72(sp)
    80003bb6:	6406                	ld	s0,64(sp)
    80003bb8:	74e2                	ld	s1,56(sp)
    80003bba:	7942                	ld	s2,48(sp)
    80003bbc:	79a2                	ld	s3,40(sp)
    80003bbe:	6161                	addi	sp,sp,80
    80003bc0:	8082                	ret
  return -1;
    80003bc2:	557d                	li	a0,-1
    80003bc4:	bfc5                	j	80003bb4 <filestat+0x60>

0000000080003bc6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bc6:	7179                	addi	sp,sp,-48
    80003bc8:	f406                	sd	ra,40(sp)
    80003bca:	f022                	sd	s0,32(sp)
    80003bcc:	ec26                	sd	s1,24(sp)
    80003bce:	e84a                	sd	s2,16(sp)
    80003bd0:	e44e                	sd	s3,8(sp)
    80003bd2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bd4:	00854783          	lbu	a5,8(a0)
    80003bd8:	c3d5                	beqz	a5,80003c7c <fileread+0xb6>
    80003bda:	84aa                	mv	s1,a0
    80003bdc:	89ae                	mv	s3,a1
    80003bde:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003be0:	411c                	lw	a5,0(a0)
    80003be2:	4705                	li	a4,1
    80003be4:	04e78963          	beq	a5,a4,80003c36 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be8:	470d                	li	a4,3
    80003bea:	04e78d63          	beq	a5,a4,80003c44 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bee:	4709                	li	a4,2
    80003bf0:	06e79e63          	bne	a5,a4,80003c6c <fileread+0xa6>
    ilock(f->ip);
    80003bf4:	6d08                	ld	a0,24(a0)
    80003bf6:	fffff097          	auipc	ra,0xfffff
    80003bfa:	008080e7          	jalr	8(ra) # 80002bfe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bfe:	874a                	mv	a4,s2
    80003c00:	5094                	lw	a3,32(s1)
    80003c02:	864e                	mv	a2,s3
    80003c04:	4585                	li	a1,1
    80003c06:	6c88                	ld	a0,24(s1)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	2aa080e7          	jalr	682(ra) # 80002eb2 <readi>
    80003c10:	892a                	mv	s2,a0
    80003c12:	00a05563          	blez	a0,80003c1c <fileread+0x56>
      f->off += r;
    80003c16:	509c                	lw	a5,32(s1)
    80003c18:	9fa9                	addw	a5,a5,a0
    80003c1a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c1c:	6c88                	ld	a0,24(s1)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	0a2080e7          	jalr	162(ra) # 80002cc0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c26:	854a                	mv	a0,s2
    80003c28:	70a2                	ld	ra,40(sp)
    80003c2a:	7402                	ld	s0,32(sp)
    80003c2c:	64e2                	ld	s1,24(sp)
    80003c2e:	6942                	ld	s2,16(sp)
    80003c30:	69a2                	ld	s3,8(sp)
    80003c32:	6145                	addi	sp,sp,48
    80003c34:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c36:	6908                	ld	a0,16(a0)
    80003c38:	00000097          	auipc	ra,0x0
    80003c3c:	3ce080e7          	jalr	974(ra) # 80004006 <piperead>
    80003c40:	892a                	mv	s2,a0
    80003c42:	b7d5                	j	80003c26 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c44:	02451783          	lh	a5,36(a0)
    80003c48:	03079693          	slli	a3,a5,0x30
    80003c4c:	92c1                	srli	a3,a3,0x30
    80003c4e:	4725                	li	a4,9
    80003c50:	02d76863          	bltu	a4,a3,80003c80 <fileread+0xba>
    80003c54:	0792                	slli	a5,a5,0x4
    80003c56:	00015717          	auipc	a4,0x15
    80003c5a:	73270713          	addi	a4,a4,1842 # 80019388 <devsw>
    80003c5e:	97ba                	add	a5,a5,a4
    80003c60:	639c                	ld	a5,0(a5)
    80003c62:	c38d                	beqz	a5,80003c84 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c64:	4505                	li	a0,1
    80003c66:	9782                	jalr	a5
    80003c68:	892a                	mv	s2,a0
    80003c6a:	bf75                	j	80003c26 <fileread+0x60>
    panic("fileread");
    80003c6c:	00005517          	auipc	a0,0x5
    80003c70:	9cc50513          	addi	a0,a0,-1588 # 80008638 <syscalls+0x268>
    80003c74:	00002097          	auipc	ra,0x2
    80003c78:	11a080e7          	jalr	282(ra) # 80005d8e <panic>
    return -1;
    80003c7c:	597d                	li	s2,-1
    80003c7e:	b765                	j	80003c26 <fileread+0x60>
      return -1;
    80003c80:	597d                	li	s2,-1
    80003c82:	b755                	j	80003c26 <fileread+0x60>
    80003c84:	597d                	li	s2,-1
    80003c86:	b745                	j	80003c26 <fileread+0x60>

0000000080003c88 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c88:	715d                	addi	sp,sp,-80
    80003c8a:	e486                	sd	ra,72(sp)
    80003c8c:	e0a2                	sd	s0,64(sp)
    80003c8e:	fc26                	sd	s1,56(sp)
    80003c90:	f84a                	sd	s2,48(sp)
    80003c92:	f44e                	sd	s3,40(sp)
    80003c94:	f052                	sd	s4,32(sp)
    80003c96:	ec56                	sd	s5,24(sp)
    80003c98:	e85a                	sd	s6,16(sp)
    80003c9a:	e45e                	sd	s7,8(sp)
    80003c9c:	e062                	sd	s8,0(sp)
    80003c9e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ca0:	00954783          	lbu	a5,9(a0)
    80003ca4:	10078663          	beqz	a5,80003db0 <filewrite+0x128>
    80003ca8:	892a                	mv	s2,a0
    80003caa:	8aae                	mv	s5,a1
    80003cac:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cae:	411c                	lw	a5,0(a0)
    80003cb0:	4705                	li	a4,1
    80003cb2:	02e78263          	beq	a5,a4,80003cd6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb6:	470d                	li	a4,3
    80003cb8:	02e78663          	beq	a5,a4,80003ce4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cbc:	4709                	li	a4,2
    80003cbe:	0ee79163          	bne	a5,a4,80003da0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cc2:	0ac05d63          	blez	a2,80003d7c <filewrite+0xf4>
    int i = 0;
    80003cc6:	4981                	li	s3,0
    80003cc8:	6b05                	lui	s6,0x1
    80003cca:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cce:	6b85                	lui	s7,0x1
    80003cd0:	c00b8b9b          	addiw	s7,s7,-1024
    80003cd4:	a861                	j	80003d6c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cd6:	6908                	ld	a0,16(a0)
    80003cd8:	00000097          	auipc	ra,0x0
    80003cdc:	22e080e7          	jalr	558(ra) # 80003f06 <pipewrite>
    80003ce0:	8a2a                	mv	s4,a0
    80003ce2:	a045                	j	80003d82 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce4:	02451783          	lh	a5,36(a0)
    80003ce8:	03079693          	slli	a3,a5,0x30
    80003cec:	92c1                	srli	a3,a3,0x30
    80003cee:	4725                	li	a4,9
    80003cf0:	0cd76263          	bltu	a4,a3,80003db4 <filewrite+0x12c>
    80003cf4:	0792                	slli	a5,a5,0x4
    80003cf6:	00015717          	auipc	a4,0x15
    80003cfa:	69270713          	addi	a4,a4,1682 # 80019388 <devsw>
    80003cfe:	97ba                	add	a5,a5,a4
    80003d00:	679c                	ld	a5,8(a5)
    80003d02:	cbdd                	beqz	a5,80003db8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d04:	4505                	li	a0,1
    80003d06:	9782                	jalr	a5
    80003d08:	8a2a                	mv	s4,a0
    80003d0a:	a8a5                	j	80003d82 <filewrite+0xfa>
    80003d0c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d10:	00000097          	auipc	ra,0x0
    80003d14:	8b0080e7          	jalr	-1872(ra) # 800035c0 <begin_op>
      ilock(f->ip);
    80003d18:	01893503          	ld	a0,24(s2)
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	ee2080e7          	jalr	-286(ra) # 80002bfe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d24:	8762                	mv	a4,s8
    80003d26:	02092683          	lw	a3,32(s2)
    80003d2a:	01598633          	add	a2,s3,s5
    80003d2e:	4585                	li	a1,1
    80003d30:	01893503          	ld	a0,24(s2)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	276080e7          	jalr	630(ra) # 80002faa <writei>
    80003d3c:	84aa                	mv	s1,a0
    80003d3e:	00a05763          	blez	a0,80003d4c <filewrite+0xc4>
        f->off += r;
    80003d42:	02092783          	lw	a5,32(s2)
    80003d46:	9fa9                	addw	a5,a5,a0
    80003d48:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d4c:	01893503          	ld	a0,24(s2)
    80003d50:	fffff097          	auipc	ra,0xfffff
    80003d54:	f70080e7          	jalr	-144(ra) # 80002cc0 <iunlock>
      end_op();
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	8e8080e7          	jalr	-1816(ra) # 80003640 <end_op>

      if(r != n1){
    80003d60:	009c1f63          	bne	s8,s1,80003d7e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d64:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d68:	0149db63          	bge	s3,s4,80003d7e <filewrite+0xf6>
      int n1 = n - i;
    80003d6c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d70:	84be                	mv	s1,a5
    80003d72:	2781                	sext.w	a5,a5
    80003d74:	f8fb5ce3          	bge	s6,a5,80003d0c <filewrite+0x84>
    80003d78:	84de                	mv	s1,s7
    80003d7a:	bf49                	j	80003d0c <filewrite+0x84>
    int i = 0;
    80003d7c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d7e:	013a1f63          	bne	s4,s3,80003d9c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d82:	8552                	mv	a0,s4
    80003d84:	60a6                	ld	ra,72(sp)
    80003d86:	6406                	ld	s0,64(sp)
    80003d88:	74e2                	ld	s1,56(sp)
    80003d8a:	7942                	ld	s2,48(sp)
    80003d8c:	79a2                	ld	s3,40(sp)
    80003d8e:	7a02                	ld	s4,32(sp)
    80003d90:	6ae2                	ld	s5,24(sp)
    80003d92:	6b42                	ld	s6,16(sp)
    80003d94:	6ba2                	ld	s7,8(sp)
    80003d96:	6c02                	ld	s8,0(sp)
    80003d98:	6161                	addi	sp,sp,80
    80003d9a:	8082                	ret
    ret = (i == n ? n : -1);
    80003d9c:	5a7d                	li	s4,-1
    80003d9e:	b7d5                	j	80003d82 <filewrite+0xfa>
    panic("filewrite");
    80003da0:	00005517          	auipc	a0,0x5
    80003da4:	8a850513          	addi	a0,a0,-1880 # 80008648 <syscalls+0x278>
    80003da8:	00002097          	auipc	ra,0x2
    80003dac:	fe6080e7          	jalr	-26(ra) # 80005d8e <panic>
    return -1;
    80003db0:	5a7d                	li	s4,-1
    80003db2:	bfc1                	j	80003d82 <filewrite+0xfa>
      return -1;
    80003db4:	5a7d                	li	s4,-1
    80003db6:	b7f1                	j	80003d82 <filewrite+0xfa>
    80003db8:	5a7d                	li	s4,-1
    80003dba:	b7e1                	j	80003d82 <filewrite+0xfa>

0000000080003dbc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dbc:	7179                	addi	sp,sp,-48
    80003dbe:	f406                	sd	ra,40(sp)
    80003dc0:	f022                	sd	s0,32(sp)
    80003dc2:	ec26                	sd	s1,24(sp)
    80003dc4:	e84a                	sd	s2,16(sp)
    80003dc6:	e44e                	sd	s3,8(sp)
    80003dc8:	e052                	sd	s4,0(sp)
    80003dca:	1800                	addi	s0,sp,48
    80003dcc:	84aa                	mv	s1,a0
    80003dce:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dd0:	0005b023          	sd	zero,0(a1)
    80003dd4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	bf8080e7          	jalr	-1032(ra) # 800039d0 <filealloc>
    80003de0:	e088                	sd	a0,0(s1)
    80003de2:	c551                	beqz	a0,80003e6e <pipealloc+0xb2>
    80003de4:	00000097          	auipc	ra,0x0
    80003de8:	bec080e7          	jalr	-1044(ra) # 800039d0 <filealloc>
    80003dec:	00aa3023          	sd	a0,0(s4)
    80003df0:	c92d                	beqz	a0,80003e62 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df2:	ffffc097          	auipc	ra,0xffffc
    80003df6:	326080e7          	jalr	806(ra) # 80000118 <kalloc>
    80003dfa:	892a                	mv	s2,a0
    80003dfc:	c125                	beqz	a0,80003e5c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dfe:	4985                	li	s3,1
    80003e00:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e04:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e08:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e0c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e10:	00005597          	auipc	a1,0x5
    80003e14:	84858593          	addi	a1,a1,-1976 # 80008658 <syscalls+0x288>
    80003e18:	00002097          	auipc	ra,0x2
    80003e1c:	406080e7          	jalr	1030(ra) # 8000621e <initlock>
  (*f0)->type = FD_PIPE;
    80003e20:	609c                	ld	a5,0(s1)
    80003e22:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e26:	609c                	ld	a5,0(s1)
    80003e28:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e2c:	609c                	ld	a5,0(s1)
    80003e2e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e32:	609c                	ld	a5,0(s1)
    80003e34:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e38:	000a3783          	ld	a5,0(s4)
    80003e3c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e40:	000a3783          	ld	a5,0(s4)
    80003e44:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e48:	000a3783          	ld	a5,0(s4)
    80003e4c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e50:	000a3783          	ld	a5,0(s4)
    80003e54:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e58:	4501                	li	a0,0
    80003e5a:	a025                	j	80003e82 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e5c:	6088                	ld	a0,0(s1)
    80003e5e:	e501                	bnez	a0,80003e66 <pipealloc+0xaa>
    80003e60:	a039                	j	80003e6e <pipealloc+0xb2>
    80003e62:	6088                	ld	a0,0(s1)
    80003e64:	c51d                	beqz	a0,80003e92 <pipealloc+0xd6>
    fileclose(*f0);
    80003e66:	00000097          	auipc	ra,0x0
    80003e6a:	c26080e7          	jalr	-986(ra) # 80003a8c <fileclose>
  if(*f1)
    80003e6e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e72:	557d                	li	a0,-1
  if(*f1)
    80003e74:	c799                	beqz	a5,80003e82 <pipealloc+0xc6>
    fileclose(*f1);
    80003e76:	853e                	mv	a0,a5
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	c14080e7          	jalr	-1004(ra) # 80003a8c <fileclose>
  return -1;
    80003e80:	557d                	li	a0,-1
}
    80003e82:	70a2                	ld	ra,40(sp)
    80003e84:	7402                	ld	s0,32(sp)
    80003e86:	64e2                	ld	s1,24(sp)
    80003e88:	6942                	ld	s2,16(sp)
    80003e8a:	69a2                	ld	s3,8(sp)
    80003e8c:	6a02                	ld	s4,0(sp)
    80003e8e:	6145                	addi	sp,sp,48
    80003e90:	8082                	ret
  return -1;
    80003e92:	557d                	li	a0,-1
    80003e94:	b7fd                	j	80003e82 <pipealloc+0xc6>

0000000080003e96 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e96:	1101                	addi	sp,sp,-32
    80003e98:	ec06                	sd	ra,24(sp)
    80003e9a:	e822                	sd	s0,16(sp)
    80003e9c:	e426                	sd	s1,8(sp)
    80003e9e:	e04a                	sd	s2,0(sp)
    80003ea0:	1000                	addi	s0,sp,32
    80003ea2:	84aa                	mv	s1,a0
    80003ea4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ea6:	00002097          	auipc	ra,0x2
    80003eaa:	408080e7          	jalr	1032(ra) # 800062ae <acquire>
  if(writable){
    80003eae:	02090d63          	beqz	s2,80003ee8 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb6:	21848513          	addi	a0,s1,536
    80003eba:	ffffd097          	auipc	ra,0xffffd
    80003ebe:	6e6080e7          	jalr	1766(ra) # 800015a0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec2:	2204b783          	ld	a5,544(s1)
    80003ec6:	eb95                	bnez	a5,80003efa <pipeclose+0x64>
    release(&pi->lock);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	00002097          	auipc	ra,0x2
    80003ece:	498080e7          	jalr	1176(ra) # 80006362 <release>
    kfree((char*)pi);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	ffffc097          	auipc	ra,0xffffc
    80003ed8:	148080e7          	jalr	328(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003edc:	60e2                	ld	ra,24(sp)
    80003ede:	6442                	ld	s0,16(sp)
    80003ee0:	64a2                	ld	s1,8(sp)
    80003ee2:	6902                	ld	s2,0(sp)
    80003ee4:	6105                	addi	sp,sp,32
    80003ee6:	8082                	ret
    pi->readopen = 0;
    80003ee8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eec:	21c48513          	addi	a0,s1,540
    80003ef0:	ffffd097          	auipc	ra,0xffffd
    80003ef4:	6b0080e7          	jalr	1712(ra) # 800015a0 <wakeup>
    80003ef8:	b7e9                	j	80003ec2 <pipeclose+0x2c>
    release(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	466080e7          	jalr	1126(ra) # 80006362 <release>
}
    80003f04:	bfe1                	j	80003edc <pipeclose+0x46>

0000000080003f06 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f06:	7159                	addi	sp,sp,-112
    80003f08:	f486                	sd	ra,104(sp)
    80003f0a:	f0a2                	sd	s0,96(sp)
    80003f0c:	eca6                	sd	s1,88(sp)
    80003f0e:	e8ca                	sd	s2,80(sp)
    80003f10:	e4ce                	sd	s3,72(sp)
    80003f12:	e0d2                	sd	s4,64(sp)
    80003f14:	fc56                	sd	s5,56(sp)
    80003f16:	f85a                	sd	s6,48(sp)
    80003f18:	f45e                	sd	s7,40(sp)
    80003f1a:	f062                	sd	s8,32(sp)
    80003f1c:	ec66                	sd	s9,24(sp)
    80003f1e:	1880                	addi	s0,sp,112
    80003f20:	84aa                	mv	s1,a0
    80003f22:	8aae                	mv	s5,a1
    80003f24:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	f32080e7          	jalr	-206(ra) # 80000e58 <myproc>
    80003f2e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	37c080e7          	jalr	892(ra) # 800062ae <acquire>
  while(i < n){
    80003f3a:	0d405463          	blez	s4,80004002 <pipewrite+0xfc>
    80003f3e:	8ba6                	mv	s7,s1
  int i = 0;
    80003f40:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f42:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f44:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f48:	21c48c13          	addi	s8,s1,540
    80003f4c:	a08d                	j	80003fae <pipewrite+0xa8>
      release(&pi->lock);
    80003f4e:	8526                	mv	a0,s1
    80003f50:	00002097          	auipc	ra,0x2
    80003f54:	412080e7          	jalr	1042(ra) # 80006362 <release>
      return -1;
    80003f58:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f5a:	854a                	mv	a0,s2
    80003f5c:	70a6                	ld	ra,104(sp)
    80003f5e:	7406                	ld	s0,96(sp)
    80003f60:	64e6                	ld	s1,88(sp)
    80003f62:	6946                	ld	s2,80(sp)
    80003f64:	69a6                	ld	s3,72(sp)
    80003f66:	6a06                	ld	s4,64(sp)
    80003f68:	7ae2                	ld	s5,56(sp)
    80003f6a:	7b42                	ld	s6,48(sp)
    80003f6c:	7ba2                	ld	s7,40(sp)
    80003f6e:	7c02                	ld	s8,32(sp)
    80003f70:	6ce2                	ld	s9,24(sp)
    80003f72:	6165                	addi	sp,sp,112
    80003f74:	8082                	ret
      wakeup(&pi->nread);
    80003f76:	8566                	mv	a0,s9
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	628080e7          	jalr	1576(ra) # 800015a0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f80:	85de                	mv	a1,s7
    80003f82:	8562                	mv	a0,s8
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	5b8080e7          	jalr	1464(ra) # 8000153c <sleep>
    80003f8c:	a839                	j	80003faa <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f8e:	21c4a783          	lw	a5,540(s1)
    80003f92:	0017871b          	addiw	a4,a5,1
    80003f96:	20e4ae23          	sw	a4,540(s1)
    80003f9a:	1ff7f793          	andi	a5,a5,511
    80003f9e:	97a6                	add	a5,a5,s1
    80003fa0:	f9f44703          	lbu	a4,-97(s0)
    80003fa4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fa8:	2905                	addiw	s2,s2,1
  while(i < n){
    80003faa:	05495063          	bge	s2,s4,80003fea <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003fae:	2204a783          	lw	a5,544(s1)
    80003fb2:	dfd1                	beqz	a5,80003f4e <pipewrite+0x48>
    80003fb4:	854e                	mv	a0,s3
    80003fb6:	ffffe097          	auipc	ra,0xffffe
    80003fba:	82e080e7          	jalr	-2002(ra) # 800017e4 <killed>
    80003fbe:	f941                	bnez	a0,80003f4e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fc0:	2184a783          	lw	a5,536(s1)
    80003fc4:	21c4a703          	lw	a4,540(s1)
    80003fc8:	2007879b          	addiw	a5,a5,512
    80003fcc:	faf705e3          	beq	a4,a5,80003f76 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd0:	4685                	li	a3,1
    80003fd2:	01590633          	add	a2,s2,s5
    80003fd6:	f9f40593          	addi	a1,s0,-97
    80003fda:	0509b503          	ld	a0,80(s3)
    80003fde:	ffffd097          	auipc	ra,0xffffd
    80003fe2:	bc4080e7          	jalr	-1084(ra) # 80000ba2 <copyin>
    80003fe6:	fb6514e3          	bne	a0,s6,80003f8e <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fea:	21848513          	addi	a0,s1,536
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	5b2080e7          	jalr	1458(ra) # 800015a0 <wakeup>
  release(&pi->lock);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	00002097          	auipc	ra,0x2
    80003ffc:	36a080e7          	jalr	874(ra) # 80006362 <release>
  return i;
    80004000:	bfa9                	j	80003f5a <pipewrite+0x54>
  int i = 0;
    80004002:	4901                	li	s2,0
    80004004:	b7dd                	j	80003fea <pipewrite+0xe4>

0000000080004006 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004006:	715d                	addi	sp,sp,-80
    80004008:	e486                	sd	ra,72(sp)
    8000400a:	e0a2                	sd	s0,64(sp)
    8000400c:	fc26                	sd	s1,56(sp)
    8000400e:	f84a                	sd	s2,48(sp)
    80004010:	f44e                	sd	s3,40(sp)
    80004012:	f052                	sd	s4,32(sp)
    80004014:	ec56                	sd	s5,24(sp)
    80004016:	e85a                	sd	s6,16(sp)
    80004018:	0880                	addi	s0,sp,80
    8000401a:	84aa                	mv	s1,a0
    8000401c:	892e                	mv	s2,a1
    8000401e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	e38080e7          	jalr	-456(ra) # 80000e58 <myproc>
    80004028:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000402a:	8b26                	mv	s6,s1
    8000402c:	8526                	mv	a0,s1
    8000402e:	00002097          	auipc	ra,0x2
    80004032:	280080e7          	jalr	640(ra) # 800062ae <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004036:	2184a703          	lw	a4,536(s1)
    8000403a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000403e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004042:	02f71763          	bne	a4,a5,80004070 <piperead+0x6a>
    80004046:	2244a783          	lw	a5,548(s1)
    8000404a:	c39d                	beqz	a5,80004070 <piperead+0x6a>
    if(killed(pr)){
    8000404c:	8552                	mv	a0,s4
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	796080e7          	jalr	1942(ra) # 800017e4 <killed>
    80004056:	e941                	bnez	a0,800040e6 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004058:	85da                	mv	a1,s6
    8000405a:	854e                	mv	a0,s3
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	4e0080e7          	jalr	1248(ra) # 8000153c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004064:	2184a703          	lw	a4,536(s1)
    80004068:	21c4a783          	lw	a5,540(s1)
    8000406c:	fcf70de3          	beq	a4,a5,80004046 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004070:	09505263          	blez	s5,800040f4 <piperead+0xee>
    80004074:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004076:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004078:	2184a783          	lw	a5,536(s1)
    8000407c:	21c4a703          	lw	a4,540(s1)
    80004080:	02f70d63          	beq	a4,a5,800040ba <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004084:	0017871b          	addiw	a4,a5,1
    80004088:	20e4ac23          	sw	a4,536(s1)
    8000408c:	1ff7f793          	andi	a5,a5,511
    80004090:	97a6                	add	a5,a5,s1
    80004092:	0187c783          	lbu	a5,24(a5)
    80004096:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000409a:	4685                	li	a3,1
    8000409c:	fbf40613          	addi	a2,s0,-65
    800040a0:	85ca                	mv	a1,s2
    800040a2:	050a3503          	ld	a0,80(s4)
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	a70080e7          	jalr	-1424(ra) # 80000b16 <copyout>
    800040ae:	01650663          	beq	a0,s6,800040ba <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b2:	2985                	addiw	s3,s3,1
    800040b4:	0905                	addi	s2,s2,1
    800040b6:	fd3a91e3          	bne	s5,s3,80004078 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ba:	21c48513          	addi	a0,s1,540
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	4e2080e7          	jalr	1250(ra) # 800015a0 <wakeup>
  release(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	29a080e7          	jalr	666(ra) # 80006362 <release>
  return i;
}
    800040d0:	854e                	mv	a0,s3
    800040d2:	60a6                	ld	ra,72(sp)
    800040d4:	6406                	ld	s0,64(sp)
    800040d6:	74e2                	ld	s1,56(sp)
    800040d8:	7942                	ld	s2,48(sp)
    800040da:	79a2                	ld	s3,40(sp)
    800040dc:	7a02                	ld	s4,32(sp)
    800040de:	6ae2                	ld	s5,24(sp)
    800040e0:	6b42                	ld	s6,16(sp)
    800040e2:	6161                	addi	sp,sp,80
    800040e4:	8082                	ret
      release(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	27a080e7          	jalr	634(ra) # 80006362 <release>
      return -1;
    800040f0:	59fd                	li	s3,-1
    800040f2:	bff9                	j	800040d0 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f4:	4981                	li	s3,0
    800040f6:	b7d1                	j	800040ba <piperead+0xb4>

00000000800040f8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040f8:	1141                	addi	sp,sp,-16
    800040fa:	e422                	sd	s0,8(sp)
    800040fc:	0800                	addi	s0,sp,16
    800040fe:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004100:	8905                	andi	a0,a0,1
    80004102:	c111                	beqz	a0,80004106 <flags2perm+0xe>
      perm = PTE_X;
    80004104:	4521                	li	a0,8
    if(flags & 0x2)
    80004106:	8b89                	andi	a5,a5,2
    80004108:	c399                	beqz	a5,8000410e <flags2perm+0x16>
      perm |= PTE_W;
    8000410a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000410e:	6422                	ld	s0,8(sp)
    80004110:	0141                	addi	sp,sp,16
    80004112:	8082                	ret

0000000080004114 <exec>:

int
exec(char *path, char **argv)
{
    80004114:	df010113          	addi	sp,sp,-528
    80004118:	20113423          	sd	ra,520(sp)
    8000411c:	20813023          	sd	s0,512(sp)
    80004120:	ffa6                	sd	s1,504(sp)
    80004122:	fbca                	sd	s2,496(sp)
    80004124:	f7ce                	sd	s3,488(sp)
    80004126:	f3d2                	sd	s4,480(sp)
    80004128:	efd6                	sd	s5,472(sp)
    8000412a:	ebda                	sd	s6,464(sp)
    8000412c:	e7de                	sd	s7,456(sp)
    8000412e:	e3e2                	sd	s8,448(sp)
    80004130:	ff66                	sd	s9,440(sp)
    80004132:	fb6a                	sd	s10,432(sp)
    80004134:	f76e                	sd	s11,424(sp)
    80004136:	0c00                	addi	s0,sp,528
    80004138:	84aa                	mv	s1,a0
    8000413a:	dea43c23          	sd	a0,-520(s0)
    8000413e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004142:	ffffd097          	auipc	ra,0xffffd
    80004146:	d16080e7          	jalr	-746(ra) # 80000e58 <myproc>
    8000414a:	892a                	mv	s2,a0

  begin_op();
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	474080e7          	jalr	1140(ra) # 800035c0 <begin_op>

  if((ip = namei(path)) == 0){
    80004154:	8526                	mv	a0,s1
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	24e080e7          	jalr	590(ra) # 800033a4 <namei>
    8000415e:	c92d                	beqz	a0,800041d0 <exec+0xbc>
    80004160:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	a9c080e7          	jalr	-1380(ra) # 80002bfe <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000416a:	04000713          	li	a4,64
    8000416e:	4681                	li	a3,0
    80004170:	e5040613          	addi	a2,s0,-432
    80004174:	4581                	li	a1,0
    80004176:	8526                	mv	a0,s1
    80004178:	fffff097          	auipc	ra,0xfffff
    8000417c:	d3a080e7          	jalr	-710(ra) # 80002eb2 <readi>
    80004180:	04000793          	li	a5,64
    80004184:	00f51a63          	bne	a0,a5,80004198 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004188:	e5042703          	lw	a4,-432(s0)
    8000418c:	464c47b7          	lui	a5,0x464c4
    80004190:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004194:	04f70463          	beq	a4,a5,800041dc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004198:	8526                	mv	a0,s1
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	cc6080e7          	jalr	-826(ra) # 80002e60 <iunlockput>
    end_op();
    800041a2:	fffff097          	auipc	ra,0xfffff
    800041a6:	49e080e7          	jalr	1182(ra) # 80003640 <end_op>
  }
  return -1;
    800041aa:	557d                	li	a0,-1
}
    800041ac:	20813083          	ld	ra,520(sp)
    800041b0:	20013403          	ld	s0,512(sp)
    800041b4:	74fe                	ld	s1,504(sp)
    800041b6:	795e                	ld	s2,496(sp)
    800041b8:	79be                	ld	s3,488(sp)
    800041ba:	7a1e                	ld	s4,480(sp)
    800041bc:	6afe                	ld	s5,472(sp)
    800041be:	6b5e                	ld	s6,464(sp)
    800041c0:	6bbe                	ld	s7,456(sp)
    800041c2:	6c1e                	ld	s8,448(sp)
    800041c4:	7cfa                	ld	s9,440(sp)
    800041c6:	7d5a                	ld	s10,432(sp)
    800041c8:	7dba                	ld	s11,424(sp)
    800041ca:	21010113          	addi	sp,sp,528
    800041ce:	8082                	ret
    end_op();
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	470080e7          	jalr	1136(ra) # 80003640 <end_op>
    return -1;
    800041d8:	557d                	li	a0,-1
    800041da:	bfc9                	j	800041ac <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041dc:	854a                	mv	a0,s2
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	d3e080e7          	jalr	-706(ra) # 80000f1c <proc_pagetable>
    800041e6:	8baa                	mv	s7,a0
    800041e8:	d945                	beqz	a0,80004198 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ea:	e7042983          	lw	s3,-400(s0)
    800041ee:	e8845783          	lhu	a5,-376(s0)
    800041f2:	c7ad                	beqz	a5,8000425c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041f4:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f6:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800041f8:	6c85                	lui	s9,0x1
    800041fa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041fe:	def43823          	sd	a5,-528(s0)
    80004202:	ac0d                	j	80004434 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004204:	00004517          	auipc	a0,0x4
    80004208:	45c50513          	addi	a0,a0,1116 # 80008660 <syscalls+0x290>
    8000420c:	00002097          	auipc	ra,0x2
    80004210:	b82080e7          	jalr	-1150(ra) # 80005d8e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004214:	8756                	mv	a4,s5
    80004216:	012d86bb          	addw	a3,s11,s2
    8000421a:	4581                	li	a1,0
    8000421c:	8526                	mv	a0,s1
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	c94080e7          	jalr	-876(ra) # 80002eb2 <readi>
    80004226:	2501                	sext.w	a0,a0
    80004228:	1aaa9a63          	bne	s5,a0,800043dc <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000422c:	6785                	lui	a5,0x1
    8000422e:	0127893b          	addw	s2,a5,s2
    80004232:	77fd                	lui	a5,0xfffff
    80004234:	01478a3b          	addw	s4,a5,s4
    80004238:	1f897563          	bgeu	s2,s8,80004422 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000423c:	02091593          	slli	a1,s2,0x20
    80004240:	9181                	srli	a1,a1,0x20
    80004242:	95ea                	add	a1,a1,s10
    80004244:	855e                	mv	a0,s7
    80004246:	ffffc097          	auipc	ra,0xffffc
    8000424a:	2c4080e7          	jalr	708(ra) # 8000050a <walkaddr>
    8000424e:	862a                	mv	a2,a0
    if(pa == 0)
    80004250:	d955                	beqz	a0,80004204 <exec+0xf0>
      n = PGSIZE;
    80004252:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004254:	fd9a70e3          	bgeu	s4,s9,80004214 <exec+0x100>
      n = sz - i;
    80004258:	8ad2                	mv	s5,s4
    8000425a:	bf6d                	j	80004214 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000425c:	4a01                	li	s4,0
  iunlockput(ip);
    8000425e:	8526                	mv	a0,s1
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	c00080e7          	jalr	-1024(ra) # 80002e60 <iunlockput>
  end_op();
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	3d8080e7          	jalr	984(ra) # 80003640 <end_op>
  p = myproc();
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	be8080e7          	jalr	-1048(ra) # 80000e58 <myproc>
    80004278:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000427a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000427e:	6785                	lui	a5,0x1
    80004280:	17fd                	addi	a5,a5,-1
    80004282:	9a3e                	add	s4,s4,a5
    80004284:	757d                	lui	a0,0xfffff
    80004286:	00aa77b3          	and	a5,s4,a0
    8000428a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000428e:	4691                	li	a3,4
    80004290:	6609                	lui	a2,0x2
    80004292:	963e                	add	a2,a2,a5
    80004294:	85be                	mv	a1,a5
    80004296:	855e                	mv	a0,s7
    80004298:	ffffc097          	auipc	ra,0xffffc
    8000429c:	626080e7          	jalr	1574(ra) # 800008be <uvmalloc>
    800042a0:	8b2a                	mv	s6,a0
  ip = 0;
    800042a2:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042a4:	12050c63          	beqz	a0,800043dc <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042a8:	75f9                	lui	a1,0xffffe
    800042aa:	95aa                	add	a1,a1,a0
    800042ac:	855e                	mv	a0,s7
    800042ae:	ffffd097          	auipc	ra,0xffffd
    800042b2:	836080e7          	jalr	-1994(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    800042b6:	7c7d                	lui	s8,0xfffff
    800042b8:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042ba:	e0043783          	ld	a5,-512(s0)
    800042be:	6388                	ld	a0,0(a5)
    800042c0:	c535                	beqz	a0,8000432c <exec+0x218>
    800042c2:	e9040993          	addi	s3,s0,-368
    800042c6:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042ca:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	030080e7          	jalr	48(ra) # 800002fc <strlen>
    800042d4:	2505                	addiw	a0,a0,1
    800042d6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042da:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042de:	13896663          	bltu	s2,s8,8000440a <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042e2:	e0043d83          	ld	s11,-512(s0)
    800042e6:	000dba03          	ld	s4,0(s11)
    800042ea:	8552                	mv	a0,s4
    800042ec:	ffffc097          	auipc	ra,0xffffc
    800042f0:	010080e7          	jalr	16(ra) # 800002fc <strlen>
    800042f4:	0015069b          	addiw	a3,a0,1
    800042f8:	8652                	mv	a2,s4
    800042fa:	85ca                	mv	a1,s2
    800042fc:	855e                	mv	a0,s7
    800042fe:	ffffd097          	auipc	ra,0xffffd
    80004302:	818080e7          	jalr	-2024(ra) # 80000b16 <copyout>
    80004306:	10054663          	bltz	a0,80004412 <exec+0x2fe>
    ustack[argc] = sp;
    8000430a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000430e:	0485                	addi	s1,s1,1
    80004310:	008d8793          	addi	a5,s11,8
    80004314:	e0f43023          	sd	a5,-512(s0)
    80004318:	008db503          	ld	a0,8(s11)
    8000431c:	c911                	beqz	a0,80004330 <exec+0x21c>
    if(argc >= MAXARG)
    8000431e:	09a1                	addi	s3,s3,8
    80004320:	fb3c96e3          	bne	s9,s3,800042cc <exec+0x1b8>
  sz = sz1;
    80004324:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004328:	4481                	li	s1,0
    8000432a:	a84d                	j	800043dc <exec+0x2c8>
  sp = sz;
    8000432c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000432e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004330:	00349793          	slli	a5,s1,0x3
    80004334:	f9040713          	addi	a4,s0,-112
    80004338:	97ba                	add	a5,a5,a4
    8000433a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000433e:	00148693          	addi	a3,s1,1
    80004342:	068e                	slli	a3,a3,0x3
    80004344:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004348:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000434c:	01897663          	bgeu	s2,s8,80004358 <exec+0x244>
  sz = sz1;
    80004350:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004354:	4481                	li	s1,0
    80004356:	a059                	j	800043dc <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004358:	e9040613          	addi	a2,s0,-368
    8000435c:	85ca                	mv	a1,s2
    8000435e:	855e                	mv	a0,s7
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	7b6080e7          	jalr	1974(ra) # 80000b16 <copyout>
    80004368:	0a054963          	bltz	a0,8000441a <exec+0x306>
  p->trapframe->a1 = sp;
    8000436c:	058ab783          	ld	a5,88(s5)
    80004370:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004374:	df843783          	ld	a5,-520(s0)
    80004378:	0007c703          	lbu	a4,0(a5)
    8000437c:	cf11                	beqz	a4,80004398 <exec+0x284>
    8000437e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004380:	02f00693          	li	a3,47
    80004384:	a039                	j	80004392 <exec+0x27e>
      last = s+1;
    80004386:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000438a:	0785                	addi	a5,a5,1
    8000438c:	fff7c703          	lbu	a4,-1(a5)
    80004390:	c701                	beqz	a4,80004398 <exec+0x284>
    if(*s == '/')
    80004392:	fed71ce3          	bne	a4,a3,8000438a <exec+0x276>
    80004396:	bfc5                	j	80004386 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004398:	4641                	li	a2,16
    8000439a:	df843583          	ld	a1,-520(s0)
    8000439e:	158a8513          	addi	a0,s5,344
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	f28080e7          	jalr	-216(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800043aa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043ae:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043b2:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043b6:	058ab783          	ld	a5,88(s5)
    800043ba:	e6843703          	ld	a4,-408(s0)
    800043be:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043c0:	058ab783          	ld	a5,88(s5)
    800043c4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043c8:	85ea                	mv	a1,s10
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	bee080e7          	jalr	-1042(ra) # 80000fb8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043d2:	0004851b          	sext.w	a0,s1
    800043d6:	bbd9                	j	800041ac <exec+0x98>
    800043d8:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043dc:	e0843583          	ld	a1,-504(s0)
    800043e0:	855e                	mv	a0,s7
    800043e2:	ffffd097          	auipc	ra,0xffffd
    800043e6:	bd6080e7          	jalr	-1066(ra) # 80000fb8 <proc_freepagetable>
  if(ip){
    800043ea:	da0497e3          	bnez	s1,80004198 <exec+0x84>
  return -1;
    800043ee:	557d                	li	a0,-1
    800043f0:	bb75                	j	800041ac <exec+0x98>
    800043f2:	e1443423          	sd	s4,-504(s0)
    800043f6:	b7dd                	j	800043dc <exec+0x2c8>
    800043f8:	e1443423          	sd	s4,-504(s0)
    800043fc:	b7c5                	j	800043dc <exec+0x2c8>
    800043fe:	e1443423          	sd	s4,-504(s0)
    80004402:	bfe9                	j	800043dc <exec+0x2c8>
    80004404:	e1443423          	sd	s4,-504(s0)
    80004408:	bfd1                	j	800043dc <exec+0x2c8>
  sz = sz1;
    8000440a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000440e:	4481                	li	s1,0
    80004410:	b7f1                	j	800043dc <exec+0x2c8>
  sz = sz1;
    80004412:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004416:	4481                	li	s1,0
    80004418:	b7d1                	j	800043dc <exec+0x2c8>
  sz = sz1;
    8000441a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000441e:	4481                	li	s1,0
    80004420:	bf75                	j	800043dc <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004422:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004426:	2b05                	addiw	s6,s6,1
    80004428:	0389899b          	addiw	s3,s3,56
    8000442c:	e8845783          	lhu	a5,-376(s0)
    80004430:	e2fb57e3          	bge	s6,a5,8000425e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004434:	2981                	sext.w	s3,s3
    80004436:	03800713          	li	a4,56
    8000443a:	86ce                	mv	a3,s3
    8000443c:	e1840613          	addi	a2,s0,-488
    80004440:	4581                	li	a1,0
    80004442:	8526                	mv	a0,s1
    80004444:	fffff097          	auipc	ra,0xfffff
    80004448:	a6e080e7          	jalr	-1426(ra) # 80002eb2 <readi>
    8000444c:	03800793          	li	a5,56
    80004450:	f8f514e3          	bne	a0,a5,800043d8 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004454:	e1842783          	lw	a5,-488(s0)
    80004458:	4705                	li	a4,1
    8000445a:	fce796e3          	bne	a5,a4,80004426 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000445e:	e4043903          	ld	s2,-448(s0)
    80004462:	e3843783          	ld	a5,-456(s0)
    80004466:	f8f966e3          	bltu	s2,a5,800043f2 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000446a:	e2843783          	ld	a5,-472(s0)
    8000446e:	993e                	add	s2,s2,a5
    80004470:	f8f964e3          	bltu	s2,a5,800043f8 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004474:	df043703          	ld	a4,-528(s0)
    80004478:	8ff9                	and	a5,a5,a4
    8000447a:	f3d1                	bnez	a5,800043fe <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000447c:	e1c42503          	lw	a0,-484(s0)
    80004480:	00000097          	auipc	ra,0x0
    80004484:	c78080e7          	jalr	-904(ra) # 800040f8 <flags2perm>
    80004488:	86aa                	mv	a3,a0
    8000448a:	864a                	mv	a2,s2
    8000448c:	85d2                	mv	a1,s4
    8000448e:	855e                	mv	a0,s7
    80004490:	ffffc097          	auipc	ra,0xffffc
    80004494:	42e080e7          	jalr	1070(ra) # 800008be <uvmalloc>
    80004498:	e0a43423          	sd	a0,-504(s0)
    8000449c:	d525                	beqz	a0,80004404 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000449e:	e2843d03          	ld	s10,-472(s0)
    800044a2:	e2042d83          	lw	s11,-480(s0)
    800044a6:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044aa:	f60c0ce3          	beqz	s8,80004422 <exec+0x30e>
    800044ae:	8a62                	mv	s4,s8
    800044b0:	4901                	li	s2,0
    800044b2:	b369                	j	8000423c <exec+0x128>

00000000800044b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044b4:	7179                	addi	sp,sp,-48
    800044b6:	f406                	sd	ra,40(sp)
    800044b8:	f022                	sd	s0,32(sp)
    800044ba:	ec26                	sd	s1,24(sp)
    800044bc:	e84a                	sd	s2,16(sp)
    800044be:	1800                	addi	s0,sp,48
    800044c0:	892e                	mv	s2,a1
    800044c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044c4:	fdc40593          	addi	a1,s0,-36
    800044c8:	ffffe097          	auipc	ra,0xffffe
    800044cc:	b28080e7          	jalr	-1240(ra) # 80001ff0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044d0:	fdc42703          	lw	a4,-36(s0)
    800044d4:	47bd                	li	a5,15
    800044d6:	02e7eb63          	bltu	a5,a4,8000450c <argfd+0x58>
    800044da:	ffffd097          	auipc	ra,0xffffd
    800044de:	97e080e7          	jalr	-1666(ra) # 80000e58 <myproc>
    800044e2:	fdc42703          	lw	a4,-36(s0)
    800044e6:	01a70793          	addi	a5,a4,26
    800044ea:	078e                	slli	a5,a5,0x3
    800044ec:	953e                	add	a0,a0,a5
    800044ee:	611c                	ld	a5,0(a0)
    800044f0:	c385                	beqz	a5,80004510 <argfd+0x5c>
    return -1;
  if(pfd)
    800044f2:	00090463          	beqz	s2,800044fa <argfd+0x46>
    *pfd = fd;
    800044f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044fa:	4501                	li	a0,0
  if(pf)
    800044fc:	c091                	beqz	s1,80004500 <argfd+0x4c>
    *pf = f;
    800044fe:	e09c                	sd	a5,0(s1)
}
    80004500:	70a2                	ld	ra,40(sp)
    80004502:	7402                	ld	s0,32(sp)
    80004504:	64e2                	ld	s1,24(sp)
    80004506:	6942                	ld	s2,16(sp)
    80004508:	6145                	addi	sp,sp,48
    8000450a:	8082                	ret
    return -1;
    8000450c:	557d                	li	a0,-1
    8000450e:	bfcd                	j	80004500 <argfd+0x4c>
    80004510:	557d                	li	a0,-1
    80004512:	b7fd                	j	80004500 <argfd+0x4c>

0000000080004514 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004514:	1101                	addi	sp,sp,-32
    80004516:	ec06                	sd	ra,24(sp)
    80004518:	e822                	sd	s0,16(sp)
    8000451a:	e426                	sd	s1,8(sp)
    8000451c:	1000                	addi	s0,sp,32
    8000451e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004520:	ffffd097          	auipc	ra,0xffffd
    80004524:	938080e7          	jalr	-1736(ra) # 80000e58 <myproc>
    80004528:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000452a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdc970>
    8000452e:	4501                	li	a0,0
    80004530:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004532:	6398                	ld	a4,0(a5)
    80004534:	cb19                	beqz	a4,8000454a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004536:	2505                	addiw	a0,a0,1
    80004538:	07a1                	addi	a5,a5,8
    8000453a:	fed51ce3          	bne	a0,a3,80004532 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000453e:	557d                	li	a0,-1
}
    80004540:	60e2                	ld	ra,24(sp)
    80004542:	6442                	ld	s0,16(sp)
    80004544:	64a2                	ld	s1,8(sp)
    80004546:	6105                	addi	sp,sp,32
    80004548:	8082                	ret
      p->ofile[fd] = f;
    8000454a:	01a50793          	addi	a5,a0,26
    8000454e:	078e                	slli	a5,a5,0x3
    80004550:	963e                	add	a2,a2,a5
    80004552:	e204                	sd	s1,0(a2)
      return fd;
    80004554:	b7f5                	j	80004540 <fdalloc+0x2c>

0000000080004556 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004556:	715d                	addi	sp,sp,-80
    80004558:	e486                	sd	ra,72(sp)
    8000455a:	e0a2                	sd	s0,64(sp)
    8000455c:	fc26                	sd	s1,56(sp)
    8000455e:	f84a                	sd	s2,48(sp)
    80004560:	f44e                	sd	s3,40(sp)
    80004562:	f052                	sd	s4,32(sp)
    80004564:	ec56                	sd	s5,24(sp)
    80004566:	e85a                	sd	s6,16(sp)
    80004568:	0880                	addi	s0,sp,80
    8000456a:	8b2e                	mv	s6,a1
    8000456c:	89b2                	mv	s3,a2
    8000456e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004570:	fb040593          	addi	a1,s0,-80
    80004574:	fffff097          	auipc	ra,0xfffff
    80004578:	e4e080e7          	jalr	-434(ra) # 800033c2 <nameiparent>
    8000457c:	84aa                	mv	s1,a0
    8000457e:	16050063          	beqz	a0,800046de <create+0x188>
    return 0;

  ilock(dp);
    80004582:	ffffe097          	auipc	ra,0xffffe
    80004586:	67c080e7          	jalr	1660(ra) # 80002bfe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000458a:	4601                	li	a2,0
    8000458c:	fb040593          	addi	a1,s0,-80
    80004590:	8526                	mv	a0,s1
    80004592:	fffff097          	auipc	ra,0xfffff
    80004596:	b50080e7          	jalr	-1200(ra) # 800030e2 <dirlookup>
    8000459a:	8aaa                	mv	s5,a0
    8000459c:	c931                	beqz	a0,800045f0 <create+0x9a>
    iunlockput(dp);
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	8c0080e7          	jalr	-1856(ra) # 80002e60 <iunlockput>
    ilock(ip);
    800045a8:	8556                	mv	a0,s5
    800045aa:	ffffe097          	auipc	ra,0xffffe
    800045ae:	654080e7          	jalr	1620(ra) # 80002bfe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045b2:	000b059b          	sext.w	a1,s6
    800045b6:	4789                	li	a5,2
    800045b8:	02f59563          	bne	a1,a5,800045e2 <create+0x8c>
    800045bc:	044ad783          	lhu	a5,68(s5)
    800045c0:	37f9                	addiw	a5,a5,-2
    800045c2:	17c2                	slli	a5,a5,0x30
    800045c4:	93c1                	srli	a5,a5,0x30
    800045c6:	4705                	li	a4,1
    800045c8:	00f76d63          	bltu	a4,a5,800045e2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045cc:	8556                	mv	a0,s5
    800045ce:	60a6                	ld	ra,72(sp)
    800045d0:	6406                	ld	s0,64(sp)
    800045d2:	74e2                	ld	s1,56(sp)
    800045d4:	7942                	ld	s2,48(sp)
    800045d6:	79a2                	ld	s3,40(sp)
    800045d8:	7a02                	ld	s4,32(sp)
    800045da:	6ae2                	ld	s5,24(sp)
    800045dc:	6b42                	ld	s6,16(sp)
    800045de:	6161                	addi	sp,sp,80
    800045e0:	8082                	ret
    iunlockput(ip);
    800045e2:	8556                	mv	a0,s5
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	87c080e7          	jalr	-1924(ra) # 80002e60 <iunlockput>
    return 0;
    800045ec:	4a81                	li	s5,0
    800045ee:	bff9                	j	800045cc <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045f0:	85da                	mv	a1,s6
    800045f2:	4088                	lw	a0,0(s1)
    800045f4:	ffffe097          	auipc	ra,0xffffe
    800045f8:	46e080e7          	jalr	1134(ra) # 80002a62 <ialloc>
    800045fc:	8a2a                	mv	s4,a0
    800045fe:	c921                	beqz	a0,8000464e <create+0xf8>
  ilock(ip);
    80004600:	ffffe097          	auipc	ra,0xffffe
    80004604:	5fe080e7          	jalr	1534(ra) # 80002bfe <ilock>
  ip->major = major;
    80004608:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000460c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004610:	4785                	li	a5,1
    80004612:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004616:	8552                	mv	a0,s4
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	51c080e7          	jalr	1308(ra) # 80002b34 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004620:	000b059b          	sext.w	a1,s6
    80004624:	4785                	li	a5,1
    80004626:	02f58b63          	beq	a1,a5,8000465c <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000462a:	004a2603          	lw	a2,4(s4)
    8000462e:	fb040593          	addi	a1,s0,-80
    80004632:	8526                	mv	a0,s1
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	cbe080e7          	jalr	-834(ra) # 800032f2 <dirlink>
    8000463c:	06054f63          	bltz	a0,800046ba <create+0x164>
  iunlockput(dp);
    80004640:	8526                	mv	a0,s1
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	81e080e7          	jalr	-2018(ra) # 80002e60 <iunlockput>
  return ip;
    8000464a:	8ad2                	mv	s5,s4
    8000464c:	b741                	j	800045cc <create+0x76>
    iunlockput(dp);
    8000464e:	8526                	mv	a0,s1
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	810080e7          	jalr	-2032(ra) # 80002e60 <iunlockput>
    return 0;
    80004658:	8ad2                	mv	s5,s4
    8000465a:	bf8d                	j	800045cc <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000465c:	004a2603          	lw	a2,4(s4)
    80004660:	00004597          	auipc	a1,0x4
    80004664:	02058593          	addi	a1,a1,32 # 80008680 <syscalls+0x2b0>
    80004668:	8552                	mv	a0,s4
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	c88080e7          	jalr	-888(ra) # 800032f2 <dirlink>
    80004672:	04054463          	bltz	a0,800046ba <create+0x164>
    80004676:	40d0                	lw	a2,4(s1)
    80004678:	00004597          	auipc	a1,0x4
    8000467c:	01058593          	addi	a1,a1,16 # 80008688 <syscalls+0x2b8>
    80004680:	8552                	mv	a0,s4
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	c70080e7          	jalr	-912(ra) # 800032f2 <dirlink>
    8000468a:	02054863          	bltz	a0,800046ba <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000468e:	004a2603          	lw	a2,4(s4)
    80004692:	fb040593          	addi	a1,s0,-80
    80004696:	8526                	mv	a0,s1
    80004698:	fffff097          	auipc	ra,0xfffff
    8000469c:	c5a080e7          	jalr	-934(ra) # 800032f2 <dirlink>
    800046a0:	00054d63          	bltz	a0,800046ba <create+0x164>
    dp->nlink++;  // for ".."
    800046a4:	04a4d783          	lhu	a5,74(s1)
    800046a8:	2785                	addiw	a5,a5,1
    800046aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046ae:	8526                	mv	a0,s1
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	484080e7          	jalr	1156(ra) # 80002b34 <iupdate>
    800046b8:	b761                	j	80004640 <create+0xea>
  ip->nlink = 0;
    800046ba:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046be:	8552                	mv	a0,s4
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	474080e7          	jalr	1140(ra) # 80002b34 <iupdate>
  iunlockput(ip);
    800046c8:	8552                	mv	a0,s4
    800046ca:	ffffe097          	auipc	ra,0xffffe
    800046ce:	796080e7          	jalr	1942(ra) # 80002e60 <iunlockput>
  iunlockput(dp);
    800046d2:	8526                	mv	a0,s1
    800046d4:	ffffe097          	auipc	ra,0xffffe
    800046d8:	78c080e7          	jalr	1932(ra) # 80002e60 <iunlockput>
  return 0;
    800046dc:	bdc5                	j	800045cc <create+0x76>
    return 0;
    800046de:	8aaa                	mv	s5,a0
    800046e0:	b5f5                	j	800045cc <create+0x76>

00000000800046e2 <sys_dup>:
{
    800046e2:	7179                	addi	sp,sp,-48
    800046e4:	f406                	sd	ra,40(sp)
    800046e6:	f022                	sd	s0,32(sp)
    800046e8:	ec26                	sd	s1,24(sp)
    800046ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046ec:	fd840613          	addi	a2,s0,-40
    800046f0:	4581                	li	a1,0
    800046f2:	4501                	li	a0,0
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	dc0080e7          	jalr	-576(ra) # 800044b4 <argfd>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046fe:	02054363          	bltz	a0,80004724 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004702:	fd843503          	ld	a0,-40(s0)
    80004706:	00000097          	auipc	ra,0x0
    8000470a:	e0e080e7          	jalr	-498(ra) # 80004514 <fdalloc>
    8000470e:	84aa                	mv	s1,a0
    return -1;
    80004710:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004712:	00054963          	bltz	a0,80004724 <sys_dup+0x42>
  filedup(f);
    80004716:	fd843503          	ld	a0,-40(s0)
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	320080e7          	jalr	800(ra) # 80003a3a <filedup>
  return fd;
    80004722:	87a6                	mv	a5,s1
}
    80004724:	853e                	mv	a0,a5
    80004726:	70a2                	ld	ra,40(sp)
    80004728:	7402                	ld	s0,32(sp)
    8000472a:	64e2                	ld	s1,24(sp)
    8000472c:	6145                	addi	sp,sp,48
    8000472e:	8082                	ret

0000000080004730 <sys_read>:
{
    80004730:	7179                	addi	sp,sp,-48
    80004732:	f406                	sd	ra,40(sp)
    80004734:	f022                	sd	s0,32(sp)
    80004736:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004738:	fd840593          	addi	a1,s0,-40
    8000473c:	4505                	li	a0,1
    8000473e:	ffffe097          	auipc	ra,0xffffe
    80004742:	8d2080e7          	jalr	-1838(ra) # 80002010 <argaddr>
  argint(2, &n);
    80004746:	fe440593          	addi	a1,s0,-28
    8000474a:	4509                	li	a0,2
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	8a4080e7          	jalr	-1884(ra) # 80001ff0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004754:	fe840613          	addi	a2,s0,-24
    80004758:	4581                	li	a1,0
    8000475a:	4501                	li	a0,0
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	d58080e7          	jalr	-680(ra) # 800044b4 <argfd>
    80004764:	87aa                	mv	a5,a0
    return -1;
    80004766:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004768:	0007cc63          	bltz	a5,80004780 <sys_read+0x50>
  return fileread(f, p, n);
    8000476c:	fe442603          	lw	a2,-28(s0)
    80004770:	fd843583          	ld	a1,-40(s0)
    80004774:	fe843503          	ld	a0,-24(s0)
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	44e080e7          	jalr	1102(ra) # 80003bc6 <fileread>
}
    80004780:	70a2                	ld	ra,40(sp)
    80004782:	7402                	ld	s0,32(sp)
    80004784:	6145                	addi	sp,sp,48
    80004786:	8082                	ret

0000000080004788 <sys_write>:
{
    80004788:	7179                	addi	sp,sp,-48
    8000478a:	f406                	sd	ra,40(sp)
    8000478c:	f022                	sd	s0,32(sp)
    8000478e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004790:	fd840593          	addi	a1,s0,-40
    80004794:	4505                	li	a0,1
    80004796:	ffffe097          	auipc	ra,0xffffe
    8000479a:	87a080e7          	jalr	-1926(ra) # 80002010 <argaddr>
  argint(2, &n);
    8000479e:	fe440593          	addi	a1,s0,-28
    800047a2:	4509                	li	a0,2
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	84c080e7          	jalr	-1972(ra) # 80001ff0 <argint>
  if(argfd(0, 0, &f) < 0)
    800047ac:	fe840613          	addi	a2,s0,-24
    800047b0:	4581                	li	a1,0
    800047b2:	4501                	li	a0,0
    800047b4:	00000097          	auipc	ra,0x0
    800047b8:	d00080e7          	jalr	-768(ra) # 800044b4 <argfd>
    800047bc:	87aa                	mv	a5,a0
    return -1;
    800047be:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047c0:	0007cc63          	bltz	a5,800047d8 <sys_write+0x50>
  return filewrite(f, p, n);
    800047c4:	fe442603          	lw	a2,-28(s0)
    800047c8:	fd843583          	ld	a1,-40(s0)
    800047cc:	fe843503          	ld	a0,-24(s0)
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	4b8080e7          	jalr	1208(ra) # 80003c88 <filewrite>
}
    800047d8:	70a2                	ld	ra,40(sp)
    800047da:	7402                	ld	s0,32(sp)
    800047dc:	6145                	addi	sp,sp,48
    800047de:	8082                	ret

00000000800047e0 <sys_close>:
{
    800047e0:	1101                	addi	sp,sp,-32
    800047e2:	ec06                	sd	ra,24(sp)
    800047e4:	e822                	sd	s0,16(sp)
    800047e6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047e8:	fe040613          	addi	a2,s0,-32
    800047ec:	fec40593          	addi	a1,s0,-20
    800047f0:	4501                	li	a0,0
    800047f2:	00000097          	auipc	ra,0x0
    800047f6:	cc2080e7          	jalr	-830(ra) # 800044b4 <argfd>
    return -1;
    800047fa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047fc:	02054463          	bltz	a0,80004824 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004800:	ffffc097          	auipc	ra,0xffffc
    80004804:	658080e7          	jalr	1624(ra) # 80000e58 <myproc>
    80004808:	fec42783          	lw	a5,-20(s0)
    8000480c:	07e9                	addi	a5,a5,26
    8000480e:	078e                	slli	a5,a5,0x3
    80004810:	97aa                	add	a5,a5,a0
    80004812:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004816:	fe043503          	ld	a0,-32(s0)
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	272080e7          	jalr	626(ra) # 80003a8c <fileclose>
  return 0;
    80004822:	4781                	li	a5,0
}
    80004824:	853e                	mv	a0,a5
    80004826:	60e2                	ld	ra,24(sp)
    80004828:	6442                	ld	s0,16(sp)
    8000482a:	6105                	addi	sp,sp,32
    8000482c:	8082                	ret

000000008000482e <sys_fstat>:
{
    8000482e:	1101                	addi	sp,sp,-32
    80004830:	ec06                	sd	ra,24(sp)
    80004832:	e822                	sd	s0,16(sp)
    80004834:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004836:	fe040593          	addi	a1,s0,-32
    8000483a:	4505                	li	a0,1
    8000483c:	ffffd097          	auipc	ra,0xffffd
    80004840:	7d4080e7          	jalr	2004(ra) # 80002010 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004844:	fe840613          	addi	a2,s0,-24
    80004848:	4581                	li	a1,0
    8000484a:	4501                	li	a0,0
    8000484c:	00000097          	auipc	ra,0x0
    80004850:	c68080e7          	jalr	-920(ra) # 800044b4 <argfd>
    80004854:	87aa                	mv	a5,a0
    return -1;
    80004856:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004858:	0007ca63          	bltz	a5,8000486c <sys_fstat+0x3e>
  return filestat(f, st);
    8000485c:	fe043583          	ld	a1,-32(s0)
    80004860:	fe843503          	ld	a0,-24(s0)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	2f0080e7          	jalr	752(ra) # 80003b54 <filestat>
}
    8000486c:	60e2                	ld	ra,24(sp)
    8000486e:	6442                	ld	s0,16(sp)
    80004870:	6105                	addi	sp,sp,32
    80004872:	8082                	ret

0000000080004874 <sys_link>:
{
    80004874:	7169                	addi	sp,sp,-304
    80004876:	f606                	sd	ra,296(sp)
    80004878:	f222                	sd	s0,288(sp)
    8000487a:	ee26                	sd	s1,280(sp)
    8000487c:	ea4a                	sd	s2,272(sp)
    8000487e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004880:	08000613          	li	a2,128
    80004884:	ed040593          	addi	a1,s0,-304
    80004888:	4501                	li	a0,0
    8000488a:	ffffd097          	auipc	ra,0xffffd
    8000488e:	7a6080e7          	jalr	1958(ra) # 80002030 <argstr>
    return -1;
    80004892:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004894:	10054e63          	bltz	a0,800049b0 <sys_link+0x13c>
    80004898:	08000613          	li	a2,128
    8000489c:	f5040593          	addi	a1,s0,-176
    800048a0:	4505                	li	a0,1
    800048a2:	ffffd097          	auipc	ra,0xffffd
    800048a6:	78e080e7          	jalr	1934(ra) # 80002030 <argstr>
    return -1;
    800048aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ac:	10054263          	bltz	a0,800049b0 <sys_link+0x13c>
  begin_op();
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	d10080e7          	jalr	-752(ra) # 800035c0 <begin_op>
  if((ip = namei(old)) == 0){
    800048b8:	ed040513          	addi	a0,s0,-304
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	ae8080e7          	jalr	-1304(ra) # 800033a4 <namei>
    800048c4:	84aa                	mv	s1,a0
    800048c6:	c551                	beqz	a0,80004952 <sys_link+0xde>
  ilock(ip);
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	336080e7          	jalr	822(ra) # 80002bfe <ilock>
  if(ip->type == T_DIR){
    800048d0:	04449703          	lh	a4,68(s1)
    800048d4:	4785                	li	a5,1
    800048d6:	08f70463          	beq	a4,a5,8000495e <sys_link+0xea>
  ip->nlink++;
    800048da:	04a4d783          	lhu	a5,74(s1)
    800048de:	2785                	addiw	a5,a5,1
    800048e0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	24e080e7          	jalr	590(ra) # 80002b34 <iupdate>
  iunlock(ip);
    800048ee:	8526                	mv	a0,s1
    800048f0:	ffffe097          	auipc	ra,0xffffe
    800048f4:	3d0080e7          	jalr	976(ra) # 80002cc0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048f8:	fd040593          	addi	a1,s0,-48
    800048fc:	f5040513          	addi	a0,s0,-176
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	ac2080e7          	jalr	-1342(ra) # 800033c2 <nameiparent>
    80004908:	892a                	mv	s2,a0
    8000490a:	c935                	beqz	a0,8000497e <sys_link+0x10a>
  ilock(dp);
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	2f2080e7          	jalr	754(ra) # 80002bfe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004914:	00092703          	lw	a4,0(s2)
    80004918:	409c                	lw	a5,0(s1)
    8000491a:	04f71d63          	bne	a4,a5,80004974 <sys_link+0x100>
    8000491e:	40d0                	lw	a2,4(s1)
    80004920:	fd040593          	addi	a1,s0,-48
    80004924:	854a                	mv	a0,s2
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	9cc080e7          	jalr	-1588(ra) # 800032f2 <dirlink>
    8000492e:	04054363          	bltz	a0,80004974 <sys_link+0x100>
  iunlockput(dp);
    80004932:	854a                	mv	a0,s2
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	52c080e7          	jalr	1324(ra) # 80002e60 <iunlockput>
  iput(ip);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	47a080e7          	jalr	1146(ra) # 80002db8 <iput>
  end_op();
    80004946:	fffff097          	auipc	ra,0xfffff
    8000494a:	cfa080e7          	jalr	-774(ra) # 80003640 <end_op>
  return 0;
    8000494e:	4781                	li	a5,0
    80004950:	a085                	j	800049b0 <sys_link+0x13c>
    end_op();
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	cee080e7          	jalr	-786(ra) # 80003640 <end_op>
    return -1;
    8000495a:	57fd                	li	a5,-1
    8000495c:	a891                	j	800049b0 <sys_link+0x13c>
    iunlockput(ip);
    8000495e:	8526                	mv	a0,s1
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	500080e7          	jalr	1280(ra) # 80002e60 <iunlockput>
    end_op();
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	cd8080e7          	jalr	-808(ra) # 80003640 <end_op>
    return -1;
    80004970:	57fd                	li	a5,-1
    80004972:	a83d                	j	800049b0 <sys_link+0x13c>
    iunlockput(dp);
    80004974:	854a                	mv	a0,s2
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	4ea080e7          	jalr	1258(ra) # 80002e60 <iunlockput>
  ilock(ip);
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	27e080e7          	jalr	638(ra) # 80002bfe <ilock>
  ip->nlink--;
    80004988:	04a4d783          	lhu	a5,74(s1)
    8000498c:	37fd                	addiw	a5,a5,-1
    8000498e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004992:	8526                	mv	a0,s1
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	1a0080e7          	jalr	416(ra) # 80002b34 <iupdate>
  iunlockput(ip);
    8000499c:	8526                	mv	a0,s1
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	4c2080e7          	jalr	1218(ra) # 80002e60 <iunlockput>
  end_op();
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	c9a080e7          	jalr	-870(ra) # 80003640 <end_op>
  return -1;
    800049ae:	57fd                	li	a5,-1
}
    800049b0:	853e                	mv	a0,a5
    800049b2:	70b2                	ld	ra,296(sp)
    800049b4:	7412                	ld	s0,288(sp)
    800049b6:	64f2                	ld	s1,280(sp)
    800049b8:	6952                	ld	s2,272(sp)
    800049ba:	6155                	addi	sp,sp,304
    800049bc:	8082                	ret

00000000800049be <sys_unlink>:
{
    800049be:	7151                	addi	sp,sp,-240
    800049c0:	f586                	sd	ra,232(sp)
    800049c2:	f1a2                	sd	s0,224(sp)
    800049c4:	eda6                	sd	s1,216(sp)
    800049c6:	e9ca                	sd	s2,208(sp)
    800049c8:	e5ce                	sd	s3,200(sp)
    800049ca:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049cc:	08000613          	li	a2,128
    800049d0:	f3040593          	addi	a1,s0,-208
    800049d4:	4501                	li	a0,0
    800049d6:	ffffd097          	auipc	ra,0xffffd
    800049da:	65a080e7          	jalr	1626(ra) # 80002030 <argstr>
    800049de:	18054163          	bltz	a0,80004b60 <sys_unlink+0x1a2>
  begin_op();
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	bde080e7          	jalr	-1058(ra) # 800035c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049ea:	fb040593          	addi	a1,s0,-80
    800049ee:	f3040513          	addi	a0,s0,-208
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	9d0080e7          	jalr	-1584(ra) # 800033c2 <nameiparent>
    800049fa:	84aa                	mv	s1,a0
    800049fc:	c979                	beqz	a0,80004ad2 <sys_unlink+0x114>
  ilock(dp);
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	200080e7          	jalr	512(ra) # 80002bfe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a06:	00004597          	auipc	a1,0x4
    80004a0a:	c7a58593          	addi	a1,a1,-902 # 80008680 <syscalls+0x2b0>
    80004a0e:	fb040513          	addi	a0,s0,-80
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	6b6080e7          	jalr	1718(ra) # 800030c8 <namecmp>
    80004a1a:	14050a63          	beqz	a0,80004b6e <sys_unlink+0x1b0>
    80004a1e:	00004597          	auipc	a1,0x4
    80004a22:	c6a58593          	addi	a1,a1,-918 # 80008688 <syscalls+0x2b8>
    80004a26:	fb040513          	addi	a0,s0,-80
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	69e080e7          	jalr	1694(ra) # 800030c8 <namecmp>
    80004a32:	12050e63          	beqz	a0,80004b6e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a36:	f2c40613          	addi	a2,s0,-212
    80004a3a:	fb040593          	addi	a1,s0,-80
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	6a2080e7          	jalr	1698(ra) # 800030e2 <dirlookup>
    80004a48:	892a                	mv	s2,a0
    80004a4a:	12050263          	beqz	a0,80004b6e <sys_unlink+0x1b0>
  ilock(ip);
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	1b0080e7          	jalr	432(ra) # 80002bfe <ilock>
  if(ip->nlink < 1)
    80004a56:	04a91783          	lh	a5,74(s2)
    80004a5a:	08f05263          	blez	a5,80004ade <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a5e:	04491703          	lh	a4,68(s2)
    80004a62:	4785                	li	a5,1
    80004a64:	08f70563          	beq	a4,a5,80004aee <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a68:	4641                	li	a2,16
    80004a6a:	4581                	li	a1,0
    80004a6c:	fc040513          	addi	a0,s0,-64
    80004a70:	ffffb097          	auipc	ra,0xffffb
    80004a74:	708080e7          	jalr	1800(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a78:	4741                	li	a4,16
    80004a7a:	f2c42683          	lw	a3,-212(s0)
    80004a7e:	fc040613          	addi	a2,s0,-64
    80004a82:	4581                	li	a1,0
    80004a84:	8526                	mv	a0,s1
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	524080e7          	jalr	1316(ra) # 80002faa <writei>
    80004a8e:	47c1                	li	a5,16
    80004a90:	0af51563          	bne	a0,a5,80004b3a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a94:	04491703          	lh	a4,68(s2)
    80004a98:	4785                	li	a5,1
    80004a9a:	0af70863          	beq	a4,a5,80004b4a <sys_unlink+0x18c>
  iunlockput(dp);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	3c0080e7          	jalr	960(ra) # 80002e60 <iunlockput>
  ip->nlink--;
    80004aa8:	04a95783          	lhu	a5,74(s2)
    80004aac:	37fd                	addiw	a5,a5,-1
    80004aae:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	080080e7          	jalr	128(ra) # 80002b34 <iupdate>
  iunlockput(ip);
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	3a2080e7          	jalr	930(ra) # 80002e60 <iunlockput>
  end_op();
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	b7a080e7          	jalr	-1158(ra) # 80003640 <end_op>
  return 0;
    80004ace:	4501                	li	a0,0
    80004ad0:	a84d                	j	80004b82 <sys_unlink+0x1c4>
    end_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	b6e080e7          	jalr	-1170(ra) # 80003640 <end_op>
    return -1;
    80004ada:	557d                	li	a0,-1
    80004adc:	a05d                	j	80004b82 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ade:	00004517          	auipc	a0,0x4
    80004ae2:	bb250513          	addi	a0,a0,-1102 # 80008690 <syscalls+0x2c0>
    80004ae6:	00001097          	auipc	ra,0x1
    80004aea:	2a8080e7          	jalr	680(ra) # 80005d8e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aee:	04c92703          	lw	a4,76(s2)
    80004af2:	02000793          	li	a5,32
    80004af6:	f6e7f9e3          	bgeu	a5,a4,80004a68 <sys_unlink+0xaa>
    80004afa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afe:	4741                	li	a4,16
    80004b00:	86ce                	mv	a3,s3
    80004b02:	f1840613          	addi	a2,s0,-232
    80004b06:	4581                	li	a1,0
    80004b08:	854a                	mv	a0,s2
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	3a8080e7          	jalr	936(ra) # 80002eb2 <readi>
    80004b12:	47c1                	li	a5,16
    80004b14:	00f51b63          	bne	a0,a5,80004b2a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b18:	f1845783          	lhu	a5,-232(s0)
    80004b1c:	e7a1                	bnez	a5,80004b64 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b1e:	29c1                	addiw	s3,s3,16
    80004b20:	04c92783          	lw	a5,76(s2)
    80004b24:	fcf9ede3          	bltu	s3,a5,80004afe <sys_unlink+0x140>
    80004b28:	b781                	j	80004a68 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b2a:	00004517          	auipc	a0,0x4
    80004b2e:	b7e50513          	addi	a0,a0,-1154 # 800086a8 <syscalls+0x2d8>
    80004b32:	00001097          	auipc	ra,0x1
    80004b36:	25c080e7          	jalr	604(ra) # 80005d8e <panic>
    panic("unlink: writei");
    80004b3a:	00004517          	auipc	a0,0x4
    80004b3e:	b8650513          	addi	a0,a0,-1146 # 800086c0 <syscalls+0x2f0>
    80004b42:	00001097          	auipc	ra,0x1
    80004b46:	24c080e7          	jalr	588(ra) # 80005d8e <panic>
    dp->nlink--;
    80004b4a:	04a4d783          	lhu	a5,74(s1)
    80004b4e:	37fd                	addiw	a5,a5,-1
    80004b50:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	fde080e7          	jalr	-34(ra) # 80002b34 <iupdate>
    80004b5e:	b781                	j	80004a9e <sys_unlink+0xe0>
    return -1;
    80004b60:	557d                	li	a0,-1
    80004b62:	a005                	j	80004b82 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b64:	854a                	mv	a0,s2
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	2fa080e7          	jalr	762(ra) # 80002e60 <iunlockput>
  iunlockput(dp);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	2f0080e7          	jalr	752(ra) # 80002e60 <iunlockput>
  end_op();
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	ac8080e7          	jalr	-1336(ra) # 80003640 <end_op>
  return -1;
    80004b80:	557d                	li	a0,-1
}
    80004b82:	70ae                	ld	ra,232(sp)
    80004b84:	740e                	ld	s0,224(sp)
    80004b86:	64ee                	ld	s1,216(sp)
    80004b88:	694e                	ld	s2,208(sp)
    80004b8a:	69ae                	ld	s3,200(sp)
    80004b8c:	616d                	addi	sp,sp,240
    80004b8e:	8082                	ret

0000000080004b90 <sys_open>:

uint64
sys_open(void)
{
    80004b90:	7131                	addi	sp,sp,-192
    80004b92:	fd06                	sd	ra,184(sp)
    80004b94:	f922                	sd	s0,176(sp)
    80004b96:	f526                	sd	s1,168(sp)
    80004b98:	f14a                	sd	s2,160(sp)
    80004b9a:	ed4e                	sd	s3,152(sp)
    80004b9c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b9e:	f4c40593          	addi	a1,s0,-180
    80004ba2:	4505                	li	a0,1
    80004ba4:	ffffd097          	auipc	ra,0xffffd
    80004ba8:	44c080e7          	jalr	1100(ra) # 80001ff0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bac:	08000613          	li	a2,128
    80004bb0:	f5040593          	addi	a1,s0,-176
    80004bb4:	4501                	li	a0,0
    80004bb6:	ffffd097          	auipc	ra,0xffffd
    80004bba:	47a080e7          	jalr	1146(ra) # 80002030 <argstr>
    80004bbe:	87aa                	mv	a5,a0
    return -1;
    80004bc0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bc2:	0a07c963          	bltz	a5,80004c74 <sys_open+0xe4>

  begin_op();
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	9fa080e7          	jalr	-1542(ra) # 800035c0 <begin_op>

  if(omode & O_CREATE){
    80004bce:	f4c42783          	lw	a5,-180(s0)
    80004bd2:	2007f793          	andi	a5,a5,512
    80004bd6:	cfc5                	beqz	a5,80004c8e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bd8:	4681                	li	a3,0
    80004bda:	4601                	li	a2,0
    80004bdc:	4589                	li	a1,2
    80004bde:	f5040513          	addi	a0,s0,-176
    80004be2:	00000097          	auipc	ra,0x0
    80004be6:	974080e7          	jalr	-1676(ra) # 80004556 <create>
    80004bea:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bec:	c959                	beqz	a0,80004c82 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bee:	04449703          	lh	a4,68(s1)
    80004bf2:	478d                	li	a5,3
    80004bf4:	00f71763          	bne	a4,a5,80004c02 <sys_open+0x72>
    80004bf8:	0464d703          	lhu	a4,70(s1)
    80004bfc:	47a5                	li	a5,9
    80004bfe:	0ce7ed63          	bltu	a5,a4,80004cd8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	dce080e7          	jalr	-562(ra) # 800039d0 <filealloc>
    80004c0a:	89aa                	mv	s3,a0
    80004c0c:	10050363          	beqz	a0,80004d12 <sys_open+0x182>
    80004c10:	00000097          	auipc	ra,0x0
    80004c14:	904080e7          	jalr	-1788(ra) # 80004514 <fdalloc>
    80004c18:	892a                	mv	s2,a0
    80004c1a:	0e054763          	bltz	a0,80004d08 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c1e:	04449703          	lh	a4,68(s1)
    80004c22:	478d                	li	a5,3
    80004c24:	0cf70563          	beq	a4,a5,80004cee <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c28:	4789                	li	a5,2
    80004c2a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c2e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c32:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c36:	f4c42783          	lw	a5,-180(s0)
    80004c3a:	0017c713          	xori	a4,a5,1
    80004c3e:	8b05                	andi	a4,a4,1
    80004c40:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c44:	0037f713          	andi	a4,a5,3
    80004c48:	00e03733          	snez	a4,a4
    80004c4c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c50:	4007f793          	andi	a5,a5,1024
    80004c54:	c791                	beqz	a5,80004c60 <sys_open+0xd0>
    80004c56:	04449703          	lh	a4,68(s1)
    80004c5a:	4789                	li	a5,2
    80004c5c:	0af70063          	beq	a4,a5,80004cfc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	05e080e7          	jalr	94(ra) # 80002cc0 <iunlock>
  end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	9d6080e7          	jalr	-1578(ra) # 80003640 <end_op>

  return fd;
    80004c72:	854a                	mv	a0,s2
}
    80004c74:	70ea                	ld	ra,184(sp)
    80004c76:	744a                	ld	s0,176(sp)
    80004c78:	74aa                	ld	s1,168(sp)
    80004c7a:	790a                	ld	s2,160(sp)
    80004c7c:	69ea                	ld	s3,152(sp)
    80004c7e:	6129                	addi	sp,sp,192
    80004c80:	8082                	ret
      end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	9be080e7          	jalr	-1602(ra) # 80003640 <end_op>
      return -1;
    80004c8a:	557d                	li	a0,-1
    80004c8c:	b7e5                	j	80004c74 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c8e:	f5040513          	addi	a0,s0,-176
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	712080e7          	jalr	1810(ra) # 800033a4 <namei>
    80004c9a:	84aa                	mv	s1,a0
    80004c9c:	c905                	beqz	a0,80004ccc <sys_open+0x13c>
    ilock(ip);
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	f60080e7          	jalr	-160(ra) # 80002bfe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ca6:	04449703          	lh	a4,68(s1)
    80004caa:	4785                	li	a5,1
    80004cac:	f4f711e3          	bne	a4,a5,80004bee <sys_open+0x5e>
    80004cb0:	f4c42783          	lw	a5,-180(s0)
    80004cb4:	d7b9                	beqz	a5,80004c02 <sys_open+0x72>
      iunlockput(ip);
    80004cb6:	8526                	mv	a0,s1
    80004cb8:	ffffe097          	auipc	ra,0xffffe
    80004cbc:	1a8080e7          	jalr	424(ra) # 80002e60 <iunlockput>
      end_op();
    80004cc0:	fffff097          	auipc	ra,0xfffff
    80004cc4:	980080e7          	jalr	-1664(ra) # 80003640 <end_op>
      return -1;
    80004cc8:	557d                	li	a0,-1
    80004cca:	b76d                	j	80004c74 <sys_open+0xe4>
      end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	974080e7          	jalr	-1676(ra) # 80003640 <end_op>
      return -1;
    80004cd4:	557d                	li	a0,-1
    80004cd6:	bf79                	j	80004c74 <sys_open+0xe4>
    iunlockput(ip);
    80004cd8:	8526                	mv	a0,s1
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	186080e7          	jalr	390(ra) # 80002e60 <iunlockput>
    end_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	95e080e7          	jalr	-1698(ra) # 80003640 <end_op>
    return -1;
    80004cea:	557d                	li	a0,-1
    80004cec:	b761                	j	80004c74 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cee:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cf2:	04649783          	lh	a5,70(s1)
    80004cf6:	02f99223          	sh	a5,36(s3)
    80004cfa:	bf25                	j	80004c32 <sys_open+0xa2>
    itrunc(ip);
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	00e080e7          	jalr	14(ra) # 80002d0c <itrunc>
    80004d06:	bfa9                	j	80004c60 <sys_open+0xd0>
      fileclose(f);
    80004d08:	854e                	mv	a0,s3
    80004d0a:	fffff097          	auipc	ra,0xfffff
    80004d0e:	d82080e7          	jalr	-638(ra) # 80003a8c <fileclose>
    iunlockput(ip);
    80004d12:	8526                	mv	a0,s1
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	14c080e7          	jalr	332(ra) # 80002e60 <iunlockput>
    end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	924080e7          	jalr	-1756(ra) # 80003640 <end_op>
    return -1;
    80004d24:	557d                	li	a0,-1
    80004d26:	b7b9                	j	80004c74 <sys_open+0xe4>

0000000080004d28 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d28:	7175                	addi	sp,sp,-144
    80004d2a:	e506                	sd	ra,136(sp)
    80004d2c:	e122                	sd	s0,128(sp)
    80004d2e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	890080e7          	jalr	-1904(ra) # 800035c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d38:	08000613          	li	a2,128
    80004d3c:	f7040593          	addi	a1,s0,-144
    80004d40:	4501                	li	a0,0
    80004d42:	ffffd097          	auipc	ra,0xffffd
    80004d46:	2ee080e7          	jalr	750(ra) # 80002030 <argstr>
    80004d4a:	02054963          	bltz	a0,80004d7c <sys_mkdir+0x54>
    80004d4e:	4681                	li	a3,0
    80004d50:	4601                	li	a2,0
    80004d52:	4585                	li	a1,1
    80004d54:	f7040513          	addi	a0,s0,-144
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	7fe080e7          	jalr	2046(ra) # 80004556 <create>
    80004d60:	cd11                	beqz	a0,80004d7c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	0fe080e7          	jalr	254(ra) # 80002e60 <iunlockput>
  end_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	8d6080e7          	jalr	-1834(ra) # 80003640 <end_op>
  return 0;
    80004d72:	4501                	li	a0,0
}
    80004d74:	60aa                	ld	ra,136(sp)
    80004d76:	640a                	ld	s0,128(sp)
    80004d78:	6149                	addi	sp,sp,144
    80004d7a:	8082                	ret
    end_op();
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	8c4080e7          	jalr	-1852(ra) # 80003640 <end_op>
    return -1;
    80004d84:	557d                	li	a0,-1
    80004d86:	b7fd                	j	80004d74 <sys_mkdir+0x4c>

0000000080004d88 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d88:	7135                	addi	sp,sp,-160
    80004d8a:	ed06                	sd	ra,152(sp)
    80004d8c:	e922                	sd	s0,144(sp)
    80004d8e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	830080e7          	jalr	-2000(ra) # 800035c0 <begin_op>
  argint(1, &major);
    80004d98:	f6c40593          	addi	a1,s0,-148
    80004d9c:	4505                	li	a0,1
    80004d9e:	ffffd097          	auipc	ra,0xffffd
    80004da2:	252080e7          	jalr	594(ra) # 80001ff0 <argint>
  argint(2, &minor);
    80004da6:	f6840593          	addi	a1,s0,-152
    80004daa:	4509                	li	a0,2
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	244080e7          	jalr	580(ra) # 80001ff0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004db4:	08000613          	li	a2,128
    80004db8:	f7040593          	addi	a1,s0,-144
    80004dbc:	4501                	li	a0,0
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	272080e7          	jalr	626(ra) # 80002030 <argstr>
    80004dc6:	02054b63          	bltz	a0,80004dfc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dca:	f6841683          	lh	a3,-152(s0)
    80004dce:	f6c41603          	lh	a2,-148(s0)
    80004dd2:	458d                	li	a1,3
    80004dd4:	f7040513          	addi	a0,s0,-144
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	77e080e7          	jalr	1918(ra) # 80004556 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004de0:	cd11                	beqz	a0,80004dfc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de2:	ffffe097          	auipc	ra,0xffffe
    80004de6:	07e080e7          	jalr	126(ra) # 80002e60 <iunlockput>
  end_op();
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	856080e7          	jalr	-1962(ra) # 80003640 <end_op>
  return 0;
    80004df2:	4501                	li	a0,0
}
    80004df4:	60ea                	ld	ra,152(sp)
    80004df6:	644a                	ld	s0,144(sp)
    80004df8:	610d                	addi	sp,sp,160
    80004dfa:	8082                	ret
    end_op();
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	844080e7          	jalr	-1980(ra) # 80003640 <end_op>
    return -1;
    80004e04:	557d                	li	a0,-1
    80004e06:	b7fd                	j	80004df4 <sys_mknod+0x6c>

0000000080004e08 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e08:	7135                	addi	sp,sp,-160
    80004e0a:	ed06                	sd	ra,152(sp)
    80004e0c:	e922                	sd	s0,144(sp)
    80004e0e:	e526                	sd	s1,136(sp)
    80004e10:	e14a                	sd	s2,128(sp)
    80004e12:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e14:	ffffc097          	auipc	ra,0xffffc
    80004e18:	044080e7          	jalr	68(ra) # 80000e58 <myproc>
    80004e1c:	892a                	mv	s2,a0
  
  begin_op();
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	7a2080e7          	jalr	1954(ra) # 800035c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e26:	08000613          	li	a2,128
    80004e2a:	f6040593          	addi	a1,s0,-160
    80004e2e:	4501                	li	a0,0
    80004e30:	ffffd097          	auipc	ra,0xffffd
    80004e34:	200080e7          	jalr	512(ra) # 80002030 <argstr>
    80004e38:	04054b63          	bltz	a0,80004e8e <sys_chdir+0x86>
    80004e3c:	f6040513          	addi	a0,s0,-160
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	564080e7          	jalr	1380(ra) # 800033a4 <namei>
    80004e48:	84aa                	mv	s1,a0
    80004e4a:	c131                	beqz	a0,80004e8e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	db2080e7          	jalr	-590(ra) # 80002bfe <ilock>
  if(ip->type != T_DIR){
    80004e54:	04449703          	lh	a4,68(s1)
    80004e58:	4785                	li	a5,1
    80004e5a:	04f71063          	bne	a4,a5,80004e9a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e5e:	8526                	mv	a0,s1
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	e60080e7          	jalr	-416(ra) # 80002cc0 <iunlock>
  iput(p->cwd);
    80004e68:	15093503          	ld	a0,336(s2)
    80004e6c:	ffffe097          	auipc	ra,0xffffe
    80004e70:	f4c080e7          	jalr	-180(ra) # 80002db8 <iput>
  end_op();
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	7cc080e7          	jalr	1996(ra) # 80003640 <end_op>
  p->cwd = ip;
    80004e7c:	14993823          	sd	s1,336(s2)
  return 0;
    80004e80:	4501                	li	a0,0
}
    80004e82:	60ea                	ld	ra,152(sp)
    80004e84:	644a                	ld	s0,144(sp)
    80004e86:	64aa                	ld	s1,136(sp)
    80004e88:	690a                	ld	s2,128(sp)
    80004e8a:	610d                	addi	sp,sp,160
    80004e8c:	8082                	ret
    end_op();
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	7b2080e7          	jalr	1970(ra) # 80003640 <end_op>
    return -1;
    80004e96:	557d                	li	a0,-1
    80004e98:	b7ed                	j	80004e82 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	fc4080e7          	jalr	-60(ra) # 80002e60 <iunlockput>
    end_op();
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	79c080e7          	jalr	1948(ra) # 80003640 <end_op>
    return -1;
    80004eac:	557d                	li	a0,-1
    80004eae:	bfd1                	j	80004e82 <sys_chdir+0x7a>

0000000080004eb0 <sys_exec>:

uint64
sys_exec(void)
{
    80004eb0:	7145                	addi	sp,sp,-464
    80004eb2:	e786                	sd	ra,456(sp)
    80004eb4:	e3a2                	sd	s0,448(sp)
    80004eb6:	ff26                	sd	s1,440(sp)
    80004eb8:	fb4a                	sd	s2,432(sp)
    80004eba:	f74e                	sd	s3,424(sp)
    80004ebc:	f352                	sd	s4,416(sp)
    80004ebe:	ef56                	sd	s5,408(sp)
    80004ec0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004ec2:	e3840593          	addi	a1,s0,-456
    80004ec6:	4505                	li	a0,1
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	148080e7          	jalr	328(ra) # 80002010 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ed0:	08000613          	li	a2,128
    80004ed4:	f4040593          	addi	a1,s0,-192
    80004ed8:	4501                	li	a0,0
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	156080e7          	jalr	342(ra) # 80002030 <argstr>
    80004ee2:	87aa                	mv	a5,a0
    return -1;
    80004ee4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ee6:	0c07c263          	bltz	a5,80004faa <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004eea:	10000613          	li	a2,256
    80004eee:	4581                	li	a1,0
    80004ef0:	e4040513          	addi	a0,s0,-448
    80004ef4:	ffffb097          	auipc	ra,0xffffb
    80004ef8:	284080e7          	jalr	644(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004efc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f00:	89a6                	mv	s3,s1
    80004f02:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f04:	02000a13          	li	s4,32
    80004f08:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f0c:	00391513          	slli	a0,s2,0x3
    80004f10:	e3040593          	addi	a1,s0,-464
    80004f14:	e3843783          	ld	a5,-456(s0)
    80004f18:	953e                	add	a0,a0,a5
    80004f1a:	ffffd097          	auipc	ra,0xffffd
    80004f1e:	038080e7          	jalr	56(ra) # 80001f52 <fetchaddr>
    80004f22:	02054a63          	bltz	a0,80004f56 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f26:	e3043783          	ld	a5,-464(s0)
    80004f2a:	c3b9                	beqz	a5,80004f70 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f2c:	ffffb097          	auipc	ra,0xffffb
    80004f30:	1ec080e7          	jalr	492(ra) # 80000118 <kalloc>
    80004f34:	85aa                	mv	a1,a0
    80004f36:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f3a:	cd11                	beqz	a0,80004f56 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f3c:	6605                	lui	a2,0x1
    80004f3e:	e3043503          	ld	a0,-464(s0)
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	062080e7          	jalr	98(ra) # 80001fa4 <fetchstr>
    80004f4a:	00054663          	bltz	a0,80004f56 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f4e:	0905                	addi	s2,s2,1
    80004f50:	09a1                	addi	s3,s3,8
    80004f52:	fb491be3          	bne	s2,s4,80004f08 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f56:	10048913          	addi	s2,s1,256
    80004f5a:	6088                	ld	a0,0(s1)
    80004f5c:	c531                	beqz	a0,80004fa8 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f5e:	ffffb097          	auipc	ra,0xffffb
    80004f62:	0be080e7          	jalr	190(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f66:	04a1                	addi	s1,s1,8
    80004f68:	ff2499e3          	bne	s1,s2,80004f5a <sys_exec+0xaa>
  return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	a835                	j	80004faa <sys_exec+0xfa>
      argv[i] = 0;
    80004f70:	0a8e                	slli	s5,s5,0x3
    80004f72:	fc040793          	addi	a5,s0,-64
    80004f76:	9abe                	add	s5,s5,a5
    80004f78:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f7c:	e4040593          	addi	a1,s0,-448
    80004f80:	f4040513          	addi	a0,s0,-192
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	190080e7          	jalr	400(ra) # 80004114 <exec>
    80004f8c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f8e:	10048993          	addi	s3,s1,256
    80004f92:	6088                	ld	a0,0(s1)
    80004f94:	c901                	beqz	a0,80004fa4 <sys_exec+0xf4>
    kfree(argv[i]);
    80004f96:	ffffb097          	auipc	ra,0xffffb
    80004f9a:	086080e7          	jalr	134(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f9e:	04a1                	addi	s1,s1,8
    80004fa0:	ff3499e3          	bne	s1,s3,80004f92 <sys_exec+0xe2>
  return ret;
    80004fa4:	854a                	mv	a0,s2
    80004fa6:	a011                	j	80004faa <sys_exec+0xfa>
  return -1;
    80004fa8:	557d                	li	a0,-1
}
    80004faa:	60be                	ld	ra,456(sp)
    80004fac:	641e                	ld	s0,448(sp)
    80004fae:	74fa                	ld	s1,440(sp)
    80004fb0:	795a                	ld	s2,432(sp)
    80004fb2:	79ba                	ld	s3,424(sp)
    80004fb4:	7a1a                	ld	s4,416(sp)
    80004fb6:	6afa                	ld	s5,408(sp)
    80004fb8:	6179                	addi	sp,sp,464
    80004fba:	8082                	ret

0000000080004fbc <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fbc:	7139                	addi	sp,sp,-64
    80004fbe:	fc06                	sd	ra,56(sp)
    80004fc0:	f822                	sd	s0,48(sp)
    80004fc2:	f426                	sd	s1,40(sp)
    80004fc4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fc6:	ffffc097          	auipc	ra,0xffffc
    80004fca:	e92080e7          	jalr	-366(ra) # 80000e58 <myproc>
    80004fce:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fd0:	fd840593          	addi	a1,s0,-40
    80004fd4:	4501                	li	a0,0
    80004fd6:	ffffd097          	auipc	ra,0xffffd
    80004fda:	03a080e7          	jalr	58(ra) # 80002010 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fde:	fc840593          	addi	a1,s0,-56
    80004fe2:	fd040513          	addi	a0,s0,-48
    80004fe6:	fffff097          	auipc	ra,0xfffff
    80004fea:	dd6080e7          	jalr	-554(ra) # 80003dbc <pipealloc>
    return -1;
    80004fee:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ff0:	0c054463          	bltz	a0,800050b8 <sys_pipe+0xfc>
  fd0 = -1;
    80004ff4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004ff8:	fd043503          	ld	a0,-48(s0)
    80004ffc:	fffff097          	auipc	ra,0xfffff
    80005000:	518080e7          	jalr	1304(ra) # 80004514 <fdalloc>
    80005004:	fca42223          	sw	a0,-60(s0)
    80005008:	08054b63          	bltz	a0,8000509e <sys_pipe+0xe2>
    8000500c:	fc843503          	ld	a0,-56(s0)
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	504080e7          	jalr	1284(ra) # 80004514 <fdalloc>
    80005018:	fca42023          	sw	a0,-64(s0)
    8000501c:	06054863          	bltz	a0,8000508c <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005020:	4691                	li	a3,4
    80005022:	fc440613          	addi	a2,s0,-60
    80005026:	fd843583          	ld	a1,-40(s0)
    8000502a:	68a8                	ld	a0,80(s1)
    8000502c:	ffffc097          	auipc	ra,0xffffc
    80005030:	aea080e7          	jalr	-1302(ra) # 80000b16 <copyout>
    80005034:	02054063          	bltz	a0,80005054 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005038:	4691                	li	a3,4
    8000503a:	fc040613          	addi	a2,s0,-64
    8000503e:	fd843583          	ld	a1,-40(s0)
    80005042:	0591                	addi	a1,a1,4
    80005044:	68a8                	ld	a0,80(s1)
    80005046:	ffffc097          	auipc	ra,0xffffc
    8000504a:	ad0080e7          	jalr	-1328(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000504e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005050:	06055463          	bgez	a0,800050b8 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005054:	fc442783          	lw	a5,-60(s0)
    80005058:	07e9                	addi	a5,a5,26
    8000505a:	078e                	slli	a5,a5,0x3
    8000505c:	97a6                	add	a5,a5,s1
    8000505e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005062:	fc042503          	lw	a0,-64(s0)
    80005066:	0569                	addi	a0,a0,26
    80005068:	050e                	slli	a0,a0,0x3
    8000506a:	94aa                	add	s1,s1,a0
    8000506c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005070:	fd043503          	ld	a0,-48(s0)
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	a18080e7          	jalr	-1512(ra) # 80003a8c <fileclose>
    fileclose(wf);
    8000507c:	fc843503          	ld	a0,-56(s0)
    80005080:	fffff097          	auipc	ra,0xfffff
    80005084:	a0c080e7          	jalr	-1524(ra) # 80003a8c <fileclose>
    return -1;
    80005088:	57fd                	li	a5,-1
    8000508a:	a03d                	j	800050b8 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000508c:	fc442783          	lw	a5,-60(s0)
    80005090:	0007c763          	bltz	a5,8000509e <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005094:	07e9                	addi	a5,a5,26
    80005096:	078e                	slli	a5,a5,0x3
    80005098:	94be                	add	s1,s1,a5
    8000509a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000509e:	fd043503          	ld	a0,-48(s0)
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	9ea080e7          	jalr	-1558(ra) # 80003a8c <fileclose>
    fileclose(wf);
    800050aa:	fc843503          	ld	a0,-56(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	9de080e7          	jalr	-1570(ra) # 80003a8c <fileclose>
    return -1;
    800050b6:	57fd                	li	a5,-1
}
    800050b8:	853e                	mv	a0,a5
    800050ba:	70e2                	ld	ra,56(sp)
    800050bc:	7442                	ld	s0,48(sp)
    800050be:	74a2                	ld	s1,40(sp)
    800050c0:	6121                	addi	sp,sp,64
    800050c2:	8082                	ret
	...

00000000800050d0 <kernelvec>:
    800050d0:	7111                	addi	sp,sp,-256
    800050d2:	e006                	sd	ra,0(sp)
    800050d4:	e40a                	sd	sp,8(sp)
    800050d6:	e80e                	sd	gp,16(sp)
    800050d8:	ec12                	sd	tp,24(sp)
    800050da:	f016                	sd	t0,32(sp)
    800050dc:	f41a                	sd	t1,40(sp)
    800050de:	f81e                	sd	t2,48(sp)
    800050e0:	fc22                	sd	s0,56(sp)
    800050e2:	e0a6                	sd	s1,64(sp)
    800050e4:	e4aa                	sd	a0,72(sp)
    800050e6:	e8ae                	sd	a1,80(sp)
    800050e8:	ecb2                	sd	a2,88(sp)
    800050ea:	f0b6                	sd	a3,96(sp)
    800050ec:	f4ba                	sd	a4,104(sp)
    800050ee:	f8be                	sd	a5,112(sp)
    800050f0:	fcc2                	sd	a6,120(sp)
    800050f2:	e146                	sd	a7,128(sp)
    800050f4:	e54a                	sd	s2,136(sp)
    800050f6:	e94e                	sd	s3,144(sp)
    800050f8:	ed52                	sd	s4,152(sp)
    800050fa:	f156                	sd	s5,160(sp)
    800050fc:	f55a                	sd	s6,168(sp)
    800050fe:	f95e                	sd	s7,176(sp)
    80005100:	fd62                	sd	s8,184(sp)
    80005102:	e1e6                	sd	s9,192(sp)
    80005104:	e5ea                	sd	s10,200(sp)
    80005106:	e9ee                	sd	s11,208(sp)
    80005108:	edf2                	sd	t3,216(sp)
    8000510a:	f1f6                	sd	t4,224(sp)
    8000510c:	f5fa                	sd	t5,232(sp)
    8000510e:	f9fe                	sd	t6,240(sp)
    80005110:	d0ffc0ef          	jal	ra,80001e1e <kerneltrap>
    80005114:	6082                	ld	ra,0(sp)
    80005116:	6122                	ld	sp,8(sp)
    80005118:	61c2                	ld	gp,16(sp)
    8000511a:	7282                	ld	t0,32(sp)
    8000511c:	7322                	ld	t1,40(sp)
    8000511e:	73c2                	ld	t2,48(sp)
    80005120:	7462                	ld	s0,56(sp)
    80005122:	6486                	ld	s1,64(sp)
    80005124:	6526                	ld	a0,72(sp)
    80005126:	65c6                	ld	a1,80(sp)
    80005128:	6666                	ld	a2,88(sp)
    8000512a:	7686                	ld	a3,96(sp)
    8000512c:	7726                	ld	a4,104(sp)
    8000512e:	77c6                	ld	a5,112(sp)
    80005130:	7866                	ld	a6,120(sp)
    80005132:	688a                	ld	a7,128(sp)
    80005134:	692a                	ld	s2,136(sp)
    80005136:	69ca                	ld	s3,144(sp)
    80005138:	6a6a                	ld	s4,152(sp)
    8000513a:	7a8a                	ld	s5,160(sp)
    8000513c:	7b2a                	ld	s6,168(sp)
    8000513e:	7bca                	ld	s7,176(sp)
    80005140:	7c6a                	ld	s8,184(sp)
    80005142:	6c8e                	ld	s9,192(sp)
    80005144:	6d2e                	ld	s10,200(sp)
    80005146:	6dce                	ld	s11,208(sp)
    80005148:	6e6e                	ld	t3,216(sp)
    8000514a:	7e8e                	ld	t4,224(sp)
    8000514c:	7f2e                	ld	t5,232(sp)
    8000514e:	7fce                	ld	t6,240(sp)
    80005150:	6111                	addi	sp,sp,256
    80005152:	10200073          	sret
    80005156:	00000013          	nop
    8000515a:	00000013          	nop
    8000515e:	0001                	nop

0000000080005160 <timervec>:
    80005160:	34051573          	csrrw	a0,mscratch,a0
    80005164:	e10c                	sd	a1,0(a0)
    80005166:	e510                	sd	a2,8(a0)
    80005168:	e914                	sd	a3,16(a0)
    8000516a:	6d0c                	ld	a1,24(a0)
    8000516c:	7110                	ld	a2,32(a0)
    8000516e:	6194                	ld	a3,0(a1)
    80005170:	96b2                	add	a3,a3,a2
    80005172:	e194                	sd	a3,0(a1)
    80005174:	4589                	li	a1,2
    80005176:	14459073          	csrw	sip,a1
    8000517a:	6914                	ld	a3,16(a0)
    8000517c:	6510                	ld	a2,8(a0)
    8000517e:	610c                	ld	a1,0(a0)
    80005180:	34051573          	csrrw	a0,mscratch,a0
    80005184:	30200073          	mret
	...

000000008000518a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000518a:	1141                	addi	sp,sp,-16
    8000518c:	e422                	sd	s0,8(sp)
    8000518e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005190:	0c0007b7          	lui	a5,0xc000
    80005194:	4705                	li	a4,1
    80005196:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005198:	c3d8                	sw	a4,4(a5)
}
    8000519a:	6422                	ld	s0,8(sp)
    8000519c:	0141                	addi	sp,sp,16
    8000519e:	8082                	ret

00000000800051a0 <plicinithart>:

void
plicinithart(void)
{
    800051a0:	1141                	addi	sp,sp,-16
    800051a2:	e406                	sd	ra,8(sp)
    800051a4:	e022                	sd	s0,0(sp)
    800051a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	c84080e7          	jalr	-892(ra) # 80000e2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051b0:	0085171b          	slliw	a4,a0,0x8
    800051b4:	0c0027b7          	lui	a5,0xc002
    800051b8:	97ba                	add	a5,a5,a4
    800051ba:	40200713          	li	a4,1026
    800051be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051c2:	00d5151b          	slliw	a0,a0,0xd
    800051c6:	0c2017b7          	lui	a5,0xc201
    800051ca:	953e                	add	a0,a0,a5
    800051cc:	00052023          	sw	zero,0(a0)
}
    800051d0:	60a2                	ld	ra,8(sp)
    800051d2:	6402                	ld	s0,0(sp)
    800051d4:	0141                	addi	sp,sp,16
    800051d6:	8082                	ret

00000000800051d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051d8:	1141                	addi	sp,sp,-16
    800051da:	e406                	sd	ra,8(sp)
    800051dc:	e022                	sd	s0,0(sp)
    800051de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051e0:	ffffc097          	auipc	ra,0xffffc
    800051e4:	c4c080e7          	jalr	-948(ra) # 80000e2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051e8:	00d5179b          	slliw	a5,a0,0xd
    800051ec:	0c201537          	lui	a0,0xc201
    800051f0:	953e                	add	a0,a0,a5
  return irq;
}
    800051f2:	4148                	lw	a0,4(a0)
    800051f4:	60a2                	ld	ra,8(sp)
    800051f6:	6402                	ld	s0,0(sp)
    800051f8:	0141                	addi	sp,sp,16
    800051fa:	8082                	ret

00000000800051fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051fc:	1101                	addi	sp,sp,-32
    800051fe:	ec06                	sd	ra,24(sp)
    80005200:	e822                	sd	s0,16(sp)
    80005202:	e426                	sd	s1,8(sp)
    80005204:	1000                	addi	s0,sp,32
    80005206:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005208:	ffffc097          	auipc	ra,0xffffc
    8000520c:	c24080e7          	jalr	-988(ra) # 80000e2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005210:	00d5151b          	slliw	a0,a0,0xd
    80005214:	0c2017b7          	lui	a5,0xc201
    80005218:	97aa                	add	a5,a5,a0
    8000521a:	c3c4                	sw	s1,4(a5)
}
    8000521c:	60e2                	ld	ra,24(sp)
    8000521e:	6442                	ld	s0,16(sp)
    80005220:	64a2                	ld	s1,8(sp)
    80005222:	6105                	addi	sp,sp,32
    80005224:	8082                	ret

0000000080005226 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005226:	1141                	addi	sp,sp,-16
    80005228:	e406                	sd	ra,8(sp)
    8000522a:	e022                	sd	s0,0(sp)
    8000522c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000522e:	479d                	li	a5,7
    80005230:	04a7cc63          	blt	a5,a0,80005288 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005234:	00015797          	auipc	a5,0x15
    80005238:	1ac78793          	addi	a5,a5,428 # 8001a3e0 <disk>
    8000523c:	97aa                	add	a5,a5,a0
    8000523e:	0187c783          	lbu	a5,24(a5)
    80005242:	ebb9                	bnez	a5,80005298 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005244:	00451613          	slli	a2,a0,0x4
    80005248:	00015797          	auipc	a5,0x15
    8000524c:	19878793          	addi	a5,a5,408 # 8001a3e0 <disk>
    80005250:	6394                	ld	a3,0(a5)
    80005252:	96b2                	add	a3,a3,a2
    80005254:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005258:	6398                	ld	a4,0(a5)
    8000525a:	9732                	add	a4,a4,a2
    8000525c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005260:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005264:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005268:	953e                	add	a0,a0,a5
    8000526a:	4785                	li	a5,1
    8000526c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005270:	00015517          	auipc	a0,0x15
    80005274:	18850513          	addi	a0,a0,392 # 8001a3f8 <disk+0x18>
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	328080e7          	jalr	808(ra) # 800015a0 <wakeup>
}
    80005280:	60a2                	ld	ra,8(sp)
    80005282:	6402                	ld	s0,0(sp)
    80005284:	0141                	addi	sp,sp,16
    80005286:	8082                	ret
    panic("free_desc 1");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	44850513          	addi	a0,a0,1096 # 800086d0 <syscalls+0x300>
    80005290:	00001097          	auipc	ra,0x1
    80005294:	afe080e7          	jalr	-1282(ra) # 80005d8e <panic>
    panic("free_desc 2");
    80005298:	00003517          	auipc	a0,0x3
    8000529c:	44850513          	addi	a0,a0,1096 # 800086e0 <syscalls+0x310>
    800052a0:	00001097          	auipc	ra,0x1
    800052a4:	aee080e7          	jalr	-1298(ra) # 80005d8e <panic>

00000000800052a8 <virtio_disk_init>:
{
    800052a8:	1101                	addi	sp,sp,-32
    800052aa:	ec06                	sd	ra,24(sp)
    800052ac:	e822                	sd	s0,16(sp)
    800052ae:	e426                	sd	s1,8(sp)
    800052b0:	e04a                	sd	s2,0(sp)
    800052b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052b4:	00003597          	auipc	a1,0x3
    800052b8:	43c58593          	addi	a1,a1,1084 # 800086f0 <syscalls+0x320>
    800052bc:	00015517          	auipc	a0,0x15
    800052c0:	24c50513          	addi	a0,a0,588 # 8001a508 <disk+0x128>
    800052c4:	00001097          	auipc	ra,0x1
    800052c8:	f5a080e7          	jalr	-166(ra) # 8000621e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052cc:	100017b7          	lui	a5,0x10001
    800052d0:	4398                	lw	a4,0(a5)
    800052d2:	2701                	sext.w	a4,a4
    800052d4:	747277b7          	lui	a5,0x74727
    800052d8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052dc:	14f71e63          	bne	a4,a5,80005438 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e0:	100017b7          	lui	a5,0x10001
    800052e4:	43dc                	lw	a5,4(a5)
    800052e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052e8:	4709                	li	a4,2
    800052ea:	14e79763          	bne	a5,a4,80005438 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ee:	100017b7          	lui	a5,0x10001
    800052f2:	479c                	lw	a5,8(a5)
    800052f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052f6:	14e79163          	bne	a5,a4,80005438 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052fa:	100017b7          	lui	a5,0x10001
    800052fe:	47d8                	lw	a4,12(a5)
    80005300:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005302:	554d47b7          	lui	a5,0x554d4
    80005306:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000530a:	12f71763          	bne	a4,a5,80005438 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530e:	100017b7          	lui	a5,0x10001
    80005312:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005316:	4705                	li	a4,1
    80005318:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531a:	470d                	li	a4,3
    8000531c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000531e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005320:	c7ffe737          	lui	a4,0xc7ffe
    80005324:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbfff>
    80005328:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000532a:	2701                	sext.w	a4,a4
    8000532c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000532e:	472d                	li	a4,11
    80005330:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005332:	0707a903          	lw	s2,112(a5)
    80005336:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005338:	00897793          	andi	a5,s2,8
    8000533c:	10078663          	beqz	a5,80005448 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005340:	100017b7          	lui	a5,0x10001
    80005344:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005348:	43fc                	lw	a5,68(a5)
    8000534a:	2781                	sext.w	a5,a5
    8000534c:	10079663          	bnez	a5,80005458 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005350:	100017b7          	lui	a5,0x10001
    80005354:	5bdc                	lw	a5,52(a5)
    80005356:	2781                	sext.w	a5,a5
  if(max == 0)
    80005358:	10078863          	beqz	a5,80005468 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000535c:	471d                	li	a4,7
    8000535e:	10f77d63          	bgeu	a4,a5,80005478 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005362:	ffffb097          	auipc	ra,0xffffb
    80005366:	db6080e7          	jalr	-586(ra) # 80000118 <kalloc>
    8000536a:	00015497          	auipc	s1,0x15
    8000536e:	07648493          	addi	s1,s1,118 # 8001a3e0 <disk>
    80005372:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005374:	ffffb097          	auipc	ra,0xffffb
    80005378:	da4080e7          	jalr	-604(ra) # 80000118 <kalloc>
    8000537c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000537e:	ffffb097          	auipc	ra,0xffffb
    80005382:	d9a080e7          	jalr	-614(ra) # 80000118 <kalloc>
    80005386:	87aa                	mv	a5,a0
    80005388:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000538a:	6088                	ld	a0,0(s1)
    8000538c:	cd75                	beqz	a0,80005488 <virtio_disk_init+0x1e0>
    8000538e:	00015717          	auipc	a4,0x15
    80005392:	05a73703          	ld	a4,90(a4) # 8001a3e8 <disk+0x8>
    80005396:	cb6d                	beqz	a4,80005488 <virtio_disk_init+0x1e0>
    80005398:	cbe5                	beqz	a5,80005488 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000539a:	6605                	lui	a2,0x1
    8000539c:	4581                	li	a1,0
    8000539e:	ffffb097          	auipc	ra,0xffffb
    800053a2:	dda080e7          	jalr	-550(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800053a6:	00015497          	auipc	s1,0x15
    800053aa:	03a48493          	addi	s1,s1,58 # 8001a3e0 <disk>
    800053ae:	6605                	lui	a2,0x1
    800053b0:	4581                	li	a1,0
    800053b2:	6488                	ld	a0,8(s1)
    800053b4:	ffffb097          	auipc	ra,0xffffb
    800053b8:	dc4080e7          	jalr	-572(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    800053bc:	6605                	lui	a2,0x1
    800053be:	4581                	li	a1,0
    800053c0:	6888                	ld	a0,16(s1)
    800053c2:	ffffb097          	auipc	ra,0xffffb
    800053c6:	db6080e7          	jalr	-586(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053ca:	100017b7          	lui	a5,0x10001
    800053ce:	4721                	li	a4,8
    800053d0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053d2:	4098                	lw	a4,0(s1)
    800053d4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053d8:	40d8                	lw	a4,4(s1)
    800053da:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053de:	6498                	ld	a4,8(s1)
    800053e0:	0007069b          	sext.w	a3,a4
    800053e4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053e8:	9701                	srai	a4,a4,0x20
    800053ea:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053ee:	6898                	ld	a4,16(s1)
    800053f0:	0007069b          	sext.w	a3,a4
    800053f4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053f8:	9701                	srai	a4,a4,0x20
    800053fa:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053fe:	4685                	li	a3,1
    80005400:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005402:	4705                	li	a4,1
    80005404:	00d48c23          	sb	a3,24(s1)
    80005408:	00e48ca3          	sb	a4,25(s1)
    8000540c:	00e48d23          	sb	a4,26(s1)
    80005410:	00e48da3          	sb	a4,27(s1)
    80005414:	00e48e23          	sb	a4,28(s1)
    80005418:	00e48ea3          	sb	a4,29(s1)
    8000541c:	00e48f23          	sb	a4,30(s1)
    80005420:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005424:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	0727a823          	sw	s2,112(a5)
}
    8000542c:	60e2                	ld	ra,24(sp)
    8000542e:	6442                	ld	s0,16(sp)
    80005430:	64a2                	ld	s1,8(sp)
    80005432:	6902                	ld	s2,0(sp)
    80005434:	6105                	addi	sp,sp,32
    80005436:	8082                	ret
    panic("could not find virtio disk");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	2c850513          	addi	a0,a0,712 # 80008700 <syscalls+0x330>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	94e080e7          	jalr	-1714(ra) # 80005d8e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	2d850513          	addi	a0,a0,728 # 80008720 <syscalls+0x350>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	93e080e7          	jalr	-1730(ra) # 80005d8e <panic>
    panic("virtio disk should not be ready");
    80005458:	00003517          	auipc	a0,0x3
    8000545c:	2e850513          	addi	a0,a0,744 # 80008740 <syscalls+0x370>
    80005460:	00001097          	auipc	ra,0x1
    80005464:	92e080e7          	jalr	-1746(ra) # 80005d8e <panic>
    panic("virtio disk has no queue 0");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	2f850513          	addi	a0,a0,760 # 80008760 <syscalls+0x390>
    80005470:	00001097          	auipc	ra,0x1
    80005474:	91e080e7          	jalr	-1762(ra) # 80005d8e <panic>
    panic("virtio disk max queue too short");
    80005478:	00003517          	auipc	a0,0x3
    8000547c:	30850513          	addi	a0,a0,776 # 80008780 <syscalls+0x3b0>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	90e080e7          	jalr	-1778(ra) # 80005d8e <panic>
    panic("virtio disk kalloc");
    80005488:	00003517          	auipc	a0,0x3
    8000548c:	31850513          	addi	a0,a0,792 # 800087a0 <syscalls+0x3d0>
    80005490:	00001097          	auipc	ra,0x1
    80005494:	8fe080e7          	jalr	-1794(ra) # 80005d8e <panic>

0000000080005498 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005498:	7159                	addi	sp,sp,-112
    8000549a:	f486                	sd	ra,104(sp)
    8000549c:	f0a2                	sd	s0,96(sp)
    8000549e:	eca6                	sd	s1,88(sp)
    800054a0:	e8ca                	sd	s2,80(sp)
    800054a2:	e4ce                	sd	s3,72(sp)
    800054a4:	e0d2                	sd	s4,64(sp)
    800054a6:	fc56                	sd	s5,56(sp)
    800054a8:	f85a                	sd	s6,48(sp)
    800054aa:	f45e                	sd	s7,40(sp)
    800054ac:	f062                	sd	s8,32(sp)
    800054ae:	ec66                	sd	s9,24(sp)
    800054b0:	e86a                	sd	s10,16(sp)
    800054b2:	1880                	addi	s0,sp,112
    800054b4:	892a                	mv	s2,a0
    800054b6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054b8:	00c52c83          	lw	s9,12(a0)
    800054bc:	001c9c9b          	slliw	s9,s9,0x1
    800054c0:	1c82                	slli	s9,s9,0x20
    800054c2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054c6:	00015517          	auipc	a0,0x15
    800054ca:	04250513          	addi	a0,a0,66 # 8001a508 <disk+0x128>
    800054ce:	00001097          	auipc	ra,0x1
    800054d2:	de0080e7          	jalr	-544(ra) # 800062ae <acquire>
  for(int i = 0; i < 3; i++){
    800054d6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054d8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800054da:	00015b17          	auipc	s6,0x15
    800054de:	f06b0b13          	addi	s6,s6,-250 # 8001a3e0 <disk>
  for(int i = 0; i < 3; i++){
    800054e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054e4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054e6:	00015c17          	auipc	s8,0x15
    800054ea:	022c0c13          	addi	s8,s8,34 # 8001a508 <disk+0x128>
    800054ee:	a8b5                	j	8000556a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800054f0:	00fb06b3          	add	a3,s6,a5
    800054f4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054f8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054fa:	0207c563          	bltz	a5,80005524 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800054fe:	2485                	addiw	s1,s1,1
    80005500:	0711                	addi	a4,a4,4
    80005502:	1f548a63          	beq	s1,s5,800056f6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005506:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005508:	00015697          	auipc	a3,0x15
    8000550c:	ed868693          	addi	a3,a3,-296 # 8001a3e0 <disk>
    80005510:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005512:	0186c583          	lbu	a1,24(a3)
    80005516:	fde9                	bnez	a1,800054f0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005518:	2785                	addiw	a5,a5,1
    8000551a:	0685                	addi	a3,a3,1
    8000551c:	ff779be3          	bne	a5,s7,80005512 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005520:	57fd                	li	a5,-1
    80005522:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005524:	02905a63          	blez	s1,80005558 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005528:	f9042503          	lw	a0,-112(s0)
    8000552c:	00000097          	auipc	ra,0x0
    80005530:	cfa080e7          	jalr	-774(ra) # 80005226 <free_desc>
      for(int j = 0; j < i; j++)
    80005534:	4785                	li	a5,1
    80005536:	0297d163          	bge	a5,s1,80005558 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000553a:	f9442503          	lw	a0,-108(s0)
    8000553e:	00000097          	auipc	ra,0x0
    80005542:	ce8080e7          	jalr	-792(ra) # 80005226 <free_desc>
      for(int j = 0; j < i; j++)
    80005546:	4789                	li	a5,2
    80005548:	0097d863          	bge	a5,s1,80005558 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000554c:	f9842503          	lw	a0,-104(s0)
    80005550:	00000097          	auipc	ra,0x0
    80005554:	cd6080e7          	jalr	-810(ra) # 80005226 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005558:	85e2                	mv	a1,s8
    8000555a:	00015517          	auipc	a0,0x15
    8000555e:	e9e50513          	addi	a0,a0,-354 # 8001a3f8 <disk+0x18>
    80005562:	ffffc097          	auipc	ra,0xffffc
    80005566:	fda080e7          	jalr	-38(ra) # 8000153c <sleep>
  for(int i = 0; i < 3; i++){
    8000556a:	f9040713          	addi	a4,s0,-112
    8000556e:	84ce                	mv	s1,s3
    80005570:	bf59                	j	80005506 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005572:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005576:	00479693          	slli	a3,a5,0x4
    8000557a:	00015797          	auipc	a5,0x15
    8000557e:	e6678793          	addi	a5,a5,-410 # 8001a3e0 <disk>
    80005582:	97b6                	add	a5,a5,a3
    80005584:	4685                	li	a3,1
    80005586:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005588:	00015597          	auipc	a1,0x15
    8000558c:	e5858593          	addi	a1,a1,-424 # 8001a3e0 <disk>
    80005590:	00a60793          	addi	a5,a2,10
    80005594:	0792                	slli	a5,a5,0x4
    80005596:	97ae                	add	a5,a5,a1
    80005598:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000559c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055a0:	f6070693          	addi	a3,a4,-160
    800055a4:	619c                	ld	a5,0(a1)
    800055a6:	97b6                	add	a5,a5,a3
    800055a8:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055aa:	6188                	ld	a0,0(a1)
    800055ac:	96aa                	add	a3,a3,a0
    800055ae:	47c1                	li	a5,16
    800055b0:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055b2:	4785                	li	a5,1
    800055b4:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800055b8:	f9442783          	lw	a5,-108(s0)
    800055bc:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055c0:	0792                	slli	a5,a5,0x4
    800055c2:	953e                	add	a0,a0,a5
    800055c4:	05890693          	addi	a3,s2,88
    800055c8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800055ca:	6188                	ld	a0,0(a1)
    800055cc:	97aa                	add	a5,a5,a0
    800055ce:	40000693          	li	a3,1024
    800055d2:	c794                	sw	a3,8(a5)
  if(write)
    800055d4:	100d0d63          	beqz	s10,800056ee <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055d8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055dc:	00c7d683          	lhu	a3,12(a5)
    800055e0:	0016e693          	ori	a3,a3,1
    800055e4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800055e8:	f9842583          	lw	a1,-104(s0)
    800055ec:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055f0:	00015697          	auipc	a3,0x15
    800055f4:	df068693          	addi	a3,a3,-528 # 8001a3e0 <disk>
    800055f8:	00260793          	addi	a5,a2,2
    800055fc:	0792                	slli	a5,a5,0x4
    800055fe:	97b6                	add	a5,a5,a3
    80005600:	587d                	li	a6,-1
    80005602:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005606:	0592                	slli	a1,a1,0x4
    80005608:	952e                	add	a0,a0,a1
    8000560a:	f9070713          	addi	a4,a4,-112
    8000560e:	9736                	add	a4,a4,a3
    80005610:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005612:	6298                	ld	a4,0(a3)
    80005614:	972e                	add	a4,a4,a1
    80005616:	4585                	li	a1,1
    80005618:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000561a:	4509                	li	a0,2
    8000561c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005620:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005624:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005628:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000562c:	6698                	ld	a4,8(a3)
    8000562e:	00275783          	lhu	a5,2(a4)
    80005632:	8b9d                	andi	a5,a5,7
    80005634:	0786                	slli	a5,a5,0x1
    80005636:	97ba                	add	a5,a5,a4
    80005638:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000563c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005640:	6698                	ld	a4,8(a3)
    80005642:	00275783          	lhu	a5,2(a4)
    80005646:	2785                	addiw	a5,a5,1
    80005648:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000564c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005650:	100017b7          	lui	a5,0x10001
    80005654:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005658:	00492703          	lw	a4,4(s2)
    8000565c:	4785                	li	a5,1
    8000565e:	02f71163          	bne	a4,a5,80005680 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005662:	00015997          	auipc	s3,0x15
    80005666:	ea698993          	addi	s3,s3,-346 # 8001a508 <disk+0x128>
  while(b->disk == 1) {
    8000566a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000566c:	85ce                	mv	a1,s3
    8000566e:	854a                	mv	a0,s2
    80005670:	ffffc097          	auipc	ra,0xffffc
    80005674:	ecc080e7          	jalr	-308(ra) # 8000153c <sleep>
  while(b->disk == 1) {
    80005678:	00492783          	lw	a5,4(s2)
    8000567c:	fe9788e3          	beq	a5,s1,8000566c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005680:	f9042903          	lw	s2,-112(s0)
    80005684:	00290793          	addi	a5,s2,2
    80005688:	00479713          	slli	a4,a5,0x4
    8000568c:	00015797          	auipc	a5,0x15
    80005690:	d5478793          	addi	a5,a5,-684 # 8001a3e0 <disk>
    80005694:	97ba                	add	a5,a5,a4
    80005696:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000569a:	00015997          	auipc	s3,0x15
    8000569e:	d4698993          	addi	s3,s3,-698 # 8001a3e0 <disk>
    800056a2:	00491713          	slli	a4,s2,0x4
    800056a6:	0009b783          	ld	a5,0(s3)
    800056aa:	97ba                	add	a5,a5,a4
    800056ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056b0:	854a                	mv	a0,s2
    800056b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056b6:	00000097          	auipc	ra,0x0
    800056ba:	b70080e7          	jalr	-1168(ra) # 80005226 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056be:	8885                	andi	s1,s1,1
    800056c0:	f0ed                	bnez	s1,800056a2 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056c2:	00015517          	auipc	a0,0x15
    800056c6:	e4650513          	addi	a0,a0,-442 # 8001a508 <disk+0x128>
    800056ca:	00001097          	auipc	ra,0x1
    800056ce:	c98080e7          	jalr	-872(ra) # 80006362 <release>
}
    800056d2:	70a6                	ld	ra,104(sp)
    800056d4:	7406                	ld	s0,96(sp)
    800056d6:	64e6                	ld	s1,88(sp)
    800056d8:	6946                	ld	s2,80(sp)
    800056da:	69a6                	ld	s3,72(sp)
    800056dc:	6a06                	ld	s4,64(sp)
    800056de:	7ae2                	ld	s5,56(sp)
    800056e0:	7b42                	ld	s6,48(sp)
    800056e2:	7ba2                	ld	s7,40(sp)
    800056e4:	7c02                	ld	s8,32(sp)
    800056e6:	6ce2                	ld	s9,24(sp)
    800056e8:	6d42                	ld	s10,16(sp)
    800056ea:	6165                	addi	sp,sp,112
    800056ec:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056ee:	4689                	li	a3,2
    800056f0:	00d79623          	sh	a3,12(a5)
    800056f4:	b5e5                	j	800055dc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056f6:	f9042603          	lw	a2,-112(s0)
    800056fa:	00a60713          	addi	a4,a2,10
    800056fe:	0712                	slli	a4,a4,0x4
    80005700:	00015517          	auipc	a0,0x15
    80005704:	ce850513          	addi	a0,a0,-792 # 8001a3e8 <disk+0x8>
    80005708:	953a                	add	a0,a0,a4
  if(write)
    8000570a:	e60d14e3          	bnez	s10,80005572 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000570e:	00a60793          	addi	a5,a2,10
    80005712:	00479693          	slli	a3,a5,0x4
    80005716:	00015797          	auipc	a5,0x15
    8000571a:	cca78793          	addi	a5,a5,-822 # 8001a3e0 <disk>
    8000571e:	97b6                	add	a5,a5,a3
    80005720:	0007a423          	sw	zero,8(a5)
    80005724:	b595                	j	80005588 <virtio_disk_rw+0xf0>

0000000080005726 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005726:	1101                	addi	sp,sp,-32
    80005728:	ec06                	sd	ra,24(sp)
    8000572a:	e822                	sd	s0,16(sp)
    8000572c:	e426                	sd	s1,8(sp)
    8000572e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005730:	00015497          	auipc	s1,0x15
    80005734:	cb048493          	addi	s1,s1,-848 # 8001a3e0 <disk>
    80005738:	00015517          	auipc	a0,0x15
    8000573c:	dd050513          	addi	a0,a0,-560 # 8001a508 <disk+0x128>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	b6e080e7          	jalr	-1170(ra) # 800062ae <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005748:	10001737          	lui	a4,0x10001
    8000574c:	533c                	lw	a5,96(a4)
    8000574e:	8b8d                	andi	a5,a5,3
    80005750:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005752:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005756:	689c                	ld	a5,16(s1)
    80005758:	0204d703          	lhu	a4,32(s1)
    8000575c:	0027d783          	lhu	a5,2(a5)
    80005760:	04f70863          	beq	a4,a5,800057b0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005764:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005768:	6898                	ld	a4,16(s1)
    8000576a:	0204d783          	lhu	a5,32(s1)
    8000576e:	8b9d                	andi	a5,a5,7
    80005770:	078e                	slli	a5,a5,0x3
    80005772:	97ba                	add	a5,a5,a4
    80005774:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005776:	00278713          	addi	a4,a5,2
    8000577a:	0712                	slli	a4,a4,0x4
    8000577c:	9726                	add	a4,a4,s1
    8000577e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005782:	e721                	bnez	a4,800057ca <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005784:	0789                	addi	a5,a5,2
    80005786:	0792                	slli	a5,a5,0x4
    80005788:	97a6                	add	a5,a5,s1
    8000578a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000578c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005790:	ffffc097          	auipc	ra,0xffffc
    80005794:	e10080e7          	jalr	-496(ra) # 800015a0 <wakeup>

    disk.used_idx += 1;
    80005798:	0204d783          	lhu	a5,32(s1)
    8000579c:	2785                	addiw	a5,a5,1
    8000579e:	17c2                	slli	a5,a5,0x30
    800057a0:	93c1                	srli	a5,a5,0x30
    800057a2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057a6:	6898                	ld	a4,16(s1)
    800057a8:	00275703          	lhu	a4,2(a4)
    800057ac:	faf71ce3          	bne	a4,a5,80005764 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057b0:	00015517          	auipc	a0,0x15
    800057b4:	d5850513          	addi	a0,a0,-680 # 8001a508 <disk+0x128>
    800057b8:	00001097          	auipc	ra,0x1
    800057bc:	baa080e7          	jalr	-1110(ra) # 80006362 <release>
}
    800057c0:	60e2                	ld	ra,24(sp)
    800057c2:	6442                	ld	s0,16(sp)
    800057c4:	64a2                	ld	s1,8(sp)
    800057c6:	6105                	addi	sp,sp,32
    800057c8:	8082                	ret
      panic("virtio_disk_intr status");
    800057ca:	00003517          	auipc	a0,0x3
    800057ce:	fee50513          	addi	a0,a0,-18 # 800087b8 <syscalls+0x3e8>
    800057d2:	00000097          	auipc	ra,0x0
    800057d6:	5bc080e7          	jalr	1468(ra) # 80005d8e <panic>

00000000800057da <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057da:	1141                	addi	sp,sp,-16
    800057dc:	e422                	sd	s0,8(sp)
    800057de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057e0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057e4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057e8:	0037979b          	slliw	a5,a5,0x3
    800057ec:	02004737          	lui	a4,0x2004
    800057f0:	97ba                	add	a5,a5,a4
    800057f2:	0200c737          	lui	a4,0x200c
    800057f6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057fa:	000f4637          	lui	a2,0xf4
    800057fe:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005802:	95b2                	add	a1,a1,a2
    80005804:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005806:	00269713          	slli	a4,a3,0x2
    8000580a:	9736                	add	a4,a4,a3
    8000580c:	00371693          	slli	a3,a4,0x3
    80005810:	00015717          	auipc	a4,0x15
    80005814:	d1070713          	addi	a4,a4,-752 # 8001a520 <timer_scratch>
    80005818:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000581a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000581c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000581e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005822:	00000797          	auipc	a5,0x0
    80005826:	93e78793          	addi	a5,a5,-1730 # 80005160 <timervec>
    8000582a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000582e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005832:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005836:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000583a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000583e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005842:	30479073          	csrw	mie,a5
}
    80005846:	6422                	ld	s0,8(sp)
    80005848:	0141                	addi	sp,sp,16
    8000584a:	8082                	ret

000000008000584c <start>:
{
    8000584c:	1141                	addi	sp,sp,-16
    8000584e:	e406                	sd	ra,8(sp)
    80005850:	e022                	sd	s0,0(sp)
    80005852:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005854:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005858:	7779                	lui	a4,0xffffe
    8000585a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc09f>
    8000585e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005860:	6705                	lui	a4,0x1
    80005862:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005866:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005868:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000586c:	ffffb797          	auipc	a5,0xffffb
    80005870:	aba78793          	addi	a5,a5,-1350 # 80000326 <main>
    80005874:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005878:	4781                	li	a5,0
    8000587a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000587e:	67c1                	lui	a5,0x10
    80005880:	17fd                	addi	a5,a5,-1
    80005882:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005886:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000588a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000588e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005892:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005896:	57fd                	li	a5,-1
    80005898:	83a9                	srli	a5,a5,0xa
    8000589a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000589e:	47bd                	li	a5,15
    800058a0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058a4:	00000097          	auipc	ra,0x0
    800058a8:	f36080e7          	jalr	-202(ra) # 800057da <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058ac:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058b0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058b2:	823e                	mv	tp,a5
  asm volatile("mret");
    800058b4:	30200073          	mret
}
    800058b8:	60a2                	ld	ra,8(sp)
    800058ba:	6402                	ld	s0,0(sp)
    800058bc:	0141                	addi	sp,sp,16
    800058be:	8082                	ret

00000000800058c0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058c0:	715d                	addi	sp,sp,-80
    800058c2:	e486                	sd	ra,72(sp)
    800058c4:	e0a2                	sd	s0,64(sp)
    800058c6:	fc26                	sd	s1,56(sp)
    800058c8:	f84a                	sd	s2,48(sp)
    800058ca:	f44e                	sd	s3,40(sp)
    800058cc:	f052                	sd	s4,32(sp)
    800058ce:	ec56                	sd	s5,24(sp)
    800058d0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058d2:	04c05663          	blez	a2,8000591e <consolewrite+0x5e>
    800058d6:	8a2a                	mv	s4,a0
    800058d8:	84ae                	mv	s1,a1
    800058da:	89b2                	mv	s3,a2
    800058dc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058de:	5afd                	li	s5,-1
    800058e0:	4685                	li	a3,1
    800058e2:	8626                	mv	a2,s1
    800058e4:	85d2                	mv	a1,s4
    800058e6:	fbf40513          	addi	a0,s0,-65
    800058ea:	ffffc097          	auipc	ra,0xffffc
    800058ee:	0b0080e7          	jalr	176(ra) # 8000199a <either_copyin>
    800058f2:	01550c63          	beq	a0,s5,8000590a <consolewrite+0x4a>
      break;
    uartputc(c);
    800058f6:	fbf44503          	lbu	a0,-65(s0)
    800058fa:	00000097          	auipc	ra,0x0
    800058fe:	7f6080e7          	jalr	2038(ra) # 800060f0 <uartputc>
  for(i = 0; i < n; i++){
    80005902:	2905                	addiw	s2,s2,1
    80005904:	0485                	addi	s1,s1,1
    80005906:	fd299de3          	bne	s3,s2,800058e0 <consolewrite+0x20>
  }

  return i;
}
    8000590a:	854a                	mv	a0,s2
    8000590c:	60a6                	ld	ra,72(sp)
    8000590e:	6406                	ld	s0,64(sp)
    80005910:	74e2                	ld	s1,56(sp)
    80005912:	7942                	ld	s2,48(sp)
    80005914:	79a2                	ld	s3,40(sp)
    80005916:	7a02                	ld	s4,32(sp)
    80005918:	6ae2                	ld	s5,24(sp)
    8000591a:	6161                	addi	sp,sp,80
    8000591c:	8082                	ret
  for(i = 0; i < n; i++){
    8000591e:	4901                	li	s2,0
    80005920:	b7ed                	j	8000590a <consolewrite+0x4a>

0000000080005922 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005922:	7119                	addi	sp,sp,-128
    80005924:	fc86                	sd	ra,120(sp)
    80005926:	f8a2                	sd	s0,112(sp)
    80005928:	f4a6                	sd	s1,104(sp)
    8000592a:	f0ca                	sd	s2,96(sp)
    8000592c:	ecce                	sd	s3,88(sp)
    8000592e:	e8d2                	sd	s4,80(sp)
    80005930:	e4d6                	sd	s5,72(sp)
    80005932:	e0da                	sd	s6,64(sp)
    80005934:	fc5e                	sd	s7,56(sp)
    80005936:	f862                	sd	s8,48(sp)
    80005938:	f466                	sd	s9,40(sp)
    8000593a:	f06a                	sd	s10,32(sp)
    8000593c:	ec6e                	sd	s11,24(sp)
    8000593e:	0100                	addi	s0,sp,128
    80005940:	8b2a                	mv	s6,a0
    80005942:	8aae                	mv	s5,a1
    80005944:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005946:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000594a:	0001d517          	auipc	a0,0x1d
    8000594e:	d1650513          	addi	a0,a0,-746 # 80022660 <cons>
    80005952:	00001097          	auipc	ra,0x1
    80005956:	95c080e7          	jalr	-1700(ra) # 800062ae <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000595a:	0001d497          	auipc	s1,0x1d
    8000595e:	d0648493          	addi	s1,s1,-762 # 80022660 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005962:	89a6                	mv	s3,s1
    80005964:	0001d917          	auipc	s2,0x1d
    80005968:	d9490913          	addi	s2,s2,-620 # 800226f8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000596c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000596e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005970:	4da9                	li	s11,10
  while(n > 0){
    80005972:	07405b63          	blez	s4,800059e8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005976:	0984a783          	lw	a5,152(s1)
    8000597a:	09c4a703          	lw	a4,156(s1)
    8000597e:	02f71763          	bne	a4,a5,800059ac <consoleread+0x8a>
      if(killed(myproc())){
    80005982:	ffffb097          	auipc	ra,0xffffb
    80005986:	4d6080e7          	jalr	1238(ra) # 80000e58 <myproc>
    8000598a:	ffffc097          	auipc	ra,0xffffc
    8000598e:	e5a080e7          	jalr	-422(ra) # 800017e4 <killed>
    80005992:	e535                	bnez	a0,800059fe <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005994:	85ce                	mv	a1,s3
    80005996:	854a                	mv	a0,s2
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	ba4080e7          	jalr	-1116(ra) # 8000153c <sleep>
    while(cons.r == cons.w){
    800059a0:	0984a783          	lw	a5,152(s1)
    800059a4:	09c4a703          	lw	a4,156(s1)
    800059a8:	fcf70de3          	beq	a4,a5,80005982 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059ac:	0017871b          	addiw	a4,a5,1
    800059b0:	08e4ac23          	sw	a4,152(s1)
    800059b4:	07f7f713          	andi	a4,a5,127
    800059b8:	9726                	add	a4,a4,s1
    800059ba:	01874703          	lbu	a4,24(a4)
    800059be:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059c2:	079c0663          	beq	s8,s9,80005a2e <consoleread+0x10c>
    cbuf = c;
    800059c6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ca:	4685                	li	a3,1
    800059cc:	f8f40613          	addi	a2,s0,-113
    800059d0:	85d6                	mv	a1,s5
    800059d2:	855a                	mv	a0,s6
    800059d4:	ffffc097          	auipc	ra,0xffffc
    800059d8:	f70080e7          	jalr	-144(ra) # 80001944 <either_copyout>
    800059dc:	01a50663          	beq	a0,s10,800059e8 <consoleread+0xc6>
    dst++;
    800059e0:	0a85                	addi	s5,s5,1
    --n;
    800059e2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059e4:	f9bc17e3          	bne	s8,s11,80005972 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059e8:	0001d517          	auipc	a0,0x1d
    800059ec:	c7850513          	addi	a0,a0,-904 # 80022660 <cons>
    800059f0:	00001097          	auipc	ra,0x1
    800059f4:	972080e7          	jalr	-1678(ra) # 80006362 <release>

  return target - n;
    800059f8:	414b853b          	subw	a0,s7,s4
    800059fc:	a811                	j	80005a10 <consoleread+0xee>
        release(&cons.lock);
    800059fe:	0001d517          	auipc	a0,0x1d
    80005a02:	c6250513          	addi	a0,a0,-926 # 80022660 <cons>
    80005a06:	00001097          	auipc	ra,0x1
    80005a0a:	95c080e7          	jalr	-1700(ra) # 80006362 <release>
        return -1;
    80005a0e:	557d                	li	a0,-1
}
    80005a10:	70e6                	ld	ra,120(sp)
    80005a12:	7446                	ld	s0,112(sp)
    80005a14:	74a6                	ld	s1,104(sp)
    80005a16:	7906                	ld	s2,96(sp)
    80005a18:	69e6                	ld	s3,88(sp)
    80005a1a:	6a46                	ld	s4,80(sp)
    80005a1c:	6aa6                	ld	s5,72(sp)
    80005a1e:	6b06                	ld	s6,64(sp)
    80005a20:	7be2                	ld	s7,56(sp)
    80005a22:	7c42                	ld	s8,48(sp)
    80005a24:	7ca2                	ld	s9,40(sp)
    80005a26:	7d02                	ld	s10,32(sp)
    80005a28:	6de2                	ld	s11,24(sp)
    80005a2a:	6109                	addi	sp,sp,128
    80005a2c:	8082                	ret
      if(n < target){
    80005a2e:	000a071b          	sext.w	a4,s4
    80005a32:	fb777be3          	bgeu	a4,s7,800059e8 <consoleread+0xc6>
        cons.r--;
    80005a36:	0001d717          	auipc	a4,0x1d
    80005a3a:	ccf72123          	sw	a5,-830(a4) # 800226f8 <cons+0x98>
    80005a3e:	b76d                	j	800059e8 <consoleread+0xc6>

0000000080005a40 <consputc>:
{
    80005a40:	1141                	addi	sp,sp,-16
    80005a42:	e406                	sd	ra,8(sp)
    80005a44:	e022                	sd	s0,0(sp)
    80005a46:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a48:	10000793          	li	a5,256
    80005a4c:	00f50a63          	beq	a0,a5,80005a60 <consputc+0x20>
    uartputc_sync(c);
    80005a50:	00000097          	auipc	ra,0x0
    80005a54:	5c6080e7          	jalr	1478(ra) # 80006016 <uartputc_sync>
}
    80005a58:	60a2                	ld	ra,8(sp)
    80005a5a:	6402                	ld	s0,0(sp)
    80005a5c:	0141                	addi	sp,sp,16
    80005a5e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a60:	4521                	li	a0,8
    80005a62:	00000097          	auipc	ra,0x0
    80005a66:	5b4080e7          	jalr	1460(ra) # 80006016 <uartputc_sync>
    80005a6a:	02000513          	li	a0,32
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	5a8080e7          	jalr	1448(ra) # 80006016 <uartputc_sync>
    80005a76:	4521                	li	a0,8
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	59e080e7          	jalr	1438(ra) # 80006016 <uartputc_sync>
    80005a80:	bfe1                	j	80005a58 <consputc+0x18>

0000000080005a82 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a82:	1101                	addi	sp,sp,-32
    80005a84:	ec06                	sd	ra,24(sp)
    80005a86:	e822                	sd	s0,16(sp)
    80005a88:	e426                	sd	s1,8(sp)
    80005a8a:	e04a                	sd	s2,0(sp)
    80005a8c:	1000                	addi	s0,sp,32
    80005a8e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a90:	0001d517          	auipc	a0,0x1d
    80005a94:	bd050513          	addi	a0,a0,-1072 # 80022660 <cons>
    80005a98:	00001097          	auipc	ra,0x1
    80005a9c:	816080e7          	jalr	-2026(ra) # 800062ae <acquire>

  switch(c){
    80005aa0:	47d5                	li	a5,21
    80005aa2:	0af48663          	beq	s1,a5,80005b4e <consoleintr+0xcc>
    80005aa6:	0297ca63          	blt	a5,s1,80005ada <consoleintr+0x58>
    80005aaa:	47a1                	li	a5,8
    80005aac:	0ef48763          	beq	s1,a5,80005b9a <consoleintr+0x118>
    80005ab0:	47c1                	li	a5,16
    80005ab2:	10f49a63          	bne	s1,a5,80005bc6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ab6:	ffffc097          	auipc	ra,0xffffc
    80005aba:	f3a080e7          	jalr	-198(ra) # 800019f0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005abe:	0001d517          	auipc	a0,0x1d
    80005ac2:	ba250513          	addi	a0,a0,-1118 # 80022660 <cons>
    80005ac6:	00001097          	auipc	ra,0x1
    80005aca:	89c080e7          	jalr	-1892(ra) # 80006362 <release>
}
    80005ace:	60e2                	ld	ra,24(sp)
    80005ad0:	6442                	ld	s0,16(sp)
    80005ad2:	64a2                	ld	s1,8(sp)
    80005ad4:	6902                	ld	s2,0(sp)
    80005ad6:	6105                	addi	sp,sp,32
    80005ad8:	8082                	ret
  switch(c){
    80005ada:	07f00793          	li	a5,127
    80005ade:	0af48e63          	beq	s1,a5,80005b9a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ae2:	0001d717          	auipc	a4,0x1d
    80005ae6:	b7e70713          	addi	a4,a4,-1154 # 80022660 <cons>
    80005aea:	0a072783          	lw	a5,160(a4)
    80005aee:	09872703          	lw	a4,152(a4)
    80005af2:	9f99                	subw	a5,a5,a4
    80005af4:	07f00713          	li	a4,127
    80005af8:	fcf763e3          	bltu	a4,a5,80005abe <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005afc:	47b5                	li	a5,13
    80005afe:	0cf48763          	beq	s1,a5,80005bcc <consoleintr+0x14a>
      consputc(c);
    80005b02:	8526                	mv	a0,s1
    80005b04:	00000097          	auipc	ra,0x0
    80005b08:	f3c080e7          	jalr	-196(ra) # 80005a40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b0c:	0001d797          	auipc	a5,0x1d
    80005b10:	b5478793          	addi	a5,a5,-1196 # 80022660 <cons>
    80005b14:	0a07a683          	lw	a3,160(a5)
    80005b18:	0016871b          	addiw	a4,a3,1
    80005b1c:	0007061b          	sext.w	a2,a4
    80005b20:	0ae7a023          	sw	a4,160(a5)
    80005b24:	07f6f693          	andi	a3,a3,127
    80005b28:	97b6                	add	a5,a5,a3
    80005b2a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b2e:	47a9                	li	a5,10
    80005b30:	0cf48563          	beq	s1,a5,80005bfa <consoleintr+0x178>
    80005b34:	4791                	li	a5,4
    80005b36:	0cf48263          	beq	s1,a5,80005bfa <consoleintr+0x178>
    80005b3a:	0001d797          	auipc	a5,0x1d
    80005b3e:	bbe7a783          	lw	a5,-1090(a5) # 800226f8 <cons+0x98>
    80005b42:	9f1d                	subw	a4,a4,a5
    80005b44:	08000793          	li	a5,128
    80005b48:	f6f71be3          	bne	a4,a5,80005abe <consoleintr+0x3c>
    80005b4c:	a07d                	j	80005bfa <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b4e:	0001d717          	auipc	a4,0x1d
    80005b52:	b1270713          	addi	a4,a4,-1262 # 80022660 <cons>
    80005b56:	0a072783          	lw	a5,160(a4)
    80005b5a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b5e:	0001d497          	auipc	s1,0x1d
    80005b62:	b0248493          	addi	s1,s1,-1278 # 80022660 <cons>
    while(cons.e != cons.w &&
    80005b66:	4929                	li	s2,10
    80005b68:	f4f70be3          	beq	a4,a5,80005abe <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b6c:	37fd                	addiw	a5,a5,-1
    80005b6e:	07f7f713          	andi	a4,a5,127
    80005b72:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b74:	01874703          	lbu	a4,24(a4)
    80005b78:	f52703e3          	beq	a4,s2,80005abe <consoleintr+0x3c>
      cons.e--;
    80005b7c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b80:	10000513          	li	a0,256
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	ebc080e7          	jalr	-324(ra) # 80005a40 <consputc>
    while(cons.e != cons.w &&
    80005b8c:	0a04a783          	lw	a5,160(s1)
    80005b90:	09c4a703          	lw	a4,156(s1)
    80005b94:	fcf71ce3          	bne	a4,a5,80005b6c <consoleintr+0xea>
    80005b98:	b71d                	j	80005abe <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b9a:	0001d717          	auipc	a4,0x1d
    80005b9e:	ac670713          	addi	a4,a4,-1338 # 80022660 <cons>
    80005ba2:	0a072783          	lw	a5,160(a4)
    80005ba6:	09c72703          	lw	a4,156(a4)
    80005baa:	f0f70ae3          	beq	a4,a5,80005abe <consoleintr+0x3c>
      cons.e--;
    80005bae:	37fd                	addiw	a5,a5,-1
    80005bb0:	0001d717          	auipc	a4,0x1d
    80005bb4:	b4f72823          	sw	a5,-1200(a4) # 80022700 <cons+0xa0>
      consputc(BACKSPACE);
    80005bb8:	10000513          	li	a0,256
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	e84080e7          	jalr	-380(ra) # 80005a40 <consputc>
    80005bc4:	bded                	j	80005abe <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bc6:	ee048ce3          	beqz	s1,80005abe <consoleintr+0x3c>
    80005bca:	bf21                	j	80005ae2 <consoleintr+0x60>
      consputc(c);
    80005bcc:	4529                	li	a0,10
    80005bce:	00000097          	auipc	ra,0x0
    80005bd2:	e72080e7          	jalr	-398(ra) # 80005a40 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bd6:	0001d797          	auipc	a5,0x1d
    80005bda:	a8a78793          	addi	a5,a5,-1398 # 80022660 <cons>
    80005bde:	0a07a703          	lw	a4,160(a5)
    80005be2:	0017069b          	addiw	a3,a4,1
    80005be6:	0006861b          	sext.w	a2,a3
    80005bea:	0ad7a023          	sw	a3,160(a5)
    80005bee:	07f77713          	andi	a4,a4,127
    80005bf2:	97ba                	add	a5,a5,a4
    80005bf4:	4729                	li	a4,10
    80005bf6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bfa:	0001d797          	auipc	a5,0x1d
    80005bfe:	b0c7a123          	sw	a2,-1278(a5) # 800226fc <cons+0x9c>
        wakeup(&cons.r);
    80005c02:	0001d517          	auipc	a0,0x1d
    80005c06:	af650513          	addi	a0,a0,-1290 # 800226f8 <cons+0x98>
    80005c0a:	ffffc097          	auipc	ra,0xffffc
    80005c0e:	996080e7          	jalr	-1642(ra) # 800015a0 <wakeup>
    80005c12:	b575                	j	80005abe <consoleintr+0x3c>

0000000080005c14 <consoleinit>:

void
consoleinit(void)
{
    80005c14:	1141                	addi	sp,sp,-16
    80005c16:	e406                	sd	ra,8(sp)
    80005c18:	e022                	sd	s0,0(sp)
    80005c1a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c1c:	00003597          	auipc	a1,0x3
    80005c20:	bb458593          	addi	a1,a1,-1100 # 800087d0 <syscalls+0x400>
    80005c24:	0001d517          	auipc	a0,0x1d
    80005c28:	a3c50513          	addi	a0,a0,-1476 # 80022660 <cons>
    80005c2c:	00000097          	auipc	ra,0x0
    80005c30:	5f2080e7          	jalr	1522(ra) # 8000621e <initlock>

  uartinit();
    80005c34:	00000097          	auipc	ra,0x0
    80005c38:	392080e7          	jalr	914(ra) # 80005fc6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c3c:	00013797          	auipc	a5,0x13
    80005c40:	74c78793          	addi	a5,a5,1868 # 80019388 <devsw>
    80005c44:	00000717          	auipc	a4,0x0
    80005c48:	cde70713          	addi	a4,a4,-802 # 80005922 <consoleread>
    80005c4c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c4e:	00000717          	auipc	a4,0x0
    80005c52:	c7270713          	addi	a4,a4,-910 # 800058c0 <consolewrite>
    80005c56:	ef98                	sd	a4,24(a5)
}
    80005c58:	60a2                	ld	ra,8(sp)
    80005c5a:	6402                	ld	s0,0(sp)
    80005c5c:	0141                	addi	sp,sp,16
    80005c5e:	8082                	ret

0000000080005c60 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c60:	7179                	addi	sp,sp,-48
    80005c62:	f406                	sd	ra,40(sp)
    80005c64:	f022                	sd	s0,32(sp)
    80005c66:	ec26                	sd	s1,24(sp)
    80005c68:	e84a                	sd	s2,16(sp)
    80005c6a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c6c:	c219                	beqz	a2,80005c72 <printint+0x12>
    80005c6e:	08054663          	bltz	a0,80005cfa <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c72:	2501                	sext.w	a0,a0
    80005c74:	4881                	li	a7,0
    80005c76:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c7a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c7c:	2581                	sext.w	a1,a1
    80005c7e:	00003617          	auipc	a2,0x3
    80005c82:	b9a60613          	addi	a2,a2,-1126 # 80008818 <digits>
    80005c86:	883a                	mv	a6,a4
    80005c88:	2705                	addiw	a4,a4,1
    80005c8a:	02b577bb          	remuw	a5,a0,a1
    80005c8e:	1782                	slli	a5,a5,0x20
    80005c90:	9381                	srli	a5,a5,0x20
    80005c92:	97b2                	add	a5,a5,a2
    80005c94:	0007c783          	lbu	a5,0(a5)
    80005c98:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c9c:	0005079b          	sext.w	a5,a0
    80005ca0:	02b5553b          	divuw	a0,a0,a1
    80005ca4:	0685                	addi	a3,a3,1
    80005ca6:	feb7f0e3          	bgeu	a5,a1,80005c86 <printint+0x26>

  if(sign)
    80005caa:	00088b63          	beqz	a7,80005cc0 <printint+0x60>
    buf[i++] = '-';
    80005cae:	fe040793          	addi	a5,s0,-32
    80005cb2:	973e                	add	a4,a4,a5
    80005cb4:	02d00793          	li	a5,45
    80005cb8:	fef70823          	sb	a5,-16(a4)
    80005cbc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cc0:	02e05763          	blez	a4,80005cee <printint+0x8e>
    80005cc4:	fd040793          	addi	a5,s0,-48
    80005cc8:	00e784b3          	add	s1,a5,a4
    80005ccc:	fff78913          	addi	s2,a5,-1
    80005cd0:	993a                	add	s2,s2,a4
    80005cd2:	377d                	addiw	a4,a4,-1
    80005cd4:	1702                	slli	a4,a4,0x20
    80005cd6:	9301                	srli	a4,a4,0x20
    80005cd8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cdc:	fff4c503          	lbu	a0,-1(s1)
    80005ce0:	00000097          	auipc	ra,0x0
    80005ce4:	d60080e7          	jalr	-672(ra) # 80005a40 <consputc>
  while(--i >= 0)
    80005ce8:	14fd                	addi	s1,s1,-1
    80005cea:	ff2499e3          	bne	s1,s2,80005cdc <printint+0x7c>
}
    80005cee:	70a2                	ld	ra,40(sp)
    80005cf0:	7402                	ld	s0,32(sp)
    80005cf2:	64e2                	ld	s1,24(sp)
    80005cf4:	6942                	ld	s2,16(sp)
    80005cf6:	6145                	addi	sp,sp,48
    80005cf8:	8082                	ret
    x = -xx;
    80005cfa:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cfe:	4885                	li	a7,1
    x = -xx;
    80005d00:	bf9d                	j	80005c76 <printint+0x16>

0000000080005d02 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d02:	1101                	addi	sp,sp,-32
    80005d04:	ec06                	sd	ra,24(sp)
    80005d06:	e822                	sd	s0,16(sp)
    80005d08:	e426                	sd	s1,8(sp)
    80005d0a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d0c:	0001d497          	auipc	s1,0x1d
    80005d10:	9fc48493          	addi	s1,s1,-1540 # 80022708 <pr>
    80005d14:	00003597          	auipc	a1,0x3
    80005d18:	ac458593          	addi	a1,a1,-1340 # 800087d8 <syscalls+0x408>
    80005d1c:	8526                	mv	a0,s1
    80005d1e:	00000097          	auipc	ra,0x0
    80005d22:	500080e7          	jalr	1280(ra) # 8000621e <initlock>
  pr.locking = 1;
    80005d26:	4785                	li	a5,1
    80005d28:	cc9c                	sw	a5,24(s1)
}
    80005d2a:	60e2                	ld	ra,24(sp)
    80005d2c:	6442                	ld	s0,16(sp)
    80005d2e:	64a2                	ld	s1,8(sp)
    80005d30:	6105                	addi	sp,sp,32
    80005d32:	8082                	ret

0000000080005d34 <backtrace>:

// solution: implement a backtrace() function
void
backtrace(void)
{
    80005d34:	7179                	addi	sp,sp,-48
    80005d36:	f406                	sd	ra,40(sp)
    80005d38:	f022                	sd	s0,32(sp)
    80005d3a:	ec26                	sd	s1,24(sp)
    80005d3c:	e84a                	sd	s2,16(sp)
    80005d3e:	e44e                	sd	s3,8(sp)
    80005d40:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80005d42:	00003517          	auipc	a0,0x3
    80005d46:	a9e50513          	addi	a0,a0,-1378 # 800087e0 <syscalls+0x410>
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	096080e7          	jalr	150(ra) # 80005de0 <printf>
// solution: add the following function
static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005d52:	84a2                	mv	s1,s0
  uint64 fp = r_fp(); // get the fp; 这里获取的是fp这个变量
  while(fp > PGROUNDDOWN(fp)){ // 所以下面先变指针再取值
    80005d54:	77fd                	lui	a5,0xfffff
    80005d56:	8fe5                	and	a5,a5,s1
    80005d58:	0297f463          	bgeu	a5,s1,80005d80 <backtrace+0x4c>
    printf("%p\n",*(uint64 *)(fp-8));// return address
    80005d5c:	00003997          	auipc	s3,0x3
    80005d60:	a9498993          	addi	s3,s3,-1388 # 800087f0 <syscalls+0x420>
  while(fp > PGROUNDDOWN(fp)){ // 所以下面先变指针再取值
    80005d64:	797d                	lui	s2,0xfffff
    printf("%p\n",*(uint64 *)(fp-8));// return address
    80005d66:	ff84b583          	ld	a1,-8(s1)
    80005d6a:	854e                	mv	a0,s3
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	074080e7          	jalr	116(ra) # 80005de0 <printf>
    fp = *(uint64 *)(fp-16); // fp-16: prev fp
    80005d74:	ff04b483          	ld	s1,-16(s1)
  while(fp > PGROUNDDOWN(fp)){ // 所以下面先变指针再取值
    80005d78:	0124f7b3          	and	a5,s1,s2
    80005d7c:	fe97e5e3          	bltu	a5,s1,80005d66 <backtrace+0x32>
  }
  return;
}
    80005d80:	70a2                	ld	ra,40(sp)
    80005d82:	7402                	ld	s0,32(sp)
    80005d84:	64e2                	ld	s1,24(sp)
    80005d86:	6942                	ld	s2,16(sp)
    80005d88:	69a2                	ld	s3,8(sp)
    80005d8a:	6145                	addi	sp,sp,48
    80005d8c:	8082                	ret

0000000080005d8e <panic>:
{
    80005d8e:	1101                	addi	sp,sp,-32
    80005d90:	ec06                	sd	ra,24(sp)
    80005d92:	e822                	sd	s0,16(sp)
    80005d94:	e426                	sd	s1,8(sp)
    80005d96:	1000                	addi	s0,sp,32
    80005d98:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d9a:	0001d797          	auipc	a5,0x1d
    80005d9e:	9807a323          	sw	zero,-1658(a5) # 80022720 <pr+0x18>
  printf("panic: ");
    80005da2:	00003517          	auipc	a0,0x3
    80005da6:	a5650513          	addi	a0,a0,-1450 # 800087f8 <syscalls+0x428>
    80005daa:	00000097          	auipc	ra,0x0
    80005dae:	036080e7          	jalr	54(ra) # 80005de0 <printf>
  printf(s);
    80005db2:	8526                	mv	a0,s1
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	02c080e7          	jalr	44(ra) # 80005de0 <printf>
  printf("\n");
    80005dbc:	00002517          	auipc	a0,0x2
    80005dc0:	28c50513          	addi	a0,a0,652 # 80008048 <etext+0x48>
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	01c080e7          	jalr	28(ra) # 80005de0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dcc:	4785                	li	a5,1
    80005dce:	00003717          	auipc	a4,0x3
    80005dd2:	b0f72723          	sw	a5,-1266(a4) # 800088dc <panicked>
  backtrace(); // solution: call it 
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	f5e080e7          	jalr	-162(ra) # 80005d34 <backtrace>
  for(;;)
    80005dde:	a001                	j	80005dde <panic+0x50>

0000000080005de0 <printf>:
{
    80005de0:	7131                	addi	sp,sp,-192
    80005de2:	fc86                	sd	ra,120(sp)
    80005de4:	f8a2                	sd	s0,112(sp)
    80005de6:	f4a6                	sd	s1,104(sp)
    80005de8:	f0ca                	sd	s2,96(sp)
    80005dea:	ecce                	sd	s3,88(sp)
    80005dec:	e8d2                	sd	s4,80(sp)
    80005dee:	e4d6                	sd	s5,72(sp)
    80005df0:	e0da                	sd	s6,64(sp)
    80005df2:	fc5e                	sd	s7,56(sp)
    80005df4:	f862                	sd	s8,48(sp)
    80005df6:	f466                	sd	s9,40(sp)
    80005df8:	f06a                	sd	s10,32(sp)
    80005dfa:	ec6e                	sd	s11,24(sp)
    80005dfc:	0100                	addi	s0,sp,128
    80005dfe:	8a2a                	mv	s4,a0
    80005e00:	e40c                	sd	a1,8(s0)
    80005e02:	e810                	sd	a2,16(s0)
    80005e04:	ec14                	sd	a3,24(s0)
    80005e06:	f018                	sd	a4,32(s0)
    80005e08:	f41c                	sd	a5,40(s0)
    80005e0a:	03043823          	sd	a6,48(s0)
    80005e0e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e12:	0001dd97          	auipc	s11,0x1d
    80005e16:	90edad83          	lw	s11,-1778(s11) # 80022720 <pr+0x18>
  if(locking)
    80005e1a:	020d9b63          	bnez	s11,80005e50 <printf+0x70>
  if (fmt == 0)
    80005e1e:	040a0263          	beqz	s4,80005e62 <printf+0x82>
  va_start(ap, fmt);
    80005e22:	00840793          	addi	a5,s0,8
    80005e26:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e2a:	000a4503          	lbu	a0,0(s4)
    80005e2e:	16050263          	beqz	a0,80005f92 <printf+0x1b2>
    80005e32:	4481                	li	s1,0
    if(c != '%'){
    80005e34:	02500a93          	li	s5,37
    switch(c){
    80005e38:	07000b13          	li	s6,112
  consputc('x');
    80005e3c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e3e:	00003b97          	auipc	s7,0x3
    80005e42:	9dab8b93          	addi	s7,s7,-1574 # 80008818 <digits>
    switch(c){
    80005e46:	07300c93          	li	s9,115
    80005e4a:	06400c13          	li	s8,100
    80005e4e:	a82d                	j	80005e88 <printf+0xa8>
    acquire(&pr.lock);
    80005e50:	0001d517          	auipc	a0,0x1d
    80005e54:	8b850513          	addi	a0,a0,-1864 # 80022708 <pr>
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	456080e7          	jalr	1110(ra) # 800062ae <acquire>
    80005e60:	bf7d                	j	80005e1e <printf+0x3e>
    panic("null fmt");
    80005e62:	00003517          	auipc	a0,0x3
    80005e66:	9a650513          	addi	a0,a0,-1626 # 80008808 <syscalls+0x438>
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	f24080e7          	jalr	-220(ra) # 80005d8e <panic>
      consputc(c);
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	bce080e7          	jalr	-1074(ra) # 80005a40 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e7a:	2485                	addiw	s1,s1,1
    80005e7c:	009a07b3          	add	a5,s4,s1
    80005e80:	0007c503          	lbu	a0,0(a5)
    80005e84:	10050763          	beqz	a0,80005f92 <printf+0x1b2>
    if(c != '%'){
    80005e88:	ff5515e3          	bne	a0,s5,80005e72 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e8c:	2485                	addiw	s1,s1,1
    80005e8e:	009a07b3          	add	a5,s4,s1
    80005e92:	0007c783          	lbu	a5,0(a5)
    80005e96:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e9a:	cfe5                	beqz	a5,80005f92 <printf+0x1b2>
    switch(c){
    80005e9c:	05678a63          	beq	a5,s6,80005ef0 <printf+0x110>
    80005ea0:	02fb7663          	bgeu	s6,a5,80005ecc <printf+0xec>
    80005ea4:	09978963          	beq	a5,s9,80005f36 <printf+0x156>
    80005ea8:	07800713          	li	a4,120
    80005eac:	0ce79863          	bne	a5,a4,80005f7c <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005eb0:	f8843783          	ld	a5,-120(s0)
    80005eb4:	00878713          	addi	a4,a5,8
    80005eb8:	f8e43423          	sd	a4,-120(s0)
    80005ebc:	4605                	li	a2,1
    80005ebe:	85ea                	mv	a1,s10
    80005ec0:	4388                	lw	a0,0(a5)
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	d9e080e7          	jalr	-610(ra) # 80005c60 <printint>
      break;
    80005eca:	bf45                	j	80005e7a <printf+0x9a>
    switch(c){
    80005ecc:	0b578263          	beq	a5,s5,80005f70 <printf+0x190>
    80005ed0:	0b879663          	bne	a5,s8,80005f7c <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ed4:	f8843783          	ld	a5,-120(s0)
    80005ed8:	00878713          	addi	a4,a5,8
    80005edc:	f8e43423          	sd	a4,-120(s0)
    80005ee0:	4605                	li	a2,1
    80005ee2:	45a9                	li	a1,10
    80005ee4:	4388                	lw	a0,0(a5)
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	d7a080e7          	jalr	-646(ra) # 80005c60 <printint>
      break;
    80005eee:	b771                	j	80005e7a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ef0:	f8843783          	ld	a5,-120(s0)
    80005ef4:	00878713          	addi	a4,a5,8
    80005ef8:	f8e43423          	sd	a4,-120(s0)
    80005efc:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f00:	03000513          	li	a0,48
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	b3c080e7          	jalr	-1220(ra) # 80005a40 <consputc>
  consputc('x');
    80005f0c:	07800513          	li	a0,120
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	b30080e7          	jalr	-1232(ra) # 80005a40 <consputc>
    80005f18:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f1a:	03c9d793          	srli	a5,s3,0x3c
    80005f1e:	97de                	add	a5,a5,s7
    80005f20:	0007c503          	lbu	a0,0(a5)
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	b1c080e7          	jalr	-1252(ra) # 80005a40 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f2c:	0992                	slli	s3,s3,0x4
    80005f2e:	397d                	addiw	s2,s2,-1
    80005f30:	fe0915e3          	bnez	s2,80005f1a <printf+0x13a>
    80005f34:	b799                	j	80005e7a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f36:	f8843783          	ld	a5,-120(s0)
    80005f3a:	00878713          	addi	a4,a5,8
    80005f3e:	f8e43423          	sd	a4,-120(s0)
    80005f42:	0007b903          	ld	s2,0(a5)
    80005f46:	00090e63          	beqz	s2,80005f62 <printf+0x182>
      for(; *s; s++)
    80005f4a:	00094503          	lbu	a0,0(s2) # fffffffffffff000 <end+0xffffffff7ffdc8a0>
    80005f4e:	d515                	beqz	a0,80005e7a <printf+0x9a>
        consputc(*s);
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	af0080e7          	jalr	-1296(ra) # 80005a40 <consputc>
      for(; *s; s++)
    80005f58:	0905                	addi	s2,s2,1
    80005f5a:	00094503          	lbu	a0,0(s2)
    80005f5e:	f96d                	bnez	a0,80005f50 <printf+0x170>
    80005f60:	bf29                	j	80005e7a <printf+0x9a>
        s = "(null)";
    80005f62:	00003917          	auipc	s2,0x3
    80005f66:	89e90913          	addi	s2,s2,-1890 # 80008800 <syscalls+0x430>
      for(; *s; s++)
    80005f6a:	02800513          	li	a0,40
    80005f6e:	b7cd                	j	80005f50 <printf+0x170>
      consputc('%');
    80005f70:	8556                	mv	a0,s5
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	ace080e7          	jalr	-1330(ra) # 80005a40 <consputc>
      break;
    80005f7a:	b701                	j	80005e7a <printf+0x9a>
      consputc('%');
    80005f7c:	8556                	mv	a0,s5
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	ac2080e7          	jalr	-1342(ra) # 80005a40 <consputc>
      consputc(c);
    80005f86:	854a                	mv	a0,s2
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	ab8080e7          	jalr	-1352(ra) # 80005a40 <consputc>
      break;
    80005f90:	b5ed                	j	80005e7a <printf+0x9a>
  if(locking)
    80005f92:	020d9163          	bnez	s11,80005fb4 <printf+0x1d4>
}
    80005f96:	70e6                	ld	ra,120(sp)
    80005f98:	7446                	ld	s0,112(sp)
    80005f9a:	74a6                	ld	s1,104(sp)
    80005f9c:	7906                	ld	s2,96(sp)
    80005f9e:	69e6                	ld	s3,88(sp)
    80005fa0:	6a46                	ld	s4,80(sp)
    80005fa2:	6aa6                	ld	s5,72(sp)
    80005fa4:	6b06                	ld	s6,64(sp)
    80005fa6:	7be2                	ld	s7,56(sp)
    80005fa8:	7c42                	ld	s8,48(sp)
    80005faa:	7ca2                	ld	s9,40(sp)
    80005fac:	7d02                	ld	s10,32(sp)
    80005fae:	6de2                	ld	s11,24(sp)
    80005fb0:	6129                	addi	sp,sp,192
    80005fb2:	8082                	ret
    release(&pr.lock);
    80005fb4:	0001c517          	auipc	a0,0x1c
    80005fb8:	75450513          	addi	a0,a0,1876 # 80022708 <pr>
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	3a6080e7          	jalr	934(ra) # 80006362 <release>
}
    80005fc4:	bfc9                	j	80005f96 <printf+0x1b6>

0000000080005fc6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fc6:	1141                	addi	sp,sp,-16
    80005fc8:	e406                	sd	ra,8(sp)
    80005fca:	e022                	sd	s0,0(sp)
    80005fcc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fce:	100007b7          	lui	a5,0x10000
    80005fd2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fd6:	f8000713          	li	a4,-128
    80005fda:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fde:	470d                	li	a4,3
    80005fe0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fe4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fe8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fec:	469d                	li	a3,7
    80005fee:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ff2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ff6:	00003597          	auipc	a1,0x3
    80005ffa:	83a58593          	addi	a1,a1,-1990 # 80008830 <digits+0x18>
    80005ffe:	0001c517          	auipc	a0,0x1c
    80006002:	72a50513          	addi	a0,a0,1834 # 80022728 <uart_tx_lock>
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	218080e7          	jalr	536(ra) # 8000621e <initlock>
}
    8000600e:	60a2                	ld	ra,8(sp)
    80006010:	6402                	ld	s0,0(sp)
    80006012:	0141                	addi	sp,sp,16
    80006014:	8082                	ret

0000000080006016 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006016:	1101                	addi	sp,sp,-32
    80006018:	ec06                	sd	ra,24(sp)
    8000601a:	e822                	sd	s0,16(sp)
    8000601c:	e426                	sd	s1,8(sp)
    8000601e:	1000                	addi	s0,sp,32
    80006020:	84aa                	mv	s1,a0
  push_off();
    80006022:	00000097          	auipc	ra,0x0
    80006026:	240080e7          	jalr	576(ra) # 80006262 <push_off>

  if(panicked){
    8000602a:	00003797          	auipc	a5,0x3
    8000602e:	8b27a783          	lw	a5,-1870(a5) # 800088dc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006032:	10000737          	lui	a4,0x10000
  if(panicked){
    80006036:	c391                	beqz	a5,8000603a <uartputc_sync+0x24>
    for(;;)
    80006038:	a001                	j	80006038 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000603a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000603e:	0ff7f793          	andi	a5,a5,255
    80006042:	0207f793          	andi	a5,a5,32
    80006046:	dbf5                	beqz	a5,8000603a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006048:	0ff4f793          	andi	a5,s1,255
    8000604c:	10000737          	lui	a4,0x10000
    80006050:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006054:	00000097          	auipc	ra,0x0
    80006058:	2ae080e7          	jalr	686(ra) # 80006302 <pop_off>
}
    8000605c:	60e2                	ld	ra,24(sp)
    8000605e:	6442                	ld	s0,16(sp)
    80006060:	64a2                	ld	s1,8(sp)
    80006062:	6105                	addi	sp,sp,32
    80006064:	8082                	ret

0000000080006066 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006066:	00003717          	auipc	a4,0x3
    8000606a:	87a73703          	ld	a4,-1926(a4) # 800088e0 <uart_tx_r>
    8000606e:	00003797          	auipc	a5,0x3
    80006072:	87a7b783          	ld	a5,-1926(a5) # 800088e8 <uart_tx_w>
    80006076:	06e78c63          	beq	a5,a4,800060ee <uartstart+0x88>
{
    8000607a:	7139                	addi	sp,sp,-64
    8000607c:	fc06                	sd	ra,56(sp)
    8000607e:	f822                	sd	s0,48(sp)
    80006080:	f426                	sd	s1,40(sp)
    80006082:	f04a                	sd	s2,32(sp)
    80006084:	ec4e                	sd	s3,24(sp)
    80006086:	e852                	sd	s4,16(sp)
    80006088:	e456                	sd	s5,8(sp)
    8000608a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000608c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006090:	0001ca17          	auipc	s4,0x1c
    80006094:	698a0a13          	addi	s4,s4,1688 # 80022728 <uart_tx_lock>
    uart_tx_r += 1;
    80006098:	00003497          	auipc	s1,0x3
    8000609c:	84848493          	addi	s1,s1,-1976 # 800088e0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060a0:	00003997          	auipc	s3,0x3
    800060a4:	84898993          	addi	s3,s3,-1976 # 800088e8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060a8:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060ac:	0ff7f793          	andi	a5,a5,255
    800060b0:	0207f793          	andi	a5,a5,32
    800060b4:	c785                	beqz	a5,800060dc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060b6:	01f77793          	andi	a5,a4,31
    800060ba:	97d2                	add	a5,a5,s4
    800060bc:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060c0:	0705                	addi	a4,a4,1
    800060c2:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060c4:	8526                	mv	a0,s1
    800060c6:	ffffb097          	auipc	ra,0xffffb
    800060ca:	4da080e7          	jalr	1242(ra) # 800015a0 <wakeup>
    
    WriteReg(THR, c);
    800060ce:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060d2:	6098                	ld	a4,0(s1)
    800060d4:	0009b783          	ld	a5,0(s3)
    800060d8:	fce798e3          	bne	a5,a4,800060a8 <uartstart+0x42>
  }
}
    800060dc:	70e2                	ld	ra,56(sp)
    800060de:	7442                	ld	s0,48(sp)
    800060e0:	74a2                	ld	s1,40(sp)
    800060e2:	7902                	ld	s2,32(sp)
    800060e4:	69e2                	ld	s3,24(sp)
    800060e6:	6a42                	ld	s4,16(sp)
    800060e8:	6aa2                	ld	s5,8(sp)
    800060ea:	6121                	addi	sp,sp,64
    800060ec:	8082                	ret
    800060ee:	8082                	ret

00000000800060f0 <uartputc>:
{
    800060f0:	7179                	addi	sp,sp,-48
    800060f2:	f406                	sd	ra,40(sp)
    800060f4:	f022                	sd	s0,32(sp)
    800060f6:	ec26                	sd	s1,24(sp)
    800060f8:	e84a                	sd	s2,16(sp)
    800060fa:	e44e                	sd	s3,8(sp)
    800060fc:	e052                	sd	s4,0(sp)
    800060fe:	1800                	addi	s0,sp,48
    80006100:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006102:	0001c517          	auipc	a0,0x1c
    80006106:	62650513          	addi	a0,a0,1574 # 80022728 <uart_tx_lock>
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	1a4080e7          	jalr	420(ra) # 800062ae <acquire>
  if(panicked){
    80006112:	00002797          	auipc	a5,0x2
    80006116:	7ca7a783          	lw	a5,1994(a5) # 800088dc <panicked>
    8000611a:	e7c9                	bnez	a5,800061a4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000611c:	00002797          	auipc	a5,0x2
    80006120:	7cc7b783          	ld	a5,1996(a5) # 800088e8 <uart_tx_w>
    80006124:	00002717          	auipc	a4,0x2
    80006128:	7bc73703          	ld	a4,1980(a4) # 800088e0 <uart_tx_r>
    8000612c:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006130:	0001ca17          	auipc	s4,0x1c
    80006134:	5f8a0a13          	addi	s4,s4,1528 # 80022728 <uart_tx_lock>
    80006138:	00002497          	auipc	s1,0x2
    8000613c:	7a848493          	addi	s1,s1,1960 # 800088e0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006140:	00002917          	auipc	s2,0x2
    80006144:	7a890913          	addi	s2,s2,1960 # 800088e8 <uart_tx_w>
    80006148:	00f71f63          	bne	a4,a5,80006166 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000614c:	85d2                	mv	a1,s4
    8000614e:	8526                	mv	a0,s1
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	3ec080e7          	jalr	1004(ra) # 8000153c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006158:	00093783          	ld	a5,0(s2)
    8000615c:	6098                	ld	a4,0(s1)
    8000615e:	02070713          	addi	a4,a4,32
    80006162:	fef705e3          	beq	a4,a5,8000614c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006166:	0001c497          	auipc	s1,0x1c
    8000616a:	5c248493          	addi	s1,s1,1474 # 80022728 <uart_tx_lock>
    8000616e:	01f7f713          	andi	a4,a5,31
    80006172:	9726                	add	a4,a4,s1
    80006174:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006178:	0785                	addi	a5,a5,1
    8000617a:	00002717          	auipc	a4,0x2
    8000617e:	76f73723          	sd	a5,1902(a4) # 800088e8 <uart_tx_w>
  uartstart();
    80006182:	00000097          	auipc	ra,0x0
    80006186:	ee4080e7          	jalr	-284(ra) # 80006066 <uartstart>
  release(&uart_tx_lock);
    8000618a:	8526                	mv	a0,s1
    8000618c:	00000097          	auipc	ra,0x0
    80006190:	1d6080e7          	jalr	470(ra) # 80006362 <release>
}
    80006194:	70a2                	ld	ra,40(sp)
    80006196:	7402                	ld	s0,32(sp)
    80006198:	64e2                	ld	s1,24(sp)
    8000619a:	6942                	ld	s2,16(sp)
    8000619c:	69a2                	ld	s3,8(sp)
    8000619e:	6a02                	ld	s4,0(sp)
    800061a0:	6145                	addi	sp,sp,48
    800061a2:	8082                	ret
    for(;;)
    800061a4:	a001                	j	800061a4 <uartputc+0xb4>

00000000800061a6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061a6:	1141                	addi	sp,sp,-16
    800061a8:	e422                	sd	s0,8(sp)
    800061aa:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061ac:	100007b7          	lui	a5,0x10000
    800061b0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061b4:	8b85                	andi	a5,a5,1
    800061b6:	cb91                	beqz	a5,800061ca <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061b8:	100007b7          	lui	a5,0x10000
    800061bc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061c0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061c4:	6422                	ld	s0,8(sp)
    800061c6:	0141                	addi	sp,sp,16
    800061c8:	8082                	ret
    return -1;
    800061ca:	557d                	li	a0,-1
    800061cc:	bfe5                	j	800061c4 <uartgetc+0x1e>

00000000800061ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061ce:	1101                	addi	sp,sp,-32
    800061d0:	ec06                	sd	ra,24(sp)
    800061d2:	e822                	sd	s0,16(sp)
    800061d4:	e426                	sd	s1,8(sp)
    800061d6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061d8:	54fd                	li	s1,-1
    int c = uartgetc();
    800061da:	00000097          	auipc	ra,0x0
    800061de:	fcc080e7          	jalr	-52(ra) # 800061a6 <uartgetc>
    if(c == -1)
    800061e2:	00950763          	beq	a0,s1,800061f0 <uartintr+0x22>
      break;
    consoleintr(c);
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	89c080e7          	jalr	-1892(ra) # 80005a82 <consoleintr>
  while(1){
    800061ee:	b7f5                	j	800061da <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061f0:	0001c497          	auipc	s1,0x1c
    800061f4:	53848493          	addi	s1,s1,1336 # 80022728 <uart_tx_lock>
    800061f8:	8526                	mv	a0,s1
    800061fa:	00000097          	auipc	ra,0x0
    800061fe:	0b4080e7          	jalr	180(ra) # 800062ae <acquire>
  uartstart();
    80006202:	00000097          	auipc	ra,0x0
    80006206:	e64080e7          	jalr	-412(ra) # 80006066 <uartstart>
  release(&uart_tx_lock);
    8000620a:	8526                	mv	a0,s1
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	156080e7          	jalr	342(ra) # 80006362 <release>
}
    80006214:	60e2                	ld	ra,24(sp)
    80006216:	6442                	ld	s0,16(sp)
    80006218:	64a2                	ld	s1,8(sp)
    8000621a:	6105                	addi	sp,sp,32
    8000621c:	8082                	ret

000000008000621e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000621e:	1141                	addi	sp,sp,-16
    80006220:	e422                	sd	s0,8(sp)
    80006222:	0800                	addi	s0,sp,16
  lk->name = name;
    80006224:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006226:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000622a:	00053823          	sd	zero,16(a0)
}
    8000622e:	6422                	ld	s0,8(sp)
    80006230:	0141                	addi	sp,sp,16
    80006232:	8082                	ret

0000000080006234 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006234:	411c                	lw	a5,0(a0)
    80006236:	e399                	bnez	a5,8000623c <holding+0x8>
    80006238:	4501                	li	a0,0
  return r;
}
    8000623a:	8082                	ret
{
    8000623c:	1101                	addi	sp,sp,-32
    8000623e:	ec06                	sd	ra,24(sp)
    80006240:	e822                	sd	s0,16(sp)
    80006242:	e426                	sd	s1,8(sp)
    80006244:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006246:	6904                	ld	s1,16(a0)
    80006248:	ffffb097          	auipc	ra,0xffffb
    8000624c:	bf4080e7          	jalr	-1036(ra) # 80000e3c <mycpu>
    80006250:	40a48533          	sub	a0,s1,a0
    80006254:	00153513          	seqz	a0,a0
}
    80006258:	60e2                	ld	ra,24(sp)
    8000625a:	6442                	ld	s0,16(sp)
    8000625c:	64a2                	ld	s1,8(sp)
    8000625e:	6105                	addi	sp,sp,32
    80006260:	8082                	ret

0000000080006262 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000626c:	100024f3          	csrr	s1,sstatus
    80006270:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006274:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006276:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	bc2080e7          	jalr	-1086(ra) # 80000e3c <mycpu>
    80006282:	5d3c                	lw	a5,120(a0)
    80006284:	cf89                	beqz	a5,8000629e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006286:	ffffb097          	auipc	ra,0xffffb
    8000628a:	bb6080e7          	jalr	-1098(ra) # 80000e3c <mycpu>
    8000628e:	5d3c                	lw	a5,120(a0)
    80006290:	2785                	addiw	a5,a5,1
    80006292:	dd3c                	sw	a5,120(a0)
}
    80006294:	60e2                	ld	ra,24(sp)
    80006296:	6442                	ld	s0,16(sp)
    80006298:	64a2                	ld	s1,8(sp)
    8000629a:	6105                	addi	sp,sp,32
    8000629c:	8082                	ret
    mycpu()->intena = old;
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	b9e080e7          	jalr	-1122(ra) # 80000e3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062a6:	8085                	srli	s1,s1,0x1
    800062a8:	8885                	andi	s1,s1,1
    800062aa:	dd64                	sw	s1,124(a0)
    800062ac:	bfe9                	j	80006286 <push_off+0x24>

00000000800062ae <acquire>:
{
    800062ae:	1101                	addi	sp,sp,-32
    800062b0:	ec06                	sd	ra,24(sp)
    800062b2:	e822                	sd	s0,16(sp)
    800062b4:	e426                	sd	s1,8(sp)
    800062b6:	1000                	addi	s0,sp,32
    800062b8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	fa8080e7          	jalr	-88(ra) # 80006262 <push_off>
  if(holding(lk))
    800062c2:	8526                	mv	a0,s1
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	f70080e7          	jalr	-144(ra) # 80006234 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062cc:	4705                	li	a4,1
  if(holding(lk))
    800062ce:	e115                	bnez	a0,800062f2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062d0:	87ba                	mv	a5,a4
    800062d2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062d6:	2781                	sext.w	a5,a5
    800062d8:	ffe5                	bnez	a5,800062d0 <acquire+0x22>
  __sync_synchronize();
    800062da:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062de:	ffffb097          	auipc	ra,0xffffb
    800062e2:	b5e080e7          	jalr	-1186(ra) # 80000e3c <mycpu>
    800062e6:	e888                	sd	a0,16(s1)
}
    800062e8:	60e2                	ld	ra,24(sp)
    800062ea:	6442                	ld	s0,16(sp)
    800062ec:	64a2                	ld	s1,8(sp)
    800062ee:	6105                	addi	sp,sp,32
    800062f0:	8082                	ret
    panic("acquire");
    800062f2:	00002517          	auipc	a0,0x2
    800062f6:	54650513          	addi	a0,a0,1350 # 80008838 <digits+0x20>
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	a94080e7          	jalr	-1388(ra) # 80005d8e <panic>

0000000080006302 <pop_off>:

void
pop_off(void)
{
    80006302:	1141                	addi	sp,sp,-16
    80006304:	e406                	sd	ra,8(sp)
    80006306:	e022                	sd	s0,0(sp)
    80006308:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000630a:	ffffb097          	auipc	ra,0xffffb
    8000630e:	b32080e7          	jalr	-1230(ra) # 80000e3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006312:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006316:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006318:	e78d                	bnez	a5,80006342 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000631a:	5d3c                	lw	a5,120(a0)
    8000631c:	02f05b63          	blez	a5,80006352 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006320:	37fd                	addiw	a5,a5,-1
    80006322:	0007871b          	sext.w	a4,a5
    80006326:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006328:	eb09                	bnez	a4,8000633a <pop_off+0x38>
    8000632a:	5d7c                	lw	a5,124(a0)
    8000632c:	c799                	beqz	a5,8000633a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000632e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006332:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006336:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000633a:	60a2                	ld	ra,8(sp)
    8000633c:	6402                	ld	s0,0(sp)
    8000633e:	0141                	addi	sp,sp,16
    80006340:	8082                	ret
    panic("pop_off - interruptible");
    80006342:	00002517          	auipc	a0,0x2
    80006346:	4fe50513          	addi	a0,a0,1278 # 80008840 <digits+0x28>
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	a44080e7          	jalr	-1468(ra) # 80005d8e <panic>
    panic("pop_off");
    80006352:	00002517          	auipc	a0,0x2
    80006356:	50650513          	addi	a0,a0,1286 # 80008858 <digits+0x40>
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	a34080e7          	jalr	-1484(ra) # 80005d8e <panic>

0000000080006362 <release>:
{
    80006362:	1101                	addi	sp,sp,-32
    80006364:	ec06                	sd	ra,24(sp)
    80006366:	e822                	sd	s0,16(sp)
    80006368:	e426                	sd	s1,8(sp)
    8000636a:	1000                	addi	s0,sp,32
    8000636c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	ec6080e7          	jalr	-314(ra) # 80006234 <holding>
    80006376:	c115                	beqz	a0,8000639a <release+0x38>
  lk->cpu = 0;
    80006378:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000637c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006380:	0f50000f          	fence	iorw,ow
    80006384:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	f7a080e7          	jalr	-134(ra) # 80006302 <pop_off>
}
    80006390:	60e2                	ld	ra,24(sp)
    80006392:	6442                	ld	s0,16(sp)
    80006394:	64a2                	ld	s1,8(sp)
    80006396:	6105                	addi	sp,sp,32
    80006398:	8082                	ret
    panic("release");
    8000639a:	00002517          	auipc	a0,0x2
    8000639e:	4c650513          	addi	a0,a0,1222 # 80008860 <digits+0x48>
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	9ec080e7          	jalr	-1556(ra) # 80005d8e <panic>
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
