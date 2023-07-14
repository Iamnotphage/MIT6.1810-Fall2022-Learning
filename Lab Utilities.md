# Lab Utilities

- [Lab Utilities](#lab-utilities)
  - [Boot xv6](#boot-xv6)
  - [sleep](#sleep)
  - [pingpong](#pingpong)
  - [primes](#primes)
  - [find](#find)
  - [xargs](#xargs)

## Boot xv6

配置好之后

Build and run xv6:

```
$ make qemu
```

退出

```c
Ctrl+a+x
```

## sleep

```c
#include "kernel/types.h"
#include "user/user.h"

int main(int argc,char* argv[]){
    if(argc!=2){
        fprintf(2,"ARGUMENTATION ERROR\n");
        exit(1);
    }else{
        int time=atoi(argv[1]);
        sleep(time);
        exit(0);
    }
}
```

## pingpong

```c
#include "kernel/types.h"
#include "user/user.h"

int main(int argc,char* argv[]){
    int pid;
    int fd[2];//file descpritor 0:read 1:write


    pipe(fd);//make a pipe

    pid=fork();

    char buffer[1];//buffer

    if(pid==-1){
        exit(1);
    }

    if(pid==0){//in child process
        read(fd[0],buffer,1);
        fprintf(2,"%d: received ping\n",getpid());
        write(fd[1],buffer,1);
        exit(0);
    }else{//in parent process
        write(fd[1],buffer,1);
        wait((int *)0);
        read(fd[0],buffer,1);
        fprintf(2,"%d: received pong\n",getpid());
        exit(0);
    }
}
```

## primes

```c
//primes.c
#include "kernel/types.h"
#include "user/user.h"

void prime_sieve(int* fd){
    int buf[1];
    close(fd[1]);
    if(read(fd[0],buf,4)!=0){
        //0 stands for nothing to read.
        int p=buf[0];
        fprintf(2,"prime %d\n",p);

        int fd2[2];//to the right neighbor
        pipe(fd2);
        int pid2=fork();//the new process shared that pipe

        if(pid2==0){
            prime_sieve(fd2);
        }else{
            //current(parent) process write to RIGHT
            int n=p;
            while(read(fd[0],buf,4)!=0){
                //n = get a number from left neighbor
                n=buf[0];

                if(n%p!=0){
                    close(fd2[0]);
                    write(fd2[1],buf,4);//send n to right neighbor
                }
            }
            close(fd2[1]);
            wait(0);
        }
    }
    exit(0);
}

int main(){
    int fd[2];
    int p,n;
    int buf[1];
    pipe(fd);
    int pid=fork();
    if(pid==0){
        //in child process
        //read frome left, write into right
        prime_sieve(fd);
    }else{
        //in parent process
        p=2;
        fprintf(2,"prime %d\n",p);
        n=p;
        while(n<35){
            buf[0]=++n;
            if(buf[0]%p!=0){
                close(fd[0]);
                write(fd[1],buf,4);//int has 4B
            }
        }
        close(fd[1]);
        wait(0);//wait for child process
    }
    exit(0);
}
```

## find

```c
//find.c

#include "kernel/types.h"
#include "kernel/fs.h"
#include "kernel/stat.h"
#include "user/user.h"


//format name 返回path最后的/后面的文件名（这里不需要没有达到DIRSIZ就空格填充)
char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p)+1);// (vdes,vsrc,n)
  //memset(buf+strlen(p), ' ', DIRSIZ-strlen(p)); 这里与ls.c不同，
  return buf;
  //因为要与des比较，而输入argv中，des最后一个字符是带结束符的，所以memmove多一个字节
  //注意strlen不包括结束符号
}

//recursion: find all the files in a direcotry tree
//use DFS
void find(char* path,char* des){
    char buf[512],*p;
    int fd;
    struct dirent de;//目录项 dirent structures
    struct stat st;//statistic info of a file

    if((fd = open(path, 0)) < 0){
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){//get file stats info
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)//only consider two types
    {
    case T_DIR://path is a directory
        //check if the path is too long
        if(strlen(path) + 1 + DIRSIZ +1 > sizeof(buf)){
            printf("find: path too long\n");
            break;
        }
        //buf assignment
        strcpy(buf, path);
        p = buf+strlen(buf);//point to the last char
        *p++ = '/';//be careful 这里buf是拼接后的路径，p是操作buf的指针，也是buf最后的部分
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
            if(de.inum == 0){
                continue;//empty directory: inode number==0
            }
            memmove(p, de.name, DIRSIZ);
            p[sizeof(de.name)] = 0;//end of file name注意这里和ls.c不一样，这里因为buf要和des比较（递归的另一个分支）
            //所以这里是sizeof(de.name) 而不是 sizeof(DIRSIZ)
            if(strcmp(de.name,".")==0 || strcmp(de.name,"..")==0){
                continue;// . and .. donot recurse
            }
            //printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
            find(buf,des);//recursion
        }
        break;
    case T_FILE: //path is a file
        if(strcmp(fmtname(path),des)==0){
            printf("%s\n",path);
        }
        break;
    }
    close(fd);
}

int main(int argc,char* argv[]){
    //find [directory] [destination_file]
    if(argc!=3){
        fprintf(2,"arg num error!");
        exit(1);
    }
    find(argv[1],argv[2]);//find(path,des);
    exit(0);
}
```

## xargs

```c
//xargs.c
//try to use *fork* and *exec*

#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

int main(int argc,char* argv[]){

    char *arglist[MAXARG];//exec's argumentation
    char c;//temp char
    int stat=1;//read stat
    char buf[1024];//echo arg

    for(int i=0;i<argc-1;i++){
        arglist[i]=argv[i+1];
    }

    while(stat){
        int p_buf=0;//buf pointer
        int p_arg=argc-1;//arg pointer
        int p_bufbegin=0;//each arg's begin

        //read each line
        while(1){

            stat=read(0,&c,1);//from stdin. 
            if(stat==0){
                exit(0);
            }
            if(c==' ' || c=='\n'){

                buf[p_buf++]=0;//end of a string(arg) and we got a arg
                arglist[p_arg++]=&buf[p_bufbegin];
                p_bufbegin=p_buf;

                if(c=='\n'){
                    break;
                }
            }else{
                buf[p_buf++]=c;
            }
        }
        
        arglist[p_arg]=0;

        /*test
        printf("------TEST------\n");
        printf("buf: %s \n",buf);
        for(int i=0;i<p_arg;i++){
            printf("arglist: %s \n",arglist[i]);
        }
        printf("------OVER------\n");
        */

        if(fork()==0){
            exec(arglist[0],arglist);
        }else{
            wait(0);
        }
    }
    exit(0);
}
```