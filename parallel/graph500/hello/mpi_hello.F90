
program mpi_hello
  use, intrinsic :: iso_fortran_env
  use mpi
  implicit none
  
  integer, parameter :: SPI = INT32
  integer (kind=SPI), parameter :: o_unit = output_unit
  
  integer (kind=SPI) :: my_mpi_rank
  integer (kind=SPI) :: num_mpi_procs
  integer (kind=SPI) :: ierr
  integer (kind=SPI) :: my_hostname_len
  character*(mpi_max_processor_name) :: my_hostname


  ! Initialize MPI environment
  call mpi_init(ierr)
  call mpi_comm_rank(mpi_comm_world, my_mpi_rank,   ierr)
  call mpi_comm_size(mpi_comm_world, num_mpi_procs, ierr)
  call mpi_get_processor_name(my_hostname, my_hostname_len, ierr)

  ! MPI task roll call
  call my_mpi_write_hello()

  ! Finalize the MPI environment
  call mpi_finalize(ierr)


contains


  subroutine my_mpi_write_hello()
    implicit none
    integer (kind=SPI) :: i
      
  
    if (my_mpi_rank == 0_SPI) then
      write(o_unit,'(a)')""
      write(o_unit,'(a)')"=============================================="
      flush(o_unit)
    end if
        
    call mpi_barrier(mpi_comm_world, ierr)
  
    ! MPI task role call
    mpi_hello: do i = 0_SPI, num_mpi_procs - 1_SPI
  
      if (i == my_mpi_rank) then
        write(o_unit, '(a,i3,a,a8,a)')"Hello from MPI Task: ", my_mpi_rank, " on host: ", my_hostname, "  ||"
        flush(o_unit)
      end if 
      call mpi_barrier(mpi_comm_world, ierr)
          
    end do mpi_hello
  
    flush(o_unit)
    call mpi_barrier(mpi_comm_world, ierr)
      
    if (my_mpi_rank == 0_SPI) then
      write(o_unit,'(a)')"=============================================="
      write(o_unit,'(a)')""
      flush(o_unit)
    end if
        
  
    call mpi_barrier(mpi_comm_world, ierr)
  
  end subroutine my_mpi_write_hello


end program mpi_hello
