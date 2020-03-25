within Simulator.Examples;

package Distillation
  extends Modelica.Icons.ExamplesPackage;
  model Condenser
    extends Simulator.UnitOperations.DistillationColumn.Cond;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Distillation to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.DistillationColumn.Cond\">Condenser</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.DistColumn\">DistColumn</a>&nbsp;model to create a complete distillation column model which will be instantiated in an executable model.</div></body></html>"));
  end Condenser;

  model Tray
    extends Simulator.UnitOperations.DistillationColumn.DistTray;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Distillation to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.DistillationColumn.DistTray\">Tray</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.DistColumn\">DistColumn</a>&nbsp;model to create a complete distillation column model which will be instantiated in an executable model.</div></body></html>"));
  end Tray;

  model Reboiler
    extends Simulator.UnitOperations.DistillationColumn.Reb;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Distillation to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.DistillationColumn.Reb\">Reboiler</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.DistColumn\">DistColumn</a>&nbsp;model to create a complete distillation column model which will be instantiated in an executable model.</div></body></html>"));
  end Reboiler;

  model DistColumn
    extends Simulator.UnitOperations.DistillationColumn.DistCol;
    Condenser condenser(Nc = Nc, C = C, Ctype = Ctype, Bin = Bin_t[1]);
    Reboiler reboiler(Nc = Nc, C = C, Bin = Bin_t[Nt]);
    Tray tray[Nt - 2](each Nc = Nc, each C = C, Bin = Bin_t[2:Nt - 1]);
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Distillation to extend the&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.DistillationColumn.DistCol\">Distillation Column</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><br></div><div>Condenser, Tray and Reboiler instances are also instantiated in this model to complete building of distillation column model.<br><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.Test\">Test</a>,&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.Test2\">Test2</a>,&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.Test3\">Test3</a>,<a href=\"modelica://Simulator.Examples.Distillation.Test4\">Test4</a>,&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.multiFeedTest\">multiFeedTest</a>&nbsp;model to create the required instance of the distillation column model.</div></div></body></html>"));
  end DistColumn;

  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package Distillation to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.Test\">Test</a>,&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.Test2\">Test2</a>,&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.Test3\">Test3</a>,<a href=\"modelica://Simulator.Examples.Distillation.Test4\">Test4</a>,&nbsp;<a href=\"modelica://Simulator.Examples.Distillation.multiFeedTest\">multiFeedTest</a>&nbsp;models to create the required number of instances of the material stream model.</div></body></html>"));
  end ms;

  model Test
    extends Modelica.Icons.Example;
    parameter Integer Nc = 2;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    Simulator.Examples.Distillation.DistColumn distCol(Nc = Nc, C = C, Nt = 4, Ni = 1, InT_s = {3}, Ctype = "Partial") annotation(
      Placement(visible = true, transformation(origin = {-22, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{3, 68}, {14.5, 68}, {14.5, 62}, {28, 62}}));
  connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{3, -52}, {38, -52}}));
  connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{3, -22}, {29.5, -22}, {29.5, -16}, {58, -16}}));
  connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{3, 38}, {26.5, 38}, {26.5, 22}, {54, 22}}));
  connect(feed.Out, distCol.In_s[1]) annotation(
      Line(points = {{-66, 2}, {-57.5, 2}, {-57.5, 8}, {-47, 8}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.5, 0.5};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 2;
    bottoms.F_p[1] = 50;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Distillation Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 4</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; Feed Stage Location: 3</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Type: Partial</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reflux Ratio: 2</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Bottoms Flow Rate: 50 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Pressure: 101325 Pa</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reboiler Pressure: 101325 Pa</span></div><!--EndFragment--></body></html>"));
      end Test;

  model Test2
    extends Modelica.Icons.Example;
    parameter Integer Nc = 2;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    Simulator.Examples.Distillation.DistColumn distCol(Nc = Nc, C = C, Nt = 12, Ni = 1, InT_s = {7}) annotation(
      Placement(visible = true, transformation(origin = {-26, 6.66134e-16}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{-1, -60}, {-1, 62}, {28, 62}}));
  connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{-1, 60}, {-1, -52}, {38, -52}}));
  connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{-1, 30}, {56, 30}, {56, -16}, {58, -16}}));
  connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{-1, -30}, {38, -30}, {38, 22}, {54, 22}}));
  connect(feed.Out, distCol.In_s[1]) annotation(
      Line(points = {{-66, 2}, {-60, 2}, {-60, 0}, {-51, 0}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.5, 0.5};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 2;
    bottoms.F_p[1] = 50;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Distillation Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 12</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; Feed Stage Location: 7</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Type: Total</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reflux Ratio: 2</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Bottoms Flow Rate: 50 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Pressure: 101325 Pa</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reboiler Pressure: 101325 Pa</span></div><!--EndFragment--></body></html>"));
      end Test2;

  model Test3
    extends Modelica.Icons.Example;
    parameter Integer Nc = 2;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    Simulator.Examples.Distillation.DistColumn distCol(Nc = Nc, C = C, Ni = 1, Nt = 22, InT_s = {10}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    Simulator.Examples.Distillation.ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In_s[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.3, 0.7};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 1.5;
    bottoms.F_p[1] = 70;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Distillation Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.3</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.7</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 22</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; Feed Stage Location: 10</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Type: Total</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reflux Ratio: 1.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Bottoms Flow Rate: 70 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Pressure: 101325 Pa</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reboiler Pressure: 101325 Pa</span></div><!--EndFragment--></body></html>"));
      end Test3;

  model Test4
    extends Modelica.Icons.Example;
    parameter Integer Nc = 2;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    DistColumn distCol(Nc = Nc, C = C, Nt = 22, Ni = 1, InT_s = {10}, condenser.Ctype = "Partial") annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    Simulator.Examples.Distillation.ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In_s[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 96.8;
    feed.x_pc[1, :] = {0.3, 0.7};
    distCol.condenser.P = 151325;
    distCol.reboiler.P = 101325;
    distCol.RR = 1.5;
    bottoms.F_p[1] = 70;
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Distillation Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;96.8 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.3</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.7</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 22</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; Feed Stage Location: 10</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Type: Partial</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reflux Ratio: 1.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Bottoms Flow Rate: 70 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Pressure: 151325 Pa</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reboiler Pressure: 101325 Pa</span></div><!--EndFragment--></body></html>"));
      end Test4;

  model multiFeedTest
    extends Modelica.Icons.Example;
    parameter Integer Nc = 2;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
    Simulator.Examples.Distillation.DistColumn distCol(Nc = Nc, C = C, Nt = 5, Ni = 2, InT_s = {3, 4}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    Simulator.Examples.Distillation.ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.EnergyStream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.Distillation.ms ms1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(ms1.Out, distCol.In_s[2]) annotation(
      Line(points = {{-70, 50}, {-26, 50}, {-26, 2}, {-28, 2}}));
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In_s[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.5, 0.5};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 2;
    bottoms.F_p[1] = 50;
    ms1.P = 101325;
    ms1.T = 298.15;
    ms1.F_p[1] = 100;
    ms1.x_pc[1, :] = {0.5, 0.5};
  annotation(
      Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Distillation Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Feed Stream 1</b></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Feed Stream 2</b></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;298.15 K</div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; Feed Stage Location: 3,4</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Type: Total</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reflux Ratio: 2</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Bottoms Flow Rate: 50 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Pressure: 101325 Pa</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reboiler Pressure: 101325 Pa</span></div><!--EndFragment--></body></html>"));
      end multiFeedTest;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following five problem statement are simulated in this Distillation Column example:</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Problem Statement 1:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a distillation column with 4 stages (excluding condenser and reboiler) where the feed is entering the 3rd stage. The column is operated at uniform pressure of 101325 Pa and with a partial condenser. The column is specified to have reflux ratio of 2 and bottoms flow rate of 50 mol/s.</span><div><br></div><div><br></div><div><div style=\"font-size: 12px;\"><div><b><u>Problem Statement 2:</u></b></div><div><b><br></b></div><b>Component System:</b>&nbsp;Benzene, Toluene<div style=\"font-size: medium;\"><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a distillation column with 12 stages (excluding condenser and reboiler) where the feed is entering the 7th stage. The column is operated at uniform pressure of 101325 Pa and with a total condenser. The column is specified to have reflux ratio of 2 and bottoms flow rate of 50 mol/s.</span></div><div style=\"font-size: medium;\"><span style=\"font-size: 12px;\"><br></span></div><div style=\"font-size: medium;\"><span style=\"font-size: 12px;\"><br></span></div><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><b><u>Problem Statement 3:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.3</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.7</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a distillation column with 22 stages (excluding condenser and reboiler) where the feed is entering the 10th stage. The column is operated at uniform pressure of 101325 Pa and with a total condenser. The column is specified to have reflux ratio of 1.5 and bottoms flow rate of 70 mol/s.</span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b><u>Problem Statement 4:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;96.8 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.3</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.7</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a distillation column with 22 stages (excluding condenser and reboiler) where the feed is entering the 10th stage. The column is operated at top pressure of 151325 Pa and with a total condenser. The bottom pressure of the column is 101325 Pa. The column is specified to have reflux ratio of 1.5 and bottoms flow rate of 70 mol/s.</span></div></div><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b><u>Problem Statement 5:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div style=\"font-size: medium;\"><div style=\"font-size: 12px;\"><div><b>Feed Stream 1</b></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;298.15 K</div><div><br></div><div><div><b>Feed Stream 2</b></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;298.15 K</div></div></div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a distillation column with 5 stages (excluding condenser and reboiler) where the feed streams are entering the 3rd and 4th stage. The column is operated at uniform pressure of 101325 Pa and with a partial condenser. The column is specified to have reflux ratio of 2 and bottoms flow rate of 50 mol/s.</span></div></div></div></div><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of Distillation Column. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.Distillation.Condenser\">Condenser</a>&nbsp;(Non-executable model):&nbsp;created to extend the condenser along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Distillation.Tray\">Tray</a>&nbsp;(Non-executable model):&nbsp;created to extend the tray along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Distillation.Reboiler\">Reboiler</a>&nbsp;(Non-executable model):&nbsp;created to extend the reboiler along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Distillation.DistColumn\">DistColumn</a>&nbsp;(Non-executable model):&nbsp;created to extend the Distillation Column along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Distillation.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.Distillation.Test\">Test</a>&nbsp;(Executable model for Problem Statement 1):&nbsp;All the components are defined, material stream &amp; Distillation Column specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.Distillation.Test2\">Test2</a>&nbsp;(Executable model for Problem Statement 2): All the components are defined, material stream &amp;&nbsp;Distillation Column&nbsp;specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.Distillation.Test3\">Test3</a>&nbsp;(Executable model for Problem Statement 3): All the components are defined, material stream &amp;&nbsp;Distillation Column&nbsp;specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.Distillation.Test4\">Test4</a>&nbsp;(Executable model for Problem Statement 4): All the components are defined, material stream &amp;&nbsp;Distillation Column&nbsp;specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.Distillation.multiFeedTest\">multiFeedTest</a>&nbsp;(Executable model for Problem Statement 5): All the components are defined, material stream &amp;&nbsp;Distillation Column&nbsp;specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></div></div></body></html>"));
end Distillation;
