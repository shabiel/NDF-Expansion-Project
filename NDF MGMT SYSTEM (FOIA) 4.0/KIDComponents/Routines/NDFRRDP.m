NDFRRDP ;BIR/WRT-Output Transform Routine Used By NDF Manager To Do Mapping Of PMIs ; 16 Feb 2010  10:18 AM
 ;;4.0; NDF MANAGEMENT;**62**; 30 Oct 98
 ; K GCN,WRT,SEQNO,FDBGCN
 S GCN=$P($G(^PSNDF(50.68,+Y,1)),"^",5) I GCN,$D(^PS(50.628)) S OLDGCN=GCN D DISPLAY
 S:'$D(FDBGCN) FDBGCN=""
 Q
DISPLAY S WRT=$O(^PS(50.628,"C",GCN,0)) I WRT]"" S SEQNO=$P(^PS(50.628,WRT,0),"^",2)_" "_$P(^PS(50.628,WRT,0),"^",3)_" "_$P(^PS(50.628,WRT,0),"^",4)_" "_$P(^PS(50.628,WRT,0),"^",5),FDBGCN=GCN_"^"_WRT_"^"_SEQNO_"^"_$P(^PS(50.628,WRT,0),"^")_"^"_OLDGCN
 Q
