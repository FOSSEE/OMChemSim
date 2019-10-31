within Simulator.Test.rigDist;

model DistColumn
  extends Simulator.Unit_Operations.Distillation_Column.DistCol;
  Condensor condensor(NOC = NOC, comp = comp, condType = condType, boolFeed = boolFeed[1], T(start = 300));
  Reboiler reboiler(NOC = NOC, comp = comp, boolFeed = boolFeed[noOfStages]);
  Tray tray[noOfStages - 2](each NOC = NOC, each comp = comp, boolFeed = boolFeed[2:noOfStages - 1], each liqMolFlo(each start = 150), each vapMolFlo(each start = 150));
end DistColumn;
