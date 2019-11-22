within Simulator.Files.ThermodynamicFunctions;

  function Psat
    extends Modelica.Icons.Function;
    /*Returns vapor pressure at given temperature*/
    input Real VP[6] "from chemsep database";
    input Real T(unit = "K") "Temperature";
    output Real Pvap(unit = "Pa") "Vapor pressure";
  algorithm
    Pvap := exp(VP[2] + VP[3] / T + VP[4] * log(T) + VP[5] .* T .^ VP[6]);
  end Psat;
