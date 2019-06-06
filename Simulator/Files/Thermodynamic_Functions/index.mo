within Simulator.Files.Thermodynamic_Functions;

function index
  input String[:] comps;
  input String comp;
  output Integer i;
algorithm
  i := Modelica.Math.BooleanVectors.firstTrueIndex({k == comp for k in comps});
end index;
