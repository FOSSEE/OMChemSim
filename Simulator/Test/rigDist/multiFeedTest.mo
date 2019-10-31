within Simulator.Test.rigDist;

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
