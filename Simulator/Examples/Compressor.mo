within Simulator.Examples;

package Compressor
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Compressor to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Compressor.main\">main</a>&nbsp;model to create the required number of instances of the material stream model.</div></body></html>"));
  end ms;

  model compres
    extends UnitOperations.AdiabaticCompressor;
    extends Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Compressor to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.AdiabaticCompressor\">AdiabaticCompressor</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Compressor.main\">main</a>&nbsp;model to create the required number of instances of the adiabatic compressor model.</div></body></html>"));
  end compres;

  model main
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene ben;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {ben, tol};
    Simulator.Examples.Compressor.compres adiabatic_Compressor1(Nc = Nc, C = C, Eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-15, 13}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    Simulator.Examples.Compressor.ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-78, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms outlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {58, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream power annotation(
      Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(inlet.Out, adiabatic_Compressor1.In) annotation(
      Line(points = {{-68, 8}, {-50, 8}, {-50, 13}, {-30, 13}}));
  connect(adiabatic_Compressor1.Out, outlet.In) annotation(
      Line(points = {{0, 13}, {31, 13}, {31, 6}, {48, 6}}));
  connect(power.Out, adiabatic_Compressor1.En) annotation(
      Line(points = {{-40, -56}, {-15, -56}, {-15, 3}}));
    inlet.x_pc[1, :] = {0.5, 0.5};
    inlet.P = 202650;
    inlet.T = 372;
    inlet.F_p[1] = 100;
    adiabatic_Compressor1.Pdel = 10000;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Compressor example where all the components are defined, material stream &amp; compressor specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;202650 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;372 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Compressor Specification:&nbsp;</b></span><span style=\"font-size: 12px;\">Efficiency: 75%</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;<span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>&nbsp;Pressure Increase: 10000 Pa</span></div></body></html>"));
      end main;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Adiabatic Compressor</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toulene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b> 100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;202650 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;372 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate an adiabatic compressor to reduce the pressure of a vapor material stream such that the pressure increase is 10000 Pa. Assume the compressor to be operated at efficiency of 75%.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of an Adiabatic Compressor. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Compressor.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.Compressor.compres\">compres</a>&nbsp;(Non-executable model):&nbsp;created to extend the adiabatic compressor along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Compressor.main\">main</a>&nbsp;(Executable model): All the components are defined, material stream &amp; compressor specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end Compressor;
