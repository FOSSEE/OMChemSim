within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_PR;

model PR
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  parameter Integer NOC;
  parameter Real R = 8.314;
  parameter Real kij[NOC, NOC] = Simulator.Files.Thermodynamic_Functions.BIP_PR(NOC, comp.name);
  Real Tr[NOC];
  Real b[NOC];
  Real m[NOC];
  Real q[NOC];
  Real a[NOC];
  Real aij[NOC, NOC];
  Real amL, bmL;
  Real AL, BL, Z_L[3];
  Real ZL;
  Real sum_xa[NOC];
  Real liqfugcoeff[NOC];
  Real amV, bmV;
  Real AV, BV, Z_V[3];
  Real ZV;
  Real sum_ya[NOC];
  Real vapfugcoeff[NOC];
  Real P;
  Real T(start = 273);
  Real Psat[NOC];
  //Bubble and Dew Point Calculation
  Real Tr_bubl[NOC];
  Real a_bubl[NOC];
  Real aij_bubl[NOC, NOC];
  Real Psat_bubl[NOC];
  Real amL_bubl, bmL_bubl;
  Real AL_bubl, BL_bubl, Z_L_bubl[3];
  Real ZL_bubl;
  Real sum_xa_bubl[NOC];
  Real liqfugcoeff_bubl[NOC];
  Real gammaBubl[NOC];
  Real Tbubl(start = 273);
equation
  for i in 1:NOC loop
    Psat_bubl[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, Tbubl);
    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
  end for;
//Bubble Point and Dew Point Calculation Routine
  Tr_bubl = Tbubl ./ comp.Tc;
  a_bubl = q .* (1 .+ m .* (1 .- sqrt(Tr_bubl))) .^ 2;
  aij_bubl = {{(1 - kij[i, j]) * sqrt(a_bubl[i] * a_bubl[j]) for i in 1:NOC} for j in 1:NOC};
  (amL_bubl, bmL_bubl, AL_bubl, BL_bubl, Z_L_bubl) = Compresseblity_Factor(b, aij_bubl, P, Tbubl, NOC, x[:]);
  ZL_bubl = min({Z_L_bubl});
  sum_xa_bubl = {sum({x[j] * aij_bubl[i, j] for j in 1:NOC}) for i in 1:NOC};
  liqfugcoeff_bubl = exp(AL_bubl / (BL_bubl * sqrt(8)) * log((ZL_bubl + 2.4142135 * BL_bubl) / (ZL_bubl - 0.414213 * BL_bubl)) .* (b / bmL_bubl .- 2 * sum_xa_bubl / amL_bubl) .+ (ZL_bubl - 1) * (b / bmL_bubl) .- log(ZL_bubl - BL_bubl));
  liqfugcoeff_bubl[:] = gammaBubl[:] .* P ./ Psat_bubl[:];
  P = sum(gammaBubl[:] .* x[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / Tbubl + comp[:].VP[4] * log(Tbubl) + comp[:].VP[5] .* Tbubl .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Calculation of Temperatures at different compositions
  Tr = T ./ comp.Tc;
  b = 0.0778 * R * comp.Tc ./ comp.Pc;
  m = 0.37464 .+ 1.54226 * comp.AF .- 0.26992 * comp.AF .^ 2;
  q = 0.45724 * R ^ 2 * comp.Tc .^ 2 ./ comp.Pc;
  a = q .* (1 .+ m .* (1 .- sqrt(Tr))) .^ 2;
  aij = {{(1 - kij[i, j]) * sqrt(a[i] * a[j]) for i in 1:NOC} for j in 1:NOC};
//Liquid Phase Calculation Routine
  (amL, bmL, AL, BL, Z_L) = Compresseblity_Factor(b, aij, P, T, NOC, x[:]);
  ZL = min({Z_L});
  sum_xa = {sum({x[j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
  liqfugcoeff = exp(AL / (BL * sqrt(8)) * log((ZL + 2.4142135 * BL) / (ZL - 0.414213 * BL)) .* (b / bmL .- 2 * sum_xa / amL) .+ (ZL - 1) * (b / bmL) .- log(ZL - BL));
//Vapour Phase Calculation Routine
  (amV, bmV, AV, BV, Z_V) = Compresseblity_Factor(b, aij, P, T, NOC, y[:]);
  ZV = max({Z_V});
  sum_ya = {sum({y[j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
  vapfugcoeff = exp(AV / (BV * sqrt(8)) * log((ZV + 2.4142135 * BV) / (ZV - 0.414213 * BV)) .* (b / bmV .- 2 * sum_ya / amV) .+ (ZV - 1) * (b / bmV) .- log(ZV - BV));
end PR;
