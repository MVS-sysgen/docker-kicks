//KFIX JOB (JOB),
//             'KFIX',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//*
//*  Installs CLIST
//*
//CLIST   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=IBMUSER.CLIST,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=KFIX
PROC 0 VER(V1R5M0) U(KICKS) S(KICKSSYS) UPDATE(UPDATE) DUMMY(.NU.)
 /* */
 /* CLIST TO MAKE JCL (ETAL) CHANGES      */
 /* */
 /* TO RUN THIS TYPE                      */
 /* EXEC KICKSSYS.V1R5M0.CLIST(KFIX)      */
 /* */
 /* */
 /* FIRST GENERATE PDSUPDTE CONTROL CARDS */
 /*            AKA IPOUPDTE               */
 /* */
CONTROL NOMSG NOFLUSH
FREE  FI(SYSTERM)
FREE  FI(SYSPRINT)
ALLOC FI(SYSTERM)  DA(*)
ALLOC FI(SYSPRINT) DA(*)
 /* */
SET &UU1 = &SYSUID
SET &UU2 = &SYSPREF
SET &UU3 = ????????  /* EDIT THIS LINE TO GET WHAT YOU WANT */
 /* */
SET &NM  = 2
SET &UU  = KICKS
 /* */
GOTO ITSYES
ITSYES: SET &UU = &UU
 /* */
ERROR GOTO ERRDONE1
 SET &ZOS = 0
 SYSCALL TESTSUB ZOS
ERRDONE1: +
  ERROR OFF
 IF &ZOS > 0 THEN DO
  WRITE LOOKS LIKE ZOS
  END
 ELSE DO
  WRITE LOOKS LIKE TURNKEY MVS
  END
 /* */
DELETE ZFIX.SYSIN
FREE  FI(SYSIN)
CONTROL   MSG   FLUSH
ALLOC FI(SYSIN) DA(ZFIX.SYSIN) NEW CATALOG +
 UNIT(SYSDA) SPACE(5) TRACKS
OPENFILE SYSIN OUTPUT
IF &ZOS > 0 THEN DO
 /* ZJOBCARD - USE JOB CLASS=A FOR Z/OS */
 WRITE -- WILL CHANGE JOB CLASS
 SET &SYSIN = &STR(CLASS=C<CLASS=A<&STR( )JOB&STR( )<)
 PUTFILE SYSIN
 /* ZJOBCARD - USE REGION=64M FOR Z/OS */
 WRITE -- WILL CHANGE REGION SIZES
 SET &SYSIN = &STR(REGION=5000K<REGION=64M<&STR( )JOB&STR( )<)
 PUTFILE SYSIN
 SET &SYSIN = &STR(REGION=6000K<REGION=64M<&STR( )JOB&STR( )<)
 PUTFILE SYSIN
 SET &SYSIN = &STR(REGION=7000K<REGION=64M<&STR( )JOB&STR( )<)
 PUTFILE SYSIN
 END
 /* ZUSRID - MATCH HLQ'S TO CURRENT USER ID */
