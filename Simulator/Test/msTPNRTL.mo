within Simulator.Test;

model msTPNRTL
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Onehexene ohex;
  parameter data.Ethanol eth;
  extends Simulator.Streams.Material_Stream(NOC = 2, comp = {ohex, eth}, compMolFrac(each start = 0.33));
  extends Simulator.Files.Thermodynamic_Packages.NRTL;
equation
  compMolFrac[1, :] = {0.5, 0.5};
  totMolFlo[1] = 100;
  P = 101325;
  T = 330;
end msTPNRTL;
