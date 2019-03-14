package Diethyl_Ether
  model Feed_PR
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Peng_Robinson;
    //thermodynamic package Raoults law is extended
  end Feed_PR;

  model Feed_Raoults
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end Feed_Raoults;

  model Feed_Grayson
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Grayson_Streed.GraysonStreed;
    //thermodynamic package Raoults law is extended
  end Feed_Grayson;

  model Shortcut
    extends Simulator.Unit_Operations.Shortcut_Column;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end Shortcut;

  package DC
    model Condensor
      extends Simulator.Unit_Operations.Distillation_Column.Cond;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Condensor;

    model Tray
      extends Simulator.Unit_Operations.Distillation_Column.DistTray;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Tray;

    model Reboiler
      extends Simulator.Unit_Operations.Distillation_Column.Reb;
      extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    end Reboiler;

    model DistColumn
      extends Simulator.Unit_Operations.Distillation_Column.DistCol;
      Condensor condensor(NOC = NOC, comp = comp, condType = condType, T(start = 300));
      Reboiler reboiler(NOC = NOC, comp = comp);
      Tray tray[noOfStages - 2](each NOC = NOC, each comp = comp, each liqMolFlo(each start = 150), each vapMolFlo(each start = 150));
    end DistColumn;
  end DC;

  model Reactor
    extends Simulator.Unit_Operations.Conversion_Reactor;
    extends Simulator.Files.Models.ReactionManager.Reaction_Manager;
  end Reactor;

  model Flowsheet
    //Distillation column
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of Siethylether
    parameter data.Diethylether dieth;
    //instantiation of Ethanol
    parameter data.Ethanol eth;
    //instantiation of Water
    parameter data.Water wat;
    //Number of Components
    parameter Integer NOC = 3;
    parameter data.General_Properties comp[NOC] = {dieth, eth, wat};
    Simulator.Unit_Operations.Mixer Mixer(NI = 2, NOC = NOC, comp = comp, outPress = "Inlet_Average", outT(start = 300)) annotation(
      Placement(visible = true, transformation(origin = {-52, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Reactor CReactor(NOC = NOC, comp = comp, Nr = 1, Bc = {2}, Sc = {{1}, {-2}, {1}}, X = {0.50}, calcMode = "Define_Outlet_Temperature", Tdef = 298.15) annotation(
      Placement(visible = true, transformation(origin = {26, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream E_I annotation(
      Placement(visible = true, transformation(origin = {43, 53}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    Simulator.Streams.Energy_Stream C_duty annotation(
      Placement(visible = true, transformation(origin = {-46, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream R_duty annotation(
      Placement(visible = true, transformation(origin = {-26, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults S_I(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-96, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults S_II(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-96, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Feed_Raoults S_III(NOC = NOC, comp = comp, totMolFlo(each start = 50), T(start = 300)) annotation(
      Placement(visible = true, transformation(origin = {-10, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults S_IV(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {74, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults Distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-8, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults Bottoms(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-12, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults Distillate_II(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {98, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.Feed_Raoults Bottoms_II(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {98, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream C_duty_II annotation(
      Placement(visible = true, transformation(origin = {52, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream R_duty_II annotation(
      Placement(visible = true, transformation(origin = {50, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Diethyl_Ether.DC.DistColumn DC_I(NOC = NOC, comp = comp, noOfStages = 8, feedStages = {4}, each tray.liqMolFlo(each start = 60), each tray.vapMolFlo(each start = 40), each tray.T(start = 380)) annotation(
      Placement(visible = true, transformation(origin = {-75, -43}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
    Diethyl_Ether.DC.DistColumn DC_II(NOC = NOC, comp = comp, noOfStages = 10, feedStages = {7}, each tray.liqMolFlo(each start = 35), each tray.vapMolFlo(each start = 50), each tray.T(start = 380)) annotation(
      Placement(visible = true, transformation(origin = {46, -42}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  equation
    connect(CReactor.energy, E_I.inlet) annotation(
      Line(points = {{26, 62}, {26, 53.5}, {36, 53.5}, {36, 53}}));
    connect(S_III.outlet, CReactor.inlet) annotation(
      Line(points = {{0, 72}, {16, 72}}));
    connect(CReactor.outlet, S_IV.inlet) annotation(
      Line(points = {{36, 72}, {64, 72}}));
    connect(DC_II.reboiler_duty, R_duty_II.inlet) annotation(
      Line(points = {{62, -64}, {62, -64}, {62, -76}, {26, -76}, {26, -92}, {40, -92}, {40, -92}}));
    connect(DC_II.bottoms, Bottoms_II.inlet) annotation(
      Line(points = {{68, -58}, {76, -58}, {76, -68}, {88, -68}, {88, -68}, {88, -68}}));
    connect(DC_II.distillate, Distillate_II.inlet) annotation(
      Line(points = {{68, -26}, {74, -26}, {74, -16}, {88, -16}, {88, -18}, {88, -18}}));
    connect(C_duty_II.inlet, DC_II.condensor_duty) annotation(
      Line(points = {{42, 2}, {20, 2}, {20, -14}, {58, -14}, {58, -20}, {60, -20}}));
    connect(Bottoms.outlet, DC_II.feed[1]) annotation(
      Line(points = {{-2, -58}, {8, -58}, {8, -42}, {24, -42}, {24, -42}}));
    connect(S_IV.outlet, DC_I.feed[1]) annotation(
      Line(points = {{84, 72}, {108, 72}, {108, 20}, {-140, 20}, {-140, -44}, {-96, -44}, {-96, -44}}));
    connect(DC_I.bottoms, Bottoms.inlet) annotation(
      Line(points = {{-54, -58}, {-38, -58}, {-38, -58}, {-22, -58}, {-22, -58}}));
    connect(DC_I.distillate, Distillate.inlet) annotation(
      Line(points = {{-54, -28}, {-40, -28}, {-40, -20}, {-18, -20}, {-18, -20}, {-18, -20}}));
    connect(DC_I.reboiler_duty, R_duty.inlet) annotation(
      Line(points = {{-60, -64}, {-60, -64}, {-60, -90}, {-36, -90}, {-36, -90}}));
    connect(DC_I.condensor_duty, C_duty.inlet) annotation(
      Line(points = {{-62, -22}, {-64, -22}, {-64, -2}, {-56, -2}, {-56, -2}}));
    connect(Mixer.outlet, S_III.inlet) annotation(
      Line(points = {{-42, 70}, {-20, 70}, {-20, 72}, {-20, 72}}));
    connect(S_II.outlet, Mixer.inlet[2]) annotation(
      Line(points = {{-86, 50}, {-62, 50}, {-62, 70}}));
    connect(S_I.outlet, Mixer.inlet[1]) annotation(
      Line(points = {{-86, 82}, {-62, 82}, {-62, 70}}));
    S_I.T = 347.602;
    S_I.P = 101325;
    S_I.totMolFlo[1] = 20.7564;
    S_I.compMolFrac[1, :] = {0.025052486, 0.81126839, 0.16367913};
    S_II.T = 313.15;
    S_II.P = 101325;
    S_II.totMolFlo[1] = 20;
    S_II.compMolFrac[1, :] = {0, 0.85, 0.15};
    DC_I.condensor.P = 101325;
    DC_I.reboiler.P = 101325;
    DC_I.refluxRatio = 3;
    Bottoms.totMolFlo[1] = 30.7662;
    DC_II.condensor.P = 101325;
    DC_II.reboiler.P = 101325;
    DC_II.refluxRatio = 2;
    Bottoms_II.totMolFlo[1] = 14.7189;
  end Flowsheet;

























end Diethyl_Ether;
