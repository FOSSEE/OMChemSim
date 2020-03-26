within Simulator.Examples;

package CSTR
  extends Modelica.Icons.ExamplesPackage;

  model MS
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
    annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package CSTR to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.CSTR.test1\">test1</a>&nbsp;&amp;&nbsp;<a href=\"modelica://Simulator.Examples.CSTR.test2\">test2</a>&nbsp;models to create the required number of instances of the material stream model.</div></body></html>"));
  end MS;

  model test1
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Ethyleneoxide e;
    parameter data.Water w;
    parameter data.Ethyleneglycol eg;
    parameter data.GeneralProperties C[Nc] = {e, w, eg};
    parameter Integer Nc = 3;
    Simulator.UnitOperations.CSTR bmr1(C = C, Mode = "Define_Out_Temperature", Nc = Nc, Phase = 1, Tdef = 350, V = 1) annotation(
      Placement(visible = true, transformation(origin = {1, -1}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
    Simulator.Examples.CSTR.MS ms1(C = C, Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.CSTR.MS ms2(C = C, Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(ms1.Out, bmr1.In) annotation(
      Line(points = {{-40, 0}, {-16, 0}, {-16, -1}}, color = {0, 70, 70}));
    connect(bmr1.Out, ms2.In) annotation(
      Line(points = {{18, -1}, {44, -1}, {44, 0}}, color = {0, 70, 70}));
    ms1.T = 320;
    ms1.P = 101325;
    ms1.x_pc[1, :] = {0.4, 0.6, 0};
    ms1.F_p[1] = 100;
    annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the CSTR example where all the components are defined, material stream, CSTR &amp; kinetic reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;27.7778 mol/s</div><div><b>Mole Fraction (Ethylene Oxide):</b>&nbsp;0.4</div><div><b>Mole Fraction (Water):</b>&nbsp;0.6</div><div><b>Mole Fraction (Ethylene Glycol):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;320 K</div></div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">Ethylene Oxide + Water ----&gt; Ethylene Glycol</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>CSTR Specification:</b>&nbsp; Reactor Volume: 1 m3</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Reactor Outlet Temperature: 350 K</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Rate Constant: 0.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Reaction Order: 1 (Ethylene Oxide)</span></div></body></html>"));
  end test1;

  model test2
    extends Modelica.Icons.Example;
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol c2;
    parameter data.Methylacetate c3;
    parameter data.Aceticacid c1;
    parameter data.Water c4;
    parameter data.GeneralProperties C[Nc] = {c1, c2, c3, c4};
    parameter Integer Nc = 4;
    Simulator.Examples.CSTR.MS S1(C = C, Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Examples.CSTR.MS S2(C = C, Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.UnitOperations.CSTR B1(Af_r = {0.2}, BC_r = {1}, C = C, Coef_cr = {{-1}, {-1}, {1}, {1}}, DO_cr = {{1}, {0}, {0}, {0}}, Ef_r = {0}, Mode = "Define_Out_Temperature", Nc = Nc, Nr = 1, Phase = 3, Tdef = 360, V = 10) annotation(
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  equation
    connect(B1.Out, S2.In) annotation(
      Line(points = {{20, 0}, {44, 0}, {44, 0}, {44, 0}}, color = {0, 70, 70}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-52, 0}, {-20, 0}, {-20, 0}, {-20, 0}}, color = {0, 70, 70}));
    S1.T = 360;
    S1.P = 101325;
    S1.x_pc[1, :] = {0.5, 0.5, 0, 0};
    S1.F_p[1] = 100;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the CSTR example where all the components are defined, material stream, CSTR &amp; kinetic reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Methanol):</b>&nbsp;0.5</div><div><b>Mole Fraction (Acetic Acid):</b>&nbsp;0.5</div><div><b>Mole Fraction (Water):</b>&nbsp;0</div><div><b>Mole Fraction (Methyl Acetate):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;360 K</div></div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">Methanol + Acetic Acid ----&gt; Methyl Acetate + Water</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>CSTR Specification:</b>&nbsp; Reactor Volume: 10 m3</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Reactor Outlet Temperature: 360 K</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Rate Constant: 0.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Reaction Order: 1 (Acetic Acid)</span></div></body></html>"));
      end test2;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following two problem statement are simulated in ts CSTR examples:</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Problem Statement 1:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethylene Oxide, Water, Ethylene Glycol</span><div><b style=\"font-size: 12px;\">Thermodynamics:</b><span style=\"font-size: 12px;\">&nbsp;Raoult's Law</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;27.7778 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethylene Oxide):</b>&nbsp;0.4</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.6</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethylene Glycol):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;320 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a continuous stirred tank reactor where Ethylene Oxide reacts with Water to form Ethylene Glycol. The reactor volume is 1 m3 and assumed to operate at 350 K. The reaction is first order with respect to ethylene oxide and the rate constant is 0.5.</span><div><br></div><div><br></div><div><div style=\"font-size: 12px;\"><b><u>Problem Statement 2:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Methanol, Acetic Acid, Water, Methyl Acetate</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Acetic Acid):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methyl Acetate):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;360 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate a continuous stirred tank reactor where Methanol reacts with Acetic Acid to form Methyl Acetate and Water.The reactor volume is 10 m3 and assumed to operate at 360 K. The reaction is assumed to be first order w.r.t acetic acid and the rate constant is 0.5.</span><br><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of a CSTR. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.CSTR.MS\">MS</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.CSTR.test1\">test1</a>&nbsp;(Executable model for Problem Statement 1):&nbsp;All the components are defined, material stream &amp; CSTR specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.CSTR.test2\">test2</a>&nbsp;(Executable model for Problem Statement 2): All the components are defined, material stream &amp; CSTR specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></div></div></body></html>"));
end CSTR;
