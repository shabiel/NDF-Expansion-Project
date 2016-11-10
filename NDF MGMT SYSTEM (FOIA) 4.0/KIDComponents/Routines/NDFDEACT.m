NDFDEACT ;BIR/DMA-inquiries, link/unlink, and inactivate/reactivate items ; 19 Apr 2010  8:46 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
PROD ;INACTIVATE PRODUCT (AND ASSOCIATED NDCS)
 F  Q:$D(DIRUT)  S DIC=50.68,DIC(0)="AEQMZ" D ^DIC Q:Y<0  S DA=+Y,Y1=^(1),Y3=^(3),Y7=$G(^(7)) D
 .W @IOF,!,"VA Product name: ",$P(Y(0),"^"),!,"VA Generic Name: ",$P(^PSNDF(50.6,+$P(Y(0),"^",2),0),"^"),!,"Dose Form: ",$P(^PS(50.606,+$P(Y(0),"^",3),0),"^"),"   Strength: ",$P(Y(0),"^",4)," Units: ",$P($G(^PS(50.607,+$P(Y(0),"^",5),0)),"^")
 .W !,"National Formulary Name: ",$P(Y(0),"^",6),!,"VA Print Name: ",$P(Y1,"^"),!,"VA Product Identifier: ",$P(Y1,"^",2)," Transmit to CMOP: ",$S($P(Y1,"^",3):"Yes",1:"No")
 .W " VA Dispense Unit: ",$P($G(^PSNDF(50.64,+$P(Y1,"^",4),0)),"^")
 .W !,"PMIS: ",$P($G(^PSPPI(+$P(Y1,"^",5),0),"None"),"^"),!,"Active Ingredients: " S K=0 F  S K=$O(^PSNDF(50.68,DA,2,K)) Q:'K  S X=^(K,0),ING=^PS(50.416,K,0) S:$P(ING,"^",2) ING=^PS(50.416,$P(ING,"^",2),0) D
 ..W ?23,$P(ING,"^"),"  Strength: ",$P(X,"^",2)," Units :",$P($G(^PS(50.607,+$P(X,"^",3),0)),"^"),!
 .W !,"Primary VA Drug Class: ",$P($G(^PS(50.605,+Y3,0),"Unknown"),"^"),!,"Secondary VA Drug Class: " S K=0 F  S K=$O(^PSNDF(DA,4,K)) Q:'K  W ?26,$P($G(^PS(50.605,+K,0),"Unknown"),"^"),!
 .W !,"CS Federal Schedule: ",$P(Y7,"^")," Single/Multi Source Product ",$S($P(Y7,"^",2)="M":"Multi",$P(Y7,"^",2)="S":"Single",1:"")
 .W !,"Inactivation date: ",$$FMTE^XLFDT($P(Y7,"^",3))
 .W !,"Max Single Dose: ",$P(Y7,"^",4),"  Min Single Dose: ",$P(Y7,"^",5),!,"Max Daily Dose: ",$P(Y7,"^",6),"  Min Daily Dose: ",$P(Y7,"^",7),!,"Max Cumulative Dose: ",$P(Y7,"^",8),!!
 .I $P(Y7,"^",3)="" S DIR(0)="Y",DIR("A")="Do you want to Inactivate " D ^DIR Q:$D(DIRUT)  I Y S DR="21////"_DT_";",DIE="^PSNDF(50.68," D ^DIE S DIC="^NDFK(5000.2,",X=DA K DD,DO D FILE^DICN S OLDDA=DA D
 ..S DA=0 F  S DA=$O(^PSNDF(50,68,"ANDC",OLDDA,DA)) Q:'DA  S DIE="^PSNDF(50.67,",DR="7////"_DT_";" D ^DIE
 ..;S DA(1)=OLDDA,DIC="^PSNDF(50.68,"_DA(1)_",""TERMSTATUS"",",X=DT,DIC("DR")=".02////0" D FILE^DICN
 .I $P(Y7,"^",3) S DIR(0)="Y",DIR("A")="Do you want to Reactivate " W !,"That product was inactivated on ",$$FMTE^XLFDT($P(Y7,"^",3)) D ^DIR Q:$D(DIRUT)  I Y D
  ..S DIE="^PSNDF(50.68,",DR="21///@" D ^DIE S OLDDA=DA D
 ...S DIK="^NDFK(5000.2,",DA=$O(^NDFK(5000.2,"B",OLDDA,0)) I DA D ^DIK
 ...S DA=0 F  S DA=$O(^PSNDF(50.68,"ANDC",OLDDA,DA)) Q:'DA  S DIE="^PSNDF(50.67,",DR="7///@" D ^DIE
 ...;S DA(1)=OLDDA,DIC="^PSNDF(50.68,"_DA(1)_",""TERMSTATUS"",",X=DT,DIC("DR")=".02////1" D FILE^DICN
 K DA,DIE,DIE,DIRUT,DR,ING,K,OLDDA,X,Y,Y1,Y3,Y7 Q
 ;
