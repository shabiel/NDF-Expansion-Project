NDFPMIUP ;BIRM/WRT/TTH - load in usp stuf into temporary global;16 Feb 99 / 2:13 PM
 ;;0.0;PATIENT MEDICATION INFORMATION SHEET - UPDATE;;
START ; Begin update process
 W !!,"This process will take approximately two hours. Upon completion, the following",!,"reports can be generated."
 W !!,"1. List of new Medication Information Sheets",!,"2. List of Changed Medication Information Sheets",!,"3. List of VA Products Linked to Deleted Medication Information Sheets"
 W !!!,"Before running this option, you should have installed the most recent PMI",!,"update from the commercial source."
 W ! S DIR("A")="Are you sure you are ready to proceed? "
 S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) Q
 I Y=0 Q
 D LOAD,SETZERO,DELETED,GETIT,LOSTONES
 Q
 ;
 ;
LOAD ;
 W !!!,"Setting up utility globals ^ZZRAND and ^ZZCOPY."
 I $D(^ZZRAND) F XX=0:0 S XX=$O(^ZZRAND(XX)) Q:'XX  K ^ZZRAND(XX)
 I $D(^ZZRAND1) F XX=0:0 S XX=$O(^ZZRAND1(XX)) Q:'XX  K ^ZZRAND1(XX)
 ;I $D(^ZZCOPY) F XX=0:0 S XX=$O(^ZZCOPY(XX)) Q:'XX  K ^ZZCOPY(XX)
 ;I $D(^ZYXWVUT) F XX=0:0 S XX=$O(^ZYXWVUT(XX)) Q:'XX  K ^ZYXWVUT(XX)
NAMES S Y=$$FTG^%ZISH("USER$:[PMIS]","VAMIS.DAT",$NA(^ZZRAND(1)),1)
 S Y=$$FTG^%ZISH("USER$:[PMIS]","VATITLE.DAT",$NA(^ZZRAND1(1)),1)
 S Y=$$FTG^%ZISH("USER$:[PMIS]","VACOPY.DAT",$NA(^ZZCOPY(1)),1)
 S Y=$$FTG^%ZISH("USER$:[PMIS]","VADELETE.DAT",$NA(^ZYXWVUT(1)),1)
 Q
 ;
DELETED ;
 W !!,"Processing list of deleted Medication Information Sheets."
 I $D(^DEL597) F XX=0:0 S XX=$O(^DEL597(XX)) Q:'XX  K ^DEL597(XX)
 S X="" F  S X=$O(^ZYXWVUT(X)) Q:'X  S D=^(X),^DEL597(D)=D
 I $D(^ZYXWVUT) F XX=0:0 S XX=$O(^ZYXWVUT(XX)) Q:'XX  K ^ZYXWVUT(XX)
 Q
 ;
