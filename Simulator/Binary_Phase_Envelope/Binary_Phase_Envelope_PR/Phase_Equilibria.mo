within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_PR;

model Phase_Equilibria
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Ethane eth;
  parameter data.Propane prop;
  extends PR(NOC = 2, comp = {eth, prop});
  Real P, T(start = 273), K[NOC], x[NOC](each start = 0.5), y[NOC], Tbubl(start = 273);
equation
  K[:] = liqfugcoeff[:] ./ vapfugcoeff[:];
  y[:] = K[:] .* x[:];
  sum(x[:]) = 1;
  sum(y[:]) = 1;
end Phase_Equilibria;
