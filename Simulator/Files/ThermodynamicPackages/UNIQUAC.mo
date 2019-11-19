within Simulator.Files.ThermodynamicPackages;

  model UNIQUAC
    //Libraries
    import Simulator.Files.*;
    //Parameter Section
    //Binary Interaction Parameters
    //Function :BIP_UNIQUAC is used to obtain the interaction parameters
    parameter Real a[Nc, Nc] = ThermodynamicFunctions.BIPUNIQUAC(Nc, C.name);
    //Uniquac Parameters R and Q called from Chemsep Database
    parameter Real R[Nc] = C.UniquacR;
    parameter Real Q[Nc] = C.UniquacQ;
    parameter Integer Z = 10 "Compresseblity-Factor";
    //Variable Section
    Real tow[Nc, Nc] "Energy interaction parameter";
    //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at the input conditions
    Real r(each start = 2, min = 0, max = 1), q(each start = 2);
    Real theta_c[Nc];
    Real S_c[Nc](each start = 1);
    Real Sum_c[Nc];
    //Activity Coefficients
    Real gmacom_c[Nc](each start = 1.2) "Combinatorial Part of activity coefficent at input conditions";
    Real gmares_c[Nc](each start = 1.2) "Residual part of activity coefficient at input conditions";
    Real gmanew_c[Nc](each start = 1.2);
    Real gma_c[Nc](each start = 1.2) "Activity coefficient with Poynting correction";
    //Fugacity coefficient
    Real phil[Nc](each start = 0.5) "Fugacity coefficient at the input conditions";
    //Dew Point Calculation Variables
    Real xliqdew_c[Nc](each start = 0.5, each min = 0, each max = 1);
    //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at dew point
    Real rdew(start = 2), qdew(start = 2);
    Real thetadew_c[Nc](each start = 2);
    Real Sdew_c[Nc](each start = 1);
    Real sum_dew[Nc](each start = 2);
    //Activity Coefficients
    Real  gmacdew_c[Nc](each start = 5) "Combinatorial Part of activity coefficent at dew point";
    Real  gmardew_c[Nc](each start = 2.5) "Residual part of activity coefficient at dew point";
    Real  gmaolddew_c[Nc](each start = 2.2) "Combinatorial Part of activity coefficent(without correction)";
    Real gmadew_c[Nc](each start = 2.2) "Activity coefficent at dew point";
    //Fugacity coefficient
    Real  phivapdew_c[Nc] "Vapour Fugacity coefficient at dew point";
    Real phildew_c[Nc](each start = 0.5);
    Real PCFdew_c[Nc] "Poynting Correction Factor";
    //Bubble Point Calculation Variables
    //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at bubble point
    Real rbubl(start = 2), qbubl(start = 2);
    Real thetabubl_c[Nc];
    Real Sbubl_c[Nc];
    Real Sumbubl_c[Nc];
    //Activity Coefficients
    Real gmacbubl_c[Nc](each start = 2) "Combinatorial Part of activity coefficent at bubble point";
    Real  gmarbubl_c[Nc](each start = 1) "Residual part of activity coefficent at bubble point";
    Real  gmaoldbubl_c[Nc](each start = 1) "Combinatorial Part of activity coefficent(without correction)";
    Real  gmabubl_c[Nc](each start = 1) "Activity coefficent at bubble point";
    //Fugacity coefficient
    Real  philiqbubl_c[Nc];
    Real phibubl[Nc](each start = 0.5) "Liquid Phase Fugacity coefficient";
    Real PCFbubl_c[Nc] "Poynting Correction Factor";
    //Phase Envelope
    Real Pvap_c[Nc](each unit = "Pa") "Saturated Vapour Pressure at the input temperature";
    Real PCF_c[Nc] "Poynting correction factor";
    Real K_c[Nc](each start = 0.7) "Distribution Coefficient";
    //Residual Energy Parameters
    Real Cpres_p[3], Hres_p[3], Sres_p[3];
    //Transport Properties at the input conditions
    Real Density[Nc](each unit = "kmol/m^3");
    Real A[Nc], B[Nc], D[Nc], E[Nc], Ff[Nc];
    Real Cc[Nc];
    Real A_bubl[Nc], B_bubl[Nc], C_bubl[Nc], D_bubl[Nc], E_bubl[Nc], F_bubl[Nc];
    Real A_dew[Nc], B_dew[Nc], C_dew[Nc], D_dew[Nc], E_dew[Nc], F_dew[Nc];
    //===========================================================================================================
    //Equation Section
  equation
