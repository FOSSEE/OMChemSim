within Simulator.Test.rigDist;

model Test
  parameter Integer NOC = 2;
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Benzene benz;
  parameter data.Toluene tol;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
  Simulator.Test.rigDist.DistColumn distCol(NOC = NOC, comp = comp, noOfStages = 4, noOfFeeds = 1, feedStages = {3}) annotation(
    Placement(visible = true, transformation(origin = {-22, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Line(points = {{3, 68}, {14.5, 68}, {14.5, 62}, {28, 62}}));
  connect(distCol.reboiler_duty, reb_duty.inlet) annotation(
    Line(points = {{3, -52}, {38, -52}}));
  connect(distCol.bottoms, bottoms.inlet) annotation(
    Line(points = {{3, -22}, {29.5, -22}, {29.5, -16}, {58, -16}}));
  connect(distCol.distillate, distillate.inlet) annotation(
    Line(points = {{3, 38}, {26.5, 38}, {26.5, 22}, {54, 22}}));
  connect(feed.outlet, distCol.feed[1]) annotation(
    Line(points = {{-66, 2}, {-57.5, 2}, {-57.5, 8}, {-47, 8}}));
  feed.P = 101325;
  feed.T = 298.15;
  feed.totMolFlo[1] = 100;
  feed.compMolFrac[1, :] = {0.5, 0.5};
  distCol.condensor.P = 101325;
  distCol.reboiler.P = 101325;
  distCol.refluxRatio = 2;
  bottoms.totMolFlo[1] = 50;
end Test;
