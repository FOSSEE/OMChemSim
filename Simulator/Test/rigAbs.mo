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
    Simulator.Test.rigAbs.ms water(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-90, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.rigAbs.ms air_acetone(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-88, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.rigAbs.AbsColumn abs(NOC = NOC, comp = comp, noOfStages = 10) annotation(
      Placement(visible = true, transformation(origin = {-20, -6}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    Simulator.Test.rigAbs.ms top(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {62, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.rigAbs.ms bottom(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {70, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(air_acetone.outlet, abs.bottom_feed) annotation(
      Line(points = {{-78, -84}, {-69, -84}, {-69, -54}, {-60, -54}}));
  connect(water.outlet, abs.top_feed) annotation(
      Line(points = {{-80, 66}, {-69, 66}, {-69, 42}, {-60, 42}}));
  connect(abs.top_product, top.inlet) annotation(
      Line(points = {{20, 42}, {38, 42}, {38, 62}, {52, 62}}));
  connect(abs.bottom_product, bottom.inlet) annotation(
      Line(points = {{20, -54}, {36.5, -54}, {36.5, -86}, {60, -86}}));
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
