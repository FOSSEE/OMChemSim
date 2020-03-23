within Simulator.Files.Models.ReactionManager;

  model ConversionReaction "Model of a conversion reaction used in conversion reactor"
  //===================================================================================================
  import Simulator.Files.*;
  import data = Simulator.Files.Chemsep_Database;
    //Number of Reactions involved in the process
  parameter Integer Nr "Number of reactions" annotation(
    Dialog(tab = "Reactions", group = "Conversion Reaction Parameters"));
  parameter Integer BC_r[Nr] "Base component in the reactions" annotation(
    Dialog(tab = "Reactions", group = "Conversion Reaction Parameters"));
  parameter Real Coef_cr[Nc, Nr] "Stoichiometric coefficient of components" annotation(
    Dialog(tab = "Reactions", group = "Conversion Reaction Parameters"));
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

annotation(
    Documentation(info = "<html><head></head><body><div>The <b>Conversion Reaction</b>&nbsp;defined is used in the conversion reactor for the following purposes:</div><div><ul><li>Check if the stoichiometry specified for the reaction is balanced</li><li>Calculate the heat of formation</li><li>Calculate the heat of reaction</li></ul></div><div><br></div>In a conversion reaction model, following calculation parameters are defined:<div><ol><li>Number of Reactions (<b>Nr</b>)</li><li>Base Component (<b>BC_r</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">All the above variables are of type <i>parameter Real </i>or<i> parameter Integer.</i></span></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\">During simulation, their values can specified directly under&nbsp;<b>Reactions </b>tab<b>&nbsp;</b>by double clicking on the reactor model instance.</div></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><br></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\">The model needs to be extended along with the conversion reator.</div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Conversion Reactor, go to&nbsp;</span><a href=\"modelica://Simulator.Examples.CR\" style=\"font-size: 12px;\">Conversion Reactor Example</a><span style=\"font-size: 12px;\">.</span></div><div><br></div></body></html>"));
    end ConversionReaction;