GETIT ;MOVE FROM ZZRAND TO DIZ(521010.7 AND PPIDRG
 W !!,"Loading incoming PMI text into ^DIZ(521010.7) and product info into ^PPIDRG."
 K SPEC S SPEC("==")="",SPEC("//")=""
 S IND=0 F  S IND=$O(^ZZRAND(IND)) Q:'IND  S X=^(IND),DA=+X,LAN=$P(X,"^",3),DATA=$$REPLACE^XLFSTR($P(X,"^",4,40),.SPEC) I IND]"",LAN]"" D
 .I LAN'="D" S DA1=$S(LAN="E1":1,LAN="E2":2,LAN="EA":3,LAN="S1":4,LAN="S2":5,LAN="SA":6),DA2=$O(^DIZ(521010.7,DA,DA1," "),-1)+1,^DIZ(521010.7,DA,DA1,DA2,0)=DATA
 .I LAN="D" S A=$P(X,"^",4),B=$P(X,"^",5),DA=+X D
 ..S DA1=$O(^PPIDRG(DA,1,"B",A,0)) I 'DA1 S DA1=$O(^PPIDRG(DA,1," "),-1)+1,^PPIDRG(DA,1,DA1,0)=A,^PPIDRG(DA,1,"B",A,DA1)=""
 ..S DA2=$O(^PPIDRG(DA,1,DA1,2,"B",B,0)) I 'DA2 S DA2=$O(^PPIDRG(DA,1,DA1,2," "),-1)+1,^(DA2,0)=B,^PPIDRG(DA,1,DA1,2,"B",B,DA2)=""
 Q
 ;
SETZERO ;
 W !!,"Setting zero node for file 521010.7 and ^PPIDRG"
 K ^DIZ(521010.7) S IND="" F  S IND=$O(^ZZRAND1(IND)) Q:IND=""  S X=^(IND),DA=+X,^DIZ(521010.7,DA,0)=$P(X,"^",2,22),^PPIDRG(DA,0)=$P(X,"^",2,22),^PPIDRG("B",$P(X,"^",2),DA)=""
 S ^DIZ(521010.7,0)=^DIC(521010.7,0)
 ;NOW UPDATE COPYRIGHT
 K ^PSPPI(.5) S ^PSPPI(.5,0)="DISCLAIMER/COPYRIGHT",X=0
 F  S X=$O(^ZZCOPY(X)) Q:'X  S D=^(X),N=$P(D,"^"),S=$P(D,"^",3),ARG=$S(N=1:S="IC"+1,1:S="IC"+2),DA=$O(^PSPPI(.5,ARG," "),-1)+1,^PSPPI(.5,ARG,DA,0)=$TR($P(D,"^",4,200),"=/*")
 Q
 ;
 ;
LOSTONES ;
 ; new file structure change
 W !!,"Creating the global ^ZGONE."
 I $D(^ZGONE) F XX=0:0 S XX=$O(^ZGONE(XX)) Q:'XX  K ^ZGONE(XX)
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S A=$P($G(^PSNDF(50.68,DA,1)),"^",5) I A,$D(^DEL597(A)) S ^ZGONE(DA)=""
 Q
 ;
COMP ;CHECK OLD NAMES AGAINST NEW ONES
 D UNDERDOG
 D EN^XUTMDEVQ("COMP1^NDFPMIUP","Changed PMIs") Q
 ;
COMP1 K ^TMP($J) S DA=0 F  S DA=$O(^PSPPI(DA)) Q:'DA  S X=^(DA,0) I $D(^DIZ(521010.7,DA)),^(DA,0)'=X S ^TMP($J,X_"^"_DA)=""
 D UNDERDOG
 ;
 S PG=1 D HEADCOMP S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !," ",$P(X,"^",3),?9,$P(X,"^"),!,?12,$P(^DIZ(521010.7,$P(X,"^",3),0),"^") I $Y+4>IOSL D HEADCOMP
 D ^%ZISC S ZTREQ="@" Q
 ;
HEADCOMP W:$Y @IOF W !,"PMIs with Changed Names",?(IOM-15),"Page ",PG,!,"Printed: ",$$HTE^XLFDT(+$H),!!,?5,"OLD NAME",!,?12,"NEW NAME",!,NDFUL,! Q
 Q
 ;
ADD ;ADDED PMIS
 D EN^XUTMDEVQ("ADD1^NDFPMIUP","NEW PMIS") Q
 ;
ADD1 D UNDERDOG K ^TMP($J) S DA=$O(^PSPPI(" "),-1) F  S DA=$O(^PPIDRG(DA)),K=0 Q:'DA  F  S K=$O(^PPIDRG(DA,1,K)) Q:'K  S X=$P(^(K,0),"^"),^TMP($J,X_"^"_DA)=""
 ;
 S PG=1 D HEADADD S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !,?5,$P(X,"^",2),?12,$P(X,"^") I $Y+4>IOSL D HEADADD
 S ZTREQ="@" Q
 ;
HEADADD W:$Y @IOF W !,"Added Medication Information Sheets",?(IOM-15),"Page ",PG,!,"Printed: ",$$HTE^XLFDT(+$H),!,NDFUL,! S PG=PG+1 Q
 ;
DEL ;DELETED PMIS
 D UNDERDOG
 D EN^XUTMDEVQ("DEL1^NDFPMIUP","DELETED PMIS") Q
 ;
DEL1 K ^TMP($J) S DA=0 F  S DA=$O(^DEL597(DA)) Q:'DA  S X=^PSPPI(DA,0),^TMP($J,X_"^"_DA)=""
 ;
 S PG=1 D HEADDEL S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !,?5,$P(X,"^",3),?12,$P(X,"^") I $Y+4>IOSL D HEADDEL
 S ZTREQ="@" D ^%ZISC Q
 ;
HEADDEL W:$Y @IOF W !,"Deleted Medication Information Sheets",?(IOM-15),"Page ",PG,!,"Printed: ",$$HTE^XLFDT(+$H),!,NDFUL,! S PG=PG+1 Q
 ;
 ;
VAPN ;VAPN that are attached to deleted PMIs
 D EN^XUTMDEVQ("VAPN1^NDFPMIUP","PRODUCT NAME LIST") Q
 ;
VAPN1 ;
 ;
 D UNDERDOG
 K ^TMP($J) S DA=0 F  S DA=$O(^ZGONE(DA)) Q:'DA  S X=$P(^PSNDF(50.68,DA,1),"^",5),^TMP($J,X_"^"_DA)=""
 ;
 S PG=1 D HEADVAPN S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !!,"PMI Entry: "_$P(X,"^"),!,$P(X,"^",2)_":",?10,$P(^PSNDF(50.68,$P(X,"^",2),0),"^") I $Y+4>IOSL D HEADVAPN
 S ZTREQ="@" D ^%ZISC Q
 ;
HEADVAPN W:$Y @IOF W !,"VA Products Connected to Deleted Medication Information Sheets",?(IOM-15),"Page ",PG,!,"Printed: ",$$HTE^XLFDT(+$H),!,NDFUL,! S PG=PG+1 Q
 ;
CUR ;ALL CURRENT PMIS
 D EN^XUTMDEVQ("CUR1^NDFPMIUP","PMI list") Q
 ;
CUR1 D UNDERDOG K ^TMP($J) S DA=.9 F  S DA=$O(^DIZ(521010.7,DA)) Q:'DA  S X=^(DA,0),^TMP($J,X_"^"_DA)=""
 ;
 S PG=1 D HEADCUR S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !," ",$P(X,"^",3),?12,$P(X,"^") I $Y+4>IOSL D HEADCUR
 S ZTREQ="@" D ^%ZISC Q
 ;
HEADCUR W:$Y @IOF W !,"Current Medication Information Sheets",?(IOM-15),"Page ",PG,!,"Printed: ",$$HTE^XLFDT(+$H),!,NDFUL,! S PG=PG+1 Q
 ;
MAP ; update official PMI files
 W !!,"Prior to using this option, you should have run the option Install Commercial",!,"Data into Utility Files, and reviewed the reports listing PMI updates."
 W !!,"Be sure that the options to link to Medication Information Sheets are disabled",!,"prior to running this process."
 W ! S DIR("A")="Are you sure you are ready to proceed? "
 S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) Q
 I Y=0 Q
