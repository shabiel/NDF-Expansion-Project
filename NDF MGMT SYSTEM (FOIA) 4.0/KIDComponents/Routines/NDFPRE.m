NDFPRE ;BIR/DMA-pre-transport routine to gather data ; 12 Dec 2008  8:18 AM
 ;;4.0;NDF MANAGEMENT;; 1 Jan 99
 ;
 ;Reads to the AUDIT File (#1.1), ^DIA, supported by DBIA #2602
 ;
 S DIR(0)="Y",DIR("A")="Have you run the VUID assigner",DIR("B")="NO" D ^DIR I 'Y W !,"Aborting" Q
 S DIR(0)="Y",DIR("A")="Have you backed up NDFK",DIR("B")="NO" D ^DIR I 'Y W !,"Aborting" Q
 ;LOAD THE TEXT
 F J=1:1 S X=$P($T(TEXT+J),";",3,300) Q:X=""  S @XPDGREF@("TEXT",J)=X
 ;
 S PN=$P(XPDNM,"*",3) I $D(^NDFK(5000,1,5,PN)) W !!,"This patch has already been transported",!! Q
 K ^TMP($J)
 ;N A1,A2,CT,FILE,GRP,I,J,J1,J2,K,LAST,LOC,NEW,NEWP,NMSP,NUM,PRE,ROOT,ROOT1,ROOT2,ROOT3,X
 S NMSP=$P(XPDNM,"*"),NUM=$O(^NDFK(5000,"B",NMSP,0)),FILE=0 Q:'NUM
 I $D(^NDFK(5000,NUM,"PRE")) S PRE=^("PRE") I PRE]"" S:PRE'["^" PRE="^"_PRE I @("$T("_PRE_")]""""") D @PRE
 ;run package specific pre-pre-transport routine
 I $D(^NDFK(5000,NUM,"POST")) S POST=^("POST"),@XPDGREF@("POST")=POST
 ;and load name of package specific post-post install routine into transport global
 ;(sam): Collect the data from various files by comparing last transport data with changes
 ;       in the file audit global.
 S TREC=0 F  S FILE=$O(^NDFK(5000,NUM,1,FILE)) Q:'FILE  S X=^(FILE,0),J1=+$P(X,"^",2),J2=+$P(X,"^",3) D
 .F  S J1=$O(^DIA(FILE,J1)) Q:'J1  I $D(^(J1,0)) S X=^(0),P01=$P(X,"^",3)[".01"&$D(^(3)),P01T=P01&($P(X,"^",3)=".01") D
 ..;P01=.01 FIELD, P01T=.01 TOP LEVEL
 ..I P01 S ^TMP($J,"SN"_$S(P01T:"T",P01:""),FILE,J1)="",^TMP($J,"SET01",FILE,$P(X,"^"),$P(X,"^",3),J1)=""
 ..I 'P01 S ^TMP($J,"D",FILE,$P(X,"^"),$P(X,"^",3))=FILE_"^"_J1
 ..S LAST=J1,TREC=TREC+1
 .I $D(LAST) S $P(^NDFK(5000,NUM,1,FILE,0),"^",2)=LAST K LAST
 .F  S J2=$O(^NDFK(5000.1,FILE,J2)) Q:'J2  I $D(^(J2,0)) S X=^(0),P01=$P(X,"^",3)[".01"&$D(^(3)),P01T=P01&($P(X,"^",3)=".01") D
 ..;P01=.01 FIELD, P01T=.01 TOP LEVEL
 ..I P01 S ^TMP($J,"SN"_$S(P01T:"T",P01:""),FILE,J2)="",^TMP($J,"SET01",FILE,$P(X,"^"),$P(X,"^",3),J2)=""
 ..I 'P01 S ^TMP($J,"D",FILE,$P(X,"^"),$P(X,"^",3))=FILE_"^"_J2
 ..S LAST=J2,TREC=TREC+1
 .I $D(LAST) S $P(^NDFK(5000,NUM,1,FILE,0),"^",3)=LAST K LAST
 F A1="D","E" S FILE=0 F  S FILE=$O(^TMP($J,A1,FILE)),A2=0 Q:'FILE  F  S A2=$O(^TMP($J,A1,FILE,A2)),A3=0 Q:A2=""  F  S A3=$O(^TMP($J,A1,FILE,A2,A3)) Q:'A3  S X=^(A3),^TMP($J,"S"_A1,$P(X,"^"),$P(X,"^",2))=""
 S ROOT=$NA(@XPDGREF@("DATANT"))
 ;get new .01 top level fields first
 ;(sam): Note that the IENs are set using the data in the Audit Global
 S FILE=0  F  S FILE=$O(^TMP($J,"SNT",FILE)),J=0,CT=0 Q:'FILE  S ROOT1=$NA(@ROOT@(FILE)) F  S J=$O(^TMP($J,"SNT",FILE,J)) Q:'J  D
 .S CT=CT+1,@ROOT1@(CT)=$G(^DIA(FILE,J,0)),DATA=^DIA(FILE,J,3),CT=CT+1 D DATER S @ROOT1@(CT)=DATA
 .I $D(^DIA(FILE,J,3.1)) S @ROOT1@(CT)=$P(^DIA(FILE,J,3.1),"^")
 S ROOT=$NA(@XPDGREF@("DATAN"))
 ;get new .01 multiple fields next
 S FILE=0  F  S FILE=$O(^TMP($J,"SN",FILE)),J=0,CT=0 Q:'FILE  S ROOT1=$NA(@ROOT@(FILE)) F  S J=$O(^TMP($J,"SN",FILE,J)) Q:'J  D
 .S CT=CT+1,@ROOT1@(CT)=$G(^DIA(FILE,J,0)),DATA=^DIA(FILE,J,3),CT=CT+1 D DATER S @ROOT1@(CT)=DATA
 .I $D(^DIA(FILE,J,3.1)) S @ROOT1@(CT)=$P(^DIA(FILE,J,3.1),"^")
 ;
 S FILE=0,ROOT=$NA(@XPDGREF@("DATAO"))
 ;now get the rest of the data
  S FILE=0 F  S FILE=$O(^TMP($J,"SD",FILE)),J=0 Q:'FILE  S ROOT1=$NA(@ROOT@(FILE)),CT=$O(@ROOT1@(" "),-1) F  S J=$O(^TMP($J,"SD",FILE,J)) Q:'J  D
 .F I=0,3 S LOC(I)=$G(^DIA(FILE,J,I))
 .I $D(^DIA(FILE,J,3.1)) S LOC(3)=$P(^DIA(FILE,J,3.1),"^")
 .I LOC(3)="" I $O(^TMP($J,"SET01",FILE,$P(LOC(0),"^"),$P(LOC(0),"^",3),J)) Q
 .;if it's a delete and there's a later set - ignore
 .;primarily for .01 fields which are set first
 .S CT=CT+1,@ROOT1@(CT)=LOC(0),DATA=LOC(3) D DATER S CT=CT+1,@ROOT1@(CT)=DATA
 S FILE=0  F  S FILE=$O(^TMP($J,"SE",FILE)) Q:'FILE  S ROOT1=$NA(@ROOT@(FILE)),CT=$O(@ROOT1@(" "),-1) F  S J=$O(^TMP($J,"SE",FILE,J)) Q:'J  D
 .F I=0,3 S CT=CT+1,@ROOT1@(CT)=$G(^NDFK(5000.1,FILE,J,I))
 .I $D(^NDFK(5000.1,FILE,J,3.1)) S @ROOT1@(CT)=$P(^NDFK(5000.1,FILE,J,3.1),"^")
 ;
