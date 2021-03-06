cc ------------ dpmjet3.4 - authors: S.Roesler, R.Engel, J.Ranft -------
cc -------- phojet1.12-40 - authors: S.Roesler, R.Engel, J.Ranft -------
cc                                                      - oct'13 -------
cc ----------- pythia-6.4 - authors: Torbjorn Sjostrand, Lund'10 -------
cc ---------------------------------------------------------------------
cc                                  converted for use with FLUKA -------
cc                                                      - oct'13 -------
 
C...PYTBBN
C...Calculates the three-body decay of gluinos into
C...neutralinos and third generation fermions.
 
      SUBROUTINE PYTBBN(I,NN,E,XMGLU,GAM)
 
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      IMPLICIT INTEGER(I-N)
      INTEGER PYCOMP
C...Parameter statement to help give large particle numbers.
      PARAMETER (KSUSY1=1000000,KSUSY2=2000000,KTECHN=3000000,
     &KEXCIT=4000000,KDIMEN=5000000)
C...Commonblocks.
      include 'inc/pydat1'
      include 'inc/pydat2'
      include 'inc/pymssm'
      include 'inc/pyssmt'
 
C...Local variables.
      EXTERNAL PYSIMP,PYLAMF
      DOUBLE PRECISION PYSIMP,PYLAMF
      INTEGER LIN,NN
      DOUBLE PRECISION COSD,SIND,COSD2,SIND2,COS2D,SIN2D
      DOUBLE PRECISION HL,HR,FL,FR,HL2,HR2,FL2,FR2
      DOUBLE PRECISION XMS2(2),XM,XM2,XMG,XMG2,XMR,XMR2
      DOUBLE PRECISION SBAR,SMIN,SMAX,XMQA,W,GRS,G(0:6),SUMME(0:100)
      DOUBLE PRECISION FF,HH,HFL,HFR,HRFL,HLFR,XMQ4,XM24
      DOUBLE PRECISION XLN1,XLN2,B1,B2
      DOUBLE PRECISION E,XMGLU,GAM
      DOUBLE PRECISION HRB(4),HLB(4),FLB(4),FRB(4)
      SAVE HRB,HLB,FLB,FRB
      DOUBLE PRECISION ALPHAW,ALPHAS
      DOUBLE PRECISION HLT(4),HRT(4),FLT(4),FRT(4)
      SAVE HLT,HRT,FLT,FRT
      DOUBLE PRECISION AMN(4),AN(4,4),ZN(3)
      SAVE AMN,AN,ZN
      DOUBLE PRECISION AMBOT,SINC,COSC
      DOUBLE PRECISION AMTOP,SINA,COSA
      DOUBLE PRECISION SINW,COSW,TANW
      DOUBLE PRECISION ROT1(4,4)
      LOGICAL IFIRST
      SAVE IFIRST
      DATA IFIRST/.TRUE./
 
      TANB=RMSS(5)
      SINB=TANB/SQRT(1D0+TANB**2)
      COSB=SINB/TANB
      XW=PARU(102)
      SINW=SQRT(XW)
      COSW=SQRT(1D0-XW)
      TANW=SINW/COSW
      AMW=PMAS(24,1)
      COSC=SFMIX(5,1)
      SINC=SFMIX(5,3)
      COSA=SFMIX(6,1)
      SINA=SFMIX(6,3)
      AMBOT=PYMRUN(5,XMGLU**2)
      AMTOP=PYMRUN(6,XMGLU**2)
      W2=SQRT(2D0)
      FAKT1=AMBOT/W2/AMW/COSB
      FAKT2=AMTOP/W2/AMW/SINB
      IF(IFIRST) THEN
        DO 110 II=1,4
          AMN(II)=SMZ(II)
          DO 100 J=1,4
            ROT1(II,J)=0D0
            AN(II,J)=0D0
  100     CONTINUE
  110   CONTINUE
        ROT1(1,1)=COSW
        ROT1(1,2)=-SINW
        ROT1(2,1)=-ROT1(1,2)
        ROT1(2,2)=ROT1(1,1)
        ROT1(3,3)=COSB
        ROT1(3,4)=SINB
        ROT1(4,3)=-ROT1(3,4)
        ROT1(4,4)=ROT1(3,3)
        DO 140 II=1,4
          DO 130 J=1,4
            DO 120 JJ=1,4
              AN(II,J)=AN(II,J)+ZMIX(II,JJ)*ROT1(JJ,J)
  120       CONTINUE
  130     CONTINUE
  140   CONTINUE
        DO 150 J=1,4
          ZN(1)=-FAKT2*(-SINB*AN(J,3)+COSB*AN(J,4))
          ZN(2)=-2D0*W2/3D0*SINW*(TANW*AN(J,2)-AN(J,1))
          ZN(3)=-2*W2/3D0*SINW*AN(J,1)-W2*(0.5D0-2D0/3D0*
     &    XW)*AN(J,2)/COSW
          HRT(J)=ZN(1)*COSA-ZN(3)*SINA
          HLT(J)=ZN(1)*COSA+ZN(2)*SINA
          FLT(J)=ZN(3)*COSA+ZN(1)*SINA
          FRT(J)=ZN(2)*COSA-ZN(1)*SINA
