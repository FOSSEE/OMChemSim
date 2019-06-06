within Simulator.Files.Thermodynamic_Functions;

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
