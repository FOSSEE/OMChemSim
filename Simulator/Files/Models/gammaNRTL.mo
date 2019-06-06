within Simulator.Files.Models;

model gammaNRTL
  //  input Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  parameter Integer NOC;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  Real molFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), T(min = 0, start = 273.15);
  Real gamma[NOC](each start = 1);
  Real tau[NOC, NOC], G[NOC, NOC], alpha[NOC, NOC], A[NOC, NOC], BIPS[NOC, NOC, 2];
  Real sum1[NOC](each start = 1), sum2[NOC](each start = 1);
  constant Real R = 1.98721;
equation
  BIPS = Simulator.Files.Thermodynamic_Functions.BIPNRTL(NOC, comp.CAS);
  A = BIPS[:, :, 1];
  alpha = BIPS[:, :, 2];
  tau = A ./ (R * T);
//  G = exp(-alpha .* tau);//this equation is giving error in OM 1.11 hence for loop used
  for i in 1:NOC loop
    for j in 1:NOC loop
      G[i, j] = exp(-alpha[i, j] * tau[i, j]);
    end for;
  end for;
//G = {{1, 1.1574891705 }, {0.8455436959, 1}};
  for i in 1:NOC loop
    sum1[i] = sum(molFrac[:] .* G[:, i]);
    sum2[i] = sum(molFrac[:] .* tau[:, i] .* G[:, i]);
  end for;
  for i in 1:NOC loop
    log(gamma[i]) = sum(molFrac[:] .* tau[:, i] .* G[:, i]) / sum(molFrac[:] .* G[:, i]) + sum(molFrac[:] .* G[i, :] ./ sum1[:] .* (tau[i, :] .- sum2[:] ./ sum1[:]));
  end for;
end gammaNRTL;
