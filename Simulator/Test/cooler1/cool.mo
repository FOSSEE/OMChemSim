within Simulator.Test.cooler1;

model cool
  //use non linear solver hybrid to simulate this model
  import data = Simulator.Files.Chemsep_Database;
  //instantiation of chemsep database
  parameter data.Methanol meth;
  //instantiation of methanol
  parameter data.Ethanol eth;
  //instantiation of ethanol
  parameter data.Water wat;
  //instantiation of water
  Simulator.Unit_Operations.Cooler cooler1(pressDrop = 0, eff = 1, NOC = 3, comp = {meth, eth, wat}) annotation(
    Placement(visible = true, transformation(origin = {-8, 18}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  ms inlet(NOC = 3, comp = {meth, eth, wat}) annotation(
    Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Simulator.Test.cooler1.ms outlet(NOC = 3, comp = {meth, eth, wat}) annotation(
    Placement(visible = true, transformation(origin = {60, 12}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Simulator.Streams.Energy_Stream energy annotation(
    Placement(visible = true, transformation(origin = {47, -27}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
equation
  connect(cooler1.energy, energy.inlet) annotation(
    Line(points = {{6, 4}, {6, -27}, {34, -27}}, color = {255, 0, 0}));
  connect(cooler1.outlet, outlet.inlet) annotation(
    Line(points = {{6, 18}, {26, 18}, {26, 12}, {48, 12}}));
  connect(inlet.outlet, cooler1.inlet) annotation(
    Line(points = {{-60, 18}, {-22, 18}}));
equation
  inlet.compMolFrac[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
  inlet.P = 101325;
//input pressure
  inlet.T = 353;
//input temperature
  inlet.totMolFlo[1] = 100;
//input molar flow
  cooler1.heatRem = 200000;
//heat removed
end cool;
