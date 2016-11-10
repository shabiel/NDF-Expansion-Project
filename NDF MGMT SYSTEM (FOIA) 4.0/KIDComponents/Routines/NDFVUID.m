NDFVUID ;BIRM/WRT - Auto populating of VUIDs.; 12/09/05 10:53 ; 13 Apr 2009  8:29 AM
 ;;0.0;NATIONAL DRUG FILE MANAGEMENT SYSTEM;; 30 Oct 98
DISPLAY W !!,"This option is used to assign VUIDs to newly added entries and to update the"
 W !,"VUID EFFECTIVE DATE/STATUS fields when an entry is inactivated.",!!,"This option should not be run until the Data Standardization Review team has",!,"reviewed the List of New Entries Pending VUID Assignment report AND has"
 W !,"provided written approval of all planned changes.",!!,"Running this option is the last step prior to the actual creation of the NDF",!,"Data Update Patch."
 W !! S DIR("A")="Has the Data Standardization Review Team reviewed and provided written approval of the report? "
 S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) Q
 I Y=0 Q
 W !! S DIR("A")="Are you sure you are ready to proceed? "
 S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) Q
 I Y=0 Q
 W !!!,"Please wait while I assign VUIDs...." K ^BT("PSNVUID") S VUID=$P(^NDFK(5000.991,1,0),"^",2)+1 D START,INGRED,CLASS,VAGN,PFS,FIX,KILL D ^NDFORCE W !!,"OK, I'm done",!!,"Now print the report to your screen to see what was assigned.",!
 D ^NDFNWVD
 Q
START ; Begin population process
 F I=0:0 S I=$O(^PSNDF(50.68,I)) Q:'I  I '$D(^PSNDF(50.68,I,"VUID")) S NAM=$P(^PSNDF(50.68,I,0),"^"),DATE=$P($G(^PSNDF(50.68,I,7)),"^",3) S:'$G(DATE) DATE=DT S MAST=1 D SETVUID,STATUS
 Q
SETVUID S DA=I,DIE="^PSNDF(50.68,",DR="99.99////"_VUID D ^DIE S DA=I,DIE="^PSNDF(50.68,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","VAPN",I)=VUID D FIL991 S VUID=VUID+1
 Q
STATUS S:'$D(^PSNDF(50.68,I,"TERMSTATUS",0)) ^PSNDF(50.68,I,"TERMSTATUS",0)="^50.6899DA^^"
 I DATE=DT S DA(1)=I,DIC="^PSNDF(50.68,"_I_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.6899,DIC("DR")=".02////"_1 D FILE^DICN
 I DATE'=DT S DA(1)=I,DIC="^PSNDF(50.68,"_I_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.6899,DIC("DR")=".02////"_0 D FILE^DICN
 Q
FIL991 S $P(^NDFK(5000.991,1,0),"^",2)=VUID,$P(^NDFK(5000.991,1,1,50.68,0),"^",2)=I
 Q
FIL992 S JJJ=$P(^NDFK(5000.992,0),"^",3)+1,^NDFK(5000.992,JJJ,0)=$P(^PSNDF(50.68,I,"VUID"),"^")_"^"_50.68_"^"_I_"^"_NAM_"^"_MAST_"^"_DATE,^NDFK(5000.992,"B",$P(^PSNDF(50.68,I,"VUID"),"^"),JJJ)="",^NDFK(5000.992,"C",NAM,JJJ)="" D NDEX
 S $P(^NDFK(5000.992,0),"^",3)=JJJ,$P(^NDFK(5000.992,0),"^",4)=JJJ
 ; KILL K I,NAM,NAM,DATE,PSZ,IEN,VUID,DVUID Q
 Q
NDEX ; S ^NDFK(5000.992,"F",$P(^PSNDF(50.68,I,"VUID"),"^"),50.68,NAM,JJJ)="" I $P(^NDFK(5000.992,JJJ,0),"^",6)=DT S DA=I,DIE="^PSNDF(50.68,",DR="99.98////"_1 D ^DIE S $P(^NDFK(5000.992,JJJ,0),"^",5)=1
 Q
INGRED K DATE,JJJ S JJJ=$P(^NDFK(5000.992,0),"^",3)+1 F LL=0:0 S LL=$O(^PS(50.416,LL)) Q:'LL  I '$D(^PS(50.416,LL,"VUID")) S NAME=$P(^PS(50.416,LL,0),"^"),DATE=$P($G(^PS(50.416,LL,2)),"^") S:'$G(DATE) DATE=DT D INGVUID,ST
 Q
INGVUID I '$D(^NDFK(5000.992,"C",NAME)) S DA=LL,DIE="^PS(50.416,",DR="99.99////"_VUID D ^DIE S DA=LL,DIE="^PS(50.416,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","ING",LL)=VUID D FL991 S VUID=VUID+1
 I $D(^NDFK(5000.992,"C",NAME)) S IEN=$O(^NDFK(5000.992,"C",NAME,0)),DVUID=$P(^NDFK(5000.992,IEN,0),"^"),DA=LL,DIE="^PS(50.416,",DR="99.99////"_DVUID D ^DIE S DA=LL,DIE="^PS(50.416,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","ING",LL)=DVUID
 D FL992
 Q