SET &SYSIN = &STR(HERC01<&UU<
PUTFILE SYSIN
SET &SYSIN = &STR(K.S.<&UU&STR(.)S.<
PUTFILE SYSIN
SET &SYSIN = &STR(K.U.<&UU&STR(.)U.<
PUTFILE SYSIN
SET &SYSIN = &STR(&STR(')K.<&STR(')&UU&STR(.)<
PUTFILE SYSIN
SET &SYSIN = &STR(&STR(=)K.<&STR(=)&UU&STR(.)<
PUTFILE SYSIN
SET &SYSIN = &STR(&STR((K.<&STR((&UU&STR(.)<
PUTFILE SYSIN
SET &SYSIN = &STR(.S.<.&S..<)
PUTFILE SYSIN
SET &SYSIN = &STR(.U.<.&U..<)
PUTFILE SYSIN
IF &ZOS = 0 THEN DO
 /* WRITE LOOKS LIKE TURNKEY */
 /* DEFAULT TCP 2$ IN CASE BAD (OLD) ZP60009 */
 WRITE -- WILL CHANGE TCP TO 2$
 SET &SYSIN = &STR(TCP&STR((1$&STR())<TCP&STR((2$&STR())<
 PUTFILE SYSIN
 END
IF &ZOS > 0 THEN DO
 /* ZASM - USE ASMA90 ASSEMBLER IN Z/OS */
 WRITE -- WILL CHANGE ASSEMBLER NAME
 SET &SYSIN = &STR(IFOX00<ASMA90<)
 PUTFILE SYSIN
 /* ZCOB - USE COBOL2 PROCS IN Z/OS */
 WRITE -- WILL CHANGE PROC NAMES TO USE COBOL2
 SET &SYSIN = &STR(KIKCOBCL<KIKCB2CL<)
 PUTFILE SYSIN
 SET &SYSIN = &STR(K2KCOBCL<KIKCB2CL<)
 PUTFILE SYSIN
 SET &SYSIN = &STR(KIKCOBCS<KIKCB2CS<)
 PUTFILE SYSIN
 SET &SYSIN = &STR(K2KCOBCS<KIKCB2CS<)
 PUTFILE SYSIN
 /* ZJCLLIB - USE Z/OS JCL PROCLIB IN Z/OS */
 WRITE -- WILL CHANGE JOBPROC TO JCLLIB
 SET &SYSIN = &STR(&STR( )DD&STR( )<&STR( )JCLLIB&STR( )<
 SET &SYSIN = &STR(&SYSIN.JOBPROC&STR( )<
 PUTFILE SYSIN
 SET &SYSIN = &STR(&STR( )DSN=<&STR( )ORDER=(<JOBPROC&STR( )<
 PUTFILE SYSIN
 SET &SYSIN = &STR(&STR(,)DISP=SHR<Z&STR()))<JOBPROC&STR( )<
 PUTFILE SYSIN
 END
CLOSFILE SYSIN
FREE FI(SYSIN)
 /* */
 /* THEN RUN PDSUPDTE WITH THOSE CONTROL CARDS */
 /* */
CONTROL NOMSG   FLUSH
 /* WOULD BE NICE TO DO THE FREE'S IN A SUBROUTINE, */
 /* BUT MVS38J CLISTS DO NOT HAVE 'SYSCALL'...      */
FREE  FI(SYSTERM)
FREE  FI(SYSPRINT)
FREE  FI(@UCB2)
FREE  FI(@UCOB)
FREE  FI(@UCOBCPY)
FREE  FI(@UGCC)
FREE  FI(@UINST)
FREE  FI(@UMAPS)
FREE  FI(@UOPIDS)
FREE  FI(@USPUFI)
FREE  FI(@SCMD)
FREE  FI(@SCOB)
FREE  FI(@SCOBCPY)
FREE  FI(@SDOC)
FREE  FI(@SGCC)
FREE  FI(@SINST)
FREE  FI(@SMACS)
FREE  FI(@SMAPS)
FREE  FI(@SPROC)
FREE  FI(@SPROCZ)
FREE  FI(@STESTC)
FREE  FI(@STESTG)
FREE  FI(@STESTF)
CONTROL   MSG   FLUSH
ALLOC FI(SYSIN) DA(ZFIX.SYSIN) OLD
ALLOC FI(SYSTERM)  DA(*)
ALLOC FI(SYSPRINT) DUMMY
 /* */
ALLOC FI(@UCB2)    DA(&U..&VER..CB2)      SHR
ALLOC FI(@UCOB)    DA(&U..&VER..COB)      SHR
ALLOC FI(@UCOBCPY) DA(&U..&VER..COBCOPY)  SHR
ALLOC FI(@UGCC)    DA(&U..&VER..GCC)      SHR
 /*   FI(@UGCCCPY) DA(&U..&VER..GCCCOPY)  S*/
ALLOC FI(@UINST)   DA(&U..&VER..INSTLIB)  SHR
ALLOC FI(@UMAPS)   DA(&U..&VER..MAPSRC)   SHR
ALLOC FI(@UOPIDS)  DA(&U..&VER..OPIDS)    SHR
ALLOC FI(@USPUFI)  DA(&U..&VER..SPUFI.IN) SHR
ALLOC FI(@SCMD)    DA(&S..&VER..CLIST)    SHR
ALLOC FI(@SCOB)    DA(&S..&VER..COB)      SHR
ALLOC FI(@SCOBCPY) DA(&S..&VER..COBCOPY)  SHR
ALLOC FI(@SDOC)    DA(&S..&VER..DOC)      SHR
ALLOC FI(@SGCC)    DA(&S..&VER..GCC)      SHR
 /*   FI(@SGCCCPY) DA(&S..&VER..GCCCOPY)  S*/
ALLOC FI(@SINST)   DA(&S..&VER..INSTLIB)  SHR
ALLOC FI(@SMACS)   DA(&S..&VER..MACLIB)   SHR
ALLOC FI(@SMAPS)   DA(&S..&VER..MAPSRC)   SHR
ALLOC FI(@SPROC)   DA(&S..&VER..PROCLIB)  SHR
ALLOC FI(@SPROCZ)  DA(&S..&VER..PROCLIBZ) SHR
ALLOC FI(@STESTC)  DA(&S..&VER..TESTCOB)  SHR
ALLOC FI(@STESTG)  DA(&S..&VER..TESTGCC)  SHR
ALLOC FI(@STESTF)  DA(&S..&VER..TESTFILE) SHR
 /* */
CALL '&UU..&S..&VER..SKIKLOAD(PDSUPDTE)' '&UPDATE'
 /* */
 /* THEN GET RID OF THE SYSIN FILE */
 /*  AND FREE ALL THE OTHER ALLOCS */
 /* */
CONTROL NOMSG NOFLUSH
FREE  FI(SYSIN)
FREE  FI(SYSTERM)
FREE  FI(SYSPRINT)
DELETE ZFIX.SYSIN
FREE  FI(@UCB2)
FREE  FI(@UCOB)
FREE  FI(@UCOBCPY)
FREE  FI(@UGCC)
 /*   FI(@UGCC)                            */
FREE  FI(@UINST)
FREE  FI(@UMAPS)
FREE  FI(@UOPIDS)
FREE  FI(@USPUFI)
FREE  FI(@SCMD)
FREE  FI(@SCOB)
FREE  FI(@SCOBCPY)
FREE  FI(@SDOC)
FREE  FI(@SGCC)
 /*   FI(@SGCC)                            */
FREE  FI(@SINST)
FREE  FI(@SMACS)
FREE  FI(@SMAPS)
FREE  FI(@SPROC)
FREE  FI(@SPROCZ)
FREE  FI(@STESTC)
FREE  FI(@STESTG)
FREE  FI(@STESTF)
WRITE DONE!
EXIT
 /* */
TESTSUB: PROC 1 TEST
 SYSREF &TEST
 SET &TEST = &TEST + 1
 END
@@
//KFIXRUN EXEC PGM=IKJEFT01,DYNAMNBR=64
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSTSIN  DD  *
PROFILE PREFIX(KICKS)
EXEC 'IBMUSER.CLIST(KFIX)'
PROFILE NOPREFIX