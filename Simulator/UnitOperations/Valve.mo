within Simulator.UnitOperations;

model Valve
  extends Simulator.Files.Icons.Valve;
  // This is generic valve model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer valve model in Test section for this.
  //====================================================================================
  Real Fin(min = 0, start = 100) "inlet mixture molar flow rate", Fout(min = 0, start = 100) "outlet mixture molar flow rate", Pin(min = 0, start = 101325) "Inlet pressure", Pout(min = 0, start = 101325) "Outlet pressure", Pdel "Pressure drop", Tin(min = 0, start = 273.15) "Inlet Temperature", Tout(min = 0, start = 273.15) "Outlet Temperature", Tdel "Temperature Increase";
  Real Hin "inlet mixture molar enthalpy", Hout "outlet mixture molar enthalpy";
  Real Sin "inlet mixture molar entropy", Sout "outlet mixture molar entropy", x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction", xvapin(min = 0, max = 1, start = 0.5) "Inlet vapor phase mole fraction", xvapout(min = 0, max = 1, start = 0.5) "Outlet vapor phase mole fraction";
  //========================================================================================
  parameter Integer Nc = 3 "number of components";
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  //========================================================================================
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
//=============================================================================================
  Fin = Fout;
//material balance
  Hin = Hout;
//energy balance
  Pin - Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
end Valve;
