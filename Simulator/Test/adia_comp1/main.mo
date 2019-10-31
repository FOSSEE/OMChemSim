within Simulator.Test.adia_comp1;

model main
  import data = Simulator.Files.Chemsep_Database;
  //instantiation of chemsep database
  parameter data.Benzene ben;
  //instantiation of methanol
  parameter data.Toluene tol;
  //instantiation of ethanol
  parameter Integer NOC = 2;
  parameter data.General_Properties comp[NOC] = {ben, tol};
  Simulator.Test.adia_comp1.compres adiabatic_Compressor1(NOC = NOC, comp = comp, eff = 0.75) annotation(
    Placement(visible = true, transformation(origin = {-17, 17}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Simulator.Test.adia_comp1.ms inlet(NOC = NOC, comp = comp) annotation(
    Placement(visible = true, transformation(origin = {-78, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms outlet(NOC = NOC, comp = comp, T(start = 374)) annotation(
    Placement(visible = true, transformation(origin = {58, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.Energy_Stream power annotation(
    Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(inlet.outlet, adiabatic_Compressor1.inlet) annotation(
    Line(points = {{-68, 8}, {-50, 8}, {-50, 17}, {-32, 17}}));
  connect(adiabatic_Compressor1.outlet, outlet.inlet) annotation(
    Line(points = {{-2, 17}, {31, 17}, {31, 6}, {48, 6}}));
  connect(power.outlet, adiabatic_Compressor1.energy) annotation(
    Line(points = {{-40, -56}, {-17, -56}, {-17, 7}}));
  inlet.compMolFrac[1, :] = {0.5, 0.5};
//mixture molar composition
  inlet.P = 202650;
//input pressure
  inlet.T = 372;
//input temperature
  inlet.totMolFlo[1] = 100;
//input molar flow
  adiabatic_Compressor1.pressInc = 10000;
//pressure increase
end main;
