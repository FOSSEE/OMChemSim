within Simulator.Test;

model msPH
  //we have to first instance components to give to material stream model.
  import data = Simulator.Files.Chemsep_Database;
  //instantiation of chemsep database
  parameter data.Methanol meth;
  //instantiation of methanol
  parameter data.Ethanol eth;
  //instantiation of ethanol
  parameter data.Water wat;
  //instantiation of water
  extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat}, totMolFlo(each start = 1), compMolFrac(each start = 0.33), T(start = sum(comp.Tb) / NOC));
  //material stream model is extended and values of parameters NOC and comp are given. These parameters are declred in Material stream model. We are only giving them values here.
  //we need to give proper initialization values for converging, Initialization values are provided for totMolFlo, compMolFrac and T while extending.
  //NOC - number of components, comp -  component array.
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
equation
//These are the values to be specified by user. In this P, mixture molar enthalpy, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
  P = 101325;
  phasMolEnth[1] = -34452;
  compMolFrac[1, :] = {0.33, 0.33, 0.34};
//1 stands for mixture
  totMolFlo[1] = 31.346262;
//1 stands for mixture
end msPH;
