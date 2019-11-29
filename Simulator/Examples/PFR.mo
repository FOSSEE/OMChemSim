within Simulator.Examples;

package PFR
  extends Modelica.Icons.ExamplesPackage;
  model MS
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end MS;

  model PFR_Test_II
    extends Modelica.Icons.Example;
  //*****Advicable to Select the First Component as the Base Component*****\\
  //========================================================================
  //Header Files and Packages
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethyleneoxide eth;
    parameter data.Ethyleneglycol eg;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {eth, wat, eg};
  
  //========================================================================
  //Instantiation of Streams and Blocks
   Simulator.Examples.PFR.MS S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Simulator.Examples.PFR.MS S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Simulator.UnitOperations.PFR.PFR B1(C = {eth, wat, eg}, Mode = "Isothermal",Nc = 3, Nr = 1, Pdel = 90.56, Phase = "Mixture",  Tdef = 360,Basis="Molar Concentration") annotation(
      Placement(visible = true, transformation(origin = { 3, -1}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
   Simulator.Streams.EnergyStream Energy annotation(
      Placement(visible = true, transformation(origin = {-14, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  equation
  
  //========================================================================
  //Connections
    connect(Energy.Out, B1.En) annotation(
      Line(points = {{-4, -54}, {2, -54}, {2, 0}, {4, 0}}, color = {255, 0, 0}));
    connect(B1.Out, S2.In) annotation(
      Line(points = {{36, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-30, 0}, {-30, 0}, {-30, 0}}, color = {0, 70, 70}));

  //========================================================================
  //Inputs and Specifications
    S1.x_pc[1, :] = {0.2, 0.8, 0};
    S1.P = 100000;
    S1.T = 360;
    S1.F_p[1] = 100;
    B1.X_r[1] =0.0991;
  end PFR_Test_II;
end PFR;
