NDFMESS ;BIR/DMA-CREATE AND EDIT MESSAGE ; 29 Jan 2010  7:55 AM
 ;;4.0;NDF MANAGEMENT;**108,262**; 1 Jan 1999
 ;
 N DIR S NDF=1
 I '$O(^NDFK(5000,NDF,2,0)),'$O(^NDFK(5000,NDF,3,0)) G LOAD
 I $O(^NDFK(5000,NDF,2,0)) S DIR("A")="Do you wish to edit the product message",DIR("A",1)="Text already exists in this message",DIR(0)="Y" D ^DIR K DIR G END:$D(DIRUT),INT:'Y
 S DIC="^NDFK(5000,NDF,2,",DWPK=1 D EN^DIWE
INT I $O(^NDFK(5000,NDF,3,0)) S DIR("A")="Do you wish to edit the interaction message",DIR("A",1)="Text already exists in this message",DIR(0)="Y" D ^DIR K DIR G END:$D(DIRUT),LOAD:'Y
 S DIC="^NDFK(5000,NDF,3,",DWPK=1 D EN^DIWE
 ;
 ;if we've edited, do we want to load
 S DIR("A")="Are you ready to load data into the message",DIR(0)="Y" D ^DIR G END:$D(DIRUT),END:'Y
 ;
LOAD ;from 5000.506 and 5000.56
 W !,"Now loading data",!
ADDED S LINE=$O(^NDFK(5000,NDF,2," "),-1)+1,^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.506,DA)) Q:'DA  S X=^(DA,0),PN=$P($G(^PSNDF(50.68,X,0)),"^") I PN]"" S ^TMP($J,PN_"^"_X)=""
 I $D(^TMP($J)) D
 .F J=1:1 S X=$P($T(TEXT+J),";",3,300) Q:X=""  S ^NDFK(5000,NDF,2,LINE,0)=X,LINE=LINE+1
 .S PN="" F  S PN=$O(^TMP($J,PN)) Q:PN=""  S ^NDFK(5000,NDF,2,LINE,0)="   "_$P(PN,"^"),LINE=LINE+1,X=$P(PN,"^",2) D
 ..S CMOP=$P($G(^PSNDF(50.68,X,1)),"^",2),DU=$P(^(1),"^",4),DU=$P(^PSNDF(50.64,+DU,0),"^"),^NDFK(5000,NDF,2,LINE,0)=$S(CMOP]"":"    (CMOP - "_CMOP_")",1:""),$E(^(0),30)="(DISPENSE UNIT - "_DU_")",LINE=LINE+1
 ..S TXT="     ",I=0 F  S I=$O(^PSNDF(50.68,"ANDC",X,I)) Q:'I  S NDC=$P(^PSNDF(50.67,I,0),"^",2) I NDC]"" S NDC=$E(NDC,1,6)_"-"_$E(NDC,7,10)_"-"_$E(NDC,11,12),TXT=TXT_NDC_"   " I $L(TXT)>65 D
 ...S ^NDFK(5000,NDF,2,LINE,0)=TXT,LINE=LINE+1,TXT=""
 ..I $L(TXT)>5 S ^NDFK(5000,NDF,2,LINE,0)=TXT,LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.5,DA)) Q:'DA  S ^TMP($J,$S($P($G(^PSNDF(50.68,DA,5)),"^"):"F",1:"N"),$P(^PSNDF(50.68,DA,0),"^"))=""
NFI S ^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1 F J=1:1 S X=$P($T(TEXT2+J),";",3,300) Q:X=""  S ^NDFK(5000,NDF,2,LINE,0)=X,LINE=LINE+1
 S ^NDFK(5000,NDF,2,LINE,0)="FORMULARY ITEMS",LINE=LINE+1
 S NA="" I $O(^TMP($J,"F",NA))="" S ^NDFK(5000,NDF,2,LINE,0)="   NONE",LINE=LINE+1
 F  S NA=$O(^TMP($J,"F",NA)) Q:NA=""  S ^NDFK(5000,NDF,2,LINE,0)="   "_NA,LINE=LINE+1
 S ^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="NON-FORMULARY ITEMS",LINE=LINE+1
 S NA="" I $O(^TMP($J,"N",NA))="" S ^NDFK(5000,NDF,2,LINE,0)="   NONE",LINE=LINE+1
 F  S NA=$O(^TMP($J,"N",NA)) Q:NA=""  S ^NDFK(5000,NDF,2,LINE,0)="   "_NA,LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.7,DA)) Q:'DA  S DA1=^(DA,0),^TMP($J,$P(^PSNDF(50.68,DA1,0),"^"))=$P($G(^PSNDF(50.68,DA1,1)),"^",2)
