NDFRR2A ;BIR/RSB - VA Product Enter/Edit ; 23 Jun 2009  9:18 AM
 ;;4.0;NDF MANAGEMENT;**70,108,262,263**; 1 Jan 99
 ;
15 ;  PRIMARY VA DRUG CLASS
 S (NDFM,X)=$$GET^NDFRR1(50.605,.01,$S($D(^TMP("NDFR",$J,"50.68,15")):$P(^PS(50.605,+^TMP("NDFR",$J,"50.68,15"),0),"^"),1:""),1,"Primary VA Drug Class")
 I $D(NDFABORT)&('$D(NDFEDIT)) G ^NDFRR2
 I $D(NDFABORT)&($D(NDFEDIT)) G EXIT^NDFRR2A
 I NDFM="" Q
 K DIC S DIC=50.605,DIC(0)="EMZ" D ^DIC
 I Y=-1 D  G 15
 .I '$$CK^NDFRR1(50.605,.01,NDFM) D HLP^NDFRR1(50.605,.01)
 .;I $$CK^NDFRR1(50.605,.01,NDFM) D SET^NDFRR1("50.68,15",NDFM)
 S NDFM=+Y S ^TMP("NDFR",$J,"50.68,15")=NDFM
 Q:$D(NDFEDIT)
 ;
16 ;  SECONDARY VA DRUG CLASS
 S CNT=0
161 S (NDFM,X)=$$GET^NDFRR1(50.605,.01,"",0,"Secondary VA Drug Class")
 I $D(NDFABORT)&('$D(NDFEDIT)) G ^NDFRR2
 I $D(NDFABORT)&($D(NDFEDIT)) G EXIT^NDFRR2A
 ;I NDFM=""&($D(^TMP("NDFR",$J,"50.6816,.01")))&('$D(NDFEDIT)) G 17
 ;I NDFM=""&($D(^TMP("NDFR",$J,"50.6816,.01")))&($D(NDFEDIT)) Q
 I NDFM=""&('$D(NDFEDIT)) G 17
 I NDFM=""&($D(NDFEDIT)) Q
 K DIC S DIC=50.605,DIC(0)="EMZ" D ^DIC
 I Y=-1 D  G 161
 .I '$$CK^NDFRR1(50.605,.01,NDFM) D HLP^NDFRR1(50.605,.01)
 I $$CK^NDFRR1(50.605,.01,NDFM) S NDFM=$S(Y["^":+Y,1:Y),CNT=CNT+1 S ^TMP("NDFR",$J,"50.6816,.01",CNT)=NDFM
 I '$D(^TMP("NDFR",$J,"50.6816,.01")) W "  (Required)" G 161
 G 161
 ;
17 ; CS FEDERAL SCHEDULE
 K DIR
 S:$G(^TMP("NDFR",$J,"50.68,19")) DIR("B")=$$EXTERNAL^DILFD(50.68,19,"",$G(^TMP("NDFR",$J,"50.68,19")))
 S DIR(0)="50.68,19" D ^DIR
 ;I $D(DTOUT)!($D(DUOUT)) G EXIT
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" W "   (Required)" H .5
 ;I X="" W "  (Required)" G 17
 I Y>-1 S ^TMP("NDFR",$J,"50.68,19")=Y
 Q:$D(NDFEDIT)
 ;
18 ;  SINGLE/MULTI SOURCE PRODUCT
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,20")) DIR("B")=$$EXTERNAL^DILFD(50.68,20,"",$G(^TMP("NDFR",$J,"50.68,20")))
 S DIR(0)="50.68,20" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" W "   (Required)" H .5
 ;I X="" W "  (Required)" G 18
 I Y>-1 S ^TMP("NDFR",$J,"50.68,20")=Y
 Q:$D(NDFEDIT)
 ;
19 ;  INACTIVATION DATE
 K DIR N Y
 I $D(^TMP("NDFR",$J,"50.68,21")) D
 .S Y=$G(^TMP("NDFR",$J,"50.68,21")) X ^DD("DD")
 .S DIR("B")=Y
 S DIR("A")="Inactivation Date",DIR(0)="DO" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" S ^TMP("NDFR",$J,"50.68,21")="" W "   (Deleted)"
 I Y>-1 S ^TMP("NDFR",$J,"50.68,21")=Y X ^DD("DD") W "   ",Y
 Q:$D(NDFEDIT)
 ;
20 ;  MAX SINGLE DOSE
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,25")) DIR("B")=$G(^TMP("NDFR",$J,"50.68,25"))
 S DIR(0)="50.68,25" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" S ^TMP("NDFR",$J,"50.68,25")="" W "   (Deleted)"
 ;I X="" W "  (Required)" G 20
 I Y>-1 S ^TMP("NDFR",$J,"50.68,25")=Y
 Q:$D(NDFEDIT)
 ;
22 ;  MIN SINGLE DOSE
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,26")) DIR("B")=$G(^TMP("NDFR",$J,"50.68,26"))
 S DIR(0)="50.68,26" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" S ^TMP("NDFR",$J,"50.68,26")="" W "   (Deleted)"
 ;I X="" W "  (Required)" G 22
 I Y>-1 S ^TMP("NDFR",$J,"50.68,26")=Y
 Q:$D(NDFEDIT)
 ;
23 ;  MAX DAILY DOSE
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,27")) DIR("B")=$G(^TMP("NDFR",$J,"50.68,27"))
 S DIR(0)="50.68,27" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" S ^TMP("NDFR",$J,"50.68,27")="" W "   (Deleted)"
 ;I X="" W "  (Required)" G 23
 I Y>-1 S ^TMP("NDFR",$J,"50.68,27")=Y
 Q:$D(NDFEDIT)
 ;
24 ; MIN DAILY DOSE
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,28")) DIR("B")=$G(^TMP("NDFR",$J,"50.68,28"))
 S DIR(0)="50.68,28" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" S ^TMP("NDFR",$J,"50.68,28")="" W "   (Deleted)"
 ;I X="" W "  (Required)" G 24
 I Y>-1 S ^TMP("NDFR",$J,"50.68,28")=Y
 Q:$D(NDFEDIT)
 ;
25 ; MAX CUMMULATIVE DOSE
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,29")) DIR("B")=$G(^TMP("NDFR",$J,"50.68,29"))
 S DIR(0)="50.68,29" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I X="@" S ^TMP("NDFR",$J,"50.68,29")="" W "   (Deleted)"
 ;I X="" W "  (Required)" G 25
 I Y>-1 S ^TMP("NDFR",$J,"50.68,29")=Y
 Q:$D(NDFEDIT)
 ;
 ; GO TO LISTMAN
 I $D(NDFNW) D
 .S $P(NDFNAME,"^",2)=^TMP("NDFR",$J,"50.68,.01")
 .K NDFCLASS,NDFINGL,NDFNW D EN^VALM("NDF RSB ACCEPT/EDIT")
 I $D(NDFNW) G 1^NDFRR2
 ;
 Q
30 ; EXCLUDE DDI Check
 N DIR
 S:$D(^TMP("NDFR",$J,"50.68,23")) DIR("B")=$$EXTERNAL^DILFD(50.68,23,"",$G(^TMP("NDFR",$J,"50.68,23")))
 S DIR("A")="EXCLUDE Drug-Drug Interaction Check"
 S DIR(0)="Y" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 S:Y>0 ^TMP("NDFR",$J,"50.68,23")=+Y
 S:Y=0 ^TMP("NDFR",$J,"50.68,23")=""
 Q:$D(NDFEDIT)
 ;
31 ;  OVERRIDE DOSE CHECK
 K DIR
 S:$D(^TMP("NDFR",$J,"50.68,31")) DIR("B")=$$EXTERNAL^DILFD(50.68,31,"",$G(^TMP("NDFR",$J,"50.68,31")))
 S DIR(0)="50.68,31" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 ;I.X="@" W "   (Required)" H .5
 ;I X="" W "  (Required)" G 18
 I Y>-1 S ^TMP("NDFR",$J,"50.68,31")=Y
 Q:$D(NDFEDIT)
 ;
40 ; CREATE DEFAULT POSSIBLE DOSAGES
 N DIR,NDFCDPD,NDFPDTC,NDFPKG
 S (NDFCDPD,NDFPDTC,NDFPKG)=""
 S DIR("B")="Yes"
 S:$D(^TMP("NDFR",$J,"50.68,40")) DIR("B")=$$EXTERNAL^DILFD(50.68,40,"",$G(^TMP("NDFR",$J,"50.68,40")))
 S DIR(0)="50.68,40",DIR("A")="Auto-Create Default Possible Dosage" D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 I Y=-1 G EXIT^NDFRR2A
 S NDFCDPD=Y
 I (NDFCDPD="N") D
 . N DIR,X,Y
 . S:$G(^TMP("NDFR",$J,"50.68,41"))'="" DIR("B")=$G(^TMP("NDFR",$J,"50.68,41"))
 . S DIR(0)="50.68,41",DIR("A")="Possible Dosages To Auto-Create"
 . F  D ^DIR Q:($D(DTOUT)!$D(DUOUT)!(X'=""))  W:X="" "??",$C(7),!
 . I $D(DTOUT)!$D(DUOUT) Q
 . S NDFPDTC=Y
 . I (NDFPDTC'="N") D
 . . N DIR,X,Y,QUIT
 . . S:$G(^TMP("NDFR",$J,"50.68,42"))'="" DIR("B")=$G(^TMP("NDFR",$J,"50.68,42"))
 . . S DIR(0)="50.68,42",DIR("A")="Package",QUIT=0
 . . F  Q:QUIT  D ^DIR Q:$D(DTOUT)!$D(DUOUT)  D
 . . . I X="" W "??",$C(7),! Q
 . . . I '$$PKGCHK(Y) Q
 . . . S NDFPKG=Y,QUIT=1
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 ;
 ; TMP global update
 I NDFCDPD="N" D
 . I NDFPDTC="N" D
 . . S ^TMP("NDFR",$J,"50.68,40")=NDFCDPD
 . . S ^TMP("NDFR",$J,"50.68,41")=NDFPDTC
 . . S ^TMP("NDFR",$J,"50.68,42")=""
 . E  D
 . . I NDFPKG'="" D
 . . . S ^TMP("NDFR",$J,"50.68,40")=NDFCDPD
 . . . S ^TMP("NDFR",$J,"50.68,41")=NDFPDTC
 . . . S ^TMP("NDFR",$J,"50.68,42")=NDFPKG
 E  D
 . S ^TMP("NDFR",$J,"50.68,40")=NDFCDPD
 . S ^TMP("NDFR",$J,"50.68,41")=""
 . S ^TMP("NDFR",$J,"50.68,42")=""
 ;
 N DIR S DIR(0)="E",DIR("A")="Press Return to continue" W ! D ^DIR
 ;
 Q:$D(NDFEDIT)
 ;
100 ;FDA MED GUIDE
 W !,"FDA Med Guide Server URL: ",$$GET1^DIQ(59.7,1,100),!
 ;
 K DIR
 S:($G(^TMP("NDFR",$J,"50.68,100"))'="") DIR("B")=$$EXTERNAL^DILFD(50.68,100,"",$G(^TMP("NDFR",$J,"50.68,100")))
 S DIR(0)="50.68,100",DIR("A")="FDA Med Guide File Name"
 S DIR("?",1)="Enter the name of the file corresponding to the FDA Medication Guide"
 S DIR("?")="associated with this VA Product."
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))&(($D(NDFEDIT))) G EXIT^NDFRR2A
 I $D(DTOUT)!($D(DUOUT))&(('$D(NDFEDIT))) G ^NDFRR2
 ;I.X="@" W "   (Required)" H .5
 ;I X="" W "  (Required)" G 18
 I Y>-1 S ^TMP("NDFR",$J,"50.68,100")=Y
 Q:$D(NDFEDIT)
 ;
199 ; VA PRODUCT NAMES
 ;S NDFC=$G(^TMP("NDFR",$J,"50.68,.01")) S NDFCC=(NDFC?1.9N)
 ;N DIR S DIR(0)="SO^E:Edit this Product Name;C:Choose another Product name" D ^DIR  I $D(DTOUT)!($D(DUOUT)) Q
 ;I Y="C" S VALMBCK="B" Q
 ;
 N CHANGE S CHANGE=$P(NDFNAME,"^",2)
 I $D(^PSNDF(50.68,"B",CHANGE)) W !,"Entry already in file.",!,"This entry can only be inactivated!" H 2 Q
 S (NDFM,X)=$$GET^NDFRR1(50.68,.01,$P(NDFNAME,"^",2),0,"Enter VA Product Name")
 I NDFM=""!(NDFM="^") Q
 S $P(NDFNAME,"^",2)=NDFM
 S ^TMP("NDFR",$J,"50.68,.01")=NDFNAME
 S:$L(^TMP("NDFR",$J,"50.68,.01"))<41 ^TMP("NDFR",$J,"50.68,5")=$P(^TMP("NDFR",$J,"50.68,.01"),"^",2)
 I CHANGE'=$P(NDFNAME,"^",2)&('$D(NDFNW)) D 119^NDFRR2
 D HDR^NDFRR6
 Q
EXIT ;
 W !,"    NO CHANGE MADE!" H .5
 Q
 ;
CLASS ;
 D FULL^VALM1 S NDFCLASS=1
 N LIST,FIRST,LAST S LIST="",FIRST=0,LAST=0 W !
 N X,TOT S TOT=0 F X=0:0 S X=$O(^TMP("NDFR",$J,"50.6816,.01",X)) Q:'X  D
 .S:FIRST=0 FIRST=X S:LAST<X LAST=X
 .S:TOT<X TOT=X S LIST=LIST_X_"|"
 .W !,"("_X_")  ",$P(^PS(50.605,+^TMP("NDFR",$J,"50.6816,.01",X),0),"^")
 .W "  ",$P(^PS(50.605,+^TMP("NDFR",$J,"50.6816,.01",X),0),"^",2)
 W ! K DIR S DIR("A")="Do you wish to Add or Delete entries?",DIR(0)="SBOM^A:Add new entries;D:Delete entries" D ^DIR
 I $D(DTOUT)!($D(DUOUT)) Q
 I Y="A" D CLASSA G CLASS
 I Y="D" D CLASSD,ADJUST("NDFR","50.6816,.01") G CLASS
 Q
 ;
CLASSA S (NDFM,X)=$$GET^NDFRR1(50.605,.01,"",0,"Secondary VA Drug Class")
 I NDFM="" Q
 K DIC S DIC=50.605,DIC(0)="EMZ" D ^DIC
 I Y=-1 D  G CLASS
 .I '$$CK^NDFRR1(50.605,.01,NDFM) D HLP^NDFRR1(50.605,.01)
 I $$CK^NDFRR1(50.605,.01,NDFM) S NDFM=$S(Y["^":+Y,1:Y) S ^TMP("NDFR",$J,"50.6816,.01",TOT+1)=NDFM,TOT=TOT+1
 G CLASSA
CLASSD ;
 K DIR S DIR(0)="N^"_FIRST_":"_LAST,DIR("A")="Delete entry" D ^DIR
 I Y=-1 Q
 I $D(DTOUT)!($D(DUOUT)) Q
 K ^TMP("NDFR",$J,"50.6816,.01",Y)
 Q
 ;
ING ;
 S NDFINGL=1
 N X,TOT S TOT=0 F X=0:0 S X=$O(^TMP("NDFR",$J,"50.6814",X)) Q:'X  D
 .S:TOT<X TOT=X
 .W !,"("_X_")"," "
 .S NDFC=$P(^TMP("NDFR",$J,"50.6814",X),"|") S NDFCC=(NDFC?1.9N)
 .I NDFCC W $P(^PS(50.416,+^TMP("NDFR",$J,"50.6814",X),0),"^")
 .I 'NDFCC W NDFC
 .K NDFC,NDFCC
 W ! K DIR S DIR("A")="Do you wish to Add or Delete entries?",DIR(0)="SBOM^A:Add new entries;D:Delete entries" D ^DIR
 I Y="A" D INGA G ING Q
 I Y="D" D INGD,ADJUST("NDFR","50.6814") G ING Q
 ;
INGA ;
 ;
ING21 W ! S (NDFM,X)=$$GET^NDFRR1(50.416,.01,"",0,"Active Ingredients")
 I $D(NDFABORT) G EXIT^NDFRR2A
 I NDFM=""&($D(NDFEDIT)) Q
 K DIC,NDFY,NDFAS S DIC=50.416,DIC(0)="EMZ" D ^DIC
 S NDFY=Y I NDFY=-1 D
 .I '$$CK^NDFRR1(50.416,.01,NDFM) D HLP^NDFRR1(50.416,.01) G ING21
 .S NDFAS=$$ADD^NDFRR1(NDFM,"DRUG INGREDIENT") I NDFAS S ^TMP("NDFR",$J,"50.6814",TOT+1)=NDFM S TOT=TOT+1 D
 ..K DIR S DIR(0)="Y",DIR("A")="Is this a primary ingredient" D ^DIR
 ..I Y=0 D
 ...S DIC=50.416,DIC(0)="QEALMZ",DIC("A")="Enter Primary ingredient: " D ^DIC
 ...I Y<0 W !,"Not Marked"
 ...I Y>0 S $P(^TMP("NDFR",$J,"50.6814",TOT),"|",4)=+Y
 I NDFY>-1 D
 .I $P(^PS(50.416,+Y,0),"^",2) W !?30," (Primary Ingredient)",$C(7)
 .S ^TMP("NDFR",$J,"50.6814",TOT+1)=+Y,TOT=TOT+1
 I $G(NDFAS)=0 Q
 ;
3 ;  STRENGTH
 S (NDFM,X)=$$GET^NDFRR1(50.6814,1,"",0,"Strength")
 I $D(NDFABORT) G EXIT^NDFRR2A
 I NDFM="" G 4
 I '$$CK^NDFRR1(50.6814,1,NDFM) D HLP^NDFRR1(50.6814,1) G 3
 I $$CK^NDFRR1(50.6814,1,NDFM) S $P(^TMP("NDFR",$J,"50.6814",TOT),"|",2)=NDFM
 ;
4 ;  UNITS
 S (NDFM,X)=$$GET^NDFRR1(50.6814,2,"",0,"Units")
 I $D(NDFABORT) G EXIT^NDFRR2A
 I NDFM="" Q
 K DIC S DIC=50.607,DIC(0)="EMZ" D ^DIC
 I Y=-1 D  G 4
 .I '$$CK^NDFRR1(50.6814,2,NDFM) D HLP^NDFRR1(50.6814,2)
 .;I $$CK^NDFRR1(50.6814,2,NDFM) S $P(^TMP("NDFR",$J,"50.6814",TOT),"|",3)=NDFM
 E  S NDFM=$S(Y["^":+Y,1:Y) S $P(^TMP("NDFR",$J,"50.6814",TOT),"|",3)=NDFM
 G INGA
 Q
INGD ;
 K DIR S DIR(0)="N^1:"_TOT,DIR("A")="Delete entry" D ^DIR
 I Y=-1 Q
 I $D(DTOUT)!($D(DUOUT)) Q
 K ^TMP("NDFR",$J,"50.6814",Y) W "   (Deleted)" H .5
 ;
 Q
ADJUST(A,N) ;
 N CNT,X,ARR S CNT=0
 F X=0:0 S X=$O(^TMP(A,$J,N,X)) Q:'X  D
 .S CNT=CNT+1,ARR(CNT)=^TMP(A,$J,N,X)
 .K ^TMP(A,$J,N,X)
 F X=0:0 S X=$O(ARR(X)) Q:'X  D
 .S ^TMP(A,$J,N,X)=ARR(X)
 Q
 ;
PKGCHK(PKG)  ;Validades PACKAGE (#42) field for  VA Product entry
 ;  Input: PKG: Package to validate ("I" - Inpatient, "O" - Outpatient, "IO" - Both)
 ;Output: PKGCHK: 0 - Invalid Package / 1 - Valid Package
 N PKGCHK,UNIT,DOSFRM
 S PKGCHK=1
 S DOSFRM=+$G(^TMP("NDFR",$J,"50.68,1"))
 S UNIT=+$G(^TMP("NDFR",$J,"50.68,3"))
 I PKG["I",'$D(^PS(50.606,"ACONI",DOSFRM,UNIT))!'$O(^PS(50.606,"ADUPI",DOSFRM,0)) D
 . S PKGCHK=0 W !!,"Dosage Form '",$$GET1^DIQ(50.606,DOSFRM,.01),"' and Unit '",$$GET1^DIQ(50.607,UNIT,.01),"' combination cannot be converted"
 . W !,"for Inpatient Medications",!,$C(7)
 I PKG["O",'$D(^PS(50.606,"ACONO",DOSFRM,UNIT))!'$O(^PS(50.606,"ADUPO",DOSFRM,0)) D
 . S PKGCHK=0 W !!,"Dosage Form '",$$GET1^DIQ(50.606,DOSFRM,.01),"' and Unit '",$$GET1^DIQ(50.607,UNIT,.01),"' combination cannot be converted"
 . W !,"for Outpatient Medications",!,$C(7)
 Q PKGCHK
