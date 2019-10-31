within Simulator.Files;

package Models
  model Flash
    //this is basic flash model.  comp and NOC has to be defined in model. thermodyanamic model must also be extended along with this model for K value.
    import Simulator.Files.*;
    Real totMolFlo[3](each min = 0, each start = 100), compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), compMolSpHeat[3, NOC], compMolEnth[3, NOC], compMolEntr[3, NOC], phasMolSpHeat[3], phasMolEnth[3], phasMolEntr[3], liqPhasMolFrac(min = 0, max = 1, start = 0.5), vapPhasMolFrac(min = 0, max = 1, start = 0.5), P(min = 0, start = 101325), T(min = 0, start = 298.15);
    Real Pbubl(start = 101325, min = 0) "Bubble point pressure", Pdew(start = 101325, min = 0) "dew point pressure";
  equation
//Mole Balance
    totMolFlo[1] = totMolFlo[2] + totMolFlo[3];
    compMolFrac[1, :] .* totMolFlo[1] = compMolFrac[2, :] .* totMolFlo[2] + compMolFrac[3, :] .* totMolFlo[3];
//Bubble point calculation
    Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
    Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
    if P >= Pbubl then
      compMolFrac[3, :] = zeros(NOC);
//    sum(compMolFrac[2, :]) = 1;
      totMolFlo[3] = 0;
    elseif P >= Pdew then
//VLE region
      for i in 1:NOC loop
//      compMolFrac[3, i] = K[i] * compMolFrac[2, i];
        compMolFrac[2, i] = compMolFrac[1, i] ./ (1 + vapPhasMolFrac * (K[i] - 1));
      end for;
      sum(compMolFrac[2, :]) = 1;
//sum y = 1
    else
//above dew point region
      compMolFrac[2, :] = zeros(NOC);
//    sum(compMolFrac[3, :]) = 1;
      totMolFlo[2] = 0;
    end if;
//Energy Balance
    for i in 1:NOC loop
