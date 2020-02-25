package Acetic_Acid_Esterification_by_Ethanol
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.NRTL;
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
      Placement(visible = true, transformation(origin = {-168, 42}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Acetic_Acid_Esterification_by_Ethanol.ms acetic_acid(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-132, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Unit_Operations.Mixer mix(NOC = NOC, comp = comp, NI = 3, outPress = "Inlet_Average") annotation(
      Placement(visible = true, transformation(origin = {-65, 57}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms reactor_feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-34, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.Conv_React CR(NOC = NOC, comp = comp, Nr = 1, Bc = {3}, Sc = {{1}, {1}, {-1}, {-1}}, X = {0.6}, calcMode = "Define_Outlet_Temperature", Tdef = 300) annotation(
      Placement(visible = true, transformation(origin = {19, 63}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms reactor_out(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {52, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Splitter split(NOC = NOC, comp = comp, NO = 2, calcType = "Split_Ratio") annotation(
      Placement(visible = true, transformation(origin = {106, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms recycle(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {162, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Acetic_Acid_Esterification_by_Ethanol.ms product(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {172, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
    connect(recycle.inlet, split.outlet[2]) annotation(
      Line(points = {{152, 28}, {140, 28}, {140, 4}, {116, 4}, {116, 4}}, color = {0, 70, 70}));
    connect(split.outlet[1], product.inlet) annotation(
      Line(points = {{116, 4}, {140, 4}, {140, -14}, {162, -14}, {162, -14}}, color = {0, 70, 70}));
    connect(reactor_out.outlet, split.inlet) annotation(
      Line(points = {{62, 4}, {96, 4}, {96, 4}, {96, 4}}, color = {0, 70, 70}));
    connect(CR.outlet, reactor_out.inlet) annotation(
      Line(points = {{16, 6}, {42, 6}, {42, 4}, {42, 4}}, color = {0, 70, 70}));
    connect(reactor_feed.outlet, CR.inlet) annotation(
      Line(points = {{-24, 6}, {-10, 6}, {-10, 6}, {-10, 6}}, color = {0, 70, 70}));
    connect(mix.outlet, reactor_feed.inlet) annotation(
      Line(points = {{-64, 2}, {-44, 2}, {-44, 6}, {-44, 6}}, color = {0, 70, 70}));
    connect(recycle.outlet, mix.inlet[3]) annotation(
      Line(points = {{172, 28}, {196, 28}, {196, 70}, {-166, 70}, {-166, 0}, {-90, 0}, {-90, 2}}, color = {0, 70, 70}));
    connect(acetic_acid.outlet, mix.inlet[2]) annotation(
      Line(points = {{-122, -26}, {-106, -26}, {-106, 0}, {-90, 0}, {-90, 2}}, color = {0, 70, 70}));
    connect(ethanol.outlet, mix.inlet[1]) annotation(
      Line(points = {{-114, 30}, {-106, 30}, {-106, 0}, {-90, 0}, {-90, 2}}, color = {0, 70, 70}));
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
    extends Simulator.UnitOperations.ConversionReactor;
    extends Simulator.Files.Models.ReactionManager.ReactionManager;
  end Conv_React;

  model Fls
    extends Simulator.UnitOperations.Flash;
    extends Simulator.Files.ThermodynamicPackages.NRTL;
  end Fls;

end Acetic_Acid_Esterification_by_Ethanol;
