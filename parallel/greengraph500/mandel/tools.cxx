#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "tools.h"

int error(MPI_Comm comm,int id,const char *fmt,...)
{
  int mytid; va_list argp;
  MPI_Comm_rank(comm,&mytid);
  va_start(argp,fmt);
  if (id<0 || id==mytid) {
    vprintf(fmt, argp); printf("\n");
  }
  va_end(argp);
  return 1;
}

int commandline_argument(int argc,char **argv,const char *keyword,int val)
{
  int ipos;
  for (ipos=1; ipos<argc-1; ipos++) {
    if (!strcmp(argv[ipos],keyword)) {
      return atoi(argv[ipos+1]);
    }
  }
  return val;
}

