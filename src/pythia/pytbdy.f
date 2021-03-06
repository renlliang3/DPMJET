cc ------------ dpmjet3.4 - authors: S.Roesler, R.Engel, J.Ranft -------
cc -------- phojet1.12-40 - authors: S.Roesler, R.Engel, J.Ranft -------
cc                                                      - oct'13 -------
cc ----------- pythia-6.4 - authors: Torbjorn Sjostrand, Lund'10 -------
cc ---------------------------------------------------------------------
cc                                  converted for use with FLUKA -------
cc                                                      - oct'13 -------
 
C...PYTBDY
C...Generates 3-body decays of gauginos.
 
      SUBROUTINE PYTBDY(IDIN)
 
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      IMPLICIT INTEGER(I-N)
      INTEGER PYCOMP

C...Parameter statement to help give large particle numbers.
      PARAMETER (KSUSY1=1000000,KSUSY2=2000000,KTECHN=3000000,
     &KEXCIT=4000000,KDIMEN=5000000)
C...Commonblocks.
      include 'inc/pyjets'
      include 'inc/pydat1'
      include 'inc/pydat2'
C     COMMON/PYDAT3/MDCY(500,3),MDME(8000,2),BRAT(8000),KFDP(8000,5)
      include 'inc/pypars'
      include 'inc/pyssmt'
 
C...Local variables.
      DOUBLE PRECISION XM(5)
      COMPLEX*16 OLPP,ORPP,QLL,QLR,QRR,QRL,GLIJ,GRIJ,PROPZ
      COMPLEX*16 QLLS,QRRS,QLRS,QRLS,QLLU,QRRU,QLRT,QRLT
      COMPLEX*16 ZMIXC(4,4),UMIXC(2,2),VMIXC(2,2)
      DOUBLE PRECISION S12MIN,S12MAX,YJACO1,S23AVE,S23DF1,S23DF2
      DOUBLE PRECISION D1,D2,D3,P1,P2,P3,CTHE1,STHE1,CTHE3,STHE3
      DOUBLE PRECISION CPHI1,SPHI1
      DOUBLE PRECISION S23DEL,EPS
C unvar      DOUBLE PRECISION GOLDEN,AX,BX,CX,TOL,XMIN,R,C
      DOUBLE PRECISION GOLDEN,AX,BX,CX,TOL,R,C
      PARAMETER (R=0.61803399D0,C=1D0-R,TOL=1D-3)
      DOUBLE PRECISION F1,F2,X0,X1,X2,X3
      INTEGER INOID(4)
      DATA INOID/22,23,25,35/
      DATA EPS/1D-6/
 
      ID=IDIN
      ISKIP=1
      XM(1)=P(N+1,5)
      XM(2)=P(N+2,5)
      XM(3)=P(N+3,5)
      XM(5)=P(ID,5)
 
C...GENERATE S12
      S12MIN=(XM(1)+XM(2))**2
      S12MAX=(XM(5)-XM(3))**2
      YJACO1=S12MAX-S12MIN
 
C...Initialize some parameters
      XW=PARU(102)
      XW1=1D0-XW
      TANW=SQRT(XW/XW1)
      IZID1=0
      IWID1=0
      IZID2=0
      IWID2=0

      IA=K(N+2,2)
      JA=K(N+3,2)

