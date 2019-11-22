within Simulator.UnitOperations;

model Heater
  extends Simulator.Files.Icons.Heater;
  // This is generic heater model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer heater models in Test section for this.
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
    parameter Integer Nc "number of components";
  //========================================================================================
  Real Fin(min = 0, start = 100) "inlet mixture molar flow rate";
  Real Pin(min = 0, start = 101325) "Inlet pressure";
  Real Tin(min = 0, start = 273.15) "Inlet Temperature";
  Real Hin "inlet mixture molar enthalpy";
  Real xvapin(min = 0, max = 1, start = 0.5) "Inlet vapor phase mole fraction";
  
  Real x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction";
  Real Q "Heat added";
  Real Fout(min = 0, start = 100) "outlet mixture molar flow rate";
  Real Pout(min = 0, start = 101325) "Outlet pressure";
  Real Tout(min = 0, start = 273.15) "Outlet Temperature";
  Real Tdel "Temperature Increase";
  Real xvapout(min = 0, max = 1, start = 0.5) "Outlet Vapor Mole Fraction";
  Real Hout "outlet mixture molar enthalpy";
  //========================================================================================
  parameter Real Pdel "Pressure drop", Eff "Efficiency";
  //========================================================================================
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
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
