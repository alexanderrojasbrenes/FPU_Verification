class stimulus;
  rand logic[31:0]  valueA;
  rand logic[31:0]  valueB;
  
  constraint cst_valueA {valueA[30:23] < 137; valueA[30:23] > 133;}
  constraint cst_valueB {valueB[30:23] < 137; valueB[30:23] > 133;}
endclass