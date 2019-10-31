within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_PR;

model Peng_Robinson_Txy
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethane eth;
  parameter data.Propane prop;
  parameter Integer NOC = 2;
  parameter Integer N = 1;
  parameter data.General_Properties comp[NOC] = {eth, prop};
  Phase_Equilibria points[N](each P = 101325, each NOC = NOC, each comp = comp, each T(start = 273), each Tbubl(start = 273), each x(each start = 0.5), each y(each start = 0.5));
  Real x[N, NOC], y[N, NOC], T[N], Tbubl[N], T_PR[N];
equation
  points[:].x = x;
  points[:].y = y;
  points[:].T = T;
  points[:].Tbubl = Tbubl;
  T_PR[1] = Tbubl[1];
  T_PR[N] = Tbubl[N];
  for i in 2:N - 1 loop
    T_PR[i] = T[i];
  end for;
  for i in 1:N loop
    x[i, 1] = 0 + (i - 1) * 0.025;
  end for;
end Peng_Robinson_Txy;
