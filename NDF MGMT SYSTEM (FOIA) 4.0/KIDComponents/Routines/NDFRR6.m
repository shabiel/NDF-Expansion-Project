NDFRR6 ;BIR/RSB  - VA Product Enter/Edit ; 07 Dec 2010  4:56 PM
 ;;4.0;NDF MANAGEMENT;**62,70,108,262**; 1 Jan 99
 ;
HDR ;
 S VALMHDR(1)=$$SETSTR^VALM1("VA Product Name: "_$P(NDFNAME,"^",2)," ",2,80)
 Q
 ;
BUILD(Y) ;
 I '$P(Y,"^") D LIST Q
 S:'$D(^TMP("NDFR",$J,"50.68,.01")) ^TMP("NDFR",$J,"50.68,.01")=$P(^PSNDF(50.68,+Y,0),"^")
 ; ACTIVE INGREDIENTS
 N X,CNT S CNT=0 F X=0:0 S X=$O(^PSNDF(50.68,+Y,2,X)) Q:'X  D
 .I $D(NDFINGL) Q
 .S CNT=CNT+1,^TMP("NDFR",$J,"50.6814",CNT)=$P(^PSNDF(50.68,+Y,2,X,0),"^")
 .S $P(^TMP("NDFR",$J,"50.6814",CNT),"|",2)=$P(^PSNDF(50.68,+Y,2,X,0),"^",2)
 .S $P(^TMP("NDFR",$J,"50.6814",CNT),"|",3)=$P(^PSNDF(50.68,+Y,2,X,0),"^",3)
 .S $P(^TMP("NDFR",$J,"50.6814",CNT),"|",4)=$S($P(^PS(50.416,+$P(^PSNDF(50.68,+Y,2,X,0),"^"),0),"^",2):$P(^PS(50.416,+$P(^PSNDF(50.68,+Y,2,X,0),"^"),0),"^",2),1:"")
 ; VA GENERIC NAME
 S:'$D(^TMP("NDFR",$J,"50.68,.05")) ^TMP("NDFR",$J,"50.68,.05")=$P(^PSNDF(50.68,+Y,0),"^",2)
 ; DOSAGE FORM
 S:'$D(^TMP("NDFR",$J,"50.68,1")) ^TMP("NDFR",$J,"50.68,1")=$P(^PSNDF(50.68,+Y,0),"^",3)
 ; STRENGTH
 S:'$D(^TMP("NDFR",$J,"50.68,2")) ^TMP("NDFR",$J,"50.68,2")=$P(^PSNDF(50.68,+Y,0),"^",4)
 ; UNITS
 S:'$D(^TMP("NDFR",$J,"50.68,3")) ^TMP("NDFR",$J,"50.68,3")=$P(^PSNDF(50.68,+Y,0),"^",5)
 ; NATIONAL FORMULARY NAME
 S:'$D(^TMP("NDFR",$J,"50.68,4")) ^TMP("NDFR",$J,"50.68,4")=$P(^PSNDF(50.68,+Y,0),"^",6)
 ; VA PRINT NAME
 S:'$D(^TMP("NDFR",$J,"50.68,5")) ^TMP("NDFR",$J,"50.68,5")=$P($G(^PSNDF(50.68,+Y,1)),"^")
 ; VA PRODUCT IDENTIFIER
 S:'$D(^TMP("NDFR",$J,"50.68,6")) ^TMP("NDFR",$J,"50.68,6")=$P($G(^PSNDF(50.68,+Y,1)),"^",2)
 ; VA DISPENSE UNIT
 S:'$D(^TMP("NDFR",$J,"50.68,8")) ^TMP("NDFR",$J,"50.68,8")=$P($G(^PSNDF(50.68,+Y,1)),"^",4)
 ; TRANSMIT TO CMOP
 S:'$D(^TMP("NDFR",$J,"50.68,7")) ^TMP("NDFR",$J,"50.68,7")=$P($G(^PSNDF(50.68,+Y,1)),"^",3)
 ; PMIS
 ; S:'$D(^TMP("NDFR",$J,"50.68,11")) ^TMP("NDFR",$J,"50.68,11")=$P($G(^PSNDF(50.68,+Y,1)),"^",5)
 D ^NDFRRDP S:'$D(^TMP("NDFR",$J,"50.68,11")) ^TMP("NDFR",$J,"50.68,11")=FDBGCN
 ; I SEQNO]"" S:'$D(^TMP("NDFR",$J,"FDBGCN")) ^TMP("NDFR",$J,"FDBGCN")=FDBGCN
 ; PREVIOUS GCNSEQNO
 ; S:'$D(^TMP("NDFR",$J,"50.68,12")) ^TMP("NDFR",$J,"50.68,12")=$P($G(^PSNDF(50.68,+Y,1)),"^",6)
 K ^TMP("NDFR",$J,"50.68,12") D ^NDFRRDP1 S:'$D(^TMP("NDFR",$J,"50.68,12")) ^TMP("NDFR",$J,"50.68,12")=PSEQNO
 ; NDC LINK TO GCNSEQNO
 S:'$D(^TMP("NDFR",$J,"50.68,13")) ^TMP("NDFR",$J,"50.68,13")=$P($G(^PSNDF(50.68,+Y,1)),"^",7)
 ;         LATER!!!!
 ; PRIMARY VA DRUG CLASS
 S:'$D(^TMP("NDFR",$J,"50.68,15")) ^TMP("NDFR",$J,"50.68,15")=$P($G(^PSNDF(50.68,+Y,3)),"^")
 ; SECONDARY VA DRUG CLASS
 N X,CNT S CNT=0 F X=0:0 S X=$O(^PSNDF(50.68,+Y,4,X)) Q:'X  D
 .I $D(NDFCLASS) Q
 .S CNT=CNT+1,^TMP("NDFR",$J,"50.6816,.01",CNT)=$P(^PSNDF(50.68,+Y,4,X,0),"^")
 ; CS FEDERAL SCHEDULE
 S:'$D(^TMP("NDFR",$J,"50.68,19")) ^TMP("NDFR",$J,"50.68,19")=$P($G(^PSNDF(50.68,+Y,7)),"^")
 ; SINGLE/MULTI SOURCE PRODUCT
 S:'$D(^TMP("NDFR",$J,"50.68,20")) ^TMP("NDFR",$J,"50.68,20")=$P($G(^PSNDF(50.68,+Y,7)),"^",2)
 ; INACTIVATION DATE
 S:'$D(^TMP("NDFR",$J,"50.68,21")) ^TMP("NDFR",$J,"50.68,21")=$P($G(^PSNDF(50.68,+Y,7)),"^",3)
 ; EXCLUDE DRG-DRG INTERACTION CK
 S:'$D(^TMP("NDFR",$J,"50.68,23")) ^TMP("NDFR",$J,"50.68,23")=$P($G(^PSNDF(50.68,+Y,8)),"^")
 ; MAX SINGLE DOSE
 S:'$D(^TMP("NDFR",$J,"50.68,25")) ^TMP("NDFR",$J,"50.68,25")=$P($G(^PSNDF(50.68,+Y,7)),"^",4)
 ; MIN SINGLE DOSE
 S:'$D(^TMP("NDFR",$J,"50.68,26")) ^TMP("NDFR",$J,"50.68,26")=$P($G(^PSNDF(50.68,+Y,7)),"^",5)
 ;OVERRIDE
 S:'$D(^TMP("NDFR",$J,"50.68,31")) ^TMP("NDFR",$J,"50.68,31")=$P($G(^PSNDF(50.68,+Y,9)),"^")
 ; MAX DAILY DOSE
 S:'$D(^TMP("NDFR",$J,"50.68,27")) ^TMP("NDFR",$J,"50.68,27")=$P($G(^PSNDF(50.68,+Y,7)),"^",6)
 ; MIN DAILY DOSE
 S:'$D(^TMP("NDFR",$J,"50.68,28")) ^TMP("NDFR",$J,"50.68,28")=$P($G(^PSNDF(50.68,+Y,7)),"^",7)
 ; MAX CUMMULATIVE DOSE
 S:'$D(^TMP("NDFR",$J,"50.68,29")) ^TMP("NDFR",$J,"50.68,29")=$P($G(^PSNDF(50.68,+Y,7)),"^",8)
 ;FDA
 S:'$D(^TMP("NDFR",$J,"50.68,100")) ^TMP("NDFR",$J,"50.68,100")=$P($G(^PSNDF(50.68,+Y,"MG")),"^")
 ;POSSIBLE DOSAGE CREATION
 S:'$D(^TMP("NDFR",$J,"50.68,40")) ^TMP("NDFR",$J,"50.68,40")=$P($G(^PSNDF(50.68,+Y,"DOS")),"^",1)
 S:'$D(^TMP("NDFR",$J,"50.68,41")) ^TMP("NDFR",$J,"50.68,41")=$P($G(^PSNDF(50.68,+Y,"DOS")),"^",2)
 S:'$D(^TMP("NDFR",$J,"50.68,42")) ^TMP("NDFR",$J,"50.68,42")=$P($G(^PSNDF(50.68,+Y,"DOS")),"^",3)
 ;
 D LIST
 ;
 Q