C...Mrenna: check that we are indeed decaying a SUSY particle
      IF(ABS(K(ID,2)).LT.KSUSY1.OR.ABS(K(ID,2)).GE.3000000) THEN
      
      ELSE
        DO 100 I1=1,4
          IF(MOD(K(N+1,2),KSUSY1).EQ.INOID(I1)) IZID1=I1
          IF(MOD(K(ID,2),KSUSY1).EQ.INOID(I1)) IZID2=I1
 100    CONTINUE
        IF(MOD(K(N+1,2),KSUSY1).EQ.24) IWID1=1
        IF(MOD(K(N+1,2),KSUSY1).EQ.37) IWID1=2
        IF(MOD(K(ID,2),KSUSY1).EQ.24) IWID2=1
        IF(MOD(K(ID,2),KSUSY1).EQ.37) IWID2=2
        ZM12=XM(5)**2
        ZM22=XM(1)**2
        EI=KCHG(PYCOMP(ABS(IA)),1)/3D0
        T3I=SIGN(1D0,EI+1D-6)/2D0
      ENDIF

      IF(MSTP(47).EQ.0) THEN
        ISKIP=0
      ELSEIF(MAX(ABS(IA),ABS(JA)).EQ.6) THEN
        ISKIP=0
      ELSEIF(IZID1*IZID2.NE.0) THEN
        SQMZ=PMAS(23,1)**2
        GMMZ=PMAS(23,1)*PMAS(23,2)
        DO 110 I=1,4
          ZMIXC(IZID1,I)=CMPLX(ZMIX(IZID1,I),ZMIXI(IZID1,I))
          ZMIXC(IZID2,I)=CMPLX(ZMIX(IZID2,I),ZMIXI(IZID2,I))
  110   CONTINUE
        OLPP=(ZMIXC(IZID1,3)*CONJG(ZMIXC(IZID2,3))-
     &  ZMIXC(IZID1,4)*CONJG(ZMIXC(IZID2,4)))/2D0
        ORPP=CONJG(OLPP)
        XLL2=PMAS(PYCOMP(KSUSY1+ABS(IA)),1)**2
        XLR2=XLL2
        XRR2=PMAS(PYCOMP(KSUSY2+ABS(IA)),1)**2
        XRL2=XRR2
        GLIJ=(T3I*ZMIXC(IZID1,2)-TANW*(T3I-EI)*ZMIXC(IZID1,1))*
     &  CONJG(T3I*ZMIXC(IZID2,2)-TANW*(T3I-EI)*ZMIXC(IZID2,1))
        GRIJ=ZMIXC(IZID1,1)*CONJG(ZMIXC(IZID2,1))*(EI*TANW)**2
        XM1M2=SMZ(IZID1)*SMZ(IZID2)
        QLLS=CMPLX((T3I-EI*XW)/XW1)*OLPP
        QLLU=-GLIJ
        QLRS=-CMPLX((T3I-EI*XW)/XW1)*ORPP
        QLRT=CONJG(GLIJ)
        QRLS=-CMPLX((EI*XW)/XW1)*OLPP
        QRLT=GRIJ
        QRRS=CMPLX((EI*XW)/XW1)*ORPP
        QRRU=-CONJG(GRIJ)
      ELSEIF(IZID1*IWID2.NE.0.OR.IZID2*IWID1.NE.0) THEN
        IF(IZID1.NE.0) THEN
          XM1M2=SMZ(IZID1)*SMW(IWID2)
          IZID1=IWID2
          IZID2=IZID1
        ELSE
          XM1M2=SMZ(IZID2)*SMW(IWID1)
          IZID1=IWID1
        ENDIF
        RT2I = 1D0/SQRT(2D0)
        SQMZ=PMAS(24,1)**2
        GMMZ=PMAS(24,1)*PMAS(24,2)
        DO 120 I=1,2
          VMIXC(IZID1,I)=CMPLX(VMIX(IZID1,I),VMIXI(IZID1,I))
          UMIXC(IZID1,I)=CMPLX(UMIX(IZID1,I),UMIXI(IZID1,I))
  120   CONTINUE
        DO 130 I=1,4
          ZMIXC(IZID2,I)=CMPLX(ZMIX(IZID2,I),ZMIXI(IZID2,I))
  130   CONTINUE
        QLLS=(CONJG(ZMIXC(IZID2,2))*VMIXC(IZID1,1)-
     &  CONJG(ZMIXC(IZID2,4))*VMIXC(IZID1,2)*RT2I)
        QLRS=(ZMIXC(IZID2,2)*CONJG(UMIXC(IZID1,1))+
     &  ZMIXC(IZID2,3)*CONJG(UMIXC(IZID1,2))*RT2I)
        EJ=KCHG(ABS(JA),1)/3D0
        T3J=SIGN(1D0,EJ+1D-6)/2D0
        QRLS=CMPLX(0D0,0D0)
        QRLT=QRLS
        QRRS=QRLS
        QRRU=QRLS
        XRR2=1D6**2
        XRL2=XRR2
        XLR2  = PMAS(PYCOMP(KSUSY1+ABS(JA)),1)**2
        XLL2  = PMAS(PYCOMP(KSUSY1+ABS(IA)),1)**2
        IF(MOD(IA,2).EQ.0) THEN
          QLLU=VMIXC(IZID1,1)*CONJG(ZMIXC(IZID2,1)*(EI-T3I)*
     &    TANW+ZMIXC(IZID2,2)*T3I)
          QLRT=-CONJG(UMIXC(IZID1,1))*(
     &    ZMIXC(IZID2,1)*(EJ-T3J)*TANW+ZMIXC(IZID2,2)*T3J)
        ELSE
          QLLU=VMIXC(IZID1,1)*CONJG(ZMIXC(IZID2,1)*(EJ-T3J)*
     &    TANW+ZMIXC(IZID2,2)*T3J)
          QLRT=-CONJG(UMIXC(IZID1,1))*(
     &    ZMIXC(IZID2,1)*(EI-T3I)*TANW+ZMIXC(IZID2,2)*T3I)
        ENDIF
      ELSEIF(IWID1*IWID2.NE.0) THEN
        IZID1=IWID1
        IZID2=IWID2
        XM1M2=SMW(IWID1)*SMW(IWID2)
        SQMZ=PMAS(23,1)**2
        GMMZ=PMAS(23,1)*PMAS(23,2)
        DO 140 I=1,2
          VMIXC(IZID1,I)=CMPLX(VMIX(IZID1,I),VMIXI(IZID1,I))
          UMIXC(IZID1,I)=CMPLX(UMIX(IZID1,I),UMIXI(IZID1,I))
          VMIXC(IZID2,I)=CMPLX(VMIX(IZID2,I),VMIXI(IZID2,I))
          UMIXC(IZID2,I)=CMPLX(UMIX(IZID2,I),UMIXI(IZID2,I))
  140   CONTINUE
        OLPP=-VMIXC(IZID2,1)*CONJG(VMIXC(IZID1,1))-
     &  VMIXC(IZID2,2)*CONJG(VMIXC(IZID1,2))/2D0
        ORPP=-UMIXC(IZID1,1)*CONJG(UMIXC(IZID2,1))-
     &  UMIXC(IZID1,2)*CONJG(UMIXC(IZID2,2))/2D0
        QRLS=-CMPLX(EI/XW1)*ORPP
        QLLS=CMPLX((T3I-XW*EI)/XW/XW1)*ORPP
        QRRS=-CMPLX(EI/XW1)*OLPP
        QLRS=CMPLX((T3I-XW*EI)/XW/XW1)*OLPP
        IF(MOD(IA,2).EQ.0) THEN
          XLR2=PMAS(PYCOMP(KSUSY1+ABS(IA)-1),1)**2
          QLRT=-UMIXC(IZID2,1)*CONJG(UMIXC(IZID1,1))*CMPLX(T3I/XW)
        ELSE
          XLR2=PMAS(PYCOMP(KSUSY1+ABS(IA)+1),1)**2
          QLRT=-VMIXC(IZID2,1)*CONJG(VMIXC(IZID1,1))*CMPLX(T3I/XW)
        ENDIF
      ELSEIF(MOD(K(N+1,2),KSUSY1).EQ.21.OR.MOD(K(ID,2),KSUSY1).EQ.21)
     &THEN
        ISKIP=0
      ELSE
        ISKIP=0
      ENDIF
 
      IF(ISKIP.NE.0) THEN
        WTMAX=0D0
        DO 160 KT=1,100
          S12=S12MIN+YJACO1*(KT-1)/99
          S23AVE=XM(2)**2+XM(3)**2-(S12+XM(2)**2-XM(1)**2)
     &    *(S12+XM(3)**2-XM(5)**2)/(2D0*S12)
          S23DF1=(S12-XM(2)**2-XM(1)**2)**2
     &    -(2D0*XM(1)*XM(2))**2
          S23DF2=(S12-XM(3)**2-XM(5)**2)**2
     &    -(2D0*XM(3)*XM(5))**2
          S23DF1=S23DF1*EPS
          S23DF2=S23DF2*EPS
          S23DEL=SQRT(MAX(0D0,S23DF1*S23DF2))/(2D0*S12)
          S23DEL=S23DEL/EPS
          S23MIN=S23AVE-S23DEL
          S23MAX=S23AVE+S23DEL
          YJACO2=S23MAX-S23MIN
          TH=S12
          DO 150 KS=1,100
            S23=S23MIN+YJACO2*(KS-1)/99
            SH=S23
            UH=ZM12+ZM22-SH-TH
            WU2 = (UH-ZM12)*(UH-ZM22)
            WT2 = (TH-ZM12)*(TH-ZM22)
            WS2 = XM1M2*SH
            PROPZ2 = (SH-SQMZ)**2 + GMMZ**2
            PROPZ=CMPLX(SH-SQMZ,-GMMZ)/CMPLX(PROPZ2)
            QLL=QLLS*PROPZ+QLLU/CMPLX(UH-XLL2)
            QLR=QLRS*PROPZ+QLRT/CMPLX(TH-XLR2)
            QRL=QRLS*PROPZ+QRLT/CMPLX(TH-XRL2)
            QRR=QRRS*PROPZ+QRRU/CMPLX(UH-XRR2)
            WT0=-((ABS(QLL)**2+ABS(QRR)**2)*WU2+
     &      (ABS(QRL)**2+ABS(QLR)**2)*WT2+
     &      2D0*DBLE(QLR*CONJG(QLL)+QRL*CONJG(QRR))*WS2)
            IF(WT0.GT.WTMAX) WTMAX=WT0
  150     CONTINUE
  160   CONTINUE
 
        WTMAX=WTMAX*1.05D0
      ENDIF
 