//Specific Heat and Enthalpy calculation
      compMolSpHeat[2, i] = Thermodynamic_Functions.LiqCpId(comp[i].LiqCp, T);
      compMolSpHeat[3, i] = Thermodynamic_Functions.VapCpId(comp[i].VapCp, T);
      compMolEnth[2, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      compMolEnth[3, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
      (compMolEntr[2, i], compMolEntr[3, i]) = Thermodynamic_Functions.SId(comp[i].AS, comp[i].VapCp, comp[i].HOV, comp[i].Tb, comp[i].Tc, T, P, compMolFrac[2, i], compMolFrac[3, i]);
    end for;
    for i in 2:3 loop
      phasMolSpHeat[i] = sum(compMolFrac[i, :] .* compMolSpHeat[i, :]) + resMolSpHeat[i];
      phasMolEnth[i] = sum(compMolFrac[i, :] .* compMolEnth[i, :]) + resMolEnth[i];
      phasMolEntr[i] = sum(compMolFrac[i, :] .* compMolEntr[i, :]) + resMolEntr[i];
    end for;
    phasMolSpHeat[1] = liqPhasMolFrac * phasMolSpHeat[2] + vapPhasMolFrac * phasMolSpHeat[3];
    compMolSpHeat[1, :] = compMolFrac[1, :] .* phasMolSpHeat[1];
    phasMolEnth[1] = liqPhasMolFrac * phasMolEnth[2] + vapPhasMolFrac * phasMolEnth[3];
    compMolEnth[1, :] = compMolFrac[1, :] .* phasMolEnth[1];
    phasMolEntr[1] = liqPhasMolFrac * phasMolEntr[2] + vapPhasMolFrac * phasMolEntr[3];
    compMolEntr[1, :] = compMolFrac[1, :] * phasMolEntr[1];
//phase molar fractions
    liqPhasMolFrac = totMolFlo[2] / totMolFlo[1];
    vapPhasMolFrac = totMolFlo[3] / totMolFlo[1];
  end Flash;

  model gammaNRTL
    //  input Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    parameter Integer NOC;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
    Real molFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), T(min = 0, start = 273.15);
    Real gamma[NOC](each start = 1);
    Real tau[NOC, NOC], G[NOC, NOC], alpha[NOC, NOC], A[NOC, NOC], BIPS[NOC, NOC, 2];
    Real sum1[NOC](each start = 1), sum2[NOC](each start = 1);
    constant Real R = 1.98721;
  equation
    BIPS = Simulator.Files.Thermodynamic_Functions.BIPNRTL(NOC, comp.CAS);
    A = BIPS[:, :, 1];
    alpha = BIPS[:, :, 2];
    tau = A ./ (R * T);
//  G = exp(-alpha .* tau);//this equation is giving error in OM 1.11 hence for loop used
    for i in 1:NOC loop
      for j in 1:NOC loop
        G[i, j] = exp(-alpha[i, j] * tau[i, j]);
      end for;
    end for;
//G = {{1, 1.1574891705 }, {0.8455436959, 1}};
    for i in 1:NOC loop
      sum1[i] = sum(molFrac[:] .* G[:, i]);
      sum2[i] = sum(molFrac[:] .* tau[:, i] .* G[:, i]);
    end for;
    for i in 1:NOC loop
      log(gamma[i]) = sum(molFrac[:] .* tau[:, i] .* G[:, i]) / sum(molFrac[:] .* G[:, i]) + sum(molFrac[:] .* G[i, :] ./ sum1[:] .* (tau[i, :] .- sum2[:] ./ sum1[:]));
    end for;
  end gammaNRTL;

  package ReactionManager
    function Stoichiometrycheck
      //This functions checks the stoichiometry of the reaction we have given and returns "1" as output if the stoichiometry is okay and returns 0 otherwise.
      input Integer Nr "No. of Reactions";
      input Integer NOC "Nomber of components in the required reactions";
      input Real MW[NOC] "Molecular weight";
      input Real Sc[NOC, Nr] "Reaction coefficients";
      output Integer Check[Nr];
    protected
      Real D[Nr] = fill(0, Nr);
    algorithm
      for i in 1:Nr loop
        for j in 1:NOC loop
          D[i] := D[i] + MW[j] * Sc[j, i];
        end for;
        if D[i] <= 0.1 and D[i] >= (-0.1) then
          Check[i] := 1;
        else
          Check[i] := 0;
        end if;
      end for;
    end Stoichiometrycheck;

    function Arhenious
      // Reaction rate constant k = A*exp(-E/RT)
      input Integer Nr;
      input Real A1 "To calulate reaction rate for forward reaction (Arrhenius constants of forward reaction)";
      input Real E1 "To calculate reaction rate for forward reaction";
      input Real T;
      output Real k1 "reaction rate constants for forward reaction";
    algorithm
      k1 := A1 .* exp(-E1 / (8.314 * T));
    end Arhenious;

    model Reaction_Manager
      //===================================================================================================
      import Simulator.Files.*;
      import data = Simulator.Files.Chemsep_Database;
      parameter Chemsep_Database.General_Properties comp[NOC];
      parameter Integer NOC;
      parameter Integer Nr;
      //Number of Reactions involved in the process
      parameter Integer Bc[Nr] "Base component of reactions";
      parameter Integer Comp;
      //Number of components involved in the reaction
      parameter Real Sc[NOC, Nr];
      //Stochiometry of reactions
      parameter Real DO[NOC, Nr];
      //Direct order of reactions
      parameter Real RO[NOC, Nr];
      //Reverse order of reactions
      Real Stoic_Check[Nr];
      //Returns whether the specified stoichiometry is correct
      Real HOF_comp[NOC];
      Real HOR[Nr];
      parameter Real A1[Nr] "Arrhenius constants of forward reaction";
      parameter Real E1[Nr] "Activation Energy of the forward reaction";
      parameter Real A2[Nr] "Arrhenius constants of reverse reaction";
      parameter Real E2[Nr] "Activation Energy for the reverse reaction";
    equation
//Check of stoichiometric balance
      Stoic_Check = Stoichiometrycheck(Nr, NOC, comp[:].MW, Sc);
//Calculation of Heat of Reaction
      HOF_comp[:] = comp[:].IGHF .* 1E-3;
//=============================================================================================
      for i in 1:Nr loop
        HOR[i] = sum(HOF_comp[:] .* Sc[:, i]) / Bc[i];
      end for;
    end Reaction_Manager;

    //==============================================================================================
  end ReactionManager;
end Models;
