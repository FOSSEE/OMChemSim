within Simulator.Examples;

package Flash
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Flash to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">It will be instantiated in the&nbsp;</span><a href=\"modelica://Simulator.Examples.Flash.test\" style=\"font-size: 12px;\">test</a><span style=\"font-size: 12px;\">&nbsp;model to create the required number of instances of the material stream model.</span></div></body></html>"));
  end ms;

  model fls
    extends Simulator.UnitOperations.Flash;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Flash to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Flash\">FlashColumn</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">It will be instantiated in the&nbsp;</span><a href=\"modelica://Simulator.Examples.Flash.test\" style=\"font-size: 12px;\">test</a><span style=\"font-size: 12px;\">&nbsp;model to create the required instance of the flash column model.</span></div></body></html>"));
  end fls;

  model test
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
    Simulator.Examples.Flash.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Flash.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {56, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Flash.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {54, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Flash.fls B1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-14, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//=====================================================================
//Connections
    connect(B1.Out2, S2.In) annotation(
      Line(points = {{-4, -6}, {32, -6}, {32, -16}, {46, -16}, {46, -16}}, color = {0, 70, 70}));
    connect(B1.Out1, S3.In) annotation(
      Line(points = {{-4, 10}, {32, 10}, {32, 28}, {44, 28}, {44, 28}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-66, 4}, {-45, 4}, {-45, 2}, {-24, 2}}, color = {0, 70, 70}));
//=====================================================================
//Inputs and Specifications
    S1.P = 101325;
    S1.T = 368;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Flash example where all the components are defined, material stream &amp; flash column specifications are declared, model instances are connected.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;368 K</div><div><br></div><b>Flash Column Specifications:</b>&nbsp;Flash Operated at feed temperature and pressure</div></div></body></html>"));end test;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Flash Column</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;368 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a flash column operating at the feed temperature and pressure.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Flash Column. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Flash.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li>
<li><a href=\"modelica://Simulator.Examples.Flash.fls\">fls</a>&nbsp;(Non-executable model):&nbsp;created to extend the flash column along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Flash.test\">test</a>&nbsp;(Executable model): All the components are defined, material stream &amp; flash column specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end Flash;
