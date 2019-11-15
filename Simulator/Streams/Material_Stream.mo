within Simulator.Streams;

model MaterialStream
  //1 -  Mixture, 2 - Liquid phase, 3 - Gas Phase
//  extends Modelica.Icons.SourcesPackage;
  extends Simulator.Files.Icons.Material_Stream;
  import Simulator.Files.*;
  parameter Integer Nc;
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  Real P(min = 0, start = 101325) "Pressure", T(start = 273) "Temperature";
  Real Pbubl(min = 0, start = sum(C[:].Pc) / Nc) "Bubble point pressure", Pdew(min = 0, start = sum(C[:].Pc) / Nc) "dew point pressure";
  Real xliq(start = 0.5, min = 0, max = 1) "Liquid Phase mole fraction", xvap(start = 0.5, min = 0, max = 1) "Vapor Phase mole fraction", xmliq(start = 0.5, min = 0, max = 1) "Liquid Phase mass fraction", xmvap(start = 0.5, min = 0, max = 1) "Vapor Phase Mass fraction";
  Real F_p[3](each min = 0, each start = 100) "Total molar flow", Fm_p[3](each min = 0, each start = 100) "Total Mass Flow", MW_p[3](each start = 0, each min = 0) "Average Molecular weight of Phases";
  Real x_pc[3, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Component mole fraction", xm_pc[3, Nc](each start = 1 / (Nc + 1), each min = 0, each max = 1) "Component Mass fraction", F_pc[3, Nc](each start = 100, each min = 0) "Component Molar flow", Fm_pc[3, Nc](each min = 0, each start = 100) "Component Mass Fraction";
  Real Cp_p[3] "phase Molar Specific Heat", Cp_pc[3, Nc] "Component Molar Specific Heat";
  Real H_p[3] "Phase Molar Enthalpy", H_pc[3, Nc] "Component Molar Enthalpy";
  Real S_p[3] "Phase Molar Entropy", S_pc[3, Nc] "Component Molar Entropy";
  Simulator.Files.Connection.matConn inlet(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Connector equations
  inlet.P = P;
  inlet.T = T;
  inlet.F = F_p[1];
  inlet.H = H_p[1];
  inlet.S = S_p[1];
  inlet.x_pc = x_pc;
  inlet.xvap = xvap;
  outlet.P = P;
  outlet.T = T;
  outlet.F = F_p[1];
  outlet.H = H_p[1];
  outlet.S = S_p[1];
  outlet.x_pc = x_pc;
  outlet.xvap = xvap;
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
    Cp_pc[2, i] = Thermodynamic_Functions.LiqCpId(C[i].LiqCp, T);
    Cp_pc[3, i] = Thermodynamic_Functions.VapCpId(C[i].VapCp, T);
    H_pc[2, i] = Thermodynamic_Functions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    H_pc[3, i] = Thermodynamic_Functions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    (S_pc[2, i], S_pc[3, i]) = Thermodynamic_Functions.SId(C[i].VapCp, C[i].HOV, C[i].Tb, C[i].Tc, T, P, x_pc[2, i], x_pc[3, i]);
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

