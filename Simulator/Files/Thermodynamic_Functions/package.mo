within Simulator.Files;

package Thermodynamic_Functions
  function Psat
    /*Returns vapor pressure at given temperature*/
    input Real VP[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Vp(unit = "Pa") "Vapor pressure";
  algorithm
    Vp := exp(VP[2] + VP[3] / T + VP[4] * log(T) + VP[5] .* T .^ VP[6]);
  end Psat;

  function LiqCpId
    /*Calculates specific heat of liquid at given Temperature*/
    input Real LiqCp[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Cp(unit = "J/mol") "Specific heat of liquid";
  algorithm
    Cp := (LiqCp[2] + exp(LiqCp[3] / T + LiqCp[4] + LiqCp[5] * T + LiqCp[6] * T ^ 2)) / 1000;
  end LiqCpId;

  function VapCpId
    /*Calculates Vapor Specific Heat*/
    input Real VapCp[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Cp(unit = "J/mol.K") "specific heat";
  algorithm
    Cp := (VapCp[2] + exp(VapCp[3] / T + VapCp[4] + VapCp[5] * T + VapCp[6] * T ^ 2)) / 1000;
  end VapCpId;

  function HV
    /*Returns Heat of Vaporization*/
    input Real HOV[6] "from chemsep database";
    input Real Tc(unit = "K") "Critical Temperature";
    input Real T(unit = "K") "Temperature";
    output Real Hv(unit = "J/mol") "Heat of Vaporization";
  protected
    Real Tr = T / Tc;
  algorithm
    if T < Tc then
      Hv := HOV[2] * (1 - Tr) ^ (HOV[3] + HOV[4] * Tr + HOV[5] * Tr ^ 2 + HOV[6] * Tr ^ 3) / 1000;
    else
      Hv := 0;
    end if;
  end HV;

  function HLiqId
    /* Calculates Enthalpy of Ideal Liquid*/
    input Real SH(unit = "J/kmol") "from chemsep database std. Heat of formation";
    input Real VapCp[6] "from chemsep database";
    input Real HOV[6] "from chemsep database";
    input Real Tc "critical temp, from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Ent(unit = "J/mol") "Molar Enthalpy";
  algorithm
    Ent := HVapId(SH, VapCp, HOV, Tc, T) - Thermodynamic_Functions.HV(HOV, Tc, T);
  end HLiqId;

  function HVapId
    /* Calculates enthalpy of ideal vapor */
    input Real SH(unit = "J/kmol") "from chemsep database std. Heat of formation";
    input Real VapCp[6] "from chemsep database";
    input Real HOV[6] "from chemsep database";
    input Real Tc "critical temp, from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Ent(unit = "J/mol") "Molar Enthalpy";
  protected
    Integer n = 100;
    Real Cp[n - 1];
  algorithm
    for i in 1:n - 1 loop
      Cp[i] := VapCpId(VapCp, 298.15 + i * (T - 298.15) / n);
    end for;
    Ent := (T - 298.15) * (VapCpId(VapCp, T) / 2 + sum(Cp[:]) + VapCpId(VapCp, 298.15) / 2) / n;
  end HVapId;

  function SId
    import Modelica.Constants.*;
    
    input Real AS;
    input Real VapCp[6];
    input Real HOV[6];
    input Real Tb;
    input Real Tc;
    input Real T;
    input Real P;
    input Real x;
    input Real y;
    output Real Sliq, Svap;
  protected
    parameter Real Tref = 298.15, Pref = 101325;
    Real Entr, Cp[n - 1];
    parameter Integer n = 10;
  
  algorithm
    Entr := 0;
    for i in 1:n - 1 loop
      Cp[i] := Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, 298.15 + i * (T - 298.15) / n) / (298.15 + i * (T - 298.15) / n);
    end for;
    if T >= Tref then
      Entr := (T - 298.15) * (Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, T) / (2 * T) + sum(Cp[:]) + Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, 298.15) / (2 * 298.15)) / n;
    else
      Entr := -(T - 298.15) * (Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, T) / (2 * T) + sum(Cp[:]) + Simulator.Files.Thermodynamic_Functions.VapCpId(VapCp, 298.15) / (2 * 298.15)) / n;
    end if;
    if x > 0 and y > 0 then
      Sliq := Entr - R * log(P / Pref) - R * log(x) - HV(HOV, Tc, T) / T;
      Svap := Entr - R * log(P / Pref) - R * log(y);
    elseif x <= 0 and y <= 0 then
      Sliq := 0;
      Svap := 0;
    elseif x == 0 then
      Sliq := 0;
      Svap := Entr - R * log(P / Pref) - R * log(y);
    elseif y == 0 then
      Sliq := Entr - R * log(P / Pref) - R * log(x) - HV(HOV, Tc, T) / T;
      Svap := 0;
    else
      Sliq := 0;
      Svap := 0;
    end if;
  end SId;

































  function Dens
    //This function is developed by swaroop katta
    //this function calculates density of pure componets as a function of temperature using chemsep database.
    input Real LiqDen[6], TC, T, P;
    output Real density "units kmol/m3";
  protected
    Real Tr;
  protected
    parameter Real R = 8.314 "gas constant";
  algorithm
    Tr := T / TC;
    if T < TC then
      if LiqDen[1] == 105 then
        density := LiqDen[2] / LiqDen[3] ^ (1 + (1 - T / LiqDen[4]) ^ LiqDen[5]) * 1000;
      elseif LiqDen[1] == 106 then
        density := LiqDen[2] * (1 - Tr) ^ (LiqDen[3] + LiqDen[4] * Tr + LiqDen[5] * Tr ^ 2 + LiqDen[6] * Tr ^ 3) * 1000;
      end if;
    else
      density := P / (R * T * 1000);
    end if;
  end Dens;

