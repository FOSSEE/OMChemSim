within Simulator.Examples;

package Expander
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model Exp
    extends Simulator.UnitOperations.AdiabaticExpander;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end Exp;

  model main
    extends Modelica.Icons.Example;
  //================================================================
  //Header files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene ben;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {ben, tol};
    
  //================================================================
  //Instantiation of Streams and Blocks
    Simulator.Examples.Compressor.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Expander.ms S2(Nc = Nc, C = C, T(start = 374)) annotation(
      Placement(visible = true, transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Expander.Exp B1(Nc = Nc, C = C, Eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-3, -1}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  
  //================================================================
  //Connections
   connect(E1.Out, B1.En) annotation(
      Line(points = {{-20, -60}, {-2, -60}, {-2, -16}, {-2, -16}}, color = {255, 0, 0}));
    connect(B1.Out, S2.In) annotation(
      Line(points = {{20, 0}, {52, 0}, {52, 0}, {52, 0}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-72, 0}, {-26, 0}, {-26, 0}, {-26, 0}}, color = {0, 70, 70}));
  
  //================================================================
  //Inputs and Specifications
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.P = 131325;
    S1.T = 372;
    S1.F_p[1] = 100;
    B1.Pdel = 10000;

  end main;
end Expander;
