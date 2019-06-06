within Simulator.Files.Thermodynamic_Packages;

model UNIQUAC
  //Libraries
  import Simulator.Files.*;
  //Parameter Section
  //Binary Interaction Parameters
  //Function :BIP_UNIQUAC is used to obtain the interaction parameters
  parameter Real a[NOC, NOC] = Thermodynamic_Functions.BIP_UNIQUAC(NOC, comp.name);
  //Uniquac Parameters R and Q called from Chemsep Database
  parameter Real R[NOC] = comp.UniquacR;
  parameter Real Q[NOC] = comp.UniquacQ;
  parameter Integer Z = 10 "Compresseblity-Factor";
  //Variable Section
  Real tow[NOC, NOC] "Energy interaction parameter";
  //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at the input conditions
  Real r(each start = 2, min = 0, max = 1), q(each start = 2);
  Real teta[NOC];
  Real S[NOC](each start = 1);
  Real sum[NOC];
  //Activity Coefficients
  Real gammac[NOC](each start = 1.2) "Combinatorial Part of activity coefficent at input conditions";
  Real gammar[NOC](each start = 1.2) "Residual part of activity coefficient at input conditions";
  Real gamma_new[NOC](each start = 1.2);
  Real gamma[NOC](each start = 1.2) "Activity coefficient with Poynting correction";
  //Fugacity coefficient
  Real phil[NOC](each start = 0.5) "Fugacity coefficient at the input conditions";
  //Dew Point Calculation Variables
  Real dewLiqMolFrac[NOC](each start = 0.5, each min = 0, each max = 1);
  //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at dew point
  Real r_dew(start = 2), q_dew(start = 2);
  Real teta_dew[NOC](each start = 2);
  Real S_dew[NOC](each start = 1);
  Real sum_dew[NOC](each start = 2);
  //Activity Coefficients
  Real gammac_dew[NOC](each start = 5) "Combinatorial Part of activity coefficent at dew point";
  Real gammar_dew[NOC](each start = 2.5) "Residual part of activity coefficient at dew point";
  Real gammaDew_old[NOC](each start = 2.2) "Combinatorial Part of activity coefficent(without correction)";
  Real gammaDew[NOC](each start = 2.2) "Activity coefficent at dew point";
  //Fugacity coefficient
  Real vapfugcoeff_dew[NOC] "Vapour Fugacity coefficient at dew point";
  Real phil_dew[NOC](each start = 0.5);
  Real PCF_dew[NOC] "Poynting Correction Factor";
  //Bubble Point Calculation Variables
  //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at bubble point
  Real r_bubl(start = 2), q_bubl(start = 2);
  Real teta_bubl[NOC];
  Real S_bubl[NOC];
  Real sum_bubl[NOC];
  //Activity Coefficients
  Real gammac_bubl[NOC](each start = 2) "Combinatorial Part of activity coefficent at bubble point";
  Real gammar_bubl[NOC](each start = 1) "Residual part of activity coefficent at bubble point";
  Real gammaBubl_old[NOC](each start = 1) "Combinatorial Part of activity coefficent(without correction)";
  Real gammaBubl[NOC](each start = 1) "Activity coefficent at bubble point";
  //Fugacity coefficient
  Real liqfugcoeff_bubl[NOC];
  Real phil_bubl[NOC](each start = 0.5) "Liquid Phase Fugacity coefficient";
  Real PCF_bubl[NOC] "Poynting Correction Factor";
  //Phase Envelope
  Real Psat[NOC](each unit = "Pa") "Saturated Vapour Pressure at the input temperature";
  Real PCF[NOC] "Poynting correction factor";
  Real K[NOC](each start = 0.7) "Distribution Coefficient";
  //Residual Energy Parameters
  Real resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
  //Transport Properties at the input conditions
  Real Density[NOC](each unit = "kmol/m^3");
  Real A[NOC], B[NOC], D[NOC], E[NOC], Ff[NOC];
  Real C[NOC];
  Real A_bubl[NOC], B_bubl[NOC], C_bubl[NOC], D_bubl[NOC], E_bubl[NOC], F_bubl[NOC];
  Real A_dew[NOC], B_dew[NOC], C_dew[NOC], D_dew[NOC], E_dew[NOC], F_dew[NOC];
  //===========================================================================================================
  //Equation Section
equation
//Fugacity coefficients set to 1 since the model type is Activity Coefficient
  for i in 1:NOC loop
    liqfugcoeff_bubl[i] = 1;
    vapfugcoeff_dew[i] = 1;
  end for;
//Calculation of Intermediate parameters to evaluate combinatorial and residual part of the activity coefficient
//Note : compMolFrac is the referenced from "Material Stream" model
  r = sum(compMolFrac[2, :] .* R[:]);
  q = sum(compMolFrac[2, :] .* Q[:]);
//Calculation of Energy interaction parameter at the input tempetraure
//Function :Tow_UNIQUAC is used to instantiated
  tow = Simulator.Files.Thermodynamic_Functions.Tow_UNIQUAC(NOC, a, T);
