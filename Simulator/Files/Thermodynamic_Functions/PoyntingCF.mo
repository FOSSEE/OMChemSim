within Simulator.Files.Thermodynamic_Functions;

function PoyntingCF
  import Simulator.Files.Thermodynamic_Functions.*;
  input Integer NOC;
  input Real Pc, Tc, Racketparam, AF, MW;
  input Real T, P;
  input Real gamma, Psat, Density;
  parameter Integer Choice = 2;
  output Real PCF;
protected
  Real vl;
algorithm
    if T < 0.98 * Tc then
      vl := 1 / Density;
    end if;
  end for;
  for i in 1:NOC loop
    if Choice == 1 then
      PCF := exp(vl * abs(P - Psat) / (8314.47 * T));
    else
      PCF := 1;
    end if;
end PoyntingCF;
