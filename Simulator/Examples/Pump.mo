within Simulator.Examples;

package Pump
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model main
    extends Modelica.Icons.Example;
  //=====================================================================
  //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
  //=====================================================================
  //Instantiation of Streams and Blocks
    Simulator.Examples.Pump.ms S1(Nc = 2, C = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.CentrifugalPump B1(C = {benz, tol}, Nc = 2, Eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-8.99281e-15, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Simulator.Examples.Pump.ms S2(Nc = 2, C = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {64, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {-38, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
   
  //=====================================================================
  //Connections
   connect(E1.Out, B1.En) annotation(
      Line(points = {{-28, -44}, {0, -44}, {0, -12}, {0, -12}}, color = {255, 0, 0}));
    connect(B1.Out, S2.In) annotation(
      Line(points = {{14, 12}, {54, 12}, {54, 12}, {54, 12}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-14, 0}}, color = {0, 70, 70}));

  //=====================================================================
//Inputs and Specifications
    S1.F_p[1] = 100;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.P = 101325;
    S1.T = 300;
    B1.Pdel = 101325;
  end main;
end Pump;