C...FIND S12*
      AX=S12MIN
      CX=S12MAX
      BX=S12MIN+0.5D0*YJACO1
      X0=AX
      X3=CX
      IF(ABS(CX-BX).GT.ABS(BX-AX))THEN
        X1=BX
        X2=BX+C*(CX-BX)
      ELSE
        X2=BX
        X1=BX-C*(BX-AX)
      ENDIF
 
C...SOLVE FOR F1 AND F2
      S23DF1=(X1-XM(2)**2-XM(1)**2)**2
     &-(2D0*XM(1)*XM(2))**2
      S23DF2=(X1-XM(3)**2-XM(5)**2)**2
     &-(2D0*XM(3)*XM(5))**2
      S23DF1=S23DF1*EPS
      S23DF2=S23DF2*EPS
      S23DEL=SQRT(MAX(0D0,S23DF1*S23DF2))/(2D0*X1)
      F1=-2D0*S23DEL/EPS
      S23DF1=(X2-XM(2)**2-XM(1)**2)**2
     &-(2D0*XM(1)*XM(2))**2
      S23DF2=(X2-XM(3)**2-XM(5)**2)**2
     &-(2D0*XM(3)*XM(5))**2
      S23DF1=S23DF1*EPS
      S23DF2=S23DF2*EPS
      S23DEL=SQRT(MAX(0D0,S23DF1*S23DF2))/(2D0*X2)
      F2=-2D0*S23DEL/EPS
 
  170 IF(ABS(X3-X0).GT.TOL*(ABS(X1)+ABS(X2)))THEN