function BIPNRTL
input Integer NOC;
input String CAS[NOC];
output Real value[NOC, NOC, 2];
protected
constant String underscore = "_";
String c[NOC, NOC];
String d[NOC, NOC];
constant String CAS1_CAS2[352] = {"67-56-1_56-23-5", "67-56-1_75-25-2", "67-66-3_67-56-1", "75-09-2_67-56-1", "67-56-1_75-12-7", "151-67-7_67-56-1", "75-01-4_67-56-1", "67-56-1_75-05-8", "67-56-1_107-06-2", "67-56-1_64-19-7", "107-31-3_67-56-1", "67-56-1_64-17-5", "67-56-1_67-68-5", "124-40-3_67-56-1", "67-64-1_67-56-1", "123-38-6_67-56-1", "75-56-9_67-56-1", "79-20-9_67-56-1", "67-56-1_79-09-4", "67-56-1_68-12-2", "67-56-1_71-23-8", "109-87-5_67-56-1", "67-56-1_110-02-1", "106-99-0_67-56-1", "67-56-1_96-33-3", "115-11-7_67-56-1", "67-56-1_78-93-3", "67-56-1_109-99-9", "67-56-1_123-91-1", "67-56-1_141-78-6", "67-56-1_126-33-0", "106-97-8_67-56-1", "67-56-1_71-36-3", "67-56-1_78-92-2", "60-29-7_67-56-1", "67-56-1_110-63-4", "67-56-1_110-86-1", "542-92-7_67-56-1", "78-79-5_67-56-1", "1574-41-0_67-56-1", "2004-70-8_67-56-1", "67-56-1_80-62-6", "513-35-9_67-56-1", "67-56-1_563-80-4", "67-56-1_110-89-4", "1634-04-4_67-56-1", "67-56-1_392-56-3", "67-56-1_108-90-7", "67-56-1_71-43-2", "67-56-1_62-53-3", "67-56-1_109-06-8", "67-56-1_108-99-6", "67-56-1_108-89-4", "67-56-1_110-83-8", "67-56-1_110-82-7", "592-41-6_67-56-1", "67-56-1_123-86-4", "67-56-1_110-54-3", "67-56-1_121-44-8", "67-56-1_108-88-3", "67-56-1_108-48-5", "67-56-1_592-76-7", "67-56-1_108-87-2", "67-56-1_142-82-5", "67-56-1_100-41-4", "67-56-1_108-38-3", "67-56-1_106-42-3", "67-56-1_111-66-0", "67-56-1_111-65-9", "67-56-1_540-84-1", "56-23-5_67-56-1", "67-66-3_64-17-5", "75-09-2_64-17-5", "64-17-5_127-18-4", "64-17-5_75-05-8", "64-17-5_107-06-2", "64-17-5_64-19-7", "64-17-5_107-21-1", "124-40-3_64-17-5", "67-64-1_64-17-5", "79-20-9_64-17-5", "64-17-5_67-63-0", "64-17-5_110-02-1", "108-05-4_64-17-5", "64-17-5_78-93-3", "109-99-9_64-17-5", "64-17-5_123-91-1", "141-78-6_64-17-5", "64-17-5_126-33-0", "64-17-5_78-92-2", "60-29-7_64-17-5", "64-17-5_78-83-1", "109-73-9_64-17-5", "64-17-5_110-86-1", "78-79-5_64-17-5", "64-17-5_80-62-6", "513-35-9_64-17-5", "64-17-5_563-80-4", "64-17-5_109-60-4", "78-78-4_64-17-5", "109-66-0_64-17-5", "64-17-5_123-51-3", "64-17-5_108-86-1", "64-17-5_108-90-7", "64-17-5_71-43-2", "64-17-5_62-53-3", "64-17-5_108-99-6", "64-17-5_110-82-7", "592-41-6_64-17-5", "64-17-5_108-93-0", "64-17-5_123-86-4", "110-54-3_64-17-5", "64-17-5_111-43-3", "64-17-5_121-44-8", "64-17-5_108-88-3", "64-17-5_100-66-3", "64-17-5_108-48-5", "64-17-5_628-63-7", "64-17-5_142-82-5", "64-17-5_100-41-4", "64-17-5_106-42-3", "64-17-5_111-65-9", "64-17-5_540-84-1", "64-17-5_544-76-3", "64-17-5_112-80-1", "56-23-5_71-23-8", "71-23-8_127-18-4", "79-01-6_71-23-8", "107-06-2_71-23-8", "71-23-8_64-19-7", "124-40-3_71-23-8", "71-23-8_79-09-4", "67-63-0_71-23-8", "71-23-8_109-86-4", "107-10-8_71-23-8", "71-23-8_79-41-4", "78-93-3_71-23-8", "109-99-9_71-23-8", "109-69-3_71-23-8", "71-23-8_78-83-1", "109-73-9_71-23-8", "71-23-8_110-86-1", "71-23-8_80-62-6", "71-23-8_109-60-4", "71-23-8_123-51-3", "392-56-3_71-23-8", "71-23-8_108-90-7", "71-43-2_71-23-8", "71-23-8_109-06-8", "71-23-8_108-99-6", "71-23-8_108-89-4", "110-82-7_71-23-8", "110-54-3_71-23-8", "71-23-8_142-84-7", "121-44-8_71-23-8", "71-23-8_107-46-0", "71-23-8_108-88-3", "71-23-8_108-48-5", "71-23-8_142-82-5", "71-23-8_100-41-4", "71-23-8_111-65-9", "71-23-8_124-18-5", "71-23-8_112-30-1", "67-56-1_7732-18-5", "67-56-1_67-66-3", "67-56-1_64-17-5", "67-56-1_67-64-1", "67-56-1_71-43-2", "67-56-1_110-82-7", "67-56-1_108-88-3", "67-56-1_142-82-5", "7732-18-5_67-64-1", "7732-18-5_78-93-3", "7732-18-5_108-95-2", "64-17-5_7732-18-5", "64-17-5_67-66-3", "64-17-5_67-64-1", "64-17-5_78-93-3", "64-17-5_71-43-2", "64-17-5_110-82-7", "64-17-5_108-88-3", "64-17-5_142-82-5", "64-17-5_106-42-3", "67-64-1_67-66-3", "67-64-1_71-43-2", "67-64-1_108-95-2", "67-64-1_110-82-7", "67-64-1_108-88-3", "78-93-3_71-43-2", "78-93-3_110-82-7", "78-93-3_108-88-3", "78-93-3_142-82-5", "71-43-2_67-66-3", "71-43-2_108-95-2", "71-43-2_108-88-3", "71-43-2_106-42-3", "108-88-3_67-66-3", "108-88-3_106-42-3", "108-87-2_108-95-2", "7732-18-5_79-34-5", "109-87-5_7732-18-5", "107-10-8_7732-18-5", "78-93-3_7732-18-5", "78-84-2_7732-18-5", "109-99-9_7732-18-5", "7732-18-5_123-91-1", "141-78-6_7732-18-5", "7732-18-5_126-33-0", "7732-18-5_127-19-5", "7732-18-5_110-91-8", "7732-18-5_71-36-3", "78-83-1_7732-18-5", "75-65-0_7732-18-5", "60-29-7_7732-18-5", "7732-18-5_110-63-4", "7732-18-5_513-85-9", "7732-18-5_111-46-6", "109-73-9_7732-18-5", "109-89-7_7732-18-5", "7732-18-5_98-01-1", "7732-18-5_110-86-1", "7732-18-5_120-94-5", "7732-18-5_123-51-3", "7732-18-5_75-85-4", "7732-18-5_108-95-2", "7732-18-5_62-53-3", "7732-18-5_109-06-8", "7732-18-5_108-99-6", "7732-18-5_108-89-4", "7732-18-5_100-63-0", "7732-18-5_108-94-1", "7732-18-5_141-79-7", "7732-18-5_108-93-0", "7732-18-5_123-86-4", "7732-18-5_123-42-2", "108-20-3_7732-18-5", "7732-18-5_111-27-3", "7732-18-5_626-93-7", "7732-18-5_111-76-2", "121-44-8_7732-18-5", "7732-18-5_100-51-6", "7732-18-5_108-48-5", "7732-18-5_123-92-2", "7732-18-5_98-86-2", "7732-18-5_91-22-5", "7732-18-5_98-82-8", "56-23-5_71-43-2", "71-43-2_75-25-2", "67-66-3_71-43-2", "74-88-4_71-43-2", "71-43-2_75-52-5", "75-15-0_71-43-2", "76-13-1_71-43-2", "71-43-2_127-18-4", "71-43-2_79-01-6", "71-43-2_76-01-7", "71-43-2_79-34-5", "71-55-6_71-43-2", "71-43-2_106-93-4", "71-43-2_107-06-2", "75-03-6_71-43-2", "71-43-2_123-39-7", "71-43-2_79-24-3", "71-43-2_67-68-5", "71-43-2_107-15-3", "71-43-2_68-12-2", "71-43-2_108-03-2", "71-43-2_79-46-9", "71-43-2_110-02-1", "109-73-9_71-43-2", "75-64-9_71-43-2", "109-89-7_71-43-2", "71-43-2_110-86-1", "71-43-2_392-56-3", "71-43-2_106-46-7", "71-43-2_108-86-1", "71-43-2_108-90-7", "71-43-2_462-06-6", "71-43-2_98-95-3", "71-43-2_62-53-3", "71-43-2_108-91-8", "71-43-2_121-44-8", "71-43-2_100-47-0", "71-43-2_108-88-3", "71-43-2_100-60-7", "71-43-2_100-42-5", "71-43-2_100-41-4", "71-43-2_108-38-3", "71-43-2_106-42-3", "71-43-2_91-66-7", "71-43-2_98-82-8", "71-43-2_103-65-1", "71-43-2_92-06-8", "56-23-5_108-88-3", "67-66-3_108-88-3", "75-15-0_108-88-3", "79-01-6_108-88-3", "75-05-8_108-88-3", "624-83-9_108-88-3", "107-06-2_108-88-3", "108-88-3_79-24-3", "108-88-3_67-68-5", "108-88-3_107-15-3", "107-12-0_108-88-3", "108-88-3_68-12-2", "110-02-1_108-88-3", "108-88-3_126-33-0", "109-89-7_108-88-3", "108-88-3_110-86-1", "392-56-3_108-88-3", "108-88-3_108-86-1", "108-88-3_108-90-7", "462-06-6_108-88-3", "108-88-3_98-95-3", "108-88-3_109-06-8", "108-88-3_108-99-6", "108-88-3_100-47-0", "108-88-3_100-41-4", "108-88-3_106-42-3", "107-13-1_100-42-5", "100-41-4_100-42-5", "100-42-5_103-65-1", "56-23-5_100-41-4", "75-05-8_100-41-4", "107-13-1_100-41-4", "109-89-7_100-41-4", "108-90-7_100-41-4", "100-41-4_98-95-3", "100-41-4_62-53-3", "100-41-4_98-82-8", "100-41-4_104-51-8", "56-23-5_108-38-3", "108-38-3_68-12-2", "110-86-1_108-38-3", "108-38-3_62-53-3", "106-42-3_108-38-3", "107-06-2_95-47-6", "107-15-3_95-47-6", "95-47-6_68-12-2", "56-23-5_106-42-3", "75-05-8_106-42-3", "107-06-2_106-42-3", "106-42-3_68-12-2", "392-56-3_106-42-3", "108-90-7_106-42-3", "106-42-3_62-53-3", "56-23-5_98-82-8", "103-65-1_98-95-3", "95-63-6_526-73-8", "104-51-8_98-95-3", "99-87-6_62-53-3", "91-57-6_90-12-0"};

