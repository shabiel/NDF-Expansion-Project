NDFPMI ;BIR/DMA - LIST OF NEWLY LINKED PRODUCTS ;14 Apr 99 / 2:47 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 K ^TMP($J),^TMP("NDF",$J) S DA=0
 F  S DA=$O(^NDFK(5000.6,DA)) Q:'DA  I $P(^(DA,0),"^",2) S ^TMP($J,$P(^PSNDF(50.68,DA,0),"^"))=""
 Q:'$D(^TMP($J))
 S ^TMP("NDF",$J,1)="The following products have been linked to PMI sheets",^(2)=" "
 S DA="",J=3 F  S DA=$O(^TMP($J,DA)) Q:DA=""  S ^TMP("NDF",$J,J)=DA,J=J+1
 ;
 K XMY S XMSUB="NEWLY LINKED PRODUCTS",XMDUZ="NDF MANAGER",XMY(DUZ)="",XMTEXT="^TMP(""NDF"",$J," N DIFROM D ^XMD
 K DA,J,XMDUZ,XMSUB,XMTEXT,XMY,^TMP($J),^TMP("NDF",$J) Q
