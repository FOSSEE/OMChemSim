within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_NRTL;

model Onehexene_Acetone_Txy
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Onehexene ohex;
  parameter data.Acetone acet;
  parameter Integer NOC = 2;
  parameter Real BIP[NOC, NOC, 2] = Simulator.Files.Thermodynamic_Functions.BIPNRTL(NOC, comp.CAS);
  parameter data.General_Properties comp[NOC] = {ohex, acet};
  base points[41](each P = 1013250, each NOC = NOC, each comp = comp, each BIP = BIP);
  Real x[41, NOC], y[41, NOC], T[41];
equation
  points[:].x = x;
  points[:].y = y;
  points[:].T = T;
  for i in 1:41 loop
    x[i, 1] = 0 + (i - 1) * 0.025;
  end for;
end Onehexene_Acetone_Txy;
