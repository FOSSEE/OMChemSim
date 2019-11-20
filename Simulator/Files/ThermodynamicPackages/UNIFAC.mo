within Simulator.Files.ThermodynamicPackages;

 model UNIFAC
    //Libraries
    import Simulator.Files.*;
    import Simulator.Files.ThermodynamicFunctions;
    //Parameter Section
    parameter Integer m = 4 "substitue of number of different group";
    parameter Integer k = 4 "number of different group in component i";
    //Van de wal surface area and volume constant's
    parameter Real V_ck[Nc, k] = {{1, 1, 1, 0}, {1, 0, 1, 0}} "number of group of kind k in molecule ";
    parameter Real R_ck[Nc, k] = {{0.9011, 0.6744, 1.6724, 0}, {0.9011, 0, 1.6724, 0}} "group volume of group k ";
    parameter Real Q_ck[Nc, k] = {{0.848, 0.540, 1.448, 0}, {0.848, 0, 1.448, 0}} "group surface area of group k";
    //Intreraction parameter
    parameter Real a[m, k] = {{0, 0, 476.4, 1318}, {0, 0, 476.4, 1318}, {26.76, 26.76, 0, 472.5}, {300, 300, -195.4, 0}} "Binary  intraction parameter";
    Real Psat[Nc] "Saturated Vapour Pressure at the input temperature";
    //Intermediate values used to compute UNIFAC R and Q values
    Real q[Nc] "Van der walls molecular surface area";
    Real r[Nc] "Van der walls molecular volume";
    Real e_kc[k, Nc] "Group Surface area fraction of comp i";
    Real tow[m, k] "Boltzmann factors";
    Real B_ck[Nc, k] "UNIFAC parameter ";
    Real theta_k[k] "UNIFAC parameter";
    Real sum_c[Nc];
    Real S_k[k] "Unifac parameter ";
    Real J_c[Nc] "Surface area fraction of comp i";
    Real L_c[Nc] "Molecular volume fraction of comp i";
    //Activity Coefficients
    Real gmacom_c[Nc] "Combinatorial activity coefficient of comp i";
    Real gmares_c[Nc] "Residual activity coefficient of comp i";
    Real gma_c[Nc] " Activity coefficient";
    Real K_c[Nc] "Equlibrium constant of compound i";
    //Fugacity coefficient  at the Bubble and Dew Points
    Real philbubl_c[Nc], phivdew_c[Nc];
    //Activity Coefficient at the Bubble and Dew Points
    Real gmabubl_c[Nc], gmadew_c[Nc](each start = 1.5);
    //Excess Energy Properties
    Real Cpres_c[3], Hres_c[3], Sres_c[3];
    //===============================================================================
    //Bubble Point Calculation Variables
    Real theta_bubl[k] "UNIFAC parameter";
    Real Sbubl_c[k] "Unifac parameter ";
    Real Jbubl_c[Nc] "Surface area fraction of comp i";
    Real Lbubl_c[Nc] "Molecular volume fraction of comp i";
    Real gmacbubl_C[Nc] "Combinatorial activity coefficient of components at bubble point";
    Real gmarbubl_C[Nc] "Residual activity coefficient of components at bubble point";
    Real sumbubl_c[Nc];
    //===============================================================================
    //Dew Point Calculation Routine
    Real theta_dew[k] "UNIFAC parameter";
    Real Sdew_c[k] "Unifac parameter ";
    Real Jdew_c[Nc] "Surface area fraction of comp i";
    Real Ldew_c[Nc] "Molecular volume fraction of comp i";
    Real gmacdew_c[Nc] "combinatorial activity coefficient of components at dew point";
    Real gmardew_c[Nc] "residual activity coefficient of components at dew point";
    Real sumdew_c[Nc];
    Real xliqdew_c[Nc](each start = 0.5);
    //==============================================================================
  equation
    Cpres_c[:] = zeros(3);
    Hres_c[:] = zeros(3);
    Sres_c[:] = zeros(3);
    for i in 1:Nc loop
      Psat[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP[:], T);
    end for;
    for i in 1:Nc loop
      philbubl_c[i] = 1;
      phivdew_c[i] = 1;
    end for;
    for i in 1:m loop
//tow_m_k=exp((-a_m_k)/t)
      tow[i, :] = exp((-a[i, :]) / T);
    end for;
// Equlibrium constant
    for i in 1:Nc loop
      K_c[i] = gma_c[i] * Psat[i] / P;
    end for;
//surface area constant
    for i in 1:Nc loop
      q[i] = sum(V_ck[i, :] .* Q_ck[i, :]);