//Fugacity coefficients set to 1 since the model type is Activity Coefficient
    for i in 1:Nc loop
       philiqbubl_c[i] = 1;
       phivapdew_c[i] = 1;
    end for;
//Calculation of Intermediate parameters to evaluate combinatorial and residual part of the activity coefficient
//Note : compMolFrac is the referenced from "Material Stream" model
    r = sum(x_pc[2, :] .* R[:]);
    q = sum(x_pc[2, :] .* Q[:]);
//Calculation of Energy interaction parameter at the input tempetraure
//Function :Tow_UNIQUAC is used to instantiated
    tow = Simulator.Files.ThermodynamicFunctions.TowUNIQUAC(Nc, a, T);
//Calculation of Combinatorial and Residual Activity coefficient
    for i in 1:Nc loop
      if q > 0 then
        theta_c[i] = x_pc[2, i] * Q[i] * (1 / q);
      elseif q < 0 then
        theta_c[i] = 0;
      else
        theta_c[i] = 0;
      end if;
    end for;
    for i in 1:Nc loop
      if theta_c[i] == 0 then
        S_c[i] = 1;
      else
        S_c[i] = sum(theta_c[:] .* tow[i, :]);
      end if;
      if S_c[i] == 1 then
        Sum_c[i] = 0;
      else
        Sum_c[i] = sum(theta_c[:] .* tow[i, :] ./ S_c[:]);
      end if;
    end for;
    for i in 1:Nc loop
      if S_c[i] == 1 then
        Cc[i] = 0;
      elseif S_c[i] > 0 then
        Cc[i] = log(S_c[i]);
      else
        Cc[i] = 0;
      end if;
      gmares_c[i] = exp(Q[i] * (1 - Cc[i] - Sum_c[i]));
    end for;
// //===================================================================
//     equation
    for i in 1:Nc loop
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
      log(gmacom_c[i]) = 1 - D[i] + A[i] + (-Z / 2 * Q[i] * (1 - Ff[i] + B[i]));
      gma_c[i] = gmacom_c[i] * gmares_c[i];
    end for;
//=====================================================================================================
//Excess Energy parameters are set to 0 since the calculation mode is Ideal
    Cpres_p[:] = zeros(3);
    Hres_p[:] = zeros(3);
    Sres_p[:] = zeros(3);
//Calculation of Saturated vapour pressure and Density at the given input condition
    for i in 1:Nc loop
      Pvap_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);
      Density[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, T, P) * 1E-3;
    end for;
//Calculation of Poynting correction Factor at input conditions,Bubble Point and Dew Point
//Function :Poynting_CF is called from the Simulator Package
  for i in 1:Nc loop
    PCF_c[i] = ThermodynamicFunctions.PoyntingCF(Nc,C[i].Pc,C[i].Tc,C[i].Racketparam,C[i].AF,C[i].MW, T, P, gma_c[i], Pvap_c[i], Density[i]);
    PCFbubl_c[i] = ThermodynamicFunctions.PoyntingCF(Nc,C[i].Pc,C[i].Tc,C[i].Racketparam,C[i].AF,C[i].MW, T, Pbubl, gma_c[i], Pvap_c[i], Density[i]);
    PCFdew_c[i] = ThermodynamicFunctions.PoyntingCF(Nc,C[i].Pc,C[i].Tc,C[i].Racketparam,C[i].AF, C[i].MW, T, Pdew, gma_c[i], Pvap_c[i], Density[i]);
  end for;
//Calculation of Fugacity coefficient with Poynting correction
    phil[:] = gma_c[:] .* Pvap_c[:] ./ P .* PCF_c[:];
    phil[:] = gmanew_c[:] .* Pvap_c[:] ./ P;
//Calculation of Distribution coefficient
    K_c[:] = gmanew_c[:] .* Pvap_c[:] ./ P;
