# this code will IPL MVS/CE and submit the jobs needed to generate
# the KICKS0 DASD with KICKS.

from pathlib import Path
import sys
from automvs import automation
import logging
import argparse
import os

cwd = os.getcwd()

recvjcl = '''//RECVKCKS JOB (TSO),
//             'ADD CAT',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//*------------------------------------------------------------
//RECV1   EXEC RECV370
//XMITIN   DD  UNIT=01C,DCB=BLKSIZE=80           <- INPUT
//SYSUT2   DD  DSN=KICKS.V1R5M0.{},         <- OUTPUT
//             VOL=SER=KICKS0,UNIT=3350,
//             SPACE=(TRK,(600,,8),RLSE),
//             DISP=(,CATLG)
//'''

desc = 'Automated KICKS Installer'
arg_parser = argparse.ArgumentParser(description=desc)
arg_parser.add_argument('-d', '--debug', help="Print debugging statements", action="store_const", dest="loglevel", const=logging.DEBUG, default=logging.WARNING)
arg_parser.add_argument('-m', '--mvsce', help="MVS/CE folder location", default="MVSCE")
args = arg_parser.parse_args()

builder = automation(mvsce=args.mvsce,loglevel=args.loglevel)
try:
    builder.ipl(clpa=False)
    builder.send_herc("attach 351 3350 /MVSCE/DASD/kicks0.3350")
    with open("{}/KICKDSF.jcl".format(cwd), "r") as injcl:
        builder.submit(injcl.read())
    builder.wait_for_string("ICK003D REPLY U TO ALTER VOLUME 351 CONTENTS, ELSE T")
    builder.send_reply('U')
    builder.wait_for_string("HASP250 ICKDSF   IS PURGED")
    builder.send_oper("v 351,online")
    builder.wait_for_string("IEE302I 351      ONLINE")
    builder.send_oper("m 351,vol=(sl,kicks0),use=private")
    builder.wait_for_string("$HASP395 MOUNT    ENDED")
    with open("{}/ADDDASD.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
    with open("{}/KICKSCAT.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
    builder.send_herc('devinit 01c /XMI/kicks-tso-v1r5m0.xmi ebcdic')
    builder.submit_and_check(recvjcl.format('INSTALL'))
    builder.send_herc('devinit 01c /XMI/kicks-source.xmi ebcdic')
    builder.submit_and_check(recvjcl.format('SOURCE'))
    with open("{}/KICKSINS.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
    with open("{}/KICKSSRC.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
    with open("{}/KFIX.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
    with open("{}/CLIST.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
    with open("{}/ALIAS.jcl".format(cwd), "r") as injcl:
        builder.submit_and_check(injcl.read())
# except:
#     with open("/MVSCE/printers/prt00e.txt", "r") as prt:
#        print(prt.read())
finally:
    builder.quit_hercules()
