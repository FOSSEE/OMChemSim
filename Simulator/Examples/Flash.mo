within Simulator.Examples;

package Flash
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model fls
    extends Simulator.UnitOperations.Flash;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end fls;

  model test
  extends Modelica.Icons.Example;
  //=====================================================================
  //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {benz, tol};
    
  //=====================================================================
  //Instantiation of Streams and Blocks
    ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Flash.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {56, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Flash.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {54, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Flash.fls B1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-14, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  equation
    
  //=====================================================================
  //Connections
   connect(B1.Out2, S2.In) annotation(
      Line(points = {{-4, -6}, {32, -6}, {32, -16}, {46, -16}, {46, -16}}, color = {0, 70, 70}));
   connect(B1.Out1, S3.In) annotation(
      Line(points = {{-4, 10}, {32, 10}, {32, 28}, {44, 28}, {44, 28}}, color = {0, 70, 70}));
   connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 2}, {-24, 2}, {-24, 2}, {-24, 2}}, color = {0, 70, 70}));
  
  //=====================================================================
  //Inputs and Specifications
    S1.P = 101325;
    S1.T = 368;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
  end test;
end Flash;
