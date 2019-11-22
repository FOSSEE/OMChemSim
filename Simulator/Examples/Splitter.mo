within Simulator.Examples;

package Splitter
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model main
    extends Modelica.Icons.Example;
  //===============================================================
  //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {benz, tol};
    
  //===============================================================
  //Instantiation of Streams and Blocks
    Simulator.Examples.Splitter.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Splitter.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {38, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Splitter.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {38, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.Splitter B1(Nc = Nc, C = C, No = 2, CalcType = "Molar_Flow") annotation(
      Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  
  
  //===============================================================
  //Connections
    connect(B1.Out[2], S3.In) annotation(
      Line(points = {{0, 0}, {12, 0}, {12, -16}, {28, -16}}, color = {0, 70, 70}));
    connect(B1.Out[1], S2.In) annotation(
      Line(points = {{0, 0}, {12, 0}, {12, 12}, {28, 12}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 70, 70}));

  //===============================================================
  //Inputs and Specifications
    S1.P = 101325;
    S1.T = 300;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
    B1.SpecVal_s = {20, 80};
  end main;
end Splitter;
