NDFCLAPR ;BIR/DMA-print VA Classification scheme ;01 Sep 98 / 1:35 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 D EN^XUTMDEVQ("GO^NDFCLAPR","PRINT VA DRUG CLASSIFICATION SCHEME")
 I POP W !,"No device selected"
 Q
 ;
GO ;ENTRY POINT
 K ^TMP($J) S TD=$TR($$HTE^XLFDT($H),"@"," "),PG=1,$P(LINE,"-",IOM-1)=""
 S DA=0 F  S DA=$O(^PS(50.605,DA)) Q:'DA  S X=^(DA,0) I $P(X,"^")'="AA000" S ^TMP($J,$P(X,"^",1,2)_"^"_DA)=""
 D HEAD S CO="" F  S CO=$O(^TMP($J,CO)) Q:CO=""  S CL=$P(CO,"^",1),DE=$P(CO,"^",2),NDF1=$P(CO,"^",3) D:$Y+4+$O(^PS(50.605,NDF1,1," "),-1)>IOSL HEAD W !,?$S(CL["000":0,CL["00":5,1:15),CL_"   "_DE I $O(^PS(50.605,NDF1,1,0)) D
 .F NDF=0:0 S NDF=$O(^PS(50.605,NDF1,1,NDF)) Q:'NDF  W !,^(NDF,0)
 .W !
 K NDF1,NDF,X,TD,PG,LINE,C0,CL,DE,^TMP($J),^UTILITY($J,"W") S:$D(ZTQUEUED) ZTREQ="" D ^%ZISC Q
 ;
HEAD W:$Y @IOF W !,"VA DRUG CLASSIFICATION",?IOM-30," ",TD," PAGE ",PG,!,LINE,! S PG=PG+1 Q
