within Simulator.Files.TransportProperties;

  function LiqK
    extends Modelica.Icons.Function;
    input Real LiqK[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real kliq;
  algorithm
    kliq := LiqK[2] + exp(LiqK[3] / T + LiqK[4] + LiqK[5] * T + LiqK[6] * T ^ 2);
  end LiqK;
