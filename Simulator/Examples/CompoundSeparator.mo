within Simulator.Examples;

package CompoundSeparator "Example of Simulating a Compound Separator"
  extends Modelica.Icons.ExamplesPackage;

  model MS "Extension of Material Stream with Raoult's Law"
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Heater to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.CompoundSeparator.CompSepSimulation\">CompSepSimulation</a>&nbsp;model to create the required number of instances of the material stream model.</div><!--EndFragment--></body></html>"));
  end MS;

  model CompSepSimulation "Separating two component system by specifying material balance"
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
     parameter Integer Nc = 2;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    Simulator.Examples.CompoundSeparator.MS S1( C = C,Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.CompoundSeparator.MS S2( C = C,Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {64, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.CompoundSeparator.MS S3( C = C,Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.CompoundSeparator B1( C = C,Nc = Nc, SepFact_c = {"Molar_Flow", "Mass_Flow"}, SepStrm = 1) annotation(
      Placement(visible = true, transformation(origin = {-20, 8}, extent = {{-10, -20}, {10, 20}}, rotation = 0)));
  equation
  connect(S1.Out, B1.In) annotation(
      Line(points = {{-72, -2}, {-43, -2}, {-43, 8}, {-32, 8}}));
  connect(B1.Out1, S2.In) annotation(
      Line(points = {{-8, 14}, {22, 14}, {22, 18}, {54, 18}}));
  connect(B1.Out2, S3.In) annotation(
      Line(points = {{-8, 3}, {26, 3}, {26, -20}, {56, -20}}));
  connect(E1.Out, B1.En) annotation(
      Line(points = {{-30, -50}, {-20, -50}, {-20, -5}}, color = {255, 0, 0}));
    S1.P = 101325;
    S1.T = 298.15;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
  B1.SepVal_c = {20, 1500};
  annotation(
      Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Compound Separator</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div><br></div><div><br></div><div><div><span style=\"font-size: 12px;\"><b>Compound Separator Specification:</b>&nbsp;Specified Outlet Stream: 1</span></div></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">							</span>Molar Flow Rate of Benzene: 20 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">							</span>Mass Flow Rate of Toluene: 1500 kg/s</span></div><div><span style=\"font-size: 12px;\"><br></span></div></body></html>"));
  end CompSepSimulation;
  annotation(
    Documentation(info = "<html><head></head><body><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">Simulate a compound separator to separate the above material stream such that the molar flow rate of benzene and mass flow rate of toluene are 20 mol/s and 1500 kg/s respectively in the outlet stream 1.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Compound Separator. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Splitter.MS\">MS</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.CompoundSeparator.CompSepSimulation\">CompSepSimulation</a>&nbsp;(Executable model): All the components are defined, material stream &amp; compound separator specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></div><div><span style=\"font-size: 12px;\"><br></span></div></body></html>"));
end CompoundSeparator;
