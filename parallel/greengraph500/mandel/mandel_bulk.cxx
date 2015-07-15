#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

#include "mandel.h"
#include "Image.h"



class bulkqueue : public queue {

  private :

    int tag1, tag2, err;
    int free_processor;
    MPI_Request *reqs;  // Two for each worker process
    MPI_Status *stats;
    int *contributions; // These need to be up here to remain in scope
    coordinate *coords;

  public:

    // Constructor
    bulkqueue(MPI_Comm queue_comm, circle *workcircle) : 
      queue(queue_comm, workcircle){
      free_processor = 0;
      tag1  = 0;
      tag2  = 0;
      reqs  = new MPI_Request[2*numprocs-2];
      stats = new  MPI_Status[2*numprocs-2];
      contributions = new int[numprocs-1]; // One for each worker process
      coords = new coordinate[numprocs-1];
      for(int i = 0; i < 2*numprocs-2; i++){ reqs[i] = MPI_REQUEST_NULL; }
      for(int i = 0; i < numprocs - 1; i++){ contributions[i] = 0; }
    };

    // Destructor
    ~bulkqueue(){
      delete [] reqs;
      delete [] stats;
      delete [] contributions;
      delete [] coords;
    };

    // Member function addtask
    int addtask(struct coordinate xy) {
    
      // Send x,y coordinate to worker process 
      err = MPI_Isend(&xy,
                      1,
                      coordinate_type,
                      free_processor,
                      tag1,
                      comm, 
                      &reqs[2*free_processor]);
      CHK(err);

      // Receive contribution to results from worker process
      err = MPI_Irecv(&contributions[free_processor],
                      1,
                      MPI_INT,
                      free_processor,
                      tag2,
                      comm, 
                      &reqs[2*free_processor+1]);
      CHK(err);
     
      // Store x,y coordinates to give to Image later 
      coords[free_processor] = xy;
      free_processor++;
     
      // Only wait once all workers have returned their contribution
      if(free_processor == numprocs - 1){
        err = MPI_Waitall(2*numprocs-2, reqs, stats);
        CHK(err);
        int contribution;
        for(int i = 0; i < numprocs - 1; i++){
          // Compute color for image for each contribution
          if(contributions[i] > 0){ 
            // printf("(Rank %i): coordinate %7.4f %7.4f result: %i\n",rank,coords[i].x,coords[i].y,contributions[i]);
            // Cannot give xy, as it goes out of scope once add_task finishes
            coordinate_to_image(coords[i],contributions[i]);
          }
        }
        // wrap around to the first worker again
        free_processor = 0;
      }

      return 0;
  };

  void complete() {
    // Create an invalid coordinate to send to all workers to 
    // tell them to stop working. 
    struct coordinate xy; workcircle->invalid_coordinate(xy);
    for (int i = 0; i < numprocs - 1; i++){
      MPI_Isend(&xy,1,coordinate_type,i,tag1,comm,&reqs[0]);
    }
    t_stop = MPI_Wtime();
    printf("Cyrus Tasks %d in time %7.4f\n",total_tasks,t_stop-t_start);
    image->Write();
    return; 
  };





};


int main(int argc,char **argv) {
  MPI_Comm comm;
  int numprocs,rank,steps,iters,ierr;

  MPI_Init(&argc,&argv);
  comm = MPI_COMM_WORLD;
  MPI_Comm_set_errhandler(comm,MPI_ERRORS_RETURN);
  MPI_Comm_size(comm,&numprocs);
  MPI_Comm_rank(comm,&rank);

  ierr = parameters_from_commandline
    (argc,argv,comm,&steps,&iters);
  if (ierr) return MPI_Abort(comm,1);

  if (numprocs==1) {
    printf("Sorry, you need at least two processors\n");
    return 1;
  }

  circle *workcircle = new circle(steps,iters,1);
  // Use bulkqueue instead of serialqueue
  bulkqueue *taskqueue = new bulkqueue(comm,workcircle);
  taskqueue->main_loop(comm,workcircle);

  MPI_Finalize();
  return 0;
}
