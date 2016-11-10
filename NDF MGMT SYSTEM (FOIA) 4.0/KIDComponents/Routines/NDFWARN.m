NDFWARN ;BIR/DMA-PRINT WARNING LABELS; 16 Jan 2008  12:44 PM ; 16 Jan 2008  12:45 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
 W ! K %ZIS,IOP,POP,ZTSK S %ZIS="QM" D ^%ZIS I POP G EXIT
 ;
 R !,"Turn on capture and press return",X:DTIME G EXIT:'$T G EXIT:X["^"
 S NA="",CT=0 F  S NA=$O(^PSNDF(50.68,"B",NA)) Q:NA=""  S DA=$O(^(NA,0)),GNSEC=$P($G(^PSNDF(50.68,DA,1)),"^",5) I GNSEC]"" D
 .I $O(^PS(50.627,"B",GNSEC,""))]"" W !,NA,"^" S DA1="" F  S DA1=$O(^PS(50.627,"B",GNSEC,DA1)) Q:'DA1  S DA2=$P(^PS(50.627,DA1,0),"^",2)  I DA2]"" S WARN=$O(^PS(50.625,"B",DA2,0)) D
 ..;S K=0 F  S K=$O(^PS(50.625,WARN,1,K)) Q:'K  W ?5,^(K,0),!
 ..W DA2,"^"
 R !!,"Turn off capture and press return",X,!!
EXIT ;
 I IO'=IO(0) D ^%ZISC
 Q
