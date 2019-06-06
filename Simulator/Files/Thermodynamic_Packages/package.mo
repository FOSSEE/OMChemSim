within Simulator.Files;

package Thermodynamic_Packages
  model Raoults_Law
    import Simulator.Files.Thermodynamic_Functions.*;
    Real K[NOC](each min = 0), resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
    Real gamma[NOC], gammaBubl[NOC], gammaDew[NOC];
    Real liqfugcoeff_bubl[NOC], vapfugcoeff_dew[NOC],Psat[NOC];
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

  model NRTL
    import Simulator.Files.Thermodynamic_Functions.*;
    Simulator.Files.Models.gammaNRTL Gamma(NOC = NOC, comp = comp, molFrac = compMolFrac[2, :], T = T), dewGamma(NOC = NOC, comp = comp, molFrac = dewLiqMolFrac, T = T), bublGamma(NOC = NOC, comp = comp, molFrac = compMolFrac[1, :], T = T);
    Real dewLiqMolFrac[NOC], density[NOC];
    Real resMolSpHeat[3] "residual specific heat", resMolEnth[3] "residual enthalpy", resMolEntr[3] "residual Entropy", K[NOC], gamma[NOC](each start = 1), gammaBubl[NOC](each start = 1), gammaDew[NOC](each start = 1);
     Real liqfugcoeff_bubl[NOC], vapfugcoeff_dew[NOC],Psat[NOC];
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
      Real r(each start=2, min=0,max=1), q(each start=2);
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
      Real dewLiqMolFrac[NOC](each start=0.5, each min=0, each max=1);
      //Intermediate variables to calculate the combinatorial and residual part of activity coefficient at dew point
      Real r_dew(start=2), q_dew(start=2);
      Real teta_dew[NOC](each start=2);
      Real S_dew[NOC](each start = 1);
      Real sum_dew[NOC](each start=2);
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
      Real r_bubl(start=2), q_bubl(start=2);
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
      Real A[NOC],B[NOC],D[NOC],E[NOC],Ff[NOC];
      Real C[NOC];
      Real A_bubl[NOC],B_bubl[NOC],C_bubl[NOC],D_bubl[NOC],E_bubl[NOC],F_bubl[NOC];
      Real A_dew[NOC],B_dew[NOC],C_dew[NOC],D_dew[NOC],E_dew[NOC],F_dew[NOC];
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
      if(q>0) then
      teta[i] = compMolFrac[2, i] * Q[i] * (1 / q);
      elseif(q<0) then
      teta[i]=0;
      else
      teta[i]=0;
      end if;
      end for;
  
      for i in 1:NOC loop
        if  (teta[i]==0) then
        S[i]=1;
        else
        S[i] = sum(teta[:] .* tow[i, :]);
        end if;
        
        if(S[i]==1) then
        sum[i]=0;
        else
        sum[i] = sum(teta[:] .* tow[i, :] ./ S[:]);
        end if;
      end for;
  
      for i in 1:NOC loop
      
        if(S[i]==1) then
        C[i] = 0;    
        elseif(S[i]>0) then
        C[i] = log(S[i]);
        else
        C[i]=0; 
        end if;
        
       (gammar[i]) = exp(Q[i] * (1 - C[i] - sum[i]));
      end for;
  // //===================================================================     
  //     equation
       
       for i in 1:NOC loop
       if(r>0) then
       D[i] = R[i]/r;   
       elseif(r<=0) then
       D[i] =0;
       else
       D[i]=0;     
       end if;
        
        if(q>0) then
        E[i] = Q[i]/q;
        elseif(q<=0) then
        E[i] = 0;
        else
        E[i] = 0;
        end if;
        
        if(E[i]==0 or D[i]==0) then
        Ff[i]=0;
        else
        Ff[i] = D[i]/E[i];
        end if;
        
        
        if(D[i]>0) then
        A[i] =log(D[i]);
        elseif(D[i]==1) then
        A[i]=0;
        else
        A[i]=0;
        end if;
        
        if(Ff[i]>1) then
        B[i] =log(Ff[i]);
        elseif(Ff[i]==1) then
        B[i]=0;
        else
        B[i]=0;
        end if;
        
        log(gammac[i])=1-D[i] + A[i] + (-Z / 2 * Q[i] * (1 - Ff[i] + B[i]));
        
       (gamma[i]) = (gammac[i]) * (gammar[i]);
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
       if(q_dew==0 or compMolFrac[1,i]==0) then
       dewLiqMolFrac[i]=0;
       else
        dewLiqMolFrac[i] = compMolFrac[1, i] * Pdew / (gammaDew[i] * Psat[i]);
       end if; 
       if(q_dew==0 or dewLiqMolFrac[i]==0) then
       teta_dew[i]=0;
       else
        teta_dew[i] = dewLiqMolFrac[i] * Q[i] * (1 / q_dew);
       end if; 
        if(teta_dew[i]==0) then
        S_dew[i] =1;
        else
        S_dew[i] = sum(teta_dew[:] .* tow[i, :]);
        end if;
        end for;
   //===================================================================================================     
  
        for i in 1:NOC loop
        if(S_dew[i]==1) then
        sum_dew[i]=0;
        else
        sum_dew[i] = sum(teta_dew[:] .* tow[i, :] ./ (S_dew[:]));
        end if;
        
        
        if(S_dew[i]==1) then
        C_dew[i]=0;
        elseif(S_dew[i]>0) then
        C_dew[i] =log(S_dew[i]);  
        else
        C_dew[i]=0;
        end if;
  
        (gammar_dew[i]) = exp(Q[i] * (1 - C_dew[i] - sum_dew[i]));
        end for;
  //===============================================================================================     
       
       for i in 1:NOC loop
       if(r_dew==0) then
       D_dew[i] =0;
       else
       D_dew[i] = R[i]/r_dew;
       end if;
        
        if(q_dew==0) then
        E_dew[i] = 0;
        else
        E_dew[i] = Q[i]/q_dew;
        end if;
        
        if(E_dew[i]==0) then
        F_dew[i]=0;
        else
        F_dew[i] = D_dew[i]/E_dew[i];
        end if;
        
        
        if(D_dew[i]>0) then
        A_dew[i] =log(D_dew[i]);
        elseif(D_dew[i]==1) then
        A_dew[i]=0;
        else
        A_dew[i]=0;
        end if;
        
        if(F_dew[i]>0) then
        B_dew[i] =log(F_dew[i]);
        elseif(F_dew[i]==1) then
        B_dew[i]=0;
        else
        B_dew[i]=0;
        end if;
        
        log(gammac_dew[i])=1-D_dew[i] + A_dew[i] + (-Z / 2 * Q[i] * (1 - F_dew[i] + B_dew[i]));
        
        (gammaDew_old[i]) = (gammac_dew[i]) * (gammar_dew[i]);
      end for;
      
      for i in 1:NOC loop
      if(Pdew==0) then
      phil_dew[i]=1;
      gammaDew[i]=1;
      
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
      if(compMolFrac[1,i]==0) then
      teta_bubl[i]=0;
      else
        teta_bubl[i] = compMolFrac[1, i] * Q[i] * (1 / q_bubl);
       end if; 
       
       if(teta_bubl[i]==0) then
        S_bubl[i] =1;
        else
        S_bubl[i] = sum(teta_bubl[:] .* tow[i, :]);
       end if;
        
        if(S_bubl[i]==1) then
        sum_bubl[i]=0;
        else
        sum_bubl[i] = sum(teta_bubl[:] .* tow[i, :] ./ S_bubl[:]);
        end if;
        
        
       if(S_bubl[i]==1) then
        C_bubl[i] =0 ;
        elseif(S_bubl[i]>0) then
        C_bubl[i]=log(S_bubl[i]);
        else
        C_bubl[i]=0;
        end if;
        log(gammar_bubl[i]) = Q[i] * (1 - C_bubl[i] - sum_bubl[i]);
  //=========================================================================================================
        
       if(r_bubl==0) then
       D_bubl[i] =0;
       else
       D_bubl[i] = R[i]/r_bubl;
       end if;
        
        if(q_bubl==0) then
        E_bubl[i] = 0;
        else
        E_bubl[i] = Q[i]/q_bubl;
        end if;
        
        if(E_bubl[i]==0) then
        F_bubl[i]=0;
        else
        F_bubl[i] = D_bubl[i]/E_bubl[i];
        end if;
        
        
        if(D_bubl[i]>0) then
        A_bubl[i] =log(D_bubl[i]);
        elseif(D_bubl[i]==1) then
        A_bubl[i]=0;
        else
        A_bubl[i]=0;
        end if;
        
        if(F_bubl[i]>0) then
        B_bubl[i] =log(F_bubl[i]);
        elseif(F_bubl[i]==1) then
        B_bubl[i]=0;
        else
        B_bubl[i]=0;
        end if;
        
        log(gammac_bubl[i])=1-D_bubl[i] + A_bubl[i] + (-Z / 2 * Q[i] * (1 - F_bubl[i] + B_bubl[i]));
       
       (gammaBubl_old[i]) = (gammac_bubl[i]) * (gammar_bubl[i]);
      end for;
       
     for i in 1:NOC loop
     if(Pbubl==0) then
      phil_bubl[i]=1;
      gammaBubl[i]=1;
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




  //=======================================================================================================

  model UNIFAC
    //Libraries
    import Simulator.Files.*;
    extends Simulator.Files.Thermodynamic_Functions;
    //Parameter Section
    parameter Integer m = 4 "substitue of number of different group";
    parameter Integer k = 4 "number of different group in component i";
    //Van de wal surface area and volume constant's
    parameter Real V[NOC, k] = {{1,1,1,0},{1,0,1,0}} "number of group of kind k in molecule ";
    parameter Real R[NOC, k] = {{0.9011,0.6744,1.6724,0},{0.9011,0,1.6724,0}} "group volume of group k ";
    parameter Real Q[NOC, k] = {{0.848,0.540,1.448,0},{0.848,0,1.448,0}} "group surface area of group k";
    //Intreraction parameter
    parameter Real a[m, k]={{0,0,476.4,1318},{0,0,476.4,1318},{26.76,26.76,0,472.5},{300,300,-195.4,0}} "Binary  intraction parameter";
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
          
          Real A,B,C,D[NOC],E,F,G,H[NOC],I[NOC],J[NOC];
          Real gamma[NOC];
        equation
          for i in 1:NOC loop
            Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
            gammaDew[i] = 1;
            gammaBubl[i] = 1;
            liqfugcoeff_bubl[i] = 1;
            vapfugcoeff_dew[i] = 1;
            gamma[i]=1;
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
           
           if((ZLL + 2.4142135 * BL)<=0) then
           A=1;  
           else
           A=(ZLL + 2.4142135 * BL);  
           end if;
           
           if((ZLL - 0.414213 * BL)<=0) then
           B=1;
           else
           B=(ZLL - 0.414213 * BL);   
           end if;
            
           if((ZLL - BL)<=0) then 
           C=0;
           else
           C= log(ZLL - BL);
           end if;
           
           for i in 1:NOC loop
           if(bML ==0) then
           D[i] = 0;
           else
           D[i] = b[i]/bML;
           end if;
           end for;
           
           for i in 1:NOC loop
           if(aML==0) then
           J[i] = 0;
           else
           J[i] = sum_xaL[i]/aML;
           end if;
           end for;
            
           liqfugcoeff = exp(AL / (BL * sqrt(8)) * log(A /B) .* (D .- 2 * J) .+ (ZLL - 1) * (D) .- (C));
        
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
          
           if((ZvV + 2.4142135 * BV)<=0) then
           E=1;  
           else
           E=(ZvV + 2.4142135 * BV);  
           end if;
           
           if((ZvV - 0.414213 * BV)<=0) then
           F=1;
           else
           F=(ZvV - 0.414213 * BV);   
           end if;
            
           if((ZvV - BV)<=0) then 
           G=0;
           else
           G= log(ZvV - BV);
           end if;
          
          for i in 1:NOC loop
           if(bMV ==0) then
           H[i] = 0;
           else
           H[i] = b[i]/bMV;
           end if;
           end for;
           
           for i in 1:NOC loop
           if(aMV==0) then
           I[i] = 0;
           else
           I[i] = sum_yaV[i]/aMV;
           end if;
           end for;
          
           vapfugcoeff = exp(AV / (BV * sqrt(8)) * log((E) /(F)) .* (H .- 2 * I) .+ (ZvV - 1) * (H) .- G);
           
          for i in 1:NOC loop
          if(liqfugcoeff[i]==0 or vapfugcoeff[i]==0) then
          K[i] = 0;
          else
          K[i] = liqfugcoeff[i]/vapfugcoeff[i];
          end if;
          end for;
  end Peng_Robinson;

