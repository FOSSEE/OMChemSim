within Simulator.Test;

package split
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model main
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer NOC = 2;
    parameter data.General_Properties comp[NOC] = {benz, tol};
    ms inlet(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms outlet1(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {38, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms outlet2(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {38, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Splitter split(NOC = NOC, comp = comp, NO = 2, calcType = "Molar_Flow") annotation(
      Placement(visible = true, transformation(origin = {-12, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(outlet2.inlet, split.outlet[2]) annotation(
      Line(points = {{28, -58}, {16, -58}, {16, 12}, {-2, 12}, {-2, 12}}));
    connect(outlet1.inlet, split.outlet[1]) annotation(
      Line(points = {{28, 56}, {12, 56}, {12, 12}, {-2, 12}, {-2, 12}}));
    connect(inlet.outlet, split.inlet) annotation(
      Line(points = {{-70, 10}, {-24, 10}, {-24, 10}, {-24, 10}}));
//  connect(split.outlet[1], outlet1.inlet);
//  connect(split.outlet[2], outlet2.inlet);
    inlet.P = 101325;
    inlet.T = 300;
    inlet.compMolFrac[1, :] = {0.5, 0.5};
    inlet.totMolFlo[1] = 100;
    split.specVal = {20, 80};
  end main;
end split;
