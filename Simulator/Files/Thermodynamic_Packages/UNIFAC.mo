within Simulator.Files.Thermodynamic_Packages;

model UNIFAC
  //Libraries
  import Simulator.Files.*;
  extends Simulator.Files.Thermodynamic_Functions;
  //Parameter Section
  parameter Integer m = 4 "substitue of number of different group";
  parameter Integer k = 4 "number of different group in component i";
  //Van de wal surface area and volume constant's
  parameter Real V[NOC, k] = {{1, 1, 1, 0}, {1, 0, 1, 0}} "number of group of kind k in molecule ";
  parameter Real R[NOC, k] = {{0.9011, 0.6744, 1.6724, 0}, {0.9011, 0, 1.6724, 0}} "group volume of group k ";
  parameter Real Q[NOC, k] = {{0.848, 0.540, 1.448, 0}, {0.848, 0, 1.448, 0}} "group surface area of group k";
  //Intreraction parameter
  parameter Real a[m, k] = {{0, 0, 476.4, 1318}, {0, 0, 476.4, 1318}, {26.76, 26.76, 0, 472.5}, {300, 300, -195.4, 0}} "Binary  intraction parameter";
  Real Psat[NOC] "Saturated Vapour Pressure at the input temperature";
  //Intermediate values used to compute UNIFAC R and Q values
  Real q[NOC] "Van der walls molecular surface area";
  Real r[NOC] "Van der walls molecular volume";
  Real e[k, NOC] "Group Surface area fraction of comp i";
  Real tau[m, k] "Boltzmann factors";
  Real B[NOC, k] "UNIFAC parameter ";
  Real theta[k] "UNIFAC parameter";
  Real sum[NOC];
  Real S[k] "Unifac parameter ";
  Real J[NOC] "Surface area fraction of comp i";
  Real L[NOC] "Molecular volume fraction of comp i";
  //Activity Coefficients
  Real gammac[NOC] "Combinatorial activity coefficient of comp i";
  Real gammar[NOC] "Residual activity coefficient of comp i";
  Real gamma[NOC] " Activity coefficient";
  Real K[NOC] "Equlibrium constant of compound i";
  //Fugacity coefficient  at the Bubble and Dew Points
  Real liqfugcoeff_bubl[NOC], vapfugcoeff_dew[NOC];
  //Activity Coefficient at the Bubble and Dew Points
  Real gammaBubl[NOC], gammaDew[NOC](each start = 1.5);
  //Excess Energy Properties
  Real resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
  //===============================================================================
  //Bubble Point Calculation Variables
  Real theta_bubl[k] "UNIFAC parameter";
  Real S_bubl[k] "Unifac parameter ";
  Real J_bubl[NOC] "Surface area fraction of comp i";
  Real L_bubl[NOC] "Molecular volume fraction of comp i";
  Real gammac_bubl[NOC] "Combinatorial activity coefficient of components at bubble point";
  Real gammar_bubl[NOC] "Residual activity coefficient of components at bubble point";
  Real sum_bubl[NOC];
  //===============================================================================
  //Dew Point Calculation Routine
  Real theta_dew[k] "UNIFAC parameter";
  Real S_dew[k] "Unifac parameter ";
  Real J_dew[NOC] "Surface area fraction of comp i";
  Real L_dew[NOC] "Molecular volume fraction of comp i";
  Real gammac_dew[NOC] "combinatorial activity coefficient of components at dew point";
  Real gammar_dew[NOC] "residual activity coefficient of components at dew point";
  Real sum_dew[NOC];
  Real dewLiqMolFrac[NOC](each start = 0.5);
  //==============================================================================
equation
  resMolSpHeat[:] = zeros(3);
  resMolEnth[:] = zeros(3);
  resMolEntr[:] = zeros(3);
  for i in 1:NOC loop
    Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP[:], T);
  end for;
  for i in 1:NOC loop
    liqfugcoeff_bubl[i] = 1;
    vapfugcoeff_dew[i] = 1;
  end for;
  for i in 1:m loop
//tau_m_k=exp((-a_m_k)/t)
    tau[i, :] = exp((-a[i, :]) / T);
  end for;
// Equlibrium constant
  for i in 1:NOC loop
    K[i] = gamma[i] * Psat[i] / P;
  end for;
//surface area constant
  for i in 1:NOC loop
    q[i] = sum(V[i, :] .* Q[i, :]);
//surface volume constant
    r[i] = sum(V[i, :] .* R[i, :]);
    e[:, i] = V[i, :] .* Q[i, :] / q[i];
  end for;
  for i in 1:NOC loop
    J[i] = r[i] / sum(r[:] .* compMolFrac[2, :]);
    L[i] = q[i] / sum(q[:] .* compMolFrac[2, :]);
    gammac[i] = exp(1 - J[i] + log(J[i]) + (-5 * q[i] * (1 - J[i] / L[i] + log(J[i] / L[i]))));
  end for;
