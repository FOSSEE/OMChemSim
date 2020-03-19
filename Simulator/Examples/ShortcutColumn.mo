within Simulator.Examples;

package ShortcutColumn
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package ShortcutColumn to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">It will be instantiated in the&nbsp;</span><a href=\"modelica:///Simulator.Examples.ShortcutColumn.main\" style=\"font-size: 12px;\">main</a><span style=\"font-size: 12px;\">&nbsp;model to create the required number of instances of the material stream model.</span></div></body></html>"));
  end ms;

  model Shortcut
    extends Simulator.UnitOperations.ShortcutColumn;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package ShortutColumn to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.ShortcutColumn\">ShortcutColumn</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">It will be instantiated in the&nbsp;</span><a href=\"modelica://Simulator.Examples.ShortcutColumn.main\" style=\"font-size: 12px;\">main</a><span style=\"font-size: 12px;\">&nbsp;model to create the required instance of the shortcut column model.</span></div></body></html>"));
  end Shortcut;

  model main
    extends Modelica.Icons.Example;
    //******Use Non-Linear Solver "Homotopy" for Solving this Model******\\
    //============================================================================
    //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    //============================================================================
    //Instantiation of Streams and Blocks
    Simulator.Examples.ShortcutColumn.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.ShortcutColumn.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.ShortcutColumn.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream E2 annotation(
      Placement(visible = true, transformation(origin = {62, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Simulator.Examples.ShortcutColumn.Shortcut B1(Nc = Nc, C = C, HKey = 2, LKey = 1) annotation(
      Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//============================================================================
//Connections
    connect(B1.En1, E1.In) annotation(
      Line(points = {{30, 60}, {50, 60}, {50, 60}, {50, 60}}, color = {255, 0, 0}));
    connect(E2.Out, B1.En2) annotation(
      Line(points = {{52, -60}, {28, -60}, {28, -60}, {30, -60}}, color = {255, 0, 0}));
    connect(B1.Out2, S3.In) annotation(
      Line(points = {{30, -30}, {52, -30}, {52, -30}, {52, -30}}, color = {0, 70, 70}));
    connect(B1.Out1, S2.In) annotation(
      Line(points = {{30, 30}, {52, 30}, {52, 30}, {52, 30}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 70, 70}));
//============================================================================
//Inputs and Specifications
    S1.P = 101325;
    S1.T = 370;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
    B1.Preb = 101325;
    B1.Pcond = 101325;
    B1.x_pc[2, B1.LKey] = 0.01;
    B1.x_pc[3, B1.HKey] = 0.01;
    B1.RR = 2;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the ShortcutColumn example where all the components are defined, material stream &amp; shortcut column specifications are declared, model instances are connected.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;370 K</div><div><br></div><b>Shortcut Column Specifications:</b> benzene mole fraction at bottoms: 0.01</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp; toluene mole fraction at distillate: 0.01</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp; Column pressure: 101325 Pa</div><div><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp;&nbsp;Reflux ratio: 2</div></div></body></html>"));
      end main;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Shortcut Column</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;370 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a shortcut column such that benzene mole fraction at bottoms is 0.01 and toluene mole fraction at distillate is 0.01</span><span style=\"font-size: 12px;\">. The column is operated at 101325 Pa. Use Reflux ratio of 2.</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Flash Column. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.ShortcutColumn.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li>
<li><a href=\"modelica://Simulator.Examples.ShortcutColumn.Shortcut\">Shortcut</a>&nbsp;(Non-executable model):&nbsp;created to extend the shortcut column along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.ShortcutColumn.main\">main</a>&nbsp;(Executable model): All the components are defined, material stream &amp; shortcut column specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end ShortcutColumn;
