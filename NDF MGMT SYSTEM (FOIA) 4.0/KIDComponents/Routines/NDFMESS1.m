NDFMESS1 ;BIR/DMA-CREATE AND EDIT MESSAGE ;23 Jul 99 / 11:31 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 S NDF=1
 I '$O(^PRE53(5000,NDF,2,0)) G LOAD
 S DIR("A")="Do you wish to edit this message",DIR("A",1)="Text already exists in this message",DIR(0)="Y" D ^DIR K DIR G END:$D(DIRUT),LOAD:'Y
 S DIC="^PRE53(5000,NDF,2,",DWPK=1 D EN^DIWE
 ;
 ;if we've edited, do we want to load
 S DIR("A")="Are you ready to load data ito the message",DIR(0)="Y" D ^DIR G END:$D(DIRUT),END:'Y
 ;
LOAD ;from 5000.506 and 5000.56
 W !,"Now loading data",!
 S LINE=$O(^PRE53(5000,NDF,2," "),-1)+1,^PRE53(5000,NDF,2,LINE,0)=" ",LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^PRE53(5000.506,DA)) Q:'DA  S X=^(DA,0),PN=$P($G(^PSNDF(50.68,X,0)),"^") I PN]"" S ^TMP($J,PN_"^"_X)=""
 I $D(^TMP($J)) D
 .F J=1:1 S X=$P($T(TEXT+J),";",3,300) Q:X=""  S ^PRE53(5000,NDF,2,LINE,0)=X,LINE=LINE+1
 .S PN="" F  S PN=$O(^TMP($J,PN)) Q:PN=""  S ^PRE53(5000,NDF,2,LINE,0)="   "_$P(PN,"^"),LINE=LINE+1,X=$P(PN,"^",2) D
 ..S CMOP=$P($G(^PSNDF(50.68,X,1)),"^",2),DU=$P(^(1),"^",4),DU=$P(^PSNDF(50.64,+DU,0),"^"),^PRE53(5000,NDF,2,LINE,0)=$S(CMOP]"":"    (CMOP - "_CMOP_")",1:""),$E(^(0),30)="(DISPENSE UNIT - "_DU_")",LINE=LINE+1
 ..S TXT="     ",I=0 F  S I=$O(^PSNDF(50.68,"ANDC",X,I)) Q:'I  S NDC=$P(^PSNDF(50.67,I,0),"^",2) I NDC]"" S NDC=$E(NDC,1,6)_"-"_$E(NDC,7,10)_"-"_$E(NDC,11,12),TXT=TXT_NDC_"   " I $L(TXT)>65 D
 ...S ^PRE53(5000,NDF,2,LINE,0)=TXT,LINE=LINE+1,TXT=""
 ..I $L(TXT)>5 S ^PRE53(5000,NDF,2,LINE,0)=TXT,LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^PRE53(5000.5,DA)) Q:'DA  S ^TMP($J,$P(^PSNDF(50.68,DA,0),"^"))=""
 I $D(^TMP($J)) S ^PRE53(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,^PRE53(5000,NDF,2,LINE,0)="  The National Formulary Indicator has changed for the following VA Products." D
 .S LINE=LINE+1,^PRE53(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,DA="" F  S DA=$O(^TMP($J,DA)) Q:DA=""   S ^PRE53(5000,NDF,2,LINE,0)="   "_DA,LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^PRE53(5000.7,DA)) Q:'DA  S ^TMP($J,$P(^PSNDF(50.68,DA,0),"^"))=""
 I $D(^TMP($J)) S ^PRE53(5000,2,LINE,0)=" ",LINE=LINE+1,^PRE53(5000,NDF,2,LINE,0)=" The following VA Products are no longer marked for CMOP.",LINE=LINE+1 D
 .S ^PRE53(5000,NDF,2,LINE,0)=" All local drug file entries matched to these VA Products will be UNMARKED for CMOP." D
 .S LINE=LINE+1,^PRE53(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,DA="" F  S DA=$O(^TMP($J,DA)) Q:DA=""   S ^PRE53(5000,NDF,2,LINE,0)="   "_DA,LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^PRE53(5000,1,4,DA)) Q:'DA  S X=^(DA,0),X=+$P(X,"50.68,",2) I X S ^TMP($J,$P(^PSNDF(50.68,X,0),"^"))=""
 I $D(^TMP($J)) S ^PRE53(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,^PRE53(5000,NDF,2,LINE,0)="   The National Formulary Restriction has changed for the following VA Products.",LINE=LINE+1 D
 .S DA="" F  S DA=$O(^TMP($J,DA)) Q:DA=""  S ^PRE53(5000,NDF,2,LINE,0)="   "_DA,LINE=LINE+1
 S LINE=LINE-1,$P(^PRE53(5000,NDF,2,0),"^",3,4)=LINE_"^"_LINE K ^TMP($J)
 K ^TMP($J) S DA=0 F  S DA=$O(^PRE53(5000.56,DA)) Q:'DA  S IN=$P(^(DA,0),"^",2),X=$G(^PS(56,DA,0)) I X]"" S ^TMP($J,IN,$P(X,"^"))=$S($P(X,"^",4)=1:"Critical",1:"Significant")
 S LINE=1 F J=1:1 S X=$P($T(TEXT1+J),";",3) Q:X=""  S ^PRE53(5000,1,3,LINE,0)=X,LINE=LINE+1
 I '$D(^TMP($J,"A")) S ^PRE53(5000,1,3,LINE,0)="   NONE",LINE=LINE+1
 S PN="" F  S PN=$O(^TMP($J,"A",PN)) Q:PN=""  S X="   "_$$LJ^XLFSTR(PN,50)_" "_^(PN),^PRE53(5000,NDF,3,LINE,0)=X,LINE=LINE+1
 S ^PRE53(5000,1,3,LINE,0)=" ",LINE=LINE+1,^PRE53(5000,1,3,LINE,0)="EDITED INTERACTIONS",LINE=LINE+1,^PRE53(5000,1,3,LINE,0)=" ",LINE=LINE+1
 I '$D(^TMP($J,"E")) S ^PRE53(5000,1,3,LINE,0)="   NONE",LINE=LINE+1
 S PN="" F  S PN=$O(^TMP($J,"E",PN)) Q:PN=""  S X="   "_$$LJ^XLFSTR(PN,50)_" "_^(PN),^PRE53(5000,NDF,3,LINE,0)=X,LINE=LINE+1
 S ^PRE53(5000,1,3,LINE,0)=" ",LINE=LINE+1,^PRE53(5000,1,3,LINE,0)="INACTIVATED INTERACTIONS",LINE=LINE+1,^PRE53(5000,1,3,LINE,0)=" ",LINE=LINE+1
 I '$D(^TMP($J,"I")) S ^PRE53(5000,1,3,LINE,0)="   NONE",LINE=LINE+1
 S PN="" F  S PN=$O(^TMP($J,"I",PN)) Q:PN=""  S X="   "_$$LJ^XLFSTR(PN,50)_" "_^(PN),^PRE53(5000,NDF,3,LINE,0)=X,LINE=LINE+1
 S DIR(0)="Y",DIR("A")="Do you wish to edit" D ^DIR K DIR G END:$D(DIRUT),END:'Y S DIC="^PRE53(5000,NDF,2,",DWPK=1 D EN^DIWE
END K DA,DIC,DIR,DIRUT,DWPK,LINE,NDC,PN,X,Y
 Q
 ;
TEXT ;
 ;;The following VA Products have been added to the National
 ;;Drug File.  You may wish to review, then match or unmatch
 ;;local drug file entries based on this updated information.
 ;;
 ;;
TEXT1 ;
 ;;The following interactions in National Drug File (NDF) have been added,
 ;;edited or inactivated.  These changes are the result of review and
 ;;recommendations from the NDF support group.
 ;;
 ;;ADDED INTERACTIONS
 ;;
 ;;
