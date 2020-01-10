within Simulator.Files.OtherFunctions;

function colDynamics

  extends Modelica.Icons.Function;
  //column boolean calculator
  input Integer noOfStages, dynamic;
  output Real d[noOfStages];
  
algorithm
if dynamic == 1 then
  d := fill(1, noOfStages);
else 
  d := fill(0, noOfStages);
end if;
end colDynamics;
