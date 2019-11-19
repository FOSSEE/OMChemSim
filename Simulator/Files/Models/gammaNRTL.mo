within Simulator.Files.Models;

model gammaNRTL
  //  input Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  parameter Integer Nc;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  Real x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)), T(min = 0, start = 273.15);
  Real gma_c[Nc](each start = 1);
  Real tau[Nc, Nc], G[Nc, Nc], alpha[Nc, Nc], A[Nc, Nc], BIPS[Nc, Nc, 2];
  Real sum1[Nc](each start = 1), sum2[Nc](each start = 1);
  constant Real R = 1.98721;
equation
  BIPS = Simulator.Files.ThermodynamicFunctions.BIPNRTL(Nc, C.CAS);
  A = BIPS[:, :, 1];
  alpha = BIPS[:, :, 2];
  tau = A ./ (R * T);
//  G = exp(-alpha .* tau);//this equation is giving error in OM 1.11 hence for loop used
  for i in 1:Nc loop
    for j in 1:Nc loop
      G[i, j] = exp(-alpha[i, j] * tau[i, j]);
    end for;
  end for;
//G = {{1, 1.1574891705 }, {0.8455436959, 1}};
  for i in 1:Nc loop
    sum1[i] = sum(x_c[:] .* G[:, i]);
    sum2[i] = sum(x_c[:] .* tau[:, i] .* G[:, i]);
  end for;
  for i in 1:Nc loop
    log(gma_c[i]) = sum(x_c[:] .* tau[:, i] .* G[:, i]) / sum(x_c[:] .* G[:, i]) + sum(x_c[:] .* G[i, :] ./ sum1[:] .* (tau[i, :] .- sum2[:] ./ sum1[:]));
  end for;
end gammaNRTL;
