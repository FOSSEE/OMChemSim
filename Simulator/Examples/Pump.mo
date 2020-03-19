within Simulator.Examples;

package Pump
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Pump to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Pump.main\">main</a>&nbsp;model to create the required number of instances of the material stream model.</div></body></html>"));
  end ms;

  model main
    extends Modelica.Icons.Example;
    //=====================================================================
    //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {benz, tol};
    //=====================================================================
    //Instantiation of Streams and Blocks
    Simulator.Examples.Pump.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.CentrifugalPump B1(C = C, Nc = Nc, Eff = 0.75) annotation(
      Placement(visible = true, transformation(origin = {-8.99281e-15, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Simulator.Examples.Pump.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {-38, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//=====================================================================
//Connections
    connect(E1.Out, B1.En) annotation(
      Line(points = {{-28, -44}, {0, -44}, {0, -12}, {0, -12}}, color = {255, 0, 0}));
    connect(B1.Out, S2.In) annotation(
      Line(points = {{14, 12}, {54, 12}, {54, 12}, {54, 12}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-14, 0}}, color = {0, 70, 70}));
//=====================================================================
//Inputs and Specifications
    S1.F_p[1] = 100;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.P = 101325;
    S1.T = 300;
    B1.Pdel = 101325;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Pump example where all the components are defined, material stream &amp; pump specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.CentrifugalPump\" style=\"font-size: 12px;\">CentrifugalPump</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;300 K</div></div><div><br></div><div><br></div><b>Pump Specification:</b>&nbsp;Pressure Increase: 101325 Pa</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Efficiency: 75%</div></div></body></html>"));
      end main;
  annotation(
    Documentation(info = "<html><head></head><body><!--StartFragment--><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Centrifugal Pump</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toulene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;300 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a centrifugal pump to reduce the pressure of a liquid material stream such that the pressure increase is 101325 Pa. Assume the pump to be operated at efficiency of 75%.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Centrifugal Pump. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Pump.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.Pump.main\">main</a>&nbsp;(Executable model): All the components are defined, material stream &amp; pump specifications are declared, model instances are connected to make the file executable.</li></ol></div></div><!--EndFragment--></body></html>"));
end Pump;
