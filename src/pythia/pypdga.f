cc ------------ dpmjet3.4 - authors: S.Roesler, R.Engel, J.Ranft -------
cc -------- phojet1.12-40 - authors: S.Roesler, R.Engel, J.Ranft -------
cc                                                      - oct'13 -------
cc ----------- pythia-6.4 - authors: Torbjorn Sjostrand, Lund'10 -------
cc ---------------------------------------------------------------------
cc                                  converted for use with FLUKA -------
cc                                                      - oct'13 -------
 
C...PYPDGA
C...Gives photon parton distribution.
 
      SUBROUTINE PYPDGA(X,Q2,XPGA)
 
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      IMPLICIT INTEGER(I-N)

C...Commonblocks.
      include 'inc/pydat1'
      include 'inc/pypars'
      include 'inc/pyint1'

C...Local arrays.
      DIMENSION XPGA(-6:6),DGAG(4,3),DGBG(4,3),DGCG(4,3),DGAN(4,3),
     &DGBN(4,3),DGCN(4,3),DGDN(4,3),DGEN(4,3),DGAS(4,3),DGBS(4,3),
     &DGCS(4,3),DGDS(4,3),DGES(4,3)
 
C...The following data lines are coefficients needed in the
C...Drees and Grassie photon parton distribution parametrization.
      DATA DGAG/-.207D0,.6158D0,1.074D0,0.D0,.8926D-2,.6594D0,
     &.4766D0,.1975D-1,.03197D0,1.018D0,.2461D0,.2707D-1/
      DATA DGBG/-.1987D0,.6257D0,8.352D0,5.024D0,.5085D-1,.2774D0,
     &-.3906D0,-.3212D0,-.618D-2,.9476D0,-.6094D0,-.1067D-1/
      DATA DGCG/5.119D0,-.2752D0,-6.993D0,2.298D0,-.2313D0,.1382D0,
     &6.542D0,.5162D0,-.1216D0,.9047D0,2.653D0,.2003D-2/
      DATA DGAN/2.285D0,-.1526D-1,1330.D0,4.219D0,-.3711D0,1.061D0,
     &4.758D0,-.1503D-1,15.8D0,-.9464D0,-.5D0,-.2118D0/
      DATA DGBN/6.073D0,-.8132D0,-41.31D0,3.165D0,-.1717D0,.7815D0,
     &1.535D0,.7067D-2,2.742D0,-.7332D0,.7148D0,3.287D0/
      DATA DGCN/-.4202D0,.1778D-1,.9216D0,.18D0,.8766D-1,.2197D-1,
     &.1096D0,.204D0,.2917D-1,.4657D-1,.1785D0,.4811D-1/
      DATA DGDN/-.8083D-1,.6346D0,1.208D0,.203D0,-.8915D0,.2857D0,
     &2.973D0,.1185D0,-.342D-1,.7196D0,.7338D0,.8139D-1/
      DATA DGEN/.5526D-1,1.136D0,.9512D0,.1163D-1,-.1816D0,.5866D0,
     &2.421D0,.4059D0,-.2302D-1,.9229D0,.5873D0,-.79D-4/
      DATA DGAS/16.69D0,-.7916D0,1099.D0,4.428D0,-.1207D0,1.071D0,
     &1.977D0,-.8625D-2,6.734D0,-1.008D0,-.8594D-1,.7625D-1/
      DATA DGBS/.176D0,.4794D-1,1.047D0,.25D-1,25.D0,-1.648D0,
     &-.1563D-1,6.438D0,59.88D0,-2.983D0,4.48D0,.9686D0/
      DATA DGCS/-.208D-1,.3386D-2,4.853D0,.8404D0,-.123D-1,1.162D0,
     &.4824D0,-.11D-1,-.3226D-2,.8432D0,.3616D0,.1383D-2/
      DATA DGDS/-.1685D-1,1.353D0,1.426D0,1.239D0,-.9194D-1,.7912D0,
     &.6397D0,2.327D0,-.3321D-1,.9475D0,-.3198D0,.2132D-1/
      DATA DGES/-.1986D0,1.1D0,1.136D0,-.2779D0,.2015D-1,.9869D0,
     &-.7036D-1,.1694D-1,.1059D0,.6954D0,-.6663D0,.3683D0/
 
