within Simulator.Test;

package comp_sep1
  model ms
    extends Simulator.Streams.Material_Stream(NOC = 2, comp = {benz, tol});
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model main
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    Simulator.Unit_Operations.Compound_Separator compound_Separator1(NOC = 2, comp = {benz, tol}, sepFact = {"Molar_Flow", "Mass_Flow"}, sepStrm = 2) annotation(
      Placement(visible = true, transformation(origin = {-5, -1}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
    ms Inlet(NOC = 2, comp = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {-82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms Outlet1(NOC = 2, comp = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {64, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.comp_sep1.ms Outlet2(NOC = 2, comp = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream Energy annotation(
      Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(compound_Separator1.outlet2, Outlet2.inlet) annotation(
      Line(points = {{22, -20}, {56, -20}}));
    connect(compound_Separator1.outlet1, Outlet1.inlet) annotation(
      Line(points = {{22, 18}, {54, 18}, {54, 18}, {54, 18}}));
    connect(Inlet.outlet, compound_Separator1.inlet) annotation(
      Line(points = {{-72, -2}, {-30, -2}, {-30, 0}, {-32, 0}}));
    connect(Energy.outlet, compound_Separator1.energy) annotation(
      Line(points = {{-30, -50}, {-4, -50}, {-4, -28}, {-4, -28}}));
    Inlet.P = 101325;
    Inlet.T = 298.15;
    Inlet.compMolFrac[1, :] = {0.5, 0.5};
    Inlet.totMolFlo[1] = 100;
    compound_Separator1.sepFactVal = {20, 1500};
  end main;
end comp_sep1;