//Binary Phase Envelope
//The same calculation routine is followed at the DewPoint
//Dew Point
    rdew = sum(xliqdew_c[:] .* R[:]);
    qdew = sum(xliqdew_c[:] .* Q[:]);
    for i in 1:Nc loop
      if qdew == 0 or x_pc[1, i] == 0 then
        xliqdew_c[i] = 0;
      else
        xliqdew_c[i] = x_pc[1, i] * Pdew / (gmadew_c[i] * Pvap_c[i]);
      end if;
      if qdew == 0 or xliqdew_c[i] == 0 then
        thetadew_c[i] = 0;
      else
        thetadew_c[i] = xliqdew_c[i] * Q[i] * (1 / qdew);
      end if;
      if thetadew_c[i] == 0 then
        Sdew_c[i] = 1;
      else
        Sdew_c[i] = sum(thetadew_c[:] .* tow[i, :]);
      end if;
    end for;
//===================================================================================================
    for i in 1:Nc loop
      if Sdew_c[i] == 1 then
        sum_dew[i] = 0;
      else
        sum_dew[i] = sum(thetadew_c[:] .* tow[i, :] ./ Sdew_c[:]);
      end if;
      if Sdew_c[i] == 1 then
        C_dew[i] = 0;
      elseif Sdew_c[i] > 0 then
        C_dew[i] = log(Sdew_c[i]);
      else
        C_dew[i] = 0;
      end if;
       gmardew_c[i] = exp(Q[i] * (1 - C_dew[i] - sum_dew[i]));
    end for;
//===============================================================================================
    for i in 1:Nc loop
      if rdew == 0 then
        D_dew[i] = 0;
      else
        D_dew[i] = R[i] / rdew;
      end if;
      if qdew == 0 then
        E_dew[i] = 0;
      else
        E_dew[i] = Q[i] / qdew;
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
      log( gmacdew_c[i]) = 1 - D_dew[i] + A_dew[i] + (-Z / 2 * Q[i] * (1 - F_dew[i] + B_dew[i]));
       gmaolddew_c[i] =  gmacdew_c[i] *  gmardew_c[i];
    end for;
    for i in 1:Nc loop
      if Pdew == 0 then
        phildew_c[i] = 1;
        gmadew_c[i] = 1;
      else
        phildew_c[i] =  gmaolddew_c[i] .* Pvap_c[i] ./ Pdew .* PCFdew_c[i];
        phildew_c[i] = gmadew_c[i] .* Pvap_c[i] ./ Pdew;
      end if;
    end for;
//The same calculation routine is followed at the Bubble Point
//Bubble Point
    rbubl = sum(x_pc[1, :] .* R[:]);
    qbubl = sum(x_pc[1, :] .* Q[:]);
    for i in 1:Nc loop
      if x_pc[1, i] == 0 then
        thetabubl_c[i] = 0;
      else
        thetabubl_c[i] = x_pc[1, i] * Q[i] * (1 / qbubl);
      end if;
      if thetabubl_c[i] == 0 then
        Sbubl_c[i] = 1;
      else
        Sbubl_c[i] = sum(thetabubl_c[:] .* tow[i, :]);
      end if;
      if Sbubl_c[i] == 1 then
        Sumbubl_c[i] = 0;
      else
        Sumbubl_c[i] = sum(thetabubl_c[:] .* tow[i, :] ./ Sbubl_c[:]);
      end if;
      if Sbubl_c[i] == 1 then
        C_bubl[i] = 0;
      elseif Sbubl_c[i] > 0 then
        C_bubl[i] = log(Sbubl_c[i]);
      else
        C_bubl[i] = 0;
      end if;
      log( gmarbubl_c[i]) = Q[i] * (1 - C_bubl[i] - Sumbubl_c[i]);
//=========================================================================================================
      if rbubl == 0 then
        D_bubl[i] = 0;
      else
        D_bubl[i] = R[i] / rbubl;
      end if;
      if qbubl == 0 then
        E_bubl[i] = 0;
      else
        E_bubl[i] = Q[i] / qbubl;
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
      log(gmacbubl_c[i]) = 1 - D_bubl[i] + A_bubl[i] + (-Z / 2 * Q[i] * (1 - F_bubl[i] + B_bubl[i]));
       gmaoldbubl_c[i] = gmacbubl_c[i] *  gmarbubl_c[i];
    end for;
    for i in 1:Nc loop
      if Pbubl == 0 then
        phibubl[i] = 1;
        gmabubl_c[i] = 1;
      else
        phibubl[i] =  gmaoldbubl_c[i] .* Pvap_c[i] ./ Pbubl .* PCFbubl_c[i];
        phibubl[i] = gmabubl_c[i] .* Pvap_c[i] ./ Pbubl;
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

  //=======================================================================================================
