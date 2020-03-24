within Simulator.Files.Models.ReactionManager;

  model KineticReaction "Model of a kinetic reaction used in PFR or CSTR"
  //===================================================================================================
  import Simulator.Files.*;
  import data = Simulator.Files.Chemsep_Database;
  //  parameter ChemsepDatabase.GeneralProperties C[Nc];
  //  parameter Integer Nc;
  parameter Integer Nr "Number of reactions" annotation (Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
  parameter Integer BC_r[Nr] "Base component of reactions" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
 //  parameter Integer Comp annotation(
  //   Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
  //Number of components involved in the reaction
  parameter Real Coef_cr[Nc, Nr] "Stoichiometric coefficient of the components" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
  parameter Real DO_cr[Nc, Nr] "Forward order of the components" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
  //  parameter Real RO_cr[Nc, Nr];
  //Reverse order of reactions
  Real Schk_r[Nr];
  //Returns whether the specified stoichiometry is correct
  Real Hf_c[Nc];
  Real Hr_r[Nr];
  parameter Real Af_r[Nr] "Arrhenius constants of forward reaction" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
  parameter Real Ef_r[Nr] "Activation Energy of the forward reaction" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
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

annotation(
    Documentation(info = "<html><head></head><body><div>The <b>Kinetic Reaction</b>&nbsp;defined is used either in the PFR or CSTR for the following purposes:</div><div><ul><li>Check if the stoichiometry specified for the reaction is balanced</li><li>Calculate the heat of formation</li><li>Calculate the heat of reaction</li></ul></div><div><br></div>In a kinetic reaction model, following calculation parameters are defined:<div><ol><li>Number of Reactions (<b>Nr</b>)</li><li>Base Component (<b>BC_r</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li><li>Forward order of the components (<b>DO_cr</b>)</li><li>Arrehenius Constant of Forward Reaction (<b>Af_r</b>)</li><li>Activation Energy of Forward Reaction (<b>Ef_r</b>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">All the above variables are of type <i>parameter Real </i>or<i> parameter Integer.</i></span></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\">During simulation, their values can specified directly under&nbsp;<b>Reactions </b>tab<b>&nbsp;</b>by double clicking on the reactor model instance.</div></div></div><div><br></div></body></html>"));
    end KineticReaction;
