within Simulator.Files.Thermodynamic_Packages;

model NRTL
  import Simulator.Files.Thermodynamic_Functions.*;
  Simulator.Files.Models.gammaNRTL Gamma(NOC = NOC, comp = comp, molFrac = compMolFrac[2, :], T = T), dewGamma(NOC = NOC, comp = comp, molFrac = dewLiqMolFrac, T = T), bublGamma(NOC = NOC, comp = comp, molFrac = compMolFrac[1, :], T = T);
  Real dewLiqMolFrac[NOC], density[NOC];
  Real resMolSpHeat[3] "residual specific heat", resMolEnth[3] "residual enthalpy", resMolEntr[3] "residual Entropy", K[NOC], gamma[NOC](each start = 1), gammaBubl[NOC](each start = 1), gammaDew[NOC](each start = 1);
  Real liqfugcoeff_bubl[NOC], vapfugcoeff_dew[NOC], Psat[NOC];
equation
  gamma = Gamma.gamma;
  for i in 1:NOC loop
    dewLiqMolFrac[i] = compMolFrac[1, i] * Pdew / (gammaDew[i] * Psat[i]);
    density[i] = Dens(comp[i].LiqDen, comp[i].Tc, T, P);
  end for;
  for i in 1:NOC loop
    liqfugcoeff_bubl[i] = 1;
    vapfugcoeff_dew[i] = 1;
  end for;
  for i in 1:NOC loop
    gammaBubl[i] = bublGamma.gamma[i];
    gammaDew[i] = dewGamma.gamma[i];
  end for;
  for i in 1:NOC loop
    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
  end for;
  for i in 1:NOC loop
    K[i] = gamma[i] * Psat[i] / P;
  end for;
  resMolSpHeat[:] = zeros(3);
  resMolEnth[:] = zeros(3);
  resMolEntr = zeros(3);
end NRTL;
