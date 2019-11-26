within Simulator.UnitOperations;

model Valve "Model of a valve to regulate the pressure of a material stream"
  extends Simulator.Files.Icons.Valve;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
    parameter Integer Nc = 3 "Number of components";
  //====================================================================================
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure"; 
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream emperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy"; 
  Real Sin(unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mole fraction"; 
  
  Real Tdel(unit = "K") "Temperature increase";
  Real Pdel(unit = "Pa") "Pressure drop"; 
 
  Real Fout(unit = "mol/s", min = 0, start = Fg) "outlet stream molar flow rate";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real Sout(unit = "kJ/[kmol.K]")  "Outlet stream molar entropy";
  Real x_c[Nc](each unit = "-", each min = 0, each max = 1,  start = xg) "Component mole fraction";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";
  //========================================================================================

  //========================================================================================
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
//=============================================================================================
  Fin = Fout;
//material balance
  Hin = Hout;
//energy balance
  Pin - Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">The valve is used to simulate the pressure manipulation process of a material stream.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">To simulate a valve, one of the following calculation parameter must be provided:</div><div style=\"font-size: 12px;\"><div><ol><li>Outlet Pressure (Pout)</li><li>Pressure Drop (Pdel)</li></ol><div><br></div></div><div>For example on simulating a valve, go to&nbsp;<b><i>Examples</i></b>&nbsp;&gt;&gt; <b><i>Valve</i></b></div></div></body></html>"));
    
    end Valve;
