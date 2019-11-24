within Simulator.Examples;

package CR
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.NRTL;
  end ms;

  model test
    extends Modelica.Icons.Example;
  //=================================================================
    //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter Integer Nc = 4;
    parameter data.Ethylacetate etac;
    parameter data.Water wat;
    parameter data.Aceticacid aa;
    parameter data.Ethanol eth;
    parameter data.GeneralProperties C[Nc] = {etac, wat, aa, eth};
    //==================================================================
    //Instantiation of Streams and Blocks
    Simulator.Examples.CR.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-89, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
    Simulator.Examples.CR.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.CR.conv_react B1(Nc = Nc, C = C, Nr = 1, BC_r = {3}, Coef_cr = {{1}, {1}, {-1}, {-1}}, X_r = {0.3},  CalcMode = "Isothermal", Tdef = 300) annotation(
      Placement(visible = true, transformation(origin = {7, -1}, extent = {{-29, -29}, {29, 29}}, rotation = 0)));
    
  equation
//==================================================================
//Connections
    connect(B1.Out, S2.In) annotation(
      Line(points = {{36, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-78, 0}, {-22, 0}, {-22, 0}, {-22, 0}}, color = {0, 70, 70}));
//==================================================================
//Inputs and Specifications
    S1.P = 101325;
    S1.T = 300;
    S1.x_pc[1, :] = {0, 0, 0.4, 0.6};
    S1.F_p[1] = 100;
  end test;

  model conv_react
    extends Simulator.UnitOperations.ConversionReactor;
    extends Simulator.Files.Models.ReactionManager.ConversionReaction;
  end conv_react;
end CR;
