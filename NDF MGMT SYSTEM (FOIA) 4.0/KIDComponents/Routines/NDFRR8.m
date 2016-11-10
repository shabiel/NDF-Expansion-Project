NDFRR8 ;BIR/RSB-BUILD LISTMAN SCREEN ; 10 Mar 98 / 2:36 PM [ 11/09/98  10:16 AM ]
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
BUILD ;
 ; find current 12 digit NDC's that contain the 10 digit NDC
 N NDFL,NDFX,NDF1,NDCNT S NDCNT=0
 I $D(NDFNDC)&($D(^PSNDF(50.67,"NDC",NDFNDC_"00"))) S NDFX=$O(^PSNDF(50.67,"NDC",NDFNDC_"00",0)) S NDCNT=NDCNT+1,NDF1=NDFX D BUILD1
 I $D(NDFNDC) S NDFL=NDFNDC,NDFX=NDFL_"00" F  S NDFX=$O(^PSNDF(50.67,"NDC",NDFX)) Q:NDFX=""!($E(NDFX,1,10)'=NDFL)  D
 .F NDF1=0:0 S NDF1=$O(^PSNDF(50.67,"NDC",NDFX,NDF1)) Q:'NDF1  D
 ..S NDCNT=NDCNT+1 D BUILD1
 I '$D(NDFNDC)&($D(NDFUPNI)) S NDF1=$G(NDFUPNI) S NDCNT=1 D BUILD1
 D LIST
 Q
BUILD1 ; build array for entries already there
 N A,B,C S A="NDFD",B=$G(^PSNDF(50.67,NDF1,0)),C=NDFPCNT+NDCNT
 S ^TMP(A,$J,C,"50.67,.01")=$P(B,"^")
 S ^TMP(A,$J,C,"50.67,SEQ")=$P(B,"^")
 S:'$D(^TMP(A,$J,C,"50.67,1")) ^TMP(A,$J,C,"50.67,1")=$P(B,"^",2)
 S:'$D(^TMP(A,$J,C,"50.67,2")) ^TMP(A,$J,C,"50.67,2")=$P(B,"^",3)
 S:'$D(^TMP(A,$J,"50.67,3")) ^TMP(A,$J,"50.67,3")=$P(B,"^",4)
 S:'$D(^TMP(A,$J,C,"50.67,3")) ^TMP(A,$J,C,"50.67,3")=$P(B,"^",4)
 S:'$D(^TMP(A,$J,"50.67,4")) ^TMP(A,$J,"50.67,4")=$P(B,"^",5)
 S:'$D(^TMP(A,$J,C,"50.67,4")) ^TMP(A,$J,C,"50.67,4")=$P(B,"^",5)
 S:'$D(^TMP(A,$J,"50.67,5")) ^TMP(A,$J,"50.67,5")=$P(B,"^",6)
 S:'$D(^TMP(A,$J,C,"50.67,5")) ^TMP(A,$J,C,"50.67,5")=$P(B,"^",6)
 S:'$D(^TMP(A,$J,C,"50.67,8")) ^TMP(A,$J,C,"50.67,8")=$P(B,"^",8)
 S:'$D(^TMP(A,$J,C,"50.67,9")) ^TMP(A,$J,C,"50.67,9")=$P(B,"^",9)
 S:'$D(^TMP(A,$J,"50.67,10")) ^TMP(A,$J,"50.67,10")=$P(B,"^",10)
 S:'$D(^TMP(A,$J,C,"50.67,10")) ^TMP(A,$J,C,"50.67,10")=$P(B,"^",10)
 N SEC F SEC=0:0 S SEC=$O(^PSNDF(50.67,NDF1,1,SEC)) Q:'SEC  D
 .Q:$D(NDFADMIN)
 .S ^TMP("NDFD",$J,"50.676,.01",SEC)=$G(^PSNDF(50.67,NDF1,1,SEC,0))
 Q
 ;
LIST ; build listman screen
 K ^TMP("NDFDRSB",$J),NDFPOSS
 N A,L,CNT,NDFL S A="NDFDRSB",CNT=1
 ;S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("10 digit NDC: "_NDFNDC,"",1,70),CNT=CNT+1
 S NDFNUM=0,L="" F  S L=$O(^TMP("NDFD",$J,L)) Q:'L!(L="")  D
 .Q:L'?1.99N  S NDFNUM=NDFNUM+1  ; count entries
 .S NDFPOSS=$S('$D(NDFPOSS):"",1:NDFPOSS)_NDFNUM_"|"
 .S NDFL=$$SETSTR^VALM1("("_NDFNUM_") Package Code: "_$S($D(^TMP("NDFD",$J,L,"NDF2DIG")):$G(^TMP("NDFD",$J,L,"NDF2DIG")),1:$E($G(^TMP("NDFD",$J,L,"50.67,1")),$S($D(NDFUPN)!($D(NDFUPNI)):1,1:11),12)),"",1,35)
 .S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("UPN: "_$G(^TMP("NDFD",$J,L,"50.67,2")),NDFL,36,44),CNT=CNT+1
 .S NDFC=$G(^TMP("NDFD",$J,L,"50.67,8")),NDFCC=NDFC'["|NEW"
 .S NDFL=$$SETSTR^VALM1("Package Size: "_$S(NDFCC:$P(^PS(50.609,$G(^TMP("NDFD",$J,L,"50.67,8")),0),"^"),1:$P($G(^TMP("NDFD",$J,L,"50.67,8")),"|")),"",5,35)
 .S NDFC=$G(^TMP("NDFD",$J,L,"50.67,9")),NDFCC=NDFC?1.9N
 .S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("Package Type: "_$S(NDFCC:$P(^PS(50.608,$G(^TMP("NDFD",$J,L,"50.67,9")),0),"^"),1:$G(^TMP("NDFD",$J,L,"50.67,9"))),NDFL,36,44),CNT=CNT+1 ;,^TMP(A,$J,CNT,0)=" ",CNT=CNT+1
 .S:'$D(^TMP("NDFD",$J,L,"50.67,5")) ^TMP("NDFD",$J,L,"50.67,5")=$G(^TMP("NDFD",$J,"50.67,5"))
 .S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("VA Product Name: "_$P(^PSNDF(50.68,$G(^TMP("NDFD",$J,L,"50.67,5")),0),"^"),"",5,79),CNT=CNT+1
 .S ^TMP(A,$J,CNT,0)=" ",CNT=CNT+1
 S NDFC=$G(^TMP("NDFD",$J,"50.67,3")),NDFCC=NDFC?1.9N
 S NDFL=$$SETSTR^VALM1("("_(NDFNUM+1)_") Manufacturer: "_$S(NDFCC:$P(^PS(55.95,$G(^TMP("NDFD",$J,"50.67,3")),0),"^"),1:$P($G(^TMP("NDFD",$J,"50.67,3")),"^")),"",1,40)
 S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("("_(NDFNUM+2)_") Trade Name: "_$G(^TMP("NDFD",$J,"50.67,4")),NDFL,41,39),CNT=CNT+1
 S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("("_(NDFNUM+3)_") OTC/Rx Indicator: "_$$EXTERNAL^DILFD(50.67,10,"",$G(^TMP("NDFD",$J,"50.67,10"))),"",1,40),CNT=CNT+1
 S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("("_(NDFNUM+4)_") Route of Administration:","",1,40),CNT=CNT+1
 N SEC F SEC=0:0 S SEC=$O(^TMP("NDFD",$J,"50.676,.01",SEC)) Q:'SEC  D
 .;S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1($P($G(^PS(51.2,^TMP("NDFD",$J,"50.676,.01",SEC),0)),"^"),"",6,40),CNT=CNT+1
 .S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1(^TMP("NDFD",$J,"50.676,.01",SEC),"",6,40),CNT=CNT+1
 ;S ^TMP(A,$J,CNT,0)=$$SETSTR^VALM1("("_(NDFNUM+5)_") VA Product Name: "_$P(^PSNDF(50.68,$G(^TMP("NDFD",$J,"50.67,5")),0),"^"),"",1,70)
 I $G(^TMP("NDFD",$J,"50.67,5")) S NDFVAPD=$P(^PSNDF(50.68,$G(^TMP("NDFD",$J,"50.67,5")),0),"^")
 ;
 S VALMCNT=CNT
 Q
ACCEPT ;
 Q
 ;
EDIT ;
 S VALMBCK="R"
EFA ;
 K Y,NDFANS S Y="" R !!,"Select FIELDS TO EDIT: ",X:DTIME E  W $C(7) S X="^" Q
 I "^"[X Q
 I X="??" D FULL^VALM1,H2 G EFA
 I X?1."?" D FULL^VALM1,H2 G EFA
 I  G FDONE
 I X'=+X!(X>(NDFNUM+4))!(X<1) W "   ??" H .4 G EFA
 S:$E(X)="-" X=+PSGEFN_X S:$E($L(X))="-" X=X_$P(PSGEFN,":",2)
 F Q=1:1:$L(X,",") S X1=$P(X,",",Q) D FS Q:'$D(X)
 I '$D(X) W $C(7),"  ??" G EFA
 ;
FDONE ;
 I '$D(Y) W $C(7)," ??" G EFA
 S:Y Y=$E(Y,1,$L(Y)-1)
 D EDIT1
 K NDFPOSS D HDR^NDFRR8
 Q
FS ;
 I $S(X1?1.N1"-"1.N:0,X1'?1.N:1,1:","_Y[X1) K X Q
 I X1'["-" S Y=Y_X1_"," Q
 S X2=+X1,Y=Y_X2_"," F  S X2=$O(PSGEFN(X2)) K:$S(X="":1,","_Y[X2:1,1:X2>$P(X1,"-",2)) Y Q:'$D(Y)  S Y=Y_X2_"," Q:X2=$P(X1,"-",2)
 Q
 ;
H2 ;
 W !,"Enter the field to edit (1-"_(NDFNUM+4)_")" Q
 N X S X="field" W !!?2,"Select ",X,"s either singularly separated by commas"
 Q
EDIT1 ;
 D FULL^VALM1
 W ! N X F Q=1:1 S Q1=$P(Y,",",Q) Q:'Q1  D
 .I Q1'>NDFNUM&(NDFPOSS'[Q1) W "   ",Q1," is not a choice!" H .5 Q
 .S NDFANS=Q1
 .I Q1'>NDFNUM S Q1=1
 .E  S Q1=Q1-(NDFNUM-1)
 .S X=$P($T(@(Q1)),";;",2) D @X
 Q
 ;
HDR ;
 I $D(^TMP("NDFD",$J,"NDFDIG")) S VALMHDR(1)=$$SETSTR^VALM1(" NDC: "_$G(^TMP("NDFD",$J,"NDFDIG")),"",3,77) Q
 I $D(NDFNDC) S VALMHDR(1)=$$SETSTR^VALM1(" NDC: "_$G(NDFNDC),"",3,77) Q
 I $D(NDFUPN) S VALMHDR(1)=$$SETSTR^VALM1(" UPN: "_NDFUPN,"",3,77) Q
 I $D(NDFUPNI) S VALMHDR(1)=$$SETSTR^VALM1(" UPN: "_$G(^TMP("NDFD",$J,1,"50.67,2")),"",3,77)
 Q
 ;
BUILD2() ;
 ; find 12 digit NDC's that contain the 10 digit NDC
 N NDFL,NDFX,NDF1,NDCNT S NDCNT=0
 I $D(NDFNDC) S NDFL=NDFNDC,NDFX=NDFL_"00" I $D(^PSNDF(50.67,"NDC",NDFX)) Q 1 ; gets one entry of "00"
 I $D(NDFNDC) S NDFL=NDFNDC,NDFX=NDFL_"00" F  S NDFX=$O(^PSNDF(50.67,"NDC",NDFX)) Q:NDFX=""!($E(NDFX,1,10)'=NDFL)  D
 .S NDCNT=NDCNT+1
 Q $S(NDCNT=0:0,NDCNT>0:1)
 ;
CMOP() ;
 I +Y=1&('$L(^TMP("NDFR",$J,"50.68,5"))!('$L(^TMP("NDFR",$J,"50.68,8")))!('$L(^TMP("NDFR",$J,"50.68,6")))) W !,"VA Print name, Dispense unit, and Product Identifier must be defined to mark for CMOP." H 1
 Q $T
 ;
FIELDS ;
1 ;;E^NDFRR10
2 ;;6^NDFRR7
3 ;;8^NDFRR7
4 ;;5^NDFRR7
5 ;;ADMIN^NDFRR9
6 ;;1^NDFRR2
