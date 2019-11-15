within Simulator.Test;

package CR_test
  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.NRTL;
  end ms;

  model test
  
  //=================================================================
  //Header Files and Parameters
    import data = Simulator.Files.Chemsep_Database;
    parameter Integer Nc = 4;
    parameter data.Ethylacetate etac;
    parameter data.Water wat;
    parameter data.Aceticacid aa;
    parameter data.Ethanol eth;
    parameter data.General_Properties C[Nc] = {etac, wat, aa, eth};
    
  //==================================================================
  //Instantiation of Streams and Blocks
    Simulator.Test.CR_test.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-89, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    Simulator.Test.CR_test.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.CR_test.conv_react B1(Nc = Nc, C = C, Nr = 1, Bc_r = {3}, Coef_cr = {{1}, {1}, {-1}, {-1}}, X_r = {0.3},  CalcMode = "Define_Outlet_Temperature", Tdef = 300) annotation(
      Placement(visible = true, transformation(origin = {7, -1}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
    
  equation
  
  //==================================================================
  //Connections
    connect(B1.Out, S2.inlet) annotation(
      Line(points = {{36, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {0, 70, 70}));
    connect(S1.outlet, B1.In) annotation(
      Line(points = {{-78, 0}, {-22, 0}, {-22, 0}, {-22, 0}}, color = {0, 70, 70}));
  
  //==================================================================
  //Inputs and Specifications
    S1.P = 101325;
    S1.T = 300;
    S1.x_pc[1, :] = {0, 0, 0.4, 0.6};
    S1.F_p[1] = 100;
  end test;

  model conv_react
    extends Simulator.Unit_Operations.Conversion_Reactor;
    extends Simulator.Files.Models.ReactionManager.Reaction_Manager;
  end conv_react;
end CR_test;