constant Real BI_Values[352, 3] = {{378.8254, 1430.7379, 0.2892}, {879.0968, 1063.6098, 0.6381}, {1414.2712, -141.8030, 0.2949}, {1560.0282, 441.3372, 0.6234}, {617.5847, -153.4695, 0.3003}, {9870.3530, -6982.8569, 0.187e-1}, {1789.7165, -34.9448, 0.2912}, {343.7042, 314.5879, 0.2981}, {348.6035, 1020.1431, 0.2921}, {16.6465, -217.1261, 0.3051}, {584.5720, 298.5567, 0.2962}, {-327.9991, 376.2667, 0.3057}, {-168.3182, -497.4171, 0.3079}, {-1018.1430, -54.3882, 0.3134}, {184.2662, 226.5580, 0.3009}, {1046.6524, -865.2660, 0.3084}, {924.8499, -61.1796, 0.2986}, {381.4559, 346.5360, 0.2965}, {-50.1450, -78.0859, 0.3056}, {-124.0904, 0.3428, 09.1633}, {24.9003, 9.5349, 0.3011}, {608.9115, 712.0226, 0.7259}, {-90.1051, 1217.1035, 0.2976}, {1353.0599, 610.8292, 0.4670}, {676.8360, 169.9831, 0.2958}, {1333.6000, 556.3608, 0.3697}, {307.4271, 217.9098, 0.3003}, {169.4153, 383.1579, 0.3002}, {607.4050, 76.7683, 0.2985}, {345.5416, 420.7355, 0.2962}, {1069.2756, 906.5741, 0.7182}, {1440.1498, 1053.7716, 0.4647}, {793.8173, -486.3299, 0.2483}, {-308.5610, 285.4420, 0.3036}, {705.9989, 211.1580, 0.2953}, {446.9520, -450.5858, 0.3152}, {-45.0888, 84.1956, 0.3027}, {1541.9324, 736.0352, 0.4515}, {1445.6425, 543.5270, 0.4260}, {1545.3339, 799.1289, 0.4753}, {1514.2761, 782.1729, 0.4657}, {590.2790, 380.8401, 0.2963}, {1355.6853, 660.9164, 0.3381}, {642.3761, -6.2901, 0.2987}, {590.8820, -1169.7242, 0.1387}, {851.4954, 465.8360, 0.8178}, {930.5910, 1244.1303, 0.4701}, {857.0852, 1348.0903, 0.4707}, {721.6136, 1158.5131, 0.4694}, {407.7440, 117.2473, 0.3008}, {226.0820, -385.6823, 0.3095}, {-163.4505, -86.1482, 0.3075}, {304.2242, -452.3483, 0.3053}, {1178.5792, 1618.9792, 0.4568}, {1315.1631, 1497.2135, 0.4222}, {1222.6032, 1145.1085, 0.4402}, {328.2162, 453.0017, 0.2961}, {1619.3829, 1622.2911, 0.4365}, {-476.8503, 1126.1143, 0.2874}, {939.7275, 1090.9297, 0.4643}, {-273.3320, 59.6250, 0.3051}, {1313.5497, 1143.9059, 0.4163}, {1444.5850, 1719.4586, 0.4397}, {1500.2043, 1519.3346, 0.4277}, {1080.1231, 1038.1572, 0.4251}, {991.1609, 822.1357, 0.2910}, {974.6545, 851.1070, 0.2921}, {1456.3583, 1147.8132, 0.4396}, {1681.6918, 1511.4353, 0.4381}, {1447.0909, 1386.4703, 0.4313}, {1339.9000, 488.6648, 0.4622}, {1438.3602, -327.5518, 0.3023}, {1332.8036, -153.0761, 0.3057}, {685.8542, 807.5935, 0.2900}, {529.7267, 338.1632, 0.2964}, {333.3502, 939.3870, 0.2926}, {-34.1971, -190.7763, 0.3050}, {1644.0484, -203.7691, 0.3704}, {-1224.5739, 370.7683, 0.3105}, {36.2965, 434.8228, 0.2987}, {188.3139, 158.0118, 0.3013}, {690.1392, -529.3472, 0.3125}, {222.3096, 1057.7115, 0.2918}, {505.1637, 320.7403, 0.2959}, {64.4957, 463.1931, 0.3010}, {661.3708, -200.6915, 0.3015}, {505.5637, 111.8389, 0.2988}, {305.6041, 330.5105, 0.2988}, {1195.1601, 705.0897, 0.5676}, {-559.8205, 802.5411, 0.2721}, {763.6707, 71.1984, 0.2946}, {53.1671, 82.0442, 0.3023}, {-612.3956, -5.7834, 0.3062}, {163.6655, -169.9802, 0.3017}, {1402.5377, 653.4866, 0.5056}, {456.9676, 386.5893, 0.2963}, {1412.7516, 674.7726, 0.4569}, {-54.0946, 639.6806, 0.3009}, {760.4933, 129.3970, 0.2950}, {1610.2811, 935.1426, 0.4960}, {1183.3812, 412.7546, 0.2886}, {51.1705, -42.8613, 0.3009}, {820.8023, 1349.6853, 0.4995}, {645.7829, 1383.7110, 0.5229}, {516.1410, 1065.9086, 0.4774}, {1823.3542, -523.0474, 0.3005}, {315.6078, -339.0825, 0.3056}, {876.7933, 1390.4162, 0.4485}, {1399.1806, 949.7239, 0.5011}, {1719.8644, -833.8389, 0.2920}, {841.9935, -55.3231, 0.2958}, {1218.1065, 575.2985, 0.2882}, {442.6124, 634.1687, 0.2945}, {-248.0407, 697.9004, 0.2996}, {713.5653, 1147.8607, 0.5292}, {3458.4788, -1438.8884, 0.1704}, {-48.2159, -19.6212, 0.3016}, {552.3897, 266.1248, 0.2964}, {1137.2650, 1453.5947, 0.4786}, {801.7191, 1006.8831, 0.4962}, {768.3633, 760.0800, 0.2914}, {1206.8097, 1385.3721, 0.4717}, {1091.0432, 1500.6711, 0.4738}, {2359.4082, 1509.2033, 0.4448}, {975.6816, -343.5446, 0.2988}, {1537.6384, 537.2439, 0.6310}, {608.3777, 646.0412, 0.2913}, {926.6139, 196.0696, 0.3007}, {636.9927, 364.0596, 0.2956}, {256.8999, -327.5173, 0.3044}, {81.4870, -703.3731, 0.2697}, {-189.7856, -32.4657, 0.3070}, {167.2501, -175.2928, 0.3057}, {-406.3767, 830.8897, 0.3013}, {-602.9687, -45.3543, 0.3061}, {276.6356, -423.9162, 0.3025}, {148.8670, 213.3829, 0.3016}, {562.4611, -302.2498, 0.3003}, {1201.9959, 506.8982, 0.5468}, {-2.8139, -13.8657, 0.3034}, {-698.9510, 34.7593, 0.3001}, {374.8691, -412.2861, 0.3110}, {504.0900, 125.6451, 0.2993}, {340.0210, 111.7437, 0.3005}, {12.2207, -31.8303, 0.3033}, {922.5224, 528.5894, 0.2937}, {456.2867, 538.5114, 0.2946}, {874.2419, 285.7774, 0.2899}, {529.6444, -608.3163, 0.3054}, {479.7439, -540.4699, 0.3045}, {523.8291, -603.0924, 0.3084}, {1707.7883, 353.2705, 0.5914}, {1092.1470, 480.6740, 0.2940}, {617.3558, -459.5845, 0.2892}, {991.6157, -435.2018, 0.3067}, {1615.0711, -498.3638, 0.1028}, {25.6220, 922.0009, 0.175e-1}, {472.9353, -545.1853, 0.2960}, {1198.9720, 1377.2975, 0.5193}, {563.6173, 475.5966, 0.2921}, {1109.3040, 334.2112, 0.2907}, {945.3159, 520.2926, 0.2895}, {1068.0694, -588.3325, 0.2958}, {-189.0469, 792.8020, 0.2999}, {-105.4657, 1335.3416, 0.2873}, {67.2902, -70.5092, 0.3009}, {296.2432, 118.0803, 0.3003}, {761.7553, 1094.8556, 0.4893}, {1313.9316, 1862.4639, 0.4410}, {884.0230, 1008.0037, 0.4064}, {1566.4390, 1598.3126, 0.4408}, {1324.9767, 814.1435, 0.5663}, {653.9718, 1883.6007, 0.3607}, {2419.3354, 1844.3794, 0.6308}, {-57.9601, 1241.7396, 0.2937}, {-285.3881, 1289.2198, 0.2909}, {375.3497, 45.3706, 0.3006}, {437.1923, 33.6363, 0.3022}, {255.3591, 1047.1959, 0.2970}, {761.7739, 1393.7993, 0.4376}, {542.4128, 772.4394, 0.2937}, {1114.2947, 1305.9242, 0.4758}, {1020.8405, 889.3461, 0.6180}, {-651.1909, 301.8389, 0.3054}, {-396.4935, 886.5703, 0.2971}, {-754.9547, -280.3830, 0.3086}, {429.8705, 727.6490, 0.2925}, {-247.9492, 727.5102, 0.2950}, {-644.8573, 898.3999, 0.1563}, {605.7381, 235.4493, 0.2963}, {503.0737, -181.5533, 0.2996}, {681.5104, 931.4616, 0.9809}, {-227.3671, -86.1025, 0.3062}, {373.4202, 318.1885, 0.2986}, {60.1980, -51.0865, 0.3019}, {-50.2635, 14.2180, 0.3056}, {-583.6169, 629.2214, 0.2974}, {226.4602, -241.7457, 0.2874}, {2587.8730, -439.4469, 0.2836}, {2435.8879, 102.7658, 0.972e-1}, {1608.0700, 1818.2947, 0.4898}, {-455.9152, 1301.6396, 0.2981}, {674.4614, 1809.8868, 0.3536}, {1166.8333, 1090.0262, 0.2862}, {915.7450, 1725.0977, 0.4522}, {715.9592, 548.8965, 0.2920}, {1285.9880, 1606.0820, 0.4393}, {1160.1372, 467.9008, 0.5573}, {75.5965, 328.8977, 0.3009}, {-803.1654, 1732.7268, 0.2954}, {2633.6951, 504.0381, 0.4447}, {639.8173, 2491.0163, 0.4385}, {471.7718, 2030.8877, 0.5155}, {1544.0251, 2086.4776, 0.3792}, {1310.8994, 1920.1402, 0.5778}, {2531.7402, -758.0034, 0.3020}, {1186.7304, -99.9000, 0.2974}, {160.3429, 2104.4002, 0.6379}, {-169.1652, 1372.3121, 0.2932}, {2602.6374, 436.9686, 0.3950}, {1835.0881, 419.8087, 0.6802}, {-239.6197, 573.8298, 0.3055}, {3633.5330, -494.8389, 0.2816}, {19947.2334, -15910.4563, 0.56e-2}, {2385.3714, 282.6970, 0.4942}, {11965.5274, -7391.5468, 0.235e-1}, {1979.5492, 197.0009, 0.6371}, {2559.3708, 418.7524, 0.5361}, {2325.9141, 162.3029, 0.5622}, {1473.9606, -66.4169, 0.811e-1}, {2983.8991, -171.6660, 0.2673}, {2121.4973, 101.3068, 0.1504}, {2232.9727, 641.3504, 0.4399}, {3805.0038, 918.2419, 0.2951}, {1323.2731, 845.9826, 0.6780}, {2665.1471, 4202.0746, 0.5409}, {2991.1845, -464.8054, 0.1563}, {1880.1699, 489.1746, 0.2938}, {1914.0077, 220.0262, 0.4776}, {-5096.5280, 28437.1380, 0.381e-1}, {4689.8409, 301.3998, 0.3168}, {2222.5960, 831.9908, 0.5706}, {1874.8967, 856.9565, 0.3734}, {725.1364, 858.8268, 00.}, {11675.1604, -3887.1802, 0.902e-1}, {2986.1161, -84.8485, 0.860e-1}, {-4.9421, 84.0212, 0.3055}, {893.4167, -566.9011, 0.2551}, {176.8791, -288.2136, 0.3061}, {294.4424, -185.2944, 0.3013}, {273.5119, 524.9030, 0.2961}, {161.2943, 431.5524, 0.3008}, {-53.1528, 551.9630, 0.3013}, {-94.1122, 288.6566, 0.3023}, {140.5075, -127.4605, 0.3064}, {-225.8274, 197.7460, 0.3030}, {-73.7504, -250.7743, 0.3055}, {-73.4845, 97.5682, 0.3038}, {-100.9240, 300.0048, 0.3046}, {58.8289, -39.5526, 0.3035}, {394.5891, 298.1172, 0.3004}, {1512.9737, 639.2332, 0.5231}, {527.2886, -57.1531, 0.3004}, {810.5440, 408.5646, 0.6691}, {490.0693, 560.0207, 0.2957}, {736.7867, -251.4046, 0.3074}, {-157.3069, 595.6615, 0.3012}, {1088.4773, -446.4137, 0.3068}, {-347.2708, 503.5971, 0.3045}, {65.9717, 67.1231, 0.3024}, {-344.6666, 757.9930, 0.3067}, {52.3512, -42.2029, 0.2813}, {541.0855, -319.8327, 0.2795}, {1085.4557, -715.7662, 0.2989}, {1441.9721, -865.5699, 0.2830}, {1538.3464, -819.5924, 0.3214}, {700.4097, -450.6274, 0.3251}, {277.6641, -292.2391, 0.3040}, {1311.3264, -523.3212, 0.3110}, {776.8671, -178.3464, 0.2990}, {717.4228, -684.6315, 0.2908}, {130.6061, -27.3294, 0.3037}, {1390.4880, -636.1853, 0.2851}, {111.1157, -121.2437, 0.3033}, {52.3967, 94.0417, 0.3020}, {-643.5999, 970.4264, 0.3110}, {-70.8372, 57.0902, 0.3034}, {-454.1872, 615.2806, 0.2878}, {-50.2635, 14.2180, 0.3056}, {85.2080, 104.9548, 0.3019}, {1915.7178, -810.5032, 0.3693}, {-192.1433, 141.5054, 0.3032}, {64.1947, 78.6570, 0.3022}, {-69.6810, 95.3839, 0.3041}, {629.2214, -583.6169, 0.2974}, {-591.6879, 1052.8580, 0.2439}, {185.3799, -250.7688, 0.3062}, {790.7250, 724.0955, 0.9353}, {-167.8974, 104.6027, 0.3029}, {-217.7768, 251.5704, 0.3097}, {537.4434, 21.7626, 0.3011}, {1063.2839, 192.0041, 0.2898}, {432.7908, 592.5054, 0.2969}, {-95.6685, 717.0741, 0.3009}, {-2260.2463, 3666.1775, 0.711e-1}, {510.1471, -197.5696, 0.3015}, {5175.2573, 224.8869, 0.4600}, {91.4853, -153.9388, 05.1012}, {264.6428, -60.3423, 0.2992}, {668.6525, -666.7128, 0.2414}, {-47.4722, 15.0630, 0.3049}, {-40.5158, 15.0972, 0.3037}, {386.4643, -304.6112, 0.3083}, {806.4313, -288.9774, 0.2969}, {396.5492, -97.1224, 0.3028}, {-490.8706, 1036.9557, 0.2963}, {-676.6725, 1239.9195, 0.3000}, {663.0837, -482.5109, 0.3005}, {226.4602, -241.7457, 0.2874}, {598.0263, -130.4323, 0.3023}, {-539.7919, 813.9959, 0.3466}, {649.8687, -453.4673, 0.3067}, {-172.3762, 122.4657, 0.3034}, {1102.5396, 5.3234, 0.2980}, {1304.6073, -338.2481, 0.2994}, {928.9662, -553.9006, 0.3457}, {357.7079, -307.8057, 0.3076}, {519.4154, -64.0219, 0.3003}, {243.6463, 384.0030, 0.2989}, {26.2560, -27.6358, 0.3043}, {-789.9294, 957.1492, 0.3026}, {-232.4578, 163.8924, 0.3047}, {308.9034, 548.6670, 0.2960}, {-78.8985, 351.0029, 0.3009}, {-259.4169, 1034.4099, 0.2992}, {282.0248, -254.9358, 0.3085}, {718.2538, -479.1971, 0.2870}, {1357.7269, -110.2727, 0.1967}, {559.7795, 332.8093, 0.2947}, {-192.9687, 121.7193, 0.3044}, {1413.0042, -210.0314, 0.2938}, {848.1184, -557.9036, 0.2733}, {153.1239, 722.4999, 0.2942}, {1004.5491, -949.1003, 0.2906}, {-395.6312, 359.7555, 0.3055}, {311.9792, 408.2084, 0.2972}, {-106.8166, 13.4903, 0.3033}, {329.7212, 143.3943, 0.3007}, {878.2759, -655.9008, 0.3261}, {370.6529, 140.0817, 0.3003}, {-118.3505, 885.1196, 0.2950}, {-615.6730, 811.3338, 0.3353}};

