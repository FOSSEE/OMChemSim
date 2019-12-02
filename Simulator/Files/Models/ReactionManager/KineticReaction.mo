within Simulator.Files.Models.ReactionManager;

  model KineticReaction
  //===================================================================================================
  import Simulator.Files.*;
  import data = Simulator.Files.Chemsep_Database;
//  parameter ChemsepDatabase.GeneralProperties C[Nc];
//  parameter Integer Nc;
  parameter Integer Nr;
  //Number of Reactions involved in the process
  parameter Integer BC_r[Nr] "Base component of reactions";
  parameter Integer Comp;
  //Number of components involved in the reaction
  parameter Real Coef_cr[Nc, Nr];
  //Stochiometry of reactions
  parameter Real DO_cr[Nc, Nr];
  //Direct order of reactions
//  parameter Real RO_cr[Nc, Nr];
  //Reverse order of reactions
  Real Schk_r[Nr];
  //Returns whether the specified stoichiometry is correct
  Real Hf_c[Nc];
  Real Hr_r[Nr];
  parameter Real Af_r[Nr] "Arrhenius constants of forward reaction";
  parameter Real Ef_r[Nr] "Activation Energy of the forward reaction";
//  parameter Real Ab_r[Nr] "Arrhenius constants of reverse reaction";
//  parameter Real Eb_r[Nr] "Activation Energy for the reverse reaction";
equation
//Check of stoichiometric balance
  Schk_r = Stoichiometrycheck(Nr, Nc, C[:].MW, Coef_cr);
//Calculation of Heat of Reaction
  Hf_c[:] = C[:].IGHF .* 1E-3;
//=============================================================================================
  for i in 1:Nr loop
    Hr_r[i] = sum(Hf_c[:] .* Coef_cr[:, i]) / BC_r[i];
  end for;
end KineticReaction;
