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