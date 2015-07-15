################################################################
################################################################
####
#### This make file is part of the source of 
#### `Parallel Programing in Science and Engineering'
#### by Victor Eijkhout, copyright 2013/4
####
#### This is a makefile for the programming exercises
####
################################################################
################################################################

info ::
	@echo "make"

APPS =

ifdef TACC_TAU_DIR
  CX = tau_cc.sh
  CXX = tau_cxx.sh
else
  CC  = mpicc
  CXX = mpicxx
endif

OPTLEVEL = 2
FFLAGS = -g -O${OPTLEVEL}
CFLAGS = ${FFLAGS} -std=c99 
CXXFLAGS = ${FFLAGS}
% : %.c
	${CC} ${CFLAGS} $*.c -o $@
%.o : %.cxx
	${CXX} ${CXXFLAGS} -c $*.cxx

# Example: mandelbrot routines
MANDEL_APPS = mandel_serial mandel_bulk mandel_async mandel_collective
APPS += ${MANDEL_APPS}
mandel_dependencies = mandel_tools.o tools.o Image.o Color.o
${MANDEL_APPS} : ${mandel_dependencies}
${patsubst %,%.o,${MANDEL_APPS}} mandel_tools.o : mandel.h tools.h Image.h Color.h
Color.o : Color.h
Image.o : Image.h
.SECONDEXPANSION:
${MANDEL_APPS} : $$@.o ${mandel_dependencies}
	${CXX} ${CFLAGS} $^ -o $@

# Example: recursive transposition
APPS += transpose
transpose : $$@.o
	${CXX} ${CFLAGS} $^ -o $@

# rules for submitting to the queue and doing tau analysis
info ::
	@echo
	@echo "make submit EXECUTABLE=<any prog> OPTIONS=<whatever>"
EXECUTABLE = mandel_serial
OPTIONS = steps 100 iters 1000
submit :
	@export TAU_EXT=`if [ ! -z "${EXECUTABLE}" ] ; then echo "_" ; fi`${EXECUTABLE} ; \
	export TAU_DUMP_DIR=`pwd`/tautrace$$TAU_EXT ; \
	  echo "tau output to: <$$TAU_DUMP_DIR>" ; \
	  rm -rf $${TAU_DUMP_DIR}; mkdir -p $${TAU_DUMP_DIR} ; \
	  TAU_TRACE=1 TAU_PROFILE=1 \
	  TRACEDIR=$${TAU_DUMP_DIR} \
	  PROFILEDIR=$${TAU_DUMP_DIR} \
	    EXECUTABLE=${EXECUTABLE} OPTIONS="${OPTIONS}" \
	      qsub jobscript
info ::
	@echo "make idevrun EXECUTABLE=<any prog> OPTIONS=<whatever>"
idevrun :
	@if [ -z "${EXECUTABLE}" ] ; then \
	   echo "Usage: make ibrun executable option"; exit 1 ; fi
	@export TAU_EXT="_${EXECUTABLE}" ; \
	export TAU_DUMP_DIR=`pwd`/tautrace$$TAU_EXT ; \
	  rm -rf $${TAU_DUMP_DIR}; mkdir -p $${TAU_DUMP_DIR} ; \
	  TAU_TRACE=1 TAU_PROFILE=1 \
	  TRACEDIR=$${TAU_DUMP_DIR} \
	  PROFILEDIR=$${TAU_DUMP_DIR} \
	    ibrun ${EXECUTABLE} ${OPTIONS}
info ::
	@echo "make tau EXECUTABLE=... (this does the post-processing)"
tau :
	@export HOME=`pwd` ; \
	export TAU_EXT=`if [ ! -z "${EXECUTABLE}" ] ; then echo "_" ; fi`${EXECUTABLE} ; \
	export TAU_DUMP_DIR=`pwd`/tautrace$$TAU_EXT ; \
	  cd $$TAU_DUMP_DIR ; \
	  echo ".. analyzing files in <$$TAU_DUMP_DIR>" ; \
	  rm -f tau.trc tau.edf ; \
	  tau_treemerge.pl ; \
	  tau2slog2 tau.trc tau.edf -o $$HOME/taulog$$TAU_EXT.slog2

info ::
	@echo "make regression"
regression: total_clean
	for a in ${MANDEL_APPS} ; do \
	  echo "Compilation $$a" ; \
	  make $$a >/dev/null 2>&1 ; \
	  if [ ! -e $$a ] ; then echo ".. could not make $$a" ; fi ; \
	  if [ ! -z "${SLURM_NNODES}" ] ; then \
	    echo ".. run $$a" ; \
	    rm -f mandelpicture* ; \
	    ibrun $$a >$$a.runlog 2>&1 ; \
	    if [ ! -e "mandelpicture.ppm" ] ; then \
	      echo ".. failed to run $$a" ; \
	    fi ; \
	  fi ; \
	done

info ::
	@echo "make clean       : cleanup but leave slog2"
	@echo "make total_clean : cleanup including slog2"
clean ::
	@/bin/rm -rf *.o *~ *.gch a.out *.dSYM MULTI__* events.* *.runlog \
	    core.[0-9]* idev[0-9]*.o[0-9]* ddt.o[0-9]* jobtest.o* tautrace_* \
	    ${APPS}
total_clean : clean 
	@/bin/rm -rf  *.slog2 *.ppm
