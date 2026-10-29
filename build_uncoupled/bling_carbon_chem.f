
















C $Header: /u/gcmpack/MITgcm_contrib/llc_hires/llc_270/code/CPP_OPTIONS.h,v 1.4 2015/09/29 18:07:50 zhc Exp $
C $Name:  $


CBOP
C !ROUTINE: CPP_OPTIONS.h
C !INTERFACE:
C #include "CPP_OPTIONS.h"

C !DESCRIPTION:
C *==================================================================*
C | main CPP options file for the model:
C | Control which optional features to compile in model/src code.
C *==================================================================*
CEOP

C CPP flags controlling particular source code features

C o Shortwave heating as extra term in external_forcing.F
C Note: this should be a run-time option

C o Include/exclude phi_hyd calculation code

C o Include/exclude call to S/R CONVECT

C o Include/exclude call to S/R CALC_DIFFUSIVITY

C o Allow full 3D specification of vertical diffusivity

C o Allow latitudinally varying BryanLewis79 vertical diffusivity

C o Include/exclude Implicit vertical advection code

C o Include/exclude AdamsBashforth-3rd-Order code

C o Include/exclude nonHydrostatic code

C o Allow to account for heating due to friction (and momentum dissipation)

C o Allow mass source or sink of Fluid in the interior
C   (3-D generalisation of oceanic real-fresh water flux)

C o Include pressure loading code

C o exclude/allow external forcing-fields load
C   this allows to read & do simple linear time interpolation of oceanic
C   forcing fields, if no specific pkg (e.g., EXF) is used to compute them.

C o Include/exclude balancing surface forcing fluxes code

C o Include/exclude balancing surface forcing relaxation code

C o Include/exclude GM-like eddy stress in momentum code

C o Use "Exact Convervation" of fluid in Free-Surface formulation
C   so that d/dt(eta) is exactly equal to - Div.Transport

C o Allow the use of Non-Linear Free-Surface formulation
C   this implies that surface thickness (hFactors) vary with time

C o Include/exclude code for single reduction Conjugate-Gradient solver

C o Choices for implicit solver routines solve_*diagonal.F
C   The following has low memory footprint, but not suitable for AD
C   The following one suitable for AD but does not vectorize

C o ALLOW isotropic scaling of harmonic and bi-harmonic terms when
C   using an locally isotropic spherical grid with (dlambda) x (dphi*cos(phi))
C *only for use on a lat-lon grid*
C   Setting this flag here affects both momentum and tracer equation unless
C   it is set/unset again in other header fields (e.g., GAD_OPTIONS.h).
C   The definition of the flag is commented to avoid interference with
C   such other header files.
C   The preferred method is specifying a value for viscAhGrid or viscA4Grid
C   in data which is then automatically scaled by the grid size;
C   the old method of specifying viscAh/viscA4 and this flag is provided
C   for completeness only (and for use with the adjoint).
C#define ISOTROPIC_COS_SCALING

C o This flag selects the form of COSINE(lat) scaling of bi-harmonic term.
C *only for use on a lat-lon grid*
C   Has no effect if ISOTROPIC_COS_SCALING is undefined.
C   Has no effect on vector invariant momentum equations.
C   Setting this flag here affects both momentum and tracer equation unless
C   it is set/unset again in other header fields (e.g., GAD_OPTIONS.h).
C   The definition of the flag is commented to avoid interference with
C   such other header files.
C#define COSINEMETH_III

C o Use "OLD" UV discretisation near boundaries (*not* recommended)
C   Note - only works with  #undef NO_SLIP_LATERAL  in calc_mom_rhs.F
C          because the old code did not have no-slip BCs

C o Use LONG.bin, LATG.bin, etc., initialization for ini_curviliear_grid.F
C   Default is to use "new" grid files (OLD_GRID_IO undef) but OLD_GRID_IO
C   is still useful with, e.g., single-domain curvilinear configurations.

C o Execution environment support options
C $Header: /u/gcmpack/MITgcm/eesupp/inc/CPP_EEOPTIONS.h,v 1.42 2017/08/09 15:18:49 mlosch Exp $
C $Name:  $

CBOP
C     !ROUTINE: CPP_EEOPTIONS.h
C     !INTERFACE:
C     include "CPP_EEOPTIONS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP\_EEOPTIONS.h                                         |
C     *==========================================================*
C     | C preprocessor "execution environment" supporting        |
C     | flags. Use this file to set flags controlling the        |
C     | execution environment in which a model runs - as opposed |
C     | to the dynamical problem the model solves.               |
C     | Note: Many options are implemented with both compile time|
C     |       and run-time switches. This allows options to be   |
C     |       removed altogether, made optional at run-time or   |
C     |       to be permanently enabled. This convention helps   |
C     |       with the data-dependence analysis performed by the |
C     |       adjoint model compiler. This data dependency       |
C     |       analysis can be upset by runtime switches that it  |
C     |       is unable to recoginise as being fixed for the     |
C     |       duration of an integration.                        |
C     |       A reasonable way to use these flags is to          |
C     |       set all options as selectable at runtime but then  |
C     |       once an experimental configuration has been        |
C     |       identified, rebuild the code with the appropriate  |
C     |       options set at compile time.                       |
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C=== Macro related options ===
C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working set size.
C     However, on vector CRAY systems this degrades performance.
C     Enable to switch REAL4_IS_SLOW from genmake2 (with LET_RS_BE_REAL4):

C--   Control use of "double" precision constants.
C     Use D0 where it means REAL*8 but not where it means REAL*16

C--   Enable some old macro conventions for backward compatibility

C=== IO related options ===
C--   Flag used to indicate whether Fortran formatted write
C     and read are threadsafe. On SGI the routines can be thread
C     safe, on Sun it is not possible - if you are unsure then
C     undef this option.

C--   Flag used to indicate whether Binary write to Local file (i.e.,
C     a different file for each tile) and read are thread-safe.

C--   Flag to turn off the writing of error message to ioUnit zero

C--   Alternative formulation of BYTESWAP, faster than
C     compiler flag -byteswapio on the Altix.

C--   Flag to turn on old default of opening scratch files with the
C     STATUS='SCRATCH' option. This method, while perfectly FORTRAN-standard,
C     caused filename conflicts on some multi-node/multi-processor platforms
C     in the past and has been replace by something (hopefully) more robust.

C--   Flag defined for eeboot_minimal.F, eeset_parms.F and open_copy_data_file.F
C     to write STDOUT, STDERR and scratch files from process 0 only.
C WARNING: to use only when absolutely confident that the setup is working
C     since any message (error/warning/print) from any proc <> 0 will be lost.

C=== MPI, EXCH and GLOBAL_SUM related options ===
C--   Flag turns off MPI_SEND ready_to_receive polling in the
C     gather_* subroutines to speed up integrations.

C--   Control MPI based parallel processing
CXXX We no longer select the use of MPI via this file (CPP_EEOPTIONS.h)
CXXX To use MPI, use an appropriate genmake2 options file or use
CXXX genmake2 -mpi .
CXXX #undef  ALLOW_USE_MPI

C--   Control use of communication that might overlap computation.
C     Under MPI selects/deselects "non-blocking" sends and receives.
C--   Control use of communication that is atomic to computation.
C     Under MPI selects/deselects "blocking" sends and receives.

C--   Control XY periodicity in processor to grid mappings
C     Note: Model code does not need to know whether a domain is
C           periodic because it has overlap regions for every box.
C           Model assume that these values have been
C           filled in some way.

C--   disconnect tiles (no exchange between tiles, just fill-in edges
C     assuming locally periodic subdomain)

C--   Always cumulate tile local-sum in the same order by applying MPI allreduce
C     to array of tiles ; can get slower with large number of tiles (big set-up)

C--   Alternative way of doing global sum without MPI allreduce call
C     but instead, explicit MPI send & recv calls. Expected to be slower.

C--   Alternative way of doing global sum on a single CPU
C     to eliminate tiling-dependent roundoff errors. Note: This is slow.

C=== Other options (to add/remove pieces of code) ===
C--   Flag to turn on checking for errors from all threads and procs
C     (calling S/R STOP_IF_ERROR) before stopping.

C--   Control use of communication with other component:
C     allow to import and export from/to Coupler interface.


C $Header: /u/gcmpack/MITgcm/eesupp/inc/CPP_EEMACROS.h,v 1.25 2017/08/10 14:06:59 mlosch Exp $
C $Name:  $

CBOP
C     !ROUTINE: CPP_EEMACROS.h
C     !INTERFACE:
C     include "CPP_EEMACROS.h "
C     !DESCRIPTION:
C     *==========================================================*
C     | CPP_EEMACROS.h
C     *==========================================================*
C     | C preprocessor "execution environment" supporting
C     | macros. Use this file to define macros for  simplifying
C     | execution environment in which a model runs - as opposed
C     | to the dynamical problem the model solves.
C     *==========================================================*
CEOP


C     In general the following convention applies:
C     ALLOW  - indicates an feature will be included but it may
C     CAN      have a run-time flag to allow it to be switched
C              on and off.
C              If ALLOW or CAN directives are "undef'd" this generally
C              means that the feature will not be available i.e. it
C              will not be included in the compiled code and so no
C              run-time option to use the feature will be available.
C
C     ALWAYS - indicates the choice will be fixed at compile time
C              so no run-time option will be present

C     Flag used to indicate which flavour of multi-threading
C     compiler directives to use. Only set one of these.
C     USE_SOLARIS_THREADING  - Takes directives for SUN Workshop
C                              compiler.
C     USE_KAP_THREADING      - Takes directives for Kuck and
C                              Associates multi-threading compiler
C                              ( used on Digital platforms ).
C     USE_IRIX_THREADING     - Takes directives for SGI MIPS
C                              Pro Fortran compiler.
C     USE_EXEMPLAR_THREADING - Takes directives for HP SPP series
C                              compiler.
C     USE_C90_THREADING      - Takes directives for CRAY/SGI C90
C                              system F90 compiler.






C--   Define the mapping for the _BARRIER macro
C     On some systems low-level hardware support can be accessed through
C     compiler directives here.

C--   Define the mapping for the BEGIN_CRIT() and  END_CRIT() macros.
C     On some systems we simply execute this section only using the
C     master thread i.e. its not really a critical section. We can
C     do this because we do not use critical sections in any critical
C     sections of our code!

C--   Define the mapping for the BEGIN_MASTER_SECTION() and
C     END_MASTER_SECTION() macros. These are generally implemented by
C     simply choosing a particular thread to be "the master" and have
C     it alone execute the BEGIN_MASTER..., END_MASTER.. sections.

CcnhDebugStarts
C      Alternate form to the above macros that increments (decrements) a counter each
C      time a MASTER section is entered (exited). This counter can then be checked in barrier
C      to try and detect calls to BARRIER within single threaded sections.
C      Using these macros requires two changes to Makefile - these changes are written
C      below.
C      1 - add a filter to the CPP command to kill off commented _MASTER lines
C      2 - add a filter to the CPP output the converts the string N EWLINE to an actual newline.
C      The N EWLINE needs to be changes to have no space when this macro and Makefile changes
C      are used. Its in here with a space to stop it getting parsed by the CPP stage in these
C      comments.
C      #define IF ( a .EQ. 1 ) THEN  IF ( a .EQ. 1 ) THEN  N EWLINE      CALL BARRIER_MS(a)
C      #define ENDIF    CALL BARRIER_MU(a) N EWLINE        ENDIF
C      'CPP = cat $< | $(TOOLSDIR)/set64bitConst.sh |  grep -v '^[cC].*_MASTER' | cpp  -traditional -P'
C      .F.f:
C      $(CPP) $(DEFINES) $(INCLUDES) |  sed 's/N EWLINE/\n/' > $@
CcnhDebugEnds

C--   Control storage of floating point operands
C     On many systems it improves performance only to use
C     8-byte precision for time stepped variables.
C     Constant in time terms ( geometric factors etc.. )
C     can use 4-byte precision, reducing memory utilisation and
C     boosting performance because of a smaller working
C     set size. However, on vector CRAY systems this degrades
C     performance.
C- Note: global_sum/max macros were used to switch to  JAM routines (obsolete);
C  in addition, since only the R4 & R8 S/R are coded, GLOBAL RS & RL macros
C  enable to call the corresponding R4 or R8 S/R.



C- Note: a) exch macros were used to switch to  JAM routines (obsolete)
C        b) exch R4 & R8 macros are not practically used ; if needed,
C           will directly call the corrresponding S/R.

C--   Control use of JAM routines for Artic network (no longer supported)
C     These invoke optimized versions of "exchange" and "sum" that
C     utilize the programmable aspect of Artic cards.
CXXX No longer supported ; started to remove JAM routines.
CXXX #ifdef LETS_MAKE_JAM
CXXX #define CALL GLOBAL_SUM_R8 ( a, b) CALL GLOBAL_SUM_R8_JAM ( a, b)
CXXX #define CALL GLOBAL_SUM_R8 ( a, b ) CALL GLOBAL_SUM_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RS ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XY_RL ( a, b ) CALL EXCH_XY_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RS ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #define CALL EXCH_XYZ_RL ( a, b ) CALL EXCH_XYZ_R8_JAM ( a, b )
CXXX #endif

C--   Control use of "double" precision constants.
C     Use d0 where it means REAL*8 but not where it means REAL*16

C--   Substitue for 1.D variables
C     Sun compilers do not use 8-byte precision for literals
C     unless .Dnn is specified. CRAY vector machines use 16-byte
C     precision when they see .Dnn which runs very slowly!

C--   Set the format for writing processor IDs, e.g. in S/R eeset_parms
C     and S/R open_copy_data_file. The default of I9.9 should work for
C     a long time (until we will use 10e10 processors and more)



C o Include/exclude single header file containing multiple packages options
C   (AUTODIFF, COST, CTRL, ECCO, EXF ...) instead of the standard way where
C   each of the above pkg get its own options from its specific option file.
C   Although this method, inherited from ECCO setup, has been traditionally
C   used for all adjoint built, work is in progress to allow to use the
C   standard method also for adjoint built.
c#ifdef 
c# include "ECCO_CPPOPTIONS.h"
c#endif


C     Package-specific Options & Macros go here

C BLING+Nitrogen is the default model. It is a version
C of BLING with 8 tracers and 3 phyto classes.
C For the original 6-tracer model of Galbraith et al (2010),
C define USE_BLING_V1 - but note the different order of tracers in data.ptracers

C Options for BLING+Nitrogen code:
C SiBLING: add a 9th tracer for silica
C apply remineralization from diel vertical migration
C active tracer for total phytoplankton biomass
C sub grid scale sediments - NOT IMPLEMENTED YET
c #undef USE_SGS_SED

C Prevents negative values in nutrient fields

C Use Liebig function instead of geometric mean of the
C nutrient limitations to calculate maximum phyto growth rate

C Allow different phytoplankton groups to have different growth rates and
C nutrient/light limitations. Parameters implemented have yet to be tuned

C Assume that phytoplankton in the mixed layer experience
C the average light over the mixed layer (as in original BLING model)

C Assume that phytoplankton are homogenized in the mixed layer

C Calculate MLD using a threshold criterion. If undefined,
C MLD is calculated using the second derivative of rho(z)

C Determine PAR from shortwave radiation Qsw;
C otherwise determined from date and latitude
C (Do not define if not using pkg/exf)

C Light absorption scheme from Manizza et al. (2005),
C with self shading from phytoplankton

c Allow self-shading to impact ocean heating

C Note: atm pressure from PKG/EXF is always used for air-sea flux calculation
C if available; otherwise read from file or set to constant value (1 atm)

C Note: winds from PKG/EXF are always used if available;
C otherwise read from file or set to constant value (5 m/s)

C Note: ice fraction from PKG/SEAICE or THSICE is always used if available;
C otherwise read from file or set to constant value (0)

C Note: atm pCO2 from EXF file is always used if available;
C otherwise set to constant value in data.bling

C Simplify some parts of the code that are problematic when using the adjoint

C For adjoint safe, do not call bling_dvm

C ABIOTIC OPTIONS
C Compile "Solvesaphe" package (Munhoven 2013) for pH/pCO2
C  can still select Follows et al (2006) solver in data.bling,
C  but will use solvesaphe dissociation coefficient options

C In S/R CARBON_CHEM convert ak1 and ak2 to the total pH scale
C  consistent with other coefficients (currently on the seawater scale).
C NOTE: Has NO effect when CARBONCHEM_SOLVESAPHE is defined (different
C  coeffs are used).

C When calculating the fraction of sinking organic matter, use model biomass diagnostics.


C--  File bling_carbon_chem.F:
C--   Contents
C--   o CALC_PCO2
C--   o CALC_PCO2_APPROX
C--   o CARBON_COEFFS
C--   o CARBON_COEFFS_PRESSURE_DEP

CBOP
       subroutine CALC_PCO2(
     I                       donewt,inewtonmax,ibrackmax,
     I                       t,s,diclocal,pt,sit,ta,
     I                       k1local,k2local,
     I                       k1plocal,k2plocal,k3plocal,
     I                       kslocal,kblocal,kwlocal,
     I                       ksilocal,kflocal,
     I                       k0local, fugflocal,
     I                       fflocal,btlocal,stlocal,ftlocal,
     U                       pHlocal,pCO2surfloc,
     I                       i,j,k,bi,bj,myIter,myThid )

C     =================================================================
C     | subroutine bling_carbon_chem
C     | o Calculates ocean inorganic carbon chemistry
C     |   Adapted from pkg/dic/carbon_chem.F
C     |   from OCMIP2 code
C     =================================================================

      IMPLICIT NONE

C     === Global variables ===
C $Header: /u/gcmpack/MITgcm_contrib/llc_hires/llc_270/code/SIZE.h,v 1.3 2015/09/29 18:07:50 zhc Exp $
C $Name:  $

C
CBOP
C    !ROUTINE: SIZE.h
C    !INTERFACE:
C    include SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SIZE.h Declare size of underlying computational grid.     
C     *==========================================================*
C     | The design here support a three-dimensional model grid    
C     | with indices I,J and K. The three-dimensional domain      
C     | is comprised of nPx*nSx blocks of size sNx along one axis 
C     | nPy*nSy blocks of size sNy along another axis and one     
C     | block of size Nz along the final axis.                    
C     | Blocks have overlap regions of size OLx and OLy along the 
C     | dimensions that are subdivided.                           
C     *==========================================================*
C     \ev
CEOP
C     Voodoo numbers controlling data layout.
C     sNx :: No. X points in sub-grid.
C     sNy :: No. Y points in sub-grid.
C     OLx :: Overlap extent in X.
C     OLy :: Overlat extent in Y.
C     nSx :: No. sub-grids in X.
C     nSy :: No. sub-grids in Y.
C     nPx :: No. of processes to use in X.
C     nPy :: No. of processes to use in Y.
C     Nx  :: No. points in X for the total domain.
C     Ny  :: No. points in Y for the total domain.
C     Nr  :: No. points in Z for full process domain.
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER (
     &           sNx = 720,
     &           sNy = 280,
     &           OLx =   8,
     &           OLy =   8,
     &           nSx =   1,
     &           nSy =   1,
     &           nPx =   1,
     &           nPy =   1,
     &           Nx  = sNx*nSx*nPx,
     &           Ny  = sNy*nSy*nPy,
     &           Nr  =  50 )

C     MAX_OLX :: Set to the maximum overlap region size of any array
C     MAX_OLY    that will be exchanged. Controls the sizing of exch
C                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx,
     &            MAX_OLY = OLy )

      INTEGER     nobcs
      PARAMETER ( nobcs = 4 )

C $Header: /u/gcmpack/MITgcm/eesupp/inc/EEPARAMS.h,v 1.36 2014/02/13 04:10:25 jmc Exp $
C $Name:  $
CBOP
C     !ROUTINE: EEPARAMS.h
C     !INTERFACE:
C     include "EEPARAMS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | EEPARAMS.h                                               |
C     *==========================================================*
C     | Parameters for "execution environemnt". These are used   |
C     | by both the particular numerical model and the execution |
C     | environment support routines.                            |
C     *==========================================================*
CEOP

C     ========  EESIZE.h  ========================================

C     MAX_LEN_MBUF  :: Default message buffer max. size
C     MAX_LEN_FNAM  :: Default file name max. size
C     MAX_LEN_PREC  :: Default rec len for reading "parameter" files

      INTEGER MAX_LEN_MBUF
      PARAMETER ( MAX_LEN_MBUF = 512 )
      INTEGER MAX_LEN_FNAM
      PARAMETER ( MAX_LEN_FNAM = 512 )
      INTEGER MAX_LEN_PREC
      PARAMETER ( MAX_LEN_PREC = 200 )

C     MAX_NO_THREADS  :: Maximum number of threads allowed.
CC    MAX_NO_PROCS    :: Maximum number of processes allowed.
CC    MAX_NO_BARRIERS :: Maximum number of distinct thread "barriers"
      INTEGER MAX_NO_THREADS
      PARAMETER ( MAX_NO_THREADS =  4 )
c     INTEGER MAX_NO_PROCS
c     PARAMETER ( MAX_NO_PROCS   =  70000 )
c     INTEGER MAX_NO_BARRIERS
c     PARAMETER ( MAX_NO_BARRIERS = 1 )

C     Particularly weird and obscure voodoo numbers
C     lShare :: This wants to be the length in
C               [148]-byte words of the size of
C               the address "window" that is snooped
C               on an SMP bus. By separating elements in
C               the global sum buffer we can avoid generating
C               extraneous invalidate traffic between
C               processors. The length of this window is usually
C               a cache line i.e. small O(64 bytes).
C               The buffer arrays are usually short arrays
C               and are declared REAL ARRA(lShare[148],LBUFF).
C               Setting lShare[148] to 1 is like making these arrays
C               one dimensional.
      INTEGER cacheLineSize
      INTEGER lShare1
      INTEGER lShare4
      INTEGER lShare8
      PARAMETER ( cacheLineSize = 256 )
      PARAMETER ( lShare1 =  cacheLineSize )
      PARAMETER ( lShare4 =  cacheLineSize/4 )
      PARAMETER ( lShare8 =  cacheLineSize/8 )

CC    MAX_VGS  :: Maximum buffer size for Global Vector Sum
c     INTEGER MAX_VGS
c     PARAMETER ( MAX_VGS = 8192 )

C     ========  EESIZE.h  ========================================

C     Symbolic values
C     precXXXX :: precision used for I/O
      INTEGER precFloat32
      PARAMETER ( precFloat32 = 32 )
      INTEGER precFloat64
      PARAMETER ( precFloat64 = 64 )

C     Real-type constant for some frequently used simple number (0,1,2,1/2):
      Real*8     zeroRS, oneRS, twoRS, halfRS
      PARAMETER ( zeroRS = 0.0D0 , oneRS  = 1.0D0 )
      PARAMETER ( twoRS  = 2.0D0 , halfRS = 0.5D0 )
      Real*8     zeroRL, oneRL, twoRL, halfRL
      PARAMETER ( zeroRL = 0.0D0 , oneRL  = 1.0D0 )
      PARAMETER ( twoRL  = 2.0D0 , halfRL = 0.5D0 )

C     UNSET_xxx :: Used to indicate variables that have not been given a value
      Real*8  UNSET_FLOAT8
      PARAMETER ( UNSET_FLOAT8 = 1.234567D5 )
      Real*4  UNSET_FLOAT4
      PARAMETER ( UNSET_FLOAT4 = 1.234567E5 )
      Real*8     UNSET_RL
      PARAMETER ( UNSET_RL     = 1.234567D5 )
      Real*8     UNSET_RS
      PARAMETER ( UNSET_RS     = 1.234567D5 )
      INTEGER UNSET_I
      PARAMETER ( UNSET_I      = 123456789  )

C     debLevX  :: used to decide when to print debug messages
      INTEGER debLevZero
      INTEGER debLevA, debLevB,  debLevC, debLevD, debLevE
      PARAMETER ( debLevZero=0 )
      PARAMETER ( debLevA=1 )
      PARAMETER ( debLevB=2 )
      PARAMETER ( debLevC=3 )
      PARAMETER ( debLevD=4 )
      PARAMETER ( debLevE=5 )

C     SQUEEZE_RIGHT      :: Flag indicating right blank space removal
C                           from text field.
C     SQUEEZE_LEFT       :: Flag indicating left blank space removal
C                           from text field.
C     SQUEEZE_BOTH       :: Flag indicating left and right blank
C                           space removal from text field.
C     PRINT_MAP_XY       :: Flag indicating to plot map as XY slices
C     PRINT_MAP_XZ       :: Flag indicating to plot map as XZ slices
C     PRINT_MAP_YZ       :: Flag indicating to plot map as YZ slices
C     commentCharacter   :: Variable used in column 1 of parameter
C                           files to indicate comments.
C     INDEX_I            :: Variable used to select an index label
C     INDEX_J               for formatted input parameters.
C     INDEX_K
C     INDEX_NONE
      CHARACTER*(*) SQUEEZE_RIGHT
      PARAMETER ( SQUEEZE_RIGHT = 'R' )
      CHARACTER*(*) SQUEEZE_LEFT
      PARAMETER ( SQUEEZE_LEFT = 'L' )
      CHARACTER*(*) SQUEEZE_BOTH
      PARAMETER ( SQUEEZE_BOTH = 'B' )
      CHARACTER*(*) PRINT_MAP_XY
      PARAMETER ( PRINT_MAP_XY = 'XY' )
      CHARACTER*(*) PRINT_MAP_XZ
      PARAMETER ( PRINT_MAP_XZ = 'XZ' )
      CHARACTER*(*) PRINT_MAP_YZ
      PARAMETER ( PRINT_MAP_YZ = 'YZ' )
      CHARACTER*(*) commentCharacter
      PARAMETER ( commentCharacter = '#' )
      INTEGER INDEX_I
      INTEGER INDEX_J
      INTEGER INDEX_K
      INTEGER INDEX_NONE
      PARAMETER ( INDEX_I    = 1,
     &            INDEX_J    = 2,
     &            INDEX_K    = 3,
     &            INDEX_NONE = 4 )

C     EXCH_IGNORE_CORNERS :: Flag to select ignoring or
C     EXCH_UPDATE_CORNERS    updating of corners during an edge exchange.
      INTEGER EXCH_IGNORE_CORNERS
      INTEGER EXCH_UPDATE_CORNERS
      PARAMETER ( EXCH_IGNORE_CORNERS = 0,
     &            EXCH_UPDATE_CORNERS = 1 )

C     FORWARD_SIMULATION
C     REVERSE_SIMULATION
C     TANGENT_SIMULATION
      INTEGER FORWARD_SIMULATION
      INTEGER REVERSE_SIMULATION
      INTEGER TANGENT_SIMULATION
      PARAMETER ( FORWARD_SIMULATION = 0,
     &            REVERSE_SIMULATION = 1,
     &            TANGENT_SIMULATION = 2 )

C--   COMMON /EEPARAMS_L/ Execution environment public logical variables.
C     eeBootError    :: Flags indicating error during multi-processing
C     eeEndError     :: initialisation and termination.
C     fatalError     :: Flag used to indicate that the model is ended with an error
C     debugMode      :: controls printing of debug msg (sequence of S/R calls).
C     useSingleCpuIO :: When useSingleCpuIO is set, MDS_WRITE_FIELD outputs from
C                       master MPI process only. -- NOTE: read from main parameter
C                       file "data" and not set until call to INI_PARMS.
C     useSingleCpuInput :: When useSingleCpuInput is set, EXF_INTERP_READ
C                       reads forcing files from master MPI process only.
C                       -- NOTE: read from main parameter file "data"
C                          and defaults to useSingleCpuInput = useSingleCpuIO
C     printMapIncludesZeros  :: Flag that controls whether character constant
C                               map code ignores exact zero values.
C     useCubedSphereExchange :: use Cubed-Sphere topology domain.
C     useCoupler     :: use Coupler for a multi-components set-up.
C     useNEST_PARENT :: use Parent Nesting interface (pkg/nest_parent)
C     useNEST_CHILD  :: use Child  Nesting interface (pkg/nest_child)
C     useOASIS       :: use OASIS-coupler for a multi-components set-up.
      COMMON /EEPARAMS_L/
c    &  eeBootError, fatalError, eeEndError,
     &  eeBootError, eeEndError, fatalError, debugMode,
     &  useSingleCpuIO, useSingleCpuInput, printMapIncludesZeros,
     &  useCubedSphereExchange, useCoupler,
     &  useNEST_PARENT, useNEST_CHILD, useOASIS,
     &  useSETRLSTK, useSIGREG
      LOGICAL eeBootError
      LOGICAL eeEndError
      LOGICAL fatalError
      LOGICAL debugMode
      LOGICAL useSingleCpuIO
      LOGICAL useSingleCpuInput
      LOGICAL printMapIncludesZeros
      LOGICAL useCubedSphereExchange
      LOGICAL useCoupler
      LOGICAL useNEST_PARENT
      LOGICAL useNEST_CHILD
      LOGICAL useOASIS
      LOGICAL useSETRLSTK
      LOGICAL useSIGREG

