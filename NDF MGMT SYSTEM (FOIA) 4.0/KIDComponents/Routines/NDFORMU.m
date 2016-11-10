NDFORMU ;BIR/DMA-entry formulary information ;13 Sep 99 / 7:41 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
GO S DIR(0)="SA^P:VA Product;G:VA Generic",DIR("A")="Do you wish to sort by VA Product (P) or VA Generic (G)? " W !! D ^DIR G END:$D(DIRUT),G:Y="G"
 ;by product
 S DIR(0)="SA^S:SINGLE;M:MULTIPLE",DIR("A")="Single (S) or Multiple (M) Products ?" D ^DIR G END:$D(DIRUT),MULT:Y="M"
 F  S DIC=50.68,DIC(0)="AEQM" D ^DIC Q:Y<0  S DA=+Y,DIE=DIC,DR="4;17R;" D EDIT
 G END
 ;
MULT ;Multiple products
 S DIC=50.605,DIC(0)="QEAM",DIC("A")="P^50.605",DIC("A")="Enter VA Drug Class Code to sort by " W !! D ^DIC G GO:Y<0 S COD=+Y
 S DIR(0)="SA^P:PRIMARY;S:SECONDARY;B:BOTH",DIR("A")="Sort Primary (P), Secondary (S), or Both (B)? " D ^DIR G END:$D(DIRUT) S PSB=Y
 W !,"Excuse me while I sort",! K ^TMP($J) S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  W:DA#200=0 "." S NA=$P(^(DA,0),"^") I PSB'="S"&($P($G(^(3)),"^")=COD)!(PSB'="P"&$D(^(4,COD))) S ^TMP($J,NA_"^"_DA)=""
 I '$D(^TMP($J)) W !,"No Matches Found",! G MULT
 K Y S NA="" F  S NA=$O(^TMP($J,NA)) Q:NA=""  S DIE=50.68,DR="4;17R;",DA=$P(NA,"^",2) W !!,$P(NA,"^") D EDIT
 G MULT
 ;
G ;GENERICS
 S DIC=50.605,DIC(0)="QEAM",DIC("A")="P^50.605",DIC("A")="Enter VA Drug Class Code to sort by " W !! D ^DIC G GO:Y<0 S COD=+Y
 S DIR(0)="SA^P:PRIMARY;S:SECONDARY;B:BOTH",DIR("A")="Sort Primary (P), Secondary (S), or Both (B)? " D ^DIR G END:$D(DIRUT) S PSB=Y
 K DIC S DIC=50.6,DIC(0)="AEQM" D ^DIC G G:Y<0 S DA1=+Y
 W !,"Excuse me while I sort " K ^TMP($J) S DA=0 F  S DA=$O(^PSNDF(50.6,"APRO",DA1,DA)) Q:'DA  S NA=$P(^PSNDF(50.68,DA,0),"^") I PSB'="S"&($P($G(^(3)),"^")=COD)!(PSB'="P"&($D(^(4,COD)))) S ^TMP($J,NA_"^"_DA)=""
 I '$D(^TMP($J)) W !,"No Matches Found",! G G
 K Y S NA="" F  S NA=$O(^TMP($J,NA)) Q:NA=""  S DA=$P(NA,"^",2) W !!,$P(NA,"^") S DIE=50.68,DR="4;17R;" D EDIT
 G G
END K ARR,COD,DA,DA1,DIC,DIE,DIR,DIR,DR,IND,NA,NDF1,NDF2,PSB,X,Y,^TMP($J) Q
 Q
 ;
CSUM(FILE,DA,MULT) ;check sum of a word processing field
 N C,J,L,X S CSUM=0
 S L=0 F  S L=$O(@FILE@(DA,MULT,L)) Q:'L  S X=^(L,0) F J=1:1:$L(X) S CSUM=L*J*$A(X,J)+CSUM
 Q CSUM
 ;
EDIT ;DIE call and look up into wp file
 S NDF1=$P($G(^PSNDF(50.68,DA,5)),"^")
 D ^DIE
 I $P($G(^PSNDF(50.68,DA,5)),"^")'=NDF1 S ^NDFK(5000.5,DA,0)=DA
 S NDF1=$$CSUM("^PSNDF(50.68)",DA,6)
 ;
 I '$O(^PSNDF(50.68,DA,6,0)) W !," No current restriction",!
 E  S X=0 W !," Current restriction",! F  S X=$O(^PSNDF(50.68,DA,6,X)) Q:'X  W ?5,^(X,0),!
 R !," Restriction (@ to delete) :",X:DTIME Q:'$T  Q:X["^"
 I X="@",$O(^PSNDF(50.68,DA,6,0)) K ^PSNDF(50.68,DA,6) S Z=$O(^NDFK(5000,1,4," "),-1)+1,^(Z,0)="PSNDF(50.68,"_DA_",6)" K Z W "    Deleted",! Q
 I X="@",'$O(^PSNDF(50.68,DA,6,0)) W !!," No restriction to delete" Q
 I $E(X)="?" K ARR D
 .W @IOF,$C(13) S IND=0 F J=1:1 S IND=$O(^PS(51.7,IND)) Q:'IND  S ARR(J)=IND,K=0 W J F  S K=$O(^PS(51.7,IND,2,K)) Q:'K  W ?5,^(K,0),!
 .S DIR(0)="N^1:"_(J-1),DIR("A")="Select 1 to "_(J-1)_" or ^ to quit" D ^DIR Q:$D(DIRUT)  S Y=ARR(+Y)
 Q:$D(DIRUT)
 E  S DIC=51.7,DIC(0)="EZ" D ^DIC Q:Y<0
 K ^PSNDF(50.68,DA,6) M ^PSNDF(50.68,DA,6)=^PS(51.7,+Y,2)
 S NDF2=$$CSUM("^PSNDF(50.68)",DA,6)
 I NDF1'=NDF2 S X=$O(^NDFK(5000,1,4," "),-1)+1,^(X,0)="PSNDF(50.68,"_DA_",6)"
 I NDF1=NDF2,$G(^PSNDF(50.68,DA,6,0))]"" S X=$O(^NDFK(5000,1,4," "),-1)+1,^(X,0)="PSNDF(50.68,"_DA_",6,0)"
 Q
 ;
ENTER ;enter new restriction
 S PSSNFI=1
 F  S DIC=51.7,DIC(0)="AQELMZ",DLAYGO=51.7 D ^DIC Q:Y<0  S DIE=DIC,DA=+Y,DR=".01;3" D ^DIE
 K DA,DIC,DIE,DR,PSSNFI,Y Q