NDC ;OR UPN
 S DIR(0)="SA^N:NDC;U:UPN",DIR("A")="NDC (N) or UPN (U) " D ^DIR G END:$D(DIRUT) S PROMPT=Y(0)
 F  S DIC=50.67,DIC(0)="AEQZ",DIC("A")="Select "_PROMPT_" ",D=PROMPT D IX^DIC Q:Y<0  S DA=+Y,NDF=Y(0) D
 .W @IOF,!,"NDC: ",$P(NDF,"^",2)," UPN: ",$P(NDF,"^",3),!,"VA Product Name: ",$P(^PSNDF(50.68,$P(NDF,"^",6),0),"^"),!,"Manfacturer: ",$P($G(^PS(55.95,+$P(NDF,"^",4),0)),"^"),"  Trade Name: ",$P(NDF,"^",5)
 .S K=0 F  S K=$O(^PSNDF(50.67,DA,1,K)) Q:'K  W $P(^PS(51.2,K,0),"^")," "
 .W !,"Inactivation Date: ",$$FMTE^XLFDT($P(NDF,"^",7)),!,"Package Size: ",$P(^PS(50.609,$P(NDF,"^",8),0),"^"),"  Package Type: ",$P(^PS(50.608,$P(NDF,"^",9),0),"^")
 .W !,"OTC/Rx Indicator: ",$S($P(NDF,"^",10)="O":"OTC",$P(NDF,"^",10)="R":"Rx",1:""),!
 .I $P(NDF,"^",7)="" S DIR(0)="Y",DIR("A")="Do you want to inactivate " D ^DIR Q:$D(DIRUT)  I Y S DIE=DIC,DR="7////"_DT_";" D ^DIE
 .I $P(NDF,"^",7) S DIR(0)="Y",DIR("A")="Do you want to Reactivate " W !,"That ",PROMPT," was inactivated on ",$$FMTE^XLFDT($P(NDF,"^",7)) D ^DIR Q:$D(DIRUT)  I Y S DIE=DIC,DR="7///@;" D ^DIE
 G NDC
END K D,DA,DIC,DIE,DIR,DIRUT,DR,IN,ING,J,K,L,NEW,NDF,OLD,OLDDA,PROMPT,X,Y,Y1,Y3,Y7,^TMP($J) Q
 Q
 ;
PRODI ;INQUIRE INTO 50.68
 F  S DIC="^PSNDF(50.68,",DIC(0)="AEQM" D ^DIC Q:Y<0  S DA=+Y D EN^DIQ
 K DA,DIC,X,Y Q
 ;