//Calculation of Combinatorial and Residual Activity coefficient
  for i in 1:NOC loop
    if q > 0 then
      teta[i] = compMolFrac[2, i] * Q[i] * (1 / q);
    elseif q < 0 then
      teta[i] = 0;
    else
      teta[i] = 0;
    end if;
  end for;
  for i in 1:NOC loop
    if teta[i] == 0 then
      S[i] = 1;
    else
      S[i] = sum(teta[:] .* tow[i, :]);
    end if;
    if S[i] == 1 then
      sum[i] = 0;
    else
      sum[i] = sum(teta[:] .* tow[i, :] ./ S[:]);
    end if;
  end for;
  for i in 1:NOC loop
    if S[i] == 1 then
      C[i] = 0;
    elseif S[i] > 0 then
      C[i] = log(S[i]);
    else
      C[i] = 0;
    end if;
    gammar[i] = exp(Q[i] * (1 - C[i] - sum[i]));
  end for;
// //===================================================================
//     equation
  for i in 1:NOC loop
    if r > 0 then
      D[i] = R[i] / r;
    elseif r <= 0 then
      D[i] = 0;
    else
      D[i] = 0;
    end if;
    if q > 0 then
      E[i] = Q[i] / q;
    elseif q <= 0 then
      E[i] = 0;
    else
      E[i] = 0;
    end if;
    if E[i] == 0 or D[i] == 0 then
      Ff[i] = 0;
    else
      Ff[i] = D[i] / E[i];
    end if;
    if D[i] > 0 then
      A[i] = log(D[i]);
    elseif D[i] == 1 then
      A[i] = 0;
    else
      A[i] = 0;
    end if;
    if Ff[i] > 1 then
      B[i] = log(Ff[i]);
    elseif Ff[i] == 1 then
      B[i] = 0;
    else
      B[i] = 0;
    end if;
    log(gammac[i]) = 1 - D[i] + A[i] + (-Z / 2 * Q[i] * (1 - Ff[i] + B[i]));
    gamma[i] = gammac[i] * gammar[i];
  end for;
//=====================================================================================================
//Excess Energy parameters are set to 0 since the calculation mode is Ideal
  resMolSpHeat[:] = zeros(3);
  resMolEnth[:] = zeros(3);
  resMolEntr[:] = zeros(3);
//Calculation of Saturated vapour pressure and Density at the given input condition
  for i in 1:NOC loop
    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
    Density[i] = Simulator.Files.Thermodynamic_Functions.Dens(comp[i].LiqDen, comp[i].Tc, T, P) * 1E-3;
  end for;
//Calculation of Poynting correction Factor at input conditions,Bubble Point and Dew Point
//Function :Poynting_CF is called from the Simulator Package
  PCF[:] = Thermodynamic_Functions.PoyntingCF(NOC, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, T, P, gamma[:], Psat[:], Density[:]);
  PCF_bubl[:] = Thermodynamic_Functions.PoyntingCF(NOC, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, T, Pbubl, gamma[:], Psat[:], Density[:]);
  PCF_dew[:] = Thermodynamic_Functions.PoyntingCF(NOC, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, T, Pdew, gamma[:], Psat[:], Density[:]);
//Calculation of Fugacity coefficient with Poynting correction
  phil[:] = gamma[:] .* Psat[:] ./ P .* PCF[:];
  phil[:] = gamma_new[:] .* Psat[:] ./ P;
//Calculation of Distribution coefficient
  K[:] = gamma_new[:] .* Psat[:] ./ P;
//Binary Phase Envelope
//The same calculation routine is followed at the DewPoint
//Dew Point
  r_dew = sum(dewLiqMolFrac[:] .* R[:]);
  q_dew = sum(dewLiqMolFrac[:] .* Q[:]);
  for i in 1:NOC loop
    if q_dew == 0 or compMolFrac[1, i] == 0 then
      dewLiqMolFrac[i] = 0;
    else
      dewLiqMolFrac[i] = compMolFrac[1, i] * Pdew / (gammaDew[i] * Psat[i]);
    end if;
    if q_dew == 0 or dewLiqMolFrac[i] == 0 then
      teta_dew[i] = 0;
    else
      teta_dew[i] = dewLiqMolFrac[i] * Q[i] * (1 / q_dew);
    end if;
    if teta_dew[i] == 0 then
      S_dew[i] = 1;
    else
      S_dew[i] = sum(teta_dew[:] .* tow[i, :]);
    end if;
  end for;
//===================================================================================================
  for i in 1:NOC loop
    if S_dew[i] == 1 then
      sum_dew[i] = 0;
    else
      sum_dew[i] = sum(teta_dew[:] .* tow[i, :] ./ S_dew[:]);
    end if;
    if S_dew[i] == 1 then
      C_dew[i] = 0;
    elseif S_dew[i] > 0 then
      C_dew[i] = log(S_dew[i]);
    else
      C_dew[i] = 0;
    end if;
    gammar_dew[i] = exp(Q[i] * (1 - C_dew[i] - sum_dew[i]));
  end for;