CMOP I $D(^TMP($J)) S ^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1 F J=1:1 S X=$P($T(TEXT3+J),";",3,300) Q:X=""  S ^NDFK(5000,NDF,2,LINE,0)=X,LINE=LINE+1
 I $D(^TMP($J)) S ^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,DA="" F  S DA=$O(^TMP($J,DA)) Q:DA=""  S X=^(DA),^NDFK(5000,NDF,2,LINE,0)="   "_DA_"    "_X,LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000,1,4,DA)) Q:'DA  S X=^(DA,0),X=+$P(X,"50.68,",2) I X S ^TMP($J,$P(^PSNDF(50.68,X,0),"^"))="    "_$G(^PSNDF(50.68,X,6,1,0),"Restriction deleted")
NFR I $D(^TMP($J)) S ^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="The National Formulary Restriction has changed for the following VA Products.",LINE=LINE+1 D
 .S DA="" F  S DA=$O(^TMP($J,DA)) Q:DA=""  S ^NDFK(5000,NDF,2,LINE,0)="   "_DA,LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="    "_^TMP($J,DA),LINE=LINE+1
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.9,DA)) Q:'DA  S CS=$P($G(^PSNDF(50.68,DA,7)),"^"),NA=$P(^(0),"^") I CS S ^TMP($J,NA_"^"_CS)=""
 ;
