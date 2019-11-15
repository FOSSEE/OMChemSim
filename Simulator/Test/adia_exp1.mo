within Simulator.Test;

package adia_exp1
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model exp
    extends Simulator.Unit_Operations.Adiabatic_Expander;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end exp;

  model main
  
  //================================================================
  //Header files and Parameters
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene ben;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.General_Properties C[Nc] = {ben, tol};
    
  //================================================================
  //Instantiation of Streams and Blocks
    Simulator.Test.adia_comp1.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.adia_exp1.ms S2(Nc = Nc, C = C, T(start = 374)) annotation(
      Placement(visible = true, transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.adia_exp1.exp B1(Nc = Nc, C = C, eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-3, -1}, extent = {{-23, -23}, {23, 23}}, rotation = 0)));
    Simulator.Streams.Energy_Stream E1 annotation(
      Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  
  //================================================================
  //Connections
    connect(E1.outlet, B1.En) annotation(
      Line(points = {{-20, -60}, {-2, -60}, {-2, -16}, {-2, -16}}, color = {255, 0, 0}));
    connect(B1.Out, S2.inlet) annotation(
      Line(points = {{20, 0}, {52, 0}, {52, 0}, {52, 0}}, color = {0, 70, 70}));
    connect(S1.outlet, B1.In) annotation(
      Line(points = {{-72, 0}, {-26, 0}, {-26, 0}, {-26, 0}}, color = {0, 70, 70}));
  
  //================================================================
  //Inputs and Specifications
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.P = 131325;
    S1.T = 372;
    S1.F_p[1] = 100;
    B1.Pdel = 10000;

  end main;
end adia_exp1;
