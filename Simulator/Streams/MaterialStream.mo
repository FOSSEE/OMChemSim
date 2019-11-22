within Simulator.Streams;

model MaterialStream
  //1 -  Mixture, 2 - Liquid phase, 3 - Gas Phase
//  extends Modelica.Icons.SourcesPackage;
  extends Simulator.Files.Icons.MaterialStream;
  import Simulator.Files.*;
  parameter Integer Nc;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  Real P(min = 0, start = 101325) "Pressure";
  Real T(start = 273) "Temperature";
  Real Pbubl(min = 0, start = sum(C[:].Pc) / Nc) "Bubble point pressure";
  Real Pdew(min = 0, start = sum(C[:].Pc) / Nc) "dew point pressure";
  Real xliq(start = 0.5, min = 0, max = 1) "Liquid Phase mole fraction";
  Real xvap(start = 0.5, min = 0, max = 1) "Vapor Phase mole fraction";
  Real xmliq(start = 0.5, min = 0, max = 1) "Liquid Phase mass fraction";
  Real xmvap(start = 0.5, min = 0, max = 1) "Vapor Phase Mass fraction";
  Real F_p[3](each min = 0, each start = 100) "Total molar flow";
  Real Fm_p[3](each min = 0, each start = 100) "Total Mass Flow";
  Real MW_p[3](each start = 0, each min = 0) "Average Molecular weight of Phases";
  Real x_pc[3, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Component mole fraction";
  Real xm_pc[3, Nc](each start = 1 / (Nc + 1), each min = 0, each max = 1) "Component Mass fraction";
  Real F_pc[3, Nc](each start = 100, each min = 0) "Component Molar flow";
  Real Fm_pc[3, Nc](each min = 0, each start = 100) "Component Mass Fraction";
  Real Cp_p[3] "phase Molar Specific Heat";
  Real Cp_pc[3, Nc] "Component Molar Specific Heat";
  Real H_p[3] "Phase Molar Enthalpy";
  Real H_pc[3, Nc] "Component Molar Enthalpy";
  Real S_p[3] "Phase Molar Entropy";
  Real S_pc[3, Nc] "Component Molar Entropy";
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Connector equations
  In.P = P;
  In.T = T;
  In.F = F_p[1];
  In.H = H_p[1];
  In.S = S_p[1];
  In.x_pc = x_pc;
  In.xvap = xvap;
  Out.P = P;
  Out.T = T;
  Out.F = F_p[1];
  Out.H = H_p[1];
  Out.S = S_p[1];
  Out.x_pc = x_pc;
  Out.xvap = xvap;
//=====================================================================================
//Mole Balance
  F_p[1] = F_p[2] + F_p[3];
//  x_pc[1, :] .* F_p[1] = x_pc[2, :] .* F_p[2] + x_pc[3, :] .* F_p[3];
//component molar and mass flows
  for i in 1:Nc loop
    F_pc[:, i] = x_pc[:, i] .* F_p[:];
  end for;
  if P >= Pbubl then
//below bubble point region
    xm_pc[3, :] = zeros(Nc);
    Fm_pc[1, :] = xm_pc[1, :] .* Fm_p[1];
    xm_pc[2, :] = xm_pc[1, :];
  elseif P >= Pdew then
    for i in 1:Nc loop
      Fm_pc[:, i] = xm_pc[:, i] .* Fm_p[:];
    end for;
  else
//above dew point region
    xm_pc[2, :] = zeros(Nc);
    Fm_pc[1, :] = xm_pc[1, :] .* Fm_p[1];
    xm_pc[3, :] = xm_pc[1, :];
  end if;
//phase molar and mass fractions
  xliq = F_p[2] / F_p[1];
  xvap = F_p[3] / F_p[1];
  xmliq = Fm_p[2] / Fm_p[1];
  xmvap = Fm_p[3] / Fm_p[1];
//Conversion between mole and mass flow
  for i in 1:Nc loop
    Fm_pc[:, i] = F_pc[:, i] * C[i].MW;
  end for;
  Fm_p[:] = F_p[:] .* MW_p[:];
//Energy Balance
  for i in 1:Nc loop
//Specific Heat and Enthalpy calculation
    Cp_pc[2, i] = ThermodynamicFunctions.LiqCpId(C[i].LiqCp, T);
    Cp_pc[3, i] = ThermodynamicFunctions.VapCpId(C[i].VapCp, T);
    H_pc[2, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    H_pc[3, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    (S_pc[2, i], S_pc[3, i]) = ThermodynamicFunctions.SId(C[i].VapCp, C[i].HOV, C[i].Tb, C[i].Tc, T, P, x_pc[2, i], x_pc[3, i]);
  end for;
  for i in 2:3 loop
    Cp_p[i] = sum(x_pc[i, :] .* Cp_pc[i, :]) + Cpres_p[i];
    H_p[i] = sum(x_pc[i, :] .* H_pc[i, :]) + Hres_p[i];
    S_p[i] = sum(x_pc[i, :] .* S_pc[i, :]) + Sres_p[i];
  end for;
  Cp_p[1] = xliq * Cp_p[2] + xvap * Cp_p[3];
  Cp_pc[1, :] = x_pc[1, :] .* Cp_p[1];
  H_p[1] = xliq * H_p[2] + xvap * H_p[3];
  H_pc[1, :] = x_pc[1, :] .* H_p[1];
  S_p[1] = xliq * S_p[2] + xvap * S_p[3];
  S_pc[1, :] = x_pc[1, :] * S_p[1];
//Bubble point calculation
  Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
//Dew point calculation
  Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
  if P >= Pbubl then
//below bubble point region
    x_pc[3, :] = zeros(Nc);
//    sum(x_pc[2, :]) = 1;
    F_p[3] = 0;
    x_pc[2,:] = x_pc[1,:];
  elseif P >= Pdew then
//VLE region
    for i in 1:Nc loop
      x_pc[3, i] = K_c[i] * x_pc[2, i];
      x_pc[2, i] = x_pc[1, i] ./ (1 + xvap * (K_c[i] - 1));
    end for;
    sum(x_pc[3, :]) = 1;
//sum y = 1
  else
//above dew point region
    x_pc[2, :] = zeros(Nc);
//    sum(x_pc[3, :]) = 1;
    F_p[2] = 0;
    x_pc[3, :] = x_pc[1, :];
  end if;
algorithm
  for i in 1:Nc loop
    MW_p[:] := MW_p[:] + C[i].MW * x_pc[:, i];
  end for;

end MaterialStream;

