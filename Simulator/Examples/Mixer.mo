within Simulator.Examples;

package Mixer
  extends Modelica.Icons.ExamplesPackage;
  model ms
    //This model will be instantiated in maintest model as material streams
    extends Simulator.Streams.MaterialStream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end ms;

  model mix
    extends Modelica.Icons.Example;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Ethanol eth;
    parameter data.Methanol meth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.General_Properties C[Nc] = {meth, eth, wat};
    ms ms1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-86, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms4(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms5(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms6(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Mixer mixer1(Nc = Nc, NI = 6, C = C, outPress = "Inlet_Average") annotation(
      Placement(visible = true, transformation(origin = {-8, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    ms out1(Nc = Nc, C = C, T(start = 354), F_p(start = 1600)) annotation(
      Placement(visible = true, transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(mixer1.outlet, out1.inlet) annotation(
      Line(points = {{12, 2}, {52, 2}}));
  connect(ms6.outlet, mixer1.inlet[6]) annotation(
      Line(points = {{-72, -86}, {-28, -86}, {-28, 2}}));
  connect(ms5.outlet, mixer1.inlet[5]) annotation(
      Line(points = {{-74, -52}, {-44, -52}, {-44, 2}, {-28, 2}}));
  connect(ms4.outlet, mixer1.inlet[4]) annotation(
      Line(points = {{-74, -16}, {-50, -16}, {-50, 2}, {-28, 2}}));
  connect(ms3.outlet, mixer1.inlet[3]) annotation(
      Line(points = {{-76, 24}, {-50, 24}, {-50, 2}, {-28, 2}}));
  connect(ms2.outlet, mixer1.inlet[2]) annotation(
      Line(points = {{-74, 58}, {-44, 58}, {-44, 2}, {-28, 2}}));
  connect(ms1.outlet, mixer1.inlet[1]) annotation(
      Line(points = {{-74, 88}, {-28, 88}, {-28, 2}}));
  equation
    ms1.P = 101325;
    ms2.P = 202650;
    ms3.P = 126523;
    ms4.P = 215365;
    ms5.P = 152365;
    ms6.P = 152568;
    ms1.T = 353;
    ms2.T = 353;
    ms3.T = 353;
    ms4.T = 353;
    ms5.T = 353;
    ms6.T = 353;
    ms1.F_p[1] = 100;
    ms2.F_p[1] = 100;
    ms3.F_p[1] = 300;
    ms4.F_p[1] = 500;
    ms5.F_p[1] = 400;
    ms6.F_p[1] = 200;
    ms1.x_pc[1, :] = {0.25, 0.25, 0.5};
    ms2.x_pc[1, :] = {0, 0, 1};
    ms3.x_pc[1, :] = {0.3, 0.3, 0.4};
    ms4.x_pc[1, :] = {0.25, 0.25, 0.5};
    ms5.x_pc[1, :] = {0.2, 0.4, 0.4};
    ms6.x_pc[1, :] = {0, 1, 0};
  end mix;
end Mixer;