CS I $D(^TMP($J)) S ^NDFK(5000,NDF,2,LINE,0)=" ",LINE=LINE+1 F J=1:1 S X=$P($T(TEXT4+J),";",3,300) Q:X=""  S ^NDFK(5000,NDF,2,LINE,0)=X,LINE=LINE+1
 I $D(^TMP($J)) S NA=""  F  S NA=$O(^TMP($J,NA)) Q:NA=""  S ^NDFK(5000,NDF,2,LINE,0)=$P(NA,"^"),$E(^(0),70)=$P(NA,"^",2),LINE=LINE+1
 ;
 ;Possible Dosages Setting Changes
 N VAPRDNAM,VAPRDIEN,ACDPD,PDTC,CMOP K ^TMP($J) S VAPRDIEN=0
 F  S VAPRDIEN=$O(^NDFK(5000.92,VAPRDIEN)) Q:'VAPRDIEN  D
 . S VAPRDNAM=$P($G(^PSNDF(50.68,VAPRDIEN,0)),"^") Q:VAPRDNAM=""
 . S ^TMP($J,VAPRDNAM)=VAPRDIEN
 I $D(^TMP($J)) D
 . S ^NDFK(5000,NDF,2,LINE,0)=""
 . S LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="The Auto-Create Possible Dosages settings have been edited for the"
 . S LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="following VA Products. Please review your local dosages for products"
 . S LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="matched to these entries. Edits to your site's possible dosages or"
 . S LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)="local possible dosages may be needed."
 . S LINE=LINE+1,^NDFK(5000,NDF,2,LINE,0)=""
 . S VAPRDNAM=""
 . F  S VAPRDNAM=$O(^TMP($J,VAPRDNAM)) Q:VAPRDNAM=""  D
 . . S VAPRDIEN=^TMP($J,VAPRDNAM),LINE=LINE+1
 . . S CMOP=$P($G(^PSNDF(50.68,VAPRDIEN,1)),"^",2)
 . . S ^NDFK(5000,NDF,2,LINE,0)=VAPRDNAM_"    "_$S(CMOP'="":"(CMOP - "_CMOP_")",1:""),LINE=LINE+1
 . . S ACDPD=$$GET1^DIQ(50.68,VAPRDIEN,40,"I")
 . . S PDTC=$$GET1^DIQ(50.68,VAPRDIEN,41,"I")
 . . S ^NDFK(5000,NDF,2,LINE,0)="     Auto-Create Default Possible Dosage? "_$$GET1^DIQ(50.68,VAPRDIEN,40),LINE=LINE+1
 . . S:ACDPD="N" ^NDFK(5000,NDF,2,LINE,0)="     Possible Dosages To Auto-Create: "_$$GET1^DIQ(50.68,VAPRDIEN,41),LINE=LINE+1
 . . S:(ACDPD="N"&(PDTC'="N")) ^NDFK(5000,NDF,2,LINE,0)="     Package: "_$$GET1^DIQ(50.68,VAPRDIEN,42),LINE=LINE+1
 . . S ^NDFK(5000,NDF,2,LINE,0)=""
 ;
 S LAST=$O(^NDFK(5000,NDF,2," "),-1),$P(^NDFK(5000,NDF,2,0),"^",3,4)=LAST_"^"_LAST K ^TMP($J)
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.56,DA)) Q:'DA  S IN=$P(^(DA,0),"^",2),X=$G(^PS(56,DA,0)) I X]"" S ^TMP($J,IN,$P(X,"^"))=$S($P(X,"^",4)=1:"Critical",1:"Significant")
 S LINE=1 F J=1:1 S X=$P($T(TEXT1+J),";",3) Q:X=""  S ^NDFK(5000,1,3,LINE,0)=X,LINE=LINE+1
 I '$D(^TMP($J,"A")) S ^NDFK(5000,1,3,LINE,0)="   NONE",LINE=LINE+1
 S PN="" F  S PN=$O(^TMP($J,"A",PN)) Q:PN=""  S X="   "_$$LJ^XLFSTR(PN,50)_" "_^(PN),^NDFK(5000,NDF,3,LINE,0)=X,LINE=LINE+1
 S ^NDFK(5000,1,3,LINE,0)=" ",LINE=LINE+1,^NDFK(5000,1,3,LINE,0)="EDITED INTERACTIONS",LINE=LINE+1,^NDFK(5000,1,3,LINE,0)=" ",LINE=LINE+1
 I '$D(^TMP($J,"E")) S ^NDFK(5000,1,3,LINE,0)="   NONE",LINE=LINE+1
 S PN="" F  S PN=$O(^TMP($J,"E",PN)) Q:PN=""  S X="   "_$$LJ^XLFSTR(PN,50)_" "_^(PN),^NDFK(5000,NDF,3,LINE,0)=X,LINE=LINE+1
 S ^NDFK(5000,1,3,LINE,0)=" ",LINE=LINE+1,^NDFK(5000,1,3,LINE,0)="INACTIVATED INTERACTIONS",LINE=LINE+1,^NDFK(5000,1,3,LINE,0)=" ",LINE=LINE+1
 I '$D(^TMP($J,"I")) S ^NDFK(5000,1,3,LINE,0)="   NONE",LINE=LINE+1
 S PN="" F  S PN=$O(^TMP($J,"I",PN)) Q:PN=""  S X="   "_$$LJ^XLFSTR(PN,50)_" "_^(PN),^NDFK(5000,NDF,3,LINE,0)=X,LINE=LINE+1
 ;
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.23,DA)) Q:'DA  S ARG=+$P(^(DA,0),"^",2),^TMP($J,ARG,$P(^PSNDF(50.68,DA,0),"^"))=""
 I $D(^TMP($J)) S ^NDFK(5000,NDF,3,LINE,0)=" ",LINE=LINE+1
 I $D(^TMP($J,1)) S ^NDFK(5000,NDF,3,LINE,0)="The following products have been flagged for exclusion from drug-drug",^NDFK(5000,NDF,3,LINE+1,0)="interaction checks.",^NDFK(5000,NDF,3,LINE+2,0)=" ",LINE=LINE+3 D
 .S NA="" F  S NA=$O(^TMP($J,1,NA)) Q:NA=""  S ^NDFK(5000,NDF,3,LINE,0)=" "_NA,LINE=LINE+1
 I $D(^TMP($J,0)) S ^NDFK(5000,NDF,3,LINE,0)=" ",LINE=LINE+1 D
 .S ^NDFK(5000,NDF,3,LINE,0)="The following products, previously flagged for exclusion from drug-drug",^NDFK(5000,NDF,3,LINE+1,0)="interaction checks, have been changed to be included"
 .S ^NDFK(5000,NDF,3,LINE+2,0)="in drug-drug interaction checks where appropriate."
 .S ^NDFK(5000,NDF,3,LINE+3,0)=" ",LINE=LINE+4
 .S NA="" F  S NA=$O(^TMP($J,0,NA)) Q:NA=""  S ^NDFK(5000,NDF,3,LINE,0)=" "_NA,LINE=LINE+1
 I $O(^NDFK(5000.91,0)) K ^TMP($J) S DA=0,^NDFK(5000,NDF,3,LINE,0)=" ",^NDFK(5000,NDF,3,LINE+1,0)="The FDA Med Guide for the following products has been changed",^NDFK(5000,NDF,3,LINE+2,0)=" ",LINE=LINE+3 D
 .F  S DA=$O(^NDFK(5000.91,DA)) Q:'DA  S X=^(DA,0),NA=$P(^PSNDF(50.68,+X,0),"^"),^TMP($J,$P(X,"^",2),NA)=""
 I $D(^TMP($J,"A")) S ^NDFK(5000,NDF,3,LINE,0)=" ADDED",^NDFK(5000,NDF,3,LINE+1,0)=" ==========",LINE=LINE+2,NA="" F  S NA=$O(^TMP($J,"A",NA)) Q:NA=""  S ^NDFK(5000,NDF,3,LINE,0)=" "_NA,LINE=LINE+1
 I $D(^TMP($J,"E")) S ^NDFK(5000,NDF,3,LINE,0)=" ",^NDFK(5000,NDF,3,LINE+1,0)=" EDITED",^NDFK(5000,NDF,3,LINE+2,0)=" ===========",LINE=LINE+3,NA="" D
 .F  S NA=$O(^TMP($J,"E",NA)) Q:NA=""  S ^NDFK(5000,NDF,3,LINE,0)=" "_NA,LINE=LINE+1
 I $D(^TMP($J,"D")) S ^NDFK(5000,NDF,3,LINE,0)=" ",^NDFK(5000,NDF,3,LINE+1,0)=" DELETED",^NDFK(5000,NDF,3,LINE+2,0)=" ===========",LINE=LINE+3,NA="" D
 .F  S NA=$O(^TMP($J,"D",NA)) Q:NA=""  S ^NDFK(5000,NDF,3,LINE,0)=" "_NA,LINE=LINE+1
 S ^NDFK(5000,NDF,3,LINE,0)=" ",LINE=LINE+1
 S LAST=$O(^NDFK(5000,NDF,3," "),-1),$P(^NDFK(5000,NDF,3,0),"^",3,4)=LAST_"^"_LAST
 S DIR(0)="Y",DIR("A")="Do you wish to edit the product message" D ^DIR K DIR G END:$D(DIRUT) I Y S DIC="^NDFK(5000,NDF,2,",DWPK=1 D EN^DIWE
 S DIR(0)="Y",DIR("A")="Do you wish to edit the interaction message" D ^DIR K DIR G END:$D(DIRUT),END:'Y S DIC="^NDFK(5000,NDF,3,",DWPK=1 D EN^DIWE
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
TEXT2 ;
 ;;The National Formulary Indicator has changed for the following
 ;;VA Products.  The National Formulary Indicator will automatically
 ;;be changed in your local DRUG file (#50).  Please review the
 ;;VISN and Local Formulary designations of these products and
 ;;make appropriate changes.
 ;;
 ;
TEXT3 ;
 ;;The following active VA Products are no longer marked for CMOP.
 ;;All local drug file entries matched to these VA Products will
 ;;be UNMARKED for CMOP.  In order to have these entries dispensed
 ;;by CMOP any local DRUG file (#50) entries matched to these
 ;;products must be re-matched to another VA product that is actively
 ;;marked for CMOP dispensing.
 ;
TEXT4 ;
 ;;
 ;;The CS Federal Schedule for the following VA Products has
 ;;been added or changed.  You may wish to review the DRUG
 ;;file (#50) and make appropriate changes to the DEA, SPECIAL
 ;;HDLG field (#3).
 ;;
 ;