MONTALI ;
 D UNMARK,DELETE,MERGE,PPINAME
 Q
 ;
UNMARK ;UNMARK ENTRIES MAPPED TO DELETED PMIS AND STORE DA(1) AND DA IN ^DELETED
 I $D(^DELETED) F XX=0:0 S XX=$O(^DELETED(XX)) Q:'XX  K ^DELETED(XX)
 W !!,"Updating entries in the VA PRODUCT NAME file that are linked to deleted PMIs.",!!,"The following entries have been unlinked."
 S PSNVAP=0 F  S PSNVAP=$O(^PSNDF(50.68,PSNVAP)) Q:'PSNVAP  S PSNPPI=$P($G(^PSNDF(50.68,PSNVAP,1)),"^",5) I PSNPPI,$D(^DEL597(PSNPPI)) D
 .W !,PSNVAP_":",?10,$P(^PSNDF(50.68,PSNVAP,0),"^")
 .K DIE,DR,DA S DA=PSNVAP,DIE=50.68,DR="11///@;12///@" D ^DIE K DIE,DR,DA
 .K DA,DIC,DD,DO,DINUM S X=PSNVAP,DINUM=X,DIC(0)="L",DIC="^NDFK(5000.6,",DLAYGO=5000.6 D FILE^DICN K X,DIC,DLAYGO,DINUM,DD,DO
 .S X=$O(^DELETED(" "),-1)+1,^DELETED(X)=PSNVAP
 Q
 ;
DELETE ;BLOW AWAY THE PMIS
 ;
 W !!,"Removing deleted Medication Information Sheets from the MEDICATION",!,"INSTRUCTION SHEETS file (54.7)."
 S U="^",ZZ=0 F  S ZZ=$O(^DEL597(ZZ)) Q:'ZZ  S DA=ZZ,DIK="^PSPPI(" D ^DIK  K DIK,DIAU
 S U="^",ZZ=0 F  S ZZ=$O(^DEL597(ZZ)) Q:'ZZ  S DA=ZZ,DIK="^PPIDRG(" D ^DIK  K DIK,DIAU
 Q
 ;
