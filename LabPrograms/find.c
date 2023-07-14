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