within Simulator.Unit_Operations;

model Heater
  extends Simulator.Files.Icons.Heater;
  // This is generic heater model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer heater models in Test section for this.
  //========================================================================================
  Real Fin(min = 0, start = 100) "inlet mixture molar flow rate", Fout(min = 0, start = 100) "outlet mixture molar flow rate", Q "Heat added", Pin(min = 0, start = 101325) "Inlet pressure", Pout(min = 0, start = 101325) "Outlet pressure", Tin(min = 0, start = 273.15) "Inlet Temperature", Tout(min = 0, start = 273.15) "Outlet Temperature", Tdel "Temperature Increase", xvapout(min = 0, max = 1, start = 0.5) "Outlet Vapor Mole Fraction";
  Real Hin "inlet mixture molar enthalpy", Hout "outlet mixture molar enthalpy";
  //========================================================================================
  parameter Real Pdel "Pressure drop", Eff "Efficiency";
  Real x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction", xvapin(min = 0, max = 1, start = 0.5) "Inlet vapor phase mole fraction";
  parameter Integer Nc "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  //========================================================================================
  Simulator.Files.Connection.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //=========================================================================================
equation
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.x_pc[1, :] = x_c[:];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.x_pc[1, :] = x_c[:];
  Out.xvap = xvapout;
  En.Q = Q;
//=============================================================================================
  Fin = Fout;
//material balance
  Hin + Eff * Q / Fin = Hout;
//energy balance
  Pin - Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
end Heater;
