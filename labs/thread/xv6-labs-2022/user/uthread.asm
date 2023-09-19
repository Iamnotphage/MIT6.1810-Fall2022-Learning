
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d6278793          	addi	a5,a5,-670 # d68 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d4f73523          	sd	a5,-694(a4) # d58 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d4f72823          	sw	a5,-688(a4) # 2d68 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d2a33303          	ld	t1,-726(t1) # d58 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb3f>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f0880813          	addi	a6,a6,-248 # 8f48 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb3f>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d0258593          	addi	a1,a1,-766 # d68 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	bb050513          	addi	a0,a0,-1104 # c20 <malloc+0xea>
  78:	00001097          	auipc	ra,0x1
  7c:	a00080e7          	jalr	-1536(ra) # a78 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	67e080e7          	jalr	1662(ra) # 700 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	ccb7b023          	sd	a1,-832(a5) # d58 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64)&t->context, (uint64)&next_thread->context);
  a0:	0521                	addi	a0,a0,8
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	360080e7          	jalr	864(ra) # 406 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	cac78793          	addi	a5,a5,-852 # d68 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb3f>
  ca:	00009617          	auipc	a2,0x9
  ce:	e7e60613          	addi	a2,a2,-386 # 8f48 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	00e786b3          	add	a3,a5,a4
  e6:	4609                	li	a2,2
  e8:	c290                	sw	a2,0(a3)
  // YOUR CODE HERE
  t->context.ra = (uint64)func;
  ea:	e688                	sd	a0,8(a3)
  t->context.sp = (uint64)(t->stack) + STACK_SIZE - 1; // sp points stack base
  ec:	177d                	addi	a4,a4,-1
  ee:	97ba                	add	a5,a5,a4
  f0:	ea9c                	sd	a5,16(a3)
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <thread_yield>:

