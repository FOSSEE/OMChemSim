within Simulator.Test.rigDist;

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