LIST ; BUILD LISTMAN SCREEN
 N INGNUM,CNT,NDFL S CNT=1
 K ^TMP("NDFRSB",$J)
 S NDFC=$P(NDFNAME,"^",2),NDFCC=(NDFC?1.9N)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("1)  VA Product: "_$S(NDFCC:$P(^PSNDF(50.68,+NDFNAME,0),"^"),1:NDFC),"",1,80),CNT=CNT+1
 S NDFC=$G(^TMP("NDFR",$J,"50.68,.05")),NDFCC=(NDFC?1.9N)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("2)  VA Generic Name: "_$S(NDFCC:$P($G(^PSNDF(50.6,^TMP("NDFR",$J,"50.68,.05"),0)),"^"),1:NDFC),"",1,70),CNT=CNT+1 K NDFC,NDFCC
 S NDFC=$G(^TMP("NDFR",$J,"50.68,1")),NDFCC=(NDFC?1.9N)
 S NDFEXC=$P($G(^PS(50.606,+$G(^TMP("NDFR",$J,"50.68,1")))),"^")&'$G(^TMP("NDFR",$J,"50.68,31"))
 S NDFEXC=$S(NDFEXC:" Exclude from dosage form checks",1:"")
 S NDFL=$$SETSTR^VALM1("3)  Dosage Form: "_$S(NDFCC:$P($G(^PS(50.606,^TMP("NDFR",$J,"50.68,1"),0)),"^"),1:NDFC),"",1,32) K NDFC,NDFCC
 S NDFL=$$SETSTR^VALM1(NDFEXC,NDFL,35,35) K NDFC,NDFCC,NDFEXC
 S ^TMP("NDFRSB",$J,CNT,0)=NDFL,CNT=CNT+1
 S NDFL=$$SETSTR^VALM1("4)  Strength: "_$G(^TMP("NDFR",$J,"50.68,2")),"",1,20)
 S NDFC=+$G(^TMP("NDFR",$J,"50.68,3"))
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("(5) Units: "_$S(NDFC:$P(^PS(50.607,+$G(^TMP("NDFR",$J,"50.68,3")),0),"^"),1:""),NDFL,25,24),CNT=CNT+1
 ; build National Formulary name again
 S NDFC=$G(^TMP("NDFR",$J,"50.68,.05")) S NDFCC=(NDFC?1.9N)
 S NDFDEF=$S(NDFCC:$P($G(^PSNDF(50.6,^TMP("NDFR",$J,"50.68,.05"),0)),"^"),1:$G(^TMP("NDFR",$J,"50.68,.05")))
 S NDFC=$G(^TMP("NDFR",$J,"50.68,1")) S NDFCC=(NDFC?1.9N)
 S NDFDEF1=$S(NDFCC:$P($G(^PS(50.606,^TMP("NDFR",$J,"50.68,1"),0)),"^"),1:$G(^TMP("NDFR",$J,"50.68,1")))
 ;S ^TMP("NDFR",$J,"50.68,4")=NDFDEF_" "_NDFDEF1 K NDFDEF,NDFDEF1,NDFC,NDFCC
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("6)  Nat' Formulary Name: "_$G(^TMP("NDFR",$J,"50.68,4")),"",1,80),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("7)  VA Print Name: "_$G(^TMP("NDFR",$J,"50.68,5")),"",1,79),CNT=CNT+1
 S NDFL=$$SETSTR^VALM1("8)  VA Product Identifier: "_$G(^TMP("NDFR",$J,"50.68,6")),"",1,35)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("(9) Transmit to CMOP: "_$S($G(^TMP("NDFR",$J,"50.68,7"))=1:"Yes",1:"No"),NDFL,36,70),CNT=CNT+1
 S NDFC=$G(^TMP("NDFR",$J,"50.68,8")) S NDFCC=(NDFC?1.9N)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("10) VA Dispense Unit: "_$S(NDFCC:$P($G(^PSNDF(50.64,^TMP("NDFR",$J,"50.68,8"),0)),"^"),1:NDFC),"",1,70),CNT=CNT+1 K NDFC,NDFCC
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("11) GCNSEQNO: "_$P($G(^TMP("NDFR",$J,"50.68,11")),"^",3),"",1,70),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("11a) PREVIOUS GCNSEQNO: "_$P($G(^TMP("NDFR",$J,"50.68,12")),"^",3),"",1,70),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("11b) NDC LINK TO GCNSEQNO: "_$G(^TMP("NDFR",$J,"50.68,13")),"",1,70),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("12) Active Ingredients: ","",1,70),CNT=CNT+1
 N ING F ING=0:0 S ING=$O(^TMP("NDFR",$J,"50.6814",ING)) Q:'ING  D
 .S NDFC=$P($G(^TMP("NDFR",$J,"50.6814",ING)),"|") S NDFCC=(NDFC?1.9N)
 .I 'NDFCC K NDFL S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1(NDFC_$S('$L($P(^TMP("NDFR",$J,"50.6814",ING),"|",4)):"  (Primary)",1:""),"",6,72)
 .I NDFCC K NDFL S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1($P($G(^PS(50.416,+^TMP("NDFR",$J,"50.6814",ING),0)),"^")_$S('$L($P($G(^PS(50.416,+^TMP("NDFR",$J,"50.6814",ING),0)),"^",2)):"  (Primary)",1:""),"",6,72)
 .K NDFC,NDFCC S CNT=CNT+1
 .S NDFL=$$SETSTR^VALM1("(12a) Strength: "_$P(^TMP("NDFR",$J,"50.6814",ING),"|",2),"",28,23)
 .S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("(12b) Unit: "_$P($G(^PS(50.607,+$P(^TMP("NDFR",$J,"50.6814",ING),"|",3),0)),"^"),NDFL,51,29),CNT=CNT+1 K NDFL
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("13) Primary VA Drug Class: "_$P($G(^PS(50.605,+$G(^TMP("NDFR",$J,"50.68,15")),0)),"^"),"",1,40),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("14) Secondary VA Drug Class:","",1,40),CNT=CNT+1
 N SEC F SEC=0:0 S SEC=$O(^TMP("NDFR",$J,"50.6816,.01",SEC)) Q:'SEC  D
 .S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1($P($G(^PS(50.605,^TMP("NDFR",$J,"50.6816,.01",SEC),0)),"^"),"",6,40),CNT=CNT+1
 S NDFL=$$SETSTR^VALM1("15) CS Fed Schedule: "_$$EXTERNAL^DILFD(50.68,19,"",$G(^TMP("NDFR",$J,"50.68,19"))),"",1,40)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("(16) S/M Source Product: "_$$EXTERNAL^DILFD(50.68,20,"",$G(^TMP("NDFR",$J,"50.68,20"))),NDFL,40,39),CNT=CNT+1
 S:$G(^TMP("NDFR",$J,"50.68,21")) Y=$G(^TMP("NDFR",$J,"50.68,21")) X ^DD("DD")
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("17) Inactivation Date: "_$S($G(^TMP("NDFR",$J,"50.68,21")):Y,1:""),NDFL,1,70),CNT=CNT+1
 S NDFL=$$SETSTR^VALM1("18) Max Single Dose: "_$G(^TMP("NDFR",$J,"50.68,25")),"",1,40)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("(19) Min Single Dose: "_$G(^TMP("NDFR",$J,"50.68,26")),NDFL,40,39),CNT=CNT+1
 S NDFL=$$SETSTR^VALM1("20) Max Daily Dose: "_$G(^TMP("NDFR",$J,"50.68,27")),"",1,40)
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("(21) Min Daily Dose: "_$G(^TMP("NDFR",$J,"50.68,28")),NDFL,40,39),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("22) Max Cumulative Dose: "_$G(^TMP("NDFR",$J,"50.68,29")),"",1,40),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("23) EXCLUDE Drg-Drg Interaction Check: "_$S($G(^TMP("NDFR",$J,"50.68,23"))=1:"Yes",1:"No"),"",1,50),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("24) OVERRIDE DF dose check exclusion: "_$S($G(^TMP("NDFR",$J,"50.68,31"))=1:"Yes",1:"No"),"",1,50),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("25) FDA Med Guide File Name: "_$G(^TMP("NDFR",$J,"50.68,100")),"",1,80),CNT=CNT+1
 S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("26) Auto-Create Default Possible Dosage: "_$S($G(^TMP("NDFR",$J,"50.68,40"))="N":"No",1:"Yes"),"",1,80),CNT=CNT+1
 I $G(^TMP("NDFR",$J,"50.68,40"))="N" D
 . N PTC S PTC=$G(^TMP("NDFR",$J,"50.68,41"))
 . S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("26a) Possible Dosages to Auto-Create: "_$S(PTC="N":"No Possible Dosages",PTC="O":"1x Possible Dosage",PTC="B":"1x and 2x Possible Dosages",1:""),"",1,80),CNT=CNT+1
 . I (PTC'="N") D
 . . N PKG S PKG=$G(^TMP("NDFR",$J,"50.68,42"))
 . . S ^TMP("NDFRSB",$J,CNT,0)=$$SETSTR^VALM1("26b) Package: "_$S(PKG="O":"Outpatient",PKG="I":"Inpatient",PKG="IO":"Both Inpatient and Outpatient",1:""),"",1,80),CNT=CNT+1
 ;
 S VALMCNT=CNT
 Q
