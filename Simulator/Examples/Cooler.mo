within Simulator.Examples;

package Cooler
  extends Modelica.Icons.ExamplesPackage;
  model ms
    //This model will be instantiated in maintest model as outlet stream of cooler. Dont run this model. Run maintest model for cooler test
    extends Simulator.Streams.MaterialStream(Nc = 2);
    //material stream extended
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //thermodynamic package Raoults law is extended
  end ms;

  model cool
    extends Modelica.Icons.Example;
    //use non linear solver hybrid to simulate this model
    import data = Simulator.Files.ChemsepDatabase;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    Simulator.UnitOperations.Cooler cooler1(Pdel = 0, Eff = 1, Nc = 3, C = {meth, eth, wat}) annotation(
      Placement(visible = true, transformation(origin = {-8, 18}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
     Simulator.Examples.Cooler.ms inlet(Nc = 3, C = {meth, eth, wat}) annotation(
      Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Examples.Cooler.ms outlet(Nc = 3, C = {meth, eth, wat}) annotation(
      Placement(visible = true, transformation(origin = {60, 12}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Streams.EnergyStream energy annotation(
      Placement(visible = true, transformation(origin = {47, -27}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
    connect(cooler1.En, energy.In) annotation(
      Line(points = {{6, 4}, {6, -27}, {34, -27}}, color = {255, 0, 0}));
  connect(cooler1.Out, outlet.In) annotation(
      Line(points = {{6, 18}, {26, 18}, {26, 12}, {48, 12}}));
  connect(inlet.Out, cooler1.In) annotation(
      Line(points = {{-60, 18}, {-22, 18}}));
  equation
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
    inlet.P = 101325;
//input pressure
    inlet.T = 353;
//input temperature
    inlet.F_p[1] = 100;
//input molar flow
    cooler1.Q = 200000;
//heat removed
  end cool;
end Cooler;
