within Simulator.Files.Thermodynamic_Functions;

function Psat
  /*Returns vapor pressure at given temperature*/
  input Real VP[6] "from chemsep database";
  input Real T(unit = "K") "Temperature";
  output Real Vp(unit = "Pa") "Vapor pressure";
algorithm
  Vp := exp(VP[2] + VP[3] / T + VP[4] * log(T) + VP[5] .* T .^ VP[6]);
end Psat;
