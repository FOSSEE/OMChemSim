within Simulator.Examples;

package Heater
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Heater to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Heater.heat\">heat</a>&nbsp;model to create the required number of instances of the material stream model.</div><!--EndFragment--></body></html>"));
  end ms;

  model heat
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    Simulator.Examples.Heater.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-80, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Examples.Heater.ms outlet(Nc = Nc, C = C, T(start = 353), x_pc(start = {{0.33, 0.33, 0.34}, {0.24, 0.31, 0.43}, {0.44, 0.34, 0.31}}), P(start = 101325)) annotation(
      Placement(visible = true, transformation(origin = {20, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Streams.EnergyStream energy annotation(
      Placement(visible = true, transformation(origin = {-75, -35}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  UnitOperations.Heater heater1(C = C, Eff = 1, Nc = Nc, Pdel = 101325)  annotation(
      Placement(visible = true, transformation(origin = {-30, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(energy.Out, heater1.En) annotation(
      Line(points = {{-62, -34}, {-40, -34}, {-40, -4}, {-40, -4}}, color = {255, 0, 0}));
    connect(heater1.Out, outlet.In) annotation(
      Line(points = {{-20, 6}, {8, 6}, {8, 8}, {8, 8}}, color = {0, 70, 70}));
    connect(inlet.Out, heater1.In) annotation(
      Line(points = {{-68, 4}, {-40, 4}, {-40, 6}, {-40, 6}}, color = {0, 70, 70}));
  equation
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
    inlet.P = 202650;
    inlet.T = 320;
    inlet.F_p[1] = 100;
    heater1.Q = 2000000;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Heater example where all the components are defined, material stream &amp; heater specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Heater\" style=\"font-size: 12px;\">Heater</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;202650 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;320 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Heater Specification:</b> Heat added: 2000000 W</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp;Efficiency: 100%</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp;Pressure Drop: 101325 Pa</span></div></body></html>"));
      end heat;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Heater</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methanol, Ethanol, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b> 100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;202650 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;320 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a heater to add 2000000 W of heat to the above material stream.&nbsp;</span><span style=\"font-size: 12px;\">Assume the heater efficiency to be 100% and pressure drop of 101325 Pa.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Heater. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Heater.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.Heater.heat\">heat</a>&nbsp;(Executable model): All the components are defined, material stream &amp; heater specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end Heater;
