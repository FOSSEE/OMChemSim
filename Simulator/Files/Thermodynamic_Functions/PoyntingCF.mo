within Simulator.Files.Thermodynamic_Functions;

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
