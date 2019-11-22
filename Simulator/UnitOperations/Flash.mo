within Simulator.UnitOperations;

model Flash
//==============================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.Flash;
  import Simulator.Files.*;
  parameter ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc;
  parameter Boolean BTdef = false, BPdef = false;
  parameter Real Tdef = 298.15 "Default Temperature", Pdef = 101325 "Default Pressure";
  
//==============================================================================
//Model Variables
  Real T(start = 298.15, min = 0) "Flash Temperature";
  Real P(start = 101325, min = 0) "Flash Pressure";
  Real Pbubl(min = 0, start = sum(C[:].Pc) / Nc) "Bubble point pressure";
  Real Pdew(min = 0, start = sum(C[:].Pc) / Nc) "dew point pressure";
  Real F_p[3](each min = 0, each start = 100)"Mole Flow";
  Real x_pc[3, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Component Mole Fraction";
  Real Cp_pc[3, Nc]"Component Molar Specific Heat";
  Real H_pc[3, Nc]"Comopent Molar Enthalpy";
  Real S_pc[3, Nc]"Component Molar Entropy";
  Real Cp_p[3]"Phase Molar Specific Heat";
  Real H_p[3]"Phase Mole Enthalpy";
  Real S_p[3]"Phase Mole Entropy";
  Real xliq(min = 0, max = 1, start = 0.5)"Liqiud Fraction";
  Real xvap(min = 0, max = 1, start = 0.5) "Vapor Fraction";
  
//===============================================================================
//Instantiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out1(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {102, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out2(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
//================================================================================
//Connector equation
  if BTdef then
    Tdef = T;
  else
    In.T = T;
  end if;
  if BPdef then
    Pdef = P;
  else
    In.P = P;
  end if;
  In.F = F_p[1];
  In.x_pc[1, :] = x_pc[1, :];
  Out2.T = T;
  Out2.P = P;
  Out2.F = F_p[2];
  Out2.x_pc[1, :] = x_pc[2, :];
  Out1.T = T;
  Out1.P = P;
  Out1.F = F_p[3];
  Out1.x_pc[1, :] = x_pc[3, :];
  
//=================================================================================
//Mole Balance
  F_p[1] = F_p[2] + F_p[3];
  x_pc[1, :] .* F_p[1] = x_pc[2, :] .* F_p[2] + x_pc[3, :] .* F_p[3];
  
//==================================================================================
//Bubble point calculation
  Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
  
//==================================================================================
//Dew point calculation
  Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
  if P >= Pbubl then
    x_pc[3, :] = zeros(Nc);
    F_p[3] = 0;
  elseif P >= Pdew then
//===================================================================================
//VLE region
    for i in 1:Nc loop
      x_pc[2, i] = x_pc[1, i] ./ (1 + xvap * (K_c[i] - 1));
    end for;
    sum(x_pc[2, :]) = 1;
  else
//==================================================================================
//above dew point region
    x_pc[2, :] = zeros(Nc);
    F_p[2] = 0;
  end if;
//===================================================================================
//Energy Balance / Specific Heat and Enthalpy calculation from Thermodynamic Functions
   for i in 1:Nc loop
    Cp_pc[2, i] = ThermodynamicFunctions.LiqCpId(C[i].LiqCp, T);
    Cp_pc[3, i] = ThermodynamicFunctions.VapCpId(C[i].VapCp, T);
    H_pc[2, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    H_pc[3, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    (S_pc[2, i], S_pc[3, i]) = ThermodynamicFunctions.SId(C[i].VapCp, C[i].HOV, C[i].Tb, C[i].Tc, T, P, x_pc[2, i], x_pc[3, i]);
  end for;
//=======================================================================================
//Specific Heat and Enthalpy calculation for Liquid and Vapor Phase
  for i in 2:3 loop
    Cp_p[i] = sum(x_pc[i, :] .* Cp_pc[i, :]) + Cpres_p[i];
    H_p[i] = sum(x_pc[i, :] .* H_pc[i, :]) + Hres_p[i];
    S_p[i] = sum(x_pc[i, :] .* S_pc[i, :]) + Sres_p[i];
  end for;
//========================================================================================
//Specific Heat and Enthalpy calculation for Mixture Phase
  Cp_p[1] = xliq * Cp_p[2] + xvap * Cp_p[3];
  Cp_pc[1, :] = x_pc[1, :] .* Cp_p[1];
  H_p[1] = xliq * H_p[2] + xvap * H_p[3];
  H_pc[1, :] = x_pc[1, :] .* H_p[1];
  S_p[1] = xliq * S_p[2] + xvap * S_p[3];
  S_pc[1, :] = x_pc[1, :] * S_p[1];
  
//=======================================================================================
//phase molar fractions
  xliq = F_p[2] / F_p[1];
  xvap = F_p[3] / F_p[1];
annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    __OpenModelica_commandLineOptions = "");end Flash;

