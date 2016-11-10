NDFPMIU1 ; Birmingham ISC/WRT - print PMIs greater than 200 ; 11 May 98 / 9:05 AM
 ;;0.0;;;
LENGTH ;FIND ANY LONGER THAN 200
 D EN^XUTMDEVQ("ENLENGTH^NDFPMIU1","LOOK FOR PMIS LONGER THAN 200") Q
 ;
ENLENGTH ;ENTRY FOR LENGTH
 S (DA,CT,MAX)=0,PG=1,TODAY=$$HTE^XLFDT(+$H) D HEADLENG F  S DA=$O(^PSPPI(DA)) Q:'DA  S X=$P(^(DA,0),"^") I $L(X)>200 S CT=CT+1 W !,DA,?5,X,!,?25,$L(X) I $L(X)>MAX S MAX=$L(X)
 I CT W !!!,?12,CT," ENTRIES FOUND    THE LONGEST IS ",MAX,!!,"Contact the Maintenance Team Leader before proceeding with the",!,"matching process."
 I 'CT W !!!,?12,"NO ENTIRES FOUND"
 D ^%ZISC S ZTREQ="@" Q
HEADLENG D UNDERDOG W:$Y @IOF W !!,"Medication Sheets with Names Longer than 200 characters",?IOM-20,"Page ",PG,!,?5,"Printed: ",TODAY,!!,"Internal File Number",?40,"Name",!,?32,"Length",!,NDFUL,!! S PG=PG+1 Q
 ;
 Q
UNDERDOG ; create underline
 S NDFUL="" F MOE=1:1:75 S NDFUL=NDFUL_"="
 K MOE
 Q
