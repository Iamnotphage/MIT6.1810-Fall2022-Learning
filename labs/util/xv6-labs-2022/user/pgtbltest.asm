
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00001917          	auipc	s2,0x1
  12:	ff293903          	ld	s2,-14(s2) # 1000 <testname>
  16:	00000097          	auipc	ra,0x0
  1a:	514080e7          	jalr	1300(ra) # 52a <getpid>
  1e:	86aa                	mv	a3,a0
  20:	8626                	mv	a2,s1
  22:	85ca                	mv	a1,s2
  24:	00001517          	auipc	a0,0x1
  28:	9bc50513          	addi	a0,a0,-1604 # 9e0 <malloc+0xf0>
  2c:	00001097          	auipc	ra,0x1
  30:	806080e7          	jalr	-2042(ra) # 832 <printf>
  exit(1);
  34:	4505                	li	a0,1
  36:	00000097          	auipc	ra,0x0
  3a:	474080e7          	jalr	1140(ra) # 4aa <exit>

000000000000003e <ugetpid_test>:
}

void
ugetpid_test()
{
  3e:	7179                	addi	sp,sp,-48
  40:	f406                	sd	ra,40(sp)
  42:	f022                	sd	s0,32(sp)
  44:	ec26                	sd	s1,24(sp)
  46:	1800                	addi	s0,sp,48
  int i;

  printf("ugetpid_test starting\n");
  48:	00001517          	auipc	a0,0x1
  4c:	9c050513          	addi	a0,a0,-1600 # a08 <malloc+0x118>
  50:	00000097          	auipc	ra,0x0
  54:	7e2080e7          	jalr	2018(ra) # 832 <printf>
  testname = "ugetpid_test";
  58:	00001797          	auipc	a5,0x1
  5c:	9c878793          	addi	a5,a5,-1592 # a20 <malloc+0x130>
  60:	00001717          	auipc	a4,0x1
  64:	faf73023          	sd	a5,-96(a4) # 1000 <testname>
  68:	04000493          	li	s1,64

  for (i = 0; i < 64; i++) {
    int ret = fork();
  6c:	00000097          	auipc	ra,0x0
  70:	436080e7          	jalr	1078(ra) # 4a2 <fork>
  74:	fca42e23          	sw	a0,-36(s0)
    if (ret != 0) {
  78:	cd15                	beqz	a0,b4 <ugetpid_test+0x76>
      wait(&ret);
  7a:	fdc40513          	addi	a0,s0,-36
  7e:	00000097          	auipc	ra,0x0
  82:	434080e7          	jalr	1076(ra) # 4b2 <wait>
      if (ret != 0)
  86:	fdc42783          	lw	a5,-36(s0)
  8a:	e385                	bnez	a5,aa <ugetpid_test+0x6c>
  for (i = 0; i < 64; i++) {
  8c:	34fd                	addiw	s1,s1,-1
  8e:	fcf9                	bnez	s1,6c <ugetpid_test+0x2e>
    }
    if (getpid() != ugetpid())
      err("missmatched PID");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
  90:	00001517          	auipc	a0,0x1
  94:	9b050513          	addi	a0,a0,-1616 # a40 <malloc+0x150>
  98:	00000097          	auipc	ra,0x0
  9c:	79a080e7          	jalr	1946(ra) # 832 <printf>
}
  a0:	70a2                	ld	ra,40(sp)
  a2:	7402                	ld	s0,32(sp)
  a4:	64e2                	ld	s1,24(sp)
  a6:	6145                	addi	sp,sp,48
  a8:	8082                	ret
        exit(1);
  aa:	4505                	li	a0,1
  ac:	00000097          	auipc	ra,0x0
  b0:	3fe080e7          	jalr	1022(ra) # 4aa <exit>
    if (getpid() != ugetpid())
  b4:	00000097          	auipc	ra,0x0
  b8:	476080e7          	jalr	1142(ra) # 52a <getpid>
  bc:	84aa                	mv	s1,a0
  be:	00000097          	auipc	ra,0x0
  c2:	3ce080e7          	jalr	974(ra) # 48c <ugetpid>
  c6:	00a48a63          	beq	s1,a0,da <ugetpid_test+0x9c>
      err("missmatched PID");
  ca:	00001517          	auipc	a0,0x1
  ce:	96650513          	addi	a0,a0,-1690 # a30 <malloc+0x140>
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <err>
    exit(0);
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	3ce080e7          	jalr	974(ra) # 4aa <exit>

00000000000000e4 <pgaccess_test>:

void
pgaccess_test()
{
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	96a50513          	addi	a0,a0,-1686 # a58 <malloc+0x168>
  f6:	00000097          	auipc	ra,0x0
  fa:	73c080e7          	jalr	1852(ra) # 832 <printf>
  testname = "pgaccess_test";
  fe:	00001797          	auipc	a5,0x1
 102:	97278793          	addi	a5,a5,-1678 # a70 <malloc+0x180>
 106:	00001717          	auipc	a4,0x1
 10a:	eef73d23          	sd	a5,-262(a4) # 1000 <testname>
  buf = malloc(32 * PGSIZE);
 10e:	00020537          	lui	a0,0x20
 112:	00000097          	auipc	ra,0x0
 116:	7de080e7          	jalr	2014(ra) # 8f0 <malloc>
 11a:	84aa                	mv	s1,a0
  if (pgaccess(buf, 32, &abits) < 0)
 11c:	fdc40613          	addi	a2,s0,-36
 120:	02000593          	li	a1,32
 124:	00000097          	auipc	ra,0x0
 128:	42e080e7          	jalr	1070(ra) # 552 <pgaccess>
 12c:	06054b63          	bltz	a0,1a2 <pgaccess_test+0xbe>
    err("pgaccess failed");
  buf[PGSIZE * 1] += 1;
 130:	6785                	lui	a5,0x1
 132:	97a6                	add	a5,a5,s1
 134:	0007c703          	lbu	a4,0(a5) # 1000 <testname>
 138:	2705                	addiw	a4,a4,1
 13a:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 2] += 1;
 13e:	6789                	lui	a5,0x2
 140:	97a6                	add	a5,a5,s1
 142:	0007c703          	lbu	a4,0(a5) # 2000 <base+0xfe0>
 146:	2705                	addiw	a4,a4,1
 148:	00e78023          	sb	a4,0(a5)
  buf[PGSIZE * 30] += 1;
 14c:	67f9                	lui	a5,0x1e
 14e:	97a6                	add	a5,a5,s1
 150:	0007c703          	lbu	a4,0(a5) # 1e000 <base+0x1cfe0>
 154:	2705                	addiw	a4,a4,1
 156:	00e78023          	sb	a4,0(a5)
  //test:
  //printf("abits: %x\n",abits);
  if (pgaccess(buf, 32, &abits) < 0)
 15a:	fdc40613          	addi	a2,s0,-36
 15e:	02000593          	li	a1,32
 162:	8526                	mv	a0,s1
 164:	00000097          	auipc	ra,0x0
 168:	3ee080e7          	jalr	1006(ra) # 552 <pgaccess>
 16c:	04054363          	bltz	a0,1b2 <pgaccess_test+0xce>
    err("pgaccess failed");
  if (abits != ((1 << 1) | (1 << 2) | (1 << 30)))
 170:	fdc42703          	lw	a4,-36(s0)
 174:	400007b7          	lui	a5,0x40000
 178:	0799                	addi	a5,a5,6
 17a:	04f71463          	bne	a4,a5,1c2 <pgaccess_test+0xde>
    err("incorrect access bits set");
  free(buf);
 17e:	8526                	mv	a0,s1
 180:	00000097          	auipc	ra,0x0
 184:	6e8080e7          	jalr	1768(ra) # 868 <free>
  printf("pgaccess_test: OK\n");
 188:	00001517          	auipc	a0,0x1
 18c:	92850513          	addi	a0,a0,-1752 # ab0 <malloc+0x1c0>
 190:	00000097          	auipc	ra,0x0
 194:	6a2080e7          	jalr	1698(ra) # 832 <printf>
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6145                	addi	sp,sp,48
 1a0:	8082                	ret
    err("pgaccess failed");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	8de50513          	addi	a0,a0,-1826 # a80 <malloc+0x190>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	e56080e7          	jalr	-426(ra) # 0 <err>
    err("pgaccess failed");
 1b2:	00001517          	auipc	a0,0x1
 1b6:	8ce50513          	addi	a0,a0,-1842 # a80 <malloc+0x190>
 1ba:	00000097          	auipc	ra,0x0
 1be:	e46080e7          	jalr	-442(ra) # 0 <err>
    err("incorrect access bits set");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	8ce50513          	addi	a0,a0,-1842 # a90 <malloc+0x1a0>
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <err>

00000000000001d2 <main>:
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  ugetpid_test();
 1da:	00000097          	auipc	ra,0x0
 1de:	e64080e7          	jalr	-412(ra) # 3e <ugetpid_test>
  pgaccess_test();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	f02080e7          	jalr	-254(ra) # e4 <pgaccess_test>
  printf("pgtbltest: all tests succeeded\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	8de50513          	addi	a0,a0,-1826 # ac8 <malloc+0x1d8>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	640080e7          	jalr	1600(ra) # 832 <printf>
  exit(0);
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	2ae080e7          	jalr	686(ra) # 4aa <exit>

0000000000000204 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 204:	1141                	addi	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 20c:	00000097          	auipc	ra,0x0
 210:	fc6080e7          	jalr	-58(ra) # 1d2 <main>
  exit(0);
 214:	4501                	li	a0,0
 216:	00000097          	auipc	ra,0x0
 21a:	294080e7          	jalr	660(ra) # 4aa <exit>

000000000000021e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 224:	87aa                	mv	a5,a0
 226:	0585                	addi	a1,a1,1
 228:	0785                	addi	a5,a5,1
 22a:	fff5c703          	lbu	a4,-1(a1)
 22e:	fee78fa3          	sb	a4,-1(a5) # 3fffffff <base+0x3fffefdf>
 232:	fb75                	bnez	a4,226 <strcpy+0x8>
    ;
  return os;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret

000000000000023a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 240:	00054783          	lbu	a5,0(a0)
 244:	cb91                	beqz	a5,258 <strcmp+0x1e>
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00f71763          	bne	a4,a5,258 <strcmp+0x1e>
    p++, q++;
 24e:	0505                	addi	a0,a0,1
 250:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	fbe5                	bnez	a5,246 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 258:	0005c503          	lbu	a0,0(a1)
}
 25c:	40a7853b          	subw	a0,a5,a0
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <strlen>:

uint
strlen(const char *s)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cf91                	beqz	a5,28c <strlen+0x26>
 272:	0505                	addi	a0,a0,1
 274:	87aa                	mv	a5,a0
 276:	4685                	li	a3,1
 278:	9e89                	subw	a3,a3,a0
 27a:	00f6853b          	addw	a0,a3,a5
 27e:	0785                	addi	a5,a5,1
 280:	fff7c703          	lbu	a4,-1(a5)
 284:	fb7d                	bnez	a4,27a <strlen+0x14>
    ;
  return n;
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  for(n = 0; s[n]; n++)
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strlen+0x20>

0000000000000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 296:	ce09                	beqz	a2,2b0 <memset+0x20>
 298:	87aa                	mv	a5,a0
 29a:	fff6071b          	addiw	a4,a2,-1
 29e:	1702                	slli	a4,a4,0x20
 2a0:	9301                	srli	a4,a4,0x20
 2a2:	0705                	addi	a4,a4,1
 2a4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2aa:	0785                	addi	a5,a5,1
 2ac:	fee79de3          	bne	a5,a4,2a6 <memset+0x16>
  }
  return dst;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <strchr>:

char*
strchr(const char *s, char c)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	cb99                	beqz	a5,2d6 <strchr+0x20>
    if(*s == c)
 2c2:	00f58763          	beq	a1,a5,2d0 <strchr+0x1a>
  for(; *s; s++)
 2c6:	0505                	addi	a0,a0,1
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	fbfd                	bnez	a5,2c2 <strchr+0xc>
      return (char*)s;
  return 0;
 2ce:	4501                	li	a0,0
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  return 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <strchr+0x1a>

00000000000002da <gets>:

char*
gets(char *buf, int max)
{
 2da:	711d                	addi	sp,sp,-96
 2dc:	ec86                	sd	ra,88(sp)
 2de:	e8a2                	sd	s0,80(sp)
 2e0:	e4a6                	sd	s1,72(sp)
 2e2:	e0ca                	sd	s2,64(sp)
 2e4:	fc4e                	sd	s3,56(sp)
 2e6:	f852                	sd	s4,48(sp)
 2e8:	f456                	sd	s5,40(sp)
 2ea:	f05a                	sd	s6,32(sp)
 2ec:	ec5e                	sd	s7,24(sp)
 2ee:	1080                	addi	s0,sp,96
 2f0:	8baa                	mv	s7,a0
 2f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f4:	892a                	mv	s2,a0
 2f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2f8:	4aa9                	li	s5,10
 2fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2fc:	89a6                	mv	s3,s1
 2fe:	2485                	addiw	s1,s1,1
 300:	0344d863          	bge	s1,s4,330 <gets+0x56>
    cc = read(0, &c, 1);
 304:	4605                	li	a2,1
 306:	faf40593          	addi	a1,s0,-81
 30a:	4501                	li	a0,0
 30c:	00000097          	auipc	ra,0x0
 310:	1b6080e7          	jalr	438(ra) # 4c2 <read>
    if(cc < 1)
 314:	00a05e63          	blez	a0,330 <gets+0x56>
    buf[i++] = c;
 318:	faf44783          	lbu	a5,-81(s0)
 31c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 320:	01578763          	beq	a5,s5,32e <gets+0x54>
 324:	0905                	addi	s2,s2,1
 326:	fd679be3          	bne	a5,s6,2fc <gets+0x22>
  for(i=0; i+1 < max; ){
 32a:	89a6                	mv	s3,s1
 32c:	a011                	j	330 <gets+0x56>
 32e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 330:	99de                	add	s3,s3,s7
 332:	00098023          	sb	zero,0(s3)
  return buf;
}
 336:	855e                	mv	a0,s7
 338:	60e6                	ld	ra,88(sp)
 33a:	6446                	ld	s0,80(sp)
 33c:	64a6                	ld	s1,72(sp)
 33e:	6906                	ld	s2,64(sp)
 340:	79e2                	ld	s3,56(sp)
 342:	7a42                	ld	s4,48(sp)
 344:	7aa2                	ld	s5,40(sp)
 346:	7b02                	ld	s6,32(sp)
 348:	6be2                	ld	s7,24(sp)
 34a:	6125                	addi	sp,sp,96
 34c:	8082                	ret

000000000000034e <stat>:

int
stat(const char *n, struct stat *st)
{
 34e:	1101                	addi	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	e426                	sd	s1,8(sp)
 356:	e04a                	sd	s2,0(sp)
 358:	1000                	addi	s0,sp,32
 35a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35c:	4581                	li	a1,0
 35e:	00000097          	auipc	ra,0x0
 362:	18c080e7          	jalr	396(ra) # 4ea <open>
  if(fd < 0)
 366:	02054563          	bltz	a0,390 <stat+0x42>
 36a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 36c:	85ca                	mv	a1,s2
 36e:	00000097          	auipc	ra,0x0
 372:	194080e7          	jalr	404(ra) # 502 <fstat>
 376:	892a                	mv	s2,a0
  close(fd);
 378:	8526                	mv	a0,s1
 37a:	00000097          	auipc	ra,0x0
 37e:	158080e7          	jalr	344(ra) # 4d2 <close>
  return r;
}
 382:	854a                	mv	a0,s2
 384:	60e2                	ld	ra,24(sp)
 386:	6442                	ld	s0,16(sp)
 388:	64a2                	ld	s1,8(sp)
 38a:	6902                	ld	s2,0(sp)
 38c:	6105                	addi	sp,sp,32
 38e:	8082                	ret
    return -1;
 390:	597d                	li	s2,-1
 392:	bfc5                	j	382 <stat+0x34>

0000000000000394 <atoi>:

int
atoi(const char *s)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39a:	00054603          	lbu	a2,0(a0)
 39e:	fd06079b          	addiw	a5,a2,-48
 3a2:	0ff7f793          	andi	a5,a5,255
 3a6:	4725                	li	a4,9
 3a8:	02f76963          	bltu	a4,a5,3da <atoi+0x46>
 3ac:	86aa                	mv	a3,a0
  n = 0;
 3ae:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3b0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3b2:	0685                	addi	a3,a3,1
 3b4:	0025179b          	slliw	a5,a0,0x2
 3b8:	9fa9                	addw	a5,a5,a0
 3ba:	0017979b          	slliw	a5,a5,0x1
 3be:	9fb1                	addw	a5,a5,a2
 3c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c4:	0006c603          	lbu	a2,0(a3)
 3c8:	fd06071b          	addiw	a4,a2,-48
 3cc:	0ff77713          	andi	a4,a4,255
 3d0:	fee5f1e3          	bgeu	a1,a4,3b2 <atoi+0x1e>
  return n;
}
 3d4:	6422                	ld	s0,8(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  n = 0;
 3da:	4501                	li	a0,0
 3dc:	bfe5                	j	3d4 <atoi+0x40>

00000000000003de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3e4:	02b57663          	bgeu	a0,a1,410 <memmove+0x32>
    while(n-- > 0)
 3e8:	02c05163          	blez	a2,40a <memmove+0x2c>
 3ec:	fff6079b          	addiw	a5,a2,-1
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	0785                	addi	a5,a5,1
 3f6:	97aa                	add	a5,a5,a0
  dst = vdst;
 3f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 3fa:	0585                	addi	a1,a1,1
 3fc:	0705                	addi	a4,a4,1
 3fe:	fff5c683          	lbu	a3,-1(a1)
 402:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 406:	fee79ae3          	bne	a5,a4,3fa <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 40a:	6422                	ld	s0,8(sp)
 40c:	0141                	addi	sp,sp,16
 40e:	8082                	ret
    dst += n;
 410:	00c50733          	add	a4,a0,a2
    src += n;
 414:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 416:	fec05ae3          	blez	a2,40a <memmove+0x2c>
 41a:	fff6079b          	addiw	a5,a2,-1
 41e:	1782                	slli	a5,a5,0x20
 420:	9381                	srli	a5,a5,0x20
 422:	fff7c793          	not	a5,a5
 426:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 428:	15fd                	addi	a1,a1,-1
 42a:	177d                	addi	a4,a4,-1
 42c:	0005c683          	lbu	a3,0(a1)
 430:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 434:	fee79ae3          	bne	a5,a4,428 <memmove+0x4a>
 438:	bfc9                	j	40a <memmove+0x2c>

000000000000043a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 43a:	1141                	addi	sp,sp,-16
 43c:	e422                	sd	s0,8(sp)
 43e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 440:	ca05                	beqz	a2,470 <memcmp+0x36>
 442:	fff6069b          	addiw	a3,a2,-1
 446:	1682                	slli	a3,a3,0x20
 448:	9281                	srli	a3,a3,0x20
 44a:	0685                	addi	a3,a3,1
 44c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 44e:	00054783          	lbu	a5,0(a0)
 452:	0005c703          	lbu	a4,0(a1)
 456:	00e79863          	bne	a5,a4,466 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 45a:	0505                	addi	a0,a0,1
    p2++;
 45c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 45e:	fed518e3          	bne	a0,a3,44e <memcmp+0x14>
  }
  return 0;
 462:	4501                	li	a0,0
 464:	a019                	j	46a <memcmp+0x30>
      return *p1 - *p2;
 466:	40e7853b          	subw	a0,a5,a4
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
  return 0;
 470:	4501                	li	a0,0
 472:	bfe5                	j	46a <memcmp+0x30>

0000000000000474 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 47c:	00000097          	auipc	ra,0x0
 480:	f62080e7          	jalr	-158(ra) # 3de <memmove>
}
 484:	60a2                	ld	ra,8(sp)
 486:	6402                	ld	s0,0(sp)
 488:	0141                	addi	sp,sp,16
 48a:	8082                	ret

