NDFRECLS ;BIR/DMA-reclass products ;03 Nov 98 / 10:34 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
GO S DIR(0)="SA^P:VA Product;G:VA Generic",DIR("A")="Do you wish to reclass by VA Product (P) or VA Generic (G)? " D ^DIR G END:$D(DIRUT),G:Y="G"
 ;by product
 S DIR(0)="SA^S:SINGLE;M:MULTIPLE",DIR("A")="Single (S) or Multiple (M) Products ?" D ^DIR G END:$D(DIRUT),MULT:Y="M"
 S DIR(0)="SA^P:PRIMARY;S:SECONDARY;B:BOTH",DIR("A")="Reclass Primary (P), Secondary (S), or Both (B)? " D ^DIR G END:$D(DIRUT) S PSB=Y
 F  S DIC=50.68,DIC(0)="AEQM" W !! D ^DIC Q:Y<0  S DA=+Y,DIE=DIC D
 .I PSB'="S" S DR="15;" D ^DIE
 .I PSB="P" Q
 .I '$O(^PSNDF(50.68,DA,4,0)) S NDF="^PSNDF(50.68,"_DA_",4,",NDF1=DA F  S DIC=50.605 D ^DIC Q:Y<0  I '$D(^PSNDF(50.68,4,+Y)) K DD,DO S DIC=NDF,(DINUM,X)=+Y,DA(1)=NDF1,DIC(0)="L",DIC("P")=$P(^DD(50.68,16,0),"^",2) D FILE^DICN
 .K L1,L2 S K=0 F  S K=$O(^PSNDF(50.68,DA,4,K)) Q:'K  S L1($P(^PS(50.605,K,0),"^")_"^"_K)=""
 .Q:'$D(L1)
 .S K="" W !,"Select",! F J=1:1 S K=$O(L1(K)) Q:K=""  W J,?5,$P(K,"^"),! S L2(J)=$P(K,"^",2)
 .F  K DIR S DIR(0)="F^1:3",DIR("A")="Enter 1 - "_$O(L2(" "),-1)_" or ""N"" to add a new one or ""Q"" to quit " D ^DIR Q:$D(DIRUT)  S NDF0=Y Q:NDF0="N"  Q:NDF0="Q"  Q:$D(L2(+NDF0))
 .Q:$D(DIRUT)  Q:NDF0="Q"
 .I NDF0="N" S NDF="^PSNDF(50.68,"_DA_",4,",NDF1=DA F  S DIC=50.605,DIC(0)="AEQMZ" D ^DIC Q:Y<0  I '$D(^PSNDF(50.68,4,+Y)) K DD,DO S DIC=NDF,DA(1)=NDF1,DIC(0)="L",DIC("P")=$P(^DD(50.68,16,0),"^",2),(DINUM,X)=+Y D FILE^DICN
 .I NDF0 S DIE="^PSNDF(50.68,"_DA_",4,",DA(1)=DA,DA=L2(NDF0),DR=".01;" D ^DIE
 G END
 ;
MULT ;Multiple products
 S DIC=50.605,DIC(0)="QEAM",DIC("A")="P^50.605",DIC("A")="Enter VA Drug Class Code to be changed " D ^DIC G GO:Y<0 S COD=+Y
 S DIR(0)="SA^P:PRIMARY;S:SECONDARY;B:BOTH",DIR("A")="Reclass Primary (P), Secondary (S), or Both (B)? " D ^DIR G END:$D(DIRUT) S PSB=Y
 W !,"Excuse me while I sort",! K ^TMP($J) S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S NA=$P(^(DA,0),"^") D  I DA#200=0 W "."
 .I PSB'="S",$P(^PSNDF(50.68,DA,3),"^")=COD S ^TMP($J,NA_"^"_DA)=""
 .I PSB'="P",$G(^PSNDF(50.68,DA,4,COD)) S ^TMP($J,NA_"^"_DA_"^"_COD)=""
 I '$D(^TMP($J)) W !,"No Matches Found",! G MULT
 K Y S NA="" F  S NA=$O(^TMP($J,NA)) Q:NA=""  S DA=$P(NA,"^",2) W !!,$P(NA,"^") D  Q:$D(Y)
 .I PSB'="S" S DIE=50.68,DR="15;" D ^DIE
 .I PSB'="P",$P(NA,"^",3) S DIE="^PSNDF(50.68,"_DA_",4,",DA(1)=DA,DA=$P(NA,"^",3),DR=".01;" D ^DIE
 G MULT
 ;