WORD S J1=+$P(^NDFK(5000,NUM,0),"^",3),ROOT1=$NA(@XPDGREF@("WORD")),CT=1
 F  S J1=$O(^NDFK(5000,NUM,4,J1)) Q:'J1  S X=^(J1,0) S:$E(X)'="^" X="^"_X S LAST=J1,^TMP($J,"W",X)="",TREC=TREC+1
 S X="" F  S X=$O(^TMP($J,"W",X)) Q:X=""  S @ROOT1@(CT)=X,ROOT2=$NA(@ROOT1@(CT)),ROOT3=$NA(@ROOT2@("D")) M @ROOT3=@X S CT=CT+1
 I $D(LAST) S $P(^NDFK(5000,NUM,0),"^",3)=LAST
 ;
GROUP S GRP=$P(^NDFK(5000,NUM,0),"^",2),@XPDGREF@("GROUP")=GRP
 ;
MESSAGE M @XPDGREF@("MESSAGE")=^NDFK(5000,NUM,2)
 M @XPDGREF@("MESSAGE2")=^NDFK(5000,NUM,3)
 I $O(^NDFK(5000.608,0)) D
 .K ^TMP("PSN",$J),^TMP("PSNN",$J) S ROOT=$NA(@XPDGREF@("MESSAGE")),LINE=$O(@ROOT@(" "),-1)+1
 .S ^TMP("PSN",$J,LINE,0)=" ",^TMP("PSN",$J,LINE+1,0)="The override dose form checks field has changed for the following products",^TMP("PSN",$J,LINE+2,0)=" ",LINE=LINE+3
 .S DA=0 F  S DA=$O(^NDFK(5000.608,DA)) Q:'DA  S X=^(DA,0),^TMP("PSNN",$J,$P(^PSNDF(50.68,+X,0),"^")_"^"_$P(X,"^",2,3))=""
 .S NA="" F  S NA=$O(^TMP("PSNN",$J,NA)) Q:NA=""  S ^TMP("PSN",$J,LINE,0)=$P(NA,"^"),^TMP("PSN",$J,LINE+1,0)="    changed from "_$S($P(X,"^",2):"YES",1:"NO")_" to "_$S($P(X,"^",3):"YES",1:"NO"),^TMP("PSN",$J,LINE+2,0)=" ",LINE=LINE+3
 M @XPDGREF@("MESSAGE")=^TMP("PSN",$J)
 ;
