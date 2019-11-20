within Simulator.UnitOperations;

model Cooler
  extends Simulator.Files.Icons.Cooler;
  // This is generic cooler model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer cooler models in Test section for this.
  //====================================================================================
  Real Fin(min = 0, start = 100) "inlet mixture molar flow rate", Fout(min = 0, start = 100) "outlet mixture molar flow rate", Q "Heat removed", Pin(min = 0, start = 101325) "Inlet pressure", Pout(min = 0, start = 101325) "Outlet pressure", Tin(min = 0, start = 273.15) "Inlet Temperature", Tout(min = 0, start = 273.15) "Outlet Temperature", Tdel "Temperature Drop", xvapout(min = 0, max = 1, start = 0.5) "Outlet Vapor Mole Fraction";
  Real Hin "inlet mixture molar enthalpy", Hout "outlet mixture molar enthalpy";
  Real Sin "inlet mixture molar entropy", Sout "outlet mixture molar entropy", x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction", inVapPhasMolFrac(min = 0, max = 1, start = 0.5) "Inlet vapor phase mole fraction";
  //========================================================================================
  parameter Real Pdel "Pressure drop", Eff "Efficiency";
  parameter Integer Nc "number of components";
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  //========================================================================================
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
equation
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = x_c[:];
  In.xvap = inVapPhasMolFrac;
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
end Cooler;
