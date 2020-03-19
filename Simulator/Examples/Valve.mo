within Simulator.Examples;

package Valve
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Valve to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">It will be instantiated in the&nbsp;</span><a href=\"modelica://Simulator.Examples.Valve.valve\" style=\"font-size: 12px;\">valve</a><span style=\"font-size: 12px;\">&nbsp;model to create the required number of instances of the material stream model.</span></div></body></html>"));
  end ms;

  model valve
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    Simulator.UnitOperations.Valve valve1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {0, 4}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Simulator.Examples.Valve.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-74, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Valve.ms outlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {71, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  equation
    connect(valve1.Out, outlet.In) annotation(
      Line(points = {{14, 4}, {35, 4}, {35, 3}, {60, 3}}, color = {0, 70, 70}));
    connect(inlet.Out, valve1.In) annotation(
      Line(points = {{-64, 4}, {-14, 4}}, color = {0, 70, 70}));
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
  inlet.P = 202650;
  valve1.Pdel = 101325;
  inlet.T = 372;
  inlet.F_p[1] = 100;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Valve example where all the components are defined, material stream &amp; valve specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Valve\" style=\"font-size: 12px;\">Valve</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div><b>Pressure:</b>&nbsp;202650 Pa</div><div><b>Temperature:</b>&nbsp;372 K</div><div><br></div><b>Valve Specification:</b>&nbsp;Pressure Drop: 101325 Pa</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;</div></body></html>"));
      end valve;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this <b>Valve</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methanol, Ethanol, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b> 100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;202650 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;372 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a valve to reduce the pressure of the above material stream such that the pressure drop is 101325 Pa.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Valve. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Valve.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.Valve.valve\">valve</a>&nbsp;(Executable model): All the components are defined, material stream &amp; valve specifications are declared, models are connected to make the file executable.</li></ol></div></div></body></html>"));
end Valve;
