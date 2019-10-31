within Simulator.Binary_Phase_Envelope.Binary_Phase_Envelope_NRTL;

model gammaNRTL_model
  parameter Integer NOC;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  Real molFrac[NOC], T;
  Real gamma[NOC];
  Real tau[NOC, NOC], G[NOC, NOC], alpha[NOC, NOC], A[NOC, NOC], BIPS[NOC, NOC, 2];
  Real sum1[NOC], sum2[NOC];
  constant Real R = 1.98721;
equation
  A = BIPS[:, :, 1];
  alpha = BIPS[:, :, 2];
  tau = A ./ (R * T);
  for i in 1:NOC loop
    for j in 1:NOC loop
      G[i, j] = exp(-alpha[i, j] * tau[i, j]);
    end for;
  end for;
  for i in 1:NOC loop
    sum1[i] = sum(molFrac[:] .* G[:, i]);
    sum2[i] = sum(molFrac[:] .* tau[:, i] .* G[:, i]);
  end for;
  for i in 1:NOC loop
    log(gamma[i]) = sum(molFrac[:] .* tau[:, i] .* G[:, i]) / sum(molFrac[:] .* G[:, i]) + sum(molFrac[:] .* G[i, :] ./ sum1[:] .* (tau[i, :] .- sum2[:] ./ sum1[:]));
  end for;
end gammaNRTL_model;
