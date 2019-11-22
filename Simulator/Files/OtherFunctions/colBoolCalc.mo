within Simulator.Files.OtherFunctions;

function colBoolCalc
  extends Modelica.Icons.Function;
  //column boolean calculator
  input Integer noOfStages, noOfExCons, exConStages[noOfExCons];
  output Boolean bool[noOfStages];
algorithm
  bool := fill(false, noOfStages);
  for i in 1:noOfExCons loop
    bool[exConStages[i]] := true;
  end for;
end colBoolCalc;
