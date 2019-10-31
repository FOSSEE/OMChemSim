within Simulator.Files;

package Other_Functions
  function colBoolCalc
    //column boolean calculator
    input Integer noOfStages, noOfExCons, exConStages[noOfExCons];
    output Boolean bool[noOfStages];
  algorithm
    bool := fill(false, noOfStages);
    for i in 1:noOfExCons loop
      bool[exConStages[i]] := true;
    end for;
  end colBoolCalc;
end Other_Functions;
