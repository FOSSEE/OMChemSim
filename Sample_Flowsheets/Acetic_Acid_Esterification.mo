package Acetic_Acid_Esterification

model ms
  extends Simulator.Streams.MaterialStream;
  extends Simulator.Files.ThermodynamicPackages.NRTL;
end ms;

model Fls
  extends Simulator.UnitOperations.Flash;
  extends Simulator.Files.ThermodynamicPackages.NRTL;
end Fls;

model Conv_React
  extends Simulator.UnitOperations.ConversionReactor;
  extends Simulator.Files.Models.ReactionManager.ConversionReaction;
end Conv_React;

model Flowsheet

  import data = Simulator.Files.ChemsepDatabase;
  parameter Integer Nc = 4;
  parameter data.Ethylacetate etac;
  parameter data.Water wat;
  parameter data.Aceticacid aa;
  parameter data.Ethanol eth;
  parameter data.GeneralProperties C[Nc] = {etac, wat, aa, eth};
  Simulator.UnitOperations.Mixer MIX_01(C = C, NI = 3, Nc = Nc, outPress = "Inlet_Average")  annotation(
      Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification.Conv_React CR_01(BC_r = {3},C = C, CalcMode = "Define_Out_Temperature", Coef_cr = {{1}, {1}, {-1}, {-1}}, Nc = Nc, Nr = 1, Tdef = 300, X_r = {0.6})  annotation(
      Placement(visible = true, transformation(origin = {16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.UnitOperations.Splitter SPLIT_01(C = C, CalcType = "Split_Ratio", Nc = Nc, No = 2)  annotation(
      Placement(visible = true, transformation(origin = {82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification.ms S_01(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-88, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification.ms S_02(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-88, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification.ms S_03(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {-18, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms S_04(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification.ms S_05(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {116, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification.ms S_06(C = C, Nc = Nc)  annotation(
      Placement(visible = true, transformation(origin = {116, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(S_05.Out, MIX_01.inlet[3]) annotation(
      Line(points = {{126, 24}, {140, 24}, {140, 50}, {-114, 50}, {-114, 0}, {-58, 0}, {-58, 0}}, color = {0, 70, 70}));
    connect(SPLIT_01.Out[1], S_05.In) annotation(
      Line(points = {{92, 0}, {106, 0}, {106, 24}}, color = {0, 70, 70}));
    connect(SPLIT_01.Out[2], S_06.In) annotation(
      Line(points = {{92, 0}, {106, 0}, {106, -28}}, color = {0, 70, 70}));
    connect(S_04.Out, SPLIT_01.In) annotation(
      Line(points = {{58, 0}, {72, 0}, {72, 0}, {72, 0}}, color = {0, 70, 70}));
    connect(CR_01.Out, S_04.In) annotation(
      Line(points = {{26, 0}, {38, 0}, {38, 0}, {38, 0}}, color = {0, 70, 70}));
    connect(S_03.Out, CR_01.In) annotation(
      Line(points = {{-8, 0}, {6, 0}, {6, 0}, {6, 0}}, color = {0, 70, 70}));
    connect(MIX_01.outlet, S_03.In) annotation(
      Line(points = {{-38, 0}, {-28, 0}, {-28, 0}, {-28, 0}}, color = {0, 70, 70}));
    connect(S_02.Out, MIX_01.inlet[2]) annotation(
      Line(points = {{-78, -30}, {-58, -30}, {-58, 0}, {-58, 0}}, color = {0, 70, 70}));
    connect(S_01.Out, MIX_01.inlet[1]) annotation(
      Line(points = {{-78, 26}, {-58, 26}, {-58, 0}, {-58, 0}}, color = {0, 70, 70}));
  
    S_01.P = 101325;
    S_01.T = 300;
    S_01.x_pc[1, :] = {0, 0, 0, 1};
    S_01.F_p[1] = 60;
    S_02.P = 101325;
    S_02.T = 300;
    S_02.x_pc[1, :] = {0, 0, 1, 0};
    S_02.F_p[1] = 40;
    SPLIT_01.SpecVal_s = {0.75, 0.25};

end Flowsheet;

end Acetic_Acid_Esterification;
