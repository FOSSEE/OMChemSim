within Simulator.UnitOperations.AbsorptionColumn;

model AbsCol
    extends Simulator.Files.Icons.AbsorptionColumn;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.GeneralProperties C[Nc];
    parameter Integer Nc "Number of Components";
    parameter Integer Nt;
 
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
      __OpenModelica_commandLineOptions = "");
end AbsCol;
