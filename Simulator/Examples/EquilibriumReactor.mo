within Simulator.Examples;

package EquilibriumReactor

extends Modelica.Icons.ExamplesPackage;

model ms
  extends Simulator.Streams.MaterialStream;
  //material stream extended
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  //thermodynamic package Raoults law is extended
end ms;

model EqRxr
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  //instantiation of ethanol
  parameter data.Hydrogen hyd;
  //instantiation of acetic acid
  parameter data.Carbonmonoxide com;
  //instantiation of water
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
    Icon(coordinateSystem(initialScale = 0)));
  annotation(
    Icon(coordinateSystem(initialScale = 0)));

end EqRxr;

model EqRxra
   extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  //instantiation of ethanol
  parameter data.Ethanol eth;
  //instantiation of acetic acid
  parameter data.Aceticacid acid;
  //instantiation of water
  parameter data.Water wat;
  // instantiation of ethyl acetate
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

end EqRxra;


end EquilibriumReactor;
