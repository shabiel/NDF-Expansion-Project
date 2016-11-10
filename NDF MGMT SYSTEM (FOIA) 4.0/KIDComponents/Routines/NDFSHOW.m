NDFSHOW ;BIR/DMA-show product information ;19 Aug 98 / 10:56 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
SHOWALL W "NDC: ",NDC,!,"Trade name: ",TR,!,"Manufacturer: ",$P(^PS(55.95,MFR,0),"^"),?50,"Dose form: ",$P(^PS(50.606,DOS,0),"^"),!,"Strength: ",ST
 W ?50,"Units: ",$P(^PS(50.607,UN,0),"^")
 F J=0:0 S J=$O(PC(J)) Q:'J  W !,"Package code: ",PC(J),?50,"Package type: ",$P(^PS(50.608,+PT(J),0),"^"),!,?3,"Package size: ",$P(^PS(50.609,+PS(J),0),"^")
 I $D(ING) W !,"Ingredients: " F J=0:0 S J=$O(ING(J)) Q:'J  W ?13,$P(^PS(50.416,+ING(J),0),"^"),?50,"Amount: ",$P(ING(J),"^",2),!,?3,"Unit: ",$P($G(^PS(50.607,+$P(ING(J),"^",3),0)),"^"),!
 I '$D(ING) W !,"Ingredients: " F JK1=0:0 S JK1=$O(^PSNDF(50.68,A3DA,2,JK1)) Q:'JK1  S JK2=^(JK1,0) W ?13,$P(^PS(50.416,JK1,0),"^"),?50,"Amount: ",$P(JK2,"^",2),!,?3,"Unit: ",$P($G(^PS(50.607,+$P(JK2,"^",3),0)),"^"),!
 W !,"VA Class: ",$P(^PS(50.605,CL,0),"^"),!,"Product name: ",PN,!,"VA generic name: ",$P(^PSNDF(50.6,$P(A,"^",2),0),"^")
 I $G(B)]"" W !,"National identifier: ",$P(B,"^",2),!,"VA print name: ",$P(B,"^"),!,"VA dispense units: ",$P(B,"^",4),?50,"CMOP?: ",$S($P(B,"^",3):"YES",1:"NO")
 Q
 ;
 ;
