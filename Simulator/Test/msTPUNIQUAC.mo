within Simulator.Test;

model msTPUNIQUAC
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethanol eth;
  parameter data.Water wat;
  extends Simulator.Streams.Material_Stream(NOC = 2, comp = {eth, wat}, Pbubl(start = 101325), Pdew(start = 101325), compMolFrac(each start = 0.33));
  extends Simulator.Files.Thermodynamic_Packages.UNIQUAC;
equation
  compMolFrac[1, :] = {0.5, 0.5};
  totMolFlo[1] = 50;
  P = 101325;
  T = 354;
end msTPUNIQUAC;
