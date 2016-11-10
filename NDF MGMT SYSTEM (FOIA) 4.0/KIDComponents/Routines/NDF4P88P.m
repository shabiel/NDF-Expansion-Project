NDF4P88P ;BIR/DMA-pretransport routine for gender specific ; 19 Aug 04
 ;;0.0; Internal;; 19 Aug 04
 S DA=0,LINE="" F  S DA=$O(^PS(50.625,DA)) Q:'DA  I $G(^(DA,2))]"" S LINE=LINE_DA_"^"_^(2)_"^"
 S @XPDGREF@(1)=LINE
 Q
