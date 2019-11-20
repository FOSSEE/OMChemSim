within Simulator.Files.ThermodynamicFunctions;

function EOSConstantIII
  extends Modelica.Icons.Function;
  input Integer NOC;
  input Real a[NOC];
  output Real a_ij[NOC, NOC];
algorithm
  for i in 1:NOC loop
    a_ij[i, :] := (a[i] .* a[:]) .^ 0.5;
  end for;
end EOSConstantIII;
