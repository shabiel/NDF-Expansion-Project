NDFPURGE ;BIR/DMA-PURGE NDF MESSAGE FILES ; 21 Jan 2010  7:49 AM
 ;;4.0; NDF MANAGEMENT;**108,262**; 1 Jan 99
 ;
 N LNCNT,DIR S LNCNT=0 W !!,"This will purge all data in the following files",!
 F FILE=5000.2:0.1:5000.9,5000.23,5000.56,5000.506:0.001:5000.509,5000.608,5000.91,5000.92 D
 . W !,?5,$P($G(^NDFK(FILE,0)),"^")," (#",FILE,")"
 . S LNCNT=LNCNT+1
 . I '(LNCNT#10) W ! S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR W !
 ;
 W !!,"This option should be run after each update transmission",!,"and before entry is started on the next transmission",!
 S (J,DA)=0 F  S DA=$O(^NDFK(5000,1,1,DA)) Q:'DA  S J=$P(^(DA,0),"^",2)'=$O(^DIA(DA," "),-1)+J
 I J W !,"It appears that data has been entered since the last transmission",! S DIR(0)="Y",DIR("A")="Are you SURE you want to purge",DIR("B")="NO" D ^DIR K DIR Q:$D(DIRUT)  Q:'Y
 S DIR(0)="Y",DIR("A")="Are you ready to purge now" D ^DIR K DIR Q:'Y
 S DIR(0)="Y",DIR("A")="Do you want a copy of the mail message",DIR("B")="YES" D ^DIR K DIR Q:$D(DIRUT)  I Y S XMSUB="MESSAGE TO USERS",XMDUZ="NDF MANAGER",XMTEXT="^NDFK(5000,1,2,",XMY(DUZ)="" D ^XMD D
 . S XMSUB="INTERACTION MESSSAGE",XMDUZ="NDF MANAGER",XMTEXT="^NDFK(5000,1,3,",XMY(DUZ)="" D ^XMD
 ;
 ; Purging entries
 F FILE=5000.2:0.1:5000.9,5000.23,5000.56,5000.506:0.001:5000.509,5000.608,5000.91,5000.92 D
 . S LOC=0 F  S LOC=$O(^NDFK(FILE,LOC)) Q:'LOC  D
 . . S DA=LOC,DIK="^NDFK("_FILE_"," D ^DIK K DIK,DIAU
 ;
 K ^NDFK(5000,1,2) ;GET THE MESSAGE
 K ^NDFK(5000,1,3) ;AND THE SECOND MESSAGE
 K ^NDFK(5000,1,4) ;GET THE WORD PROCESSING FIELDS
 K DA,FIL,J,LOC,XMDUZ,XMSUB,XMTEXT,XMY,Y
 Q
