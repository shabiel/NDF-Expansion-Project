NDFPATCH ;BIR/DMA NEW REPORT ; 27 Jul 2007  9:38 AM
 ;;4.0; NDF MANAGEMENT;; 16 April 03
 ;
 ;
 W @IOF
 ;N DATA,DIR,LIST,NA,NDF1,NDFDATA,NDFAF,NDFBL,NDFCL,NDFE,NDFF,NDFS,NDFSORT,NEW,OLD,Y
 S DIR(0)="S^P:PRODUCT;F:FIELD",DIR("A")="Sort by: " D ^DIR I $D(DIRUT) K DIR Q
 S NDFSORT=Y
 S NDFBL="" F NDF1=1:1:75 S NDFBL=NDFBL_"-"
 ;
 W !,"START DATE (Corresponding to the start of entering data for the current patch)",!
 K DIR S DIR(0)="D",DIR("A")="ENTER START DATE" D ^DIR S NDFS=Y W !
 I $D(DTOUT)!($D(DUOUT)) Q
 K DIR S DIR(0)="D",DIR("A")="ENTER END DATE" D ^DIR S NDFE=Y+.3 W !
 I $D(DTOUT)!($D(DUOUT)) Q
 I NDFS<$$FMADD^XLFDT(DT,-180)!(NDFE>(DT+1)) W !,"DATES OUT OF ACCEPTABLE RANGES" H 2 Q
 ;
 S NDFCL=0 D ^%ZIS S:POP>0 NDFCL=1 D:POP>0 ^%ZISC Q:NDFCL>0
 U IO K ^TMP("NDFAU",$J),^TMP($J) W @IOF
 S LIST="^.01^.05^5^3^1^21^2^15^6^19^8^" ;list of fields
 S NDFAF=$QS($Q(^DIA(50.68,"C",NDFS-.1)),4)-1
 F  S NDFAF=$O(^DIA(50.68,NDFAF)) Q:'NDFAF  S NDFDATA=^(NDFAF,0) Q:$P(NDFDATA,"^",2)>NDFE  D
 .I $P(NDFDATA,"^",3)=.01,$P(NDFDATA,"^",5)="A" S ^TMP($J,+NDFDATA)=""
 .S NDFF=$P(NDFDATA,"^",3) I LIST[("^"_NDFF_"^"),'$D(^TMP($J,+NDFDATA)) S OLD=$G(^DIA(50.68,NDFAF,2)),NEW=$G(^(3)) I OLD'=NEW D
 ..I NDFSORT="F" S ^TMP("NDFAU",$J,$P(^DD(50.68,$P(NDFDATA,"^",3),0),"^"),$P(^PSNDF(50.68,+NDFDATA,0),"^")_"^"_$$FMTE^XLFDT($P($P(NDFDATA,"^",2),"."))_"^"_OLD_"^"_NEW)=""
 ..I NDFSORT="P" S ^TMP("NDFAU",$J,$P(^PSNDF(50.68,+NDFDATA,0),"^"),$P(^DD(50.68,$P(NDFDATA,"^",3),0),"^")_"^"_$$FMTE^XLFDT($P($P(NDFDATA,"^",2),"."))_"^"_OLD_"^"_NEW)=""
PRINT ;
 W !,"The following list contains VA Product changes made between ",!,"       ",$$FMTE^XLFDT(NDFS)," and ",$$FMTE^XLFDT(NDFE),!,NDFBL,!!
 S NA="" F  S NA=$O(^TMP("NDFAU",$J,NA)),DATA="" Q:NA=""  W !,NA,! F  S DATA=$O(^TMP("NDFAU",$J,NA,DATA)) Q:DATA=""  D
 .W !,?5,$P(DATA,"^"),?60,$P(DATA,"^",2),!,?5,"Old Value: ",$P(DATA,"^",3),!,?5,"New Value: ",$P(DATA,"^",4),!
 ;
 ;K DATA,DIR,DTOUT,DUOUT,LIST,NA,NDFDATA,NDFAF,NDFBL,NDFCL,NDFE,NDFF,NDFS,NDFSORT,NEW,OLD,X,Y,^TMP($J),^TMP("NDFAU",$J) D ^%ZISC Q
