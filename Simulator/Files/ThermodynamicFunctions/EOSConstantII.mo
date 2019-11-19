within Simulator.Files.ThermodynamicFunctions;

function EOSConstantII
  parameter Real R_gas = 8.314;
  input Integer NOC;
  input Real Tc[NOC], Pc[NOC];
  input Real T;
  output Real b[NOC];
algorithm
  for i in 1:NOC loop
    b[i] := 0.08664 * R_gas * (Tc[i] / Pc[i]);
  end for;
end EOSConstantII;
