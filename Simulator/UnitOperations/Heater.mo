within Simulator.UnitOperations;

model Heater "Model of a heater to heat a material stream"
  extends Simulator.Files.Icons.Heater;
  
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Heater Specifications", group = "Component Parameters"));
    parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Heater Specifications", group = "Component Parameters"));
  //========================================================================================
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "inlet stream molar enthalpy";
  Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mole fraction";
  
  Real x_c[Nc](each unit = "-", each min = 0, each max = 1) "Component mole fraction";
  Real Q(unit = "W") "Heat added";
  Real Fout(unit = "mol/s", min = 0, start = Fg) "outlet stream molar flow rate";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Tdel(unit = "K") "Temperature Increase";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor mole fraction";
  Real Hout(unit = "kJ/kmol",start=Htotg) "outlet mixture molar enthalpy";
  //========================================================================================
  parameter Real Pdel(unit = "Pa") "Pressure drop" annotation(
    Dialog(tab = "Heater Specifications", group = "Calculation Parameters"));
  parameter Real Eff(unit = "-") "Efficiency" annotation(
    Dialog(tab = "Heater Specifications", group = "Calculation Parameters"));
  //========================================================================================
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //=========================================================================================
  extends GuessModels.InitialGuess;
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
  annotation(
    Documentation(info = "<html><head></head><body>The <b>Heater</b> is used to simulate the heating process of a material stream.<div><br></div><div><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The heater model have following connection ports:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">heat added</span></li></ul></ol></div></div><div><br></div><div>Following calculation parameters must be provided to the heater:</div><div><ol><li>Pressure Drop (<b>Pdel</b>)</li><li>Efficiency (<b>Eff</b>)</li></ol><div>The above variables have been declared of type <i>parameter Real.&nbsp;</i></div><div>During simulation, their values can specified directly under <b>Heater Specifications</b> by double clicking on the heater model instance.</div><div><br></div><div><br></div><div>In addition to the above parameters, any one additional variable from the below list must be provided for the model to simulate successfully:</div><div><ol><li>Outlet Temperature (<b>Tout</b>)</li><li>Temperature Increase (<b>Tdel</b>)</li><li>Heat Added (<b>Q</b>)</li><li>Outlet Stream Vapor Phase Mole Fraction (<b>xvapout</b>)</li></ol><div>These variables are declared of type <i>Real.</i></div><div>During simulation, value of one of these variables need to be defined in the equation section.</div><div><br></div></div><div><br></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Heater, go to <a href=\"modelica://Simulator.Examples.Heater\">Heater Example</a>.</span></div></div></div></body></html>"));
end Heater;