000000000000048c <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 48c:	1141                	addi	sp,sp,-16
 48e:	e422                	sd	s0,8(sp)
 490:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 492:	040007b7          	lui	a5,0x4000
}
 496:	17f5                	addi	a5,a5,-3
 498:	07b2                	slli	a5,a5,0xc
 49a:	4388                	lw	a0,0(a5)
 49c:	6422                	ld	s0,8(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret

00000000000004a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4a2:	4885                	li	a7,1
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 4aa:	4889                	li	a7,2
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4b2:	488d                	li	a7,3
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4ba:	4891                	li	a7,4
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <read>:
.global read
read:
 li a7, SYS_read
 4c2:	4895                	li	a7,5
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <write>:
.global write
write:
 li a7, SYS_write
 4ca:	48c1                	li	a7,16
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <close>:
.global close
close:
 li a7, SYS_close
 4d2:	48d5                	li	a7,21
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <kill>:
.global kill
kill:
 li a7, SYS_kill
 4da:	4899                	li	a7,6
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4e2:	489d                	li	a7,7
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <open>:
.global open
open:
 li a7, SYS_open
 4ea:	48bd                	li	a7,15
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4f2:	48c5                	li	a7,17
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4fa:	48c9                	li	a7,18
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 502:	48a1                	li	a7,8
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <link>:
.global link
link:
 li a7, SYS_link
 50a:	48cd                	li	a7,19
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 512:	48d1                	li	a7,20
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 51a:	48a5                	li	a7,9
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <dup>:
.global dup
dup:
 li a7, SYS_dup
 522:	48a9                	li	a7,10
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 52a:	48ad                	li	a7,11
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 532:	48b1                	li	a7,12
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 53a:	48b5                	li	a7,13
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 542:	48b9                	li	a7,14
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <connect>:
.global connect
connect:
 li a7, SYS_connect
 54a:	48f5                	li	a7,29
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 552:	48f9                	li	a7,30
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 55a:	1101                	addi	sp,sp,-32
 55c:	ec06                	sd	ra,24(sp)
 55e:	e822                	sd	s0,16(sp)
 560:	1000                	addi	s0,sp,32
 562:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 566:	4605                	li	a2,1
 568:	fef40593          	addi	a1,s0,-17
 56c:	00000097          	auipc	ra,0x0
 570:	f5e080e7          	jalr	-162(ra) # 4ca <write>
}
 574:	60e2                	ld	ra,24(sp)
 576:	6442                	ld	s0,16(sp)
 578:	6105                	addi	sp,sp,32
 57a:	8082                	ret

