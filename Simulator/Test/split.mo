within Simulator.Test;

package split
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model main
  
  //===============================================================
  //Header Files and Parameters
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.General_Properties C[Nc] = {benz, tol};
    
  //===============================================================
  //Instantiation of Streams and Blocks
    ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.split.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {36, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.split.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {40, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Splitter B1(Nc = Nc, C = C, No = 2, CalcType = "Molar_Flow") annotation(
      Placement(visible = true, transformation(origin = {-24, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  
  //===============================================================
  //Connections
    connect(B1.Out[2], S3.inlet) annotation(
      Line(points = {{-14, 10}, {0, 10}, {0, -10}, {30, -10}}, color = {0, 70, 70}));
    connect(B1.Out[1], S2.inlet) annotation(
      Line(points = {{-14, 10}, {0, 10}, {0, 30}, {26, 30}}, color = {0, 70, 70}));
    connect(S1.outlet, B1.In) annotation(
      Line(points = {{-70, 10}, {-34, 10}, {-34, 10}, {-34, 10}}, color = {0, 70, 70}));

  //===============================================================
  //Inputs and Specifications
    S1.P = 101325;
    S1.T = 300;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
    B1.SpecVal_s = {20, 80};
  end main;
end split;
