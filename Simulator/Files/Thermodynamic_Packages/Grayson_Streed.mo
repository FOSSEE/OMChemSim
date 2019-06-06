within Simulator.Files.Thermodynamic_Packages;

model Grayson_Streed
//  import Simulator.Files.Thermodynamic_Functions.*;
//  parameter Real R_gas = 8.314;
//  parameter Real u = 1;
//  import Simulator.Files.*;
//  //w=Acentric Factor
//  //Sp = Solublity Parameter
//  //V = Molar Volume
//  //All the above three parameters have to be mentioned as arguments while extending the thermodynamic Package Grayson Streed
//  parameter Real w[NOC];
//  parameter Real Sp[NOC](each unit = "(cal/mL)^0.5");
//  parameter Real V[NOC](each unit = "mL/mol");
//  parameter Real Tc[NOC] = comp.Tc;
//  parameter Real Pc[NOC] = comp.Pc;
//  parameter Real R = 8314470;
//  Real resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
//  Real K[NOC];
//  Real S(start = 3), gamma[NOC];
//  Real liqfugcoeff[NOC](each start = 2), vapfugcoeff[NOC](each start = 0.99), vapfugcoeff_dew[NOC](each start = 1.2);
//  Real S_bubl, liqfugcoeff_bubl[NOC](each start = 1.5), gamma_bubl[NOC];
//  //Vapour Phase Fugacity coefficient
//  Real a[NOC], b[NOC];
//  Real a_ij[NOC, NOC];
//  Real amv, amv_dew, bmv, bmv_dew;
//  Real AG, AG_dew, BG(start = 3), BG_dew;
//  Real Zv(start = 3), Zv_dew;
//  Real t1[NOC], t3[NOC], t4, t2(start = 10);
//  Real t1_dew[NOC], t3_dew[NOC], t4_dew, t2_dew(start = 10);
//  Real CV[4], Z_RV[3, 2], ZV[3];
//  Real CV_dew[4], Z_RV_dew[3, 2], ZV_dew[3];
//  Real gammaBubl[NOC](each start = 0.5), gammaDew[NOC](each start = 2.06221);
//  Real gamma_liq[NOC], Psat[NOC];
//  Real A[NOC], B[NOC], C[NOC], D[NOC], E, G, H[NOC], I, J;
//  Real dewLiqMolFrac[NOC];
//  Real Tr[NOC];
//  Real Pr_bubl[NOC](each start = 2);
//  Real v0[NOC](each start = 2), v1[NOC](each start = 2), v[NOC];
//  Real Vs, Vtot;
//equation
////======================================================================================================
////Calculation Routine for Liquid Phase Fugacity Coefficient
//  S = Solublity_Parameter(NOC, V, Sp, compMolFrac[2, :]);
//  for i in 1:NOC loop
//    gamma[i] = exp(V[i] * (Sp[i] - S) ^ 2 / (R * T));
//  end for;
//  liqfugcoeff = Liquid_Fugacity_Coeffcient(NOC, Sp, Tc, Pc, w, T, P, V, S, gamma);
//  for i in 1:NOC loop
//    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
//    gamma_liq[i] = liqfugcoeff[i] * (P / Psat[i]);
//  end for;
////========================================================================================================
////Calculation Routine for Vapour Phase Fugacity Coefficient
////Calculation of Equation of State Constants
//  a = EOS_Constants(NOC, Tc, Pc, T);
//  b = EOS_ConstantII(NOC, Tc, Pc, T);
//  a_ij = EOS_ConstantIII(NOC, a);
//  amv = EOS_Constant1V(NOC, compMolFrac[3, :], a_ij);
//  bmv = sum(compMolFrac[3, :] .* b[:]);
//  AG = amv * P / (R_gas * T) ^ 2;
//  BG = bmv * P / (R_gas * T);
//  for i in 1:NOC loop
//    if bmv == 0 then
//      C[i] = 0;
//    else
//      C[i] = b[i] / bmv;
//    end if;
//  end for;
//  for i in 1:NOC loop
//    if amv == 0 then
//      D[i] = 0;
//    else
//      D[i] = a[i] / amv;
//    end if;
//  end for;
//  for i in 1:NOC loop
//    t1[i] = b[i] * (Zv - 1) / bmv;
//    t3[i] = AG / (BG * u ^ 2 ^ 0.5) * (C[i] - 2 * D[i] ^ 0.5);
//  end for;
//  t4 = log((2 * Zv + BG * (u + u ^ 2 ^ 0.5)) / (2 * Zv + BG * (u - u ^ 2 ^ 0.5)));
//  t2 = -log(Zv - BG);
//  resMolSpHeat[:] = zeros(3);
//  resMolEnth[:] = zeros(3);
//  resMolEntr[:] = zeros(3);
//  for i in 1:NOC loop
//    vapfugcoeff[i] = exp(t1[i] + t2 + t3[i] * t4);
//    K[i] = liqfugcoeff[i] / vapfugcoeff[i];
//  end for;
////====================================================================================================
////Bubble Point Algorithm
//  Vtot = sum(compMolFrac[1, :] .* V[:]);
//  Vs = sum(compMolFrac[1, :] .* V[:] .* Sp[:]);
//  S_bubl = Vs / Vtot;
//  for i in 1:NOC loop
//    gamma_bubl[i] = exp(V[i] * (Sp[i] - S_bubl) ^ 2 / (R * T));
//  end for;
//  for i in 1:NOC loop
//    Tr[i] = T / Tc[i];
//    if Pc[i] <= 0 then
//      Pr_bubl[i] = 0;
//    else
//      Pr_bubl[i] = Pbubl / Pc[i];
//    end if;
//    if Tc[i] == 33.19 then
//      v0[i] = 10 ^ (1.50709 + 2.74283 / Tr[i] + (-0.0211) * Tr[i] + 0.00011 * Tr[i] * Tr[i] + 0.008585 - log10(Pr_bubl[i]));
//    elseif Tc[i] == 190.56 then
//      v0[i] = 10 ^ (1.36822 + (-1.54831) / Tr[i] + 0.02889 * Tr[i] * Tr[i] + (-0.01076) * Tr[i] * Tr[i] * Tr[i] + 0.10486 + (-0.02529) * Tr[i] - log10(Pr_bubl[i]));
//    else
//      v0[i] = 10 ^ (2.05135 + (-2.10889) / Tr[i] + (-0.19396) * Tr[i] * Tr[i] + 0.02282 * Tr[i] * Tr[i] * Tr[i] + (0.08852 + (-0.00872) * Tr[i] * Tr[i]) * Pr_bubl[i] + ((-0.00353) + 0.00203 * Tr[i]) * (Pr_bubl[i] * Pr_bubl[i]) - log10(Pr_bubl[i]));
//    end if;
//    v1[i] = 10 ^ ((-4.23893) + 8.65808 * Tr[i] - 1.2206 / Tr[i] - 3.15224 * Tr[i] ^ 3 - 0.025 * (Pr_bubl[i] - 0.6));
//    if v1[i] == 0 then
//      v[i] = 10 ^ log10(v0[i]);
//    else
//      v[i] = 10 ^ (log10(v0[i]) + w[i] * log10(v1[i]));
//    end if;
//    liqfugcoeff_bubl[i] = v[i] * gamma_bubl[i];
//  end for;
//  for i in 1:NOC loop
//    gammaBubl[i] = liqfugcoeff_bubl[i] * (Pbubl / Psat[i]);
//  end for;
////===================================================================================
////Dew Point Algorithm
//  for i in 1:NOC loop
//    if gammaDew[i] * Psat[i] == 0 then
//      dewLiqMolFrac[i] = 0;
//    else
//      dewLiqMolFrac[i] = compMolFrac[1, i] * Pdew / (gammaDew[i] * Psat[i]);
//    end if;
//  end for;
//  amv_dew = EOS_Constant1V(NOC, dewLiqMolFrac[:], a_ij);
//  bmv_dew = sum(dewLiqMolFrac[:] .* b[:]);
//  AG_dew = amv_dew * Pdew / (R_gas * T) ^ 2;
//  BG_dew = bmv_dew * Pdew / (R_gas * T);
//  for i in 1:NOC loop
//    if bmv_dew == 0 then
//      A[i] = 0;
//    else
//      A[i] = b[i] / bmv_dew;
//    end if;
//  end for;
//  for i in 1:NOC loop
//    if amv_dew == 0 then
//      B[i] = 0;
//    else
//      B[i] = a[i] / amv_dew;
//    end if;
//  end for;
//  if BG_dew * u ^ 2 ^ 0.5 == 0 then
//    E = 0;
//  else
//    E = BG_dew * u ^ 2 ^ 0.5;
//  end if;
//  if E == 0 then
//    G = 0;
//  else
//    G = AG_dew / E;
//  end if;
//  if bmv_dew == 0 then
//    I = 0;
//  else
//    I = (Zv_dew - 1) / bmv_dew;
//  end if;
//  if Zv_dew - BG_dew <= 0 then
//    J = 0;
//  else
//    J = -log(Zv_dew - BG_dew);
//  end if;
//  for i in 1:NOC loop
//    t1_dew[i] = b[i] * I;
//    t3_dew[i] = G * (A[i] - 2 * B[i] ^ 0.5);
//  end for;
//  if (2 * Zv_dew + BG_dew * (u + u ^ 2 ^ 0.5)) / (2 * Zv_dew + BG_dew * (u - u ^ 2 ^ 0.5)) <= 0 then
//    t4_dew = 0;
//  else
//    t4_dew = log((2 * Zv_dew + BG_dew * (u + u ^ 2 ^ 0.5)) / (2 * Zv_dew + BG_dew * (u - u ^ 2 ^ 0.5)));
//  end if;
//  t2_dew = J;
//  for i in 1:NOC loop
//    vapfugcoeff_dew[i] = exp(t1_dew[i] + t2_dew + t3_dew[i] * t4_dew);
//	if Psat[i] == 0 then
//      H[i] = 0;
//    else
//      H[i] = Pdew / Psat[i];
//    end if;
//    gammaDew[i] = vapfugcoeff_dew[i] * H[i];
//  end for;
//algorithm
//  CV_dew[1] := 1;
//  CV_dew[2] := -(1 + BG_dew - u * BG_dew);
//  CV_dew[3] := AG_dew - u * BG_dew - u * BG_dew ^ 2;
//  CV_dew[4] := -AG_dew * BG_dew;
//  Z_RV_dew := Modelica.Math.Vectors.Utilities.roots(CV_dew);
//  ZV_dew := {Z_RV_dew[i, 1] for i in 1:3};
//  Zv_dew := max({ZV_dew});
//algorithm
//  CV[1] := 1;
//  CV[2] := -(1 + BG - u * BG);
//  CV[3] := AG - u * BG - u * BG ^ 2;
//  CV[4] := -AG * BG;
//  Z_RV := Modelica.Math.Vectors.Utilities.roots(CV);
//  ZV := {Z_RV[i, 1] for i in 1:3};
//  Zv := max({ZV});
////==========================================================================================================
end Grayson_Streed;
