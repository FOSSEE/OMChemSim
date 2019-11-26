within Simulator.Examples;

package Mixer
  extends Modelica.Icons.ExamplesPackage;
  model ms
    //This model will be instantiated in maintest model as material streams
    extends Simulator.Streams.MaterialStream;
    //material stream extended
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //thermodynamic package Raoults law is extended
  end ms;

  model mix
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethanol eth;
    parameter data.Methanol meth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
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
    Simulator.UnitOperations.Mixer mixer1(Nc = Nc, NI = 6, C = C, outPress = "Inlet_Average") annotation(
      Placement(visible = true, transformation(origin = {-8, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    ms out1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  
  equation
    connect(mixer1.outlet, out1.In) annotation(
      Line(points = {{12, 2}, {52, 2}, {52, 2}, {52, 2}}, color = {0, 70, 70}));
    connect(ms6.Out, mixer1.inlet[6]) annotation(
      Line(points = {{-72, -86}, {-28, -86}, {-28, 2}, {-28, 2}}, color = {0, 70, 70}));
    connect(ms5.Out, mixer1.inlet[5]) annotation(
      Line(points = {{-74, -52}, {-28, -52}, {-28, 2}, {-28, 2}}, color = {0, 70, 70}));
    connect(ms4.Out, mixer1.inlet[4]) annotation(
      Line(points = {{-74, -16}, {-28, -16}, {-28, 2}, {-28, 2}}, color = {0, 70, 70}));
    connect(ms3.Out, mixer1.inlet[3]) annotation(
      Line(points = {{-76, 24}, {-28, 24}, {-28, 2}, {-28, 2}}, color = {0, 70, 70}));
    connect(ms2.Out, mixer1.inlet[2]) annotation(
      Line(points = {{-74, 58}, {-28, 58}, {-28, 2}, {-28, 2}}, color = {0, 70, 70}));
    connect(ms1.Out, mixer1.inlet[1]) annotation(
      Line(points = {{-74, 88}, {-28, 88}, {-28, 2}, {-28, 2}}, color = {0, 70, 70}));
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
