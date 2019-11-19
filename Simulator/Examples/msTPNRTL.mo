within Simulator.Examples;

model msTPNRTL
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Onehexene ohex;
  parameter data.Ethanol eth;
  extends Simulator.Streams.MaterialStream(Nc = 2, C = {ohex, eth}, x_pc(each start = 0.33));
  extends Simulator.Files.ThermodynamicPackages.NRTL;
equation
  x_pc[1, :] = {0.5, 0.5};
  F_p[1] = 100;
  P = 101325;
  T = 330;
end msTPNRTL;
