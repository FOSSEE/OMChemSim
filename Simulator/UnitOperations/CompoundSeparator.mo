within Simulator.UnitOperations;

model CompoundSeparator
  extends Simulator.Files.Icons.CompoundSeparator;
    parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Separator Specifications", group = "Component Parameters"));
   parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Separator Specifications", group = "Component Parameters"));
    parameter Integer SepStrm "Specified Stream" annotation(
    Dialog(tab = "Separator Specifications", group = "Separator Parameters"));

  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real xin_c[Nc](each unit = "-", each min = 0, each max = 1, start=xguess) "Inlet stream component mole fraction";
  Real Fin(unit = "mol/s", min = 0, start = 100) "Inlet stream molar flow";
  Real Fin_c[Nc](each unit = "mol/s", each min = 0, each start = Fg) "Inlet stream compound molar flow";
  Real Fmin_c[Nc](each unit = "kg/s", each min = 0, each start =Fg) "Inlet stream compound mass flow";
  Real Hin(unit = "kJ/kmol", start=Htotg) "inlet mixture molar enthalpy";
  
  Real Q "energy required";
  Real SepVal_c[Nc] "Separation factor value";
 
  Real Pout_s[2](each unit = "Pa", each min = 0, start={Pg,Pg}) "Outlet stream pressure";
  Real Tout_s[2](each unit = "K", each min = 0, start={Tg,Tg}) "Outlet stream temperature";
  Real xout_sc[2, Nc](each unit = "-", each min = 0, each max = 1, start={xg,xg}) "Component mole fraction at outlet stream";
  Real Fout_s[2](each unit = "mol/s", each min = 0,  start = {Fg,Fg}) "Outlet stream molar flow";
  Real Fout_sc[2, Nc](each unit = "mol/s", each min = 0,  start = {Fg,Fg}) "outlet compounds molar flow";
  Real Fmout_sc[2, Nc](each unit = "kg/s", each min = 0, start={Fg,Fg}) "outlet compound mass flow";
  Real Hout_s[2](each unit = "kJ/kmol", start={Hvapg,Hliqg}) "outlet mixture molar enthalpy";
 
  parameter String SepFact_c[Nc] "Separation factor" annotation(
    Dialog(tab = "Separator Specifications", group = "Separator Parameters"));
  // separation factor: Molar_Flow, Mass_Flow, Inlet_Molar_Flow_Percent, Inlet_Mass_Flow_Percent.
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out1(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out2(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
  
equation
// Connector equation
  In.P = Pin;
  In.T = Tin;
  In.F  = Fin;
  In.x_pc[1, :] = xin_c[:];
  In.H = Hin;
  Out1.P = Pout_s[1];
  Out1.T = Tout_s[1];
  Out1.F = Fout_s[1];
  Out1.x_pc[1, :] = xout_sc[1, :];
  Out1.H = Hout_s[1];
  Out2.F = Fout_s[2];
  Out2.x_pc[1, :] = xout_sc[2, :];
  Out2.H = Hout_s[2];
  Out2.P = Pout_s[2];
  Out2.T = Tout_s[2];
  En.Q = Q;
// Pressure and temperature equations
  Pout_s[1] = Pin;
  Pout_s[2] = Pin;
  Tout_s[1] = Tin;
  Tout_s[2] = Tin;
// mole balance
  Fin = sum(Fout_s[:]);
  Fin_c[:] = xout_sc[1, :] * Fout_s[1] + xout_sc[2, :] * Fout_s[2];
// Conversion
  Fin_c = xin_c .* Fin;
  Fmin_c = Fin_c .* C[:].MW;
  for i in 1:2 loop
    Fout_sc[i, :] = xout_sc[i, :] .* Fout_s[i];
    Fmout_sc[i, :] = Fout_sc[i, :] .* C[:].MW;
  end for;
  sum(xout_sc[2, :]) = 1;
  for i in 1:Nc loop
    if SepFact_c[i] == "Molar_Flow" then
      SepVal_c[i] = Fout_sc[SepStrm, i];
    elseif SepFact_c[i] == "Mass_Flow" then
      SepVal_c[i] = Fmout_sc[SepStrm, i];
    elseif SepFact_c[i] == "Inlet_Molar_Flow_Percent" then
      Fout_sc[SepStrm, i] = SepVal_c[i] * Fin_c[i] / 100;
    elseif SepFact_c[i] == "Inlet_Mass_Flow_Percent" then
      Fmout_sc[SepStrm, i] = SepVal_c[i] * Fmin_c[i] / 100;
    end if;
  end for;
//Energy balance
  Q = sum(Hout_s .* Fout_s) - Fin * Hin;

annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    __OpenModelica_commandLineOptions = "",
 Documentation(info = "<html><head></head><body>The <b>Compound Separator</b> is used to simulate the separation process of a material stream bases on mass balance<div><br></div><div><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The compound separator model have following connection ports:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Three Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">two outlet streams</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">heat added</span></li></ul></ol></div></div><div><br></div><div>Following calculation parameters must be provided to the compound separator:</div><div><ol><li>Specified Stream (<b>SepStrm</b>)</li><li>Separation Factor (<b>SepFact_c</b>)</li></ol><div>Among the above variables, <b>SepStrm</b> has been declared of type&nbsp;<i>parameter Real&nbsp;</i>and <b>SepFact_c</b> has been declared of type <i>parameter String.&nbsp;</i><span style=\"font-size: 12px; orphans: 2; widows: 2;\">It can have either of the string values among the following types:</span></div><div style=\"orphans: 2; widows: 2;\"><ol><li style=\"font-size: 12px;\"><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><b>Molar_flow: </b>All the outlet streams are to be calculated depending on the specified molar flow of component in the specified stream</span></font></li><li style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\"><b>Mass_Flow</b>:&nbsp;</span><span style=\"font-size: 13px; font-family: Arial, Helvetica, sans-serif;\">All the outlet streams are to be calculated depending on the specified mass flow of component in the specified stream</span></li><li style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\"><b>Inlet_Molar_Flow_Percent</b>:&nbsp;</span><span style=\"font-size: 13px; font-family: Arial, Helvetica, sans-serif;\">All the outlet streams are to be calculated depending on the specified percentage of inlet molar flow of component in the specified stream</span></li><li style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\"><b>Inlet_Mass_Flow_Percent</b>:&nbsp;</span><span style=\"font-size: 13px; font-family: Arial, Helvetica, sans-serif;\">All the outlet streams are to be calculated depending on the&nbsp;specified percentage of inlet molar flow of component&nbsp;in the specified stream</span></li></ol></div><div><br></div><div>During simulation, their values can specified directly under <b>Separator Specifications</b> by double clicking on the compound separator model instance.</div><div><br></div><div><br></div><div>For the selected separation factor, its value has to be specified through another variable Separation Factor Value (<b>SepVal_c</b>). It is declared of type <i>Real.</i></div><div><div>During simulation, its value need to be defined in the equation section.</div><div><br></div></div><div><br></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Compound Separator, go to <a href=\"modelica://Simulator.Examples.CompoundSeparator\">Compound Separator Example</a>.</span></div></div></div></body></html>"));
  end CompoundSeparator;
