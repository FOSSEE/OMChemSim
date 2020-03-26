package Methanol_Water_Distillation

  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

package rigDist
  model Condenser
    extends Simulator.UnitOperations.DistillationColumn.Cond;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Condenser;

  model Tray
    extends Simulator.UnitOperations.DistillationColumn.DistTray;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Tray;

  model Reboiler
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
    Simulator.UnitOperations.Heater HEAT_01(C = C, Eff = 1, Nc = Nc, Pdel = 0)  annotation(
      Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    rigDist.DistColumn DC_01(C = C, Ctype = "Total", InT_s = {4}, Nc = Nc, Nt = 8)  annotation(
      Placement(visible = true, transformation(origin = {24, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.Cooler COOL_01(C = C, Eff = 1, Nc = Nc, Pdel = 0)  annotation(
      Placement(visible = true, transformation(origin = {134, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms S_01(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms S_02(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.ms S_03(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {80, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Methanol_Water_Distillation.ms S_04(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {80, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms S_05(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {174, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E_01 annotation(
      Placement(visible = true, transformation(origin = {-92, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E_02 annotation(
      Placement(visible = true, transformation(origin = {74, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E_03 annotation(
      Placement(visible = true, transformation(origin = {76, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E_04 annotation(
      Placement(visible = true, transformation(origin = {174, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
    connect(S_02.Out, DC_01.In_s[1]) annotation(
      Line(points = {{-20, 0}, {-2, 0}, {-2, 0}, {0, 0}}, color = {0, 70, 70}));
    connect(COOL_01.En, E_04.In) annotation(
      Line(points = {{144, -10}, {144, -26}, {164, -26}}, color = {255, 0, 0}));
    connect(DC_01.Rduty, E_03.In) annotation(
      Line(points = {{50, -60}, {66, -60}, {66, -60}, {66, -60}}, color = {255, 0, 0}));
    connect(DC_01.Cduty, E_02.In) annotation(
      Line(points = {{50, 60}, {64, 60}, {64, 60}, {64, 60}}, color = {255, 0, 0}));
    connect(E_01.Out, HEAT_01.En) annotation(
      Line(points = {{-82, -22}, {-72, -22}, {-72, -10}, {-72, -10}}, color = {255, 0, 0}));
    connect(COOL_01.Out, S_05.In) annotation(
      Line(points = {{144, 0}, {164, 0}, {164, 0}, {164, 0}}, color = {0, 70, 70}));
    connect(S_03.Out, COOL_01.In) annotation(
      Line(points = {{90, 30}, {106, 30}, {106, 0}, {124, 0}, {124, 0}}, color = {0, 70, 70}));
    connect(DC_01.Bot, S_04.In) annotation(
      Line(points = {{50, -30}, {70, -30}, {70, -30}, {70, -30}}, color = {0, 70, 70}));
    connect(DC_01.Dist, S_03.In) annotation(
      Line(points = {{50, 30}, {70, 30}, {70, 30}, {70, 30}}, color = {0, 70, 70}));
    connect(HEAT_01.Out, S_02.In) annotation(
      Line(points = {{-52, 0}, {-40, 0}, {-40, 0}, {-40, 0}}, color = {0, 70, 70}));
    connect(S_01.Out, HEAT_01.In) annotation(
      Line(points = {{-82, 0}, {-72, 0}, {-72, 0}, {-72, 0}}, color = {0, 70, 70}));
    
    S_01.x_pc[1, :] = {0.36, 0.64};
    S_01.T = 300;
    S_01.F_p[1] = 60;
    S_01.P = 101325;
    HEAT_01.Tout = 325.15;
    DC_01.condenser.P = 101325;
    DC_01.reboiler.P = 101325;
    DC_01.RR = 2;
    S_04.F_p[1] = 36.7475;
    COOL_01.Tout = 298;
end Flowsheet;


end Methanol_Water_Distillation;
