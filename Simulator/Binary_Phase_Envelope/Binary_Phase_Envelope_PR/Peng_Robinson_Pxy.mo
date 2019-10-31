within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_PR;

model Peng_Robinson_Pxy
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethane eth;
  parameter data.Propane prop;
  parameter Integer NOC = 2;
  parameter Integer N = 2;
  parameter data.General_Properties comp[NOC] = {eth, prop};
  Phase_Equilibria points[N](each T = 210, each NOC = NOC, each comp = comp, each T(start = 273), each Tbubl(start = 273), each x(each start = 0.5), each y(each start = 0.5));
  Real x1[N], y1[N], x2[N], y2[N], P[N](each start = 101325), Tbubl[N], Temp[N];
equation
//Generation of Points to compute Bubble Temperature
  points[:].x[1] = x1[:];
  points[:].y[1] = y1[:];
  points[:].x[2] = x2[:];
  points[:].y[2] = y2[:];
  points[:].P = P;
  points[:].Tbubl = Tbubl;
  Temp[1] = Tbubl[1];
  Temp[N] = Tbubl[N];
  for i in 2:N - 1 loop
    Temp[i] = points[i].T;
  end for;
  for i in 1:N loop
    x1[i] = 0.5 + (i - 1) * 0.025;
  end for;
end Peng_Robinson_Pxy;
