! W. Cyrus Proctor
! 2015-07-09
!

module digits_mod
  use, intrinsic :: iso_fortran_env
  implicit none

  integer, parameter :: SPI   = INT32
  integer, parameter :: DPI   = INT64
  integer, parameter :: SPR   = REAL32
  integer, parameter :: DPR   = REAL64
  integer, parameter :: QPR   = REAL128

  integer (kind=SPI), parameter :: max_int_len = 18_SPI

end module digits_mod



module io_mod
  use digits_mod
  implicit none

  integer (kind=SPI), parameter :: c_unit = 42_SPI
  integer (kind=SPI), parameter :: o_unit = error_unit !output_unit
  integer (kind=SPI), parameter :: i_unit = input_unit
  integer (kind=SPI), parameter :: e_unit = error_unit

end module io_mod



module mpi_mod
  use mpi
  use omp_lib
  use digits_mod
  use io_mod
  implicit none

  !$omp declare target (my_mpi_rank)
  !$omp declare target (num_mpi_procs)
  !$omp declare target (my_message)

  integer (kind=SPI)            :: my_mpi_rank
  integer (kind=SPI)            :: num_mpi_procs
  integer (kind=SPI)            :: num_omp_threads 
  integer (kind=SPI)            :: iam_omp_thread
  integer (kind=SPI)            :: ierr
  integer (kind=SPI)            :: error_code = 1_SPI

  character(len=mpi_max_processor_name) :: my_hostname
  character(len=256)                    :: my_message
  character(len=35)                     :: filename = ""

  real (kind=DPR), parameter  :: exact_pi = 3.1415926535897932384626433832795028841971693993751058_DPR
  real (kind=DPR)             :: abs_diff
  real (kind=DPR)             :: rel_diff


  interface my_mpi_check
    module procedure my_mpi_check_int, my_mpi_check_bool
  end interface my_mpi_check

  interface my_mpi_scalar_sum
    module procedure my_mpi_scalar_sum_DPR
  end interface my_mpi_scalar_sum

  interface my_mpi_write
    module procedure my_mpi_write_hello, my_mpi_write_hello_DPR, my_mpi_write_hello_DPI, my_mpi_write_hello_SPI
  end interface my_mpi_write



  contains
  

  subroutine compare_answer(approx_pi)
    implicit none
  
    real    (kind=DPR), intent(in) :: approx_pi
    
    ! Serial Code 
  
    abs_diff = abs(exact_pi - approx_pi)
    rel_diff = abs_diff / exact_pi * 100.0_DPR
  
  end subroutine compare_answer
  
  
  subroutine compare_create_filename(num_mpi_procs, num_omp_threads, num_subintervals)
    implicit none
    
    ! Arguments
    integer (kind=SPI) :: num_mpi_procs
    integer (kind=SPI) :: num_omp_threads
    integer (kind=DPI) :: num_subintervals
    
    ! Serial Code
    
    write(filename,'(a8,2(i0.3,a1),i0.12,a4)')&
          "compare_", num_mpi_procs, "_", num_omp_threads, "_", num_subintervals, ".out"
  
  end subroutine compare_create_filename

  
  subroutine my_mpi_start()
    implicit none

    ! Local Variables
    integer (kind=SPI) :: my_hostname_len

    ! Initialize MPI environment
    call mpi_init(ierr)
    call my_mpi_check(ierr)
    call mpi_comm_rank(mpi_comm_world, my_mpi_rank,   ierr)
    call my_mpi_check(ierr)
    call mpi_comm_size(mpi_comm_world, num_mpi_procs, ierr)
    call my_mpi_check(ierr)
    call mpi_get_processor_name(my_hostname, my_hostname_len, ierr)
    call my_mpi_check(ierr)


  end subroutine my_mpi_start



  subroutine my_mpi_get_cmdline_args(num_subintervals, offload_threshold)
    implicit none
    
    ! Arguments
    integer (kind=DPI), intent(inout) :: num_subintervals
    integer (kind=DPI), intent(inout) :: offload_threshold

    ! Local Variables
    character (len=max_int_len*2_SPI) :: num_subintervals_str
    character (len=max_int_len*2_SPI) :: offload_threshold_str
    integer (kind=SPI) :: i
    logical :: err
    integer (kind=SPI) :: io_stat


    num_subintervals_str  = ""
    offload_threshold_str = ""
    err = .false.


    mpi_loop: do i = 0_SPI, num_mpi_procs - 1_SPI

    mpi_rank: if ( my_mpi_rank == i ) then
      call get_command_argument(1_SPI, num_subintervals_str)
      call get_command_argument(2_SPI, offload_threshold_str)

      empty1: if ( num_subintervals_str == "" .and. .not. err ) then
        mpiempty1: if ( my_mpi_rank == 0_SPI) then
          flush(o_unit)
          write(o_unit,'(a)')"Usage: Command-line Argument #1: (64-bit integer) number of sub-intervals for Riemann sum integration"
          flush(o_unit)
        end if mpiempty1
        err = .true.
      else
        huge1: if (len_trim(num_subintervals_str) > max_int_len .and. .not. err) then
          mpihuge1: if ( my_mpi_rank == 0_SPI) then
            flush(o_unit)
            write(o_unit,'(a,i0,a)')"Usage: Command-line Argument #1 (64-bit integer) Number of integration sub-intervals must be less than ", max_int_len, " digits. Recieved:",trim(num_subintervals_str)
            flush(o_unit)
          end if mpihuge1
          err = .true.
        end if huge1
        read(num_subintervals_str,'(i30)',iostat=io_stat)num_subintervals
        noint1: if (io_stat /= 0_SPI .and. .not. err) then
          mpinoint1: if (my_mpi_rank == 0_SPI) then
            flush(o_unit)
            write(o_unit,'(a)')"Usage: Command-line Argument #1 (64-bit integer) Number of integration sub-intervals must be an integer. Recieved:",trim(num_subintervals_str)
            flush(o_unit)
          end if mpinoint1
          err = .true.
        end if noint1
        ltzero1: if (num_subintervals <= 0_SPI .and. .not. err) then
          mpiltzero1: if ( my_mpi_rank == 0_SPI) then
            flush(o_unit)
            write(o_unit,'(a)')"Usage: Command-line Argument #1 (64-bit integer) Number of integration sub-intervals must be greater than zero. Recieved:",trim(num_subintervals_str)
            flush(o_unit)
          end if mpiltzero1
          err = .true.
        end if ltzero1
      end if empty1


      empty2: if ( offload_threshold_str == "" .and. .not. err ) then
        mpiempty2: if ( my_mpi_rank == 0_SPI) then
          flush(o_unit)
          write(o_unit,'(a)')"Usage: Command-line Argument #2: (64-bit integer) Minimum number of sub-intervals for MIC-offload"
          flush(o_unit)
        end if mpiempty2
        err = .true.
      else
        huge2: if (len_trim(offload_threshold_str) > max_int_len .and. .not. err) then
          mpihuge2: if ( my_mpi_rank == 0_SPI) then
            flush(o_unit)
            write(o_unit,'(a,i0,a)')"Usage: Command-line Argument #2 (64-bit integer) Minimum number of sub-intervals for MIC-offload must be less than ", max_int_len, " digits. Recieved:",trim(offload_threshold_str)
            flush(o_unit)
          end if mpihuge2
          err = .true.
        end if huge2
        read(offload_threshold_str,'(i30)',iostat=io_stat)offload_threshold
        noint2: if (io_stat /= 0_SPI .and. .not. err) then
          mpinoint2: if ( my_mpi_rank == 0_SPI) then
            flush(o_unit)
            write(o_unit,'(a)')"Usage: Command-line Argument #2 (64-bit integer) Minimum number of sub-intevals for MIC-offload must be an integer. Recieved:",trim(offload_threshold_str)
            flush(o_unit)
          end if mpinoint2
          err = .true.
        end if noint2
        ltzero2: if (offload_threshold < 0_SPI .and. .not. err) then
          mpiltzero2: if ( my_mpi_rank == 0_SPI) then
            flush(o_unit)
            write(o_unit,'(a)')"Usage: Command-line Arguement #2: (64-bit integer) Minimum number of integration sub-intervals for MIC-offload must be greater than or equal to zero. Recieved:",trim(offload_threshold_str)
            flush(o_unit)
          end if mpiltzero2
          err = .true.
        end if ltzero2
      end if empty2

    end if mpi_rank

    call mpi_barrier(mpi_comm_world, ierr)

    end do mpi_loop
    
    if ( err ) then
      call my_mpi_finish()
      stop
    end if

    call my_mpi_write("num_subintervals" , num_subintervals)
    call my_mpi_write("offload_threshold", offload_threshold)

  end subroutine my_mpi_get_cmdline_args



  subroutine my_mpi_finish()
    implicit none

    ! Finalize MPI environment
    call mpi_finalize(ierr)
    call my_mpi_check(ierr)

  end subroutine my_mpi_finish


  subroutine my_mpi_abort()
    implicit none

    call mpi_abort(mpi_comm_world, error_code, ierr)

  end subroutine my_mpi_abort


  function my_mpi_scalar_sum_DPR(my_var, mpi_task_rank) result(ans)
    implicit none

    ! Arguments
    ! Single Precision Integers
    integer (kind=SPI), optional, intent(in) :: mpi_task_rank ! MPI        private
    
    ! Double Precision Reals
    real (kind=DPR), intent(in) :: my_var                     ! MPI        private
    real (kind=DPR)             :: ans                        ! MPI        private

    ! Initialize
    ans = 0.0_DPR

    ! Ensure mpi_task_rank is a sane value if present
    presence: if (present(mpi_task_rank)) then
      good_range: if (mpi_task_rank < 0_SPI .or. mpi_task_rank >= num_mpi_procs) then
        rank: if (my_mpi_rank == 0_SPI) then
          flush(o_unit)
          write(o_unit,'(a,i0)')"ERROR: Illegal mpi_task_rank: my_mpi_scalar_sum: ", mpi_task_rank
          flush(o_unit)
          call my_mpi_abort()
        end if rank
      end if good_range

      ! Send answer to designated mpi_task_rank only
      call mpi_reduce(my_var,  & ! Variable to sum over MPI tasks
                         ans,  & ! Variable to store answer in
                        1_SPI, & ! MPI reduction number of elements
        mpi_double_precision,  & ! MPI precision of the elements
                     mpi_sum,  & ! MPI reduction operation
               mpi_task_rank,  & ! MPI task rank to store answer on
              mpi_comm_world,  & ! MPI communicator where my_var lives
                        ierr)    ! MPI error status

    else

      ! Send answer to all MPI tasks
      call mpi_allreduce(my_var,  & ! Variable to sum over MPI tasks
                            ans,  & ! Variable to store answer in
                          1_SPI,  & ! MPI reduction number of elements
           mpi_double_precision,  & ! MPI precision of the elements
                        mpi_sum,  & ! MPI reduction operation
                 mpi_comm_world,  & ! MPI communicator where my_var lives
                           ierr)    ! MPI error status

    end if presence
    
    call my_mpi_check(ierr)

  end function my_mpi_scalar_sum_DPR


  
  subroutine my_mpi_check_int(expression)
    implicit none
    integer (kind=SPI), intent(in) :: expression

    if (expression /= 0_SPI) then
      flush(o_unit)
      write(o_unit,'()')"ERROR: check"
      flush(o_unit)
      call my_mpi_abort()
      stop
    end if

  end subroutine my_mpi_check_int


  subroutine my_mpi_check_bool(expression)
    implicit none
    logical (kind=SPI), intent(in) :: expression

    if (.not. expression) then
      flush(o_unit)
      write(o_unit,'()')"ERROR: check"
      flush(o_unit)
      call my_mpi_abort()
      stop
    end if

  end subroutine my_mpi_check_bool

  subroutine my_mpi_ordered_write()
    implicit none
    
    ! Local Variables
    integer (kind=SPI) :: i
    integer (kind=SPI) :: stat(mpi_status_size)
    
    if (my_mpi_rank /= 0_SPI) then
        call mpi_send(my_message, len(my_message), mpi_character, 0_SPI, 101_SPI, mpi_comm_world, ierr)
    else
      write(o_unit,'(a)')""
      write(o_unit,'(a)')repeat("=",len(trim(my_message)))
      write(o_unit,'(a)')trim(my_message)
      mpi_write: do i = 1_SPI, num_mpi_procs - 1_SPI
        call mpi_recv(my_message, len(my_message), mpi_character, i, 101_SPI, mpi_comm_world, stat, ierr)
        write(o_unit,'(a)')trim(my_message)
      end do mpi_write
      write(o_unit,'(a)')repeat("=",len(trim(my_message)))
      write(o_unit,'(a)')""
    end if

  end subroutine my_mpi_ordered_write


  subroutine my_mpi_write_hello()
    implicit none

    my_message = ""
    write(my_message, '(a,i3,a,a,a)')"Hello from MPI Task: ", my_mpi_rank, " on host: ", trim(my_hostname), "  ||"
    call my_mpi_ordered_write()
 
    ! All MPI processes must synchronize
    call mpi_barrier(mpi_comm_world, ierr)

  end subroutine my_mpi_write_hello

  

  subroutine my_mpi_write_hello_DPR(my_label,my_var)
    implicit none
    
    ! Arguments
    character*(*),   intent(in) :: my_label
    real (kind=DPR), intent(in) :: my_var

    my_message = ""
    write(my_message, '(a,i3,x,a,a,E23.15,a)')"MPI Task: ", my_mpi_rank, my_label, " Value: ", my_var, "  ||"
    call my_mpi_ordered_write()
  
    ! All MPI processes must synchronize
    call mpi_barrier(mpi_comm_world, ierr)

  end subroutine my_mpi_write_hello_DPR



  subroutine my_mpi_write_hello_DPI(my_label,my_var)
    implicit none

    ! Arguments
    character*(*),      intent(in) :: my_label
    integer (kind=DPI), intent(in) :: my_var

    my_message = ""
    write(my_message, '(a,i3,x,a,a,I23,a)')"MPI Task: ", my_mpi_rank, my_label, " Value: ", my_var, "  ||"
    call my_mpi_ordered_write()
    
    ! All MPI processes must synchronize
    call mpi_barrier(mpi_comm_world, ierr)

  end subroutine my_mpi_write_hello_DPI


  subroutine my_mpi_write_hello_SPI(my_label, my_var)
    implicit none

    ! Arguments
    character*(*),     intent(in) :: my_label
    integer(kind=SPI), intent(in) :: my_var

    call my_mpi_write_hello_DPI(my_label, int(my_var, kind=DPI))

  end subroutine my_mpi_write_hello_SPI



  subroutine my_mpi_omp_write_hello(num_subintervals)
    implicit none

    ! Arguments
    integer (kind=DPI) :: num_subintervals

    ! Local Variables
    integer (kind=SPI) :: i
  
  
    !$omp parallel private (iam_omp_thread, i)
  
