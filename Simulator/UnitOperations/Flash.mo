within Simulator.UnitOperations;

model Flash "Model of a flash column to separate vapor and liquid phases from a mixed phase material stream"
  //==============================================================================
  //Header Files and Parameters
  extends Simulator.Files.Icons.Flash;
  import Simulator.Files.*;
  parameter ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Flash Specifications", group = "Component Parameters"));
  parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Flash Specifications", group = "Component Parameters"));
  parameter Boolean BTdef = false "True if flash is operated at temperature other than feed temp else false" annotation(
    Dialog(tab = "Flash Specifications", group = "Calculation Parameters"));
  parameter Boolean BPdef = false "True if flash is operated at pressure other than feed pressure else false" annotation(
    Dialog(tab = "Flash Specifications", group = "Calculation Parameters"));
  parameter Real Tdef(unit = "K") = 298.15 "Separation temperature if BTdef is true" annotation(
    Dialog(tab = "Flash Specifications", group = "Calculation Parameters"));
  parameter Real Pdef(unit = "Pa") = 101325 "Separation pressure if BPdef is true" annotation(
    Dialog(tab = "Flash Specifications", group = "Calculation Parameters"));
  //==============================================================================
  //Model Variables
  Real T(unit = "K", start = Tg, min = 0) "Flash column temperature";
  Real P(unit = "Pa", start = Pg, min = 0) "Flash column pressure";
  Real Pbubl(unit = "Pa", min = 0, start = Pmin) "Bubble point pressure";
  Real Pdew(unit = "Pa", min = 0, start = Pmax) "Dew point pressure";
  Real F_p[3](each unit = "mol/s", each min = 0,start = {Fg,Fliqg,Fvapg})"Feed stream mole flow";
  Real x_pc[3, Nc](each unit = "-", each min = 0, each max = 1, start={xguess,xg,yg}) "Component mole fraction";
  Real Cp_pc[3, Nc](each unit = "kJ/[kmol.K]") "Component molar specific heat";
  Real H_pc[3, Nc](each unit = "kJ/kmol") "Comopent molar enthalpy";
  Real S_pc[3, Nc](each unit = "kJ/[kmol.K]") "Component molar entropy";
  Real Cp_p[3](each unit = "kJ/[kmol.K]") "Molar specific heat in phase";
  Real H_p[3](each unit = "kJ/kmol") "Molar enthalpy in phase";
  Real S_p[3](each unit = "kJ/[kmol.K]") "Molar entropy in phase";
  Real xliq(unit = "-", min = 0, max = 1, start = xliqg)"Liquid phase mole fraction";
  Real xvap(unit = "-", min = 0, max = 1, start = xvapg) "Vapor phase mole fraction";
  //===============================================================================
  //Instantiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out1(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {102, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out2(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
  
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
    __OpenModelica_commandLineOptions = "",
  Documentation(info = "<html><head></head><body>The <b>Flash</b> column is used to calculate the vapor and liquid phase distribution for a mixed phase material stream.<div><br></div><div><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The flash column model have three Material Stream connection ports as:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">a feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">two outlet streams as vapor and liquid</span></li></ol></div></div><div><br></div><div>Following calculation parameters may be provided for the flash column:</div><div><ol><li>Boolean for Separation Temperature (<b>BTdef</b>)</li><li>Boolean for Separation Pressure (<b>BPdef</b>)</li><li>Separation Temperature (<b>Tdef</b>)</li><li>Separation Pressure (<b>Pdef</b>)</li></ol><div>The first two variables (<b>BTdef</b> and <b>BPdef</b>) are of type boolean to indicate if the flash is operated at temperature and pressure other than the temperature and pressure at which feed stream is entering. If so, the variables are to be entered as <b>True</b> else can be left to be blank to take the default value as False.</div><div><br></div><div>The other two variables (<b>Tdef</b> and <b>Pdef</b>) are of type <i>parameter Real</i> and are to be specified only if the corresponding boolean variables, <b>BTdef</b> and <b>BPdef</b> respectively<b>,</b>&nbsp;are <b>True</b>. In some cases, any one of the boolean variables can be True only and therefore its value at corresponding variable needs to specified.</div><div><br></div><div>In case either both or any one of the boolean variables among BTdef and BPdef are defined as True and its corresponding value at Tdef and Pdef are not specified, the flash will be operated at temperature of 298.15 K and pressure of 101325 Pa.</div><div><br></div><div><span style=\"font-size: 12px;\">During simulation, their values can be specified directly under&nbsp;</span><b style=\"font-size: 12px;\">Flash Specifications&nbsp;</b><span style=\"font-size: 12px;\">by double clicking on the flash model instance.</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><br></div></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Flash, go to&nbsp;</span><a href=\"modelica://Simulator.Examples.Flash\" style=\"font-size: 12px;\">Flash Example</a><span style=\"font-size: 12px;\">.</span></div></div></body></html>"));
  end Flash;
