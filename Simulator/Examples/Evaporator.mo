within Simulator.Examples;

package Evaporator
extends Modelica.Icons.ExamplesPackage;
model ms
extends Simulator.Streams.MaterialStream;
extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
end ms;

model Test

extends Modelica.Icons.Example;
import data = Simulator.Files.ChemsepDatabase;
parameter data.Water w;
parameter data.Ethyleneglycol eg;
parameter data.GeneralProperties C[Nc] = {w, eg};
parameter Integer Nc = 2;
  Simulator.UnitOperations.Evaporator B1(C = C, Nc = Nc, Ps = 170000)  annotation(
    Placement(visible = true, transformation(origin = {-3.55271e-15, 5.32907e-15}, extent = {{-28, -28}, {28, 28}}, rotation = 0)));
  ms ms1(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms ms2(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {68, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ms ms3(C = C, Nc = Nc)  annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(B1.Out2, ms3.In) annotation(
    Line(points = {{26, -26}, {43, -26}, {43, -40}, {60, -40}}, color = {0, 70, 70}));
  connect(B1.Out1, ms2.In) annotation(
    Line(points = {{26, 26}, {42, 26}, {42, 48}, {58, 48}}, color = {0, 70, 70}));
  connect(ms1.Out, B1.In) annotation(
    Line(points = {{-60, 0}, {-26, 0}, {-26, 0}, {-26, 0}}, color = {0, 70, 70}));
ms1.T = 358.15;
ms1.P = 1e5;
ms1.F_p[1] = 100; 
ms1.x_pc[1,:] = {0.9,0.1};
B1.x_pc[2,Nc] = 0.25;
end Test;

end Evaporator;
