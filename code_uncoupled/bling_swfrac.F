#include "BLING_OPTIONS.h"

CBOP
      subroutine BLING_SWFRAC(
C     U               swfrac_ir, swfrac_rd, swfrac_bg
C     I               bi, bj, imin, imax, jmin, jmax,
     I               myIter, myTime, myThid )

C     =================================================================
C     | subroutine bling_swfrac
C     | o calculate fraction of incoming radiation at each level in each
C     |   band
C     =================================================================

      implicit none

C     === Global variables ===
C     swfrac_ir    ::   Fraction of incoming infrared radiation 
C     swfrac_rd    ::   Fraction of incoming red light
C     swfrac_bg    ::   Fraction of incoming blue-green light

#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "FFIELDS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "BLING_VARS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS_PARAMS.h"
#ifdef ALLOW_AUTODIFF
# include "tamc.h"
#endif
 
C     === Routine arguments ===
C     myTime        :: current time
C     myIter        :: current timestep
C     myThid        :: thread Id. number
       
      INTEGER myThid
      INTEGER myIter
      _RL     myTime
C     === Output ===

C     === Local variables ===
C     i, j, k  :: indices
C     bi, bj   :: tile indices
C     kChl_rd  :: attenuation coefficient for red light
C     kChl_bg  :: attenuation coefficient for blue-green light
C     atten_ir :: path length for infra-red light
C     atten_rd :: path length for red light
C     atten_bg :: path length for blue-green light

      INTEGER bi, bj, i, j, k
      _RL     kChl_rd
      _RL     kChl_bg
      _RL     atten_ir
      _RL     atten_rd
      _RL     atten_bg

      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO j = 1, sNy
         DO i = 1, sNx
          DO k=1,Nr
           IF (hFacC(i,j,k,bi,bj).gt.0) THEN
            IF (k.eq.1) THEN
             swfrac_ir(i,j,k,bi,bj) = (1 _d 0  - parfrac) 
             swfrac_rd(i,j,k,bi,bj) = parfrac / 2 _d 0
             swfrac_bg(i,j,k,bi,bj) = parfrac  / 2 _d 0
            ELSE
c  Attenuation coefficient adjusted to chlorophyll in kth layer
             kChl_rd = k0_rd + chi_rd * (chl(i,j,k-1,bi,bj)**e_rd)
             kChl_bg = k0_bg + chi_bg * (chl(i,j,k-1,bi,bj)**e_bg)
c  Light attenuation from one more layer
             atten_ir = k_ir           * drF(k-1) * hFacC(i,j,k-1,bi,bj)
             atten_rd = kChl_rd * drF(k-1) * hFacC(i,j,k-1,bi,bj)
             atten_bg = kChl_bg * drF(k-1) * hFacC(i,j,k-1,bi,bj)
c  Irradiance at bottom of cell
             swfrac_ir(i,j,k,bi,bj) = swfrac_ir(i,j,k-1,bi,bj)
     &         * exp(-atten_ir)
             swfrac_rd(i,j,k,bi,bj) = swfrac_rd(i,j,k-1,bi,bj)
     &         * exp(-atten_rd)
             swfrac_bg(i,j,k,bi,bj) = swfrac_bg(i,j,k-1,bi,bj)
     &         * exp(-atten_bg)
            ENDIF
           ENDIF
          ENDDO
         ENDDO
        ENDDO
       ENDDO
      ENDDO

C update overlap regions
      _EXCH_XYZ_RL( swfrac_ir, myThid )
      _EXCH_XYZ_RL( swfrac_rd, myThid )
      _EXCH_XYZ_RL( swfrac_bg, myThid )

      CALL DIAGNOSTICS_FILL(swfrac_ir ,'FRACIR  ',0,Nr,0,1,1,myThid)
      CALL DIAGNOSTICS_FILL(swfrac_rd ,'FRACRD  ',0,Nr,0,1,1,myThid)
      CALL DIAGNOSTICS_FILL(swfrac_bg ,'FRACBG  ',0,Nr,0,1,1,myThid)

      RETURN
      END
