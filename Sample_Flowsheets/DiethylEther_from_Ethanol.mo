package DiethylEther_from_Ethanol

model ms
  extends Simulator.Streams.MaterialStream;
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
end ms;

model CR
  extends Simulator.UnitOperations.ConversionReactor;
  extends Simulator.Files.Models.ReactionManager.ConversionReaction;
end CR;

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
    parameter data.Diethylether dieth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {dieth, eth, wat};
  Simulator.UnitOperations.Mixer MIX_01(C = C, NI = 2, Nc = Nc, outPress = "Inlet_Average")  annotation(
      Placement(visible = true, transformation(origin = {-48, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.CR REACT_01(BC_r = {2}, C = C, CalcMode = "Define_Out_Temperature", Coef_cr = {{1}, {-2}, {1}}, Nc = Nc, Nr = 1, Tdef = 298.15, X_r = {0.5})  annotation(
      Placement(visible = true, transformation(origin = {38, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.rigDist.DistColumn DC_01(C = C, Ctype = "Total", InT_s = {4}, Nc = Nc, Ni = 1, Nt = 8)  annotation(
      Placement(visible = true, transformation(origin = {66, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.rigDist.DistColumn DC_02(C = C, Ctype = "Total", InT_s = {7}, Nc = Nc, Ni = 1, Nt = 10)  annotation(
      Placement(visible = true, transformation(origin = {-48, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  ms S_01(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-84, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.ms S_02(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-86, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms S_03(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-8, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms S_04(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.ms S_05(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {10, -4}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.ms S_06(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {8, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.ms S_07(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-106, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  DiethylEther_from_Ethanol.ms S_08(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-106, -66}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E_01 annotation(
      Placement(visible = true, transformation(origin = {20, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E_02 annotation(
      Placement(visible = true, transformation(origin = {18, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E_03 annotation(
      Placement(visible = true, transformation(origin = {10, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E_04 annotation(
      Placement(visible = true, transformation(origin = {-92, 22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E_05 annotation(
      Placement(visible = true, transformation(origin = {-106, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(S_06.Out, DC_02.In_s[1]) annotation(
      Line(points = {{-2, -70}, {-6, -70}, {-6, -38}, {-22, -38}, {-22, -38}}, color = {0, 70, 70}));
    connect(E_05.Out, DC_02.Rduty) annotation(
      Line(points = {{-96, -98}, {-74, -98}, {-74, -98}, {-72, -98}}, color = {255, 0, 0}));
    connect(E_02.Out, DC_01.Rduty) annotation(
      Line(points = {{28, -98}, {40, -98}, {40, -98}, {42, -98}}, color = {255, 0, 0}));
    connect(DC_02.Cduty, E_04.In) annotation(
      Line(points = {{-72, 22}, {-82, 22}}, color = {255, 0, 0}));
    connect(DC_01.Cduty, E_01.In) annotation(
      Line(points = {{42, 22}, {30, 22}, {30, 8}, {30, 8}}, color = {255, 0, 0}));
    connect(E_03.Out, REACT_01.energy) annotation(
      Line(points = {{20, 28}, {38, 28}, {38, 38}, {38, 38}}, color = {255, 0, 0}));
    connect(S_08.In, DC_02.Bot) annotation(
      Line(points = {{-96, -66}, {-72, -66}, {-72, -68}, {-74, -68}, {-74, -68}}, color = {0, 70, 70}));
    connect(S_07.In, DC_02.Dist) annotation(
      Line(points = {{-96, -8}, {-72, -8}, {-72, -8}, {-72, -8}}, color = {0, 70, 70}));
    connect(S_06.In, DC_01.Bot) annotation(
      Line(points = {{18, -70}, {40, -70}, {40, -68}, {40, -68}}, color = {0, 70, 70}));
    connect(S_05.In, DC_01.Dist) annotation(
      Line(points = {{20, -4}, {40, -4}, {40, -8}, {42, -8}}, color = {0, 70, 70}));
    connect(S_04.Out, DC_01.In_s[1]) annotation(
      Line(points = {{90, 50}, {128, 50}, {128, -38}, {92, -38}, {92, -38}}, color = {0, 70, 70}));
    connect(REACT_01.Out, S_04.In) annotation(
      Line(points = {{48, 50}, {70, 50}, {70, 50}, {70, 50}}, color = {0, 70, 70}));
    connect(S_03.Out, REACT_01.In) annotation(
      Line(points = {{2, 50}, {28, 50}, {28, 50}, {28, 50}, {28, 50}}, color = {0, 70, 70}));
    connect(MIX_01.outlet, S_03.In) annotation(
      Line(points = {{-38, 48}, {-18, 48}, {-18, 50}, {-18, 50}}, color = {0, 70, 70}));
    connect(S_02.Out, MIX_01.inlet[2]) annotation(
      Line(points = {{-76, 40}, {-64, 40}, {-64, 48}, {-58, 48}, {-58, 48}}, color = {0, 70, 70}));
    connect(S_01.Out, MIX_01.inlet[1]) annotation(
      Line(points = {{-74, 66}, {-64, 66}, {-64, 48}, {-58, 48}, {-58, 48}}, color = {0, 70, 70}));
  
    S_01.T = 347.602;
    S_01.P = 101325;
    S_01.F_p[1] = 20.7564;
    S_01.x_pc[1, :] = {0.025052486, 0.81126839, 0.16367913};
    S_02.T = 313.15;
    S_02.P = 101325;
    S_02.F_p[1] = 20;
    S_02.x_pc[1, :] = {0, 0.85, 0.15};
    DC_01.condenser.P = 101325;
    DC_01.reboiler.P = 101325;
    DC_01.RR = 3;
    S_06.F_p[1] = 30.7662;
    DC_02.condenser.P = 101325;
    DC_02.reboiler.P = 101325;
    DC_02.RR = 2;
    S_08.F_p[1] = 14.7189;
  end Flowsheet;

end DiethylEther_from_Ethanol;
