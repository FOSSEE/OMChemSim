package Acetic_Acid_Esterification_by_Ethanol
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.NRTL;
  end ms;

  model flowsheet
    import data = Simulator.Files.Chemsep_Database;
    parameter Integer NOC = 4;
    parameter data.Ethylacetate etac;
    parameter data.Water wat;
    parameter data.Aceticacid aa;
    parameter data.Ethanol eth;
    parameter data.General_Properties comp[NOC] = {etac, wat, aa, eth};
  Acetic_Acid_Esterification_by_Ethanol.ms ethanol(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-132, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Acetic_Acid_Esterification_by_Ethanol.ms acetic_acid(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-132, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Unit_Operations.Mixer mix(NOC = NOC, comp = comp, NI = 3, outPress = "Inlet_Average") annotation(
      Placement(visible = true, transformation(origin = {-80, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms reactor_feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-26, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.Conv_React CR(NOC = NOC, comp = comp, Nr = 1, Bc = {3}, Sc = {{1}, {1}, {-1}, {-1}}, X = {0.6}, calcMode = "Define_Outlet_Temperature", Tdef = 300) annotation(
      Placement(visible = true, transformation(origin = {16, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms reactor_out(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {56, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Splitter split(NOC = NOC, comp = comp, NO = 2, calcType = "Split_Ratio") annotation(
      Placement(visible = true, transformation(origin = {106, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms recycle(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {160, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms product(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {162, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
  connect(split.outlet[2], product.inlet) annotation(
      Line(points = {{116.2, 4}, {125.2, 4}, {125.2, -2}, {136.2, -2}, {136.2, -18}, {154.2, -18}, {154.2, -13}, {152.2, -13}, {152.2, -12}}));
  connect(split.outlet[1], recycle.inlet) annotation(
      Line(points = {{116.2, 4}, {126.2, 4}, {126.2, 12}, {136.2, 12}, {136.2, 28}, {150.2, 28}, {150.2, 28}, {150.2, 28}, {150.2, 20}, {150.2, 20}}));
  connect(recycle.outlet, mix.inlet[3]) annotation(
      Line(points = {{170, 28}, {187, 28}, {187, 28}, {204, 28}, {204, 84}, {-208, 84}, {-208, 4}, {-88, 4}, {-88, 4}, {-90, 4}, {-90, 4}}));
  connect(reactor_out.outlet, split.inlet) annotation(
      Line(points = {{66, 4}, {81, 4}, {81, 4}, {98, 4}, {98, 4}, {95, 4}, {95, 4}, {96, 4}}));
  connect(CR.outlet, reactor_out.inlet) annotation(
      Line(points = {{26, 4}, {46, 4}}));
  connect(reactor_feed.outlet, CR.inlet) annotation(
      Line(points = {{-16, 4}, {-5, 4}, {-5, 4}, {8, 4}, {8, 4}, {5, 4}, {5, 4}, {6, 4}}));
  connect(mix.outlet, reactor_feed.inlet) annotation(
      Line(points = {{-70, 3.8}, {-36, 3.8}}));
  connect(ethanol.outlet, mix.inlet[1]) annotation(
      Line(points = {{-122, 34}, {-104, 34}, {-104, 4}, {-90, 4}, {-90, 4}}));
  connect(acetic_acid.outlet, mix.inlet[2]) annotation(
      Line(points = {{-122, -26}, {-114, -26}, {-114, -26}, {-102, -26}, {-102, 4}, {-88, 4}, {-88, 3}, {-90, 3}, {-90, 4}}));
      ethanol.P = 101325;
      ethanol.T = 300;
      ethanol.compMolFrac[1, :] = {0, 0, 0, 1};
      ethanol.totMolFlo[1] = 60;
      acetic_acid.P = 101325;
      acetic_acid.T = 300;
      acetic_acid.compMolFrac[1, :] = {0, 0, 1, 0};
      acetic_acid.totMolFlo[1] = 40;
      split.specVal = {0.75, 0.25};
       
  annotation(
      Diagram(coordinateSystem(extent = {{-220, -100}, {220, 100}})),
      Icon(coordinateSystem(extent = {{-220, -100}, {220, 100}})),
      __OpenModelica_commandLineOptions = "");end flowsheet;





  model Conv_React
    extends Simulator.Unit_Operations.Conversion_Reactor;
    extends Simulator.Files.Models.ReactionManager.Reaction_Manager;
  end Conv_React;

  model Fls
    extends Simulator.Unit_Operations.Flash;
    extends Simulator.Files.Thermodynamic_Packages.NRTL;
  end Fls;

end Acetic_Acid_Esterification_by_Ethanol;
