within Simulator.UnitOperations;

model Cooler "Model of a cooler to heat a material stream"
  extends Simulator.Files.Icons.Cooler; 
  
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
    parameter Integer Nc "number of components";
  //====================================================================================
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Pin(unit = "Pa", min = 0, start =Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Hin(unit = "kJ/kmol") "Inlet stream molar enthalpy";
  Real Sin(unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mole fraction";
  
  Real Q(unit = "W") "Heat removed";
  Real Tdel(unit = "K") "Temperature drop";
   
  Real Fout(unit = "mol/s", min = 0, start = Fg) "Outlet stream molar flow rate";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";
  Real Hout(unit = "kJ/kmol") "Outlet stream molar enthalpy";
  Real Sout(unit = "kJ/[kmol.K]") "Outlet stream molar entropy"; 
  Real x_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Component mole fraction";
  //========================================================================================
  parameter Real Pdel(unit = "Pa") "Pressure drop";
  parameter Real Eff(unit = "-") "Efficiency";

  //========================================================================================
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  Hin - Eff * Q / Fin = Hout;
//energy balance
  Pin - Pdel = Pout;
//pressure calculation
  Tin - Tdel = Tout;
//temperature calculation
annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">The cooler is used to simulate the cooling process of a material stream.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Following calculation parameters must be provided to the cooler:</div><div style=\"font-size: 12px;\"><ol><li>Pressure Drop</li><li>Efficiency</li></ol><div>In addition to the above parameters, any one additional variable from the below list must be provided for the model to simulate successfully:</div><div><ol><li>Outlet Temperature (Tout)</li><li>Temperature Drop (Tdel)</li><li>Heat Removed (Q)</li><li>Outlet Stream Vapor Phase Mole Fraction (xvapout)</li></ol><div><br></div></div><div>For example on simulating a cooler, go to <b><i>Examples</i></b> &gt;&gt; <i><b>Cooler</b></i></div></div></body></html>"));
    
    end Cooler;