#ifdef _OPENMP 
      num_omp_threads     = omp_get_num_threads()
      iam_omp_thread      = omp_get_thread_num()
#else
      num_omp_threads     = 1_SPI
      iam_omp_thread      = 0_SPI
#endif

      ! Only the rank 0 MPI task master OMP thread on 
      ! the initial do loop iteration will create a filename.
      !$omp master
      if ( my_mpi_rank == 0_SPI ) then
        call compare_create_filename(num_mpi_procs,num_omp_threads,num_subintervals) 
      end if
      !$omp end master
  
      ! omp thread role call
      omp_hello: do i = 0_SPI, num_omp_threads - 1_SPI
      
        if (i == iam_omp_thread) then
          my_message = ""
          write(my_message, '(4(a,i3,x),a)')"Hello from MPI Task:", my_mpi_rank, "OMP Thread:", iam_omp_thread, &
                                     &"MPI Total:", num_mpi_procs, "OMP Total:", num_omp_threads, "  ||"
          call my_mpi_ordered_write()
        end if
      
        ! All OMP threads must synchronize
        !$omp barrier
      
      end do omp_hello
  
    !$omp end parallel

  
    ! All MPI processes must synchronize
    call mpi_barrier(mpi_comm_world, ierr)

  end subroutine my_mpi_omp_write_hello



  function my_mpi_get_num_offload_devices() result(my_num_offload_devices)
    implicit none
    integer (kind=SPI) :: my_num_offload_devices
   