000000000000057c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57c:	7139                	addi	sp,sp,-64
 57e:	fc06                	sd	ra,56(sp)
 580:	f822                	sd	s0,48(sp)
 582:	f426                	sd	s1,40(sp)
 584:	f04a                	sd	s2,32(sp)
 586:	ec4e                	sd	s3,24(sp)
 588:	0080                	addi	s0,sp,64
 58a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58c:	c299                	beqz	a3,592 <printint+0x16>
 58e:	0805c863          	bltz	a1,61e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 592:	2581                	sext.w	a1,a1
  neg = 0;
 594:	4881                	li	a7,0
 596:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 59a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 59c:	2601                	sext.w	a2,a2
 59e:	00000517          	auipc	a0,0x0
 5a2:	55a50513          	addi	a0,a0,1370 # af8 <digits>
 5a6:	883a                	mv	a6,a4
 5a8:	2705                	addiw	a4,a4,1
 5aa:	02c5f7bb          	remuw	a5,a1,a2
 5ae:	1782                	slli	a5,a5,0x20
 5b0:	9381                	srli	a5,a5,0x20
 5b2:	97aa                	add	a5,a5,a0
 5b4:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ffefe0>
 5b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5bc:	0005879b          	sext.w	a5,a1
 5c0:	02c5d5bb          	divuw	a1,a1,a2
 5c4:	0685                	addi	a3,a3,1
 5c6:	fec7f0e3          	bgeu	a5,a2,5a6 <printint+0x2a>
  if(neg)
 5ca:	00088b63          	beqz	a7,5e0 <printint+0x64>
    buf[i++] = '-';
 5ce:	fd040793          	addi	a5,s0,-48
 5d2:	973e                	add	a4,a4,a5
 5d4:	02d00793          	li	a5,45
 5d8:	fef70823          	sb	a5,-16(a4)
 5dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5e0:	02e05863          	blez	a4,610 <printint+0x94>
 5e4:	fc040793          	addi	a5,s0,-64
 5e8:	00e78933          	add	s2,a5,a4
 5ec:	fff78993          	addi	s3,a5,-1
 5f0:	99ba                	add	s3,s3,a4
 5f2:	377d                	addiw	a4,a4,-1
 5f4:	1702                	slli	a4,a4,0x20
 5f6:	9301                	srli	a4,a4,0x20
 5f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fc:	fff94583          	lbu	a1,-1(s2)
 600:	8526                	mv	a0,s1
 602:	00000097          	auipc	ra,0x0
 606:	f58080e7          	jalr	-168(ra) # 55a <putc>
  while(--i >= 0)
 60a:	197d                	addi	s2,s2,-1
 60c:	ff3918e3          	bne	s2,s3,5fc <printint+0x80>
}
 610:	70e2                	ld	ra,56(sp)
 612:	7442                	ld	s0,48(sp)
 614:	74a2                	ld	s1,40(sp)
 616:	7902                	ld	s2,32(sp)
 618:	69e2                	ld	s3,24(sp)
 61a:	6121                	addi	sp,sp,64
 61c:	8082                	ret
    x = -xx;
 61e:	40b005bb          	negw	a1,a1
    neg = 1;
 622:	4885                	li	a7,1
    x = -xx;
 624:	bf8d                	j	596 <printint+0x1a>

