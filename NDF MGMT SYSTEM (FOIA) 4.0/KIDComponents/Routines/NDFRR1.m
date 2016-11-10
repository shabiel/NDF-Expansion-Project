NDFRR1 ;BIR/RSB-NDF ENTER EDIT PROMPTS ; 03 Sep 98 / 2:08 PM
 ;;4.0; NDF MANAGEMENT;; 1 Jan 99
 ;
GET(F1,F2,DEF,REQ,PROM)         ;
 ;  Input F1  -  File number
 ;  Input F2  -  Field number
 ;  Input DEF -  Default value for prompt
 ;  Input REQ -  Is answer required? 0 or 1
 N NDFX K NDFABORT
GETA D PROM(F1,F2,DEF,PROM) R NDFX:DTIME I NDFX="^"!('$T) S NDFABORT=1 Q "^"
 I (NDFX="")&($L(DEF)) S NDFX=DEF G GETB
 I $G(REQ)=0&(NDFX="")&('$L(DEF)) Q NDFX
 I $G(REQ)=1&(NDFX="")&('$L(DEF)) W "  (Required)" G GETA
 I $G(REQ)=1&(NDFX="@") W "   (Required)" H .5 G GETA
 I NDFX="?" D HLP(F1,F2) G GETA
 I NDFX="??" D HLP2(F1,F2) G GETA
 I F1=50.68&(F2=".01")&(NDFX=" ") D
 .S NDFX=$S($D(NDFSPACE):NDFSPACE,1:NDFX) W "  ",NDFX
GETB ;I '$$CK(F1,F2,NDFX) W "  ??",$C(7) D HLP(F1,F2) G GETA
 I F1=50.68&(F2=".01") S NDFSPACE=NDFX
 Q NDFX
 ;
PROM(F1,F2,DEF,PROM)        ;
 N NDFAM,NDFT D FIELD^DID(F1,F2,"","LABEL","NDFAM")
 ;S NDFT="$T("_F1_F2_"^NDFRR1)",@("NDFT="_NDFT),NDFT=$P(NDFT,";;",2)
 ;W !,$S($L(NDFT):NDFT,1:NDFAM("LABEL"))_": "
 W !,$S($L(PROM):PROM,1:NDFAM("LABEL"))_": "
 I $L(DEF) W " ",DEF,"//"
 Q
 ;
 ;
HLP(F1,F2) ;
 ; Input: F1 - File #
 ;        F2 - Field #
 N F,F0,F3,NDFD,NDFHP,NDFT
 D FIELD^DID(F1,F2,"","HELP-PROMPT","NDFHP")
 I $D(NDFHP("HELP-PROMPT")) S F=$G(NDFHP("HELP-PROMPT")) W !?5 F F0=1:1:$L(F," ") S F3=$P(F," ",F0) W:$L(F3)+$X>78 !?5 W F3_" "
 D FIELD^DID(F1,F2,"","DESCRIPTION","NDFD")
 F F=0:0 S F=$O(NDFD("DESCRIPTION",F)) Q:'F  I $D(NDFD("DESCRIPTION",F)) W !?2,NDFD("DESCRIPTION",F)
 Q
 ;
HLP2(F1,F2) ;
 ; Input: F1 - File #
 ;        F2 - Field #
 N F,F0,F3,NDFD,NDFHP,NDFT
 D FIELD^DID(F1,F2,"","HELP-PROMPT","NDFHP")
 I $D(NDFHP("HELP-PROMPT")) S F=$G(NDFHP("HELP-PROMPT")) W !?5 F F0=1:1:$L(F," ") S F3=$P(F," ",F0) W:$L(F3)+$X>78 !?5 W F3_" "
 D FIELD^DID(F1,F2,"","DESCRIPTION","NDFD")
 F F=0:0 S F=$O(NDFD("DESCRIPTION",F)) Q:'F  I $D(NDFD("DESCRIPTION",F)) W !?2,NDFD("DESCRIPTION",F)
 W ! D FIELD^DID(F1,F2,"","XECUTABLE HELP","NDFT") I $D(NDFT("XECUTABLE HELP")) X NDFT("XECUTABLE HELP")
 Q
 ;
DIR(F1,F2)         ;
 ; Input F1 - File #
 ; Input F2 - Field #
 N DIR S DIR(0)=F1_","_F2 D ^DIR
 Q Y
 ;
 ;
CK(F1,F2,F3)          ;
 ; Input F1 - File #
 ; Input F2 - Field #
 N ANS D CHK^DIE(F1,F2,"",F3,.ANS)
 Q $S(ANS="^":0,$D(ANS):1)
 ;
ADD(X,X1) ;
 S DIR("A")="Are you adding """_X_""" as a new "_X1,DIR(0)="Y"
 S DIR("B")="Yes" N Y D ^DIR
 Q Y
 ;
SET(X,X1)          ;
 ; place in ^TMP("NDFR",$J
 S ^TMP("NDFR",$J,X)=X1
 Q