#ifdef _OPENMP 
      my_num_offload_devices = omp_get_num_devices()
#else
      my_num_offload_devices = 0_SPI
      if (my_mpi_rank == 0_SPI) then
        flush(o_unit)   
        write(o_unit,'(a)')"========================="
        write(o_unit,'(a)')"OpenMP is NOT enabled  ||"
        write(o_unit,'(a)')"========================="
        flush(o_unit)
      end if
#endif
    
    call my_mpi_write("num_offload_devices", my_num_offload_devices)
  
  end function my_mpi_get_num_offload_devices



  function my_mpi_distribute_subintervals(num_subintervals) result(my_num_subintervals)
    implicit none

    ! Arguments
    ! Double Precision Integers
    integer (kind=DPI), intent(in) :: num_subintervals      ! Global
    integer (kind=DPI)             :: my_num_subintervals   ! MPI        private

    if (num_subintervals >= num_mpi_procs) then
      my_num_subintervals = num_subintervals / num_mpi_procs
      if (my_mpi_rank == num_mpi_procs - 1_SPI) then
        my_num_subintervals = my_num_subintervals + (num_subintervals - (num_subintervals / num_mpi_procs) * num_mpi_procs) !mod(num_subintervals, num_mpi_procs)
      end if
    else
      if (my_mpi_rank < num_subintervals) then
        my_num_subintervals = 1_SPI
      else
        my_num_subintervals = 0_SPI
      end if
    end if
    
  end function my_mpi_distribute_subintervals


  ! Check if OMP will offload to MIC or stay on HOST
  subroutine check_on_mic()
    implicit none
    logical :: on_mic

    !$omp declare target

    on_mic = .false.