C...Possibility of infinite loop with .LT.; changed to .LE. (SKANDS)
        IF(F2.LE.F1)THEN
          X0=X1
          X1=X2
          X2=R*X1+C*X3
          F1=F2
          S23DF1=(X2-XM(2)**2-XM(1)**2)**2
     &    -(2D0*XM(1)*XM(2))**2
          S23DF2=(X2-XM(3)**2-XM(5)**2)**2
     &    -(2D0*XM(3)*XM(5))**2
          S23DF1=S23DF1*EPS
          S23DF2=S23DF2*EPS
          S23DEL=SQRT(MAX(0D0,S23DF1*S23DF2))/(2D0*X2)
          F2=-2D0*S23DEL/EPS
        ELSE
          X3=X2
          X2=X1
          X1=R*X2+C*X0
          F2=F1
          S23DF1=(X1-XM(2)**2-XM(1)**2)**2
     &    -(2D0*XM(1)*XM(2))**2
          S23DF2=(X1-XM(3)**2-XM(5)**2)**2
     &    -(2D0*XM(3)*XM(5))**2
          S23DF1=S23DF1*EPS
          S23DF2=S23DF2*EPS
          S23DEL=SQRT(MAX(0D0,S23DF1*S23DF2))/(2D0*X1)
          F1=-2D0*S23DEL/EPS
        ENDIF
        GOTO 170
      ENDIF
C...WE WANT THE MAXIMUM, NOT THE MINIMUM
      IF(F1.LT.F2)THEN
        GOLDEN=-F1
C unvar        XMIN=X1
      ELSE
        GOLDEN=-F2
C unvar        XMIN=X2
      ENDIF
 
      IKNT=0
  180 S12=S12MIN+PYR(0)*YJACO1
      IKNT=IKNT+1
C...GENERATE S23
      S23AVE=XM(2)**2+XM(3)**2-(S12+XM(2)**2-XM(1)**2)
     &*(S12+XM(3)**2-XM(5)**2)/(2D0*S12)
      S23DF1=(S12-XM(2)**2-XM(1)**2)**2
     &-(2D0*XM(1)*XM(2))**2
      S23DF2=(S12-XM(3)**2-XM(5)**2)**2
     &-(2D0*XM(3)*XM(5))**2
      S23DF1=S23DF1*EPS
      S23DF2=S23DF2*EPS
      S23DEL=SQRT(MAX(0D0,S23DF1*S23DF2))/(2D0*S12)
      S23DEL=S23DEL/EPS
      S23MIN=S23AVE-S23DEL
      S23MAX=S23AVE+S23DEL
      YJACO2=S23MAX-S23MIN
      S23=S23MIN+PYR(0)*YJACO2
 
