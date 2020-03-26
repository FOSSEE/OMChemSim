within Simulator.UnitOperations;

model Splitter "Model of a splitter to split one material stream into multiple ones"
//============================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.Splitter;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Splitter Specifications", group = "Component Parameters"));
  parameter Integer Nc "Number of Components" annotation(
    Dialog(tab = "Splitter Specifications", group = "Component Parameters"));
  parameter Integer No "Number of outlet streams" annotation(
    Dialog(tab = "Splitter Specifications", group = "Splitter Parameters"));
  parameter String CalcType "Split_Ratio, Mass_Flow or Molar_Flow" annotation(
    Dialog(tab = "Splitter Specifications", group = "Splitter Parameters"));
  
//=============================================================================
//Model Variables
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet Temperature";
  Real xin_c[Nc](each unit = "-", each min = 0, each max = 1,  start =xg) "Inlet Mixture Mole Fraction";
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet Mixture Molar Flow";
  
  Real SplRat_s[No](each min = 0, each max = 1) "Split ratio";
  Real MW(each min = 0) "Average molecular weight";
  Real SpecVal_s[No] "Specification value"; 
  
  Real Pout_s[No](each unit = "Pa", each min = 0, each start = Pg) "Outlet Pressure";
  Real Tout_s[No](each unit = "K", each min = 0, each start = Tg) "Outlet Temperature";
  Real xout_sc[No, Nc](each unit = "-", each min = 0, each max = 1) "Outlet Mixture Molar Fraction";
  Real Fout_c[No](each unit = "mol/s", each min = 0,  start = Fg) "Outlet Mixture Molar Flow";
  Real Fmout_c[No](each unit = "kg/s", each min = 0, start = Fg) "Outlet Mixture Mass Flow";
  

//==============================================================================
//Instantiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out[No](each Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
  
  equation
//==============================================================================
//Connector equations
  In.P = Pin;
  In.T = Tin;
  In.x_pc[1, :] = xin_c[:];
  In.F = Fin;
  for i in 1:No loop
    Out[i].P = Pout_s[i];
    Out[i].T = Tout_s[i];
    Out[i].x_pc[1, :] = xout_sc[i, :];
    Out[i].F = Fout_c[i];
  end for;
//================================================================================
//Specification value assigning equation
  if CalcType == "Split_Ratio" then
    SplRat_s[:] = SpecVal_s[:];
  elseif CalcType == "Molar_Flow" then
    Fout_c[:] = SpecVal_s[:];
  elseif CalcType == "Mass_Flow" then
    Fmout_c[:] = SpecVal_s[:];
  end if;
//=================================================================================
//Balance equation
  for i in 1:No loop
    Pin = Pout_s[i];
    Tin = Tout_s[i];
    xin_c[:] = xout_sc[i, :];
    SplRat_s[i] = Fout_c[i] / Fin;
    MW * Fout_c[i] = Fmout_c[i];
  end for;
//==================================================================================
//Average Molecular Weight Calculation
algorithm
  MW := 0;
  for i in 1:Nc loop
    MW := MW + C[i].MW * xin_c[i];
  end for;
annotation(
    Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The <b>Splitter</b> is used to split up to a material streams into two, while executing all the mass and energy balances.</span><div><div style=\"orphans: 2; widows: 2;\"><div style=\"orphans: auto; widows: auto;\"><br></div><div style=\"orphans: auto; widows: auto;\"><br></div><div style=\"orphans: auto; widows: auto;\"><div><div style=\"orphans: 2; widows: 2;\"><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">The only calculation parameter for splitter is the calculation type (<b>CalcType</b>) variable which is</span></font><span style=\"font-size: 12px;\">&nbsp;of type&nbsp;</span><i style=\"font-size: 12px;\">parameter String</i><span style=\"font-size: 12px;\">. It can have either of the string values among the following types:</span></div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><b>Split_Ratio</b>: Mass and molar flow rate of the outlet streams are to be calculated depending on the specified split ratio</span></font></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\"><b>Mass_Flow</b>: Molar flow rate of the outlet streams are to be calculated depending on the specified mass flow rates of outlet stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\"><b>Molar_Flow</b>: Mass f</span><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">low rate of the outlet streams are to be calculated depending on the specified molar flow rate of the outlet stream</span></li></ol><div><span style=\"font-size: 12px; orphans: auto; widows: auto;\"><b>CalcType</b>&nbsp;has</span><span style=\"font-size: 12px; orphans: auto; widows: auto;\">&nbsp;been declared of type&nbsp;</span><i style=\"font-size: 12px; orphans: auto; widows: auto;\">parameter String.&nbsp;</i></div><div><span style=\"font-size: 12px; orphans: auto; widows: auto;\">During simulation, it can specified directly under</span><b style=\"font-size: 12px; orphans: auto; widows: auto;\">&nbsp;Splitter Specifications</b><span style=\"font-size: 12px; orphans: auto; widows: auto;\">&nbsp;by double clicking on the splitter model instance.</span></div></div></div><div><br></div><div><br></div><div>Depending on the CalcType specified in the Splitter Specification, its value has to be specified through the variable Specification Value (<b>SpecVal_s</b>). It is declared of type&nbsp;<i>Real.</i></div><div><div>During simulation, value of this variable need to be defined in the equation section.</div></div></div></div><div style=\"orphans: 2; widows: 2;\"><div><span style=\"font-size: 12px; orphans: auto; widows: auto;\"><br></span></div><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><br></span></font></div><div><span style=\"font-size: 12px; orphans: auto; widows: auto;\">For demonstration on how to use this model to simulate a Splitter,</span><span style=\"font-size: 12px; orphans: auto; widows: auto;\">&nbsp;go to <a href=\"modelica://Simulator.Examples.Splitter\">Splitter Example</a>.</span></div><!--EndFragment--></div></div></body></html>"));
    end Splitter;
