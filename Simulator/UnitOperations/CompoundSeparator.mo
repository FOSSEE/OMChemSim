within Simulator.UnitOperations;

model CompoundSeparator
  extends Simulator.Files.Icons.CompoundSeparator;
    parameter Integer Nc "Number of components";
   parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Components array";
    parameter Integer SepStrm "Specified Stream";

  Real Pin(min = 0, start = Pg) "inlet pressure";
  Real Tin(min = 0, start = Tg) "inlet temperature";
  Real xin_c[Nc](each min = 0, each max = 1, start=xguess) "inlet mixture mole fraction";
  Real Fin(min = 0, start = 100) "inlet mixture molar flow";
  Real Fin_c[Nc](each min = 0, each start = Fg) "inlet compound molar flow";
  Real Fmin_c[Nc](each min = 0, each start =Fg) "inlet compound mass flow";
  Real Hin(start=Htotg) "inlet mixture molar enthalpy";
  
  Real Q "energy required";
  Real SepVal_c[Nc] "Separation factor value";
 
  Real Pout_s[2](each min = 0, start={Pg,Pg}) "outlet Pressure";
  Real Tout_s[2](each min = 0, start={Tg,Tg}) "outlet temperature";
  Real xout_sc[2, Nc](each min = 0, each max = 1, start={xg,xg}) "outlet mixture mole fraction";
  Real Fout_s[2](each min = 0,  start = {Fg,Fg}) "Outlet mixture molar flow";
  Real Fout_sc[2, Nc](each min = 0,  start = {Fg,Fg}) "outlet compounds molar flow";
  Real Fmout_sc[2, Nc](each min = 0, start={Fg,Fg}) "outlet compound mass flow";
  Real Hout_s[2](start={Hvapg,Hliqg}) "outlet mixture molar enthalpy";
 
  parameter String SepFact_c[Nc] "Separation factor";
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
    __OpenModelica_commandLineOptions = "");
  end CompoundSeparator;