C          FLU(J)=ZN(3)
C          FRU(J)=ZN(2)
          ZN(1)=-FAKT1*(COSB*AN(J,3)+SINB*AN(J,4))
          ZN(2)=W2/3D0*SINW*(TANW*AN(J,2)-AN(J,1))
          ZN(3)=W2/3D0*SINW*AN(J,1)+W2*(0.5D0-XW/3D0)*AN(J,2)/COSW
          HRB(J)=ZN(1)*COSC-ZN(3)*SINC
          HLB(J)=ZN(1)*COSC+ZN(2)*SINC
          FLB(J)=ZN(3)*COSC+ZN(1)*SINC
          FRB(J)=ZN(2)*COSC-ZN(1)*SINC
C          FLD(J)=ZN(3)
C          FRD(J)=ZN(2)
  150   CONTINUE
C        AMST(1)=PMAS(PYCOMP(KSUSY1+6),1)
C        AMST(2)=PMAS(PYCOMP(KSUSY2+6),1)
C        AMSB(1)=PMAS(PYCOMP(KSUSY1+5),1)
C        AMSB(2)=PMAS(PYCOMP(KSUSY2+5),1)
        IFIRST=.FALSE.
      ENDIF
 
      IF(NINT(3D0*E).EQ.2) THEN
        HL=HLT(I)
        HR=HRT(I)
        FL=FLT(I)
        FR=FRT(I)
        COSD=SFMIX(6,1)
        SIND=SFMIX(6,3)
        XMS2(1)=PMAS(PYCOMP(KSUSY1+6),1)**2
        XMS2(2)=PMAS(PYCOMP(KSUSY2+6),1)**2
        XM=PMAS(6,1)
      ELSE
        HL=HLB(I)
        HR=HRB(I)
        FL=FLB(I)
        FR=FRB(I)
        COSD=SFMIX(5,1)
        SIND=SFMIX(5,3)
        XMS2(1)=PMAS(PYCOMP(KSUSY1+5),1)**2
        XMS2(2)=PMAS(PYCOMP(KSUSY2+5),1)**2
        XM=PMAS(5,1)
      ENDIF
      COSD2=COSD*COSD
      SIND2=SIND*SIND
      COS2D=COSD2-SIND2
      SIN2D=SIND*COSD*2D0
      HL2=HL*HL
      HR2=HR*HR
      FL2=FL*FL
      FR2=FR*FR
      FF=FL*FR
      HH=HL*HR
      HFL=HL*FL
      HFR=HR*FR
      HRFL=HR*FL
      HLFR=HL*FR
      XM2=XM*XM
      XMG=XMGLU
      XMG2=XMG*XMG
      ALPHAW=PYALEM(XMG2)
      ALPHAS=PYALPS(XMG2)
      XMR=AMN(I)
      XMR2=XMR*XMR
      XMQ4=XMG*XM2*XMR
      XM24=(XMG2+XM2)*(XM2+XMR2)
      SMIN=4D0*XM2
      SMAX=(XMG-ABS(XMR))**2
      XMQA=XMG2+2D0*XM2+XMR2
      DO 170 LIN=1,NN-1
        SBAR=SMIN+DBLE(LIN)*(SMAX-SMIN)/DBLE(NN)
        GRS=SBAR-XMQA
        W=PYLAMF(XMG2,XMR2,SBAR)*(0.25D0-XM2/SBAR)
        W=SQRT(W)
        XLN1=LOG(ABS((GRS/2D0+XMS2(1)-W)/(GRS/2D0+XMS2(1)+W)))
        XLN2=LOG(ABS((GRS/2D0+XMS2(2)-W)/(GRS/2D0+XMS2(2)+W)))
        B1=1D0/(GRS/2D0+XMS2(1)-W)-1D0/(GRS/2D0+XMS2(1)+W)
        B2=1D0/(GRS/2D0+XMS2(2)-W)-1D0/(GRS/2D0+XMS2(2)+W)
        G(0)=-2D0*(HL2+FL2+HR2+FR2+(HFR-HFL)*SIN2D
     &  +2D0*(FF*SIND2-HH*COSD2))*W
        G(1)=((HL2+FL2)*(XMQA-2D0*XMS2(1)-2D0*XM*XMG*SIN2D)
     &  +4D0*HFL*XM*XMR)*XLN1
     &  +((HL2+FL2)*((XMQA-XMS2(1))*XMS2(1)-XM24
     &  +2D0*XM*XMG*(XM2+XMR2-XMS2(1))*SIN2D)
     &  -4D0*HFL*XMR*XM*(XMG2+XM2-XMS2(1))
     &  +8D0*HFL*XMQ4*SIN2D)*B1
        G(2)=((HR2+FR2)*(XMQA-2D0*XMS2(2)+2D0*XM*XMG*SIN2D)
     &  +4D0*HFR*XMR*XM)*XLN2
     &  +((HR2+FR2)*((XMQA-XMS2(2))*XMS2(2)-XM24
     &  +2D0*XMG*XM*SIN2D*(XMS2(2)-XM2-XMR2))
     &  +4D0*HFR*XM*XMR*(XMS2(2)-XMG2-XM2)
     &  -8D0*HFR*XMQ4*SIN2D)*B2
        G(3)=(2D0*HFL*SIN2D*(XMS2(1)*(GRS+XMS2(1))+XM2*(SBAR-XMG2-XMR2)
     &  +XMG2*XMR2+XM2*XM2)-2D0*XMR*XMG*(HL2*SIND2+FL2*COSD2)*SBAR
     &  -2D0*XMG*XM*HFL*(SBAR+XMR2-XMG2)
     &  +XMR*XM*(HL2+FL2)*SIN2D*(SBAR+XMG2-XMR2)
     &  -4D0*XMQ4*(HL2-FL2)*COS2D)/(GRS+2D0*XMS2(1))*XLN1
        G(4)=4D0*COS2D*XM*XMG/(XMS2(1)-XMS2(2))*
     &  (((HLFR+HRFL)*(XM2+XMR2)+2D0*XM*XMR*(HH+FF))*(XLN1-XLN2)
     &  +(HLFR+HRFL)*(XMS2(2)*XLN2-XMS2(1)*XLN1))
        G(5)=(2D0*(HH*COSD2-FF*SIND2)
     &  *((XMS2(2)*(XMS2(2)+GRS)+XM2*XM2+XMG2*XMR2)*XLN2
     &  +(XMS2(1)*(XMS2(1)+GRS)+XM2*XM2+XMG2*XMR2)*XLN1)
     &  +XM*((HH-FF)*SIN2D*XMG-(HRFL-HLFR)*XMR)
     &  *((GRS+XMS2(1)*2D0)*XLN1-(GRS+XMS2(2)*2D0)*XLN2)
     &  +((HRFL-HLFR)*XMR*(SIN2D*XMG*(SBAR-4D0*XM2)
     &  +COS2D*XM*(SBAR+XMG2-XMR2))
     &  +2D0*(FF*COSD2-HH*SIND2)*XM2*(SBAR-XMG2-XMR2))
     &  *(XLN1+XLN2))/(GRS+XMS2(1)+XMS2(2))
        G(6)=(-2D0*HFR*SIN2D*(XMS2(2)*(GRS+XMS2(2))+XM2*(SBAR-XMG2-XMR2)
     &  +XMG2*XMR2+XM2*XM2)-2D0*XMR*XMG*(HR2*SIND2+FR2*COSD2)*SBAR
     &  -2D0*XMG*XM*HFR*(SBAR+XMR2-XMG2)
     &  -XMR*XM*(HR2+FR2)*SIN2D*(SBAR+XMG2-XMR2)
     &  -4D0*XMQ4*(HR2-FR2)*COS2D)/(GRS+2D0*XMS2(2))*XLN2
        SUMME(LIN)=0D0
        DO 160 J=0,6
          SUMME(LIN)=SUMME(LIN)+G(J)
  160   CONTINUE
  170 CONTINUE
      SUMME(0)=0D0
      SUMME(NN)=0D0
      GAM = ALPHAW * ALPHAS * PYSIMP(SUMME,SMIN,SMAX,NN)
     &/ (16D0 * PARU(1) * PARU(102) * XMGLU**3)
 
      RETURN
      END
