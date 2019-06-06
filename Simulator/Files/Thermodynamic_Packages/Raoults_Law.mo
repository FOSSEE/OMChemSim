within Simulator.Files.Thermodynamic_Packages;

model Raoults_Law
  import Simulator.Files.Thermodynamic_Functions.*;
  Real K[NOC](each min = 0), resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
  Real gamma[NOC], gammaBubl[NOC], gammaDew[NOC];
  Real liqfugcoeff_bubl[NOC], vapfugcoeff_dew[NOC], Psat[NOC];
equation
  for i in 1:NOC loop
    gamma[i] = 1;
    gammaBubl[i] = 1;
    gammaDew[i] = 1;
    liqfugcoeff_bubl[i] = 1;
    vapfugcoeff_dew[i] = 1;
  end for;
  for i in 1:NOC loop
    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
  end for;
  for j in 1:NOC loop
    K[j] = Psat[j] / P;
  end for;
  resMolSpHeat[:] = zeros(3);
  resMolEnth[:] = zeros(3);
  resMolEntr[:] = zeros(3);
end Raoults_Law;