ST S:'$D(^PS(50.416,LL,"TERMSTATUS",0)) ^PS(50.416,LL,"TERMSTATUS",0)="^50.4169DA^^"
 I DATE=DT S DA(1)=LL,DIC="^PS(50.416,"_LL_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.4169,DIC("DR")=".02////"_1 D FILE^DICN
 I DATE'=DT S DA(1)=LL,DIC="^PS(50.416,"_LL_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.4169,DIC("DR")=".02////"_0 D FILE^DICN
 Q
FL991 S $P(^NDFK(5000.991,1,0),"^",2)=VUID,$P(^NDFK(5000.991,1,1,50.416,0),"^",2)=LL
 Q
FL992 S JJJ=$P(^NDFK(5000.992,0),"^",3)+1,^NDFK(5000.992,JJJ,0)=$P(^PS(50.416,LL,"VUID"),"^")_"^"_50.416_"^"_LL_"^"_NAME,^NDFK(5000.992,"B",$P(^PS(50.416,LL,"VUID"),"^"),JJJ)="",^NDFK(5000.992,"C",NAME,JJJ)=""
 S $P(^NDFK(5000.992,0),"^",3)=JJJ,$P(^NDFK(5000.992,0),"^",4)=JJJ
 Q
CLASS K DATE,JJJ F PP=0:0 S PP=$O(^PS(50.605,PP)) Q:'PP  I '$D(^PS(50.605,PP,"VUID")) D COMBO S DATE=$P($G(^PS(50.605,PP,2)),"^") S:'$G(DATE) DATE=DT S MAST=1 D CLSVUID,STA
 Q
COMBO S NME=$P(^PS(50.605,PP,0),"^")_"***"_$P(^PS(50.605,PP,0),"^",2)
 Q
CLSVUID I '$D(^NDFK(5000.992,"C",NME)) S DA=PP,DIE="^PS(50.605,",DR="99.99////"_VUID D ^DIE S DA=PP,DIE="^PS(50.605,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","VACL",PP)=VUID D F991 S VUID=VUID+1
 I $D(^NDFK(5000.992,"C",NME)) S IEN=$O(^NDFK(5000.992,"C",NME,0)),DVUID=$P(^NDFK(5000.992,IEN,0),"^"),DA=PP,DIE="^PS(50.605,",DR="99.99////"_DVUID D ^DIE S DA=PP,DIE="^PS(50.605,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","VACL",PP)=DVUID
 D F992
 Q
STA S:'$D(^PS(50.605,PP,"TERMSTATUS",0)) ^PS(50.605,PP,"TERMSTATUS",0)="^50.60509DA^^"
 I DATE=DT S DA(1)=PP,DIC="^PS(50.605,"_PP_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.60509,DIC("DR")=".02////"_1 D FILE^DICN
 I DATE'=DT S DA(1)=PP,DIC="^PS(50.605,"_PP_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.60509,DIC("DR")=".02////"_0 D FILE^DICN
 Q
F991 S $P(^NDFK(5000.991,1,0),"^",2)=VUID,$P(^NDFK(5000.991,1,1,50.605,0),"^",2)=PP
 Q
F992 S JJJ=$P(^NDFK(5000.992,0),"^",3)+1,^NDFK(5000.992,JJJ,0)=$P(^PS(50.605,PP,"VUID"),"^")_"^"_50.605_"^"_PP_"^"_NME_"^"_MAST_"^"_DATE,^NDFK(5000.992,"B",$P(^PS(50.605,PP,"VUID"),"^"),JJJ)="",^NDFK(5000.992,"C",NME,JJJ)="" D DXX
 S $P(^NDFK(5000.992,0),"^",3)=JJJ,$P(^NDFK(5000.992,0),"^",4)=JJJ
 Q
DXX ; S ^NDFK(5000.992,"F",$P(^PS(50.605,PP,"VUID"),"^"),50.68,NME,JJJ)="" I $P(^NDFK(5000.992,JJJ,0),"^",6)=DT S DA=PP,DIE="^PS(50.605,",DR="99.98////"_1,$P(^NDFK(5000.992,JJJ,0),"^",5)=1
 Q
VAGN K DATE,JJJ
 S JJJ=$P(^NDFK(5000.992,0),"^",3)+1 F TT=0:0 S TT=$O(^PSNDF(50.6,TT)) Q:'TT  I '$D(^PSNDF(50.6,TT,"VUID")) S TERM=$P(^PSNDF(50.6,TT,0),"^"),DATE=$P($G(^PSNDF(50.6,TT,0)),"^",2) S:'$G(DATE) DATE=DT S MAST=1 D VAGNVUID,STUTS
 Q
