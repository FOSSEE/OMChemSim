within Simulator.Examples;

package EquilibriumReactor

extends Modelica.Icons.ExamplesPackage;

model ms
  extends Simulator.Streams.MaterialStream;
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is a non-executable model is created inside the package CR to extend the&nbsp;</span><a href=\"modelica://Simulator.Streams.MaterialStream\">MaterialStream</a><span style=\"font-size: 12px;\">&nbsp;model along with the necessary property method from&nbsp;</span>ThermodynamicPackages<span style=\"font-size: 12px;\">&nbsp;which is&nbsp;</span><a href=\"modelica://Simulator.Files.ThermodynamicPackages.RaoultsLaw\">RaoultsLaw</a><span style=\"font-size: 12px;\">&nbsp;in this case.</span><div><span style=\"font-size: 12px;\"><br></span></div><div>It will be instantiated in the&nbsp;<a href=\"modelica://Simulator.Examples.EquilibriumReactor.EqRxr\">EqRxr</a>&nbsp;&amp;&nbsp;<a href=\"modelica://Simulator.Examples.EquilibriumReactor.EqRxra\">EqRxra</a>&nbsp;models to create the required number of instances of the material stream model.</div></body></html>"));
end ms;

model EqRxr
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Hydrogen hyd;
  parameter data.Carbonmonoxide com;
  parameter data.Methanol meth;
  
  parameter Integer Nc = 3;
  parameter data.GeneralProperties C[Nc] = {hyd,com,meth};
 Simulator.Examples.EquilibriumReactor.ms Inlet(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-108, 46}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Simulator.Examples.EquilibriumReactor.ms Outlet(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {88, -46}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Simulator.UnitOperations.EquilibriumReactor Eqreactor(Basis = "Activity",C = C, Coef_cr = {{-2}, {-1}, {1}}, Kg = {0.5}, Mode = "Isothermal", Nc = Nc, Phase = "Vapour", Rmode = "ConstantK") annotation(
    Placement(visible = true, transformation(origin = {-2, 10}, extent = {{28, 28}, {-28, -28}}, rotation = 180)));

  equation
 
  Inlet.T = 366.5;
  Inlet.P = 101325;
  Inlet.F_p[1] = 27.7778;
  Inlet.x_pc[1, :] = {0.667,0.333,0};
 connect(Inlet.Out, Eqreactor.In) annotation(
      Line(points = {{-88, 46}, {-30, 46}, {-30, 10}, {-30, 10}}, color = {0, 70, 70}));
 connect(Eqreactor.Out, Outlet.In) annotation(
      Line(points = {{26, 10}, {28, 10}, {28, -46}, {68, -46}, {68, -46}}, color = {0, 70, 70}));
  annotation(
    Icon(coordinateSystem(initialScale = 0)),
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Equilibrium Reactor example where all the components are defined, material stream, equilibirum reactor &amp; equilibrium reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><div><br></div><div><b>Molar Flow Rate:</b>&nbsp;27.7778 mol/s</div><div><b>Mole Fraction (Hydrogen):</b>&nbsp;0</div><div><b>Mole Fraction (Carbon Monoxide):</b>&nbsp;0</div><div><b>Mole Fraction (Methanol):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;366.5 K</div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">2 Hydrogen + Carbon Monoxide ----&gt; Methanol</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Equilibrium Reactor Specification:</b> Equilibrium Constant:&nbsp;0.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;<span class=\"Apple-tab-span\" style=\"white-space: pre;\">		</span>&nbsp; &nbsp;&nbsp;Operation Mode: Isothermal</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp; &nbsp; Reaction Basis: Activity</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp; &nbsp;&nbsp;Reaction Phase: Vapour</span></div></body></html>"));
end EqRxr;

