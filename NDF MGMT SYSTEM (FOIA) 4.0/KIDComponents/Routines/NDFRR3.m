NDFRR3 ;BIR/RSB-PRODUCT ENTER EDIT (Accept) ; 26 Jan 2010  9:17 AM
 ;;4.0;NDF MANAGEMENT;**62,70,108,262**; 1 Jan 99
 ;
ACCEPT ;
 I '$L($G(^TMP("NDFR",$J,"50.68,21")))&$G(^TMP("NDFR",$J,"50.68,8"))="" W !,$C(7),"VA Dispense Unit must be defined.    < NO FILES UPDATED>" H 2 S VALMBCK="R" Q
 W !!,"  Updating NDF files..." K NDFSAVE
 I '$P(NDFNAME,"^") D NEW
 I $P(NDFNAME,"^") S X=+NDFNAME K DIC S DIC=50.68,DIC(0)="MNZ" D ^DIC
 S NDFIEN=+Y I $D(NDFNDC)!($D(NDFUPNI)) S ^TMP("NDFD",$J,"50.67,5")=+Y
 I '$D(NDFCNEW) D SAVE
 D STUFF,STUFF1,STUFF3,STUFF4,STUFF5,STUFF2 S VALMBCK="B"
 I '$D(NDFCNEW) D CHECK
 W "..done." H .5 K NDFCNEW,NDFSAVE
 S VALMSG="NDF Files updated successfully!",VALMBCK="R"
 Q
NEW ; ADD NEW ENTRY TO 50.68
 K NDFCNEW,DD S DIC="^PSNDF(50.68,",DIC(0)="",X=$P(NDFNAME,"^",2) D FILE^DICN S NDFCNEW=1,$P(NDFNAME,"^")=+Y D
 .; SET IF ENTERING A NEW PRODUCT NAME ON A NEW UPN ENTRY
 .S:$D(NDFNDC)!($D(NDFUPN))!($D(NDFUPNI)) ^TMP("NDFD",$J,"50.67,5")=+Y
 .; ADD TO NEW ENTRY FILE
 .K DD S DIC="^NDFK(5000.506,",DIC(0)="",X=+Y N Y D FILE^DICN
 .W $C(7),!,$P(NDFNAME,"^",2)," has been added to the NEW VA PRODUCT NAMES File." H 2.5
 Q
STUFF ; STUFF SINGLE FIELDS THAT DON'T DLAYGO
 I $G(^TMP("NDFR",$J,"50.68,40"))="" D
 . S ^TMP("NDFR",$J,"50.68,40")="Y",^TMP("NDFR",$J,"50.68,41")="",^TMP("NDFR",$J,"50.68,42")=""
 I $G(^TMP("NDFR",$J,"50.68,11"))'="" S PEEYOU=$P(^PSNDF(50.68,$P(NDFNAME,"^"),1),"^",5),DIE=50.68,DA=$P(NDFNAME,"^"),DR="12////"_PEEYOU D ^DIE
 S DR=""
 N FIELD S DR=""
 F FIELD=".01",2,3,4,5,6,7,11,13,15,19,20,21,23,25,26,27,28,29,31,40,41,42,100 D
 .S NFIELD="50.68,"_FIELD D
 ..I $G(^TMP("NDFR",$J,NFIELD))="" S DR=DR_FIELD_"////"_"@;"
 ..I $G(^TMP("NDFR",$J,NFIELD))'="" D
 ...S DR=DR_FIELD_"////"_$S(FIELD=".01":$P($G(^TMP("NDFR",$J,NFIELD)),"^",2),FIELD=11:$P($G(^TMP("NDFR",$J,NFIELD)),"^"),1:$G(^TMP("NDFR",$J,NFIELD)))_";"
 D DIE
 ; set NATIONAL FORMULARY INDICATOR to 0 if node not there
 I '$L($G(^PSNDF(50.68,NDFIEN,5))) N DA,DIE,DR S DA=NDFIEN,DIE="^PSNDF(50.68,",DR="17////0;" D ^DIE
 Q
 ;
STUFF1 ; CLEAR AND STUFF SECONDARY VA DRUG CLASS ENTRIES
 N NDF1 F NDF1=0:0 S NDF1=$O(^PSNDF(50.68,NDFIEN,4,NDF1)) Q:'NDF1  D
 .S DA(1)=NDFIEN,DA=NDF1,DIE="^PSNDF(50.68,"_NDFIEN_",4,",DR=".01///"_"@" D ^DIE K DIE,DR
 F NDF1=0:0 S NDF1=$O(^TMP("NDFR",$J,"50.6816,.01",NDF1)) Q:'NDF1  D
 .;S DA(1)=NDFIEN,DA=NDF1,DIE="^PSNDF(50.68,"_NDFIEN_",4,",DR=".01////"_$G(^TMP("NDFR",$J,"50.6816,.01",NDF1)) D ^DIE K DIE,DR
 .K DD S DIC="^PSNDF(50.68,"_NDFIEN_",4,",DIC(0)="L",DIC("P")="50.6816P",DA(1)=NDFIEN,DA=NDF1,(DINUM,X)=$G(^TMP("NDFR",$J,"50.6816,.01",NDF1)) D FILE^DICN K DINUM
 Q
 ;