//===============================================================================================
  for i in 1:NOC loop
    if r_dew == 0 then
      D_dew[i] = 0;
    else
      D_dew[i] = R[i] / r_dew;
    end if;
    if q_dew == 0 then
      E_dew[i] = 0;
    else
      E_dew[i] = Q[i] / q_dew;
    end if;
    if E_dew[i] == 0 then
      F_dew[i] = 0;
    else
      F_dew[i] = D_dew[i] / E_dew[i];
    end if;
    if D_dew[i] > 0 then
      A_dew[i] = log(D_dew[i]);
    elseif D_dew[i] == 1 then
      A_dew[i] = 0;
    else
      A_dew[i] = 0;
    end if;
    if F_dew[i] > 0 then
      B_dew[i] = log(F_dew[i]);
    elseif F_dew[i] == 1 then
      B_dew[i] = 0;
    else
      B_dew[i] = 0;
    end if;
    log(gammac_dew[i]) = 1 - D_dew[i] + A_dew[i] + (-Z / 2 * Q[i] * (1 - F_dew[i] + B_dew[i]));
    gammaDew_old[i] = gammac_dew[i] * gammar_dew[i];
  end for;
  for i in 1:NOC loop
    if Pdew == 0 then
      phil_dew[i] = 1;
      gammaDew[i] = 1;
    else
      phil_dew[i] = gammaDew_old[i] .* Psat[i] ./ Pdew .* PCF_dew[i];
      phil_dew[i] = gammaDew[i] .* Psat[i] ./ Pdew;
    end if;
  end for;
//The same calculation routine is followed at the Bubble Point
//Bubble Point
  r_bubl = sum(compMolFrac[1, :] .* R[:]);
  q_bubl = sum(compMolFrac[1, :] .* Q[:]);
  for i in 1:NOC loop
    if compMolFrac[1, i] == 0 then
      teta_bubl[i] = 0;
    else
      teta_bubl[i] = compMolFrac[1, i] * Q[i] * (1 / q_bubl);
    end if;
    if teta_bubl[i] == 0 then
      S_bubl[i] = 1;
    else
      S_bubl[i] = sum(teta_bubl[:] .* tow[i, :]);
    end if;
    if S_bubl[i] == 1 then
      sum_bubl[i] = 0;
    else
      sum_bubl[i] = sum(teta_bubl[:] .* tow[i, :] ./ S_bubl[:]);
    end if;
    if S_bubl[i] == 1 then
      C_bubl[i] = 0;
    elseif S_bubl[i] > 0 then
      C_bubl[i] = log(S_bubl[i]);
    else
      C_bubl[i] = 0;
    end if;
    log(gammar_bubl[i]) = Q[i] * (1 - C_bubl[i] - sum_bubl[i]);
//=========================================================================================================
    if r_bubl == 0 then
      D_bubl[i] = 0;
    else
      D_bubl[i] = R[i] / r_bubl;
    end if;
    if q_bubl == 0 then
      E_bubl[i] = 0;
    else
      E_bubl[i] = Q[i] / q_bubl;
    end if;
    if E_bubl[i] == 0 then
      F_bubl[i] = 0;
    else
      F_bubl[i] = D_bubl[i] / E_bubl[i];
    end if;
    if D_bubl[i] > 0 then
      A_bubl[i] = log(D_bubl[i]);
    elseif D_bubl[i] == 1 then
      A_bubl[i] = 0;
    else
      A_bubl[i] = 0;
    end if;
    if F_bubl[i] > 0 then
      B_bubl[i] = log(F_bubl[i]);
    elseif F_bubl[i] == 1 then
      B_bubl[i] = 0;
    else
      B_bubl[i] = 0;
    end if;
    log(gammac_bubl[i]) = 1 - D_bubl[i] + A_bubl[i] + (-Z / 2 * Q[i] * (1 - F_bubl[i] + B_bubl[i]));
    gammaBubl_old[i] = gammac_bubl[i] * gammar_bubl[i];
  end for;
  for i in 1:NOC loop
    if Pbubl == 0 then
      phil_bubl[i] = 1;
      gammaBubl[i] = 1;
    else
      phil_bubl[i] = gammaBubl_old[i] .* Psat[i] ./ Pbubl .* PCF_bubl[i];
      phil_bubl[i] = gammaBubl[i] .* Psat[i] ./ Pbubl;
    end if;
  end for;
  annotation(
    Documentation(info = "<html>
     <p>
    UNIQUAC-Universal Quasi Coefficient Model
    </p>
    <b>Description</b>:<br>
    </p>
    UNIQUAC(Univeral Quasi Coefficient) model is an activity coefficient based thermodynamic model used to predict phase equilibria in Chemical Engineering. 
    The activity coefficent comprises of two major contibutions named as combinatorial and residual contribution
    Combinatorial contribution focusses on the deviation from ideality as a result of molecular shape while the residual contribution quantifies the enthalpic correction caused by the change in interactive forces between different molecules.<br>
    </p>
    <b>Equations and References</b>:<br>
    </p>https://wikimedia.org/api/rest_v1/media/math/render/svg/21b673ea8edb013fc1675d11b7e40263bef90ffa
    </p>
    </tr>
    </html>"),
    experiment(StopTime = 1.0, Interval = 0.001));
end UNIQUAC;
