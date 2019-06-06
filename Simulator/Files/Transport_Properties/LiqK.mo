within Simulator.Files.Transport_Properties;

function LiqK
  input Real LiqK[6] "from chemsep database";
  input Real T(unit = "K") "Temperature";
  output Real k_liq;
algorithm
  k_liq := LiqK[2] + exp(LiqK[3] / T + LiqK[4] + LiqK[5] * T + LiqK[6] * T ^ 2);
end LiqK;