UNMAP ;GET GENERICS AND PRODUCTS TO UNMAP
 S ROOT1=$NA(@XPDGREF@("GENERIC")),DA=0 F  S DA=$O(^NDFK(5000.3,DA)) Q:'DA  S X=^(DA,0),@ROOT1@(X)=""
 S ROOT1=$NA(@XPDGREF@("PRODUCT")),DA=0 F  S DA=$O(^NDFK(5000.2,DA)) Q:'DA  S X=^(DA,0),@ROOT1@(X)=""
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  I $P($G(^(DA,7)),"^",3) S @ROOT1@(DA)=""
 S ROOT1=$NA(@XPDGREF@("POE")),DA=0 F  S DA=$O(^NDFK(5000.4,DA)) Q:'DA  S X=^(DA,0),@ROOT1@(X)=""
 S ROOT1=$NA(@XPDGREF@("CMOP")),DA=0 F  S DA=$O(^NDFK(5000.7,DA)) Q:'DA  S @ROOT1@(X)=""
 S ROOT1=$NA(@XPDGREF@("NFI")),DA=0 F  S DA=$O(^NDFK(5000.5,DA)) Q:'DA  S @ROOT1@(DA)=""
 M @XPDGREF@("CLASS")=^NDFK(5000.8)
 ;
 S ^NDFK(5000,1,5,PN,0)=PN_"^"_$$NOW^XLFDT_"^"_DUZ,@XPDGREF@("TREC")=TREC
 ;K A1,A2,CT,FILE,GRP,I,J,J1,J2,K,LAST,LOC,NEW,NEWP,NMSP,NUM,PRE,ROOT,ROOT1,ROOT2,ROOT3,X,^TMP($J)
 Q
 ;
 ;
DATER ;CONVERT DATE TO INTERNAL
 I DATA?3A1" "1.2N1", "4N,"JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC^Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec^"[$E(DATA,1,3) N X S X=DATA,%DT="X" D ^%DT S DATA=Y
 Q
 ;
TEXT ;
 ;;unmatched from the National Drug File (NDF).  The VA Product
 ;;name and CMOP ID corresponding to the unmatched local drug file
 ;;name are listed on the indented line beneath each entry.  An
 ;;Inactivation Date may be listed for entries when this reason
 ;;applies.  Until you rematch these entries to NDF, they will not
 ;;transmit to CMOP and drug-drug interaction checks will not check
 ;;for these products.  It is critical that you rematch these
 ;;products immediately.  You may also need to match a new
 ;;orderable item.  Any possible dosages and local possible
 ;;dosages for these unmatched products have been deleted.
 ;;Therefore, the dosages for each unmatched product should
 ;;be reviewed after the rematch or recreated if the product
 ;;can not be rematched to a VA Product through the NDF
 ;;matching process.
 ;;
 ;; DRUG                                                 IEN       INACTIVATION
 ;;                                                                    DATE
 ;;