MERGE ;FROM DIZ(521010.7 TO PSPPI
 W !!,"Moving data into the MEDICATION INSTRUCTION SHEETS file (54.7)."
 S DA=0 F  S DA=$O(^DIZ(521010.7,DA)) Q:'DA  K ^PSPPI(DA) M ^PSPPI(DA)=^DIZ(521010.7,DA)
 ;SET ZERO NODE
 S LAST=$O(^PSPPI(" "),-1),DA=0 F TOT=0:1 S DA=$O(^PSPPI(DA)) Q:'DA
 S $P(^PSPPI(0),"^",3,4)=LAST_"^"_TOT
 Q
 ;
NEWMATCH ;find new matches
 W !!,"This option no longer works",!! Q
 ;this compares against ^PSNDF in BIL,NDF
 ;this may change from release to release
 ;
 D EN^XUTMDEVQ("NEWMTCH^NDFPMIUP","NEWLY MATCHED PRODUCTS") Q
 ;
NEWMTCH K ^TMP($J)
 S DA=0 F  S DA=$O(^PSNDF(DA)),DA1=0 Q:'DA  F  S DA1=$O(^PSNDF(DA,5,DA1)) Q:'DA1  S X=^(DA1,0) I $P(X,"^",7),'$P($G(^["BIL"]PSNDF(DA,5,DA1,0)),"^",7) S ^TMP($J,$P(X,"^")_"^"_DA_"^"_DA1)=""
 S PG=1 D HEADNEW
 S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !,?5,$P(X,"^") I $Y+4>IOSL D HEADNEW
 D ^%ZISC S ZTREQ="@" K ^TMP($J) Q
 ;
HEADNEW W:$Y @IOF W !,"VA products newly matched to PMIs",?(IOM-15),"PAGE ",PG,!,"printed on ",$$HTE^XLFDT(+$H),! S PG=PG+1 Q
 ;
 ;
 ;
PPINAME ;build ^PPINAME from ^PPIDRG
 S A=^PPINAME(0)
 K ^PPINAME(0),^PPINAME("B"),^PPINAME("C"),^PPINAME("D") S X="" F  S X=$O(^PPINAME(X)) Q:'X  K ^PPINAME(X)
 H 20 S ^PPINAME(0)=$P(A,"^",1,2)
 S DA=0 F  S DA=$O(^PPIDRG(DA)),DA1=0 Q:'DA  F  S DA1=$O(^PPIDRG(DA,1,DA1)),DA2=0  Q:'DA1  S X=$P(^(DA1,0),"^"),IND=$O(^PPINAME(" "),-1)+1,^PPINAME(IND,0)=X_"^"_DA_"^"_DA1 D
 .S ^PPINAME("C",X,IND)="",^PPINAME("B",X,IND)="",^PPINAME("D",$$UP^XLFSTR(X),IND)=""
 .F  S DA2=$O(^PPIDRG(DA,1,DA1,2,DA2)) Q:'DA2  S X=$P(^(DA2,0),"^"),IND1=$O(^PPINAME(IND,1," "),-1)+1,^PPINAME(IND,1,IND1,0)=X
 Q
 ;
 ;
LIST ;OF VA PRODUCTS ATTACHED TO PMI
 D EN^XUTMDEVQ("ENLIST^NDFPMIUP","LIST OF VA PRODUCTS WITH PMIS") Q
 ;
ENLIST ;
 D UNDERDOG
 K ^TMP($J) S DA=0 F  S DA=$O(^PSNDF(DA)),K=0 Q:'DA  F  S K=$O(^PSNDF(DA,5,K)) Q:'K  S X=^(K,0) I $P(X,"^",7) S ^TMP($J,$P(X,"^")_"^"_DA_"^"_K)=""
 S PG=1,TODAY=$$HTE^XLFDT(+$H) D HEADLIST
 S X="" F  S X=$O(^TMP($J,X)) Q:X=""  W !,?5,$P(X,"^") I $Y+4>IOSL D HEADLIST
 D ^%ZISC K ^TMP($J) S ZTREQ="@" Q
 ;
HEADLIST W:$Y @IOF W !!,"VA Products Associated with a PMI Sheet",?IOM-15,"Page ",PG,!,"Printed: ",TODAY,!,NDFUL,! S PG=PG+1 Q
 ;
 Q
UNDERDOG ; create underline
 S NDFUL="" F MOE=1:1:75 S NDFUL=NDFUL_"="
 K MOE
 Q
