
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	c3010113          	addi	sp,sp,-976 # 80019c30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	716050ef          	jal	ra,8000572c <start>

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
    80000034:	d0078793          	addi	a5,a5,-768 # 80021d30 <end>
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
    80000054:	87090913          	addi	s2,s2,-1936 # 800088c0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	0d2080e7          	jalr	210(ra) # 8000612c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	172080e7          	jalr	370(ra) # 800061e0 <release>
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
    8000008e:	b58080e7          	jalr	-1192(ra) # 80005be2 <panic>

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
    800000ec:	00008517          	auipc	a0,0x8
    800000f0:	7d450513          	addi	a0,a0,2004 # 800088c0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	fa8080e7          	jalr	-88(ra) # 8000609c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	c3050513          	addi	a0,a0,-976 # 80021d30 <end>
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
    80000126:	79e48493          	addi	s1,s1,1950 # 800088c0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	000080e7          	jalr	ra # 8000612c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	78650513          	addi	a0,a0,1926 # 800088c0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	09c080e7          	jalr	156(ra) # 800061e0 <release>

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
    8000016a:	75a50513          	addi	a0,a0,1882 # 800088c0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	072080e7          	jalr	114(ra) # 800061e0 <release>
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
    8000033a:	55a70713          	addi	a4,a4,1370 # 80008890 <started>
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
    80000360:	8d0080e7          	jalr	-1840(ra) # 80005c2c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	784080e7          	jalr	1924(ra) # 80001af0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d0c080e7          	jalr	-756(ra) # 80005080 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fce080e7          	jalr	-50(ra) # 8000134a <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	770080e7          	jalr	1904(ra) # 80005af4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	a86080e7          	jalr	-1402(ra) # 80005e12 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	890080e7          	jalr	-1904(ra) # 80005c2c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	880080e7          	jalr	-1920(ra) # 80005c2c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	870080e7          	jalr	-1936(ra) # 80005c2c <printf>
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
    800003e8:	6e4080e7          	jalr	1764(ra) # 80001ac8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	704080e7          	jalr	1796(ra) # 80001af0 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c76080e7          	jalr	-906(ra) # 8000506a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	c84080e7          	jalr	-892(ra) # 80005080 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	e36080e7          	jalr	-458(ra) # 8000223a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	4da080e7          	jalr	1242(ra) # 800028e6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	478080e7          	jalr	1144(ra) # 8000388c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	d6c080e7          	jalr	-660(ra) # 80005188 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d0c080e7          	jalr	-756(ra) # 80001130 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	44f72f23          	sw	a5,1118(a4) # 80008890 <started>
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
    8000044a:	4527b783          	ld	a5,1106(a5) # 80008898 <kernel_pagetable>
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
    80000492:	00005097          	auipc	ra,0x5
    80000496:	750080e7          	jalr	1872(ra) # 80005be2 <panic>
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
    8000058a:	00005097          	auipc	ra,0x5
    8000058e:	658080e7          	jalr	1624(ra) # 80005be2 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	648080e7          	jalr	1608(ra) # 80005be2 <panic>
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
    80000618:	5ce080e7          	jalr	1486(ra) # 80005be2 <panic>

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
    80000706:	18a7bb23          	sd	a0,406(a5) # 80008898 <kernel_pagetable>
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
    80000764:	482080e7          	jalr	1154(ra) # 80005be2 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	472080e7          	jalr	1138(ra) # 80005be2 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	462080e7          	jalr	1122(ra) # 80005be2 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	452080e7          	jalr	1106(ra) # 80005be2 <panic>
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
    80000872:	374080e7          	jalr	884(ra) # 80005be2 <panic>

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
    800009bc:	22a080e7          	jalr	554(ra) # 80005be2 <panic>
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
    80000a98:	14e080e7          	jalr	334(ra) # 80005be2 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	13e080e7          	jalr	318(ra) # 80005be2 <panic>
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
    80000b12:	0d4080e7          	jalr	212(ra) # 80005be2 <panic>

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
    80000cfc:	01848493          	addi	s1,s1,24 # 80008d10 <proc>
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
    80000d16:	9fea0a13          	addi	s4,s4,-1538 # 8000e710 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	3fe080e7          	jalr	1022(ra) # 80000118 <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c131                	beqz	a0,80000d68 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	858d                	srai	a1,a1,0x3
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
    80000d4c:	16848493          	addi	s1,s1,360
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
    80000d74:	e72080e7          	jalr	-398(ra) # 80005be2 <panic>

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
    80000d98:	b4c50513          	addi	a0,a0,-1204 # 800088e0 <pid_lock>
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	300080e7          	jalr	768(ra) # 8000609c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3c458593          	addi	a1,a1,964 # 80008168 <etext+0x168>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	b4c50513          	addi	a0,a0,-1204 # 800088f8 <wait_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	2e8080e7          	jalr	744(ra) # 8000609c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbc:	00008497          	auipc	s1,0x8
    80000dc0:	f5448493          	addi	s1,s1,-172 # 80008d10 <proc>
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
    80000de2:	93298993          	addi	s3,s3,-1742 # 8000e710 <tickslock>
      initlock(&p->lock, "proc");
    80000de6:	85da                	mv	a1,s6
    80000de8:	8526                	mv	a0,s1
    80000dea:	00005097          	auipc	ra,0x5
    80000dee:	2b2080e7          	jalr	690(ra) # 8000609c <initlock>
      p->state = UNUSED;
    80000df2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	415487b3          	sub	a5,s1,s5
    80000dfa:	878d                	srai	a5,a5,0x3
    80000dfc:	000a3703          	ld	a4,0(s4)
    80000e00:	02e787b3          	mul	a5,a5,a4
    80000e04:	2785                	addiw	a5,a5,1
    80000e06:	00d7979b          	slliw	a5,a5,0xd
    80000e0a:	40f907b3          	sub	a5,s2,a5
    80000e0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	16848493          	addi	s1,s1,360
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
    80000e4c:	ac850513          	addi	a0,a0,-1336 # 80008910 <cpus>
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
    80000e66:	27e080e7          	jalr	638(ra) # 800060e0 <push_off>
    80000e6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e6c:	2781                	sext.w	a5,a5
    80000e6e:	079e                	slli	a5,a5,0x7
    80000e70:	00008717          	auipc	a4,0x8
    80000e74:	a7070713          	addi	a4,a4,-1424 # 800088e0 <pid_lock>
    80000e78:	97ba                	add	a5,a5,a4
    80000e7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e7c:	00005097          	auipc	ra,0x5
    80000e80:	304080e7          	jalr	772(ra) # 80006180 <pop_off>
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
    80000ea4:	340080e7          	jalr	832(ra) # 800061e0 <release>

  if (first) {
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	9987a783          	lw	a5,-1640(a5) # 80008840 <first.1678>
    80000eb0:	eb89                	bnez	a5,80000ec2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	c56080e7          	jalr	-938(ra) # 80001b08 <usertrapret>
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
    first = 0;
    80000ec2:	00008797          	auipc	a5,0x8
    80000ec6:	9607af23          	sw	zero,-1666(a5) # 80008840 <first.1678>
    fsinit(ROOTDEV);
    80000eca:	4505                	li	a0,1
    80000ecc:	00002097          	auipc	ra,0x2
    80000ed0:	99a080e7          	jalr	-1638(ra) # 80002866 <fsinit>
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
    80000ee6:	9fe90913          	addi	s2,s2,-1538 # 800088e0 <pid_lock>
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	240080e7          	jalr	576(ra) # 8000612c <acquire>
  pid = nextpid;
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	95078793          	addi	a5,a5,-1712 # 80008844 <nextpid>
    80000efc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efe:	0014871b          	addiw	a4,s1,1
    80000f02:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f04:	854a                	mv	a0,s2
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	2da080e7          	jalr	730(ra) # 800061e0 <release>
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
}
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6105                	addi	sp,sp,32
    80001060:	8082                	ret

0000000080001062 <allocproc>:
{
    80001062:	1101                	addi	sp,sp,-32
    80001064:	ec06                	sd	ra,24(sp)
    80001066:	e822                	sd	s0,16(sp)
    80001068:	e426                	sd	s1,8(sp)
    8000106a:	e04a                	sd	s2,0(sp)
    8000106c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106e:	00008497          	auipc	s1,0x8
    80001072:	ca248493          	addi	s1,s1,-862 # 80008d10 <proc>
    80001076:	0000d917          	auipc	s2,0xd
    8000107a:	69a90913          	addi	s2,s2,1690 # 8000e710 <tickslock>
    acquire(&p->lock);
    8000107e:	8526                	mv	a0,s1
    80001080:	00005097          	auipc	ra,0x5
    80001084:	0ac080e7          	jalr	172(ra) # 8000612c <acquire>
    if(p->state == UNUSED) {
    80001088:	4c9c                	lw	a5,24(s1)
    8000108a:	cf81                	beqz	a5,800010a2 <allocproc+0x40>
      release(&p->lock);
    8000108c:	8526                	mv	a0,s1
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	152080e7          	jalr	338(ra) # 800061e0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001096:	16848493          	addi	s1,s1,360
    8000109a:	ff2492e3          	bne	s1,s2,8000107e <allocproc+0x1c>
  return 0;
    8000109e:	4481                	li	s1,0
    800010a0:	a889                	j	800010f2 <allocproc+0x90>
  p->pid = allocpid();
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	e34080e7          	jalr	-460(ra) # 80000ed6 <allocpid>
    800010aa:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ac:	4785                	li	a5,1
    800010ae:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	068080e7          	jalr	104(ra) # 80000118 <kalloc>
    800010b8:	892a                	mv	s2,a0
    800010ba:	eca8                	sd	a0,88(s1)
    800010bc:	c131                	beqz	a0,80001100 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	e5c080e7          	jalr	-420(ra) # 80000f1c <proc_pagetable>
    800010c8:	892a                	mv	s2,a0
    800010ca:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010cc:	c531                	beqz	a0,80001118 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ce:	07000613          	li	a2,112
    800010d2:	4581                	li	a1,0
    800010d4:	06048513          	addi	a0,s1,96
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	0a0080e7          	jalr	160(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e0:	00000797          	auipc	a5,0x0
    800010e4:	db078793          	addi	a5,a5,-592 # 80000e90 <forkret>
    800010e8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ea:	60bc                	ld	a5,64(s1)
    800010ec:	6705                	lui	a4,0x1
    800010ee:	97ba                	add	a5,a5,a4
    800010f0:	f4bc                	sd	a5,104(s1)
}
    800010f2:	8526                	mv	a0,s1
    800010f4:	60e2                	ld	ra,24(sp)
    800010f6:	6442                	ld	s0,16(sp)
    800010f8:	64a2                	ld	s1,8(sp)
    800010fa:	6902                	ld	s2,0(sp)
    800010fc:	6105                	addi	sp,sp,32
    800010fe:	8082                	ret
    freeproc(p);
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f08080e7          	jalr	-248(ra) # 8000100a <freeproc>
    release(&p->lock);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00005097          	auipc	ra,0x5
    80001110:	0d4080e7          	jalr	212(ra) # 800061e0 <release>
    return 0;
    80001114:	84ca                	mv	s1,s2
    80001116:	bff1                	j	800010f2 <allocproc+0x90>
    freeproc(p);
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	ef0080e7          	jalr	-272(ra) # 8000100a <freeproc>
    release(&p->lock);
    80001122:	8526                	mv	a0,s1
    80001124:	00005097          	auipc	ra,0x5
    80001128:	0bc080e7          	jalr	188(ra) # 800061e0 <release>
    return 0;
    8000112c:	84ca                	mv	s1,s2
    8000112e:	b7d1                	j	800010f2 <allocproc+0x90>

0000000080001130 <userinit>:
{
    80001130:	1101                	addi	sp,sp,-32
    80001132:	ec06                	sd	ra,24(sp)
    80001134:	e822                	sd	s0,16(sp)
    80001136:	e426                	sd	s1,8(sp)
    80001138:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	f28080e7          	jalr	-216(ra) # 80001062 <allocproc>
    80001142:	84aa                	mv	s1,a0
  initproc = p;
    80001144:	00007797          	auipc	a5,0x7
    80001148:	74a7be23          	sd	a0,1884(a5) # 800088a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000114c:	03400613          	li	a2,52
    80001150:	00007597          	auipc	a1,0x7
    80001154:	70058593          	addi	a1,a1,1792 # 80008850 <initcode>
    80001158:	6928                	ld	a0,80(a0)
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	6aa080e7          	jalr	1706(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    80001162:	6785                	lui	a5,0x1
    80001164:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001166:	6cb8                	ld	a4,88(s1)
    80001168:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116c:	6cb8                	ld	a4,88(s1)
    8000116e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001170:	4641                	li	a2,16
    80001172:	00007597          	auipc	a1,0x7
    80001176:	00e58593          	addi	a1,a1,14 # 80008180 <etext+0x180>
    8000117a:	15848513          	addi	a0,s1,344
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	14c080e7          	jalr	332(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	00a50513          	addi	a0,a0,10 # 80008190 <etext+0x190>
    8000118e:	00002097          	auipc	ra,0x2
    80001192:	0fa080e7          	jalr	250(ra) # 80003288 <namei>
    80001196:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000119a:	478d                	li	a5,3
    8000119c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00005097          	auipc	ra,0x5
    800011a4:	040080e7          	jalr	64(ra) # 800061e0 <release>
}
    800011a8:	60e2                	ld	ra,24(sp)
    800011aa:	6442                	ld	s0,16(sp)
    800011ac:	64a2                	ld	s1,8(sp)
    800011ae:	6105                	addi	sp,sp,32
    800011b0:	8082                	ret

00000000800011b2 <growproc>:
{
    800011b2:	1101                	addi	sp,sp,-32
    800011b4:	ec06                	sd	ra,24(sp)
    800011b6:	e822                	sd	s0,16(sp)
    800011b8:	e426                	sd	s1,8(sp)
    800011ba:	e04a                	sd	s2,0(sp)
    800011bc:	1000                	addi	s0,sp,32
    800011be:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	c98080e7          	jalr	-872(ra) # 80000e58 <myproc>
    800011c8:	84aa                	mv	s1,a0
  sz = p->sz;
    800011ca:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011cc:	01204c63          	bgtz	s2,800011e4 <growproc+0x32>
  } else if(n < 0){
    800011d0:	02094663          	bltz	s2,800011fc <growproc+0x4a>
  p->sz = sz;
    800011d4:	e4ac                	sd	a1,72(s1)
  return 0;
    800011d6:	4501                	li	a0,0
}
    800011d8:	60e2                	ld	ra,24(sp)
    800011da:	6442                	ld	s0,16(sp)
    800011dc:	64a2                	ld	s1,8(sp)
    800011de:	6902                	ld	s2,0(sp)
    800011e0:	6105                	addi	sp,sp,32
    800011e2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e4:	4691                	li	a3,4
    800011e6:	00b90633          	add	a2,s2,a1
    800011ea:	6928                	ld	a0,80(a0)
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	6d2080e7          	jalr	1746(ra) # 800008be <uvmalloc>
    800011f4:	85aa                	mv	a1,a0
    800011f6:	fd79                	bnez	a0,800011d4 <growproc+0x22>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bff9                	j	800011d8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	00b90633          	add	a2,s2,a1
    80001200:	6928                	ld	a0,80(a0)
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	674080e7          	jalr	1652(ra) # 80000876 <uvmdealloc>
    8000120a:	85aa                	mv	a1,a0
    8000120c:	b7e1                	j	800011d4 <growproc+0x22>

000000008000120e <fork>:
{
    8000120e:	7179                	addi	sp,sp,-48
    80001210:	f406                	sd	ra,40(sp)
    80001212:	f022                	sd	s0,32(sp)
    80001214:	ec26                	sd	s1,24(sp)
    80001216:	e84a                	sd	s2,16(sp)
    80001218:	e44e                	sd	s3,8(sp)
    8000121a:	e052                	sd	s4,0(sp)
    8000121c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	c3a080e7          	jalr	-966(ra) # 80000e58 <myproc>
    80001226:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	e3a080e7          	jalr	-454(ra) # 80001062 <allocproc>
    80001230:	10050b63          	beqz	a0,80001346 <fork+0x138>
    80001234:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001236:	04893603          	ld	a2,72(s2)
    8000123a:	692c                	ld	a1,80(a0)
    8000123c:	05093503          	ld	a0,80(s2)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	7d2080e7          	jalr	2002(ra) # 80000a12 <uvmcopy>
    80001248:	04054663          	bltz	a0,80001294 <fork+0x86>
  np->sz = p->sz;
    8000124c:	04893783          	ld	a5,72(s2)
    80001250:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001254:	05893683          	ld	a3,88(s2)
    80001258:	87b6                	mv	a5,a3
    8000125a:	0589b703          	ld	a4,88(s3)
    8000125e:	12068693          	addi	a3,a3,288
    80001262:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001266:	6788                	ld	a0,8(a5)
    80001268:	6b8c                	ld	a1,16(a5)
    8000126a:	6f90                	ld	a2,24(a5)
    8000126c:	01073023          	sd	a6,0(a4)
    80001270:	e708                	sd	a0,8(a4)
    80001272:	eb0c                	sd	a1,16(a4)
    80001274:	ef10                	sd	a2,24(a4)
    80001276:	02078793          	addi	a5,a5,32
    8000127a:	02070713          	addi	a4,a4,32
    8000127e:	fed792e3          	bne	a5,a3,80001262 <fork+0x54>
  np->trapframe->a0 = 0;
    80001282:	0589b783          	ld	a5,88(s3)
    80001286:	0607b823          	sd	zero,112(a5)
    8000128a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000128e:	15000a13          	li	s4,336
    80001292:	a03d                	j	800012c0 <fork+0xb2>
    freeproc(np);
    80001294:	854e                	mv	a0,s3
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	d74080e7          	jalr	-652(ra) # 8000100a <freeproc>
    release(&np->lock);
    8000129e:	854e                	mv	a0,s3
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	f40080e7          	jalr	-192(ra) # 800061e0 <release>
    return -1;
    800012a8:	5a7d                	li	s4,-1
    800012aa:	a069                	j	80001334 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ac:	00002097          	auipc	ra,0x2
    800012b0:	672080e7          	jalr	1650(ra) # 8000391e <filedup>
    800012b4:	009987b3          	add	a5,s3,s1
    800012b8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	01448763          	beq	s1,s4,800012ca <fork+0xbc>
    if(p->ofile[i])
    800012c0:	009907b3          	add	a5,s2,s1
    800012c4:	6388                	ld	a0,0(a5)
    800012c6:	f17d                	bnez	a0,800012ac <fork+0x9e>
    800012c8:	bfcd                	j	800012ba <fork+0xac>
  np->cwd = idup(p->cwd);
    800012ca:	15093503          	ld	a0,336(s2)
    800012ce:	00001097          	auipc	ra,0x1
    800012d2:	7d6080e7          	jalr	2006(ra) # 80002aa4 <idup>
    800012d6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012da:	4641                	li	a2,16
    800012dc:	15890593          	addi	a1,s2,344
    800012e0:	15898513          	addi	a0,s3,344
    800012e4:	fffff097          	auipc	ra,0xfffff
    800012e8:	fe6080e7          	jalr	-26(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012ec:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	eee080e7          	jalr	-274(ra) # 800061e0 <release>
  acquire(&wait_lock);
    800012fa:	00007497          	auipc	s1,0x7
    800012fe:	5fe48493          	addi	s1,s1,1534 # 800088f8 <wait_lock>
    80001302:	8526                	mv	a0,s1
    80001304:	00005097          	auipc	ra,0x5
    80001308:	e28080e7          	jalr	-472(ra) # 8000612c <acquire>
  np->parent = p;
    8000130c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001310:	8526                	mv	a0,s1
    80001312:	00005097          	auipc	ra,0x5
    80001316:	ece080e7          	jalr	-306(ra) # 800061e0 <release>
  acquire(&np->lock);
    8000131a:	854e                	mv	a0,s3
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	e10080e7          	jalr	-496(ra) # 8000612c <acquire>
  np->state = RUNNABLE;
    80001324:	478d                	li	a5,3
    80001326:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000132a:	854e                	mv	a0,s3
    8000132c:	00005097          	auipc	ra,0x5
    80001330:	eb4080e7          	jalr	-332(ra) # 800061e0 <release>
}
    80001334:	8552                	mv	a0,s4
    80001336:	70a2                	ld	ra,40(sp)
    80001338:	7402                	ld	s0,32(sp)
    8000133a:	64e2                	ld	s1,24(sp)
    8000133c:	6942                	ld	s2,16(sp)
    8000133e:	69a2                	ld	s3,8(sp)
    80001340:	6a02                	ld	s4,0(sp)
    80001342:	6145                	addi	sp,sp,48
    80001344:	8082                	ret
    return -1;
    80001346:	5a7d                	li	s4,-1
    80001348:	b7f5                	j	80001334 <fork+0x126>

000000008000134a <scheduler>:
{
    8000134a:	7139                	addi	sp,sp,-64
    8000134c:	fc06                	sd	ra,56(sp)
    8000134e:	f822                	sd	s0,48(sp)
    80001350:	f426                	sd	s1,40(sp)
    80001352:	f04a                	sd	s2,32(sp)
    80001354:	ec4e                	sd	s3,24(sp)
    80001356:	e852                	sd	s4,16(sp)
    80001358:	e456                	sd	s5,8(sp)
    8000135a:	e05a                	sd	s6,0(sp)
    8000135c:	0080                	addi	s0,sp,64
    8000135e:	8792                	mv	a5,tp
  int id = r_tp();
    80001360:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001362:	00779a93          	slli	s5,a5,0x7
    80001366:	00007717          	auipc	a4,0x7
    8000136a:	57a70713          	addi	a4,a4,1402 # 800088e0 <pid_lock>
    8000136e:	9756                	add	a4,a4,s5
    80001370:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001374:	00007717          	auipc	a4,0x7
    80001378:	5a470713          	addi	a4,a4,1444 # 80008918 <cpus+0x8>
    8000137c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000137e:	498d                	li	s3,3
        p->state = RUNNING;
    80001380:	4b11                	li	s6,4
        c->proc = p;
    80001382:	079e                	slli	a5,a5,0x7
    80001384:	00007a17          	auipc	s4,0x7
    80001388:	55ca0a13          	addi	s4,s4,1372 # 800088e0 <pid_lock>
    8000138c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000138e:	0000d917          	auipc	s2,0xd
    80001392:	38290913          	addi	s2,s2,898 # 8000e710 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001396:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000139a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000139e:	10079073          	csrw	sstatus,a5
    800013a2:	00008497          	auipc	s1,0x8
    800013a6:	96e48493          	addi	s1,s1,-1682 # 80008d10 <proc>
    800013aa:	a03d                	j	800013d8 <scheduler+0x8e>
        p->state = RUNNING;
    800013ac:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013b4:	06048593          	addi	a1,s1,96
    800013b8:	8556                	mv	a0,s5
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	6a4080e7          	jalr	1700(ra) # 80001a5e <swtch>
        c->proc = 0;
    800013c2:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013c6:	8526                	mv	a0,s1
    800013c8:	00005097          	auipc	ra,0x5
    800013cc:	e18080e7          	jalr	-488(ra) # 800061e0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d0:	16848493          	addi	s1,s1,360
    800013d4:	fd2481e3          	beq	s1,s2,80001396 <scheduler+0x4c>
      acquire(&p->lock);
    800013d8:	8526                	mv	a0,s1
    800013da:	00005097          	auipc	ra,0x5
    800013de:	d52080e7          	jalr	-686(ra) # 8000612c <acquire>
      if(p->state == RUNNABLE) {
    800013e2:	4c9c                	lw	a5,24(s1)
    800013e4:	ff3791e3          	bne	a5,s3,800013c6 <scheduler+0x7c>
    800013e8:	b7d1                	j	800013ac <scheduler+0x62>

00000000800013ea <sched>:
{
    800013ea:	7179                	addi	sp,sp,-48
    800013ec:	f406                	sd	ra,40(sp)
    800013ee:	f022                	sd	s0,32(sp)
    800013f0:	ec26                	sd	s1,24(sp)
    800013f2:	e84a                	sd	s2,16(sp)
    800013f4:	e44e                	sd	s3,8(sp)
    800013f6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	a60080e7          	jalr	-1440(ra) # 80000e58 <myproc>
    80001400:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001402:	00005097          	auipc	ra,0x5
    80001406:	cb0080e7          	jalr	-848(ra) # 800060b2 <holding>
    8000140a:	c93d                	beqz	a0,80001480 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000140c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000140e:	2781                	sext.w	a5,a5
    80001410:	079e                	slli	a5,a5,0x7
    80001412:	00007717          	auipc	a4,0x7
    80001416:	4ce70713          	addi	a4,a4,1230 # 800088e0 <pid_lock>
    8000141a:	97ba                	add	a5,a5,a4
    8000141c:	0a87a703          	lw	a4,168(a5)
    80001420:	4785                	li	a5,1
    80001422:	06f71763          	bne	a4,a5,80001490 <sched+0xa6>
  if(p->state == RUNNING)
    80001426:	4c98                	lw	a4,24(s1)
    80001428:	4791                	li	a5,4
    8000142a:	06f70b63          	beq	a4,a5,800014a0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000142e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001432:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001434:	efb5                	bnez	a5,800014b0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001436:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001438:	00007917          	auipc	s2,0x7
    8000143c:	4a890913          	addi	s2,s2,1192 # 800088e0 <pid_lock>
    80001440:	2781                	sext.w	a5,a5
    80001442:	079e                	slli	a5,a5,0x7
    80001444:	97ca                	add	a5,a5,s2
    80001446:	0ac7a983          	lw	s3,172(a5)
    8000144a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00007597          	auipc	a1,0x7
    80001454:	4c858593          	addi	a1,a1,1224 # 80008918 <cpus+0x8>
    80001458:	95be                	add	a1,a1,a5
    8000145a:	06048513          	addi	a0,s1,96
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	600080e7          	jalr	1536(ra) # 80001a5e <swtch>
    80001466:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	97ca                	add	a5,a5,s2
    8000146e:	0b37a623          	sw	s3,172(a5)
}
    80001472:	70a2                	ld	ra,40(sp)
    80001474:	7402                	ld	s0,32(sp)
    80001476:	64e2                	ld	s1,24(sp)
    80001478:	6942                	ld	s2,16(sp)
    8000147a:	69a2                	ld	s3,8(sp)
    8000147c:	6145                	addi	sp,sp,48
    8000147e:	8082                	ret
    panic("sched p->lock");
    80001480:	00007517          	auipc	a0,0x7
    80001484:	d1850513          	addi	a0,a0,-744 # 80008198 <etext+0x198>
    80001488:	00004097          	auipc	ra,0x4
    8000148c:	75a080e7          	jalr	1882(ra) # 80005be2 <panic>
    panic("sched locks");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d1850513          	addi	a0,a0,-744 # 800081a8 <etext+0x1a8>
    80001498:	00004097          	auipc	ra,0x4
    8000149c:	74a080e7          	jalr	1866(ra) # 80005be2 <panic>
    panic("sched running");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d1850513          	addi	a0,a0,-744 # 800081b8 <etext+0x1b8>
    800014a8:	00004097          	auipc	ra,0x4
    800014ac:	73a080e7          	jalr	1850(ra) # 80005be2 <panic>
    panic("sched interruptible");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d1850513          	addi	a0,a0,-744 # 800081c8 <etext+0x1c8>
    800014b8:	00004097          	auipc	ra,0x4
    800014bc:	72a080e7          	jalr	1834(ra) # 80005be2 <panic>

00000000800014c0 <yield>:
{
    800014c0:	1101                	addi	sp,sp,-32
    800014c2:	ec06                	sd	ra,24(sp)
    800014c4:	e822                	sd	s0,16(sp)
    800014c6:	e426                	sd	s1,8(sp)
    800014c8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	98e080e7          	jalr	-1650(ra) # 80000e58 <myproc>
    800014d2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	c58080e7          	jalr	-936(ra) # 8000612c <acquire>
  p->state = RUNNABLE;
    800014dc:	478d                	li	a5,3
    800014de:	cc9c                	sw	a5,24(s1)
  sched();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	f0a080e7          	jalr	-246(ra) # 800013ea <sched>
  release(&p->lock);
    800014e8:	8526                	mv	a0,s1
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	cf6080e7          	jalr	-778(ra) # 800061e0 <release>
}
    800014f2:	60e2                	ld	ra,24(sp)
    800014f4:	6442                	ld	s0,16(sp)
    800014f6:	64a2                	ld	s1,8(sp)
    800014f8:	6105                	addi	sp,sp,32
    800014fa:	8082                	ret

00000000800014fc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800014fc:	7179                	addi	sp,sp,-48
    800014fe:	f406                	sd	ra,40(sp)
    80001500:	f022                	sd	s0,32(sp)
    80001502:	ec26                	sd	s1,24(sp)
    80001504:	e84a                	sd	s2,16(sp)
    80001506:	e44e                	sd	s3,8(sp)
    80001508:	1800                	addi	s0,sp,48
    8000150a:	89aa                	mv	s3,a0
    8000150c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	94a080e7          	jalr	-1718(ra) # 80000e58 <myproc>
    80001516:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	c14080e7          	jalr	-1004(ra) # 8000612c <acquire>
  release(lk);
    80001520:	854a                	mv	a0,s2
    80001522:	00005097          	auipc	ra,0x5
    80001526:	cbe080e7          	jalr	-834(ra) # 800061e0 <release>

  // Go to sleep.
  p->chan = chan;
    8000152a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000152e:	4789                	li	a5,2
    80001530:	cc9c                	sw	a5,24(s1)

  sched();
    80001532:	00000097          	auipc	ra,0x0
    80001536:	eb8080e7          	jalr	-328(ra) # 800013ea <sched>

  // Tidy up.
  p->chan = 0;
    8000153a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000153e:	8526                	mv	a0,s1
    80001540:	00005097          	auipc	ra,0x5
    80001544:	ca0080e7          	jalr	-864(ra) # 800061e0 <release>
  acquire(lk);
    80001548:	854a                	mv	a0,s2
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	be2080e7          	jalr	-1054(ra) # 8000612c <acquire>
}
    80001552:	70a2                	ld	ra,40(sp)
    80001554:	7402                	ld	s0,32(sp)
    80001556:	64e2                	ld	s1,24(sp)
    80001558:	6942                	ld	s2,16(sp)
    8000155a:	69a2                	ld	s3,8(sp)
    8000155c:	6145                	addi	sp,sp,48
    8000155e:	8082                	ret

0000000080001560 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001560:	7139                	addi	sp,sp,-64
    80001562:	fc06                	sd	ra,56(sp)
    80001564:	f822                	sd	s0,48(sp)
    80001566:	f426                	sd	s1,40(sp)
    80001568:	f04a                	sd	s2,32(sp)
    8000156a:	ec4e                	sd	s3,24(sp)
    8000156c:	e852                	sd	s4,16(sp)
    8000156e:	e456                	sd	s5,8(sp)
    80001570:	0080                	addi	s0,sp,64
    80001572:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001574:	00007497          	auipc	s1,0x7
    80001578:	79c48493          	addi	s1,s1,1948 # 80008d10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000157c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000157e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001580:	0000d917          	auipc	s2,0xd
    80001584:	19090913          	addi	s2,s2,400 # 8000e710 <tickslock>
    80001588:	a821                	j	800015a0 <wakeup+0x40>
        p->state = RUNNABLE;
    8000158a:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	c50080e7          	jalr	-944(ra) # 800061e0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001598:	16848493          	addi	s1,s1,360
    8000159c:	03248463          	beq	s1,s2,800015c4 <wakeup+0x64>
    if(p != myproc()){
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	8b8080e7          	jalr	-1864(ra) # 80000e58 <myproc>
    800015a8:	fea488e3          	beq	s1,a0,80001598 <wakeup+0x38>
      acquire(&p->lock);
    800015ac:	8526                	mv	a0,s1
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	b7e080e7          	jalr	-1154(ra) # 8000612c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015b6:	4c9c                	lw	a5,24(s1)
    800015b8:	fd379be3          	bne	a5,s3,8000158e <wakeup+0x2e>
    800015bc:	709c                	ld	a5,32(s1)
    800015be:	fd4798e3          	bne	a5,s4,8000158e <wakeup+0x2e>
    800015c2:	b7e1                	j	8000158a <wakeup+0x2a>
    }
  }
}
    800015c4:	70e2                	ld	ra,56(sp)
    800015c6:	7442                	ld	s0,48(sp)
    800015c8:	74a2                	ld	s1,40(sp)
    800015ca:	7902                	ld	s2,32(sp)
    800015cc:	69e2                	ld	s3,24(sp)
    800015ce:	6a42                	ld	s4,16(sp)
    800015d0:	6aa2                	ld	s5,8(sp)
    800015d2:	6121                	addi	sp,sp,64
    800015d4:	8082                	ret

00000000800015d6 <reparent>:
{
    800015d6:	7179                	addi	sp,sp,-48
    800015d8:	f406                	sd	ra,40(sp)
    800015da:	f022                	sd	s0,32(sp)
    800015dc:	ec26                	sd	s1,24(sp)
    800015de:	e84a                	sd	s2,16(sp)
    800015e0:	e44e                	sd	s3,8(sp)
    800015e2:	e052                	sd	s4,0(sp)
    800015e4:	1800                	addi	s0,sp,48
    800015e6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015e8:	00007497          	auipc	s1,0x7
    800015ec:	72848493          	addi	s1,s1,1832 # 80008d10 <proc>
      pp->parent = initproc;
    800015f0:	00007a17          	auipc	s4,0x7
    800015f4:	2b0a0a13          	addi	s4,s4,688 # 800088a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f8:	0000d997          	auipc	s3,0xd
    800015fc:	11898993          	addi	s3,s3,280 # 8000e710 <tickslock>
    80001600:	a029                	j	8000160a <reparent+0x34>
    80001602:	16848493          	addi	s1,s1,360
    80001606:	01348d63          	beq	s1,s3,80001620 <reparent+0x4a>
    if(pp->parent == p){
    8000160a:	7c9c                	ld	a5,56(s1)
    8000160c:	ff279be3          	bne	a5,s2,80001602 <reparent+0x2c>
      pp->parent = initproc;
    80001610:	000a3503          	ld	a0,0(s4)
    80001614:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	f4a080e7          	jalr	-182(ra) # 80001560 <wakeup>
    8000161e:	b7d5                	j	80001602 <reparent+0x2c>
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6a02                	ld	s4,0(sp)
    8000162c:	6145                	addi	sp,sp,48
    8000162e:	8082                	ret

0000000080001630 <exit>:
{
    80001630:	7179                	addi	sp,sp,-48
    80001632:	f406                	sd	ra,40(sp)
    80001634:	f022                	sd	s0,32(sp)
    80001636:	ec26                	sd	s1,24(sp)
    80001638:	e84a                	sd	s2,16(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	e052                	sd	s4,0(sp)
    8000163e:	1800                	addi	s0,sp,48
    80001640:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001642:	00000097          	auipc	ra,0x0
    80001646:	816080e7          	jalr	-2026(ra) # 80000e58 <myproc>
    8000164a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000164c:	00007797          	auipc	a5,0x7
    80001650:	2547b783          	ld	a5,596(a5) # 800088a0 <initproc>
    80001654:	0d050493          	addi	s1,a0,208
    80001658:	15050913          	addi	s2,a0,336
    8000165c:	02a79363          	bne	a5,a0,80001682 <exit+0x52>
    panic("init exiting");
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b8050513          	addi	a0,a0,-1152 # 800081e0 <etext+0x1e0>
    80001668:	00004097          	auipc	ra,0x4
    8000166c:	57a080e7          	jalr	1402(ra) # 80005be2 <panic>
      fileclose(f);
    80001670:	00002097          	auipc	ra,0x2
    80001674:	300080e7          	jalr	768(ra) # 80003970 <fileclose>
      p->ofile[fd] = 0;
    80001678:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000167c:	04a1                	addi	s1,s1,8
    8000167e:	01248563          	beq	s1,s2,80001688 <exit+0x58>
    if(p->ofile[fd]){
    80001682:	6088                	ld	a0,0(s1)
    80001684:	f575                	bnez	a0,80001670 <exit+0x40>
    80001686:	bfdd                	j	8000167c <exit+0x4c>
  begin_op();
    80001688:	00002097          	auipc	ra,0x2
    8000168c:	e1c080e7          	jalr	-484(ra) # 800034a4 <begin_op>
  iput(p->cwd);
    80001690:	1509b503          	ld	a0,336(s3)
    80001694:	00001097          	auipc	ra,0x1
    80001698:	608080e7          	jalr	1544(ra) # 80002c9c <iput>
  end_op();
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	e88080e7          	jalr	-376(ra) # 80003524 <end_op>
  p->cwd = 0;
    800016a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016a8:	00007497          	auipc	s1,0x7
    800016ac:	25048493          	addi	s1,s1,592 # 800088f8 <wait_lock>
    800016b0:	8526                	mv	a0,s1
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	a7a080e7          	jalr	-1414(ra) # 8000612c <acquire>
  reparent(p);
    800016ba:	854e                	mv	a0,s3
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	f1a080e7          	jalr	-230(ra) # 800015d6 <reparent>
  wakeup(p->parent);
    800016c4:	0389b503          	ld	a0,56(s3)
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	e98080e7          	jalr	-360(ra) # 80001560 <wakeup>
  acquire(&p->lock);
    800016d0:	854e                	mv	a0,s3
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	a5a080e7          	jalr	-1446(ra) # 8000612c <acquire>
  p->xstate = status;
    800016da:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016de:	4795                	li	a5,5
    800016e0:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	afa080e7          	jalr	-1286(ra) # 800061e0 <release>
  sched();
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	cfc080e7          	jalr	-772(ra) # 800013ea <sched>
  panic("zombie exit");
    800016f6:	00007517          	auipc	a0,0x7
    800016fa:	afa50513          	addi	a0,a0,-1286 # 800081f0 <etext+0x1f0>
    800016fe:	00004097          	auipc	ra,0x4
    80001702:	4e4080e7          	jalr	1252(ra) # 80005be2 <panic>

0000000080001706 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	1800                	addi	s0,sp,48
    80001714:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001716:	00007497          	auipc	s1,0x7
    8000171a:	5fa48493          	addi	s1,s1,1530 # 80008d10 <proc>
    8000171e:	0000d997          	auipc	s3,0xd
    80001722:	ff298993          	addi	s3,s3,-14 # 8000e710 <tickslock>
    acquire(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	a04080e7          	jalr	-1532(ra) # 8000612c <acquire>
    if(p->pid == pid){
    80001730:	589c                	lw	a5,48(s1)
    80001732:	01278d63          	beq	a5,s2,8000174c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001736:	8526                	mv	a0,s1
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	aa8080e7          	jalr	-1368(ra) # 800061e0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001740:	16848493          	addi	s1,s1,360
    80001744:	ff3491e3          	bne	s1,s3,80001726 <kill+0x20>
  }
  return -1;
    80001748:	557d                	li	a0,-1
    8000174a:	a829                	j	80001764 <kill+0x5e>
      p->killed = 1;
    8000174c:	4785                	li	a5,1
    8000174e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001750:	4c98                	lw	a4,24(s1)
    80001752:	4789                	li	a5,2
    80001754:	00f70f63          	beq	a4,a5,80001772 <kill+0x6c>
      release(&p->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	a86080e7          	jalr	-1402(ra) # 800061e0 <release>
      return 0;
    80001762:	4501                	li	a0,0
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
        p->state = RUNNABLE;
    80001772:	478d                	li	a5,3
    80001774:	cc9c                	sw	a5,24(s1)
    80001776:	b7cd                	j	80001758 <kill+0x52>

0000000080001778 <setkilled>:

void
setkilled(struct proc *p)
{
    80001778:	1101                	addi	sp,sp,-32
    8000177a:	ec06                	sd	ra,24(sp)
    8000177c:	e822                	sd	s0,16(sp)
    8000177e:	e426                	sd	s1,8(sp)
    80001780:	1000                	addi	s0,sp,32
    80001782:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001784:	00005097          	auipc	ra,0x5
    80001788:	9a8080e7          	jalr	-1624(ra) # 8000612c <acquire>
  p->killed = 1;
    8000178c:	4785                	li	a5,1
    8000178e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	a4e080e7          	jalr	-1458(ra) # 800061e0 <release>
}
    8000179a:	60e2                	ld	ra,24(sp)
    8000179c:	6442                	ld	s0,16(sp)
    8000179e:	64a2                	ld	s1,8(sp)
    800017a0:	6105                	addi	sp,sp,32
    800017a2:	8082                	ret

00000000800017a4 <killed>:

int
killed(struct proc *p)
{
    800017a4:	1101                	addi	sp,sp,-32
    800017a6:	ec06                	sd	ra,24(sp)
    800017a8:	e822                	sd	s0,16(sp)
    800017aa:	e426                	sd	s1,8(sp)
    800017ac:	e04a                	sd	s2,0(sp)
    800017ae:	1000                	addi	s0,sp,32
    800017b0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	97a080e7          	jalr	-1670(ra) # 8000612c <acquire>
  k = p->killed;
    800017ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	a20080e7          	jalr	-1504(ra) # 800061e0 <release>
  return k;
}
    800017c8:	854a                	mv	a0,s2
    800017ca:	60e2                	ld	ra,24(sp)
    800017cc:	6442                	ld	s0,16(sp)
    800017ce:	64a2                	ld	s1,8(sp)
    800017d0:	6902                	ld	s2,0(sp)
    800017d2:	6105                	addi	sp,sp,32
    800017d4:	8082                	ret

00000000800017d6 <wait>:
{
    800017d6:	715d                	addi	sp,sp,-80
    800017d8:	e486                	sd	ra,72(sp)
    800017da:	e0a2                	sd	s0,64(sp)
    800017dc:	fc26                	sd	s1,56(sp)
    800017de:	f84a                	sd	s2,48(sp)
    800017e0:	f44e                	sd	s3,40(sp)
    800017e2:	f052                	sd	s4,32(sp)
    800017e4:	ec56                	sd	s5,24(sp)
    800017e6:	e85a                	sd	s6,16(sp)
    800017e8:	e45e                	sd	s7,8(sp)
    800017ea:	e062                	sd	s8,0(sp)
    800017ec:	0880                	addi	s0,sp,80
    800017ee:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017f0:	fffff097          	auipc	ra,0xfffff
    800017f4:	668080e7          	jalr	1640(ra) # 80000e58 <myproc>
    800017f8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	0fe50513          	addi	a0,a0,254 # 800088f8 <wait_lock>
    80001802:	00005097          	auipc	ra,0x5
    80001806:	92a080e7          	jalr	-1750(ra) # 8000612c <acquire>
    havekids = 0;
    8000180a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000180c:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180e:	0000d997          	auipc	s3,0xd
    80001812:	f0298993          	addi	s3,s3,-254 # 8000e710 <tickslock>
        havekids = 1;
    80001816:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001818:	00007c17          	auipc	s8,0x7
    8000181c:	0e0c0c13          	addi	s8,s8,224 # 800088f8 <wait_lock>
    havekids = 0;
    80001820:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001822:	00007497          	auipc	s1,0x7
    80001826:	4ee48493          	addi	s1,s1,1262 # 80008d10 <proc>
    8000182a:	a0bd                	j	80001898 <wait+0xc2>
          pid = pp->pid;
    8000182c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001830:	000b0e63          	beqz	s6,8000184c <wait+0x76>
    80001834:	4691                	li	a3,4
    80001836:	02c48613          	addi	a2,s1,44
    8000183a:	85da                	mv	a1,s6
    8000183c:	05093503          	ld	a0,80(s2)
    80001840:	fffff097          	auipc	ra,0xfffff
    80001844:	2d6080e7          	jalr	726(ra) # 80000b16 <copyout>
    80001848:	02054563          	bltz	a0,80001872 <wait+0x9c>
          freeproc(pp);
    8000184c:	8526                	mv	a0,s1
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	7bc080e7          	jalr	1980(ra) # 8000100a <freeproc>
          release(&pp->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	988080e7          	jalr	-1656(ra) # 800061e0 <release>
          release(&wait_lock);
    80001860:	00007517          	auipc	a0,0x7
    80001864:	09850513          	addi	a0,a0,152 # 800088f8 <wait_lock>
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	978080e7          	jalr	-1672(ra) # 800061e0 <release>
          return pid;
    80001870:	a0b5                	j	800018dc <wait+0x106>
            release(&pp->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	00005097          	auipc	ra,0x5
    80001878:	96c080e7          	jalr	-1684(ra) # 800061e0 <release>
            release(&wait_lock);
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	07c50513          	addi	a0,a0,124 # 800088f8 <wait_lock>
    80001884:	00005097          	auipc	ra,0x5
    80001888:	95c080e7          	jalr	-1700(ra) # 800061e0 <release>
            return -1;
    8000188c:	59fd                	li	s3,-1
    8000188e:	a0b9                	j	800018dc <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001890:	16848493          	addi	s1,s1,360
    80001894:	03348463          	beq	s1,s3,800018bc <wait+0xe6>
      if(pp->parent == p){
    80001898:	7c9c                	ld	a5,56(s1)
    8000189a:	ff279be3          	bne	a5,s2,80001890 <wait+0xba>
        acquire(&pp->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	88c080e7          	jalr	-1908(ra) # 8000612c <acquire>
        if(pp->state == ZOMBIE){
    800018a8:	4c9c                	lw	a5,24(s1)
    800018aa:	f94781e3          	beq	a5,s4,8000182c <wait+0x56>
        release(&pp->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	930080e7          	jalr	-1744(ra) # 800061e0 <release>
        havekids = 1;
    800018b8:	8756                	mv	a4,s5
    800018ba:	bfd9                	j	80001890 <wait+0xba>
    if(!havekids || killed(p)){
    800018bc:	c719                	beqz	a4,800018ca <wait+0xf4>
    800018be:	854a                	mv	a0,s2
    800018c0:	00000097          	auipc	ra,0x0
    800018c4:	ee4080e7          	jalr	-284(ra) # 800017a4 <killed>
    800018c8:	c51d                	beqz	a0,800018f6 <wait+0x120>
      release(&wait_lock);
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	02e50513          	addi	a0,a0,46 # 800088f8 <wait_lock>
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	90e080e7          	jalr	-1778(ra) # 800061e0 <release>
      return -1;
    800018da:	59fd                	li	s3,-1
}
    800018dc:	854e                	mv	a0,s3
    800018de:	60a6                	ld	ra,72(sp)
    800018e0:	6406                	ld	s0,64(sp)
    800018e2:	74e2                	ld	s1,56(sp)
    800018e4:	7942                	ld	s2,48(sp)
    800018e6:	79a2                	ld	s3,40(sp)
    800018e8:	7a02                	ld	s4,32(sp)
    800018ea:	6ae2                	ld	s5,24(sp)
    800018ec:	6b42                	ld	s6,16(sp)
    800018ee:	6ba2                	ld	s7,8(sp)
    800018f0:	6c02                	ld	s8,0(sp)
    800018f2:	6161                	addi	sp,sp,80
    800018f4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f6:	85e2                	mv	a1,s8
    800018f8:	854a                	mv	a0,s2
    800018fa:	00000097          	auipc	ra,0x0
    800018fe:	c02080e7          	jalr	-1022(ra) # 800014fc <sleep>
    havekids = 0;
    80001902:	bf39                	j	80001820 <wait+0x4a>

0000000080001904 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001904:	7179                	addi	sp,sp,-48
    80001906:	f406                	sd	ra,40(sp)
    80001908:	f022                	sd	s0,32(sp)
    8000190a:	ec26                	sd	s1,24(sp)
    8000190c:	e84a                	sd	s2,16(sp)
    8000190e:	e44e                	sd	s3,8(sp)
    80001910:	e052                	sd	s4,0(sp)
    80001912:	1800                	addi	s0,sp,48
    80001914:	84aa                	mv	s1,a0
    80001916:	892e                	mv	s2,a1
    80001918:	89b2                	mv	s3,a2
    8000191a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	53c080e7          	jalr	1340(ra) # 80000e58 <myproc>
  if(user_dst){
    80001924:	c08d                	beqz	s1,80001946 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001926:	86d2                	mv	a3,s4
    80001928:	864e                	mv	a2,s3
    8000192a:	85ca                	mv	a1,s2
    8000192c:	6928                	ld	a0,80(a0)
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	1e8080e7          	jalr	488(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001936:	70a2                	ld	ra,40(sp)
    80001938:	7402                	ld	s0,32(sp)
    8000193a:	64e2                	ld	s1,24(sp)
    8000193c:	6942                	ld	s2,16(sp)
    8000193e:	69a2                	ld	s3,8(sp)
    80001940:	6a02                	ld	s4,0(sp)
    80001942:	6145                	addi	sp,sp,48
    80001944:	8082                	ret
    memmove((char *)dst, src, len);
    80001946:	000a061b          	sext.w	a2,s4
    8000194a:	85ce                	mv	a1,s3
    8000194c:	854a                	mv	a0,s2
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	88a080e7          	jalr	-1910(ra) # 800001d8 <memmove>
    return 0;
    80001956:	8526                	mv	a0,s1
    80001958:	bff9                	j	80001936 <either_copyout+0x32>

000000008000195a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	e052                	sd	s4,0(sp)
    80001968:	1800                	addi	s0,sp,48
    8000196a:	892a                	mv	s2,a0
    8000196c:	84ae                	mv	s1,a1
    8000196e:	89b2                	mv	s3,a2
    80001970:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	4e6080e7          	jalr	1254(ra) # 80000e58 <myproc>
  if(user_src){
    8000197a:	c08d                	beqz	s1,8000199c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197c:	86d2                	mv	a3,s4
    8000197e:	864e                	mv	a2,s3
    80001980:	85ca                	mv	a1,s2
    80001982:	6928                	ld	a0,80(a0)
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	21e080e7          	jalr	542(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198c:	70a2                	ld	ra,40(sp)
    8000198e:	7402                	ld	s0,32(sp)
    80001990:	64e2                	ld	s1,24(sp)
    80001992:	6942                	ld	s2,16(sp)
    80001994:	69a2                	ld	s3,8(sp)
    80001996:	6a02                	ld	s4,0(sp)
    80001998:	6145                	addi	sp,sp,48
    8000199a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199c:	000a061b          	sext.w	a2,s4
    800019a0:	85ce                	mv	a1,s3
    800019a2:	854a                	mv	a0,s2
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	834080e7          	jalr	-1996(ra) # 800001d8 <memmove>
    return 0;
    800019ac:	8526                	mv	a0,s1
    800019ae:	bff9                	j	8000198c <either_copyin+0x32>

00000000800019b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019b0:	715d                	addi	sp,sp,-80
    800019b2:	e486                	sd	ra,72(sp)
    800019b4:	e0a2                	sd	s0,64(sp)
    800019b6:	fc26                	sd	s1,56(sp)
    800019b8:	f84a                	sd	s2,48(sp)
    800019ba:	f44e                	sd	s3,40(sp)
    800019bc:	f052                	sd	s4,32(sp)
    800019be:	ec56                	sd	s5,24(sp)
    800019c0:	e85a                	sd	s6,16(sp)
    800019c2:	e45e                	sd	s7,8(sp)
    800019c4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c6:	00006517          	auipc	a0,0x6
    800019ca:	68250513          	addi	a0,a0,1666 # 80008048 <etext+0x48>
    800019ce:	00004097          	auipc	ra,0x4
    800019d2:	25e080e7          	jalr	606(ra) # 80005c2c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	00007497          	auipc	s1,0x7
    800019da:	49248493          	addi	s1,s1,1170 # 80008e68 <proc+0x158>
    800019de:	0000d917          	auipc	s2,0xd
    800019e2:	e8a90913          	addi	s2,s2,-374 # 8000e868 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e8:	00007997          	auipc	s3,0x7
    800019ec:	81898993          	addi	s3,s3,-2024 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	00007a97          	auipc	s5,0x7
    800019f4:	818a8a93          	addi	s5,s5,-2024 # 80008208 <etext+0x208>
    printf("\n");
    800019f8:	00006a17          	auipc	s4,0x6
    800019fc:	650a0a13          	addi	s4,s4,1616 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a00:	00007b97          	auipc	s7,0x7
    80001a04:	848b8b93          	addi	s7,s7,-1976 # 80008248 <states.1722>
    80001a08:	a00d                	j	80001a2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0a:	ed86a583          	lw	a1,-296(a3)
    80001a0e:	8556                	mv	a0,s5
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	21c080e7          	jalr	540(ra) # 80005c2c <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	212080e7          	jalr	530(ra) # 80005c2c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a22:	16848493          	addi	s1,s1,360
    80001a26:	03248163          	beq	s1,s2,80001a48 <procdump+0x98>
    if(p->state == UNUSED)
    80001a2a:	86a6                	mv	a3,s1
    80001a2c:	ec04a783          	lw	a5,-320(s1)
    80001a30:	dbed                	beqz	a5,80001a22 <procdump+0x72>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	fcfb6be3          	bltu	s6,a5,80001a0a <procdump+0x5a>
    80001a38:	1782                	slli	a5,a5,0x20
    80001a3a:	9381                	srli	a5,a5,0x20
    80001a3c:	078e                	slli	a5,a5,0x3
    80001a3e:	97de                	add	a5,a5,s7
    80001a40:	6390                	ld	a2,0(a5)
    80001a42:	f661                	bnez	a2,80001a0a <procdump+0x5a>
      state = "???";
    80001a44:	864e                	mv	a2,s3
    80001a46:	b7d1                	j	80001a0a <procdump+0x5a>
  }
}
    80001a48:	60a6                	ld	ra,72(sp)
    80001a4a:	6406                	ld	s0,64(sp)
    80001a4c:	74e2                	ld	s1,56(sp)
    80001a4e:	7942                	ld	s2,48(sp)
    80001a50:	79a2                	ld	s3,40(sp)
    80001a52:	7a02                	ld	s4,32(sp)
    80001a54:	6ae2                	ld	s5,24(sp)
    80001a56:	6b42                	ld	s6,16(sp)
    80001a58:	6ba2                	ld	s7,8(sp)
    80001a5a:	6161                	addi	sp,sp,80
    80001a5c:	8082                	ret

0000000080001a5e <swtch>:
    80001a5e:	00153023          	sd	ra,0(a0)
    80001a62:	00253423          	sd	sp,8(a0)
    80001a66:	e900                	sd	s0,16(a0)
    80001a68:	ed04                	sd	s1,24(a0)
    80001a6a:	03253023          	sd	s2,32(a0)
    80001a6e:	03353423          	sd	s3,40(a0)
    80001a72:	03453823          	sd	s4,48(a0)
    80001a76:	03553c23          	sd	s5,56(a0)
    80001a7a:	05653023          	sd	s6,64(a0)
    80001a7e:	05753423          	sd	s7,72(a0)
    80001a82:	05853823          	sd	s8,80(a0)
    80001a86:	05953c23          	sd	s9,88(a0)
    80001a8a:	07a53023          	sd	s10,96(a0)
    80001a8e:	07b53423          	sd	s11,104(a0)
    80001a92:	0005b083          	ld	ra,0(a1)
    80001a96:	0085b103          	ld	sp,8(a1)
    80001a9a:	6980                	ld	s0,16(a1)
    80001a9c:	6d84                	ld	s1,24(a1)
    80001a9e:	0205b903          	ld	s2,32(a1)
    80001aa2:	0285b983          	ld	s3,40(a1)
    80001aa6:	0305ba03          	ld	s4,48(a1)
    80001aaa:	0385ba83          	ld	s5,56(a1)
    80001aae:	0405bb03          	ld	s6,64(a1)
    80001ab2:	0485bb83          	ld	s7,72(a1)
    80001ab6:	0505bc03          	ld	s8,80(a1)
    80001aba:	0585bc83          	ld	s9,88(a1)
    80001abe:	0605bd03          	ld	s10,96(a1)
    80001ac2:	0685bd83          	ld	s11,104(a1)
    80001ac6:	8082                	ret

0000000080001ac8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac8:	1141                	addi	sp,sp,-16
    80001aca:	e406                	sd	ra,8(sp)
    80001acc:	e022                	sd	s0,0(sp)
    80001ace:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad0:	00006597          	auipc	a1,0x6
    80001ad4:	7a858593          	addi	a1,a1,1960 # 80008278 <states.1722+0x30>
    80001ad8:	0000d517          	auipc	a0,0xd
    80001adc:	c3850513          	addi	a0,a0,-968 # 8000e710 <tickslock>
    80001ae0:	00004097          	auipc	ra,0x4
    80001ae4:	5bc080e7          	jalr	1468(ra) # 8000609c <initlock>
}
    80001ae8:	60a2                	ld	ra,8(sp)
    80001aea:	6402                	ld	s0,0(sp)
    80001aec:	0141                	addi	sp,sp,16
    80001aee:	8082                	ret

0000000080001af0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af0:	1141                	addi	sp,sp,-16
    80001af2:	e422                	sd	s0,8(sp)
    80001af4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af6:	00003797          	auipc	a5,0x3
    80001afa:	4ba78793          	addi	a5,a5,1210 # 80004fb0 <kernelvec>
    80001afe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b02:	6422                	ld	s0,8(sp)
    80001b04:	0141                	addi	sp,sp,16
    80001b06:	8082                	ret

0000000080001b08 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b08:	1141                	addi	sp,sp,-16
    80001b0a:	e406                	sd	ra,8(sp)
    80001b0c:	e022                	sd	s0,0(sp)
    80001b0e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	348080e7          	jalr	840(ra) # 80000e58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b22:	00005617          	auipc	a2,0x5
    80001b26:	4de60613          	addi	a2,a2,1246 # 80007000 <_trampoline>
    80001b2a:	00005697          	auipc	a3,0x5
    80001b2e:	4d668693          	addi	a3,a3,1238 # 80007000 <_trampoline>
    80001b32:	8e91                	sub	a3,a3,a2
    80001b34:	040007b7          	lui	a5,0x4000
    80001b38:	17fd                	addi	a5,a5,-1
    80001b3a:	07b2                	slli	a5,a5,0xc
    80001b3c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3e:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b42:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b44:	180026f3          	csrr	a3,satp
    80001b48:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4a:	6d38                	ld	a4,88(a0)
    80001b4c:	6134                	ld	a3,64(a0)
    80001b4e:	6585                	lui	a1,0x1
    80001b50:	96ae                	add	a3,a3,a1
    80001b52:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b54:	6d38                	ld	a4,88(a0)
    80001b56:	00000697          	auipc	a3,0x0
    80001b5a:	13068693          	addi	a3,a3,304 # 80001c86 <usertrap>
    80001b5e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b60:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b62:	8692                	mv	a3,tp
    80001b64:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b66:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b72:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b76:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b78:	6f18                	ld	a4,24(a4)
    80001b7a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7e:	6928                	ld	a0,80(a0)
    80001b80:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b82:	00005717          	auipc	a4,0x5
    80001b86:	51a70713          	addi	a4,a4,1306 # 8000709c <userret>
    80001b8a:	8f11                	sub	a4,a4,a2
    80001b8c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8e:	577d                	li	a4,-1
    80001b90:	177e                	slli	a4,a4,0x3f
    80001b92:	8d59                	or	a0,a0,a4
    80001b94:	9782                	jalr	a5
}
    80001b96:	60a2                	ld	ra,8(sp)
    80001b98:	6402                	ld	s0,0(sp)
    80001b9a:	0141                	addi	sp,sp,16
    80001b9c:	8082                	ret

0000000080001b9e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ba8:	0000d497          	auipc	s1,0xd
    80001bac:	b6848493          	addi	s1,s1,-1176 # 8000e710 <tickslock>
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	57a080e7          	jalr	1402(ra) # 8000612c <acquire>
  ticks++;
    80001bba:	00007517          	auipc	a0,0x7
    80001bbe:	cee50513          	addi	a0,a0,-786 # 800088a8 <ticks>
    80001bc2:	411c                	lw	a5,0(a0)
    80001bc4:	2785                	addiw	a5,a5,1
    80001bc6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	998080e7          	jalr	-1640(ra) # 80001560 <wakeup>
  release(&tickslock);
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	00004097          	auipc	ra,0x4
    80001bd6:	60e080e7          	jalr	1550(ra) # 800061e0 <release>
}
    80001bda:	60e2                	ld	ra,24(sp)
    80001bdc:	6442                	ld	s0,16(sp)
    80001bde:	64a2                	ld	s1,8(sp)
    80001be0:	6105                	addi	sp,sp,32
    80001be2:	8082                	ret

0000000080001be4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be4:	1101                	addi	sp,sp,-32
    80001be6:	ec06                	sd	ra,24(sp)
    80001be8:	e822                	sd	s0,16(sp)
    80001bea:	e426                	sd	s1,8(sp)
    80001bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bee:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf2:	00074d63          	bltz	a4,80001c0c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bf6:	57fd                	li	a5,-1
    80001bf8:	17fe                	slli	a5,a5,0x3f
    80001bfa:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bfc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfe:	06f70363          	beq	a4,a5,80001c64 <devintr+0x80>
  }
}
    80001c02:	60e2                	ld	ra,24(sp)
    80001c04:	6442                	ld	s0,16(sp)
    80001c06:	64a2                	ld	s1,8(sp)
    80001c08:	6105                	addi	sp,sp,32
    80001c0a:	8082                	ret
     (scause & 0xff) == 9){
    80001c0c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c10:	46a5                	li	a3,9
    80001c12:	fed792e3          	bne	a5,a3,80001bf6 <devintr+0x12>
    int irq = plic_claim();
    80001c16:	00003097          	auipc	ra,0x3
    80001c1a:	4a2080e7          	jalr	1186(ra) # 800050b8 <plic_claim>
    80001c1e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c20:	47a9                	li	a5,10
    80001c22:	02f50763          	beq	a0,a5,80001c50 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c26:	4785                	li	a5,1
    80001c28:	02f50963          	beq	a0,a5,80001c5a <devintr+0x76>
    return 1;
    80001c2c:	4505                	li	a0,1
    } else if(irq){
    80001c2e:	d8f1                	beqz	s1,80001c02 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c30:	85a6                	mv	a1,s1
    80001c32:	00006517          	auipc	a0,0x6
    80001c36:	64e50513          	addi	a0,a0,1614 # 80008280 <states.1722+0x38>
    80001c3a:	00004097          	auipc	ra,0x4
    80001c3e:	ff2080e7          	jalr	-14(ra) # 80005c2c <printf>
      plic_complete(irq);
    80001c42:	8526                	mv	a0,s1
    80001c44:	00003097          	auipc	ra,0x3
    80001c48:	498080e7          	jalr	1176(ra) # 800050dc <plic_complete>
    return 1;
    80001c4c:	4505                	li	a0,1
    80001c4e:	bf55                	j	80001c02 <devintr+0x1e>
      uartintr();
    80001c50:	00004097          	auipc	ra,0x4
    80001c54:	3fc080e7          	jalr	1020(ra) # 8000604c <uartintr>
    80001c58:	b7ed                	j	80001c42 <devintr+0x5e>
      virtio_disk_intr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	9ac080e7          	jalr	-1620(ra) # 80005606 <virtio_disk_intr>
    80001c62:	b7c5                	j	80001c42 <devintr+0x5e>
    if(cpuid() == 0){
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	1c8080e7          	jalr	456(ra) # 80000e2c <cpuid>
    80001c6c:	c901                	beqz	a0,80001c7c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c6e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c72:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c74:	14479073          	csrw	sip,a5
    return 2;
    80001c78:	4509                	li	a0,2
    80001c7a:	b761                	j	80001c02 <devintr+0x1e>
      clockintr();
    80001c7c:	00000097          	auipc	ra,0x0
    80001c80:	f22080e7          	jalr	-222(ra) # 80001b9e <clockintr>
    80001c84:	b7ed                	j	80001c6e <devintr+0x8a>

0000000080001c86 <usertrap>:
{
    80001c86:	1101                	addi	sp,sp,-32
    80001c88:	ec06                	sd	ra,24(sp)
    80001c8a:	e822                	sd	s0,16(sp)
    80001c8c:	e426                	sd	s1,8(sp)
    80001c8e:	e04a                	sd	s2,0(sp)
    80001c90:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c92:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c96:	1007f793          	andi	a5,a5,256
    80001c9a:	e3b1                	bnez	a5,80001cde <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c9c:	00003797          	auipc	a5,0x3
    80001ca0:	31478793          	addi	a5,a5,788 # 80004fb0 <kernelvec>
    80001ca4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	1b0080e7          	jalr	432(ra) # 80000e58 <myproc>
    80001cb0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb4:	14102773          	csrr	a4,sepc
    80001cb8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cba:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cbe:	47a1                	li	a5,8
    80001cc0:	02f70763          	beq	a4,a5,80001cee <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	f20080e7          	jalr	-224(ra) # 80001be4 <devintr>
    80001ccc:	892a                	mv	s2,a0
    80001cce:	c151                	beqz	a0,80001d52 <usertrap+0xcc>
  if(killed(p))
    80001cd0:	8526                	mv	a0,s1
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	ad2080e7          	jalr	-1326(ra) # 800017a4 <killed>
    80001cda:	c929                	beqz	a0,80001d2c <usertrap+0xa6>
    80001cdc:	a099                	j	80001d22 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cde:	00006517          	auipc	a0,0x6
    80001ce2:	5c250513          	addi	a0,a0,1474 # 800082a0 <states.1722+0x58>
    80001ce6:	00004097          	auipc	ra,0x4
    80001cea:	efc080e7          	jalr	-260(ra) # 80005be2 <panic>
    if(killed(p))
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	ab6080e7          	jalr	-1354(ra) # 800017a4 <killed>
    80001cf6:	e921                	bnez	a0,80001d46 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001cf8:	6cb8                	ld	a4,88(s1)
    80001cfa:	6f1c                	ld	a5,24(a4)
    80001cfc:	0791                	addi	a5,a5,4
    80001cfe:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d00:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d04:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d08:	10079073          	csrw	sstatus,a5
    syscall();
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	2d4080e7          	jalr	724(ra) # 80001fe0 <syscall>
  if(killed(p))
    80001d14:	8526                	mv	a0,s1
    80001d16:	00000097          	auipc	ra,0x0
    80001d1a:	a8e080e7          	jalr	-1394(ra) # 800017a4 <killed>
    80001d1e:	c911                	beqz	a0,80001d32 <usertrap+0xac>
    80001d20:	4901                	li	s2,0
    exit(-1);
    80001d22:	557d                	li	a0,-1
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	90c080e7          	jalr	-1780(ra) # 80001630 <exit>
  if(which_dev == 2)
    80001d2c:	4789                	li	a5,2
    80001d2e:	04f90f63          	beq	s2,a5,80001d8c <usertrap+0x106>
  usertrapret();
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	dd6080e7          	jalr	-554(ra) # 80001b08 <usertrapret>
}
    80001d3a:	60e2                	ld	ra,24(sp)
    80001d3c:	6442                	ld	s0,16(sp)
    80001d3e:	64a2                	ld	s1,8(sp)
    80001d40:	6902                	ld	s2,0(sp)
    80001d42:	6105                	addi	sp,sp,32
    80001d44:	8082                	ret
      exit(-1);
    80001d46:	557d                	li	a0,-1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	8e8080e7          	jalr	-1816(ra) # 80001630 <exit>
    80001d50:	b765                	j	80001cf8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d52:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d56:	5890                	lw	a2,48(s1)
    80001d58:	00006517          	auipc	a0,0x6
    80001d5c:	56850513          	addi	a0,a0,1384 # 800082c0 <states.1722+0x78>
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	ecc080e7          	jalr	-308(ra) # 80005c2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d68:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d6c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d70:	00006517          	auipc	a0,0x6
    80001d74:	58050513          	addi	a0,a0,1408 # 800082f0 <states.1722+0xa8>
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	eb4080e7          	jalr	-332(ra) # 80005c2c <printf>
    setkilled(p);
    80001d80:	8526                	mv	a0,s1
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	9f6080e7          	jalr	-1546(ra) # 80001778 <setkilled>
    80001d8a:	b769                	j	80001d14 <usertrap+0x8e>
    yield();
    80001d8c:	fffff097          	auipc	ra,0xfffff
    80001d90:	734080e7          	jalr	1844(ra) # 800014c0 <yield>
    80001d94:	bf79                	j	80001d32 <usertrap+0xac>

0000000080001d96 <kerneltrap>:
{
    80001d96:	7179                	addi	sp,sp,-48
    80001d98:	f406                	sd	ra,40(sp)
    80001d9a:	f022                	sd	s0,32(sp)
    80001d9c:	ec26                	sd	s1,24(sp)
    80001d9e:	e84a                	sd	s2,16(sp)
    80001da0:	e44e                	sd	s3,8(sp)
    80001da2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dac:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db0:	1004f793          	andi	a5,s1,256
    80001db4:	cb85                	beqz	a5,80001de4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dba:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dbc:	ef85                	bnez	a5,80001df4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	e26080e7          	jalr	-474(ra) # 80001be4 <devintr>
    80001dc6:	cd1d                	beqz	a0,80001e04 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc8:	4789                	li	a5,2
    80001dca:	06f50a63          	beq	a0,a5,80001e3e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dce:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd2:	10049073          	csrw	sstatus,s1
}
    80001dd6:	70a2                	ld	ra,40(sp)
    80001dd8:	7402                	ld	s0,32(sp)
    80001dda:	64e2                	ld	s1,24(sp)
    80001ddc:	6942                	ld	s2,16(sp)
    80001dde:	69a2                	ld	s3,8(sp)
    80001de0:	6145                	addi	sp,sp,48
    80001de2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de4:	00006517          	auipc	a0,0x6
    80001de8:	52c50513          	addi	a0,a0,1324 # 80008310 <states.1722+0xc8>
    80001dec:	00004097          	auipc	ra,0x4
    80001df0:	df6080e7          	jalr	-522(ra) # 80005be2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	54450513          	addi	a0,a0,1348 # 80008338 <states.1722+0xf0>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	de6080e7          	jalr	-538(ra) # 80005be2 <panic>
    printf("scause %p\n", scause);
    80001e04:	85ce                	mv	a1,s3
    80001e06:	00006517          	auipc	a0,0x6
    80001e0a:	55250513          	addi	a0,a0,1362 # 80008358 <states.1722+0x110>
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	e1e080e7          	jalr	-482(ra) # 80005c2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e16:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1e:	00006517          	auipc	a0,0x6
    80001e22:	54a50513          	addi	a0,a0,1354 # 80008368 <states.1722+0x120>
    80001e26:	00004097          	auipc	ra,0x4
    80001e2a:	e06080e7          	jalr	-506(ra) # 80005c2c <printf>
    panic("kerneltrap");
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	55250513          	addi	a0,a0,1362 # 80008380 <states.1722+0x138>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	dac080e7          	jalr	-596(ra) # 80005be2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3e:	fffff097          	auipc	ra,0xfffff
    80001e42:	01a080e7          	jalr	26(ra) # 80000e58 <myproc>
    80001e46:	d541                	beqz	a0,80001dce <kerneltrap+0x38>
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	010080e7          	jalr	16(ra) # 80000e58 <myproc>
    80001e50:	4d18                	lw	a4,24(a0)
    80001e52:	4791                	li	a5,4
    80001e54:	f6f71de3          	bne	a4,a5,80001dce <kerneltrap+0x38>
    yield();
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	668080e7          	jalr	1640(ra) # 800014c0 <yield>
    80001e60:	b7bd                	j	80001dce <kerneltrap+0x38>

0000000080001e62 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e62:	1101                	addi	sp,sp,-32
    80001e64:	ec06                	sd	ra,24(sp)
    80001e66:	e822                	sd	s0,16(sp)
    80001e68:	e426                	sd	s1,8(sp)
    80001e6a:	1000                	addi	s0,sp,32
    80001e6c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	fea080e7          	jalr	-22(ra) # 80000e58 <myproc>
  switch (n) {
    80001e76:	4795                	li	a5,5
    80001e78:	0497e163          	bltu	a5,s1,80001eba <argraw+0x58>
    80001e7c:	048a                	slli	s1,s1,0x2
    80001e7e:	00006717          	auipc	a4,0x6
    80001e82:	53a70713          	addi	a4,a4,1338 # 800083b8 <states.1722+0x170>
    80001e86:	94ba                	add	s1,s1,a4
    80001e88:	409c                	lw	a5,0(s1)
    80001e8a:	97ba                	add	a5,a5,a4
    80001e8c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8e:	6d3c                	ld	a5,88(a0)
    80001e90:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e92:	60e2                	ld	ra,24(sp)
    80001e94:	6442                	ld	s0,16(sp)
    80001e96:	64a2                	ld	s1,8(sp)
    80001e98:	6105                	addi	sp,sp,32
    80001e9a:	8082                	ret
    return p->trapframe->a1;
    80001e9c:	6d3c                	ld	a5,88(a0)
    80001e9e:	7fa8                	ld	a0,120(a5)
    80001ea0:	bfcd                	j	80001e92 <argraw+0x30>
    return p->trapframe->a2;
    80001ea2:	6d3c                	ld	a5,88(a0)
    80001ea4:	63c8                	ld	a0,128(a5)
    80001ea6:	b7f5                	j	80001e92 <argraw+0x30>
    return p->trapframe->a3;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	67c8                	ld	a0,136(a5)
    80001eac:	b7dd                	j	80001e92 <argraw+0x30>
    return p->trapframe->a4;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	6bc8                	ld	a0,144(a5)
    80001eb2:	b7c5                	j	80001e92 <argraw+0x30>
    return p->trapframe->a5;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	6fc8                	ld	a0,152(a5)
    80001eb8:	bfe9                	j	80001e92 <argraw+0x30>
  panic("argraw");
    80001eba:	00006517          	auipc	a0,0x6
    80001ebe:	4d650513          	addi	a0,a0,1238 # 80008390 <states.1722+0x148>
    80001ec2:	00004097          	auipc	ra,0x4
    80001ec6:	d20080e7          	jalr	-736(ra) # 80005be2 <panic>

0000000080001eca <fetchaddr>:
{
    80001eca:	1101                	addi	sp,sp,-32
    80001ecc:	ec06                	sd	ra,24(sp)
    80001ece:	e822                	sd	s0,16(sp)
    80001ed0:	e426                	sd	s1,8(sp)
    80001ed2:	e04a                	sd	s2,0(sp)
    80001ed4:	1000                	addi	s0,sp,32
    80001ed6:	84aa                	mv	s1,a0
    80001ed8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	f7e080e7          	jalr	-130(ra) # 80000e58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ee2:	653c                	ld	a5,72(a0)
    80001ee4:	02f4f863          	bgeu	s1,a5,80001f14 <fetchaddr+0x4a>
    80001ee8:	00848713          	addi	a4,s1,8
    80001eec:	02e7e663          	bltu	a5,a4,80001f18 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef0:	46a1                	li	a3,8
    80001ef2:	8626                	mv	a2,s1
    80001ef4:	85ca                	mv	a1,s2
    80001ef6:	6928                	ld	a0,80(a0)
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	caa080e7          	jalr	-854(ra) # 80000ba2 <copyin>
    80001f00:	00a03533          	snez	a0,a0
    80001f04:	40a00533          	neg	a0,a0
}
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6902                	ld	s2,0(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret
    return -1;
    80001f14:	557d                	li	a0,-1
    80001f16:	bfcd                	j	80001f08 <fetchaddr+0x3e>
    80001f18:	557d                	li	a0,-1
    80001f1a:	b7fd                	j	80001f08 <fetchaddr+0x3e>

0000000080001f1c <fetchstr>:
{
    80001f1c:	7179                	addi	sp,sp,-48
    80001f1e:	f406                	sd	ra,40(sp)
    80001f20:	f022                	sd	s0,32(sp)
    80001f22:	ec26                	sd	s1,24(sp)
    80001f24:	e84a                	sd	s2,16(sp)
    80001f26:	e44e                	sd	s3,8(sp)
    80001f28:	1800                	addi	s0,sp,48
    80001f2a:	892a                	mv	s2,a0
    80001f2c:	84ae                	mv	s1,a1
    80001f2e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	f28080e7          	jalr	-216(ra) # 80000e58 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f38:	86ce                	mv	a3,s3
    80001f3a:	864a                	mv	a2,s2
    80001f3c:	85a6                	mv	a1,s1
    80001f3e:	6928                	ld	a0,80(a0)
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	cee080e7          	jalr	-786(ra) # 80000c2e <copyinstr>
    80001f48:	00054e63          	bltz	a0,80001f64 <fetchstr+0x48>
  return strlen(buf);
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	ffffe097          	auipc	ra,0xffffe
    80001f52:	3ae080e7          	jalr	942(ra) # 800002fc <strlen>
}
    80001f56:	70a2                	ld	ra,40(sp)
    80001f58:	7402                	ld	s0,32(sp)
    80001f5a:	64e2                	ld	s1,24(sp)
    80001f5c:	6942                	ld	s2,16(sp)
    80001f5e:	69a2                	ld	s3,8(sp)
    80001f60:	6145                	addi	sp,sp,48
    80001f62:	8082                	ret
    return -1;
    80001f64:	557d                	li	a0,-1
    80001f66:	bfc5                	j	80001f56 <fetchstr+0x3a>

0000000080001f68 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	1000                	addi	s0,sp,32
    80001f72:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	eee080e7          	jalr	-274(ra) # 80001e62 <argraw>
    80001f7c:	c088                	sw	a0,0(s1)
}
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	64a2                	ld	s1,8(sp)
    80001f84:	6105                	addi	sp,sp,32
    80001f86:	8082                	ret

0000000080001f88 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	1000                	addi	s0,sp,32
    80001f92:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f94:	00000097          	auipc	ra,0x0
    80001f98:	ece080e7          	jalr	-306(ra) # 80001e62 <argraw>
    80001f9c:	e088                	sd	a0,0(s1)
}
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6105                	addi	sp,sp,32
    80001fa6:	8082                	ret

0000000080001fa8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa8:	7179                	addi	sp,sp,-48
    80001faa:	f406                	sd	ra,40(sp)
    80001fac:	f022                	sd	s0,32(sp)
    80001fae:	ec26                	sd	s1,24(sp)
    80001fb0:	e84a                	sd	s2,16(sp)
    80001fb2:	1800                	addi	s0,sp,48
    80001fb4:	84ae                	mv	s1,a1
    80001fb6:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fb8:	fd840593          	addi	a1,s0,-40
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	fcc080e7          	jalr	-52(ra) # 80001f88 <argaddr>
  return fetchstr(addr, buf, max);
    80001fc4:	864a                	mv	a2,s2
    80001fc6:	85a6                	mv	a1,s1
    80001fc8:	fd843503          	ld	a0,-40(s0)
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	f50080e7          	jalr	-176(ra) # 80001f1c <fetchstr>
}
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	64e2                	ld	s1,24(sp)
    80001fda:	6942                	ld	s2,16(sp)
    80001fdc:	6145                	addi	sp,sp,48
    80001fde:	8082                	ret

0000000080001fe0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fe0:	1101                	addi	sp,sp,-32
    80001fe2:	ec06                	sd	ra,24(sp)
    80001fe4:	e822                	sd	s0,16(sp)
    80001fe6:	e426                	sd	s1,8(sp)
    80001fe8:	e04a                	sd	s2,0(sp)
    80001fea:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fec:	fffff097          	auipc	ra,0xfffff
    80001ff0:	e6c080e7          	jalr	-404(ra) # 80000e58 <myproc>
    80001ff4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001ff6:	05853903          	ld	s2,88(a0)
    80001ffa:	0a893783          	ld	a5,168(s2)
    80001ffe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002002:	37fd                	addiw	a5,a5,-1
    80002004:	4751                	li	a4,20
    80002006:	00f76f63          	bltu	a4,a5,80002024 <syscall+0x44>
    8000200a:	00369713          	slli	a4,a3,0x3
    8000200e:	00006797          	auipc	a5,0x6
    80002012:	3c278793          	addi	a5,a5,962 # 800083d0 <syscalls>
    80002016:	97ba                	add	a5,a5,a4
    80002018:	639c                	ld	a5,0(a5)
    8000201a:	c789                	beqz	a5,80002024 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000201c:	9782                	jalr	a5
    8000201e:	06a93823          	sd	a0,112(s2)
    80002022:	a839                	j	80002040 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002024:	15848613          	addi	a2,s1,344
    80002028:	588c                	lw	a1,48(s1)
    8000202a:	00006517          	auipc	a0,0x6
    8000202e:	36e50513          	addi	a0,a0,878 # 80008398 <states.1722+0x150>
    80002032:	00004097          	auipc	ra,0x4
    80002036:	bfa080e7          	jalr	-1030(ra) # 80005c2c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000203a:	6cbc                	ld	a5,88(s1)
    8000203c:	577d                	li	a4,-1
    8000203e:	fbb8                	sd	a4,112(a5)
  }
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6902                	ld	s2,0(sp)
    80002048:	6105                	addi	sp,sp,32
    8000204a:	8082                	ret

000000008000204c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000204c:	1101                	addi	sp,sp,-32
    8000204e:	ec06                	sd	ra,24(sp)
    80002050:	e822                	sd	s0,16(sp)
    80002052:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002054:	fec40593          	addi	a1,s0,-20
    80002058:	4501                	li	a0,0
    8000205a:	00000097          	auipc	ra,0x0
    8000205e:	f0e080e7          	jalr	-242(ra) # 80001f68 <argint>
  exit(n);
    80002062:	fec42503          	lw	a0,-20(s0)
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	5ca080e7          	jalr	1482(ra) # 80001630 <exit>
  return 0;  // not reached
}
    8000206e:	4501                	li	a0,0
    80002070:	60e2                	ld	ra,24(sp)
    80002072:	6442                	ld	s0,16(sp)
    80002074:	6105                	addi	sp,sp,32
    80002076:	8082                	ret

0000000080002078 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002078:	1141                	addi	sp,sp,-16
    8000207a:	e406                	sd	ra,8(sp)
    8000207c:	e022                	sd	s0,0(sp)
    8000207e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	dd8080e7          	jalr	-552(ra) # 80000e58 <myproc>
}
    80002088:	5908                	lw	a0,48(a0)
    8000208a:	60a2                	ld	ra,8(sp)
    8000208c:	6402                	ld	s0,0(sp)
    8000208e:	0141                	addi	sp,sp,16
    80002090:	8082                	ret

0000000080002092 <sys_fork>:

uint64
sys_fork(void)
{
    80002092:	1141                	addi	sp,sp,-16
    80002094:	e406                	sd	ra,8(sp)
    80002096:	e022                	sd	s0,0(sp)
    80002098:	0800                	addi	s0,sp,16
  return fork();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	174080e7          	jalr	372(ra) # 8000120e <fork>
}
    800020a2:	60a2                	ld	ra,8(sp)
    800020a4:	6402                	ld	s0,0(sp)
    800020a6:	0141                	addi	sp,sp,16
    800020a8:	8082                	ret

00000000800020aa <sys_wait>:

uint64
sys_wait(void)
{
    800020aa:	1101                	addi	sp,sp,-32
    800020ac:	ec06                	sd	ra,24(sp)
    800020ae:	e822                	sd	s0,16(sp)
    800020b0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800020b2:	fe840593          	addi	a1,s0,-24
    800020b6:	4501                	li	a0,0
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	ed0080e7          	jalr	-304(ra) # 80001f88 <argaddr>
  return wait(p);
    800020c0:	fe843503          	ld	a0,-24(s0)
    800020c4:	fffff097          	auipc	ra,0xfffff
    800020c8:	712080e7          	jalr	1810(ra) # 800017d6 <wait>
}
    800020cc:	60e2                	ld	ra,24(sp)
    800020ce:	6442                	ld	s0,16(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020d4:	7179                	addi	sp,sp,-48
    800020d6:	f406                	sd	ra,40(sp)
    800020d8:	f022                	sd	s0,32(sp)
    800020da:	ec26                	sd	s1,24(sp)
    800020dc:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800020de:	fdc40593          	addi	a1,s0,-36
    800020e2:	4501                	li	a0,0
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	e84080e7          	jalr	-380(ra) # 80001f68 <argint>
  addr = myproc()->sz;
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	d6c080e7          	jalr	-660(ra) # 80000e58 <myproc>
    800020f4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800020f6:	fdc42503          	lw	a0,-36(s0)
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	0b8080e7          	jalr	184(ra) # 800011b2 <growproc>
    80002102:	00054863          	bltz	a0,80002112 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002106:	8526                	mv	a0,s1
    80002108:	70a2                	ld	ra,40(sp)
    8000210a:	7402                	ld	s0,32(sp)
    8000210c:	64e2                	ld	s1,24(sp)
    8000210e:	6145                	addi	sp,sp,48
    80002110:	8082                	ret
    return -1;
    80002112:	54fd                	li	s1,-1
    80002114:	bfcd                	j	80002106 <sys_sbrk+0x32>

0000000080002116 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002116:	7139                	addi	sp,sp,-64
    80002118:	fc06                	sd	ra,56(sp)
    8000211a:	f822                	sd	s0,48(sp)
    8000211c:	f426                	sd	s1,40(sp)
    8000211e:	f04a                	sd	s2,32(sp)
    80002120:	ec4e                	sd	s3,24(sp)
    80002122:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002124:	fcc40593          	addi	a1,s0,-52
    80002128:	4501                	li	a0,0
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	e3e080e7          	jalr	-450(ra) # 80001f68 <argint>
  if(n < 0)
    80002132:	fcc42783          	lw	a5,-52(s0)
    80002136:	0607cf63          	bltz	a5,800021b4 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000213a:	0000c517          	auipc	a0,0xc
    8000213e:	5d650513          	addi	a0,a0,1494 # 8000e710 <tickslock>
    80002142:	00004097          	auipc	ra,0x4
    80002146:	fea080e7          	jalr	-22(ra) # 8000612c <acquire>
  ticks0 = ticks;
    8000214a:	00006917          	auipc	s2,0x6
    8000214e:	75e92903          	lw	s2,1886(s2) # 800088a8 <ticks>
  while(ticks - ticks0 < n){
    80002152:	fcc42783          	lw	a5,-52(s0)
    80002156:	cf9d                	beqz	a5,80002194 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002158:	0000c997          	auipc	s3,0xc
    8000215c:	5b898993          	addi	s3,s3,1464 # 8000e710 <tickslock>
    80002160:	00006497          	auipc	s1,0x6
    80002164:	74848493          	addi	s1,s1,1864 # 800088a8 <ticks>
    if(killed(myproc())){
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	cf0080e7          	jalr	-784(ra) # 80000e58 <myproc>
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	634080e7          	jalr	1588(ra) # 800017a4 <killed>
    80002178:	e129                	bnez	a0,800021ba <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000217a:	85ce                	mv	a1,s3
    8000217c:	8526                	mv	a0,s1
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	37e080e7          	jalr	894(ra) # 800014fc <sleep>
  while(ticks - ticks0 < n){
    80002186:	409c                	lw	a5,0(s1)
    80002188:	412787bb          	subw	a5,a5,s2
    8000218c:	fcc42703          	lw	a4,-52(s0)
    80002190:	fce7ece3          	bltu	a5,a4,80002168 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002194:	0000c517          	auipc	a0,0xc
    80002198:	57c50513          	addi	a0,a0,1404 # 8000e710 <tickslock>
    8000219c:	00004097          	auipc	ra,0x4
    800021a0:	044080e7          	jalr	68(ra) # 800061e0 <release>
  return 0;
    800021a4:	4501                	li	a0,0
}
    800021a6:	70e2                	ld	ra,56(sp)
    800021a8:	7442                	ld	s0,48(sp)
    800021aa:	74a2                	ld	s1,40(sp)
    800021ac:	7902                	ld	s2,32(sp)
    800021ae:	69e2                	ld	s3,24(sp)
    800021b0:	6121                	addi	sp,sp,64
    800021b2:	8082                	ret
    n = 0;
    800021b4:	fc042623          	sw	zero,-52(s0)
    800021b8:	b749                	j	8000213a <sys_sleep+0x24>
      release(&tickslock);
    800021ba:	0000c517          	auipc	a0,0xc
    800021be:	55650513          	addi	a0,a0,1366 # 8000e710 <tickslock>
    800021c2:	00004097          	auipc	ra,0x4
    800021c6:	01e080e7          	jalr	30(ra) # 800061e0 <release>
      return -1;
    800021ca:	557d                	li	a0,-1
    800021cc:	bfe9                	j	800021a6 <sys_sleep+0x90>

00000000800021ce <sys_kill>:

uint64
sys_kill(void)
{
    800021ce:	1101                	addi	sp,sp,-32
    800021d0:	ec06                	sd	ra,24(sp)
    800021d2:	e822                	sd	s0,16(sp)
    800021d4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800021d6:	fec40593          	addi	a1,s0,-20
    800021da:	4501                	li	a0,0
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	d8c080e7          	jalr	-628(ra) # 80001f68 <argint>
  return kill(pid);
    800021e4:	fec42503          	lw	a0,-20(s0)
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	51e080e7          	jalr	1310(ra) # 80001706 <kill>
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	6105                	addi	sp,sp,32
    800021f6:	8082                	ret

00000000800021f8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021f8:	1101                	addi	sp,sp,-32
    800021fa:	ec06                	sd	ra,24(sp)
    800021fc:	e822                	sd	s0,16(sp)
    800021fe:	e426                	sd	s1,8(sp)
    80002200:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002202:	0000c517          	auipc	a0,0xc
    80002206:	50e50513          	addi	a0,a0,1294 # 8000e710 <tickslock>
    8000220a:	00004097          	auipc	ra,0x4
    8000220e:	f22080e7          	jalr	-222(ra) # 8000612c <acquire>
  xticks = ticks;
    80002212:	00006497          	auipc	s1,0x6
    80002216:	6964a483          	lw	s1,1686(s1) # 800088a8 <ticks>
  release(&tickslock);
    8000221a:	0000c517          	auipc	a0,0xc
    8000221e:	4f650513          	addi	a0,a0,1270 # 8000e710 <tickslock>
    80002222:	00004097          	auipc	ra,0x4
    80002226:	fbe080e7          	jalr	-66(ra) # 800061e0 <release>
  return xticks;
}
    8000222a:	02049513          	slli	a0,s1,0x20
    8000222e:	9101                	srli	a0,a0,0x20
    80002230:	60e2                	ld	ra,24(sp)
    80002232:	6442                	ld	s0,16(sp)
    80002234:	64a2                	ld	s1,8(sp)
    80002236:	6105                	addi	sp,sp,32
    80002238:	8082                	ret

000000008000223a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000223a:	7179                	addi	sp,sp,-48
    8000223c:	f406                	sd	ra,40(sp)
    8000223e:	f022                	sd	s0,32(sp)
    80002240:	ec26                	sd	s1,24(sp)
    80002242:	e84a                	sd	s2,16(sp)
    80002244:	e44e                	sd	s3,8(sp)
    80002246:	e052                	sd	s4,0(sp)
    80002248:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000224a:	00006597          	auipc	a1,0x6
    8000224e:	23658593          	addi	a1,a1,566 # 80008480 <syscalls+0xb0>
    80002252:	0000c517          	auipc	a0,0xc
    80002256:	4d650513          	addi	a0,a0,1238 # 8000e728 <bcache>
    8000225a:	00004097          	auipc	ra,0x4
    8000225e:	e42080e7          	jalr	-446(ra) # 8000609c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002262:	00014797          	auipc	a5,0x14
    80002266:	4c678793          	addi	a5,a5,1222 # 80016728 <bcache+0x8000>
    8000226a:	00014717          	auipc	a4,0x14
    8000226e:	72670713          	addi	a4,a4,1830 # 80016990 <bcache+0x8268>
    80002272:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002276:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000227a:	0000c497          	auipc	s1,0xc
    8000227e:	4c648493          	addi	s1,s1,1222 # 8000e740 <bcache+0x18>
    b->next = bcache.head.next;
    80002282:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002284:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002286:	00006a17          	auipc	s4,0x6
    8000228a:	202a0a13          	addi	s4,s4,514 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000228e:	2b893783          	ld	a5,696(s2)
    80002292:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002294:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002298:	85d2                	mv	a1,s4
    8000229a:	01048513          	addi	a0,s1,16
    8000229e:	00001097          	auipc	ra,0x1
    800022a2:	4c4080e7          	jalr	1220(ra) # 80003762 <initsleeplock>
    bcache.head.next->prev = b;
    800022a6:	2b893783          	ld	a5,696(s2)
    800022aa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022ac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022b0:	45848493          	addi	s1,s1,1112
    800022b4:	fd349de3          	bne	s1,s3,8000228e <binit+0x54>
  }
}
    800022b8:	70a2                	ld	ra,40(sp)
    800022ba:	7402                	ld	s0,32(sp)
    800022bc:	64e2                	ld	s1,24(sp)
    800022be:	6942                	ld	s2,16(sp)
    800022c0:	69a2                	ld	s3,8(sp)
    800022c2:	6a02                	ld	s4,0(sp)
    800022c4:	6145                	addi	sp,sp,48
    800022c6:	8082                	ret

00000000800022c8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022c8:	7179                	addi	sp,sp,-48
    800022ca:	f406                	sd	ra,40(sp)
    800022cc:	f022                	sd	s0,32(sp)
    800022ce:	ec26                	sd	s1,24(sp)
    800022d0:	e84a                	sd	s2,16(sp)
    800022d2:	e44e                	sd	s3,8(sp)
    800022d4:	1800                	addi	s0,sp,48
    800022d6:	89aa                	mv	s3,a0
    800022d8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800022da:	0000c517          	auipc	a0,0xc
    800022de:	44e50513          	addi	a0,a0,1102 # 8000e728 <bcache>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	e4a080e7          	jalr	-438(ra) # 8000612c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022ea:	00014497          	auipc	s1,0x14
    800022ee:	6f64b483          	ld	s1,1782(s1) # 800169e0 <bcache+0x82b8>
    800022f2:	00014797          	auipc	a5,0x14
    800022f6:	69e78793          	addi	a5,a5,1694 # 80016990 <bcache+0x8268>
    800022fa:	02f48f63          	beq	s1,a5,80002338 <bread+0x70>
    800022fe:	873e                	mv	a4,a5
    80002300:	a021                	j	80002308 <bread+0x40>
    80002302:	68a4                	ld	s1,80(s1)
    80002304:	02e48a63          	beq	s1,a4,80002338 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002308:	449c                	lw	a5,8(s1)
    8000230a:	ff379ce3          	bne	a5,s3,80002302 <bread+0x3a>
    8000230e:	44dc                	lw	a5,12(s1)
    80002310:	ff2799e3          	bne	a5,s2,80002302 <bread+0x3a>
      b->refcnt++;
    80002314:	40bc                	lw	a5,64(s1)
    80002316:	2785                	addiw	a5,a5,1
    80002318:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000231a:	0000c517          	auipc	a0,0xc
    8000231e:	40e50513          	addi	a0,a0,1038 # 8000e728 <bcache>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	ebe080e7          	jalr	-322(ra) # 800061e0 <release>
      acquiresleep(&b->lock);
    8000232a:	01048513          	addi	a0,s1,16
    8000232e:	00001097          	auipc	ra,0x1
    80002332:	46e080e7          	jalr	1134(ra) # 8000379c <acquiresleep>
      return b;
    80002336:	a8b9                	j	80002394 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002338:	00014497          	auipc	s1,0x14
    8000233c:	6a04b483          	ld	s1,1696(s1) # 800169d8 <bcache+0x82b0>
    80002340:	00014797          	auipc	a5,0x14
    80002344:	65078793          	addi	a5,a5,1616 # 80016990 <bcache+0x8268>
    80002348:	00f48863          	beq	s1,a5,80002358 <bread+0x90>
    8000234c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000234e:	40bc                	lw	a5,64(s1)
    80002350:	cf81                	beqz	a5,80002368 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002352:	64a4                	ld	s1,72(s1)
    80002354:	fee49de3          	bne	s1,a4,8000234e <bread+0x86>
  panic("bget: no buffers");
    80002358:	00006517          	auipc	a0,0x6
    8000235c:	13850513          	addi	a0,a0,312 # 80008490 <syscalls+0xc0>
    80002360:	00004097          	auipc	ra,0x4
    80002364:	882080e7          	jalr	-1918(ra) # 80005be2 <panic>
      b->dev = dev;
    80002368:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000236c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002370:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002374:	4785                	li	a5,1
    80002376:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002378:	0000c517          	auipc	a0,0xc
    8000237c:	3b050513          	addi	a0,a0,944 # 8000e728 <bcache>
    80002380:	00004097          	auipc	ra,0x4
    80002384:	e60080e7          	jalr	-416(ra) # 800061e0 <release>
      acquiresleep(&b->lock);
    80002388:	01048513          	addi	a0,s1,16
    8000238c:	00001097          	auipc	ra,0x1
    80002390:	410080e7          	jalr	1040(ra) # 8000379c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002394:	409c                	lw	a5,0(s1)
    80002396:	cb89                	beqz	a5,800023a8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002398:	8526                	mv	a0,s1
    8000239a:	70a2                	ld	ra,40(sp)
    8000239c:	7402                	ld	s0,32(sp)
    8000239e:	64e2                	ld	s1,24(sp)
    800023a0:	6942                	ld	s2,16(sp)
    800023a2:	69a2                	ld	s3,8(sp)
    800023a4:	6145                	addi	sp,sp,48
    800023a6:	8082                	ret
    virtio_disk_rw(b, 0);
    800023a8:	4581                	li	a1,0
    800023aa:	8526                	mv	a0,s1
    800023ac:	00003097          	auipc	ra,0x3
    800023b0:	fcc080e7          	jalr	-52(ra) # 80005378 <virtio_disk_rw>
    b->valid = 1;
    800023b4:	4785                	li	a5,1
    800023b6:	c09c                	sw	a5,0(s1)
  return b;
    800023b8:	b7c5                	j	80002398 <bread+0xd0>

00000000800023ba <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023ba:	1101                	addi	sp,sp,-32
    800023bc:	ec06                	sd	ra,24(sp)
    800023be:	e822                	sd	s0,16(sp)
    800023c0:	e426                	sd	s1,8(sp)
    800023c2:	1000                	addi	s0,sp,32
    800023c4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023c6:	0541                	addi	a0,a0,16
    800023c8:	00001097          	auipc	ra,0x1
    800023cc:	46e080e7          	jalr	1134(ra) # 80003836 <holdingsleep>
    800023d0:	cd01                	beqz	a0,800023e8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023d2:	4585                	li	a1,1
    800023d4:	8526                	mv	a0,s1
    800023d6:	00003097          	auipc	ra,0x3
    800023da:	fa2080e7          	jalr	-94(ra) # 80005378 <virtio_disk_rw>
}
    800023de:	60e2                	ld	ra,24(sp)
    800023e0:	6442                	ld	s0,16(sp)
    800023e2:	64a2                	ld	s1,8(sp)
    800023e4:	6105                	addi	sp,sp,32
    800023e6:	8082                	ret
    panic("bwrite");
    800023e8:	00006517          	auipc	a0,0x6
    800023ec:	0c050513          	addi	a0,a0,192 # 800084a8 <syscalls+0xd8>
    800023f0:	00003097          	auipc	ra,0x3
    800023f4:	7f2080e7          	jalr	2034(ra) # 80005be2 <panic>

00000000800023f8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023f8:	1101                	addi	sp,sp,-32
    800023fa:	ec06                	sd	ra,24(sp)
    800023fc:	e822                	sd	s0,16(sp)
    800023fe:	e426                	sd	s1,8(sp)
    80002400:	e04a                	sd	s2,0(sp)
    80002402:	1000                	addi	s0,sp,32
    80002404:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002406:	01050913          	addi	s2,a0,16
    8000240a:	854a                	mv	a0,s2
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	42a080e7          	jalr	1066(ra) # 80003836 <holdingsleep>
    80002414:	c92d                	beqz	a0,80002486 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002416:	854a                	mv	a0,s2
    80002418:	00001097          	auipc	ra,0x1
    8000241c:	3da080e7          	jalr	986(ra) # 800037f2 <releasesleep>

  acquire(&bcache.lock);
    80002420:	0000c517          	auipc	a0,0xc
    80002424:	30850513          	addi	a0,a0,776 # 8000e728 <bcache>
    80002428:	00004097          	auipc	ra,0x4
    8000242c:	d04080e7          	jalr	-764(ra) # 8000612c <acquire>
  b->refcnt--;
    80002430:	40bc                	lw	a5,64(s1)
    80002432:	37fd                	addiw	a5,a5,-1
    80002434:	0007871b          	sext.w	a4,a5
    80002438:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000243a:	eb05                	bnez	a4,8000246a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000243c:	68bc                	ld	a5,80(s1)
    8000243e:	64b8                	ld	a4,72(s1)
    80002440:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002442:	64bc                	ld	a5,72(s1)
    80002444:	68b8                	ld	a4,80(s1)
    80002446:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002448:	00014797          	auipc	a5,0x14
    8000244c:	2e078793          	addi	a5,a5,736 # 80016728 <bcache+0x8000>
    80002450:	2b87b703          	ld	a4,696(a5)
    80002454:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002456:	00014717          	auipc	a4,0x14
    8000245a:	53a70713          	addi	a4,a4,1338 # 80016990 <bcache+0x8268>
    8000245e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002460:	2b87b703          	ld	a4,696(a5)
    80002464:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002466:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000246a:	0000c517          	auipc	a0,0xc
    8000246e:	2be50513          	addi	a0,a0,702 # 8000e728 <bcache>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	d6e080e7          	jalr	-658(ra) # 800061e0 <release>
}
    8000247a:	60e2                	ld	ra,24(sp)
    8000247c:	6442                	ld	s0,16(sp)
    8000247e:	64a2                	ld	s1,8(sp)
    80002480:	6902                	ld	s2,0(sp)
    80002482:	6105                	addi	sp,sp,32
    80002484:	8082                	ret
    panic("brelse");
    80002486:	00006517          	auipc	a0,0x6
    8000248a:	02a50513          	addi	a0,a0,42 # 800084b0 <syscalls+0xe0>
    8000248e:	00003097          	auipc	ra,0x3
    80002492:	754080e7          	jalr	1876(ra) # 80005be2 <panic>

0000000080002496 <bpin>:

void
bpin(struct buf *b) {
    80002496:	1101                	addi	sp,sp,-32
    80002498:	ec06                	sd	ra,24(sp)
    8000249a:	e822                	sd	s0,16(sp)
    8000249c:	e426                	sd	s1,8(sp)
    8000249e:	1000                	addi	s0,sp,32
    800024a0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024a2:	0000c517          	auipc	a0,0xc
    800024a6:	28650513          	addi	a0,a0,646 # 8000e728 <bcache>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	c82080e7          	jalr	-894(ra) # 8000612c <acquire>
  b->refcnt++;
    800024b2:	40bc                	lw	a5,64(s1)
    800024b4:	2785                	addiw	a5,a5,1
    800024b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024b8:	0000c517          	auipc	a0,0xc
    800024bc:	27050513          	addi	a0,a0,624 # 8000e728 <bcache>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	d20080e7          	jalr	-736(ra) # 800061e0 <release>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6105                	addi	sp,sp,32
    800024d0:	8082                	ret

00000000800024d2 <bunpin>:

void
bunpin(struct buf *b) {
    800024d2:	1101                	addi	sp,sp,-32
    800024d4:	ec06                	sd	ra,24(sp)
    800024d6:	e822                	sd	s0,16(sp)
    800024d8:	e426                	sd	s1,8(sp)
    800024da:	1000                	addi	s0,sp,32
    800024dc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024de:	0000c517          	auipc	a0,0xc
    800024e2:	24a50513          	addi	a0,a0,586 # 8000e728 <bcache>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	c46080e7          	jalr	-954(ra) # 8000612c <acquire>
  b->refcnt--;
    800024ee:	40bc                	lw	a5,64(s1)
    800024f0:	37fd                	addiw	a5,a5,-1
    800024f2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024f4:	0000c517          	auipc	a0,0xc
    800024f8:	23450513          	addi	a0,a0,564 # 8000e728 <bcache>
    800024fc:	00004097          	auipc	ra,0x4
    80002500:	ce4080e7          	jalr	-796(ra) # 800061e0 <release>
}
    80002504:	60e2                	ld	ra,24(sp)
    80002506:	6442                	ld	s0,16(sp)
    80002508:	64a2                	ld	s1,8(sp)
    8000250a:	6105                	addi	sp,sp,32
    8000250c:	8082                	ret

000000008000250e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000250e:	1101                	addi	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	e04a                	sd	s2,0(sp)
    80002518:	1000                	addi	s0,sp,32
    8000251a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000251c:	00d5d59b          	srliw	a1,a1,0xd
    80002520:	00015797          	auipc	a5,0x15
    80002524:	8e47a783          	lw	a5,-1820(a5) # 80016e04 <sb+0x1c>
    80002528:	9dbd                	addw	a1,a1,a5
    8000252a:	00000097          	auipc	ra,0x0
    8000252e:	d9e080e7          	jalr	-610(ra) # 800022c8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002532:	0074f713          	andi	a4,s1,7
    80002536:	4785                	li	a5,1
    80002538:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000253c:	14ce                	slli	s1,s1,0x33
    8000253e:	90d9                	srli	s1,s1,0x36
    80002540:	00950733          	add	a4,a0,s1
    80002544:	05874703          	lbu	a4,88(a4)
    80002548:	00e7f6b3          	and	a3,a5,a4
    8000254c:	c69d                	beqz	a3,8000257a <bfree+0x6c>
    8000254e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002550:	94aa                	add	s1,s1,a0
    80002552:	fff7c793          	not	a5,a5
    80002556:	8ff9                	and	a5,a5,a4
    80002558:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000255c:	00001097          	auipc	ra,0x1
    80002560:	120080e7          	jalr	288(ra) # 8000367c <log_write>
  brelse(bp);
    80002564:	854a                	mv	a0,s2
    80002566:	00000097          	auipc	ra,0x0
    8000256a:	e92080e7          	jalr	-366(ra) # 800023f8 <brelse>
}
    8000256e:	60e2                	ld	ra,24(sp)
    80002570:	6442                	ld	s0,16(sp)
    80002572:	64a2                	ld	s1,8(sp)
    80002574:	6902                	ld	s2,0(sp)
    80002576:	6105                	addi	sp,sp,32
    80002578:	8082                	ret
    panic("freeing free block");
    8000257a:	00006517          	auipc	a0,0x6
    8000257e:	f3e50513          	addi	a0,a0,-194 # 800084b8 <syscalls+0xe8>
    80002582:	00003097          	auipc	ra,0x3
    80002586:	660080e7          	jalr	1632(ra) # 80005be2 <panic>

000000008000258a <balloc>:
{
    8000258a:	711d                	addi	sp,sp,-96
    8000258c:	ec86                	sd	ra,88(sp)
    8000258e:	e8a2                	sd	s0,80(sp)
    80002590:	e4a6                	sd	s1,72(sp)
    80002592:	e0ca                	sd	s2,64(sp)
    80002594:	fc4e                	sd	s3,56(sp)
    80002596:	f852                	sd	s4,48(sp)
    80002598:	f456                	sd	s5,40(sp)
    8000259a:	f05a                	sd	s6,32(sp)
    8000259c:	ec5e                	sd	s7,24(sp)
    8000259e:	e862                	sd	s8,16(sp)
    800025a0:	e466                	sd	s9,8(sp)
    800025a2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025a4:	00015797          	auipc	a5,0x15
    800025a8:	8487a783          	lw	a5,-1976(a5) # 80016dec <sb+0x4>
    800025ac:	10078163          	beqz	a5,800026ae <balloc+0x124>
    800025b0:	8baa                	mv	s7,a0
    800025b2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025b4:	00015b17          	auipc	s6,0x15
    800025b8:	834b0b13          	addi	s6,s6,-1996 # 80016de8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025bc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025be:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025c2:	6c89                	lui	s9,0x2
    800025c4:	a061                	j	8000264c <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025c6:	974a                	add	a4,a4,s2
    800025c8:	8fd5                	or	a5,a5,a3
    800025ca:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025ce:	854a                	mv	a0,s2
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	0ac080e7          	jalr	172(ra) # 8000367c <log_write>
        brelse(bp);
    800025d8:	854a                	mv	a0,s2
    800025da:	00000097          	auipc	ra,0x0
    800025de:	e1e080e7          	jalr	-482(ra) # 800023f8 <brelse>
  bp = bread(dev, bno);
    800025e2:	85a6                	mv	a1,s1
    800025e4:	855e                	mv	a0,s7
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	ce2080e7          	jalr	-798(ra) # 800022c8 <bread>
    800025ee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800025f0:	40000613          	li	a2,1024
    800025f4:	4581                	li	a1,0
    800025f6:	05850513          	addi	a0,a0,88
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	b7e080e7          	jalr	-1154(ra) # 80000178 <memset>
  log_write(bp);
    80002602:	854a                	mv	a0,s2
    80002604:	00001097          	auipc	ra,0x1
    80002608:	078080e7          	jalr	120(ra) # 8000367c <log_write>
  brelse(bp);
    8000260c:	854a                	mv	a0,s2
    8000260e:	00000097          	auipc	ra,0x0
    80002612:	dea080e7          	jalr	-534(ra) # 800023f8 <brelse>
}
    80002616:	8526                	mv	a0,s1
    80002618:	60e6                	ld	ra,88(sp)
    8000261a:	6446                	ld	s0,80(sp)
    8000261c:	64a6                	ld	s1,72(sp)
    8000261e:	6906                	ld	s2,64(sp)
    80002620:	79e2                	ld	s3,56(sp)
    80002622:	7a42                	ld	s4,48(sp)
    80002624:	7aa2                	ld	s5,40(sp)
    80002626:	7b02                	ld	s6,32(sp)
    80002628:	6be2                	ld	s7,24(sp)
    8000262a:	6c42                	ld	s8,16(sp)
    8000262c:	6ca2                	ld	s9,8(sp)
    8000262e:	6125                	addi	sp,sp,96
    80002630:	8082                	ret
    brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	dc4080e7          	jalr	-572(ra) # 800023f8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000263c:	015c87bb          	addw	a5,s9,s5
    80002640:	00078a9b          	sext.w	s5,a5
    80002644:	004b2703          	lw	a4,4(s6)
    80002648:	06eaf363          	bgeu	s5,a4,800026ae <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000264c:	41fad79b          	sraiw	a5,s5,0x1f
    80002650:	0137d79b          	srliw	a5,a5,0x13
    80002654:	015787bb          	addw	a5,a5,s5
    80002658:	40d7d79b          	sraiw	a5,a5,0xd
    8000265c:	01cb2583          	lw	a1,28(s6)
    80002660:	9dbd                	addw	a1,a1,a5
    80002662:	855e                	mv	a0,s7
    80002664:	00000097          	auipc	ra,0x0
    80002668:	c64080e7          	jalr	-924(ra) # 800022c8 <bread>
    8000266c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000266e:	004b2503          	lw	a0,4(s6)
    80002672:	000a849b          	sext.w	s1,s5
    80002676:	8662                	mv	a2,s8
    80002678:	faa4fde3          	bgeu	s1,a0,80002632 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000267c:	41f6579b          	sraiw	a5,a2,0x1f
    80002680:	01d7d69b          	srliw	a3,a5,0x1d
    80002684:	00c6873b          	addw	a4,a3,a2
    80002688:	00777793          	andi	a5,a4,7
    8000268c:	9f95                	subw	a5,a5,a3
    8000268e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002692:	4037571b          	sraiw	a4,a4,0x3
    80002696:	00e906b3          	add	a3,s2,a4
    8000269a:	0586c683          	lbu	a3,88(a3)
    8000269e:	00d7f5b3          	and	a1,a5,a3
    800026a2:	d195                	beqz	a1,800025c6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a4:	2605                	addiw	a2,a2,1
    800026a6:	2485                	addiw	s1,s1,1
    800026a8:	fd4618e3          	bne	a2,s4,80002678 <balloc+0xee>
    800026ac:	b759                	j	80002632 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800026ae:	00006517          	auipc	a0,0x6
    800026b2:	e2250513          	addi	a0,a0,-478 # 800084d0 <syscalls+0x100>
    800026b6:	00003097          	auipc	ra,0x3
    800026ba:	576080e7          	jalr	1398(ra) # 80005c2c <printf>
  return 0;
    800026be:	4481                	li	s1,0
    800026c0:	bf99                	j	80002616 <balloc+0x8c>

00000000800026c2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800026c2:	7179                	addi	sp,sp,-48
    800026c4:	f406                	sd	ra,40(sp)
    800026c6:	f022                	sd	s0,32(sp)
    800026c8:	ec26                	sd	s1,24(sp)
    800026ca:	e84a                	sd	s2,16(sp)
    800026cc:	e44e                	sd	s3,8(sp)
    800026ce:	e052                	sd	s4,0(sp)
    800026d0:	1800                	addi	s0,sp,48
    800026d2:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026d4:	47ad                	li	a5,11
    800026d6:	02b7e763          	bltu	a5,a1,80002704 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800026da:	02059493          	slli	s1,a1,0x20
    800026de:	9081                	srli	s1,s1,0x20
    800026e0:	048a                	slli	s1,s1,0x2
    800026e2:	94aa                	add	s1,s1,a0
    800026e4:	0504a903          	lw	s2,80(s1)
    800026e8:	06091e63          	bnez	s2,80002764 <bmap+0xa2>
      addr = balloc(ip->dev);
    800026ec:	4108                	lw	a0,0(a0)
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	e9c080e7          	jalr	-356(ra) # 8000258a <balloc>
    800026f6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800026fa:	06090563          	beqz	s2,80002764 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800026fe:	0524a823          	sw	s2,80(s1)
    80002702:	a08d                	j	80002764 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002704:	ff45849b          	addiw	s1,a1,-12
    80002708:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000270c:	0ff00793          	li	a5,255
    80002710:	08e7e563          	bltu	a5,a4,8000279a <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002714:	08052903          	lw	s2,128(a0)
    80002718:	00091d63          	bnez	s2,80002732 <bmap+0x70>
      addr = balloc(ip->dev);
    8000271c:	4108                	lw	a0,0(a0)
    8000271e:	00000097          	auipc	ra,0x0
    80002722:	e6c080e7          	jalr	-404(ra) # 8000258a <balloc>
    80002726:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000272a:	02090d63          	beqz	s2,80002764 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000272e:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002732:	85ca                	mv	a1,s2
    80002734:	0009a503          	lw	a0,0(s3)
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	b90080e7          	jalr	-1136(ra) # 800022c8 <bread>
    80002740:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002742:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002746:	02049593          	slli	a1,s1,0x20
    8000274a:	9181                	srli	a1,a1,0x20
    8000274c:	058a                	slli	a1,a1,0x2
    8000274e:	00b784b3          	add	s1,a5,a1
    80002752:	0004a903          	lw	s2,0(s1)
    80002756:	02090063          	beqz	s2,80002776 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000275a:	8552                	mv	a0,s4
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	c9c080e7          	jalr	-868(ra) # 800023f8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002764:	854a                	mv	a0,s2
    80002766:	70a2                	ld	ra,40(sp)
    80002768:	7402                	ld	s0,32(sp)
    8000276a:	64e2                	ld	s1,24(sp)
    8000276c:	6942                	ld	s2,16(sp)
    8000276e:	69a2                	ld	s3,8(sp)
    80002770:	6a02                	ld	s4,0(sp)
    80002772:	6145                	addi	sp,sp,48
    80002774:	8082                	ret
      addr = balloc(ip->dev);
    80002776:	0009a503          	lw	a0,0(s3)
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	e10080e7          	jalr	-496(ra) # 8000258a <balloc>
    80002782:	0005091b          	sext.w	s2,a0
      if(addr){
    80002786:	fc090ae3          	beqz	s2,8000275a <bmap+0x98>
        a[bn] = addr;
    8000278a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000278e:	8552                	mv	a0,s4
    80002790:	00001097          	auipc	ra,0x1
    80002794:	eec080e7          	jalr	-276(ra) # 8000367c <log_write>
    80002798:	b7c9                	j	8000275a <bmap+0x98>
  panic("bmap: out of range");
    8000279a:	00006517          	auipc	a0,0x6
    8000279e:	d4e50513          	addi	a0,a0,-690 # 800084e8 <syscalls+0x118>
    800027a2:	00003097          	auipc	ra,0x3
    800027a6:	440080e7          	jalr	1088(ra) # 80005be2 <panic>

00000000800027aa <iget>:
{
    800027aa:	7179                	addi	sp,sp,-48
    800027ac:	f406                	sd	ra,40(sp)
    800027ae:	f022                	sd	s0,32(sp)
    800027b0:	ec26                	sd	s1,24(sp)
    800027b2:	e84a                	sd	s2,16(sp)
    800027b4:	e44e                	sd	s3,8(sp)
    800027b6:	e052                	sd	s4,0(sp)
    800027b8:	1800                	addi	s0,sp,48
    800027ba:	89aa                	mv	s3,a0
    800027bc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027be:	00014517          	auipc	a0,0x14
    800027c2:	64a50513          	addi	a0,a0,1610 # 80016e08 <itable>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	966080e7          	jalr	-1690(ra) # 8000612c <acquire>
  empty = 0;
    800027ce:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027d0:	00014497          	auipc	s1,0x14
    800027d4:	65048493          	addi	s1,s1,1616 # 80016e20 <itable+0x18>
    800027d8:	00016697          	auipc	a3,0x16
    800027dc:	0d868693          	addi	a3,a3,216 # 800188b0 <log>
    800027e0:	a039                	j	800027ee <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027e2:	02090b63          	beqz	s2,80002818 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e6:	08848493          	addi	s1,s1,136
    800027ea:	02d48a63          	beq	s1,a3,8000281e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027ee:	449c                	lw	a5,8(s1)
    800027f0:	fef059e3          	blez	a5,800027e2 <iget+0x38>
    800027f4:	4098                	lw	a4,0(s1)
    800027f6:	ff3716e3          	bne	a4,s3,800027e2 <iget+0x38>
    800027fa:	40d8                	lw	a4,4(s1)
    800027fc:	ff4713e3          	bne	a4,s4,800027e2 <iget+0x38>
      ip->ref++;
    80002800:	2785                	addiw	a5,a5,1
    80002802:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002804:	00014517          	auipc	a0,0x14
    80002808:	60450513          	addi	a0,a0,1540 # 80016e08 <itable>
    8000280c:	00004097          	auipc	ra,0x4
    80002810:	9d4080e7          	jalr	-1580(ra) # 800061e0 <release>
      return ip;
    80002814:	8926                	mv	s2,s1
    80002816:	a03d                	j	80002844 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002818:	f7f9                	bnez	a5,800027e6 <iget+0x3c>
    8000281a:	8926                	mv	s2,s1
    8000281c:	b7e9                	j	800027e6 <iget+0x3c>
  if(empty == 0)
    8000281e:	02090c63          	beqz	s2,80002856 <iget+0xac>
  ip->dev = dev;
    80002822:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002826:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000282a:	4785                	li	a5,1
    8000282c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002830:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002834:	00014517          	auipc	a0,0x14
    80002838:	5d450513          	addi	a0,a0,1492 # 80016e08 <itable>
    8000283c:	00004097          	auipc	ra,0x4
    80002840:	9a4080e7          	jalr	-1628(ra) # 800061e0 <release>
}
    80002844:	854a                	mv	a0,s2
    80002846:	70a2                	ld	ra,40(sp)
    80002848:	7402                	ld	s0,32(sp)
    8000284a:	64e2                	ld	s1,24(sp)
    8000284c:	6942                	ld	s2,16(sp)
    8000284e:	69a2                	ld	s3,8(sp)
    80002850:	6a02                	ld	s4,0(sp)
    80002852:	6145                	addi	sp,sp,48
    80002854:	8082                	ret
    panic("iget: no inodes");
    80002856:	00006517          	auipc	a0,0x6
    8000285a:	caa50513          	addi	a0,a0,-854 # 80008500 <syscalls+0x130>
    8000285e:	00003097          	auipc	ra,0x3
    80002862:	384080e7          	jalr	900(ra) # 80005be2 <panic>

0000000080002866 <fsinit>:
fsinit(int dev) {
    80002866:	7179                	addi	sp,sp,-48
    80002868:	f406                	sd	ra,40(sp)
    8000286a:	f022                	sd	s0,32(sp)
    8000286c:	ec26                	sd	s1,24(sp)
    8000286e:	e84a                	sd	s2,16(sp)
    80002870:	e44e                	sd	s3,8(sp)
    80002872:	1800                	addi	s0,sp,48
    80002874:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002876:	4585                	li	a1,1
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	a50080e7          	jalr	-1456(ra) # 800022c8 <bread>
    80002880:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002882:	00014997          	auipc	s3,0x14
    80002886:	56698993          	addi	s3,s3,1382 # 80016de8 <sb>
    8000288a:	02000613          	li	a2,32
    8000288e:	05850593          	addi	a1,a0,88
    80002892:	854e                	mv	a0,s3
    80002894:	ffffe097          	auipc	ra,0xffffe
    80002898:	944080e7          	jalr	-1724(ra) # 800001d8 <memmove>
  brelse(bp);
    8000289c:	8526                	mv	a0,s1
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	b5a080e7          	jalr	-1190(ra) # 800023f8 <brelse>
  if(sb.magic != FSMAGIC)
    800028a6:	0009a703          	lw	a4,0(s3)
    800028aa:	102037b7          	lui	a5,0x10203
    800028ae:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028b2:	02f71263          	bne	a4,a5,800028d6 <fsinit+0x70>
  initlog(dev, &sb);
    800028b6:	00014597          	auipc	a1,0x14
    800028ba:	53258593          	addi	a1,a1,1330 # 80016de8 <sb>
    800028be:	854a                	mv	a0,s2
    800028c0:	00001097          	auipc	ra,0x1
    800028c4:	b40080e7          	jalr	-1216(ra) # 80003400 <initlog>
}
    800028c8:	70a2                	ld	ra,40(sp)
    800028ca:	7402                	ld	s0,32(sp)
    800028cc:	64e2                	ld	s1,24(sp)
    800028ce:	6942                	ld	s2,16(sp)
    800028d0:	69a2                	ld	s3,8(sp)
    800028d2:	6145                	addi	sp,sp,48
    800028d4:	8082                	ret
    panic("invalid file system");
    800028d6:	00006517          	auipc	a0,0x6
    800028da:	c3a50513          	addi	a0,a0,-966 # 80008510 <syscalls+0x140>
    800028de:	00003097          	auipc	ra,0x3
    800028e2:	304080e7          	jalr	772(ra) # 80005be2 <panic>

00000000800028e6 <iinit>:
{
    800028e6:	7179                	addi	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	e44e                	sd	s3,8(sp)
    800028f2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028f4:	00006597          	auipc	a1,0x6
    800028f8:	c3458593          	addi	a1,a1,-972 # 80008528 <syscalls+0x158>
    800028fc:	00014517          	auipc	a0,0x14
    80002900:	50c50513          	addi	a0,a0,1292 # 80016e08 <itable>
    80002904:	00003097          	auipc	ra,0x3
    80002908:	798080e7          	jalr	1944(ra) # 8000609c <initlock>
  for(i = 0; i < NINODE; i++) {
    8000290c:	00014497          	auipc	s1,0x14
    80002910:	52448493          	addi	s1,s1,1316 # 80016e30 <itable+0x28>
    80002914:	00016997          	auipc	s3,0x16
    80002918:	fac98993          	addi	s3,s3,-84 # 800188c0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000291c:	00006917          	auipc	s2,0x6
    80002920:	c1490913          	addi	s2,s2,-1004 # 80008530 <syscalls+0x160>
    80002924:	85ca                	mv	a1,s2
    80002926:	8526                	mv	a0,s1
    80002928:	00001097          	auipc	ra,0x1
    8000292c:	e3a080e7          	jalr	-454(ra) # 80003762 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002930:	08848493          	addi	s1,s1,136
    80002934:	ff3498e3          	bne	s1,s3,80002924 <iinit+0x3e>
}
    80002938:	70a2                	ld	ra,40(sp)
    8000293a:	7402                	ld	s0,32(sp)
    8000293c:	64e2                	ld	s1,24(sp)
    8000293e:	6942                	ld	s2,16(sp)
    80002940:	69a2                	ld	s3,8(sp)
    80002942:	6145                	addi	sp,sp,48
    80002944:	8082                	ret

0000000080002946 <ialloc>:
{
    80002946:	715d                	addi	sp,sp,-80
    80002948:	e486                	sd	ra,72(sp)
    8000294a:	e0a2                	sd	s0,64(sp)
    8000294c:	fc26                	sd	s1,56(sp)
    8000294e:	f84a                	sd	s2,48(sp)
    80002950:	f44e                	sd	s3,40(sp)
    80002952:	f052                	sd	s4,32(sp)
    80002954:	ec56                	sd	s5,24(sp)
    80002956:	e85a                	sd	s6,16(sp)
    80002958:	e45e                	sd	s7,8(sp)
    8000295a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000295c:	00014717          	auipc	a4,0x14
    80002960:	49872703          	lw	a4,1176(a4) # 80016df4 <sb+0xc>
    80002964:	4785                	li	a5,1
    80002966:	04e7fa63          	bgeu	a5,a4,800029ba <ialloc+0x74>
    8000296a:	8aaa                	mv	s5,a0
    8000296c:	8bae                	mv	s7,a1
    8000296e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002970:	00014a17          	auipc	s4,0x14
    80002974:	478a0a13          	addi	s4,s4,1144 # 80016de8 <sb>
    80002978:	00048b1b          	sext.w	s6,s1
    8000297c:	0044d593          	srli	a1,s1,0x4
    80002980:	018a2783          	lw	a5,24(s4)
    80002984:	9dbd                	addw	a1,a1,a5
    80002986:	8556                	mv	a0,s5
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	940080e7          	jalr	-1728(ra) # 800022c8 <bread>
    80002990:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002992:	05850993          	addi	s3,a0,88
    80002996:	00f4f793          	andi	a5,s1,15
    8000299a:	079a                	slli	a5,a5,0x6
    8000299c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000299e:	00099783          	lh	a5,0(s3)
    800029a2:	c3a1                	beqz	a5,800029e2 <ialloc+0x9c>
    brelse(bp);
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	a54080e7          	jalr	-1452(ra) # 800023f8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029ac:	0485                	addi	s1,s1,1
    800029ae:	00ca2703          	lw	a4,12(s4)
    800029b2:	0004879b          	sext.w	a5,s1
    800029b6:	fce7e1e3          	bltu	a5,a4,80002978 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800029ba:	00006517          	auipc	a0,0x6
    800029be:	b7e50513          	addi	a0,a0,-1154 # 80008538 <syscalls+0x168>
    800029c2:	00003097          	auipc	ra,0x3
    800029c6:	26a080e7          	jalr	618(ra) # 80005c2c <printf>
  return 0;
    800029ca:	4501                	li	a0,0
}
    800029cc:	60a6                	ld	ra,72(sp)
    800029ce:	6406                	ld	s0,64(sp)
    800029d0:	74e2                	ld	s1,56(sp)
    800029d2:	7942                	ld	s2,48(sp)
    800029d4:	79a2                	ld	s3,40(sp)
    800029d6:	7a02                	ld	s4,32(sp)
    800029d8:	6ae2                	ld	s5,24(sp)
    800029da:	6b42                	ld	s6,16(sp)
    800029dc:	6ba2                	ld	s7,8(sp)
    800029de:	6161                	addi	sp,sp,80
    800029e0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800029e2:	04000613          	li	a2,64
    800029e6:	4581                	li	a1,0
    800029e8:	854e                	mv	a0,s3
    800029ea:	ffffd097          	auipc	ra,0xffffd
    800029ee:	78e080e7          	jalr	1934(ra) # 80000178 <memset>
      dip->type = type;
    800029f2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029f6:	854a                	mv	a0,s2
    800029f8:	00001097          	auipc	ra,0x1
    800029fc:	c84080e7          	jalr	-892(ra) # 8000367c <log_write>
      brelse(bp);
    80002a00:	854a                	mv	a0,s2
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	9f6080e7          	jalr	-1546(ra) # 800023f8 <brelse>
      return iget(dev, inum);
    80002a0a:	85da                	mv	a1,s6
    80002a0c:	8556                	mv	a0,s5
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	d9c080e7          	jalr	-612(ra) # 800027aa <iget>
    80002a16:	bf5d                	j	800029cc <ialloc+0x86>

0000000080002a18 <iupdate>:
{
    80002a18:	1101                	addi	sp,sp,-32
    80002a1a:	ec06                	sd	ra,24(sp)
    80002a1c:	e822                	sd	s0,16(sp)
    80002a1e:	e426                	sd	s1,8(sp)
    80002a20:	e04a                	sd	s2,0(sp)
    80002a22:	1000                	addi	s0,sp,32
    80002a24:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a26:	415c                	lw	a5,4(a0)
    80002a28:	0047d79b          	srliw	a5,a5,0x4
    80002a2c:	00014597          	auipc	a1,0x14
    80002a30:	3d45a583          	lw	a1,980(a1) # 80016e00 <sb+0x18>
    80002a34:	9dbd                	addw	a1,a1,a5
    80002a36:	4108                	lw	a0,0(a0)
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	890080e7          	jalr	-1904(ra) # 800022c8 <bread>
    80002a40:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a42:	05850793          	addi	a5,a0,88
    80002a46:	40c8                	lw	a0,4(s1)
    80002a48:	893d                	andi	a0,a0,15
    80002a4a:	051a                	slli	a0,a0,0x6
    80002a4c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a4e:	04449703          	lh	a4,68(s1)
    80002a52:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a56:	04649703          	lh	a4,70(s1)
    80002a5a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a5e:	04849703          	lh	a4,72(s1)
    80002a62:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a66:	04a49703          	lh	a4,74(s1)
    80002a6a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a6e:	44f8                	lw	a4,76(s1)
    80002a70:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a72:	03400613          	li	a2,52
    80002a76:	05048593          	addi	a1,s1,80
    80002a7a:	0531                	addi	a0,a0,12
    80002a7c:	ffffd097          	auipc	ra,0xffffd
    80002a80:	75c080e7          	jalr	1884(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a84:	854a                	mv	a0,s2
    80002a86:	00001097          	auipc	ra,0x1
    80002a8a:	bf6080e7          	jalr	-1034(ra) # 8000367c <log_write>
  brelse(bp);
    80002a8e:	854a                	mv	a0,s2
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	968080e7          	jalr	-1688(ra) # 800023f8 <brelse>
}
    80002a98:	60e2                	ld	ra,24(sp)
    80002a9a:	6442                	ld	s0,16(sp)
    80002a9c:	64a2                	ld	s1,8(sp)
    80002a9e:	6902                	ld	s2,0(sp)
    80002aa0:	6105                	addi	sp,sp,32
    80002aa2:	8082                	ret

0000000080002aa4 <idup>:
{
    80002aa4:	1101                	addi	sp,sp,-32
    80002aa6:	ec06                	sd	ra,24(sp)
    80002aa8:	e822                	sd	s0,16(sp)
    80002aaa:	e426                	sd	s1,8(sp)
    80002aac:	1000                	addi	s0,sp,32
    80002aae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ab0:	00014517          	auipc	a0,0x14
    80002ab4:	35850513          	addi	a0,a0,856 # 80016e08 <itable>
    80002ab8:	00003097          	auipc	ra,0x3
    80002abc:	674080e7          	jalr	1652(ra) # 8000612c <acquire>
  ip->ref++;
    80002ac0:	449c                	lw	a5,8(s1)
    80002ac2:	2785                	addiw	a5,a5,1
    80002ac4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ac6:	00014517          	auipc	a0,0x14
    80002aca:	34250513          	addi	a0,a0,834 # 80016e08 <itable>
    80002ace:	00003097          	auipc	ra,0x3
    80002ad2:	712080e7          	jalr	1810(ra) # 800061e0 <release>
}
    80002ad6:	8526                	mv	a0,s1
    80002ad8:	60e2                	ld	ra,24(sp)
    80002ada:	6442                	ld	s0,16(sp)
    80002adc:	64a2                	ld	s1,8(sp)
    80002ade:	6105                	addi	sp,sp,32
    80002ae0:	8082                	ret

0000000080002ae2 <ilock>:
{
    80002ae2:	1101                	addi	sp,sp,-32
    80002ae4:	ec06                	sd	ra,24(sp)
    80002ae6:	e822                	sd	s0,16(sp)
    80002ae8:	e426                	sd	s1,8(sp)
    80002aea:	e04a                	sd	s2,0(sp)
    80002aec:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002aee:	c115                	beqz	a0,80002b12 <ilock+0x30>
    80002af0:	84aa                	mv	s1,a0
    80002af2:	451c                	lw	a5,8(a0)
    80002af4:	00f05f63          	blez	a5,80002b12 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002af8:	0541                	addi	a0,a0,16
    80002afa:	00001097          	auipc	ra,0x1
    80002afe:	ca2080e7          	jalr	-862(ra) # 8000379c <acquiresleep>
  if(ip->valid == 0){
    80002b02:	40bc                	lw	a5,64(s1)
    80002b04:	cf99                	beqz	a5,80002b22 <ilock+0x40>
}
    80002b06:	60e2                	ld	ra,24(sp)
    80002b08:	6442                	ld	s0,16(sp)
    80002b0a:	64a2                	ld	s1,8(sp)
    80002b0c:	6902                	ld	s2,0(sp)
    80002b0e:	6105                	addi	sp,sp,32
    80002b10:	8082                	ret
    panic("ilock");
    80002b12:	00006517          	auipc	a0,0x6
    80002b16:	a3e50513          	addi	a0,a0,-1474 # 80008550 <syscalls+0x180>
    80002b1a:	00003097          	auipc	ra,0x3
    80002b1e:	0c8080e7          	jalr	200(ra) # 80005be2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b22:	40dc                	lw	a5,4(s1)
    80002b24:	0047d79b          	srliw	a5,a5,0x4
    80002b28:	00014597          	auipc	a1,0x14
    80002b2c:	2d85a583          	lw	a1,728(a1) # 80016e00 <sb+0x18>
    80002b30:	9dbd                	addw	a1,a1,a5
    80002b32:	4088                	lw	a0,0(s1)
    80002b34:	fffff097          	auipc	ra,0xfffff
    80002b38:	794080e7          	jalr	1940(ra) # 800022c8 <bread>
    80002b3c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b3e:	05850593          	addi	a1,a0,88
    80002b42:	40dc                	lw	a5,4(s1)
    80002b44:	8bbd                	andi	a5,a5,15
    80002b46:	079a                	slli	a5,a5,0x6
    80002b48:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b4a:	00059783          	lh	a5,0(a1)
    80002b4e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b52:	00259783          	lh	a5,2(a1)
    80002b56:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b5a:	00459783          	lh	a5,4(a1)
    80002b5e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b62:	00659783          	lh	a5,6(a1)
    80002b66:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b6a:	459c                	lw	a5,8(a1)
    80002b6c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b6e:	03400613          	li	a2,52
    80002b72:	05b1                	addi	a1,a1,12
    80002b74:	05048513          	addi	a0,s1,80
    80002b78:	ffffd097          	auipc	ra,0xffffd
    80002b7c:	660080e7          	jalr	1632(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b80:	854a                	mv	a0,s2
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	876080e7          	jalr	-1930(ra) # 800023f8 <brelse>
    ip->valid = 1;
    80002b8a:	4785                	li	a5,1
    80002b8c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b8e:	04449783          	lh	a5,68(s1)
    80002b92:	fbb5                	bnez	a5,80002b06 <ilock+0x24>
      panic("ilock: no type");
    80002b94:	00006517          	auipc	a0,0x6
    80002b98:	9c450513          	addi	a0,a0,-1596 # 80008558 <syscalls+0x188>
    80002b9c:	00003097          	auipc	ra,0x3
    80002ba0:	046080e7          	jalr	70(ra) # 80005be2 <panic>

0000000080002ba4 <iunlock>:
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	e04a                	sd	s2,0(sp)
    80002bae:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bb0:	c905                	beqz	a0,80002be0 <iunlock+0x3c>
    80002bb2:	84aa                	mv	s1,a0
    80002bb4:	01050913          	addi	s2,a0,16
    80002bb8:	854a                	mv	a0,s2
    80002bba:	00001097          	auipc	ra,0x1
    80002bbe:	c7c080e7          	jalr	-900(ra) # 80003836 <holdingsleep>
    80002bc2:	cd19                	beqz	a0,80002be0 <iunlock+0x3c>
    80002bc4:	449c                	lw	a5,8(s1)
    80002bc6:	00f05d63          	blez	a5,80002be0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bca:	854a                	mv	a0,s2
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	c26080e7          	jalr	-986(ra) # 800037f2 <releasesleep>
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6902                	ld	s2,0(sp)
    80002bdc:	6105                	addi	sp,sp,32
    80002bde:	8082                	ret
    panic("iunlock");
    80002be0:	00006517          	auipc	a0,0x6
    80002be4:	98850513          	addi	a0,a0,-1656 # 80008568 <syscalls+0x198>
    80002be8:	00003097          	auipc	ra,0x3
    80002bec:	ffa080e7          	jalr	-6(ra) # 80005be2 <panic>

0000000080002bf0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bf0:	7179                	addi	sp,sp,-48
    80002bf2:	f406                	sd	ra,40(sp)
    80002bf4:	f022                	sd	s0,32(sp)
    80002bf6:	ec26                	sd	s1,24(sp)
    80002bf8:	e84a                	sd	s2,16(sp)
    80002bfa:	e44e                	sd	s3,8(sp)
    80002bfc:	e052                	sd	s4,0(sp)
    80002bfe:	1800                	addi	s0,sp,48
    80002c00:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c02:	05050493          	addi	s1,a0,80
    80002c06:	08050913          	addi	s2,a0,128
    80002c0a:	a021                	j	80002c12 <itrunc+0x22>
    80002c0c:	0491                	addi	s1,s1,4
    80002c0e:	01248d63          	beq	s1,s2,80002c28 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c12:	408c                	lw	a1,0(s1)
    80002c14:	dde5                	beqz	a1,80002c0c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c16:	0009a503          	lw	a0,0(s3)
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	8f4080e7          	jalr	-1804(ra) # 8000250e <bfree>
      ip->addrs[i] = 0;
    80002c22:	0004a023          	sw	zero,0(s1)
    80002c26:	b7dd                	j	80002c0c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c28:	0809a583          	lw	a1,128(s3)
    80002c2c:	e185                	bnez	a1,80002c4c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c2e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c32:	854e                	mv	a0,s3
    80002c34:	00000097          	auipc	ra,0x0
    80002c38:	de4080e7          	jalr	-540(ra) # 80002a18 <iupdate>
}
    80002c3c:	70a2                	ld	ra,40(sp)
    80002c3e:	7402                	ld	s0,32(sp)
    80002c40:	64e2                	ld	s1,24(sp)
    80002c42:	6942                	ld	s2,16(sp)
    80002c44:	69a2                	ld	s3,8(sp)
    80002c46:	6a02                	ld	s4,0(sp)
    80002c48:	6145                	addi	sp,sp,48
    80002c4a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c4c:	0009a503          	lw	a0,0(s3)
    80002c50:	fffff097          	auipc	ra,0xfffff
    80002c54:	678080e7          	jalr	1656(ra) # 800022c8 <bread>
    80002c58:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c5a:	05850493          	addi	s1,a0,88
    80002c5e:	45850913          	addi	s2,a0,1112
    80002c62:	a811                	j	80002c76 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002c64:	0009a503          	lw	a0,0(s3)
    80002c68:	00000097          	auipc	ra,0x0
    80002c6c:	8a6080e7          	jalr	-1882(ra) # 8000250e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002c70:	0491                	addi	s1,s1,4
    80002c72:	01248563          	beq	s1,s2,80002c7c <itrunc+0x8c>
      if(a[j])
    80002c76:	408c                	lw	a1,0(s1)
    80002c78:	dde5                	beqz	a1,80002c70 <itrunc+0x80>
    80002c7a:	b7ed                	j	80002c64 <itrunc+0x74>
    brelse(bp);
    80002c7c:	8552                	mv	a0,s4
    80002c7e:	fffff097          	auipc	ra,0xfffff
    80002c82:	77a080e7          	jalr	1914(ra) # 800023f8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c86:	0809a583          	lw	a1,128(s3)
    80002c8a:	0009a503          	lw	a0,0(s3)
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	880080e7          	jalr	-1920(ra) # 8000250e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c96:	0809a023          	sw	zero,128(s3)
    80002c9a:	bf51                	j	80002c2e <itrunc+0x3e>

0000000080002c9c <iput>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	e04a                	sd	s2,0(sp)
    80002ca6:	1000                	addi	s0,sp,32
    80002ca8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002caa:	00014517          	auipc	a0,0x14
    80002cae:	15e50513          	addi	a0,a0,350 # 80016e08 <itable>
    80002cb2:	00003097          	auipc	ra,0x3
    80002cb6:	47a080e7          	jalr	1146(ra) # 8000612c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cba:	4498                	lw	a4,8(s1)
    80002cbc:	4785                	li	a5,1
    80002cbe:	02f70363          	beq	a4,a5,80002ce4 <iput+0x48>
  ip->ref--;
    80002cc2:	449c                	lw	a5,8(s1)
    80002cc4:	37fd                	addiw	a5,a5,-1
    80002cc6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cc8:	00014517          	auipc	a0,0x14
    80002ccc:	14050513          	addi	a0,a0,320 # 80016e08 <itable>
    80002cd0:	00003097          	auipc	ra,0x3
    80002cd4:	510080e7          	jalr	1296(ra) # 800061e0 <release>
}
    80002cd8:	60e2                	ld	ra,24(sp)
    80002cda:	6442                	ld	s0,16(sp)
    80002cdc:	64a2                	ld	s1,8(sp)
    80002cde:	6902                	ld	s2,0(sp)
    80002ce0:	6105                	addi	sp,sp,32
    80002ce2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ce4:	40bc                	lw	a5,64(s1)
    80002ce6:	dff1                	beqz	a5,80002cc2 <iput+0x26>
    80002ce8:	04a49783          	lh	a5,74(s1)
    80002cec:	fbf9                	bnez	a5,80002cc2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002cee:	01048913          	addi	s2,s1,16
    80002cf2:	854a                	mv	a0,s2
    80002cf4:	00001097          	auipc	ra,0x1
    80002cf8:	aa8080e7          	jalr	-1368(ra) # 8000379c <acquiresleep>
    release(&itable.lock);
    80002cfc:	00014517          	auipc	a0,0x14
    80002d00:	10c50513          	addi	a0,a0,268 # 80016e08 <itable>
    80002d04:	00003097          	auipc	ra,0x3
    80002d08:	4dc080e7          	jalr	1244(ra) # 800061e0 <release>
    itrunc(ip);
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	ee2080e7          	jalr	-286(ra) # 80002bf0 <itrunc>
    ip->type = 0;
    80002d16:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d1a:	8526                	mv	a0,s1
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	cfc080e7          	jalr	-772(ra) # 80002a18 <iupdate>
    ip->valid = 0;
    80002d24:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d28:	854a                	mv	a0,s2
    80002d2a:	00001097          	auipc	ra,0x1
    80002d2e:	ac8080e7          	jalr	-1336(ra) # 800037f2 <releasesleep>
    acquire(&itable.lock);
    80002d32:	00014517          	auipc	a0,0x14
    80002d36:	0d650513          	addi	a0,a0,214 # 80016e08 <itable>
    80002d3a:	00003097          	auipc	ra,0x3
    80002d3e:	3f2080e7          	jalr	1010(ra) # 8000612c <acquire>
    80002d42:	b741                	j	80002cc2 <iput+0x26>

0000000080002d44 <iunlockput>:
{
    80002d44:	1101                	addi	sp,sp,-32
    80002d46:	ec06                	sd	ra,24(sp)
    80002d48:	e822                	sd	s0,16(sp)
    80002d4a:	e426                	sd	s1,8(sp)
    80002d4c:	1000                	addi	s0,sp,32
    80002d4e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	e54080e7          	jalr	-428(ra) # 80002ba4 <iunlock>
  iput(ip);
    80002d58:	8526                	mv	a0,s1
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	f42080e7          	jalr	-190(ra) # 80002c9c <iput>
}
    80002d62:	60e2                	ld	ra,24(sp)
    80002d64:	6442                	ld	s0,16(sp)
    80002d66:	64a2                	ld	s1,8(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret

0000000080002d6c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d6c:	1141                	addi	sp,sp,-16
    80002d6e:	e422                	sd	s0,8(sp)
    80002d70:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d72:	411c                	lw	a5,0(a0)
    80002d74:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d76:	415c                	lw	a5,4(a0)
    80002d78:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d7a:	04451783          	lh	a5,68(a0)
    80002d7e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d82:	04a51783          	lh	a5,74(a0)
    80002d86:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d8a:	04c56783          	lwu	a5,76(a0)
    80002d8e:	e99c                	sd	a5,16(a1)
}
    80002d90:	6422                	ld	s0,8(sp)
    80002d92:	0141                	addi	sp,sp,16
    80002d94:	8082                	ret

0000000080002d96 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d96:	457c                	lw	a5,76(a0)
    80002d98:	0ed7e963          	bltu	a5,a3,80002e8a <readi+0xf4>
{
    80002d9c:	7159                	addi	sp,sp,-112
    80002d9e:	f486                	sd	ra,104(sp)
    80002da0:	f0a2                	sd	s0,96(sp)
    80002da2:	eca6                	sd	s1,88(sp)
    80002da4:	e8ca                	sd	s2,80(sp)
    80002da6:	e4ce                	sd	s3,72(sp)
    80002da8:	e0d2                	sd	s4,64(sp)
    80002daa:	fc56                	sd	s5,56(sp)
    80002dac:	f85a                	sd	s6,48(sp)
    80002dae:	f45e                	sd	s7,40(sp)
    80002db0:	f062                	sd	s8,32(sp)
    80002db2:	ec66                	sd	s9,24(sp)
    80002db4:	e86a                	sd	s10,16(sp)
    80002db6:	e46e                	sd	s11,8(sp)
    80002db8:	1880                	addi	s0,sp,112
    80002dba:	8b2a                	mv	s6,a0
    80002dbc:	8bae                	mv	s7,a1
    80002dbe:	8a32                	mv	s4,a2
    80002dc0:	84b6                	mv	s1,a3
    80002dc2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002dc4:	9f35                	addw	a4,a4,a3
    return 0;
    80002dc6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dc8:	0ad76063          	bltu	a4,a3,80002e68 <readi+0xd2>
  if(off + n > ip->size)
    80002dcc:	00e7f463          	bgeu	a5,a4,80002dd4 <readi+0x3e>
    n = ip->size - off;
    80002dd0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dd4:	0a0a8963          	beqz	s5,80002e86 <readi+0xf0>
    80002dd8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dda:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dde:	5c7d                	li	s8,-1
    80002de0:	a82d                	j	80002e1a <readi+0x84>
    80002de2:	020d1d93          	slli	s11,s10,0x20
    80002de6:	020ddd93          	srli	s11,s11,0x20
    80002dea:	05890613          	addi	a2,s2,88
    80002dee:	86ee                	mv	a3,s11
    80002df0:	963a                	add	a2,a2,a4
    80002df2:	85d2                	mv	a1,s4
    80002df4:	855e                	mv	a0,s7
    80002df6:	fffff097          	auipc	ra,0xfffff
    80002dfa:	b0e080e7          	jalr	-1266(ra) # 80001904 <either_copyout>
    80002dfe:	05850d63          	beq	a0,s8,80002e58 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e02:	854a                	mv	a0,s2
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	5f4080e7          	jalr	1524(ra) # 800023f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e0c:	013d09bb          	addw	s3,s10,s3
    80002e10:	009d04bb          	addw	s1,s10,s1
    80002e14:	9a6e                	add	s4,s4,s11
    80002e16:	0559f763          	bgeu	s3,s5,80002e64 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e1a:	00a4d59b          	srliw	a1,s1,0xa
    80002e1e:	855a                	mv	a0,s6
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	8a2080e7          	jalr	-1886(ra) # 800026c2 <bmap>
    80002e28:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002e2c:	cd85                	beqz	a1,80002e64 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002e2e:	000b2503          	lw	a0,0(s6)
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	496080e7          	jalr	1174(ra) # 800022c8 <bread>
    80002e3a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e3c:	3ff4f713          	andi	a4,s1,1023
    80002e40:	40ec87bb          	subw	a5,s9,a4
    80002e44:	413a86bb          	subw	a3,s5,s3
    80002e48:	8d3e                	mv	s10,a5
    80002e4a:	2781                	sext.w	a5,a5
    80002e4c:	0006861b          	sext.w	a2,a3
    80002e50:	f8f679e3          	bgeu	a2,a5,80002de2 <readi+0x4c>
    80002e54:	8d36                	mv	s10,a3
    80002e56:	b771                	j	80002de2 <readi+0x4c>
      brelse(bp);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	59e080e7          	jalr	1438(ra) # 800023f8 <brelse>
      tot = -1;
    80002e62:	59fd                	li	s3,-1
  }
  return tot;
    80002e64:	0009851b          	sext.w	a0,s3
}
    80002e68:	70a6                	ld	ra,104(sp)
    80002e6a:	7406                	ld	s0,96(sp)
    80002e6c:	64e6                	ld	s1,88(sp)
    80002e6e:	6946                	ld	s2,80(sp)
    80002e70:	69a6                	ld	s3,72(sp)
    80002e72:	6a06                	ld	s4,64(sp)
    80002e74:	7ae2                	ld	s5,56(sp)
    80002e76:	7b42                	ld	s6,48(sp)
    80002e78:	7ba2                	ld	s7,40(sp)
    80002e7a:	7c02                	ld	s8,32(sp)
    80002e7c:	6ce2                	ld	s9,24(sp)
    80002e7e:	6d42                	ld	s10,16(sp)
    80002e80:	6da2                	ld	s11,8(sp)
    80002e82:	6165                	addi	sp,sp,112
    80002e84:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e86:	89d6                	mv	s3,s5
    80002e88:	bff1                	j	80002e64 <readi+0xce>
    return 0;
    80002e8a:	4501                	li	a0,0
}
    80002e8c:	8082                	ret

0000000080002e8e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8e:	457c                	lw	a5,76(a0)
    80002e90:	10d7e863          	bltu	a5,a3,80002fa0 <writei+0x112>
{
    80002e94:	7159                	addi	sp,sp,-112
    80002e96:	f486                	sd	ra,104(sp)
    80002e98:	f0a2                	sd	s0,96(sp)
    80002e9a:	eca6                	sd	s1,88(sp)
    80002e9c:	e8ca                	sd	s2,80(sp)
    80002e9e:	e4ce                	sd	s3,72(sp)
    80002ea0:	e0d2                	sd	s4,64(sp)
    80002ea2:	fc56                	sd	s5,56(sp)
    80002ea4:	f85a                	sd	s6,48(sp)
    80002ea6:	f45e                	sd	s7,40(sp)
    80002ea8:	f062                	sd	s8,32(sp)
    80002eaa:	ec66                	sd	s9,24(sp)
    80002eac:	e86a                	sd	s10,16(sp)
    80002eae:	e46e                	sd	s11,8(sp)
    80002eb0:	1880                	addi	s0,sp,112
    80002eb2:	8aaa                	mv	s5,a0
    80002eb4:	8bae                	mv	s7,a1
    80002eb6:	8a32                	mv	s4,a2
    80002eb8:	8936                	mv	s2,a3
    80002eba:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ebc:	00e687bb          	addw	a5,a3,a4
    80002ec0:	0ed7e263          	bltu	a5,a3,80002fa4 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ec4:	00043737          	lui	a4,0x43
    80002ec8:	0ef76063          	bltu	a4,a5,80002fa8 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ecc:	0c0b0863          	beqz	s6,80002f9c <writei+0x10e>
    80002ed0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ed2:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ed6:	5c7d                	li	s8,-1
    80002ed8:	a091                	j	80002f1c <writei+0x8e>
    80002eda:	020d1d93          	slli	s11,s10,0x20
    80002ede:	020ddd93          	srli	s11,s11,0x20
    80002ee2:	05848513          	addi	a0,s1,88
    80002ee6:	86ee                	mv	a3,s11
    80002ee8:	8652                	mv	a2,s4
    80002eea:	85de                	mv	a1,s7
    80002eec:	953a                	add	a0,a0,a4
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	a6c080e7          	jalr	-1428(ra) # 8000195a <either_copyin>
    80002ef6:	07850263          	beq	a0,s8,80002f5a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002efa:	8526                	mv	a0,s1
    80002efc:	00000097          	auipc	ra,0x0
    80002f00:	780080e7          	jalr	1920(ra) # 8000367c <log_write>
    brelse(bp);
    80002f04:	8526                	mv	a0,s1
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	4f2080e7          	jalr	1266(ra) # 800023f8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f0e:	013d09bb          	addw	s3,s10,s3
    80002f12:	012d093b          	addw	s2,s10,s2
    80002f16:	9a6e                	add	s4,s4,s11
    80002f18:	0569f663          	bgeu	s3,s6,80002f64 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f1c:	00a9559b          	srliw	a1,s2,0xa
    80002f20:	8556                	mv	a0,s5
    80002f22:	fffff097          	auipc	ra,0xfffff
    80002f26:	7a0080e7          	jalr	1952(ra) # 800026c2 <bmap>
    80002f2a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f2e:	c99d                	beqz	a1,80002f64 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002f30:	000aa503          	lw	a0,0(s5)
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	394080e7          	jalr	916(ra) # 800022c8 <bread>
    80002f3c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3e:	3ff97713          	andi	a4,s2,1023
    80002f42:	40ec87bb          	subw	a5,s9,a4
    80002f46:	413b06bb          	subw	a3,s6,s3
    80002f4a:	8d3e                	mv	s10,a5
    80002f4c:	2781                	sext.w	a5,a5
    80002f4e:	0006861b          	sext.w	a2,a3
    80002f52:	f8f674e3          	bgeu	a2,a5,80002eda <writei+0x4c>
    80002f56:	8d36                	mv	s10,a3
    80002f58:	b749                	j	80002eda <writei+0x4c>
      brelse(bp);
    80002f5a:	8526                	mv	a0,s1
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	49c080e7          	jalr	1180(ra) # 800023f8 <brelse>
  }

  if(off > ip->size)
    80002f64:	04caa783          	lw	a5,76(s5)
    80002f68:	0127f463          	bgeu	a5,s2,80002f70 <writei+0xe2>
    ip->size = off;
    80002f6c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f70:	8556                	mv	a0,s5
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	aa6080e7          	jalr	-1370(ra) # 80002a18 <iupdate>

  return tot;
    80002f7a:	0009851b          	sext.w	a0,s3
}
    80002f7e:	70a6                	ld	ra,104(sp)
    80002f80:	7406                	ld	s0,96(sp)
    80002f82:	64e6                	ld	s1,88(sp)
    80002f84:	6946                	ld	s2,80(sp)
    80002f86:	69a6                	ld	s3,72(sp)
    80002f88:	6a06                	ld	s4,64(sp)
    80002f8a:	7ae2                	ld	s5,56(sp)
    80002f8c:	7b42                	ld	s6,48(sp)
    80002f8e:	7ba2                	ld	s7,40(sp)
    80002f90:	7c02                	ld	s8,32(sp)
    80002f92:	6ce2                	ld	s9,24(sp)
    80002f94:	6d42                	ld	s10,16(sp)
    80002f96:	6da2                	ld	s11,8(sp)
    80002f98:	6165                	addi	sp,sp,112
    80002f9a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f9c:	89da                	mv	s3,s6
    80002f9e:	bfc9                	j	80002f70 <writei+0xe2>
    return -1;
    80002fa0:	557d                	li	a0,-1
}
    80002fa2:	8082                	ret
    return -1;
    80002fa4:	557d                	li	a0,-1
    80002fa6:	bfe1                	j	80002f7e <writei+0xf0>
    return -1;
    80002fa8:	557d                	li	a0,-1
    80002faa:	bfd1                	j	80002f7e <writei+0xf0>

0000000080002fac <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fac:	1141                	addi	sp,sp,-16
    80002fae:	e406                	sd	ra,8(sp)
    80002fb0:	e022                	sd	s0,0(sp)
    80002fb2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fb4:	4639                	li	a2,14
    80002fb6:	ffffd097          	auipc	ra,0xffffd
    80002fba:	29a080e7          	jalr	666(ra) # 80000250 <strncmp>
}
    80002fbe:	60a2                	ld	ra,8(sp)
    80002fc0:	6402                	ld	s0,0(sp)
    80002fc2:	0141                	addi	sp,sp,16
    80002fc4:	8082                	ret

0000000080002fc6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fc6:	7139                	addi	sp,sp,-64
    80002fc8:	fc06                	sd	ra,56(sp)
    80002fca:	f822                	sd	s0,48(sp)
    80002fcc:	f426                	sd	s1,40(sp)
    80002fce:	f04a                	sd	s2,32(sp)
    80002fd0:	ec4e                	sd	s3,24(sp)
    80002fd2:	e852                	sd	s4,16(sp)
    80002fd4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fd6:	04451703          	lh	a4,68(a0)
    80002fda:	4785                	li	a5,1
    80002fdc:	00f71a63          	bne	a4,a5,80002ff0 <dirlookup+0x2a>
    80002fe0:	892a                	mv	s2,a0
    80002fe2:	89ae                	mv	s3,a1
    80002fe4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe6:	457c                	lw	a5,76(a0)
    80002fe8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fea:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fec:	e79d                	bnez	a5,8000301a <dirlookup+0x54>
    80002fee:	a8a5                	j	80003066 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ff0:	00005517          	auipc	a0,0x5
    80002ff4:	58050513          	addi	a0,a0,1408 # 80008570 <syscalls+0x1a0>
    80002ff8:	00003097          	auipc	ra,0x3
    80002ffc:	bea080e7          	jalr	-1046(ra) # 80005be2 <panic>
      panic("dirlookup read");
    80003000:	00005517          	auipc	a0,0x5
    80003004:	58850513          	addi	a0,a0,1416 # 80008588 <syscalls+0x1b8>
    80003008:	00003097          	auipc	ra,0x3
    8000300c:	bda080e7          	jalr	-1062(ra) # 80005be2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003010:	24c1                	addiw	s1,s1,16
    80003012:	04c92783          	lw	a5,76(s2)
    80003016:	04f4f763          	bgeu	s1,a5,80003064 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000301a:	4741                	li	a4,16
    8000301c:	86a6                	mv	a3,s1
    8000301e:	fc040613          	addi	a2,s0,-64
    80003022:	4581                	li	a1,0
    80003024:	854a                	mv	a0,s2
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	d70080e7          	jalr	-656(ra) # 80002d96 <readi>
    8000302e:	47c1                	li	a5,16
    80003030:	fcf518e3          	bne	a0,a5,80003000 <dirlookup+0x3a>
    if(de.inum == 0)
    80003034:	fc045783          	lhu	a5,-64(s0)
    80003038:	dfe1                	beqz	a5,80003010 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000303a:	fc240593          	addi	a1,s0,-62
    8000303e:	854e                	mv	a0,s3
    80003040:	00000097          	auipc	ra,0x0
    80003044:	f6c080e7          	jalr	-148(ra) # 80002fac <namecmp>
    80003048:	f561                	bnez	a0,80003010 <dirlookup+0x4a>
      if(poff)
    8000304a:	000a0463          	beqz	s4,80003052 <dirlookup+0x8c>
        *poff = off;
    8000304e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003052:	fc045583          	lhu	a1,-64(s0)
    80003056:	00092503          	lw	a0,0(s2)
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	750080e7          	jalr	1872(ra) # 800027aa <iget>
    80003062:	a011                	j	80003066 <dirlookup+0xa0>
  return 0;
    80003064:	4501                	li	a0,0
}
    80003066:	70e2                	ld	ra,56(sp)
    80003068:	7442                	ld	s0,48(sp)
    8000306a:	74a2                	ld	s1,40(sp)
    8000306c:	7902                	ld	s2,32(sp)
    8000306e:	69e2                	ld	s3,24(sp)
    80003070:	6a42                	ld	s4,16(sp)
    80003072:	6121                	addi	sp,sp,64
    80003074:	8082                	ret

0000000080003076 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003076:	711d                	addi	sp,sp,-96
    80003078:	ec86                	sd	ra,88(sp)
    8000307a:	e8a2                	sd	s0,80(sp)
    8000307c:	e4a6                	sd	s1,72(sp)
    8000307e:	e0ca                	sd	s2,64(sp)
    80003080:	fc4e                	sd	s3,56(sp)
    80003082:	f852                	sd	s4,48(sp)
    80003084:	f456                	sd	s5,40(sp)
    80003086:	f05a                	sd	s6,32(sp)
    80003088:	ec5e                	sd	s7,24(sp)
    8000308a:	e862                	sd	s8,16(sp)
    8000308c:	e466                	sd	s9,8(sp)
    8000308e:	1080                	addi	s0,sp,96
    80003090:	84aa                	mv	s1,a0
    80003092:	8b2e                	mv	s6,a1
    80003094:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003096:	00054703          	lbu	a4,0(a0)
    8000309a:	02f00793          	li	a5,47
    8000309e:	02f70363          	beq	a4,a5,800030c4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	db6080e7          	jalr	-586(ra) # 80000e58 <myproc>
    800030aa:	15053503          	ld	a0,336(a0)
    800030ae:	00000097          	auipc	ra,0x0
    800030b2:	9f6080e7          	jalr	-1546(ra) # 80002aa4 <idup>
    800030b6:	89aa                	mv	s3,a0
  while(*path == '/')
    800030b8:	02f00913          	li	s2,47
  len = path - s;
    800030bc:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800030be:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030c0:	4c05                	li	s8,1
    800030c2:	a865                	j	8000317a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030c4:	4585                	li	a1,1
    800030c6:	4505                	li	a0,1
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	6e2080e7          	jalr	1762(ra) # 800027aa <iget>
    800030d0:	89aa                	mv	s3,a0
    800030d2:	b7dd                	j	800030b8 <namex+0x42>
      iunlockput(ip);
    800030d4:	854e                	mv	a0,s3
    800030d6:	00000097          	auipc	ra,0x0
    800030da:	c6e080e7          	jalr	-914(ra) # 80002d44 <iunlockput>
      return 0;
    800030de:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030e0:	854e                	mv	a0,s3
    800030e2:	60e6                	ld	ra,88(sp)
    800030e4:	6446                	ld	s0,80(sp)
    800030e6:	64a6                	ld	s1,72(sp)
    800030e8:	6906                	ld	s2,64(sp)
    800030ea:	79e2                	ld	s3,56(sp)
    800030ec:	7a42                	ld	s4,48(sp)
    800030ee:	7aa2                	ld	s5,40(sp)
    800030f0:	7b02                	ld	s6,32(sp)
    800030f2:	6be2                	ld	s7,24(sp)
    800030f4:	6c42                	ld	s8,16(sp)
    800030f6:	6ca2                	ld	s9,8(sp)
    800030f8:	6125                	addi	sp,sp,96
    800030fa:	8082                	ret
      iunlock(ip);
    800030fc:	854e                	mv	a0,s3
    800030fe:	00000097          	auipc	ra,0x0
    80003102:	aa6080e7          	jalr	-1370(ra) # 80002ba4 <iunlock>
      return ip;
    80003106:	bfe9                	j	800030e0 <namex+0x6a>
      iunlockput(ip);
    80003108:	854e                	mv	a0,s3
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	c3a080e7          	jalr	-966(ra) # 80002d44 <iunlockput>
      return 0;
    80003112:	89d2                	mv	s3,s4
    80003114:	b7f1                	j	800030e0 <namex+0x6a>
  len = path - s;
    80003116:	40b48633          	sub	a2,s1,a1
    8000311a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000311e:	094cd463          	bge	s9,s4,800031a6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003122:	4639                	li	a2,14
    80003124:	8556                	mv	a0,s5
    80003126:	ffffd097          	auipc	ra,0xffffd
    8000312a:	0b2080e7          	jalr	178(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000312e:	0004c783          	lbu	a5,0(s1)
    80003132:	01279763          	bne	a5,s2,80003140 <namex+0xca>
    path++;
    80003136:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003138:	0004c783          	lbu	a5,0(s1)
    8000313c:	ff278de3          	beq	a5,s2,80003136 <namex+0xc0>
    ilock(ip);
    80003140:	854e                	mv	a0,s3
    80003142:	00000097          	auipc	ra,0x0
    80003146:	9a0080e7          	jalr	-1632(ra) # 80002ae2 <ilock>
    if(ip->type != T_DIR){
    8000314a:	04499783          	lh	a5,68(s3)
    8000314e:	f98793e3          	bne	a5,s8,800030d4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003152:	000b0563          	beqz	s6,8000315c <namex+0xe6>
    80003156:	0004c783          	lbu	a5,0(s1)
    8000315a:	d3cd                	beqz	a5,800030fc <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000315c:	865e                	mv	a2,s7
    8000315e:	85d6                	mv	a1,s5
    80003160:	854e                	mv	a0,s3
    80003162:	00000097          	auipc	ra,0x0
    80003166:	e64080e7          	jalr	-412(ra) # 80002fc6 <dirlookup>
    8000316a:	8a2a                	mv	s4,a0
    8000316c:	dd51                	beqz	a0,80003108 <namex+0x92>
    iunlockput(ip);
    8000316e:	854e                	mv	a0,s3
    80003170:	00000097          	auipc	ra,0x0
    80003174:	bd4080e7          	jalr	-1068(ra) # 80002d44 <iunlockput>
    ip = next;
    80003178:	89d2                	mv	s3,s4
  while(*path == '/')
    8000317a:	0004c783          	lbu	a5,0(s1)
    8000317e:	05279763          	bne	a5,s2,800031cc <namex+0x156>
    path++;
    80003182:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003184:	0004c783          	lbu	a5,0(s1)
    80003188:	ff278de3          	beq	a5,s2,80003182 <namex+0x10c>
  if(*path == 0)
    8000318c:	c79d                	beqz	a5,800031ba <namex+0x144>
    path++;
    8000318e:	85a6                	mv	a1,s1
  len = path - s;
    80003190:	8a5e                	mv	s4,s7
    80003192:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003194:	01278963          	beq	a5,s2,800031a6 <namex+0x130>
    80003198:	dfbd                	beqz	a5,80003116 <namex+0xa0>
    path++;
    8000319a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000319c:	0004c783          	lbu	a5,0(s1)
    800031a0:	ff279ce3          	bne	a5,s2,80003198 <namex+0x122>
    800031a4:	bf8d                	j	80003116 <namex+0xa0>
    memmove(name, s, len);
    800031a6:	2601                	sext.w	a2,a2
    800031a8:	8556                	mv	a0,s5
    800031aa:	ffffd097          	auipc	ra,0xffffd
    800031ae:	02e080e7          	jalr	46(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031b2:	9a56                	add	s4,s4,s5
    800031b4:	000a0023          	sb	zero,0(s4)
    800031b8:	bf9d                	j	8000312e <namex+0xb8>
  if(nameiparent){
    800031ba:	f20b03e3          	beqz	s6,800030e0 <namex+0x6a>
    iput(ip);
    800031be:	854e                	mv	a0,s3
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	adc080e7          	jalr	-1316(ra) # 80002c9c <iput>
    return 0;
    800031c8:	4981                	li	s3,0
    800031ca:	bf19                	j	800030e0 <namex+0x6a>
  if(*path == 0)
    800031cc:	d7fd                	beqz	a5,800031ba <namex+0x144>
  while(*path != '/' && *path != 0)
    800031ce:	0004c783          	lbu	a5,0(s1)
    800031d2:	85a6                	mv	a1,s1
    800031d4:	b7d1                	j	80003198 <namex+0x122>

00000000800031d6 <dirlink>:
{
    800031d6:	7139                	addi	sp,sp,-64
    800031d8:	fc06                	sd	ra,56(sp)
    800031da:	f822                	sd	s0,48(sp)
    800031dc:	f426                	sd	s1,40(sp)
    800031de:	f04a                	sd	s2,32(sp)
    800031e0:	ec4e                	sd	s3,24(sp)
    800031e2:	e852                	sd	s4,16(sp)
    800031e4:	0080                	addi	s0,sp,64
    800031e6:	892a                	mv	s2,a0
    800031e8:	8a2e                	mv	s4,a1
    800031ea:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031ec:	4601                	li	a2,0
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	dd8080e7          	jalr	-552(ra) # 80002fc6 <dirlookup>
    800031f6:	e93d                	bnez	a0,8000326c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f8:	04c92483          	lw	s1,76(s2)
    800031fc:	c49d                	beqz	s1,8000322a <dirlink+0x54>
    800031fe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003200:	4741                	li	a4,16
    80003202:	86a6                	mv	a3,s1
    80003204:	fc040613          	addi	a2,s0,-64
    80003208:	4581                	li	a1,0
    8000320a:	854a                	mv	a0,s2
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	b8a080e7          	jalr	-1142(ra) # 80002d96 <readi>
    80003214:	47c1                	li	a5,16
    80003216:	06f51163          	bne	a0,a5,80003278 <dirlink+0xa2>
    if(de.inum == 0)
    8000321a:	fc045783          	lhu	a5,-64(s0)
    8000321e:	c791                	beqz	a5,8000322a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003220:	24c1                	addiw	s1,s1,16
    80003222:	04c92783          	lw	a5,76(s2)
    80003226:	fcf4ede3          	bltu	s1,a5,80003200 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000322a:	4639                	li	a2,14
    8000322c:	85d2                	mv	a1,s4
    8000322e:	fc240513          	addi	a0,s0,-62
    80003232:	ffffd097          	auipc	ra,0xffffd
    80003236:	05a080e7          	jalr	90(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000323a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000323e:	4741                	li	a4,16
    80003240:	86a6                	mv	a3,s1
    80003242:	fc040613          	addi	a2,s0,-64
    80003246:	4581                	li	a1,0
    80003248:	854a                	mv	a0,s2
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	c44080e7          	jalr	-956(ra) # 80002e8e <writei>
    80003252:	1541                	addi	a0,a0,-16
    80003254:	00a03533          	snez	a0,a0
    80003258:	40a00533          	neg	a0,a0
}
    8000325c:	70e2                	ld	ra,56(sp)
    8000325e:	7442                	ld	s0,48(sp)
    80003260:	74a2                	ld	s1,40(sp)
    80003262:	7902                	ld	s2,32(sp)
    80003264:	69e2                	ld	s3,24(sp)
    80003266:	6a42                	ld	s4,16(sp)
    80003268:	6121                	addi	sp,sp,64
    8000326a:	8082                	ret
    iput(ip);
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	a30080e7          	jalr	-1488(ra) # 80002c9c <iput>
    return -1;
    80003274:	557d                	li	a0,-1
    80003276:	b7dd                	j	8000325c <dirlink+0x86>
      panic("dirlink read");
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	32050513          	addi	a0,a0,800 # 80008598 <syscalls+0x1c8>
    80003280:	00003097          	auipc	ra,0x3
    80003284:	962080e7          	jalr	-1694(ra) # 80005be2 <panic>

0000000080003288 <namei>:

struct inode*
namei(char *path)
{
    80003288:	1101                	addi	sp,sp,-32
    8000328a:	ec06                	sd	ra,24(sp)
    8000328c:	e822                	sd	s0,16(sp)
    8000328e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003290:	fe040613          	addi	a2,s0,-32
    80003294:	4581                	li	a1,0
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	de0080e7          	jalr	-544(ra) # 80003076 <namex>
}
    8000329e:	60e2                	ld	ra,24(sp)
    800032a0:	6442                	ld	s0,16(sp)
    800032a2:	6105                	addi	sp,sp,32
    800032a4:	8082                	ret

00000000800032a6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032a6:	1141                	addi	sp,sp,-16
    800032a8:	e406                	sd	ra,8(sp)
    800032aa:	e022                	sd	s0,0(sp)
    800032ac:	0800                	addi	s0,sp,16
    800032ae:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032b0:	4585                	li	a1,1
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	dc4080e7          	jalr	-572(ra) # 80003076 <namex>
}
    800032ba:	60a2                	ld	ra,8(sp)
    800032bc:	6402                	ld	s0,0(sp)
    800032be:	0141                	addi	sp,sp,16
    800032c0:	8082                	ret

00000000800032c2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032c2:	1101                	addi	sp,sp,-32
    800032c4:	ec06                	sd	ra,24(sp)
    800032c6:	e822                	sd	s0,16(sp)
    800032c8:	e426                	sd	s1,8(sp)
    800032ca:	e04a                	sd	s2,0(sp)
    800032cc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032ce:	00015917          	auipc	s2,0x15
    800032d2:	5e290913          	addi	s2,s2,1506 # 800188b0 <log>
    800032d6:	01892583          	lw	a1,24(s2)
    800032da:	02892503          	lw	a0,40(s2)
    800032de:	fffff097          	auipc	ra,0xfffff
    800032e2:	fea080e7          	jalr	-22(ra) # 800022c8 <bread>
    800032e6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032e8:	02c92683          	lw	a3,44(s2)
    800032ec:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032ee:	02d05763          	blez	a3,8000331c <write_head+0x5a>
    800032f2:	00015797          	auipc	a5,0x15
    800032f6:	5ee78793          	addi	a5,a5,1518 # 800188e0 <log+0x30>
    800032fa:	05c50713          	addi	a4,a0,92
    800032fe:	36fd                	addiw	a3,a3,-1
    80003300:	1682                	slli	a3,a3,0x20
    80003302:	9281                	srli	a3,a3,0x20
    80003304:	068a                	slli	a3,a3,0x2
    80003306:	00015617          	auipc	a2,0x15
    8000330a:	5de60613          	addi	a2,a2,1502 # 800188e4 <log+0x34>
    8000330e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003310:	4390                	lw	a2,0(a5)
    80003312:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003314:	0791                	addi	a5,a5,4
    80003316:	0711                	addi	a4,a4,4
    80003318:	fed79ce3          	bne	a5,a3,80003310 <write_head+0x4e>
  }
  bwrite(buf);
    8000331c:	8526                	mv	a0,s1
    8000331e:	fffff097          	auipc	ra,0xfffff
    80003322:	09c080e7          	jalr	156(ra) # 800023ba <bwrite>
  brelse(buf);
    80003326:	8526                	mv	a0,s1
    80003328:	fffff097          	auipc	ra,0xfffff
    8000332c:	0d0080e7          	jalr	208(ra) # 800023f8 <brelse>
}
    80003330:	60e2                	ld	ra,24(sp)
    80003332:	6442                	ld	s0,16(sp)
    80003334:	64a2                	ld	s1,8(sp)
    80003336:	6902                	ld	s2,0(sp)
    80003338:	6105                	addi	sp,sp,32
    8000333a:	8082                	ret

000000008000333c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000333c:	00015797          	auipc	a5,0x15
    80003340:	5a07a783          	lw	a5,1440(a5) # 800188dc <log+0x2c>
    80003344:	0af05d63          	blez	a5,800033fe <install_trans+0xc2>
{
    80003348:	7139                	addi	sp,sp,-64
    8000334a:	fc06                	sd	ra,56(sp)
    8000334c:	f822                	sd	s0,48(sp)
    8000334e:	f426                	sd	s1,40(sp)
    80003350:	f04a                	sd	s2,32(sp)
    80003352:	ec4e                	sd	s3,24(sp)
    80003354:	e852                	sd	s4,16(sp)
    80003356:	e456                	sd	s5,8(sp)
    80003358:	e05a                	sd	s6,0(sp)
    8000335a:	0080                	addi	s0,sp,64
    8000335c:	8b2a                	mv	s6,a0
    8000335e:	00015a97          	auipc	s5,0x15
    80003362:	582a8a93          	addi	s5,s5,1410 # 800188e0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003366:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003368:	00015997          	auipc	s3,0x15
    8000336c:	54898993          	addi	s3,s3,1352 # 800188b0 <log>
    80003370:	a035                	j	8000339c <install_trans+0x60>
      bunpin(dbuf);
    80003372:	8526                	mv	a0,s1
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	15e080e7          	jalr	350(ra) # 800024d2 <bunpin>
    brelse(lbuf);
    8000337c:	854a                	mv	a0,s2
    8000337e:	fffff097          	auipc	ra,0xfffff
    80003382:	07a080e7          	jalr	122(ra) # 800023f8 <brelse>
    brelse(dbuf);
    80003386:	8526                	mv	a0,s1
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	070080e7          	jalr	112(ra) # 800023f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003390:	2a05                	addiw	s4,s4,1
    80003392:	0a91                	addi	s5,s5,4
    80003394:	02c9a783          	lw	a5,44(s3)
    80003398:	04fa5963          	bge	s4,a5,800033ea <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000339c:	0189a583          	lw	a1,24(s3)
    800033a0:	014585bb          	addw	a1,a1,s4
    800033a4:	2585                	addiw	a1,a1,1
    800033a6:	0289a503          	lw	a0,40(s3)
    800033aa:	fffff097          	auipc	ra,0xfffff
    800033ae:	f1e080e7          	jalr	-226(ra) # 800022c8 <bread>
    800033b2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033b4:	000aa583          	lw	a1,0(s5)
    800033b8:	0289a503          	lw	a0,40(s3)
    800033bc:	fffff097          	auipc	ra,0xfffff
    800033c0:	f0c080e7          	jalr	-244(ra) # 800022c8 <bread>
    800033c4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033c6:	40000613          	li	a2,1024
    800033ca:	05890593          	addi	a1,s2,88
    800033ce:	05850513          	addi	a0,a0,88
    800033d2:	ffffd097          	auipc	ra,0xffffd
    800033d6:	e06080e7          	jalr	-506(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033da:	8526                	mv	a0,s1
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	fde080e7          	jalr	-34(ra) # 800023ba <bwrite>
    if(recovering == 0)
    800033e4:	f80b1ce3          	bnez	s6,8000337c <install_trans+0x40>
    800033e8:	b769                	j	80003372 <install_trans+0x36>
}
    800033ea:	70e2                	ld	ra,56(sp)
    800033ec:	7442                	ld	s0,48(sp)
    800033ee:	74a2                	ld	s1,40(sp)
    800033f0:	7902                	ld	s2,32(sp)
    800033f2:	69e2                	ld	s3,24(sp)
    800033f4:	6a42                	ld	s4,16(sp)
    800033f6:	6aa2                	ld	s5,8(sp)
    800033f8:	6b02                	ld	s6,0(sp)
    800033fa:	6121                	addi	sp,sp,64
    800033fc:	8082                	ret
    800033fe:	8082                	ret

0000000080003400 <initlog>:
{
    80003400:	7179                	addi	sp,sp,-48
    80003402:	f406                	sd	ra,40(sp)
    80003404:	f022                	sd	s0,32(sp)
    80003406:	ec26                	sd	s1,24(sp)
    80003408:	e84a                	sd	s2,16(sp)
    8000340a:	e44e                	sd	s3,8(sp)
    8000340c:	1800                	addi	s0,sp,48
    8000340e:	892a                	mv	s2,a0
    80003410:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003412:	00015497          	auipc	s1,0x15
    80003416:	49e48493          	addi	s1,s1,1182 # 800188b0 <log>
    8000341a:	00005597          	auipc	a1,0x5
    8000341e:	18e58593          	addi	a1,a1,398 # 800085a8 <syscalls+0x1d8>
    80003422:	8526                	mv	a0,s1
    80003424:	00003097          	auipc	ra,0x3
    80003428:	c78080e7          	jalr	-904(ra) # 8000609c <initlock>
  log.start = sb->logstart;
    8000342c:	0149a583          	lw	a1,20(s3)
    80003430:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003432:	0109a783          	lw	a5,16(s3)
    80003436:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003438:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000343c:	854a                	mv	a0,s2
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	e8a080e7          	jalr	-374(ra) # 800022c8 <bread>
  log.lh.n = lh->n;
    80003446:	4d3c                	lw	a5,88(a0)
    80003448:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000344a:	02f05563          	blez	a5,80003474 <initlog+0x74>
    8000344e:	05c50713          	addi	a4,a0,92
    80003452:	00015697          	auipc	a3,0x15
    80003456:	48e68693          	addi	a3,a3,1166 # 800188e0 <log+0x30>
    8000345a:	37fd                	addiw	a5,a5,-1
    8000345c:	1782                	slli	a5,a5,0x20
    8000345e:	9381                	srli	a5,a5,0x20
    80003460:	078a                	slli	a5,a5,0x2
    80003462:	06050613          	addi	a2,a0,96
    80003466:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003468:	4310                	lw	a2,0(a4)
    8000346a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000346c:	0711                	addi	a4,a4,4
    8000346e:	0691                	addi	a3,a3,4
    80003470:	fef71ce3          	bne	a4,a5,80003468 <initlog+0x68>
  brelse(buf);
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	f84080e7          	jalr	-124(ra) # 800023f8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000347c:	4505                	li	a0,1
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	ebe080e7          	jalr	-322(ra) # 8000333c <install_trans>
  log.lh.n = 0;
    80003486:	00015797          	auipc	a5,0x15
    8000348a:	4407ab23          	sw	zero,1110(a5) # 800188dc <log+0x2c>
  write_head(); // clear the log
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	e34080e7          	jalr	-460(ra) # 800032c2 <write_head>
}
    80003496:	70a2                	ld	ra,40(sp)
    80003498:	7402                	ld	s0,32(sp)
    8000349a:	64e2                	ld	s1,24(sp)
    8000349c:	6942                	ld	s2,16(sp)
    8000349e:	69a2                	ld	s3,8(sp)
    800034a0:	6145                	addi	sp,sp,48
    800034a2:	8082                	ret

00000000800034a4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034a4:	1101                	addi	sp,sp,-32
    800034a6:	ec06                	sd	ra,24(sp)
    800034a8:	e822                	sd	s0,16(sp)
    800034aa:	e426                	sd	s1,8(sp)
    800034ac:	e04a                	sd	s2,0(sp)
    800034ae:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034b0:	00015517          	auipc	a0,0x15
    800034b4:	40050513          	addi	a0,a0,1024 # 800188b0 <log>
    800034b8:	00003097          	auipc	ra,0x3
    800034bc:	c74080e7          	jalr	-908(ra) # 8000612c <acquire>
  while(1){
    if(log.committing){
    800034c0:	00015497          	auipc	s1,0x15
    800034c4:	3f048493          	addi	s1,s1,1008 # 800188b0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034c8:	4979                	li	s2,30
    800034ca:	a039                	j	800034d8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034cc:	85a6                	mv	a1,s1
    800034ce:	8526                	mv	a0,s1
    800034d0:	ffffe097          	auipc	ra,0xffffe
    800034d4:	02c080e7          	jalr	44(ra) # 800014fc <sleep>
    if(log.committing){
    800034d8:	50dc                	lw	a5,36(s1)
    800034da:	fbed                	bnez	a5,800034cc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034dc:	509c                	lw	a5,32(s1)
    800034de:	0017871b          	addiw	a4,a5,1
    800034e2:	0007069b          	sext.w	a3,a4
    800034e6:	0027179b          	slliw	a5,a4,0x2
    800034ea:	9fb9                	addw	a5,a5,a4
    800034ec:	0017979b          	slliw	a5,a5,0x1
    800034f0:	54d8                	lw	a4,44(s1)
    800034f2:	9fb9                	addw	a5,a5,a4
    800034f4:	00f95963          	bge	s2,a5,80003506 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034f8:	85a6                	mv	a1,s1
    800034fa:	8526                	mv	a0,s1
    800034fc:	ffffe097          	auipc	ra,0xffffe
    80003500:	000080e7          	jalr	ra # 800014fc <sleep>
    80003504:	bfd1                	j	800034d8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003506:	00015517          	auipc	a0,0x15
    8000350a:	3aa50513          	addi	a0,a0,938 # 800188b0 <log>
    8000350e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003510:	00003097          	auipc	ra,0x3
    80003514:	cd0080e7          	jalr	-816(ra) # 800061e0 <release>
      break;
    }
  }
}
    80003518:	60e2                	ld	ra,24(sp)
    8000351a:	6442                	ld	s0,16(sp)
    8000351c:	64a2                	ld	s1,8(sp)
    8000351e:	6902                	ld	s2,0(sp)
    80003520:	6105                	addi	sp,sp,32
    80003522:	8082                	ret

0000000080003524 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003524:	7139                	addi	sp,sp,-64
    80003526:	fc06                	sd	ra,56(sp)
    80003528:	f822                	sd	s0,48(sp)
    8000352a:	f426                	sd	s1,40(sp)
    8000352c:	f04a                	sd	s2,32(sp)
    8000352e:	ec4e                	sd	s3,24(sp)
    80003530:	e852                	sd	s4,16(sp)
    80003532:	e456                	sd	s5,8(sp)
    80003534:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003536:	00015497          	auipc	s1,0x15
    8000353a:	37a48493          	addi	s1,s1,890 # 800188b0 <log>
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	bec080e7          	jalr	-1044(ra) # 8000612c <acquire>
  log.outstanding -= 1;
    80003548:	509c                	lw	a5,32(s1)
    8000354a:	37fd                	addiw	a5,a5,-1
    8000354c:	0007891b          	sext.w	s2,a5
    80003550:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003552:	50dc                	lw	a5,36(s1)
    80003554:	efb9                	bnez	a5,800035b2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003556:	06091663          	bnez	s2,800035c2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000355a:	00015497          	auipc	s1,0x15
    8000355e:	35648493          	addi	s1,s1,854 # 800188b0 <log>
    80003562:	4785                	li	a5,1
    80003564:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003566:	8526                	mv	a0,s1
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	c78080e7          	jalr	-904(ra) # 800061e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003570:	54dc                	lw	a5,44(s1)
    80003572:	06f04763          	bgtz	a5,800035e0 <end_op+0xbc>
    acquire(&log.lock);
    80003576:	00015497          	auipc	s1,0x15
    8000357a:	33a48493          	addi	s1,s1,826 # 800188b0 <log>
    8000357e:	8526                	mv	a0,s1
    80003580:	00003097          	auipc	ra,0x3
    80003584:	bac080e7          	jalr	-1108(ra) # 8000612c <acquire>
    log.committing = 0;
    80003588:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000358c:	8526                	mv	a0,s1
    8000358e:	ffffe097          	auipc	ra,0xffffe
    80003592:	fd2080e7          	jalr	-46(ra) # 80001560 <wakeup>
    release(&log.lock);
    80003596:	8526                	mv	a0,s1
    80003598:	00003097          	auipc	ra,0x3
    8000359c:	c48080e7          	jalr	-952(ra) # 800061e0 <release>
}
    800035a0:	70e2                	ld	ra,56(sp)
    800035a2:	7442                	ld	s0,48(sp)
    800035a4:	74a2                	ld	s1,40(sp)
    800035a6:	7902                	ld	s2,32(sp)
    800035a8:	69e2                	ld	s3,24(sp)
    800035aa:	6a42                	ld	s4,16(sp)
    800035ac:	6aa2                	ld	s5,8(sp)
    800035ae:	6121                	addi	sp,sp,64
    800035b0:	8082                	ret
    panic("log.committing");
    800035b2:	00005517          	auipc	a0,0x5
    800035b6:	ffe50513          	addi	a0,a0,-2 # 800085b0 <syscalls+0x1e0>
    800035ba:	00002097          	auipc	ra,0x2
    800035be:	628080e7          	jalr	1576(ra) # 80005be2 <panic>
    wakeup(&log);
    800035c2:	00015497          	auipc	s1,0x15
    800035c6:	2ee48493          	addi	s1,s1,750 # 800188b0 <log>
    800035ca:	8526                	mv	a0,s1
    800035cc:	ffffe097          	auipc	ra,0xffffe
    800035d0:	f94080e7          	jalr	-108(ra) # 80001560 <wakeup>
  release(&log.lock);
    800035d4:	8526                	mv	a0,s1
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	c0a080e7          	jalr	-1014(ra) # 800061e0 <release>
  if(do_commit){
    800035de:	b7c9                	j	800035a0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e0:	00015a97          	auipc	s5,0x15
    800035e4:	300a8a93          	addi	s5,s5,768 # 800188e0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035e8:	00015a17          	auipc	s4,0x15
    800035ec:	2c8a0a13          	addi	s4,s4,712 # 800188b0 <log>
    800035f0:	018a2583          	lw	a1,24(s4)
    800035f4:	012585bb          	addw	a1,a1,s2
    800035f8:	2585                	addiw	a1,a1,1
    800035fa:	028a2503          	lw	a0,40(s4)
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	cca080e7          	jalr	-822(ra) # 800022c8 <bread>
    80003606:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003608:	000aa583          	lw	a1,0(s5)
    8000360c:	028a2503          	lw	a0,40(s4)
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	cb8080e7          	jalr	-840(ra) # 800022c8 <bread>
    80003618:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000361a:	40000613          	li	a2,1024
    8000361e:	05850593          	addi	a1,a0,88
    80003622:	05848513          	addi	a0,s1,88
    80003626:	ffffd097          	auipc	ra,0xffffd
    8000362a:	bb2080e7          	jalr	-1102(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000362e:	8526                	mv	a0,s1
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	d8a080e7          	jalr	-630(ra) # 800023ba <bwrite>
    brelse(from);
    80003638:	854e                	mv	a0,s3
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	dbe080e7          	jalr	-578(ra) # 800023f8 <brelse>
    brelse(to);
    80003642:	8526                	mv	a0,s1
    80003644:	fffff097          	auipc	ra,0xfffff
    80003648:	db4080e7          	jalr	-588(ra) # 800023f8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000364c:	2905                	addiw	s2,s2,1
    8000364e:	0a91                	addi	s5,s5,4
    80003650:	02ca2783          	lw	a5,44(s4)
    80003654:	f8f94ee3          	blt	s2,a5,800035f0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	c6a080e7          	jalr	-918(ra) # 800032c2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003660:	4501                	li	a0,0
    80003662:	00000097          	auipc	ra,0x0
    80003666:	cda080e7          	jalr	-806(ra) # 8000333c <install_trans>
    log.lh.n = 0;
    8000366a:	00015797          	auipc	a5,0x15
    8000366e:	2607a923          	sw	zero,626(a5) # 800188dc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003672:	00000097          	auipc	ra,0x0
    80003676:	c50080e7          	jalr	-944(ra) # 800032c2 <write_head>
    8000367a:	bdf5                	j	80003576 <end_op+0x52>

000000008000367c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000367c:	1101                	addi	sp,sp,-32
    8000367e:	ec06                	sd	ra,24(sp)
    80003680:	e822                	sd	s0,16(sp)
    80003682:	e426                	sd	s1,8(sp)
    80003684:	e04a                	sd	s2,0(sp)
    80003686:	1000                	addi	s0,sp,32
    80003688:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000368a:	00015917          	auipc	s2,0x15
    8000368e:	22690913          	addi	s2,s2,550 # 800188b0 <log>
    80003692:	854a                	mv	a0,s2
    80003694:	00003097          	auipc	ra,0x3
    80003698:	a98080e7          	jalr	-1384(ra) # 8000612c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000369c:	02c92603          	lw	a2,44(s2)
    800036a0:	47f5                	li	a5,29
    800036a2:	06c7c563          	blt	a5,a2,8000370c <log_write+0x90>
    800036a6:	00015797          	auipc	a5,0x15
    800036aa:	2267a783          	lw	a5,550(a5) # 800188cc <log+0x1c>
    800036ae:	37fd                	addiw	a5,a5,-1
    800036b0:	04f65e63          	bge	a2,a5,8000370c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036b4:	00015797          	auipc	a5,0x15
    800036b8:	21c7a783          	lw	a5,540(a5) # 800188d0 <log+0x20>
    800036bc:	06f05063          	blez	a5,8000371c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036c0:	4781                	li	a5,0
    800036c2:	06c05563          	blez	a2,8000372c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036c6:	44cc                	lw	a1,12(s1)
    800036c8:	00015717          	auipc	a4,0x15
    800036cc:	21870713          	addi	a4,a4,536 # 800188e0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036d0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d2:	4314                	lw	a3,0(a4)
    800036d4:	04b68c63          	beq	a3,a1,8000372c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036d8:	2785                	addiw	a5,a5,1
    800036da:	0711                	addi	a4,a4,4
    800036dc:	fef61be3          	bne	a2,a5,800036d2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036e0:	0621                	addi	a2,a2,8
    800036e2:	060a                	slli	a2,a2,0x2
    800036e4:	00015797          	auipc	a5,0x15
    800036e8:	1cc78793          	addi	a5,a5,460 # 800188b0 <log>
    800036ec:	963e                	add	a2,a2,a5
    800036ee:	44dc                	lw	a5,12(s1)
    800036f0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036f2:	8526                	mv	a0,s1
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	da2080e7          	jalr	-606(ra) # 80002496 <bpin>
    log.lh.n++;
    800036fc:	00015717          	auipc	a4,0x15
    80003700:	1b470713          	addi	a4,a4,436 # 800188b0 <log>
    80003704:	575c                	lw	a5,44(a4)
    80003706:	2785                	addiw	a5,a5,1
    80003708:	d75c                	sw	a5,44(a4)
    8000370a:	a835                	j	80003746 <log_write+0xca>
    panic("too big a transaction");
    8000370c:	00005517          	auipc	a0,0x5
    80003710:	eb450513          	addi	a0,a0,-332 # 800085c0 <syscalls+0x1f0>
    80003714:	00002097          	auipc	ra,0x2
    80003718:	4ce080e7          	jalr	1230(ra) # 80005be2 <panic>
    panic("log_write outside of trans");
    8000371c:	00005517          	auipc	a0,0x5
    80003720:	ebc50513          	addi	a0,a0,-324 # 800085d8 <syscalls+0x208>
    80003724:	00002097          	auipc	ra,0x2
    80003728:	4be080e7          	jalr	1214(ra) # 80005be2 <panic>
  log.lh.block[i] = b->blockno;
    8000372c:	00878713          	addi	a4,a5,8
    80003730:	00271693          	slli	a3,a4,0x2
    80003734:	00015717          	auipc	a4,0x15
    80003738:	17c70713          	addi	a4,a4,380 # 800188b0 <log>
    8000373c:	9736                	add	a4,a4,a3
    8000373e:	44d4                	lw	a3,12(s1)
    80003740:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003742:	faf608e3          	beq	a2,a5,800036f2 <log_write+0x76>
  }
  release(&log.lock);
    80003746:	00015517          	auipc	a0,0x15
    8000374a:	16a50513          	addi	a0,a0,362 # 800188b0 <log>
    8000374e:	00003097          	auipc	ra,0x3
    80003752:	a92080e7          	jalr	-1390(ra) # 800061e0 <release>
}
    80003756:	60e2                	ld	ra,24(sp)
    80003758:	6442                	ld	s0,16(sp)
    8000375a:	64a2                	ld	s1,8(sp)
    8000375c:	6902                	ld	s2,0(sp)
    8000375e:	6105                	addi	sp,sp,32
    80003760:	8082                	ret

0000000080003762 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003762:	1101                	addi	sp,sp,-32
    80003764:	ec06                	sd	ra,24(sp)
    80003766:	e822                	sd	s0,16(sp)
    80003768:	e426                	sd	s1,8(sp)
    8000376a:	e04a                	sd	s2,0(sp)
    8000376c:	1000                	addi	s0,sp,32
    8000376e:	84aa                	mv	s1,a0
    80003770:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003772:	00005597          	auipc	a1,0x5
    80003776:	e8658593          	addi	a1,a1,-378 # 800085f8 <syscalls+0x228>
    8000377a:	0521                	addi	a0,a0,8
    8000377c:	00003097          	auipc	ra,0x3
    80003780:	920080e7          	jalr	-1760(ra) # 8000609c <initlock>
  lk->name = name;
    80003784:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003788:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000378c:	0204a423          	sw	zero,40(s1)
}
    80003790:	60e2                	ld	ra,24(sp)
    80003792:	6442                	ld	s0,16(sp)
    80003794:	64a2                	ld	s1,8(sp)
    80003796:	6902                	ld	s2,0(sp)
    80003798:	6105                	addi	sp,sp,32
    8000379a:	8082                	ret

000000008000379c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000379c:	1101                	addi	sp,sp,-32
    8000379e:	ec06                	sd	ra,24(sp)
    800037a0:	e822                	sd	s0,16(sp)
    800037a2:	e426                	sd	s1,8(sp)
    800037a4:	e04a                	sd	s2,0(sp)
    800037a6:	1000                	addi	s0,sp,32
    800037a8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037aa:	00850913          	addi	s2,a0,8
    800037ae:	854a                	mv	a0,s2
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	97c080e7          	jalr	-1668(ra) # 8000612c <acquire>
  while (lk->locked) {
    800037b8:	409c                	lw	a5,0(s1)
    800037ba:	cb89                	beqz	a5,800037cc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037bc:	85ca                	mv	a1,s2
    800037be:	8526                	mv	a0,s1
    800037c0:	ffffe097          	auipc	ra,0xffffe
    800037c4:	d3c080e7          	jalr	-708(ra) # 800014fc <sleep>
  while (lk->locked) {
    800037c8:	409c                	lw	a5,0(s1)
    800037ca:	fbed                	bnez	a5,800037bc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037cc:	4785                	li	a5,1
    800037ce:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037d0:	ffffd097          	auipc	ra,0xffffd
    800037d4:	688080e7          	jalr	1672(ra) # 80000e58 <myproc>
    800037d8:	591c                	lw	a5,48(a0)
    800037da:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037dc:	854a                	mv	a0,s2
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	a02080e7          	jalr	-1534(ra) # 800061e0 <release>
}
    800037e6:	60e2                	ld	ra,24(sp)
    800037e8:	6442                	ld	s0,16(sp)
    800037ea:	64a2                	ld	s1,8(sp)
    800037ec:	6902                	ld	s2,0(sp)
    800037ee:	6105                	addi	sp,sp,32
    800037f0:	8082                	ret

00000000800037f2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037f2:	1101                	addi	sp,sp,-32
    800037f4:	ec06                	sd	ra,24(sp)
    800037f6:	e822                	sd	s0,16(sp)
    800037f8:	e426                	sd	s1,8(sp)
    800037fa:	e04a                	sd	s2,0(sp)
    800037fc:	1000                	addi	s0,sp,32
    800037fe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003800:	00850913          	addi	s2,a0,8
    80003804:	854a                	mv	a0,s2
    80003806:	00003097          	auipc	ra,0x3
    8000380a:	926080e7          	jalr	-1754(ra) # 8000612c <acquire>
  lk->locked = 0;
    8000380e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003812:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	d48080e7          	jalr	-696(ra) # 80001560 <wakeup>
  release(&lk->lk);
    80003820:	854a                	mv	a0,s2
    80003822:	00003097          	auipc	ra,0x3
    80003826:	9be080e7          	jalr	-1602(ra) # 800061e0 <release>
}
    8000382a:	60e2                	ld	ra,24(sp)
    8000382c:	6442                	ld	s0,16(sp)
    8000382e:	64a2                	ld	s1,8(sp)
    80003830:	6902                	ld	s2,0(sp)
    80003832:	6105                	addi	sp,sp,32
    80003834:	8082                	ret

0000000080003836 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003836:	7179                	addi	sp,sp,-48
    80003838:	f406                	sd	ra,40(sp)
    8000383a:	f022                	sd	s0,32(sp)
    8000383c:	ec26                	sd	s1,24(sp)
    8000383e:	e84a                	sd	s2,16(sp)
    80003840:	e44e                	sd	s3,8(sp)
    80003842:	1800                	addi	s0,sp,48
    80003844:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003846:	00850913          	addi	s2,a0,8
    8000384a:	854a                	mv	a0,s2
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	8e0080e7          	jalr	-1824(ra) # 8000612c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003854:	409c                	lw	a5,0(s1)
    80003856:	ef99                	bnez	a5,80003874 <holdingsleep+0x3e>
    80003858:	4481                	li	s1,0
  release(&lk->lk);
    8000385a:	854a                	mv	a0,s2
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	984080e7          	jalr	-1660(ra) # 800061e0 <release>
  return r;
}
    80003864:	8526                	mv	a0,s1
    80003866:	70a2                	ld	ra,40(sp)
    80003868:	7402                	ld	s0,32(sp)
    8000386a:	64e2                	ld	s1,24(sp)
    8000386c:	6942                	ld	s2,16(sp)
    8000386e:	69a2                	ld	s3,8(sp)
    80003870:	6145                	addi	sp,sp,48
    80003872:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003874:	0284a983          	lw	s3,40(s1)
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	5e0080e7          	jalr	1504(ra) # 80000e58 <myproc>
    80003880:	5904                	lw	s1,48(a0)
    80003882:	413484b3          	sub	s1,s1,s3
    80003886:	0014b493          	seqz	s1,s1
    8000388a:	bfc1                	j	8000385a <holdingsleep+0x24>

000000008000388c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000388c:	1141                	addi	sp,sp,-16
    8000388e:	e406                	sd	ra,8(sp)
    80003890:	e022                	sd	s0,0(sp)
    80003892:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003894:	00005597          	auipc	a1,0x5
    80003898:	d7458593          	addi	a1,a1,-652 # 80008608 <syscalls+0x238>
    8000389c:	00015517          	auipc	a0,0x15
    800038a0:	15c50513          	addi	a0,a0,348 # 800189f8 <ftable>
    800038a4:	00002097          	auipc	ra,0x2
    800038a8:	7f8080e7          	jalr	2040(ra) # 8000609c <initlock>
}
    800038ac:	60a2                	ld	ra,8(sp)
    800038ae:	6402                	ld	s0,0(sp)
    800038b0:	0141                	addi	sp,sp,16
    800038b2:	8082                	ret

00000000800038b4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038b4:	1101                	addi	sp,sp,-32
    800038b6:	ec06                	sd	ra,24(sp)
    800038b8:	e822                	sd	s0,16(sp)
    800038ba:	e426                	sd	s1,8(sp)
    800038bc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038be:	00015517          	auipc	a0,0x15
    800038c2:	13a50513          	addi	a0,a0,314 # 800189f8 <ftable>
    800038c6:	00003097          	auipc	ra,0x3
    800038ca:	866080e7          	jalr	-1946(ra) # 8000612c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038ce:	00015497          	auipc	s1,0x15
    800038d2:	14248493          	addi	s1,s1,322 # 80018a10 <ftable+0x18>
    800038d6:	00016717          	auipc	a4,0x16
    800038da:	0da70713          	addi	a4,a4,218 # 800199b0 <disk>
    if(f->ref == 0){
    800038de:	40dc                	lw	a5,4(s1)
    800038e0:	cf99                	beqz	a5,800038fe <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e2:	02848493          	addi	s1,s1,40
    800038e6:	fee49ce3          	bne	s1,a4,800038de <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038ea:	00015517          	auipc	a0,0x15
    800038ee:	10e50513          	addi	a0,a0,270 # 800189f8 <ftable>
    800038f2:	00003097          	auipc	ra,0x3
    800038f6:	8ee080e7          	jalr	-1810(ra) # 800061e0 <release>
  return 0;
    800038fa:	4481                	li	s1,0
    800038fc:	a819                	j	80003912 <filealloc+0x5e>
      f->ref = 1;
    800038fe:	4785                	li	a5,1
    80003900:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003902:	00015517          	auipc	a0,0x15
    80003906:	0f650513          	addi	a0,a0,246 # 800189f8 <ftable>
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	8d6080e7          	jalr	-1834(ra) # 800061e0 <release>
}
    80003912:	8526                	mv	a0,s1
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6105                	addi	sp,sp,32
    8000391c:	8082                	ret

000000008000391e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000391e:	1101                	addi	sp,sp,-32
    80003920:	ec06                	sd	ra,24(sp)
    80003922:	e822                	sd	s0,16(sp)
    80003924:	e426                	sd	s1,8(sp)
    80003926:	1000                	addi	s0,sp,32
    80003928:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000392a:	00015517          	auipc	a0,0x15
    8000392e:	0ce50513          	addi	a0,a0,206 # 800189f8 <ftable>
    80003932:	00002097          	auipc	ra,0x2
    80003936:	7fa080e7          	jalr	2042(ra) # 8000612c <acquire>
  if(f->ref < 1)
    8000393a:	40dc                	lw	a5,4(s1)
    8000393c:	02f05263          	blez	a5,80003960 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003940:	2785                	addiw	a5,a5,1
    80003942:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003944:	00015517          	auipc	a0,0x15
    80003948:	0b450513          	addi	a0,a0,180 # 800189f8 <ftable>
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	894080e7          	jalr	-1900(ra) # 800061e0 <release>
  return f;
}
    80003954:	8526                	mv	a0,s1
    80003956:	60e2                	ld	ra,24(sp)
    80003958:	6442                	ld	s0,16(sp)
    8000395a:	64a2                	ld	s1,8(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret
    panic("filedup");
    80003960:	00005517          	auipc	a0,0x5
    80003964:	cb050513          	addi	a0,a0,-848 # 80008610 <syscalls+0x240>
    80003968:	00002097          	auipc	ra,0x2
    8000396c:	27a080e7          	jalr	634(ra) # 80005be2 <panic>

0000000080003970 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003970:	7139                	addi	sp,sp,-64
    80003972:	fc06                	sd	ra,56(sp)
    80003974:	f822                	sd	s0,48(sp)
    80003976:	f426                	sd	s1,40(sp)
    80003978:	f04a                	sd	s2,32(sp)
    8000397a:	ec4e                	sd	s3,24(sp)
    8000397c:	e852                	sd	s4,16(sp)
    8000397e:	e456                	sd	s5,8(sp)
    80003980:	0080                	addi	s0,sp,64
    80003982:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003984:	00015517          	auipc	a0,0x15
    80003988:	07450513          	addi	a0,a0,116 # 800189f8 <ftable>
    8000398c:	00002097          	auipc	ra,0x2
    80003990:	7a0080e7          	jalr	1952(ra) # 8000612c <acquire>
  if(f->ref < 1)
    80003994:	40dc                	lw	a5,4(s1)
    80003996:	06f05163          	blez	a5,800039f8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000399a:	37fd                	addiw	a5,a5,-1
    8000399c:	0007871b          	sext.w	a4,a5
    800039a0:	c0dc                	sw	a5,4(s1)
    800039a2:	06e04363          	bgtz	a4,80003a08 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039a6:	0004a903          	lw	s2,0(s1)
    800039aa:	0094ca83          	lbu	s5,9(s1)
    800039ae:	0104ba03          	ld	s4,16(s1)
    800039b2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039b6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039ba:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039be:	00015517          	auipc	a0,0x15
    800039c2:	03a50513          	addi	a0,a0,58 # 800189f8 <ftable>
    800039c6:	00003097          	auipc	ra,0x3
    800039ca:	81a080e7          	jalr	-2022(ra) # 800061e0 <release>

  if(ff.type == FD_PIPE){
    800039ce:	4785                	li	a5,1
    800039d0:	04f90d63          	beq	s2,a5,80003a2a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039d4:	3979                	addiw	s2,s2,-2
    800039d6:	4785                	li	a5,1
    800039d8:	0527e063          	bltu	a5,s2,80003a18 <fileclose+0xa8>
    begin_op();
    800039dc:	00000097          	auipc	ra,0x0
    800039e0:	ac8080e7          	jalr	-1336(ra) # 800034a4 <begin_op>
    iput(ff.ip);
    800039e4:	854e                	mv	a0,s3
    800039e6:	fffff097          	auipc	ra,0xfffff
    800039ea:	2b6080e7          	jalr	694(ra) # 80002c9c <iput>
    end_op();
    800039ee:	00000097          	auipc	ra,0x0
    800039f2:	b36080e7          	jalr	-1226(ra) # 80003524 <end_op>
    800039f6:	a00d                	j	80003a18 <fileclose+0xa8>
    panic("fileclose");
    800039f8:	00005517          	auipc	a0,0x5
    800039fc:	c2050513          	addi	a0,a0,-992 # 80008618 <syscalls+0x248>
    80003a00:	00002097          	auipc	ra,0x2
    80003a04:	1e2080e7          	jalr	482(ra) # 80005be2 <panic>
    release(&ftable.lock);
    80003a08:	00015517          	auipc	a0,0x15
    80003a0c:	ff050513          	addi	a0,a0,-16 # 800189f8 <ftable>
    80003a10:	00002097          	auipc	ra,0x2
    80003a14:	7d0080e7          	jalr	2000(ra) # 800061e0 <release>
  }
}
    80003a18:	70e2                	ld	ra,56(sp)
    80003a1a:	7442                	ld	s0,48(sp)
    80003a1c:	74a2                	ld	s1,40(sp)
    80003a1e:	7902                	ld	s2,32(sp)
    80003a20:	69e2                	ld	s3,24(sp)
    80003a22:	6a42                	ld	s4,16(sp)
    80003a24:	6aa2                	ld	s5,8(sp)
    80003a26:	6121                	addi	sp,sp,64
    80003a28:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a2a:	85d6                	mv	a1,s5
    80003a2c:	8552                	mv	a0,s4
    80003a2e:	00000097          	auipc	ra,0x0
    80003a32:	34c080e7          	jalr	844(ra) # 80003d7a <pipeclose>
    80003a36:	b7cd                	j	80003a18 <fileclose+0xa8>

0000000080003a38 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a38:	715d                	addi	sp,sp,-80
    80003a3a:	e486                	sd	ra,72(sp)
    80003a3c:	e0a2                	sd	s0,64(sp)
    80003a3e:	fc26                	sd	s1,56(sp)
    80003a40:	f84a                	sd	s2,48(sp)
    80003a42:	f44e                	sd	s3,40(sp)
    80003a44:	0880                	addi	s0,sp,80
    80003a46:	84aa                	mv	s1,a0
    80003a48:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a4a:	ffffd097          	auipc	ra,0xffffd
    80003a4e:	40e080e7          	jalr	1038(ra) # 80000e58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a52:	409c                	lw	a5,0(s1)
    80003a54:	37f9                	addiw	a5,a5,-2
    80003a56:	4705                	li	a4,1
    80003a58:	04f76763          	bltu	a4,a5,80003aa6 <filestat+0x6e>
    80003a5c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a5e:	6c88                	ld	a0,24(s1)
    80003a60:	fffff097          	auipc	ra,0xfffff
    80003a64:	082080e7          	jalr	130(ra) # 80002ae2 <ilock>
    stati(f->ip, &st);
    80003a68:	fb840593          	addi	a1,s0,-72
    80003a6c:	6c88                	ld	a0,24(s1)
    80003a6e:	fffff097          	auipc	ra,0xfffff
    80003a72:	2fe080e7          	jalr	766(ra) # 80002d6c <stati>
    iunlock(f->ip);
    80003a76:	6c88                	ld	a0,24(s1)
    80003a78:	fffff097          	auipc	ra,0xfffff
    80003a7c:	12c080e7          	jalr	300(ra) # 80002ba4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a80:	46e1                	li	a3,24
    80003a82:	fb840613          	addi	a2,s0,-72
    80003a86:	85ce                	mv	a1,s3
    80003a88:	05093503          	ld	a0,80(s2)
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	08a080e7          	jalr	138(ra) # 80000b16 <copyout>
    80003a94:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a98:	60a6                	ld	ra,72(sp)
    80003a9a:	6406                	ld	s0,64(sp)
    80003a9c:	74e2                	ld	s1,56(sp)
    80003a9e:	7942                	ld	s2,48(sp)
    80003aa0:	79a2                	ld	s3,40(sp)
    80003aa2:	6161                	addi	sp,sp,80
    80003aa4:	8082                	ret
  return -1;
    80003aa6:	557d                	li	a0,-1
    80003aa8:	bfc5                	j	80003a98 <filestat+0x60>

0000000080003aaa <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aaa:	7179                	addi	sp,sp,-48
    80003aac:	f406                	sd	ra,40(sp)
    80003aae:	f022                	sd	s0,32(sp)
    80003ab0:	ec26                	sd	s1,24(sp)
    80003ab2:	e84a                	sd	s2,16(sp)
    80003ab4:	e44e                	sd	s3,8(sp)
    80003ab6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ab8:	00854783          	lbu	a5,8(a0)
    80003abc:	c3d5                	beqz	a5,80003b60 <fileread+0xb6>
    80003abe:	84aa                	mv	s1,a0
    80003ac0:	89ae                	mv	s3,a1
    80003ac2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ac4:	411c                	lw	a5,0(a0)
    80003ac6:	4705                	li	a4,1
    80003ac8:	04e78963          	beq	a5,a4,80003b1a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003acc:	470d                	li	a4,3
    80003ace:	04e78d63          	beq	a5,a4,80003b28 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ad2:	4709                	li	a4,2
    80003ad4:	06e79e63          	bne	a5,a4,80003b50 <fileread+0xa6>
    ilock(f->ip);
    80003ad8:	6d08                	ld	a0,24(a0)
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	008080e7          	jalr	8(ra) # 80002ae2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ae2:	874a                	mv	a4,s2
    80003ae4:	5094                	lw	a3,32(s1)
    80003ae6:	864e                	mv	a2,s3
    80003ae8:	4585                	li	a1,1
    80003aea:	6c88                	ld	a0,24(s1)
    80003aec:	fffff097          	auipc	ra,0xfffff
    80003af0:	2aa080e7          	jalr	682(ra) # 80002d96 <readi>
    80003af4:	892a                	mv	s2,a0
    80003af6:	00a05563          	blez	a0,80003b00 <fileread+0x56>
      f->off += r;
    80003afa:	509c                	lw	a5,32(s1)
    80003afc:	9fa9                	addw	a5,a5,a0
    80003afe:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b00:	6c88                	ld	a0,24(s1)
    80003b02:	fffff097          	auipc	ra,0xfffff
    80003b06:	0a2080e7          	jalr	162(ra) # 80002ba4 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b0a:	854a                	mv	a0,s2
    80003b0c:	70a2                	ld	ra,40(sp)
    80003b0e:	7402                	ld	s0,32(sp)
    80003b10:	64e2                	ld	s1,24(sp)
    80003b12:	6942                	ld	s2,16(sp)
    80003b14:	69a2                	ld	s3,8(sp)
    80003b16:	6145                	addi	sp,sp,48
    80003b18:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b1a:	6908                	ld	a0,16(a0)
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	3ce080e7          	jalr	974(ra) # 80003eea <piperead>
    80003b24:	892a                	mv	s2,a0
    80003b26:	b7d5                	j	80003b0a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b28:	02451783          	lh	a5,36(a0)
    80003b2c:	03079693          	slli	a3,a5,0x30
    80003b30:	92c1                	srli	a3,a3,0x30
    80003b32:	4725                	li	a4,9
    80003b34:	02d76863          	bltu	a4,a3,80003b64 <fileread+0xba>
    80003b38:	0792                	slli	a5,a5,0x4
    80003b3a:	00015717          	auipc	a4,0x15
    80003b3e:	e1e70713          	addi	a4,a4,-482 # 80018958 <devsw>
    80003b42:	97ba                	add	a5,a5,a4
    80003b44:	639c                	ld	a5,0(a5)
    80003b46:	c38d                	beqz	a5,80003b68 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b48:	4505                	li	a0,1
    80003b4a:	9782                	jalr	a5
    80003b4c:	892a                	mv	s2,a0
    80003b4e:	bf75                	j	80003b0a <fileread+0x60>
    panic("fileread");
    80003b50:	00005517          	auipc	a0,0x5
    80003b54:	ad850513          	addi	a0,a0,-1320 # 80008628 <syscalls+0x258>
    80003b58:	00002097          	auipc	ra,0x2
    80003b5c:	08a080e7          	jalr	138(ra) # 80005be2 <panic>
    return -1;
    80003b60:	597d                	li	s2,-1
    80003b62:	b765                	j	80003b0a <fileread+0x60>
      return -1;
    80003b64:	597d                	li	s2,-1
    80003b66:	b755                	j	80003b0a <fileread+0x60>
    80003b68:	597d                	li	s2,-1
    80003b6a:	b745                	j	80003b0a <fileread+0x60>

0000000080003b6c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b6c:	715d                	addi	sp,sp,-80
    80003b6e:	e486                	sd	ra,72(sp)
    80003b70:	e0a2                	sd	s0,64(sp)
    80003b72:	fc26                	sd	s1,56(sp)
    80003b74:	f84a                	sd	s2,48(sp)
    80003b76:	f44e                	sd	s3,40(sp)
    80003b78:	f052                	sd	s4,32(sp)
    80003b7a:	ec56                	sd	s5,24(sp)
    80003b7c:	e85a                	sd	s6,16(sp)
    80003b7e:	e45e                	sd	s7,8(sp)
    80003b80:	e062                	sd	s8,0(sp)
    80003b82:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b84:	00954783          	lbu	a5,9(a0)
    80003b88:	10078663          	beqz	a5,80003c94 <filewrite+0x128>
    80003b8c:	892a                	mv	s2,a0
    80003b8e:	8aae                	mv	s5,a1
    80003b90:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b92:	411c                	lw	a5,0(a0)
    80003b94:	4705                	li	a4,1
    80003b96:	02e78263          	beq	a5,a4,80003bba <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b9a:	470d                	li	a4,3
    80003b9c:	02e78663          	beq	a5,a4,80003bc8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba0:	4709                	li	a4,2
    80003ba2:	0ee79163          	bne	a5,a4,80003c84 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ba6:	0ac05d63          	blez	a2,80003c60 <filewrite+0xf4>
    int i = 0;
    80003baa:	4981                	li	s3,0
    80003bac:	6b05                	lui	s6,0x1
    80003bae:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003bb2:	6b85                	lui	s7,0x1
    80003bb4:	c00b8b9b          	addiw	s7,s7,-1024
    80003bb8:	a861                	j	80003c50 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bba:	6908                	ld	a0,16(a0)
    80003bbc:	00000097          	auipc	ra,0x0
    80003bc0:	22e080e7          	jalr	558(ra) # 80003dea <pipewrite>
    80003bc4:	8a2a                	mv	s4,a0
    80003bc6:	a045                	j	80003c66 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bc8:	02451783          	lh	a5,36(a0)
    80003bcc:	03079693          	slli	a3,a5,0x30
    80003bd0:	92c1                	srli	a3,a3,0x30
    80003bd2:	4725                	li	a4,9
    80003bd4:	0cd76263          	bltu	a4,a3,80003c98 <filewrite+0x12c>
    80003bd8:	0792                	slli	a5,a5,0x4
    80003bda:	00015717          	auipc	a4,0x15
    80003bde:	d7e70713          	addi	a4,a4,-642 # 80018958 <devsw>
    80003be2:	97ba                	add	a5,a5,a4
    80003be4:	679c                	ld	a5,8(a5)
    80003be6:	cbdd                	beqz	a5,80003c9c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003be8:	4505                	li	a0,1
    80003bea:	9782                	jalr	a5
    80003bec:	8a2a                	mv	s4,a0
    80003bee:	a8a5                	j	80003c66 <filewrite+0xfa>
    80003bf0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	8b0080e7          	jalr	-1872(ra) # 800034a4 <begin_op>
      ilock(f->ip);
    80003bfc:	01893503          	ld	a0,24(s2)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	ee2080e7          	jalr	-286(ra) # 80002ae2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c08:	8762                	mv	a4,s8
    80003c0a:	02092683          	lw	a3,32(s2)
    80003c0e:	01598633          	add	a2,s3,s5
    80003c12:	4585                	li	a1,1
    80003c14:	01893503          	ld	a0,24(s2)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	276080e7          	jalr	630(ra) # 80002e8e <writei>
    80003c20:	84aa                	mv	s1,a0
    80003c22:	00a05763          	blez	a0,80003c30 <filewrite+0xc4>
        f->off += r;
    80003c26:	02092783          	lw	a5,32(s2)
    80003c2a:	9fa9                	addw	a5,a5,a0
    80003c2c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c30:	01893503          	ld	a0,24(s2)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	f70080e7          	jalr	-144(ra) # 80002ba4 <iunlock>
      end_op();
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	8e8080e7          	jalr	-1816(ra) # 80003524 <end_op>

      if(r != n1){
    80003c44:	009c1f63          	bne	s8,s1,80003c62 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c48:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c4c:	0149db63          	bge	s3,s4,80003c62 <filewrite+0xf6>
      int n1 = n - i;
    80003c50:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003c54:	84be                	mv	s1,a5
    80003c56:	2781                	sext.w	a5,a5
    80003c58:	f8fb5ce3          	bge	s6,a5,80003bf0 <filewrite+0x84>
    80003c5c:	84de                	mv	s1,s7
    80003c5e:	bf49                	j	80003bf0 <filewrite+0x84>
    int i = 0;
    80003c60:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c62:	013a1f63          	bne	s4,s3,80003c80 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c66:	8552                	mv	a0,s4
    80003c68:	60a6                	ld	ra,72(sp)
    80003c6a:	6406                	ld	s0,64(sp)
    80003c6c:	74e2                	ld	s1,56(sp)
    80003c6e:	7942                	ld	s2,48(sp)
    80003c70:	79a2                	ld	s3,40(sp)
    80003c72:	7a02                	ld	s4,32(sp)
    80003c74:	6ae2                	ld	s5,24(sp)
    80003c76:	6b42                	ld	s6,16(sp)
    80003c78:	6ba2                	ld	s7,8(sp)
    80003c7a:	6c02                	ld	s8,0(sp)
    80003c7c:	6161                	addi	sp,sp,80
    80003c7e:	8082                	ret
    ret = (i == n ? n : -1);
    80003c80:	5a7d                	li	s4,-1
    80003c82:	b7d5                	j	80003c66 <filewrite+0xfa>
    panic("filewrite");
    80003c84:	00005517          	auipc	a0,0x5
    80003c88:	9b450513          	addi	a0,a0,-1612 # 80008638 <syscalls+0x268>
    80003c8c:	00002097          	auipc	ra,0x2
    80003c90:	f56080e7          	jalr	-170(ra) # 80005be2 <panic>
    return -1;
    80003c94:	5a7d                	li	s4,-1
    80003c96:	bfc1                	j	80003c66 <filewrite+0xfa>
      return -1;
    80003c98:	5a7d                	li	s4,-1
    80003c9a:	b7f1                	j	80003c66 <filewrite+0xfa>
    80003c9c:	5a7d                	li	s4,-1
    80003c9e:	b7e1                	j	80003c66 <filewrite+0xfa>

0000000080003ca0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ca0:	7179                	addi	sp,sp,-48
    80003ca2:	f406                	sd	ra,40(sp)
    80003ca4:	f022                	sd	s0,32(sp)
    80003ca6:	ec26                	sd	s1,24(sp)
    80003ca8:	e84a                	sd	s2,16(sp)
    80003caa:	e44e                	sd	s3,8(sp)
    80003cac:	e052                	sd	s4,0(sp)
    80003cae:	1800                	addi	s0,sp,48
    80003cb0:	84aa                	mv	s1,a0
    80003cb2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cb4:	0005b023          	sd	zero,0(a1)
    80003cb8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	bf8080e7          	jalr	-1032(ra) # 800038b4 <filealloc>
    80003cc4:	e088                	sd	a0,0(s1)
    80003cc6:	c551                	beqz	a0,80003d52 <pipealloc+0xb2>
    80003cc8:	00000097          	auipc	ra,0x0
    80003ccc:	bec080e7          	jalr	-1044(ra) # 800038b4 <filealloc>
    80003cd0:	00aa3023          	sd	a0,0(s4)
    80003cd4:	c92d                	beqz	a0,80003d46 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cd6:	ffffc097          	auipc	ra,0xffffc
    80003cda:	442080e7          	jalr	1090(ra) # 80000118 <kalloc>
    80003cde:	892a                	mv	s2,a0
    80003ce0:	c125                	beqz	a0,80003d40 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ce2:	4985                	li	s3,1
    80003ce4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ce8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cec:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cf0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cf4:	00005597          	auipc	a1,0x5
    80003cf8:	95458593          	addi	a1,a1,-1708 # 80008648 <syscalls+0x278>
    80003cfc:	00002097          	auipc	ra,0x2
    80003d00:	3a0080e7          	jalr	928(ra) # 8000609c <initlock>
  (*f0)->type = FD_PIPE;
    80003d04:	609c                	ld	a5,0(s1)
    80003d06:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d0a:	609c                	ld	a5,0(s1)
    80003d0c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d10:	609c                	ld	a5,0(s1)
    80003d12:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d16:	609c                	ld	a5,0(s1)
    80003d18:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d1c:	000a3783          	ld	a5,0(s4)
    80003d20:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d24:	000a3783          	ld	a5,0(s4)
    80003d28:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d2c:	000a3783          	ld	a5,0(s4)
    80003d30:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d34:	000a3783          	ld	a5,0(s4)
    80003d38:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d3c:	4501                	li	a0,0
    80003d3e:	a025                	j	80003d66 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d40:	6088                	ld	a0,0(s1)
    80003d42:	e501                	bnez	a0,80003d4a <pipealloc+0xaa>
    80003d44:	a039                	j	80003d52 <pipealloc+0xb2>
    80003d46:	6088                	ld	a0,0(s1)
    80003d48:	c51d                	beqz	a0,80003d76 <pipealloc+0xd6>
    fileclose(*f0);
    80003d4a:	00000097          	auipc	ra,0x0
    80003d4e:	c26080e7          	jalr	-986(ra) # 80003970 <fileclose>
  if(*f1)
    80003d52:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d56:	557d                	li	a0,-1
  if(*f1)
    80003d58:	c799                	beqz	a5,80003d66 <pipealloc+0xc6>
    fileclose(*f1);
    80003d5a:	853e                	mv	a0,a5
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	c14080e7          	jalr	-1004(ra) # 80003970 <fileclose>
  return -1;
    80003d64:	557d                	li	a0,-1
}
    80003d66:	70a2                	ld	ra,40(sp)
    80003d68:	7402                	ld	s0,32(sp)
    80003d6a:	64e2                	ld	s1,24(sp)
    80003d6c:	6942                	ld	s2,16(sp)
    80003d6e:	69a2                	ld	s3,8(sp)
    80003d70:	6a02                	ld	s4,0(sp)
    80003d72:	6145                	addi	sp,sp,48
    80003d74:	8082                	ret
  return -1;
    80003d76:	557d                	li	a0,-1
    80003d78:	b7fd                	j	80003d66 <pipealloc+0xc6>

0000000080003d7a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d7a:	1101                	addi	sp,sp,-32
    80003d7c:	ec06                	sd	ra,24(sp)
    80003d7e:	e822                	sd	s0,16(sp)
    80003d80:	e426                	sd	s1,8(sp)
    80003d82:	e04a                	sd	s2,0(sp)
    80003d84:	1000                	addi	s0,sp,32
    80003d86:	84aa                	mv	s1,a0
    80003d88:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d8a:	00002097          	auipc	ra,0x2
    80003d8e:	3a2080e7          	jalr	930(ra) # 8000612c <acquire>
  if(writable){
    80003d92:	02090d63          	beqz	s2,80003dcc <pipeclose+0x52>
    pi->writeopen = 0;
    80003d96:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d9a:	21848513          	addi	a0,s1,536
    80003d9e:	ffffd097          	auipc	ra,0xffffd
    80003da2:	7c2080e7          	jalr	1986(ra) # 80001560 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003da6:	2204b783          	ld	a5,544(s1)
    80003daa:	eb95                	bnez	a5,80003dde <pipeclose+0x64>
    release(&pi->lock);
    80003dac:	8526                	mv	a0,s1
    80003dae:	00002097          	auipc	ra,0x2
    80003db2:	432080e7          	jalr	1074(ra) # 800061e0 <release>
    kfree((char*)pi);
    80003db6:	8526                	mv	a0,s1
    80003db8:	ffffc097          	auipc	ra,0xffffc
    80003dbc:	264080e7          	jalr	612(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dc0:	60e2                	ld	ra,24(sp)
    80003dc2:	6442                	ld	s0,16(sp)
    80003dc4:	64a2                	ld	s1,8(sp)
    80003dc6:	6902                	ld	s2,0(sp)
    80003dc8:	6105                	addi	sp,sp,32
    80003dca:	8082                	ret
    pi->readopen = 0;
    80003dcc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dd0:	21c48513          	addi	a0,s1,540
    80003dd4:	ffffd097          	auipc	ra,0xffffd
    80003dd8:	78c080e7          	jalr	1932(ra) # 80001560 <wakeup>
    80003ddc:	b7e9                	j	80003da6 <pipeclose+0x2c>
    release(&pi->lock);
    80003dde:	8526                	mv	a0,s1
    80003de0:	00002097          	auipc	ra,0x2
    80003de4:	400080e7          	jalr	1024(ra) # 800061e0 <release>
}
    80003de8:	bfe1                	j	80003dc0 <pipeclose+0x46>

0000000080003dea <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dea:	7159                	addi	sp,sp,-112
    80003dec:	f486                	sd	ra,104(sp)
    80003dee:	f0a2                	sd	s0,96(sp)
    80003df0:	eca6                	sd	s1,88(sp)
    80003df2:	e8ca                	sd	s2,80(sp)
    80003df4:	e4ce                	sd	s3,72(sp)
    80003df6:	e0d2                	sd	s4,64(sp)
    80003df8:	fc56                	sd	s5,56(sp)
    80003dfa:	f85a                	sd	s6,48(sp)
    80003dfc:	f45e                	sd	s7,40(sp)
    80003dfe:	f062                	sd	s8,32(sp)
    80003e00:	ec66                	sd	s9,24(sp)
    80003e02:	1880                	addi	s0,sp,112
    80003e04:	84aa                	mv	s1,a0
    80003e06:	8aae                	mv	s5,a1
    80003e08:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e0a:	ffffd097          	auipc	ra,0xffffd
    80003e0e:	04e080e7          	jalr	78(ra) # 80000e58 <myproc>
    80003e12:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e14:	8526                	mv	a0,s1
    80003e16:	00002097          	auipc	ra,0x2
    80003e1a:	316080e7          	jalr	790(ra) # 8000612c <acquire>
  while(i < n){
    80003e1e:	0d405463          	blez	s4,80003ee6 <pipewrite+0xfc>
    80003e22:	8ba6                	mv	s7,s1
  int i = 0;
    80003e24:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e26:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e28:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e2c:	21c48c13          	addi	s8,s1,540
    80003e30:	a08d                	j	80003e92 <pipewrite+0xa8>
      release(&pi->lock);
    80003e32:	8526                	mv	a0,s1
    80003e34:	00002097          	auipc	ra,0x2
    80003e38:	3ac080e7          	jalr	940(ra) # 800061e0 <release>
      return -1;
    80003e3c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e3e:	854a                	mv	a0,s2
    80003e40:	70a6                	ld	ra,104(sp)
    80003e42:	7406                	ld	s0,96(sp)
    80003e44:	64e6                	ld	s1,88(sp)
    80003e46:	6946                	ld	s2,80(sp)
    80003e48:	69a6                	ld	s3,72(sp)
    80003e4a:	6a06                	ld	s4,64(sp)
    80003e4c:	7ae2                	ld	s5,56(sp)
    80003e4e:	7b42                	ld	s6,48(sp)
    80003e50:	7ba2                	ld	s7,40(sp)
    80003e52:	7c02                	ld	s8,32(sp)
    80003e54:	6ce2                	ld	s9,24(sp)
    80003e56:	6165                	addi	sp,sp,112
    80003e58:	8082                	ret
      wakeup(&pi->nread);
    80003e5a:	8566                	mv	a0,s9
    80003e5c:	ffffd097          	auipc	ra,0xffffd
    80003e60:	704080e7          	jalr	1796(ra) # 80001560 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e64:	85de                	mv	a1,s7
    80003e66:	8562                	mv	a0,s8
    80003e68:	ffffd097          	auipc	ra,0xffffd
    80003e6c:	694080e7          	jalr	1684(ra) # 800014fc <sleep>
    80003e70:	a839                	j	80003e8e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e72:	21c4a783          	lw	a5,540(s1)
    80003e76:	0017871b          	addiw	a4,a5,1
    80003e7a:	20e4ae23          	sw	a4,540(s1)
    80003e7e:	1ff7f793          	andi	a5,a5,511
    80003e82:	97a6                	add	a5,a5,s1
    80003e84:	f9f44703          	lbu	a4,-97(s0)
    80003e88:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e8c:	2905                	addiw	s2,s2,1
  while(i < n){
    80003e8e:	05495063          	bge	s2,s4,80003ece <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003e92:	2204a783          	lw	a5,544(s1)
    80003e96:	dfd1                	beqz	a5,80003e32 <pipewrite+0x48>
    80003e98:	854e                	mv	a0,s3
    80003e9a:	ffffe097          	auipc	ra,0xffffe
    80003e9e:	90a080e7          	jalr	-1782(ra) # 800017a4 <killed>
    80003ea2:	f941                	bnez	a0,80003e32 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ea4:	2184a783          	lw	a5,536(s1)
    80003ea8:	21c4a703          	lw	a4,540(s1)
    80003eac:	2007879b          	addiw	a5,a5,512
    80003eb0:	faf705e3          	beq	a4,a5,80003e5a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eb4:	4685                	li	a3,1
    80003eb6:	01590633          	add	a2,s2,s5
    80003eba:	f9f40593          	addi	a1,s0,-97
    80003ebe:	0509b503          	ld	a0,80(s3)
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	ce0080e7          	jalr	-800(ra) # 80000ba2 <copyin>
    80003eca:	fb6514e3          	bne	a0,s6,80003e72 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003ece:	21848513          	addi	a0,s1,536
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	68e080e7          	jalr	1678(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80003eda:	8526                	mv	a0,s1
    80003edc:	00002097          	auipc	ra,0x2
    80003ee0:	304080e7          	jalr	772(ra) # 800061e0 <release>
  return i;
    80003ee4:	bfa9                	j	80003e3e <pipewrite+0x54>
  int i = 0;
    80003ee6:	4901                	li	s2,0
    80003ee8:	b7dd                	j	80003ece <pipewrite+0xe4>

0000000080003eea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003eea:	715d                	addi	sp,sp,-80
    80003eec:	e486                	sd	ra,72(sp)
    80003eee:	e0a2                	sd	s0,64(sp)
    80003ef0:	fc26                	sd	s1,56(sp)
    80003ef2:	f84a                	sd	s2,48(sp)
    80003ef4:	f44e                	sd	s3,40(sp)
    80003ef6:	f052                	sd	s4,32(sp)
    80003ef8:	ec56                	sd	s5,24(sp)
    80003efa:	e85a                	sd	s6,16(sp)
    80003efc:	0880                	addi	s0,sp,80
    80003efe:	84aa                	mv	s1,a0
    80003f00:	892e                	mv	s2,a1
    80003f02:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f04:	ffffd097          	auipc	ra,0xffffd
    80003f08:	f54080e7          	jalr	-172(ra) # 80000e58 <myproc>
    80003f0c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f0e:	8b26                	mv	s6,s1
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	21a080e7          	jalr	538(ra) # 8000612c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f1a:	2184a703          	lw	a4,536(s1)
    80003f1e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f22:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f26:	02f71763          	bne	a4,a5,80003f54 <piperead+0x6a>
    80003f2a:	2244a783          	lw	a5,548(s1)
    80003f2e:	c39d                	beqz	a5,80003f54 <piperead+0x6a>
    if(killed(pr)){
    80003f30:	8552                	mv	a0,s4
    80003f32:	ffffe097          	auipc	ra,0xffffe
    80003f36:	872080e7          	jalr	-1934(ra) # 800017a4 <killed>
    80003f3a:	e941                	bnez	a0,80003fca <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f3c:	85da                	mv	a1,s6
    80003f3e:	854e                	mv	a0,s3
    80003f40:	ffffd097          	auipc	ra,0xffffd
    80003f44:	5bc080e7          	jalr	1468(ra) # 800014fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f48:	2184a703          	lw	a4,536(s1)
    80003f4c:	21c4a783          	lw	a5,540(s1)
    80003f50:	fcf70de3          	beq	a4,a5,80003f2a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f54:	09505263          	blez	s5,80003fd8 <piperead+0xee>
    80003f58:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f5a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003f5c:	2184a783          	lw	a5,536(s1)
    80003f60:	21c4a703          	lw	a4,540(s1)
    80003f64:	02f70d63          	beq	a4,a5,80003f9e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f68:	0017871b          	addiw	a4,a5,1
    80003f6c:	20e4ac23          	sw	a4,536(s1)
    80003f70:	1ff7f793          	andi	a5,a5,511
    80003f74:	97a6                	add	a5,a5,s1
    80003f76:	0187c783          	lbu	a5,24(a5)
    80003f7a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f7e:	4685                	li	a3,1
    80003f80:	fbf40613          	addi	a2,s0,-65
    80003f84:	85ca                	mv	a1,s2
    80003f86:	050a3503          	ld	a0,80(s4)
    80003f8a:	ffffd097          	auipc	ra,0xffffd
    80003f8e:	b8c080e7          	jalr	-1140(ra) # 80000b16 <copyout>
    80003f92:	01650663          	beq	a0,s6,80003f9e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f96:	2985                	addiw	s3,s3,1
    80003f98:	0905                	addi	s2,s2,1
    80003f9a:	fd3a91e3          	bne	s5,s3,80003f5c <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f9e:	21c48513          	addi	a0,s1,540
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	5be080e7          	jalr	1470(ra) # 80001560 <wakeup>
  release(&pi->lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	00002097          	auipc	ra,0x2
    80003fb0:	234080e7          	jalr	564(ra) # 800061e0 <release>
  return i;
}
    80003fb4:	854e                	mv	a0,s3
    80003fb6:	60a6                	ld	ra,72(sp)
    80003fb8:	6406                	ld	s0,64(sp)
    80003fba:	74e2                	ld	s1,56(sp)
    80003fbc:	7942                	ld	s2,48(sp)
    80003fbe:	79a2                	ld	s3,40(sp)
    80003fc0:	7a02                	ld	s4,32(sp)
    80003fc2:	6ae2                	ld	s5,24(sp)
    80003fc4:	6b42                	ld	s6,16(sp)
    80003fc6:	6161                	addi	sp,sp,80
    80003fc8:	8082                	ret
      release(&pi->lock);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	00002097          	auipc	ra,0x2
    80003fd0:	214080e7          	jalr	532(ra) # 800061e0 <release>
      return -1;
    80003fd4:	59fd                	li	s3,-1
    80003fd6:	bff9                	j	80003fb4 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd8:	4981                	li	s3,0
    80003fda:	b7d1                	j	80003f9e <piperead+0xb4>

0000000080003fdc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003fdc:	1141                	addi	sp,sp,-16
    80003fde:	e422                	sd	s0,8(sp)
    80003fe0:	0800                	addi	s0,sp,16
    80003fe2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003fe4:	8905                	andi	a0,a0,1
    80003fe6:	c111                	beqz	a0,80003fea <flags2perm+0xe>
      perm = PTE_X;
    80003fe8:	4521                	li	a0,8
    if(flags & 0x2)
    80003fea:	8b89                	andi	a5,a5,2
    80003fec:	c399                	beqz	a5,80003ff2 <flags2perm+0x16>
      perm |= PTE_W;
    80003fee:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ff2:	6422                	ld	s0,8(sp)
    80003ff4:	0141                	addi	sp,sp,16
    80003ff6:	8082                	ret

0000000080003ff8 <exec>:

int
exec(char *path, char **argv)
{
    80003ff8:	df010113          	addi	sp,sp,-528
    80003ffc:	20113423          	sd	ra,520(sp)
    80004000:	20813023          	sd	s0,512(sp)
    80004004:	ffa6                	sd	s1,504(sp)
    80004006:	fbca                	sd	s2,496(sp)
    80004008:	f7ce                	sd	s3,488(sp)
    8000400a:	f3d2                	sd	s4,480(sp)
    8000400c:	efd6                	sd	s5,472(sp)
    8000400e:	ebda                	sd	s6,464(sp)
    80004010:	e7de                	sd	s7,456(sp)
    80004012:	e3e2                	sd	s8,448(sp)
    80004014:	ff66                	sd	s9,440(sp)
    80004016:	fb6a                	sd	s10,432(sp)
    80004018:	f76e                	sd	s11,424(sp)
    8000401a:	0c00                	addi	s0,sp,528
    8000401c:	84aa                	mv	s1,a0
    8000401e:	dea43c23          	sd	a0,-520(s0)
    80004022:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	e32080e7          	jalr	-462(ra) # 80000e58 <myproc>
    8000402e:	892a                	mv	s2,a0

  begin_op();
    80004030:	fffff097          	auipc	ra,0xfffff
    80004034:	474080e7          	jalr	1140(ra) # 800034a4 <begin_op>

  if((ip = namei(path)) == 0){
    80004038:	8526                	mv	a0,s1
    8000403a:	fffff097          	auipc	ra,0xfffff
    8000403e:	24e080e7          	jalr	590(ra) # 80003288 <namei>
    80004042:	c92d                	beqz	a0,800040b4 <exec+0xbc>
    80004044:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	a9c080e7          	jalr	-1380(ra) # 80002ae2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000404e:	04000713          	li	a4,64
    80004052:	4681                	li	a3,0
    80004054:	e5040613          	addi	a2,s0,-432
    80004058:	4581                	li	a1,0
    8000405a:	8526                	mv	a0,s1
    8000405c:	fffff097          	auipc	ra,0xfffff
    80004060:	d3a080e7          	jalr	-710(ra) # 80002d96 <readi>
    80004064:	04000793          	li	a5,64
    80004068:	00f51a63          	bne	a0,a5,8000407c <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000406c:	e5042703          	lw	a4,-432(s0)
    80004070:	464c47b7          	lui	a5,0x464c4
    80004074:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004078:	04f70463          	beq	a4,a5,800040c0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000407c:	8526                	mv	a0,s1
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	cc6080e7          	jalr	-826(ra) # 80002d44 <iunlockput>
    end_op();
    80004086:	fffff097          	auipc	ra,0xfffff
    8000408a:	49e080e7          	jalr	1182(ra) # 80003524 <end_op>
  }
  return -1;
    8000408e:	557d                	li	a0,-1
}
    80004090:	20813083          	ld	ra,520(sp)
    80004094:	20013403          	ld	s0,512(sp)
    80004098:	74fe                	ld	s1,504(sp)
    8000409a:	795e                	ld	s2,496(sp)
    8000409c:	79be                	ld	s3,488(sp)
    8000409e:	7a1e                	ld	s4,480(sp)
    800040a0:	6afe                	ld	s5,472(sp)
    800040a2:	6b5e                	ld	s6,464(sp)
    800040a4:	6bbe                	ld	s7,456(sp)
    800040a6:	6c1e                	ld	s8,448(sp)
    800040a8:	7cfa                	ld	s9,440(sp)
    800040aa:	7d5a                	ld	s10,432(sp)
    800040ac:	7dba                	ld	s11,424(sp)
    800040ae:	21010113          	addi	sp,sp,528
    800040b2:	8082                	ret
    end_op();
    800040b4:	fffff097          	auipc	ra,0xfffff
    800040b8:	470080e7          	jalr	1136(ra) # 80003524 <end_op>
    return -1;
    800040bc:	557d                	li	a0,-1
    800040be:	bfc9                	j	80004090 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800040c0:	854a                	mv	a0,s2
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	e5a080e7          	jalr	-422(ra) # 80000f1c <proc_pagetable>
    800040ca:	8baa                	mv	s7,a0
    800040cc:	d945                	beqz	a0,8000407c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040ce:	e7042983          	lw	s3,-400(s0)
    800040d2:	e8845783          	lhu	a5,-376(s0)
    800040d6:	c7ad                	beqz	a5,80004140 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040d8:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040da:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800040dc:	6c85                	lui	s9,0x1
    800040de:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040e2:	def43823          	sd	a5,-528(s0)
    800040e6:	ac0d                	j	80004318 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040e8:	00004517          	auipc	a0,0x4
    800040ec:	56850513          	addi	a0,a0,1384 # 80008650 <syscalls+0x280>
    800040f0:	00002097          	auipc	ra,0x2
    800040f4:	af2080e7          	jalr	-1294(ra) # 80005be2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040f8:	8756                	mv	a4,s5
    800040fa:	012d86bb          	addw	a3,s11,s2
    800040fe:	4581                	li	a1,0
    80004100:	8526                	mv	a0,s1
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	c94080e7          	jalr	-876(ra) # 80002d96 <readi>
    8000410a:	2501                	sext.w	a0,a0
    8000410c:	1aaa9a63          	bne	s5,a0,800042c0 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004110:	6785                	lui	a5,0x1
    80004112:	0127893b          	addw	s2,a5,s2
    80004116:	77fd                	lui	a5,0xfffff
    80004118:	01478a3b          	addw	s4,a5,s4
    8000411c:	1f897563          	bgeu	s2,s8,80004306 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004120:	02091593          	slli	a1,s2,0x20
    80004124:	9181                	srli	a1,a1,0x20
    80004126:	95ea                	add	a1,a1,s10
    80004128:	855e                	mv	a0,s7
    8000412a:	ffffc097          	auipc	ra,0xffffc
    8000412e:	3e0080e7          	jalr	992(ra) # 8000050a <walkaddr>
    80004132:	862a                	mv	a2,a0
    if(pa == 0)
    80004134:	d955                	beqz	a0,800040e8 <exec+0xf0>
      n = PGSIZE;
    80004136:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004138:	fd9a70e3          	bgeu	s4,s9,800040f8 <exec+0x100>
      n = sz - i;
    8000413c:	8ad2                	mv	s5,s4
    8000413e:	bf6d                	j	800040f8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004140:	4a01                	li	s4,0
  iunlockput(ip);
    80004142:	8526                	mv	a0,s1
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	c00080e7          	jalr	-1024(ra) # 80002d44 <iunlockput>
  end_op();
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	3d8080e7          	jalr	984(ra) # 80003524 <end_op>
  p = myproc();
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	d04080e7          	jalr	-764(ra) # 80000e58 <myproc>
    8000415c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000415e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004162:	6785                	lui	a5,0x1
    80004164:	17fd                	addi	a5,a5,-1
    80004166:	9a3e                	add	s4,s4,a5
    80004168:	757d                	lui	a0,0xfffff
    8000416a:	00aa77b3          	and	a5,s4,a0
    8000416e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004172:	4691                	li	a3,4
    80004174:	6609                	lui	a2,0x2
    80004176:	963e                	add	a2,a2,a5
    80004178:	85be                	mv	a1,a5
    8000417a:	855e                	mv	a0,s7
    8000417c:	ffffc097          	auipc	ra,0xffffc
    80004180:	742080e7          	jalr	1858(ra) # 800008be <uvmalloc>
    80004184:	8b2a                	mv	s6,a0
  ip = 0;
    80004186:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004188:	12050c63          	beqz	a0,800042c0 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000418c:	75f9                	lui	a1,0xffffe
    8000418e:	95aa                	add	a1,a1,a0
    80004190:	855e                	mv	a0,s7
    80004192:	ffffd097          	auipc	ra,0xffffd
    80004196:	952080e7          	jalr	-1710(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    8000419a:	7c7d                	lui	s8,0xfffff
    8000419c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000419e:	e0043783          	ld	a5,-512(s0)
    800041a2:	6388                	ld	a0,0(a5)
    800041a4:	c535                	beqz	a0,80004210 <exec+0x218>
    800041a6:	e9040993          	addi	s3,s0,-368
    800041aa:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041ae:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800041b0:	ffffc097          	auipc	ra,0xffffc
    800041b4:	14c080e7          	jalr	332(ra) # 800002fc <strlen>
    800041b8:	2505                	addiw	a0,a0,1
    800041ba:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041be:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041c2:	13896663          	bltu	s2,s8,800042ee <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041c6:	e0043d83          	ld	s11,-512(s0)
    800041ca:	000dba03          	ld	s4,0(s11)
    800041ce:	8552                	mv	a0,s4
    800041d0:	ffffc097          	auipc	ra,0xffffc
    800041d4:	12c080e7          	jalr	300(ra) # 800002fc <strlen>
    800041d8:	0015069b          	addiw	a3,a0,1
    800041dc:	8652                	mv	a2,s4
    800041de:	85ca                	mv	a1,s2
    800041e0:	855e                	mv	a0,s7
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	934080e7          	jalr	-1740(ra) # 80000b16 <copyout>
    800041ea:	10054663          	bltz	a0,800042f6 <exec+0x2fe>
    ustack[argc] = sp;
    800041ee:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041f2:	0485                	addi	s1,s1,1
    800041f4:	008d8793          	addi	a5,s11,8
    800041f8:	e0f43023          	sd	a5,-512(s0)
    800041fc:	008db503          	ld	a0,8(s11)
    80004200:	c911                	beqz	a0,80004214 <exec+0x21c>
    if(argc >= MAXARG)
    80004202:	09a1                	addi	s3,s3,8
    80004204:	fb3c96e3          	bne	s9,s3,800041b0 <exec+0x1b8>
  sz = sz1;
    80004208:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000420c:	4481                	li	s1,0
    8000420e:	a84d                	j	800042c0 <exec+0x2c8>
  sp = sz;
    80004210:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004212:	4481                	li	s1,0
  ustack[argc] = 0;
    80004214:	00349793          	slli	a5,s1,0x3
    80004218:	f9040713          	addi	a4,s0,-112
    8000421c:	97ba                	add	a5,a5,a4
    8000421e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004222:	00148693          	addi	a3,s1,1
    80004226:	068e                	slli	a3,a3,0x3
    80004228:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000422c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004230:	01897663          	bgeu	s2,s8,8000423c <exec+0x244>
  sz = sz1;
    80004234:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004238:	4481                	li	s1,0
    8000423a:	a059                	j	800042c0 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000423c:	e9040613          	addi	a2,s0,-368
    80004240:	85ca                	mv	a1,s2
    80004242:	855e                	mv	a0,s7
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	8d2080e7          	jalr	-1838(ra) # 80000b16 <copyout>
    8000424c:	0a054963          	bltz	a0,800042fe <exec+0x306>
  p->trapframe->a1 = sp;
    80004250:	058ab783          	ld	a5,88(s5)
    80004254:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004258:	df843783          	ld	a5,-520(s0)
    8000425c:	0007c703          	lbu	a4,0(a5)
    80004260:	cf11                	beqz	a4,8000427c <exec+0x284>
    80004262:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004264:	02f00693          	li	a3,47
    80004268:	a039                	j	80004276 <exec+0x27e>
      last = s+1;
    8000426a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000426e:	0785                	addi	a5,a5,1
    80004270:	fff7c703          	lbu	a4,-1(a5)
    80004274:	c701                	beqz	a4,8000427c <exec+0x284>
    if(*s == '/')
    80004276:	fed71ce3          	bne	a4,a3,8000426e <exec+0x276>
    8000427a:	bfc5                	j	8000426a <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    8000427c:	4641                	li	a2,16
    8000427e:	df843583          	ld	a1,-520(s0)
    80004282:	158a8513          	addi	a0,s5,344
    80004286:	ffffc097          	auipc	ra,0xffffc
    8000428a:	044080e7          	jalr	68(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000428e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004292:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004296:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000429a:	058ab783          	ld	a5,88(s5)
    8000429e:	e6843703          	ld	a4,-408(s0)
    800042a2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042a4:	058ab783          	ld	a5,88(s5)
    800042a8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042ac:	85ea                	mv	a1,s10
    800042ae:	ffffd097          	auipc	ra,0xffffd
    800042b2:	d0a080e7          	jalr	-758(ra) # 80000fb8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042b6:	0004851b          	sext.w	a0,s1
    800042ba:	bbd9                	j	80004090 <exec+0x98>
    800042bc:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800042c0:	e0843583          	ld	a1,-504(s0)
    800042c4:	855e                	mv	a0,s7
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	cf2080e7          	jalr	-782(ra) # 80000fb8 <proc_freepagetable>
  if(ip){
    800042ce:	da0497e3          	bnez	s1,8000407c <exec+0x84>
  return -1;
    800042d2:	557d                	li	a0,-1
    800042d4:	bb75                	j	80004090 <exec+0x98>
    800042d6:	e1443423          	sd	s4,-504(s0)
    800042da:	b7dd                	j	800042c0 <exec+0x2c8>
    800042dc:	e1443423          	sd	s4,-504(s0)
    800042e0:	b7c5                	j	800042c0 <exec+0x2c8>
    800042e2:	e1443423          	sd	s4,-504(s0)
    800042e6:	bfe9                	j	800042c0 <exec+0x2c8>
    800042e8:	e1443423          	sd	s4,-504(s0)
    800042ec:	bfd1                	j	800042c0 <exec+0x2c8>
  sz = sz1;
    800042ee:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042f2:	4481                	li	s1,0
    800042f4:	b7f1                	j	800042c0 <exec+0x2c8>
  sz = sz1;
    800042f6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042fa:	4481                	li	s1,0
    800042fc:	b7d1                	j	800042c0 <exec+0x2c8>
  sz = sz1;
    800042fe:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004302:	4481                	li	s1,0
    80004304:	bf75                	j	800042c0 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004306:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000430a:	2b05                	addiw	s6,s6,1
    8000430c:	0389899b          	addiw	s3,s3,56
    80004310:	e8845783          	lhu	a5,-376(s0)
    80004314:	e2fb57e3          	bge	s6,a5,80004142 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004318:	2981                	sext.w	s3,s3
    8000431a:	03800713          	li	a4,56
    8000431e:	86ce                	mv	a3,s3
    80004320:	e1840613          	addi	a2,s0,-488
    80004324:	4581                	li	a1,0
    80004326:	8526                	mv	a0,s1
    80004328:	fffff097          	auipc	ra,0xfffff
    8000432c:	a6e080e7          	jalr	-1426(ra) # 80002d96 <readi>
    80004330:	03800793          	li	a5,56
    80004334:	f8f514e3          	bne	a0,a5,800042bc <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004338:	e1842783          	lw	a5,-488(s0)
    8000433c:	4705                	li	a4,1
    8000433e:	fce796e3          	bne	a5,a4,8000430a <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004342:	e4043903          	ld	s2,-448(s0)
    80004346:	e3843783          	ld	a5,-456(s0)
    8000434a:	f8f966e3          	bltu	s2,a5,800042d6 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000434e:	e2843783          	ld	a5,-472(s0)
    80004352:	993e                	add	s2,s2,a5
    80004354:	f8f964e3          	bltu	s2,a5,800042dc <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004358:	df043703          	ld	a4,-528(s0)
    8000435c:	8ff9                	and	a5,a5,a4
    8000435e:	f3d1                	bnez	a5,800042e2 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004360:	e1c42503          	lw	a0,-484(s0)
    80004364:	00000097          	auipc	ra,0x0
    80004368:	c78080e7          	jalr	-904(ra) # 80003fdc <flags2perm>
    8000436c:	86aa                	mv	a3,a0
    8000436e:	864a                	mv	a2,s2
    80004370:	85d2                	mv	a1,s4
    80004372:	855e                	mv	a0,s7
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	54a080e7          	jalr	1354(ra) # 800008be <uvmalloc>
    8000437c:	e0a43423          	sd	a0,-504(s0)
    80004380:	d525                	beqz	a0,800042e8 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004382:	e2843d03          	ld	s10,-472(s0)
    80004386:	e2042d83          	lw	s11,-480(s0)
    8000438a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000438e:	f60c0ce3          	beqz	s8,80004306 <exec+0x30e>
    80004392:	8a62                	mv	s4,s8
    80004394:	4901                	li	s2,0
    80004396:	b369                	j	80004120 <exec+0x128>

0000000080004398 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004398:	7179                	addi	sp,sp,-48
    8000439a:	f406                	sd	ra,40(sp)
    8000439c:	f022                	sd	s0,32(sp)
    8000439e:	ec26                	sd	s1,24(sp)
    800043a0:	e84a                	sd	s2,16(sp)
    800043a2:	1800                	addi	s0,sp,48
    800043a4:	892e                	mv	s2,a1
    800043a6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800043a8:	fdc40593          	addi	a1,s0,-36
    800043ac:	ffffe097          	auipc	ra,0xffffe
    800043b0:	bbc080e7          	jalr	-1092(ra) # 80001f68 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043b4:	fdc42703          	lw	a4,-36(s0)
    800043b8:	47bd                	li	a5,15
    800043ba:	02e7eb63          	bltu	a5,a4,800043f0 <argfd+0x58>
    800043be:	ffffd097          	auipc	ra,0xffffd
    800043c2:	a9a080e7          	jalr	-1382(ra) # 80000e58 <myproc>
    800043c6:	fdc42703          	lw	a4,-36(s0)
    800043ca:	01a70793          	addi	a5,a4,26
    800043ce:	078e                	slli	a5,a5,0x3
    800043d0:	953e                	add	a0,a0,a5
    800043d2:	611c                	ld	a5,0(a0)
    800043d4:	c385                	beqz	a5,800043f4 <argfd+0x5c>
    return -1;
  if(pfd)
    800043d6:	00090463          	beqz	s2,800043de <argfd+0x46>
    *pfd = fd;
    800043da:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043de:	4501                	li	a0,0
  if(pf)
    800043e0:	c091                	beqz	s1,800043e4 <argfd+0x4c>
    *pf = f;
    800043e2:	e09c                	sd	a5,0(s1)
}
    800043e4:	70a2                	ld	ra,40(sp)
    800043e6:	7402                	ld	s0,32(sp)
    800043e8:	64e2                	ld	s1,24(sp)
    800043ea:	6942                	ld	s2,16(sp)
    800043ec:	6145                	addi	sp,sp,48
    800043ee:	8082                	ret
    return -1;
    800043f0:	557d                	li	a0,-1
    800043f2:	bfcd                	j	800043e4 <argfd+0x4c>
    800043f4:	557d                	li	a0,-1
    800043f6:	b7fd                	j	800043e4 <argfd+0x4c>

00000000800043f8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043f8:	1101                	addi	sp,sp,-32
    800043fa:	ec06                	sd	ra,24(sp)
    800043fc:	e822                	sd	s0,16(sp)
    800043fe:	e426                	sd	s1,8(sp)
    80004400:	1000                	addi	s0,sp,32
    80004402:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	a54080e7          	jalr	-1452(ra) # 80000e58 <myproc>
    8000440c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000440e:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd3a0>
    80004412:	4501                	li	a0,0
    80004414:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004416:	6398                	ld	a4,0(a5)
    80004418:	cb19                	beqz	a4,8000442e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000441a:	2505                	addiw	a0,a0,1
    8000441c:	07a1                	addi	a5,a5,8
    8000441e:	fed51ce3          	bne	a0,a3,80004416 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004422:	557d                	li	a0,-1
}
    80004424:	60e2                	ld	ra,24(sp)
    80004426:	6442                	ld	s0,16(sp)
    80004428:	64a2                	ld	s1,8(sp)
    8000442a:	6105                	addi	sp,sp,32
    8000442c:	8082                	ret
      p->ofile[fd] = f;
    8000442e:	01a50793          	addi	a5,a0,26
    80004432:	078e                	slli	a5,a5,0x3
    80004434:	963e                	add	a2,a2,a5
    80004436:	e204                	sd	s1,0(a2)
      return fd;
    80004438:	b7f5                	j	80004424 <fdalloc+0x2c>

000000008000443a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000443a:	715d                	addi	sp,sp,-80
    8000443c:	e486                	sd	ra,72(sp)
    8000443e:	e0a2                	sd	s0,64(sp)
    80004440:	fc26                	sd	s1,56(sp)
    80004442:	f84a                	sd	s2,48(sp)
    80004444:	f44e                	sd	s3,40(sp)
    80004446:	f052                	sd	s4,32(sp)
    80004448:	ec56                	sd	s5,24(sp)
    8000444a:	e85a                	sd	s6,16(sp)
    8000444c:	0880                	addi	s0,sp,80
    8000444e:	8b2e                	mv	s6,a1
    80004450:	89b2                	mv	s3,a2
    80004452:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004454:	fb040593          	addi	a1,s0,-80
    80004458:	fffff097          	auipc	ra,0xfffff
    8000445c:	e4e080e7          	jalr	-434(ra) # 800032a6 <nameiparent>
    80004460:	84aa                	mv	s1,a0
    80004462:	16050063          	beqz	a0,800045c2 <create+0x188>
    return 0;

  ilock(dp);
    80004466:	ffffe097          	auipc	ra,0xffffe
    8000446a:	67c080e7          	jalr	1660(ra) # 80002ae2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000446e:	4601                	li	a2,0
    80004470:	fb040593          	addi	a1,s0,-80
    80004474:	8526                	mv	a0,s1
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	b50080e7          	jalr	-1200(ra) # 80002fc6 <dirlookup>
    8000447e:	8aaa                	mv	s5,a0
    80004480:	c931                	beqz	a0,800044d4 <create+0x9a>
    iunlockput(dp);
    80004482:	8526                	mv	a0,s1
    80004484:	fffff097          	auipc	ra,0xfffff
    80004488:	8c0080e7          	jalr	-1856(ra) # 80002d44 <iunlockput>
    ilock(ip);
    8000448c:	8556                	mv	a0,s5
    8000448e:	ffffe097          	auipc	ra,0xffffe
    80004492:	654080e7          	jalr	1620(ra) # 80002ae2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004496:	000b059b          	sext.w	a1,s6
    8000449a:	4789                	li	a5,2
    8000449c:	02f59563          	bne	a1,a5,800044c6 <create+0x8c>
    800044a0:	044ad783          	lhu	a5,68(s5)
    800044a4:	37f9                	addiw	a5,a5,-2
    800044a6:	17c2                	slli	a5,a5,0x30
    800044a8:	93c1                	srli	a5,a5,0x30
    800044aa:	4705                	li	a4,1
    800044ac:	00f76d63          	bltu	a4,a5,800044c6 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800044b0:	8556                	mv	a0,s5
    800044b2:	60a6                	ld	ra,72(sp)
    800044b4:	6406                	ld	s0,64(sp)
    800044b6:	74e2                	ld	s1,56(sp)
    800044b8:	7942                	ld	s2,48(sp)
    800044ba:	79a2                	ld	s3,40(sp)
    800044bc:	7a02                	ld	s4,32(sp)
    800044be:	6ae2                	ld	s5,24(sp)
    800044c0:	6b42                	ld	s6,16(sp)
    800044c2:	6161                	addi	sp,sp,80
    800044c4:	8082                	ret
    iunlockput(ip);
    800044c6:	8556                	mv	a0,s5
    800044c8:	fffff097          	auipc	ra,0xfffff
    800044cc:	87c080e7          	jalr	-1924(ra) # 80002d44 <iunlockput>
    return 0;
    800044d0:	4a81                	li	s5,0
    800044d2:	bff9                	j	800044b0 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800044d4:	85da                	mv	a1,s6
    800044d6:	4088                	lw	a0,0(s1)
    800044d8:	ffffe097          	auipc	ra,0xffffe
    800044dc:	46e080e7          	jalr	1134(ra) # 80002946 <ialloc>
    800044e0:	8a2a                	mv	s4,a0
    800044e2:	c921                	beqz	a0,80004532 <create+0xf8>
  ilock(ip);
    800044e4:	ffffe097          	auipc	ra,0xffffe
    800044e8:	5fe080e7          	jalr	1534(ra) # 80002ae2 <ilock>
  ip->major = major;
    800044ec:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800044f0:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800044f4:	4785                	li	a5,1
    800044f6:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800044fa:	8552                	mv	a0,s4
    800044fc:	ffffe097          	auipc	ra,0xffffe
    80004500:	51c080e7          	jalr	1308(ra) # 80002a18 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004504:	000b059b          	sext.w	a1,s6
    80004508:	4785                	li	a5,1
    8000450a:	02f58b63          	beq	a1,a5,80004540 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000450e:	004a2603          	lw	a2,4(s4)
    80004512:	fb040593          	addi	a1,s0,-80
    80004516:	8526                	mv	a0,s1
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	cbe080e7          	jalr	-834(ra) # 800031d6 <dirlink>
    80004520:	06054f63          	bltz	a0,8000459e <create+0x164>
  iunlockput(dp);
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	81e080e7          	jalr	-2018(ra) # 80002d44 <iunlockput>
  return ip;
    8000452e:	8ad2                	mv	s5,s4
    80004530:	b741                	j	800044b0 <create+0x76>
    iunlockput(dp);
    80004532:	8526                	mv	a0,s1
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	810080e7          	jalr	-2032(ra) # 80002d44 <iunlockput>
    return 0;
    8000453c:	8ad2                	mv	s5,s4
    8000453e:	bf8d                	j	800044b0 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004540:	004a2603          	lw	a2,4(s4)
    80004544:	00004597          	auipc	a1,0x4
    80004548:	12c58593          	addi	a1,a1,300 # 80008670 <syscalls+0x2a0>
    8000454c:	8552                	mv	a0,s4
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	c88080e7          	jalr	-888(ra) # 800031d6 <dirlink>
    80004556:	04054463          	bltz	a0,8000459e <create+0x164>
    8000455a:	40d0                	lw	a2,4(s1)
    8000455c:	00004597          	auipc	a1,0x4
    80004560:	11c58593          	addi	a1,a1,284 # 80008678 <syscalls+0x2a8>
    80004564:	8552                	mv	a0,s4
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	c70080e7          	jalr	-912(ra) # 800031d6 <dirlink>
    8000456e:	02054863          	bltz	a0,8000459e <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004572:	004a2603          	lw	a2,4(s4)
    80004576:	fb040593          	addi	a1,s0,-80
    8000457a:	8526                	mv	a0,s1
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	c5a080e7          	jalr	-934(ra) # 800031d6 <dirlink>
    80004584:	00054d63          	bltz	a0,8000459e <create+0x164>
    dp->nlink++;  // for ".."
    80004588:	04a4d783          	lhu	a5,74(s1)
    8000458c:	2785                	addiw	a5,a5,1
    8000458e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004592:	8526                	mv	a0,s1
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	484080e7          	jalr	1156(ra) # 80002a18 <iupdate>
    8000459c:	b761                	j	80004524 <create+0xea>
  ip->nlink = 0;
    8000459e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800045a2:	8552                	mv	a0,s4
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	474080e7          	jalr	1140(ra) # 80002a18 <iupdate>
  iunlockput(ip);
    800045ac:	8552                	mv	a0,s4
    800045ae:	ffffe097          	auipc	ra,0xffffe
    800045b2:	796080e7          	jalr	1942(ra) # 80002d44 <iunlockput>
  iunlockput(dp);
    800045b6:	8526                	mv	a0,s1
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	78c080e7          	jalr	1932(ra) # 80002d44 <iunlockput>
  return 0;
    800045c0:	bdc5                	j	800044b0 <create+0x76>
    return 0;
    800045c2:	8aaa                	mv	s5,a0
    800045c4:	b5f5                	j	800044b0 <create+0x76>

00000000800045c6 <sys_dup>:
{
    800045c6:	7179                	addi	sp,sp,-48
    800045c8:	f406                	sd	ra,40(sp)
    800045ca:	f022                	sd	s0,32(sp)
    800045cc:	ec26                	sd	s1,24(sp)
    800045ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045d0:	fd840613          	addi	a2,s0,-40
    800045d4:	4581                	li	a1,0
    800045d6:	4501                	li	a0,0
    800045d8:	00000097          	auipc	ra,0x0
    800045dc:	dc0080e7          	jalr	-576(ra) # 80004398 <argfd>
    return -1;
    800045e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045e2:	02054363          	bltz	a0,80004608 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045e6:	fd843503          	ld	a0,-40(s0)
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	e0e080e7          	jalr	-498(ra) # 800043f8 <fdalloc>
    800045f2:	84aa                	mv	s1,a0
    return -1;
    800045f4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045f6:	00054963          	bltz	a0,80004608 <sys_dup+0x42>
  filedup(f);
    800045fa:	fd843503          	ld	a0,-40(s0)
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	320080e7          	jalr	800(ra) # 8000391e <filedup>
  return fd;
    80004606:	87a6                	mv	a5,s1
}
    80004608:	853e                	mv	a0,a5
    8000460a:	70a2                	ld	ra,40(sp)
    8000460c:	7402                	ld	s0,32(sp)
    8000460e:	64e2                	ld	s1,24(sp)
    80004610:	6145                	addi	sp,sp,48
    80004612:	8082                	ret

0000000080004614 <sys_read>:
{
    80004614:	7179                	addi	sp,sp,-48
    80004616:	f406                	sd	ra,40(sp)
    80004618:	f022                	sd	s0,32(sp)
    8000461a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000461c:	fd840593          	addi	a1,s0,-40
    80004620:	4505                	li	a0,1
    80004622:	ffffe097          	auipc	ra,0xffffe
    80004626:	966080e7          	jalr	-1690(ra) # 80001f88 <argaddr>
  argint(2, &n);
    8000462a:	fe440593          	addi	a1,s0,-28
    8000462e:	4509                	li	a0,2
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	938080e7          	jalr	-1736(ra) # 80001f68 <argint>
  if(argfd(0, 0, &f) < 0)
    80004638:	fe840613          	addi	a2,s0,-24
    8000463c:	4581                	li	a1,0
    8000463e:	4501                	li	a0,0
    80004640:	00000097          	auipc	ra,0x0
    80004644:	d58080e7          	jalr	-680(ra) # 80004398 <argfd>
    80004648:	87aa                	mv	a5,a0
    return -1;
    8000464a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000464c:	0007cc63          	bltz	a5,80004664 <sys_read+0x50>
  return fileread(f, p, n);
    80004650:	fe442603          	lw	a2,-28(s0)
    80004654:	fd843583          	ld	a1,-40(s0)
    80004658:	fe843503          	ld	a0,-24(s0)
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	44e080e7          	jalr	1102(ra) # 80003aaa <fileread>
}
    80004664:	70a2                	ld	ra,40(sp)
    80004666:	7402                	ld	s0,32(sp)
    80004668:	6145                	addi	sp,sp,48
    8000466a:	8082                	ret

000000008000466c <sys_write>:
{
    8000466c:	7179                	addi	sp,sp,-48
    8000466e:	f406                	sd	ra,40(sp)
    80004670:	f022                	sd	s0,32(sp)
    80004672:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004674:	fd840593          	addi	a1,s0,-40
    80004678:	4505                	li	a0,1
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	90e080e7          	jalr	-1778(ra) # 80001f88 <argaddr>
  argint(2, &n);
    80004682:	fe440593          	addi	a1,s0,-28
    80004686:	4509                	li	a0,2
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	8e0080e7          	jalr	-1824(ra) # 80001f68 <argint>
  if(argfd(0, 0, &f) < 0)
    80004690:	fe840613          	addi	a2,s0,-24
    80004694:	4581                	li	a1,0
    80004696:	4501                	li	a0,0
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	d00080e7          	jalr	-768(ra) # 80004398 <argfd>
    800046a0:	87aa                	mv	a5,a0
    return -1;
    800046a2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046a4:	0007cc63          	bltz	a5,800046bc <sys_write+0x50>
  return filewrite(f, p, n);
    800046a8:	fe442603          	lw	a2,-28(s0)
    800046ac:	fd843583          	ld	a1,-40(s0)
    800046b0:	fe843503          	ld	a0,-24(s0)
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	4b8080e7          	jalr	1208(ra) # 80003b6c <filewrite>
}
    800046bc:	70a2                	ld	ra,40(sp)
    800046be:	7402                	ld	s0,32(sp)
    800046c0:	6145                	addi	sp,sp,48
    800046c2:	8082                	ret

00000000800046c4 <sys_close>:
{
    800046c4:	1101                	addi	sp,sp,-32
    800046c6:	ec06                	sd	ra,24(sp)
    800046c8:	e822                	sd	s0,16(sp)
    800046ca:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046cc:	fe040613          	addi	a2,s0,-32
    800046d0:	fec40593          	addi	a1,s0,-20
    800046d4:	4501                	li	a0,0
    800046d6:	00000097          	auipc	ra,0x0
    800046da:	cc2080e7          	jalr	-830(ra) # 80004398 <argfd>
    return -1;
    800046de:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046e0:	02054463          	bltz	a0,80004708 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	774080e7          	jalr	1908(ra) # 80000e58 <myproc>
    800046ec:	fec42783          	lw	a5,-20(s0)
    800046f0:	07e9                	addi	a5,a5,26
    800046f2:	078e                	slli	a5,a5,0x3
    800046f4:	97aa                	add	a5,a5,a0
    800046f6:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800046fa:	fe043503          	ld	a0,-32(s0)
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	272080e7          	jalr	626(ra) # 80003970 <fileclose>
  return 0;
    80004706:	4781                	li	a5,0
}
    80004708:	853e                	mv	a0,a5
    8000470a:	60e2                	ld	ra,24(sp)
    8000470c:	6442                	ld	s0,16(sp)
    8000470e:	6105                	addi	sp,sp,32
    80004710:	8082                	ret

0000000080004712 <sys_fstat>:
{
    80004712:	1101                	addi	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000471a:	fe040593          	addi	a1,s0,-32
    8000471e:	4505                	li	a0,1
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	868080e7          	jalr	-1944(ra) # 80001f88 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004728:	fe840613          	addi	a2,s0,-24
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	c68080e7          	jalr	-920(ra) # 80004398 <argfd>
    80004738:	87aa                	mv	a5,a0
    return -1;
    8000473a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000473c:	0007ca63          	bltz	a5,80004750 <sys_fstat+0x3e>
  return filestat(f, st);
    80004740:	fe043583          	ld	a1,-32(s0)
    80004744:	fe843503          	ld	a0,-24(s0)
    80004748:	fffff097          	auipc	ra,0xfffff
    8000474c:	2f0080e7          	jalr	752(ra) # 80003a38 <filestat>
}
    80004750:	60e2                	ld	ra,24(sp)
    80004752:	6442                	ld	s0,16(sp)
    80004754:	6105                	addi	sp,sp,32
    80004756:	8082                	ret

0000000080004758 <sys_link>:
{
    80004758:	7169                	addi	sp,sp,-304
    8000475a:	f606                	sd	ra,296(sp)
    8000475c:	f222                	sd	s0,288(sp)
    8000475e:	ee26                	sd	s1,280(sp)
    80004760:	ea4a                	sd	s2,272(sp)
    80004762:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004764:	08000613          	li	a2,128
    80004768:	ed040593          	addi	a1,s0,-304
    8000476c:	4501                	li	a0,0
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	83a080e7          	jalr	-1990(ra) # 80001fa8 <argstr>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004778:	10054e63          	bltz	a0,80004894 <sys_link+0x13c>
    8000477c:	08000613          	li	a2,128
    80004780:	f5040593          	addi	a1,s0,-176
    80004784:	4505                	li	a0,1
    80004786:	ffffe097          	auipc	ra,0xffffe
    8000478a:	822080e7          	jalr	-2014(ra) # 80001fa8 <argstr>
    return -1;
    8000478e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004790:	10054263          	bltz	a0,80004894 <sys_link+0x13c>
  begin_op();
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	d10080e7          	jalr	-752(ra) # 800034a4 <begin_op>
  if((ip = namei(old)) == 0){
    8000479c:	ed040513          	addi	a0,s0,-304
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	ae8080e7          	jalr	-1304(ra) # 80003288 <namei>
    800047a8:	84aa                	mv	s1,a0
    800047aa:	c551                	beqz	a0,80004836 <sys_link+0xde>
  ilock(ip);
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	336080e7          	jalr	822(ra) # 80002ae2 <ilock>
  if(ip->type == T_DIR){
    800047b4:	04449703          	lh	a4,68(s1)
    800047b8:	4785                	li	a5,1
    800047ba:	08f70463          	beq	a4,a5,80004842 <sys_link+0xea>
  ip->nlink++;
    800047be:	04a4d783          	lhu	a5,74(s1)
    800047c2:	2785                	addiw	a5,a5,1
    800047c4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047c8:	8526                	mv	a0,s1
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	24e080e7          	jalr	590(ra) # 80002a18 <iupdate>
  iunlock(ip);
    800047d2:	8526                	mv	a0,s1
    800047d4:	ffffe097          	auipc	ra,0xffffe
    800047d8:	3d0080e7          	jalr	976(ra) # 80002ba4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047dc:	fd040593          	addi	a1,s0,-48
    800047e0:	f5040513          	addi	a0,s0,-176
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	ac2080e7          	jalr	-1342(ra) # 800032a6 <nameiparent>
    800047ec:	892a                	mv	s2,a0
    800047ee:	c935                	beqz	a0,80004862 <sys_link+0x10a>
  ilock(dp);
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	2f2080e7          	jalr	754(ra) # 80002ae2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047f8:	00092703          	lw	a4,0(s2)
    800047fc:	409c                	lw	a5,0(s1)
    800047fe:	04f71d63          	bne	a4,a5,80004858 <sys_link+0x100>
    80004802:	40d0                	lw	a2,4(s1)
    80004804:	fd040593          	addi	a1,s0,-48
    80004808:	854a                	mv	a0,s2
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	9cc080e7          	jalr	-1588(ra) # 800031d6 <dirlink>
    80004812:	04054363          	bltz	a0,80004858 <sys_link+0x100>
  iunlockput(dp);
    80004816:	854a                	mv	a0,s2
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	52c080e7          	jalr	1324(ra) # 80002d44 <iunlockput>
  iput(ip);
    80004820:	8526                	mv	a0,s1
    80004822:	ffffe097          	auipc	ra,0xffffe
    80004826:	47a080e7          	jalr	1146(ra) # 80002c9c <iput>
  end_op();
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	cfa080e7          	jalr	-774(ra) # 80003524 <end_op>
  return 0;
    80004832:	4781                	li	a5,0
    80004834:	a085                	j	80004894 <sys_link+0x13c>
    end_op();
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	cee080e7          	jalr	-786(ra) # 80003524 <end_op>
    return -1;
    8000483e:	57fd                	li	a5,-1
    80004840:	a891                	j	80004894 <sys_link+0x13c>
    iunlockput(ip);
    80004842:	8526                	mv	a0,s1
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	500080e7          	jalr	1280(ra) # 80002d44 <iunlockput>
    end_op();
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	cd8080e7          	jalr	-808(ra) # 80003524 <end_op>
    return -1;
    80004854:	57fd                	li	a5,-1
    80004856:	a83d                	j	80004894 <sys_link+0x13c>
    iunlockput(dp);
    80004858:	854a                	mv	a0,s2
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	4ea080e7          	jalr	1258(ra) # 80002d44 <iunlockput>
  ilock(ip);
    80004862:	8526                	mv	a0,s1
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	27e080e7          	jalr	638(ra) # 80002ae2 <ilock>
  ip->nlink--;
    8000486c:	04a4d783          	lhu	a5,74(s1)
    80004870:	37fd                	addiw	a5,a5,-1
    80004872:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004876:	8526                	mv	a0,s1
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	1a0080e7          	jalr	416(ra) # 80002a18 <iupdate>
  iunlockput(ip);
    80004880:	8526                	mv	a0,s1
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	4c2080e7          	jalr	1218(ra) # 80002d44 <iunlockput>
  end_op();
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	c9a080e7          	jalr	-870(ra) # 80003524 <end_op>
  return -1;
    80004892:	57fd                	li	a5,-1
}
    80004894:	853e                	mv	a0,a5
    80004896:	70b2                	ld	ra,296(sp)
    80004898:	7412                	ld	s0,288(sp)
    8000489a:	64f2                	ld	s1,280(sp)
    8000489c:	6952                	ld	s2,272(sp)
    8000489e:	6155                	addi	sp,sp,304
    800048a0:	8082                	ret

00000000800048a2 <sys_unlink>:
{
    800048a2:	7151                	addi	sp,sp,-240
    800048a4:	f586                	sd	ra,232(sp)
    800048a6:	f1a2                	sd	s0,224(sp)
    800048a8:	eda6                	sd	s1,216(sp)
    800048aa:	e9ca                	sd	s2,208(sp)
    800048ac:	e5ce                	sd	s3,200(sp)
    800048ae:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048b0:	08000613          	li	a2,128
    800048b4:	f3040593          	addi	a1,s0,-208
    800048b8:	4501                	li	a0,0
    800048ba:	ffffd097          	auipc	ra,0xffffd
    800048be:	6ee080e7          	jalr	1774(ra) # 80001fa8 <argstr>
    800048c2:	18054163          	bltz	a0,80004a44 <sys_unlink+0x1a2>
  begin_op();
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	bde080e7          	jalr	-1058(ra) # 800034a4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048ce:	fb040593          	addi	a1,s0,-80
    800048d2:	f3040513          	addi	a0,s0,-208
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	9d0080e7          	jalr	-1584(ra) # 800032a6 <nameiparent>
    800048de:	84aa                	mv	s1,a0
    800048e0:	c979                	beqz	a0,800049b6 <sys_unlink+0x114>
  ilock(dp);
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	200080e7          	jalr	512(ra) # 80002ae2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048ea:	00004597          	auipc	a1,0x4
    800048ee:	d8658593          	addi	a1,a1,-634 # 80008670 <syscalls+0x2a0>
    800048f2:	fb040513          	addi	a0,s0,-80
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	6b6080e7          	jalr	1718(ra) # 80002fac <namecmp>
    800048fe:	14050a63          	beqz	a0,80004a52 <sys_unlink+0x1b0>
    80004902:	00004597          	auipc	a1,0x4
    80004906:	d7658593          	addi	a1,a1,-650 # 80008678 <syscalls+0x2a8>
    8000490a:	fb040513          	addi	a0,s0,-80
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	69e080e7          	jalr	1694(ra) # 80002fac <namecmp>
    80004916:	12050e63          	beqz	a0,80004a52 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000491a:	f2c40613          	addi	a2,s0,-212
    8000491e:	fb040593          	addi	a1,s0,-80
    80004922:	8526                	mv	a0,s1
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	6a2080e7          	jalr	1698(ra) # 80002fc6 <dirlookup>
    8000492c:	892a                	mv	s2,a0
    8000492e:	12050263          	beqz	a0,80004a52 <sys_unlink+0x1b0>
  ilock(ip);
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	1b0080e7          	jalr	432(ra) # 80002ae2 <ilock>
  if(ip->nlink < 1)
    8000493a:	04a91783          	lh	a5,74(s2)
    8000493e:	08f05263          	blez	a5,800049c2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004942:	04491703          	lh	a4,68(s2)
    80004946:	4785                	li	a5,1
    80004948:	08f70563          	beq	a4,a5,800049d2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000494c:	4641                	li	a2,16
    8000494e:	4581                	li	a1,0
    80004950:	fc040513          	addi	a0,s0,-64
    80004954:	ffffc097          	auipc	ra,0xffffc
    80004958:	824080e7          	jalr	-2012(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000495c:	4741                	li	a4,16
    8000495e:	f2c42683          	lw	a3,-212(s0)
    80004962:	fc040613          	addi	a2,s0,-64
    80004966:	4581                	li	a1,0
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	524080e7          	jalr	1316(ra) # 80002e8e <writei>
    80004972:	47c1                	li	a5,16
    80004974:	0af51563          	bne	a0,a5,80004a1e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004978:	04491703          	lh	a4,68(s2)
    8000497c:	4785                	li	a5,1
    8000497e:	0af70863          	beq	a4,a5,80004a2e <sys_unlink+0x18c>
  iunlockput(dp);
    80004982:	8526                	mv	a0,s1
    80004984:	ffffe097          	auipc	ra,0xffffe
    80004988:	3c0080e7          	jalr	960(ra) # 80002d44 <iunlockput>
  ip->nlink--;
    8000498c:	04a95783          	lhu	a5,74(s2)
    80004990:	37fd                	addiw	a5,a5,-1
    80004992:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004996:	854a                	mv	a0,s2
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	080080e7          	jalr	128(ra) # 80002a18 <iupdate>
  iunlockput(ip);
    800049a0:	854a                	mv	a0,s2
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	3a2080e7          	jalr	930(ra) # 80002d44 <iunlockput>
  end_op();
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	b7a080e7          	jalr	-1158(ra) # 80003524 <end_op>
  return 0;
    800049b2:	4501                	li	a0,0
    800049b4:	a84d                	j	80004a66 <sys_unlink+0x1c4>
    end_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	b6e080e7          	jalr	-1170(ra) # 80003524 <end_op>
    return -1;
    800049be:	557d                	li	a0,-1
    800049c0:	a05d                	j	80004a66 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049c2:	00004517          	auipc	a0,0x4
    800049c6:	cbe50513          	addi	a0,a0,-834 # 80008680 <syscalls+0x2b0>
    800049ca:	00001097          	auipc	ra,0x1
    800049ce:	218080e7          	jalr	536(ra) # 80005be2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049d2:	04c92703          	lw	a4,76(s2)
    800049d6:	02000793          	li	a5,32
    800049da:	f6e7f9e3          	bgeu	a5,a4,8000494c <sys_unlink+0xaa>
    800049de:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049e2:	4741                	li	a4,16
    800049e4:	86ce                	mv	a3,s3
    800049e6:	f1840613          	addi	a2,s0,-232
    800049ea:	4581                	li	a1,0
    800049ec:	854a                	mv	a0,s2
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	3a8080e7          	jalr	936(ra) # 80002d96 <readi>
    800049f6:	47c1                	li	a5,16
    800049f8:	00f51b63          	bne	a0,a5,80004a0e <sys_unlink+0x16c>
    if(de.inum != 0)
    800049fc:	f1845783          	lhu	a5,-232(s0)
    80004a00:	e7a1                	bnez	a5,80004a48 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a02:	29c1                	addiw	s3,s3,16
    80004a04:	04c92783          	lw	a5,76(s2)
    80004a08:	fcf9ede3          	bltu	s3,a5,800049e2 <sys_unlink+0x140>
    80004a0c:	b781                	j	8000494c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a0e:	00004517          	auipc	a0,0x4
    80004a12:	c8a50513          	addi	a0,a0,-886 # 80008698 <syscalls+0x2c8>
    80004a16:	00001097          	auipc	ra,0x1
    80004a1a:	1cc080e7          	jalr	460(ra) # 80005be2 <panic>
    panic("unlink: writei");
    80004a1e:	00004517          	auipc	a0,0x4
    80004a22:	c9250513          	addi	a0,a0,-878 # 800086b0 <syscalls+0x2e0>
    80004a26:	00001097          	auipc	ra,0x1
    80004a2a:	1bc080e7          	jalr	444(ra) # 80005be2 <panic>
    dp->nlink--;
    80004a2e:	04a4d783          	lhu	a5,74(s1)
    80004a32:	37fd                	addiw	a5,a5,-1
    80004a34:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	fde080e7          	jalr	-34(ra) # 80002a18 <iupdate>
    80004a42:	b781                	j	80004982 <sys_unlink+0xe0>
    return -1;
    80004a44:	557d                	li	a0,-1
    80004a46:	a005                	j	80004a66 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a48:	854a                	mv	a0,s2
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	2fa080e7          	jalr	762(ra) # 80002d44 <iunlockput>
  iunlockput(dp);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	2f0080e7          	jalr	752(ra) # 80002d44 <iunlockput>
  end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	ac8080e7          	jalr	-1336(ra) # 80003524 <end_op>
  return -1;
    80004a64:	557d                	li	a0,-1
}
    80004a66:	70ae                	ld	ra,232(sp)
    80004a68:	740e                	ld	s0,224(sp)
    80004a6a:	64ee                	ld	s1,216(sp)
    80004a6c:	694e                	ld	s2,208(sp)
    80004a6e:	69ae                	ld	s3,200(sp)
    80004a70:	616d                	addi	sp,sp,240
    80004a72:	8082                	ret

0000000080004a74 <sys_open>:

uint64
sys_open(void)
{
    80004a74:	7131                	addi	sp,sp,-192
    80004a76:	fd06                	sd	ra,184(sp)
    80004a78:	f922                	sd	s0,176(sp)
    80004a7a:	f526                	sd	s1,168(sp)
    80004a7c:	f14a                	sd	s2,160(sp)
    80004a7e:	ed4e                	sd	s3,152(sp)
    80004a80:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a82:	f4c40593          	addi	a1,s0,-180
    80004a86:	4505                	li	a0,1
    80004a88:	ffffd097          	auipc	ra,0xffffd
    80004a8c:	4e0080e7          	jalr	1248(ra) # 80001f68 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a90:	08000613          	li	a2,128
    80004a94:	f5040593          	addi	a1,s0,-176
    80004a98:	4501                	li	a0,0
    80004a9a:	ffffd097          	auipc	ra,0xffffd
    80004a9e:	50e080e7          	jalr	1294(ra) # 80001fa8 <argstr>
    80004aa2:	87aa                	mv	a5,a0
    return -1;
    80004aa4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004aa6:	0a07c963          	bltz	a5,80004b58 <sys_open+0xe4>

  begin_op();
    80004aaa:	fffff097          	auipc	ra,0xfffff
    80004aae:	9fa080e7          	jalr	-1542(ra) # 800034a4 <begin_op>

  if(omode & O_CREATE){
    80004ab2:	f4c42783          	lw	a5,-180(s0)
    80004ab6:	2007f793          	andi	a5,a5,512
    80004aba:	cfc5                	beqz	a5,80004b72 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004abc:	4681                	li	a3,0
    80004abe:	4601                	li	a2,0
    80004ac0:	4589                	li	a1,2
    80004ac2:	f5040513          	addi	a0,s0,-176
    80004ac6:	00000097          	auipc	ra,0x0
    80004aca:	974080e7          	jalr	-1676(ra) # 8000443a <create>
    80004ace:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ad0:	c959                	beqz	a0,80004b66 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ad2:	04449703          	lh	a4,68(s1)
    80004ad6:	478d                	li	a5,3
    80004ad8:	00f71763          	bne	a4,a5,80004ae6 <sys_open+0x72>
    80004adc:	0464d703          	lhu	a4,70(s1)
    80004ae0:	47a5                	li	a5,9
    80004ae2:	0ce7ed63          	bltu	a5,a4,80004bbc <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	dce080e7          	jalr	-562(ra) # 800038b4 <filealloc>
    80004aee:	89aa                	mv	s3,a0
    80004af0:	10050363          	beqz	a0,80004bf6 <sys_open+0x182>
    80004af4:	00000097          	auipc	ra,0x0
    80004af8:	904080e7          	jalr	-1788(ra) # 800043f8 <fdalloc>
    80004afc:	892a                	mv	s2,a0
    80004afe:	0e054763          	bltz	a0,80004bec <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b02:	04449703          	lh	a4,68(s1)
    80004b06:	478d                	li	a5,3
    80004b08:	0cf70563          	beq	a4,a5,80004bd2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b0c:	4789                	li	a5,2
    80004b0e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b12:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b16:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b1a:	f4c42783          	lw	a5,-180(s0)
    80004b1e:	0017c713          	xori	a4,a5,1
    80004b22:	8b05                	andi	a4,a4,1
    80004b24:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b28:	0037f713          	andi	a4,a5,3
    80004b2c:	00e03733          	snez	a4,a4
    80004b30:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b34:	4007f793          	andi	a5,a5,1024
    80004b38:	c791                	beqz	a5,80004b44 <sys_open+0xd0>
    80004b3a:	04449703          	lh	a4,68(s1)
    80004b3e:	4789                	li	a5,2
    80004b40:	0af70063          	beq	a4,a5,80004be0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	05e080e7          	jalr	94(ra) # 80002ba4 <iunlock>
  end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	9d6080e7          	jalr	-1578(ra) # 80003524 <end_op>

  return fd;
    80004b56:	854a                	mv	a0,s2
}
    80004b58:	70ea                	ld	ra,184(sp)
    80004b5a:	744a                	ld	s0,176(sp)
    80004b5c:	74aa                	ld	s1,168(sp)
    80004b5e:	790a                	ld	s2,160(sp)
    80004b60:	69ea                	ld	s3,152(sp)
    80004b62:	6129                	addi	sp,sp,192
    80004b64:	8082                	ret
      end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	9be080e7          	jalr	-1602(ra) # 80003524 <end_op>
      return -1;
    80004b6e:	557d                	li	a0,-1
    80004b70:	b7e5                	j	80004b58 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b72:	f5040513          	addi	a0,s0,-176
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	712080e7          	jalr	1810(ra) # 80003288 <namei>
    80004b7e:	84aa                	mv	s1,a0
    80004b80:	c905                	beqz	a0,80004bb0 <sys_open+0x13c>
    ilock(ip);
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	f60080e7          	jalr	-160(ra) # 80002ae2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b8a:	04449703          	lh	a4,68(s1)
    80004b8e:	4785                	li	a5,1
    80004b90:	f4f711e3          	bne	a4,a5,80004ad2 <sys_open+0x5e>
    80004b94:	f4c42783          	lw	a5,-180(s0)
    80004b98:	d7b9                	beqz	a5,80004ae6 <sys_open+0x72>
      iunlockput(ip);
    80004b9a:	8526                	mv	a0,s1
    80004b9c:	ffffe097          	auipc	ra,0xffffe
    80004ba0:	1a8080e7          	jalr	424(ra) # 80002d44 <iunlockput>
      end_op();
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	980080e7          	jalr	-1664(ra) # 80003524 <end_op>
      return -1;
    80004bac:	557d                	li	a0,-1
    80004bae:	b76d                	j	80004b58 <sys_open+0xe4>
      end_op();
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	974080e7          	jalr	-1676(ra) # 80003524 <end_op>
      return -1;
    80004bb8:	557d                	li	a0,-1
    80004bba:	bf79                	j	80004b58 <sys_open+0xe4>
    iunlockput(ip);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	186080e7          	jalr	390(ra) # 80002d44 <iunlockput>
    end_op();
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	95e080e7          	jalr	-1698(ra) # 80003524 <end_op>
    return -1;
    80004bce:	557d                	li	a0,-1
    80004bd0:	b761                	j	80004b58 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004bd2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bd6:	04649783          	lh	a5,70(s1)
    80004bda:	02f99223          	sh	a5,36(s3)
    80004bde:	bf25                	j	80004b16 <sys_open+0xa2>
    itrunc(ip);
    80004be0:	8526                	mv	a0,s1
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	00e080e7          	jalr	14(ra) # 80002bf0 <itrunc>
    80004bea:	bfa9                	j	80004b44 <sys_open+0xd0>
      fileclose(f);
    80004bec:	854e                	mv	a0,s3
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	d82080e7          	jalr	-638(ra) # 80003970 <fileclose>
    iunlockput(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	14c080e7          	jalr	332(ra) # 80002d44 <iunlockput>
    end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	924080e7          	jalr	-1756(ra) # 80003524 <end_op>
    return -1;
    80004c08:	557d                	li	a0,-1
    80004c0a:	b7b9                	j	80004b58 <sys_open+0xe4>

0000000080004c0c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c0c:	7175                	addi	sp,sp,-144
    80004c0e:	e506                	sd	ra,136(sp)
    80004c10:	e122                	sd	s0,128(sp)
    80004c12:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	890080e7          	jalr	-1904(ra) # 800034a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c1c:	08000613          	li	a2,128
    80004c20:	f7040593          	addi	a1,s0,-144
    80004c24:	4501                	li	a0,0
    80004c26:	ffffd097          	auipc	ra,0xffffd
    80004c2a:	382080e7          	jalr	898(ra) # 80001fa8 <argstr>
    80004c2e:	02054963          	bltz	a0,80004c60 <sys_mkdir+0x54>
    80004c32:	4681                	li	a3,0
    80004c34:	4601                	li	a2,0
    80004c36:	4585                	li	a1,1
    80004c38:	f7040513          	addi	a0,s0,-144
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	7fe080e7          	jalr	2046(ra) # 8000443a <create>
    80004c44:	cd11                	beqz	a0,80004c60 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	0fe080e7          	jalr	254(ra) # 80002d44 <iunlockput>
  end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	8d6080e7          	jalr	-1834(ra) # 80003524 <end_op>
  return 0;
    80004c56:	4501                	li	a0,0
}
    80004c58:	60aa                	ld	ra,136(sp)
    80004c5a:	640a                	ld	s0,128(sp)
    80004c5c:	6149                	addi	sp,sp,144
    80004c5e:	8082                	ret
    end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	8c4080e7          	jalr	-1852(ra) # 80003524 <end_op>
    return -1;
    80004c68:	557d                	li	a0,-1
    80004c6a:	b7fd                	j	80004c58 <sys_mkdir+0x4c>

0000000080004c6c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c6c:	7135                	addi	sp,sp,-160
    80004c6e:	ed06                	sd	ra,152(sp)
    80004c70:	e922                	sd	s0,144(sp)
    80004c72:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	830080e7          	jalr	-2000(ra) # 800034a4 <begin_op>
  argint(1, &major);
    80004c7c:	f6c40593          	addi	a1,s0,-148
    80004c80:	4505                	li	a0,1
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	2e6080e7          	jalr	742(ra) # 80001f68 <argint>
  argint(2, &minor);
    80004c8a:	f6840593          	addi	a1,s0,-152
    80004c8e:	4509                	li	a0,2
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	2d8080e7          	jalr	728(ra) # 80001f68 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c98:	08000613          	li	a2,128
    80004c9c:	f7040593          	addi	a1,s0,-144
    80004ca0:	4501                	li	a0,0
    80004ca2:	ffffd097          	auipc	ra,0xffffd
    80004ca6:	306080e7          	jalr	774(ra) # 80001fa8 <argstr>
    80004caa:	02054b63          	bltz	a0,80004ce0 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cae:	f6841683          	lh	a3,-152(s0)
    80004cb2:	f6c41603          	lh	a2,-148(s0)
    80004cb6:	458d                	li	a1,3
    80004cb8:	f7040513          	addi	a0,s0,-144
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	77e080e7          	jalr	1918(ra) # 8000443a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cc4:	cd11                	beqz	a0,80004ce0 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	07e080e7          	jalr	126(ra) # 80002d44 <iunlockput>
  end_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	856080e7          	jalr	-1962(ra) # 80003524 <end_op>
  return 0;
    80004cd6:	4501                	li	a0,0
}
    80004cd8:	60ea                	ld	ra,152(sp)
    80004cda:	644a                	ld	s0,144(sp)
    80004cdc:	610d                	addi	sp,sp,160
    80004cde:	8082                	ret
    end_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	844080e7          	jalr	-1980(ra) # 80003524 <end_op>
    return -1;
    80004ce8:	557d                	li	a0,-1
    80004cea:	b7fd                	j	80004cd8 <sys_mknod+0x6c>

0000000080004cec <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cec:	7135                	addi	sp,sp,-160
    80004cee:	ed06                	sd	ra,152(sp)
    80004cf0:	e922                	sd	s0,144(sp)
    80004cf2:	e526                	sd	s1,136(sp)
    80004cf4:	e14a                	sd	s2,128(sp)
    80004cf6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	160080e7          	jalr	352(ra) # 80000e58 <myproc>
    80004d00:	892a                	mv	s2,a0
  
  begin_op();
    80004d02:	ffffe097          	auipc	ra,0xffffe
    80004d06:	7a2080e7          	jalr	1954(ra) # 800034a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d0a:	08000613          	li	a2,128
    80004d0e:	f6040593          	addi	a1,s0,-160
    80004d12:	4501                	li	a0,0
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	294080e7          	jalr	660(ra) # 80001fa8 <argstr>
    80004d1c:	04054b63          	bltz	a0,80004d72 <sys_chdir+0x86>
    80004d20:	f6040513          	addi	a0,s0,-160
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	564080e7          	jalr	1380(ra) # 80003288 <namei>
    80004d2c:	84aa                	mv	s1,a0
    80004d2e:	c131                	beqz	a0,80004d72 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	db2080e7          	jalr	-590(ra) # 80002ae2 <ilock>
  if(ip->type != T_DIR){
    80004d38:	04449703          	lh	a4,68(s1)
    80004d3c:	4785                	li	a5,1
    80004d3e:	04f71063          	bne	a4,a5,80004d7e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	e60080e7          	jalr	-416(ra) # 80002ba4 <iunlock>
  iput(p->cwd);
    80004d4c:	15093503          	ld	a0,336(s2)
    80004d50:	ffffe097          	auipc	ra,0xffffe
    80004d54:	f4c080e7          	jalr	-180(ra) # 80002c9c <iput>
  end_op();
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	7cc080e7          	jalr	1996(ra) # 80003524 <end_op>
  p->cwd = ip;
    80004d60:	14993823          	sd	s1,336(s2)
  return 0;
    80004d64:	4501                	li	a0,0
}
    80004d66:	60ea                	ld	ra,152(sp)
    80004d68:	644a                	ld	s0,144(sp)
    80004d6a:	64aa                	ld	s1,136(sp)
    80004d6c:	690a                	ld	s2,128(sp)
    80004d6e:	610d                	addi	sp,sp,160
    80004d70:	8082                	ret
    end_op();
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	7b2080e7          	jalr	1970(ra) # 80003524 <end_op>
    return -1;
    80004d7a:	557d                	li	a0,-1
    80004d7c:	b7ed                	j	80004d66 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d7e:	8526                	mv	a0,s1
    80004d80:	ffffe097          	auipc	ra,0xffffe
    80004d84:	fc4080e7          	jalr	-60(ra) # 80002d44 <iunlockput>
    end_op();
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	79c080e7          	jalr	1948(ra) # 80003524 <end_op>
    return -1;
    80004d90:	557d                	li	a0,-1
    80004d92:	bfd1                	j	80004d66 <sys_chdir+0x7a>

0000000080004d94 <sys_exec>:

uint64
sys_exec(void)
{
    80004d94:	7145                	addi	sp,sp,-464
    80004d96:	e786                	sd	ra,456(sp)
    80004d98:	e3a2                	sd	s0,448(sp)
    80004d9a:	ff26                	sd	s1,440(sp)
    80004d9c:	fb4a                	sd	s2,432(sp)
    80004d9e:	f74e                	sd	s3,424(sp)
    80004da0:	f352                	sd	s4,416(sp)
    80004da2:	ef56                	sd	s5,408(sp)
    80004da4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004da6:	e3840593          	addi	a1,s0,-456
    80004daa:	4505                	li	a0,1
    80004dac:	ffffd097          	auipc	ra,0xffffd
    80004db0:	1dc080e7          	jalr	476(ra) # 80001f88 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004db4:	08000613          	li	a2,128
    80004db8:	f4040593          	addi	a1,s0,-192
    80004dbc:	4501                	li	a0,0
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	1ea080e7          	jalr	490(ra) # 80001fa8 <argstr>
    80004dc6:	87aa                	mv	a5,a0
    return -1;
    80004dc8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004dca:	0c07c263          	bltz	a5,80004e8e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004dce:	10000613          	li	a2,256
    80004dd2:	4581                	li	a1,0
    80004dd4:	e4040513          	addi	a0,s0,-448
    80004dd8:	ffffb097          	auipc	ra,0xffffb
    80004ddc:	3a0080e7          	jalr	928(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004de0:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004de4:	89a6                	mv	s3,s1
    80004de6:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004de8:	02000a13          	li	s4,32
    80004dec:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004df0:	00391513          	slli	a0,s2,0x3
    80004df4:	e3040593          	addi	a1,s0,-464
    80004df8:	e3843783          	ld	a5,-456(s0)
    80004dfc:	953e                	add	a0,a0,a5
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	0cc080e7          	jalr	204(ra) # 80001eca <fetchaddr>
    80004e06:	02054a63          	bltz	a0,80004e3a <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e0a:	e3043783          	ld	a5,-464(s0)
    80004e0e:	c3b9                	beqz	a5,80004e54 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e10:	ffffb097          	auipc	ra,0xffffb
    80004e14:	308080e7          	jalr	776(ra) # 80000118 <kalloc>
    80004e18:	85aa                	mv	a1,a0
    80004e1a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e1e:	cd11                	beqz	a0,80004e3a <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e20:	6605                	lui	a2,0x1
    80004e22:	e3043503          	ld	a0,-464(s0)
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	0f6080e7          	jalr	246(ra) # 80001f1c <fetchstr>
    80004e2e:	00054663          	bltz	a0,80004e3a <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004e32:	0905                	addi	s2,s2,1
    80004e34:	09a1                	addi	s3,s3,8
    80004e36:	fb491be3          	bne	s2,s4,80004dec <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e3a:	10048913          	addi	s2,s1,256
    80004e3e:	6088                	ld	a0,0(s1)
    80004e40:	c531                	beqz	a0,80004e8c <sys_exec+0xf8>
    kfree(argv[i]);
    80004e42:	ffffb097          	auipc	ra,0xffffb
    80004e46:	1da080e7          	jalr	474(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e4a:	04a1                	addi	s1,s1,8
    80004e4c:	ff2499e3          	bne	s1,s2,80004e3e <sys_exec+0xaa>
  return -1;
    80004e50:	557d                	li	a0,-1
    80004e52:	a835                	j	80004e8e <sys_exec+0xfa>
      argv[i] = 0;
    80004e54:	0a8e                	slli	s5,s5,0x3
    80004e56:	fc040793          	addi	a5,s0,-64
    80004e5a:	9abe                	add	s5,s5,a5
    80004e5c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e60:	e4040593          	addi	a1,s0,-448
    80004e64:	f4040513          	addi	a0,s0,-192
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	190080e7          	jalr	400(ra) # 80003ff8 <exec>
    80004e70:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e72:	10048993          	addi	s3,s1,256
    80004e76:	6088                	ld	a0,0(s1)
    80004e78:	c901                	beqz	a0,80004e88 <sys_exec+0xf4>
    kfree(argv[i]);
    80004e7a:	ffffb097          	auipc	ra,0xffffb
    80004e7e:	1a2080e7          	jalr	418(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e82:	04a1                	addi	s1,s1,8
    80004e84:	ff3499e3          	bne	s1,s3,80004e76 <sys_exec+0xe2>
  return ret;
    80004e88:	854a                	mv	a0,s2
    80004e8a:	a011                	j	80004e8e <sys_exec+0xfa>
  return -1;
    80004e8c:	557d                	li	a0,-1
}
    80004e8e:	60be                	ld	ra,456(sp)
    80004e90:	641e                	ld	s0,448(sp)
    80004e92:	74fa                	ld	s1,440(sp)
    80004e94:	795a                	ld	s2,432(sp)
    80004e96:	79ba                	ld	s3,424(sp)
    80004e98:	7a1a                	ld	s4,416(sp)
    80004e9a:	6afa                	ld	s5,408(sp)
    80004e9c:	6179                	addi	sp,sp,464
    80004e9e:	8082                	ret

0000000080004ea0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ea0:	7139                	addi	sp,sp,-64
    80004ea2:	fc06                	sd	ra,56(sp)
    80004ea4:	f822                	sd	s0,48(sp)
    80004ea6:	f426                	sd	s1,40(sp)
    80004ea8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eaa:	ffffc097          	auipc	ra,0xffffc
    80004eae:	fae080e7          	jalr	-82(ra) # 80000e58 <myproc>
    80004eb2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004eb4:	fd840593          	addi	a1,s0,-40
    80004eb8:	4501                	li	a0,0
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	0ce080e7          	jalr	206(ra) # 80001f88 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004ec2:	fc840593          	addi	a1,s0,-56
    80004ec6:	fd040513          	addi	a0,s0,-48
    80004eca:	fffff097          	auipc	ra,0xfffff
    80004ece:	dd6080e7          	jalr	-554(ra) # 80003ca0 <pipealloc>
    return -1;
    80004ed2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004ed4:	0c054463          	bltz	a0,80004f9c <sys_pipe+0xfc>
  fd0 = -1;
    80004ed8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004edc:	fd043503          	ld	a0,-48(s0)
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	518080e7          	jalr	1304(ra) # 800043f8 <fdalloc>
    80004ee8:	fca42223          	sw	a0,-60(s0)
    80004eec:	08054b63          	bltz	a0,80004f82 <sys_pipe+0xe2>
    80004ef0:	fc843503          	ld	a0,-56(s0)
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	504080e7          	jalr	1284(ra) # 800043f8 <fdalloc>
    80004efc:	fca42023          	sw	a0,-64(s0)
    80004f00:	06054863          	bltz	a0,80004f70 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f04:	4691                	li	a3,4
    80004f06:	fc440613          	addi	a2,s0,-60
    80004f0a:	fd843583          	ld	a1,-40(s0)
    80004f0e:	68a8                	ld	a0,80(s1)
    80004f10:	ffffc097          	auipc	ra,0xffffc
    80004f14:	c06080e7          	jalr	-1018(ra) # 80000b16 <copyout>
    80004f18:	02054063          	bltz	a0,80004f38 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f1c:	4691                	li	a3,4
    80004f1e:	fc040613          	addi	a2,s0,-64
    80004f22:	fd843583          	ld	a1,-40(s0)
    80004f26:	0591                	addi	a1,a1,4
    80004f28:	68a8                	ld	a0,80(s1)
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	bec080e7          	jalr	-1044(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f32:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f34:	06055463          	bgez	a0,80004f9c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004f38:	fc442783          	lw	a5,-60(s0)
    80004f3c:	07e9                	addi	a5,a5,26
    80004f3e:	078e                	slli	a5,a5,0x3
    80004f40:	97a6                	add	a5,a5,s1
    80004f42:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f46:	fc042503          	lw	a0,-64(s0)
    80004f4a:	0569                	addi	a0,a0,26
    80004f4c:	050e                	slli	a0,a0,0x3
    80004f4e:	94aa                	add	s1,s1,a0
    80004f50:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f54:	fd043503          	ld	a0,-48(s0)
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	a18080e7          	jalr	-1512(ra) # 80003970 <fileclose>
    fileclose(wf);
    80004f60:	fc843503          	ld	a0,-56(s0)
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	a0c080e7          	jalr	-1524(ra) # 80003970 <fileclose>
    return -1;
    80004f6c:	57fd                	li	a5,-1
    80004f6e:	a03d                	j	80004f9c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004f70:	fc442783          	lw	a5,-60(s0)
    80004f74:	0007c763          	bltz	a5,80004f82 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004f78:	07e9                	addi	a5,a5,26
    80004f7a:	078e                	slli	a5,a5,0x3
    80004f7c:	94be                	add	s1,s1,a5
    80004f7e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004f82:	fd043503          	ld	a0,-48(s0)
    80004f86:	fffff097          	auipc	ra,0xfffff
    80004f8a:	9ea080e7          	jalr	-1558(ra) # 80003970 <fileclose>
    fileclose(wf);
    80004f8e:	fc843503          	ld	a0,-56(s0)
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	9de080e7          	jalr	-1570(ra) # 80003970 <fileclose>
    return -1;
    80004f9a:	57fd                	li	a5,-1
}
    80004f9c:	853e                	mv	a0,a5
    80004f9e:	70e2                	ld	ra,56(sp)
    80004fa0:	7442                	ld	s0,48(sp)
    80004fa2:	74a2                	ld	s1,40(sp)
    80004fa4:	6121                	addi	sp,sp,64
    80004fa6:	8082                	ret
	...

0000000080004fb0 <kernelvec>:
    80004fb0:	7111                	addi	sp,sp,-256
    80004fb2:	e006                	sd	ra,0(sp)
    80004fb4:	e40a                	sd	sp,8(sp)
    80004fb6:	e80e                	sd	gp,16(sp)
    80004fb8:	ec12                	sd	tp,24(sp)
    80004fba:	f016                	sd	t0,32(sp)
    80004fbc:	f41a                	sd	t1,40(sp)
    80004fbe:	f81e                	sd	t2,48(sp)
    80004fc0:	fc22                	sd	s0,56(sp)
    80004fc2:	e0a6                	sd	s1,64(sp)
    80004fc4:	e4aa                	sd	a0,72(sp)
    80004fc6:	e8ae                	sd	a1,80(sp)
    80004fc8:	ecb2                	sd	a2,88(sp)
    80004fca:	f0b6                	sd	a3,96(sp)
    80004fcc:	f4ba                	sd	a4,104(sp)
    80004fce:	f8be                	sd	a5,112(sp)
    80004fd0:	fcc2                	sd	a6,120(sp)
    80004fd2:	e146                	sd	a7,128(sp)
    80004fd4:	e54a                	sd	s2,136(sp)
    80004fd6:	e94e                	sd	s3,144(sp)
    80004fd8:	ed52                	sd	s4,152(sp)
    80004fda:	f156                	sd	s5,160(sp)
    80004fdc:	f55a                	sd	s6,168(sp)
    80004fde:	f95e                	sd	s7,176(sp)
    80004fe0:	fd62                	sd	s8,184(sp)
    80004fe2:	e1e6                	sd	s9,192(sp)
    80004fe4:	e5ea                	sd	s10,200(sp)
    80004fe6:	e9ee                	sd	s11,208(sp)
    80004fe8:	edf2                	sd	t3,216(sp)
    80004fea:	f1f6                	sd	t4,224(sp)
    80004fec:	f5fa                	sd	t5,232(sp)
    80004fee:	f9fe                	sd	t6,240(sp)
    80004ff0:	da7fc0ef          	jal	ra,80001d96 <kerneltrap>
    80004ff4:	6082                	ld	ra,0(sp)
    80004ff6:	6122                	ld	sp,8(sp)
    80004ff8:	61c2                	ld	gp,16(sp)
    80004ffa:	7282                	ld	t0,32(sp)
    80004ffc:	7322                	ld	t1,40(sp)
    80004ffe:	73c2                	ld	t2,48(sp)
    80005000:	7462                	ld	s0,56(sp)
    80005002:	6486                	ld	s1,64(sp)
    80005004:	6526                	ld	a0,72(sp)
    80005006:	65c6                	ld	a1,80(sp)
    80005008:	6666                	ld	a2,88(sp)
    8000500a:	7686                	ld	a3,96(sp)
    8000500c:	7726                	ld	a4,104(sp)
    8000500e:	77c6                	ld	a5,112(sp)
    80005010:	7866                	ld	a6,120(sp)
    80005012:	688a                	ld	a7,128(sp)
    80005014:	692a                	ld	s2,136(sp)
    80005016:	69ca                	ld	s3,144(sp)
    80005018:	6a6a                	ld	s4,152(sp)
    8000501a:	7a8a                	ld	s5,160(sp)
    8000501c:	7b2a                	ld	s6,168(sp)
    8000501e:	7bca                	ld	s7,176(sp)
    80005020:	7c6a                	ld	s8,184(sp)
    80005022:	6c8e                	ld	s9,192(sp)
    80005024:	6d2e                	ld	s10,200(sp)
    80005026:	6dce                	ld	s11,208(sp)
    80005028:	6e6e                	ld	t3,216(sp)
    8000502a:	7e8e                	ld	t4,224(sp)
    8000502c:	7f2e                	ld	t5,232(sp)
    8000502e:	7fce                	ld	t6,240(sp)
    80005030:	6111                	addi	sp,sp,256
    80005032:	10200073          	sret
    80005036:	00000013          	nop
    8000503a:	00000013          	nop
    8000503e:	0001                	nop

0000000080005040 <timervec>:
    80005040:	34051573          	csrrw	a0,mscratch,a0
    80005044:	e10c                	sd	a1,0(a0)
    80005046:	e510                	sd	a2,8(a0)
    80005048:	e914                	sd	a3,16(a0)
    8000504a:	6d0c                	ld	a1,24(a0)
    8000504c:	7110                	ld	a2,32(a0)
    8000504e:	6194                	ld	a3,0(a1)
    80005050:	96b2                	add	a3,a3,a2
    80005052:	e194                	sd	a3,0(a1)
    80005054:	4589                	li	a1,2
    80005056:	14459073          	csrw	sip,a1
    8000505a:	6914                	ld	a3,16(a0)
    8000505c:	6510                	ld	a2,8(a0)
    8000505e:	610c                	ld	a1,0(a0)
    80005060:	34051573          	csrrw	a0,mscratch,a0
    80005064:	30200073          	mret
	...

000000008000506a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000506a:	1141                	addi	sp,sp,-16
    8000506c:	e422                	sd	s0,8(sp)
    8000506e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005070:	0c0007b7          	lui	a5,0xc000
    80005074:	4705                	li	a4,1
    80005076:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005078:	c3d8                	sw	a4,4(a5)
}
    8000507a:	6422                	ld	s0,8(sp)
    8000507c:	0141                	addi	sp,sp,16
    8000507e:	8082                	ret

0000000080005080 <plicinithart>:

void
plicinithart(void)
{
    80005080:	1141                	addi	sp,sp,-16
    80005082:	e406                	sd	ra,8(sp)
    80005084:	e022                	sd	s0,0(sp)
    80005086:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005088:	ffffc097          	auipc	ra,0xffffc
    8000508c:	da4080e7          	jalr	-604(ra) # 80000e2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005090:	0085171b          	slliw	a4,a0,0x8
    80005094:	0c0027b7          	lui	a5,0xc002
    80005098:	97ba                	add	a5,a5,a4
    8000509a:	40200713          	li	a4,1026
    8000509e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800050a2:	00d5151b          	slliw	a0,a0,0xd
    800050a6:	0c2017b7          	lui	a5,0xc201
    800050aa:	953e                	add	a0,a0,a5
    800050ac:	00052023          	sw	zero,0(a0)
}
    800050b0:	60a2                	ld	ra,8(sp)
    800050b2:	6402                	ld	s0,0(sp)
    800050b4:	0141                	addi	sp,sp,16
    800050b6:	8082                	ret

00000000800050b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800050b8:	1141                	addi	sp,sp,-16
    800050ba:	e406                	sd	ra,8(sp)
    800050bc:	e022                	sd	s0,0(sp)
    800050be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	d6c080e7          	jalr	-660(ra) # 80000e2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050c8:	00d5179b          	slliw	a5,a0,0xd
    800050cc:	0c201537          	lui	a0,0xc201
    800050d0:	953e                	add	a0,a0,a5
  return irq;
}
    800050d2:	4148                	lw	a0,4(a0)
    800050d4:	60a2                	ld	ra,8(sp)
    800050d6:	6402                	ld	s0,0(sp)
    800050d8:	0141                	addi	sp,sp,16
    800050da:	8082                	ret

00000000800050dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050dc:	1101                	addi	sp,sp,-32
    800050de:	ec06                	sd	ra,24(sp)
    800050e0:	e822                	sd	s0,16(sp)
    800050e2:	e426                	sd	s1,8(sp)
    800050e4:	1000                	addi	s0,sp,32
    800050e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d44080e7          	jalr	-700(ra) # 80000e2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050f0:	00d5151b          	slliw	a0,a0,0xd
    800050f4:	0c2017b7          	lui	a5,0xc201
    800050f8:	97aa                	add	a5,a5,a0
    800050fa:	c3c4                	sw	s1,4(a5)
}
    800050fc:	60e2                	ld	ra,24(sp)
    800050fe:	6442                	ld	s0,16(sp)
    80005100:	64a2                	ld	s1,8(sp)
    80005102:	6105                	addi	sp,sp,32
    80005104:	8082                	ret

0000000080005106 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005106:	1141                	addi	sp,sp,-16
    80005108:	e406                	sd	ra,8(sp)
    8000510a:	e022                	sd	s0,0(sp)
    8000510c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000510e:	479d                	li	a5,7
    80005110:	04a7cc63          	blt	a5,a0,80005168 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005114:	00015797          	auipc	a5,0x15
    80005118:	89c78793          	addi	a5,a5,-1892 # 800199b0 <disk>
    8000511c:	97aa                	add	a5,a5,a0
    8000511e:	0187c783          	lbu	a5,24(a5)
    80005122:	ebb9                	bnez	a5,80005178 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005124:	00451613          	slli	a2,a0,0x4
    80005128:	00015797          	auipc	a5,0x15
    8000512c:	88878793          	addi	a5,a5,-1912 # 800199b0 <disk>
    80005130:	6394                	ld	a3,0(a5)
    80005132:	96b2                	add	a3,a3,a2
    80005134:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005138:	6398                	ld	a4,0(a5)
    8000513a:	9732                	add	a4,a4,a2
    8000513c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005140:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005144:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005148:	953e                	add	a0,a0,a5
    8000514a:	4785                	li	a5,1
    8000514c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005150:	00015517          	auipc	a0,0x15
    80005154:	87850513          	addi	a0,a0,-1928 # 800199c8 <disk+0x18>
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	408080e7          	jalr	1032(ra) # 80001560 <wakeup>
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret
    panic("free_desc 1");
    80005168:	00003517          	auipc	a0,0x3
    8000516c:	55850513          	addi	a0,a0,1368 # 800086c0 <syscalls+0x2f0>
    80005170:	00001097          	auipc	ra,0x1
    80005174:	a72080e7          	jalr	-1422(ra) # 80005be2 <panic>
    panic("free_desc 2");
    80005178:	00003517          	auipc	a0,0x3
    8000517c:	55850513          	addi	a0,a0,1368 # 800086d0 <syscalls+0x300>
    80005180:	00001097          	auipc	ra,0x1
    80005184:	a62080e7          	jalr	-1438(ra) # 80005be2 <panic>

0000000080005188 <virtio_disk_init>:
{
    80005188:	1101                	addi	sp,sp,-32
    8000518a:	ec06                	sd	ra,24(sp)
    8000518c:	e822                	sd	s0,16(sp)
    8000518e:	e426                	sd	s1,8(sp)
    80005190:	e04a                	sd	s2,0(sp)
    80005192:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005194:	00003597          	auipc	a1,0x3
    80005198:	54c58593          	addi	a1,a1,1356 # 800086e0 <syscalls+0x310>
    8000519c:	00015517          	auipc	a0,0x15
    800051a0:	93c50513          	addi	a0,a0,-1732 # 80019ad8 <disk+0x128>
    800051a4:	00001097          	auipc	ra,0x1
    800051a8:	ef8080e7          	jalr	-264(ra) # 8000609c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051ac:	100017b7          	lui	a5,0x10001
    800051b0:	4398                	lw	a4,0(a5)
    800051b2:	2701                	sext.w	a4,a4
    800051b4:	747277b7          	lui	a5,0x74727
    800051b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051bc:	14f71e63          	bne	a4,a5,80005318 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051c0:	100017b7          	lui	a5,0x10001
    800051c4:	43dc                	lw	a5,4(a5)
    800051c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c8:	4709                	li	a4,2
    800051ca:	14e79763          	bne	a5,a4,80005318 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051ce:	100017b7          	lui	a5,0x10001
    800051d2:	479c                	lw	a5,8(a5)
    800051d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800051d6:	14e79163          	bne	a5,a4,80005318 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051da:	100017b7          	lui	a5,0x10001
    800051de:	47d8                	lw	a4,12(a5)
    800051e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051e2:	554d47b7          	lui	a5,0x554d4
    800051e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051ea:	12f71763          	bne	a4,a5,80005318 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051ee:	100017b7          	lui	a5,0x10001
    800051f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051f6:	4705                	li	a4,1
    800051f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051fa:	470d                	li	a4,3
    800051fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051fe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005200:	c7ffe737          	lui	a4,0xc7ffe
    80005204:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdca2f>
    80005208:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000520a:	2701                	sext.w	a4,a4
    8000520c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000520e:	472d                	li	a4,11
    80005210:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005212:	0707a903          	lw	s2,112(a5)
    80005216:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005218:	00897793          	andi	a5,s2,8
    8000521c:	10078663          	beqz	a5,80005328 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005220:	100017b7          	lui	a5,0x10001
    80005224:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005228:	43fc                	lw	a5,68(a5)
    8000522a:	2781                	sext.w	a5,a5
    8000522c:	10079663          	bnez	a5,80005338 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005230:	100017b7          	lui	a5,0x10001
    80005234:	5bdc                	lw	a5,52(a5)
    80005236:	2781                	sext.w	a5,a5
  if(max == 0)
    80005238:	10078863          	beqz	a5,80005348 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000523c:	471d                	li	a4,7
    8000523e:	10f77d63          	bgeu	a4,a5,80005358 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005242:	ffffb097          	auipc	ra,0xffffb
    80005246:	ed6080e7          	jalr	-298(ra) # 80000118 <kalloc>
    8000524a:	00014497          	auipc	s1,0x14
    8000524e:	76648493          	addi	s1,s1,1894 # 800199b0 <disk>
    80005252:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005254:	ffffb097          	auipc	ra,0xffffb
    80005258:	ec4080e7          	jalr	-316(ra) # 80000118 <kalloc>
    8000525c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000525e:	ffffb097          	auipc	ra,0xffffb
    80005262:	eba080e7          	jalr	-326(ra) # 80000118 <kalloc>
    80005266:	87aa                	mv	a5,a0
    80005268:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000526a:	6088                	ld	a0,0(s1)
    8000526c:	cd75                	beqz	a0,80005368 <virtio_disk_init+0x1e0>
    8000526e:	00014717          	auipc	a4,0x14
    80005272:	74a73703          	ld	a4,1866(a4) # 800199b8 <disk+0x8>
    80005276:	cb6d                	beqz	a4,80005368 <virtio_disk_init+0x1e0>
    80005278:	cbe5                	beqz	a5,80005368 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000527a:	6605                	lui	a2,0x1
    8000527c:	4581                	li	a1,0
    8000527e:	ffffb097          	auipc	ra,0xffffb
    80005282:	efa080e7          	jalr	-262(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005286:	00014497          	auipc	s1,0x14
    8000528a:	72a48493          	addi	s1,s1,1834 # 800199b0 <disk>
    8000528e:	6605                	lui	a2,0x1
    80005290:	4581                	li	a1,0
    80005292:	6488                	ld	a0,8(s1)
    80005294:	ffffb097          	auipc	ra,0xffffb
    80005298:	ee4080e7          	jalr	-284(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000529c:	6605                	lui	a2,0x1
    8000529e:	4581                	li	a1,0
    800052a0:	6888                	ld	a0,16(s1)
    800052a2:	ffffb097          	auipc	ra,0xffffb
    800052a6:	ed6080e7          	jalr	-298(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052aa:	100017b7          	lui	a5,0x10001
    800052ae:	4721                	li	a4,8
    800052b0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800052b2:	4098                	lw	a4,0(s1)
    800052b4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800052b8:	40d8                	lw	a4,4(s1)
    800052ba:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800052be:	6498                	ld	a4,8(s1)
    800052c0:	0007069b          	sext.w	a3,a4
    800052c4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800052c8:	9701                	srai	a4,a4,0x20
    800052ca:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800052ce:	6898                	ld	a4,16(s1)
    800052d0:	0007069b          	sext.w	a3,a4
    800052d4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800052d8:	9701                	srai	a4,a4,0x20
    800052da:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800052de:	4685                	li	a3,1
    800052e0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800052e2:	4705                	li	a4,1
    800052e4:	00d48c23          	sb	a3,24(s1)
    800052e8:	00e48ca3          	sb	a4,25(s1)
    800052ec:	00e48d23          	sb	a4,26(s1)
    800052f0:	00e48da3          	sb	a4,27(s1)
    800052f4:	00e48e23          	sb	a4,28(s1)
    800052f8:	00e48ea3          	sb	a4,29(s1)
    800052fc:	00e48f23          	sb	a4,30(s1)
    80005300:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005304:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	0727a823          	sw	s2,112(a5)
}
    8000530c:	60e2                	ld	ra,24(sp)
    8000530e:	6442                	ld	s0,16(sp)
    80005310:	64a2                	ld	s1,8(sp)
    80005312:	6902                	ld	s2,0(sp)
    80005314:	6105                	addi	sp,sp,32
    80005316:	8082                	ret
    panic("could not find virtio disk");
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	3d850513          	addi	a0,a0,984 # 800086f0 <syscalls+0x320>
    80005320:	00001097          	auipc	ra,0x1
    80005324:	8c2080e7          	jalr	-1854(ra) # 80005be2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005328:	00003517          	auipc	a0,0x3
    8000532c:	3e850513          	addi	a0,a0,1000 # 80008710 <syscalls+0x340>
    80005330:	00001097          	auipc	ra,0x1
    80005334:	8b2080e7          	jalr	-1870(ra) # 80005be2 <panic>
    panic("virtio disk should not be ready");
    80005338:	00003517          	auipc	a0,0x3
    8000533c:	3f850513          	addi	a0,a0,1016 # 80008730 <syscalls+0x360>
    80005340:	00001097          	auipc	ra,0x1
    80005344:	8a2080e7          	jalr	-1886(ra) # 80005be2 <panic>
    panic("virtio disk has no queue 0");
    80005348:	00003517          	auipc	a0,0x3
    8000534c:	40850513          	addi	a0,a0,1032 # 80008750 <syscalls+0x380>
    80005350:	00001097          	auipc	ra,0x1
    80005354:	892080e7          	jalr	-1902(ra) # 80005be2 <panic>
    panic("virtio disk max queue too short");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	41850513          	addi	a0,a0,1048 # 80008770 <syscalls+0x3a0>
    80005360:	00001097          	auipc	ra,0x1
    80005364:	882080e7          	jalr	-1918(ra) # 80005be2 <panic>
    panic("virtio disk kalloc");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	42850513          	addi	a0,a0,1064 # 80008790 <syscalls+0x3c0>
    80005370:	00001097          	auipc	ra,0x1
    80005374:	872080e7          	jalr	-1934(ra) # 80005be2 <panic>

0000000080005378 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005378:	7159                	addi	sp,sp,-112
    8000537a:	f486                	sd	ra,104(sp)
    8000537c:	f0a2                	sd	s0,96(sp)
    8000537e:	eca6                	sd	s1,88(sp)
    80005380:	e8ca                	sd	s2,80(sp)
    80005382:	e4ce                	sd	s3,72(sp)
    80005384:	e0d2                	sd	s4,64(sp)
    80005386:	fc56                	sd	s5,56(sp)
    80005388:	f85a                	sd	s6,48(sp)
    8000538a:	f45e                	sd	s7,40(sp)
    8000538c:	f062                	sd	s8,32(sp)
    8000538e:	ec66                	sd	s9,24(sp)
    80005390:	e86a                	sd	s10,16(sp)
    80005392:	1880                	addi	s0,sp,112
    80005394:	892a                	mv	s2,a0
    80005396:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005398:	00c52c83          	lw	s9,12(a0)
    8000539c:	001c9c9b          	slliw	s9,s9,0x1
    800053a0:	1c82                	slli	s9,s9,0x20
    800053a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053a6:	00014517          	auipc	a0,0x14
    800053aa:	73250513          	addi	a0,a0,1842 # 80019ad8 <disk+0x128>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	d7e080e7          	jalr	-642(ra) # 8000612c <acquire>
  for(int i = 0; i < 3; i++){
    800053b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053b8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800053ba:	00014b17          	auipc	s6,0x14
    800053be:	5f6b0b13          	addi	s6,s6,1526 # 800199b0 <disk>
  for(int i = 0; i < 3; i++){
    800053c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053c4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053c6:	00014c17          	auipc	s8,0x14
    800053ca:	712c0c13          	addi	s8,s8,1810 # 80019ad8 <disk+0x128>
    800053ce:	a8b5                	j	8000544a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800053d0:	00fb06b3          	add	a3,s6,a5
    800053d4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053d8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053da:	0207c563          	bltz	a5,80005404 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800053de:	2485                	addiw	s1,s1,1
    800053e0:	0711                	addi	a4,a4,4
    800053e2:	1f548a63          	beq	s1,s5,800055d6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800053e6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053e8:	00014697          	auipc	a3,0x14
    800053ec:	5c868693          	addi	a3,a3,1480 # 800199b0 <disk>
    800053f0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053f2:	0186c583          	lbu	a1,24(a3)
    800053f6:	fde9                	bnez	a1,800053d0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800053f8:	2785                	addiw	a5,a5,1
    800053fa:	0685                	addi	a3,a3,1
    800053fc:	ff779be3          	bne	a5,s7,800053f2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005400:	57fd                	li	a5,-1
    80005402:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005404:	02905a63          	blez	s1,80005438 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005408:	f9042503          	lw	a0,-112(s0)
    8000540c:	00000097          	auipc	ra,0x0
    80005410:	cfa080e7          	jalr	-774(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    80005414:	4785                	li	a5,1
    80005416:	0297d163          	bge	a5,s1,80005438 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000541a:	f9442503          	lw	a0,-108(s0)
    8000541e:	00000097          	auipc	ra,0x0
    80005422:	ce8080e7          	jalr	-792(ra) # 80005106 <free_desc>
      for(int j = 0; j < i; j++)
    80005426:	4789                	li	a5,2
    80005428:	0097d863          	bge	a5,s1,80005438 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000542c:	f9842503          	lw	a0,-104(s0)
    80005430:	00000097          	auipc	ra,0x0
    80005434:	cd6080e7          	jalr	-810(ra) # 80005106 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005438:	85e2                	mv	a1,s8
    8000543a:	00014517          	auipc	a0,0x14
    8000543e:	58e50513          	addi	a0,a0,1422 # 800199c8 <disk+0x18>
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	0ba080e7          	jalr	186(ra) # 800014fc <sleep>
  for(int i = 0; i < 3; i++){
    8000544a:	f9040713          	addi	a4,s0,-112
    8000544e:	84ce                	mv	s1,s3
    80005450:	bf59                	j	800053e6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005452:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005456:	00479693          	slli	a3,a5,0x4
    8000545a:	00014797          	auipc	a5,0x14
    8000545e:	55678793          	addi	a5,a5,1366 # 800199b0 <disk>
    80005462:	97b6                	add	a5,a5,a3
    80005464:	4685                	li	a3,1
    80005466:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005468:	00014597          	auipc	a1,0x14
    8000546c:	54858593          	addi	a1,a1,1352 # 800199b0 <disk>
    80005470:	00a60793          	addi	a5,a2,10
    80005474:	0792                	slli	a5,a5,0x4
    80005476:	97ae                	add	a5,a5,a1
    80005478:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000547c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005480:	f6070693          	addi	a3,a4,-160
    80005484:	619c                	ld	a5,0(a1)
    80005486:	97b6                	add	a5,a5,a3
    80005488:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000548a:	6188                	ld	a0,0(a1)
    8000548c:	96aa                	add	a3,a3,a0
    8000548e:	47c1                	li	a5,16
    80005490:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005492:	4785                	li	a5,1
    80005494:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005498:	f9442783          	lw	a5,-108(s0)
    8000549c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054a0:	0792                	slli	a5,a5,0x4
    800054a2:	953e                	add	a0,a0,a5
    800054a4:	05890693          	addi	a3,s2,88
    800054a8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800054aa:	6188                	ld	a0,0(a1)
    800054ac:	97aa                	add	a5,a5,a0
    800054ae:	40000693          	li	a3,1024
    800054b2:	c794                	sw	a3,8(a5)
  if(write)
    800054b4:	100d0d63          	beqz	s10,800055ce <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054b8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054bc:	00c7d683          	lhu	a3,12(a5)
    800054c0:	0016e693          	ori	a3,a3,1
    800054c4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800054c8:	f9842583          	lw	a1,-104(s0)
    800054cc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d0:	00014697          	auipc	a3,0x14
    800054d4:	4e068693          	addi	a3,a3,1248 # 800199b0 <disk>
    800054d8:	00260793          	addi	a5,a2,2
    800054dc:	0792                	slli	a5,a5,0x4
    800054de:	97b6                	add	a5,a5,a3
    800054e0:	587d                	li	a6,-1
    800054e2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e6:	0592                	slli	a1,a1,0x4
    800054e8:	952e                	add	a0,a0,a1
    800054ea:	f9070713          	addi	a4,a4,-112
    800054ee:	9736                	add	a4,a4,a3
    800054f0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800054f2:	6298                	ld	a4,0(a3)
    800054f4:	972e                	add	a4,a4,a1
    800054f6:	4585                	li	a1,1
    800054f8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054fa:	4509                	li	a0,2
    800054fc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005500:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005504:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005508:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000550c:	6698                	ld	a4,8(a3)
    8000550e:	00275783          	lhu	a5,2(a4)
    80005512:	8b9d                	andi	a5,a5,7
    80005514:	0786                	slli	a5,a5,0x1
    80005516:	97ba                	add	a5,a5,a4
    80005518:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000551c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005520:	6698                	ld	a4,8(a3)
    80005522:	00275783          	lhu	a5,2(a4)
    80005526:	2785                	addiw	a5,a5,1
    80005528:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000552c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005530:	100017b7          	lui	a5,0x10001
    80005534:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005538:	00492703          	lw	a4,4(s2)
    8000553c:	4785                	li	a5,1
    8000553e:	02f71163          	bne	a4,a5,80005560 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005542:	00014997          	auipc	s3,0x14
    80005546:	59698993          	addi	s3,s3,1430 # 80019ad8 <disk+0x128>
  while(b->disk == 1) {
    8000554a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000554c:	85ce                	mv	a1,s3
    8000554e:	854a                	mv	a0,s2
    80005550:	ffffc097          	auipc	ra,0xffffc
    80005554:	fac080e7          	jalr	-84(ra) # 800014fc <sleep>
  while(b->disk == 1) {
    80005558:	00492783          	lw	a5,4(s2)
    8000555c:	fe9788e3          	beq	a5,s1,8000554c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005560:	f9042903          	lw	s2,-112(s0)
    80005564:	00290793          	addi	a5,s2,2
    80005568:	00479713          	slli	a4,a5,0x4
    8000556c:	00014797          	auipc	a5,0x14
    80005570:	44478793          	addi	a5,a5,1092 # 800199b0 <disk>
    80005574:	97ba                	add	a5,a5,a4
    80005576:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000557a:	00014997          	auipc	s3,0x14
    8000557e:	43698993          	addi	s3,s3,1078 # 800199b0 <disk>
    80005582:	00491713          	slli	a4,s2,0x4
    80005586:	0009b783          	ld	a5,0(s3)
    8000558a:	97ba                	add	a5,a5,a4
    8000558c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005590:	854a                	mv	a0,s2
    80005592:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	b70080e7          	jalr	-1168(ra) # 80005106 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000559e:	8885                	andi	s1,s1,1
    800055a0:	f0ed                	bnez	s1,80005582 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055a2:	00014517          	auipc	a0,0x14
    800055a6:	53650513          	addi	a0,a0,1334 # 80019ad8 <disk+0x128>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	c36080e7          	jalr	-970(ra) # 800061e0 <release>
}
    800055b2:	70a6                	ld	ra,104(sp)
    800055b4:	7406                	ld	s0,96(sp)
    800055b6:	64e6                	ld	s1,88(sp)
    800055b8:	6946                	ld	s2,80(sp)
    800055ba:	69a6                	ld	s3,72(sp)
    800055bc:	6a06                	ld	s4,64(sp)
    800055be:	7ae2                	ld	s5,56(sp)
    800055c0:	7b42                	ld	s6,48(sp)
    800055c2:	7ba2                	ld	s7,40(sp)
    800055c4:	7c02                	ld	s8,32(sp)
    800055c6:	6ce2                	ld	s9,24(sp)
    800055c8:	6d42                	ld	s10,16(sp)
    800055ca:	6165                	addi	sp,sp,112
    800055cc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055ce:	4689                	li	a3,2
    800055d0:	00d79623          	sh	a3,12(a5)
    800055d4:	b5e5                	j	800054bc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055d6:	f9042603          	lw	a2,-112(s0)
    800055da:	00a60713          	addi	a4,a2,10
    800055de:	0712                	slli	a4,a4,0x4
    800055e0:	00014517          	auipc	a0,0x14
    800055e4:	3d850513          	addi	a0,a0,984 # 800199b8 <disk+0x8>
    800055e8:	953a                	add	a0,a0,a4
  if(write)
    800055ea:	e60d14e3          	bnez	s10,80005452 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800055ee:	00a60793          	addi	a5,a2,10
    800055f2:	00479693          	slli	a3,a5,0x4
    800055f6:	00014797          	auipc	a5,0x14
    800055fa:	3ba78793          	addi	a5,a5,954 # 800199b0 <disk>
    800055fe:	97b6                	add	a5,a5,a3
    80005600:	0007a423          	sw	zero,8(a5)
    80005604:	b595                	j	80005468 <virtio_disk_rw+0xf0>

0000000080005606 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005606:	1101                	addi	sp,sp,-32
    80005608:	ec06                	sd	ra,24(sp)
    8000560a:	e822                	sd	s0,16(sp)
    8000560c:	e426                	sd	s1,8(sp)
    8000560e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005610:	00014497          	auipc	s1,0x14
    80005614:	3a048493          	addi	s1,s1,928 # 800199b0 <disk>
    80005618:	00014517          	auipc	a0,0x14
    8000561c:	4c050513          	addi	a0,a0,1216 # 80019ad8 <disk+0x128>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	b0c080e7          	jalr	-1268(ra) # 8000612c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005628:	10001737          	lui	a4,0x10001
    8000562c:	533c                	lw	a5,96(a4)
    8000562e:	8b8d                	andi	a5,a5,3
    80005630:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005632:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005636:	689c                	ld	a5,16(s1)
    80005638:	0204d703          	lhu	a4,32(s1)
    8000563c:	0027d783          	lhu	a5,2(a5)
    80005640:	04f70863          	beq	a4,a5,80005690 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005644:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005648:	6898                	ld	a4,16(s1)
    8000564a:	0204d783          	lhu	a5,32(s1)
    8000564e:	8b9d                	andi	a5,a5,7
    80005650:	078e                	slli	a5,a5,0x3
    80005652:	97ba                	add	a5,a5,a4
    80005654:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005656:	00278713          	addi	a4,a5,2
    8000565a:	0712                	slli	a4,a4,0x4
    8000565c:	9726                	add	a4,a4,s1
    8000565e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005662:	e721                	bnez	a4,800056aa <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005664:	0789                	addi	a5,a5,2
    80005666:	0792                	slli	a5,a5,0x4
    80005668:	97a6                	add	a5,a5,s1
    8000566a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000566c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005670:	ffffc097          	auipc	ra,0xffffc
    80005674:	ef0080e7          	jalr	-272(ra) # 80001560 <wakeup>

    disk.used_idx += 1;
    80005678:	0204d783          	lhu	a5,32(s1)
    8000567c:	2785                	addiw	a5,a5,1
    8000567e:	17c2                	slli	a5,a5,0x30
    80005680:	93c1                	srli	a5,a5,0x30
    80005682:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005686:	6898                	ld	a4,16(s1)
    80005688:	00275703          	lhu	a4,2(a4)
    8000568c:	faf71ce3          	bne	a4,a5,80005644 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005690:	00014517          	auipc	a0,0x14
    80005694:	44850513          	addi	a0,a0,1096 # 80019ad8 <disk+0x128>
    80005698:	00001097          	auipc	ra,0x1
    8000569c:	b48080e7          	jalr	-1208(ra) # 800061e0 <release>
}
    800056a0:	60e2                	ld	ra,24(sp)
    800056a2:	6442                	ld	s0,16(sp)
    800056a4:	64a2                	ld	s1,8(sp)
    800056a6:	6105                	addi	sp,sp,32
    800056a8:	8082                	ret
      panic("virtio_disk_intr status");
    800056aa:	00003517          	auipc	a0,0x3
    800056ae:	0fe50513          	addi	a0,a0,254 # 800087a8 <syscalls+0x3d8>
    800056b2:	00000097          	auipc	ra,0x0
    800056b6:	530080e7          	jalr	1328(ra) # 80005be2 <panic>

00000000800056ba <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056ba:	1141                	addi	sp,sp,-16
    800056bc:	e422                	sd	s0,8(sp)
    800056be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056c0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056c4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056c8:	0037979b          	slliw	a5,a5,0x3
    800056cc:	02004737          	lui	a4,0x2004
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	0200c737          	lui	a4,0x200c
    800056d6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800056da:	000f4637          	lui	a2,0xf4
    800056de:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056e2:	95b2                	add	a1,a1,a2
    800056e4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056e6:	00269713          	slli	a4,a3,0x2
    800056ea:	9736                	add	a4,a4,a3
    800056ec:	00371693          	slli	a3,a4,0x3
    800056f0:	00014717          	auipc	a4,0x14
    800056f4:	40070713          	addi	a4,a4,1024 # 80019af0 <timer_scratch>
    800056f8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056fa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056fc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056fe:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005702:	00000797          	auipc	a5,0x0
    80005706:	93e78793          	addi	a5,a5,-1730 # 80005040 <timervec>
    8000570a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000570e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005712:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005716:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000571a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000571e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005722:	30479073          	csrw	mie,a5
}
    80005726:	6422                	ld	s0,8(sp)
    80005728:	0141                	addi	sp,sp,16
    8000572a:	8082                	ret

000000008000572c <start>:
{
    8000572c:	1141                	addi	sp,sp,-16
    8000572e:	e406                	sd	ra,8(sp)
    80005730:	e022                	sd	s0,0(sp)
    80005732:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005734:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005738:	7779                	lui	a4,0xffffe
    8000573a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdcacf>
    8000573e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005740:	6705                	lui	a4,0x1
    80005742:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005746:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005748:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000574c:	ffffb797          	auipc	a5,0xffffb
    80005750:	bda78793          	addi	a5,a5,-1062 # 80000326 <main>
    80005754:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005758:	4781                	li	a5,0
    8000575a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000575e:	67c1                	lui	a5,0x10
    80005760:	17fd                	addi	a5,a5,-1
    80005762:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005766:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000576a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000576e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005772:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005776:	57fd                	li	a5,-1
    80005778:	83a9                	srli	a5,a5,0xa
    8000577a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000577e:	47bd                	li	a5,15
    80005780:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005784:	00000097          	auipc	ra,0x0
    80005788:	f36080e7          	jalr	-202(ra) # 800056ba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000578c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005790:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005792:	823e                	mv	tp,a5
  asm volatile("mret");
    80005794:	30200073          	mret
}
    80005798:	60a2                	ld	ra,8(sp)
    8000579a:	6402                	ld	s0,0(sp)
    8000579c:	0141                	addi	sp,sp,16
    8000579e:	8082                	ret

00000000800057a0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057a0:	715d                	addi	sp,sp,-80
    800057a2:	e486                	sd	ra,72(sp)
    800057a4:	e0a2                	sd	s0,64(sp)
    800057a6:	fc26                	sd	s1,56(sp)
    800057a8:	f84a                	sd	s2,48(sp)
    800057aa:	f44e                	sd	s3,40(sp)
    800057ac:	f052                	sd	s4,32(sp)
    800057ae:	ec56                	sd	s5,24(sp)
    800057b0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057b2:	04c05663          	blez	a2,800057fe <consolewrite+0x5e>
    800057b6:	8a2a                	mv	s4,a0
    800057b8:	84ae                	mv	s1,a1
    800057ba:	89b2                	mv	s3,a2
    800057bc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057be:	5afd                	li	s5,-1
    800057c0:	4685                	li	a3,1
    800057c2:	8626                	mv	a2,s1
    800057c4:	85d2                	mv	a1,s4
    800057c6:	fbf40513          	addi	a0,s0,-65
    800057ca:	ffffc097          	auipc	ra,0xffffc
    800057ce:	190080e7          	jalr	400(ra) # 8000195a <either_copyin>
    800057d2:	01550c63          	beq	a0,s5,800057ea <consolewrite+0x4a>
      break;
    uartputc(c);
    800057d6:	fbf44503          	lbu	a0,-65(s0)
    800057da:	00000097          	auipc	ra,0x0
    800057de:	794080e7          	jalr	1940(ra) # 80005f6e <uartputc>
  for(i = 0; i < n; i++){
    800057e2:	2905                	addiw	s2,s2,1
    800057e4:	0485                	addi	s1,s1,1
    800057e6:	fd299de3          	bne	s3,s2,800057c0 <consolewrite+0x20>
  }

  return i;
}
    800057ea:	854a                	mv	a0,s2
    800057ec:	60a6                	ld	ra,72(sp)
    800057ee:	6406                	ld	s0,64(sp)
    800057f0:	74e2                	ld	s1,56(sp)
    800057f2:	7942                	ld	s2,48(sp)
    800057f4:	79a2                	ld	s3,40(sp)
    800057f6:	7a02                	ld	s4,32(sp)
    800057f8:	6ae2                	ld	s5,24(sp)
    800057fa:	6161                	addi	sp,sp,80
    800057fc:	8082                	ret
  for(i = 0; i < n; i++){
    800057fe:	4901                	li	s2,0
    80005800:	b7ed                	j	800057ea <consolewrite+0x4a>

0000000080005802 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005802:	7119                	addi	sp,sp,-128
    80005804:	fc86                	sd	ra,120(sp)
    80005806:	f8a2                	sd	s0,112(sp)
    80005808:	f4a6                	sd	s1,104(sp)
    8000580a:	f0ca                	sd	s2,96(sp)
    8000580c:	ecce                	sd	s3,88(sp)
    8000580e:	e8d2                	sd	s4,80(sp)
    80005810:	e4d6                	sd	s5,72(sp)
    80005812:	e0da                	sd	s6,64(sp)
    80005814:	fc5e                	sd	s7,56(sp)
    80005816:	f862                	sd	s8,48(sp)
    80005818:	f466                	sd	s9,40(sp)
    8000581a:	f06a                	sd	s10,32(sp)
    8000581c:	ec6e                	sd	s11,24(sp)
    8000581e:	0100                	addi	s0,sp,128
    80005820:	8b2a                	mv	s6,a0
    80005822:	8aae                	mv	s5,a1
    80005824:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005826:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000582a:	0001c517          	auipc	a0,0x1c
    8000582e:	40650513          	addi	a0,a0,1030 # 80021c30 <cons>
    80005832:	00001097          	auipc	ra,0x1
    80005836:	8fa080e7          	jalr	-1798(ra) # 8000612c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000583a:	0001c497          	auipc	s1,0x1c
    8000583e:	3f648493          	addi	s1,s1,1014 # 80021c30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005842:	89a6                	mv	s3,s1
    80005844:	0001c917          	auipc	s2,0x1c
    80005848:	48490913          	addi	s2,s2,1156 # 80021cc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000584c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000584e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005850:	4da9                	li	s11,10
  while(n > 0){
    80005852:	07405b63          	blez	s4,800058c8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005856:	0984a783          	lw	a5,152(s1)
    8000585a:	09c4a703          	lw	a4,156(s1)
    8000585e:	02f71763          	bne	a4,a5,8000588c <consoleread+0x8a>
      if(killed(myproc())){
    80005862:	ffffb097          	auipc	ra,0xffffb
    80005866:	5f6080e7          	jalr	1526(ra) # 80000e58 <myproc>
    8000586a:	ffffc097          	auipc	ra,0xffffc
    8000586e:	f3a080e7          	jalr	-198(ra) # 800017a4 <killed>
    80005872:	e535                	bnez	a0,800058de <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005874:	85ce                	mv	a1,s3
    80005876:	854a                	mv	a0,s2
    80005878:	ffffc097          	auipc	ra,0xffffc
    8000587c:	c84080e7          	jalr	-892(ra) # 800014fc <sleep>
    while(cons.r == cons.w){
    80005880:	0984a783          	lw	a5,152(s1)
    80005884:	09c4a703          	lw	a4,156(s1)
    80005888:	fcf70de3          	beq	a4,a5,80005862 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000588c:	0017871b          	addiw	a4,a5,1
    80005890:	08e4ac23          	sw	a4,152(s1)
    80005894:	07f7f713          	andi	a4,a5,127
    80005898:	9726                	add	a4,a4,s1
    8000589a:	01874703          	lbu	a4,24(a4)
    8000589e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800058a2:	079c0663          	beq	s8,s9,8000590e <consoleread+0x10c>
    cbuf = c;
    800058a6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058aa:	4685                	li	a3,1
    800058ac:	f8f40613          	addi	a2,s0,-113
    800058b0:	85d6                	mv	a1,s5
    800058b2:	855a                	mv	a0,s6
    800058b4:	ffffc097          	auipc	ra,0xffffc
    800058b8:	050080e7          	jalr	80(ra) # 80001904 <either_copyout>
    800058bc:	01a50663          	beq	a0,s10,800058c8 <consoleread+0xc6>
    dst++;
    800058c0:	0a85                	addi	s5,s5,1
    --n;
    800058c2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800058c4:	f9bc17e3          	bne	s8,s11,80005852 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800058c8:	0001c517          	auipc	a0,0x1c
    800058cc:	36850513          	addi	a0,a0,872 # 80021c30 <cons>
    800058d0:	00001097          	auipc	ra,0x1
    800058d4:	910080e7          	jalr	-1776(ra) # 800061e0 <release>

  return target - n;
    800058d8:	414b853b          	subw	a0,s7,s4
    800058dc:	a811                	j	800058f0 <consoleread+0xee>
        release(&cons.lock);
    800058de:	0001c517          	auipc	a0,0x1c
    800058e2:	35250513          	addi	a0,a0,850 # 80021c30 <cons>
    800058e6:	00001097          	auipc	ra,0x1
    800058ea:	8fa080e7          	jalr	-1798(ra) # 800061e0 <release>
        return -1;
    800058ee:	557d                	li	a0,-1
}
    800058f0:	70e6                	ld	ra,120(sp)
    800058f2:	7446                	ld	s0,112(sp)
    800058f4:	74a6                	ld	s1,104(sp)
    800058f6:	7906                	ld	s2,96(sp)
    800058f8:	69e6                	ld	s3,88(sp)
    800058fa:	6a46                	ld	s4,80(sp)
    800058fc:	6aa6                	ld	s5,72(sp)
    800058fe:	6b06                	ld	s6,64(sp)
    80005900:	7be2                	ld	s7,56(sp)
    80005902:	7c42                	ld	s8,48(sp)
    80005904:	7ca2                	ld	s9,40(sp)
    80005906:	7d02                	ld	s10,32(sp)
    80005908:	6de2                	ld	s11,24(sp)
    8000590a:	6109                	addi	sp,sp,128
    8000590c:	8082                	ret
      if(n < target){
    8000590e:	000a071b          	sext.w	a4,s4
    80005912:	fb777be3          	bgeu	a4,s7,800058c8 <consoleread+0xc6>
        cons.r--;
    80005916:	0001c717          	auipc	a4,0x1c
    8000591a:	3af72923          	sw	a5,946(a4) # 80021cc8 <cons+0x98>
    8000591e:	b76d                	j	800058c8 <consoleread+0xc6>

0000000080005920 <consputc>:
{
    80005920:	1141                	addi	sp,sp,-16
    80005922:	e406                	sd	ra,8(sp)
    80005924:	e022                	sd	s0,0(sp)
    80005926:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005928:	10000793          	li	a5,256
    8000592c:	00f50a63          	beq	a0,a5,80005940 <consputc+0x20>
    uartputc_sync(c);
    80005930:	00000097          	auipc	ra,0x0
    80005934:	564080e7          	jalr	1380(ra) # 80005e94 <uartputc_sync>
}
    80005938:	60a2                	ld	ra,8(sp)
    8000593a:	6402                	ld	s0,0(sp)
    8000593c:	0141                	addi	sp,sp,16
    8000593e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005940:	4521                	li	a0,8
    80005942:	00000097          	auipc	ra,0x0
    80005946:	552080e7          	jalr	1362(ra) # 80005e94 <uartputc_sync>
    8000594a:	02000513          	li	a0,32
    8000594e:	00000097          	auipc	ra,0x0
    80005952:	546080e7          	jalr	1350(ra) # 80005e94 <uartputc_sync>
    80005956:	4521                	li	a0,8
    80005958:	00000097          	auipc	ra,0x0
    8000595c:	53c080e7          	jalr	1340(ra) # 80005e94 <uartputc_sync>
    80005960:	bfe1                	j	80005938 <consputc+0x18>

0000000080005962 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005962:	1101                	addi	sp,sp,-32
    80005964:	ec06                	sd	ra,24(sp)
    80005966:	e822                	sd	s0,16(sp)
    80005968:	e426                	sd	s1,8(sp)
    8000596a:	e04a                	sd	s2,0(sp)
    8000596c:	1000                	addi	s0,sp,32
    8000596e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005970:	0001c517          	auipc	a0,0x1c
    80005974:	2c050513          	addi	a0,a0,704 # 80021c30 <cons>
    80005978:	00000097          	auipc	ra,0x0
    8000597c:	7b4080e7          	jalr	1972(ra) # 8000612c <acquire>

  switch(c){
    80005980:	47d5                	li	a5,21
    80005982:	0af48663          	beq	s1,a5,80005a2e <consoleintr+0xcc>
    80005986:	0297ca63          	blt	a5,s1,800059ba <consoleintr+0x58>
    8000598a:	47a1                	li	a5,8
    8000598c:	0ef48763          	beq	s1,a5,80005a7a <consoleintr+0x118>
    80005990:	47c1                	li	a5,16
    80005992:	10f49a63          	bne	s1,a5,80005aa6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005996:	ffffc097          	auipc	ra,0xffffc
    8000599a:	01a080e7          	jalr	26(ra) # 800019b0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000599e:	0001c517          	auipc	a0,0x1c
    800059a2:	29250513          	addi	a0,a0,658 # 80021c30 <cons>
    800059a6:	00001097          	auipc	ra,0x1
    800059aa:	83a080e7          	jalr	-1990(ra) # 800061e0 <release>
}
    800059ae:	60e2                	ld	ra,24(sp)
    800059b0:	6442                	ld	s0,16(sp)
    800059b2:	64a2                	ld	s1,8(sp)
    800059b4:	6902                	ld	s2,0(sp)
    800059b6:	6105                	addi	sp,sp,32
    800059b8:	8082                	ret
  switch(c){
    800059ba:	07f00793          	li	a5,127
    800059be:	0af48e63          	beq	s1,a5,80005a7a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800059c2:	0001c717          	auipc	a4,0x1c
    800059c6:	26e70713          	addi	a4,a4,622 # 80021c30 <cons>
    800059ca:	0a072783          	lw	a5,160(a4)
    800059ce:	09872703          	lw	a4,152(a4)
    800059d2:	9f99                	subw	a5,a5,a4
    800059d4:	07f00713          	li	a4,127
    800059d8:	fcf763e3          	bltu	a4,a5,8000599e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059dc:	47b5                	li	a5,13
    800059de:	0cf48763          	beq	s1,a5,80005aac <consoleintr+0x14a>
      consputc(c);
    800059e2:	8526                	mv	a0,s1
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	f3c080e7          	jalr	-196(ra) # 80005920 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800059ec:	0001c797          	auipc	a5,0x1c
    800059f0:	24478793          	addi	a5,a5,580 # 80021c30 <cons>
    800059f4:	0a07a683          	lw	a3,160(a5)
    800059f8:	0016871b          	addiw	a4,a3,1
    800059fc:	0007061b          	sext.w	a2,a4
    80005a00:	0ae7a023          	sw	a4,160(a5)
    80005a04:	07f6f693          	andi	a3,a3,127
    80005a08:	97b6                	add	a5,a5,a3
    80005a0a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a0e:	47a9                	li	a5,10
    80005a10:	0cf48563          	beq	s1,a5,80005ada <consoleintr+0x178>
    80005a14:	4791                	li	a5,4
    80005a16:	0cf48263          	beq	s1,a5,80005ada <consoleintr+0x178>
    80005a1a:	0001c797          	auipc	a5,0x1c
    80005a1e:	2ae7a783          	lw	a5,686(a5) # 80021cc8 <cons+0x98>
    80005a22:	9f1d                	subw	a4,a4,a5
    80005a24:	08000793          	li	a5,128
    80005a28:	f6f71be3          	bne	a4,a5,8000599e <consoleintr+0x3c>
    80005a2c:	a07d                	j	80005ada <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a2e:	0001c717          	auipc	a4,0x1c
    80005a32:	20270713          	addi	a4,a4,514 # 80021c30 <cons>
    80005a36:	0a072783          	lw	a5,160(a4)
    80005a3a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a3e:	0001c497          	auipc	s1,0x1c
    80005a42:	1f248493          	addi	s1,s1,498 # 80021c30 <cons>
    while(cons.e != cons.w &&
    80005a46:	4929                	li	s2,10
    80005a48:	f4f70be3          	beq	a4,a5,8000599e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005a4c:	37fd                	addiw	a5,a5,-1
    80005a4e:	07f7f713          	andi	a4,a5,127
    80005a52:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a54:	01874703          	lbu	a4,24(a4)
    80005a58:	f52703e3          	beq	a4,s2,8000599e <consoleintr+0x3c>
      cons.e--;
    80005a5c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a60:	10000513          	li	a0,256
    80005a64:	00000097          	auipc	ra,0x0
    80005a68:	ebc080e7          	jalr	-324(ra) # 80005920 <consputc>
    while(cons.e != cons.w &&
    80005a6c:	0a04a783          	lw	a5,160(s1)
    80005a70:	09c4a703          	lw	a4,156(s1)
    80005a74:	fcf71ce3          	bne	a4,a5,80005a4c <consoleintr+0xea>
    80005a78:	b71d                	j	8000599e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a7a:	0001c717          	auipc	a4,0x1c
    80005a7e:	1b670713          	addi	a4,a4,438 # 80021c30 <cons>
    80005a82:	0a072783          	lw	a5,160(a4)
    80005a86:	09c72703          	lw	a4,156(a4)
    80005a8a:	f0f70ae3          	beq	a4,a5,8000599e <consoleintr+0x3c>
      cons.e--;
    80005a8e:	37fd                	addiw	a5,a5,-1
    80005a90:	0001c717          	auipc	a4,0x1c
    80005a94:	24f72023          	sw	a5,576(a4) # 80021cd0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a98:	10000513          	li	a0,256
    80005a9c:	00000097          	auipc	ra,0x0
    80005aa0:	e84080e7          	jalr	-380(ra) # 80005920 <consputc>
    80005aa4:	bded                	j	8000599e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005aa6:	ee048ce3          	beqz	s1,8000599e <consoleintr+0x3c>
    80005aaa:	bf21                	j	800059c2 <consoleintr+0x60>
      consputc(c);
    80005aac:	4529                	li	a0,10
    80005aae:	00000097          	auipc	ra,0x0
    80005ab2:	e72080e7          	jalr	-398(ra) # 80005920 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ab6:	0001c797          	auipc	a5,0x1c
    80005aba:	17a78793          	addi	a5,a5,378 # 80021c30 <cons>
    80005abe:	0a07a703          	lw	a4,160(a5)
    80005ac2:	0017069b          	addiw	a3,a4,1
    80005ac6:	0006861b          	sext.w	a2,a3
    80005aca:	0ad7a023          	sw	a3,160(a5)
    80005ace:	07f77713          	andi	a4,a4,127
    80005ad2:	97ba                	add	a5,a5,a4
    80005ad4:	4729                	li	a4,10
    80005ad6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ada:	0001c797          	auipc	a5,0x1c
    80005ade:	1ec7a923          	sw	a2,498(a5) # 80021ccc <cons+0x9c>
        wakeup(&cons.r);
    80005ae2:	0001c517          	auipc	a0,0x1c
    80005ae6:	1e650513          	addi	a0,a0,486 # 80021cc8 <cons+0x98>
    80005aea:	ffffc097          	auipc	ra,0xffffc
    80005aee:	a76080e7          	jalr	-1418(ra) # 80001560 <wakeup>
    80005af2:	b575                	j	8000599e <consoleintr+0x3c>

0000000080005af4 <consoleinit>:

void
consoleinit(void)
{
    80005af4:	1141                	addi	sp,sp,-16
    80005af6:	e406                	sd	ra,8(sp)
    80005af8:	e022                	sd	s0,0(sp)
    80005afa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005afc:	00003597          	auipc	a1,0x3
    80005b00:	cc458593          	addi	a1,a1,-828 # 800087c0 <syscalls+0x3f0>
    80005b04:	0001c517          	auipc	a0,0x1c
    80005b08:	12c50513          	addi	a0,a0,300 # 80021c30 <cons>
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	590080e7          	jalr	1424(ra) # 8000609c <initlock>

  uartinit();
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	330080e7          	jalr	816(ra) # 80005e44 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b1c:	00013797          	auipc	a5,0x13
    80005b20:	e3c78793          	addi	a5,a5,-452 # 80018958 <devsw>
    80005b24:	00000717          	auipc	a4,0x0
    80005b28:	cde70713          	addi	a4,a4,-802 # 80005802 <consoleread>
    80005b2c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b2e:	00000717          	auipc	a4,0x0
    80005b32:	c7270713          	addi	a4,a4,-910 # 800057a0 <consolewrite>
    80005b36:	ef98                	sd	a4,24(a5)
}
    80005b38:	60a2                	ld	ra,8(sp)
    80005b3a:	6402                	ld	s0,0(sp)
    80005b3c:	0141                	addi	sp,sp,16
    80005b3e:	8082                	ret

0000000080005b40 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b40:	7179                	addi	sp,sp,-48
    80005b42:	f406                	sd	ra,40(sp)
    80005b44:	f022                	sd	s0,32(sp)
    80005b46:	ec26                	sd	s1,24(sp)
    80005b48:	e84a                	sd	s2,16(sp)
    80005b4a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b4c:	c219                	beqz	a2,80005b52 <printint+0x12>
    80005b4e:	08054663          	bltz	a0,80005bda <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005b52:	2501                	sext.w	a0,a0
    80005b54:	4881                	li	a7,0
    80005b56:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b5a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b5c:	2581                	sext.w	a1,a1
    80005b5e:	00003617          	auipc	a2,0x3
    80005b62:	c9260613          	addi	a2,a2,-878 # 800087f0 <digits>
    80005b66:	883a                	mv	a6,a4
    80005b68:	2705                	addiw	a4,a4,1
    80005b6a:	02b577bb          	remuw	a5,a0,a1
    80005b6e:	1782                	slli	a5,a5,0x20
    80005b70:	9381                	srli	a5,a5,0x20
    80005b72:	97b2                	add	a5,a5,a2
    80005b74:	0007c783          	lbu	a5,0(a5)
    80005b78:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b7c:	0005079b          	sext.w	a5,a0
    80005b80:	02b5553b          	divuw	a0,a0,a1
    80005b84:	0685                	addi	a3,a3,1
    80005b86:	feb7f0e3          	bgeu	a5,a1,80005b66 <printint+0x26>

  if(sign)
    80005b8a:	00088b63          	beqz	a7,80005ba0 <printint+0x60>
    buf[i++] = '-';
    80005b8e:	fe040793          	addi	a5,s0,-32
    80005b92:	973e                	add	a4,a4,a5
    80005b94:	02d00793          	li	a5,45
    80005b98:	fef70823          	sb	a5,-16(a4)
    80005b9c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ba0:	02e05763          	blez	a4,80005bce <printint+0x8e>
    80005ba4:	fd040793          	addi	a5,s0,-48
    80005ba8:	00e784b3          	add	s1,a5,a4
    80005bac:	fff78913          	addi	s2,a5,-1
    80005bb0:	993a                	add	s2,s2,a4
    80005bb2:	377d                	addiw	a4,a4,-1
    80005bb4:	1702                	slli	a4,a4,0x20
    80005bb6:	9301                	srli	a4,a4,0x20
    80005bb8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bbc:	fff4c503          	lbu	a0,-1(s1)
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	d60080e7          	jalr	-672(ra) # 80005920 <consputc>
  while(--i >= 0)
    80005bc8:	14fd                	addi	s1,s1,-1
    80005bca:	ff2499e3          	bne	s1,s2,80005bbc <printint+0x7c>
}
    80005bce:	70a2                	ld	ra,40(sp)
    80005bd0:	7402                	ld	s0,32(sp)
    80005bd2:	64e2                	ld	s1,24(sp)
    80005bd4:	6942                	ld	s2,16(sp)
    80005bd6:	6145                	addi	sp,sp,48
    80005bd8:	8082                	ret
    x = -xx;
    80005bda:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bde:	4885                	li	a7,1
    x = -xx;
    80005be0:	bf9d                	j	80005b56 <printint+0x16>

0000000080005be2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005be2:	1101                	addi	sp,sp,-32
    80005be4:	ec06                	sd	ra,24(sp)
    80005be6:	e822                	sd	s0,16(sp)
    80005be8:	e426                	sd	s1,8(sp)
    80005bea:	1000                	addi	s0,sp,32
    80005bec:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005bee:	0001c797          	auipc	a5,0x1c
    80005bf2:	1007a123          	sw	zero,258(a5) # 80021cf0 <pr+0x18>
  printf("panic: ");
    80005bf6:	00003517          	auipc	a0,0x3
    80005bfa:	bd250513          	addi	a0,a0,-1070 # 800087c8 <syscalls+0x3f8>
    80005bfe:	00000097          	auipc	ra,0x0
    80005c02:	02e080e7          	jalr	46(ra) # 80005c2c <printf>
  printf(s);
    80005c06:	8526                	mv	a0,s1
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	024080e7          	jalr	36(ra) # 80005c2c <printf>
  printf("\n");
    80005c10:	00002517          	auipc	a0,0x2
    80005c14:	43850513          	addi	a0,a0,1080 # 80008048 <etext+0x48>
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	014080e7          	jalr	20(ra) # 80005c2c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c20:	4785                	li	a5,1
    80005c22:	00003717          	auipc	a4,0x3
    80005c26:	c8f72523          	sw	a5,-886(a4) # 800088ac <panicked>
  for(;;)
    80005c2a:	a001                	j	80005c2a <panic+0x48>

0000000080005c2c <printf>:
{
    80005c2c:	7131                	addi	sp,sp,-192
    80005c2e:	fc86                	sd	ra,120(sp)
    80005c30:	f8a2                	sd	s0,112(sp)
    80005c32:	f4a6                	sd	s1,104(sp)
    80005c34:	f0ca                	sd	s2,96(sp)
    80005c36:	ecce                	sd	s3,88(sp)
    80005c38:	e8d2                	sd	s4,80(sp)
    80005c3a:	e4d6                	sd	s5,72(sp)
    80005c3c:	e0da                	sd	s6,64(sp)
    80005c3e:	fc5e                	sd	s7,56(sp)
    80005c40:	f862                	sd	s8,48(sp)
    80005c42:	f466                	sd	s9,40(sp)
    80005c44:	f06a                	sd	s10,32(sp)
    80005c46:	ec6e                	sd	s11,24(sp)
    80005c48:	0100                	addi	s0,sp,128
    80005c4a:	8a2a                	mv	s4,a0
    80005c4c:	e40c                	sd	a1,8(s0)
    80005c4e:	e810                	sd	a2,16(s0)
    80005c50:	ec14                	sd	a3,24(s0)
    80005c52:	f018                	sd	a4,32(s0)
    80005c54:	f41c                	sd	a5,40(s0)
    80005c56:	03043823          	sd	a6,48(s0)
    80005c5a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c5e:	0001cd97          	auipc	s11,0x1c
    80005c62:	092dad83          	lw	s11,146(s11) # 80021cf0 <pr+0x18>
  if(locking)
    80005c66:	020d9b63          	bnez	s11,80005c9c <printf+0x70>
  if (fmt == 0)
    80005c6a:	040a0263          	beqz	s4,80005cae <printf+0x82>
  va_start(ap, fmt);
    80005c6e:	00840793          	addi	a5,s0,8
    80005c72:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c76:	000a4503          	lbu	a0,0(s4)
    80005c7a:	16050263          	beqz	a0,80005dde <printf+0x1b2>
    80005c7e:	4481                	li	s1,0
    if(c != '%'){
    80005c80:	02500a93          	li	s5,37
    switch(c){
    80005c84:	07000b13          	li	s6,112
  consputc('x');
    80005c88:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c8a:	00003b97          	auipc	s7,0x3
    80005c8e:	b66b8b93          	addi	s7,s7,-1178 # 800087f0 <digits>
    switch(c){
    80005c92:	07300c93          	li	s9,115
    80005c96:	06400c13          	li	s8,100
    80005c9a:	a82d                	j	80005cd4 <printf+0xa8>
    acquire(&pr.lock);
    80005c9c:	0001c517          	auipc	a0,0x1c
    80005ca0:	03c50513          	addi	a0,a0,60 # 80021cd8 <pr>
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	488080e7          	jalr	1160(ra) # 8000612c <acquire>
    80005cac:	bf7d                	j	80005c6a <printf+0x3e>
    panic("null fmt");
    80005cae:	00003517          	auipc	a0,0x3
    80005cb2:	b2a50513          	addi	a0,a0,-1238 # 800087d8 <syscalls+0x408>
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	f2c080e7          	jalr	-212(ra) # 80005be2 <panic>
      consputc(c);
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	c62080e7          	jalr	-926(ra) # 80005920 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cc6:	2485                	addiw	s1,s1,1
    80005cc8:	009a07b3          	add	a5,s4,s1
    80005ccc:	0007c503          	lbu	a0,0(a5)
    80005cd0:	10050763          	beqz	a0,80005dde <printf+0x1b2>
    if(c != '%'){
    80005cd4:	ff5515e3          	bne	a0,s5,80005cbe <printf+0x92>
    c = fmt[++i] & 0xff;
    80005cd8:	2485                	addiw	s1,s1,1
    80005cda:	009a07b3          	add	a5,s4,s1
    80005cde:	0007c783          	lbu	a5,0(a5)
    80005ce2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ce6:	cfe5                	beqz	a5,80005dde <printf+0x1b2>
    switch(c){
    80005ce8:	05678a63          	beq	a5,s6,80005d3c <printf+0x110>
    80005cec:	02fb7663          	bgeu	s6,a5,80005d18 <printf+0xec>
    80005cf0:	09978963          	beq	a5,s9,80005d82 <printf+0x156>
    80005cf4:	07800713          	li	a4,120
    80005cf8:	0ce79863          	bne	a5,a4,80005dc8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005cfc:	f8843783          	ld	a5,-120(s0)
    80005d00:	00878713          	addi	a4,a5,8
    80005d04:	f8e43423          	sd	a4,-120(s0)
    80005d08:	4605                	li	a2,1
    80005d0a:	85ea                	mv	a1,s10
    80005d0c:	4388                	lw	a0,0(a5)
    80005d0e:	00000097          	auipc	ra,0x0
    80005d12:	e32080e7          	jalr	-462(ra) # 80005b40 <printint>
      break;
    80005d16:	bf45                	j	80005cc6 <printf+0x9a>
    switch(c){
    80005d18:	0b578263          	beq	a5,s5,80005dbc <printf+0x190>
    80005d1c:	0b879663          	bne	a5,s8,80005dc8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d20:	f8843783          	ld	a5,-120(s0)
    80005d24:	00878713          	addi	a4,a5,8
    80005d28:	f8e43423          	sd	a4,-120(s0)
    80005d2c:	4605                	li	a2,1
    80005d2e:	45a9                	li	a1,10
    80005d30:	4388                	lw	a0,0(a5)
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	e0e080e7          	jalr	-498(ra) # 80005b40 <printint>
      break;
    80005d3a:	b771                	j	80005cc6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d3c:	f8843783          	ld	a5,-120(s0)
    80005d40:	00878713          	addi	a4,a5,8
    80005d44:	f8e43423          	sd	a4,-120(s0)
    80005d48:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005d4c:	03000513          	li	a0,48
    80005d50:	00000097          	auipc	ra,0x0
    80005d54:	bd0080e7          	jalr	-1072(ra) # 80005920 <consputc>
  consputc('x');
    80005d58:	07800513          	li	a0,120
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	bc4080e7          	jalr	-1084(ra) # 80005920 <consputc>
    80005d64:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d66:	03c9d793          	srli	a5,s3,0x3c
    80005d6a:	97de                	add	a5,a5,s7
    80005d6c:	0007c503          	lbu	a0,0(a5)
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	bb0080e7          	jalr	-1104(ra) # 80005920 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d78:	0992                	slli	s3,s3,0x4
    80005d7a:	397d                	addiw	s2,s2,-1
    80005d7c:	fe0915e3          	bnez	s2,80005d66 <printf+0x13a>
    80005d80:	b799                	j	80005cc6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d82:	f8843783          	ld	a5,-120(s0)
    80005d86:	00878713          	addi	a4,a5,8
    80005d8a:	f8e43423          	sd	a4,-120(s0)
    80005d8e:	0007b903          	ld	s2,0(a5)
    80005d92:	00090e63          	beqz	s2,80005dae <printf+0x182>
      for(; *s; s++)
    80005d96:	00094503          	lbu	a0,0(s2)
    80005d9a:	d515                	beqz	a0,80005cc6 <printf+0x9a>
        consputc(*s);
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	b84080e7          	jalr	-1148(ra) # 80005920 <consputc>
      for(; *s; s++)
    80005da4:	0905                	addi	s2,s2,1
    80005da6:	00094503          	lbu	a0,0(s2)
    80005daa:	f96d                	bnez	a0,80005d9c <printf+0x170>
    80005dac:	bf29                	j	80005cc6 <printf+0x9a>
        s = "(null)";
    80005dae:	00003917          	auipc	s2,0x3
    80005db2:	a2290913          	addi	s2,s2,-1502 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005db6:	02800513          	li	a0,40
    80005dba:	b7cd                	j	80005d9c <printf+0x170>
      consputc('%');
    80005dbc:	8556                	mv	a0,s5
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	b62080e7          	jalr	-1182(ra) # 80005920 <consputc>
      break;
    80005dc6:	b701                	j	80005cc6 <printf+0x9a>
      consputc('%');
    80005dc8:	8556                	mv	a0,s5
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	b56080e7          	jalr	-1194(ra) # 80005920 <consputc>
      consputc(c);
    80005dd2:	854a                	mv	a0,s2
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	b4c080e7          	jalr	-1204(ra) # 80005920 <consputc>
      break;
    80005ddc:	b5ed                	j	80005cc6 <printf+0x9a>
  if(locking)
    80005dde:	020d9163          	bnez	s11,80005e00 <printf+0x1d4>
}
    80005de2:	70e6                	ld	ra,120(sp)
    80005de4:	7446                	ld	s0,112(sp)
    80005de6:	74a6                	ld	s1,104(sp)
    80005de8:	7906                	ld	s2,96(sp)
    80005dea:	69e6                	ld	s3,88(sp)
    80005dec:	6a46                	ld	s4,80(sp)
    80005dee:	6aa6                	ld	s5,72(sp)
    80005df0:	6b06                	ld	s6,64(sp)
    80005df2:	7be2                	ld	s7,56(sp)
    80005df4:	7c42                	ld	s8,48(sp)
    80005df6:	7ca2                	ld	s9,40(sp)
    80005df8:	7d02                	ld	s10,32(sp)
    80005dfa:	6de2                	ld	s11,24(sp)
    80005dfc:	6129                	addi	sp,sp,192
    80005dfe:	8082                	ret
    release(&pr.lock);
    80005e00:	0001c517          	auipc	a0,0x1c
    80005e04:	ed850513          	addi	a0,a0,-296 # 80021cd8 <pr>
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	3d8080e7          	jalr	984(ra) # 800061e0 <release>
}
    80005e10:	bfc9                	j	80005de2 <printf+0x1b6>

0000000080005e12 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e12:	1101                	addi	sp,sp,-32
    80005e14:	ec06                	sd	ra,24(sp)
    80005e16:	e822                	sd	s0,16(sp)
    80005e18:	e426                	sd	s1,8(sp)
    80005e1a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e1c:	0001c497          	auipc	s1,0x1c
    80005e20:	ebc48493          	addi	s1,s1,-324 # 80021cd8 <pr>
    80005e24:	00003597          	auipc	a1,0x3
    80005e28:	9c458593          	addi	a1,a1,-1596 # 800087e8 <syscalls+0x418>
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	26e080e7          	jalr	622(ra) # 8000609c <initlock>
  pr.locking = 1;
    80005e36:	4785                	li	a5,1
    80005e38:	cc9c                	sw	a5,24(s1)
}
    80005e3a:	60e2                	ld	ra,24(sp)
    80005e3c:	6442                	ld	s0,16(sp)
    80005e3e:	64a2                	ld	s1,8(sp)
    80005e40:	6105                	addi	sp,sp,32
    80005e42:	8082                	ret

0000000080005e44 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e44:	1141                	addi	sp,sp,-16
    80005e46:	e406                	sd	ra,8(sp)
    80005e48:	e022                	sd	s0,0(sp)
    80005e4a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e4c:	100007b7          	lui	a5,0x10000
    80005e50:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e54:	f8000713          	li	a4,-128
    80005e58:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e5c:	470d                	li	a4,3
    80005e5e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e62:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e66:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e6a:	469d                	li	a3,7
    80005e6c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e70:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e74:	00003597          	auipc	a1,0x3
    80005e78:	99458593          	addi	a1,a1,-1644 # 80008808 <digits+0x18>
    80005e7c:	0001c517          	auipc	a0,0x1c
    80005e80:	e7c50513          	addi	a0,a0,-388 # 80021cf8 <uart_tx_lock>
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	218080e7          	jalr	536(ra) # 8000609c <initlock>
}
    80005e8c:	60a2                	ld	ra,8(sp)
    80005e8e:	6402                	ld	s0,0(sp)
    80005e90:	0141                	addi	sp,sp,16
    80005e92:	8082                	ret

0000000080005e94 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e94:	1101                	addi	sp,sp,-32
    80005e96:	ec06                	sd	ra,24(sp)
    80005e98:	e822                	sd	s0,16(sp)
    80005e9a:	e426                	sd	s1,8(sp)
    80005e9c:	1000                	addi	s0,sp,32
    80005e9e:	84aa                	mv	s1,a0
  push_off();
    80005ea0:	00000097          	auipc	ra,0x0
    80005ea4:	240080e7          	jalr	576(ra) # 800060e0 <push_off>

  if(panicked){
    80005ea8:	00003797          	auipc	a5,0x3
    80005eac:	a047a783          	lw	a5,-1532(a5) # 800088ac <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eb0:	10000737          	lui	a4,0x10000
  if(panicked){
    80005eb4:	c391                	beqz	a5,80005eb8 <uartputc_sync+0x24>
    for(;;)
    80005eb6:	a001                	j	80005eb6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005eb8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ebc:	0ff7f793          	andi	a5,a5,255
    80005ec0:	0207f793          	andi	a5,a5,32
    80005ec4:	dbf5                	beqz	a5,80005eb8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ec6:	0ff4f793          	andi	a5,s1,255
    80005eca:	10000737          	lui	a4,0x10000
    80005ece:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	2ae080e7          	jalr	686(ra) # 80006180 <pop_off>
}
    80005eda:	60e2                	ld	ra,24(sp)
    80005edc:	6442                	ld	s0,16(sp)
    80005ede:	64a2                	ld	s1,8(sp)
    80005ee0:	6105                	addi	sp,sp,32
    80005ee2:	8082                	ret

0000000080005ee4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ee4:	00003717          	auipc	a4,0x3
    80005ee8:	9cc73703          	ld	a4,-1588(a4) # 800088b0 <uart_tx_r>
    80005eec:	00003797          	auipc	a5,0x3
    80005ef0:	9cc7b783          	ld	a5,-1588(a5) # 800088b8 <uart_tx_w>
    80005ef4:	06e78c63          	beq	a5,a4,80005f6c <uartstart+0x88>
{
    80005ef8:	7139                	addi	sp,sp,-64
    80005efa:	fc06                	sd	ra,56(sp)
    80005efc:	f822                	sd	s0,48(sp)
    80005efe:	f426                	sd	s1,40(sp)
    80005f00:	f04a                	sd	s2,32(sp)
    80005f02:	ec4e                	sd	s3,24(sp)
    80005f04:	e852                	sd	s4,16(sp)
    80005f06:	e456                	sd	s5,8(sp)
    80005f08:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f0a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f0e:	0001ca17          	auipc	s4,0x1c
    80005f12:	deaa0a13          	addi	s4,s4,-534 # 80021cf8 <uart_tx_lock>
    uart_tx_r += 1;
    80005f16:	00003497          	auipc	s1,0x3
    80005f1a:	99a48493          	addi	s1,s1,-1638 # 800088b0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f1e:	00003997          	auipc	s3,0x3
    80005f22:	99a98993          	addi	s3,s3,-1638 # 800088b8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f26:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f2a:	0ff7f793          	andi	a5,a5,255
    80005f2e:	0207f793          	andi	a5,a5,32
    80005f32:	c785                	beqz	a5,80005f5a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f34:	01f77793          	andi	a5,a4,31
    80005f38:	97d2                	add	a5,a5,s4
    80005f3a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005f3e:	0705                	addi	a4,a4,1
    80005f40:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f42:	8526                	mv	a0,s1
    80005f44:	ffffb097          	auipc	ra,0xffffb
    80005f48:	61c080e7          	jalr	1564(ra) # 80001560 <wakeup>
    
    WriteReg(THR, c);
    80005f4c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f50:	6098                	ld	a4,0(s1)
    80005f52:	0009b783          	ld	a5,0(s3)
    80005f56:	fce798e3          	bne	a5,a4,80005f26 <uartstart+0x42>
  }
}
    80005f5a:	70e2                	ld	ra,56(sp)
    80005f5c:	7442                	ld	s0,48(sp)
    80005f5e:	74a2                	ld	s1,40(sp)
    80005f60:	7902                	ld	s2,32(sp)
    80005f62:	69e2                	ld	s3,24(sp)
    80005f64:	6a42                	ld	s4,16(sp)
    80005f66:	6aa2                	ld	s5,8(sp)
    80005f68:	6121                	addi	sp,sp,64
    80005f6a:	8082                	ret
    80005f6c:	8082                	ret

0000000080005f6e <uartputc>:
{
    80005f6e:	7179                	addi	sp,sp,-48
    80005f70:	f406                	sd	ra,40(sp)
    80005f72:	f022                	sd	s0,32(sp)
    80005f74:	ec26                	sd	s1,24(sp)
    80005f76:	e84a                	sd	s2,16(sp)
    80005f78:	e44e                	sd	s3,8(sp)
    80005f7a:	e052                	sd	s4,0(sp)
    80005f7c:	1800                	addi	s0,sp,48
    80005f7e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005f80:	0001c517          	auipc	a0,0x1c
    80005f84:	d7850513          	addi	a0,a0,-648 # 80021cf8 <uart_tx_lock>
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	1a4080e7          	jalr	420(ra) # 8000612c <acquire>
  if(panicked){
    80005f90:	00003797          	auipc	a5,0x3
    80005f94:	91c7a783          	lw	a5,-1764(a5) # 800088ac <panicked>
    80005f98:	e7c9                	bnez	a5,80006022 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f9a:	00003797          	auipc	a5,0x3
    80005f9e:	91e7b783          	ld	a5,-1762(a5) # 800088b8 <uart_tx_w>
    80005fa2:	00003717          	auipc	a4,0x3
    80005fa6:	90e73703          	ld	a4,-1778(a4) # 800088b0 <uart_tx_r>
    80005faa:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fae:	0001ca17          	auipc	s4,0x1c
    80005fb2:	d4aa0a13          	addi	s4,s4,-694 # 80021cf8 <uart_tx_lock>
    80005fb6:	00003497          	auipc	s1,0x3
    80005fba:	8fa48493          	addi	s1,s1,-1798 # 800088b0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fbe:	00003917          	auipc	s2,0x3
    80005fc2:	8fa90913          	addi	s2,s2,-1798 # 800088b8 <uart_tx_w>
    80005fc6:	00f71f63          	bne	a4,a5,80005fe4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005fca:	85d2                	mv	a1,s4
    80005fcc:	8526                	mv	a0,s1
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	52e080e7          	jalr	1326(ra) # 800014fc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fd6:	00093783          	ld	a5,0(s2)
    80005fda:	6098                	ld	a4,0(s1)
    80005fdc:	02070713          	addi	a4,a4,32
    80005fe0:	fef705e3          	beq	a4,a5,80005fca <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005fe4:	0001c497          	auipc	s1,0x1c
    80005fe8:	d1448493          	addi	s1,s1,-748 # 80021cf8 <uart_tx_lock>
    80005fec:	01f7f713          	andi	a4,a5,31
    80005ff0:	9726                	add	a4,a4,s1
    80005ff2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80005ff6:	0785                	addi	a5,a5,1
    80005ff8:	00003717          	auipc	a4,0x3
    80005ffc:	8cf73023          	sd	a5,-1856(a4) # 800088b8 <uart_tx_w>
  uartstart();
    80006000:	00000097          	auipc	ra,0x0
    80006004:	ee4080e7          	jalr	-284(ra) # 80005ee4 <uartstart>
  release(&uart_tx_lock);
    80006008:	8526                	mv	a0,s1
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	1d6080e7          	jalr	470(ra) # 800061e0 <release>
}
    80006012:	70a2                	ld	ra,40(sp)
    80006014:	7402                	ld	s0,32(sp)
    80006016:	64e2                	ld	s1,24(sp)
    80006018:	6942                	ld	s2,16(sp)
    8000601a:	69a2                	ld	s3,8(sp)
    8000601c:	6a02                	ld	s4,0(sp)
    8000601e:	6145                	addi	sp,sp,48
    80006020:	8082                	ret
    for(;;)
    80006022:	a001                	j	80006022 <uartputc+0xb4>

0000000080006024 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006024:	1141                	addi	sp,sp,-16
    80006026:	e422                	sd	s0,8(sp)
    80006028:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000602a:	100007b7          	lui	a5,0x10000
    8000602e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006032:	8b85                	andi	a5,a5,1
    80006034:	cb91                	beqz	a5,80006048 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006036:	100007b7          	lui	a5,0x10000
    8000603a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000603e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006042:	6422                	ld	s0,8(sp)
    80006044:	0141                	addi	sp,sp,16
    80006046:	8082                	ret
    return -1;
    80006048:	557d                	li	a0,-1
    8000604a:	bfe5                	j	80006042 <uartgetc+0x1e>

000000008000604c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000604c:	1101                	addi	sp,sp,-32
    8000604e:	ec06                	sd	ra,24(sp)
    80006050:	e822                	sd	s0,16(sp)
    80006052:	e426                	sd	s1,8(sp)
    80006054:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006056:	54fd                	li	s1,-1
    int c = uartgetc();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	fcc080e7          	jalr	-52(ra) # 80006024 <uartgetc>
    if(c == -1)
    80006060:	00950763          	beq	a0,s1,8000606e <uartintr+0x22>
      break;
    consoleintr(c);
    80006064:	00000097          	auipc	ra,0x0
    80006068:	8fe080e7          	jalr	-1794(ra) # 80005962 <consoleintr>
  while(1){
    8000606c:	b7f5                	j	80006058 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000606e:	0001c497          	auipc	s1,0x1c
    80006072:	c8a48493          	addi	s1,s1,-886 # 80021cf8 <uart_tx_lock>
    80006076:	8526                	mv	a0,s1
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	0b4080e7          	jalr	180(ra) # 8000612c <acquire>
  uartstart();
    80006080:	00000097          	auipc	ra,0x0
    80006084:	e64080e7          	jalr	-412(ra) # 80005ee4 <uartstart>
  release(&uart_tx_lock);
    80006088:	8526                	mv	a0,s1
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	156080e7          	jalr	342(ra) # 800061e0 <release>
}
    80006092:	60e2                	ld	ra,24(sp)
    80006094:	6442                	ld	s0,16(sp)
    80006096:	64a2                	ld	s1,8(sp)
    80006098:	6105                	addi	sp,sp,32
    8000609a:	8082                	ret

000000008000609c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000609c:	1141                	addi	sp,sp,-16
    8000609e:	e422                	sd	s0,8(sp)
    800060a0:	0800                	addi	s0,sp,16
  lk->name = name;
    800060a2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060a4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060a8:	00053823          	sd	zero,16(a0)
}
    800060ac:	6422                	ld	s0,8(sp)
    800060ae:	0141                	addi	sp,sp,16
    800060b0:	8082                	ret

00000000800060b2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060b2:	411c                	lw	a5,0(a0)
    800060b4:	e399                	bnez	a5,800060ba <holding+0x8>
    800060b6:	4501                	li	a0,0
  return r;
}
    800060b8:	8082                	ret
{
    800060ba:	1101                	addi	sp,sp,-32
    800060bc:	ec06                	sd	ra,24(sp)
    800060be:	e822                	sd	s0,16(sp)
    800060c0:	e426                	sd	s1,8(sp)
    800060c2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800060c4:	6904                	ld	s1,16(a0)
    800060c6:	ffffb097          	auipc	ra,0xffffb
    800060ca:	d76080e7          	jalr	-650(ra) # 80000e3c <mycpu>
    800060ce:	40a48533          	sub	a0,s1,a0
    800060d2:	00153513          	seqz	a0,a0
}
    800060d6:	60e2                	ld	ra,24(sp)
    800060d8:	6442                	ld	s0,16(sp)
    800060da:	64a2                	ld	s1,8(sp)
    800060dc:	6105                	addi	sp,sp,32
    800060de:	8082                	ret

00000000800060e0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800060e0:	1101                	addi	sp,sp,-32
    800060e2:	ec06                	sd	ra,24(sp)
    800060e4:	e822                	sd	s0,16(sp)
    800060e6:	e426                	sd	s1,8(sp)
    800060e8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060ea:	100024f3          	csrr	s1,sstatus
    800060ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060f2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060f4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060f8:	ffffb097          	auipc	ra,0xffffb
    800060fc:	d44080e7          	jalr	-700(ra) # 80000e3c <mycpu>
    80006100:	5d3c                	lw	a5,120(a0)
    80006102:	cf89                	beqz	a5,8000611c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006104:	ffffb097          	auipc	ra,0xffffb
    80006108:	d38080e7          	jalr	-712(ra) # 80000e3c <mycpu>
    8000610c:	5d3c                	lw	a5,120(a0)
    8000610e:	2785                	addiw	a5,a5,1
    80006110:	dd3c                	sw	a5,120(a0)
}
    80006112:	60e2                	ld	ra,24(sp)
    80006114:	6442                	ld	s0,16(sp)
    80006116:	64a2                	ld	s1,8(sp)
    80006118:	6105                	addi	sp,sp,32
    8000611a:	8082                	ret
    mycpu()->intena = old;
    8000611c:	ffffb097          	auipc	ra,0xffffb
    80006120:	d20080e7          	jalr	-736(ra) # 80000e3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006124:	8085                	srli	s1,s1,0x1
    80006126:	8885                	andi	s1,s1,1
    80006128:	dd64                	sw	s1,124(a0)
    8000612a:	bfe9                	j	80006104 <push_off+0x24>

000000008000612c <acquire>:
{
    8000612c:	1101                	addi	sp,sp,-32
    8000612e:	ec06                	sd	ra,24(sp)
    80006130:	e822                	sd	s0,16(sp)
    80006132:	e426                	sd	s1,8(sp)
    80006134:	1000                	addi	s0,sp,32
    80006136:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	fa8080e7          	jalr	-88(ra) # 800060e0 <push_off>
  if(holding(lk))
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	f70080e7          	jalr	-144(ra) # 800060b2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000614a:	4705                	li	a4,1
  if(holding(lk))
    8000614c:	e115                	bnez	a0,80006170 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000614e:	87ba                	mv	a5,a4
    80006150:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006154:	2781                	sext.w	a5,a5
    80006156:	ffe5                	bnez	a5,8000614e <acquire+0x22>
  __sync_synchronize();
    80006158:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000615c:	ffffb097          	auipc	ra,0xffffb
    80006160:	ce0080e7          	jalr	-800(ra) # 80000e3c <mycpu>
    80006164:	e888                	sd	a0,16(s1)
}
    80006166:	60e2                	ld	ra,24(sp)
    80006168:	6442                	ld	s0,16(sp)
    8000616a:	64a2                	ld	s1,8(sp)
    8000616c:	6105                	addi	sp,sp,32
    8000616e:	8082                	ret
    panic("acquire");
    80006170:	00002517          	auipc	a0,0x2
    80006174:	6a050513          	addi	a0,a0,1696 # 80008810 <digits+0x20>
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	a6a080e7          	jalr	-1430(ra) # 80005be2 <panic>

0000000080006180 <pop_off>:

void
pop_off(void)
{
    80006180:	1141                	addi	sp,sp,-16
    80006182:	e406                	sd	ra,8(sp)
    80006184:	e022                	sd	s0,0(sp)
    80006186:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006188:	ffffb097          	auipc	ra,0xffffb
    8000618c:	cb4080e7          	jalr	-844(ra) # 80000e3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006190:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006194:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006196:	e78d                	bnez	a5,800061c0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006198:	5d3c                	lw	a5,120(a0)
    8000619a:	02f05b63          	blez	a5,800061d0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000619e:	37fd                	addiw	a5,a5,-1
    800061a0:	0007871b          	sext.w	a4,a5
    800061a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061a6:	eb09                	bnez	a4,800061b8 <pop_off+0x38>
    800061a8:	5d7c                	lw	a5,124(a0)
    800061aa:	c799                	beqz	a5,800061b8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800061b8:	60a2                	ld	ra,8(sp)
    800061ba:	6402                	ld	s0,0(sp)
    800061bc:	0141                	addi	sp,sp,16
    800061be:	8082                	ret
    panic("pop_off - interruptible");
    800061c0:	00002517          	auipc	a0,0x2
    800061c4:	65850513          	addi	a0,a0,1624 # 80008818 <digits+0x28>
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	a1a080e7          	jalr	-1510(ra) # 80005be2 <panic>
    panic("pop_off");
    800061d0:	00002517          	auipc	a0,0x2
    800061d4:	66050513          	addi	a0,a0,1632 # 80008830 <digits+0x40>
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	a0a080e7          	jalr	-1526(ra) # 80005be2 <panic>

00000000800061e0 <release>:
{
    800061e0:	1101                	addi	sp,sp,-32
    800061e2:	ec06                	sd	ra,24(sp)
    800061e4:	e822                	sd	s0,16(sp)
    800061e6:	e426                	sd	s1,8(sp)
    800061e8:	1000                	addi	s0,sp,32
    800061ea:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	ec6080e7          	jalr	-314(ra) # 800060b2 <holding>
    800061f4:	c115                	beqz	a0,80006218 <release+0x38>
  lk->cpu = 0;
    800061f6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061fa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061fe:	0f50000f          	fence	iorw,ow
    80006202:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	f7a080e7          	jalr	-134(ra) # 80006180 <pop_off>
}
    8000620e:	60e2                	ld	ra,24(sp)
    80006210:	6442                	ld	s0,16(sp)
    80006212:	64a2                	ld	s1,8(sp)
    80006214:	6105                	addi	sp,sp,32
    80006216:	8082                	ret
    panic("release");
    80006218:	00002517          	auipc	a0,0x2
    8000621c:	62050513          	addi	a0,a0,1568 # 80008838 <digits+0x48>
    80006220:	00000097          	auipc	ra,0x0
    80006224:	9c2080e7          	jalr	-1598(ra) # 80005be2 <panic>
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