G ;GENERICS
 S DIR(0)="F^1:5",DIR("A")="Enter a VA Drug Class Code to change or ""A"" to display all VA Products " W !! D ^DIR G END:$D(DIRUT) I Y="A" S COD="A"
 E  S X=Y,DIC=50.605,DIC(0)="M" D ^DIC G G:Y<0 S COD=+Y
 S DIR(0)="SA^P:PRIMARY;S:SECONDARY;B:BOTH",DIR("A")="Reclass Primary (P), Secondary (S), or Both (B)? " D ^DIR G END:$D(DIRUT) S PSB=Y
 K DIC S DIC=50.6,DIC(0)="AEQM" D ^DIC G G:Y<0 S DA1=+Y
 W !,"Excuse me while I sort " S DA=0 K ^TMP($J) F  S DA=$O(^PSNDF(50.6,"APRO",DA1,DA)) Q:'DA  S NA=$P(^PSNDF(50.68,DA,0),"^") D
 .I COD="A" S ^TMP($J,NA_"^"_DA)="" Q
 .I PSB'="S",$P(^PSNDF(50.68,DA,3),"^")=COD S ^TMP($J,NA_"^"_DA)=""
 .I PSB'="P",$G(^PSNDF(50.68,DA,4,COD)) S ^TMP($J,NA_"^"_DA_"^"_COD)=""
 I '$D(^TMP($J)) W !,"No Matches Found",! G G
 K Y S NA="" F  S NA=$O(^TMP($J,NA)) Q:NA=""  S DA=$P(NA,"^",2) W !!,$P(NA,"^") D  Q:$D(Y)
 .I PSB'="S" S DIE=50.68,DR="15;" D ^DIE
 .I PSB'="P",COD'="A",$P(NA,"^",3) S DIE="^PSNDF(50.68,"_DA_",4,",DA(1)=DA,DA=$P(NA,"^",3),DR=".01;" D ^DIE
 .I PSB'="P",COD="A" D
 ..I '$O(^PSNDF(50.68,DA,4,0)) S NDF="^PSNDF(50.68,"_DA_",4,",NDF1=DA F  S DIC=50.605 D ^DIC K:Y<0 Y Q:'$D(Y)  I '$D(^PSNDF(50.68,4,+Y)) K DD,DO S DIC=NDF,(DINUM,X)=+Y,DA(1)=NDF1,DIC(0)="L",DIC("P")=$P(^DD(50.68,16,0),"^",2) D FILE^DICN
 ..K L1,L2 S K=0 F  S K=$O(^PSNDF(50.68,DA,4,K)) Q:'K  S L1($P(^PS(50.605,K,0),"^")_"^"_K)=""
 ..I $D(L1) D
 ...S K="" W !,"Select",! F J=1:1 S K=$O(L1(K)) Q:K=""  W J,?5,$P(K,"^"),! S L2(J)=$P(K,"^",2)
 ...F  K DIR S DIR(0)="F^1:3",DIR("A")="Enter 1 - "_$O(L2(" "),-1)_" or ""N"" to add a new one or ""Q"" to quit " D ^DIR Q:$D(DIRUT)  S NDF0=Y Q:NDF0="N"  Q:NDF0="Q"  Q:$D(L2(+NDF0))
 ...Q:$D(DIRUT)  Q:NDF0="Q"
 ...I NDF0="N" S NDF="^PSNDF(50.68,"_DA_",4,",NDF1=DA F  S DIC=50.605 D ^DIC Q:'Y  I '$D(^PSNDF(50.68,4,+Y)) K DD,DO S DIC=NDF,DA(1)=NDF1,DIC(0)="L",DIC("P")=$P(^DD(50.68,16,0),"^",2),(DINUM,X)=+Y D FILE^DICN
 ...I NDF0 S DIE="^PSNDF(50.68,"_DA_",4,",DA(1)=DA,DA=L2(NDF0),DR=".01;" D ^DIE
 G G
END K COD,DA,DA1,DIC,DIR,DIR,DR,L1,L2,NA,NDF,NDF0,NDF1,PSB,X,Y,^TMP($J) Q