0000000000000626 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 626:	7119                	addi	sp,sp,-128
 628:	fc86                	sd	ra,120(sp)
 62a:	f8a2                	sd	s0,112(sp)
 62c:	f4a6                	sd	s1,104(sp)
 62e:	f0ca                	sd	s2,96(sp)
 630:	ecce                	sd	s3,88(sp)
 632:	e8d2                	sd	s4,80(sp)
 634:	e4d6                	sd	s5,72(sp)
 636:	e0da                	sd	s6,64(sp)
 638:	fc5e                	sd	s7,56(sp)
 63a:	f862                	sd	s8,48(sp)
 63c:	f466                	sd	s9,40(sp)
 63e:	f06a                	sd	s10,32(sp)
 640:	ec6e                	sd	s11,24(sp)
 642:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 644:	0005c903          	lbu	s2,0(a1)
 648:	18090f63          	beqz	s2,7e6 <vprintf+0x1c0>
 64c:	8aaa                	mv	s5,a0
 64e:	8b32                	mv	s6,a2
 650:	00158493          	addi	s1,a1,1
  state = 0;
 654:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 656:	02500a13          	li	s4,37
      if(c == 'd'){
 65a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 65e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 662:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 666:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66a:	00000b97          	auipc	s7,0x0
 66e:	48eb8b93          	addi	s7,s7,1166 # af8 <digits>
 672:	a839                	j	690 <vprintf+0x6a>
        putc(fd, c);
 674:	85ca                	mv	a1,s2
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	ee2080e7          	jalr	-286(ra) # 55a <putc>
 680:	a019                	j	686 <vprintf+0x60>
    } else if(state == '%'){
 682:	01498f63          	beq	s3,s4,6a0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 686:	0485                	addi	s1,s1,1
 688:	fff4c903          	lbu	s2,-1(s1)
 68c:	14090d63          	beqz	s2,7e6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 690:	0009079b          	sext.w	a5,s2
    if(state == 0){
 694:	fe0997e3          	bnez	s3,682 <vprintf+0x5c>
      if(c == '%'){
 698:	fd479ee3          	bne	a5,s4,674 <vprintf+0x4e>
        state = '%';
 69c:	89be                	mv	s3,a5
 69e:	b7e5                	j	686 <vprintf+0x60>
      if(c == 'd'){
 6a0:	05878063          	beq	a5,s8,6e0 <vprintf+0xba>
      } else if(c == 'l') {
 6a4:	05978c63          	beq	a5,s9,6fc <vprintf+0xd6>
      } else if(c == 'x') {
 6a8:	07a78863          	beq	a5,s10,718 <vprintf+0xf2>
      } else if(c == 'p') {
 6ac:	09b78463          	beq	a5,s11,734 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6b0:	07300713          	li	a4,115
 6b4:	0ce78663          	beq	a5,a4,780 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b8:	06300713          	li	a4,99
 6bc:	0ee78e63          	beq	a5,a4,7b8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6c0:	11478863          	beq	a5,s4,7d0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c4:	85d2                	mv	a1,s4
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	e92080e7          	jalr	-366(ra) # 55a <putc>
        putc(fd, c);
 6d0:	85ca                	mv	a1,s2
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e86080e7          	jalr	-378(ra) # 55a <putc>
      }
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b765                	j	686 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6e0:	008b0913          	addi	s2,s6,8
 6e4:	4685                	li	a3,1
 6e6:	4629                	li	a2,10
 6e8:	000b2583          	lw	a1,0(s6)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e8e080e7          	jalr	-370(ra) # 57c <printint>
 6f6:	8b4a                	mv	s6,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b771                	j	686 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fc:	008b0913          	addi	s2,s6,8
 700:	4681                	li	a3,0
 702:	4629                	li	a2,10
 704:	000b2583          	lw	a1,0(s6)
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e72080e7          	jalr	-398(ra) # 57c <printint>
 712:	8b4a                	mv	s6,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	bf85                	j	686 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 718:	008b0913          	addi	s2,s6,8
 71c:	4681                	li	a3,0
 71e:	4641                	li	a2,16
 720:	000b2583          	lw	a1,0(s6)
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e56080e7          	jalr	-426(ra) # 57c <printint>
 72e:	8b4a                	mv	s6,s2
      state = 0;
 730:	4981                	li	s3,0
 732:	bf91                	j	686 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 734:	008b0793          	addi	a5,s6,8
 738:	f8f43423          	sd	a5,-120(s0)
 73c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 740:	03000593          	li	a1,48
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	e14080e7          	jalr	-492(ra) # 55a <putc>
  putc(fd, 'x');
 74e:	85ea                	mv	a1,s10
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e08080e7          	jalr	-504(ra) # 55a <putc>
 75a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75c:	03c9d793          	srli	a5,s3,0x3c
 760:	97de                	add	a5,a5,s7
 762:	0007c583          	lbu	a1,0(a5)
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	df2080e7          	jalr	-526(ra) # 55a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 770:	0992                	slli	s3,s3,0x4
 772:	397d                	addiw	s2,s2,-1
 774:	fe0914e3          	bnez	s2,75c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 778:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b721                	j	686 <vprintf+0x60>
        s = va_arg(ap, char*);
 780:	008b0993          	addi	s3,s6,8
 784:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 788:	02090163          	beqz	s2,7aa <vprintf+0x184>
        while(*s != 0){
 78c:	00094583          	lbu	a1,0(s2)
 790:	c9a1                	beqz	a1,7e0 <vprintf+0x1ba>
          putc(fd, *s);
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	dc6080e7          	jalr	-570(ra) # 55a <putc>
          s++;
 79c:	0905                	addi	s2,s2,1
        while(*s != 0){
 79e:	00094583          	lbu	a1,0(s2)
 7a2:	f9e5                	bnez	a1,792 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7a4:	8b4e                	mv	s6,s3
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	bdf9                	j	686 <vprintf+0x60>
          s = "(null)";
 7aa:	00000917          	auipc	s2,0x0
 7ae:	34690913          	addi	s2,s2,838 # af0 <malloc+0x200>
        while(*s != 0){
 7b2:	02800593          	li	a1,40
 7b6:	bff1                	j	792 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7b8:	008b0913          	addi	s2,s6,8
 7bc:	000b4583          	lbu	a1,0(s6)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	d98080e7          	jalr	-616(ra) # 55a <putc>
 7ca:	8b4a                	mv	s6,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	bd65                	j	686 <vprintf+0x60>
        putc(fd, c);
 7d0:	85d2                	mv	a1,s4
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	d86080e7          	jalr	-634(ra) # 55a <putc>
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b565                	j	686 <vprintf+0x60>
        s = va_arg(ap, char*);
 7e0:	8b4e                	mv	s6,s3
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b54d                	j	686 <vprintf+0x60>
    }
  }
}
 7e6:	70e6                	ld	ra,120(sp)
 7e8:	7446                	ld	s0,112(sp)
 7ea:	74a6                	ld	s1,104(sp)
 7ec:	7906                	ld	s2,96(sp)
 7ee:	69e6                	ld	s3,88(sp)
 7f0:	6a46                	ld	s4,80(sp)
 7f2:	6aa6                	ld	s5,72(sp)
 7f4:	6b06                	ld	s6,64(sp)
 7f6:	7be2                	ld	s7,56(sp)
 7f8:	7c42                	ld	s8,48(sp)
 7fa:	7ca2                	ld	s9,40(sp)
 7fc:	7d02                	ld	s10,32(sp)
 7fe:	6de2                	ld	s11,24(sp)
 800:	6109                	addi	sp,sp,128
 802:	8082                	ret

0000000000000804 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 804:	715d                	addi	sp,sp,-80
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e010                	sd	a2,0(s0)
 80e:	e414                	sd	a3,8(s0)
 810:	e818                	sd	a4,16(s0)
 812:	ec1c                	sd	a5,24(s0)
 814:	03043023          	sd	a6,32(s0)
 818:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 820:	8622                	mv	a2,s0
 822:	00000097          	auipc	ra,0x0
 826:	e04080e7          	jalr	-508(ra) # 626 <vprintf>
}
 82a:	60e2                	ld	ra,24(sp)
 82c:	6442                	ld	s0,16(sp)
 82e:	6161                	addi	sp,sp,80
 830:	8082                	ret

0000000000000832 <printf>:

void
printf(const char *fmt, ...)
{
 832:	711d                	addi	sp,sp,-96
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	e40c                	sd	a1,8(s0)
 83c:	e810                	sd	a2,16(s0)
 83e:	ec14                	sd	a3,24(s0)
 840:	f018                	sd	a4,32(s0)
 842:	f41c                	sd	a5,40(s0)
 844:	03043823          	sd	a6,48(s0)
 848:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84c:	00840613          	addi	a2,s0,8
 850:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 854:	85aa                	mv	a1,a0
 856:	4505                	li	a0,1
 858:	00000097          	auipc	ra,0x0
 85c:	dce080e7          	jalr	-562(ra) # 626 <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6125                	addi	sp,sp,96
 866:	8082                	ret

0000000000000868 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 868:	1141                	addi	sp,sp,-16
 86a:	e422                	sd	s0,8(sp)
 86c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 872:	00000797          	auipc	a5,0x0
 876:	79e7b783          	ld	a5,1950(a5) # 1010 <freep>
 87a:	a805                	j	8aa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87c:	4618                	lw	a4,8(a2)
 87e:	9db9                	addw	a1,a1,a4
 880:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	6318                	ld	a4,0(a4)
 888:	fee53823          	sd	a4,-16(a0)
 88c:	a091                	j	8d0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 88e:	ff852703          	lw	a4,-8(a0)
 892:	9e39                	addw	a2,a2,a4
 894:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 896:	ff053703          	ld	a4,-16(a0)
 89a:	e398                	sd	a4,0(a5)
 89c:	a099                	j	8e2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e7e463          	bltu	a5,a4,8a8 <free+0x40>
 8a4:	00e6ea63          	bltu	a3,a4,8b8 <free+0x50>
{
 8a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	fed7fae3          	bgeu	a5,a3,89e <free+0x36>
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e6e463          	bltu	a3,a4,8b8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	fee7eae3          	bltu	a5,a4,8a8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8b8:	ff852583          	lw	a1,-8(a0)
 8bc:	6390                	ld	a2,0(a5)
 8be:	02059713          	slli	a4,a1,0x20
 8c2:	9301                	srli	a4,a4,0x20
 8c4:	0712                	slli	a4,a4,0x4
 8c6:	9736                	add	a4,a4,a3
 8c8:	fae60ae3          	beq	a2,a4,87c <free+0x14>
    bp->s.ptr = p->s.ptr;
 8cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d0:	4790                	lw	a2,8(a5)
 8d2:	02061713          	slli	a4,a2,0x20
 8d6:	9301                	srli	a4,a4,0x20
 8d8:	0712                	slli	a4,a4,0x4
 8da:	973e                	add	a4,a4,a5
 8dc:	fae689e3          	beq	a3,a4,88e <free+0x26>
  } else
    p->s.ptr = bp;
 8e0:	e394                	sd	a3,0(a5)
  freep = p;
 8e2:	00000717          	auipc	a4,0x0
 8e6:	72f73723          	sd	a5,1838(a4) # 1010 <freep>
}
 8ea:	6422                	ld	s0,8(sp)
 8ec:	0141                	addi	sp,sp,16
 8ee:	8082                	ret

00000000000008f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f0:	7139                	addi	sp,sp,-64
 8f2:	fc06                	sd	ra,56(sp)
 8f4:	f822                	sd	s0,48(sp)
 8f6:	f426                	sd	s1,40(sp)
 8f8:	f04a                	sd	s2,32(sp)
 8fa:	ec4e                	sd	s3,24(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
 902:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 904:	02051493          	slli	s1,a0,0x20
 908:	9081                	srli	s1,s1,0x20
 90a:	04bd                	addi	s1,s1,15
 90c:	8091                	srli	s1,s1,0x4
 90e:	0014899b          	addiw	s3,s1,1
 912:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 914:	00000517          	auipc	a0,0x0
 918:	6fc53503          	ld	a0,1788(a0) # 1010 <freep>
 91c:	c515                	beqz	a0,948 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	02977f63          	bgeu	a4,s1,960 <malloc+0x70>
 926:	8a4e                	mv	s4,s3
 928:	0009871b          	sext.w	a4,s3
 92c:	6685                	lui	a3,0x1
 92e:	00d77363          	bgeu	a4,a3,934 <malloc+0x44>
 932:	6a05                	lui	s4,0x1
 934:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 938:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 93c:	00000917          	auipc	s2,0x0
 940:	6d490913          	addi	s2,s2,1748 # 1010 <freep>
  if(p == (char*)-1)
 944:	5afd                	li	s5,-1
 946:	a88d                	j	9b8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 948:	00000797          	auipc	a5,0x0
 94c:	6d878793          	addi	a5,a5,1752 # 1020 <base>
 950:	00000717          	auipc	a4,0x0
 954:	6cf73023          	sd	a5,1728(a4) # 1010 <freep>
 958:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95e:	b7e1                	j	926 <malloc+0x36>
      if(p->s.size == nunits)
 960:	02e48b63          	beq	s1,a4,996 <malloc+0xa6>
        p->s.size -= nunits;
 964:	4137073b          	subw	a4,a4,s3
 968:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96a:	1702                	slli	a4,a4,0x20
 96c:	9301                	srli	a4,a4,0x20
 96e:	0712                	slli	a4,a4,0x4
 970:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 972:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 976:	00000717          	auipc	a4,0x0
 97a:	68a73d23          	sd	a0,1690(a4) # 1010 <freep>
      return (void*)(p + 1);
 97e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 982:	70e2                	ld	ra,56(sp)
 984:	7442                	ld	s0,48(sp)
 986:	74a2                	ld	s1,40(sp)
 988:	7902                	ld	s2,32(sp)
 98a:	69e2                	ld	s3,24(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 996:	6398                	ld	a4,0(a5)
 998:	e118                	sd	a4,0(a0)
 99a:	bff1                	j	976 <malloc+0x86>
  hp->s.size = nu;
 99c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a0:	0541                	addi	a0,a0,16
 9a2:	00000097          	auipc	ra,0x0
 9a6:	ec6080e7          	jalr	-314(ra) # 868 <free>
  return freep;
 9aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9ae:	d971                	beqz	a0,982 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b2:	4798                	lw	a4,8(a5)
 9b4:	fa9776e3          	bgeu	a4,s1,960 <malloc+0x70>
    if(p == freep)
 9b8:	00093703          	ld	a4,0(s2)
 9bc:	853e                	mv	a0,a5
 9be:	fef719e3          	bne	a4,a5,9b0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9c2:	8552                	mv	a0,s4
 9c4:	00000097          	auipc	ra,0x0
 9c8:	b6e080e7          	jalr	-1170(ra) # 532 <sbrk>
  if(p == (char*)-1)
 9cc:	fd5518e3          	bne	a0,s5,99c <malloc+0xac>
        return 0;
 9d0:	4501                	li	a0,0
 9d2:	bf45                	j	982 <malloc+0x92>
