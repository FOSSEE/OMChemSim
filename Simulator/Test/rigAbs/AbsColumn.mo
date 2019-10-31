within Simulator.Test.rigAbs;

model AbsColumn
  extends Simulator.Unit_Operations.Absorption_Column.AbsCol;
  Tray tray[noOfStages](each NOC = NOC, each comp = comp, each liqMolFlo(each start = 30), each vapMolFlo(each start = 30), each T(start = 300));
end AbsColumn;
