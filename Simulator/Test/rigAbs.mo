within Simulator.Test;

package rigAbs
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model Tray
    extends Simulator.Unit_Operations.Absorption_Column.AbsTray;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end Tray;

  model AbsColumn
    extends Simulator.Unit_Operations.Absorption_Column.AbsCol;
    Tray tray[noOfStages](each NOC = NOC, each comp = comp, each liqMolFlo(each start = 30), each vapMolFlo(each start = 30), each T(start = 300));
  end AbsColumn;

  model Test
    import data = Simulator.Files.Chemsep_Database;
    parameter Integer NOC = 3;
    parameter data.Acetone acet;
    parameter data.Air air;
    parameter data.Water wat;
    parameter data.General_Properties comp[NOC] = {acet, air, wat};
    rigAbs.ms water(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-70, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms air_acetone(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-70, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    rigAbs.AbsColumn abs(NOC = NOC, comp = comp, noOfStages = 10) annotation(
      Placement(visible = true, transformation(origin = {-3, 11}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
    ms top(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {62, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottom(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {66, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(abs.bottom_product, bottom.inlet) annotation(
      Line(points = {{30, -16}, {42, -16}, {42, -50}, {56, -50}, {56, -52}}));
    connect(abs.top_product, top.inlet) annotation(
      Line(points = {{30, 38}, {40, 38}, {40, 60}, {52, 60}, {52, 60}}));
    connect(air_acetone.outlet, abs.bottom_feed) annotation(
      Line(points = {{-60, -56}, {-52, -56}, {-52, -14}, {-36, -14}, {-36, -16}}));
    connect(water.outlet, abs.top_feed) annotation(
      Line(points = {{-60, 62}, {-48, 62}, {-48, 38}, {-36, 38}, {-36, 38}}));
    water.P = 101325;
    water.T = 325;
    water.totMolFlo[1] = 30;
    water.compMolFrac[1, :] = {0, 0, 1};
    air_acetone.P = 101325;
    air_acetone.T = 335;
    air_acetone.totMolFlo[1] = 30;
    air_acetone.compMolFrac[1, :] = {0.5, 0.5, 0};
  end Test;
end rigAbs;
