within Simulator.Examples;

package PFR
  extends Modelica.Icons.ExamplesPackage;
  model MS
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package PFR to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.PFR.PFR_Test_II\">PFR_Test_II</a>&nbsp;model to create the required number of instances of the material stream model.</div><!--EndFragment--></body></html>"));
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
    Simulator.UnitOperations.PFR.PFR B1(C = C, Mode = "Isothermal", Nc = Nc, Nr = 1, Pdel = 90.56, Phase = "Mixture", Tdef = 360, Basis = "Molar Concentration") annotation(
      Placement(visible = true, transformation(origin = {3, -1}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
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
    B1.X_r[1] = 0.0991;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the PFR example where all the components are defined, material stream, plug flow reactor &amp; kinetic reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Ethylene Oxide):</b>&nbsp;0.2</div><div><b>Mole Fraction (Water):</b>&nbsp;0.8</div><div><b>Mole Fraction (Ethylene Glycol):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;100000 Pa</div><div><b>Temperature:</b>&nbsp;360 K</div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">Ethylene Oxide + Water ----&gt; Ethylene Glycol</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Compressor Specification: </b>Conversion of Ethylene Oxide: 9.91%</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>&nbsp;Operation Mode: isothermal</span></div></body></html>"));
      end PFR_Test_II;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this <b>Plug Flow&nbsp;Reactor</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethylene Oxide, Water, Ethylene Glycol</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethylene Oxide):</b>&nbsp;0.2</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.8</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethylene Glycol):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;100000 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;360 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a plug flow reactor where Ethylene Oxide reacts with Water to form Ethylene Glycol. The conversion of ethylene oxide is 9.91%. Assume the reactor to be operated isothermally. Pressure drop across the PFR is 90.56 Pa.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Plug Flow Reactor. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.PFR.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.PFR.PFR_Test_II\">PFR_Test_II</a>&nbsp;(Executable model): All the components are defined, material stream &amp; plug flow reactor specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end PFR;