void 
thread_yield(void)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
 100:	00001797          	auipc	a5,0x1
 104:	c587b783          	ld	a5,-936(a5) # d58 <current_thread>
 108:	6709                	lui	a4,0x2
 10a:	97ba                	add	a5,a5,a4
 10c:	4709                	li	a4,2
 10e:	c398                	sw	a4,0(a5)
  thread_schedule();
 110:	00000097          	auipc	ra,0x0
 114:	f16080e7          	jalr	-234(ra) # 26 <thread_schedule>
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 120:	7179                	addi	sp,sp,-48
 122:	f406                	sd	ra,40(sp)
 124:	f022                	sd	s0,32(sp)
 126:	ec26                	sd	s1,24(sp)
 128:	e84a                	sd	s2,16(sp)
 12a:	e44e                	sd	s3,8(sp)
 12c:	e052                	sd	s4,0(sp)
 12e:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 130:	00001517          	auipc	a0,0x1
 134:	b1850513          	addi	a0,a0,-1256 # c48 <malloc+0x112>
 138:	00001097          	auipc	ra,0x1
 13c:	940080e7          	jalr	-1728(ra) # a78 <printf>
  a_started = 1;
 140:	4785                	li	a5,1
 142:	00001717          	auipc	a4,0x1
 146:	c0f72923          	sw	a5,-1006(a4) # d54 <a_started>
  while(b_started == 0 || c_started == 0)
 14a:	00001497          	auipc	s1,0x1
 14e:	c0648493          	addi	s1,s1,-1018 # d50 <b_started>
 152:	00001917          	auipc	s2,0x1
 156:	bfa90913          	addi	s2,s2,-1030 # d4c <c_started>
 15a:	a029                	j	164 <thread_a+0x44>
    thread_yield();
 15c:	00000097          	auipc	ra,0x0
 160:	f9c080e7          	jalr	-100(ra) # f8 <thread_yield>
  while(b_started == 0 || c_started == 0)
 164:	409c                	lw	a5,0(s1)
 166:	2781                	sext.w	a5,a5
 168:	dbf5                	beqz	a5,15c <thread_a+0x3c>
 16a:	00092783          	lw	a5,0(s2)
 16e:	2781                	sext.w	a5,a5
 170:	d7f5                	beqz	a5,15c <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 172:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 174:	00001a17          	auipc	s4,0x1
 178:	aeca0a13          	addi	s4,s4,-1300 # c60 <malloc+0x12a>
    a_n += 1;
 17c:	00001917          	auipc	s2,0x1
 180:	bcc90913          	addi	s2,s2,-1076 # d48 <a_n>
  for (i = 0; i < 100; i++) {
 184:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 188:	85a6                	mv	a1,s1
 18a:	8552                	mv	a0,s4
 18c:	00001097          	auipc	ra,0x1
 190:	8ec080e7          	jalr	-1812(ra) # a78 <printf>
    a_n += 1;
 194:	00092783          	lw	a5,0(s2)
 198:	2785                	addiw	a5,a5,1
 19a:	00f92023          	sw	a5,0(s2)
    thread_yield();
 19e:	00000097          	auipc	ra,0x0
 1a2:	f5a080e7          	jalr	-166(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a6:	2485                	addiw	s1,s1,1
 1a8:	ff3490e3          	bne	s1,s3,188 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1ac:	00001597          	auipc	a1,0x1
 1b0:	b9c5a583          	lw	a1,-1124(a1) # d48 <a_n>
 1b4:	00001517          	auipc	a0,0x1
 1b8:	abc50513          	addi	a0,a0,-1348 # c70 <malloc+0x13a>
 1bc:	00001097          	auipc	ra,0x1
 1c0:	8bc080e7          	jalr	-1860(ra) # a78 <printf>

  current_thread->state = FREE;
 1c4:	00001797          	auipc	a5,0x1
 1c8:	b947b783          	ld	a5,-1132(a5) # d58 <current_thread>
 1cc:	6709                	lui	a4,0x2
 1ce:	97ba                	add	a5,a5,a4
 1d0:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1d4:	00000097          	auipc	ra,0x0
 1d8:	e52080e7          	jalr	-430(ra) # 26 <thread_schedule>
}
 1dc:	70a2                	ld	ra,40(sp)
 1de:	7402                	ld	s0,32(sp)
 1e0:	64e2                	ld	s1,24(sp)
 1e2:	6942                	ld	s2,16(sp)
 1e4:	69a2                	ld	s3,8(sp)
 1e6:	6a02                	ld	s4,0(sp)
 1e8:	6145                	addi	sp,sp,48
 1ea:	8082                	ret

00000000000001ec <thread_b>:

void 
thread_b(void)
{
 1ec:	7179                	addi	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1fc:	00001517          	auipc	a0,0x1
 200:	a9450513          	addi	a0,a0,-1388 # c90 <malloc+0x15a>
 204:	00001097          	auipc	ra,0x1
 208:	874080e7          	jalr	-1932(ra) # a78 <printf>
  b_started = 1;
 20c:	4785                	li	a5,1
 20e:	00001717          	auipc	a4,0x1
 212:	b4f72123          	sw	a5,-1214(a4) # d50 <b_started>
  while(a_started == 0 || c_started == 0)
 216:	00001497          	auipc	s1,0x1
 21a:	b3e48493          	addi	s1,s1,-1218 # d54 <a_started>
 21e:	00001917          	auipc	s2,0x1
 222:	b2e90913          	addi	s2,s2,-1234 # d4c <c_started>
 226:	a029                	j	230 <thread_b+0x44>
    thread_yield();
 228:	00000097          	auipc	ra,0x0
 22c:	ed0080e7          	jalr	-304(ra) # f8 <thread_yield>
  while(a_started == 0 || c_started == 0)
 230:	409c                	lw	a5,0(s1)
 232:	2781                	sext.w	a5,a5
 234:	dbf5                	beqz	a5,228 <thread_b+0x3c>
 236:	00092783          	lw	a5,0(s2)
 23a:	2781                	sext.w	a5,a5
 23c:	d7f5                	beqz	a5,228 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 23e:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 240:	00001a17          	auipc	s4,0x1
 244:	a68a0a13          	addi	s4,s4,-1432 # ca8 <malloc+0x172>
    b_n += 1;
 248:	00001917          	auipc	s2,0x1
 24c:	afc90913          	addi	s2,s2,-1284 # d44 <b_n>
  for (i = 0; i < 100; i++) {
 250:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 254:	85a6                	mv	a1,s1
 256:	8552                	mv	a0,s4
 258:	00001097          	auipc	ra,0x1
 25c:	820080e7          	jalr	-2016(ra) # a78 <printf>
    b_n += 1;
 260:	00092783          	lw	a5,0(s2)
 264:	2785                	addiw	a5,a5,1
 266:	00f92023          	sw	a5,0(s2)
    thread_yield();
 26a:	00000097          	auipc	ra,0x0
 26e:	e8e080e7          	jalr	-370(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 272:	2485                	addiw	s1,s1,1
 274:	ff3490e3          	bne	s1,s3,254 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 278:	00001597          	auipc	a1,0x1
 27c:	acc5a583          	lw	a1,-1332(a1) # d44 <b_n>
 280:	00001517          	auipc	a0,0x1
 284:	a3850513          	addi	a0,a0,-1480 # cb8 <malloc+0x182>
 288:	00000097          	auipc	ra,0x0
 28c:	7f0080e7          	jalr	2032(ra) # a78 <printf>

  current_thread->state = FREE;
 290:	00001797          	auipc	a5,0x1
 294:	ac87b783          	ld	a5,-1336(a5) # d58 <current_thread>
 298:	6709                	lui	a4,0x2
 29a:	97ba                	add	a5,a5,a4
 29c:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 2a0:	00000097          	auipc	ra,0x0
 2a4:	d86080e7          	jalr	-634(ra) # 26 <thread_schedule>
}
 2a8:	70a2                	ld	ra,40(sp)
 2aa:	7402                	ld	s0,32(sp)
 2ac:	64e2                	ld	s1,24(sp)
 2ae:	6942                	ld	s2,16(sp)
 2b0:	69a2                	ld	s3,8(sp)
 2b2:	6a02                	ld	s4,0(sp)
 2b4:	6145                	addi	sp,sp,48
 2b6:	8082                	ret

00000000000002b8 <thread_c>:

void 
thread_c(void)
{
 2b8:	7179                	addi	sp,sp,-48
 2ba:	f406                	sd	ra,40(sp)
 2bc:	f022                	sd	s0,32(sp)
 2be:	ec26                	sd	s1,24(sp)
 2c0:	e84a                	sd	s2,16(sp)
 2c2:	e44e                	sd	s3,8(sp)
 2c4:	e052                	sd	s4,0(sp)
 2c6:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c8:	00001517          	auipc	a0,0x1
 2cc:	a1050513          	addi	a0,a0,-1520 # cd8 <malloc+0x1a2>
 2d0:	00000097          	auipc	ra,0x0
 2d4:	7a8080e7          	jalr	1960(ra) # a78 <printf>
  c_started = 1;
 2d8:	4785                	li	a5,1
 2da:	00001717          	auipc	a4,0x1
 2de:	a6f72923          	sw	a5,-1422(a4) # d4c <c_started>
  while(a_started == 0 || b_started == 0)
 2e2:	00001497          	auipc	s1,0x1
 2e6:	a7248493          	addi	s1,s1,-1422 # d54 <a_started>
 2ea:	00001917          	auipc	s2,0x1
 2ee:	a6690913          	addi	s2,s2,-1434 # d50 <b_started>
 2f2:	a029                	j	2fc <thread_c+0x44>
    thread_yield();
 2f4:	00000097          	auipc	ra,0x0
 2f8:	e04080e7          	jalr	-508(ra) # f8 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2fc:	409c                	lw	a5,0(s1)
 2fe:	2781                	sext.w	a5,a5
 300:	dbf5                	beqz	a5,2f4 <thread_c+0x3c>
 302:	00092783          	lw	a5,0(s2)
 306:	2781                	sext.w	a5,a5
 308:	d7f5                	beqz	a5,2f4 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 30a:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 30c:	00001a17          	auipc	s4,0x1
 310:	9e4a0a13          	addi	s4,s4,-1564 # cf0 <malloc+0x1ba>
    c_n += 1;
 314:	00001917          	auipc	s2,0x1
 318:	a2c90913          	addi	s2,s2,-1492 # d40 <c_n>
  for (i = 0; i < 100; i++) {
 31c:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 320:	85a6                	mv	a1,s1
 322:	8552                	mv	a0,s4
 324:	00000097          	auipc	ra,0x0
 328:	754080e7          	jalr	1876(ra) # a78 <printf>
    c_n += 1;
 32c:	00092783          	lw	a5,0(s2)
 330:	2785                	addiw	a5,a5,1
 332:	00f92023          	sw	a5,0(s2)
    thread_yield();
 336:	00000097          	auipc	ra,0x0
 33a:	dc2080e7          	jalr	-574(ra) # f8 <thread_yield>
  for (i = 0; i < 100; i++) {
 33e:	2485                	addiw	s1,s1,1
 340:	ff3490e3          	bne	s1,s3,320 <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 344:	00001597          	auipc	a1,0x1
 348:	9fc5a583          	lw	a1,-1540(a1) # d40 <c_n>
 34c:	00001517          	auipc	a0,0x1
 350:	9b450513          	addi	a0,a0,-1612 # d00 <malloc+0x1ca>
 354:	00000097          	auipc	ra,0x0
 358:	724080e7          	jalr	1828(ra) # a78 <printf>

  current_thread->state = FREE;
 35c:	00001797          	auipc	a5,0x1
 360:	9fc7b783          	ld	a5,-1540(a5) # d58 <current_thread>
 364:	6709                	lui	a4,0x2
 366:	97ba                	add	a5,a5,a4
 368:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 36c:	00000097          	auipc	ra,0x0
 370:	cba080e7          	jalr	-838(ra) # 26 <thread_schedule>
}
 374:	70a2                	ld	ra,40(sp)
 376:	7402                	ld	s0,32(sp)
 378:	64e2                	ld	s1,24(sp)
 37a:	6942                	ld	s2,16(sp)
 37c:	69a2                	ld	s3,8(sp)
 37e:	6a02                	ld	s4,0(sp)
 380:	6145                	addi	sp,sp,48
 382:	8082                	ret

0000000000000384 <main>:

int 
main(int argc, char *argv[]) 
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 38c:	00001797          	auipc	a5,0x1
 390:	9c07a023          	sw	zero,-1600(a5) # d4c <c_started>
 394:	00001797          	auipc	a5,0x1
 398:	9a07ae23          	sw	zero,-1604(a5) # d50 <b_started>
 39c:	00001797          	auipc	a5,0x1
 3a0:	9a07ac23          	sw	zero,-1608(a5) # d54 <a_started>
  a_n = b_n = c_n = 0;
 3a4:	00001797          	auipc	a5,0x1
 3a8:	9807ae23          	sw	zero,-1636(a5) # d40 <c_n>
 3ac:	00001797          	auipc	a5,0x1
 3b0:	9807ac23          	sw	zero,-1640(a5) # d44 <b_n>
 3b4:	00001797          	auipc	a5,0x1
 3b8:	9807aa23          	sw	zero,-1644(a5) # d48 <a_n>
  thread_init();
 3bc:	00000097          	auipc	ra,0x0
 3c0:	c44080e7          	jalr	-956(ra) # 0 <thread_init>
  thread_create(thread_a);
 3c4:	00000517          	auipc	a0,0x0
 3c8:	d5c50513          	addi	a0,a0,-676 # 120 <thread_a>
 3cc:	00000097          	auipc	ra,0x0
 3d0:	cea080e7          	jalr	-790(ra) # b6 <thread_create>
  thread_create(thread_b);
 3d4:	00000517          	auipc	a0,0x0
 3d8:	e1850513          	addi	a0,a0,-488 # 1ec <thread_b>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	cda080e7          	jalr	-806(ra) # b6 <thread_create>
  thread_create(thread_c);
 3e4:	00000517          	auipc	a0,0x0
 3e8:	ed450513          	addi	a0,a0,-300 # 2b8 <thread_c>
 3ec:	00000097          	auipc	ra,0x0
 3f0:	cca080e7          	jalr	-822(ra) # b6 <thread_create>
  thread_schedule();
 3f4:	00000097          	auipc	ra,0x0
 3f8:	c32080e7          	jalr	-974(ra) # 26 <thread_schedule>
  exit(0);
 3fc:	4501                	li	a0,0
 3fe:	00000097          	auipc	ra,0x0
 402:	302080e7          	jalr	770(ra) # 700 <exit>

0000000000000406 <thread_switch>:

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	/* accroding to switch.S */
	sd ra, 0(a0)
 406:	00153023          	sd	ra,0(a0)
	sd sp, 8(a0)
 40a:	00253423          	sd	sp,8(a0)
	sd s0, 16(a0)
 40e:	e900                	sd	s0,16(a0)
	sd s1, 24(a0)
 410:	ed04                	sd	s1,24(a0)
	sd s2, 32(a0)
 412:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
 416:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
 41a:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
 41e:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
 422:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
 426:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
 42a:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
 42e:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
 432:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
 436:	07b53423          	sd	s11,104(a0)

	ld ra, 0(a1)
 43a:	0005b083          	ld	ra,0(a1)
	ld sp, 8(a1)
 43e:	0085b103          	ld	sp,8(a1)
	ld s0, 16(a1)
 442:	6980                	ld	s0,16(a1)
	ld s1, 24(a1)
 444:	6d84                	ld	s1,24(a1)
	ld s2, 32(a1)
 446:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
 44a:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
 44e:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
 452:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
 456:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
 45a:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
 45e:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
 462:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
 466:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
 46a:	0685bd83          	ld	s11,104(a1)
	ret    /* return to ra */
 46e:	8082                	ret

0000000000000470 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 470:	1141                	addi	sp,sp,-16
 472:	e406                	sd	ra,8(sp)
 474:	e022                	sd	s0,0(sp)
 476:	0800                	addi	s0,sp,16
  extern int main();
  main();
 478:	00000097          	auipc	ra,0x0
 47c:	f0c080e7          	jalr	-244(ra) # 384 <main>
  exit(0);
 480:	4501                	li	a0,0
 482:	00000097          	auipc	ra,0x0
 486:	27e080e7          	jalr	638(ra) # 700 <exit>

000000000000048a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e422                	sd	s0,8(sp)
 48e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 490:	87aa                	mv	a5,a0
 492:	0585                	addi	a1,a1,1
 494:	0785                	addi	a5,a5,1
 496:	fff5c703          	lbu	a4,-1(a1)
 49a:	fee78fa3          	sb	a4,-1(a5)
 49e:	fb75                	bnez	a4,492 <strcpy+0x8>
    ;
  return os;
}
 4a0:	6422                	ld	s0,8(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret

00000000000004a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e422                	sd	s0,8(sp)
 4aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4ac:	00054783          	lbu	a5,0(a0)
 4b0:	cb91                	beqz	a5,4c4 <strcmp+0x1e>
 4b2:	0005c703          	lbu	a4,0(a1)
 4b6:	00f71763          	bne	a4,a5,4c4 <strcmp+0x1e>
    p++, q++;
 4ba:	0505                	addi	a0,a0,1
 4bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4be:	00054783          	lbu	a5,0(a0)
 4c2:	fbe5                	bnez	a5,4b2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4c4:	0005c503          	lbu	a0,0(a1)
}
 4c8:	40a7853b          	subw	a0,a5,a0
 4cc:	6422                	ld	s0,8(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret

00000000000004d2 <strlen>:

uint
strlen(const char *s)
{
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e422                	sd	s0,8(sp)
 4d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	cf91                	beqz	a5,4f8 <strlen+0x26>
 4de:	0505                	addi	a0,a0,1
 4e0:	87aa                	mv	a5,a0
 4e2:	4685                	li	a3,1
 4e4:	9e89                	subw	a3,a3,a0
 4e6:	00f6853b          	addw	a0,a3,a5
 4ea:	0785                	addi	a5,a5,1
 4ec:	fff7c703          	lbu	a4,-1(a5)
 4f0:	fb7d                	bnez	a4,4e6 <strlen+0x14>
    ;
  return n;
}
 4f2:	6422                	ld	s0,8(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret
  for(n = 0; s[n]; n++)
 4f8:	4501                	li	a0,0
 4fa:	bfe5                	j	4f2 <strlen+0x20>

00000000000004fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e422                	sd	s0,8(sp)
 500:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 502:	ce09                	beqz	a2,51c <memset+0x20>
 504:	87aa                	mv	a5,a0
 506:	fff6071b          	addiw	a4,a2,-1
 50a:	1702                	slli	a4,a4,0x20
 50c:	9301                	srli	a4,a4,0x20
 50e:	0705                	addi	a4,a4,1
 510:	972a                	add	a4,a4,a0
    cdst[i] = c;
 512:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 516:	0785                	addi	a5,a5,1
 518:	fee79de3          	bne	a5,a4,512 <memset+0x16>
  }
  return dst;
}
 51c:	6422                	ld	s0,8(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret

0000000000000522 <strchr>:

char*
strchr(const char *s, char c)
{
 522:	1141                	addi	sp,sp,-16
 524:	e422                	sd	s0,8(sp)
 526:	0800                	addi	s0,sp,16
  for(; *s; s++)
 528:	00054783          	lbu	a5,0(a0)
 52c:	cb99                	beqz	a5,542 <strchr+0x20>
    if(*s == c)
 52e:	00f58763          	beq	a1,a5,53c <strchr+0x1a>
  for(; *s; s++)
 532:	0505                	addi	a0,a0,1
 534:	00054783          	lbu	a5,0(a0)
 538:	fbfd                	bnez	a5,52e <strchr+0xc>
      return (char*)s;
  return 0;
 53a:	4501                	li	a0,0
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
  return 0;
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <strchr+0x1a>

0000000000000546 <gets>:

char*
gets(char *buf, int max)
{
 546:	711d                	addi	sp,sp,-96
 548:	ec86                	sd	ra,88(sp)
 54a:	e8a2                	sd	s0,80(sp)
 54c:	e4a6                	sd	s1,72(sp)
 54e:	e0ca                	sd	s2,64(sp)
 550:	fc4e                	sd	s3,56(sp)
 552:	f852                	sd	s4,48(sp)
 554:	f456                	sd	s5,40(sp)
 556:	f05a                	sd	s6,32(sp)
 558:	ec5e                	sd	s7,24(sp)
 55a:	1080                	addi	s0,sp,96
 55c:	8baa                	mv	s7,a0
 55e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 560:	892a                	mv	s2,a0
 562:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 564:	4aa9                	li	s5,10
 566:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 568:	89a6                	mv	s3,s1
 56a:	2485                	addiw	s1,s1,1
 56c:	0344d863          	bge	s1,s4,59c <gets+0x56>
    cc = read(0, &c, 1);
 570:	4605                	li	a2,1
 572:	faf40593          	addi	a1,s0,-81
 576:	4501                	li	a0,0
 578:	00000097          	auipc	ra,0x0
 57c:	1a0080e7          	jalr	416(ra) # 718 <read>
    if(cc < 1)
 580:	00a05e63          	blez	a0,59c <gets+0x56>
    buf[i++] = c;
 584:	faf44783          	lbu	a5,-81(s0)
 588:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 58c:	01578763          	beq	a5,s5,59a <gets+0x54>
 590:	0905                	addi	s2,s2,1
 592:	fd679be3          	bne	a5,s6,568 <gets+0x22>
  for(i=0; i+1 < max; ){
 596:	89a6                	mv	s3,s1
 598:	a011                	j	59c <gets+0x56>
 59a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 59c:	99de                	add	s3,s3,s7
 59e:	00098023          	sb	zero,0(s3)
  return buf;
}
 5a2:	855e                	mv	a0,s7
 5a4:	60e6                	ld	ra,88(sp)
 5a6:	6446                	ld	s0,80(sp)
 5a8:	64a6                	ld	s1,72(sp)
 5aa:	6906                	ld	s2,64(sp)
 5ac:	79e2                	ld	s3,56(sp)
 5ae:	7a42                	ld	s4,48(sp)
 5b0:	7aa2                	ld	s5,40(sp)
 5b2:	7b02                	ld	s6,32(sp)
 5b4:	6be2                	ld	s7,24(sp)
 5b6:	6125                	addi	sp,sp,96
 5b8:	8082                	ret

00000000000005ba <stat>:

int
stat(const char *n, struct stat *st)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	e426                	sd	s1,8(sp)
 5c2:	e04a                	sd	s2,0(sp)
 5c4:	1000                	addi	s0,sp,32
 5c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c8:	4581                	li	a1,0
 5ca:	00000097          	auipc	ra,0x0
 5ce:	176080e7          	jalr	374(ra) # 740 <open>
  if(fd < 0)
 5d2:	02054563          	bltz	a0,5fc <stat+0x42>
 5d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5d8:	85ca                	mv	a1,s2
 5da:	00000097          	auipc	ra,0x0
 5de:	17e080e7          	jalr	382(ra) # 758 <fstat>
 5e2:	892a                	mv	s2,a0
  close(fd);
 5e4:	8526                	mv	a0,s1
 5e6:	00000097          	auipc	ra,0x0
 5ea:	142080e7          	jalr	322(ra) # 728 <close>
  return r;
}
 5ee:	854a                	mv	a0,s2
 5f0:	60e2                	ld	ra,24(sp)
 5f2:	6442                	ld	s0,16(sp)
 5f4:	64a2                	ld	s1,8(sp)
 5f6:	6902                	ld	s2,0(sp)
 5f8:	6105                	addi	sp,sp,32
 5fa:	8082                	ret
    return -1;
 5fc:	597d                	li	s2,-1
 5fe:	bfc5                	j	5ee <stat+0x34>

0000000000000600 <atoi>:

int
atoi(const char *s)
{
 600:	1141                	addi	sp,sp,-16
 602:	e422                	sd	s0,8(sp)
 604:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 606:	00054603          	lbu	a2,0(a0)
 60a:	fd06079b          	addiw	a5,a2,-48
 60e:	0ff7f793          	andi	a5,a5,255
 612:	4725                	li	a4,9
 614:	02f76963          	bltu	a4,a5,646 <atoi+0x46>
 618:	86aa                	mv	a3,a0
  n = 0;
 61a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 61c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 61e:	0685                	addi	a3,a3,1
 620:	0025179b          	slliw	a5,a0,0x2
 624:	9fa9                	addw	a5,a5,a0
 626:	0017979b          	slliw	a5,a5,0x1
 62a:	9fb1                	addw	a5,a5,a2
 62c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 630:	0006c603          	lbu	a2,0(a3)
 634:	fd06071b          	addiw	a4,a2,-48
 638:	0ff77713          	andi	a4,a4,255
 63c:	fee5f1e3          	bgeu	a1,a4,61e <atoi+0x1e>
  return n;
}
 640:	6422                	ld	s0,8(sp)
 642:	0141                	addi	sp,sp,16
 644:	8082                	ret
  n = 0;
 646:	4501                	li	a0,0
 648:	bfe5                	j	640 <atoi+0x40>

000000000000064a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 64a:	1141                	addi	sp,sp,-16
 64c:	e422                	sd	s0,8(sp)
 64e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 650:	02b57663          	bgeu	a0,a1,67c <memmove+0x32>
    while(n-- > 0)
 654:	02c05163          	blez	a2,676 <memmove+0x2c>
 658:	fff6079b          	addiw	a5,a2,-1
 65c:	1782                	slli	a5,a5,0x20
 65e:	9381                	srli	a5,a5,0x20
 660:	0785                	addi	a5,a5,1
 662:	97aa                	add	a5,a5,a0
  dst = vdst;
 664:	872a                	mv	a4,a0
      *dst++ = *src++;
 666:	0585                	addi	a1,a1,1
 668:	0705                	addi	a4,a4,1
 66a:	fff5c683          	lbu	a3,-1(a1)
 66e:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xac6>
    while(n-- > 0)
 672:	fee79ae3          	bne	a5,a4,666 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 676:	6422                	ld	s0,8(sp)
 678:	0141                	addi	sp,sp,16
 67a:	8082                	ret
    dst += n;
 67c:	00c50733          	add	a4,a0,a2
    src += n;
 680:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 682:	fec05ae3          	blez	a2,676 <memmove+0x2c>
 686:	fff6079b          	addiw	a5,a2,-1
 68a:	1782                	slli	a5,a5,0x20
 68c:	9381                	srli	a5,a5,0x20
 68e:	fff7c793          	not	a5,a5
 692:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 694:	15fd                	addi	a1,a1,-1
 696:	177d                	addi	a4,a4,-1
 698:	0005c683          	lbu	a3,0(a1)
 69c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6a0:	fee79ae3          	bne	a5,a4,694 <memmove+0x4a>
 6a4:	bfc9                	j	676 <memmove+0x2c>

00000000000006a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e422                	sd	s0,8(sp)
 6aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6ac:	ca05                	beqz	a2,6dc <memcmp+0x36>
 6ae:	fff6069b          	addiw	a3,a2,-1
 6b2:	1682                	slli	a3,a3,0x20
 6b4:	9281                	srli	a3,a3,0x20
 6b6:	0685                	addi	a3,a3,1
 6b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 6ba:	00054783          	lbu	a5,0(a0)
 6be:	0005c703          	lbu	a4,0(a1)
 6c2:	00e79863          	bne	a5,a4,6d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6c6:	0505                	addi	a0,a0,1
    p2++;
 6c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6ca:	fed518e3          	bne	a0,a3,6ba <memcmp+0x14>
  }
  return 0;
 6ce:	4501                	li	a0,0
 6d0:	a019                	j	6d6 <memcmp+0x30>
      return *p1 - *p2;
 6d2:	40e7853b          	subw	a0,a5,a4
}
 6d6:	6422                	ld	s0,8(sp)
 6d8:	0141                	addi	sp,sp,16
 6da:	8082                	ret
  return 0;
 6dc:	4501                	li	a0,0
 6de:	bfe5                	j	6d6 <memcmp+0x30>

00000000000006e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e406                	sd	ra,8(sp)
 6e4:	e022                	sd	s0,0(sp)
 6e6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6e8:	00000097          	auipc	ra,0x0
 6ec:	f62080e7          	jalr	-158(ra) # 64a <memmove>
}
 6f0:	60a2                	ld	ra,8(sp)
 6f2:	6402                	ld	s0,0(sp)
 6f4:	0141                	addi	sp,sp,16
 6f6:	8082                	ret

00000000000006f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6f8:	4885                	li	a7,1
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <exit>:
.global exit
exit:
 li a7, SYS_exit
 700:	4889                	li	a7,2
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <wait>:
.global wait
wait:
 li a7, SYS_wait
 708:	488d                	li	a7,3
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 710:	4891                	li	a7,4
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <read>:
.global read
read:
 li a7, SYS_read
 718:	4895                	li	a7,5
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <write>:
.global write
write:
 li a7, SYS_write
 720:	48c1                	li	a7,16
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <close>:
.global close
close:
 li a7, SYS_close
 728:	48d5                	li	a7,21
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <kill>:
.global kill
kill:
 li a7, SYS_kill
 730:	4899                	li	a7,6
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <exec>:
.global exec
exec:
 li a7, SYS_exec
 738:	489d                	li	a7,7
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <open>:
.global open
open:
 li a7, SYS_open
 740:	48bd                	li	a7,15
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 748:	48c5                	li	a7,17
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 750:	48c9                	li	a7,18
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 758:	48a1                	li	a7,8
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <link>:
.global link
link:
 li a7, SYS_link
 760:	48cd                	li	a7,19
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 768:	48d1                	li	a7,20
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 770:	48a5                	li	a7,9
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <dup>:
.global dup
dup:
 li a7, SYS_dup
 778:	48a9                	li	a7,10
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 780:	48ad                	li	a7,11
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 788:	48b1                	li	a7,12
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 790:	48b5                	li	a7,13
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 798:	48b9                	li	a7,14
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7a0:	1101                	addi	sp,sp,-32
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7ac:	4605                	li	a2,1
 7ae:	fef40593          	addi	a1,s0,-17
 7b2:	00000097          	auipc	ra,0x0
 7b6:	f6e080e7          	jalr	-146(ra) # 720 <write>
}
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	6105                	addi	sp,sp,32
 7c0:	8082                	ret

00000000000007c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7c2:	7139                	addi	sp,sp,-64
 7c4:	fc06                	sd	ra,56(sp)
 7c6:	f822                	sd	s0,48(sp)
 7c8:	f426                	sd	s1,40(sp)
 7ca:	f04a                	sd	s2,32(sp)
 7cc:	ec4e                	sd	s3,24(sp)
 7ce:	0080                	addi	s0,sp,64
 7d0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7d2:	c299                	beqz	a3,7d8 <printint+0x16>
 7d4:	0805c863          	bltz	a1,864 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7d8:	2581                	sext.w	a1,a1
  neg = 0;
 7da:	4881                	li	a7,0
 7dc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7e2:	2601                	sext.w	a2,a2
 7e4:	00000517          	auipc	a0,0x0
 7e8:	54450513          	addi	a0,a0,1348 # d28 <digits>
 7ec:	883a                	mv	a6,a4
 7ee:	2705                	addiw	a4,a4,1
 7f0:	02c5f7bb          	remuw	a5,a1,a2
 7f4:	1782                	slli	a5,a5,0x20
 7f6:	9381                	srli	a5,a5,0x20
 7f8:	97aa                	add	a5,a5,a0
 7fa:	0007c783          	lbu	a5,0(a5)
 7fe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 802:	0005879b          	sext.w	a5,a1
 806:	02c5d5bb          	divuw	a1,a1,a2
 80a:	0685                	addi	a3,a3,1
 80c:	fec7f0e3          	bgeu	a5,a2,7ec <printint+0x2a>
  if(neg)
 810:	00088b63          	beqz	a7,826 <printint+0x64>
    buf[i++] = '-';
 814:	fd040793          	addi	a5,s0,-48
 818:	973e                	add	a4,a4,a5
 81a:	02d00793          	li	a5,45
 81e:	fef70823          	sb	a5,-16(a4)
 822:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 826:	02e05863          	blez	a4,856 <printint+0x94>
 82a:	fc040793          	addi	a5,s0,-64
 82e:	00e78933          	add	s2,a5,a4
 832:	fff78993          	addi	s3,a5,-1
 836:	99ba                	add	s3,s3,a4
 838:	377d                	addiw	a4,a4,-1
 83a:	1702                	slli	a4,a4,0x20
 83c:	9301                	srli	a4,a4,0x20
 83e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 842:	fff94583          	lbu	a1,-1(s2)
 846:	8526                	mv	a0,s1
 848:	00000097          	auipc	ra,0x0
 84c:	f58080e7          	jalr	-168(ra) # 7a0 <putc>
  while(--i >= 0)
 850:	197d                	addi	s2,s2,-1
 852:	ff3918e3          	bne	s2,s3,842 <printint+0x80>
}
 856:	70e2                	ld	ra,56(sp)
 858:	7442                	ld	s0,48(sp)
 85a:	74a2                	ld	s1,40(sp)
 85c:	7902                	ld	s2,32(sp)
 85e:	69e2                	ld	s3,24(sp)
 860:	6121                	addi	sp,sp,64
 862:	8082                	ret
    x = -xx;
 864:	40b005bb          	negw	a1,a1
    neg = 1;
 868:	4885                	li	a7,1
    x = -xx;
 86a:	bf8d                	j	7dc <printint+0x1a>

000000000000086c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 86c:	7119                	addi	sp,sp,-128
 86e:	fc86                	sd	ra,120(sp)
 870:	f8a2                	sd	s0,112(sp)
 872:	f4a6                	sd	s1,104(sp)
 874:	f0ca                	sd	s2,96(sp)
 876:	ecce                	sd	s3,88(sp)
 878:	e8d2                	sd	s4,80(sp)
 87a:	e4d6                	sd	s5,72(sp)
 87c:	e0da                	sd	s6,64(sp)
 87e:	fc5e                	sd	s7,56(sp)
 880:	f862                	sd	s8,48(sp)
 882:	f466                	sd	s9,40(sp)
 884:	f06a                	sd	s10,32(sp)
 886:	ec6e                	sd	s11,24(sp)
 888:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 88a:	0005c903          	lbu	s2,0(a1)
 88e:	18090f63          	beqz	s2,a2c <vprintf+0x1c0>
 892:	8aaa                	mv	s5,a0
 894:	8b32                	mv	s6,a2
 896:	00158493          	addi	s1,a1,1
  state = 0;
 89a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 89c:	02500a13          	li	s4,37
      if(c == 'd'){
 8a0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 8a4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 8a8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 8ac:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b0:	00000b97          	auipc	s7,0x0
 8b4:	478b8b93          	addi	s7,s7,1144 # d28 <digits>
 8b8:	a839                	j	8d6 <vprintf+0x6a>
        putc(fd, c);
 8ba:	85ca                	mv	a1,s2
 8bc:	8556                	mv	a0,s5
 8be:	00000097          	auipc	ra,0x0
 8c2:	ee2080e7          	jalr	-286(ra) # 7a0 <putc>
 8c6:	a019                	j	8cc <vprintf+0x60>
    } else if(state == '%'){
 8c8:	01498f63          	beq	s3,s4,8e6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8cc:	0485                	addi	s1,s1,1
 8ce:	fff4c903          	lbu	s2,-1(s1)
 8d2:	14090d63          	beqz	s2,a2c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8d6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8da:	fe0997e3          	bnez	s3,8c8 <vprintf+0x5c>
      if(c == '%'){
 8de:	fd479ee3          	bne	a5,s4,8ba <vprintf+0x4e>
        state = '%';
 8e2:	89be                	mv	s3,a5
 8e4:	b7e5                	j	8cc <vprintf+0x60>
      if(c == 'd'){
 8e6:	05878063          	beq	a5,s8,926 <vprintf+0xba>
      } else if(c == 'l') {
 8ea:	05978c63          	beq	a5,s9,942 <vprintf+0xd6>
      } else if(c == 'x') {
 8ee:	07a78863          	beq	a5,s10,95e <vprintf+0xf2>
      } else if(c == 'p') {
 8f2:	09b78463          	beq	a5,s11,97a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8f6:	07300713          	li	a4,115
 8fa:	0ce78663          	beq	a5,a4,9c6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8fe:	06300713          	li	a4,99
 902:	0ee78e63          	beq	a5,a4,9fe <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 906:	11478863          	beq	a5,s4,a16 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 90a:	85d2                	mv	a1,s4
 90c:	8556                	mv	a0,s5
 90e:	00000097          	auipc	ra,0x0
 912:	e92080e7          	jalr	-366(ra) # 7a0 <putc>
        putc(fd, c);
 916:	85ca                	mv	a1,s2
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	e86080e7          	jalr	-378(ra) # 7a0 <putc>
      }
      state = 0;
 922:	4981                	li	s3,0
 924:	b765                	j	8cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 926:	008b0913          	addi	s2,s6,8
 92a:	4685                	li	a3,1
 92c:	4629                	li	a2,10
 92e:	000b2583          	lw	a1,0(s6)
 932:	8556                	mv	a0,s5
 934:	00000097          	auipc	ra,0x0
 938:	e8e080e7          	jalr	-370(ra) # 7c2 <printint>
 93c:	8b4a                	mv	s6,s2
      state = 0;
 93e:	4981                	li	s3,0
 940:	b771                	j	8cc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 942:	008b0913          	addi	s2,s6,8
 946:	4681                	li	a3,0
 948:	4629                	li	a2,10
 94a:	000b2583          	lw	a1,0(s6)
 94e:	8556                	mv	a0,s5
 950:	00000097          	auipc	ra,0x0
 954:	e72080e7          	jalr	-398(ra) # 7c2 <printint>
 958:	8b4a                	mv	s6,s2
      state = 0;
 95a:	4981                	li	s3,0
 95c:	bf85                	j	8cc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 95e:	008b0913          	addi	s2,s6,8
 962:	4681                	li	a3,0
 964:	4641                	li	a2,16
 966:	000b2583          	lw	a1,0(s6)
 96a:	8556                	mv	a0,s5
 96c:	00000097          	auipc	ra,0x0
 970:	e56080e7          	jalr	-426(ra) # 7c2 <printint>
 974:	8b4a                	mv	s6,s2
      state = 0;
 976:	4981                	li	s3,0
 978:	bf91                	j	8cc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 97a:	008b0793          	addi	a5,s6,8
 97e:	f8f43423          	sd	a5,-120(s0)
 982:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 986:	03000593          	li	a1,48
 98a:	8556                	mv	a0,s5
 98c:	00000097          	auipc	ra,0x0
 990:	e14080e7          	jalr	-492(ra) # 7a0 <putc>
  putc(fd, 'x');
 994:	85ea                	mv	a1,s10
 996:	8556                	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	e08080e7          	jalr	-504(ra) # 7a0 <putc>
 9a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9a2:	03c9d793          	srli	a5,s3,0x3c
 9a6:	97de                	add	a5,a5,s7
 9a8:	0007c583          	lbu	a1,0(a5)
 9ac:	8556                	mv	a0,s5
 9ae:	00000097          	auipc	ra,0x0
 9b2:	df2080e7          	jalr	-526(ra) # 7a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9b6:	0992                	slli	s3,s3,0x4
 9b8:	397d                	addiw	s2,s2,-1
 9ba:	fe0914e3          	bnez	s2,9a2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 9be:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9c2:	4981                	li	s3,0
 9c4:	b721                	j	8cc <vprintf+0x60>
        s = va_arg(ap, char*);
 9c6:	008b0993          	addi	s3,s6,8
 9ca:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9ce:	02090163          	beqz	s2,9f0 <vprintf+0x184>
        while(*s != 0){
 9d2:	00094583          	lbu	a1,0(s2)
 9d6:	c9a1                	beqz	a1,a26 <vprintf+0x1ba>
          putc(fd, *s);
 9d8:	8556                	mv	a0,s5
 9da:	00000097          	auipc	ra,0x0
 9de:	dc6080e7          	jalr	-570(ra) # 7a0 <putc>
          s++;
 9e2:	0905                	addi	s2,s2,1
        while(*s != 0){
 9e4:	00094583          	lbu	a1,0(s2)
 9e8:	f9e5                	bnez	a1,9d8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9ea:	8b4e                	mv	s6,s3
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	bdf9                	j	8cc <vprintf+0x60>
          s = "(null)";
 9f0:	00000917          	auipc	s2,0x0
 9f4:	33090913          	addi	s2,s2,816 # d20 <malloc+0x1ea>
        while(*s != 0){
 9f8:	02800593          	li	a1,40
 9fc:	bff1                	j	9d8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9fe:	008b0913          	addi	s2,s6,8
 a02:	000b4583          	lbu	a1,0(s6)
 a06:	8556                	mv	a0,s5
 a08:	00000097          	auipc	ra,0x0
 a0c:	d98080e7          	jalr	-616(ra) # 7a0 <putc>
 a10:	8b4a                	mv	s6,s2
      state = 0;
 a12:	4981                	li	s3,0
 a14:	bd65                	j	8cc <vprintf+0x60>
        putc(fd, c);
 a16:	85d2                	mv	a1,s4
 a18:	8556                	mv	a0,s5
 a1a:	00000097          	auipc	ra,0x0
 a1e:	d86080e7          	jalr	-634(ra) # 7a0 <putc>
      state = 0;
 a22:	4981                	li	s3,0
 a24:	b565                	j	8cc <vprintf+0x60>
        s = va_arg(ap, char*);
 a26:	8b4e                	mv	s6,s3
      state = 0;
 a28:	4981                	li	s3,0
 a2a:	b54d                	j	8cc <vprintf+0x60>
    }
  }
}
 a2c:	70e6                	ld	ra,120(sp)
 a2e:	7446                	ld	s0,112(sp)
 a30:	74a6                	ld	s1,104(sp)
 a32:	7906                	ld	s2,96(sp)
 a34:	69e6                	ld	s3,88(sp)
 a36:	6a46                	ld	s4,80(sp)
 a38:	6aa6                	ld	s5,72(sp)
 a3a:	6b06                	ld	s6,64(sp)
 a3c:	7be2                	ld	s7,56(sp)
 a3e:	7c42                	ld	s8,48(sp)
 a40:	7ca2                	ld	s9,40(sp)
 a42:	7d02                	ld	s10,32(sp)
 a44:	6de2                	ld	s11,24(sp)
 a46:	6109                	addi	sp,sp,128
 a48:	8082                	ret

0000000000000a4a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a4a:	715d                	addi	sp,sp,-80
 a4c:	ec06                	sd	ra,24(sp)
 a4e:	e822                	sd	s0,16(sp)
 a50:	1000                	addi	s0,sp,32
 a52:	e010                	sd	a2,0(s0)
 a54:	e414                	sd	a3,8(s0)
 a56:	e818                	sd	a4,16(s0)
 a58:	ec1c                	sd	a5,24(s0)
 a5a:	03043023          	sd	a6,32(s0)
 a5e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a62:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a66:	8622                	mv	a2,s0
 a68:	00000097          	auipc	ra,0x0
 a6c:	e04080e7          	jalr	-508(ra) # 86c <vprintf>
}
 a70:	60e2                	ld	ra,24(sp)
 a72:	6442                	ld	s0,16(sp)
 a74:	6161                	addi	sp,sp,80
 a76:	8082                	ret

0000000000000a78 <printf>:

void
printf(const char *fmt, ...)
{
 a78:	711d                	addi	sp,sp,-96
 a7a:	ec06                	sd	ra,24(sp)
 a7c:	e822                	sd	s0,16(sp)
 a7e:	1000                	addi	s0,sp,32
 a80:	e40c                	sd	a1,8(s0)
 a82:	e810                	sd	a2,16(s0)
 a84:	ec14                	sd	a3,24(s0)
 a86:	f018                	sd	a4,32(s0)
 a88:	f41c                	sd	a5,40(s0)
 a8a:	03043823          	sd	a6,48(s0)
 a8e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a92:	00840613          	addi	a2,s0,8
 a96:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a9a:	85aa                	mv	a1,a0
 a9c:	4505                	li	a0,1
 a9e:	00000097          	auipc	ra,0x0
 aa2:	dce080e7          	jalr	-562(ra) # 86c <vprintf>
}
 aa6:	60e2                	ld	ra,24(sp)
 aa8:	6442                	ld	s0,16(sp)
 aaa:	6125                	addi	sp,sp,96
 aac:	8082                	ret

0000000000000aae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 aae:	1141                	addi	sp,sp,-16
 ab0:	e422                	sd	s0,8(sp)
 ab2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ab4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab8:	00000797          	auipc	a5,0x0
 abc:	2a87b783          	ld	a5,680(a5) # d60 <freep>
 ac0:	a805                	j	af0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ac2:	4618                	lw	a4,8(a2)
 ac4:	9db9                	addw	a1,a1,a4
 ac6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aca:	6398                	ld	a4,0(a5)
 acc:	6318                	ld	a4,0(a4)
 ace:	fee53823          	sd	a4,-16(a0)
 ad2:	a091                	j	b16 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ad4:	ff852703          	lw	a4,-8(a0)
 ad8:	9e39                	addw	a2,a2,a4
 ada:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 adc:	ff053703          	ld	a4,-16(a0)
 ae0:	e398                	sd	a4,0(a5)
 ae2:	a099                	j	b28 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae4:	6398                	ld	a4,0(a5)
 ae6:	00e7e463          	bltu	a5,a4,aee <free+0x40>
 aea:	00e6ea63          	bltu	a3,a4,afe <free+0x50>
{
 aee:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af0:	fed7fae3          	bgeu	a5,a3,ae4 <free+0x36>
 af4:	6398                	ld	a4,0(a5)
 af6:	00e6e463          	bltu	a3,a4,afe <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afa:	fee7eae3          	bltu	a5,a4,aee <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 afe:	ff852583          	lw	a1,-8(a0)
 b02:	6390                	ld	a2,0(a5)
 b04:	02059713          	slli	a4,a1,0x20
 b08:	9301                	srli	a4,a4,0x20
 b0a:	0712                	slli	a4,a4,0x4
 b0c:	9736                	add	a4,a4,a3
 b0e:	fae60ae3          	beq	a2,a4,ac2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 b12:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b16:	4790                	lw	a2,8(a5)
 b18:	02061713          	slli	a4,a2,0x20
 b1c:	9301                	srli	a4,a4,0x20
 b1e:	0712                	slli	a4,a4,0x4
 b20:	973e                	add	a4,a4,a5
 b22:	fae689e3          	beq	a3,a4,ad4 <free+0x26>
  } else
    p->s.ptr = bp;
 b26:	e394                	sd	a3,0(a5)
  freep = p;
 b28:	00000717          	auipc	a4,0x0
 b2c:	22f73c23          	sd	a5,568(a4) # d60 <freep>
}
 b30:	6422                	ld	s0,8(sp)
 b32:	0141                	addi	sp,sp,16
 b34:	8082                	ret

0000000000000b36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b36:	7139                	addi	sp,sp,-64
 b38:	fc06                	sd	ra,56(sp)
 b3a:	f822                	sd	s0,48(sp)
 b3c:	f426                	sd	s1,40(sp)
 b3e:	f04a                	sd	s2,32(sp)
 b40:	ec4e                	sd	s3,24(sp)
 b42:	e852                	sd	s4,16(sp)
 b44:	e456                	sd	s5,8(sp)
 b46:	e05a                	sd	s6,0(sp)
 b48:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b4a:	02051493          	slli	s1,a0,0x20
 b4e:	9081                	srli	s1,s1,0x20
 b50:	04bd                	addi	s1,s1,15
 b52:	8091                	srli	s1,s1,0x4
 b54:	0014899b          	addiw	s3,s1,1
 b58:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b5a:	00000517          	auipc	a0,0x0
 b5e:	20653503          	ld	a0,518(a0) # d60 <freep>
 b62:	c515                	beqz	a0,b8e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b64:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b66:	4798                	lw	a4,8(a5)
 b68:	02977f63          	bgeu	a4,s1,ba6 <malloc+0x70>
 b6c:	8a4e                	mv	s4,s3
 b6e:	0009871b          	sext.w	a4,s3
 b72:	6685                	lui	a3,0x1
 b74:	00d77363          	bgeu	a4,a3,b7a <malloc+0x44>
 b78:	6a05                	lui	s4,0x1
 b7a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b7e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b82:	00000917          	auipc	s2,0x0
 b86:	1de90913          	addi	s2,s2,478 # d60 <freep>
  if(p == (char*)-1)
 b8a:	5afd                	li	s5,-1
 b8c:	a88d                	j	bfe <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b8e:	00008797          	auipc	a5,0x8
 b92:	3ba78793          	addi	a5,a5,954 # 8f48 <base>
 b96:	00000717          	auipc	a4,0x0
 b9a:	1cf73523          	sd	a5,458(a4) # d60 <freep>
 b9e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ba0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ba4:	b7e1                	j	b6c <malloc+0x36>
      if(p->s.size == nunits)
 ba6:	02e48b63          	beq	s1,a4,bdc <malloc+0xa6>
        p->s.size -= nunits;
 baa:	4137073b          	subw	a4,a4,s3
 bae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bb0:	1702                	slli	a4,a4,0x20
 bb2:	9301                	srli	a4,a4,0x20
 bb4:	0712                	slli	a4,a4,0x4
 bb6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bb8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bbc:	00000717          	auipc	a4,0x0
 bc0:	1aa73223          	sd	a0,420(a4) # d60 <freep>
      return (void*)(p + 1);
 bc4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bc8:	70e2                	ld	ra,56(sp)
 bca:	7442                	ld	s0,48(sp)
 bcc:	74a2                	ld	s1,40(sp)
 bce:	7902                	ld	s2,32(sp)
 bd0:	69e2                	ld	s3,24(sp)
 bd2:	6a42                	ld	s4,16(sp)
 bd4:	6aa2                	ld	s5,8(sp)
 bd6:	6b02                	ld	s6,0(sp)
 bd8:	6121                	addi	sp,sp,64
 bda:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bdc:	6398                	ld	a4,0(a5)
 bde:	e118                	sd	a4,0(a0)
 be0:	bff1                	j	bbc <malloc+0x86>
  hp->s.size = nu;
 be2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 be6:	0541                	addi	a0,a0,16
 be8:	00000097          	auipc	ra,0x0
 bec:	ec6080e7          	jalr	-314(ra) # aae <free>
  return freep;
 bf0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bf4:	d971                	beqz	a0,bc8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bf8:	4798                	lw	a4,8(a5)
 bfa:	fa9776e3          	bgeu	a4,s1,ba6 <malloc+0x70>
    if(p == freep)
 bfe:	00093703          	ld	a4,0(s2)
 c02:	853e                	mv	a0,a5
 c04:	fef719e3          	bne	a4,a5,bf6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 c08:	8552                	mv	a0,s4
 c0a:	00000097          	auipc	ra,0x0
 c0e:	b7e080e7          	jalr	-1154(ra) # 788 <sbrk>
  if(p == (char*)-1)
 c12:	fd5518e3          	bne	a0,s5,be2 <malloc+0xac>
        return 0;
 c16:	4501                	li	a0,0
 c18:	bf45                	j	bc8 <malloc+0x92>
