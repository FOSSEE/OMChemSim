within Simulator.Examples;

package Expander
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Expander to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Expander.main\">main</a>&nbsp;model to create the required number of instances of the material stream model.</div><!--EndFragment--></body></html>"));
  end ms;

  model Exp
    extends Simulator.UnitOperations.AdiabaticExpander;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Expander to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.AdiabaticExpander\">AdiabaticExpander</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Expander.main\">main</a>&nbsp;model to create the required number of instances of the adiabatic expander model.</div></body></html>"));
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
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Expander example where all the components are defined, material stream &amp; expander specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;131325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;372 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Expander Specification:&nbsp;</b></span><span style=\"font-size: 12px;\">Efficiency: 75%</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; &nbsp; &nbsp;Pressure Drop: 10000 Pa</span></div><!--EndFragment--></body></html>"));
      end main;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Adiabatic Expander</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toulene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b> 100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;131325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;372 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate an adiabatic expander to reduce the pressure of a vapor material stream such that the pressure drop is 10000 Pa. Assume the expander to be operated at efficiency of 75%.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of an Adiabatic Expander. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Expander.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Expander.Exp\">Exp</a>&nbsp;(Non-executable model):&nbsp;created to extend the adiabatic expander along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Expander.main\">main</a>&nbsp;(Executable model): All the components are defined, material stream &amp; expander specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end Expander;