//=======================================================================================
  for j in 1:k loop
    theta[j] = sum(compMolFrac[2, :] .* q[:] .* e[j, :]) / sum(compMolFrac[2, :] .* q[:]);
  end for;
  for i in 1:k loop
    S[i] = sum(theta[:] .* tau[:, i]);
  end for;
algorithm
  for i in 1:NOC loop
    for j in 1:k loop
      for l in 1:m loop
        B[i, j] := sum(e[:, i] .* tau[:, j]);
      end for;
    end for;
  end for;
  sum[:] := fill(0, NOC);
  for j in 1:k loop
    for i in 1:NOC loop
      sum[i] := sum[i] + theta[j] * B[i, j] / S[j] - e[j, i] * log(B[i, j] / S[j]);
      gammar[i] := exp(q[i] * (1 - sum[i]));
    end for;
  end for;
equation
// activity coefficient:
  for i in 1:NOC loop
    gamma[i] = exp(log(gammar[i]) + log(gammac[i]));
  end for;
//===============================================================================================
//Bubble Point Calculation Routine
  for i in 1:NOC loop
    J_bubl[i] = r[i] / sum(r[:] .* compMolFrac[1, :]);
    L_bubl[i] = q[i] / sum(q[:] .* compMolFrac[1, :]);
    gammac_bubl[i] = exp(1 - J_bubl[i] + log(J_bubl[i]) + (-5 * q[i] * (1 - J_bubl[i] / L_bubl[i] + log(J_bubl[i] / L_bubl[i]))));
  end for;
  for j in 1:k loop
    theta_bubl[j] = sum(compMolFrac[1, :] .* q[:] .* e[j, :]) / sum(compMolFrac[1, :] .* q[:]);
  end for;
  for i in 1:k loop
    S_bubl[i] = sum(theta_bubl[:] .* tau[:, i]);
  end for;
algorithm
  sum_bubl[:] := fill(0, NOC);
  for j in 1:k loop
    for i in 1:NOC loop
      sum_bubl[i] := sum_bubl[i] + theta_bubl[j] * B[i, j] / S_bubl[j] - e[j, i] * log(B[i, j] / S_bubl[j]);
      gammar_bubl[i] := exp(q[i] * (1 - sum_bubl[i]));
    end for;
  end for;
equation
  for i in 1:NOC loop
    gammaBubl[i] = exp(log(gammar_bubl[i]) + log(gammac_bubl[i]));
  end for;
//=======================================================================================================
//Dew Point Calculation Routine
  for i in 1:NOC loop
    dewLiqMolFrac[i] = compMolFrac[1, i] * Pdew / (gammaDew[i] * Psat[i]);
  end for;
  for i in 1:NOC loop
    J_dew[i] = r[i] / sum(r[:] .* dewLiqMolFrac[:]);
    L_dew[i] = q[i] / sum(q[:] .* dewLiqMolFrac[:]);
    gammac_dew[i] = exp(1 - J_dew[i] + log(J_dew[i]) + (-5 * q[i] * (1 - J_dew[i] / L_dew[i] + log(J_dew[i] / L_dew[i]))));
  end for;
  for j in 1:k loop
    theta_dew[j] = sum(dewLiqMolFrac[:] .* q[:] .* e[j, :]) / sum(dewLiqMolFrac[:] .* q[:]);
  end for;
  for i in 1:k loop
    S_dew[i] = sum(theta_dew[:] .* tau[:, i]);
  end for;
algorithm
  sum_dew[:] := fill(0, NOC);
  for j in 1:k loop
    for i in 1:NOC loop
      sum_dew[i] := sum_dew[i] + theta_dew[j] * B[i, j] / S_dew[j] - e[j, i] * log(B[i, j] / S_dew[j]);
      gammar_dew[i] := exp(q[i] * (1 - sum_dew[i]));
    end for;
  end for;
equation
  for i in 1:NOC loop
    gammaDew[i] = exp(log(gammar_dew[i]) + log(gammac_dew[i]));
  end for;
//=================================================================================================s
  annotation(
    Documentation(info = "<html>
   <p>
  UNIFAC-Universal Functional group Model
  </p>
  <b>Description</b>:<br>
  </p>
  UNIFAC(Univeral functional group) model is a semi empherical system to determine the activity coefficient in non ideal mixtures. It makes use of the functional group present in the chemical molecule to predict the phase equlibria of the system. 
  The activity coefficent comprises of two major contibutions named as combinatorial and residual contribution
  Combinatorial contribution focusses on the deviation from ideality as a result of molecular shape while the residual contribution quantifies the interaction between different groups in the system.<br>
  </p>
  <b>Equations and References</b>:<br>
  </p>https://wikimedia.org/api/rest_v1/media/math/render/svg/b6eb40a653fe590b5bfa137fe76342eef6a502d2
  </p>
  </tr>
  </html>"),
    experiment(StopTime = 1.0, Interval = 0.001));
end UNIFAC;
