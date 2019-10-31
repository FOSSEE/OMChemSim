within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_NRTL;

model NRTL_model
  import Simulator.Files.Thermodynamic_Functions.*;
  gammaNRTL_model Gamma(NOC = NOC, comp = comp, molFrac = x[:], T = T);
  Real density[NOC], BIPS[NOC, NOC, 2];
equation
  gamma = Gamma.gamma;
  BIPS = Gamma.BIPS;
  for i in 1:NOC loop
    density[i] = Dens(comp[i].LiqDen, comp[i].Tc, T, P);
  end for;
  for i in 1:NOC loop
    K[i] = gamma[i] * Psat(comp[i].VP, T) / P;
  end for;
end NRTL_model;
