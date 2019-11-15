within Simulator.Unit_Operations;
model Adiabatic_Expander
//=====================================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.Adiabatic_Expander;
  extends Simulator.Files.Models.Flash;
  parameter Real Eff "Efficiency";
  parameter Integer Nc "Number of Components";
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  
//====================================================================================
//Model Variables
  Real Fin(min = 0, start = 100) "Inlet mixture molar flow rate", Fout(min = 0, start = 100) "Outlet mixture molar flow rate", Q "Generated Power", Pin(min = 0, start = 101325) "Inlet pressure", Pout(min = 0, start = 101325) "Outlet pressure", Pdel "Pressure Drop", Tin(min = 0, start = 273.15) "Inlet Temperature", Tout(min = 0, start = 273.15) "Outlet Temperature", Tdel "Temperature increase";
  Real Hin "Inlet mixture molar enthalpy", Hout "Outlet mixture molar enthalpy", Sin "Inlet mixture molar entropy", Sout "Outlet mixture molar entropy";
  Real xvapin(min = 0, max = 1, start = 0.5) "In vapor mol fraction", xvapout(min = 0, max = 1, start = 0.5) "Out Vapor Mole fraction", xin_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction";

//========================================================================================
//Instantiation of connectors
  Files.Connection.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn En annotation(
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
end Adiabatic_Expander;
