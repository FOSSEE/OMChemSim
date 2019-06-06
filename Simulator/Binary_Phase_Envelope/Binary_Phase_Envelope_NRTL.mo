within Simulator.Binary_Phase_Envelope;

package Binary_Phase_Envelope_NRTL
  model NRTL_model
    import Simulator.Files.Thermodynamic_Functions.*;
    gammaNRTL_model Gamma(NOC = NOC, comp = comp, molFrac = x[:], T = T);
    Real density[NOC], BIPS[NOC, NOC, 2];
  equation
    gamma = Gamma.gamma;
    BIPS = Gamma.BIPS;
    for i in 1:NOC loop
      density[i] = Dens(comp[i].LiqDen, comp[i].Tc, T, P);
    end for;
    for i in 1:NOC loop
      K[i] = gamma[i] * Psat(comp[i].VP, T) / P;
    end for;
  end NRTL_model;

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

  model Onehexene_Acetone_Pxy
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Onehexene ohex;
    parameter data.Acetone acet;
    parameter Integer NOC = 2;
    parameter Real BIP[NOC, NOC, 2] = Simulator.Files.Thermodynamic_Functions.BIPNRTL(NOC, comp.CAS);
    parameter data.General_Properties comp[NOC] = {ohex, acet};
    base points[41](each T = 424, each NOC = NOC, each comp = comp, each BIP = BIP);
    Real x[41, NOC], y[41, NOC], P[41];
  equation
    points[:].x = x;
    points[:].y = y;
    points[:].P = P;
    for i in 1:41 loop
      x[i, 1] = 0 + (i - 1) * 0.025;
    end for;
  end Onehexene_Acetone_Pxy;
end Binary_Phase_Envelope_NRTL;
