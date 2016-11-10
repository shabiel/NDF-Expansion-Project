NDFEXMPT ;BIR/WRT-REPORT TO DISPLAY EXEMPTIONS FOR DDI CHECKING IN VA PRODUCT FILE ; 05/07/03 10:36
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 D RPT K ACT,NODE
 Q
RPT W !!,"This report gives you a printed copy of active VA Products marked as",!,"exclude from Drug-Drug Interaction checking.",!,"You may queue the report to print, if you wish.",!
 S DIC="^PSNDF(50.68,",L=0,FLDS="[NDFEXMP1]",BY="@.01",DHD="VA Products Marked As Exclude From Drg-Drg Interaction Checking" D EN1^DIP
 Q
