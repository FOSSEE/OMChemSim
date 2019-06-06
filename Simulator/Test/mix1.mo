within Simulator.Test;

package mix1
  model ms
    //This model will be instantiated in maintest model as material streams
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end ms;

  model mix
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Ethanol eth;
    parameter data.Methanol meth;
    parameter data.Water wat;
    parameter Integer NOC = 3;
    parameter data.General_Properties comp[NOC] = {meth, eth, wat};
    ms ms1(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-84, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms2(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-84, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms3(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-86, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms4(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-84, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms5(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-84, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms6(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Unit_Operations.Mixer mixer1(NOC = NOC, NI = 6, comp = comp, outPress = "Inlet_Average") annotation(
      Placement(visible = true, transformation(origin = {0, 2}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
    ms out1(NOC = NOC, comp = comp, T(start = 354), totMolFlo(start = 1600)) annotation(
      Placement(visible = true, transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(mixer1.outlet, out1.inlet) annotation(
      Line(points = {{26, 2}, {52, 2}, {52, 2}, {52, 2}}));
    connect(ms6.outlet, mixer1.inlet[6]) annotation(
      Line(points = {{-72, -86}, {-34, -86}, {-34, -20}, {-26, -20}, {-26, -20}}));
    connect(ms5.outlet, mixer1.inlet[5]) annotation(
      Line(points = {{-74, -52}, {-44, -52}, {-44, -12}, {-26, -12}, {-26, -12}}));
    connect(ms4.outlet, mixer1.inlet[4]) annotation(
      Line(points = {{-74, -16}, {-50, -16}, {-50, -2}, {-26, -2}, {-26, -4}}));
    connect(ms3.outlet, mixer1.inlet[3]) annotation(
      Line(points = {{-76, 24}, {-50, 24}, {-50, 6}, {-26, 6}, {-26, 8}}));
    connect(ms2.outlet, mixer1.inlet[2]) annotation(
      Line(points = {{-74, 58}, {-44, 58}, {-44, 16}, {-26, 16}, {-26, 16}}));
    connect(ms1.outlet, mixer1.inlet[1]) annotation(
      Line(points = {{-74, 88}, {-26, 88}, {-26, 25}}));
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
    ms1.totMolFlo[1] = 100;
    ms2.totMolFlo[1] = 100;
    ms3.totMolFlo[1] = 300;
    ms4.totMolFlo[1] = 500;
    ms5.totMolFlo[1] = 400;
    ms6.totMolFlo[1] = 200;
    ms1.compMolFrac[1, :] = {0.25, 0.25, 0.5};
    ms2.compMolFrac[1, :] = {0, 0, 1};
    ms3.compMolFrac[1, :] = {0.3, 0.3, 0.4};
    ms4.compMolFrac[1, :] = {0.25, 0.25, 0.5};
    ms5.compMolFrac[1, :] = {0.2, 0.4, 0.4};
    ms6.compMolFrac[1, :] = {0, 1, 0};
  end mix;
end mix1;
