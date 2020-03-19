within Simulator.Examples;

package Cooler
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Cooler to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><br><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Cooler.cool\">cool</a>&nbsp;model to create the required number of instances of the material stream model.</div></div></body></html>"));
  end ms;

  model cool
    extends Modelica.Icons.Example;
    //use non linear solver hybrid to simulate this model
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    Simulator.UnitOperations.Cooler cooler1(Pdel = 0, Eff = 1, Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-8, 18}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
     Simulator.Examples.Cooler.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Examples.Cooler.ms outlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {60, 12}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Streams.EnergyStream energy annotation(
      Placement(visible = true, transformation(origin = {47, -27}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
    connect(cooler1.En, energy.In) annotation(
      Line(points = {{6, 4}, {6, -27}, {34, -27}}, color = {255, 0, 0}));
  connect(cooler1.Out, outlet.In) annotation(
      Line(points = {{6, 18}, {26, 18}, {26, 12}, {48, 12}}));
  connect(inlet.Out, cooler1.In) annotation(
      Line(points = {{-60, 18}, {-22, 18}}));
  equation
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
    inlet.P = 101325;
    inlet.T = 353;
    inlet.F_p[1] = 100;
    cooler1.Q = 200000;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Cooler example where all the components are defined, material stream &amp; cooler specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Cooler\" style=\"font-size: 12px;\">Cooler</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;353 K</div><div><br></div><b>Cooler Specification:</b>&nbsp;Heat removed: 2000000 W</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;Efficiency: 100%</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;Pressure Drop: 0 Pa</div></body></html>"));
      end cool;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Cooler</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methanol, Ethanol, Water</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b> 100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;353 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a cooler to remove 2000000 W of heat from the above material stream. Assume the cooler efficiency to be 100% and zero pressure drop.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Cooler. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Cooler.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.Cooler.cool\">cool</a>&nbsp;(Executable model): All the components are defined, material stream &amp; cooler specifications are declared, models are connected to make the file executable.</li></ol></div></div></body></html>"));
end Cooler;
