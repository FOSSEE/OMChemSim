within Simulator.Examples;

package Mixer
  extends Modelica.Icons.ExamplesPackage;
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><div>This is a non-executable model is created inside the package Mixer to extend the&nbsp;<a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a>&nbsp;model along with the necessary property method from&nbsp;ThermodynamicPackages&nbsp;which is&nbsp;<a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a>&nbsp;in this case.</div><div><br></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Mixer.mix\">mix</a>&nbsp;model to create the required number of instances of the material stream model.</div><!--EndFragment--></body></html>"));
  end ms;

  model mix
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethanol eth;
    parameter data.Methanol meth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    Simulator.Examples.Mixer.ms ms1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Mixer.ms ms2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Mixer.ms ms3(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-86, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Mixer.ms ms4(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Mixer.ms ms5(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-84, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Mixer.ms ms6(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.Mixer mixer1(Nc = Nc, NI = 6, C = C, outPress = "Inlet_Average") annotation(
      Placement(visible = true, transformation(origin = {-8, 2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Simulator.Examples.Mixer.ms out1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {62, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(mixer1.outlet, out1.In) annotation(
      Line(points = {{12, 2}, {52, 2}}, color = {0, 70, 70}));
  connect(ms6.Out, mixer1.inlet[6]) annotation(
      Line(points = {{-72, -86}, {-28, -86}, {-28, 2}}, color = {0, 70, 70}));
  connect(ms5.Out, mixer1.inlet[5]) annotation(
      Line(points = {{-74, -52}, {-28, -52}, {-28, 2}}, color = {0, 70, 70}));
  connect(ms4.Out, mixer1.inlet[4]) annotation(
      Line(points = {{-74, -16}, {-51, -16}, {-51, 2}, {-28, 2}}, color = {0, 70, 70}));
  connect(ms3.Out, mixer1.inlet[3]) annotation(
      Line(points = {{-76, 24}, {-28, 24}, {-28, 2}}, color = {0, 70, 70}));
  connect(ms2.Out, mixer1.inlet[2]) annotation(
      Line(points = {{-74, 58}, {-28, 58}, {-28, 2}}, color = {0, 70, 70}));
  connect(ms1.Out, mixer1.inlet[1]) annotation(
      Line(points = {{-74, 88}, {-28, 88}, {-28, 2}}, color = {0, 70, 70}));
    ms1.P = 101325;
    ms2.P = 202650;
    ms3.P = 126523;
    ms4.P = 215365;
    ms5.P = 152365;
    ms6.P = 152568;
    ms1.T = 353;
    ms2.T = 353;
    ms3.T = 353;
    ms4.T = 353;
    ms5.T = 353;
    ms6.T = 353;
    ms1.F_p[1] = 100;
    ms2.F_p[1] = 100;
    ms3.F_p[1] = 300;
    ms4.F_p[1] = 500;
    ms5.F_p[1] = 400;
    ms6.F_p[1] = 200;
    ms1.x_pc[1, :] = {0.25, 0.25, 0.5};
    ms2.x_pc[1, :] = {0, 0, 1};
    ms3.x_pc[1, :] = {0.3, 0.3, 0.4};
    ms4.x_pc[1, :] = {0.25, 0.25, 0.5};
    ms5.x_pc[1, :] = {0.2, 0.4, 0.4};
    ms6.x_pc[1, :] = {0, 1, 0};
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Mixer example where all the components are defined, material stream &amp; mixer specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Mixer\">Mixer</a> model from the UnitOperations package has been instantiated here.<div><br></div><div><b>Material Stream Specification:</b><br><div><span style=\"font-size: 12px;\"><br></span></div><div><table border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"width: 553px;\"><caption align=\"bottom\"><b>&nbsp;</b></caption><tbody><tr><td style=\"width: 88px;\"><b>Material Stream</b></td><td style=\"width: 87px;\"><b>Molar Flow Rate, mol/s</b></td><td style=\"width: 73.95px;\"><p><b>Mole Fraction</b></p><p><b>(Methanol)</b></p></td><td style=\"width: 72.05px;\"><p><b>Mole Fraction</b></p><p><b>(Ethanol)</b></p></td><td style=\"width: 73px;\"><p><b>Mole Fraction</b></p><p><b>(Water)</b></p></td><td style=\"width: 46px;\"><b>Pressure, Pa</b></td><td style=\"width: 69px;\"><b>Temperature, K</b></td></tr><tr><td style=\"width: 88px;\">&nbsp;Stream 1</td><td style=\"width: 87px;\">&nbsp;100</td><td style=\"width: 73.95px;\">&nbsp;0.25</td><td style=\"width: 72.05px;\">&nbsp;0.25</td><td style=\"width: 73px;\">&nbsp;0.5</td><td style=\"width: 46px;\">&nbsp;101325</td><td style=\"width: 69px;\">&nbsp;353</td></tr><tr><td style=\"width: 88px;\">&nbsp;Stream 2</td><td style=\"width: 87px;\">&nbsp;100</td><td style=\"width: 73.95px;\">&nbsp;0</td><td style=\"width: 72.05px;\">&nbsp;0</td><td style=\"width: 73px;\">&nbsp;1</td><td style=\"width: 46px;\">&nbsp;202650</td><td style=\"width: 69px;\">&nbsp;353</td></tr><tr><td style=\"width: 88px;\">&nbsp;Stream 3</td><td style=\"width: 87px;\">&nbsp;300</td><td style=\"width: 73.95px;\">&nbsp;0.3</td><td style=\"width: 72.05px;\">&nbsp;0.3</td><td style=\"width: 73px;\">&nbsp;0.4</td><td style=\"width: 46px;\">&nbsp;126523</td><td style=\"width: 69px;\">&nbsp;353</td></tr><tr><td style=\"width: 88px;\">&nbsp;Stream 4</td><td style=\"width: 87px;\">&nbsp;400</td><td style=\"width: 73.95px;\">&nbsp;0.25</td><td style=\"width: 72.05px;\">&nbsp;0.25</td><td style=\"width: 73px;\">&nbsp;0.5</td><td style=\"width: 46px;\">&nbsp;215365</td><td style=\"width: 69px;\">&nbsp;353</td></tr><tr><td style=\"width: 88px;\">&nbsp;Stream 5</td><td style=\"width: 87px;\">&nbsp;500</td><td style=\"width: 73.95px;\">&nbsp;0.2</td><td style=\"width: 72.05px;\">&nbsp;0.4</td><td style=\"width: 73px;\">&nbsp;0.4</td><td style=\"width: 46px;\">&nbsp;152365</td><td style=\"width: 69px;\">&nbsp;353</td></tr><tr><td style=\"width: 88px;\">&nbsp;Stream 6</td><td style=\"width: 87px;\">&nbsp;200</td><td style=\"width: 73.95px;\">&nbsp;0</td><td style=\"width: 72.05px;\">&nbsp;1</td><td style=\"width: 73px;\">&nbsp;0</td><td style=\"width: 46px;\">&nbsp;152568</td><td style=\"width: 69px;\">&nbsp;353<br></td></tr></tbody></table><b>Mixer Specification:</b> Inlet Average Pressure</div></div></body></html>"));
      end mix;
  annotation(
    Documentation(info = "<html><head></head><body><div>Following problem statement is simulated in this <b>Mixer</b> example</div><div><b><br></b></div><b>Component System:</b> Methanol, Ethanol, Water<div><b>Thermodynamics:</b> Raoult's Law</div><div><br></div><div><b><u>Material Stream Information</u></b></div><div><br></div>
<table style=\"font-family: 'MS Shell Dlg 2'; letter-spacing: normal; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; width: 553px;\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\"><caption align=\"bottom\"><b>&nbsp;</b></caption>
<tbody>
<tr>
<td style=\"width: 88px;\"><b>Material Stream</b></td>
<td style=\"width: 87px;\"><b>Molar Flow Rate, mol/s</b></td>
<td style=\"width: 73.95px;\">
<p><b>Mole Fraction</b></p>
<p><b>(Methanol)</b></p>
</td>
<td style=\"width: 72.05px;\">
<p><b>Mole Fraction</b></p>
<p><b>(Ethanol)</b></p>
</td>
<td style=\"width: 73px;\">
<p><b>Mole Fraction</b></p>
<p><b>(Water)</b></p>
</td>
<td style=\"width: 46px;\"><b>Pressure, Pa</b></td>
<td style=\"width: 69px;\"><b>Temperature, K</b></td>
</tr>
<tr>
<td style=\"width: 88px;\">&nbsp;Stream 1</td>
<td style=\"width: 87px;\">&nbsp;100</td>
<td style=\"width: 73.95px;\">&nbsp;0.25</td>
<td style=\"width: 72.05px;\">&nbsp;0.25</td>
<td style=\"width: 73px;\">&nbsp;0.5</td>
<td style=\"width: 46px;\">&nbsp;101325</td>
<td style=\"width: 69px;\">&nbsp;353</td>
</tr>
<tr>
<td style=\"width: 88px;\">&nbsp;Stream 2</td>
<td style=\"width: 87px;\">&nbsp;100</td>
<td style=\"width: 73.95px;\">&nbsp;0</td>
<td style=\"width: 72.05px;\">&nbsp;0</td>
<td style=\"width: 73px;\">&nbsp;1</td>
<td style=\"width: 46px;\">&nbsp;202650</td>
<td style=\"width: 69px;\">&nbsp;353</td>
</tr>
<tr>
<td style=\"width: 88px;\">&nbsp;Stream 3</td>
<td style=\"width: 87px;\">&nbsp;300</td>
<td style=\"width: 73.95px;\">&nbsp;0.3</td>
<td style=\"width: 72.05px;\">&nbsp;0.3</td>
<td style=\"width: 73px;\">&nbsp;0.4</td>
<td style=\"width: 46px;\">&nbsp;126523</td>
<td style=\"width: 69px;\">&nbsp;353</td>
</tr>
<tr>
<td style=\"width: 88px;\">&nbsp;Stream 4</td>
<td style=\"width: 87px;\">&nbsp;400</td>
<td style=\"width: 73.95px;\">&nbsp;0.25</td>
<td style=\"width: 72.05px;\">&nbsp;0.25</td>
<td style=\"width: 73px;\">&nbsp;0.5</td>
<td style=\"width: 46px;\">&nbsp;215365</td>
<td style=\"width: 69px;\">&nbsp;353</td>
</tr>
<tr>
<td style=\"width: 88px;\">&nbsp;Stream 5</td>
<td style=\"width: 87px;\">&nbsp;500</td>
<td style=\"width: 73.95px;\">&nbsp;0.2</td>
<td style=\"width: 72.05px;\">&nbsp;0.4</td>
<td style=\"width: 73px;\">&nbsp;0.4</td>
<td style=\"width: 46px;\">&nbsp;152365</td>
<td style=\"width: 69px;\">&nbsp;353</td>
</tr>
<tr>
<td style=\"width: 88px;\">&nbsp;Stream 6</td>
<td style=\"width: 87px;\">&nbsp;200</td>
<td style=\"width: 73.95px;\">&nbsp;0</td>
<td style=\"width: 72.05px;\">&nbsp;1</td>
<td style=\"width: 73px;\">&nbsp;0</td>
<td style=\"width: 46px;\">&nbsp;152568</td>
<td style=\"width: 69px;\">&nbsp;353</td>
</tr>
</tbody>
</table>Simulate a Mixer to mix the above six material streams into a single output material stream where the pressure of the outlet stream is calculated as average of the inlet streams.<hr><div><br></div><div>This package is created to demnostrate the simualtion of a Mixer. Following models are created inside the package:</div><div><ol><li><a href=\"modelica://Simulator.Examples.Mixer.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Mixer.mix\">mix</a>&nbsp;(Executable model): All the components are defined, material stream &amp; mixer specifications are declared, model instances are connected to make the file executable.</li></ol></div><div><div>
<p>&nbsp;</p></div></div></body></html>"));
end Mixer;
