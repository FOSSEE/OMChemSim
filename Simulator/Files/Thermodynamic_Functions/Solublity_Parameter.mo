within Simulator.Files.Thermodynamic_Functions;

function Solublity_Parameter
  input Integer NOC;
  input Real V[NOC];
  input Real Sp[NOC];
  input Real compMolFrac[NOC];
  output Real S;
protected
  Real Vs, Vtot;
algorithm
  Vtot := sum(compMolFrac[:] .* V[:]);
  Vs := sum(compMolFrac[:] .* V[:] .* Sp[:]);
  if Vtot == 0 then
    S := 0;
  else
    S := Vs / Vtot;
  end if;
end Solublity_Parameter;
