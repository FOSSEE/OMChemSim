within Simulator.Examples;
  
package HeatExchanger "Example of Simulating Heat Exchanger"
  //================================================================================================================
  extends Modelica.Icons.ExamplesPackage;
  model MS "Extension of Material Stream with Raoult's Law"
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Cooler to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><br><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.HeatExchanger.HXSimulation\">HXSimulation</a>&nbsp;and&nbsp;<a href=\"modelica://Simulator.Examples.HeatExchanger.ShellnTubeHXSimulation\">ShellnTubeHXSimulation</a>&nbsp;model to create the required number of instances of the material stream model.</div></div></body></html>"));
  end MS;

  model HXSimulation "Calculating outlet temperatures of material stream by specifying overall heat transfer coeffiecient and amount of heat transfer in a Heat Exchanger"
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
    parameter data.Styrene sty;
    parameter data.Toluene tol;
    parameter Integer Nc = 2;
    parameter data.GeneralProperties C[Nc] = {sty, tol};
    Simulator.UnitOperations.HeatExchanger B1(Cmode = "Outlet Temparature", Qloss = 0, Mode = "CounterCurrent", Nc = Nc, C = C, Pdelc = 0, Pdelh = 0) annotation(
      Placement(visible = true, transformation(origin = {-16, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-86, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {58, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-64, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S4(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {46, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(S2.Out, B1.In_Cold) annotation(
      Line(points = {{-54, 80}, {-16, 80}, {-16, 20}, {-16, 20}}, color = {0, 70, 70}));
  connect(S3.In, B1.Out_Hot) annotation(
      Line(points = {{48, 44}, {6, 44}, {6, -2}, {6, -2}}, color = {0, 70, 70}));
  connect(S1.Out, B1.In_Hot) annotation(
      Line(points = {{-76, 38}, {-76, -2}, {-38, -2}}));
  connect(B1.Out_Cold, S4.In) annotation(
      Line(points = {{-16, -24}, {-16, -48}, {36, -48}}));
  S1.x_pc[1, :] = {1, 0};
  S2.x_pc[1, :] = {0, 1};
  S1.F_p[1] = 181.46776;
  S2.F_p[1] = 170.93083;
  S1.T = 422.03889;
  S2.T = 310.92778;
  S1.P = 344737.24128;
  S2.P = 620527.03429;
    B1.U = 300;
    B1.Qact = 2700E03;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Heat Exchanger example where all the components are defined, material stream &amp; heat exchanger specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.HeatExchanger\" style=\"font-size: 12px;\">Heat Exchanger</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><b>Hot Stream</b></div><div><b>Molar Flow Rate:</b>&nbsp;181.46776 mol/s</div><div><b>Mole Fraction (Styrene):</b>&nbsp;1</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;344737.24 Pa</div><div><b>Temperature:</b>&nbsp;422.03 K</div><div><br></div><div><br></div><div><b>Cold Stream</b></div><div><div><b>Molar Flow Rate:</b>&nbsp;170.93 mol/s</div><div><div><b>Mole Fraction (Styrene):</b>&nbsp;0</div><div><b>Mole Fraction (Toluene):</b>&nbsp;1</div></div><div><b>Pressure:</b>&nbsp;620527.03 Pa</div><div><b>Temperature:</b>&nbsp;310.93 K</div></div><div><br></div><b>Heat Exchanger Specification:</b>&nbsp;Overall Heat Transfer Coefficient: 300 W/[m2.K]</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">					</span>&nbsp; &nbsp; &nbsp; &nbsp;Heat Exchanged: 2700000 W</div></body></html>"));
      end HXSimulation;

  model ShellnTubeHXSimulation "Calculating outlet temperatures of material stream by specifying the shell and tube side properties in a Heat Exchanger"
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
    
    parameter data.Water wat;
    parameter data.Noctane oct;
    parameter data.Nnonane non;
    parameter data.Ndecane dec;
    
    parameter Integer Nc = 4;
    parameter data.GeneralProperties C[Nc] = {wat,oct,non,dec};
    
    Simulator.UnitOperations.HeatExchanger B1( C = C,Cmode = "Design", Mode = "CounterCurrent", Nc = Nc, Pdelc = 0, Pdelh = 0, Qloss = 0) annotation(
      Placement(visible = true, transformation(origin = {-16, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-86, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-22, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.HeatExchanger.MS S4(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {46, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  equation
  connect(S1.Out, B1.In_Hot) annotation(
      Line(points = {{-76, 38}, {-76, -2}, {-38, -2}}));
  connect(B1.Out_Hot, S3.In) annotation(
      Line(points = {{6, -2}, {6, 45}, {58, 45}, {58, 70}}));
  connect(B1.Out_Cold, S4.In) annotation(
      Line(points = {{-16, -24}, {-16, -48}, {36, -48}}));
  connect(S2.Out, B1.In_Cold) annotation(
      Line(points = {{-12, 64}, {-12, 38}, {-16, 38}, {-16, 20}}));
  S1.x_pc[1, :] = {0, 0, 0.1, 0.9};
  S2.x_pc[1, :] = {1, 0, 0, 0};
  S1.F_p[1] = 212.94371;
  S2.F_p[1] = 3077.38424;
  S1.T = 377.03889;
  S2.T = 304.26111;
  S1.P = 1116948.66173;
  S2.P = 606737.54464;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Heat Exchanger example where all the components are defined, material stream &amp; heat exchanger specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.HeatExchanger\" style=\"font-size: 12px;\">Heat Exchanger</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><b>Hot Stream</b></div><div><b>Molar Flow Rate:</b>&nbsp;212.94371 mol/s</div><div><b>Mole Fraction (Water):</b>&nbsp;0</div><div><b>Mole Fraction (N-Octane):</b>&nbsp;0</div><div><div><b>Mole Fraction (N-Nonane):</b>&nbsp;0.1</div><div><b>Mole Fraction (N-Decane):</b>&nbsp;0.9</div></div><div><b>Pressure:</b>&nbsp;1116948.66 Pa</div><div><b>Temperature:</b>&nbsp;377.03889 K</div><div><br></div><div><br></div><div><b>Cold Stream</b></div><div><div><b>Molar Flow Rate:</b>&nbsp;3077.38424 mol/s</div><div><div><b>Mole Fraction (Water):</b>&nbsp;1</div><div><b>Mole Fraction (N-Octane):</b>&nbsp;0</div><div><div><b>Mole Fraction (N-Nonane):</b>&nbsp;1</div></div><div><b>Mole Fraction (N-Decane):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;606737.54464 Pa</div></div><div><b>Temperature:</b>&nbsp;304.26111 K</div></div></div></body></html>"));
      end ShellnTubeHXSimulation;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following two problem statement are simulated in this Heat Exchanger example:</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Problem Statement 1:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:&nbsp;</b><span style=\"font-size: 12px;\">Styrene and Toluene</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Hot Stream</b></div><div><b>Molar Flow Rate:</b>&nbsp;181.46776 mol/s</div><div><b>Mole Fraction (Styrene):</b>&nbsp;1</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;344737.24 Pa</div><div><b>Temperature:</b>&nbsp;422.03 K</div><div><br></div><div><br></div><div><b>Cold Stream</b></div><div><div><b>Molar Flow Rate:</b>&nbsp;170.93 mol/s</div><div><div><b>Mole Fraction (Styrene):</b>&nbsp;0</div><div><b>Mole Fraction (Toluene):</b>&nbsp;1</div></div><div><b>Pressure:</b>&nbsp;620527.03 Pa</div><div><b>Temperature:</b>&nbsp;310.93 K</div></div></div></div><div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">Simulate a Heat Exchanger with above mentioned material streams as inlet streams. Find the outlet temperatures such that the overall heat transfer coefficient is 300 W/[m2.K] and amount of heat exchanged in 2.7 MW.</div><div><br></div><div><br></div><div><div style=\"font-size: 12px;\"><b><u>Problem Statement 2:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Water, N-Octane, N-Nonane and N-Decane</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Hot Stream</b></div><div><b>Molar Flow Rate:</b>&nbsp;212.94371 mol/s</div><div><b>Mole Fraction (Water):</b>&nbsp;0</div><div><b>Mole Fraction (N-Octane):</b>&nbsp;0</div><div><div><b>Mole Fraction (N-Nonane):</b>&nbsp;0.1</div><div><b>Mole Fraction (N-Decane):</b>&nbsp;0.9</div></div><div><b>Pressure:</b>&nbsp;1116948.66 Pa</div><div><b>Temperature:</b>&nbsp;377.03889 K</div><div><br></div><div><br></div><div><b>Cold Stream</b></div><div><div><b>Molar Flow Rate:</b>&nbsp;3077.38424 mol/s</div><div><div><b>Mole Fraction (Water):</b>&nbsp;1</div><div><b>Mole Fraction (N-Octane):</b>&nbsp;0</div><div><b>Mole Fraction (N-Nonane):</b>&nbsp;1</div><div><b>Mole Fraction (N-Decane):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;606737.54464 Pa</div></div><div><b>Temperature:</b>&nbsp;304.26111 K</div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a Heat Exchanger with above mentioned material streams as inlet streams. Find the outlet temperatures with the given shell and tube heat exchanger configuration.</span><br><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a Heat Exchanger. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.HeatExchanger.MS\">MS</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.HeatExchanger.HXSimulation\">HXSimulation</a>&nbsp;(Executable model for Problem Statement 1):&nbsp;All the components are defined, material stream &amp; Heat Exchanger specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.HeatExchanger.ShellnTubeHXSimulation\">ShellnTubeHXSimulation</a>&nbsp;(Executable model for Problem Statement 2): All the components are defined, material stream &amp; Shell and Tube Heat Exchanger specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></div></div></body></html>"));
end HeatExchanger;
