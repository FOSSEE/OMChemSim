within Simulator.Test;

package flash
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model fls
    extends Simulator.Unit_Operations.Flash;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end fls;

  model test
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer NOC = 2;
    parameter data.General_Properties comp[NOC] = {benz, tol};
    ms inlet(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-70, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    fls fls1(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {-6, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms outlet1(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms outlet2(NOC = NOC, comp = comp) annotation(
      Placement(visible = true, transformation(origin = {58, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(outlet2.inlet, fls1.vapor) annotation(
      Line(points = {{48, 40}, {28, 40}, {28, 10}, {4, 10}, {4, 12}}));
    connect(fls1.liquid, outlet1.inlet) annotation(
      Line(points = {{4, -4}, {32, -4}, {32, -20}, {56, -20}, {56, -20}}));
    connect(inlet.outlet, fls1.feed) annotation(
      Line(points = {{-60, 2}, {-16, 2}, {-16, 4}, {-16, 4}}));
    inlet.P = 101325;
    inlet.T = 368;
    inlet.compMolFrac[1, :] = {0.5, 0.5};
    inlet.totMolFlo[1] = 100;
  end test;
end flash;
