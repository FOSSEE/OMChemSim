within Simulator.Test;

package shortcut1
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model Shortcut
    extends Simulator.Unit_Operations.Shortcut_Column;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end Shortcut;

  model main
    //use non linear solver homotopy for solving
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer NOC = 2;
    parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] = {benz, tol};
    Simulator.Test.shortcut1.Shortcut shortcut(NOC = NOC, comp = comp, condType = "Partial", HKey = 2, LKey = 1, mixMolFrac(start = {{0.5, 0.5}, {0.01, 0.99}, {0.99, 0.01}}), minN(start = 9.1859), theta(start = 1, min = 1), minR(start = 2, min = 0)) annotation(
      Placement(visible = true, transformation(origin = {2, 4}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
    ms feed(NOC = NOC, comp = comp, compMolFrac(start = {{0.5, 0.5}, {0.34, 0.65}, {0.56, 0.44}})) annotation(
      Placement(visible = true, transformation(origin = {-74, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(NOC = NOC, comp = comp, T(start = 383.08), compMolFrac(start = {{0.01, 0.99}, {0.01, 0.99}, {0, 0}})) annotation(
      Placement(visible = true, transformation(origin = {76, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(NOC = NOC, comp = comp, T(start = 353.83), compMolFrac(start = {{0.99, 0.01}, {0.99, 0.01}, {0, 0}})) annotation(
      Placement(visible = true, transformation(origin = {76, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Condensor_Duty annotation(
      Placement(visible = true, transformation(origin = {40, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Reboiler_Duty annotation(
      Placement(visible = true, transformation(origin = {-8, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(shortcut.reboiler_duty, Reboiler_Duty.outlet) annotation(
      Line(points = {{18, -26}, {18, -55}, {2, -55}, {2, -84}}));
    connect(Condensor_Duty.inlet, shortcut.condenser_duty) annotation(
      Line(points = {{30, 76}, {30, 57}, {18, 57}, {18, 34}}));
    connect(shortcut.distillate, distillate.inlet) annotation(
      Line(points = {{32, 20}, {50, 20}, {50, 38}, {66, 38}}));
    connect(shortcut.bottoms, bottoms.inlet) annotation(
      Line(points = {{32, -10}, {51, -10}, {51, -28}, {66, -28}}));
    connect(feed.outlet, shortcut.feed) annotation(
      Line(points = {{-64, 4}, {-30, 4}, {-30, 4}, {-28, 4}}));
    feed.P = 101325;
    feed.T = 370;
    feed.compMolFrac[1, :] = {0.5, 0.5};
    feed.totMolFlo[1] = 100;
    shortcut.rebP = 101325;
    shortcut.condP = 101325;
    shortcut.mixMolFrac[2, shortcut.LKey] = 0.01;
    shortcut.mixMolFrac[3, shortcut.HKey] = 0.01;
    shortcut.actR = 2;
  end main;
end shortcut1;
