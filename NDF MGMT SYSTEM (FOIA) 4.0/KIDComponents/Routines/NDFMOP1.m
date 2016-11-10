NDFMOP1 ;BIR/WRT-PROPOSED NEW VUID Assignment Report; 12/21/05 15:52
 ;;0.0; NATIONAL DRUG FILE MANAGEMENT SYSTEM;; 30 Oct 98
 K I
 W !,"This report gives you a hard copy of NEW entries with proposed VUIDs.",!,"In addition, it will reflect entries that have been Inactivated or Re-Activated.",!,"You may queue the report to print, if you wish.",!
 K ^WRT("NDFID") S VUID=$P(^NDFK(5000.991,1,0),"^",2)+1,NUM=1
DVC K %ZIS,POP,IOP S %ZIS="QM",%ZIS("B")="",%ZIS("A")="Select Printer: " D ^%ZIS G:POP DONE W:$E(IOST)'="P" !!,"This report must be run on a printer.",!! G:$E(IOST)'="P" DVC I POP K IOP,POP,IO("Q") Q
QUEUE I $D(IO("Q")) K IO("Q") S ZTRTN="ENQ^NDFMOP1",ZTDESC="List of NEW Entries Pending VUID Assignment",ZTSAVE("VUID")="",ZTSAVE("NUM")="" D ^%ZTLOAD K ZTSK D ^%ZISC Q
ENQ ;ENTRY POINT WHEN QUEUED
 U IO
 S NDFPGCT=0,NDFPGLNG=IOSL-6 D TITLE,ACT
DONE W @IOF S:$D(ZTQUEUED) ZTREQ="@" K NDFPRT,I,NAM,IFN,DATE,MAST,MASTER,NBR,NUM,STAMP,VUID,DVUID,ENTRY,MJT,NDFPGCT,NDFPGLNG,Y,IOP,POP,IO("Q") K ^WRT("NDFID") D ^%ZISC
 Q
TITLE I $D(IOF),IOF]"" W @IOF S NDFPGCT=NDFPGCT+1
 S NDFPRT=0 W !,?12," List of NEW Entries Pending VUID Assignment",!
 W !?27,"VA PRODUCT FILE",!
 S Y=DT X ^DD("DD") W ?22,"Date printed: ",Y,!
 W !,"IEN",?8,"VA PRODUCT NAME",!,?8,"PLANNED VUID",?63,"MASTER/NON-MASTER",!
 F MJT=1:1:80 W "-"
 Q
ACT S NBR=$P(^NDFK(5000,1,1,50.68,0),"^",2) F  S NBR=$O(^DIA(50.68,NBR)) Q:'NBR  I $P(^(NBR,0),"^",3)=6 S ENTRY=$P(^DIA(50.68,NBR,0),"^") I $D(^PSNDF(50.68,ENTRY,0)) D CHECK
 Q
CHECK I $D(^DIA(50.68,NBR,2.1)),'$D(^DIA(50.68,NBR,3.1)) W !!,ENTRY,?8,$P(^PSNDF(50.68,ENTRY,0),"^"),?67,"RE-ACTIVATED" S NDFPRT=1
 I '$D(^DIA(50.68,NBR,2.1)),$D(^DIA(50.68,NBR,3.1)) S STAMP=$P(^DIA(50.68,NBR,3.1),"^"),Y=STAMP X ^DD("DD") I STAMP>3050310 W !!,ENTRY,?8,$P(^PSNDF(50.68,ENTRY,0),"^"),?67,"INACTIVATED",!?67,Y S NDFPRT=1
 I $D(^DIA(50.68,NBR,2.1)),$D(^DIA(50.68,NBR,3.1)) S STAMP=$P(^DIA(50.68,NBR,3.1),"^"),Y=STAMP X ^DD("DD") I STAMP>3050310 W !!,ENTRY,?8,$P(^PSNDF(50.68,ENTRY,0),"^"),?67,"INACTIVATED",!?67,Y S NDFPRT=1
 Q
