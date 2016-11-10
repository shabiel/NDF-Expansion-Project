NDFMERGE ;BIR/DMA-merge VA generics or VA products ;24 Sep 98 / 7:15 AM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
PROD ;MERGE PRODUCTS
 S DIC=50.68,DIC(0)="AEQMZ",DIC("A")="Select VA Product " D ^DIC G END:Y<0 S PRO1=+Y,PROD1=$P(Y,"^",2)
 S DIC("A")="Merge into VA Product ",DIC("S")="I $P(Y,""^"")'=PRO1" D ^DIC G END:Y<0 S PRO2=+Y,PROD2=$P(Y,"^",2)
 W !,"This procedure is very difficult to reverse",! S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are you sure you want to merge "_PROD1_" into "_PROD2_" " D ^DIR G END:$D(DIRUT),PROD:'Y
 S ZTIO="",(ZTSAVE("PRO1"),ZTSAVE("PRO2"))="",ZTRTN="ENP^NDFMERGE",ZTDESC="MERGE VA PRODUCTS" D ^%ZTLOAD
 K PRO1,PROD1,PRO2,PROD2,X,Y,DIC,DIR,ZTSAVE G PROD
 ;
ENP ;entry for merging products
 S NDC=0 F  S NDC=$O(^PSNDF(50.68,"ANDC",PRO1,NDC)) Q:'NDC  S DIE="^PSNDF(50.67,",DA=NDC,DR="5////"_PRO2_";" D ^DIE
 S DA=PRO1,DIE="^PSNDF(50.68,",DR="21////"_DT_";" D ^DIE S NDF=$O(^NDFK(5000.2," "),-1)+1,^(NDF,0)=PRO1
 S ZTREQ="@" Q
 ;
GEN ;MERGE GENERICS
 S DIC=50.6,DIC(0)="AQEMZ",DIC("A")="Select VA Generic " D ^DIC G END:Y<0 S GEN1=+Y,GENE1=$P(Y,"^",2)
 S DIC("A")="Merge into VA Generic ",DIC("S")="I $P(Y,""^"")'=GEN1" D ^DIC G END:Y<0 S GEN2=+Y,GENE2=$P(Y,"^",2)
 W !,"This procedure is very difficult to reverse",! S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are you sure you want to merge "_GENE1_" into "_GENE2_" " D ^DIR G END:$D(DIRUT),GEN:'Y
  S ZTIO="",(ZTSAVE("GEN1"),ZTSAVE("GEN2"))="",ZTRTN="ENG^NDFMERGE",ZTDESC="MERGE VA GENERICS" D ^%ZTLOAD
 K GEN1,GENE1,GEN2,GENE2,X,Y,DIC,DIR,ZTSAVE G GEN
 ;
ENG ;entry for merging generics
 S PRO=0 F  S PRO=$O(^PSNDF(50.6,"APRO",GEN1,PRO)) Q:'PRO  S DIE="^PSNDF(50.68,",DA=PRO,DR=".05////"_GEN2_";" D ^DIE
 S DA=GEN1,DIE="^PSNDF(50.6,",DR="1////"_DT_";" D ^DIE S NDF=$O(^NDFK(5000.3," "),-1)+1,^(NDF,0)=GEN1
 S ZTREQ="@" Q
 ;
END K DA,DIC,DIE,DIR,DIRUT,GEN1,GEN2,GENE1,GENE2,NDC,PRO,PRO1,PRO2,PROD1,PROD2,X,Y,ZTDESC,ZTRTN,ZTSAVE Q
