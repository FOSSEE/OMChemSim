package Methanol_Water_Distillation

  model MS "Extension of Material Stream with Raoults's Law"
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end MS;

package rigDist
  model Condenser "Extension of Condenser with Raoult's Law"
    extends Simulator.UnitOperations.DistillationColumn.Cond;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Condenser;

  model Tray "Extension of Tray with Raoult's Law"
    extends Simulator.UnitOperations.DistillationColumn.DistTray;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Tray;

  model Reboiler "Extension of Reboiler with Raoult's Law"
    extends Simulator.UnitOperations.DistillationColumn.Reb;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Reboiler;

  model DistColumn
    
    extends Simulator.UnitOperations.DistillationColumn.DistCol;
    Condenser condenser(Nc = Nc, C = C, Ctype = Ctype, Bin = Bin_t[1]);
    Reboiler reboiler(Nc = Nc, C = C, Bin = Bin_t[Nt]);
    Tray tray[Nt - 2](each Nc = Nc, each C = C, Bin = Bin_t[2:Nt - 1]);
      
  end DistColumn;

end rigDist;

model Flowsheet
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Water wat;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {meth, wat};
    Simulator.UnitOperations.Heater HEAT1(C = C, Eff = 1, Nc = Nc, Pdel = 0)  annotation(
      Placement(visible = true, transformation(origin = {-66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.rigDist.DistColumn DC1(C = C, Ctype = "Total", InT_s = {4}, Nc = Nc, Nt = 8)  annotation(
      Placement(visible = true, transformation(origin = {2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.Cooler COOL1(C = C, Eff = 1, Nc = Nc, Pdel = 0)  annotation(
      Placement(visible = true, transformation(origin = {62, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.MS S1(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.MS S2(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.MS S3(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {36, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.MS S4(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {80, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.MS S5(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {86, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {-90, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E2 annotation(
      Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E3 annotation(
      Placement(visible = true, transformation(origin = {76, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E4 annotation(
      Placement(visible = true, transformation(origin = {82, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
    connect(COOL1.En, E4.In) annotation(
      Line(points = {{72, 20}, {72, 8}}, color = {255, 0, 0}));
    connect(S3.Out, COOL1.In) annotation(
      Line(points = {{46, 30}, {52, 30}}, color = {0, 70, 70}));
    connect(COOL1.Out, S5.In) annotation(
      Line(points = {{72, 30}, {76, 30}}, color = {0, 70, 70}));
    connect(DC1.Dist, S3.In) annotation(
      Line(points = {{27, 30}, {26, 30}}, color = {0, 70, 70}));
    connect(E1.Out, HEAT1.En) annotation(
      Line(points = {{-80, -22}, {-76, -22}, {-76, -10}}, color = {255, 0, 0}));
    connect(S1.Out, HEAT1.In) annotation(
      Line(points = {{-80, 0}, {-76, 0}}, color = {0, 70, 70}));
    connect(DC1.Bot, S4.In) annotation(
      Line(points = {{27, -30}, {70, -30}}, color = {0, 70, 70}));
    connect(DC1.Cduty, E2.In) annotation(
      Line(points = {{27, 60}, {40, 60}}, color = {255, 0, 0}));
    connect(DC1.Rduty, E3.In) annotation(
      Line(points = {{27, -60}, {66, -60}}, color = {255, 0, 0}));
    connect(S2.Out, DC1.In_s[1]) annotation(
      Line(points = {{-28, 0}, {-23, 0}}, color = {0, 70, 70}));
    connect(HEAT1.Out, S2.In) annotation(
      Line(points = {{-56, 0}, {-48, 0}}, color = {0, 70, 70}));
    S1.x_pc[1, :] = {0.36, 0.64};
    S1.T = 300;
    S1.F_p[1] = 60;
    S1.P = 101325;
    HEAT1.Tout = 325.15;
    DC1.condenser.P = 101325;
    DC1.reboiler.P = 101325;
    DC1.RR = 2;
    S4.F_p[1] = 36.7475;
    COOL1.Tout = 298;

end Flowsheet;


end Methanol_Water_Distillation;
