//ICKDSF JOB (TSO),
//             'ADD DASD',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//* ***************************************************************** *
//* * USE FOR 3350 | 3330 | 3340 | 2314                               *
//* ***************************************************************** *
//*
//ICKDSF EXEC PGM=ICKDSF,REGION=4096K
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
  INIT UNITADDRESS(351) VERIFY(111111) -
               VOLID(KICKS0) OWNER(HERCULES) -
               VTOC(0,1,15)
//