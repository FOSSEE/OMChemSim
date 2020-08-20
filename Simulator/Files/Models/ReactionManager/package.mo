within Simulator.Files.Models;

package ReactionManager "Package with functions and reactions used in different reaction systems"
  extends Modelica.Icons.Package;
   










  annotation(
    Documentation(info = "<html><head></head><body>This is a package of different functions and models for required for simulating different reactors available under this package. Currently, following functions and models are available:<div><ol><li>Stoichiometrycheck - Function to check the stoichiometric balance of a reaction equation</li><li>Arhenious - Function to calcculate the Arrhenius rate constant from pre-exponential factor and frequency factor</li><li>BaseCalc - Function to determine the base component/limiting component in a reaction</li><li><a href=\"modelica://Simulator.Files.Models.ReactionManager.ConversionReaction\" style=\"font-size: 12px;\">Conversion Reaction</a>&nbsp;- Model of Conversion Reaction used in a Conversion Reactor</li><li><a href=\"modelica://Simulator.Files.Models.ReactionManager.KineticReaction\" style=\"font-size: 12px;\">Kinetic Reaction</a>&nbsp;-&nbsp;Model of Kinetic Reaction used in PFR/CSTR</li><li><a href=\"modelica://Simulator.Files.Models.ReactionManager.EquilibriumReaction\" style=\"font-size: 12px;\">Equilibrium Reaction</a>&nbsp;-&nbsp;Model of Equilibrium Reaction used in an Equilibrium Reactor</li></ol></div></body></html>"));
end ReactionManager;
