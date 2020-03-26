within Simulator.UnitOperations.AbsorptionColumn;

model AbsCol "Model of an absorption column representing fractionating towers where mixture is separated in equilibrium stages"
    extends Simulator.Files.Icons.AbsorptionColumn;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Column Specifications", group = "Component Parameters"));
    parameter Integer Nc "Number of Components" annotation(
    Dialog(tab = "Column Specifications", group = "Component Parameters"));
    parameter Integer Nt "Number of stages" annotation(
    Dialog(tab = "Column Specifications", group = "Column Parameters"));
 
    Simulator.Files.Interfaces.matConn In_Top(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 302}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn In_Bot(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Out_Top(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Out_Bot(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//connector equation
    tray[1].Fliq_s[1] = In_Top.F;
    tray[1].xliq_sc[1, :] = In_Top.x_pc[1, :];
    tray[1].Hliq_s[1] = In_Top.H;
    tray[1].Fvap_s[2] = Out_Top.F;
    tray[1].xvap_sc[2, :] = Out_Top.x_pc[1, :];
//  tray[1].vapMolEnth[2] = Out_Top.mixMolEnth;
    tray[1].T = Out_Top.T;
    tray[Nt].Fliq_s[2] = Out_Bot.F;
    tray[Nt].xliq_sc[2, :] = Out_Bot.x_pc[1, :];
//  tray[Nt].liqMolEnth[2] = Out_Bot.mixMolEnth;
    tray[Nt].T = Out_Bot.T;
    tray[Nt].Fvap_s[1] = In_Bot.F;
    tray[Nt].xvap_sc[1, :] = In_Bot.x_pc[1, :];
    tray[Nt].Hvap_s[1] = In_Bot.H;
    for i in 1:Nt - 1 loop
      connect(tray[i].Out_Liq, tray[i + 1].In_Liq);
      connect(tray[i].In_Vap, tray[i + 1].Out_Vap);
    end for;
//tray pressures
    for i in 2:Nt - 1 loop
      tray[i].P = tray[1].P + i * (tray[Nt].P - tray[1].P) / (Nt - 1);
    end for;
    tray[1].P = In_Top.P;
    tray[Nt].P = In_Bot.P;
    tray[1].P = Out_Top.P;
    tray[Nt].P = Out_Bot.P;
    annotation(
      Icon(coordinateSystem(extent = {{-250, -450}, {250, 450}})),
      Diagram(coordinateSystem(extent = {{-250, -450}, {250, 450}})),
      __OpenModelica_commandLineOptions = "",
 Documentation(info = "<html><head></head><body><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The&nbsp;<b>Absorption Column</b>&nbsp;is used to separate gas mixture by scrubbing through a liquid solvent.</span><div style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\"><br></span></div><div style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The absorption column model have following connection ports:</span></div><div><ol style=\"font-size: 12px;\"><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">Material Streams</span></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">two feed streams</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">two products</span></li></ul></ol><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">The results are:</span></font></div><div><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Molar flow rate of Product streams</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Composition of Components in Product streams</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Stagewise Liquid and Vapor Flows</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Temperature Profile</span></font></li></ol></div><div><br></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">To simulate an absorption column, the only calculation parameter which must be provided is&nbsp;</span></font><span style=\"font-size: 13px; font-family: Arial, Helvetica, sans-serif;\">Number of Stages (</span><b style=\"font-size: 13px; font-family: Arial, Helvetica, sans-serif;\">Nt</b><span style=\"font-size: 13px; font-family: Arial, Helvetica, sans-serif;\">).</span></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><div><br></div><div><span style=\"orphans: auto; widows: auto;\">During simulation, its value can specified directly under&nbsp;</span><b style=\"orphans: auto; widows: auto;\">Column Specifications</b><span style=\"orphans: auto; widows: auto;\">&nbsp;by double clicking on the column instance.</span></div></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><div><span style=\"orphans: auto; widows: auto;\"><br></span></div><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><br></span></font></div><div><span style=\"orphans: auto; widows: auto;\">For detailed explaination on how to use this model to simulate an Absorption Column,</span><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">&nbsp;go to&nbsp;<a href=\"modelica://Simulator.Examples.Absorption\">Absorption Column Example</a></span></font></div></div></div></body></html>"));
end AbsCol;
