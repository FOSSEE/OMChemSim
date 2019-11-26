within Simulator.Examples;

package ShortcutColumn
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model Shortcut
    extends Simulator.UnitOperations.ShortcutColumn;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Shortcut;

  model main
    extends Modelica.Icons.Example;
  
  //******Use Non-Linear Solver "Homotopy" for Solving this Model******\\
  //============================================================================
  //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    
  //============================================================================
  //Instantiation of Streams and Blocks
    Simulator.Examples.ShortcutColumn.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.ShortcutColumn.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.ShortcutColumn.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E2 annotation(
      Placement(visible = true, transformation(origin = {62, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Simulator.Examples.ShortcutColumn.Shortcut B1(Nc = Nc, C = C, HKey = 2, LKey = 1) annotation(
      Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  
  
  //============================================================================
  //Connections
    connect(B1.En1, E1.In) annotation(
      Line(points = {{30, 60}, {50, 60}, {50, 60}, {50, 60}}, color = {255, 0, 0}));
    connect(E2.Out, B1.En2) annotation(
      Line(points = {{52, -60}, {28, -60}, {28, -60}, {30, -60}}, color = {255, 0, 0}));
    connect(B1.Out2, S3.In) annotation(
      Line(points = {{30, -30}, {52, -30}, {52, -30}, {52, -30}}, color = {0, 70, 70}));
    connect(B1.Out1, S2.In) annotation(
      Line(points = {{30, 30}, {52, 30}, {52, 30}, {52, 30}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 70, 70}));
    
  //============================================================================
//Inputs and Specifications
    S1.P = 101325;
    S1.T = 370;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
    B1.Preb = 101325;
    B1.Pcond = 101325;
    B1.x_pc[2, B1.LKey] = 0.01;
    B1.x_pc[3, B1.HKey] = 0.01;
    B1.RR = 2;
  end main;
end ShortcutColumn;
