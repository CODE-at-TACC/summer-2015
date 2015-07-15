#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "unistd.h"

#include "tools.h"
#include "mandel.h"

#define MAX(a,b) ( ((a)>(b)) ? (a) : (b) )
/**
   Read the commandline arguments for this program.
   This uses the general commandline_argument routine;
   the commandline is only inspected on processors zero,
   all others get their values by broadcast.
*/
int parameters_from_commandline(int argc,char** argv,MPI_Comm comm,
				int *rsteps,int *riters)
{
  int rank,numprocs, steps,iters, err;
  MPI_Comm_rank(comm,&rank);
  MPI_Comm_size(comm,&numprocs);
  if (rank==0) {
    if ( argc>1 && ( !strcmp(argv[1],"-h") || !strcmp(argv[1],"h") ) )
      return error(comm,0,"\nUsage: mandel steps 123 iters 456\n");
    steps = commandline_argument(argc,argv,"steps",10);
    iters = commandline_argument(argc,argv,"iters",100000);
  }
  err = MPI_Bcast(&steps,1,MPI_INT,0,comm); CHK(err);
  err = MPI_Bcast(&iters,1,MPI_INT,0,comm); CHK(err);
  *rsteps = steps; *riters = iters;
  return 0;
}

/**
   Set the bounds on the x and y range for circle points:
   y from -2 to 2, x bounds will be depending on y.
*/
circle::circle(int pxls,int bound,int bs) {
  infty = bound; pixels = pxls;
  blocksize = bs; block = new struct coordinate[bs];
  writepointer = 0; readpointer = bs;
  ymin=-2.; ymax=+2.; step=2./pixels; y = ymin;
  xmax = sqrt(4-y*y); xmin = -xmax; x = xmin;
  make_coordinate_type(&coordinate_type);
}

/**
   Generate successive coordinates in the circle.
   This simulates a double loop on y and x:
   for each y values, we evaluate those x that are in the circle.
*/
void circle::next_coordinate_internal(struct coordinate& xy) {
  if (x<xmax-step) {
    xy.x = x; xy.y = y; x += step;
  } else if (y<ymax-step) {
    y += step; 
    xmax = sqrt(4-y*y); xmin = -xmax; x = xmin;
    xy.x = x; xy.y = y; x += step;
  } else {
    invalid_coordinate(xy); //.x = -5.; xy.y = -5;
  }
  return;
}
/** 
    Generate blocks of coordinates. The main reason for 
    introducing this level is so that in a block
    all coordinates are valid or all are invalid.
*/
void circle::next_coordinate(struct coordinate& xy) {
  while (writepointer<blocksize) {
    struct coordinate xy;
    next_coordinate_internal(xy);
    if (!is_valid_coordinate(xy)) {
      /* Once one invalid coorddinate has been generated, we
	 fill the whole block with invalids */
      for (int prev=0; prev<blocksize; prev++)
	      invalid_coordinate( block[prev] );
      writepointer = blocksize;
    } else
      /* default case: add the coordinate to the block */
      block[writepointer++] = xy;
    /* if the block is full, set the read pointer at the beginning */
    if (writepointer==blocksize)
      readpointer = 0;
  }
  if (readpointer<blocksize)
    xy = block[readpointer++];
  if (readpointer==blocksize)
    writepointer = 0;
}

int circle::is_valid_coordinate(struct coordinate xy) {
  return xy.x>-3. && xy.y > -3.;
}
void circle::invalid_coordinate(struct coordinate& xy) {
  xy.x = -5.; xy.y = -5.;
}

/* Compute how many iterations it takes for the Mandelbrot
   iteration to escape the circle, return 0 otherwise
*/
int belongs(struct coordinate xy,int itbound) {
  double x=xy.x, y=xy.y; int it;
  for (it=0; it<itbound; it++) {
    double xx,yy;
    xx = x*x - y*y + xy.x;
    yy = 2*x*y + xy.y;
    x = xx; y = yy;
    if (x*x+y*y>4.) {
      return it;
    }
  }
  return 0;
}

/** The main computational loop
 */
void queue::main_loop(MPI_Comm comm,circle *workcircle) {
  int numprocs,rank; 

  numprocs = this->numprocs;
  rank = this->rank;

  // Master
  if (rank==numprocs-1)  {
    this->set_image( new Image(workcircle->pixels,workcircle->pixels,"mandelpicture") );
    for (;;) {
      struct coordinate xy;
      workcircle->next_coordinate(xy);
      if (workcircle->is_valid_coordinate(xy)) {
	      this->total_tasks += 1;
	      this->addtask(xy);
      } // End if
      else break;
    } // End for loop
    this->complete();
  } 
  // Worker
  else { this->wait_for_work(comm,workcircle); }
}

void queue::wait_for_work(MPI_Comm comm,circle *workcircle) {
  MPI_Status status; int numprocs;
  MPI_Comm_size(comm,&numprocs);
  int stop = 0;

  while (!stop) {
    struct coordinate xy;
    int res = 0;

    MPI_Recv(&xy,1,coordinate_type,numprocs-1,0, comm,&status);
    stop = !workcircle->is_valid_coordinate(xy);
    if (stop) res = 0;
    else {
      res = belongs(xy,workcircle->infty);
    }
    MPI_Send(&res,1,MPI_INT,numprocs-1,0, comm);
  }
  return;
}

/** We complete the computation by sending an invalid coordinate
    to all worker processes which causes them to stop.
*/
void queue::complete() { 
  struct coordinate xy;

  workcircle->invalid_coordinate(xy);
  for (int p=0; p<numprocs-1; p++)
    MPI_Send(&xy,1,coordinate_type, p,0,comm);

  t_stop = MPI_Wtime();
  printf("Tasks %d in time %7.4f\n",total_tasks,t_stop-t_start);
  image->Write();
  return; 
};

void make_coordinate_type(MPI_Datatype *ctype) {
  MPI_Type_contiguous(2,MPI_DOUBLE,ctype);
  MPI_Type_commit(ctype);
  return;
}

/** Image stuff
 */
void queue::set_image(Image *theimage) {
  image = theimage;
}

void queue::coordinate_to_image(struct coordinate xy,int iteration) {
  int nx = (int) ( (xy.x+2.f)*(float)image->width *.25 ), 
      ny = (int) ( (xy.y+2.f)*(float)image->height*.25 );
  int pixel = nx+ny*image->width;
  float colour[3];
  if (iteration==0)
    memset(colour,0,3*sizeof(float));
  else {
    float rfloat = ((float) log(log(iteration)+1)) / log(log(workcircle->infty)+1);
    colour[0] = rfloat;
    colour[1] = MAX((float)0,(float)(1-2*rfloat));
    colour[2] = MAX((float)0,(float)(2*(rfloat-.5)));
  }
  image->Add( pixel, colour );
}

