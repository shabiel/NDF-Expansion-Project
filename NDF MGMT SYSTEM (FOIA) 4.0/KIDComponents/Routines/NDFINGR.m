NDFINGR ;BIR/DMA-LIST INGREDIENTS ;7 May 03
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
 W ! K %ZIS,IOP,POP,ZTSK S %ZIS="QM" D ^%ZIS I POP G EXIT
 ;
 R !,"Turn on capture and press return",X:DTIME G EXIT:'$T G EXIT:X["^"
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)) Q:'DA  I $O(^(DA,2,0)) D
 .S ZERO=^PSNDF(50.68,DA,0),VAP=$P(ZERO,"^"),DOS=$P(ZERO,"^",3),DOS=$P($G(^PS(50.606,DOS,0)),"^")
 .S K=0 F  S K=$O(^PSNDF(50.68,DA,2,K)) Q:'K  S X=^(K,0),LINE=$P($G(^PS(50.416,+X,0)),"^")_"^"_$P(X,"^",2)_"^"_$P($G(^PS(50.607,+$P(X,"^",3),0)),"^") W !,VAP_"^"_LINE_"^"_DOS
 R !!,"Turn off capture and press return",X,!!
EXIT ;
 K DA,DOS,K,LINE,VAP,X,ZERO
 I IO'=IO(0) D ^%ZISC
 Q