algorithm
for i in 1:NOC loop
  for j in 1:NOC loop
    for k in 1:2 loop
      value[i, j, k] := 0;
    end for;
  end for;
end for;
for i in 1:NOC loop
  for j in 1:NOC loop
    c[i, j] := CAS[i] + underscore + CAS[j];
    d[i, j] := CAS[j] + underscore + CAS[i];
    for k in 1:352 loop
      if c[i, j] == CAS1_CAS2[k] then
        value[i, j, 1] := BI_Values[k, 1];
        value[j, i, 1] := BI_Values[k, 2];
        value[i, j, 2] := BI_Values[k, 3];
        value[j, i, 2] := BI_Values[k, 3];
      end if;
      if d[i, j] == CAS1_CAS2[k] then
        value[j, i, 1] := BI_Values[k, 1];
        value[i, j, 1] := BI_Values[k, 2];
        value[i, j, 2] := BI_Values[k, 3];
        value[j, i, 2] := BI_Values[k, 3];
      end if;
    end for;
  end for;
end for;
end BIPNRTL;































 function Tow_UNIQUAC

  input Integer NOC;
  input  Real a[NOC,NOC];
  input Real T;
  output Real tow[NOC,NOC](start = 1);
  
  protected  Real R_gas = 1.98721;
  algorithm
  
    for i in 1:NOC  loop
      for j in 1:NOC  loop
        tow[i,j] := exp(-a[i,j]/(R_gas * T));
      end for;
    end for;

