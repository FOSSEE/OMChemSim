***************
Developer Guide
***************

 - Class/Model names should be written in upper camel case, e.g., "HeatExchanger"
 - For Variables/Constants, first one/ two letter should specify the thermophysical property as mentioned below.

+------------------+---------------------+
| Property         | Variable Notation   |
+==================+=====================+
|Pressure          | P                   |
+------------------+---------------------+
|Temperature       | T                   |
+------------------+---------------------+
|Molar Flow        | F                   |
+------------------+---------------------+
|Mass Flow         | Fm                  |
+------------------+---------------------+
|Volumetric Flow   | Fv                  |
+------------------+---------------------+
|Efficiency        | Eff                 |
+------------------+---------------------+
|Molar Enthalpy    | H                   |
+------------------+---------------------+
|Specific Enthalpy | Hm                  |
+------------------+---------------------+
|Energy Flow       | Q                   |
+------------------+---------------------+
|Molar Entropy     | S                   |
+------------------+---------------------+
|Specific Entropy  | Sm                  |
+------------------+---------------------+
|Mole Fraction     | x                   |
+------------------+---------------------+
|Mass Fraction     | xm                  |
+------------------+---------------------+




 - To denote a variable of specific phase, liq is used to represent liquid and vap is to be used to represent vapor. 
   For example, vapor phase mole fraction is to be denoted by using xvap.
 - If a variable/constant is of array type, the array notation should come at the end and should be separated from the 
   variable by an underscore. Following notation are to be used for array. For example, if a variable is to represent 
   molar flow rate of components in different phases, it should be written as F_pc[3,Nc]


