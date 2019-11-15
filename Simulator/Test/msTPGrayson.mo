within Simulator.Test;

model msTPGrayson
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethylene eth;
  parameter data.Acetylene acet;
  parameter data.OneOnedichloroethane dich;
  parameter data.Propadiene prop;
  //w=Acentric Factor
  //Sp = Solublity Parameter
  //V = Molar Volume
  //All the above three parameters have to be mentioned as arguments while extending the thermodynamic Package Grayson Streed  as shown below
  extends Simulator.Files.Thermodynamic_Packages.Grayson_Streed(W_c = {0.0949, 0.1841, 0.244612, 0.3125}, SP_c = {0.00297044, 0.00449341, 0.00437069, 0.00419199}, V_c = {61, 42.1382, 84.7207, 60.4292});
  extends Simulator.Streams.MaterialStream(Nc = 4, C = {eth, acet, dich, prop});
  //Equations
equation
  P = 101325;
  T = 210.246;
  x_pc[1, :] = {0.4, 0.2, 0.3, 0.1};
  F_p[1] = 50;
end msTPGrayson;