end Tow_UNIQUAC;

 
  function BIP_UNIQUAC
    input Integer NOC;
    input String Comp[NOC];
    output Real value[NOC, NOC];
    constant String underscore = "_";
    String c[NOC, NOC];
    String d[NOC, NOC];
    constant String Comp1_Comp2[440] = {"Butane_Methanol", "Pentane_Ethanol", "Twomethylbutane_Ethanol", "Hexane_Ethanol", "Hexane_Onepropanol", "Cyclohexane_Onepropanol", "Methylcyclohexane_Phenol", "Isobutylene_Methanol", "Twomethyltwobutene_Methanol", "Twomethyltwobutene_Ethanol", "Onehexene_Methanol", "Onehexene_Ethanol", "Onethreebutadiene_Methanol", "Onethreepentadiene_Methanol", "Transonethreepentadiene_Methanol", "Isoprene_Methanol", "Isoprene_Ethanol", "Cyclopentadiene_Methanol", "Benzene_Chloroform", "Benzene_Phenol", "Benzene_Toluene", "Benzene_Pxylene", "Benzene_Onepropanol", "Toluene_Chloroform", "Toluene_Pxylene", "Acetaldehyde_Water", "Propionicaldehyde_Water", "Propionicaldehyde_Methanol", "Isobutyraldehyde_Water", "Acetone_Chloroform", "Acetone_Benzene", "Acetone_Phenol", "Acetone_Cyclohexane", "Acetone_Toluene", "Acetone_Ethanol", "Twobutanone_Benzene", "Twobutanone_Cyclohexane", "Twobutanone_Toluene", "Twobutanone_Nheptane", "Twobutanone_Water", "Twobutanone_Onepropanol", "Methanol_Water", "Methanol_Chloroform", "Methanol_Ethanol", "Methanol_Acetone", "Methanol_Benzene", "Methanol_Cyclohexane", "Methanol_Toluene", "Methanol_Nheptane", "Methanol_Tetrachloromethane", "Methanol_Tribromomethane", "Methanol_Acetonitrile", "Methanol_Onetwodichloroethane", "Methanol_Aceticacid", "Methanol_Dimethylsulfoxide", "Methanol_Propionicacid", "Methanol_Nndimethylformamide", "Methanol_Propanol", "Methanol_Thiophene", "Methanol_Methylacrylate", "Methanol_Twobutanone", "Methanol_Tetrahyrofuran", "Methanol_Onefourdioxane", "Methanol_Ethylacetate", "Methanol_Sulfolane", "Methanol_Onebutanol", "Methanol_Twobutanol", "Methanol_Tertbutanol", "Methanol_Onefourbutanediol", "Methanol_Pyridine", "Methanol_Methylmethacrylate", "Methanol_Methylisopropylketone", "Methanol_Threepentanone", "Methanol_Piperidine", "Methanol_Hexafluorobenzene", "Methanol_Chlorobenzene", "Methanol_Aniline", "Methanol_Twomethylpyridine", "Methanol_Threemethylpyridine", "Methanol_Fourmethylpyridine", "Methanol_Cyclohexene", "Methanol_Nbutylacetate", "Methanol_Hexane", "Methanol_Triethylamine", "Methanol_Twomethylphenol", "Methanol_Two6dimethylpyridine", "Methanol_Oneheptane", "Methanol_Methylcyclohexane", "Methanol_Heptane", "Methanol_Ethylbenzene", "Methanol_Mxylene", "Methanol_Pxylene", "Methanol_Oneoctene", "Methanol_Octane", "Methanol_Twotwofourtrimethylpentane", "Methanol_Onedodecanol", "Methanol_Oleic acid", "Ethanol_Water", "Ethanol_Chloroform", "Ethanol_Acetone", "Ethanol_Twobutanone", "Ethanol_Benzene", "Ethanol_Cyclohexane", "Ethanol_Toluene", "Ethanol_Nheptane", "Ethanol_Pxylene", "Ethanol_Tetrachloroethylene", "Ethanol_Acetonitrile", "Ethanol_Onetwodichloroethane", "Ethanol_Acetic acid", "Ethanol_Onetwoethanediol", "Ethanol_Twopropanol", "Ethanol_Onetwopropanediol", "Ethanol_Thiophene", "Ethanol_Onefourdioxane", "Ethanol_Sulfolane", "Ethanol_Morpholine", "Ethanol_Twobutanol", "Ethanol_Twomethylonepropanol", "Ethanol_Pyridine", "Ethanol_Methylmethacrylate", "Ethanol_Methylisopropyl", "Ethanol_Propylacetate", "Ethanol_Threemethylonebutanol", "Ethanol_Bromobenzene", "Ethanol_Chlorobezene", "Ethanol_Aniline", "Ethanol_Twomethylpyridine", "Ethanol_Threemethylpyridine", "Ethanol_Cyclohexanol", "Ethanol_Butylacetate", "Ethanol_Dipropylether", "Ethanol_Triethylamine", "Ethanol_Anisole", "Ethanol_Two6dimethylpyridine", "Ethanol_Pentylacetate", "Ethanol_Heptane", "Ethanol_Ethylbezene", "Ethanol_Octane", "Ethanol_Twotwofourtrimethylpentane", "Ethanol_Hexadecane", "Ethanol_Oleicacid", "Onepropanol_Water", "Onepropanol_Tetrachloroethylene", "Onepropanol_Aceticacid", "Onepropanol_Propionicacid", "Onepropanol_Twomethoxyethanol", "Propylamine_Onepropanol", "Onepropanol_Methacrylicacid", "Onepropanol_Twomethylonepropanol", "Onepropanol_Pyridine", "Onepropanol_Methylmethacrylate", "Onepropnaol_Propylacetate", "Onepropanol_Threemethylbutanol", "Onepropnaol_Chlorobenzene", "Onepropanol_Twomethylpyridine", "Onepropanol_Threemethylpyridine", "Onepropanol_Fourmethylpyridine", "Onepropanol_Propylpropionate", "Onepropanol_Dipropylamine", "Onepropanol_Hexamethyldisiloxane", "Onepropanol_Toluene", "Onepropnaol_Two6dimethylpyridine", "Onepropanol_Heptane", "Onepropanol_Pxylene", "Onepropanol_Octane", "Onepropanol_Decane", "Onepropanol_Onedecanol", "Twopropanol_Water", "Twopropanol_Onepropanol", "Isobutanol_Water", "Tertbutanol_Water", "Allylalcohol_Water", "Methylformate_Methanol", "Methylacetate_Water", "Methylacetate_Methanol", "Methylacetate_Ethanol", "Ethylacetate_Water", "Ethylacetate_Ethanol", "Vinylacetate_Ethanol", "Diethylether_Water", "Diethylether_Methanol", "Diethylether_Ethanol", "Diisopropylether_Water", "Methyltertbutylether_Methanol", "Dimethoxymethane_Water", "Dimethoxymethane_Methanol", "Ethyleneoxide_Water", "Propyleneoxide_Methanol", "Tetrahydrofuran_Water", "Tetrahydrofuran_Ethanol", "Tetrahydrofuran_Onepropanol", "Tetrachloromethane_Methanol", "Tertachloromethane_Onepropanol", "Vinylcloride_Methanol", "Dichloromethane_Methanol", "Dichloromethane_Ethanol", "Chloroform_Methanol", "Chloroform_Ethanol", "Onetwodichloroethane_Onepropanol", "Trichloroethylene_Onepropanol", "Threechloroonepropene_Water", "Butylchloride_Onepropanol", "Dimethylamine_Water", "Dimethylamine_Methanol", "Dimethylamine_Ethanol", "Dimethylamine_Onepropanol", "Ethylamine_Water", "Triethylamine_Water", "Triethylamine_Onepropanol", "Diethylamine_Water", "Diethylamine_Ethanol", "Propylamine_Water", "Nbutylamine_Water", "Butylamine_Ethanol", "Butylamine_Onepropanol", "Isopropylamine_Water", "Acetonitrile_Water", "Propionitrile_Water", "Acrylonitrile_Water", "Hexafluorobenzene_Onepropnaol", "Water_Acetone", "Water_Twobutanone", "Water_Phenol", "Water_Aceticacid", "Water_Nmethylformamide", "Water_Dimethylsulfoxide", "Water_Ethylenediamine", "Water_Acrylicacid", "Water_Propionicacid", "Water_Onethreefivetrioxane", "Water_Nndimethylformamide", "Water_Onefourdioxane", "Water_Sulfolane", "Water_Nndimethylacetamide", "Water_Morpholine", "Water_Nbutanol", "Water_Onefourbutanediol", "Water_Twothreebutanediol", "Water_Diethylenegylcol", "Water_Furfural", "Water_Pyridine", "Water_Nmethylpyrrolidone", "Water_Threemethylbutanol", "Water_Twomethyltwobutanol", "Water_Aniline", "Water_Twomethylpyridine", "Water_Threemethylpyridine", "Water_Fourmethylpyridine", "Water_Phenylhydrazine", "Water_Cyclohexanone", "Water_Mesityloxide", "Water_Cyclohexanol", "Water_Nbutylacetate", "Water_Diacetonealcohol", "Water_Onehexanol", "Water_Twohexanol", "Water_Twobutoxyethanol", "Water_Benzylalcohol", "Water_Two6dimethylpyridinr", "Water_Isopentylacetate", "Water_Acetophenone", "Water_Quinoline", "Water_Isopropylbenzene", "Halothane_Methanol", "Methanol_Formamide", "Methane_Acetone", "Methane_Propane", "Methane_Nbutane", "Methane_Npentane", "Methane_Benzene", "Methane_Nhexane", "Methane_Ndecane", "Ethane_Nheptane", "Ibutane_Nbutane", "Npentane_Acetone", "Nhexane_Nitroethane", "Nhexane_Aniline", "Nhexane_Methylcyclop", "Nhexane_Toluene", "Nheptane_Benzene", "Nheptane_Toluene", "Noctane_Nitroethane", "Noctane_Ipropanol", "Twotwofourtrimethylpentane_Nitroethane", "Twotwofourtrimethylpentane_Furfural", "Twotwofourtrimethylpentane_Benzene", "Twotwofourtrimethylpentane_Cyclohexane", "Twotwofourtrimethylpentane_Toluene", "Ndecane_Npropanol", "Ndecane_Nbutanol", "Ndecane_Ipropanol", "Cyclopentane_Benzene", "Methylcyclopentane_Benzene", "Methylcyclopentane_Toluene", "Cyclohexane_Nitromethan", "Cyclohexane_Npropanol", "Cyclohexane_Nbutanol", "Cyclohexane_Benzene", "Cyclohexane_Methylcyclop", "Cyclohexane_Nhexane", "Cyclohexane_Toluene", "Cyclohexane_Heptane", "Methylcyclohexane_Toluene", "Onebutene_Ibutane", "Onebutene_Propane", "Onebutene_Nbutane", "Benzene_Twobutanone", "Benzene_Nbutanol", "Benzene_Nhexane", "Benzene_Water", "Toluene_Furfural", "Hydrogen_Methanol", "Hydrogen_Acetone", "Hydrogen_Benzene", "Hydrogen_Nhexane", "Hydrogen_Mxylene", "Hydrogen_Noctane", "Hydrogen_Water", "Hydrogen_Ammonia", "Nitrogen_Nbutane", "Nitrogen_Nhexane", "Nitrogen_Water", "Nitrogen_Ammonia", "Carbonmonoxide_Methanol", "Carbonmonoxide_Acetone", "Carbonmonoxide_Benzene", "Carbonmonoxide_Noctane", "Acetaldehyde_Aceticacid", "Acetaldehyde_Vinylacetat", "Acetone_Carbontetra", "Acetone_Acetonitrile", "Acetone_Methanol", "Acetone_Aceticacid", "Acetone_Furfural", "Acetone_Nhexane", "Acetone_Water", "Acetone_Vinylacetat", "Methanol_Carbontetra", "Methanol_Ipropanol", "Methanol_Ethylacetat", "Methanol_Diethylamin", "Methanol_Methylisobut", "Methanol_Nhexane", "Methanol_Two.threedimethyl", "Methanol_Triethylamin", "Methanol_Anisole", "Ethanol_One.twodichloro", "Ethanol_Aceticacid", "Ethanol_Npropanol", "Ethanol_Tertbutanol", "Ethanol_Methylcyclop", "Ethanol_Nhexane", "Ethanol_Methylcyclo", "Ethanol_Noctane", "Ethanol_Twotwofourtrimethyl", "Ethanol_Ndecane", "Npropanol_Carbontetra", "Npropanol_Aceticacid", "Npropanol_Benzene", "Npropanol_Nhexane", "Npropanol_Toluene", "Npropanol_Nheptane", "Npropanol_Water", "Ipropanol_Ethylacetat", "Ipropanol_Benzene", "Ipropanol_Nheptane", "Ipropanol_Water", "Ipropanol_Twotwofourtrimethyl", "Nbutanol_Carbontetra", "Nbutanol_Aceticacid", "Nbutanol_Nhexane", "Nbutanol_Nheptane", "Nbutanol_Noctane", "Ibutanol_Benzene", "Secbutanol_Benzene", "Tertbutanol_Benzene", "Formicacid_Aceticacid", "Aceticacid_Toluene", "Aceticacid_Nheptane", "Propionicacid_Methylisobut", "Propionicacid_Noctane", "Methylacetate_Chloroform", "Methylacetate_Benzene", "Ethylacetate_Aceticacid", "Ethylacetate_Npropanol", "Ethylacetate_Furfural", "Ethylacetate_Benzene", "Ethylacetate_Toluene", "Ethylacetate_Ethylbenzen", "Vinylacetate_Aceticacid", "Vinylacetate_Water", "Dioxane_Benzene", "Carbontetrachloride_Acetonitrile", "Carbontetrachloride_Ethanol", "Carbontetrachloride_Furfural", "Carbontetrachloride_Benzene", "Carbontetrachloride_Cyclohexane", "Carbontetrachloride_Methylcyclop", "Carbontetrachloride_Toluene", "Carbontetrachloride_Nheptane", "Dichloromethane_Dichloroetan", "Chloroform_Carbontetra", "Chloroform_Formicacid", "Chloroform_Aceticacid", "Chloroform_Ethylacetate", "Chloroform_Benzene", "Nitromethane_Carbontetra", "Nitromethane_Benzene", "Nitroethane_Carbontetra", "Nitroethane_Npropanol", "Nitroethane_Benzene", "Onenitropropane_Carbontetra", "Onenitropropane_Benzene", "Twonitropropane_Carbontetra", "Twonitropropane_Benzene", "Twonitropropane_Nhexane", "Acetonitrile_Benzene", "Acetonitrile_Nheptane", "Acrylonitrile_Acetonitrile", "Aniline_Methylcyclop", "Furfural_Onebutene", "Furfural_Nbutane", "Furfural_Ibutane", "Furfural_Benzene", "Furfural_Cyclohexane", "Water_Formicacid", "Water_Acetonitrile", "Water_Nitroethane", "Water_Dioxane", "Water_Onebutene", "Water_Ibutane", "Water_Toluene", "Water_Acrylonitril", "Water_Cisbutenetwo", "Water_Transbutene", "Water_Isobutene", "Water_Butadiene", "Carbondisulfide_Methanol", "Carbondisulfide_Acetone"};
    constant Real BI_Values[440, 2] = {{1289.4881, 6.7114}, {938.0838, -112.7209}, {849.013, -56.7699}, {1056.8977, -135.5484}, {743.1034, -127.2476}, {1251.6417, -391.9511}, {1525.5351, -516.0584}, {1403.5125, -70.3003}, {1499.6766, -66.3796}, {983.1208, -123.8651}, {1329.9294, -21.5842}, {970.6914, -128.7022}, {1300.2481, -72.9715}, {1489.1438, -97.747}, {1477.5985, -92.9294}, {1514.3534, -144.3088}, {912.9208, -118.3758}, {1410.4509, -61.3753}, {-119.7224, -29.4499}, {72.2429, 197.453}, {70.7224, -58.3017}, {5.7397, 0.5699}, {378.6125, 20.5261}, {860.8206, -554.8868}, {121.3912, -119.706}, {-1132.16, -231.7521}, {735.9692, 208.343}, {416.3831, -377.9488}, {1263.005, -81.883}, {1566.0069, -781.5877}, {-358.9226, 604.28}, {-468.3882, 27.3851}, {-77.5361, 543.595}, {-315.279, 555.7418}, {94.5536, 117.867}, {-300.8429, 385.863}, {146.0313, 100.2596}, {366.3689, -250.2784}, {-184.485, 559.8999}, {775.153, 30.4806}, {147.6576, -8.2705}, {-337.1298, 549.2958}, {-271.0633, 1304.9835}, {-474.7791, 762.8153}, {-84.2364, 403.8524}, {-67.7213, 1117.8797}, {-32.2887, 1703.2055}, {-58.1103, 1190.6454}, {17.9144, 1360.0217}, {-95.2921, 1463.4548}, {-92.0642, 984.2538}, {101.9628, 334.9587}, {-80.7067, 1094.1304}, {-40.7254, -51.0491}, {-366.7607, 84.4189}, {7.1816, 0.3295}, {-156.3839, 103.9406}, {-26.2861, 113.5565}, {-265.3781, 1099.9741}, {-25.1614, 600.3028}, {-136.0158, 584.0634}, {-153.2518, 629.7314}, {-19.0988, 451.089}, {-138.9829, 770.3047}, {-28.6882, 675.1045}, {40.3898, 121.5049}, {471.807, -279.7321}, {-291.983, 403.6892}, {-286.6527, 490.8909}, {425.4563, -393.3415}, {-98.6602, 843.2593}, {-100.1669, 594.2312}, {-83.8392, 609.2057}, {-383.9791, 153.8253}, {-90.0876, 1245.166}, {-118.0717, 1402.7818}, {-144.7753, 517.8626}, {-603.5633, 950.103}, {-206.2407, 81.4664}, {-78.8509, -53.173}, {-38.5257, 1529.9926}, {-174.2617, 892.9417}, {38.3254, 1391.4917}, {-318.8007, 905.0708}, {-502.2428, 548.3889}, {-272.5909, 272.4921}, {-12.605, 1363.9261}, {1.0023, 1552.7297}, {-27.9877, 1578.6097}, {-57.095, 1259.4286}, {-41.7377, 1208.1529}, {-47.6694, 1231.2086}, {-32.2567, 1396.3019}, {-32.7911, 1561.8955}, {-59.6929, 1577.3145}, {18.9334, 484.2757}, {-149.1808, 952.0283}, {173.801, 109.8687}, {-305.3246, 881.3549}, {94.2417, 98.7523}, {-25.7234, 250.3958}, {-127.9893, 744.8826}, {-153.0128, 1100.3231}, {-97.5633, 698.6183}, {-150.277, 1127.5232}, {-63.9673, 664.259}, {-61.6485, 783.4873}, {392.2083, 91.3933}, {-39.1051, 669.688}, {-25.2901, -86.9343}, {818.093, -200.1567}, {437.5184, -324.6275}, {181.0206, -57.8238}, {-77.9585, 662.4746}, {50.8172, 212.2982}, {177.7675, 306.35}, {-712.473, 1116.7138}, {-311.9029, 474.5511}, {-117.4292, 220.9133}, {378.8209, -378.8991}, {-105.4041, 544.4089}, {-260.5944, 652.4019}, {-13.0186, 405.1733}, {82.3751, -18.3336}, {-169.9204, 998.8196}, {-205.6039, 1032.724}, {1262.584, -446.4834}, {139.4905, -225.4203}, {-578.9542, 942.9023}, {634.1484, -339.732}, {-38.4912, 384.6715}, {-177.4837, 780.0513}, {-305.4069, 674.3341}, {928.9185, -379.9781}, {-432.4206, 583.2958}, {-161.4264, 631.1662}, {-115.7807, 1040.2891}, {-127.6343, 841.5199}, {-152.8323, 1156.688}, {-165.9382, 1120.4853}, {-401.4408, 1783.7857}, {-180.7604, 627.9668}, {190.5947, 290.554}, {-13.5513, 473.6899}, {-729.0848, 1660.0903}, {-83.3064, -4.418}, {-300.7498, 511.0851}, {-274.4208, 15.9476}, {114.789, -169.5098}, {47.0059, -46.6524}, {423.4439, -423.9207}, {-27.435, 256.1456}, {-91.8942, 278.7259}, {-19.2402, 27.9161}, {1.3035, 311.4544}, {163.7157, -281.9383}, {199.1862, -290.3666}, {180.7309, -293.8268}, {-585.5214, 1186.3162}, {-1.1304, 48.1557}, {-218.4928, 677.0367}, {-1.7464, 340.4905}, {-595.2165, 936.7248}, {-91.2018, 743.266}, {-74.7475, 427.6292}, {-48.752, 525.9933}, {-175.9432, 744.763}, {89.4506, 31.0832}, {327.443, 64.4408}, {103.5993, -103.7179}, {350.1707, 309.5428}, {230.5098, 271.3048}, {281.7442, 47.6526}, {623.2636, -2.0107}, {830.7943, 47.5023}, {611.2312, -70.982}, {267.0169, -79.2922}, {1441.5619, -205.7336}, {436.0416, -98.562}, {483.9533, -67.6116}, {1198.9207, 102.271}, {906.3646, -157.3556}, {642.6982, -171.8091}, {1415.2748, 81.2811}, {1024.985, -203.711}, {1098.9416, -44.1418}, {657.2765, -4.6934}, {10542.2026, -344.1682}, {791.0185, -210.2403}, {835.2626, 10.5163}, {559.1539, -260.1951}, {381.8256, -244.669}, {1029.3332, -171.0842}, {957.274, -252.3762}, {7661.2894, -187.7083}, {1516.5558, -229.3734}, {796.2935, -172.0713}, {1295.4282, -271.461}, {981.7658, -335.4504}, {272.4952, 107.634}, {538.1802, -90.5235}, {1260.1312, 81.3308}, {748.22, -172.7007}, {-1070.3252, 1057.3916}, {-520.5358, -200.8021}, {-1071.4286, 1018.5371}, {-71.2521, -231.1124}, {149.3345, -412.065}, {242.4137, 2458.766}, {701.924, -371.1197}, {721.1889, -312.3228}, {-613.4553, 1006.1474}, {426.0894, -302.8076}, {-379.6694, 874.815}, {-17.1391, -220.6087}, {-188.4751, -68.9772}, {-553.685, 1001.0323}, {266.3109, 332.5988}, {367.0686, 510.5582}, {395.4004, 537.1531}, {535.7543, -38.2344}, {-110.3829, 698.7989}, {752.9217, 39.6746}, {934.8834, -501.3763}, {-251.6868, 407.0073}, {-867.7066, 2091.772}, {-292.3021, -523.6271}, {-175.0216, -724.876}, {-417.4722, 1189.9025}, {486.4688, -146.6582}, {-210.5536, 915.1339}, {639.5742, -556.8715}, {-444.013, 1302.0378}, {-397.8616, 997.3999}, {453.4841, -463.0383}, {933.6195, -802.5279}, {548.2453, 89.0444}, {-370.3689, 1635.7568}, {489.1312, -286.7611}, {-346.2827, 900.5916}, {537.7334, -36.221}, {-56.5403, -97.5005}, {-801.2765, 1402.6755}, {819.6231, -223.7898}, {-178.9352, 1021.7979}, {-91.7122, 485.3384}, {-657.2675, 1253.468}, {1280.6209, -655.1387}, {-358.5748, 333.911}, {-334.1695, 857.6208}, {316.6082, 95.0342}, {-56.9399, 1043.7692}, {-286.8493, 1023.7144}, {394.2396, 756.4163}, {-351.0861, 1188.5242}, {-9.7248, 802.6348}, {-172.0599, 1138.3704}, {-178.571, 670.1422}, {83.4921, 304.0167}, {-497.9465, 893.7955}, {-250.5667, 1438.236}, {234.4706, 641.1422}, {-847.2235, 663.5428}, {-310.5637, 1655.4649}, {1653.8373, -379.2679}, {319.3243, -34.2606}, {-0.26, 471}, {-2.01, 604}, {-2.05, 731}, {-1.32, 509}, {-0.38, 473}, {-0.06, 94}, {-0.24, 150}, {264.89, -112.61}, {1, 1}, {266.31, -22.83}, {230.64, -5.86}, {283.76, 34.82}, {-138.84, 162.13}, {34.27, 4.3}, {245.42, -135.93}, {108.24, -72.96}, {333.48, -30.98}, {1107.44, -166.18}, {236.48, 10.66}, {410.08, -4.98}, {80.91, -27.13}, {141.01, -112.66}, {141.11, -94.6}, {1137.2, -201.82}, {1430.77, -259.67}, {1074.76, -207.27}, {15.19, 33.15}, {56.47, -6.47}, {89.77, -48.05}, {517.19, 105.01}, {1284.75, -173.42}, {1393.11, -196.9}, {-32.57, 88.26}, {144.37, -118.82}, {172.73, -145.56}, {83.67, -44.04}, {-76.36, 98.22}, {210.35, -134.19}, {-23.03, 35.11}, {126.71, -98.63}, {-23.03, 35.11}, {350.47, -226.16}, {928.9, -181.24}, {-77.13, 132.43}, {2057.42, 115.13}, {74.87, 244.12}, {3.94, 218}, {3.23, 218}, {1.97, 810}, {2.99, -4}, {2.09, 765}, {-0.05, 1646}, {9.97, -880}, {0.68, 1344}, {-1.67, 814}, {0.07, 336}, {3.76, 913}, {-3.35, 2098}, {0.83, 552}, {0.48, 408}, {-1.04, 1062}, {-3.38, 1878}, {458.43, -212.77}, {-117.74, 243.51}, {-92.32, 246.68}, {-176.38, 261.53}, {359.1, -96.9}, {461.81, -262.3}, {-101.3, 195.63}, {-33.08, 261.51}, {530.99, -100.71}, {-82.48, 110.6}, {-29.64, 1127.95}, {-24.85, 31.22}, {-107.54, 579.61}, {-374.88, 676.42}, {-105.94, 688.03}, {-2.66, 1636.05}, {-7.18, 1463.9}, {-186.66, 664.29}, {-48.39, 782.28}, {-105.66, 929.71}, {-210.53, 244.67}, {210.95, -67.7}, {-2.62, 9.24}, {-118.27, 1383.93}, {-108.93, 1441.57}, {-117.57, 1340.56}, {-109.08, 1385.91}, {-120.42, 1449.61}, {-127.48, 1254.65}, {-166.93, 1336.03}, {299.33, 445.77}, {-155.1, 928.5}, {-144.11, 1326.05}, {-195.4, 818.34}, {-160.43, 1306.22}, {78.37, 583.03}, {-190.57, 522.07}, {-145.52, 854.75}, {-162.54, 1295.6}, {217.23, 11.59}, {-198.06, 994}, {-188.77, 1248.17}, {-296.3, 546.68}, {-159.24, 1370.74}, {-251.11, 1291.98}, {-236.21, 1098.91}, {-162.39, 861.06}, {784.99, -168.83}, {744.89, -165.4}, {-144.58, 241.64}, {-67.91, 298.09}, {-8.49, 342.57}, {-78.49, 136.46}, {-183.2, 556.12}, {-187.87, 121.17}, {203.46, -143.88}, {-214.39, 63.04}, {539.64, -190.31}, {-19.15, 48.52}, {233.81, -181.49}, {309.41, -214.26}, {137.11, -105.5}, {330.03, -124.12}, {1557.23, 131.36}, {363.78, -197.65}, {458.86, -40.18}, {1192.49, -135.27}, {476.85, -100.42}, {-37.52, 43.39}, {98.18, -84.82}, {161.96, -129.21}, {-168.53, 203.67}, {88.3, -59.13}, {1, 1}, {-14.74, 38.19}, {461.38, 90.36}, {346.43, -98.44}, {24.16, -119.49}, {4.98, -50.53}, {0.59, 398.4}, {73.79, 82.2}, {73.06, 295.06}, {574.22, -94.39}, {16.61, 46.05}, {-95.68, 267.13}, {535.16, -246.81}, {-134.32, 307.25}, {794.91, -344.15}, {-32.95, 252.2}, {60.28, 89.57}, {23.71, 545.79}, {183.65, -142.35}, {54.36, 228.71}, {49.12, 242.1}, {88.87, 257.71}, {97.14, 268}, {71, 12}, {41.17, 354.83}, {-508.85, 1019.29}, {122.02, 122.07}, {138.44, 920.08}, {-328.7, 927.26}, {590.17, 777.95}, {646.79, 1173.23}, {305.71, 1371.36}, {155.78, 471.21}, {356.45, -18.31}, {356.45, -18.31}, {346.74, 657.5}, {496.1, 270.6}, {1166.49, 138.15}, {157.31, 103.91}};
  algorithm
    for i in 1:NOC loop
      for j in 1:NOC loop
        for k in 1:2 loop
          value[i, j] := 0;
        end for;
      end for;
    end for;
    for i in 1:NOC loop
      for j in 1:NOC loop
        c[i, j] := Comp[i] + underscore + Comp[j];
        d[i, j] := Comp[j] + underscore + Comp[i];
        for k in 1:440 loop
          if c[i, j] == Comp1_Comp2[k] then
            value[i, j] := BI_Values[k, 1];
            value[j, i] := BI_Values[k, 2];
          end if;
          if d[i, j] == Comp1_Comp2[k] then
            value[j, i] := BI_Values[k, 1];
            value[i, j] := BI_Values[k, 2];
          end if;
        end for;
      end for;
    end for;
  end BIP_UNIQUAC;
  
  function BIP_PR
    input Integer Nc;
    input String comp[Nc];
    output Real kij[Nc, Nc];
  protected
    String name;
    String nameRev;
    constant String Comp1_Comp2[179] = {"Heliumfour_Carbonmonoxide", "Hydrogen_Nitrogen", "Hydrogen_Carbonmonoxide", "Hydrogen_Methane", "Hydrogen_Ethylene", "Hydrogen_Ethane", "Hydrogen_Carbondioxide", "Hydrogen_Propylene", "Hydrogen_Propane", "Hydrogen_Nbutane", "Hydrogen_Nhexane", "Hydrogen_Nheptane", "Hydrogen_Toluene", "Hydrogen_Quinoline", "Hydrogen_Bicyclohexyl", "Hydrogen_Onemethylnaphthalene", "Nitrogen_Carbonmonoxide", "Nitrogen_Argon", "Nitrogen_Oxygen", "Nitrogen_Methane", "Nitrogen_Ethylene", "Nitrogen_Ethane", "Nitrogen_Nitrousoxide", "Nitrogen_Carbondioxide", "Nitrogen_Hydrogensulfide", "Nitrogen_Propylene", "Nitrogen_Propane", "Nitrogen_Ammonia", "Nitrogen_Dichlorodiflouromethane", "Nitrogen_Isobutane", "Nitrogen_Sulfurdioxide", "Nitrogen_Nbutane", "Nitrogen_Isoc5", "Nitrogen_Npentane", "Nitrogen_Methanol", "Nitrogen_Nhexane", "Nitrogen_Benzene", "Nitrogen_Nheptane", "Nitrogen_Noctane", "Nitrogen_Ndecane", "Carbonmonoxide_Methane", "Carbonmonoxide_Ethane", "Carbonmonoxide_Hydrogensulfide", "Carbonmonoxide_Propane", "Argon_Oxygen", "Argon_Methane", "Argon_Ammonia", "Oxygen_Krypton", "Oxygen_Nitrousoxide", "Methane_Ethylene", "Methane_Ethane", "Methane_Nitrousoxide", "Methane_Carbondioxide", "Methane_Carbonylsulfide", "Methane_Propylene", "Methane_Propane", "Methane_Isobutane", "Methane_Sulfurdioxide", "Methane_Nbutane", "Methane_Isoc5", "Methane_Npentane", "Methane_Nhexane", "Methane_Benzene", "Methane_Cyclohexane", "Methane_Nheptane", "Methane_Toluene", "Methane_Noctane", "Methane_Mxylene", "Methane_Nnonane", "Methane_Ndecane", "Methane_Mcresol", "Methane_Tetralin", "Methane_Onemethylnaphthalene", "Methane_Diphenylmethane", "Ethylene_Ethane", "Ethylene_Acetylene", "Ethylene_Carbondioxide", "Ethylene_Nbutane", "Ethylene_Benzene", "Ethylene_Nheptane", "Ethylene_Ndecane", "Carbondioxide_Ethane", "Ethane_Hydrogensulfide", "Ethane_Propylene", "Ethane_Propane", "Ethane_Isobutane", "Ethane_Nbutane", "Ethane_Ethylether", "Ethane_Npentane", "Ethane_Acetone", "Ethane_Methylacetate", "Ethane_Methanol", "Ethane_Nhexane", "Ethane_Benzene", "Ethane_Cyclohexane", "Ethane_Nheptane", "Ethane_Noctane", "Ethane_Ndecane", "Carbondioxide_Nitrousoxidedioxide", "Acetylene_Propylene", "Trifluoromethane_Triflourochloromethane", "Trifluorochloromethane_Dichlorodifluoromethane", "Carbondioxide_Hydrogensulfide", "Carbondioxide_Difluoromethane", "Carbondioxide_Propylene", "Carbondioxide_Propane", "Carbondioxide_Isobutane", "Carbondioxide_Onebutene", "Carbondioxide_Nbutane", "Carbondioxide_Isoc5", "Carbondioxide_Ethylether", "Carbondioxide_Npentane", "Carbondioxide_Methylacetate", "Carbondioxide_Methanol", "Carbondioxide_Nhexane", "Carbondioxide_Benzene", "Carbondioxide_Cyclohexane", "Carbondioxide_Nheptane", "Carbondioxide_Water", "Carbondioxide_Toluene", "Carbondioxide_Ndecane", "Carbondioxide_Nbutylbenzene", "Hydrogensulfide_Propane", "Hydrogensulfide_Isobutane", "Hydrogensulfide_Npentane", "Hydrogensulfide_Water", "Hydrogensulfide_Ndecane", "Propylene_Propane", "Propylene_Isobutane", "Propylene_Onecfour", "Propane_Isobutane", "Propane_Nbutane", "Propane_Isopentane", "Propane_Npentane", "Propane_Nhexane", "Propane_Ethanol", "Propane_Benzene", "Propane_Nheptane", "Propane_Noctane", "Propane_Ndecane", "Pentaflourohloroethane_Difluorochloromethane", "Difluorochloromethane_Dichlorodifluoromethane", "Ammonia_Water", "Ammonia_Watert=two7three.one5k", "Isobutane_Nbutane", "Sulfurdioxide_Benzene", "Onebutene_One", "Onebutene_Nbutane", "One_Threebutadiene", "Nbutane_Npentane", "Nbutane_Nhexane", "Nbutane_Nheptane", "Nbutane_Noctane", "Nbutane_Ndecane", "Npentane_Benzene", "Npentane_Cyclohexane", "Npentane_Nheptane", "Npentane_Noctane", "Two_Twodimethylbutane", "Two_Threedimethylbutane", "Twomethylpentane_Onepentanol", "Onepentanol_Threemethylpentane", "Methanol_Water", "Nhexane_Benzene", "Nhexane_Cyclohexane", "Nhexane_Twopropanol", "Nhexane_Nheptane", "Nhexane_Isopentanol", "Nhexane_Onepentanol", "Cyclohexane_Benzene", "Benzene_Nheptane", "Benzene_Isooctane", "Benzene_Noctane", "Cyclohexene_Cyclohexane", "Cyclohexane_One", "Cyclohexane_Cyclohexanone", "One_Twodichloroethane", "Nheptane_Isooctane", "Nheptane_Twopentanone"};
    constant Real BI_Val[size(Comp1_Comp2, 1)] = {1, 7.1100E-02, 9.1900E-02, 2.6300E-02, 6.3300E-02, -7.5600E-02, 0, 0, 0, 0, -3.00E-02, 0, -1, -1, -1, 0, 3.300E-02, -2.6000E-03, -1.5900E-02, 2.8900E-02, 8.5600E-02, 3.4400E-02, 4.4000E-03, -2.2200E-02, 0, 9.00E-02, 8.7800E-02, 0, 1.0700E-02, 0, 8.00E-02, 7.1100E-02, 9.2200E-02, 0, 0, 0, 0, 0, 0, 0, 3.00E-02, -2.2600E-02, 5.4400E-02, 2.5900E-02, 1.0700E-02, 2.300E-02, 0, 2.5600E-02, 4.7800E-02, 3.7800E-02, -3.3000E-03, 2.5600E-02, 7.9300E-02, 2.8900E-02, 3.300E-02, 1.1900E-02, 2.5600E-02, 0, 2.4400E-02, -5.6000E-03, 2.300E-02, 4.00E-02, 8.0700E-02, 3.8900E-02, 4.0100E-02, 9.700E-02, 4.9600E-02, 8.4400E-02, 4.7400E-02, 4.8900E-02, 0, 0, 0, 8.7400E-02, 1.1900E-02, 6.5200E-02, 5.7800E-02, 9.2200E-02, 3.1100E-02, 1.4400E-02, 2.5300E-02, 0, 8.2200E-02, 8.9000E-03, 1.1000E-03, -6.7000E-03, 8.9000E-03, 1.8100E-02, 7.8000E-03, 0, 0, 2.700E-02, -4.00E-02, 3.2200E-02, 1.7800E-02, 7.4000E-03, 1.8500E-02, 1.4400E-02, 4.8000E-03, 0, 0, 3.3700E-02, 9.7800E-02, 1.700E-02, 9.3300E-02, 0, 0, 5.9300E-02, 0, 0, 4.700E-02, -1.00E-02, -4.9300E-02, 2.200E-02, 0, 7.7400E-02, 0, 0, 6.3000E-03, 0, 0, 0, 6.00E-02, 4.7400E-02, 6.300E-02, 3.9400E-02, 3.3300E-02, 9.6000E-03, -1.4400E-02, 4.0000E-04, -7.8000E-03, 3.3000E-03, 1.1100E-02, 2.6700E-02, 7.0000E-04, 3.1500E-02, 2.3300E-02, 5.6000E-03, 0, 0, 8.7400E-02, 5.2200E-02, 0, 0, -4.0000E-04, 1.5000E-03, 2.2000E-03, 7.0000E-04, 1.4100E-02, 1.7400E-02, -5.6000E-03, 3.3000E-03, 7.4000E-03, 7.8000E-03, 1.8900E-02, 3.7000E-03, 7.4000E-03, 0, 4.5200E-02, 4.6700E-02, 4.6700E-02, 4.7800E-02, -7.7800E-02, 8.9000E-03, -3.000E-03, 8.4400E-02, -7.8000E-03, 4.8500E-02, 4.5600E-02, 1.2600E-02, 1.1000E-03, 4.0000E-04, 3.000E-03, 1.1000E-03, 7.300E-02, 6.5900E-02, 4.300E-02, 4.0000E-04, 6.9300E-02};
  algorithm
    for i in 1:Nc loop
      for j in 1:Nc loop
        name := comp[i] + "_" + comp[j];
        nameRev := comp[j] + "_" + comp[i];
        if i == j then
          kij[i, j] := 0;
        elseif FindString(Comp1_Comp2, name) == (-1) then
          kij[i, j] := BI_Val[index(Comp1_Comp2, nameRev)];
        else
          kij[i, j] := BI_Val[index(Comp1_Comp2, name)];
        end if;
      end for;
    end for;
  end BIP_PR;

  function FindString
    input String compound_array[:];
    input String compound;
    output Integer int;
  protected
    Integer i, len = size(compound_array, 1);
  algorithm
    int := -1;
    i := 1;
    while int == (-1) and i <= len loop
      if compound_array[i] == compound then
        int := i;
      end if;
      i := i + 1;
    end while;
  end FindString;

  function index
    input String[:] comps;
    input String comp;
    output Integer i;
  algorithm
    i := Modelica.Math.BooleanVectors.firstTrueIndex({k == comp for k in comps});
  end index; 
  
  function Density_Racket
  input Integer NOC;
  input Real T;
  input Real P;
  input Real Pc[NOC];
  input Real Tc[NOC];
  input Real Racketparam[NOC];
  input Real AF[NOC];
  input Real MW[NOC];
  input Real Psat[NOC];
  output Real Density[NOC];
  parameter Real R = 83.14;