STUFF2 ; CLEAR AND STUFF INGREDIENT MULTIPLE
 N NDFC,NDFCC,NDF1,NDFE,NDFIG,PIECE
 ; CLEAR MULTIPLE
 F NDF1=0:0 S NDF1=$O(^PSNDF(50.68,NDFIEN,2,NDF1)) Q:'NDF1  D
 .S DA(1)=NDFIEN,DA=NDF1,DIE="^PSNDF(50.68,"_NDFIEN_",2,",DR=".01///"_"@" D ^DIE K DIE,DR
 ;
 F NDF1=0:0 S NDF1=$O(^TMP("NDFR",$J,"50.6814",NDF1)) Q:'NDF1  D
 .F PIECE=1,2,3,4 D
 ..S $P(NDFIG,"^",PIECE)=$P(^TMP("NDFR",$J,"50.6814",NDF1),"|",PIECE)
 .S NDFC=$P(NDFIG,"^"),NDFCC=(NDFC?1.9N)
 .I 'NDFCC D
 ..K DIC S X=NDFC,DIC=50.416,DIC(0)="EMZ" D ^DIC K DIC I Y<0 D
 ...K DD S DIC="^PS(50.416,",DIC(0)="",X=NDFC D FILE^DICN
 ..S NDFE=+Y I Y>0&($P(NDFIG,"^",4)) S DIE="^PS(50.416,",DA=+Y D
 ...S DR="2////"_$P(NDFIG,"^",4) D ^DIE K DIE,DR
 ..;create new entry in ing multiple
 ..K DD S DIC="^PSNDF(50.68,"_NDFIEN_",2,",DIC(0)="L",DIC("P")="50.6814P",DA(1)=NDFIEN,DA=NDF1,(X,DINUM)=+NDFE D FILE^DICN K DINUM,DA,D0,DIC
 ..; edit the new entry
 ..S NDFG=NDFE S DA(1)=NDFIEN,DA=+Y,DIE="^PSNDF(50.68,"_NDFIEN_",2,"
 ..S DR="1////"_$P(NDFIG,"^",2)_";2////"_$P(NDFIG,"^",3) D ^DIE K DIE,DR,NDFG
 ..;
 .I NDFCC D
 ..K DD S DIC="^PSNDF(50.68,"_NDFIEN_",2,",DIC(0)="L",DIC("P")="50.6814P",DA(1)=NDFIEN,DA=NDF1,(X,DINUM)=+$G(^TMP("NDFR",$J,"50.6814",NDF1)) D FILE^DICN K DINUM
 ..S DA(1)=NDFIEN,DA=+Y,DIE="^PSNDF(50.68,"_NDFIEN_",2,",DR="1////"_$P(NDFIG,"^",2)_";2////"_$P(NDFIG,"^",3)
 ..D ^DIE K DIE,DR
 Q
 ;
STUFF3 ; STUFF AND ADD VA GENERIC NAME
 N NDFC,NDFCC,NDFG S NDFC=$G(^TMP("NDFR",$J,"50.68,.05"))
 S NDFCC=(NDFC?1.9N)
 I NDFCC D
 .S DA=NDFIEN,DIE="^PSNDF(50.68,",DR=".05////"_$G(^TMP("NDFR",$J,"50.68,.05")) D ^DIE K DIE,DR
 I 'NDFCC D
 .K DIC S X=NDFC,DIC=50.6,DIC(0)="EMZ" D ^DIC K DIC I Y<0 D
 ..K DD S DIC="^PSNDF(50.6,",DIC(0)="",X=NDFC D FILE^DICN
 .S NDFG=Y S DA=NDFIEN,DIE="^PSNDF(50.68,",DR=".05////"_+NDFG D ^DIE K DIE,DR
 Q
 ;
STUFF4 ; STUFF AND ADD DOSAGE FORM
 N NDFC,NDFCC,NDFG S NDFC=$G(^TMP("NDFR",$J,"50.68,1"))
 S NDFCC=(NDFC?1.9N)
 I NDFCC D
 .S DA=NDFIEN,DIE="^PSNDF(50.68,",DR="1////"_$G(^TMP("NDFR",$J,"50.68,1")) D ^DIE K DIE,DR
 I 'NDFCC D
 .K DIC S X=NDFC,DIC=50.606,DIC(0)="EMZ" D ^DIC K DIC I Y<0 D
 ..S XPDGREF=1 ; TAKE OUT LATER ?????????????????????????????????????
 ..K DD S DIC="^PS(50.606,",DIC(0)="",X=NDFC D FILE^DICN
 .S NDFG=Y S DA=NDFIEN,DIE="^PSNDF(50.68,",DR="1////"_+NDFG D ^DIE K DIE,DR
 Q
 ;
