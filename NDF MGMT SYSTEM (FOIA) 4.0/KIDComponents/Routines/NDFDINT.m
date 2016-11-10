NDFDINT ;BIR/DMA-ENTER/EDIT INTERACTIONS ; 18 Aug 2006  2:38 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
GO W !!
 S PSNDF=1 K PSN,PSN1,PSN2,PSNN,PSNNN
 S DIC=50.416,DIC(0)="AEMQZ",DIC("A")="Choose first ingredient ",DIC("S")="I '$P(^(0),""^"",2)" D ^DIC G OUT:Y<0 S PSN1=+Y,PSNN($P(Y(0),"^"))=""
 S DIC("A")="Choose second ingredient ",DIC("S")=DIC("S")_",+Y'=PSN1" D ^DIC G OUT:Y<0 S PSN2=+Y,PSNN($P(Y(0),"^"))=""
 S DA=$O(^PS(56,"AE",PSN1,PSN2,0)),PSND=DA I DA S PSN=^PS(56,DA,0) W !,"Severity: ",$S($P(PSN,"^",4)=2:"Significant",1:"Critical") D  G GO
 .S DIR(0)="Y",DIR("A")="That interaction already exists.  Do you wish to edit it" D ^DIR Q:'Y  K DIR S DIR(0)="56,3" D ^DIR Q:'Y  S DIE="^PS(56,",DR="3////"_Y_";",PSND1=Y'=$P(PSN,"^",4) D ^DIE
 .I PSND1 S ^NDFK(5000.56,PSND,0)=PSND_"^E"
 .Q
 S PSNNN=$O(PSNN(""))_"/"_$O(PSNN($O(PSNN(""))))
 K DA,DIR S DIR(0)="56,3" D ^DIR G OUT:$D(DTOUT)!$D(DUOUT) S PSN=Y
 W !,PSNNN,"   Severity : ",Y(0)
 S DIR(0)="Y",DIR("A")="OK to add " D ^DIR G OUT:$D(DTOUT)!$D(DUOUT) I 'Y K PSNN,PSNNN G GO
 F  L +^PS(56):3 Q:$T
 S DINUM=$O(^PS(56,15000),-1)+1,PSND=DINUM
 S DIC("DR")="1////"_PSN1_";2////"_PSN2_";3////"_PSN_";4////1",DIC="^PS(56,",DIC(0)="L",X=PSNNN K DD,DO D FILE^DICN L -^PS(56)
 S ^NDFK(5000.56,PSND,0)=PSND_"^A"
 K NDF,PSN1,PSN2,PSNN,PSNNN G GO
 ;
OUT K PSN,PSN1,PSN2,PSND,PSND1,PSNDF,PSNL,PSNN,PSNNN,DA,DIC,DIR,DINUM,DTOUT,DUOUT,DIRUT,DR,X,Y Q
 ;
INACT ;Inactivate an existing interaction
 F  S DIC=56,DIC(0)="AEQM" D ^DIC Q:Y<0  S DIE=DIC,DA=+Y,INA=$P(^(0),"^",7),DR="7;" D ^DIE D
 .I 'INA,$P(^PS(56,DA,0),"^",7) S ^NDFK(5000.56,DA,0)=DA_"^I"
 .I INA,'$P(^PS(56,DA,0),"^",7),$P($G(^NDFK(5000.56,DA,0)),"^",2)="I" K ^NDFK(5000.56,DA)
 K DIC,DIE,DA,INA,X,Y,DR Q
 ;
LIST ;LIST ADDED INTERACTIONS FROM 5000.56
 D EN^XUTMDEVQ("LIST1^NDFDINT","LIST NEW INTERACTIONS") Q
 ;
LIST1 ;ENTRY POINT
 K ^TMP($J) S DA=0 F  S DA=$O(^NDFK(5000.56,DA)) Q:'DA  S X=^(DA,0),^TMP($J,$P(X,"^",2),^PS(56,+X,0))=""
 F J="A","E","I" S DA="" D HEAD W:'$D(^TMP($J,J)) "  NONE",! F  S DA=$O(^TMP($J,J,DA)) Q:DA=""  S X=$P(DA,"^",4) W $P(DA,"^"),?60,$S(X=1:"Critical",1:"Significant"),! I $Y+4>IOSL D HEAD
 S:$D(ZTQUEUED) ZTREQ="@" D ^%ZISC K J,X,^TMP($J) Q
 ;
HEAD ;
 W:$Y&(DA]"") @IOF W !!,$S(J="A":"Added",J="E":"Edited",1:"Inactivated")," Interactions",!!
 Q
