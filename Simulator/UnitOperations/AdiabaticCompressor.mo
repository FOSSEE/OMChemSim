within Simulator.UnitOperations;

model AdiabaticCompressor "Model of an adiabatic compressor to provide energy to vapor stream in form of pressure"
  extends Simulator.Files.Icons.AdiabaticCompressor;
  
  extends Simulator.Files.Models.Flash;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Compressor Specifications", group = "Component Parameters"));
  parameter Integer Nc "number of components" annotation(
    Dialog(tab = "Compressor Specifications", group = "Component Parameters"));

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
 
  parameter Real Eff(unit = "-") "Efficiency" annotation(
    Dialog(tab = "Compressor Specifications", group = "Calculation Parameters"));

//========================================================================================
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
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
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">The <b>Adiabatic Compressor</b> is generally used to provide energy to a vapor material stream. The energy supplied is in form of pressure.</div><div style=\"font-size: 12px;\"><div><br></div><div><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The adiabatic compressor model have following connection ports:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">power required</span></font></li></ul></ol></div></div></div><div><br></div><div><br></div>To simulate an adiabatic compressor, Efficiency (<b>Eff</b>) of the compressor should be provided as calculation parameter. The variable&nbsp;<b>Eff</b>&nbsp;is defined as of type&nbsp;<i>parameter Real.</i>&nbsp;</div><div style=\"font-size: 12px;\"><span style=\"font-size: medium;\">During simulation, its value can specified directly under&nbsp;</span><b style=\"font-size: medium;\">Compressor Specifications</b><span style=\"font-size: medium;\">&nbsp;by double clicking on the compressor model instance.</span><br><div><br></div><div><br></div><div>Additionally one of the following input variables must be defined:<div><ol><li>Outlet Pressure (<b>Pout</b>)</li><li>Pressure Increase (<b>Pdel</b>)</li><li>Power Required (<b>Q</b>)</li></ol><div>These variables are declared of type&nbsp;<i>Real.</i></div><div>During simulation, value of one of these variables need to be defined in the equation section.</div></div><div><br></div><div>For detailed explaination on how to use this model to simulate an Adiabatic Compressor, go to&nbsp;<a href=\"modelica://Simulator.Examples.Compressor\">Adiabatic Compressor Example</a>.</div></div></div></body></html>"));
    end AdiabaticCompressor;
