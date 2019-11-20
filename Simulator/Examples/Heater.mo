within Simulator.Examples;

package Heater
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    //material stream extended
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    //thermodynamic package Raoults law is extended
  end ms;

  model heat
    extends Modelica.Icons.Example;
    //instance of chemsep database
    import data = Simulator.Files.ChemsepDatabase;
    //instance of methanol
    parameter data.Methanol meth;
    //instance of ethanol
    parameter data.Ethanol eth;
    //instance of water
    parameter data.Water wat;
    //instance of heater
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    Simulator.UnitOperations.Heater heater1(Pdel = 101325, Eff = 1, Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-26, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    //instances of composite material stream
    Simulator.Examples.Heater.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-80, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Examples.Heater.ms outlet(Nc = Nc, C = C, T(start = 353), x_pc(start = {{0.33, 0.33, 0.34}, {0.24, 0.31, 0.43}, {0.44, 0.34, 0.31}}), P(start = 101325)) annotation(
      Placement(visible = true, transformation(origin = {20, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    //instance of energy stream
    Simulator.Streams.EnergyStream energy annotation(
      Placement(visible = true, transformation(origin = {-75, -35}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
  connect(heater1.Out, outlet.In) annotation(
      Line(points = {{-16, -4}, {8, -4}, {8, 8}}));
  connect(inlet.Out, heater1.In) annotation(
      Line(points = {{-68, 4}, {-58, 4}, {-58, -4}, {-36, -4}}));
  connect(energy.Out, heater1.En) annotation(
      Line(points = {{-62, -35}, {-62, -34.5}, {-36, -34.5}, {-36, -14}}));
  equation
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
    inlet.P = 202650;
//input pressure
    inlet.T = 320;
//input temperature
    inlet.F_p[1] = 100;
//input molar flow
    heater1.Q = 2000000;
//heat added
  end heat;
end Heater;
