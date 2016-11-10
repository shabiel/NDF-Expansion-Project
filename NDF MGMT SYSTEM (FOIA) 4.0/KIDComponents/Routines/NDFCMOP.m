NDFCMOP ;BIR/DMA-print products marked for CMOP ;31 Aug 98 / 1:05 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 S DIR(0)="SA^I:IDENTIFIER;N:NAME",DIR("A")="Sort by VA Identifier (I) or VA Product Nnme (N)? " D ^DIR G END:$D(DIRUT) S S=Y
 S ZTSAVE("S")="" D EN^XUTMDEVQ("GO^NDFCMOP","PRINT DRUGS MARKED FOR CMOP",.ZTSAVE) I POP W !,"No device selected",!
END K DIR,S,X,Y,ZTSAVE Q
 ;
GO ;ENTRY POINT
 K ^TMP($J) D @S
 S:$D(ZTQUEUED) ZTREQ="@" K DA,DIR,ID,LINE,NA,PG,PR,S,TD,UN,X0,X1,Y,^TMP($J) D ^%ZISC Q
 ;
I ;SORT BY ID
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S X0=^(DA,0),X1=^(1) I $P(X1,"^",3) S ID=$P(X1,"^",2),NA=$P(X0,"^",1),UN=$P(X1,"^",4),UN=$P($G(^PSNDF(50.64,+UN,0)),"^"),^TMP($J,ID,NA,UN)=""
 S PG=1,TD=$TR($$HTE^XLFDT($H),"@"," "),$P(LINE,"-",IOM-1)="" D HEADID
 S ID="" F  S ID=$O(^TMP($J,ID)),NA="" Q:ID=""  F  S NA=$O(^TMP($J,ID,NA)),UN="" Q:NA=""  F  S UN=$O(^TMP($J,ID,NA,UN)) Q:UN=""  W !,ID,?12,NA,?60,UN I $Y+4>IOSL D HEADID
 Q
 ;
HEADID W:$Y @IOF W !,?12,"VA PRODUCT LIST",?IOM-30," ",TD," PAGE ",PG,!,"ID#",?12,"VA PRINT NAME",?55,"VA DISP UNIT",!,LINE,! S PG=PG+1 Q
 ;
 ;
N ;SORT BY NAME
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S X0=^(DA,0),X1=^(1) I $P(X0,"^",3)]"" S NA=$P(X1,"^"),PR=$P(X1,"^"),UN=$P(X1,"^",4),UN=$P($G(^PSNDF(50.64,+UN,0)),"^"),ID=$P(X1,"^",2),^TMP($J,NA,PR,UN,ID)=""
 S PG=1,TD=$TR($$HTE^XLFDT($H),"@"," "),$P(LINE,"-",IOM-1)="" D HEADNA
 S NA="" F  S NA=$O(^TMP($J,NA)),PR="" Q:NA=""  F  S PR=$O(^TMP($J,NA,PR)),UN="" Q:PR=""  F  S UN=$O(^TMP($J,NA,PR,UN)),ID="" Q:UN=""  F  S ID=$O(^TMP($J,NA,PR,UN,ID)) Q:ID=""  D
 .W !,NA,!,?7,PR,?60,UN,?70,ID I $Y+4>IOSL D HEADNA
 Q
 ;
HEADNA W:$Y @IOF W !,?12,"VA PRODUCT LIST",?IOM-30," ",TD," PAGE ",PG,!,"VA PRODCUT NAME",!,?5,"VA PRINT NAME",?55,"VA DISP UNIT",?70,"ID#",!,LINE,! S PG=PG+1 Q
