NDFRRDP1 ;BIR/WRT-Output Transform Routine Used By NDF Manager To Do Mapping Of PMIs ; 06/03/03 15:10;
 ;;4.0; NDF MANAGEMENT;**62**; 30 Oct 98
 ; K GCN1,BRT,PSEQNO,PREV
 S GCN1=$P($G(^PSNDF(50.68,+Y,1)),"^",6) I GCN1,$D(^PS(50.628)) D DISPLAY
 S:'$D(PSEQNO) PSEQNO=""
 Q
DISPLAY S BRT=$O(^PS(50.628,"C",GCN1,0)) Q:'BRT  S PREV=$P(^PS(50.628,BRT,0),"^",2)_" "_$P(^PS(50.628,BRT,0),"^",3)_" "_$P(^PS(50.628,BRT,0),"^",4)_" "_$P(^PS(50.628,BRT,0),"^",5),PSEQNO=GCN1_"^"_BRT_"^"_PREV_"^"_$P(^PS(50.628,BRT,0),"^")
 Q
