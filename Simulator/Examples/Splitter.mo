within Simulator.Examples;

package Splitter
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><div>This is a non-executable model is created inside the package Splitter to extend the&nbsp;<a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a>&nbsp;model along with the necessary property method from&nbsp;ThermodynamicPackages&nbsp;which is&nbsp;<a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a>&nbsp;in this case.</div><div><br></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Splitter.main\">main</a>&nbsp;model to create the required number of instances of the material stream model.</div><!--EndFragment--></body></html>"));
  end ms;

  model main
    extends Modelica.Icons.Example;
  //===============================================================
    //Header Files and Parameters
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {benz, tol};
    //===============================================================
    //Instantiation of Streams and Blocks
    Simulator.Examples.Splitter.ms S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Splitter.ms S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {38, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Splitter.ms S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {38, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.Splitter B1(Nc = Nc, C = C, No = 2, CalcType = "Molar_Flow") annotation(
      Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
//===============================================================
//Connections
    connect(B1.Out[2], S3.In) annotation(
      Line(points = {{0, 0}, {12, 0}, {12, -16}, {28, -16}}, color = {0, 70, 70}));
    connect(B1.Out[1], S2.In) annotation(
      Line(points = {{0, 0}, {12, 0}, {12, 12}, {28, 12}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 70, 70}));
//===============================================================
//Inputs and Specifications
    S1.P = 101325;
    S1.T = 300;
    S1.x_pc[1, :] = {0.5, 0.5};
    S1.F_p[1] = 100;
    B1.SpecVal_s = {20, 80};
  annotation(
      Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Splitter</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;300 K</div><div><br></div><div><br></div><div><div><span style=\"font-size: 12px;\"><b>Splitter Specification:</b>&nbsp;Molar Flow Rate of Outlet Stream 1: 20 mol/s</span></div></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp;&nbsp;</span><span style=\"font-size: 12px;\">Molar Flow Rate of Outlet Stream 2: 80 mol/s</span></div><div><span style=\"font-size: 12px;\"><br></span></div></body></html>"));
      end main;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Splitter</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b> 100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;300 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a splitter to split the above material stream into two such that the molar flow rate of one stream is 20 mol/s</span><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Splitter. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Splitter.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package</li><li><a href=\"modelica://Simulator.Examples.Splitter.main\">main</a>&nbsp;(Executable model): All the components are defined, material stream &amp; splitter specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></body></html>"));
end Splitter;
