NDFPODDI ;BIR/WRT-Print report from Don's List that will potentially be marked for NO DDI check ; 05/21/03 14:22
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 W !!,"This report will list VA Products from Don's Exclude DDIs List that will",!,"potentially be marked. Information included in this",!,"report is the Dose Form, VA Drug Class, and VA Generic."
 W !,"You may queue the report to print, if you wish.",!
DVC K %ZIS,POP,IOP S %ZIS="QM",%ZIS("B")="",%ZIS("A")="Select Printer: " D ^%ZIS G:POP DONE W:$E(IOST)'="P" !!,"This report must be run on a printer.",!! G:$E(IOST)'="P" DVC I POP K IOP,POP,IO("Q") Q
QUEUE I $D(IO("Q")) K IO("Q") S ZTRTN="ENQ^NDFPODDI",ZTDESC="VA Products from Don's List that potentially be marked (No DDI check) Report" D ^%ZTLOAD K ZTSK D ^%ZISC Q
ENQ ;ENTRY POINT WHEN QUEUED
 U IO
 S PSNPGCT=0,PSNPGLNG=IOSL-6,PSNPRT=0 D TITLE,LOOP1
DONE I $D(PSNPRT) W:PSNPRT=0 !!?10,"No Entries Found"
 W @IOF S:$D(ZTQUEUED) ZTREQ="@" K PSNPRT,PSNB,CODE,CL,CLS,DF,DFM,GN,NODE,VA,NAME,CLSDA,WRT,MJT,PSNPGCT,PSNPGLNG,Y,IOP,POP,IO("Q") D ^%ZISC
 Q
TITLE I $D(IOF),IOF]"" W @IOF S PSNPGCT=PSNPGCT+1
 W !,?3,"VA Products from Don's list that will potentially be marked for NO DDI check",!
 S Y=DT X ^DD("DD") W !,?3,"Date printed: ",Y,?55,"Page: ",PSNPGCT,!
 W !,"VA PRODUCT",?65,"DOSE FORM",!,"VA GENERIC",?65,"VA CLASS",!,"INACTIVE DATE",!
 F MJT=1:1:80 W "-"
 Q
LOOP1 S NAME="" F WRT=0:0 S NAME=$O(^DONLIST1("B",NAME)) Q:NAME=""  F PSNB=0:0 S PSNB=$O(^DONLIST1("B",NAME,PSNB)) Q:'PSNB  D GETDAT
 Q
GETDAT S NODE=^PSNDF(50.68,PSNB,0),GN=$P(NODE,"^",2),DF=$P(NODE,"^",3),CL=$P($G(^PSNDF(50.68,PSNB,3)),"^"),VA=$P($G(^PSNDF(50.6,GN,0)),"^"),DFM=$P($G(^PS(50.606,DF,0)),"^"),CLS=$P($G(^PS(50.605,CL,0)),"^") D REPRT
 Q
INACT S DATE=$P($G(^PSNDF(50.68,PSNB,7)),"^",3)
 Q
REPRT D:$Y>PSNPGLNG TITLE W !!,NAME,?65,DFM,!,VA,?65,CLS S PSNPRT=1
 D:$Y>PSNPGLNG TITLE I $G(DATE) S Y=DATE X ^DD("DD") W !,Y
 Q
