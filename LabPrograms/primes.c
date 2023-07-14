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