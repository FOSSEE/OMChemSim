within Simulator.Files.Thermodynamic_Functions;

function LiqCpId
  /*Calculates specific heat of liquid at given Temperature*/
  input Real LiqCp[6] "from chemsep database";
  input Real T(unit = "K") "Temperature";
  output Real Cp(unit = "J/mol") "Specific heat of liquid";
algorithm
  Cp := (LiqCp[2] + exp(LiqCp[3] / T + LiqCp[4] + LiqCp[5] * T + LiqCp[6] * T ^ 2)) / 1000;
end LiqCpId;