C--   COMMON /EPARAMS_I/ Execution environment public integer variables.
C     errorMessageUnit    :: Fortran IO unit for error messages
C     standardMessageUnit :: Fortran IO unit for informational messages
C     maxLengthPrt1D :: maximum length for printing (to Std-Msg-Unit) 1-D array
C     scrUnit1      :: Scratch file 1 unit number
C     scrUnit2      :: Scratch file 2 unit number
C     eeDataUnit    :: Unit # for reading "execution environment" parameter file
C     modelDataUnit :: Unit number for reading "model" parameter file.
C     numberOfProcs :: Number of processes computing in parallel
C     pidIO         :: Id of process to use for I/O.
C     myBxLo, myBxHi :: Extents of domain in blocks in X and Y
C     myByLo, myByHi :: that each threads is responsble for.
C     myProcId      :: My own "process" id.
C     myPx          :: My X coord on the proc. grid.
C     myPy          :: My Y coord on the proc. grid.
C     myXGlobalLo   :: My bottom-left (south-west) x-index global domain.
C                      The x-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     myYGlobalLo   :: My bottom-left (south-west) y-index in global domain.
C                      The y-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     nThreads      :: No. of threads
C     nTx, nTy      :: No. of threads in X and in Y
C                      This assumes a simple cartesian gridding of the threads
C                      which is not required elsewhere but that makes it easier
C     ioErrorCount  :: IO Error Counter. Set to zero initially and increased
C                      by one every time an IO error occurs.
      COMMON /EEPARAMS_I/
     &  errorMessageUnit, standardMessageUnit, maxLengthPrt1D,
     &  scrUnit1, scrUnit2, eeDataUnit, modelDataUnit,
     &  numberOfProcs, pidIO, myProcId,
     &  myPx, myPy, myXGlobalLo, myYGlobalLo, nThreads,
     &  myBxLo, myBxHi, myByLo, myByHi,
     &  nTx, nTy, ioErrorCount
      INTEGER errorMessageUnit
      INTEGER standardMessageUnit
      INTEGER maxLengthPrt1D
      INTEGER scrUnit1
      INTEGER scrUnit2
      INTEGER eeDataUnit
      INTEGER modelDataUnit
      INTEGER ioErrorCount(MAX_NO_THREADS)
      INTEGER myBxLo(MAX_NO_THREADS)
      INTEGER myBxHi(MAX_NO_THREADS)
      INTEGER myByLo(MAX_NO_THREADS)
      INTEGER myByHi(MAX_NO_THREADS)
      INTEGER myProcId
      INTEGER myPx
      INTEGER myPy
      INTEGER myXGlobalLo
      INTEGER myYGlobalLo
      INTEGER nThreads
      INTEGER nTx
      INTEGER nTy
      INTEGER numberOfProcs
      INTEGER pidIO

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c#include "PARAMS.h"
c#include "GRID.h"
c#include "DYNVARS.h"
c#include "FFIELDS.h"
C ==========================================================
C   Carbon chemistry variables
C ==========================================================

       COMMON /CARBON_NEEDS/
     &                      apCO2, AtmosP, pH, pCO2, FluxCO2,
     &                      wind, FIce, Silica
     &                      , apco20, apco21
      Real*8  apCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  AtmosP(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pH(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  pCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FluxCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  wind(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FIce(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Silica(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco20(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco21(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C ==========================================================
C   Carbon and oxygen chemistry parameters
C ==========================================================

       COMMON /CARBON_CHEM/
     &                     ak0,ak1,ak2,akw,akb,aks,akf,
     &                     ak1p,ak2p,ak3p,aksi,fugf,
     &                     ff,ft,st,bt,
     &                     Ksp_TP_Calc,Ksp_TP_Arag
      Real*8  ak0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akw(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akb(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aks(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak3p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aksi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ff(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  fugf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ft(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  st(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  bt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Calc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Arag(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


       COMMON /OXYGEN_CHEM/
     &                     oA0,oA1,oA2,oA3,oA4,oA5,
     &                     oB0,oB1,oB2,oB3,
     &                     oC0
      Real*8 oA0,oA1,oA2,oA3,oA4,oA5
      Real*8 oB0,oB1,oB2,oB3
      Real*8 oC0

       COMMON /GLOBAL_SURF_MEAN/
     &                          permil,Pa2Atm,epsln

C      permil : is conversion factor for mol/m3 to mol/kg
C               assumes uniform (surface) density
C      Pa2Atm : for conversion of atmospheric pressure
C               when coming from atmospheric model

      Real*8  permil
      Real*8  Pa2Atm
      Real*8  epsln

       COMMON /SCHMIDT_NO/
     &                    sca1, sca2, sca3, sca4,
     &                    sox1, sox2, sox3, sox4

C      Schmidt number coefficients

      Real*8  sca1,sca2,sca3,sca4
      Real*8  sox1,sox2,sox3,sox4

      integer apco2startdate1
      integer apco2startdate2
      Real*8     apco2StartTime
      Real*8     apco2period
      Real*8     apco2RepCycle
      Real*8     apco2const
      Real*8     apco2_exfremo_intercept
      Real*8     apco2_exfremo_slope
      CHARACTER*1 apco2mask

C ==========================================================
C   Bling inputs (specified in data.bling)
C
C  bling_k0_2dFile :: File containing a 2D spatial field of light attenuation
C        coefficient (k0_2d, in m^-1). This coefficient regulates underwater
C        light availability in the BLING model. If not specified, a constant
C        value k0 (default= 0.04 m^-1) is applied for entire domain.
C ==========================================================

       COMMON /BLING_INPUTS/
     &        bling_windFile, bling_atmospFile, bling_iceFile,
     &        bling_ironFile, bling_silicaFile,
     &        bling_psmFile, bling_plgFile, bling_pdiazFile,
     &        bling_forcingPeriod, bling_forcingCycle,
     &        bling_pCO2,
     &        river_conc_po4, river_dom_to_nut,
     &        bling_Pc_2dFile, bling_Pc_2d_diazFile,
     &        bling_k0_2dFile,
     &        bling_alpha_photo2dFile,bling_phi_DOM2dFile,
     &        bling_k_Fe2dFile, bling_k_Fe_diaz2dFile,
     &        bling_gamma_POM2dFile, bling_wsink0_2dFile,
     &        bling_phi_lg2dFile, bling_phi_sm2dFile
     &       ,apco2startdate1,apco2startdate2,
     &        apco2StartTime, apco2period, apco2RepCycle,
     &        apco2const,
     &        apco2_exfremo_intercept,
     &        apco2_exfremo_slope,
     &        apco2file, apco2mask

C      bling_windFile      :: file name of wind speeds
C      bling_atmospFile    :: file name of atmospheric pressure
C      bling_iceFile       :: file name of sea ice fraction
C      bling_ironFile      :: file name of aeolian iron flux
C      bling_silicaFile    :: file name of surface silica
C      bling_psmFile       :: file name of init small phyto biomass
C      bling_plgFile       :: file name of init lg phyto biomass
C      bling_pdiazFile     :: file name of init diaz biomass
C      bling_forcingPeriod :: period of forcing for biogeochemistry (seconds)
C      bling_forcingCycle  :: periodic forcing parameter for biogeochemistry
C      bling_pCO2          :: Atmospheric pCO2 to be read in data.bling
C      river_conc_trac     :: River concentration, bgc tracers
C      apco2               :: Atmospheric pCO2 to be read in with exf pkg

      CHARACTER*(MAX_LEN_FNAM) bling_windFile
      CHARACTER*(MAX_LEN_FNAM) bling_atmospFile
      CHARACTER*(MAX_LEN_FNAM) bling_iceFile
      CHARACTER*(MAX_LEN_FNAM) bling_ironFile
      CHARACTER*(MAX_LEN_FNAM) bling_silicaFile
      CHARACTER*(MAX_LEN_FNAM) bling_psmFile
      CHARACTER*(MAX_LEN_FNAM) bling_plgFile
      CHARACTER*(MAX_LEN_FNAM) bling_pdiazFile
      CHARACTER*(MAX_LEN_FNAM) bling_k0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2d_diazFile
      CHARACTER*(MAX_LEN_FNAM) bling_alpha_photo2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe_diaz2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_gamma_POM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_wsink0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_DOM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_lg2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_sm2dFile
      CHARACTER*(MAX_LEN_FNAM) apco2file
      Real*8     bling_forcingPeriod
      Real*8     bling_forcingCycle
      Real*8     bling_pCO2
      Real*8     river_conc_po4
      Real*8     river_dom_to_nut

C ==========================================================
C   EXF input/output scaling factors for unit conversion if needed
C ==========================================================
      Real*8     exf_inscal_apco2
      Real*8     exf_outscal_apco2
      COMMON /BLG_PARAM_SCAL/
     &                    exf_inscal_apco2,
     &                    exf_outscal_apco2

C ==========================================================
C   EXF interpolation needs
C ==========================================================

C ==========================================================
C   Ecosystem variables and parameters
C ==========================================================
C     irr_mem       :: Phyto irradiance memory
C          this is a temporally smoothed field carried between timesteps,
C          to represent photoadaptation.
C   chlsat_locTimWindow(1:2) :: local-time window (in h) for
C          satellite-equivalent chlorophyll diagnostic (and cost)

      COMMON /BIOTIC_NEEDS/
     &                     InputFe,
     &                     omegaC,
     &                     omegaAr,
     &                     irr_mem,
     &                     phyto_lg,
     &                     phyto_sm,
     &                     chl,
     &                     chl_sat,
     &                     poc,
     &                     k0_2d,
     &                     Pc_0_2d,
     &                     k_Fe_2d,
     &                     wsink0_2d,
     &                     gamma_POM_2d,
     &                     phi_DOM_2d,
     &                     phi_sm_2d,
     &                     phi_lg_2d,
     &                     phyto_diaz,
     &                     Pc_0_diaz_2d,
     &                     k_Fe_diaz_2d,
     &                     alpha_photo_2d,
     &                     Pc_0_diaz,
     &                     alpha_photo,
     &                     gamma_DON,
     &                     k_Fe_diaz,
     &                     k_NO3,
     &                     k_NO3_sm,
     &                     k_NO3_lg,
     &                     k_PO4_sm,
     &                     k_PO4_lg,
     &                     k_Fe_sm,
     &                     k_Fe_lg,
     &                     k_PtoN,
     &                     k_FetoN,
     &                     PtoN_min,
     &                     PtoN_max,
     &                     FetoN_min,
     &                     FetoN_max,
     &                     kappa_eppley_diaz,
     &                     phi_dvm,
     &                     sigma_dvm,
     &                     CtoN,
     &                     CtoP,
     &                     NtoP,
     &                     HtoC,
     &                     NO3toN,
     &                     O2toN,
     &                     O2toP,
     &                     CatoN,
     &                     CatoP,
     &                     masstoN,
     &                     pivotal,
     &                     Pc_0,
     &                     lambda_0,
     &                     resp_frac,
     &                     chl_min,
     &                     theta_Fe_max_hi,
     &                     theta_Fe_max_lo,
     &                     gamma_irr_mem,
     &                     gamma_DOP,
     &                     gamma_POM,
     &                     k_O2,
     &                     k_Fe,
     &                     k_PO4,
     &                     kFe_eq_lig_max,
     &                     kFe_eq_lig_min,
     &                     kFe_eq_lig_Femin,
     &                     kFe_eq_lig_irr,
     &                     kFe_org,
     &                     kFe_inorg,
     &                     FetoC_sed,
     &                     remin_min,
     &                     oxic_min,
     &                     ligand,
     &                     kappa_eppley,
     &                     kappa_remin,
     &                     ca_remin_depth,
     &                     phi_DOM,
     &                     phi_sm,
     &                     phi_lg,
     &                     wsink0,
     &                     wsink0z,
     &                     wsinkacc,
     &                     parfrac,
     &                     alpfe,
     &                     k0,
     &                     MLmix_max,
     &                     chlsat_locTimWindow,
CAT(
     &                     swfrac_ir,
     &                     swfrac_rd,
     &                     swfrac_bg,
     &                     k0_rd,
     &                     k0_bg,
     &                     k_ir,
     &                     chi_rd,
     &                     chi_bg,
     &                     e_rd,
     &                     e_bg,
     &                     SWFrac3D
CAT)

      Real*8 InputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 omegaC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 omegaAr(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 irr_mem(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_lg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_sm(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl_sat(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 poc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 k0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 wsink0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 gamma_POM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_DOM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_sm_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_lg_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phyto_diaz(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 Pc_0_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 alpha_photo_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_diaz
      Real*8 alpha_photo
      Real*8 gamma_DON
      Real*8 k_Fe_diaz
      Real*8 k_NO3
      Real*8 k_NO3_sm
      Real*8 k_NO3_lg
      Real*8 k_PO4_sm
      Real*8 k_PO4_lg
      Real*8 k_Fe_sm
      Real*8 k_Fe_lg
      Real*8 k_PtoN
      Real*8 k_FetoN
      Real*8 PtoN_min
      Real*8 PtoN_max
      Real*8 FetoN_min
      Real*8 FetoN_max
      Real*8 kappa_eppley_diaz
      Real*8 phi_dvm
      Real*8 sigma_dvm
      Real*8 CtoN
      Real*8 CtoP
      Real*8 NtoP
      Real*8 HtoC
      Real*8 NO3toN
      Real*8 O2toN
      Real*8 O2toP
      Real*8 CatoN
      Real*8 CatoP
      Real*8 masstoN
      Real*8 pivotal
      Real*8 Pc_0
      Real*8 lambda_0
      Real*8 resp_frac
      Real*8 chl_min
      Real*8 theta_Fe_max_hi
      Real*8 theta_Fe_max_lo
      Real*8 gamma_irr_mem
      Real*8 gamma_DOP
      Real*8 gamma_POM
      Real*8 k_O2
      Real*8 k_Fe
      Real*8 k_PO4
      Real*8 kFe_eq_lig_max
      Real*8 kFe_eq_lig_min
      Real*8 kFe_eq_lig_Femin
      Real*8 kFe_eq_lig_irr
      Real*8 kFe_org
      Real*8 kFe_inorg
      Real*8 FetoC_sed
      Real*8 remin_min
      Real*8 oxic_min
      Real*8 ligand
      Real*8 kappa_eppley
      Real*8 kappa_remin
      Real*8 ca_remin_depth
      Real*8 phi_DOM
      Real*8 phi_sm
      Real*8 phi_lg
      Real*8 wsink0
      Real*8 wsink0z
      Real*8 wsinkacc
      Real*8 parfrac
      Real*8 alpfe
      Real*8 k0
      Real*8 MLmix_max
      Real*8 chlsat_locTimWindow(2)
CAT(
      Real*8 swfrac_ir(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_rd(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_bg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
C     SWFrac3D :: combined (ir+rd+bg) shortwave fraction profile,
C                 used by BLING_HEATING to penetrate Qsw in apply_forcing.F
      Real*8 SWFrac3D(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 k0_rd
      Real*8 k0_bg
      Real*8 k_ir
      Real*8 chi_rd
      Real*8 chi_bg
      Real*8 e_rd
      Real*8 e_bg
CAT)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

C     == Routine arguments ==
C       diclocal = total inorganic carbon (mol/m^3)
C             where 1 T = 1 metric ton = 1000 kg
C       ta  = total alkalinity (eq/m^3)
C       pt  = inorganic phosphate (mol/^3)
C       sit = inorganic silicate (mol/^3)
C       t   = temperature (degrees C)
C       s   = salinity (g/kg)
        INTEGER donewt
        INTEGER inewtonmax
        INTEGER ibrackmax
        Real*8  t, s, pt, sit, ta
        Real*8  pCO2surfloc, diclocal, pHlocal
        Real*8  fflocal, btlocal, stlocal, ftlocal
        Real*8  k1local, k2local
        Real*8  k1plocal, k2plocal, k3plocal
        Real*8  kslocal, kblocal, kwlocal, ksilocal, kflocal
        Real*8  k0local, fugflocal
        INTEGER i,j,k,bi,bj,myIter
        INTEGER myThid
CEOP

C     == Local variables ==
C INPUT
C       phlo= lower limit of pH range
C       phhi= upper limit of pH range
C       atmpres = atmospheric pressure in atmospheres (1 atm==1013.25mbar)
C OUTPUT
C       co2star  = CO2*water (mol/m^3)
C       pco2surf = oceanic pCO2 (ppmv)
C ---------------------------------------------------------------------
C OCMIP NOTE: Some words about units - (JCO, 4/4/1999)
C     - Models carry tracers in mol/m^3 (on a per volume basis)
C     - Conversely, this routine, which was written by
C       observationalists (C. Sabine and R. Key), passes input
C       arguments in umol/kg (i.e., on a per mass basis)
C     - I have changed things slightly so that input arguments are in
C       mol/m^3,
C     - Thus, all input concentrations (diclocal, ta, pt, and st) should be
C       given in mol/m^3; output arguments "co2star" and "dco2star"
C       are likewise be in mol/m^3.
C ---------------------------------------------------------------------

        Real*8  phhi
        Real*8  phlo
        Real*8  c
        Real*8  a
        Real*8  a2
        Real*8  da
        Real*8  b
        Real*8  b2
        Real*8  db
        Real*8  fn
        Real*8  df
        Real*8  deltax
        Real*8  x
        Real*8  x2
        Real*8  x3
        Real*8  xmid
        Real*8  ftest
        Real*8  htotal
        Real*8  htotal2
        Real*8  co2star
        Real*8  phguess
        Real*8  fco2
        INTEGER inewton
        INTEGER ibrack
        INTEGER hstep
        Real*8  fni(3)
        Real*8  xlo
        Real*8  xhi
        Real*8  xguess
        Real*8  k123p
        Real*8  k12p
        Real*8  k12
c ---------------------------------------------------------------------
c import donewt flag
c set donewt = 1 for newton-raphson iteration
c set donewt = 0 for bracket and bisection
c ---------------------------------------------------------------------
C Change units from the input of mol/m^3 -> mol/kg:
c (1 mol/m^3)  x (1 m^3/1024.5 kg)
c where the ocean mean surface density is 1024.5 kg/m^3
c Note: mol/kg are actually what the body of this routine uses
c for calculations.  Units are reconverted back to mol/m^3 at the
c end of this routine.
c ---------------------------------------------------------------------
c To convert input in mol/m^3 -> mol/kg
        pt=pt*permil
        sit=sit*permil
        ta=ta*permil
        diclocal=diclocal*permil
c ---------------------------------------------------------------------
c set first guess and brackets for [H+] solvers
c first guess (for newton-raphson)
        phguess = phlocal

c bracketing values (for bracket/bisection)
        phhi = 10.0
        phlo = 5.0
c convert to [H+]...
        xguess = 10.0**(-phguess)
        xlo = 10.0**(-phhi)
        xhi = 10.0**(-phlo)
        xmid = (xlo + xhi)*0.5

c----------------------------------------------------------------
c iteratively solve for [H+]
c (i) Newton-Raphson method with fixed number of iterations,
c     use previous [H+] as first guess

c select newton-raphson, inewt=1
c else select bracket and bisection

cQQQQQ
        if( donewt .eq. 1)then
c.........................................................
c NEWTON-RAPHSON METHOD
c.........................................................
          x = xguess
cdiags
c         WRITE(0,*)'xguess ',xguess
cdiags
          do inewton = 1, inewtonmax
c set some common combinations of parameters used in
c the iterative [H+] solvers
            x2=x*x
            x3=x2*x
            k12 = k1local*k2local
            k12p = k1plocal*k2plocal
            k123p = k12p*k3plocal
            c = 1.0 + stlocal/kslocal
            a = x3 + k1plocal*x2 + k12p*x + k123p
            a2=a*a
            da = 3.0*x2 + 2.0*k1plocal*x + k12p
            b = x2 + k1local*x + k12
            b2=b*b
            db = 2.0*x + k1local

c Evaluate f([H+]) and f_prime([H+])
c fn = hco3+co3+borate+oh+hpo4+2*po4+silicate+hfree
c      +hso4+hf+h3po4-ta
            fn = k1local*x*diclocal/b +
     &        2.0*diclocal*k12/b +
     &        btlocal/(1.0 + x/kblocal) +
     &        kwlocal/x +
     &        pt*k12p*x/a +
     &        2.0*pt*k123p/a +
     &        sit/(1.0 + x/ksilocal) -
     &        x/c -
     &        stlocal/(1.0 + kslocal/x/c) -
     &        ftlocal/(1.0 + kflocal/x) -
     &        pt*x3/a -
     &        ta

c df = dfn/dx
cdiags
c      WRITE(0,*)'values',b2,kblocal,x2,a2,c,x
cdiags
            df = ((k1local*diclocal*b) - k1local*x*diclocal*db)/b2 -
     &        2.0*diclocal*k12*db/b2 -
     &        btlocal/kblocal/(1.0+x/kblocal)**2. -
     &        kwlocal/x2 +
     &        (pt*k12p*(a - x*da))/a2 -
     &        2.0*pt*k123p*da/a2 -
     &        sit/ksilocal/(1.0+x/ksilocal)**2. +
     &        1.0/c +
     &        stlocal*(1.0 + kslocal/x/c)**(-2.0)*(kslocal/c/x2) +
     &        ftlocal*(1.0 + kflocal/x)**(-2.)*kflocal/x2 -
     &        pt*x2*(3.0*a-x*da)/a2
c evaluate increment in [H+]
            deltax = - fn/df
c update estimate of [H+]
            x = x + deltax
cdiags
c write value of x to check convergence....
c           write(0,*)'inewton, x, deltax ',inewton, x, deltax
c           write(6,*)
cdiags

          end do
c end of newton-raphson method
c....................................................
        else
c....................................................
C BRACKET AND BISECTION METHOD
c....................................................
c (ii) If first step use Bracket and Bisection method
c      with fixed, large number of iterations
          do ibrack = 1, ibrackmax
            do hstep = 1,3
              if(hstep .eq. 1)x = xhi
              if(hstep .eq. 2)x = xlo
              if(hstep .eq. 3)x = xmid
c set some common combinations of parameters used in
c the iterative [H+] solvers

              x2=x*x
              x3=x2*x
              k12 = k1local*k2local
              k12p = k1plocal*k2plocal
              k123p = k12p*k3plocal
              c = 1.0 + stlocal/kslocal
              a = x3 + k1plocal*x2 + k12p*x + k123p
              a2=a*a
              da = 3.0*x2 + 2.0*k1plocal*x + k12p
              b = x2 + k1local*x + k12
              b2=b*b
              db = 2.0*x + k1local
c evaluate f([H+]) for bracketing and mid-value cases
              fn = k1local*x*diclocal/b +
     &          2.0*diclocal*k12/b +
     &          btlocal/(1.0 + x/kblocal) +
     &          kwlocal/x +
     &          pt*k12p*x/a +
     &          2.0*pt*k123p/a +
     &          sit/(1.0 + x/ksilocal) -
     &          x/c -
     &          stlocal/(1.0 + kslocal/x/c) -
     &          ftlocal/(1.0 + kflocal/x) -
     &          pt*x3/a -
     &          ta
              fni(hstep) = fn
            end do
c now bracket solution within two of three
            ftest = fni(1)/fni(3)
            if(ftest .gt. 0.0)then
              xhi = xmid
            else
              xlo = xmid
            end if
            xmid = (xlo + xhi)*0.5

cdiags
c write value of x to check convergence....
c           WRITE(0,*)'bracket-bisection iteration ',ibrack, xmid
cdiags
          end do
c last iteration gives value
          x = xmid
c end of bracket and bisection method
c....................................
        end if
c iterative [H+] solver finished
c----------------------------------------------------------------

c now determine pCO2 etc...
c htotal = [H+], hydrogen ion conc
        htotal = x
C Calculate [CO2*] as defined in DOE Methods Handbook 1994 Ver.2,
C ORNL/CDIAC-74, dickson and Goyet, eds. (Ch 2 p 10, Eq A.49)
        htotal2=htotal*htotal
        co2star=diclocal*htotal2/(htotal2 + k1local*htotal
     &            + k1local*k2local)
        phlocal=-log10(htotal)

c ---------------------------------------------------------------
c Add two output arguments for storing pCO2surf
c Should we be using K0 or ff for the solubility here?
c ---------------------------------------------------------------
        fco2 = co2star / k0local
        pCO2surfloc = fco2/fugflocal

C ----------------------------------------------------------------
C Reconvert units back to original values for input arguments
C no longer necessary????
C ----------------------------------------------------------------
c       Reconvert from mol/kg -> mol/m^3
        pt=pt/permil
        sit=sit/permil
        ta=ta/permil
        diclocal=diclocal/permil

        RETURN
        END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
      subroutine CALC_PCO2_APPROX(
     I                       t,s,diclocal,pt,sit,ta,
     I                       k1local,k2local,
     I                       k1plocal,k2plocal,k3plocal,
     I                       kslocal,kblocal,kwlocal,
     I                       ksilocal,kflocal,
     I                       k0local, fugflocal,
     I                       fflocal,btlocal,stlocal,ftlocal,
     U                       pHlocal,pCO2surfloc,co3local,
     I                       i,j,k,bi,bj,myIter,myThid )

C !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE CALC_PCO2_APPROX                              |
C     *==========================================================*
C     CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     C  New efficient pCO2 solver, Mick Follows         CC
C     C                             Taka Ito             CC
C     C                             Stephanie Dutkiewicz CC
C     C  20 April 2003                                   CC
C     CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C      Apr 2011: fix vapour bug (following Bennington)
C      Oct 2011: add CO3 extimation and pass out

      IMPLICIT NONE

C     === Global variables ===
C $Header: /u/gcmpack/MITgcm_contrib/llc_hires/llc_270/code/SIZE.h,v 1.3 2015/09/29 18:07:50 zhc Exp $
C $Name:  $

C
CBOP
C    !ROUTINE: SIZE.h
C    !INTERFACE:
C    include SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SIZE.h Declare size of underlying computational grid.     
C     *==========================================================*
C     | The design here support a three-dimensional model grid    
C     | with indices I,J and K. The three-dimensional domain      
C     | is comprised of nPx*nSx blocks of size sNx along one axis 
C     | nPy*nSy blocks of size sNy along another axis and one     
C     | block of size Nz along the final axis.                    
C     | Blocks have overlap regions of size OLx and OLy along the 
C     | dimensions that are subdivided.                           
C     *==========================================================*
C     \ev
CEOP
C     Voodoo numbers controlling data layout.
C     sNx :: No. X points in sub-grid.
C     sNy :: No. Y points in sub-grid.
C     OLx :: Overlap extent in X.
C     OLy :: Overlat extent in Y.
C     nSx :: No. sub-grids in X.
C     nSy :: No. sub-grids in Y.
C     nPx :: No. of processes to use in X.
C     nPy :: No. of processes to use in Y.
C     Nx  :: No. points in X for the total domain.
C     Ny  :: No. points in Y for the total domain.
C     Nr  :: No. points in Z for full process domain.
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER (
     &           sNx = 720,
     &           sNy = 280,
     &           OLx =   8,
     &           OLy =   8,
     &           nSx =   1,
     &           nSy =   1,
     &           nPx =   1,
     &           nPy =   1,
     &           Nx  = sNx*nSx*nPx,
     &           Ny  = sNy*nSy*nPy,
     &           Nr  =  50 )

C     MAX_OLX :: Set to the maximum overlap region size of any array
C     MAX_OLY    that will be exchanged. Controls the sizing of exch
C                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx,
     &            MAX_OLY = OLy )

      INTEGER     nobcs
      PARAMETER ( nobcs = 4 )

C $Header: /u/gcmpack/MITgcm/eesupp/inc/EEPARAMS.h,v 1.36 2014/02/13 04:10:25 jmc Exp $
C $Name:  $
CBOP
C     !ROUTINE: EEPARAMS.h
C     !INTERFACE:
C     include "EEPARAMS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | EEPARAMS.h                                               |
C     *==========================================================*
C     | Parameters for "execution environemnt". These are used   |
C     | by both the particular numerical model and the execution |
C     | environment support routines.                            |
C     *==========================================================*
CEOP

C     ========  EESIZE.h  ========================================

C     MAX_LEN_MBUF  :: Default message buffer max. size
C     MAX_LEN_FNAM  :: Default file name max. size
C     MAX_LEN_PREC  :: Default rec len for reading "parameter" files

      INTEGER MAX_LEN_MBUF
      PARAMETER ( MAX_LEN_MBUF = 512 )
      INTEGER MAX_LEN_FNAM
      PARAMETER ( MAX_LEN_FNAM = 512 )
      INTEGER MAX_LEN_PREC
      PARAMETER ( MAX_LEN_PREC = 200 )

C     MAX_NO_THREADS  :: Maximum number of threads allowed.
CC    MAX_NO_PROCS    :: Maximum number of processes allowed.
CC    MAX_NO_BARRIERS :: Maximum number of distinct thread "barriers"
      INTEGER MAX_NO_THREADS
      PARAMETER ( MAX_NO_THREADS =  4 )
c     INTEGER MAX_NO_PROCS
c     PARAMETER ( MAX_NO_PROCS   =  70000 )
c     INTEGER MAX_NO_BARRIERS
c     PARAMETER ( MAX_NO_BARRIERS = 1 )

C     Particularly weird and obscure voodoo numbers
C     lShare :: This wants to be the length in
C               [148]-byte words of the size of
C               the address "window" that is snooped
C               on an SMP bus. By separating elements in
C               the global sum buffer we can avoid generating
C               extraneous invalidate traffic between
C               processors. The length of this window is usually
C               a cache line i.e. small O(64 bytes).
C               The buffer arrays are usually short arrays
C               and are declared REAL ARRA(lShare[148],LBUFF).
C               Setting lShare[148] to 1 is like making these arrays
C               one dimensional.
      INTEGER cacheLineSize
      INTEGER lShare1
      INTEGER lShare4
      INTEGER lShare8
      PARAMETER ( cacheLineSize = 256 )
      PARAMETER ( lShare1 =  cacheLineSize )
      PARAMETER ( lShare4 =  cacheLineSize/4 )
      PARAMETER ( lShare8 =  cacheLineSize/8 )

CC    MAX_VGS  :: Maximum buffer size for Global Vector Sum
c     INTEGER MAX_VGS
c     PARAMETER ( MAX_VGS = 8192 )

C     ========  EESIZE.h  ========================================

C     Symbolic values
C     precXXXX :: precision used for I/O
      INTEGER precFloat32
      PARAMETER ( precFloat32 = 32 )
      INTEGER precFloat64
      PARAMETER ( precFloat64 = 64 )

C     Real-type constant for some frequently used simple number (0,1,2,1/2):
      Real*8     zeroRS, oneRS, twoRS, halfRS
      PARAMETER ( zeroRS = 0.0D0 , oneRS  = 1.0D0 )
      PARAMETER ( twoRS  = 2.0D0 , halfRS = 0.5D0 )
      Real*8     zeroRL, oneRL, twoRL, halfRL
      PARAMETER ( zeroRL = 0.0D0 , oneRL  = 1.0D0 )
      PARAMETER ( twoRL  = 2.0D0 , halfRL = 0.5D0 )

C     UNSET_xxx :: Used to indicate variables that have not been given a value
      Real*8  UNSET_FLOAT8
      PARAMETER ( UNSET_FLOAT8 = 1.234567D5 )
      Real*4  UNSET_FLOAT4
      PARAMETER ( UNSET_FLOAT4 = 1.234567E5 )
      Real*8     UNSET_RL
      PARAMETER ( UNSET_RL     = 1.234567D5 )
      Real*8     UNSET_RS
      PARAMETER ( UNSET_RS     = 1.234567D5 )
      INTEGER UNSET_I
      PARAMETER ( UNSET_I      = 123456789  )

C     debLevX  :: used to decide when to print debug messages
      INTEGER debLevZero
      INTEGER debLevA, debLevB,  debLevC, debLevD, debLevE
      PARAMETER ( debLevZero=0 )
      PARAMETER ( debLevA=1 )
      PARAMETER ( debLevB=2 )
      PARAMETER ( debLevC=3 )
      PARAMETER ( debLevD=4 )
      PARAMETER ( debLevE=5 )

C     SQUEEZE_RIGHT      :: Flag indicating right blank space removal
C                           from text field.
C     SQUEEZE_LEFT       :: Flag indicating left blank space removal
C                           from text field.
C     SQUEEZE_BOTH       :: Flag indicating left and right blank
C                           space removal from text field.
C     PRINT_MAP_XY       :: Flag indicating to plot map as XY slices
C     PRINT_MAP_XZ       :: Flag indicating to plot map as XZ slices
C     PRINT_MAP_YZ       :: Flag indicating to plot map as YZ slices
C     commentCharacter   :: Variable used in column 1 of parameter
C                           files to indicate comments.
C     INDEX_I            :: Variable used to select an index label
C     INDEX_J               for formatted input parameters.
C     INDEX_K
C     INDEX_NONE
      CHARACTER*(*) SQUEEZE_RIGHT
      PARAMETER ( SQUEEZE_RIGHT = 'R' )
      CHARACTER*(*) SQUEEZE_LEFT
      PARAMETER ( SQUEEZE_LEFT = 'L' )
      CHARACTER*(*) SQUEEZE_BOTH
      PARAMETER ( SQUEEZE_BOTH = 'B' )
      CHARACTER*(*) PRINT_MAP_XY
      PARAMETER ( PRINT_MAP_XY = 'XY' )
      CHARACTER*(*) PRINT_MAP_XZ
      PARAMETER ( PRINT_MAP_XZ = 'XZ' )
      CHARACTER*(*) PRINT_MAP_YZ
      PARAMETER ( PRINT_MAP_YZ = 'YZ' )
      CHARACTER*(*) commentCharacter
      PARAMETER ( commentCharacter = '#' )
      INTEGER INDEX_I
      INTEGER INDEX_J
      INTEGER INDEX_K
      INTEGER INDEX_NONE
      PARAMETER ( INDEX_I    = 1,
     &            INDEX_J    = 2,
     &            INDEX_K    = 3,
     &            INDEX_NONE = 4 )

C     EXCH_IGNORE_CORNERS :: Flag to select ignoring or
C     EXCH_UPDATE_CORNERS    updating of corners during an edge exchange.
      INTEGER EXCH_IGNORE_CORNERS
      INTEGER EXCH_UPDATE_CORNERS
      PARAMETER ( EXCH_IGNORE_CORNERS = 0,
     &            EXCH_UPDATE_CORNERS = 1 )

C     FORWARD_SIMULATION
C     REVERSE_SIMULATION
C     TANGENT_SIMULATION
      INTEGER FORWARD_SIMULATION
      INTEGER REVERSE_SIMULATION
      INTEGER TANGENT_SIMULATION
      PARAMETER ( FORWARD_SIMULATION = 0,
     &            REVERSE_SIMULATION = 1,
     &            TANGENT_SIMULATION = 2 )

C--   COMMON /EEPARAMS_L/ Execution environment public logical variables.
C     eeBootError    :: Flags indicating error during multi-processing
C     eeEndError     :: initialisation and termination.
C     fatalError     :: Flag used to indicate that the model is ended with an error
C     debugMode      :: controls printing of debug msg (sequence of S/R calls).
C     useSingleCpuIO :: When useSingleCpuIO is set, MDS_WRITE_FIELD outputs from
C                       master MPI process only. -- NOTE: read from main parameter
C                       file "data" and not set until call to INI_PARMS.
C     useSingleCpuInput :: When useSingleCpuInput is set, EXF_INTERP_READ
C                       reads forcing files from master MPI process only.
C                       -- NOTE: read from main parameter file "data"
C                          and defaults to useSingleCpuInput = useSingleCpuIO
C     printMapIncludesZeros  :: Flag that controls whether character constant
C                               map code ignores exact zero values.
C     useCubedSphereExchange :: use Cubed-Sphere topology domain.
C     useCoupler     :: use Coupler for a multi-components set-up.
C     useNEST_PARENT :: use Parent Nesting interface (pkg/nest_parent)
C     useNEST_CHILD  :: use Child  Nesting interface (pkg/nest_child)
C     useOASIS       :: use OASIS-coupler for a multi-components set-up.
      COMMON /EEPARAMS_L/
c    &  eeBootError, fatalError, eeEndError,
     &  eeBootError, eeEndError, fatalError, debugMode,
     &  useSingleCpuIO, useSingleCpuInput, printMapIncludesZeros,
     &  useCubedSphereExchange, useCoupler,
     &  useNEST_PARENT, useNEST_CHILD, useOASIS,
     &  useSETRLSTK, useSIGREG
      LOGICAL eeBootError
      LOGICAL eeEndError
      LOGICAL fatalError
      LOGICAL debugMode
      LOGICAL useSingleCpuIO
      LOGICAL useSingleCpuInput
      LOGICAL printMapIncludesZeros
      LOGICAL useCubedSphereExchange
      LOGICAL useCoupler
      LOGICAL useNEST_PARENT
      LOGICAL useNEST_CHILD
      LOGICAL useOASIS
      LOGICAL useSETRLSTK
      LOGICAL useSIGREG

C--   COMMON /EPARAMS_I/ Execution environment public integer variables.
C     errorMessageUnit    :: Fortran IO unit for error messages
C     standardMessageUnit :: Fortran IO unit for informational messages
C     maxLengthPrt1D :: maximum length for printing (to Std-Msg-Unit) 1-D array
C     scrUnit1      :: Scratch file 1 unit number
C     scrUnit2      :: Scratch file 2 unit number
C     eeDataUnit    :: Unit # for reading "execution environment" parameter file
C     modelDataUnit :: Unit number for reading "model" parameter file.
C     numberOfProcs :: Number of processes computing in parallel
C     pidIO         :: Id of process to use for I/O.
C     myBxLo, myBxHi :: Extents of domain in blocks in X and Y
C     myByLo, myByHi :: that each threads is responsble for.
C     myProcId      :: My own "process" id.
C     myPx          :: My X coord on the proc. grid.
C     myPy          :: My Y coord on the proc. grid.
C     myXGlobalLo   :: My bottom-left (south-west) x-index global domain.
C                      The x-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     myYGlobalLo   :: My bottom-left (south-west) y-index in global domain.
C                      The y-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     nThreads      :: No. of threads
C     nTx, nTy      :: No. of threads in X and in Y
C                      This assumes a simple cartesian gridding of the threads
C                      which is not required elsewhere but that makes it easier
C     ioErrorCount  :: IO Error Counter. Set to zero initially and increased
C                      by one every time an IO error occurs.
      COMMON /EEPARAMS_I/
     &  errorMessageUnit, standardMessageUnit, maxLengthPrt1D,
     &  scrUnit1, scrUnit2, eeDataUnit, modelDataUnit,
     &  numberOfProcs, pidIO, myProcId,
     &  myPx, myPy, myXGlobalLo, myYGlobalLo, nThreads,
     &  myBxLo, myBxHi, myByLo, myByHi,
     &  nTx, nTy, ioErrorCount
      INTEGER errorMessageUnit
      INTEGER standardMessageUnit
      INTEGER maxLengthPrt1D
      INTEGER scrUnit1
      INTEGER scrUnit2
      INTEGER eeDataUnit
      INTEGER modelDataUnit
      INTEGER ioErrorCount(MAX_NO_THREADS)
      INTEGER myBxLo(MAX_NO_THREADS)
      INTEGER myBxHi(MAX_NO_THREADS)
      INTEGER myByLo(MAX_NO_THREADS)
      INTEGER myByHi(MAX_NO_THREADS)
      INTEGER myProcId
      INTEGER myPx
      INTEGER myPy
      INTEGER myXGlobalLo
      INTEGER myYGlobalLo
      INTEGER nThreads
      INTEGER nTx
      INTEGER nTy
      INTEGER numberOfProcs
      INTEGER pidIO

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c#include "PARAMS.h"
C $Header: /u/gcmpack/MITgcm/model/inc/GRID.h,v 1.43 2013/07/26 14:20:01 jmc Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: GRID.h
C    !INTERFACE:
C    include GRID.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID.h
C     | o Header file defining model grid.
C     *==========================================================*
C     | Model grid is defined for each process by reference to
C     | the arrays set here.
C     | Notes
C     | =====
C     | The standard MITgcm convention of westmost, southern most
C     | and upper most having the (1,1,1) index is used here.
C     | i.e.
C     |----------------------------------------------------------
C     | (1)  Plan view schematic of model grid (top layer i.e. )
C     |      ================================= ( ocean surface )
C     |                                        ( or top of     )
C     |                                        ( atmosphere    )
C     |      This diagram shows the location of the model
C     |      prognostic variables on the model grid. The "T"
C     |      location is used for all tracers. The figure also
C     |      shows the southern most, western most indexing
C     |      convention that is used for all model variables.
C     |
C     |
C     |             V(i=1,                     V(i=Nx,
C     |               j=Ny+1,                    j=Ny+1,
C     |               k=1)                       k=1)
C     |                /|\                       /|\  "PWX"
C     |       |---------|------------------etc..  |---- *---
C     |       |                     |                   *  |
C     |"PWY"*******************************etc..  **********"PWY"
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *==>U
C     |  j=Ny,|      T(i=1,         |          T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=Ny,        |            j=Ny,  *  |j=Ny,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *  |
C     |  j=2, |      T(i=1,         |          T(i=Nx,  *  |
C     |  k=1) |        j=2,         |            j=2,   *  |
C     |       |        k=1)         |            k=1)   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |      -----------|------------------etc..  |-----*---
C     |       |       V(i=1,        |           V(i=Nx, *  |
C     |       |         j=2,        |             j=2,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |"SB"++>|---------|------------------etc..  |-----*---
C     |      /+\      V(i=1,                    V(i=Nx, *
C     |       +         j=1,                      j=1,  *
C     |       +         k=1)                      k=1)  *
C     |     "WB"                                      "PWX"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     |    V: y-velocity (m/s)
C     |    T: potential temperature (oC)
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |----------------------------------------------------------
C     | (2) South elevation schematic of model grid
C     |     =======================================
C     |     This diagram shows the location of the model
C     |     prognostic variables on the model grid. The "T"
C     |     location is used for all tracers. The figure also
C     |     shows the upper most, western most indexing
C     |     convention that is used for all model variables.
C     |
C     |      "WB"
C     |       +
C     |       +
C     |      \+/       /|\                       /|\       .
C     |"UB"++>|-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=2)        |             k=2)  *  |
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=Nr)       |             k=Nr) *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=Nr)|        j=1,         |  k=Nr)     j=1,   *  |j=1,
C     |       |        k=Nr)        |            k=Nr)  *  |k=Nr)
C     |       |                     |                   *  |
C     |"LB"++>==============================================
C     |                                               "PWX"
C     |
C     | Up   increasing upwards.
C     |/|\                                                       .
C     | |
C     | |
C     | =====> E  i increasing eastwards
C     | |         x increasing eastwards
C     | |
C     |\|/
C     | Down,k increasing downwards.
C     |
C     | Note: r => height (m) => r increases upwards
C     |       r => pressure (Pa) => r increases downwards
C     |
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     | rVel: z-velocity ( units of r )
C     |       The vertical velocity variable rVel is in units of
C     |       "r" the vertical coordinate. r in m will give
C     |       rVel m/s. r in Pa will give rVel Pa/s.
C     |    T: potential temperature (oC)
C     | "UB": Upper boundary.
C     | "LB": Lower boundary (always solid - therefore om|w == 0)
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |----------------------------------------------------------
C     | (3) Views showing nomenclature and indexing
C     |     for grid descriptor variables.
C     |
C     |      Fig 3a. shows the orientation, indexing and
C     |      notation for the grid spacing terms used internally
C     |      for the evaluation of gradient and averaging terms.
C     |      These varaibles are set based on the model input
C     |      parameters which define the model grid in terms of
C     |      spacing in X, Y and Z.
C     |
C     |      Fig 3b. shows the orientation, indexing and
C     |      notation for the variables that are used to define
C     |      the model grid. These varaibles are set directly
C     |      from the model input.
C     |
C     | Figure 3a
C     | =========
C     |       |------------------------------------
C     |       |                       |
C     |"PWY"********************************* etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v----------|-
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       u<--dxF(i=1,j=2,k=1)--->u           t          |
C     |       |/|\       /|\          |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       |dyU(i=1,  dyC(i=1,     |                      |
C     | ---  ---|--j=2,---|--j=2,-----------------v----------|-
C     | /|\   | |  k=1)   |  k=1)     |          /|\         |
C     |  |    | |         |           |          dyF(i=2,    |
C     |  |    | |         |           |           |  j=1,    |
C     |dyG(   |\|/       \|/          |           |  k=1)    |
C     |   i=1,u---        t<---dxC(i=2,j=1,k=1)-->t          |
C     |   j=1,|                       |           |          |
C     |   k=1)|                       |           |          |
C     |  |    |                       |           |          |
C     |  |    |                       |           |          |
C     | \|/   |           |<---dxV(i=2,j=1,k=1)--\|/         |
C     |"SB"++>|___________v___________|___________v__________|_
C     |       <--dxG(i=1,j=1,k=1)----->
C     |      /+\                                              .
C     |       +
C     |       +
C     |     "WB"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    u: x-velocity point
C     |    V: y-velocity point
C     |    t: tracer point
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |
C     | Figure 3b
C     | =========
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v--etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       u<--delX(i=1)---------->u           t
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |-----------v-----------------------v--etc...
C     |       |          /|\          |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       u        delY(j=1)      |           t
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |          \|/          |
C     |"SB"++>|___________v___________|___________v__etc...
C     |      /+\                                                 .
C     |       +
C     |       +
C     |     "WB"
C     |
C     *==========================================================*
C     \ev
CEOP

C     Macros that override/modify standard definitions
C $Header: /u/gcmpack/MITgcm/model/inc/GRID_MACROS.h,v 1.13 2013/08/11 14:27:37 jmc Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: GRID_MACROS.h
C    !INTERFACE:
C    include GRID_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID_MACROS.h
C     *==========================================================*
C     | These macros are used to substitute definitions for
C     | GRID.h variables for particular configurations.
C     | In setting these variables the following convention
C     | applies.
C     | undef  phi_CONST   - Indicates the variable phi is fixed
C     |                      in X, Y and Z.
C     | undef  phi_FX      - Indicates the variable phi only
C     |                      varies in X (i.e.not in X or Z).
C     | undef  phi_FY      - Indicates the variable phi only
C     |                      varies in Y (i.e.not in X or Z).
C     | undef  phi_FXY     - Indicates the variable phi only
C     |                      varies in X and Y ( i.e. not Z).
C     *==========================================================*
C     \ev
CEOP

C $Header: /u/gcmpack/MITgcm/model/inc/DXC_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXC_MACROS.h
C    !INTERFACE:
C    include DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXF_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXF_MACROS.h
C    !INTERFACE:
C    include DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXG_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXG_MACROS.h
C    !INTERFACE:
C    include DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXV_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXV_MACROS.h
C    !INTERFACE:
C    include DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXV_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYC_MACROS.h
C    !INTERFACE:
C    include DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYF_MACROS.h
C    !INTERFACE:
C    include DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYG_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYG_MACROS.h
C    !INTERFACE:
C    include DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYU_MACROS.h
C    !INTERFACE:
C    include DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYU_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/HFACC_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACC_MACROS.h
C    !INTERFACE:
C    include HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACC_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/HFACS_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACS_MACROS.h
C    !INTERFACE:
C    include HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/HFACW_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACW_MACROS.h
C    !INTERFACE:
C    include HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXC_MACROS.h
C    !INTERFACE:
C    include RECIP_DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXF_MACROS.h
C    !INTERFACE:
C    include RECIP_DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXG_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXG_MACROS.h
C    !INTERFACE:
C    include RECIP_DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXV_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXV_MACROS.h
C    !INTERFACE:
C    include RECIP_DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYC_MACROS.h
C    !INTERFACE:
C    include RECIP_DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYF_MACROS.h
C    !INTERFACE:
C    include RECIP_DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYG_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYG_MACROS.h
C    !INTERFACE:
C    include RECIP_DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYU_MACROS.h
C    !INTERFACE:
C    include RECIP_DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACC_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACC_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACC_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACS_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACS_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACS_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACW_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACW_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACW_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/XC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: XC_MACROS.h
C    !INTERFACE:
C    include XC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | XC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/YC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: YC_MACROS.h
C    !INTERFACE:
C    include YC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | YC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RA_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RA_MACROS.h
C    !INTERFACE:
C    include RA_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RA_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C $Header: /u/gcmpack/MITgcm/model/inc/RAW_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RAW_MACROS.h
C    !INTERFACE:
C    include RAW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAW_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C $Header: /u/gcmpack/MITgcm/model/inc/RAS_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RAS_MACROS.h
C    !INTERFACE:
C    include RAS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAS_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/MASKW_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: MASKW_MACROS.h
C    !INTERFACE:
C    include MASKW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C $Header: /u/gcmpack/MITgcm/model/inc/MASKS_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: MASKS_MACROS.h
C    !INTERFACE:
C    include MASKS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C $Header: /u/gcmpack/MITgcm/model/inc/TANPHIATU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: TANPHIATU_MACROS.h
C    !INTERFACE:
C    include TANPHIATU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/TANPHIATV_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: TANPHIATV_MACROS.h
C    !INTERFACE:
C    include TANPHIATV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/FCORI_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: FCORI_MACROS.h
C    !INTERFACE:
C    include FCORI_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | FCORI_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C--   COMMON /GRID_RL/ RL valued grid defining variables.
C     deepFacC  :: deep-model grid factor (fct of vertical only) for dx,dy
C     deepFacF     at level-center (deepFacC)  and level interface (deepFacF)
C     deepFac2C :: deep-model grid factor (fct of vertical only) for area dx*dy
C     deepFac2F    at level-center (deepFac2C) and level interface (deepFac2F)
C     gravitySign :: indicates the direction of gravity relative to R direction
C                   (= -1 for R=Z (Z increases upward, -gravity direction  )
C                   (= +1 for R=P (P increases downward, +gravity direction)
C     rkSign     :: Vertical coordinate to vertical index orientation.
C                   ( +1 same orientation, -1 opposite orientation )
C     globalArea :: Domain Integrated horizontal Area [m2]
      COMMON /GRID_RL/
     &  cosFacU, cosFacV, sqCosFacU, sqCosFacV,
     &  deepFacC, deepFac2C, recip_deepFacC, recip_deepFac2C,
     &  deepFacF, deepFac2F, recip_deepFacF, recip_deepFac2F,
     &  gravitySign, rkSign, globalArea
      Real*8 cosFacU        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 cosFacV        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacU      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacV      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 deepFacC       (Nr)
      Real*8 deepFac2C      (Nr)
      Real*8 deepFacF       (Nr+1)
      Real*8 deepFac2F      (Nr+1)
      Real*8 recip_deepFacC (Nr)
      Real*8 recip_deepFac2C(Nr)
      Real*8 recip_deepFacF (Nr+1)
      Real*8 recip_deepFac2F(Nr+1)
      Real*8 gravitySign
      Real*8 rkSign
      Real*8 globalArea

C--   COMMON /GRID_RS/ RS valued grid defining variables.
C     dxC     :: Cell center separation in X across western cell wall (m)
C     dxG     :: Cell face separation in X along southern cell wall (m)
C     dxF     :: Cell face separation in X thru cell center (m)
C     dxV     :: V-point separation in X across south-west corner of cell (m)
C     dyC     :: Cell center separation in Y across southern cell wall (m)
C     dyG     :: Cell face separation in Y along western cell wall (m)
C     dyF     :: Cell face separation in Y thru cell center (m)
C     dyU     :: U-point separation in Y across south-west corner of cell (m)
C     drC     :: Cell center separation along Z axis ( units of r ).
C     drF     :: Cell face separation along Z axis ( units of r ).
C     R_low   :: base of fluid in r_unit (Depth(m) / Pressure(Pa) at top Atmos.)
C     rLowW   :: base of fluid column in r_unit at Western  edge location.
C     rLowS   :: base of fluid column in r_unit at Southern edge location.
C     Ro_surf :: surface reference (at rest) position, r_unit.
C     rSurfW  :: surface reference position at Western  edge location [r_unit].
C     rSurfS  :: surface reference position at Southern edge location [r_unit].
C     hFac    :: Fraction of cell in vertical which is open i.e how
C              "lopped" a cell is (dimensionless scale factor).
C              Note: The code needs terms like MIN(hFac,hFac(I-1))
C                    On some platforms it may be better to precompute
C                    hFacW, hFacS, ... here than do MIN on the fly.
C     maskInC :: Cell Center 2-D Interior mask (i.e., zero beyond OB)
C     maskInW :: West  face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskInS :: South face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskC   :: cell Center land mask
C     maskW   :: West face land mask
C     maskS   :: South face land mask
C     recip_dxC   :: Reciprocal of dxC
C     recip_dxG   :: Reciprocal of dxG
C     recip_dxF   :: Reciprocal of dxF
C     recip_dxV   :: Reciprocal of dxV
C     recip_dyC   :: Reciprocal of dxC
C     recip_dyG   :: Reciprocal of dyG
C     recip_dyF   :: Reciprocal of dyF
C     recip_dyU   :: Reciprocal of dyU
C     recip_drC   :: Reciprocal of drC
C     recip_drF   :: Reciprocal of drF
C     recip_Rcol  :: Inverse of cell center column thickness (1/r_unit)
C     recip_hFacC :: Inverse of cell open-depth f[X,Y,Z] ( dimensionless ).
C     recip_hFacW    rhFacC center, rhFacW west, rhFacS south.
C     recip_hFacS    Note: This is precomputed here because it involves division.
C     xC        :: X-coordinate of cell center f[X,Y]. The units of xc, yc
C                  depend on the grid. They are not used in differencing or
C                  averaging but are just a convient quantity for I/O,
C                  diagnostics etc.. As such xc is in m for cartesian
C                  coordinates but degrees for spherical polar.
C     yC        :: Y-coordinate of center of cell f[X,Y].
C     yG        :: Y-coordinate of corner of cell ( c-grid vorticity point) f[X,Y].
C     rA        :: R-face are f[X,Y] ( m^2 ).
C                  Note: In a cartesian framework rA is simply dx*dy,
C                      however we use rA to allow for non-globally
C                      orthogonal coordinate frames (with appropriate
C                      metric terms).
C     rC        :: R-coordinate of center of cell f[Z] (units of r).
C     rF        :: R-coordinate of face of cell f[Z] (units of r).
C - *HybSigm* - :: Hybrid-Sigma vert. Coord coefficients
C     aHybSigmF    at level-interface (*HybSigmF) and level-center (*HybSigmC)
C     aHybSigmC    aHybSigm* = constant r part, bHybSigm* = sigma part, such as
C     bHybSigmF    r(ij,k,t) = rLow(ij) + aHybSigm(k)*[rF(1)-rF(Nr+1)]
C     bHybSigmC              + bHybSigm(k)*[eta(ij,t)+Ro_surf(ij) - rLow(ij)]
C     dAHybSigF :: vertical increment of Hybrid-Sigma coefficient: constant r part,
C     dAHybSigC    between interface (dAHybSigF) and between center (dAHybSigC)
C     dBHybSigF :: vertical increment of Hybrid-Sigma coefficient: sigma part,
C     dBHybSigC    between interface (dBHybSigF) and between center (dBHybSigC)
C     tanPhiAtU :: tan of the latitude at U point. Used for spherical polar
C                  metric term in U equation.
C     tanPhiAtV :: tan of the latitude at V point. Used for spherical polar
C                  metric term in V equation.
C     angleCosC :: cosine of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     angleSinC :: sine   of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     u2zonDir  :: cosine of grid orientation angle at U point location
C     v2zonDir  :: minus sine of  orientation angle at V point location
C     fCori     :: Coriolis parameter at grid Center point
C     fCoriG    :: Coriolis parameter at grid Corner point
C     fCoriCos  :: Coriolis Cos(phi) parameter at grid Center point (for NH)

      COMMON /GRID_RS/
     &  dxC,dxF,dxG,dxV,dyC,dyF,dyG,dyU,
     &  R_low, rLowW, rLowS,
     &  Ro_surf, rSurfW, rSurfS,
     &  hFacC, hFacW, hFacS,
     &  recip_dxC,recip_dxF,recip_dxG,recip_dxV,
     &  recip_dyC,recip_dyF,recip_dyG,recip_dyU,
     &  recip_Rcol,
     &  recip_hFacC,recip_hFacW,recip_hFacS,
     &  xC,yC,rA,rAw,rAs,rAz,xG,yG,
     &  maskInC, maskInW, maskInS,
     &  maskC, maskW, maskS,
     &  recip_rA,recip_rAw,recip_rAs,recip_rAz,
     &  drC, drF, recip_drC, recip_drF, rC, rF,
     &  aHybSigmF, bHybSigmF, aHybSigmC, bHybSigmC,
     &  dAHybSigF, dBHybSigF, dBHybSigC, dAHybSigC,
     &  tanPhiAtU, tanPhiAtV,
     &  angleCosC, angleSinC, u2zonDir, v2zonDir,
     &  fCori, fCoriG, fCoriCos
      Real*8 dxC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxV            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyU            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 R_low          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Ro_surf        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfW         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfS         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hFacC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_dxC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_Rcol     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_hFacC    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacW    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacS    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 xC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 xG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rA             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAw            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAs            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAz            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAw      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAs      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAz      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInC        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInW        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInS        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 drC            (Nr+1)
      Real*8 drF            (Nr)
      Real*8 recip_drC      (Nr+1)
      Real*8 recip_drF      (Nr)
      Real*8 rC             (Nr)
      Real*8 rF             (Nr+1)
      Real*8 aHybSigmF      (Nr+1)
      Real*8 bHybSigmF      (Nr+1)
      Real*8 aHybSigmC      (Nr)
      Real*8 bHybSigmC      (Nr)
      Real*8 dAHybSigF      (Nr)
      Real*8 dBHybSigF      (Nr)
      Real*8 dBHybSigC      (Nr+1)
      Real*8 dAHybSigC      (Nr+1)
      Real*8 tanPhiAtU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tanPhiAtV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleCosC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleSinC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 u2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 v2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCori          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriG         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriCos       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


C--   COMMON /GRID_I/ INTEGER valued grid defining variables.
C     kSurfC  :: vertical index of the surface tracer cell
C     kSurfW  :: vertical index of the surface U point
C     kSurfS  :: vertical index of the surface V point
C     kLowC   :: index of the r-lowest "wet cell" (2D)
C IMPORTANT: kSurfC,W,S = Nr+1 and kLowC = 0 where the fluid column
C            is empty (continent)
      COMMON /GRID_I/
     &  kSurfC, kSurfW, kSurfS,
     &  kLowC
      INTEGER kSurfC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfW(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kLowC (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
c#include "DYNVARS.h"
c#include "FFIELDS.h"
C ==========================================================
C   Carbon chemistry variables
C ==========================================================

       COMMON /CARBON_NEEDS/
     &                      apCO2, AtmosP, pH, pCO2, FluxCO2,
     &                      wind, FIce, Silica
     &                      , apco20, apco21
      Real*8  apCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  AtmosP(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pH(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  pCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FluxCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  wind(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FIce(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Silica(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco20(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco21(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C ==========================================================
C   Carbon and oxygen chemistry parameters
C ==========================================================

       COMMON /CARBON_CHEM/
     &                     ak0,ak1,ak2,akw,akb,aks,akf,
     &                     ak1p,ak2p,ak3p,aksi,fugf,
     &                     ff,ft,st,bt,
     &                     Ksp_TP_Calc,Ksp_TP_Arag
      Real*8  ak0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akw(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akb(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aks(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak3p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aksi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ff(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  fugf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ft(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  st(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  bt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Calc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Arag(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


       COMMON /OXYGEN_CHEM/
     &                     oA0,oA1,oA2,oA3,oA4,oA5,
     &                     oB0,oB1,oB2,oB3,
     &                     oC0
      Real*8 oA0,oA1,oA2,oA3,oA4,oA5
      Real*8 oB0,oB1,oB2,oB3
      Real*8 oC0

       COMMON /GLOBAL_SURF_MEAN/
     &                          permil,Pa2Atm,epsln

C      permil : is conversion factor for mol/m3 to mol/kg
C               assumes uniform (surface) density
C      Pa2Atm : for conversion of atmospheric pressure
C               when coming from atmospheric model

      Real*8  permil
      Real*8  Pa2Atm
      Real*8  epsln

       COMMON /SCHMIDT_NO/
     &                    sca1, sca2, sca3, sca4,
     &                    sox1, sox2, sox3, sox4

C      Schmidt number coefficients

      Real*8  sca1,sca2,sca3,sca4
      Real*8  sox1,sox2,sox3,sox4

      integer apco2startdate1
      integer apco2startdate2
      Real*8     apco2StartTime
      Real*8     apco2period
      Real*8     apco2RepCycle
      Real*8     apco2const
      Real*8     apco2_exfremo_intercept
      Real*8     apco2_exfremo_slope
      CHARACTER*1 apco2mask

C ==========================================================
C   Bling inputs (specified in data.bling)
C
C  bling_k0_2dFile :: File containing a 2D spatial field of light attenuation
C        coefficient (k0_2d, in m^-1). This coefficient regulates underwater
C        light availability in the BLING model. If not specified, a constant
C        value k0 (default= 0.04 m^-1) is applied for entire domain.
C ==========================================================

       COMMON /BLING_INPUTS/
     &        bling_windFile, bling_atmospFile, bling_iceFile,
     &        bling_ironFile, bling_silicaFile,
     &        bling_psmFile, bling_plgFile, bling_pdiazFile,
     &        bling_forcingPeriod, bling_forcingCycle,
     &        bling_pCO2,
     &        river_conc_po4, river_dom_to_nut,
     &        bling_Pc_2dFile, bling_Pc_2d_diazFile,
     &        bling_k0_2dFile,
     &        bling_alpha_photo2dFile,bling_phi_DOM2dFile,
     &        bling_k_Fe2dFile, bling_k_Fe_diaz2dFile,
     &        bling_gamma_POM2dFile, bling_wsink0_2dFile,
     &        bling_phi_lg2dFile, bling_phi_sm2dFile
     &       ,apco2startdate1,apco2startdate2,
     &        apco2StartTime, apco2period, apco2RepCycle,
     &        apco2const,
     &        apco2_exfremo_intercept,
     &        apco2_exfremo_slope,
     &        apco2file, apco2mask

C      bling_windFile      :: file name of wind speeds
C      bling_atmospFile    :: file name of atmospheric pressure
C      bling_iceFile       :: file name of sea ice fraction
C      bling_ironFile      :: file name of aeolian iron flux
C      bling_silicaFile    :: file name of surface silica
C      bling_psmFile       :: file name of init small phyto biomass
C      bling_plgFile       :: file name of init lg phyto biomass
C      bling_pdiazFile     :: file name of init diaz biomass
C      bling_forcingPeriod :: period of forcing for biogeochemistry (seconds)
C      bling_forcingCycle  :: periodic forcing parameter for biogeochemistry
C      bling_pCO2          :: Atmospheric pCO2 to be read in data.bling
C      river_conc_trac     :: River concentration, bgc tracers
C      apco2               :: Atmospheric pCO2 to be read in with exf pkg

      CHARACTER*(MAX_LEN_FNAM) bling_windFile
      CHARACTER*(MAX_LEN_FNAM) bling_atmospFile
      CHARACTER*(MAX_LEN_FNAM) bling_iceFile
      CHARACTER*(MAX_LEN_FNAM) bling_ironFile
      CHARACTER*(MAX_LEN_FNAM) bling_silicaFile
      CHARACTER*(MAX_LEN_FNAM) bling_psmFile
      CHARACTER*(MAX_LEN_FNAM) bling_plgFile
      CHARACTER*(MAX_LEN_FNAM) bling_pdiazFile
      CHARACTER*(MAX_LEN_FNAM) bling_k0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2d_diazFile
      CHARACTER*(MAX_LEN_FNAM) bling_alpha_photo2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe_diaz2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_gamma_POM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_wsink0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_DOM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_lg2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_sm2dFile
      CHARACTER*(MAX_LEN_FNAM) apco2file
      Real*8     bling_forcingPeriod
      Real*8     bling_forcingCycle
      Real*8     bling_pCO2
      Real*8     river_conc_po4
      Real*8     river_dom_to_nut

C ==========================================================
C   EXF input/output scaling factors for unit conversion if needed
C ==========================================================
      Real*8     exf_inscal_apco2
      Real*8     exf_outscal_apco2
      COMMON /BLG_PARAM_SCAL/
     &                    exf_inscal_apco2,
     &                    exf_outscal_apco2

C ==========================================================
C   EXF interpolation needs
C ==========================================================

C ==========================================================
C   Ecosystem variables and parameters
C ==========================================================
C     irr_mem       :: Phyto irradiance memory
C          this is a temporally smoothed field carried between timesteps,
C          to represent photoadaptation.
C   chlsat_locTimWindow(1:2) :: local-time window (in h) for
C          satellite-equivalent chlorophyll diagnostic (and cost)

      COMMON /BIOTIC_NEEDS/
     &                     InputFe,
     &                     omegaC,
     &                     omegaAr,
     &                     irr_mem,
     &                     phyto_lg,
     &                     phyto_sm,
     &                     chl,
     &                     chl_sat,
     &                     poc,
     &                     k0_2d,
     &                     Pc_0_2d,
     &                     k_Fe_2d,
     &                     wsink0_2d,
     &                     gamma_POM_2d,
     &                     phi_DOM_2d,
     &                     phi_sm_2d,
     &                     phi_lg_2d,
     &                     phyto_diaz,
     &                     Pc_0_diaz_2d,
     &                     k_Fe_diaz_2d,
     &                     alpha_photo_2d,
     &                     Pc_0_diaz,
     &                     alpha_photo,
     &                     gamma_DON,
     &                     k_Fe_diaz,
     &                     k_NO3,
     &                     k_NO3_sm,
     &                     k_NO3_lg,
     &                     k_PO4_sm,
     &                     k_PO4_lg,
     &                     k_Fe_sm,
     &                     k_Fe_lg,
     &                     k_PtoN,
     &                     k_FetoN,
     &                     PtoN_min,
     &                     PtoN_max,
     &                     FetoN_min,
     &                     FetoN_max,
     &                     kappa_eppley_diaz,
     &                     phi_dvm,
     &                     sigma_dvm,
     &                     CtoN,
     &                     CtoP,
     &                     NtoP,
     &                     HtoC,
     &                     NO3toN,
     &                     O2toN,
     &                     O2toP,
     &                     CatoN,
     &                     CatoP,
     &                     masstoN,
     &                     pivotal,
     &                     Pc_0,
     &                     lambda_0,
     &                     resp_frac,
     &                     chl_min,
     &                     theta_Fe_max_hi,
     &                     theta_Fe_max_lo,
     &                     gamma_irr_mem,
     &                     gamma_DOP,
     &                     gamma_POM,
     &                     k_O2,
     &                     k_Fe,
     &                     k_PO4,
     &                     kFe_eq_lig_max,
     &                     kFe_eq_lig_min,
     &                     kFe_eq_lig_Femin,
     &                     kFe_eq_lig_irr,
     &                     kFe_org,
     &                     kFe_inorg,
     &                     FetoC_sed,
     &                     remin_min,
     &                     oxic_min,
     &                     ligand,
     &                     kappa_eppley,
     &                     kappa_remin,
     &                     ca_remin_depth,
     &                     phi_DOM,
     &                     phi_sm,
     &                     phi_lg,
     &                     wsink0,
     &                     wsink0z,
     &                     wsinkacc,
     &                     parfrac,
     &                     alpfe,
     &                     k0,
     &                     MLmix_max,
     &                     chlsat_locTimWindow,
CAT(
     &                     swfrac_ir,
     &                     swfrac_rd,
     &                     swfrac_bg,
     &                     k0_rd,
     &                     k0_bg,
     &                     k_ir,
     &                     chi_rd,
     &                     chi_bg,
     &                     e_rd,
     &                     e_bg,
     &                     SWFrac3D
CAT)

      Real*8 InputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 omegaC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 omegaAr(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 irr_mem(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_lg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_sm(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl_sat(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 poc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 k0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 wsink0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 gamma_POM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_DOM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_sm_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_lg_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phyto_diaz(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 Pc_0_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 alpha_photo_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_diaz
      Real*8 alpha_photo
      Real*8 gamma_DON
      Real*8 k_Fe_diaz
      Real*8 k_NO3
      Real*8 k_NO3_sm
      Real*8 k_NO3_lg
      Real*8 k_PO4_sm
      Real*8 k_PO4_lg
      Real*8 k_Fe_sm
      Real*8 k_Fe_lg
      Real*8 k_PtoN
      Real*8 k_FetoN
      Real*8 PtoN_min
      Real*8 PtoN_max
      Real*8 FetoN_min
      Real*8 FetoN_max
      Real*8 kappa_eppley_diaz
      Real*8 phi_dvm
      Real*8 sigma_dvm
      Real*8 CtoN
      Real*8 CtoP
      Real*8 NtoP
      Real*8 HtoC
      Real*8 NO3toN
      Real*8 O2toN
      Real*8 O2toP
      Real*8 CatoN
      Real*8 CatoP
      Real*8 masstoN
      Real*8 pivotal
      Real*8 Pc_0
      Real*8 lambda_0
      Real*8 resp_frac
      Real*8 chl_min
      Real*8 theta_Fe_max_hi
      Real*8 theta_Fe_max_lo
      Real*8 gamma_irr_mem
      Real*8 gamma_DOP
      Real*8 gamma_POM
      Real*8 k_O2
      Real*8 k_Fe
      Real*8 k_PO4
      Real*8 kFe_eq_lig_max
      Real*8 kFe_eq_lig_min
      Real*8 kFe_eq_lig_Femin
      Real*8 kFe_eq_lig_irr
      Real*8 kFe_org
      Real*8 kFe_inorg
      Real*8 FetoC_sed
      Real*8 remin_min
      Real*8 oxic_min
      Real*8 ligand
      Real*8 kappa_eppley
      Real*8 kappa_remin
      Real*8 ca_remin_depth
      Real*8 phi_DOM
      Real*8 phi_sm
      Real*8 phi_lg
      Real*8 wsink0
      Real*8 wsink0z
      Real*8 wsinkacc
      Real*8 parfrac
      Real*8 alpfe
      Real*8 k0
      Real*8 MLmix_max
      Real*8 chlsat_locTimWindow(2)
CAT(
      Real*8 swfrac_ir(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_rd(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_bg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
C     SWFrac3D :: combined (ir+rd+bg) shortwave fraction profile,
C                 used by BLING_HEATING to penetrate Qsw in apply_forcing.F
      Real*8 SWFrac3D(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 k0_rd
      Real*8 k0_bg
      Real*8 k_ir
      Real*8 chi_rd
      Real*8 chi_bg
      Real*8 e_rd
      Real*8 e_bg
CAT)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

C     == Routine arguments ==
C       diclocal = total inorganic carbon (mol/m^3)
C             where 1 T = 1 metric ton = 1000 kg
C       ta  = total alkalinity (eq/m^3)
C       pt  = inorganic phosphate (mol/^3)
C       sit = inorganic silicate (mol/^3)
C       t   = temperature (degrees C)
C       s   = salinity (g/kg)
        Real*8  t, s, pt, sit, ta
        Real*8  pCO2surfloc, diclocal, pHlocal
        Real*8  fflocal, btlocal, stlocal, ftlocal
        Real*8  k1local, k2local
        Real*8  k1plocal, k2plocal, k3plocal
        Real*8  kslocal, kblocal, kwlocal, ksilocal, kflocal
        Real*8  k0local, fugflocal
        Real*8  co3local
        INTEGER i,j,k,bi,bj,myIter
        INTEGER myThid
CEOP

C     == Local variables ==
        Real*8  phguess
        Real*8  cag
        Real*8  bohg
        Real*8  hguess
        Real*8  stuff
        Real*8  gamm
        Real*8  hnew
        Real*8  co2s
        Real*8  h3po4g, h2po4g, hpo4g, po4g
        Real*8  siooh3g
        Real*8  fco2

c ---------------------------------------------------------------------
C Change units from the input of mol/m^3 -> mol/kg:
c (1 mol/m^3)  x (1 m^3/1024.5 kg)
c where the ocean mean surface density is 1024.5 kg/m^3
c Note: mol/kg are actually what the body of this routine uses
c for calculations.  Units are reconverted back to mol/m^3 at the
c end of this routine.
c To convert input in mol/m^3 -> mol/kg
        pt=pt*permil
        sit=sit*permil
        ta=ta*permil
        diclocal=diclocal*permil
c ---------------------------------------------------------------------
c set first guess and brackets for [H+] solvers
c first guess (for newton-raphson)
        phguess = phlocal
cmick - new approx method
cmick - make estimate of htotal (hydrogen ion conc) using
cmick   appromate estimate of CA, carbonate alkalinity
        hguess = 10.0**(-phguess)
cmick - first estimate borate contribution using guess for [H+]
        bohg = btlocal*kblocal/(hguess+kblocal)

cmick - first estimate of contribution from phosphate
cmick based on Dickson and Goyet
        stuff = hguess*hguess*hguess
     &           + (k1plocal*hguess*hguess)
     &           + (k1plocal*k2plocal*hguess)
     &           + (k1plocal*k2plocal*k3plocal)
        h3po4g = (pt*hguess*hguess*hguess) / stuff
        h2po4g = (pt*k1plocal*hguess*hguess) / stuff
        hpo4g  = (pt*k1plocal*k2plocal*hguess) / stuff
        po4g   = (pt*k1plocal*k2plocal*k3plocal) / stuff

cmick - estimate contribution from silicate
cmick based on Dickson and Goyet
        siooh3g = sit*ksilocal / (ksilocal + hguess)

cmm - rare, but ice melt can cause prescribed silicate alkalinity to be
cmm   larger than total alkalinity. Crop here to account for this
        IF (siooh3g.GT.0.2D0*ta) siooh3g = 0.2D0*ta

cmick - now estimate carbonate alkalinity
        cag = ta - bohg - (kwlocal/hguess) + hguess
     &           - hpo4g - 2.0D0*po4g + h3po4g
     &           - siooh3g
CMM(
        IF ( cag .LT. (0.1D0*ta) )  THEN
       print *,'CMMcag1', cag,i,j,k,xC(i,j,1,1),yC(i,j,1,1)
C myXGlobalLo-1+(bi-1)*sNx+i,        myYGlobalLo-1+(bj-1)*sNy+j
       print *,'CMMcag2',ta,bohg,(kwlocal/hguess),hguess,hpo4g,
     &           2.0D0*po4g,h3po4g, siooh3g
       cag = 0.1D0*ta
        ENDIF
CMM)
cmick - now evaluate better guess of hydrogen ion conc
cmick   htotal = [H+], hydrogen ion conc
        gamm  = diclocal/cag
        stuff = (1.0D0-gamm)*(1.0D0-gamm)*k1local*k1local
     &          - 4.0D0*k1local*k2local*(1.0D0-2.0D0*gamm)
        hnew  = 0.5D0*( (gamm-1.0D0)*k1local + sqrt(stuff) )
CMM(
        IF ( hnew .GT. (0.00001D0) )  THEN
cmm          print *,'CMMhnew reset:',hnew,i,j,k,xC(i,j,1,1),yC(i,j,1,1)
          hnew = 0.00000001D0
        ENDIF
        IF ( hnew .LT. (0.0000000001D0) )  THEN
cmm          print *,'CMMhnew reset:',hnew,i,j,k,xC(i,j,1,1),yC(i,j,1,1)
          hnew = 0.00000001D0
        ENDIF
CMM)
cmick - now determine [CO2*]
        co2s  = diclocal/
     &   (1.0D0 + (k1local/hnew) + (k1local*k2local/(hnew*hnew)))
cmick - return update pH to main routine
        phlocal = -log10(hnew)

c NOW EVALUATE CO32-, carbonate ion concentration
c used in determination of calcite compensation depth
c Karsten Friis & Mick - Sep 2004
        co3local = k1local*k2local*diclocal /
     &         (hnew*hnew + k1local*hnew + k1local*k2local)

c ---------------------------------------------------------------
c surface pCO2 (following Dickson and Goyet, DOE...)
        fco2 = co2s/k0local
        pco2surfloc = fco2/fugflocal

C ----------------------------------------------------------------
c Reconvert from mol/kg -> mol/m^3
        pt=pt/permil
        sit=sit/permil
        ta=ta/permil
        diclocal=diclocal/permil

        RETURN
        END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
      subroutine CARBON_COEFFS(
     I                   ttemp,stemp,
     I                   bi,bj,iMin,iMax,jMin,jMax,myThid)

C !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE CARBON_COEFFS                                 |
C     | determine coefficients for surface carbon chemistry      |
C     | adapted from OCMIP2:  SUBROUTINE CO2CALC                 |
C     | mick follows, oct 1999                                   |
C     | minor changes to tidy, swd aug 2002                      |
C     *==========================================================*
C INPUT
C       diclocal = total inorganic carbon (mol/m^3)
C             where 1 T = 1 metric ton = 1000 kg
C       ta  = total alkalinity (eq/m^3)
C       pt  = inorganic phosphate (mol/^3)
C       sit = inorganic silicate (mol/^3)
C       t   = temperature (degrees C)
C       s   = salinity (g/kg)
C OUTPUT
C IMPORTANT: Some words about units - (JCO, 4/4/1999)
C     - Models carry tracers in mol/m^3 (on a per volume basis)
C     - Conversely, this routine, which was written by observationalists
C       (C. Sabine and R. Key), passes input arguments in umol/kg
C       (i.e., on a per mass basis)
C     - I have changed things slightly so that input arguments are in mol/m^3,
C     - Thus, all input concentrations (diclocal, ta, pt, and st) should be
C       given in mol/m^3; output arguments "co2star" and "dco2star"
C       are likewise be in mol/m^3.
C
C Apr 2011: fix vapour bug (following Bennington)
C--------------------------------------------------------------------------

      IMPLICIT NONE

C     === Global variables ===
C $Header: /u/gcmpack/MITgcm_contrib/llc_hires/llc_270/code/SIZE.h,v 1.3 2015/09/29 18:07:50 zhc Exp $
C $Name:  $

C
CBOP
C    !ROUTINE: SIZE.h
C    !INTERFACE:
C    include SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SIZE.h Declare size of underlying computational grid.     
C     *==========================================================*
C     | The design here support a three-dimensional model grid    
C     | with indices I,J and K. The three-dimensional domain      
C     | is comprised of nPx*nSx blocks of size sNx along one axis 
C     | nPy*nSy blocks of size sNy along another axis and one     
C     | block of size Nz along the final axis.                    
C     | Blocks have overlap regions of size OLx and OLy along the 
C     | dimensions that are subdivided.                           
C     *==========================================================*
C     \ev
CEOP
C     Voodoo numbers controlling data layout.
C     sNx :: No. X points in sub-grid.
C     sNy :: No. Y points in sub-grid.
C     OLx :: Overlap extent in X.
C     OLy :: Overlat extent in Y.
C     nSx :: No. sub-grids in X.
C     nSy :: No. sub-grids in Y.
C     nPx :: No. of processes to use in X.
C     nPy :: No. of processes to use in Y.
C     Nx  :: No. points in X for the total domain.
C     Ny  :: No. points in Y for the total domain.
C     Nr  :: No. points in Z for full process domain.
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER (
     &           sNx = 720,
     &           sNy = 280,
     &           OLx =   8,
     &           OLy =   8,
     &           nSx =   1,
     &           nSy =   1,
     &           nPx =   1,
     &           nPy =   1,
     &           Nx  = sNx*nSx*nPx,
     &           Ny  = sNy*nSy*nPy,
     &           Nr  =  50 )

C     MAX_OLX :: Set to the maximum overlap region size of any array
C     MAX_OLY    that will be exchanged. Controls the sizing of exch
C                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx,
     &            MAX_OLY = OLy )

      INTEGER     nobcs
      PARAMETER ( nobcs = 4 )

C $Header: /u/gcmpack/MITgcm/eesupp/inc/EEPARAMS.h,v 1.36 2014/02/13 04:10:25 jmc Exp $
C $Name:  $
CBOP
C     !ROUTINE: EEPARAMS.h
C     !INTERFACE:
C     include "EEPARAMS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | EEPARAMS.h                                               |
C     *==========================================================*
C     | Parameters for "execution environemnt". These are used   |
C     | by both the particular numerical model and the execution |
C     | environment support routines.                            |
C     *==========================================================*
CEOP

C     ========  EESIZE.h  ========================================

C     MAX_LEN_MBUF  :: Default message buffer max. size
C     MAX_LEN_FNAM  :: Default file name max. size
C     MAX_LEN_PREC  :: Default rec len for reading "parameter" files

      INTEGER MAX_LEN_MBUF
      PARAMETER ( MAX_LEN_MBUF = 512 )
      INTEGER MAX_LEN_FNAM
      PARAMETER ( MAX_LEN_FNAM = 512 )
      INTEGER MAX_LEN_PREC
      PARAMETER ( MAX_LEN_PREC = 200 )

C     MAX_NO_THREADS  :: Maximum number of threads allowed.
CC    MAX_NO_PROCS    :: Maximum number of processes allowed.
CC    MAX_NO_BARRIERS :: Maximum number of distinct thread "barriers"
      INTEGER MAX_NO_THREADS
      PARAMETER ( MAX_NO_THREADS =  4 )
c     INTEGER MAX_NO_PROCS
c     PARAMETER ( MAX_NO_PROCS   =  70000 )
c     INTEGER MAX_NO_BARRIERS
c     PARAMETER ( MAX_NO_BARRIERS = 1 )

C     Particularly weird and obscure voodoo numbers
C     lShare :: This wants to be the length in
C               [148]-byte words of the size of
C               the address "window" that is snooped
C               on an SMP bus. By separating elements in
C               the global sum buffer we can avoid generating
C               extraneous invalidate traffic between
C               processors. The length of this window is usually
C               a cache line i.e. small O(64 bytes).
C               The buffer arrays are usually short arrays
C               and are declared REAL ARRA(lShare[148],LBUFF).
C               Setting lShare[148] to 1 is like making these arrays
C               one dimensional.
      INTEGER cacheLineSize
      INTEGER lShare1
      INTEGER lShare4
      INTEGER lShare8
      PARAMETER ( cacheLineSize = 256 )
      PARAMETER ( lShare1 =  cacheLineSize )
      PARAMETER ( lShare4 =  cacheLineSize/4 )
      PARAMETER ( lShare8 =  cacheLineSize/8 )

CC    MAX_VGS  :: Maximum buffer size for Global Vector Sum
c     INTEGER MAX_VGS
c     PARAMETER ( MAX_VGS = 8192 )

C     ========  EESIZE.h  ========================================

C     Symbolic values
C     precXXXX :: precision used for I/O
      INTEGER precFloat32
      PARAMETER ( precFloat32 = 32 )
      INTEGER precFloat64
      PARAMETER ( precFloat64 = 64 )

C     Real-type constant for some frequently used simple number (0,1,2,1/2):
      Real*8     zeroRS, oneRS, twoRS, halfRS
      PARAMETER ( zeroRS = 0.0D0 , oneRS  = 1.0D0 )
      PARAMETER ( twoRS  = 2.0D0 , halfRS = 0.5D0 )
      Real*8     zeroRL, oneRL, twoRL, halfRL
      PARAMETER ( zeroRL = 0.0D0 , oneRL  = 1.0D0 )
      PARAMETER ( twoRL  = 2.0D0 , halfRL = 0.5D0 )

C     UNSET_xxx :: Used to indicate variables that have not been given a value
      Real*8  UNSET_FLOAT8
      PARAMETER ( UNSET_FLOAT8 = 1.234567D5 )
      Real*4  UNSET_FLOAT4
      PARAMETER ( UNSET_FLOAT4 = 1.234567E5 )
      Real*8     UNSET_RL
      PARAMETER ( UNSET_RL     = 1.234567D5 )
      Real*8     UNSET_RS
      PARAMETER ( UNSET_RS     = 1.234567D5 )
      INTEGER UNSET_I
      PARAMETER ( UNSET_I      = 123456789  )

C     debLevX  :: used to decide when to print debug messages
      INTEGER debLevZero
      INTEGER debLevA, debLevB,  debLevC, debLevD, debLevE
      PARAMETER ( debLevZero=0 )
      PARAMETER ( debLevA=1 )
      PARAMETER ( debLevB=2 )
      PARAMETER ( debLevC=3 )
      PARAMETER ( debLevD=4 )
      PARAMETER ( debLevE=5 )

C     SQUEEZE_RIGHT      :: Flag indicating right blank space removal
C                           from text field.
C     SQUEEZE_LEFT       :: Flag indicating left blank space removal
C                           from text field.
C     SQUEEZE_BOTH       :: Flag indicating left and right blank
C                           space removal from text field.
C     PRINT_MAP_XY       :: Flag indicating to plot map as XY slices
C     PRINT_MAP_XZ       :: Flag indicating to plot map as XZ slices
C     PRINT_MAP_YZ       :: Flag indicating to plot map as YZ slices
C     commentCharacter   :: Variable used in column 1 of parameter
C                           files to indicate comments.
C     INDEX_I            :: Variable used to select an index label
C     INDEX_J               for formatted input parameters.
C     INDEX_K
C     INDEX_NONE
      CHARACTER*(*) SQUEEZE_RIGHT
      PARAMETER ( SQUEEZE_RIGHT = 'R' )
      CHARACTER*(*) SQUEEZE_LEFT
      PARAMETER ( SQUEEZE_LEFT = 'L' )
      CHARACTER*(*) SQUEEZE_BOTH
      PARAMETER ( SQUEEZE_BOTH = 'B' )
      CHARACTER*(*) PRINT_MAP_XY
      PARAMETER ( PRINT_MAP_XY = 'XY' )
      CHARACTER*(*) PRINT_MAP_XZ
      PARAMETER ( PRINT_MAP_XZ = 'XZ' )
      CHARACTER*(*) PRINT_MAP_YZ
      PARAMETER ( PRINT_MAP_YZ = 'YZ' )
      CHARACTER*(*) commentCharacter
      PARAMETER ( commentCharacter = '#' )
      INTEGER INDEX_I
      INTEGER INDEX_J
      INTEGER INDEX_K
      INTEGER INDEX_NONE
      PARAMETER ( INDEX_I    = 1,
     &            INDEX_J    = 2,
     &            INDEX_K    = 3,
     &            INDEX_NONE = 4 )

C     EXCH_IGNORE_CORNERS :: Flag to select ignoring or
C     EXCH_UPDATE_CORNERS    updating of corners during an edge exchange.
      INTEGER EXCH_IGNORE_CORNERS
      INTEGER EXCH_UPDATE_CORNERS
      PARAMETER ( EXCH_IGNORE_CORNERS = 0,
     &            EXCH_UPDATE_CORNERS = 1 )

C     FORWARD_SIMULATION
C     REVERSE_SIMULATION
C     TANGENT_SIMULATION
      INTEGER FORWARD_SIMULATION
      INTEGER REVERSE_SIMULATION
      INTEGER TANGENT_SIMULATION
      PARAMETER ( FORWARD_SIMULATION = 0,
     &            REVERSE_SIMULATION = 1,
     &            TANGENT_SIMULATION = 2 )

C--   COMMON /EEPARAMS_L/ Execution environment public logical variables.
C     eeBootError    :: Flags indicating error during multi-processing
C     eeEndError     :: initialisation and termination.
C     fatalError     :: Flag used to indicate that the model is ended with an error
C     debugMode      :: controls printing of debug msg (sequence of S/R calls).
C     useSingleCpuIO :: When useSingleCpuIO is set, MDS_WRITE_FIELD outputs from
C                       master MPI process only. -- NOTE: read from main parameter
C                       file "data" and not set until call to INI_PARMS.
C     useSingleCpuInput :: When useSingleCpuInput is set, EXF_INTERP_READ
C                       reads forcing files from master MPI process only.
C                       -- NOTE: read from main parameter file "data"
C                          and defaults to useSingleCpuInput = useSingleCpuIO
C     printMapIncludesZeros  :: Flag that controls whether character constant
C                               map code ignores exact zero values.
C     useCubedSphereExchange :: use Cubed-Sphere topology domain.
C     useCoupler     :: use Coupler for a multi-components set-up.
C     useNEST_PARENT :: use Parent Nesting interface (pkg/nest_parent)
C     useNEST_CHILD  :: use Child  Nesting interface (pkg/nest_child)
C     useOASIS       :: use OASIS-coupler for a multi-components set-up.
      COMMON /EEPARAMS_L/
c    &  eeBootError, fatalError, eeEndError,
     &  eeBootError, eeEndError, fatalError, debugMode,
     &  useSingleCpuIO, useSingleCpuInput, printMapIncludesZeros,
     &  useCubedSphereExchange, useCoupler,
     &  useNEST_PARENT, useNEST_CHILD, useOASIS,
     &  useSETRLSTK, useSIGREG
      LOGICAL eeBootError
      LOGICAL eeEndError
      LOGICAL fatalError
      LOGICAL debugMode
      LOGICAL useSingleCpuIO
      LOGICAL useSingleCpuInput
      LOGICAL printMapIncludesZeros
      LOGICAL useCubedSphereExchange
      LOGICAL useCoupler
      LOGICAL useNEST_PARENT
      LOGICAL useNEST_CHILD
      LOGICAL useOASIS
      LOGICAL useSETRLSTK
      LOGICAL useSIGREG

C--   COMMON /EPARAMS_I/ Execution environment public integer variables.
C     errorMessageUnit    :: Fortran IO unit for error messages
C     standardMessageUnit :: Fortran IO unit for informational messages
C     maxLengthPrt1D :: maximum length for printing (to Std-Msg-Unit) 1-D array
C     scrUnit1      :: Scratch file 1 unit number
C     scrUnit2      :: Scratch file 2 unit number
C     eeDataUnit    :: Unit # for reading "execution environment" parameter file
C     modelDataUnit :: Unit number for reading "model" parameter file.
C     numberOfProcs :: Number of processes computing in parallel
C     pidIO         :: Id of process to use for I/O.
C     myBxLo, myBxHi :: Extents of domain in blocks in X and Y
C     myByLo, myByHi :: that each threads is responsble for.
C     myProcId      :: My own "process" id.
C     myPx          :: My X coord on the proc. grid.
C     myPy          :: My Y coord on the proc. grid.
C     myXGlobalLo   :: My bottom-left (south-west) x-index global domain.
C                      The x-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     myYGlobalLo   :: My bottom-left (south-west) y-index in global domain.
C                      The y-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     nThreads      :: No. of threads
C     nTx, nTy      :: No. of threads in X and in Y
C                      This assumes a simple cartesian gridding of the threads
C                      which is not required elsewhere but that makes it easier
C     ioErrorCount  :: IO Error Counter. Set to zero initially and increased
C                      by one every time an IO error occurs.
      COMMON /EEPARAMS_I/
     &  errorMessageUnit, standardMessageUnit, maxLengthPrt1D,
     &  scrUnit1, scrUnit2, eeDataUnit, modelDataUnit,
     &  numberOfProcs, pidIO, myProcId,
     &  myPx, myPy, myXGlobalLo, myYGlobalLo, nThreads,
     &  myBxLo, myBxHi, myByLo, myByHi,
     &  nTx, nTy, ioErrorCount
      INTEGER errorMessageUnit
      INTEGER standardMessageUnit
      INTEGER maxLengthPrt1D
      INTEGER scrUnit1
      INTEGER scrUnit2
      INTEGER eeDataUnit
      INTEGER modelDataUnit
      INTEGER ioErrorCount(MAX_NO_THREADS)
      INTEGER myBxLo(MAX_NO_THREADS)
      INTEGER myBxHi(MAX_NO_THREADS)
      INTEGER myByLo(MAX_NO_THREADS)
      INTEGER myByHi(MAX_NO_THREADS)
      INTEGER myProcId
      INTEGER myPx
      INTEGER myPy
      INTEGER myXGlobalLo
      INTEGER myYGlobalLo
      INTEGER nThreads
      INTEGER nTx
      INTEGER nTy
      INTEGER numberOfProcs
      INTEGER pidIO

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c#include "PARAMS.h"
C $Header: /u/gcmpack/MITgcm/model/inc/GRID.h,v 1.43 2013/07/26 14:20:01 jmc Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: GRID.h
C    !INTERFACE:
C    include GRID.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID.h
C     | o Header file defining model grid.
C     *==========================================================*
C     | Model grid is defined for each process by reference to
C     | the arrays set here.
C     | Notes
C     | =====
C     | The standard MITgcm convention of westmost, southern most
C     | and upper most having the (1,1,1) index is used here.
C     | i.e.
C     |----------------------------------------------------------
C     | (1)  Plan view schematic of model grid (top layer i.e. )
C     |      ================================= ( ocean surface )
C     |                                        ( or top of     )
C     |                                        ( atmosphere    )
C     |      This diagram shows the location of the model
C     |      prognostic variables on the model grid. The "T"
C     |      location is used for all tracers. The figure also
C     |      shows the southern most, western most indexing
C     |      convention that is used for all model variables.
C     |
C     |
C     |             V(i=1,                     V(i=Nx,
C     |               j=Ny+1,                    j=Ny+1,
C     |               k=1)                       k=1)
C     |                /|\                       /|\  "PWX"
C     |       |---------|------------------etc..  |---- *---
C     |       |                     |                   *  |
C     |"PWY"*******************************etc..  **********"PWY"
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *==>U
C     |  j=Ny,|      T(i=1,         |          T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=Ny,        |            j=Ny,  *  |j=Ny,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *  |
C     |  j=2, |      T(i=1,         |          T(i=Nx,  *  |
C     |  k=1) |        j=2,         |            j=2,   *  |
C     |       |        k=1)         |            k=1)   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |      -----------|------------------etc..  |-----*---
C     |       |       V(i=1,        |           V(i=Nx, *  |
C     |       |         j=2,        |             j=2,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |"SB"++>|---------|------------------etc..  |-----*---
C     |      /+\      V(i=1,                    V(i=Nx, *
C     |       +         j=1,                      j=1,  *
C     |       +         k=1)                      k=1)  *
C     |     "WB"                                      "PWX"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     |    V: y-velocity (m/s)
C     |    T: potential temperature (oC)
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |----------------------------------------------------------
C     | (2) South elevation schematic of model grid
C     |     =======================================
C     |     This diagram shows the location of the model
C     |     prognostic variables on the model grid. The "T"
C     |     location is used for all tracers. The figure also
C     |     shows the upper most, western most indexing
C     |     convention that is used for all model variables.
C     |
C     |      "WB"
C     |       +
C     |       +
C     |      \+/       /|\                       /|\       .
C     |"UB"++>|-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=2)        |             k=2)  *  |
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=Nr)       |             k=Nr) *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=Nr)|        j=1,         |  k=Nr)     j=1,   *  |j=1,
C     |       |        k=Nr)        |            k=Nr)  *  |k=Nr)
C     |       |                     |                   *  |
C     |"LB"++>==============================================
C     |                                               "PWX"
C     |
C     | Up   increasing upwards.
C     |/|\                                                       .
C     | |
C     | |
C     | =====> E  i increasing eastwards
C     | |         x increasing eastwards
C     | |
C     |\|/
C     | Down,k increasing downwards.
C     |
C     | Note: r => height (m) => r increases upwards
C     |       r => pressure (Pa) => r increases downwards
C     |
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     | rVel: z-velocity ( units of r )
C     |       The vertical velocity variable rVel is in units of
C     |       "r" the vertical coordinate. r in m will give
C     |       rVel m/s. r in Pa will give rVel Pa/s.
C     |    T: potential temperature (oC)
C     | "UB": Upper boundary.
C     | "LB": Lower boundary (always solid - therefore om|w == 0)
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |----------------------------------------------------------
C     | (3) Views showing nomenclature and indexing
C     |     for grid descriptor variables.
C     |
C     |      Fig 3a. shows the orientation, indexing and
C     |      notation for the grid spacing terms used internally
C     |      for the evaluation of gradient and averaging terms.
C     |      These varaibles are set based on the model input
C     |      parameters which define the model grid in terms of
C     |      spacing in X, Y and Z.
C     |
C     |      Fig 3b. shows the orientation, indexing and
C     |      notation for the variables that are used to define
C     |      the model grid. These varaibles are set directly
C     |      from the model input.
C     |
C     | Figure 3a
C     | =========
C     |       |------------------------------------
C     |       |                       |
C     |"PWY"********************************* etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v----------|-
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       u<--dxF(i=1,j=2,k=1)--->u           t          |
C     |       |/|\       /|\          |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       |dyU(i=1,  dyC(i=1,     |                      |
C     | ---  ---|--j=2,---|--j=2,-----------------v----------|-
C     | /|\   | |  k=1)   |  k=1)     |          /|\         |
C     |  |    | |         |           |          dyF(i=2,    |
C     |  |    | |         |           |           |  j=1,    |
C     |dyG(   |\|/       \|/          |           |  k=1)    |
C     |   i=1,u---        t<---dxC(i=2,j=1,k=1)-->t          |
C     |   j=1,|                       |           |          |
C     |   k=1)|                       |           |          |
C     |  |    |                       |           |          |
C     |  |    |                       |           |          |
C     | \|/   |           |<---dxV(i=2,j=1,k=1)--\|/         |
C     |"SB"++>|___________v___________|___________v__________|_
C     |       <--dxG(i=1,j=1,k=1)----->
C     |      /+\                                              .
C     |       +
C     |       +
C     |     "WB"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    u: x-velocity point
C     |    V: y-velocity point
C     |    t: tracer point
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |
C     | Figure 3b
C     | =========
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v--etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       u<--delX(i=1)---------->u           t
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |-----------v-----------------------v--etc...
C     |       |          /|\          |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       u        delY(j=1)      |           t
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |          \|/          |
C     |"SB"++>|___________v___________|___________v__etc...
C     |      /+\                                                 .
C     |       +
C     |       +
C     |     "WB"
C     |
C     *==========================================================*
C     \ev
CEOP

C     Macros that override/modify standard definitions
C $Header: /u/gcmpack/MITgcm/model/inc/GRID_MACROS.h,v 1.13 2013/08/11 14:27:37 jmc Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: GRID_MACROS.h
C    !INTERFACE:
C    include GRID_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID_MACROS.h
C     *==========================================================*
C     | These macros are used to substitute definitions for
C     | GRID.h variables for particular configurations.
C     | In setting these variables the following convention
C     | applies.
C     | undef  phi_CONST   - Indicates the variable phi is fixed
C     |                      in X, Y and Z.
C     | undef  phi_FX      - Indicates the variable phi only
C     |                      varies in X (i.e.not in X or Z).
C     | undef  phi_FY      - Indicates the variable phi only
C     |                      varies in Y (i.e.not in X or Z).
C     | undef  phi_FXY     - Indicates the variable phi only
C     |                      varies in X and Y ( i.e. not Z).
C     *==========================================================*
C     \ev
CEOP

C $Header: /u/gcmpack/MITgcm/model/inc/DXC_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXC_MACROS.h
C    !INTERFACE:
C    include DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXF_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXF_MACROS.h
C    !INTERFACE:
C    include DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXG_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXG_MACROS.h
C    !INTERFACE:
C    include DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXV_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXV_MACROS.h
C    !INTERFACE:
C    include DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXV_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYC_MACROS.h
C    !INTERFACE:
C    include DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYF_MACROS.h
C    !INTERFACE:
C    include DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYG_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYG_MACROS.h
C    !INTERFACE:
C    include DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYU_MACROS.h
C    !INTERFACE:
C    include DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYU_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/HFACC_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACC_MACROS.h
C    !INTERFACE:
C    include HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACC_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/HFACS_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACS_MACROS.h
C    !INTERFACE:
C    include HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/HFACW_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACW_MACROS.h
C    !INTERFACE:
C    include HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXC_MACROS.h
C    !INTERFACE:
C    include RECIP_DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXF_MACROS.h
C    !INTERFACE:
C    include RECIP_DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXG_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXG_MACROS.h
C    !INTERFACE:
C    include RECIP_DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXV_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXV_MACROS.h
C    !INTERFACE:
C    include RECIP_DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYC_MACROS.h
C    !INTERFACE:
C    include RECIP_DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYF_MACROS.h
C    !INTERFACE:
C    include RECIP_DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYG_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYG_MACROS.h
C    !INTERFACE:
C    include RECIP_DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYU_MACROS.h
C    !INTERFACE:
C    include RECIP_DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACC_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACC_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACC_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACS_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACS_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACS_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACW_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACW_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACW_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/XC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: XC_MACROS.h
C    !INTERFACE:
C    include XC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | XC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/YC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: YC_MACROS.h
C    !INTERFACE:
C    include YC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | YC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RA_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RA_MACROS.h
C    !INTERFACE:
C    include RA_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RA_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C $Header: /u/gcmpack/MITgcm/model/inc/RAW_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RAW_MACROS.h
C    !INTERFACE:
C    include RAW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAW_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C $Header: /u/gcmpack/MITgcm/model/inc/RAS_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RAS_MACROS.h
C    !INTERFACE:
C    include RAS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAS_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/MASKW_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: MASKW_MACROS.h
C    !INTERFACE:
C    include MASKW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C $Header: /u/gcmpack/MITgcm/model/inc/MASKS_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: MASKS_MACROS.h
C    !INTERFACE:
C    include MASKS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C $Header: /u/gcmpack/MITgcm/model/inc/TANPHIATU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: TANPHIATU_MACROS.h
C    !INTERFACE:
C    include TANPHIATU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/TANPHIATV_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: TANPHIATV_MACROS.h
C    !INTERFACE:
C    include TANPHIATV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/FCORI_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: FCORI_MACROS.h
C    !INTERFACE:
C    include FCORI_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | FCORI_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C--   COMMON /GRID_RL/ RL valued grid defining variables.
C     deepFacC  :: deep-model grid factor (fct of vertical only) for dx,dy
C     deepFacF     at level-center (deepFacC)  and level interface (deepFacF)
C     deepFac2C :: deep-model grid factor (fct of vertical only) for area dx*dy
C     deepFac2F    at level-center (deepFac2C) and level interface (deepFac2F)
C     gravitySign :: indicates the direction of gravity relative to R direction
C                   (= -1 for R=Z (Z increases upward, -gravity direction  )
C                   (= +1 for R=P (P increases downward, +gravity direction)
C     rkSign     :: Vertical coordinate to vertical index orientation.
C                   ( +1 same orientation, -1 opposite orientation )
C     globalArea :: Domain Integrated horizontal Area [m2]
      COMMON /GRID_RL/
     &  cosFacU, cosFacV, sqCosFacU, sqCosFacV,
     &  deepFacC, deepFac2C, recip_deepFacC, recip_deepFac2C,
     &  deepFacF, deepFac2F, recip_deepFacF, recip_deepFac2F,
     &  gravitySign, rkSign, globalArea
      Real*8 cosFacU        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 cosFacV        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacU      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacV      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 deepFacC       (Nr)
      Real*8 deepFac2C      (Nr)
      Real*8 deepFacF       (Nr+1)
      Real*8 deepFac2F      (Nr+1)
      Real*8 recip_deepFacC (Nr)
      Real*8 recip_deepFac2C(Nr)
      Real*8 recip_deepFacF (Nr+1)
      Real*8 recip_deepFac2F(Nr+1)
      Real*8 gravitySign
      Real*8 rkSign
      Real*8 globalArea

C--   COMMON /GRID_RS/ RS valued grid defining variables.
C     dxC     :: Cell center separation in X across western cell wall (m)
C     dxG     :: Cell face separation in X along southern cell wall (m)
C     dxF     :: Cell face separation in X thru cell center (m)
C     dxV     :: V-point separation in X across south-west corner of cell (m)
C     dyC     :: Cell center separation in Y across southern cell wall (m)
C     dyG     :: Cell face separation in Y along western cell wall (m)
C     dyF     :: Cell face separation in Y thru cell center (m)
C     dyU     :: U-point separation in Y across south-west corner of cell (m)
C     drC     :: Cell center separation along Z axis ( units of r ).
C     drF     :: Cell face separation along Z axis ( units of r ).
C     R_low   :: base of fluid in r_unit (Depth(m) / Pressure(Pa) at top Atmos.)
C     rLowW   :: base of fluid column in r_unit at Western  edge location.
C     rLowS   :: base of fluid column in r_unit at Southern edge location.
C     Ro_surf :: surface reference (at rest) position, r_unit.
C     rSurfW  :: surface reference position at Western  edge location [r_unit].
C     rSurfS  :: surface reference position at Southern edge location [r_unit].
C     hFac    :: Fraction of cell in vertical which is open i.e how
C              "lopped" a cell is (dimensionless scale factor).
C              Note: The code needs terms like MIN(hFac,hFac(I-1))
C                    On some platforms it may be better to precompute
C                    hFacW, hFacS, ... here than do MIN on the fly.
C     maskInC :: Cell Center 2-D Interior mask (i.e., zero beyond OB)
C     maskInW :: West  face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskInS :: South face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskC   :: cell Center land mask
C     maskW   :: West face land mask
C     maskS   :: South face land mask
C     recip_dxC   :: Reciprocal of dxC
C     recip_dxG   :: Reciprocal of dxG
C     recip_dxF   :: Reciprocal of dxF
C     recip_dxV   :: Reciprocal of dxV
C     recip_dyC   :: Reciprocal of dxC
C     recip_dyG   :: Reciprocal of dyG
C     recip_dyF   :: Reciprocal of dyF
C     recip_dyU   :: Reciprocal of dyU
C     recip_drC   :: Reciprocal of drC
C     recip_drF   :: Reciprocal of drF
C     recip_Rcol  :: Inverse of cell center column thickness (1/r_unit)
C     recip_hFacC :: Inverse of cell open-depth f[X,Y,Z] ( dimensionless ).
C     recip_hFacW    rhFacC center, rhFacW west, rhFacS south.
C     recip_hFacS    Note: This is precomputed here because it involves division.
C     xC        :: X-coordinate of cell center f[X,Y]. The units of xc, yc
C                  depend on the grid. They are not used in differencing or
C                  averaging but are just a convient quantity for I/O,
C                  diagnostics etc.. As such xc is in m for cartesian
C                  coordinates but degrees for spherical polar.
C     yC        :: Y-coordinate of center of cell f[X,Y].
C     yG        :: Y-coordinate of corner of cell ( c-grid vorticity point) f[X,Y].
C     rA        :: R-face are f[X,Y] ( m^2 ).
C                  Note: In a cartesian framework rA is simply dx*dy,
C                      however we use rA to allow for non-globally
C                      orthogonal coordinate frames (with appropriate
C                      metric terms).
C     rC        :: R-coordinate of center of cell f[Z] (units of r).
C     rF        :: R-coordinate of face of cell f[Z] (units of r).
C - *HybSigm* - :: Hybrid-Sigma vert. Coord coefficients
C     aHybSigmF    at level-interface (*HybSigmF) and level-center (*HybSigmC)
C     aHybSigmC    aHybSigm* = constant r part, bHybSigm* = sigma part, such as
C     bHybSigmF    r(ij,k,t) = rLow(ij) + aHybSigm(k)*[rF(1)-rF(Nr+1)]
C     bHybSigmC              + bHybSigm(k)*[eta(ij,t)+Ro_surf(ij) - rLow(ij)]
C     dAHybSigF :: vertical increment of Hybrid-Sigma coefficient: constant r part,
C     dAHybSigC    between interface (dAHybSigF) and between center (dAHybSigC)
C     dBHybSigF :: vertical increment of Hybrid-Sigma coefficient: sigma part,
C     dBHybSigC    between interface (dBHybSigF) and between center (dBHybSigC)
C     tanPhiAtU :: tan of the latitude at U point. Used for spherical polar
C                  metric term in U equation.
C     tanPhiAtV :: tan of the latitude at V point. Used for spherical polar
C                  metric term in V equation.
C     angleCosC :: cosine of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     angleSinC :: sine   of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     u2zonDir  :: cosine of grid orientation angle at U point location
C     v2zonDir  :: minus sine of  orientation angle at V point location
C     fCori     :: Coriolis parameter at grid Center point
C     fCoriG    :: Coriolis parameter at grid Corner point
C     fCoriCos  :: Coriolis Cos(phi) parameter at grid Center point (for NH)

      COMMON /GRID_RS/
     &  dxC,dxF,dxG,dxV,dyC,dyF,dyG,dyU,
     &  R_low, rLowW, rLowS,
     &  Ro_surf, rSurfW, rSurfS,
     &  hFacC, hFacW, hFacS,
     &  recip_dxC,recip_dxF,recip_dxG,recip_dxV,
     &  recip_dyC,recip_dyF,recip_dyG,recip_dyU,
     &  recip_Rcol,
     &  recip_hFacC,recip_hFacW,recip_hFacS,
     &  xC,yC,rA,rAw,rAs,rAz,xG,yG,
     &  maskInC, maskInW, maskInS,
     &  maskC, maskW, maskS,
     &  recip_rA,recip_rAw,recip_rAs,recip_rAz,
     &  drC, drF, recip_drC, recip_drF, rC, rF,
     &  aHybSigmF, bHybSigmF, aHybSigmC, bHybSigmC,
     &  dAHybSigF, dBHybSigF, dBHybSigC, dAHybSigC,
     &  tanPhiAtU, tanPhiAtV,
     &  angleCosC, angleSinC, u2zonDir, v2zonDir,
     &  fCori, fCoriG, fCoriCos
      Real*8 dxC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxV            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyU            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 R_low          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Ro_surf        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfW         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfS         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hFacC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_dxC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_Rcol     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_hFacC    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacW    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacS    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 xC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 xG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rA             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAw            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAs            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAz            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAw      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAs      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAz      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInC        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInW        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInS        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 drC            (Nr+1)
      Real*8 drF            (Nr)
      Real*8 recip_drC      (Nr+1)
      Real*8 recip_drF      (Nr)
      Real*8 rC             (Nr)
      Real*8 rF             (Nr+1)
      Real*8 aHybSigmF      (Nr+1)
      Real*8 bHybSigmF      (Nr+1)
      Real*8 aHybSigmC      (Nr)
      Real*8 bHybSigmC      (Nr)
      Real*8 dAHybSigF      (Nr)
      Real*8 dBHybSigF      (Nr)
      Real*8 dBHybSigC      (Nr+1)
      Real*8 dAHybSigC      (Nr+1)
      Real*8 tanPhiAtU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tanPhiAtV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleCosC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleSinC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 u2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 v2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCori          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriG         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriCos       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


C--   COMMON /GRID_I/ INTEGER valued grid defining variables.
C     kSurfC  :: vertical index of the surface tracer cell
C     kSurfW  :: vertical index of the surface U point
C     kSurfS  :: vertical index of the surface V point
C     kLowC   :: index of the r-lowest "wet cell" (2D)
C IMPORTANT: kSurfC,W,S = Nr+1 and kLowC = 0 where the fluid column
C            is empty (continent)
      COMMON /GRID_I/
     &  kSurfC, kSurfW, kSurfS,
     &  kLowC
      INTEGER kSurfC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfW(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kLowC (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
c#include "DYNVARS.h"
c#include "FFIELDS.h"
C ==========================================================
C   Carbon chemistry variables
C ==========================================================

       COMMON /CARBON_NEEDS/
     &                      apCO2, AtmosP, pH, pCO2, FluxCO2,
     &                      wind, FIce, Silica
     &                      , apco20, apco21
      Real*8  apCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  AtmosP(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pH(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  pCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FluxCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  wind(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FIce(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Silica(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco20(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco21(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C ==========================================================
C   Carbon and oxygen chemistry parameters
C ==========================================================

       COMMON /CARBON_CHEM/
     &                     ak0,ak1,ak2,akw,akb,aks,akf,
     &                     ak1p,ak2p,ak3p,aksi,fugf,
     &                     ff,ft,st,bt,
     &                     Ksp_TP_Calc,Ksp_TP_Arag
      Real*8  ak0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akw(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akb(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aks(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak3p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aksi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ff(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  fugf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ft(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  st(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  bt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Calc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Arag(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


       COMMON /OXYGEN_CHEM/
     &                     oA0,oA1,oA2,oA3,oA4,oA5,
     &                     oB0,oB1,oB2,oB3,
     &                     oC0
      Real*8 oA0,oA1,oA2,oA3,oA4,oA5
      Real*8 oB0,oB1,oB2,oB3
      Real*8 oC0

       COMMON /GLOBAL_SURF_MEAN/
     &                          permil,Pa2Atm,epsln

C      permil : is conversion factor for mol/m3 to mol/kg
C               assumes uniform (surface) density
C      Pa2Atm : for conversion of atmospheric pressure
C               when coming from atmospheric model

      Real*8  permil
      Real*8  Pa2Atm
      Real*8  epsln

       COMMON /SCHMIDT_NO/
     &                    sca1, sca2, sca3, sca4,
     &                    sox1, sox2, sox3, sox4

C      Schmidt number coefficients

      Real*8  sca1,sca2,sca3,sca4
      Real*8  sox1,sox2,sox3,sox4

      integer apco2startdate1
      integer apco2startdate2
      Real*8     apco2StartTime
      Real*8     apco2period
      Real*8     apco2RepCycle
      Real*8     apco2const
      Real*8     apco2_exfremo_intercept
      Real*8     apco2_exfremo_slope
      CHARACTER*1 apco2mask

C ==========================================================
C   Bling inputs (specified in data.bling)
C
C  bling_k0_2dFile :: File containing a 2D spatial field of light attenuation
C        coefficient (k0_2d, in m^-1). This coefficient regulates underwater
C        light availability in the BLING model. If not specified, a constant
C        value k0 (default= 0.04 m^-1) is applied for entire domain.
C ==========================================================

       COMMON /BLING_INPUTS/
     &        bling_windFile, bling_atmospFile, bling_iceFile,
     &        bling_ironFile, bling_silicaFile,
     &        bling_psmFile, bling_plgFile, bling_pdiazFile,
     &        bling_forcingPeriod, bling_forcingCycle,
     &        bling_pCO2,
     &        river_conc_po4, river_dom_to_nut,
     &        bling_Pc_2dFile, bling_Pc_2d_diazFile,
     &        bling_k0_2dFile,
     &        bling_alpha_photo2dFile,bling_phi_DOM2dFile,
     &        bling_k_Fe2dFile, bling_k_Fe_diaz2dFile,
     &        bling_gamma_POM2dFile, bling_wsink0_2dFile,
     &        bling_phi_lg2dFile, bling_phi_sm2dFile
     &       ,apco2startdate1,apco2startdate2,
     &        apco2StartTime, apco2period, apco2RepCycle,
     &        apco2const,
     &        apco2_exfremo_intercept,
     &        apco2_exfremo_slope,
     &        apco2file, apco2mask

C      bling_windFile      :: file name of wind speeds
C      bling_atmospFile    :: file name of atmospheric pressure
C      bling_iceFile       :: file name of sea ice fraction
C      bling_ironFile      :: file name of aeolian iron flux
C      bling_silicaFile    :: file name of surface silica
C      bling_psmFile       :: file name of init small phyto biomass
C      bling_plgFile       :: file name of init lg phyto biomass
C      bling_pdiazFile     :: file name of init diaz biomass
C      bling_forcingPeriod :: period of forcing for biogeochemistry (seconds)
C      bling_forcingCycle  :: periodic forcing parameter for biogeochemistry
C      bling_pCO2          :: Atmospheric pCO2 to be read in data.bling
C      river_conc_trac     :: River concentration, bgc tracers
C      apco2               :: Atmospheric pCO2 to be read in with exf pkg

      CHARACTER*(MAX_LEN_FNAM) bling_windFile
      CHARACTER*(MAX_LEN_FNAM) bling_atmospFile
      CHARACTER*(MAX_LEN_FNAM) bling_iceFile
      CHARACTER*(MAX_LEN_FNAM) bling_ironFile
      CHARACTER*(MAX_LEN_FNAM) bling_silicaFile
      CHARACTER*(MAX_LEN_FNAM) bling_psmFile
      CHARACTER*(MAX_LEN_FNAM) bling_plgFile
      CHARACTER*(MAX_LEN_FNAM) bling_pdiazFile
      CHARACTER*(MAX_LEN_FNAM) bling_k0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2d_diazFile
      CHARACTER*(MAX_LEN_FNAM) bling_alpha_photo2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe_diaz2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_gamma_POM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_wsink0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_DOM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_lg2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_sm2dFile
      CHARACTER*(MAX_LEN_FNAM) apco2file
      Real*8     bling_forcingPeriod
      Real*8     bling_forcingCycle
      Real*8     bling_pCO2
      Real*8     river_conc_po4
      Real*8     river_dom_to_nut

C ==========================================================
C   EXF input/output scaling factors for unit conversion if needed
C ==========================================================
      Real*8     exf_inscal_apco2
      Real*8     exf_outscal_apco2
      COMMON /BLG_PARAM_SCAL/
     &                    exf_inscal_apco2,
     &                    exf_outscal_apco2

C ==========================================================
C   EXF interpolation needs
C ==========================================================

C ==========================================================
C   Ecosystem variables and parameters
C ==========================================================
C     irr_mem       :: Phyto irradiance memory
C          this is a temporally smoothed field carried between timesteps,
C          to represent photoadaptation.
C   chlsat_locTimWindow(1:2) :: local-time window (in h) for
C          satellite-equivalent chlorophyll diagnostic (and cost)

      COMMON /BIOTIC_NEEDS/
     &                     InputFe,
     &                     omegaC,
     &                     omegaAr,
     &                     irr_mem,
     &                     phyto_lg,
     &                     phyto_sm,
     &                     chl,
     &                     chl_sat,
     &                     poc,
     &                     k0_2d,
     &                     Pc_0_2d,
     &                     k_Fe_2d,
     &                     wsink0_2d,
     &                     gamma_POM_2d,
     &                     phi_DOM_2d,
     &                     phi_sm_2d,
     &                     phi_lg_2d,
     &                     phyto_diaz,
     &                     Pc_0_diaz_2d,
     &                     k_Fe_diaz_2d,
     &                     alpha_photo_2d,
     &                     Pc_0_diaz,
     &                     alpha_photo,
     &                     gamma_DON,
     &                     k_Fe_diaz,
     &                     k_NO3,
     &                     k_NO3_sm,
     &                     k_NO3_lg,
     &                     k_PO4_sm,
     &                     k_PO4_lg,
     &                     k_Fe_sm,
     &                     k_Fe_lg,
     &                     k_PtoN,
     &                     k_FetoN,
     &                     PtoN_min,
     &                     PtoN_max,
     &                     FetoN_min,
     &                     FetoN_max,
     &                     kappa_eppley_diaz,
     &                     phi_dvm,
     &                     sigma_dvm,
     &                     CtoN,
     &                     CtoP,
     &                     NtoP,
     &                     HtoC,
     &                     NO3toN,
     &                     O2toN,
     &                     O2toP,
     &                     CatoN,
     &                     CatoP,
     &                     masstoN,
     &                     pivotal,
     &                     Pc_0,
     &                     lambda_0,
     &                     resp_frac,
     &                     chl_min,
     &                     theta_Fe_max_hi,
     &                     theta_Fe_max_lo,
     &                     gamma_irr_mem,
     &                     gamma_DOP,
     &                     gamma_POM,
     &                     k_O2,
     &                     k_Fe,
     &                     k_PO4,
     &                     kFe_eq_lig_max,
     &                     kFe_eq_lig_min,
     &                     kFe_eq_lig_Femin,
     &                     kFe_eq_lig_irr,
     &                     kFe_org,
     &                     kFe_inorg,
     &                     FetoC_sed,
     &                     remin_min,
     &                     oxic_min,
     &                     ligand,
     &                     kappa_eppley,
     &                     kappa_remin,
     &                     ca_remin_depth,
     &                     phi_DOM,
     &                     phi_sm,
     &                     phi_lg,
     &                     wsink0,
     &                     wsink0z,
     &                     wsinkacc,
     &                     parfrac,
     &                     alpfe,
     &                     k0,
     &                     MLmix_max,
     &                     chlsat_locTimWindow,
CAT(
     &                     swfrac_ir,
     &                     swfrac_rd,
     &                     swfrac_bg,
     &                     k0_rd,
     &                     k0_bg,
     &                     k_ir,
     &                     chi_rd,
     &                     chi_bg,
     &                     e_rd,
     &                     e_bg,
     &                     SWFrac3D
CAT)

      Real*8 InputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 omegaC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 omegaAr(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 irr_mem(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_lg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_sm(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl_sat(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 poc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 k0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 wsink0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 gamma_POM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_DOM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_sm_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_lg_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phyto_diaz(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 Pc_0_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 alpha_photo_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_diaz
      Real*8 alpha_photo
      Real*8 gamma_DON
      Real*8 k_Fe_diaz
      Real*8 k_NO3
      Real*8 k_NO3_sm
      Real*8 k_NO3_lg
      Real*8 k_PO4_sm
      Real*8 k_PO4_lg
      Real*8 k_Fe_sm
      Real*8 k_Fe_lg
      Real*8 k_PtoN
      Real*8 k_FetoN
      Real*8 PtoN_min
      Real*8 PtoN_max
      Real*8 FetoN_min
      Real*8 FetoN_max
      Real*8 kappa_eppley_diaz
      Real*8 phi_dvm
      Real*8 sigma_dvm
      Real*8 CtoN
      Real*8 CtoP
      Real*8 NtoP
      Real*8 HtoC
      Real*8 NO3toN
      Real*8 O2toN
      Real*8 O2toP
      Real*8 CatoN
      Real*8 CatoP
      Real*8 masstoN
      Real*8 pivotal
      Real*8 Pc_0
      Real*8 lambda_0
      Real*8 resp_frac
      Real*8 chl_min
      Real*8 theta_Fe_max_hi
      Real*8 theta_Fe_max_lo
      Real*8 gamma_irr_mem
      Real*8 gamma_DOP
      Real*8 gamma_POM
      Real*8 k_O2
      Real*8 k_Fe
      Real*8 k_PO4
      Real*8 kFe_eq_lig_max
      Real*8 kFe_eq_lig_min
      Real*8 kFe_eq_lig_Femin
      Real*8 kFe_eq_lig_irr
      Real*8 kFe_org
      Real*8 kFe_inorg
      Real*8 FetoC_sed
      Real*8 remin_min
      Real*8 oxic_min
      Real*8 ligand
      Real*8 kappa_eppley
      Real*8 kappa_remin
      Real*8 ca_remin_depth
      Real*8 phi_DOM
      Real*8 phi_sm
      Real*8 phi_lg
      Real*8 wsink0
      Real*8 wsink0z
      Real*8 wsinkacc
      Real*8 parfrac
      Real*8 alpfe
      Real*8 k0
      Real*8 MLmix_max
      Real*8 chlsat_locTimWindow(2)
CAT(
      Real*8 swfrac_ir(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_rd(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_bg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
C     SWFrac3D :: combined (ir+rd+bg) shortwave fraction profile,
C                 used by BLING_HEATING to penetrate Qsw in apply_forcing.F
      Real*8 SWFrac3D(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 k0_rd
      Real*8 k0_bg
      Real*8 k_ir
      Real*8 chi_rd
      Real*8 chi_bg
      Real*8 e_rd
      Real*8 e_bg
CAT)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

C     == Routine arguments ==
C ttemp and stemp are local theta and salt arrays
C dont really need to pass T and S in, could use theta, salt in
C common block in DYNVARS.h, but this way keeps subroutine more
C general
        Real*8  ttemp(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
        Real*8  stemp(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
        INTEGER bi,bj,iMin,iMax,jMin,jMax
        INTEGER myThid
CEOP

C LOCAL VARIABLES
        Real*8  t
        Real*8  s
        Real*8  tk
        Real*8  tk100
        Real*8  tk1002
        Real*8  dlogtk
        Real*8  sqrtis
        Real*8  sqrts
        Real*8  s15
        Real*8  scl
        Real*8  s2
        Real*8  invtk
        Real*8  is
        Real*8  is2
c add Bennington
        Real*8  P1atm
        Real*8  Rgas
        Real*8  RT
        Real*8  delta
        Real*8  B1
        Real*8  B
        INTEGER i
        INTEGER j

C.....................................................................
C OCMIP note:
C Calculate all constants needed to convert between various measured
C carbon species. References for each equation are noted in the code.
C Once calculated, the constants are
C stored and passed in the common block "const". The original version
C of this code was based on the code by dickson in Version 2 of
C  Handbook of Methods C for the Analysis of the Various Parameters of
C the Carbon Dioxide System in Seawater , DOE, 1994 (SOP No. 3, p25-26).
C....................................................................

        do i=imin,imax
         do j=jmin,jmax
          if (hFacC(i,j,1,bi,bj).gt.0.D0) then
           t = ttemp(i,j)
           s = stemp(i,j)
C terms used more than once for:
C temperature
           tk = 273.15D0 + t
           tk100 = tk/100.D0
           tk1002=tk100*tk100
           invtk=1.0D0/tk
           dlogtk=log(tk)
C ionic strength
           is=19.924D0*s/(1000.D0-1.005D0*s)
           is2=is*is
           sqrtis=sqrt(is)
C salinity
           s2=s*s
           sqrts=sqrt(s)
           s15=s**1.5D0
           scl=s/1.80655D0
C -----------------------------------------------------------------------
C added by Val Bennington Nov 2010
C Fugacity Factor needed for non-ideality in ocean
C ff used for atmospheric correction for water vapor and pressure
C Weiss (1974) Marine Chemistry
           P1atm = 1.01325D0 ! bars
           Rgas = 83.1451D0 ! bar*cm3/(mol*K)
           RT = Rgas*tk
           delta = (57.7D0 - 0.118D0*tk)
           B1 = -1636.75D0 + 12.0408D0*tk - 0.0327957D0*tk*tk
           B = B1 + 3.16528D0*tk*tk*tk*(0.00001D0)
           fugf(i,j,bi,bj) = exp( (B+2.D0*delta) *
     &                            AtmosP(i,j,bi,bj) * P1atm / RT)

C------------------------------------------------------------------------
C f = k0(1-pH2O)*correction term for non-ideality
C Weiss & Price (1980, Mar. Chem., 8, 347-359; Eq 13 with table 6 values)
           ff(i,j,bi,bj) = exp(-162.8301D0 + 218.2968D0/tk100  +
     &          90.9241D0*log(tk100) - 1.47696D0*tk1002 +
     &          s * (.025695D0 - .025225D0*tk100 +
     &          0.0049867D0*tk1002))
C------------------------------------------------------------------------
C K0 from Weiss 1974
C Independent of pH scale
           ak0(i,j,bi,bj) = exp(93.4517D0/tk100 - 60.2409D0 +
     &        23.3585D0 * log(tk100) +
     &        s * (0.023517D0 - 0.023656D0*tk100 +
     &        0.0047036D0*tk1002))
C------------------------------------------------------------------------
C k1 = [H][HCO3]/[H2CO3]
C k2 = [H][CO3]/[HCO3]
C Millero p.664 (1995) using Mehrbach et al. data on seawater scale
C Both on seawater pH scale
           ak1(i,j,bi,bj)=10.**(-1.D0*(3670.7D0*invtk -
     &          62.008D0 + 9.7944D0*dlogtk -
     &          0.0118D0 * s + 0.000116D0*s2))
           ak2(i,j,bi,bj)=10.**(-1.D0*(1394.7D0*invtk +4.777D0
     &          -0.0184D0*s + 0.000118D0*s2))
C------------------------------------------------------------------------
C kb = [H][BO2]/[HBO2]
C Millero p.669 (1995) using data from dickson (1990)
C On total pH scale
           akb(i,j,bi,bj)=exp((-8966.90D0- 2890.53D0*sqrts -
     &          77.942D0*s + 1.728D0*s15 - 0.0996D0*s2)*invtk +
     &          (148.0248D0 + 137.1942D0*sqrts + 1.62142D0*s) +
     &          (-24.4344D0 - 25.085D0*sqrts - 0.2474D0*s) *
     &          dlogtk + 0.053105D0*sqrts*tk)
C------------------------------------------------------------------------
C k1p = [H][H2PO4]/[H3PO4]
C DOE(1994) eq 7.2.20 with footnote using data from Millero (1974)
C The constant 115.525 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 115.540 constant to stay on the seawater
C  pH scale (everything else is the same).
           ak1p(i,j,bi,bj) = exp(-4576.752D0*invtk + 115.525D0 -
     &          18.453D0*dlogtk +
     &          (-106.736D0*invtk + 0.69171D0)*sqrts +
     &          (-0.65643D0*invtk - 0.01844D0)*s)
C------------------------------------------------------------------------
C k2p = [H][HPO4]/[H2PO4]
C DOE(1994) eq 7.2.23 with footnote using data from Millero (1974))
C The constant 172.0833 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 172.1033 constant to stay on the seawater
C  pH scale (everything else is the same).
           ak2p(i,j,bi,bj) = exp(-8814.715D0*invtk + 172.0883D0 -
     &          27.927D0*dlogtk +
     &          (-160.340D0*invtk + 1.3566D0) * sqrts +
     &          (0.37335D0*invtk - 0.05778D0) * s)
C------------------------------------------------------------------------
C k3p = [H][PO4]/[HPO4]
C DOE(1994) eq 7.2.26 with footnote using data from Millero (1974)
C The constant 18.141 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 18.126 constant to stay on the seawater
C  pH scale (everything else is the same).
           ak3p(i,j,bi,bj) = exp(-3070.75D0*invtk - 18.141D0 +
     &          (17.27039D0*invtk + 2.81197D0) *
     &          sqrts + (-44.99486D0*invtk - 0.09984D0) * s)
C------------------------------------------------------------------------
C ksi = [H][SiO(OH)3]/[Si(OH)4]
C Millero p.671 (1995) using data from Yao and Millero (1995)
C The constant 117.385 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 117.400 constant to stay on the seawater
C  pH scale (everything else is the same).
C  Note: converted here from mol/kg-H2O to mol/kg-SW
           aksi(i,j,bi,bj) = exp(-8904.2D0*invtk + 117.385D0 -
     &          19.334D0*dlogtk +
     &          (-458.79D0*invtk + 3.5913D0) * sqrtis +
     &          (188.74D0*invtk - 1.5998D0) * is +
     &          (-12.1652D0*invtk + 0.07871D0) * is2 +
     &          log(1.0D0-0.001005D0*s))
C------------------------------------------------------------------------
C kw = [H][OH]
C Millero p.670 (1995) using composite data
C The constant 148.9652 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 148.9802 constant to stay on the seawater
C  pH scale (everything else is the same).
           akw(i,j,bi,bj) = exp(-13847.26D0*invtk + 148.9652D0 -
     &          23.6521D0*dlogtk +
     &          (118.67D0*invtk - 5.977D0 + 1.0495D0 * dlogtk)
     &          * sqrts - 0.01615D0 * s)
C------------------------------------------------------------------------
C ks = [H][SO4]/[HSO4]
C dickson (1990, J. chem. Thermodynamics 22, 113)
C On the free pH scale
C Note: converted here from mol/kg-H2O to mol/kg-SW
           aks(i,j,bi,bj)=exp(-4276.1D0*invtk + 141.328D0 -
     &          23.093D0*dlogtk +
     &   (-13856.D0*invtk + 324.57D0 - 47.986D0*dlogtk)*sqrtis+
     &   (35474.D0*invtk - 771.54D0 + 114.723D0*dlogtk)*is -
     &          2698.D0*invtk*is**1.5D0 + 1776.D0*invtk*is2 +
     &          log(1.0D0 - 0.001005D0*s))
C------------------------------------------------------------------------
C kf = [H][F]/[HF]
C dickson and Riley (1979) -- change pH scale to total (following Dickson & Goyet, 1994)
C Note: converted here from mol/kg-H2O to mol/kg-SW
           akf(i,j,bi,bj)=exp(1590.2D0*invtk - 12.641D0 +
     &   1.525D0*sqrtis + log(1.0D0 - 0.001005D0*s) +
     &   log(1.0D0 + (0.1400D0/96.062D0)*(scl)/aks(i,j,bi,bj)))
C------------------------------------------------------------------------
C Calculate concentrations for borate, sulfate, and fluoride
C Uppstrom (1974)
           bt(i,j,bi,bj) = 0.000232D0 * scl/10.811D0
C Morris & Riley (1966)
           st(i,j,bi,bj) = 0.14D0 * scl/96.062D0
C Riley (1965)
           ft(i,j,bi,bj) = 0.000067D0 * scl/18.9984D0
C------------------------------------------------------------------------
         else
c add Bennington
            fugf(i,j,bi,bj)=0.D0
            ff(i,j,bi,bj)=0.D0
            ak0(i,j,bi,bj)= 0.D0
            ak1(i,j,bi,bj)= 0.D0
            ak2(i,j,bi,bj)= 0.D0
            akb(i,j,bi,bj)= 0.D0
            ak1p(i,j,bi,bj) = 0.D0
            ak2p(i,j,bi,bj) = 0.D0
            ak3p(i,j,bi,bj) = 0.D0
            aksi(i,j,bi,bj) = 0.D0
            akw(i,j,bi,bj) = 0.D0
            aks(i,j,bi,bj)= 0.D0
            akf(i,j,bi,bj)= 0.D0
            bt(i,j,bi,bj) = 0.D0
            st(i,j,bi,bj) = 0.D0
            ft(i,j,bi,bj) = 0.D0
         endif
         end do
        end do

        RETURN
        END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CBOP
      subroutine CARBON_COEFFS_PRESSURE_DEP(
     I                   ttemp,stemp,
     I                   bi,bj,iMin,iMax,jMin,jMax,
     I                   Klevel,myThid)

C !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE CARBON_COEFFS                                 |
C     | determine coefficients for surface carbon chemistry      |
C     | adapted from OCMIP2:  SUBROUTINE CO2CALC                 |
C     | mick follows, oct 1999                                   |
C     | minor changes to tidy, swd aug 2002                      |
C     | MODIFIED FOR PRESSURE DEPENDENCE                         |
C     | Karsten Friis and Mick Follows 2004                      |
C     *==========================================================*
C INPUT
C       diclocal = total inorganic carbon (mol/m^3)
C             where 1 T = 1 metric ton = 1000 kg
C       ta  = total alkalinity (eq/m^3)
C       pt  = inorganic phosphate (mol/^3)
C       sit = inorganic silicate (mol/^3)
C       t   = temperature (degrees C)
C       s   = salinity (g/kg)
C OUTPUT
C IMPORTANT: Some words about units - (JCO, 4/4/1999)
C     - Models carry tracers in mol/m^3 (on a per volume basis)
C     - Conversely, this routine, which was written by observationalists
C       (C. Sabine and R. Key), passes input arguments in umol/kg
C       (i.e., on a per mass basis)
C     - I have changed things slightly so that input arguments are in mol/m^3,
C     - Thus, all input concentrations (diclocal, ta, pt, and st) should be
C       given in mol/m^3; output arguments "co2star" and "dco2star"
C       are likewise be in mol/m^3.
C
C NOW INCLUDES:
C PRESSURE DEPENDENCE of K1, K2, solubility product of calcite
C based on Takahashi, GEOSECS Atlantic Report, Vol. 1 (1981)
C
C--------------------------------------------------------------------------

      IMPLICIT NONE

C     === Global variables ===
C $Header: /u/gcmpack/MITgcm_contrib/llc_hires/llc_270/code/SIZE.h,v 1.3 2015/09/29 18:07:50 zhc Exp $
C $Name:  $

C
CBOP
C    !ROUTINE: SIZE.h
C    !INTERFACE:
C    include SIZE.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | SIZE.h Declare size of underlying computational grid.     
C     *==========================================================*
C     | The design here support a three-dimensional model grid    
C     | with indices I,J and K. The three-dimensional domain      
C     | is comprised of nPx*nSx blocks of size sNx along one axis 
C     | nPy*nSy blocks of size sNy along another axis and one     
C     | block of size Nz along the final axis.                    
C     | Blocks have overlap regions of size OLx and OLy along the 
C     | dimensions that are subdivided.                           
C     *==========================================================*
C     \ev
CEOP
C     Voodoo numbers controlling data layout.
C     sNx :: No. X points in sub-grid.
C     sNy :: No. Y points in sub-grid.
C     OLx :: Overlap extent in X.
C     OLy :: Overlat extent in Y.
C     nSx :: No. sub-grids in X.
C     nSy :: No. sub-grids in Y.
C     nPx :: No. of processes to use in X.
C     nPy :: No. of processes to use in Y.
C     Nx  :: No. points in X for the total domain.
C     Ny  :: No. points in Y for the total domain.
C     Nr  :: No. points in Z for full process domain.
      INTEGER sNx
      INTEGER sNy
      INTEGER OLx
      INTEGER OLy
      INTEGER nSx
      INTEGER nSy
      INTEGER nPx
      INTEGER nPy
      INTEGER Nx
      INTEGER Ny
      INTEGER Nr
      PARAMETER (
     &           sNx = 720,
     &           sNy = 280,
     &           OLx =   8,
     &           OLy =   8,
     &           nSx =   1,
     &           nSy =   1,
     &           nPx =   1,
     &           nPy =   1,
     &           Nx  = sNx*nSx*nPx,
     &           Ny  = sNy*nSy*nPy,
     &           Nr  =  50 )

C     MAX_OLX :: Set to the maximum overlap region size of any array
C     MAX_OLY    that will be exchanged. Controls the sizing of exch
C                routine buffers.
      INTEGER MAX_OLX
      INTEGER MAX_OLY
      PARAMETER ( MAX_OLX = OLx,
     &            MAX_OLY = OLy )

      INTEGER     nobcs
      PARAMETER ( nobcs = 4 )

C $Header: /u/gcmpack/MITgcm/eesupp/inc/EEPARAMS.h,v 1.36 2014/02/13 04:10:25 jmc Exp $
C $Name:  $
CBOP
C     !ROUTINE: EEPARAMS.h
C     !INTERFACE:
C     include "EEPARAMS.h"
C
C     !DESCRIPTION:
C     *==========================================================*
C     | EEPARAMS.h                                               |
C     *==========================================================*
C     | Parameters for "execution environemnt". These are used   |
C     | by both the particular numerical model and the execution |
C     | environment support routines.                            |
C     *==========================================================*
CEOP

C     ========  EESIZE.h  ========================================

C     MAX_LEN_MBUF  :: Default message buffer max. size
C     MAX_LEN_FNAM  :: Default file name max. size
C     MAX_LEN_PREC  :: Default rec len for reading "parameter" files

      INTEGER MAX_LEN_MBUF
      PARAMETER ( MAX_LEN_MBUF = 512 )
      INTEGER MAX_LEN_FNAM
      PARAMETER ( MAX_LEN_FNAM = 512 )
      INTEGER MAX_LEN_PREC
      PARAMETER ( MAX_LEN_PREC = 200 )

C     MAX_NO_THREADS  :: Maximum number of threads allowed.
CC    MAX_NO_PROCS    :: Maximum number of processes allowed.
CC    MAX_NO_BARRIERS :: Maximum number of distinct thread "barriers"
      INTEGER MAX_NO_THREADS
      PARAMETER ( MAX_NO_THREADS =  4 )
c     INTEGER MAX_NO_PROCS
c     PARAMETER ( MAX_NO_PROCS   =  70000 )
c     INTEGER MAX_NO_BARRIERS
c     PARAMETER ( MAX_NO_BARRIERS = 1 )

C     Particularly weird and obscure voodoo numbers
C     lShare :: This wants to be the length in
C               [148]-byte words of the size of
C               the address "window" that is snooped
C               on an SMP bus. By separating elements in
C               the global sum buffer we can avoid generating
C               extraneous invalidate traffic between
C               processors. The length of this window is usually
C               a cache line i.e. small O(64 bytes).
C               The buffer arrays are usually short arrays
C               and are declared REAL ARRA(lShare[148],LBUFF).
C               Setting lShare[148] to 1 is like making these arrays
C               one dimensional.
      INTEGER cacheLineSize
      INTEGER lShare1
      INTEGER lShare4
      INTEGER lShare8
      PARAMETER ( cacheLineSize = 256 )
      PARAMETER ( lShare1 =  cacheLineSize )
      PARAMETER ( lShare4 =  cacheLineSize/4 )
      PARAMETER ( lShare8 =  cacheLineSize/8 )

CC    MAX_VGS  :: Maximum buffer size for Global Vector Sum
c     INTEGER MAX_VGS
c     PARAMETER ( MAX_VGS = 8192 )

C     ========  EESIZE.h  ========================================

C     Symbolic values
C     precXXXX :: precision used for I/O
      INTEGER precFloat32
      PARAMETER ( precFloat32 = 32 )
      INTEGER precFloat64
      PARAMETER ( precFloat64 = 64 )

C     Real-type constant for some frequently used simple number (0,1,2,1/2):
      Real*8     zeroRS, oneRS, twoRS, halfRS
      PARAMETER ( zeroRS = 0.0D0 , oneRS  = 1.0D0 )
      PARAMETER ( twoRS  = 2.0D0 , halfRS = 0.5D0 )
      Real*8     zeroRL, oneRL, twoRL, halfRL
      PARAMETER ( zeroRL = 0.0D0 , oneRL  = 1.0D0 )
      PARAMETER ( twoRL  = 2.0D0 , halfRL = 0.5D0 )

C     UNSET_xxx :: Used to indicate variables that have not been given a value
      Real*8  UNSET_FLOAT8
      PARAMETER ( UNSET_FLOAT8 = 1.234567D5 )
      Real*4  UNSET_FLOAT4
      PARAMETER ( UNSET_FLOAT4 = 1.234567E5 )
      Real*8     UNSET_RL
      PARAMETER ( UNSET_RL     = 1.234567D5 )
      Real*8     UNSET_RS
      PARAMETER ( UNSET_RS     = 1.234567D5 )
      INTEGER UNSET_I
      PARAMETER ( UNSET_I      = 123456789  )

C     debLevX  :: used to decide when to print debug messages
      INTEGER debLevZero
      INTEGER debLevA, debLevB,  debLevC, debLevD, debLevE
      PARAMETER ( debLevZero=0 )
      PARAMETER ( debLevA=1 )
      PARAMETER ( debLevB=2 )
      PARAMETER ( debLevC=3 )
      PARAMETER ( debLevD=4 )
      PARAMETER ( debLevE=5 )

C     SQUEEZE_RIGHT      :: Flag indicating right blank space removal
C                           from text field.
C     SQUEEZE_LEFT       :: Flag indicating left blank space removal
C                           from text field.
C     SQUEEZE_BOTH       :: Flag indicating left and right blank
C                           space removal from text field.
C     PRINT_MAP_XY       :: Flag indicating to plot map as XY slices
C     PRINT_MAP_XZ       :: Flag indicating to plot map as XZ slices
C     PRINT_MAP_YZ       :: Flag indicating to plot map as YZ slices
C     commentCharacter   :: Variable used in column 1 of parameter
C                           files to indicate comments.
C     INDEX_I            :: Variable used to select an index label
C     INDEX_J               for formatted input parameters.
C     INDEX_K
C     INDEX_NONE
      CHARACTER*(*) SQUEEZE_RIGHT
      PARAMETER ( SQUEEZE_RIGHT = 'R' )
      CHARACTER*(*) SQUEEZE_LEFT
      PARAMETER ( SQUEEZE_LEFT = 'L' )
      CHARACTER*(*) SQUEEZE_BOTH
      PARAMETER ( SQUEEZE_BOTH = 'B' )
      CHARACTER*(*) PRINT_MAP_XY
      PARAMETER ( PRINT_MAP_XY = 'XY' )
      CHARACTER*(*) PRINT_MAP_XZ
      PARAMETER ( PRINT_MAP_XZ = 'XZ' )
      CHARACTER*(*) PRINT_MAP_YZ
      PARAMETER ( PRINT_MAP_YZ = 'YZ' )
      CHARACTER*(*) commentCharacter
      PARAMETER ( commentCharacter = '#' )
      INTEGER INDEX_I
      INTEGER INDEX_J
      INTEGER INDEX_K
      INTEGER INDEX_NONE
      PARAMETER ( INDEX_I    = 1,
     &            INDEX_J    = 2,
     &            INDEX_K    = 3,
     &            INDEX_NONE = 4 )

C     EXCH_IGNORE_CORNERS :: Flag to select ignoring or
C     EXCH_UPDATE_CORNERS    updating of corners during an edge exchange.
      INTEGER EXCH_IGNORE_CORNERS
      INTEGER EXCH_UPDATE_CORNERS
      PARAMETER ( EXCH_IGNORE_CORNERS = 0,
     &            EXCH_UPDATE_CORNERS = 1 )

C     FORWARD_SIMULATION
C     REVERSE_SIMULATION
C     TANGENT_SIMULATION
      INTEGER FORWARD_SIMULATION
      INTEGER REVERSE_SIMULATION
      INTEGER TANGENT_SIMULATION
      PARAMETER ( FORWARD_SIMULATION = 0,
     &            REVERSE_SIMULATION = 1,
     &            TANGENT_SIMULATION = 2 )

C--   COMMON /EEPARAMS_L/ Execution environment public logical variables.
C     eeBootError    :: Flags indicating error during multi-processing
C     eeEndError     :: initialisation and termination.
C     fatalError     :: Flag used to indicate that the model is ended with an error
C     debugMode      :: controls printing of debug msg (sequence of S/R calls).
C     useSingleCpuIO :: When useSingleCpuIO is set, MDS_WRITE_FIELD outputs from
C                       master MPI process only. -- NOTE: read from main parameter
C                       file "data" and not set until call to INI_PARMS.
C     useSingleCpuInput :: When useSingleCpuInput is set, EXF_INTERP_READ
C                       reads forcing files from master MPI process only.
C                       -- NOTE: read from main parameter file "data"
C                          and defaults to useSingleCpuInput = useSingleCpuIO
C     printMapIncludesZeros  :: Flag that controls whether character constant
C                               map code ignores exact zero values.
C     useCubedSphereExchange :: use Cubed-Sphere topology domain.
C     useCoupler     :: use Coupler for a multi-components set-up.
C     useNEST_PARENT :: use Parent Nesting interface (pkg/nest_parent)
C     useNEST_CHILD  :: use Child  Nesting interface (pkg/nest_child)
C     useOASIS       :: use OASIS-coupler for a multi-components set-up.
      COMMON /EEPARAMS_L/
c    &  eeBootError, fatalError, eeEndError,
     &  eeBootError, eeEndError, fatalError, debugMode,
     &  useSingleCpuIO, useSingleCpuInput, printMapIncludesZeros,
     &  useCubedSphereExchange, useCoupler,
     &  useNEST_PARENT, useNEST_CHILD, useOASIS,
     &  useSETRLSTK, useSIGREG
      LOGICAL eeBootError
      LOGICAL eeEndError
      LOGICAL fatalError
      LOGICAL debugMode
      LOGICAL useSingleCpuIO
      LOGICAL useSingleCpuInput
      LOGICAL printMapIncludesZeros
      LOGICAL useCubedSphereExchange
      LOGICAL useCoupler
      LOGICAL useNEST_PARENT
      LOGICAL useNEST_CHILD
      LOGICAL useOASIS
      LOGICAL useSETRLSTK
      LOGICAL useSIGREG

C--   COMMON /EPARAMS_I/ Execution environment public integer variables.
C     errorMessageUnit    :: Fortran IO unit for error messages
C     standardMessageUnit :: Fortran IO unit for informational messages
C     maxLengthPrt1D :: maximum length for printing (to Std-Msg-Unit) 1-D array
C     scrUnit1      :: Scratch file 1 unit number
C     scrUnit2      :: Scratch file 2 unit number
C     eeDataUnit    :: Unit # for reading "execution environment" parameter file
C     modelDataUnit :: Unit number for reading "model" parameter file.
C     numberOfProcs :: Number of processes computing in parallel
C     pidIO         :: Id of process to use for I/O.
C     myBxLo, myBxHi :: Extents of domain in blocks in X and Y
C     myByLo, myByHi :: that each threads is responsble for.
C     myProcId      :: My own "process" id.
C     myPx          :: My X coord on the proc. grid.
C     myPy          :: My Y coord on the proc. grid.
C     myXGlobalLo   :: My bottom-left (south-west) x-index global domain.
C                      The x-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     myYGlobalLo   :: My bottom-left (south-west) y-index in global domain.
C                      The y-coordinate of this point in for example m or
C                      degrees is *not* specified here. A model needs to
C                      provide a mechanism for deducing that information
C                      if it is needed.
C     nThreads      :: No. of threads
C     nTx, nTy      :: No. of threads in X and in Y
C                      This assumes a simple cartesian gridding of the threads
C                      which is not required elsewhere but that makes it easier
C     ioErrorCount  :: IO Error Counter. Set to zero initially and increased
C                      by one every time an IO error occurs.
      COMMON /EEPARAMS_I/
     &  errorMessageUnit, standardMessageUnit, maxLengthPrt1D,
     &  scrUnit1, scrUnit2, eeDataUnit, modelDataUnit,
     &  numberOfProcs, pidIO, myProcId,
     &  myPx, myPy, myXGlobalLo, myYGlobalLo, nThreads,
     &  myBxLo, myBxHi, myByLo, myByHi,
     &  nTx, nTy, ioErrorCount
      INTEGER errorMessageUnit
      INTEGER standardMessageUnit
      INTEGER maxLengthPrt1D
      INTEGER scrUnit1
      INTEGER scrUnit2
      INTEGER eeDataUnit
      INTEGER modelDataUnit
      INTEGER ioErrorCount(MAX_NO_THREADS)
      INTEGER myBxLo(MAX_NO_THREADS)
      INTEGER myBxHi(MAX_NO_THREADS)
      INTEGER myByLo(MAX_NO_THREADS)
      INTEGER myByHi(MAX_NO_THREADS)
      INTEGER myProcId
      INTEGER myPx
      INTEGER myPy
      INTEGER myXGlobalLo
      INTEGER myYGlobalLo
      INTEGER nThreads
      INTEGER nTx
      INTEGER nTy
      INTEGER numberOfProcs
      INTEGER pidIO

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
c#include "PARAMS.h"
C $Header: /u/gcmpack/MITgcm/model/inc/GRID.h,v 1.43 2013/07/26 14:20:01 jmc Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: GRID.h
C    !INTERFACE:
C    include GRID.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID.h
C     | o Header file defining model grid.
C     *==========================================================*
C     | Model grid is defined for each process by reference to
C     | the arrays set here.
C     | Notes
C     | =====
C     | The standard MITgcm convention of westmost, southern most
C     | and upper most having the (1,1,1) index is used here.
C     | i.e.
C     |----------------------------------------------------------
C     | (1)  Plan view schematic of model grid (top layer i.e. )
C     |      ================================= ( ocean surface )
C     |                                        ( or top of     )
C     |                                        ( atmosphere    )
C     |      This diagram shows the location of the model
C     |      prognostic variables on the model grid. The "T"
C     |      location is used for all tracers. The figure also
C     |      shows the southern most, western most indexing
C     |      convention that is used for all model variables.
C     |
C     |
C     |             V(i=1,                     V(i=Nx,
C     |               j=Ny+1,                    j=Ny+1,
C     |               k=1)                       k=1)
C     |                /|\                       /|\  "PWX"
C     |       |---------|------------------etc..  |---- *---
C     |       |                     |                   *  |
C     |"PWY"*******************************etc..  **********"PWY"
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *==>U
C     |  j=Ny,|      T(i=1,         |          T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=Ny,        |            j=Ny,  *  |j=Ny,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x           |             x     *  |
C     |  j=2, |      T(i=1,         |          T(i=Nx,  *  |
C     |  k=1) |        j=2,         |            j=2,   *  |
C     |       |        k=1)         |            k=1)   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |      -----------|------------------etc..  |-----*---
C     |       |       V(i=1,        |           V(i=Nx, *  |
C     |       |         j=2,        |             j=2,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |"SB"++>|---------|------------------etc..  |-----*---
C     |      /+\      V(i=1,                    V(i=Nx, *
C     |       +         j=1,                      j=1,  *
C     |       +         k=1)                      k=1)  *
C     |     "WB"                                      "PWX"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     |    V: y-velocity (m/s)
C     |    T: potential temperature (oC)
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |----------------------------------------------------------
C     | (2) South elevation schematic of model grid
C     |     =======================================
C     |     This diagram shows the location of the model
C     |     prognostic variables on the model grid. The "T"
C     |     location is used for all tracers. The figure also
C     |     shows the upper most, western most indexing
C     |     convention that is used for all model variables.
C     |
C     |      "WB"
C     |       +
C     |       +
C     |      \+/       /|\                       /|\       .
C     |"UB"++>|-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=1)        |             k=1)  *  |
C     |       |                     |                   *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=1) |        j=1,         |  k=1)      j=1,   *  |j=1,
C     |       |        k=1)         |            k=1)   *  |k=1)
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=2)        |             k=2)  *  |
C     |
C     |       .                     .                      .
C     |       .                     .                      .
C     |       .                     .                      .
C     |       e                     e                   *  e
C     |       t                     t                   *  t
C     |       c                     c                   *  c
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |                     |                   *  |
C     |       |        /|\          |            /|\    *  |
C     |       |-------- | -----------------etc..  | ----*---
C     |       |    rVel(i=1,        |        rVel(i=Nx, *  |
C     |       |         j=1,        |             j=1,  *  |
C     |       |         k=Nr)       |             k=Nr) *  |
C     |U(i=1, ==>       x         ==>U(i=2,       x     *==>U
C     |  j=1, |      T(i=1,         |  j=1,    T(i=Nx,  *(i=Nx+1,
C     |  k=Nr)|        j=1,         |  k=Nr)     j=1,   *  |j=1,
C     |       |        k=Nr)        |            k=Nr)  *  |k=Nr)
C     |       |                     |                   *  |
C     |"LB"++>==============================================
C     |                                               "PWX"
C     |
C     | Up   increasing upwards.
C     |/|\                                                       .
C     | |
C     | |
C     | =====> E  i increasing eastwards
C     | |         x increasing eastwards
C     | |
C     |\|/
C     | Down,k increasing downwards.
C     |
C     | Note: r => height (m) => r increases upwards
C     |       r => pressure (Pa) => r increases downwards
C     |
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    U: x-velocity (m/s)
C     | rVel: z-velocity ( units of r )
C     |       The vertical velocity variable rVel is in units of
C     |       "r" the vertical coordinate. r in m will give
C     |       rVel m/s. r in Pa will give rVel Pa/s.
C     |    T: potential temperature (oC)
C     | "UB": Upper boundary.
C     | "LB": Lower boundary (always solid - therefore om|w == 0)
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |----------------------------------------------------------
C     | (3) Views showing nomenclature and indexing
C     |     for grid descriptor variables.
C     |
C     |      Fig 3a. shows the orientation, indexing and
C     |      notation for the grid spacing terms used internally
C     |      for the evaluation of gradient and averaging terms.
C     |      These varaibles are set based on the model input
C     |      parameters which define the model grid in terms of
C     |      spacing in X, Y and Z.
C     |
C     |      Fig 3b. shows the orientation, indexing and
C     |      notation for the variables that are used to define
C     |      the model grid. These varaibles are set directly
C     |      from the model input.
C     |
C     | Figure 3a
C     | =========
C     |       |------------------------------------
C     |       |                       |
C     |"PWY"********************************* etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v----------|-
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       |                       |                      |
C     |       u<--dxF(i=1,j=2,k=1)--->u           t          |
C     |       |/|\       /|\          |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       | |         |           |                      |
C     |       |dyU(i=1,  dyC(i=1,     |                      |
C     | ---  ---|--j=2,---|--j=2,-----------------v----------|-
C     | /|\   | |  k=1)   |  k=1)     |          /|\         |
C     |  |    | |         |           |          dyF(i=2,    |
C     |  |    | |         |           |           |  j=1,    |
C     |dyG(   |\|/       \|/          |           |  k=1)    |
C     |   i=1,u---        t<---dxC(i=2,j=1,k=1)-->t          |
C     |   j=1,|                       |           |          |
C     |   k=1)|                       |           |          |
C     |  |    |                       |           |          |
C     |  |    |                       |           |          |
C     | \|/   |           |<---dxV(i=2,j=1,k=1)--\|/         |
C     |"SB"++>|___________v___________|___________v__________|_
C     |       <--dxG(i=1,j=1,k=1)----->
C     |      /+\                                              .
C     |       +
C     |       +
C     |     "WB"
C     |
C     |   N, y increasing northwards
C     |  /|\ j increasing northwards
C     |   |
C     |   |
C     |   ======>E, x increasing eastwards
C     |             i increasing eastwards
C     |
C     |    i: East-west index
C     |    j: North-south index
C     |    k: up-down index
C     |    u: x-velocity point
C     |    V: y-velocity point
C     |    t: tracer point
C     | "SB": Southern boundary
C     | "WB": Western boundary
C     |"PWX": Periodic wrap around in X.
C     |"PWY": Periodic wrap around in Y.
C     |
C     | Figure 3b
C     | =========
C     |
C     |       .                       .
C     |       .                       .
C     |       .                       .
C     |       e                       e
C     |       t                       t
C     |       c                       c
C     |       |-----------v-----------|-----------v--etc...
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       u<--delX(i=1)---------->u           t
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |                       |
C     |       |-----------v-----------------------v--etc...
C     |       |          /|\          |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       u        delY(j=1)      |           t
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |           |           |
C     |       |          \|/          |
C     |"SB"++>|___________v___________|___________v__etc...
C     |      /+\                                                 .
C     |       +
C     |       +
C     |     "WB"
C     |
C     *==========================================================*
C     \ev
CEOP

C     Macros that override/modify standard definitions
C $Header: /u/gcmpack/MITgcm/model/inc/GRID_MACROS.h,v 1.13 2013/08/11 14:27:37 jmc Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: GRID_MACROS.h
C    !INTERFACE:
C    include GRID_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | GRID_MACROS.h
C     *==========================================================*
C     | These macros are used to substitute definitions for
C     | GRID.h variables for particular configurations.
C     | In setting these variables the following convention
C     | applies.
C     | undef  phi_CONST   - Indicates the variable phi is fixed
C     |                      in X, Y and Z.
C     | undef  phi_FX      - Indicates the variable phi only
C     |                      varies in X (i.e.not in X or Z).
C     | undef  phi_FY      - Indicates the variable phi only
C     |                      varies in Y (i.e.not in X or Z).
C     | undef  phi_FXY     - Indicates the variable phi only
C     |                      varies in X and Y ( i.e. not Z).
C     *==========================================================*
C     \ev
CEOP

C $Header: /u/gcmpack/MITgcm/model/inc/DXC_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXC_MACROS.h
C    !INTERFACE:
C    include DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXF_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXF_MACROS.h
C    !INTERFACE:
C    include DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXG_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXG_MACROS.h
C    !INTERFACE:
C    include DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DXV_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DXV_MACROS.h
C    !INTERFACE:
C    include DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DXV_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYC_MACROS.h
C    !INTERFACE:
C    include DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYC_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYF_MACROS.h
C    !INTERFACE:
C    include DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYF_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYG_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYG_MACROS.h
C    !INTERFACE:
C    include DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYG_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/DYU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: DYU_MACROS.h
C    !INTERFACE:
C    include DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | DYU_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/HFACC_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACC_MACROS.h
C    !INTERFACE:
C    include HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACC_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/HFACS_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACS_MACROS.h
C    !INTERFACE:
C    include HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/HFACW_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: HFACW_MACROS.h
C    !INTERFACE:
C    include HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | HFACW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXC_MACROS.h
C    !INTERFACE:
C    include RECIP_DXC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXF_MACROS.h
C    !INTERFACE:
C    include RECIP_DXF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXG_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXG_MACROS.h
C    !INTERFACE:
C    include RECIP_DXG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DXV_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DXV_MACROS.h
C    !INTERFACE:
C    include RECIP_DXV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DXV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYC_MACROS.h
C    !INTERFACE:
C    include RECIP_DYC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYC_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYF_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYF_MACROS.h
C    !INTERFACE:
C    include RECIP_DYF_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYF_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYG_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYG_MACROS.h
C    !INTERFACE:
C    include RECIP_DYG_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYG_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_DYU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_DYU_MACROS.h
C    !INTERFACE:
C    include RECIP_DYU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_DYU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACC_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACC_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACC_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACS_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACS_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACS_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/RECIP_HFACW_MACROS.h,v 1.4 2006/06/07 01:55:12 heimbach Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RECIP_HFACW_MACROS.h
C    !INTERFACE:
C    include RECIP_HFACW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RECIP_HFACW_MACROS.h                                      
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP







C $Header: /u/gcmpack/MITgcm/model/inc/XC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: XC_MACROS.h
C    !INTERFACE:
C    include XC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | XC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/YC_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: YC_MACROS.h
C    !INTERFACE:
C    include YC_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | YC_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/RA_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RA_MACROS.h
C    !INTERFACE:
C    include RA_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RA_MACROS.h                                               
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C $Header: /u/gcmpack/MITgcm/model/inc/RAW_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RAW_MACROS.h
C    !INTERFACE:
C    include RAW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAW_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP




C $Header: /u/gcmpack/MITgcm/model/inc/RAS_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: RAS_MACROS.h
C    !INTERFACE:
C    include RAS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | RAS_MACROS.h                                              
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/MASKW_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: MASKW_MACROS.h
C    !INTERFACE:
C    include MASKW_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKW_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C $Header: /u/gcmpack/MITgcm/model/inc/MASKS_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: MASKS_MACROS.h
C    !INTERFACE:
C    include MASKS_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | MASKS_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP






C $Header: /u/gcmpack/MITgcm/model/inc/TANPHIATU_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: TANPHIATU_MACROS.h
C    !INTERFACE:
C    include TANPHIATU_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATU_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/TANPHIATV_MACROS.h,v 1.3 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: TANPHIATV_MACROS.h
C    !INTERFACE:
C    include TANPHIATV_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | TANPHIATV_MACROS.h                                        
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C $Header: /u/gcmpack/MITgcm/model/inc/FCORI_MACROS.h,v 1.4 2001/09/21 15:13:31 cnh Exp $
C $Name:  $
C
CBOP
C    !ROUTINE: FCORI_MACROS.h
C    !INTERFACE:
C    include FCORI_MACROS.h
C    !DESCRIPTION: \bv
C     *==========================================================*
C     | FCORI_MACROS.h                                            
C     *==========================================================*
C     | These macros are used to reduce memory requirement and/or 
C     | memory references when variables are fixed along a given  
C     | axis or axes.                                             
C     *==========================================================*
C     \ev
CEOP





C--   COMMON /GRID_RL/ RL valued grid defining variables.
C     deepFacC  :: deep-model grid factor (fct of vertical only) for dx,dy
C     deepFacF     at level-center (deepFacC)  and level interface (deepFacF)
C     deepFac2C :: deep-model grid factor (fct of vertical only) for area dx*dy
C     deepFac2F    at level-center (deepFac2C) and level interface (deepFac2F)
C     gravitySign :: indicates the direction of gravity relative to R direction
C                   (= -1 for R=Z (Z increases upward, -gravity direction  )
C                   (= +1 for R=P (P increases downward, +gravity direction)
C     rkSign     :: Vertical coordinate to vertical index orientation.
C                   ( +1 same orientation, -1 opposite orientation )
C     globalArea :: Domain Integrated horizontal Area [m2]
      COMMON /GRID_RL/
     &  cosFacU, cosFacV, sqCosFacU, sqCosFacV,
     &  deepFacC, deepFac2C, recip_deepFacC, recip_deepFac2C,
     &  deepFacF, deepFac2F, recip_deepFacF, recip_deepFac2F,
     &  gravitySign, rkSign, globalArea
      Real*8 cosFacU        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 cosFacV        (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacU      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 sqCosFacV      (1-OLy:sNy+OLy,nSx,nSy)
      Real*8 deepFacC       (Nr)
      Real*8 deepFac2C      (Nr)
      Real*8 deepFacF       (Nr+1)
      Real*8 deepFac2F      (Nr+1)
      Real*8 recip_deepFacC (Nr)
      Real*8 recip_deepFac2C(Nr)
      Real*8 recip_deepFacF (Nr+1)
      Real*8 recip_deepFac2F(Nr+1)
      Real*8 gravitySign
      Real*8 rkSign
      Real*8 globalArea

C--   COMMON /GRID_RS/ RS valued grid defining variables.
C     dxC     :: Cell center separation in X across western cell wall (m)
C     dxG     :: Cell face separation in X along southern cell wall (m)
C     dxF     :: Cell face separation in X thru cell center (m)
C     dxV     :: V-point separation in X across south-west corner of cell (m)
C     dyC     :: Cell center separation in Y across southern cell wall (m)
C     dyG     :: Cell face separation in Y along western cell wall (m)
C     dyF     :: Cell face separation in Y thru cell center (m)
C     dyU     :: U-point separation in Y across south-west corner of cell (m)
C     drC     :: Cell center separation along Z axis ( units of r ).
C     drF     :: Cell face separation along Z axis ( units of r ).
C     R_low   :: base of fluid in r_unit (Depth(m) / Pressure(Pa) at top Atmos.)
C     rLowW   :: base of fluid column in r_unit at Western  edge location.
C     rLowS   :: base of fluid column in r_unit at Southern edge location.
C     Ro_surf :: surface reference (at rest) position, r_unit.
C     rSurfW  :: surface reference position at Western  edge location [r_unit].
C     rSurfS  :: surface reference position at Southern edge location [r_unit].
C     hFac    :: Fraction of cell in vertical which is open i.e how
C              "lopped" a cell is (dimensionless scale factor).
C              Note: The code needs terms like MIN(hFac,hFac(I-1))
C                    On some platforms it may be better to precompute
C                    hFacW, hFacS, ... here than do MIN on the fly.
C     maskInC :: Cell Center 2-D Interior mask (i.e., zero beyond OB)
C     maskInW :: West  face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskInS :: South face 2-D Interior mask (i.e., zero on and beyond OB)
C     maskC   :: cell Center land mask
C     maskW   :: West face land mask
C     maskS   :: South face land mask
C     recip_dxC   :: Reciprocal of dxC
C     recip_dxG   :: Reciprocal of dxG
C     recip_dxF   :: Reciprocal of dxF
C     recip_dxV   :: Reciprocal of dxV
C     recip_dyC   :: Reciprocal of dxC
C     recip_dyG   :: Reciprocal of dyG
C     recip_dyF   :: Reciprocal of dyF
C     recip_dyU   :: Reciprocal of dyU
C     recip_drC   :: Reciprocal of drC
C     recip_drF   :: Reciprocal of drF
C     recip_Rcol  :: Inverse of cell center column thickness (1/r_unit)
C     recip_hFacC :: Inverse of cell open-depth f[X,Y,Z] ( dimensionless ).
C     recip_hFacW    rhFacC center, rhFacW west, rhFacS south.
C     recip_hFacS    Note: This is precomputed here because it involves division.
C     xC        :: X-coordinate of cell center f[X,Y]. The units of xc, yc
C                  depend on the grid. They are not used in differencing or
C                  averaging but are just a convient quantity for I/O,
C                  diagnostics etc.. As such xc is in m for cartesian
C                  coordinates but degrees for spherical polar.
C     yC        :: Y-coordinate of center of cell f[X,Y].
C     yG        :: Y-coordinate of corner of cell ( c-grid vorticity point) f[X,Y].
C     rA        :: R-face are f[X,Y] ( m^2 ).
C                  Note: In a cartesian framework rA is simply dx*dy,
C                      however we use rA to allow for non-globally
C                      orthogonal coordinate frames (with appropriate
C                      metric terms).
C     rC        :: R-coordinate of center of cell f[Z] (units of r).
C     rF        :: R-coordinate of face of cell f[Z] (units of r).
C - *HybSigm* - :: Hybrid-Sigma vert. Coord coefficients
C     aHybSigmF    at level-interface (*HybSigmF) and level-center (*HybSigmC)
C     aHybSigmC    aHybSigm* = constant r part, bHybSigm* = sigma part, such as
C     bHybSigmF    r(ij,k,t) = rLow(ij) + aHybSigm(k)*[rF(1)-rF(Nr+1)]
C     bHybSigmC              + bHybSigm(k)*[eta(ij,t)+Ro_surf(ij) - rLow(ij)]
C     dAHybSigF :: vertical increment of Hybrid-Sigma coefficient: constant r part,
C     dAHybSigC    between interface (dAHybSigF) and between center (dAHybSigC)
C     dBHybSigF :: vertical increment of Hybrid-Sigma coefficient: sigma part,
C     dBHybSigC    between interface (dBHybSigF) and between center (dBHybSigC)
C     tanPhiAtU :: tan of the latitude at U point. Used for spherical polar
C                  metric term in U equation.
C     tanPhiAtV :: tan of the latitude at V point. Used for spherical polar
C                  metric term in V equation.
C     angleCosC :: cosine of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     angleSinC :: sine   of grid orientation angle relative to Geographic direction
C               at cell center: alpha=(Eastward_dir,grid_uVel_dir)=(North_d,vVel_d)
C     u2zonDir  :: cosine of grid orientation angle at U point location
C     v2zonDir  :: minus sine of  orientation angle at V point location
C     fCori     :: Coriolis parameter at grid Center point
C     fCoriG    :: Coriolis parameter at grid Corner point
C     fCoriCos  :: Coriolis Cos(phi) parameter at grid Center point (for NH)

      COMMON /GRID_RS/
     &  dxC,dxF,dxG,dxV,dyC,dyF,dyG,dyU,
     &  R_low, rLowW, rLowS,
     &  Ro_surf, rSurfW, rSurfS,
     &  hFacC, hFacW, hFacS,
     &  recip_dxC,recip_dxF,recip_dxG,recip_dxV,
     &  recip_dyC,recip_dyF,recip_dyG,recip_dyU,
     &  recip_Rcol,
     &  recip_hFacC,recip_hFacW,recip_hFacS,
     &  xC,yC,rA,rAw,rAs,rAz,xG,yG,
     &  maskInC, maskInW, maskInS,
     &  maskC, maskW, maskS,
     &  recip_rA,recip_rAw,recip_rAs,recip_rAz,
     &  drC, drF, recip_drC, recip_drF, rC, rF,
     &  aHybSigmF, bHybSigmF, aHybSigmC, bHybSigmC,
     &  dAHybSigF, dBHybSigF, dBHybSigC, dAHybSigC,
     &  tanPhiAtU, tanPhiAtV,
     &  angleCosC, angleSinC, u2zonDir, v2zonDir,
     &  fCori, fCoriG, fCoriCos
      Real*8 dxC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dxV            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyC            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyF            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyG            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 dyU            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 R_low          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rLowS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Ro_surf        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfW         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rSurfS         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 hFacC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 hFacS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_dxC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dxV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyF      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyG      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_dyU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_Rcol     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_hFacC    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacW    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 recip_hFacS    (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 xC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 xG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yC             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 yG             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rA             (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAw            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAs            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 rAz            (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rA       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAw      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAs      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 recip_rAz      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInC        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInW        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskInS        (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 maskC          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskW          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 maskS          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 drC            (Nr+1)
      Real*8 drF            (Nr)
      Real*8 recip_drC      (Nr+1)
      Real*8 recip_drF      (Nr)
      Real*8 rC             (Nr)
      Real*8 rF             (Nr+1)
      Real*8 aHybSigmF      (Nr+1)
      Real*8 bHybSigmF      (Nr+1)
      Real*8 aHybSigmC      (Nr)
      Real*8 bHybSigmC      (Nr)
      Real*8 dAHybSigF      (Nr)
      Real*8 dBHybSigF      (Nr)
      Real*8 dBHybSigC      (Nr+1)
      Real*8 dAHybSigC      (Nr+1)
      Real*8 tanPhiAtU      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 tanPhiAtV      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleCosC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 angleSinC      (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 u2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 v2zonDir       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCori          (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriG         (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 fCoriCos       (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


C--   COMMON /GRID_I/ INTEGER valued grid defining variables.
C     kSurfC  :: vertical index of the surface tracer cell
C     kSurfW  :: vertical index of the surface U point
C     kSurfS  :: vertical index of the surface V point
C     kLowC   :: index of the r-lowest "wet cell" (2D)
C IMPORTANT: kSurfC,W,S = Nr+1 and kLowC = 0 where the fluid column
C            is empty (continent)
      COMMON /GRID_I/
     &  kSurfC, kSurfW, kSurfS,
     &  kLowC
      INTEGER kSurfC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfW(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kSurfS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      INTEGER kLowC (1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
c#include "DYNVARS.h"
c#include "FFIELDS.h"
C ==========================================================
C   Carbon chemistry variables
C ==========================================================

       COMMON /CARBON_NEEDS/
     &                      apCO2, AtmosP, pH, pCO2, FluxCO2,
     &                      wind, FIce, Silica
     &                      , apco20, apco21
      Real*8  apCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  AtmosP(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  pH(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8  pCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FluxCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  wind(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  FIce(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Silica(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco20(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  apco21(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)

C ==========================================================
C   Carbon and oxygen chemistry parameters
C ==========================================================

       COMMON /CARBON_CHEM/
     &                     ak0,ak1,ak2,akw,akb,aks,akf,
     &                     ak1p,ak2p,ak3p,aksi,fugf,
     &                     ff,ft,st,bt,
     &                     Ksp_TP_Calc,Ksp_TP_Arag
      Real*8  ak0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akw(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akb(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aks(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  akf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak1p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak2p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ak3p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  aksi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ff(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  fugf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  ft(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  st(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  bt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Calc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8  Ksp_TP_Arag(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


       COMMON /OXYGEN_CHEM/
     &                     oA0,oA1,oA2,oA3,oA4,oA5,
     &                     oB0,oB1,oB2,oB3,
     &                     oC0
      Real*8 oA0,oA1,oA2,oA3,oA4,oA5
      Real*8 oB0,oB1,oB2,oB3
      Real*8 oC0

       COMMON /GLOBAL_SURF_MEAN/
     &                          permil,Pa2Atm,epsln

C      permil : is conversion factor for mol/m3 to mol/kg
C               assumes uniform (surface) density
C      Pa2Atm : for conversion of atmospheric pressure
C               when coming from atmospheric model

      Real*8  permil
      Real*8  Pa2Atm
      Real*8  epsln

       COMMON /SCHMIDT_NO/
     &                    sca1, sca2, sca3, sca4,
     &                    sox1, sox2, sox3, sox4

C      Schmidt number coefficients

      Real*8  sca1,sca2,sca3,sca4
      Real*8  sox1,sox2,sox3,sox4

      integer apco2startdate1
      integer apco2startdate2
      Real*8     apco2StartTime
      Real*8     apco2period
      Real*8     apco2RepCycle
      Real*8     apco2const
      Real*8     apco2_exfremo_intercept
      Real*8     apco2_exfremo_slope
      CHARACTER*1 apco2mask

C ==========================================================
C   Bling inputs (specified in data.bling)
C
C  bling_k0_2dFile :: File containing a 2D spatial field of light attenuation
C        coefficient (k0_2d, in m^-1). This coefficient regulates underwater
C        light availability in the BLING model. If not specified, a constant
C        value k0 (default= 0.04 m^-1) is applied for entire domain.
C ==========================================================

       COMMON /BLING_INPUTS/
     &        bling_windFile, bling_atmospFile, bling_iceFile,
     &        bling_ironFile, bling_silicaFile,
     &        bling_psmFile, bling_plgFile, bling_pdiazFile,
     &        bling_forcingPeriod, bling_forcingCycle,
     &        bling_pCO2,
     &        river_conc_po4, river_dom_to_nut,
     &        bling_Pc_2dFile, bling_Pc_2d_diazFile,
     &        bling_k0_2dFile,
     &        bling_alpha_photo2dFile,bling_phi_DOM2dFile,
     &        bling_k_Fe2dFile, bling_k_Fe_diaz2dFile,
     &        bling_gamma_POM2dFile, bling_wsink0_2dFile,
     &        bling_phi_lg2dFile, bling_phi_sm2dFile
     &       ,apco2startdate1,apco2startdate2,
     &        apco2StartTime, apco2period, apco2RepCycle,
     &        apco2const,
     &        apco2_exfremo_intercept,
     &        apco2_exfremo_slope,
     &        apco2file, apco2mask

C      bling_windFile      :: file name of wind speeds
C      bling_atmospFile    :: file name of atmospheric pressure
C      bling_iceFile       :: file name of sea ice fraction
C      bling_ironFile      :: file name of aeolian iron flux
C      bling_silicaFile    :: file name of surface silica
C      bling_psmFile       :: file name of init small phyto biomass
C      bling_plgFile       :: file name of init lg phyto biomass
C      bling_pdiazFile     :: file name of init diaz biomass
C      bling_forcingPeriod :: period of forcing for biogeochemistry (seconds)
C      bling_forcingCycle  :: periodic forcing parameter for biogeochemistry
C      bling_pCO2          :: Atmospheric pCO2 to be read in data.bling
C      river_conc_trac     :: River concentration, bgc tracers
C      apco2               :: Atmospheric pCO2 to be read in with exf pkg

      CHARACTER*(MAX_LEN_FNAM) bling_windFile
      CHARACTER*(MAX_LEN_FNAM) bling_atmospFile
      CHARACTER*(MAX_LEN_FNAM) bling_iceFile
      CHARACTER*(MAX_LEN_FNAM) bling_ironFile
      CHARACTER*(MAX_LEN_FNAM) bling_silicaFile
      CHARACTER*(MAX_LEN_FNAM) bling_psmFile
      CHARACTER*(MAX_LEN_FNAM) bling_plgFile
      CHARACTER*(MAX_LEN_FNAM) bling_pdiazFile
      CHARACTER*(MAX_LEN_FNAM) bling_k0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_Pc_2d_diazFile
      CHARACTER*(MAX_LEN_FNAM) bling_alpha_photo2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_k_Fe_diaz2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_gamma_POM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_wsink0_2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_DOM2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_lg2dFile
      CHARACTER*(MAX_LEN_FNAM) bling_phi_sm2dFile
      CHARACTER*(MAX_LEN_FNAM) apco2file
      Real*8     bling_forcingPeriod
      Real*8     bling_forcingCycle
      Real*8     bling_pCO2
      Real*8     river_conc_po4
      Real*8     river_dom_to_nut

C ==========================================================
C   EXF input/output scaling factors for unit conversion if needed
C ==========================================================
      Real*8     exf_inscal_apco2
      Real*8     exf_outscal_apco2
      COMMON /BLG_PARAM_SCAL/
     &                    exf_inscal_apco2,
     &                    exf_outscal_apco2

C ==========================================================
C   EXF interpolation needs
C ==========================================================

C ==========================================================
C   Ecosystem variables and parameters
C ==========================================================
C     irr_mem       :: Phyto irradiance memory
C          this is a temporally smoothed field carried between timesteps,
C          to represent photoadaptation.
C   chlsat_locTimWindow(1:2) :: local-time window (in h) for
C          satellite-equivalent chlorophyll diagnostic (and cost)

      COMMON /BIOTIC_NEEDS/
     &                     InputFe,
     &                     omegaC,
     &                     omegaAr,
     &                     irr_mem,
     &                     phyto_lg,
     &                     phyto_sm,
     &                     chl,
     &                     chl_sat,
     &                     poc,
     &                     k0_2d,
     &                     Pc_0_2d,
     &                     k_Fe_2d,
     &                     wsink0_2d,
     &                     gamma_POM_2d,
     &                     phi_DOM_2d,
     &                     phi_sm_2d,
     &                     phi_lg_2d,
     &                     phyto_diaz,
     &                     Pc_0_diaz_2d,
     &                     k_Fe_diaz_2d,
     &                     alpha_photo_2d,
     &                     Pc_0_diaz,
     &                     alpha_photo,
     &                     gamma_DON,
     &                     k_Fe_diaz,
     &                     k_NO3,
     &                     k_NO3_sm,
     &                     k_NO3_lg,
     &                     k_PO4_sm,
     &                     k_PO4_lg,
     &                     k_Fe_sm,
     &                     k_Fe_lg,
     &                     k_PtoN,
     &                     k_FetoN,
     &                     PtoN_min,
     &                     PtoN_max,
     &                     FetoN_min,
     &                     FetoN_max,
     &                     kappa_eppley_diaz,
     &                     phi_dvm,
     &                     sigma_dvm,
     &                     CtoN,
     &                     CtoP,
     &                     NtoP,
     &                     HtoC,
     &                     NO3toN,
     &                     O2toN,
     &                     O2toP,
     &                     CatoN,
     &                     CatoP,
     &                     masstoN,
     &                     pivotal,
     &                     Pc_0,
     &                     lambda_0,
     &                     resp_frac,
     &                     chl_min,
     &                     theta_Fe_max_hi,
     &                     theta_Fe_max_lo,
     &                     gamma_irr_mem,
     &                     gamma_DOP,
     &                     gamma_POM,
     &                     k_O2,
     &                     k_Fe,
     &                     k_PO4,
     &                     kFe_eq_lig_max,
     &                     kFe_eq_lig_min,
     &                     kFe_eq_lig_Femin,
     &                     kFe_eq_lig_irr,
     &                     kFe_org,
     &                     kFe_inorg,
     &                     FetoC_sed,
     &                     remin_min,
     &                     oxic_min,
     &                     ligand,
     &                     kappa_eppley,
     &                     kappa_remin,
     &                     ca_remin_depth,
     &                     phi_DOM,
     &                     phi_sm,
     &                     phi_lg,
     &                     wsink0,
     &                     wsink0z,
     &                     wsinkacc,
     &                     parfrac,
     &                     alpfe,
     &                     k0,
     &                     MLmix_max,
     &                     chlsat_locTimWindow,
CAT(
     &                     swfrac_ir,
     &                     swfrac_rd,
     &                     swfrac_bg,
     &                     k0_rd,
     &                     k0_bg,
     &                     k_ir,
     &                     chi_rd,
     &                     chi_bg,
     &                     e_rd,
     &                     e_bg,
     &                     SWFrac3D
CAT)

      Real*8 InputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 omegaC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 omegaAr(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 irr_mem(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_lg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 phyto_sm(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 chl_sat(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 poc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 k0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 wsink0_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 gamma_POM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_DOM_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_sm_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phi_lg_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 phyto_diaz(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      Real*8 Pc_0_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 k_Fe_diaz_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 alpha_photo_2d(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      Real*8 Pc_0_diaz
      Real*8 alpha_photo
      Real*8 gamma_DON
      Real*8 k_Fe_diaz
      Real*8 k_NO3
      Real*8 k_NO3_sm
      Real*8 k_NO3_lg
      Real*8 k_PO4_sm
      Real*8 k_PO4_lg
      Real*8 k_Fe_sm
      Real*8 k_Fe_lg
      Real*8 k_PtoN
      Real*8 k_FetoN
      Real*8 PtoN_min
      Real*8 PtoN_max
      Real*8 FetoN_min
      Real*8 FetoN_max
      Real*8 kappa_eppley_diaz
      Real*8 phi_dvm
      Real*8 sigma_dvm
      Real*8 CtoN
      Real*8 CtoP
      Real*8 NtoP
      Real*8 HtoC
      Real*8 NO3toN
      Real*8 O2toN
      Real*8 O2toP
      Real*8 CatoN
      Real*8 CatoP
      Real*8 masstoN
      Real*8 pivotal
      Real*8 Pc_0
      Real*8 lambda_0
      Real*8 resp_frac
      Real*8 chl_min
      Real*8 theta_Fe_max_hi
      Real*8 theta_Fe_max_lo
      Real*8 gamma_irr_mem
      Real*8 gamma_DOP
      Real*8 gamma_POM
      Real*8 k_O2
      Real*8 k_Fe
      Real*8 k_PO4
      Real*8 kFe_eq_lig_max
      Real*8 kFe_eq_lig_min
      Real*8 kFe_eq_lig_Femin
      Real*8 kFe_eq_lig_irr
      Real*8 kFe_org
      Real*8 kFe_inorg
      Real*8 FetoC_sed
      Real*8 remin_min
      Real*8 oxic_min
      Real*8 ligand
      Real*8 kappa_eppley
      Real*8 kappa_remin
      Real*8 ca_remin_depth
      Real*8 phi_DOM
      Real*8 phi_sm
      Real*8 phi_lg
      Real*8 wsink0
      Real*8 wsink0z
      Real*8 wsinkacc
      Real*8 parfrac
      Real*8 alpfe
      Real*8 k0
      Real*8 MLmix_max
      Real*8 chlsat_locTimWindow(2)
CAT(
      Real*8 swfrac_ir(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_rd(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 swfrac_bg(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
C     SWFrac3D :: combined (ir+rd+bg) shortwave fraction profile,
C                 used by BLING_HEATING to penetrate Qsw in apply_forcing.F
      Real*8 SWFrac3D(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1,nSx,nSy)
      Real*8 k0_rd
      Real*8 k0_bg
      Real*8 k_ir
      Real*8 chi_rd
      Real*8 chi_bg
      Real*8 e_rd
      Real*8 e_bg
CAT)

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

C     == Routine arguments ==
C ttemp and stemp are local theta and salt arrays
C dont really need to pass T and S in, could use theta, salt in
C common block in DYNVARS.h, but this way keeps subroutine more
C general
        Real*8  ttemp(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
        Real*8  stemp(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
        INTEGER bi,bj,iMin,iMax,jMin,jMax
C K is depth index
        INTEGER Klevel
        INTEGER myThid
CEOP

C LOCAL VARIABLES
        Real*8  t
        Real*8  s
        Real*8  tk
        Real*8  tk100
        Real*8  tk1002
        Real*8  dlogtk
        Real*8  sqrtis
        Real*8  sqrts
        Real*8  s15
        Real*8  scl
        Real*8  s2
        Real*8  invtk
        Real*8  is
        Real*8  is2
c add Bennington
        Real*8  P1atm
        Real*8  Rgas
        Real*8  RT
        Real*8  delta
        Real*8  B1
        Real*8  B
        INTEGER i
        INTEGER j
        INTEGER k
        Real*8  bdepth
        Real*8  cdepth
        Real*8  pressc
        Real*8  Ksp_T_Calc
        Real*8  Ksp_T_Arag
        Real*8  xvalue
        Real*8  zdum
        Real*8  tmpa1
        Real*8  tmpa2
        Real*8  tmpa3
        Real*8  logKspc
        Real*8  logKspa
        Real*8  dv
        Real*8  dk
        Real*8  pfactor
        Real*8  bigR

C.....................................................................
C OCMIP note:
C Calculate all constants needed to convert between various measured
C carbon species. References for each equation are noted in the code.
C Once calculated, the constants are
C stored and passed in the common block "const". The original version
C of this code was based on the code by dickson in Version 2 of
C  Handbook of Methods C for the Analysis of the Various Parameters of
C the Carbon Dioxide System in Seawater , DOE, 1994 (SOP No. 3, p25-26).
C....................................................................

c determine pressure (bar) from depth
c 1 BAR at z=0m (atmos pressure)
c use UPPER surface of cell so top layer pressure = 0 bar
c for surface exchange coeffs

        bdepth = 0.0d0
        cdepth = 0.0d0
        pressc = 1.0d0
        do k = 1,Klevel
            cdepth = bdepth + 0.5d0*drF(k)
            bdepth = bdepth + drF(k)
            pressc = 1.0d0 + 0.1d0*cdepth
        end do

        bigR = 83.145D0
        P1atm = 1.01325D0 ! bars
        Rgas = 83.1451D0 ! bar*cm3/(mol*K)

        do i=imin,imax
         do j=jmin,jmax
          if (hFacC(i,j,Klevel,bi,bj).gt.0.d0) then
           t = ttemp(i,j)
           s = stemp(i,j)
C terms used more than once for:
C temperature
           tk = 273.15 + t
           tk100 = tk/100.0
           tk1002=tk100*tk100
           invtk=1.0/tk
           dlogtk=log(tk)
C ionic strength
           is=19.924*s/(1000.-1.005*s)
           is2=is*is
           sqrtis=sqrt(is)
C salinity
           s2=s*s
           sqrts=sqrt(s)
           s15=s**1.5
           scl=s/1.80655

C-----------------------------------------------------------------------
C Ariane adding this - copied from non-pressure-dep case
C added by Val Bennington Nov 2010
C Fugacity Factor needed for non-ideality in ocean
C ff used for atmospheric correction for water vapor and pressure
C Weiss (1974) Marine Chemistry
           RT = Rgas*tk
           delta = (57.7D0 - 0.118D0*tk)
           B1 = -1636.75D0 + 12.0408D0*tk - 0.0327957D0*tk*tk
           B = B1 + 3.16528D0*tk*tk*tk*(0.00001D0)
           fugf(i,j,bi,bj) = exp( (B+2.D0*delta) *
     &                            AtmosP(i,j,bi,bj) * P1atm / RT)
C------------------------------------------------------------------------
C f = k0(1-pH2O)*correction term for non-ideality
C Weiss & Price (1980, Mar. Chem., 8, 347-359; Eq 13 with table 6 values)
           ff(i,j,bi,bj) = exp(-162.8301 + 218.2968/tk100  +
     &          90.9241*log(tk100) - 1.47696*tk1002 +
     &          s * (.025695 - .025225*tk100 +
     &          0.0049867*tk1002))
C------------------------------------------------------------------------
C K0 from Weiss 1974
C Independent of pH scale
           ak0(i,j,bi,bj) = exp(93.4517/tk100 - 60.2409 +
     &        23.3585 * log(tk100) +
     &        s * (0.023517 - 0.023656*tk100 +
     &        0.0047036*tk1002))
C------------------------------------------------------------------------
C k1 = [H][HCO3]/[H2CO3]
C k2 = [H][CO3]/[HCO3]
C Millero p.664 (1995) using Mehrbach et al. data on seawater scale
C Both on seawater pH scale
           ak1(i,j,bi,bj)=10.**(-1.*(3670.7*invtk -
     &          62.008 + 9.7944*dlogtk -
     &          0.0118 * s + 0.000116*s2))
           ak2(i,j,bi,bj)=10.**(-1.*(1394.7*invtk + 4.777 -
     &          0.0184*s + 0.000118*s2))
C NOW PRESSURE DEPENDENCE:
c Following Takahashi (1981) GEOSECS report - quoting Culberson and
c Pytkowicz (1968)
c pressc = pressure in bars
           ak1(i,j,bi,bj) = ak1(i,j,bi,bj)*
     &             exp( (24.2-0.085*t)*(pressc-1.0)/(83.143*tk) )
c FIRST GO FOR K2: According to GEOSECS (1982) report
c          ak2(i,j,bi,bj) = ak2(i,j,bi,bj)*
c    &             exp( (26.4-0.040*t)*(pressc-1.0)/(83.143*tk) )
c SECOND GO FOR K2: corrected coeff according to CO2sys documentation
c                   E. Lewis and D. Wallace (1998) ORNL/CDIAC-105
           ak2(i,j,bi,bj) = ak2(i,j,bi,bj)*
     &             exp( (16.4-0.040*t)*(pressc-1.0)/(83.143*tk) )
C------------------------------------------------------------------------
C kb = [H][BO2]/[HBO2]
C Millero p.669 (1995) using data from dickson (1990)
C On total pH scale
           akb(i,j,bi,bj)=exp((-8966.90 - 2890.53*sqrts - 77.942*s +
     &          1.728*s15 - 0.0996*s2)*invtk +
     &          (148.0248 + 137.1942*sqrts + 1.62142*s) +
     &          (-24.4344 - 25.085*sqrts - 0.2474*s) *
     &          dlogtk + 0.053105*sqrts*tk)
C Mick and Karsten - Dec 04
C ADDING pressure dependence based on Millero (1995), p675
C with additional info from CO2sys documentation (E. Lewis and
C D. Wallace, 1998 - see endnotes for commentary on Millero, 95)
           dv = -29.48D0 + 0.1622D0*t + 2.608D-3*t*t
           dk = -2.84D-3
           pfactor = - (dv/(bigR*tk))*pressc
     &               + (0.5D0*dk/(bigR*tk))*pressc*pressc
           akb(i,j,bi,bj) = akb(i,j,bi,bj)*exp(pfactor)
C------------------------------------------------------------------------
C k1p = [H][H2PO4]/[H3PO4]
C DOE(1994) eq 7.2.20 with footnote using data from Millero (1974)
C The constant 115.525 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 115.540 constant to stay on the seawater
C  pH scale (everything else is the same).
           ak1p(i,j,bi,bj) = exp(-4576.752*invtk + 115.525 -
     &          18.453*dlogtk +
     &          (-106.736*invtk + 0.69171)*sqrts +
     &          (-0.65643*invtk - 0.01844)*s)
C------------------------------------------------------------------------
C k2p = [H][HPO4]/[H2PO4]
C DOE(1994) eq 7.2.23 with footnote using data from Millero (1974))
C The constant 172.0833 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 172.1033 constant to stay on the seawater
C  pH scale (everything else is the same).
           ak2p(i,j,bi,bj) = exp(-8814.715*invtk + 172.0883 -
     &          27.927*dlogtk +
     &          (-160.340*invtk + 1.3566) * sqrts +
     &          (0.37335*invtk - 0.05778) * s)
C------------------------------------------------------------------------
C k3p = [H][PO4]/[HPO4]
C DOE(1994) eq 7.2.26 with footnote using data from Millero (1974)
C The constant 18.141 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 18.126 constant to stay on the seawater
C  pH scale (everything else is the same).
           ak3p(i,j,bi,bj) = exp(-3070.75*invtk - 18.141 +
     &          (17.27039*invtk + 2.81197) *
     &          sqrts + (-44.99486*invtk - 0.09984) * s)
C------------------------------------------------------------------------
C ksi = [H][SiO(OH)3]/[Si(OH)4]
C Millero p.671 (1995) using data from Yao and Millero (1995)
C The constant 117.385 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 117.400 constant to stay on the seawater
C  pH scale (everything else is the same).
C Note: converted here from mol/kg-H2O to mol/kg-SW
           aksi(i,j,bi,bj) = exp(-8904.2*invtk + 117.385 -
     &          19.334*dlogtk +
     &          (-458.79*invtk + 3.5913) * sqrtis +
     &          (188.74*invtk - 1.5998) * is +
     &          (-12.1652*invtk + 0.07871) * is2 +
     &          log(1.0-0.001005*s))
C------------------------------------------------------------------------
C kw = [H][OH]
C Millero p.670 (1995) using composite data
C The constant 148.9652 is an approximation to convert to the total pH scale
C  (Dickson et al., 2007). Use Milleros 148.9802 constant to stay on the seawater
C  pH scale (everything else is the same).
           akw(i,j,bi,bj) = exp(-13847.26*invtk + 148.9652 -
     &          23.6521*dlogtk +
     &          (118.67*invtk - 5.977 + 1.0495 * dlogtk) *
     &          sqrts - 0.01615 * s)
C------------------------------------------------------------------------
C ks = [H][SO4]/[HSO4]
C dickson (1990, J. chem. Thermodynamics 22, 113)
C On the free pH scale
C Note: converted here from mol/kg-H2O to mol/kg-SW
           aks(i,j,bi,bj)=exp(-4276.1*invtk + 141.328 -
     &          23.093*dlogtk +
     &          (-13856*invtk + 324.57 - 47.986*dlogtk)*sqrtis +
     &          (35474*invtk - 771.54 + 114.723*dlogtk)*is -
     &          2698*invtk*is**1.5 + 1776*invtk*is2 +
     &          log(1.0 - 0.001005*s))
C------------------------------------------------------------------------
C kf = [H][F]/[HF]
C dickson and Riley (1979) -- change pH scale to total (following Dickson & Goyet, 1994)
C Note: converted here from mol/kg-H2O to mol/kg-SW
           akf(i,j,bi,bj)=exp(1590.2*invtk - 12.641 + 1.525*sqrtis +
     &          log(1.0 - 0.001005*s) +
     &          log(1.0 + (0.1400/96.062)*(scl)/aks(i,j,bi,bj)))
C------------------------------------------------------------------------
C Calculate concentrations for borate, sulfate, and fluoride
C Uppstrom (1974)
           bt(i,j,bi,bj) = 0.000232 * scl/10.811
C Morris & Riley (1966)
           st(i,j,bi,bj) = 0.14 * scl/96.062
C Riley (1965)
           ft(i,j,bi,bj) = 0.000067 * scl/18.9984
C------------------------------------------------------------------------


C------------------------------------------------------------------------
C solubility product for calcite
cav                  and aragonite
C
c Following Takahashi (1982) GEOSECS handbook
C NOT SURE THIS IS WORKING???
C Ingle et al. (1973)
c          Ksp_T_Calc = ( -34.452 - 39.866*(s**0.333333)
c    &                  + 110.21*log(s) - 7.5752d-6 * (tk**2.0)
c    &                  ) * 1.0d-7
c with pressure dependence Culberson and Pytkowicz (1968)
c          xvalue  =  (36-0.20*t)*(pressc-1.0)/(83.143*tk)
c          Ksp_TP_Calc(i,j,bi,bj) = Ksp_T_Calc*exp(xvalue)
c
c
C Following Mucci (1983) - from Zeebe/Wolf-Gladrow equic.m
         tmpa1 = - 171.9065 - (0.077993*tk) + (2839.319/tk)
     &            + (71.595*log10(tk))
         tmpa2 = +(-0.77712 + (0.0028426*tk) + (178.34/tk) )*sqrts
         tmpa3 = -(0.07711*s) + (0.0041249*s15)
         logKspc = tmpa1 + tmpa2 + tmpa3
         Ksp_T_Calc = 10.0**logKspc
C
         tmpa1 = - 171.945 - (0.077993*tk) + (2903.293/tk)
     &            + (71.595*log10(tk))
         tmpa2 = +(-0.068393 + (0.0017276*tk) + (88.135/tk) )*sqrts
         tmpa3 = -(0.10018*s) + (0.0059415*s15)
         logKspa = tmpa1 + tmpa2 + tmpa3
         Ksp_T_Arag = 10.0**logKspa

c with pressure dependence Culberson and Pytkowicz (1968)
c        xvalue  =  (36.0-0.20*t)*(pressc-1.0)/(83.143*tk)
c        Ksp_TP_Calc(i,j,bi,bj) = Ksp_T_Calc*exp(xvalue)

c alternative pressure depdendence
c following Millero (1995) but using info from Appendix A11 of
c Zeebe and Wolf-Gladrow (2001) book
c          dv = -48.6 - 0.5304*t
c          dk = -11.76d-3 - 0.3692*t
c          xvalue = - (dv/(bigR*tk))*pressc
c    &               + (0.5*dk/(bigR*tk))*pressc*pressc
c          Ksp_TP_Calc(i,j,bi,bj) = Ksp_T_Calc*exp(xvalue)

c alternative pressure dependence from Ingle (1975)

           zdum   = (pressc*10.0d0 - 10.0d0)/10.0d0
           xvalue = ( (48.8d0 - 0.53d0*t)*zdum
     &                 + (-0.00588d0 + 0.0001845d0*t)*zdum*zdum)
     &            / (188.93d0*(t + 273.15d0))

           Ksp_TP_Calc(i,j,bi,bj) = Ksp_T_Calc*10.**(xvalue)
           Ksp_TP_Arag(i,j,bi,bj) = Ksp_T_Arag*10.**(xvalue)

C------------------------------------------------------------------------
         else
            fugf(i,j,bi,bj) = 0.d0
            ff(i,j,bi,bj) = 0.d0
            ak0(i,j,bi,bj)= 0.d0
            ak1(i,j,bi,bj)= 0.d0
            ak2(i,j,bi,bj)= 0.d0
            akb(i,j,bi,bj)= 0.d0
            ak1p(i,j,bi,bj) = 0.d0
            ak2p(i,j,bi,bj) = 0.d0
            ak3p(i,j,bi,bj) = 0.d0
            aksi(i,j,bi,bj) = 0.d0
            akw(i,j,bi,bj) = 0.d0
            aks(i,j,bi,bj)= 0.d0
            akf(i,j,bi,bj)= 0.d0
            bt(i,j,bi,bj) = 0.d0
            st(i,j,bi,bj) = 0.d0
            ft(i,j,bi,bj) = 0.d0
            Ksp_TP_Calc(i,j,bi,bj) = 0.d0
            Ksp_TP_Arag(i,j,bi,bj) = 0.d0
         endif
         end do
        end do

        return
        end