protected
  Real Tr[NOC], Pcm[NOC], temp[NOC], tempcor[NOC], a, b, c[NOC], d, e[NOC], Beta[NOC], f, g, h, j, k, Racketparam_new[NOC];
algorithm
  for i in 1:NOC loop
    Pcm[i] := Pc[i] / 100000;
    Tr[i] := T / Tc[i];
    if Tr[i] > 0.99 then
      Tr[i] := 0.5;
    end if;
    if Racketparam[i] == 0 then
      Racketparam_new[i] := 0.29056 - 0.08775 * AF[i];
    else
      Racketparam_new[i] := Racketparam[i];
    end if;
    temp[i] := R * (Tc[i] / Pcm[i]) * Racketparam_new[i] ^ (1 + (1 - Tr[i]) ^ (2 / 7));
    if T < Tc[i] then
      a := -9.070217;
      b := 62.45326;
      d := -135.1102;
      f := 4.79594;
      g := 0.250047;
      h := 1.14188;
      j := 0.0861488;
      k := 0.0344483;
      e[NOC] := exp(f + g * AF[i] + h * AF[i] * AF[i]);
      c[NOC] := j + k * AF[i];
      Beta[i] := Pc[i] * ((-1) + a * (1 - Tr[i]) ^ (1 / 3) + b * (1 - Tr[i]) ^ (2 / 3) + d * (1 - Tr[i]) + e[i] * (1 - Tr[i]) ^ (4 / 3));
      tempcor[i] := temp[i] * (1 - c[i] * log((Beta[i] + P) / (Beta[i] + Psat[i])));
      Density[i] := 0.001 * MW[i] / (tempcor[i] * 0.000001);
    else
      Density[i] := 0.001 * MW[i] / (temp[i] * 0.000001);
    end if;
  end for;
