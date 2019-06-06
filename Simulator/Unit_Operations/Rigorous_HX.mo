within Simulator.Unit_Operations;

model Rigorous_HX
  //Heat-Exchanger Operates in various modes
  //Mode-I - Estimation of Hot Fluid Outlet Temperature
  //      Inputs : deltap_hot,deltap_cold,Heat_Loss,coutT,Flow Direction,Name of the calculation type,Area
  //Mode-II - Estimation of Cold Fluid Outlet Temperature
  //      Inputs : deltap_hot,deltap_cold,Heat_Loss,houtT,Flow Direction,Name of the calculation type,Area
  //Mode-III - Estimation of Both the fluid outlet temperature
  //      Inputs : deltap_hot,deltap_cold,Heat_Loss,Qactual,Flow Direction,Name of the calculation type,Area
  //Mode-IV - Estimation of both the fluid outlet temperature-NTU Method
  //      Inputs : deltap_hot,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type,Area
  //Mode-V-Estimation of Heat Transfer Area
  //      Inputs : deltap_hot,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type
  //Mode-VI-Estimation of all parameters given the heat transfer efficiency
  //      Inputs : deltap_hot,deltap_cold,Heat_Loss,U,Efficiency,Flow Direction,Name of the calculation type
  import Simulator.Files.*;
  import Simulator.Files.Thermodynamic_Functions.*;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  parameter Integer NOC "number of compounds ";
  Simulator.Files.Connection.matConn Hot_In(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-74, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-74, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Hot_Out(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {80, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Cold_In(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-74, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-74, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Cold_Out(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {76, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {76, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Parameters
  //Mode-I -Outlet Temperature-Hot Stream Calculaions
  parameter Real Heat_Loss;
  parameter Real deltap_hot;
  parameter Real deltap_cold;
  parameter String Mode;
  parameter String Calculation_Method;
  //Variables
  //Hot Stream Inlet
  Real hinP, hinT, hintotMolFlow[1], hinEnth, hinEntr, hincompMolFrac[2, NOC], hinVapfrac;
  //Hot Stream Outlet
  Real houtP, houtT, houttotMolFlow[1], houtEnth, houtEntr, houtcompMolFrac[2, NOC], houtVapfrac;
  //Cold Stream Inlet
  Real cinP, cinT, cintotMolFlow[1], cinEnth, cinEntr, cincompMolFrac[2, NOC], cinVapfrac;
  //Cold Stream Outlet
  Real coutP, coutT, couttT, couttotMolFlow[1], coutEnth, coutEntr, coutcompMolFrac[2, NOC], coutVapfrac;
  Real Qactual(start = 2000) "Actual Heat Load";
  Real Qmax, Qmax_hot, Qmax_cold;
  //Hot Stream Enthalpy at Cold Stream Inlet Temperature
  Real hinCompMolEnth[2, NOC];
  Real hinPhasMolEnth[3];
  //Cold Stream Enthalpy at Hot Stream Inlet Temperature
  Real cinCompMolEnth[2, NOC];
  Real cinPhasMolEnth[3];
  Real deltaH;
  //Heat Exchanger Effeciency
  Real Efficiency;
  //LMTD
  Real delta_T1(start = 20), delta_T2(start = 10);
  Real LMTD "Log Mean Temperature Difference";
  //Global Heat Transfer Coefficient
  Real U;
  //Heat Transfer Area
  Real Area;
  //==================================================================================================================
  //Mode-4-NTU Method-when both the outlet temperatures are unknown
  //Heat Capacity Rate for hot and cold fluid
  Real C_cold, C_hot;
  //Number of Transfer Units for Hot Side and Cold Side
  Real NTU_cold, NTU_hot;
  //Heat Capacity Ratio for hot and cold side
  Real R_cold, R_hot;
  //Effectiveness Factor
  Real Eff_cold, Eff_hot;
equation
//Hot Stream Inlet
  Hot_In.P = hinP;
  Hot_In.T = hinT;
  Hot_In.mixMolFlo = hintotMolFlow[1];
  Hot_In.mixMolEnth = hinEnth;
  Hot_In.mixMolEntr = hinEntr;
  Hot_In.mixMolFrac[1, :] = hincompMolFrac[1, :];
  Hot_In.mixMolFrac[2, :] = hincompMolFrac[2, :];
  Hot_In.vapPhasMolFrac = hinVapfrac;
//Hot Stream Outlet
  Hot_Out.P = houtP;
  Hot_Out.T = houtT;
  Hot_Out.mixMolFlo = houttotMolFlow[1];
  Hot_Out.mixMolEnth = houtEnth;
  Hot_Out.mixMolEntr = houtEntr;
  Hot_Out.mixMolFrac[1, :] = houtcompMolFrac[1, :];
  Hot_Out.mixMolFrac[2, :] = houtcompMolFrac[2, :];
  Hot_Out.vapPhasMolFrac = houtVapfrac;
//Cold Stream In
  Cold_In.P = cinP;
  Cold_In.T = cinT;
  Cold_In.mixMolFlo = cintotMolFlow[1];
  Cold_In.mixMolEnth = cinEnth;
  Cold_In.mixMolEntr = cinEntr;
  Cold_In.mixMolFrac[1, :] = cincompMolFrac[1, :];
  Cold_In.mixMolFrac[2, :] = cincompMolFrac[2, :];
  Cold_In.vapPhasMolFrac = cinVapfrac;
//Cold Stream Out
  Cold_Out.P = coutP;
  Cold_Out.T = couttT;
  Cold_Out.mixMolFlo = couttotMolFlow[1];
  Cold_Out.mixMolEnth = coutEnth;
  Cold_Out.mixMolEntr = coutEntr;
  Cold_Out.mixMolFrac[1, :] = coutcompMolFrac[1, :];
  Cold_Out.mixMolFrac[2, :] = coutcompMolFrac[2, :];
  Cold_Out.vapPhasMolFrac = coutVapfrac;
equation
  hintotMolFlow[1] = houttotMolFlow[1];
  cintotMolFlow[1] = couttotMolFlow[1];
  hincompMolFrac[1] = houtcompMolFrac[1];
  cincompMolFrac[1] = coutcompMolFrac[1];
  houtP = hinP - deltap_hot;
  coutP = cinP - deltap_cold;
  Qactual = cintotMolFlow[1] * (coutEnth - cinEnth);
  deltaH = -(Qactual + Heat_Loss * 1000) / hintotMolFlow[1];
  if Calculation_Method == "BothOutletTemp(UA" then
    houtEnth = hinEnth - Qactual / hintotMolFlow[1] - Heat_Loss * 1000 / hintotMolFlow[1];
    coutT = cinT + Eff_cold * (hinT - cinT);
  else
    coutT = couttT;
    houtEnth = hinEnth + deltaH;
  end if;
//==========================================================================================================
//Calculation of Hot Stream Enthalpy at  Cold Stream Inlet Temperature
  for i in 1:NOC loop
    hinCompMolEnth[1, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, cinT);
    hinCompMolEnth[2, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, cinT);
  end for;
  for i in 1:2 loop
    hinPhasMolEnth[i] = sum(hincompMolFrac[i, :] .* hinCompMolEnth[i, :]);
/*+ inResMolEnth[2, i]*/
  end for;
  hinPhasMolEnth[3] = (1 - hinVapfrac) * hinPhasMolEnth[1] + hinVapfrac * hinPhasMolEnth[2];
//Maximum Theoritical Heat Exchange-Hot Fluid
  Qmax_hot = hintotMolFlow[1] * (hinEnth - hinPhasMolEnth[3]);
//===========================================================================================================
//Enthalpy of Cold Stream Enthalpy at Hot Fluid Inlet Temperature
  for i in 1:NOC loop
    cinCompMolEnth[1, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, hinT);
    cinCompMolEnth[2, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, hinT);
  end for;
  for i in 1:2 loop
    cinPhasMolEnth[i] = sum(cincompMolFrac[i, :] .* cinCompMolEnth[i, :]);
/*+ inResMolEnth[1, i]*/
  end for;
  cinPhasMolEnth[3] = (1 - cinVapfrac) * cinPhasMolEnth[1] + cinVapfrac * cinPhasMolEnth[2];
//Maximum Theoritical Heat Exchange- Cold Fluid
  Qmax_cold = cintotMolFlow[1] * abs(cinEnth - cinPhasMolEnth[3]);
//Maximum Heat Exchange
  Qmax = min(Qmax_hot, Qmax_cold);
  Efficiency = (Qactual - Heat_Loss * 1000) / Qmax * 100;
//Log Mean Temperature Difference
  if Mode == "Parallal" then
    delta_T1 = hinT - cinT;
    delta_T2 = houtT - coutT;
  else
    delta_T1 = hinT - coutT;
    delta_T2 = houtT - cinT;
  end if;
  if delta_T1 <= 0 or delta_T2 <= 0 then
    LMTD = 1;
  else
    LMTD = (delta_T1 - delta_T2) / log(delta_T1 / delta_T2);
  end if;
  U = Qactual / (Area * LMTD);
//===========================================================================================================
//==========================================================================================================
//NTU-Method
  C_cold = cintotMolFlow[1] * ((coutEnth - cinEnth) / (coutT - cinT));
  C_hot = hintotMolFlow[1] * ((houtEnth - hinEnth) / (houtT - hinT));
//Number of Transfer Units
  NTU_cold = U * Area / C_cold;
  NTU_hot = U * Area / C_hot;
//Heat Capacity Ratio for Hot and Cold Side
  R_cold = C_cold / C_hot;
  R_hot = C_hot / C_cold;
  if Mode == "Parallal" then
    Eff_cold = (1 - exp(-NTU_cold * (1 + R_cold))) / (1 + R_cold);
    Eff_hot = (1 - exp(-NTU_hot * (1 + R_hot))) / (1 + R_hot);
  else
    Eff_cold = (1 - exp((R_cold - 1) * NTU_cold)) / (1 - R_cold * exp((R_cold - 1) * NTU_cold));
    Eff_hot = (1 - exp((R_hot - 1) * NTU_hot)) / (1 - R_hot * exp((R_hot - 1) * NTU_hot));
  end if;
end Rigorous_HX;