#ifdef __MIC__
    on_mic = .true.
#endif

    if (on_mic) then
      write(my_message, '(a,i3,a)')"MPI Task: ", my_mpi_rank," Offloading on a MIC  ||"
    else
      write(my_message, '(a,i3,a)')"MPI Task: ", my_mpi_rank," Running on a HOST  ||"
    end if

  end subroutine check_on_mic


end module mpi_mod


module timer_mod
  use mpi_mod
  implicit none

  type, public :: Timer

    real(kind=DPR),   private :: start_time    =  0.0_DPR
    real(kind=DPR),   private :: end_time      =  0.0_DPR
    real(kind=DPR),   private :: delta_time    = -1.0_DPR
    real(kind=DPR),   public  :: total_time    = -1.0_DPR
    character(len=1), private :: timer_type    = ""
    logical,          private :: timer_started = .false.
    logical,          private :: timer_ended   = .false.

  contains

    procedure, public :: tick    => timer_start
    procedure, public :: tock    => timer_end
    procedure, public :: report  => timer_report
    
  end type Timer
  
  ! Timers
  type(Timer) :: omp_timer
  type(Timer) :: mpi_timer
  type(Timer) :: sys_timer
  type(Timer) :: cpu_timer

contains

  subroutine timer_start(this, timer_type)
    implicit none

    ! Arguments
    class(Timer), intent(inout)  :: this
    character(len=1), intent(in) :: timer_type

    select case(timer_type)
      case("o")
        call omp_timer_start(this)
      case("m")
        call mpi_timer_start(this)
      case("s")
        call system_timer_start(this)
      case("c")
        call cpu_timer_start(this)
      case default
        call timer_type_error(timer_type)
    end select

    this%timer_type = timer_type
    this%timer_started = .true.

  end subroutine timer_start

  subroutine timer_end(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout)  :: this

    if (.not. this%timer_started)then
      call timer_start_error()
    end if

    select case(this%timer_type)
      case("o")
        call omp_timer_end(this)
      case("m")
        call mpi_timer_end(this)
      case("s")
        call system_timer_end(this)
      case("c")
        call cpu_timer_end(this)
      case default
        call timer_type_error(this%timer_type)
    end select

    this%timer_ended = .true.

  end subroutine timer_end

  subroutine timer_report(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

    ! Local Variables
    character(len=256) :: my_label
    
    if (.not. this%timer_started)then
      call timer_start_error()
    end if

    if (.not. this%timer_ended)then
      call timer_end_error()
    end if

    select case(this%timer_type)
      case("o")
        my_label = "omp_get_wtime"
      case("m")
        my_label = "    mpi_wtime"
      case("s")
        my_label = " system_clock"
      case("c")
        my_label = "     cpu_time"
      case default
        call timer_type_error(this%timer_type)
    end select

    call my_mpi_write(trim(my_label),this%delta_time)
    
    this%total_time =  my_mpi_scalar_sum(this%delta_time)

  end subroutine timer_report

  subroutine omp_timer_start(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

#ifdef _OPENMP
    this%start_time = omp_get_wtime()
#else
    this%start_time = 0.0_DPR
#endif

  end subroutine omp_timer_start

  subroutine omp_timer_end(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

#ifdef _OPENMP
    this%end_time   = omp_get_wtime()
    this%delta_time = this%end_time - this%start_time 
#else
    this%end_time   = 0.0_DPR
    this%delta_time = -1.0_DPR
#endif

  end subroutine omp_timer_end

  subroutine mpi_timer_start(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

    this%start_time = mpi_wtime()

  end subroutine mpi_timer_start

  subroutine mpi_timer_end(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

    this%end_time   = mpi_wtime()
    this%delta_time = this%end_time - this%start_time

  end subroutine mpi_timer_end

  subroutine system_timer_start(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

    ! Local Variables
    ! Double Precision Integers
    integer (kind=DPI) :: counter
    integer (kind=DPI) :: count_rate
    integer (kind=DPI) :: count_max
   
    call system_clock(counter, count_rate, count_max)

    this%start_time = real(counter, kind=DPR)

  end subroutine system_timer_start
  
  subroutine system_timer_end(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

    ! Local Variables
    ! Double Precision Integers
    integer (kind=DPI) :: counter
    integer (kind=DPI) :: count_rate
    integer (kind=DPI) :: count_max
   
    call system_clock(counter, count_rate, count_max)

    this%end_time   = real(counter, kind=DPR)
    this%delta_time = (this%end_time - this%start_time) / real(count_rate, kind=DPR)

  end subroutine system_timer_end

  subroutine cpu_timer_start(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this

    call cpu_time(this%start_time)

  end subroutine cpu_timer_start

  subroutine cpu_timer_end(this)
    implicit none

    ! Arguments
    class(Timer), intent(inout) :: this
    
    call cpu_time(this%end_time)
    this%delta_time = this%end_time - this%start_time

  end subroutine cpu_timer_end

  subroutine timer_type_error(timer_type)
    implicit none

    ! Arguments
    character(len=1) :: timer_type

    if (my_mpi_rank == 0_SPI) then
      write(o_unit,'(a,a)')"ERROR: timer_mod: Unknown Timer type. Received: ", timer_type
      write(o_unit,'(a)')"Allowed types:"
      write(o_unit,'(a)')"  o - omp_get_wtime"
      write(o_unit,'(a)')"  m - mpi_wtime"
      write(o_unit,'(a)')"  s - system_clock"
      write(o_unit,'(a)')"  c - cpu_time"
      call my_mpi_abort()
    end if
    
  end subroutine timer_type_error

  subroutine timer_start_error()
    implicit none

    if (my_mpi_rank == 0_SPI)then
      write(o_unit,'(a)')"ERROR: timer_mod: A timer_start call must precede a timer_end call."
      call my_mpi_abort()
    end if

  end subroutine timer_start_error
  
  subroutine timer_end_error()
    implicit none

    if (my_mpi_rank == 0_SPI)then
      write(o_unit,'(a)')"ERROR: timer_mod: A timer_end call must precede a timer_report call."
      call my_mpi_abort()
    end if

  end subroutine timer_end_error

end module timer_mod



!> @details
!! @verbatim
!! Hybrid MPI/OpenMP 4.0 program with offload directives 
!! to calculate Pi via numerical approximation of
!!  _                                              .
!! / | 1                                           .
!! |           4                                   .
!!  \     ----------- dx = Pi                      .
!!   |     1 + x * x                               .
!! |_/ 0                                           .
!!                                                 .
!! by a Riemann sum using the midpoint method, i.e.:
!!                                                 .
!!  _                   N                          .
!! / | 1               ---                         .
!! |                   \                           .       
!!  \    f(x) dx ~= h  /   f( h * ( n - 1/2) )     .
!!   |                 ---                         .
!! |_/ 0               n=1                         .
!!                                                 .
!! @endverbatim
program calc_pi
  use timer_mod
  implicit none 
  
  integer (kind=DPI) :: num_subintervals                  ! Global
  integer (kind=DPI) :: offload_threshold                 ! Global
  integer (kind=DPI) :: my_num_subintervals               ! MPI        private

  real    (kind=DPR) :: my_subintegral                    ! MPI        private
  real    (kind=DPR) :: my_pi                             ! MPI        private
  real    (kind=DPR) :: global_pi                         ! Global
  

  ! Initialize MPI environment
  call my_mpi_start()

  ! MPI task roll call
  call my_mpi_write()

  ! Retrieve num_subintervals and offload_threshold from command-line
  call my_mpi_get_cmdline_args(num_subintervals, offload_threshold)

  ! Divide number of subintervals amongst MPI tasks
  my_num_subintervals = my_mpi_distribute_subintervals(num_subintervals)
  
  call my_mpi_write("my_num_subintervals",my_num_subintervals)
  
  ! Integrate function with MPI + OMP and conditionally offload onto MIC
  my_subintegral = omp_integrate(my_num_subintervals, num_subintervals, offload_threshold)

  ! Collect all the partial sums from each MPI task
  my_pi     = my_mpi_scalar_sum(my_subintegral, 0_SPI)
  global_pi = my_mpi_scalar_sum(my_subintegral)

  ! Write out the results to the screen
  call my_mpi_write("my_subintegral", my_subintegral)
  call my_mpi_write("      local_pi", my_pi)
  call my_mpi_write("     global_pi", global_pi)

  ! Compare our answer to "exact" answer
  if (my_mpi_rank == 0_SPI) then
    call compare_answer(global_pi)
    call compare_write(c_unit, global_pi, exact_pi)
    call compare_write(o_unit, global_pi, exact_pi)
  end if

  ! Finalize the MPI environment
  call my_mpi_finish()  


contains




!> function omp_integrate
!! @brief Integrate a function -- func -- over interval [0,1]
!!
!! @details 
!! Each MPI task will compute via a Riemann sum midpoint approximation the
!! integral of a function, defined in func, over a subinterval [a,b] within the 
!! inclusive interval from 0 <= a < b <= 1. Each MPI task will split the 
!! number of function calls in a round-robin type fashion to all OMP threads
!! assigned to it. Each OMP thread reports its contribution and is summed
!! via an OMP sum reduction into my_subintegration_sum. Each MPI task's result,
!! stored in its copy of my_subintegral, is returned to be reduced again for the 
!! final answer.
!!
!! @param my_num_subintervals Number of subintervals per MPI task for Riemann sum
!! @param num_subintervals Total number of subintervals for Riemann sum
!! @param offload_threshold Minimum number of elements within a subinterval
!!                          such that offload onto an accelerator is allowed
!! @returns my_subintegral The contribution to the total integral per MPI task
function omp_integrate(my_num_subintervals, num_subintervals, offload_threshold) result(my_subintegral)
  implicit none

  ! Arguments
  ! Double Precision Integers
  integer (kind=DPI), intent(in)  :: my_num_subintervals  ! MPI        private
  integer (kind=DPI), intent(in)  :: num_subintervals     ! Global
  integer (kind=DPI), intent(in)  :: offload_threshold    ! Global
  
  ! Double Precision Reals
  real (kind=DPR)                 :: my_subintegral       ! MPI        private


  ! Local Variables
  ! Single Precision Integers
  integer (kind=SPI) :: my_num_offload_devices            ! MPI        private
                             
  ! Double Precision Integers                            
  integer (kind=DPI) :: i                                 ! MPI/Thread private 
  integer (kind=DPI) :: my_start_index                    ! MPI        private
  integer (kind=DPI) :: my_end_index                      ! MPI        private
  integer (kind=DPI) :: my_start_index_offset             ! MPI        private
  integer (kind=DPI) :: subintervals_per_proc             ! Global
                             
  ! Double Precision Reals                            
  real (kind=DPR)    :: h                                 ! Global
  real (kind=DPR)    :: x                                 ! MPI/Thread private
  real (kind=DPR)    :: my_subintegration_sum             ! MPI        private

  ! Logicals
  logical            :: my_conduct_offload                ! MPI        private


  ! Initialize
  my_conduct_offload = .false.

  call my_mpi_omp_write_hello(num_subintervals)
 
  ! Determine number of potential offload devices
  my_num_offload_devices = my_mpi_get_num_offload_devices()

  ! Calculate the global numerical integration step size
  h = 1.0_DPR / num_subintervals
  
  ! Determine MPI interval index range for this MPI task
  ! Note: The last MPI task picks up any extra subintervals
  subintervals_per_proc = int(num_subintervals / num_mpi_procs, kind=DPI)  ! Integer division
  my_start_index_offset = 0_DPI
  if (subintervals_per_proc == 0_DPI) my_start_index_offset = int(my_mpi_rank, kind=DPI)
  my_start_index =  subintervals_per_proc * int(my_mpi_rank, kind=DPI) + 1_DPI + my_start_index_offset
  my_end_index   = my_start_index + my_num_subintervals - 1_DPI

  call my_mpi_write("my_start_index", my_start_index)
  call my_mpi_write("  my_end_index", my_end_index)

  ! Only offload if a device exists and our threshold requirement is met
  if (my_num_offload_devices >= 1_SPI .and. num_subintervals >= offload_threshold) then
    my_conduct_offload = .true.
  end if

  ! Initialize on all MPI tasks
  my_subintegration_sum = 0.0_DPR

  ! Start timers
  call omp_timer%tick("o")
  call mpi_timer%tick("m")
  call sys_timer%tick("s")
  call cpu_timer%tick("c")

  ! Tell OMP that we wish to send the values of my_mpi_rank to the offload device
  !$omp target data map(to:my_mpi_rank, num_mpi_procs) map(from: my_message) if (my_conduct_offload)
  
    ! Transfer host MPI task values of my_mpi_rank to the offload device
    !$omp target update to(my_mpi_rank, num_mpi_procs) if (my_conduct_offload)
    
      ! Conditional offload directive
      !$omp target if (my_conduct_offload)
      
        ! Check to see if we are running on a MIC or host
        call check_on_mic()
      
        ! Start an OMP thread parallel section ensuring each thread has their own copy of i and x
        !$omp parallel private (i, x)
        
          ! Allow each thread to complete an addition reduction on their own sub-subinterval 
          !$omp do schedule(static) reduction(+:my_subintegration_sum)

            ! Respective threads further subdivide the MPI subindices
            do i = my_start_index, my_end_index

              ! Evaluate at x = h * (i - 1/2)
              x = h * ( real(i, kind=DPR) - 0.5_DPR )

              ! Keep a runnning sum func(x) evaluations for each OMP thread on each MPI task
              my_subintegration_sum = my_subintegration_sum + func(x)

            end do

          !$omp end do
      !$omp end parallel
    !$omp end target
    
    ! Transfer the content of my_message from the MIC(s) back to the host(s) and write out
    !$omp target update from(my_message) if (my_conduct_offload)
    call my_mpi_ordered_write()

  !$omp end target data

  ! End timers
  call omp_timer%tock()
  call mpi_timer%tock()
  call sys_timer%tock()
  call cpu_timer%tock()

  ! Report timings
  call omp_timer%report()
  call mpi_timer%report()
  call sys_timer%report()
  call cpu_timer%report()

  ! Normalize answer for each MPI task
  my_subintegral = h * my_subintegration_sum

  
  ! All MPI processes must synchronize
  call mpi_barrier(mpi_comm_world, ierr)

end function omp_integrate



!> function func
!! @brief Evaluate the value f(x) given x
!!
!! @details 
!! Given a value, x, evaluate f(x) = 4 / (1 + x^2) and return the result.
!!
!! @param x abscissa with which to evaluate by
!! @returns f evaluated at point x
pure function func(x) result(f)
  implicit none
  
  ! Arguments
  ! Double Precision Reals
  real (kind=DPR), intent(in)  :: x                       ! Global
  real (kind=DPR)              :: f                       ! Global
  
  !$omp declare target                                    ! Signals compiler to generate device offload code
  
  f = 4.0_DPR / ( 1.0_DPR + x * x )

end function func



subroutine compare_write(output_unit, approx_answer, exact_answer)
  implicit none

  ! Arguments
  ! Single Precision Integer
  integer (kind=SPI), intent(in) :: output_unit

  ! Double Precision Real
  real    (kind=DPR), intent(in) :: approx_answer
  real    (kind=DPR), intent(in) :: exact_answer

  ! Local Variables
  logical                        :: unit_ok 
  logical                        :: unit_open
  logical                        :: to_screen


  ! Serial Code


  ! Initialize
  unit_ok   = .false.
  unit_open = .true.
  to_screen = .true.

  inquire (unit=output_unit, exist=unit_ok , opened=unit_open)

  if (unit_ok .and. .not. unit_open) then
    open (unit=output_unit, file=filename)
    to_screen = .false.
  endif

  flush(output_unit)
  if (to_screen) then
    write(output_unit,'(a)')""
    write(output_unit,'(a)')"================================================================="
    write(output_unit,'(a,x,E23.15,a)')"                       exact_answer: ", exact_answer, "  ||"
    write(output_unit,'(a,x,E23.15,a)')"                 approximate_answer: ", approx_answer, "  ||"
    write(output_unit,'(a,x,E23.15,a)')"                absolute_difference: ", abs_diff, "  ||"
    write(output_unit,'(a,x,F19.15,a)')"                 percent_difference: ", rel_diff, " %    ||"
    write(output_unit,'(a)')"================================================================="
    write(output_unit,'(a,x,E23.15,a)')"                 omp_wtime_total(s): ", omp_timer%total_time, "  ||"
    write(output_unit,'(a,x,E23.15,a)')"                 mpi_wtime_total(s): ", mpi_timer%total_time, "  ||"
    write(output_unit,'(a,x,E23.15,a)')"              system_clock_total(s): ", sys_timer%total_time, "  ||"
    write(output_unit,'(a,x,E23.15,a)')"                  cpu_time_total(s): ", cpu_timer%total_time, "  ||"
    write(output_unit,'(a)')"================================================================="
    write(output_unit,'(a,x,E23.15,a)')"      omp_wtime_avg_per_mpi_task(s): ", omp_timer%total_time / real(num_mpi_procs, kind=DPR), "  ||"
    write(output_unit,'(a,x,E23.15,a)')"      mpi_wtime_avg_per_mpi_task(s): ", mpi_timer%total_time / real(num_mpi_procs, kind=DPR), "  ||"
    write(output_unit,'(a,x,E23.15,a)')"   system_clock_avg_per_mpi_task(s): ", sys_timer%total_time / real(num_mpi_procs, kind=DPR), "  ||"
    write(output_unit,'(a,x,E23.15,a)')"       cpu_time_avg_per_mpi_task(s): ", cpu_timer%total_time / real(num_mpi_procs, kind=DPR), "  ||"
    write(output_unit,'(a)')"================================================================="
    write(output_unit,'(a,x,E23.15,a)')"      omp_wtime_avg_per_omp_task(s): ", omp_timer%total_time / real(num_mpi_procs, kind=DPR) / real(num_omp_threads, kind=DPR), "  ||"
    write(output_unit,'(a,x,E23.15,a)')"      mpi_wtime_avg_per_omp_task(s): ", mpi_timer%total_time / real(num_mpi_procs, kind=DPR) / real(num_omp_threads, kind=DPR), "  ||"
    write(output_unit,'(a,x,E23.15,a)')"   system_clock_avg_per_omp_task(s): ", sys_timer%total_time / real(num_mpi_procs, kind=DPR) / real(num_omp_threads, kind=DPR), "  ||"
    write(output_unit,'(a,x,E23.15,a)')"       cpu_time_avg_per_omp_task(s): ", cpu_timer%total_time / real(num_mpi_procs, kind=DPR) / real(num_omp_threads, kind=DPR), "  ||"
    write(output_unit,'(a)')"================================================================="
    write(output_unit,'(a)')""
  else
    write(output_unit,'(a,x,E23.15)')"                       exact_answer: ", exact_answer
    write(output_unit,'(a,x,E23.15)')"                 approximate_answer: ", approx_answer
    write(output_unit,'(a,x,E23.15)')"                absolute_difference: ", abs_diff
    write(output_unit,'(a,x,F19.15)')"                 percent_difference: ", rel_diff
    write(output_unit,'(a,x,E23.15)')"                 omp_wtime_total(s): ", omp_timer%total_time
    write(output_unit,'(a,x,E23.15)')"                 mpi_wtime_total(s): ", mpi_timer%total_time
    write(output_unit,'(a,x,E23.15)')"              system_clock_total(s): ", sys_timer%total_time
    write(output_unit,'(a,x,E23.15)')"                  cpu_time_total(s): ", cpu_timer%total_time
    write(output_unit,'(a,x,E23.15)')"      omp_wtime_avg_per_mpi_task(s): ", omp_timer%total_time / real(num_mpi_procs, kind=DPR)
    write(output_unit,'(a,x,E23.15)')"      mpi_wtime_avg_per_mpi_task(s): ", mpi_timer%total_time / real(num_mpi_procs, kind=DPR)
    write(output_unit,'(a,x,E23.15)')"   system_clock_avg_per_mpi_task(s): ", sys_timer%total_time / real(num_mpi_procs, kind=DPR)
    write(output_unit,'(a,x,E23.15)')"       cpu_time_avg_per_mpi_task(s): ", cpu_timer%total_time / real(num_mpi_procs, kind=DPR)
  end if
  flush(output_unit)

  close(output_unit)


end subroutine compare_write




end program calc_pi