C...Photon parton distribution from Drees and Grassie.
C...Allowed variable range: 1 GeV^2 < Q^2 < 10000 GeV^2.
      DO 100 KFL=-6,6
        XPGA(KFL)=0D0
  100 CONTINUE
      VINT(231)=1D0
      IF(MSTP(57).LE.0) THEN
        T=LOG(1D0/0.16D0)
      ELSE
        T=LOG(MIN(1D4,MAX(1D0,Q2))/0.16D0)
      ENDIF
      X1=1D0-X
      NF=3
      IF(Q2.GT.25D0) NF=4
      IF(Q2.GT.300D0) NF=5
      NFE=NF-2
      AEM=PARU(101)
 
C...Evaluate gluon content.
      DGA=DGAG(1,NFE)*T**DGAG(2,NFE)+DGAG(3,NFE)*T**(-DGAG(4,NFE))
      DGB=DGBG(1,NFE)*T**DGBG(2,NFE)+DGBG(3,NFE)*T**(-DGBG(4,NFE))
      DGC=DGCG(1,NFE)*T**DGCG(2,NFE)+DGCG(3,NFE)*T**(-DGCG(4,NFE))
      XPGL=DGA*X**DGB*X1**DGC
 
C...Evaluate up- and down-type quark content.
      DGA=DGAN(1,NFE)*T**DGAN(2,NFE)+DGAN(3,NFE)*T**(-DGAN(4,NFE))
      DGB=DGBN(1,NFE)*T**DGBN(2,NFE)+DGBN(3,NFE)*T**(-DGBN(4,NFE))
      DGC=DGCN(1,NFE)*T**DGCN(2,NFE)+DGCN(3,NFE)*T**(-DGCN(4,NFE))
      DGD=DGDN(1,NFE)*T**DGDN(2,NFE)+DGDN(3,NFE)*T**(-DGDN(4,NFE))
      DGE=DGEN(1,NFE)*T**DGEN(2,NFE)+DGEN(3,NFE)*T**(-DGEN(4,NFE))
      XPQN=X*(X**2+X1**2)/(DGA-DGB*LOG(X1))+DGC*X**DGD*X1**DGE
      DGA=DGAS(1,NFE)*T**DGAS(2,NFE)+DGAS(3,NFE)*T**(-DGAS(4,NFE))
      DGB=DGBS(1,NFE)*T**DGBS(2,NFE)+DGBS(3,NFE)*T**(-DGBS(4,NFE))
      DGC=DGCS(1,NFE)*T**DGCS(2,NFE)+DGCS(3,NFE)*T**(-DGCS(4,NFE))
      DGD=DGDS(1,NFE)*T**DGDS(2,NFE)+DGDS(3,NFE)*T**(-DGDS(4,NFE))
      DGE=DGES(1,NFE)*T**DGES(2,NFE)+DGES(3,NFE)*T**(-DGES(4,NFE))
      DGF=9D0
      IF(NF.EQ.4) DGF=10D0
      IF(NF.EQ.5) DGF=55D0/6D0
      XPQS=DGF*X*(X**2+X1**2)/(DGA-DGB*LOG(X1))+DGC*X**DGD*X1**DGE
      IF(NF.LE.3) THEN
        XPQU=(XPQS+9D0*XPQN)/6D0
        XPQD=(XPQS-4.5D0*XPQN)/6D0
      ELSEIF(NF.EQ.4) THEN
        XPQU=(XPQS+6D0*XPQN)/8D0
        XPQD=(XPQS-6D0*XPQN)/8D0
      ELSE
        XPQU=(XPQS+7.5D0*XPQN)/10D0
        XPQD=(XPQS-5D0*XPQN)/10D0
      ENDIF
 
C...Put into output arrays.
      XPGA(0)=AEM*XPGL
      XPGA(1)=AEM*XPQD
      XPGA(2)=AEM*XPQU
      XPGA(3)=AEM*XPQD
      IF(NF.GE.4) XPGA(4)=AEM*XPQU
      IF(NF.GE.5) XPGA(5)=AEM*XPQD
      DO 110 KFL=1,6
        XPGA(-KFL)=XPGA(KFL)
  110 CONTINUE
 
      RETURN
      END