STUFF5  ; STUFF AND ADD VA DISPENSE UNIT
 N NDFC,NDFCC,NDFG S NDFC=$G(^TMP("NDFR",$J,"50.68,8"))
 Q:NDFC=""  ; quit if no dispense unit, only happens on marking inactive
 S NDFCC=(NDFC?1.9N)
 I NDFCC D
 .S DA=NDFIEN,DIE="^PSNDF(50.68,",DR="8////"_$G(^TMP("NDFR",$J,"50.68,8")) D ^DIE K DIE,DR
 I 'NDFCC D
 .K DIC S X=NDFC,DIC=50.64,DIC(0)="EMZ" D ^DIC K DIC I Y<0 D
 ..K DD S DIC="^PSNDF(50.64,",DIC(0)="",X=NDFC D FILE^DICN
 .S NDFG=Y S DA=NDFIEN,DIE="^PSNDF(50.68,",DR="8////"_+NDFG D ^DIE K DIE,DR
 Q
DIE ;
 S DA=NDFIEN,DIE="^PSNDF(50.68," D ^DIE K DIE,DR
 Q
SAVE ; save off fields to compare if they changed
 S NDFSAVE("50.68,.05")=$P(^PSNDF(50.68,NDFIEN,0),"^",2)  ; generic name
 S NDFSAVE("50.68,.01")=$P(^PSNDF(50.68,NDFIEN,0),"^")  ; product name
 S NDFSAVE("50.68,5")=$P(^PSNDF(50.68,NDFIEN,1),"^")  ; print name
 S NDFSAVE("50.68,3")=$P(^PSNDF(50.68,NDFIEN,0),"^",5)  ; unit
 S NDFSAVE("50.68,1")=$P(^PSNDF(50.68,NDFIEN,0),"^",3)  ; dosage form
 S NDFSAVE("50.68,21")=$P($G(^PSNDF(50.68,NDFIEN,7)),"^",3)  ; inact date
 S NDFSAVE("50.68,2")=$P(^PSNDF(50.68,NDFIEN,0),"^",4)  ; top level strength
 S NDFSAVE("50.68,7")=$P($G(^PSNDF(50.68,NDFIEN,1)),"^",3)   ; transmit to CMOP
 S NDFSAVE("50.68,6")=$P($G(^PSNDF(50.68,NDFIEN,1)),"^",2)   ;cmop id
 ; S NDFSAVE("50.68,19")=$P($G(^PSNDF(50.68,NDFIEN,7)),"^")   ; cs federal schedule
 S NDFSAVE("50.68,15")=$P($G(^PSNDF(50.68,NDFIEN,3)),"^")  ; class
 S NDFSAVE("50.68,23")=+$P($G(^PSNDF(50.68,NDFIEN,8)),"^") ;exclude from interaction check
 S NDFSAVE("50.68,31")=+$P($G(^PSNDF(50.68,NDFIEN,9)),"^") ;override df check
 S NDFSAVE("50.68,40")=$P($G(^PSNDF(50.68,NDFIEN,"DOS")),"^",1) ;Create Default Possible Dosage
 S NDFSAVE("50.68,41")=$P($G(^PSNDF(50.68,NDFIEN,"DOS")),"^",2) ;Possible Dosage to Create
 S NDFSAVE("50.68,42")=$P($G(^PSNDF(50.68,NDFIEN,"DOS")),"^",3) ;Package
 S NDFSAVE("50.68,100")=$G(^PSNDF(50.68,NDFIEN,"MG")) ;URL
 Q
