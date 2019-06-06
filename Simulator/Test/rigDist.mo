within Simulator.Test;

package rigDist
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
    Condensor condensor(NOC = NOC, comp = comp, condType = condType, boolFeed = boolFeed[1], T(start = 300));
    Reboiler reboiler(NOC = NOC, comp = comp, boolFeed = boolFeed[noOfStages]);
    Tray tray[noOfStages - 2](each NOC = NOC, each comp = comp, boolFeed = boolFeed[2:noOfStages - 1], each liqMolFlo(each start = 150), each vapMolFlo(each start = 150));
  end DistColumn;

  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model Test
    parameter Integer NOC = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
    DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 4, noOfFeeds = 1, feedStages = {3}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.condensor_duty, cond_duty.inlet) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.bottoms, bottoms.inlet) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.distillate, distillate.inlet) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.outlet, distCol.feed[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.totMolFlo[1] = 100;
    feed.compMolFrac[1, :] = {0.5, 0.5};
    distCol.condensor.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.refluxRatio = 2;
    bottoms.totMolFlo[1] = 50;
  end Test;

  model Test2
    parameter Integer NOC = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
    DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 12, noOfFeeds = 1, feedStages = {7}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.condensor_duty, cond_duty.inlet) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.bottoms, bottoms.inlet) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.distillate, distillate.inlet) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.outlet, distCol.feed[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.totMolFlo[1] = 100;
    feed.compMolFrac[1, :] = {0.5, 0.5};
    distCol.condensor.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.refluxRatio = 2;
    bottoms.totMolFlo[1] = 50;
  end Test2;

  model Test3
    parameter Integer NOC = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
    DistColumn distCol(NOC = NOC, comp = comp, noOfFeeds = 1, noOfStages = 22, feedStages = {10}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.condensor_duty, cond_duty.inlet) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.bottoms, bottoms.inlet) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.distillate, distillate.inlet) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.outlet, distCol.feed[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.totMolFlo[1] = 100;
    feed.compMolFrac[1, :] = {0.3, 0.7};
    distCol.condensor.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.refluxRatio = 1.5;
    bottoms.totMolFlo[1] = 70;
  end Test3;

  model Test4
    parameter Integer NOC = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
    DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 22, noOfFeeds = 1, feedStages = {10}, condensor.condType = "Partial", each tray.liqMolFlo(each start = 100), each tray.vapMolFlo(each start = 100)) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.condensor_duty, cond_duty.inlet) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.bottoms, bottoms.inlet) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.distillate, distillate.inlet) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.outlet, distCol.feed[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.totMolFlo[1] = 96.8;
    feed.compMolFrac[1, :] = {0.3, 0.7};
    distCol.condensor.P = 151325;
    distCol.reboiler.P = 101325;
    distCol.refluxRatio = 1.5;
    bottoms.totMolFlo[1] = 70;
  end Test4;

  model multiFeedTest
    parameter Integer NOC = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
    DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 5, noOfFeeds = 2, feedStages = {3, 4}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms1(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(ms1.outlet, distCol.feed[2]) annotation(
      Line(points = {{-70, 50}, {-26, 50}, {-26, 2}, {-28, 2}}));
    connect(distCol.condensor_duty, cond_duty.inlet) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.bottoms, bottoms.inlet) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.distillate, distillate.inlet) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.outlet, distCol.feed[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.totMolFlo[1] = 100;
    feed.compMolFrac[1, :] = {0.5, 0.5};
    distCol.condensor.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.refluxRatio = 2;
    bottoms.totMolFlo[1] = 50;
    ms1.P = 101325;
    ms1.T = 298.15;
    ms1.totMolFlo[1] = 100;
    ms1.compMolFrac[1, :] = {0.5, 0.5};
  end multiFeedTest;
end rigDist;
