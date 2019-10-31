within Simulator.Test.comp_sep1;

model main
  import data = Simulator.Files.Chemsep_Database;
  parameter data.Benzene benz;
  parameter data.Toluene tol;
  ms Inlet(NOC = 2, comp = {benz, tol}) annotation(
    Placement(visible = true, transformation(origin = {-82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms Outlet1(NOC = 2, comp = {benz, tol}) annotation(
    Placement(visible = true, transformation(origin = {64, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Test.comp_sep1.ms Outlet2(NOC = 2, comp = {benz, tol}) annotation(
    Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.Energy_Stream Energy annotation(
    Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Unit_Operations.Compound_Separator compound_Separator1(NOC = 2, comp = {benz, tol}, sepFact = {"Molar_Flow", "Mass_Flow"}, sepStrm = 1) annotation(
    Placement(visible = true, transformation(origin = {-20, 8}, extent = {{-10, -20}, {10, 20}}, rotation = 0)));
equation
  connect(Inlet.outlet, compound_Separator1.inlet) annotation(
    Line(points = {{-72, -2}, {-43, -2}, {-43, 8}, {-32, 8}}));
  connect(compound_Separator1.outlet1, Outlet1.inlet) annotation(
    Line(points = {{-8, 14}, {22, 14}, {22, 18}, {54, 18}}));
  connect(compound_Separator1.outlet2, Outlet2.inlet) annotation(
    Line(points = {{-8, 3}, {26, 3}, {26, -20}, {56, -20}}));
  connect(Energy.outlet, compound_Separator1.energy) annotation(
    Line(points = {{-30, -50}, {-20, -50}, {-20, -5}}, color = {255, 0, 0}));
  Inlet.P = 101325;
  Inlet.T = 298.15;
  Inlet.compMolFrac[1, :] = {0.5, 0.5};
  Inlet.totMolFlo[1] = 100;
  compound_Separator1.sepFactVal = {20, 1500};
end main;
