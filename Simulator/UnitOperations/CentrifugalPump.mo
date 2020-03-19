within Simulator.UnitOperations;

model CentrifugalPump "Model of a centrifugal pump to provide energy to liquid stream in form of pressure"
  //===========================================================================
  //Header files and Parameters
  extends Simulator.Files.Icons.CentrifugalPump;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Pump Specifications", group = "Component Parameters"));
  parameter Integer Nc = 2 "Number of components" annotation(
    Dialog(tab = "Pump Specifications", group = "Component Parameters"));
  parameter Real Eff(unit = "-") "Efficiency" annotation(
    Dialog(tab = "Pump Specifications", group = "Calculation Parameters"));
  //===========================================================================
  //Model Variables
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy";
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow";
  Real xin_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Inlet stream components molar fraction";
  Real Tdel(unit = "K") "Temperature increase";
  Real Pdel(unit = "K") "Pressure increase";
  Real Q(unit = "W") "Power required";
  Real rho_c[Nc](each unit = "kmol/m3", each min = 0) "Component molar density";
  Real rho(unit = "kmol/m3", min = 0) "Density";
  Real Pvap(unit = "Pa", min = 0, start = Pg) "Vapor pressure of mixture at Outlet temperature";
  Real NPSH(unit = "m") "Net Positive Suction Head";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real Fout(unit = "mol/s", min = 0, start = Fg) "Outlet stream molar flow";
  Real xout_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Outlet stream molar fraction";
  //============================================================================
  //Instantiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  extends GuessModels.InitialGuess;
equation
//============================================================================
//Connector equation
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.x_pc[1, :] = xin_c[:];
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.x_pc[1, :] = xout_c[:];
  En.Q = Q;
//=============================================================================
//Pump equations
  Fin = Fout;
  xin_c = xout_c;
  Pin + Pdel = Pout;
  Tin + Tdel = Tout;
//=============================================================================
//Calculation of Density
  for i in 1:Nc loop
    rho_c[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tin, Pin);
  end for;
  rho = 1 / sum(xin_c ./ rho_c);
//==============================================================================
//Energy Balance and NPSH Calculation
  Hout = Hin + Pdel / rho;
  Q = Fin * (Hout - Hin) / Eff;
  NPSH = (Pin - Pvap) / rho;
//===============================================================================
//Vapor Pressure of mixture at Outlet Temperature
  Pvap = sum(xin_c .* exp(C[:].VP[2] + C[:].VP[3] / Tout + C[:].VP[4] * log(Tout) + C[:].VP[5] .* Tout .^ C[:].VP[6]));
  annotation(
    Documentation(info = "<html><head></head><body><!--StartFragment--><div>The&nbsp;<b>Centrifugal Pump</b>&nbsp;is generally used to provide energy to a liquid material stream. The energy supplied is in form of pressure.</div><div><br></div><div><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The centrifugal pump model have following connection ports:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">power required</span></font></li></ul></ol></div></div></div><div><br></div><div><br></div>To simulate a centrifugal pump, Efficiency (<b>Eff</b>) of the pump should be provided as calculation parameter. T<span style=\"font-size: 12px;\">he variable&nbsp;<b>Eff</b>&nbsp;is defined as of type&nbsp;</span><i style=\"font-size: 12px;\">parameter Real.<br></i>During simulation, its value can specified directly under <b>Pump&nbsp;Specifications</b>&nbsp;by double clicking on the pump model instance.<div><br></div><div><br></div><div>Additionally one of the following input variables must be defined:<div><ol><li>Outlet Pressure (<b>Pout</b>)</li><li>Pressure Increase (<b>Pdel</b>)</li><li>Power Required (<b>Q</b>)</li></ol><div><div style=\"font-size: 12px;\">These variables are declared of type&nbsp;<i>Real.</i></div><div style=\"font-size: 12px;\">During simulation, value of one of these variables need to be defined in the equation section.</div></div><div><br></div></div><div><br></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Centrifugal Pump, go to&nbsp;</span><a href=\"modelica://Simulator.Examples.Pump\" style=\"font-size: 12px;\">Centrifugal Pump Example</a><span style=\"font-size: 12px;\">.</span></div></div><!--EndFragment--></body></html>"));
    
end CentrifugalPump;
