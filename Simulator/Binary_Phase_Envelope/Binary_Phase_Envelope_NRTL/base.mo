within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_NRTL;

model base
  import data = Simulator.Files.Chemsep_Database;
  parameter Integer NOC;
  parameter Real BIP[NOC, NOC, 2];
  parameter data.General_Properties comp[NOC];
  extends NRTL_model(BIPS = BIP);
  Real P, T(start = 300), gamma[NOC], K[NOC], x[NOC](each start = 0.5), y[NOC];
equation
  y[:] = K[:] .* x[:];
  sum(x[:]) = 1;
  sum(y[:]) = 1;
end base;
