within Simulator.Test;

package pump
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model main
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    Simulator.Test.pump.ms inlet(NOC = 2, comp = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {-70, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Centrifugal_Pump pump(comp = {benz, tol}, NOC = 2, eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-2, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.pump.ms outlet(NOC = 2, comp = {benz, tol}, T(start = 300.089), compMolFrac(start = {{0.5, 0.5}, {0.5, 0.5}, {0, 0}}), totMolFlo(start = 100)) annotation(
      Placement(visible = true, transformation(origin = {68, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Streams.Energy_Stream energy annotation(
      Placement(visible = true, transformation(origin = {-38, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(inlet.outlet, pump.inlet) annotation(
      Line(points = {{-60, -8}, {-35, -8}, {-35, 0}, {-12, 0}}));
  connect(pump.outlet, outlet.inlet) annotation(
      Line(points = {{8, 8}, {33, 8}, {33, 16}, {58, 16}}));
  connect(energy.outlet, pump.energy) annotation(
      Line(points = {{-28, -44}, {-2, -44}, {-2, -12}}));
    inlet.totMolFlo[1] = 100;
    inlet.compMolFrac[1, :] = {0.5, 0.5};
    inlet.P = 101325;
    inlet.T = 300;
    pump.pressInc = 101325;
  end main;
end pump;