NDCI ;INQUIRE INTO 50.67
 S DIR(0)="SA^N:NDC;U:UPN;T:TRADE;P:PRODUCT",DIR("A")="NDC (N), UPN (U), Trade name (T), or Product (P) " D ^DIR G END:$D(DIRUT) S PROMPT=Y(0) G LISTNDC:PROMPT["PRO",LISTNDC1:PROMPT="NDC" I PROMPT["T" S PROMPT="T"
 F  S DIC="^PSNDF(50.67,",DIC(0)="AEQZS",DIC("A")="Select "_PROMPT S:PROMPT="T" DIC("A")=DIC("A")_"rade name" S DIC("A")=DIC("A")_" ",D=PROMPT D IX^DIC Q:Y<0  S DA=+Y D EN^DIQ
 K DA,DIC,DIR,PROMPT,X,Y Q
 ;
LINK ;LINK NDCS OR UPNS
 S DIR(0)="SA^N:NDC;U:UPN",DIR("A")="NDC (N) or UPN (U) ",DIR("B")="NDC" D ^DIR G END:$D(DIRUT) S PROMPT=Y(0)
 F  Q:$D(DIRUT)!(Y<0)  S DIC=50.67,DIC(0)="AEQZ",DIC("A")="Enter Current "_PROMPT_" ",D=PROMPT D IX^DIC Q:Y<0  S DA=+Y,OLD=$P(Y(0),"^",$S(PROMPT="NDC":2,1:3)) D
 .K DIR S DIR(0)="F^"_$S(PROMPT="NDC":"12:12",1:"1:40")_"^W:$D(^PSNDF(50.67,PROMPT,X)) !!,""That "_PROMPT_" already exists"",! K:$D(^PSNDF(50.67,PROMPT,X)) X",DIR("A")="Enter a new "_PROMPT_" " D ^DIR K DIR Q:$D(DIRUT)  S NEW=Y
 .I PROMPT="NDC" D
 ..S IN=$O(^PSNDF(50.67,DA,2,"B",NEW,0)) I IN S DIR(0)="Y" W !,"Those NDCs are already linked" S DIR("A")="Do you want to unlink them " D ^DIR Q:$D(DIRUT)  Q:'Y
 ..I IN S DA(1)=DA,DA=IN,DIE="^PSNDF(50.67,"_DA(1)_",2,",DR=".01///@;" D ^DIE W !,"Unlinked",! Q
 ..I 'IN S DIE="^PSNDF(50.67,",DR="1////"_NEW D ^DIE K DD,DO S DA(1)=DA,DIC="^PSNDF(50.67,"_DA(1)_",2,",DIC(0)="L",DIC("P")=$P(^DD(50.67,11,0),"^",2),X=OLD D ^DIC W !,"Linked",! Q
 .I PROMPT="UPN" D
 ..S IN=$O(^PSNDF(50.67,DA,3,"B",NEW,0)) I IN S DIR(0)="Y" W !,"Those UPNs are already linked" S DIR("A")="Do you want to unlink them " D ^DIR Q:$D(DIRUT)  Q:'Y
  ..S DA(1)=DA,DA=IN,DIE="^PSNDF(50.67,"_DA(1)_",3,",DR=".01///@;" D ^DIE W !,"Unlinked",! Q
 ..I 'IN S DIE="^PSNDF(50.67,",DR="1////"_NEW D ^DIE K DD,DO S DA(1)=DA,DIC="^PSNDF(50.67,"_DA(1)_",3,",DIC(0)="L",DIC("P")=$P(^DD(50.67,12,0),"^",2),X=OLD D ^DIC W !,"Linked",! Q
 G LINK
 ;
LISTNDC ;LOOK UP NDCS BY PRODUCT
 K L,DA,DIR,^TMP($J)
 S DIC=50.68,DIC(0)="AQEM" D ^DIC G END:Y<0 S K=0 F CNT=0:1 S K=$O(^PSNDF(50.68,"ANDC",+Y,K)) Q:'K  S ^TMP($J,"A"_$P(^PSNDF(50.67,K,0),"^",2)_"^"_K)=""
 I '$D(^TMP($J)) W !!,"No NDCs associated with ",$P(Y,"^",2),!! Q
 S A="",QUIT=0 F J=0:1 Q:QUIT  F K=1:1:5 Q:QUIT  S A=$O(^TMP($J,A)) S QUIT=A="" S:A]"" L(5*J+K)=$P(A,"^",2) W:A]"" !,$J(J*5+K,4),"   ",$P($P(A,"^"),"A",2,15) I K=5!(A="") D
 .S:A="" K=K-1 S DIR(0)="NOA^1:"_(J*5+K),DIR("A")="Choose 1 - "_(J*5+K)_" or ^ to quit" S:A'="" DIR("A")=DIR("A")_" or return to see more" S DIR("A")=DIR("A")_" " D ^DIR
 .I $D(DUOUT)!$D(DTOUT) S QUIT=1 Q
 .I Y="" Q
 .S DA=L(+Y),QUIT=1,DIC="^PSNDF(50.67," W !!! D EN^DIQ Q
 G END
 ;
LISTNDC1 ;LOOK UP PARTIAL NDC
 ;
 F  K ^TMP($J) S QUIT=0,DIR(0)="F^1:12",DIR("A")="Select NDC " D ^DIR Q:$D(DIRUT)  S PSN1=Y,PSN=Y D
 .I $D(^PSNDF(50.67,"NDC",PSN1)) S DA=0 F  S DA=$O(^PSNDF(50.67,"NDC",PSN1,DA)) S:'DA QUIT=1 Q:QUIT  S DIC="^PSNDF(50.67," W ! D EN^DIQ
 .Q:QUIT
 .I PSN1?."0".E S PSN1=PSN1_"/"
 .I PSN1?.N,PSN1=+PSN1 S PSN1=$$LJ^XLFSTR(PSN1,12,0)-1
 .S ZCT=0 F  Q:QUIT  S PSN1=$O(^PSNDF(50.67,"NDC",PSN1)),DA=0 Q:$E(PSN1,1,$L(PSN))'=PSN  F  Q:QUIT  S DA=$O(^PSNDF(50.67,"NDC",PSN1,DA)) Q:'DA  S ZCT=ZCT+1,^TMP($J,ZCT)=DA W !,$J(ZCT,5),"  ",PSN1 D
 ..S MORE=$E($O(^PSNDF(50.67,"NDC",PSN1)),1,$L(PSN))=PSN!$O(^(PSN1,DA)) I ZCT#5&MORE Q
 ..S DIR(0)="NOA^1:"_ZCT,DIR("A")="Choose 1 - "_ZCT_" or ^ to quit " S:MORE DIR("A")=DIR("A")_"or return to see more "
 ..D ^DIR I $D(DUOUT)!$D(DTOUT) S QUIT=1 Q
 ..I Y="" Q
 ..S DA=^TMP($J,Y),QUIT=1,DIC="^PSNDF(50.67," W !! D EN^DIQ Q
 G END
