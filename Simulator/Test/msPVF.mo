within Simulator.Test;

model msPVF
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Methanol meth;
  parameter data.Ethanol eth;
  parameter data.Water wat;
  extends Streams.MaterialStream(NC = 3, C = {meth, eth, wat}, T(start = 355.97), x_pc(start = {{0.33, 0.33, 0.34}, {0.32, 0.33, 0.34}, {0.53, 0.32, 0.14}}));
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
equation
  P = 101325;
  xvap = 0.036257;
  x_pc[1, :] = {0.33, 0.33, 0.34};
  F_p[1] = 100;
end msPVF;
