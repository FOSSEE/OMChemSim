within Simulator.Examples;

package CR
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.NRTL;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package CR to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.NRTL\">NRTL</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.CR.test\">test</a>&nbsp;model to create the required number of instances of the material stream model.</div></body></html>"));
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
    Simulator.Examples.CR.conv_react B1(Nc = Nc, C = C, Nr = 1, BC_r = {3}, Coef_cr = {{1}, {1}, {-1}, {-1}}, X_r = {0.3}, CalcMode = "Isothermal", Tdef = 300) annotation(
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
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the CR example where all the components are defined, material stream, conversion reactor &amp; conversion reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Ethyl Acetate):</b>&nbsp;0</div><div><b>Mole Fraction (Water):</b>&nbsp;0</div><div><b>Mole Fraction (Acetic Acid):</b>&nbsp;0.4</div><div><b>Mole Fraction (Ethanol):</b>&nbsp;0.6</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;300 K</div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">Acetic Acid + Ethanol ----&gt; Ethyl Acetate + Water</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Conversion Reactor Specification: </b>Conversion of Acetic Acid: 30%</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;<span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>&nbsp; &nbsp; &nbsp;Operation Mode: isothermal</span></div></body></html>"));
      end test;

  model conv_react
    extends Simulator.UnitOperations.ConversionReactor;
    extends Simulator.Files.Models.ReactionManager.ConversionReaction;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package CR to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.ConversionReactor\">ConversionReactor</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary reaction from Reaction Manager which is</span><span style=\"font-size: 12px;\">&nbsp;</span><a href=\"modelica://Simulator.Files.Models.ReactionManager.ConversionReaction\">ConversionReaction</a>&nbsp;in this case<span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.CR.test\">test</a>&nbsp;model to create the required number of instances of the adiabatic expander model.</div></body></html>"));
  end conv_react;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Conversion Reactor</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethyl Acetate, Water, Acetic Acid, Ethanol</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;NRTL</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethyl Acetate):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Acetic Acid):</b>&nbsp;0.4</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.6</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;300 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a conversion reactor where Acetic Acid reacts with Ethanol to form Ethyl Acetate and Water. The conversion of acetic acid is 60%. Assume the reactor to be operated isothermally.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Conversion Reactor. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.CR.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.CR.conv_react\">conv_react</a>&nbsp;(Non-executable model):&nbsp;created to extend the conversion reactor along with the reaction manager.</li><li><a href=\"modelica://Simulator.Examples.CR.test\">test</a>&nbsp;(Executable model): All the components are defined, material stream &amp; conversion reactor specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end CR;
