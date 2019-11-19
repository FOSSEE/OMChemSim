within Simulator.UnitOperations;

model HeatExchanger
  extends Simulator.Files.Icons.HeatExchanger;
  //Heat-Exchanger Operates in various modes
  //Mode-I - Estimation of Hot Fluid Outlet Temperature
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,Tcout,Flow Direction,Name of the calculation type,Area
  //Mode-II - Estimation of Cold Fluid Outlet Temperature
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,Thout,Flow Direction,Name of the calculation type,Area
  //Mode-III - Estimation of Both the fluid outlet temperature
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,Qact,Flow Direction,Name of the calculation type,Area
  //Mode-IV - Estimation of both the fluid outlet temperature-NTU Method
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type,Area
  //Mode-V-Estimation of Heat Transfer Area
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,U,Flow Direction,Name of the calculation type
  //Mode-VI-Estimation of all parameters given the heat transfer Eff
  //      Inputs : Pdelh,deltap_cold,Heat_Loss,U,Eff,Flow Direction,Name of the calculation type
  import Simulator.Files.*;
  import Simulator.Files.Thermodynamic_Functions.*;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc "number of compounds ";
  Simulator.Files.Connection.matConn In_Hot(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-74, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out_Hot(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {80, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn In_Cold(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-74, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out_Cold(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {76, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Parameters
  //Mode-I -Outlet Temperature-Hot Stream Calculaions
  parameter Real Qloss = 0;
  parameter Real Pdelh = 0;
  parameter Real Pdelc = 0;
  parameter String Mode"''CoCurrent'',''CounterCurrent''";
  parameter String Cmode"''BothOutletTemp(UA)''";
  //Variables
  //Hot Stream Inlet
  Real Phin, Thin, Fhin, Hhin, Shin, xhin_pc[2, Nc], xvaphin;
  //Hot Stream Outlet
  Real Phout, Thout, Fhout, Hhout, Shout, xhout_pc[2, Nc], xvaphout;
  //Cold Stream Inlet
  Real Pcin, Tcin, Fcin[1], Hcin, Scin, xcin_pc[2, Nc], xvapcin;
  //Cold Stream Outlet
  Real Pcout, Tcout, couttT, Fcout[1], Hcout, Scout, xcout_pc[2, Nc], xvapcout;
  Real Qact(start = 2000) "Actual Heat Load";
  Real Qmax, Qmaxh, Qmaxc;
  //Hot Stream Enthalpy at Cold Stream Inlet Temperature
  Real Hhin_pc[2, Nc];
  Real Hhin_p[3];
  //Cold Stream Enthalpy at Hot Stream Inlet Temperature
  Real Hcin_pc[2, Nc];
  Real Hcin_p[3];
  Real Hdel;
  //Heat Exchanger Effeciency
  Real Eff;
  //LMTD
  Real Tdel1(start = 20), Tdel2(start = 10);
  Real LMTD "Log Mean Temperature Difference";
  //Global Heat Transfer Coefficient
  Real U;
  //Heat Transfer A
  Real A;
  //==================================================================================================================
  //Mode-4-NTU Method-when both the outlet temperatures are unknown
  //Heat Capacity Rate for hot and cold fluid
  Real Cc, Ch;
  //Number of Transfer Units for Hot Side and Cold Side
  Real Ntuc, Ntuh;
  //Heat Capacity Ratio for hot and cold side
  Real Rc, Rh;
  //Effectiveness Factor
  Real Effc, Effh;
equation
//Hot Stream Inlet
  In_Hot.P = Phin;
  In_Hot.T = Thin;
  In_Hot.F = Fhin;
  In_Hot.H = Hhin;
  In_Hot.S = Shin;
  In_Hot.x_pc[1, :] = xhin_pc[1, :];
  In_Hot.x_pc[2, :] = xhin_pc[2, :];
  In_Hot.xvap = xvaphin;
//Hot Stream Outlet
  Out_Hot.P = Phout;
  Out_Hot.T = Thout;
  Out_Hot.F = Fhout;
  Out_Hot.H = Hhout;
  Out_Hot.S = Shout;
  Out_Hot.x_pc[1, :] = xhout_pc[1, :];
  Out_Hot.x_pc[2, :] = xhout_pc[2, :];
  Out_Hot.xvap = xvaphout;
//Cold Stream In
  In_Cold.P = Pcin;
  In_Cold.T = Tcin;
  In_Cold.F = Fcin[1];
  In_Cold.H = Hcin;
  In_Cold.S = Scin;
  In_Cold.x_pc[1, :] = xcin_pc[1, :];
  In_Cold.x_pc[2, :] = xcin_pc[2, :];
  In_Cold.xvap = xvapcin;
//Cold Stream Out
  Out_Cold.P = Pcout;
  Out_Cold.T = couttT;
  Out_Cold.F = Fcout[1];
  Out_Cold.H = Hcout;
  Out_Cold.S = Scout;
  Out_Cold.x_pc[1, :] = xcout_pc[1, :];
  Out_Cold.x_pc[2, :] = xcout_pc[2, :];
  Out_Cold.xvap = xvapcout;
equation
  Fhin = Fhout;
  Fcin[1] = Fcout[1];
  xhin_pc[1] = xhout_pc[1];
  xcin_pc[1] = xcout_pc[1];
  Phout = Phin - Pdelh;
  Pcout = Pcin - Pdelc;
  Qact = Fcin[1] * (Hcout - Hcin);
  Hdel = -(Qact + Qloss * 1000) / Fhin;
  if Cmode == "BothOutletTemp(UA)" then
    Hhout = Hhin - Qact / Fhin - Qloss * 1000 / Fhin;
    Tcout = Tcin + Effc * (Thin - Tcin);
  else
    Tcout = couttT;
    Hhout = Hhin + Hdel;
  end if;
//==========================================================================================================
//Calculation of Hot Stream Enthalpy at  Cold Stream Inlet Temperature
  for i in 1:Nc loop
    Hhin_pc[1, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Tcin);
    Hhin_pc[2, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Tcin);
  end for;
  for i in 1:2 loop
    Hhin_p[i] = sum(xhin_pc[i, :] .* Hhin_pc[i, :]);
/*+ inResMolEnth[2, i]*/
  end for;
  Hhin_p[3] = (1 - xvaphin) * Hhin_p[1] + xvaphin * Hhin_p[2];
//Maximum Theoritical Heat Exchange-Hot Fluid
  Qmaxh = Fhin * (Hhin - Hhin_p[3]);
//===========================================================================================================
//Enthalpy of Cold Stream Enthalpy at Hot Fluid Inlet Temperature
  for i in 1:Nc loop
    Hcin_pc[1, i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Thin);
    Hcin_pc[2, i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Thin);
  end for;
  for i in 1:2 loop
    Hcin_p[i] = sum(xcin_pc[i, :] .* Hcin_pc[i, :]);
/*+ inResMolEnth[1, i]*/
  end for;
  Hcin_p[3] = (1 - xvapcin) * Hcin_p[1] + xvapcin * Hcin_p[2];
//Maximum Theoritical Heat Exchange- Cold Fluid
  Qmaxc = Fcin[1] * abs(Hcin - Hcin_p[3]);
//Maximum Heat Exchange
  Qmax = min(Qmaxh, Qmaxc);
  Eff = (Qact - Qloss * 1000) / Qmax * 100;
//Log Mean Temperature Difference
  if(Mode=="CoCurrent") then
    Tdel1 =Thin-Tcin;
    Tdel2 =Thout-Tcout;  
  elseif Mode=="CounterCurrent" then
    Tdel1 =Thin-Tcout;
    Tdel2 =Thout-Tcin;
  end if;
  
  if Tdel1 <= 0 or Tdel2 <= 0 then
    LMTD = 1;
  else
    LMTD = (Tdel1 - Tdel2) / log(Tdel1 / Tdel2);
  end if;
  U = Qact / (A * LMTD);
//===========================================================================================================
//==========================================================================================================
//NTU-Method
  Cc = Fcin[1] * ((Hcout - Hcin) / (Tcout - Tcin));
  Ch = Fhin * ((Hhout - Hhin) / (Thout - Thin));
//Number of Transfer Units
  Ntuc = U * A / Cc;
  Ntuh = U * A / Ch;
//Heat Capacity Ratio for Hot and Cold Side
  Rc = Cc / Ch;
  Rh = Ch / Cc;
  if Mode=="CoCurrent" then
    Effc = (1- exp(-Ntuc * (1+Rc)))/(1+Rc);
    Effh =  (1- exp(-Ntuh * (1+Rh)))/(1+Rh);
  elseif Mode=="CounterCurrent" then
    Effc = (1-exp((Rc-1)*Ntuc))/(1 -Rc*  exp((Rc-1)*Ntuc));
    Effh =  (1-exp((Rh-1) *Ntuh ))/(1 -Rh *  exp((Rh-1)*Ntuh));
  end if;
end HeatExchanger;
