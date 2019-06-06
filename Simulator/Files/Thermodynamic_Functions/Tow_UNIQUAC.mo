within Simulator.Files.Thermodynamic_Functions;

function Tow_UNIQUAC
  input Integer NOC;
  input Real a[NOC, NOC];
  input Real T;
  output Real tow[NOC, NOC](start = 1);
protected
  Real R_gas = 1.98721;
algorithm
  for i in 1:NOC loop
    for j in 1:NOC loop
      tow[i, j] := exp(-a[i, j] / (R_gas * T));
    end for;
  end for;
end Tow_UNIQUAC;
