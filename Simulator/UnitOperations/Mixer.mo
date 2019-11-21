within Simulator.UnitOperations;

model Mixer
  extends Simulator.Files.Icons.Mixer;
  import Simulator.Files.*;
  parameter Integer Nc "Number of Components", NI = 6 "Number of Input streams";
  parameter ChemsepDatabase.GeneralProperties C[Nc];
  parameter String outPress;
  Real Pout(min = 0, start = 101325), Pin[NI](min = 0, start = 101325);
  Real xin_sc[NI, Nc](each start = 1 / (Nc + 1), each min = 0, each max = 1) "Input stream component mol fraction", Fin_s[NI](each min = 0, each start = 100) "Input stream Molar Flow";
  Real xout_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Output Stream component mol fraction", Fout(each min = 0, each start = 100) "Output stream Molar Flow";
  Real Hin_s[NI] "Inlet molar enthalpy of each stream", Hout "Outlet molar enthalpy";
  Real Tin_s[NI](each min = 0, each start = 273.15) "Temperature of each stream", Tout(each min = 0, each start = 273.15) "Temperature of outlet stream", Sin_s[NI] "Inlet molar enthalpy of each stream", Sout "Outlet molar entropy", Bin_s[NI](each min = 0, each max = 1, each start = 0.5) "Inlet vapor phase mol fraction", Bout(min = 0, max = 1, start = 0.5) "Outlet vapor phase mol fraction";
  //================================================================================
  //  Files.Interfaces.matConn inlet[NI](each Nc = Nc);
  Simulator.Files.Interfaces.matConn outlet(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn inlet[NI](each Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Connector equation
  for i in 1:NI loop
    inlet[i].P = Pin[i];
    inlet[i].T = Tin_s[i];
    inlet[i].F = Fin_s[i];
    inlet[i].H = Hin_s[i];
    inlet[i].S = Sin_s[i];
    inlet[i].x_pc[1, :] = xin_sc[i, :];
    inlet[i].xvap = Bin_s[i];
  end for;
  outlet.P = Pout;
  outlet.T = Tout;
  outlet.F = Fout;
  outlet.H = Hout;
  outlet.S = Sout;
  outlet.x_pc[1, :] = xout_c[:];
  outlet.xvap = Bout;
//===================================================================================
//Output Pressure
  if outPress == "Inlet_Minimum" then
    Pout = min(Pin);
  elseif outPress == "Inlet_Average" then
    Pout = sum(Pin) / NI;
  elseif outPress == "Inlet_Maximum" then
    Pout = max(Pin);
  end if;
//Molar Balance
  Fout = sum(Fin_s[:]);
  for i in 1:Nc loop
    xout_c[i] * Fout = sum(xin_sc[:, i] .* Fin_s[:]);
  end for;
//Energy balance
  Hout = sum(Hin_s[:] .* Fin_s[:] / Fout);
end Mixer;

