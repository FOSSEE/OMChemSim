within Simulator.Examples;

package CSTR
extends Modelica.Icons.ExamplesPackage;
model MS
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  extends Simulator.Streams.MaterialStream(Nc = 3, C = {e,w,eg});
  //material stream extended
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  //thermodynamic package Raoults law is extended

end MS;

model test1
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  parameter data.GeneralProperties C[Nc] = {e, w, eg};
  parameter Integer Nc = 3;
  Simulator.UnitOperations.CSTR bmr1(C = C, Mode = "Adiabatic", Nc = Nc, Phase = 3, V = 2) annotation(
    Placement(visible = true, transformation(origin = {1, -1}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  MS ms1(C = C, Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MS ms2(C = C, Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ms1.Out, bmr1.In) annotation(
    Line(points = {{-40, 0}, {-16, 0}, {-16, -1}}, color = {0, 70, 70}));
  connect(bmr1.Out, ms2.In) annotation(
    Line(points = {{18, -1}, {44, -1}, {44, 0}}, color = {0, 70, 70}));
  ms1.T = 360;
  ms1.P = 101325;
  ms1.x_pc[1, :] = {0.4, 0.6, 0};
  ms1.F_p[1] = 100;
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
  MS S1(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MS S2(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.UnitOperations.CSTR B1(Af_r = {0.2},BC_r = {1}, C = C, Coef_cr = {{-1}, {-1}, {1}, {1}}, Comp = 4, DO_cr = {{1}, {0}, {0}, {0}}, Ef_r = {0}, Mode = "Define_Out_Temperature", Nc = Nc, Nr = 1, Phase = 3, Tdef = 360, V = 10)  annotation(
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
end test2;
end CSTR;
