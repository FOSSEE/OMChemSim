within Simulator.Unit_Operations.PF_Reactor;

function Integral
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;
  input Integer n;
  input Real Cao;
  input Real Fao;
  input Real k;
algorithm
  y := Fao / (k * Cao ^ n) * (1 / (1 - u) ^ n);
end Integral;