model EqRxra
   extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethanol eth;
  parameter data.Aceticacid acid;
  parameter data.Water wat;
  parameter data.Ethylacetate eac;
  parameter Integer Nc = 4;
  parameter data.GeneralProperties C[Nc] = {eth, acid, wat, eac};
  Simulator.Examples.EquilibriumReactor .ms Inlet(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-118, 48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Simulator.Examples.EquilibriumReactor .ms Outlet(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {88, -46}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Simulator.UnitOperations.EquilibriumReactor Eqreactor(C = C, Nc = Nc, Mode = "Adiabatic", Basis = "PartialPressure", Phase = "Vapour") annotation(
    Placement(visible = true, transformation(origin = {-4, 10}, extent = {{28, 28}, {-28, -28}}, rotation = 180)));
  equation
  Inlet.T = 343.15;
  Inlet.P = 101325;
  Inlet.F_p[1] = 10;
  Inlet.x_pc[1, :] = {0.5, 0.5, 0, 0};
  connect(Inlet.Out, Eqreactor.In) annotation(
      Line(points = {{-98, 48}, {-32, 48}, {-32, 10}, {-32, 10}}, color = {0, 70, 70}));
  connect(Eqreactor.Out, Outlet.In) annotation(
      Line(points = {{24, 10}, {24, 10}, {24, -46}, {68, -46}, {68, -46}}, color = {0, 70, 70}));

annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Equilibrium Reactor example where all the components are defined, material stream, equilibirum reactor &amp; equilibrium reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;10 mol/s</div><div><b>Mole Fraction (Ethanol):</b>&nbsp;0.5</div><div><b>Mole Fraction (Acetic Acid):</b>&nbsp;0.5</div><div><b>Mole Fraction (Water):</b>&nbsp;0</div><div><b>Mole Fraction (Ethyl Acetate):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;343.15 K</div></div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">Ethanol + Acetic Acid -------&gt; Ethyl Acetate + Water</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Equilibrium Reactor Specification:</b> Equilibrium Constant:&nbsp;0.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;<span class=\"Apple-tab-span\" style=\"white-space: pre;\">		</span>&nbsp; &nbsp;&nbsp;Operation Mode: Adiabatic&nbsp;</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp; &nbsp; Reaction Basis: Partial Pressure</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">						</span>&nbsp; &nbsp;&nbsp;Reaction Phase: Vapour</span></div></body></html>"));
      end EqRxra;
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following two problem statement are simulated in this <b>Equilibrium Reactor</b>&nbsp;examples:</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Problem Statement 1:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\"> Hydrogen, Carbon Monoxide, Methanol</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;27.7778 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Hydrogen):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Carbon Monoxide):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;366.5 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate an equilibrium reactor where Hydrogen reacts with Carbon Monoxide to form Methanol. The equilibirum constant is considered to be 0.5 and is defined on the basis of activity. Assume the reactor to be operated isothermally and the reaction to be taking place in vapor phase.</span><div><br></div><div><br></div><div><div style=\"font-size: 12px;\"><b><u>Problem Statement 2:</u></b></div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Ethanol, Acetic Acid, Water, Ethyl Acetate</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b><u>Material Stream Information</u></b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;10 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Acetic Acid):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethyl Acetate):</b>&nbsp;0</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;343.15 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">Simulate an equilibrium reactor where Ethanol reacts with Acetic Acid to form Ethyl Acetate and Water. The equilibirum constant is considered to be 0.5 and is defined on the basis of partial pressure. Assume the reactor to be operated adiabatically and the reaction to be taking place in vapor phase.</span><br><hr><div><span style=\"font-size: 12px;\"><br></span></div><div><span style=\"font-size: 12px;\">This package is created to demnostrate the simualtion of an Equilibirum Reactor. Following models are created inside the package:</span></div><div><div style=\"font-size: 12px;\"><ol><li><a href=\"modelica://Simulator.Examples.EquilibriumReactor.ms\">ms</a>&nbsp;(Non-executable model):&nbsp;created to extend the material stream along with the necessary thermodynamic package.</li><li><a href=\"modelica://Simulator.Examples.EquilibriumReactor.EqRxr\">EqRxr</a>&nbsp;(Executable model for Problem Statement 1):&nbsp;All the components are defined, material stream &amp; equilibrium reactor specifications are declared, model instances are connected to make the file executable.</li><li><a href=\"modelica://Simulator.Examples.EquilibriumReactor.EqRxra\">EqRxra</a>&nbsp;(Executable model for Problem Statement 2): All the components are defined, material stream &amp; equilibrium reactor specifications are declared, model instances are connected to make the file executable.</li></ol></div></div></div></body></html>"));


end EquilibriumReactor;
