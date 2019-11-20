within Simulator.Files.ThermodynamicFunctions;

function EOSConstant1V
  extends Modelica.Icons.Function;
  input Integer NOC;
  input Real compMolFrac[NOC];
  input Real a_ij[NOC, NOC];
  output Real amv;
protected
  Real amvv[NOC];
algorithm
  for i in 1:NOC loop
    amvv[i] := sum(compMolFrac[i] .* compMolFrac[:] .* a_ij[i, :]);
  end for;
  amv := sum(amvv[:]);
end EOSConstant1V;