VAGNVUID I '$D(^NDFK(5000.992,"C",TERM)) S DA=TT,DIE="^PSNDF(50.6,",DR="99.99////"_VUID D ^DIE S DA=TT,DIE="^PSNDF(50.6,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","VAGN",TT)=VUID D FILE991 S VUID=VUID+1
 I $D(^NDFK(5000.992,"C",TERM)) S IEN=$O(^NDFK(5000.992,"C",TERM,0)),DVUID=$P(^NDFK(5000.992,IEN,0),"^"),DA=TT,DIE="^PSNDF(50.6,",DR="99.99////"_DVUID D ^DIE S DA=TT,DIE="^PSNDF(50.6,",DR="99.98////"_1 D ^DIE S ^BT("PSNVUID","VAGN",TT)=DVUID
 D FILE992
 Q
STUTS S:'$D(^PSNDF(50.6,TT,"TERMSTATUS",0)) ^PSNDF(50.6,TT,"TERMSTATUS",0)="^50.6009DA^^"
 I DATE=DT S DA(1)=TT,DIC="^PSNDF(50.6,"_TT_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.6009,DIC("DR")=".02////"_1 D FILE^DICN
 I DATE'=DT S DA(1)=TT,DIC="^PSNDF(50.6,"_TT_",""TERMSTATUS"",",X=DATE,DIC(0)="L",DLAYGO=50.6009,DIC("DR")=".02////"_0 D FILE^DICN
 ; S (PSZ,ZZZ)=0 F  S ZZZ=$O(^PSNDF(50.6,TT,"TERMSTATUS",ZZZ)) Q:'ZZZ  S PSZ=ZZZ
 ; S PSZ=PSZ+1 S ^PSNDF(50.6,TT,"TERMSTATUS",PSZ,0)=DATE_"^"_1 S:DATE'=DT $P(^PSNDF(50.6,TT,"TERMSTATUS",PSZ,0),"^",2)=0 S ^PSNDF(50.6,TT,"TERMSTATUS","B",DATE,PSZ)=""
 ; S $P(^PSNDF(50.6,TT,"TERMSTATUS",0),"^",3)=PSZ,$P(^PSNDF(50.6,TT,"TERMSTATUS",0),"^",4)=PSZ D FILE991,FILE992
 Q
FILE991 S $P(^NDFK(5000.991,1,0),"^",2)=VUID,$P(^NDFK(5000.991,1,1,50.6,0),"^",2)=TT
 Q
FILE992 S JJJ=$P(^NDFK(5000.992,0),"^",3)+1,^NDFK(5000.992,JJJ,0)=$P(^PSNDF(50.6,TT,"VUID"),"^")_"^"_50.6_"^"_TT_"^"_TERM_"^"_MAST_"^"_DATE,^NDFK(5000.992,"B",$P(^PSNDF(50.6,TT,"VUID"),"^"),JJJ)="",^NDFK(5000.992,"C",TERM,JJJ)="" D INDX
 S $P(^NDFK(5000.992,0),"^",3)=JJJ,$P(^NDFK(5000.992,0),"^",4)=JJJ
 Q
INDX ; S ^NDFK(5000.992,"F",$P(^PSNDF(50.6,TT,"VUID"),"^"),50.6,TERM,JJJ)="" I $P(^NDFK(5000.992,JJJ,0),"^",6)=DT S DA=TT,DIE="^PSNDF(50.6,",DR="99.98////"_TT,$P(^NDFK(5000.992,JJJ,0),"^",5)=1
 Q
SAF ; W !,"HERE" F ZZZ=0:0 S ZZZ=$O(^NDFK(5000.992,"F",ZZZ)) Q:'ZZZ  S CNCPT="" F  S CNCPT=$O(^NDFK(5000.992,ZZZ,CNCPT,50.6)) Q:CNCPT=""  S EEE=$O(^NDFK(5000.992,"F",ZZZ,CNCPT,50.6,0)) I $P(^NDFK(5000.992,EEE,0),"^"5)=0 D SAF1
 Q
SAF1 ; S $P(^PSNDF(50.6,TT,"VUID"),"^",2)=1,^PSNDF(50.6,"AMASTERVUID",1,TT)="",$P(^NDFK(5000.992,JJJ,0),"^",5)=1
 Q
PFS N ZQ,DA,DIE,DR S ZQ=" " F  S ZQ=$O(^PSNDF(50.68,ZQ),-1) Q:$D(^(ZQ,"PFS"))  S DIE="^PSNDF(50.68,",DA=ZQ,X=600000+DA,DR="2000////"_X_";" D ^DIE
 K ZQ,DA,DIR,DR Q
FIX ;EXCLUSIONS
 S ZQ=0 F  S ZQ=$O(^PSNDF(50.68,ZQ)) Q:'ZQ  I $P($G(^(ZQ,9)),"^")="" S DA=ZQ,DIE="^PSNDF(50.68,",DR="31////0;" D ^DIE
 S ZQ=0 F  S ZQ=$O(^PS(50.606,ZQ)) Q:'ZQ  I $P($G(^(ZQ,1)),"^")="" S DA=ZQ,DIE="^PS(50.606,",DR="11////0;" D ^DIE
 K ZQ,DA,DIE,DR Q
KILL K DATE,DVUID,VUID,I,IEN,JJJ,LL,MAST,NAM,NAME,NME,PP,PSZ,TERM,TT,VUID,ZZZ
 Q