NDFPPRT ;BIR/DMA NEW REPORT ; 25 Jul 2007  11:13 AM
 ;;4.0; NDF MANAGEMENT;; 16 April 03
 ;
 W !!,"This report has been replaced with VA Product Changes Report.",!! Q
 ;NDFACK = person entering change
 ;NDFAF1=audit file change product file IEN
 ;NDFAF2=audit file change product file subfile IEN
 ;NDFAF0=the data at the 0 node of the audit file
 ;NDFAF=IEN of audit file, NDFBL = line separater
 ;NDFCFDT=date field was changed, NDFCKD=check date for dates enteries
 ;NDFCL = flag for closing open device, NDFE=ending date for report
 ;NDFEP=printable end date, NDFF1=NDF audit file #s
 ;NDFF2=VA product file #, NDFFT=first time flag, NDF1=counter
 ;NDF2=todays date, NDFFNC=field number that was changed
 ;NDFFNS=subfile field # that was changed, NDFDNM=drug name
 ;NDFINM=drug ingredient name, NDFF3=hold for IEN from product file
 ;NDFLC=printed line count, NDFD1=drug name, NDFN=new value of field
 ;NDFF4=product file IEN from the NDF audit files
 ;NDFO=old value of field, NDFPG=page number count
 ;NDFOT=$O sequence variable for TMP file used in sorting
 ;NDFON=$O sequence variable for NDF audit files
 ;NDFS=starting date for the report, NDFSP=printable start date
 ;
 W @IOF
 N NDFAF1,NDFAF2,NDFAF0,NDFAF,NDFBL,NDFCFDT,NDFCKD,NDFCL,NDFE,NDFEP,NDFF1,NDFF2,NDFFT,NDF1,NDF2,NDFFNC,NDFFNS,NDFDNM,NDFINM,NDFF3,NDFD1,NDFN,NDFF4,NDFO,NDFPG,NDFOT,NDFON,NDFS,NDFSP
 S %H=$H D YX^%DTC S NDF2=Y,NDFBL="" F NDF1=1:1:75 S NDFBL=NDFBL_"-"
 ;
 W "START DATE (Corresponding to the start of entering data for the current patch)",!
 K DIR S DIR(0)="D",DIR("A")="ENTER START DATE" D ^DIR S NDFS=Y W !
 I $D(DTOUT)!($D(DUOUT)) Q
 W !,"END DATE of today (no date can be less than 180 days from today, as the report",!,"uses current patch data files).",!
 K DIR S DIR(0)="D",DIR("A")="ENTER END DATE" D ^DIR S NDFE=Y W !
 I $D(DTOUT)!($D(DUOUT)) Q
 S %H=$H-180 D YMD^%DTC S NDFCKD=X
 I NDFS<NDFCKD!(NDFE>DT) W !,"DATES OUT OF ACCEPTABLE RANGES" H 2 Q
 S Y=NDFS D DD^%DT S NDFSP=Y,Y=NDFE D DD^%DT S NDFEP=Y
 ;
 S NDFCL=0 D ^%ZIS S:POP>0 NDFCL=1 D:POP>0 ^%ZISC Q:NDFCL>0
 U IO S NDFF2=50.68 K ^TMP("NDFAU",$J) W @IOF
 S NDFPG=1,NDFLC=0,NDFF3=0,NDFMRN=0,NDFAF1=1,NDFFT=1 D HEAD
 F NDFF1=5000.2,5000.4,5000.5,5000.7,5000.507,5000.9 D EDIT
 D EDIT1 K ^TMP("NDFAU",$J)
 D ^%ZISC
 Q
 ;
EDIT S NDFON=0 F  S NDFON=$O(^NDFK(NDFF1,NDFON)) Q:'NDFON  S NDFF4=^(NDFON,0),NDFD1=$$GET1^DIQ(NDFF2,NDFF4,.01),^TMP("NDFAU",$J,NDFD1)=NDFF4
 Q
 ;
EDIT1 S NDFOT="" F  S NDFOT=$O(^TMP("NDFAU",$J,NDFOT)) Q:NDFOT=""  S NDFMRN=^(NDFOT),NDFFT=1 D AUDIT
 Q
 ;
AUDIT S NDFAF=0 F  S NDFAF=$O(^DIA(50.68,NDFAF)) Q:'NDFAF  S NDFAF0=$G(^DIA(50.68,NDFAF,0)),NDFAF1=$P(NDFAF0,U),NDFCFDT=$P($P(NDFAF0,U,2),".") I +NDFAF1=+NDFMRN I NDFCFDT'<NDFS&(NDFCFDT'>NDFE) D
 .S NDFO=$G(^DIA(50.68,NDFAF,2)),NDFN=$G(^DIA(50.68,NDFAF,3)),NDFACK=$P(NDFAF0,U,5)
 .S NDFAF2=$P(NDFAF1,",",2),NDFFNC=$P(NDFAF0,U,3),NDFFNS=$P(NDFFNC,",",2),Y=NDFCFDT D DD^%DT S NDFCFDT=Y
 .Q:NDFAF2!(NDFFNS&(NDFO'=""))  S:NDFACK="A" NDFF3=NDFMRN Q:NDFF3=NDFMRN  Q:NDFO=NDFN
 .I NDFFT=1 S NDFDNM=$$GET1^DIQ(50.68,NDFMRN,.01) W !,?3,NDFDNM,!! S NDFFT=0,NDFLC=NDFLC+3
 .I NDFAF2!(NDFFNS) D
 ..S NDFINM=$$GET1^DIQ(50.416,NDFAF2,.01) D FIELD^DID(50.68_$P(NDFFNC,","),NDFFNS,,"LABEL","LBLS") S NDFFNS=LBLS("LABEL"),LBLS("LABEL")=""
 ..W "INGREDIENT: ",NDFINM,?35,NDFFNS,!,?45,NDFCFDT,! S NDFLC=NDFLC+2
 .I 'NDFAF2&('NDFFNS) D FIELD^DID(50.68,NDFFNC,,"LABEL","LBL") S NDFFNC=LBL("LABEL"),LBL("LABEL")="" W NDFFNC,?45,NDFCFDT,! S NDFLC=NDFLC+1 D:NDFLC>60 HEAD
 .W ?5,"OLD VALUE: ",NDFO,!,?5,"NEW VALUE: ",NDFN,!! S NDFLC=NDFLC+3
 .S (NDFAF1,NDFAF2,NDFFNC,NDFFNS)=0,(NDFO,NDFN,NDFINM,NDFCFDT)=""
 Q
 ;
HEAD W #,!!,?5,$P(NDF2,"@"),?27,"VA PATCH EDIT REPORT",?55,$P(NDF2,"@",2),?65,"PAGE: ",NDFPG,!
 W "START DATE: ",NDFSP,?50,"END DATE: ",NDFEP,!,NDFBL,! S NDFPG=NDFPG+1,NDFLC=5
 I NDFFT=0 I +NDFMRN=+NDFAF1 W !,?3,NDFDNM,!! S NDFLC=NDFLC+3
 Q
