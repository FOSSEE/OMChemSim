within Simulator.Files.Thermodynamic_Functions;

function EOS_Constant1V
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
end EOS_Constant1V;