end Density_Racket;

function PoyntingCF
  import Simulator.Files.Thermodynamic_Functions.*;
  input Integer NOC;
  input Real Pc[NOC], Tc[NOC], Racketparam[NOC], AF[NOC], MW[NOC];
  input Real T, P;
  input Real gamma[NOC], Psat[NOC], Density[NOC];
  parameter Integer Choice = 2;
  output Real PCF[NOC];
protected
  Real vl[NOC];
algorithm
  for i in 1:NOC loop
    if T < 0.98 * Tc[i] then
      vl[i] := 1 / Density[i];
    end if;
  end for;
  for i in 1:NOC loop
    if Choice == 1 then
      PCF[i] := exp(vl[i] * abs(P - Psat[i]) / (8314.47 * T));
    else
      PCF[i] := 1;
    end if;
  end for;
end PoyntingCF;

 
   function Solublity_Parameter
   
   input Integer NOC;
   input Real V[NOC];
   input Real Sp[NOC];
   input Real compMolFrac[NOC];
   
   output Real S;
   protected Real Vs,Vtot;
   
   algorithm
     
     Vtot := sum(compMolFrac[:] .* V[:]);
     Vs :=   sum(compMolFrac[:] .* V[:] .* Sp[:]);
     
     if(Vtot==0) then
     S :=0;
     else
     S := Vs / Vtot;
     end if;
   
   end Solublity_Parameter;
   
   
   
   function EOS_ConstantII
   parameter Real R_gas = 8.314;
   input Integer NOC;
   input Real Tc[NOC],Pc[NOC];
   input Real T;
    
   output Real b[NOC];
   
   algorithm
   
     for i in 1:NOC loop
     b[i] := 0.08664 * R_gas * (Tc[i] / Pc[i]);
     end for;
   end EOS_ConstantII;
   
   
   function EOS_ConstantIII
   
   input Integer NOC;
   input Real a[NOC];
   
   output Real a_ij[NOC,NOC];
   
   algorithm
   
   for i in 1:NOC loop
     a_ij[i,:] := (a[i] .* a[:]) .^ 0.5;
   end for;
     
   end EOS_ConstantIII;
   
   function EOS_Constant1V
   
   input Integer NOC;
   input Real compMolFrac[NOC];
   input Real a_ij[NOC,NOC];
   
   output Real amv;
   protected Real amvv[NOC];
   
   algorithm
     for i in 1:NOC loop
     amvv[i] := sum(compMolFrac[i] .* compMolFrac[:] .* a_ij[i,:]); 
     end for;  
     amv := sum(amvv[:]);
   end EOS_Constant1V;
   
   function EOS_Constants
   
   parameter Real R_gas = 8.314;
   input Integer NOC;
   input Real Tc[NOC],Pc[NOC];
   input Real T;
    
   output Real a[NOC];
   
   algorithm
   
     for i in 1:NOC loop
     a[i] := 0.42748 * (R_gas^2) * ((Tc[i] ^ 2.5) / (Pc[i] * (T ^ 0.5)));
    
     end for;
   
   end EOS_Constants;
   
   
   function Liquid_Fugacity_Coeffcient
   
   input Integer NOC;
   
   input Real Sp[NOC];
   input Real Tc[NOC];
   input Real Pc[NOC];
   input Real w[NOC];
   input Real T,P;
   input Real V[NOC];
   input Real S;
   input Real gamma[NOC];
   
   output Real liqfugcoeff[NOC](each start = 2);
   protected Real Tr[NOC];
   protected Real Pr[NOC];
   protected Real v0[NOC](each start=2),v1[NOC](each start=2),v[NOC];
   protected Real A[10];
   
   algorithm
    
   
     for i in 1:NOC loop
     Tr[i] := T / Tc[i];
     Pr[i] := P / Pc[i];
    
     if(Tc[i] == 33.19) then
       A[1] := 1.50709;
       A[2] := 2.74283;
       A[3] := -0.0211;
       A[4] := 0.00011;
       A[5] := 0;
       A[6] := 0.008585;
       A[7] := 0;
       A[8] := 0;
       A[9] := 0;
       A[10] :=0;
     
          v0[i] := 10^(A[1] + (A[2]/Tr[i]) + (A[3]*Tr[i])+(A[4] *Tr[i] *Tr[i])+(A[5] *Tr[i]*Tr[i]*Tr[i])+((A[6] +(A[7] *Tr[i]) +(A[8]*Tr[i]*Tr[i]))*Pr[i])+((A[9] +(A[10]*Tr[i]))*(Pr[i]*Pr[i])) - (log10(Pr[i])));
         
      elseif(Tc[i] == 190.56) then 
       A[1] := 1.36822;
       A[2] := -1.54831;
       A[3] := 0;
       A[4] := 0.02889;
       A[5] := -0.01076;
       A[6] := 0.10486;
       A[7] := -0.02529;
       A[8] := 0;
       A[9] := 0;
       A[10] := 0;
    
      v0[i] := 10^(A[1] + (A[2]/Tr[i]) + (A[3]*Tr[i])+(A[4] *Tr[i] *Tr[i])+(A[5] *Tr[i]*Tr[i]*Tr[i])+((A[6] +(A[7] *Tr[i]) +(A[8]*Tr[i]*Tr[i]))*Pr[i])+((A[9] +(A[10]*Tr[i]))*(Pr[i]*Pr[i])) - (log10(Pr[i])));   
     
     else 
       A[1] := 2.05135;
       A[2] := -2.10889;
       A[3] := 0;
       A[4] := -0.19396;
       A[5] := 0.02282;
       A[6] := 0.08852;
       A[7] := 0;
       A[8] := -0.00872;
       A[9] := -0.00353;
       A[10] := 0.00203;
     
     v0[i] := 10^(A[1] + (A[2]/Tr[i]) + (A[3]*Tr[i])+(A[4] *Tr[i] *Tr[i])+(A[5] *Tr[i]*Tr[i]*Tr[i])+((A[6] +(A[7] *Tr[i]) +(A[8]*Tr[i]*Tr[i]))*Pr[i])+((A[9] +(A[10]*Tr[i]))*(Pr[i]*Pr[i])) - (log10(Pr[i])));
       
    end if;
    
      v1[i] := 10^(-4.23893 + (8.65808 * Tr[i]) - (1.2206 / Tr[i]) - (3.15224 * Tr[i] ^ 3) - 0.025 * (Pr[i] - 0.6));
    
    if(v1[i] == 0) then 
      v[i]  := 10^(log10(v0[i]) );
    else 
      v[i]  := 10^(log10(v0[i]) + (w[i] * log10(v1[i])));
    end if; 
     liqfugcoeff[i] := v[i] * gamma[i];
   end for; 
   
   end Liquid_Fugacity_Coeffcient;

end Thermodynamic_Functions;