//=============================================================================================================

 model Grayson_Streed
   
    import Simulator.Files.Thermodynamic_Functions.*; 
      parameter Real R_gas = 8.314;
      parameter Real u = 1;
      import Simulator.Files.*;
      
  //w=Acentric Factor
  //Sp = Solublity Parameter
  //V = Molar Volume 
  //All the above three parameters have to be mentioned as arguments while extending the thermodynamic Package Grayson Streed  
  
     parameter Real   w[NOC] ;
      parameter Real  Sp[NOC](each unit = "(cal/mL)^0.5") ;
      parameter Real  V[NOC] (each unit = "mL/mol") ;
             
      parameter Real Tc[NOC] = comp.Tc;
      parameter Real Pc[NOC] = comp.Pc;
      parameter Real R= 8314470;
     
      Real resMolSpHeat[3],resMolEnth[3],resMolEntr[3];
      Real K[NOC] ;
      Real S(start=3),gamma[NOC];
      Real liqfugcoeff[NOC](each start=2),vapfugcoeff[NOC](each start = 0.99),vapfugcoeff_dew[NOC](each start = 1.2);
      
      Real S_bubl,liqfugcoeff_bubl[NOC](each start=1.5),gamma_bubl[NOC];
      
      //Vapour Phase Fugacity coefficient
      Real a[NOC],b[NOC];
      Real a_ij[NOC,NOC];
      Real amv,amv_dew , bmv,bmv_dew;
      Real AG ,AG_dew, BG(start=3),BG_dew;
      Real Zv(start=3),Zv_dew;
      Real t1[NOC], t3[NOC],t4,t2(start=10);
      Real t1_dew[NOC], t3_dew[NOC],t4_dew,t2_dew(start=10);
      Real CV[4],Z_RV[3,2],ZV[3];
      Real CV_dew[4],Z_RV_dew[3,2],ZV_dew[3];
      Real gammaBubl[NOC](each start = 0.5),gammaDew[NOC](each start= 2.06221);
      Real gamma_liq[NOC],Psat[NOC];
      Real A[NOC],B[NOC],C[NOC],D[NOC],E,G,H[NOC],I,J;
      
      Real dewLiqMolFrac[NOC];
      Real Tr[NOC];
      Real Pr_bubl[NOC](each start=2);
      Real v0[NOC](each start=2),v1[NOC](each start=2),v[NOC];
      Real Vs,Vtot;
    
    equation
      
    //======================================================================================================  
      //Calculation Routine for Liquid Phase Fugacity Coefficient
      S = Solublity_Parameter(NOC,V,Sp,compMolFrac[2,:]);
      for i in 1:NOC loop
      gamma[i] = exp(V[i] * ((Sp[i] - S) ^ 2) / (R * T));
      end for;
      liqfugcoeff = Liquid_Fugacity_Coeffcient(NOC,Sp,Tc,Pc,w,T,P,V,S,gamma);
      
      for i in 1:NOC loop
      Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
      gamma_liq[i] = liqfugcoeff[i] * (P/Psat[i]);
      end for;
    //========================================================================================================     
      //Calculation Routine for Vapour Phase Fugacity Coefficient
      //Calculation of Equation of State Constants
      a =    EOS_Constants(NOC,Tc,Pc,T);
      b =    EOS_ConstantII(NOC,Tc,Pc,T);
      a_ij = EOS_ConstantIII(NOC,a);
      amv =  EOS_Constant1V(NOC,compMolFrac[3,:],a_ij);
      bmv =  sum(compMolFrac[3,:] .* b[:]);
      
      AG = (amv * P) / ((R_gas * T) ^ 2);
      BG = (bmv * P) / ( R_gas * T);
      
      for i in 1:NOC loop
      if(bmv==0) then
      C[i]=0;
      else
      C[i]=b[i]/bmv;
      end if;
      end for;
      
      for i in 1:NOC loop
      if(amv==0) then
      D[i]=0;
      else
      D[i]=a[i]/amv;
      end if;
      end for;
      
        
      for i in 1:NOC loop
      t1[i] = b[i] * (Zv - 1)/ bmv;
      t3[i] = AG /(BG * (((u) ^ 2)^ 0.5)) * ((C[i]) - ( 2 * ((D[i]) ^ 0.5)));
      end for;
      t4 =  log(((2 * Zv) + (BG * (u + ((((u)^ 2)^ 0.5)))))/((2 * Zv) + (BG * (u - ((((u) ^ 2)^ 0.5))))));  
      t2 = -log(Zv - BG);
       
      resMolSpHeat[:] = zeros(3);
      resMolEnth[:] =   zeros(3);
      resMolEntr[:] =   zeros(3);
      
      for i in 1:NOC loop
      vapfugcoeff[i] = exp(t1[i] + t2 + (t3[i] * t4));
      K[i] = liqfugcoeff[i]/vapfugcoeff[i];
      end for;
    
     
    //====================================================================================================
      //Bubble Point Algorithm
      
       Vtot = sum(compMolFrac[1,:] .* V[:]);
       Vs =   sum(compMolFrac[1,:] .* V[:] .* Sp[:]);
       S_bubl = Vs / Vtot;
       for i in 1:NOC loop
       gamma_bubl[i] = exp(V[i] * ((Sp[i] - S_bubl) ^ 2) / (R * T));
       end for;
      
      for i in 1:NOC loop
        Tr[i] = T / Tc[i];
        
        if((Pc[i]<=0)) then
        Pr_bubl[i] =0;
        else
        Pr_bubl[i] = Pbubl / Pc[i];
        end if;
     
      if(Tc[i] == 33.19) then
      
      (v0[i]) = 10^(( 1.50709)+(( 2.74283)/Tr[i])+((-0.0211)*Tr[i])+(( 0.00011)*Tr[i]*Tr[i])+(((0.008585)- (log10(Pr_bubl[i])))));
          
      elseif(Tc[i] == 190.56) then 
       
        (v0[i]) =10^((1.36822)+((-1.54831)/Tr[i])+((0.02889)*Tr[i]*Tr[i])+((-0.01076) *Tr[i]*Tr[i]*Tr[i])+(((0.10486)+((-0.02529)*Tr[i])-(log10(Pr_bubl[i])))));   
      
      else 
        
        (v0[i]) = 10^((2.05135) + ((-2.10889)/Tr[i]) +((-0.19396) *Tr[i] *Tr[i])+((0.02282) *Tr[i]*Tr[i]*Tr[i])+(((0.08852)+((-0.00872)*Tr[i]*Tr[i]))*Pr_bubl[i])+(((-0.00353) +((0.00203)*Tr[i]))*(Pr_bubl[i]*Pr_bubl[i])) - (log10(Pr_bubl[i])));
        
     end if;
     
    (v1[i]) = 10^(-4.23893 + (8.65808 * Tr[i]) - (1.2206 / Tr[i]) - (3.15224 * Tr[i] ^ 3) - 0.025 * (Pr_bubl[i] - 0.6));
     
     if(v1[i] == 0) then 
       v[i]  = 10^(log10(v0[i]) );
     else 
       v[i]  = 10^(log10(v0[i]) + (w[i] * log10(v1[i])));
     end if; 
       liqfugcoeff_bubl[i] = v[i] * gamma_bubl[i];
      end for; 
    
     for i in 1:NOC loop
       gammaBubl[i] = liqfugcoeff_bubl[i] * (Pbubl/Psat[i]);
     end for;
    //===================================================================================
    //Dew Point Algorithm
      for i in 1:NOC loop
      if((gammaDew[i] * Psat[i]==0)) then
      dewLiqMolFrac[i] = 0;
      else
      dewLiqMolFrac[i] = (compMolFrac[1, i] * Pdew) / (gammaDew[i] * Psat[i]);
      end if;
      end for; 
       
      amv_dew =  EOS_Constant1V(NOC,dewLiqMolFrac[:],a_ij);
      bmv_dew =  sum(dewLiqMolFrac[:] .* b[:]);
      
      AG_dew = (amv_dew * Pdew) / ((R_gas * T) ^ 2);
      BG_dew = (bmv_dew * Pdew) / ( R_gas * T);
      
      for i in 1:NOC loop
      if(bmv_dew==0) then
      A[i]=0;
      else
      A[i] = b[i]/bmv_dew;
      end if;
      end for;
      
      for i in 1:NOC loop
      if(amv_dew==0) then
      B[i]=0;
      else
      B[i] = a[i]/amv_dew;
      end if;
      end for;
      
      if((BG_dew * (((u) ^ 2)^ 0.5))==0) then
      E =0;
      else
      E = (BG_dew * (((u) ^ 2)^ 0.5));
      end if;
      
      if(E==0) then
      G =0;
      else
      G = AG_dew /(E);
      end if;
      
      if(bmv_dew==0) then
      I =0;
      else
      I = (Zv_dew - 1)/ bmv_dew;
      end if;
      
      if((Zv_dew - BG_dew)<=0) then
      J = 0;
      else
      J = -log((Zv_dew - BG_dew));
      end if;
        
      for i in 1:NOC loop
      t1_dew[i] = b[i] * I;
      t3_dew[i] = G * ((A[i]) - ( 2 * ((B[i]) ^ 0.5)));
      end for;
      if((((2 * Zv_dew) + (BG_dew * (u + ((((u)^ 2)^ 0.5)))))/((2 * Zv_dew) + (BG_dew * (u - ((((u) ^ 2)^ 0.5))))))<=0) then
      t4_dew =0;
      else 
      t4_dew =  log(((2 * Zv_dew) + (BG_dew * (u + ((((u)^ 2)^ 0.5)))))/((2 * Zv_dew) + (BG_dew * (u - ((((u) ^ 2)^ 0.5))))));  
      end if;
      t2_dew = J;
      
      for i in 1:NOC loop
      vapfugcoeff_dew[i] = exp(t1_dew[i] + t2_dew + (t3_dew[i] * t4_dew));  
      
      if(Psat[i]==0) then
      H[i]=0;
      else
      H[i] = Pdew/Psat[i];
      end if;
      gammaDew[i] = vapfugcoeff_dew[i] * H[i];  
      end for;
       
      algorithm
      CV_dew[1] := 1;
      CV_dew[2] := -(1+BG_dew - (u*BG_dew));
      CV_dew[3] := (AG_dew -(u * BG_dew)-(u*(BG_dew^2)));
      CV_dew[4] := (-AG_dew *BG_dew );
      Z_RV_dew := Modelica.Math.Vectors.Utilities.roots(CV_dew);
      ZV_dew := {Z_RV_dew[i, 1] for i in 1:3};
      Zv_dew := max({ZV_dew}); 
      algorithm   
      CV[1] := 1;
      CV[2] := -(1+BG - (u*BG));
      CV[3] := (AG -(u * BG)-(u*(BG^2)));
      CV[4] := (-AG *BG );
      Z_RV := Modelica.Math.Vectors.Utilities.roots(CV);
      ZV := {Z_RV[i, 1] for i in 1:3};
      Zv := max({ZV}); 
      
    //==========================================================================================================
    end Grayson_Streed;

end Thermodynamic_Packages;
