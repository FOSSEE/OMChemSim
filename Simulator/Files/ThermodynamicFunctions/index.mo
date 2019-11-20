within Simulator.Files.ThermodynamicFunctions;

function index
  extends Modelica.Icons.Function;
  input String[:] comps;
  input String comp;
  output Integer i;
algorithm
  i := Modelica.Math.BooleanVectors.firstTrueIndex({k == comp for k in comps});
end index;
