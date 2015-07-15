#if defined(TOOLS_H)
#else
#define TOOLS_H 1

#include <mpi.h>

int error(MPI_Comm comm,int id,const char *fmt,...);
int commandline_argument(int argc,char **argv,const char *keyword,int val);

#endif
