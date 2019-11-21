within Simulator.UnitOperations;
model AdiabaticExpander
//=====================================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.AdiabaticExpander;
  extends Simulator.Files.Models.Flash;
 parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc "Number of Components";
  parameter Real Eff "Efficiency";
//====================================================================================
//Model Variables
  Real Fin(min = 0, start = 100) "Inlet mixture molar flow rate";
  Real Tin(min = 0, start = 273.15) "Inlet Temperature"; 
  Real Hin "Inlet mixture molar enthalpy";
  Real xvapin(min = 0, max = 1, start = 0.5) "In vapor mol fraction";
  Real xin_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction";
  Real Sin "Inlet mixture molar entropy"; 
  Real Pin(min = 0, start = 101325) "Inlet pressure"; 
  

  Real Q "Generated Power";
  Real Pdel "Pressure Drop"; 
  Real Tdel "Temperature increase";

  Real Pout(min = 0, start = 101325) "Outlet pressure";
  Real Fout(min = 0, start = 100) "Outlet mixture molar flow rate";
  Real Tout(min = 0, start = 273.15) "Outlet Temperature";
  Real Hout "Outlet mixture molar enthalpy";
  Real Sout "Outlet mixture molar entropy";
  Real xvapout(min = 0, max = 1, start = 0.5) "Out Vapor Mole fraction";
 
//========================================================================================
//Instantiation of connectors
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
//========================================================================================
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = xin_c[:];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = xin_c[:];
  Out.xvap = xvapout;
  En.Q = Q;
//=============================================================================================
//Material and Energy balance 
  Fin = Fout;
  Hout = Hin + (H_p[1] - Hin) * Eff;
  Q = Fin * (H_p[1] - Hin) * Eff;
//=============================================================================================
//Pressure and Temperature calculation
  Pin - Pdel = Pout;
  Tin - Tdel = Tout;
  
//=========================================================================
//Ideal flash
  Fin = F_p[1];
  Pout = P;
  Sin = S_p[1];
  xin_c[:] = x_pc[1, :];
end AdiabaticExpander;
