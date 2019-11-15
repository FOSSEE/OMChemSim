within Simulator.Test;

package pump
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model main
  //=====================================================================
  //Header Files and Parameters
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
  //=====================================================================
  //Instantiation of Streams and Blocks
    Simulator.Test.pump.ms S1(Nc = 2, C = {benz, tol}) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Unit_Operations.Centrifugal_Pump B1(C = {benz, tol}, Nc = 2, eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-2, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Simulator.Test.pump.ms S2(Nc = 2, C = {benz, tol}, T(start = 300.089),  x_pc(start = {{0.5, 0.5}, {0.5, 0.5}, {0, 0}}), F_p(start = 100)) annotation(
      Placement(visible = true, transformation(origin = {64, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Streams.Energy_Stream E1 annotation(
      Placement(visible = true, transformation(origin = {-38, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  //=====================================================================
  //Connections
    connect(E1.outlet, B1.En) annotation(
      Line(points = {{-28, -44}, {-2, -44}, {-2, -12}, {-2, -12}}, color = {255, 0, 0}));
    connect(B1.Out, S2.inlet) annotation(
      Line(points = {{12, 12}, {54, 12}}, color = {0, 70, 70}));
    connect(S1.outlet, B1.In) annotation(
      Line(points = {{-60, 0}, {-16, 0}}, color = {0, 70, 70}));

  //=====================================================================
//Inputs and Specifications
    S1.F_p[1] = 100;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.P = 101325;
    S1.T = 300;
    B1.Pdel = 101325;
  end main;
end pump;
