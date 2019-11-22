within Simulator.Files.Models.ReactionManager;

  model ConversionReaction
  //===================================================================================================
  import Simulator.Files.*;
  import data = Simulator.Files.Chemsep_Database;
    //Number of Reactions involved in the process
  parameter Integer Nr;

  parameter Integer BC_r[Nr] "Base component of reactions";

  parameter Real Coef_cr[Nc, Nr];
  //Stochiometry of reactions

  Real Schk_r[Nr];
  //Returns whether the specified stoichiometry is correct
  Real Hf_c[Nc];
  Real Hr_r[Nr];

equation
//Check of stoichiometric balance
  Schk_r = Stoichiometrycheck(Nr, Nc, C[:].MW, Coef_cr);
//Calculation of Heat of Reaction
  Hf_c[:] = C[:].IGHF .* 1E-3;
//=============================================================================================
  for i in 1:Nr loop
    Hr_r[i] = sum(Hf_c[:] .* Coef_cr[:, i] / abs(Coef_cr[BC_r[i], i]));
  end for;
end ConversionReaction;
