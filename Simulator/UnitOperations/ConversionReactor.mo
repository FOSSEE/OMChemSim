within Simulator.UnitOperations;

model ConversionReactor "Model of a conversion reactor to calculate the outlet stream mole fraction of components"

//=============================================================================
  //Header Files and Parameters
  extends Simulator.Files.Icons.ConversionReactor;
   parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
   parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
   parameter String CalcMode = "Isothermal" "Required mode of operation: ''Isothermal'', ''Define_Out_Temperature'', ''Adiabatic''" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real Tdef(unit = "K") = 300 "Defined outlet temperature, applicable if Define_Out_Temperature mode is chosen" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real Pdel(unit = "Pa") = 0 "Pressure drop" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real X_r[Nr] = fill(0.4, Nr) "Conversion of base component" annotation(
    Dialog(tab = "Reactions", group = "Conversion Reaction Parameters"));
 //=============================================================================
  //Model Variables
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy"; 
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure"; 
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real xin_c[Nc](each unit = "K", each min = 0, each max = 1, start=xg) "Inlet stream component mole fraction"; 
 
  Real Fout(unit = "mol/s", min = 0, start = Fg) "Outlet stream molar flow rate";   
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real xout_c[Nc](each unit = "=", each min = 0, each max = 1, start=xg) "Outlet stream component mole fraction";  
  Real Pout(unit = "Pa", min = 0, start =Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Fout_cr[Nc, Nr](each unit = "mol/s") "Molar flor rate of components after each reaction";
 //=============================================================================
  //Instanstiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
equation
//=============================================================================
//Connector Equations
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
//=============================================================================
//Mole Balance
  for i in 1:Nc loop
    Fout_cr[i, 1] = Fin * xin_c[i] - Coef_cr[i, 1] / Coef_cr[BC_r[1], 1] * Fin * xin_c[BC_r[1]] * X_r[1];
  end for;
  if Nr > 1 then
    for j in 2:Nr loop
      for i in 1:Nc loop
        Fout_cr[i, j] = Fout_cr[i, j - 1] - Coef_cr[i, j] / Coef_cr[BC_r[j], j] * Fin * xin_c[BC_r[j]] * X_r[j];
      end for;
    end for;
  end if;
  Fout = sum(Fout_cr[:, Nr]);
  for i in 1:Nc loop
    xout_c[i] = Fout_cr[i, Nr] / Fout;
  end for;
//=============================================================================
//Outlet Pressure
  Pin - Pdel = Pout;
//=============================================================================
//Energy Balance
  if CalcMode == "Isothermal" then
    Tin = Tout;
    energy.Q = Hout * Fout - Hin * Fin + sum(Hr_r .* Fin .* xin_c[BC_r] .* X_r);
  elseif CalcMode == "Adiabatic" then
    Hout * Fout + sum(Hr_r .* Fin .* xin_c[BC_r] .* X_r) = Hin * Fin;
    energy.Q = 0;
  elseif CalcMode == "Define_Out_Temperature" then
    Tout = Tdef;
    energy.Q = Hout * Fout - Hin * Fin + sum(Hr_r .* Fin .* xin_c[BC_r] .* X_r);
  end if;

annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}}, initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}}, initialScale = 0.1)),
    __OpenModelica_commandLineOptions = "",
 Documentation(info = "<html><head></head><body><div>The <b>Conversion Reactor</b>&nbsp;is used to calculate the mole fraction of components at outlet stream when the conversion of base component for the reaction is defined.</div><div><br></div><div><div style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The conversion reactor model have following connection ports:</span></div><div style=\"font-size: 12px;\"><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">heat added</span></li></ul></ol></div></div></div><div><br></div>To simulate a conversion reactor, following calculation parameters must be provided:<div><ol><li>Calculation Mode (<b>CalcMode</b>)</li><li>Outlet Temperature&nbsp;(<b>Tdef</b>)&nbsp;(If calculation mode is Define_Out_Temperature)</li><li>Number of Reactions (<b>Nr</b>)</li><li>Base Component (<b>BC_r</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li><li>Conversion of Base Component (<b>X_r</b>)</li><li>Pressure Drop (<b>Pdel</b>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">All the above variables are of type <i>parameter Real</i> except the first one (<b>CalcMode</b>) which is of type&nbsp;<i>parameter String</i>. It can have either of the sting values among following:</span></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><ol><li><b>Isothermal</b>: If the reactor is operated isothermally</li><li><b>Define_Out_Temperature</b>: If the reactor is operated at specified outlet temperature</li><li><b>Adiabatic</b>: If the reactor is operated adiabatically</li></ol></div></div><div><div style=\"font-size: 12px;\">During simulation, their values can specified directly under&nbsp;<b>Reactor Specifications</b>&nbsp;by double clicking on the reactor model instance.</div></div></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Conversion Reactor, go to&nbsp;</span><a href=\"modelica://Simulator.Examples.CR\" style=\"font-size: 12px;\">Conversion Reactor Example</a><span style=\"font-size: 12px;\">.</span></div><div><br></div></body></html>"));
 end ConversionReactor;
