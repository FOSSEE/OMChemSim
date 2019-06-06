within Simulator.Files.Models.ReactionManager;

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
