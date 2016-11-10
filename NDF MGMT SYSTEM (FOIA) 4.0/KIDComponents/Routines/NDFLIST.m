NDFLIST ;BIR/DMA-list changes made in NDF ; 14 Apr 2005  10:07 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
 NEW CT,DA,FILE,NEW,OLD
 F FILE=50.416,50.6,50.605,50.68 S DA=$P(^NDFK(5000,1,1,FILE,0),"^",2),CT=0 D
 .W !!!,$P(^DIC(FILE,0),"^"),!,"OLD VALUE",?45,"NEW VALUE",!
 .F  S DA=$O(^DIA(FILE,DA)) Q:'DA  I $P(^(DA,0),"^",3)=.01 S NEW=$G(^(3)),OLD=$G(^(2)) I OLD'=NEW W !,OLD,?40," ",NEW S CT=CT+1
 .I 'CT W !,"No Changes"
 K CT,DA,FILE,NEW,OLD Q