CHECK ; check fields and save ien if changed
 N FLAG S FLAG=0
 I NDFSAVE("50.68,.05")'=$P(^PSNDF(50.68,NDFIEN,0),"^",2) S FLAG=1  ; generic name
 I NDFSAVE("50.68,.01")'=$P(^PSNDF(50.68,NDFIEN,0),"^") S FLAG=1  ; product name
 I $L(NDFSAVE("50.68,5"))>0&(NDFSAVE("50.68,5")'=$P(^PSNDF(50.68,NDFIEN,1),"^")) S FLAG=1  ; print name
 I NDFSAVE("50.68,21")'=$P($G(^PSNDF(50.68,NDFIEN,7)),"^",3) S FLAG=1 ; inact
 I $L(NDFSAVE("50.68,3"))>0&(NDFSAVE("50.68,3")'=$P(^PSNDF(50.68,NDFIEN,0),"^",5)) S FLAG=2  ; unit
 I NDFSAVE("50.68,1")'=$P(^PSNDF(50.68,NDFIEN,0),"^",3) S FLAG=2  ; dosage form
 I NDFSAVE("50.68,2")'=$P(^PSNDF(50.68,NDFIEN,0),"^",4) S FLAG=2  ;top level strength
 I NDFSAVE("50.68,6")'=$P($G(^PSNDF(50.68,NDFIEN,1)),"^",2) S FLAG=1  ;cmop id
 I NDFSAVE("50.68,23")'=+$P($G(^PSNDF(50.68,NDFIEN,8)),"^") D
 .I $D(^NDFK(5000.23,NDFIEN)) K ^(NDFIEN) Q
 .S ^NDFK(5000.23,NDFIEN,0)=NDFIEN_"^"_+$P($G(^PSNDF(50.68,NDFIEN,8)),"^")
 .;change in exclude from ineraction check
 I NDFSAVE("50.68,100")'=$G(^PSNDF(50.68,NDFIEN,"MG")) D
 .S ^NDFK(5000.91,NDFIEN,0)=NDFIEN_"^"_$S(NDFSAVE("50.68,100")="":"A",$G(^PSNDF(50.68,NDFIEN,"MG"))="":"D",1:"E")
 I FLAG D
 .K DD S DIC="^NDFK(5000.2,",DIC(0)="",X=NDFIEN D FILE^DICN
 .W $C(7),!,$P($G(^PSNDF(50.68,+NDFIEN,0)),"^")," has been added to the PRODUCTS TO UNMATCH File." H 2.5
 I FLAG=2 K DD,DO S DIC="^NDFK(5000.4,",X=NDFIEN D FILE^DICN
 I NDFSAVE("50.68,7"),'$P($G(^PSNDF(50.68,NDFIEN,1)),"^",3) S ^NDFK(5000.7,NDFIEN,0)=NDFIEN
 I 'NDFSAVE("50.68,7"),$P($G(^PSNDF(50.68,NDFIEN,1)),"^",3) K ^NDFK(5000.7,NDFIEN)
 ;
 ;Does not record class/edits on new VA Products
 I '$D(^NDFK(5000.506,"B",NDFIEN)) D
 .S NDFCLASS=$P($G(^PSNDF(50.68,NDFIEN,3)),"^")
 .I NDFSAVE("50.68,15"),NDFSAVE("50.68,15")'=NDFCLASS D
 ..I NDFCLASS=$P($G(^NDFK(5000.8,NDFIEN,0)),"^",2) K ^NDFK(5000.8,NDFIEN) Q
 ..;new class equals previous old class - changed back - delete
 ..I $D(^NDFK(5000.8,NDFIEN,0)) S $P(^(0),"^",3)=NDFCLASS
 ..;previous change exists - changed and changed again - reset new
 ..E  S ^NDFK(5000.8,NDFIEN,0)=NDFIEN_"^"_NDFSAVE("50.68,15")_"^"_NDFCLASS_"^"_NDFSAVE("50.68,.05")_"^"_$P(^PSNDF(50.6,NDFSAVE("50.68,.05"),0),"^")
 ..;no previous change - set one up
 ;
 ;override
 S NDFOV=$P($G(^PSNDF(50.68,NDFIEN,9)),"^")
 I NDFSAVE("50.68,31")'=NDFOV D
 .I NDFOV=$P($G(^NDFK(5000.608,NDFIEN,0)),"^",2) K ^NDFK(5000.608,NDFIEN) Q
 .I $D(^NDFK(5000.608,NDFIEN,0)) S $P(^(0),"^",3)=NDFOV
 .E   S ^NDFK(5000.608,NDFIEN,0)=NDFIEN_"^"_NDFSAVE("50.68,31")_"^"_NDFOV
 ;
 ;Possible Dosage Settings
 N POSDOS,DIC,DD,X,DINUM
 S POSDOS=$G(^PSNDF(50.68,NDFIEN,"DOS"))
 I (NDFSAVE("50.68,40")'=$P(POSDOS,"^",1))!(NDFSAVE("50.68,41")'=$P(POSDOS,"^",2))!(NDFSAVE("50.68,42")'=$P(POSDOS,"^",3)) D
 .K DD S DIC="^NDFK(5000.92,",DIC(0)="",(X,DINUM)=NDFIEN D FILE^DICN
 ;
 K NDFSAVE,NDFCLASS
 ;
 Q
 ;
CHECKP(NAME) ;
 N X,PNAME,FLAG S FLAG=0
 F X=0:0 S X=$O(^PSNDF(50.68,"C",NDFM,X)) Q:'X  D
 .S PNAME=$P($G(^PSNDF(50.68,X,1)),"^") I PNAME'=NAME S FLAG=1
 Q FLAG
