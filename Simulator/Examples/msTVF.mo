within Simulator.Examples;


model msTVF
  // database and components are instantiated, material stream and thermodynamic package extended
  Simulator.Files.ChemsepDatabase data;
  parameter data.Methanol meth;
  parameter data.Ethanol eth;
  parameter data.Water wat;
  extends Streams.MaterialStream(Nc = 3, C= {meth, eth, wat}, x_pc(start = {{0.33, 0.33, 0.34}, {0.32, 0.33, 0.34}, {0.53, 0.32, 0.14}}));
  //Nc - number of components, comp -  component array.
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
equation
//Here vapor phase mole fraction, temperature, mixture component mole fraction and mixture molar flow is given.
  xvap = 0.036257;
  T = 351;
  x_pc[1, :] = {0.33, 0.33, 0.34};
  F_p[1] = 31.346262;
end msTVF;
