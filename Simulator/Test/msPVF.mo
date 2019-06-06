within Simulator.Test;

model msPVF
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Methanol meth;
  parameter data.Ethanol eth;
  parameter data.Water wat;
  extends Streams.Material_Stream(NOC = 3, comp = {meth, eth, wat}, T(start = 355.97), compMolFrac(start = {{0.33, 0.33, 0.34}, {0.32, 0.33, 0.34}, {0.53, 0.32, 0.14}}));
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
equation
  P = 101325;
  vapPhasMolFrac = 0.036257;
  compMolFrac[1, :] = {0.33, 0.33, 0.34};
  totMolFlo[1] = 100;
end msPVF;
