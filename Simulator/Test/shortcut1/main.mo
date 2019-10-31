within Simulator.Test.shortcut1;

model main
  //use non linear solver homotopy for solving
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Benzene benz;
  parameter data.Toluene tol;
  parameter Integer NOC = 2;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
  Simulator.Test.shortcut1.ms feed(NOC = NOC, comp = comp, compMolFrac(start = {{0.5, 0.5}, {0.34, 0.65}, {0.56, 0.44}})) annotation(
    Placement(visible = true, transformation(origin = {-79, 15}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Simulator.Test.shortcut1.ms bottoms(NOC = NOC, comp = comp, T(start = 383.08), compMolFrac(start = {{0.01, 0.99}, {0.01, 0.99}, {0, 0}})) annotation(
    Placement(visible = true, transformation(origin = {64, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Test.shortcut1.ms distillate(NOC = NOC, comp = comp, T(start = 353.83), compMolFrac(start = {{0.99, 0.01}, {0.99, 0.01}, {0, 0}})) annotation(
    Placement(visible = true, transformation(origin = {66, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.Energy_Stream Condensor_Duty annotation(
    Placement(visible = true, transformation(origin = {54, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.Energy_Stream Reboiler_Duty annotation(
    Placement(visible = true, transformation(origin = {62, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Shortcut shortcut1(NOC = NOC, comp = comp, HKey = 2, LKey = 1) annotation(
    Placement(visible = true, transformation(origin = {-20, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(feed.outlet, shortcut1.feed) annotation(
    Line(points = {{-66, 15}, {-46, 15}, {-46, 16}}));
  connect(shortcut1.condenser_duty, Condensor_Duty.inlet) annotation(
    Line(points = {{10, 78}, {24, 78}, {24, 80}, {44, 80}}, color = {255, 0, 0}));
  connect(shortcut1.reboiler_duty, Reboiler_Duty.outlet) annotation(
    Line(points = {{6, -44}, {24, -44}, {24, -60}, {52, -60}, {52, -60}}, color = {255, 0, 0}));
  connect(shortcut1.distillate, distillate.inlet) annotation(
    Line(points = {{6, 44}, {30, 44}, {30, 56}, {56, 56}, {56, 56}}));
  connect(shortcut1.bottoms, bottoms.inlet) annotation(
    Line(points = {{6, -12}, {54, -12}, {54, -18}, {54, -18}}));
  feed.P = 101325;
  feed.T = 370;
  feed.compMolFrac[1, :] = {0.5, 0.5};
  feed.totMolFlo[1] = 100;
  shortcut1.rebP = 101325;
  shortcut1.condP = 101325;
  shortcut1.mixMolFrac[2, shortcut1.LKey] = 0.01;
  shortcut1.mixMolFrac[3, shortcut1.HKey] = 0.01;
  shortcut1.actR = 2;
end main;
