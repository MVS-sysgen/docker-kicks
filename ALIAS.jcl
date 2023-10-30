//ALIAS JOB (JOB),
//             'ADD ALIAS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//*
//*  Install KICKS CLIST
//*
//ALIAS   EXEC PGM=IKJEFT01                               
//SYSTSPRT  DD SYSOUT=*                                         
//SYSTSIN   DD *                                                
RENAME 'GCC.LINKLIB(GCC)' 'GCC.LINKLIB(GCC3270)' ALIAS
//