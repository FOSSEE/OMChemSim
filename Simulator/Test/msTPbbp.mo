within Simulator.Test;

model msTPbbp "material stream below bubble point"
  //we have to first instance components to give to material stream model.
  import data = Simulator.Files.Chemsep_Database;
  //instantiation of chemsep database
  parameter data.Methanol meth;
  //instantiation of methanol
  parameter data.Ethanol eth;
  //instantiation of ethanol
  parameter data.Water wat;
  //instantiation of water
  extends Streams.Material_Stream(Nc = 3, C = {meth, eth, wat}, H_pc(each start = eth.SH), S_pc(each start = eth.AS), x_pc(each min = 0.01, each max = 1, each start = 0.33));
  //material stream model is extended and values of parameters NOC and comp are given. These parameters are declared in Material stream model. We are only giving them values here.
  //NOC - number of components, comp -  component array.
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
equation
//These are the values to be specified by user. In this P, T, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
  P = 202650;
  T = 320;
  x_pc[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
  F_p[1] = 31.346262;
//1 stands for mixture
end msTPbbp;
