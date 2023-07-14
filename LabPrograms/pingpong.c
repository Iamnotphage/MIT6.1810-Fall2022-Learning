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