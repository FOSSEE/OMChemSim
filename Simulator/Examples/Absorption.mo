within Simulator.Examples;

package Absorption
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model Tray
    extends Simulator.UnitOperations.AbsorptionColumn.AbsTray;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Tray;

  model AbsColumn
    extends Simulator.UnitOperations.AbsorptionColumn.AbsCol;
    Tray tray[Nt](each Nc = Nc, each C = C);
  end AbsColumn;

  model Test
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter Integer Nc = 3;
    parameter data.Acetone acet;
    parameter data.Air air;
    parameter data.Water wat;
    parameter data.GeneralProperties C[Nc] = {acet, air, wat};
    Simulator.Examples.Absorption.ms water(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-90, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Absorption.ms air_acetone(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-88, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Absorption.AbsColumn abs(Nc = Nc, C = C, Nt = 10) annotation(
      Placement(visible = true, transformation(origin = {-20, -6}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    Simulator.Examples.Absorption.ms top(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Absorption.ms bottom(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {70, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(air_acetone.Out, abs.In_Bot) annotation(
      Line(points = {{-78, -84}, {-69, -84}, {-69, -54}, {-60, -54}}));
  connect(water.Out, abs.In_Top) annotation(
      Line(points = {{-80, 66}, {-69, 66}, {-69, 42}, {-60, 42}}));
  connect(abs.Out_Top, top.In) annotation(
      Line(points = {{20, 42}, {38, 42}, {38, 62}, {52, 62}}));
  connect(abs.Out_Bot, bottom.In) annotation(
      Line(points = {{20, -54}, {36.5, -54}, {36.5, -86}, {60, -86}}));
    water.P = 101325;
    water.T = 325;
    water.F_p[1] = 30;
    water.x_pc[1, :] = {0, 0, 1};
    air_acetone.P = 101325;
    air_acetone.T = 335;
    air_acetone.F_p[1] = 30;
    air_acetone.x_pc[1, :] = {0.5, 0.5, 0};
  end Test;
end Absorption;
