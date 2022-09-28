//RECV370  JOB (1),'UNPACK XMIT',CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID,
//       USER=IBMUSER,PASSWORD=SYS1
//*------------------------------------------------------------
//RECV1   EXEC RECV370
//XMITIN   DD  UNIT=01C,DCB=BLKSIZE=80           <- INPUT
//SYSUT2   DD  DSN=KICKS.V1R5M0.SOURCE,         <- OUTPUT
//             VOL=SER=KICKS0,UNIT=3350,
//             SPACE=(TRK,(600,,8),RLSE),
//             DISP=(,CATLG)
//