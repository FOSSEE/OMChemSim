within Simulator.Files.Thermodynamic_Packages;

model Peng_Robinson
  import Simulator.Files.*;
  parameter Real R = 8.314;
  // feed composition
  Real Tr[NOC](each start = 100) "reduced temperature";
  Real b[NOC];
  Real a[NOC](each start = 0.5);
  Real m[NOC];
  Real q[NOC];
  parameter Real kij[NOC, NOC](each start = 1) = Simulator.Files.Thermodynamic_Functions.BIP_PR(NOC, comp.name);
  Real aij[NOC, NOC];
  Real K[NOC](each start = 0.2);
  Real Psat[NOC];
  Real liqfugcoeff[NOC](each start = 5);
  Real vapfugcoeff[NOC](each start = 5);
  Real gammaBubl[NOC], gammaDew[NOC];
  Real liqfugcoeff_bubl[NOC], vapfugcoeff_dew[NOC];
  Real resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
  //Liquid Fugacity Coefficient
  Real aML, bML;
  Real AL, BL;
  Real CL[4];
  Real Z_RL[3, 2];
  Real ZL[3], ZLL;
  Real sum_xaL[NOC];
  //Vapour Fugacity Coefficient
  Real aMV, bMV;
  Real AV, BV;
  Real CV[4];
  Real Z_RV[3, 2];
  Real ZV[3], ZvV;
  Real sum_yaV[NOC];
  Real A, B, C, D[NOC], E, F, G, H[NOC], I[NOC], J[NOC];
  Real gamma[NOC];
equation
  for i in 1:NOC loop
    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
    gammaDew[i] = 1;
    gammaBubl[i] = 1;
    liqfugcoeff_bubl[i] = 1;
    vapfugcoeff_dew[i] = 1;
    gamma[i] = 1;
  end for;
  resMolSpHeat[:] = zeros(3);
  resMolEnth[:] = zeros(3);
  resMolEntr[:] = zeros(3);
  Tr = T ./ comp.Tc;
  b = 0.0778 * R * comp.Tc ./ comp.Pc;
  m = 0.37464 .+ 1.54226 * comp.AF .- 0.26992 * comp.AF .^ 2;
  q = 0.45724 * R ^ 2 * comp.Tc .^ 2 ./ comp.Pc;
  a = q .* (1 .+ m .* (1 .- sqrt(Tr))) .^ 2;
  aij = {{(1 - kij[i, j]) * sqrt(a[i] * a[j]) for i in 1:NOC} for j in 1:NOC};
//Liquid_Fugacity Coefficient Calculation Routine
  aML = sum({{compMolFrac[2, i] * compMolFrac[2, j] * aij[i, j] for i in 1:NOC} for j in 1:NOC});
  bML = sum(b .* compMolFrac[2, :]);
  AL = aML * P / (R * T) ^ 2;
  BL = bML * P / (R * T);
  CL[1] = 1;
  CL[2] = BL - 1;
  CL[3] = AL - 3 * BL ^ 2 - 2 * BL;
  CL[4] = BL ^ 3 + BL ^ 2 - AL * BL;
  Z_RL = Modelica.Math.Vectors.Utilities.roots(CL);
  ZL = {Z_RL[i, 1] for i in 1:3};
  ZLL = min({ZL});
  sum_xaL = {sum({compMolFrac[2, j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
  if ZLL + 2.4142135 * BL <= 0 then
    A = 1;
  else
    A = ZLL + 2.4142135 * BL;
  end if;
  if ZLL - 0.414213 * BL <= 0 then
    B = 1;
  else
    B = ZLL - 0.414213 * BL;
  end if;
  if ZLL - BL <= 0 then
    C = 0;
  else
    C = log(ZLL - BL);
  end if;
  for i in 1:NOC loop
    if bML == 0 then
      D[i] = 0;
    else
      D[i] = b[i] / bML;
    end if;
  end for;
  for i in 1:NOC loop
    if aML == 0 then
      J[i] = 0;
    else
      J[i] = sum_xaL[i] / aML;
    end if;
  end for;
  liqfugcoeff = exp(AL / (BL * sqrt(8)) * log(A / B) .* (D .- 2 * J) .+ (ZLL - 1) * D .- C);
//Vapour Fugacity Calculation Routine
  aMV = sum({{compMolFrac[3, i] * compMolFrac[3, j] * aij[i, j] for i in 1:NOC} for j in 1:NOC});
  bMV = sum(b .* compMolFrac[3, :]);
  AV = aMV * P / (R * T) ^ 2;
  BV = bMV * P / (R * T);
  CV[1] = 1;
  CV[2] = BV - 1;
  CV[3] = AV - 3 * BV ^ 2 - 2 * BV;
  CV[4] = BV ^ 3 + BV ^ 2 - AV * BV;
  Z_RV = Modelica.Math.Vectors.Utilities.roots(CV);
  ZV = {Z_RV[i, 1] for i in 1:3};
  ZvV = max({ZV});
  sum_yaV = {sum({compMolFrac[3, j] * aij[i, j] for j in 1:NOC}) for i in 1:NOC};
  if ZvV + 2.4142135 * BV <= 0 then
    E = 1;
  else
    E = ZvV + 2.4142135 * BV;
  end if;
  if ZvV - 0.414213 * BV <= 0 then
    F = 1;
  else
    F = ZvV - 0.414213 * BV;
  end if;
  if ZvV - BV <= 0 then
    G = 0;
  else
    G = log(ZvV - BV);
  end if;
  for i in 1:NOC loop
    if bMV == 0 then
      H[i] = 0;
    else
      H[i] = b[i] / bMV;
    end if;
  end for;
  for i in 1:NOC loop
    if aMV == 0 then
      I[i] = 0;
    else
      I[i] = sum_yaV[i] / aMV;
    end if;
  end for;
  vapfugcoeff = exp(AV / (BV * sqrt(8)) * log(E / F) .* (H .- 2 * I) .+ (ZvV - 1) * H .- G);
  for i in 1:NOC loop
    if liqfugcoeff[i] == 0 or vapfugcoeff[i] == 0 then
      K[i] = 0;
    else
      K[i] = liqfugcoeff[i] / vapfugcoeff[i];
    end if;
  end for;
end Peng_Robinson;
