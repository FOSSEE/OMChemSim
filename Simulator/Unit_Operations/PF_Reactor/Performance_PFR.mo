within Simulator.Unit_Operations.PF_Reactor;

function Performance_PFR
  input Integer n;
  input Real C;
  input Real F;
  input Real k;
  input Real X;
  output Real V;
algorithm
  V := Modelica.Math.Nonlinear.quadratureLobatto(function Integral(n = n, Cao = C, Fao = F, k = k), 0, X);
end Performance_PFR;
