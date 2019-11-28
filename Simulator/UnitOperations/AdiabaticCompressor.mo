within Simulator.UnitOperations;

model AdiabaticCompressor "Model of an adiabatic compressor to provide energy to vapor stream in form of pressure"
  extends Simulator.Files.Icons.AdiabaticCompressor;
  
  extends Simulator.Files.Models.Flash;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc "number of components";

  //====================================================================================
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure"; 
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy";
  Real Sin(unit = "kJ/[kmol/K]") "Inlet stream molar entropy";
  Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mol fraction";   
  
  Real Fout(min = 0, start = Fg) "Outlet stream molar flow rate";
  Real Q(unit = "W") "Power required";
  Real Pdel(unit = "Pa") "Pressure increase"; 
  Real Tdel(unit = "K") "Temperature increase"; 

  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "Pa", min = 0, start = Tg) "Outlet stream temperature";
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real Sout(unit = "kJ/[kmol.K]") "Outlet stream molar entropy";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";
  Real x_c[Nc](each unit = "-", each min = 0, each max = 1,start=xg) "Component mole fraction";
 
  parameter Real Eff(unit = "-") "Efficiency";

  //========================================================================================
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
  
  extends GuessModels.InitialGuess;
  
equation
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = x_c[:];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = x_c[:];
  Out.xvap = xvapout;
  En.Q = Q;
//=============================================================================================
  Fin = Fout;
//material balance
  Hout = Hin + (H_p[1] - Hin) / Eff;
  Q = Fin * (H_p[1] - Hin) / Eff;
//energy balance
  Pin + Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
//=========================================================================
//ideal flash
  Fin = F_p[1];
  Pout = P;
  Sin = S_p[1];
  x_c[:] = x_pc[1, :];
annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Adiabatic Compressor is generally used to provide energy to a vapor material stream. The energy supplied is in form of pressure.</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">To simulate an adiabatic compressor, Efficiency of the compressor should be provided as calculation parameter. Additionally, one of the following variables must be defined:</span><div style=\"font-size: 12px;\"><ol><li>Outlet Pressure</li><li>Pressure Increase</li><li>Power Required</li></ol><div><br></div></div><div style=\"font-size: 12px;\">For example on simulating an adiabatic compressor, go to&nbsp;<i><b>Examples</b></i>&nbsp;&gt;&gt; <b><i>Compressor</i></b></div></body></html>"));
    end AdiabaticCompressor;
