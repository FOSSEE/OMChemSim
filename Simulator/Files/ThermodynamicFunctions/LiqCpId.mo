within Simulator.Files.ThermodynamicFunctions;

  function LiqCpId
    /*Calculates specific heat of liquid at given Temperature*/
    extends Modelica.Icons.Function;
    input Real LiqCp[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Cpliq(unit = "J/mol") "Specific heat of liquid";
  algorithm
    Cpliq := (LiqCp[2] + exp(LiqCp[3] / T + LiqCp[4] + LiqCp[5] * T + LiqCp[6] * T ^ 2)) / 1000;
  end LiqCpId;
