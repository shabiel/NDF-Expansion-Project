NDFCLPR ;BIR/DMA-print products sorted by class ;31 Aug 98 / 1:57 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 S DIR(0)="SA^P:PRIMARY;S:SECONDARY;B:BOTH",DIR("A")="Sort by Primary (P), Secondary (S), or Both (B) Classes? " D ^DIR G END:$D(DIRUT) S S=Y
 S ZTSAVE("S")="" D EN^XUTMDEVQ("GO^NDFCLPR","PRINT DRUGS SORTED BY CLASS",.ZTSAVE) I POP W !,"No device selected",!
END K DIR,S,X,Y,ZTSAVE Q
 ;
GO ;ENTRY POINT
 K ^TMP($J)
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  S NA=$P(^(DA,0),"^") D
 .I S'="S" S CL=$P($G(^PSNDF(50.68,DA,3)),"^"),CL=$P(^PS(50.605,+CL,0),"^"),^TMP($J,CL,NA)=""
 .I S'="P" S K=0 F  S K=$O(^PSNDF(DA,4,K,0)) Q:'K  S CL=$P($G(^PS(50.605,K,0)),"^")_$S(S="B":"*",1:""),^TMP($J,CL,NA)=""
 ;
 S PG=1,TD=$TR($$HTE^XLFDT($H),"@"," "),$P(LINE,"-",IOM-1)=""
 D HEAD S CL="" F  S CL=$O(^TMP($J,CL)),NA="" Q:CL=""  F  S NA=$O(^TMP($J,CL,NA)) Q:NA=""  W !,CL,?S="B"*8+10,NA I $Y+4>IOSL D HEAD
 K CL,DA,K,LINE,NA,S,TD S:$D(ZTQUEUED) ZTREQ="@" D ^%ZISC Q
 ;
HEAD W:$Y @IOF W !,"VA PRODUCT LIST",?IOM-30," ",TD," PAGE ",PG,!! W:S="P" "PRIMARY",! W:S="S" "SECONDARY",! W:S="B" "PRIMARY OR",!,"SECONDARY",!,"VA CLASS CODE" W:S'="B" "VA CLASS",!,"CODE" W ?S="B"*10+12,"VA PRODUCT NAME",!,LINE,! S PG=PG+1 Q
