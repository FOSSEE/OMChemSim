within Simulator.Examples;

package Absorption "Example of Simulating an Absorption Column"
  extends Modelica.Icons.ExamplesPackage;
  model MS "Extension of Material Stream with Raoult's Law"
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Absorption to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Absorption.AbsorptionSimulation\">AbsorptionSimulation</a>&nbsp;model to create the required number of instances of the material stream model.</div></body></html>"));
  end MS;

  model Tray "Extension of Tray with Raoult's Law"
    extends Simulator.UnitOperations.AbsorptionColumn.AbsTray;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Absorption to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.AbsorptionColumn.AbsTray\">Tray</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Absorption.AbsColumn\">AbsColumn</a>&nbsp;model to create a complete absorption column model which will be instantiated in an executable model.</div></body></html>"));
  end Tray;

  model AbsColumn "Extension of Absorption COlumn with instance of Tray"
    extends Simulator.UnitOperations.AbsorptionColumn.AbsCol;
    Tray tray[Nt](each Nc = Nc, each C = C);
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Absorption to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.AbsorptionColumn.AbsCol\">Absorption Column</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><br></div><div>Tray model is also instantiated in this model to complete building of absorption column model.<br><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Absorption.AbsorptionSimulation\">AbsorptionSimulation</a>&nbsp;model to create the required instance of the absorption column model.</div></div></body></html>"));
  end AbsColumn;

  model AbsorptionSimulation "Separating a gaseous mixtue of Air and Acetone using Water in an Absorption Column"
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter Integer Nc = 3;
    parameter data.Acetone acet;
    parameter data.Air air;
    parameter data.Water wat;
    parameter data.GeneralProperties C[Nc] = {acet, air, wat};
    Simulator.Examples.Absorption.MS S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-90, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Absorption.AbsColumn B1(Nc = Nc, C = C, Nt = 10) annotation(
      Placement(visible = true, transformation(origin = {-20, -6}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
    Simulator.Examples.Absorption.MS S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {52, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Absorption.MS S4(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {52, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.Absorption.MS S2 annotation(
      Placement(visible = true, transformation(origin = {-88, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(B1.Out_Bot, S4.In) annotation(
      Line(points = {{20, -54}, {36.5, -54}, {36.5, -94}, {42, -94}}));
    connect(B1.Out_Top, S3.In) annotation(
      Line(points = {{20, 42}, {38, 42}, {38, 80}, {42, 80}}));
    connect(S2.Out, B1.In_Bot) annotation(
      Line(points = {{-78, -54}, {-60, -54}}));
    connect(S1.Out, B1.In_Top) annotation(
      Line(points = {{-80, 42}, {-60, 42}}));
    S1.P = 101325;
    S1.T = 325;
    S1.F_p[1] = 30;
    S1.x_pc[1, :] = {0, 0, 1};
    S2.P = 101325;
    S2.T = 335;
    S2.F_p[1] = 30;
    S2.x_pc[1, :] = {0.5, 0.5, 0};
    annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Absorption Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Feed Stream 1 (Solvent)</b></div><div><b>Molar Flow Rate:</b>&nbsp;30 mol/s</div><div><b>Mole Fraction (Water):</b>&nbsp;1</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;325 K</div><div><br></div><div><div><b>Feed Stream 2 (Gas Mixture)</b></div><div><b>Molar Flow Rate:</b>&nbsp;30 mol/s</div><div><b>Mole Fraction (Air):</b>&nbsp;0.5</div><div><b>Mole Fraction (Acetone):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;335 K</div></div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 10</span></div><!--EndFragment--></body></html>"));
      end AbsorptionSimulation;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this Absorption Column example:</div><div style=\"font-size: 12px;\"><br></div><div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b><u>Problem Statement:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Air, Water, Acetone</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><div><div><b>Feed Stream 1 (Solvent)</b></div><div><b>Molar Flow Rate:</b>&nbsp;30 mol/s</div><div><b>Mole Fraction (Water):</b>&nbsp;1</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;325 K</div><div><br></div><div><div><b>Feed Stream 2 (Gas Mixture)</b></div><div><b>Molar Flow Rate:</b>&nbsp;30 mol/s</div><div><b>Mole Fraction (Air):</b>&nbsp;0.5</div><div><b>Mole Fraction (Acetone):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;335 K</div></div></div><div><br></div></div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate an absorption column with 10 stages where the solvent enters from the top and gas mixture enters from bottom to remove acetone from air.</span></div></div></div></div><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of an Absorption Column. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Absorption.MS\">MS</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Absorption.Tray\">Tray</a>&nbsp;(Non-executable model):&nbsp;created to extend the tray along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Absorption.AbsColumn\">AbsColumn</a>&nbsp;(Non-executable model):&nbsp;created to extend the Absorption Column along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Absorption.AbsorptionSimulation\">AbsorptionSimulation</a>&nbsp;(Executable model):&nbsp;All the components are defined, material stream &amp; Absorption Column specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></div></body></html>"));
end Absorption;