C...CHECK THE SAMPLING
      IF(IKNT.GT.100) THEN
        WRITE(MSTU(11),*) ' IKNT > 100 IN PYTBDY '
        GOTO 190
      ENDIF
      IF(YJACO2.LT.PYR(0)*GOLDEN) GOTO 180
 
      IF(ISKIP.EQ.0) GOTO 190
 
      SH=S23
      TH=S12
      UH=ZM12+ZM22-SH-TH
 
      WU2 = (UH-ZM12)*(UH-ZM22)
      WT2 = (TH-ZM12)*(TH-ZM22)
      WS2 = XM1M2*SH
      PROPZ2 = (SH-SQMZ)**2 + GMMZ**2
      PROPZ=CMPLX(SH-SQMZ,-GMMZ)/CMPLX(PROPZ2)
 
      QLL=QLLS*PROPZ+QLLU/CMPLX(UH-XLL2)
      QLR=QLRS*PROPZ+QLRT/CMPLX(TH-XLR2)
      QRL=QRLS*PROPZ+QRLT/CMPLX(TH-XRL2)
      QRR=QRRS*PROPZ+QRRU/CMPLX(UH-XRR2)
c      QLL=CMPLX((T3I-EI*XW)/XW1)*OLPP*PROPZ-GLIJ/CMPLX(UH-XML2)
c      QLR=-CMPLX((T3I-EI*XW)/XW1)*ORPP*PROPZ+CONJG(GLIJ)
c     &/CMPLX(TH-XML2)
c      QRL=-CMPLX((EI*XW)/XW1)*OLPP*PROPZ+GRIJ/CMPLX(TH-XMR2)
c      QRR=CMPLX((EI*XW)/XW1)*ORPP*PROPZ
c     &-CONJG(GRIJ)/CMPLX(UH-XMR2)
      WT=-((ABS(QLL)**2+ABS(QRR)**2)*WU2+
     &(ABS(QRL)**2+ABS(QLR)**2)*WT2+
     &2D0*DBLE(QLR*CONJG(QLL)+QRL*CONJG(QRR))*WS2)
 
      IF(WT.LT.PYR(0)*WTMAX) GOTO 180
      IF(WT.GT.WTMAX) PRINT*,' WT > WTMAX ',WT,WTMAX
 
  190 D3=(XM(5)**2+XM(3)**2-S12)/(2D0*XM(5))
      D1=(XM(5)**2+XM(1)**2-S23)/(2D0*XM(5))
      D2=XM(5)-D1-D3
      P1=SQRT(D1*D1-XM(1)**2)
      P2=SQRT(D2*D2-XM(2)**2)
      P3=SQRT(D3*D3-XM(3)**2)
      CTHE1=2D0*PYR(0)-1D0
      ANG1=2D0*PYR(0)*PARU(1)
      CPHI1=COS(ANG1)
      SPHI1=SIN(ANG1)
      ARG=1D0-CTHE1**2
      IF(ARG.LT.0D0.AND.ARG.GT.-1D-3) ARG=0D0
      STHE1=SQRT(ARG)
      P(N+1,1)=P1*STHE1*CPHI1
      P(N+1,2)=P1*STHE1*SPHI1
      P(N+1,3)=P1*CTHE1
      P(N+1,4)=D1
 
C...GET CPHI3
      ANG3=2D0*PYR(0)*PARU(1)
      CPHI3=COS(ANG3)
      SPHI3=SIN(ANG3)
      CTHE3=(P2**2-P1**2-P3**2)/2D0/P1/P3
      ARG=1D0-CTHE3**2
      IF(ARG.LT.0D0.AND.ARG.GT.-1D-3) ARG=0D0
      STHE3=SQRT(ARG)
      P(N+3,1)=-P3*STHE3*CPHI3*CTHE1*CPHI1
     &+P3*STHE3*SPHI3*SPHI1
     &+P3*CTHE3*STHE1*CPHI1
      P(N+3,2)=-P3*STHE3*CPHI3*CTHE1*SPHI1
     &-P3*STHE3*SPHI3*CPHI1
     &+P3*CTHE3*STHE1*SPHI1
      P(N+3,3)=P3*STHE3*CPHI3*STHE1
     &+P3*CTHE3*CTHE1
      P(N+3,4)=D3
 
      DO 200 I=1,3
        P(N+2,I)=-P(N+1,I)-P(N+3,I)
  200 CONTINUE
      P(N+2,4)=D2
 
      RETURN
      END
