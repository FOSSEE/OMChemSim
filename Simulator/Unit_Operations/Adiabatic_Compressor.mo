within Simulator.Unit_Operations;

model Adiabatic_Compressor
  extends Simulator.Files.Icons.Adiabatic_Compressor;
  // This is generic Adibatic Compressor model. For using this model we need to extend this model and respective thermodynamic model and use the new model in flowsheets. Refer adia_comp models in Test section for this.
  extends Simulator.Files.Models.Flash;
  //====================================================================================
  Real Fin(min = 0, start = 100) "inlet mixture molar flow rate", Fout(min = 0, start = 100) "outlet mixture molar flow rate", Q "required Power", Pin(min = 0, start = 101325) "Inlet pressure", Pout(min = 0, start = 101325) "Outlet pressure", Pdel "Pressure Increase", Tin(min = 0, start = 273.15) "Inlet Temperature", Tout(min = 0, start = 273.15) "Outlet Temperature", Tdel "Temperature increase";
  Real Hin "inlet mixture molar enthalpy", Hout "outlet mixture molar enthalpy", Sin "inlet mixture molar entropy", Sout "outlet mixture molar entropy";
  Real xvapin(min = 0, max = 1, start = 0.5) "Inlet vapor mol fraction", xvapout(min = 0, max = 1, start = 0.5) "Outlet Vapor Mole fraction", x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction";
  parameter Real Eff "Efficiency";
  parameter Integer Nc "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  //========================================================================================
  Files.Connection.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
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
end Adiabatic_Compressor;
