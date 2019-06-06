within Simulator.Test;

model msTVF
  // database and components are instantiated, material stream and thermodynamic package extended
  Simulator.Files.Chemsep_Database data;
  parameter data.Methanol meth;
  parameter data.Ethanol eth;
  parameter data.Water wat;
  extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat}, compMolFrac(start = {{0.33, 0.33, 0.34}, {0.32, 0.33, 0.34}, {0.53, 0.32, 0.14}}));
  //NOC - number of components, comp -  component array.
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
equation
//Here vapor phase mole fraction, temperature, mixture component mole fraction and mixture molar flow is given.
  vapPhasMolFrac = 0.036257;
  T = 351;
  compMolFrac[1, :] = {0.33, 0.33, 0.34};
  totMolFlo[1] = 31.346262;
end msTVF;
