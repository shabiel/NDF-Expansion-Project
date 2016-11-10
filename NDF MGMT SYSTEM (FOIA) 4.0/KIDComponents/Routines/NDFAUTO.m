NDFAUTO ;BIRM/WRT - Auto marking of VA Products to be excluded from Drug-Drug Interaction checking.; 05/19/03 10:01
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
START ; Begin update process
 W !!,"This option will run the auto-marking process. This will be accomplished by",!,"taking entries in ^TMP global and mark those IENs in VA PRODUCT file (#50.68) marking them with a flag",!
 W "to exclude from drug-drug interaction checking."
 W ! S DIR("A")="Are you sure you are ready to proceed? "
 S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) Q
 I Y=0 Q
 D LOOP W !!,"**** OK, I'm through. Please REVIEW your matches. ****"
 K IFN
 Q
 ;
LOOP ;
 F IFN=0:0 S IFN=$O(^DONLIST1(IFN)) Q:'IFN  U IO W:'(IFN#100) "." D STUFF
 Q
DELETE S DA=IFN S DIE="^PSNDF(50.68,",DR="23////"_"@" D ^DIE
 Q
STUFF K DA,DIE S DA=IEN S DIE="^PSNDF(50.68,",DR="23////"_"1" D ^DIE
 Q
