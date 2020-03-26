within Simulator.UnitOperations.DistillationColumn;

  model DistCol "Model of a distillation column representing fractionating towers where mixture is separated in equilibrium stages"
    extends Simulator.Files.Icons.DistillationColumn;
     parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Column Specifications", group = "Component Parameters"));
    parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Column Specifications", group = "Component Parameters"));
    import data = Simulator.Files.ChemsepDatabase;
    parameter Boolean Bin_t[Nt] = Simulator.Files.OtherFunctions.colBoolCalc(Nt, Ni, InT_s) "Stream stage associations" annotation(
    Dialog(tab = "Column Specifications", group = "Component Parameters"));
    parameter Integer Nt = 4 "Number of stages" annotation(
    Dialog(tab = "Column Specifications", group = "Calculation Parameters"));
    parameter Integer Nout = 0 "Number of side draws" annotation(
    Dialog(tab = "Column Specifications", group = "Calculation Parameters"));
    parameter Integer NQ = 0 "Number of heat load" annotation(
    Dialog(tab = "Column Specifications", group = "Calculation Parameters"));
    parameter Integer Ni = 1 "Number of feed streams" annotation(
    Dialog(tab = "Column Specifications", group = "Calculation Parameters"));
    parameter Integer InT_s[Ni] "Feed stage location" annotation(
    Dialog(tab = "Column Specifications", group = "Calculation Parameters"));
    parameter String Ctype = "Total" "Condenser type: Total or Partial" annotation(
    Dialog(tab = "Column Specifications", group = "Calculation Parameters"));

    Real RR(min = 0);
    Simulator.Files.Interfaces.matConn In_s[Ni](each Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-248, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Dist(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {250, 316}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 298}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Bot(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {250, -296}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {252, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.enConn Cduty annotation(
      Placement(visible = true, transformation(origin = {246, 590}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.enConn Rduty annotation(
      Placement(visible = true, transformation(origin = {252, -588}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -598}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Out_s[Nout](each Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-36, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.enConn En[NQ](each Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-34, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  for i in 1:Ni loop
    if InT_s[i] == 1 then
      connect(In_s[i], condenser.In);
    elseif InT_s[i] == Nt then
      connect(In_s[i], reboiler.In);
    elseif InT_s[i] > 1 and InT_s[i] < Nt then
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
      In_s[i].P = tray[InT_s[i] - 1].Pdmy1;
      In_s[i].T = tray[InT_s[i] - 1].Tdmy1;
      In_s[i].F = tray[InT_s[i] - 1].Fdmy1;
      In_s[i].x_pc = tray[InT_s[i] - 1].xdmy1_pc;
      In_s[i].H = tray[InT_s[i] - 1].Hdmy1;
      In_s[i].S = tray[InT_s[i] - 1].Sdmy1;
      In_s[i].xvap = tray[InT_s[i] - 1].xvapdmy1;
    end if;
  end for;
    connect(condenser.Out, Dist);
    connect(reboiler.Out, Bot);
    connect(condenser.En, Cduty);
    connect(reboiler.En, Rduty);
    for i in 1:Nt - 3 loop
      connect(tray[i].Out_Liq, tray[i + 1].In_Liq);
      connect(tray[i].In_Vap, tray[i + 1].Out_Vap);
    end for;
    connect(tray[1].Out_Vap, condenser.In_Vap);
    connect(condenser.Out_Liq, tray[1].In_Liq);
    connect(tray[Nt - 2].Out_Liq, reboiler.In_Liq);
    connect(reboiler.Out_Vap, tray[Nt - 2].In_Vap);
//tray pressures
  for i in 1:Nt - 2 loop
    tray[i].P = condenser.P + i * (reboiler.P - condenser.P) / (Nt - 1);
  end for;
    
    for i in 2:Nt - 1 loop
      tray[i - 1].OutType = "Null";
      tray[i - 1].Out.x_pc = zeros(3, Nc);
      tray[i - 1].Out.F = 0;
      tray[i - 1].Out.H = 0;
      tray[i - 1].Out.S = 0;
      tray[i - 1].Out.xvap = 0;
      tray[i - 1].Q = 0;
    end for;
    RR = condenser.Fliqout / condenser.Out.F;
  annotation(
      Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
      __OpenModelica_commandLineOptions = "",
  Documentation(info = "<html><head></head><body><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The&nbsp;<b>Distillation Column</b>&nbsp;is used to separate the component mixture into component parts or fraction based on difference in volatalities.</span><div style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\"><br></span></div><div style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The distillation column model have following connection ports:</span></div><div><ol style=\"font-size: 12px;\"><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">Material Streams</span></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">any number of feed stage</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">two products (distillate and bottom)</span></li></ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">Two Energy Streams</span></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">condenser (total or partial)</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">reboiler</span></li></ul></ol><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><br></span></font></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">The results are:</span></font></div><div><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Molar flow rate of Distillate and Bottoms</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Composition of Components in Distillate and Bottoms</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Condenser and Reboiler Duty</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Stagewise Liquid and Vapor Flows</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Temperature Profile</span></font></li></ol><div><br></div></div><div><br></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">To simulate a distillation column, following calculation parameters must be provided:</span></font></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Number of Stages (<b>Nt</b>)</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Number of Feed Streams (<b>Ni</b>)</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Feed Tray Location (<b>InT_s</b>)</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Condenser Type (<b>Ctype</b>)</span></font></li></ol><div><span style=\"orphans: auto; widows: auto;\">All the variables are of type <i>parameter Real</i> except the last one (<b>Ctype</b>) which is of type&nbsp;<i>parameter String</i>. It can have either of the sting values among following:</span></div><div><ol><li><span style=\"orphans: auto; widows: auto;\"><b>Total</b>: To indicate that the condenser is Total Condenser</span></li><li><span style=\"orphans: auto; widows: auto;\"><b>Partial</b>: To indicate that the condenser is Partial Condenser</span></li></ol><span style=\"orphans: auto; widows: auto;\">During simulation, their values can specified directly under&nbsp;</span><b style=\"orphans: auto; widows: auto;\">Column Specifications</b><span style=\"orphans: auto; widows: auto;\">&nbsp;by double clicking on the column instance.</span></div><div><span style=\"orphans: auto; widows: auto;\"><br></span></div><div><span style=\"orphans: auto; widows: auto;\"><br></span></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">Additionally, following input for following variables must be provided:</span></div><div style=\"orphans: 2; widows: 2;\"><ol style=\"font-size: 12px;\"><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Condenser Pressure (<b>Pcond)</b></span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Reboiler Pressure (<b>Preb</b>)</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Top Specification</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Bottom Specification</span></font></li></ol><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Any one of the following variables can be considered as Top Specification:</span></font></div><div><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Reflux Ratio (<b>RR</b>)</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Molar Flow rate (<b>F_p[1]</b>)</span></font></li></ol><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Any one of the following can be considered as Bottoms Specification:</span></font></div></div><div><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Molar Flow rate (<b>F_p[1]</b>)</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Mole Fraction of Component (<b>x_pc[1,:]</b>)</span></font></li></ol></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><div><span style=\"orphans: auto; widows: auto;\">These variables are declared of type&nbsp;</span><i style=\"orphans: auto; widows: auto;\">Real</i><span style=\"orphans: auto; widows: auto;\">&nbsp;and therefore all these variables need to be declared in the equation section while simulating the model.</span></div><div><span style=\"orphans: auto; widows: auto;\"><br></span></div><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><br></span></font></div><div><span style=\"orphans: auto; widows: auto;\">For detailed explaination on how to use this model to simulate a Distillation Column,</span><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">&nbsp;go to&nbsp;<a href=\"modelica://Simulator.Examples.Distillation\">Distillation Column Example</a></span></font></div></div></div></body></html>"));
  end DistCol;