//surface volume constant
      r[i] = sum(V_ck[i, :] .* R_ck[i, :]);
      e_kc[:, i] = V_ck[i, :] .* Q_ck[i, :] / q[i];
    end for;
    for i in 1:Nc loop
      J_c[i] = r[i] / sum(r[:] .* x_pc[2, :]);
      L_c[i] = q[i] / sum(q[:] .* x_pc[2, :]);
      gmacom_c[i] = exp(1 - J_c[i] + log(J_c[i]) + (-5 * q[i] * (1 - J_c[i] / L_c[i] + log(J_c[i] / L_c[i]))));
    end for;
//=======================================================================================
    for j in 1:k loop
      theta_k[j] = sum(x_pc[2, :] .* q[:] .* e_kc[j, :]) / sum(x_pc[2, :] .* q[:]);
    end for;
    for i in 1:k loop
      S_k[i] = sum(theta_k[:] .* tow[:, i]);
    end for;
  algorithm
    for i in 1:Nc loop
      for j in 1:k loop
        for l in 1:m loop
          B_ck[i, j] := sum(e_kc[:, i] .* tow[:, j]);
        end for;
      end for;
    end for;
    sum_c[:] := fill(0, Nc);
    for j in 1:k loop
      for i in 1:Nc loop
        sum_c[i] := sum_c[i] + theta_k[j] * B_ck[i, j] / S_k[j] - e_kc[j, i] * log(B[i, j] / S_k[j]);
        gmares_c[i] := exp(q[i] * (1 - sum_c[i]));
      end for;
    end for;
  equation
// activity coefficient:
    for i in 1:Nc loop
      gma_c[i] = exp(log(gmares_c[i]) + log(gmacom_c[i]));
    end for;
//===============================================================================================
//Bubble Point Calculation Routine
    for i in 1:Nc loop
      Jbubl_c[i] = r[i] / sum(r[:] .* x_pc[1, :]);
      Lbubl_c[i] = q[i] / sum(q[:] .* x_pc[1, :]);
      gmacbubl_C[i] = exp(1 - Jbubl_c[i] + log(Jbubl_c[i]) + (-5 * q[i] * (1 - Jbubl_c[i] / Lbubl_c[i] + log(Jbubl_c[i] / Lbubl_c[i]))));
    end for;
    for j in 1:k loop
      theta_bubl[j] = sum(x_pc[1, :] .* q[:] .* e_kc[j, :]) / sum(x_pc[1, :] .* q[:]);
    end for;
    for i in 1:k loop
      Sbubl_c[i] = sum(theta_bubl[:] .* tow[:, i]);
    end for;
  algorithm
    sumbubl_c[:] := fill(0, Nc);
    for j in 1:k loop
      for i in 1:Nc loop
        sumbubl_c[i] := sumbubl_c[i] + theta_bubl[j] * B[i, j] / Sbubl_c[j] - e_kc[j, i] * log(B[i, j] / Sbubl_c[j]);
        gmarbubl_C[i] := exp(q[i] * (1 - sumbubl_c[i]));
      end for;
    end for;
  equation
    for i in 1:Nc loop
      gmabubl_c[i] = exp(log(gmarbubl_C[i]) + log(gmacbubl_C[i]));
    end for;
//=======================================================================================================
//Dew Point Calculation Routine
    for i in 1:Nc loop
      xliqdew_c[i] = x_pc[1, i] * Pdew / (gmadew_c[i] * Psat[i]);
    end for;
    for i in 1:Nc loop
      Jdew_c[i] = r[i] / sum(r[:] .* xliqdew_c[:]);
      Ldew_c[i] = q[i] / sum(q[:] .* xliqdew_c[:]);
      gmacdew_c[i] = exp(1 - Jdew_c[i] + log(Jdew_c[i]) + (-5 * q[i] * (1 - Jdew_c[i] / Ldew_c[i] + log(Jdew_c[i] / Ldew_c[i]))));
    end for;
    for j in 1:k loop
      theta_dew[j] = sum(xliqdew_c[:] .* q[:] .* e_kc[j, :]) / sum(xliqdew_c[:] .* q[:]);
    end for;
    for i in 1:k loop
      Sdew_c[i] = sum(theta_dew[:] .* tow[:, i]);
    end for;
  algorithm
    sumdew_c[:] := fill(0, Nc);
    for j in 1:k loop
      for i in 1:Nc loop
        sumdew_c[i] := sumdew_c[i] + theta_dew[j] * B[i, j] / Sdew_c[j] - e_kc[j, i] * log(B[i, j] / Sdew_c[j]);
        gmardew_c[i] := exp(q[i] * (1 - sumdew_c[i]));
      end for;
    end for;
  equation
    for i in 1:Nc loop
      gmadew_c[i] = exp(log(gmardew_c[i]) + log(gmacdew_c[i]));
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

