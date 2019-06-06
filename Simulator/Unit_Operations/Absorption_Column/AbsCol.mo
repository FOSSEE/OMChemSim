within Simulator.Unit_Operations.Absorption_Column;

model AbsCol
  import data = Simulator.Files.Chemsep_Database;
  parameter Integer NOC "Number of Components";
  parameter Integer noOfStages;
  parameter data.General_Properties comp[NOC];
  Simulator.Files.Connection.matConn top_feed(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn bottom_feed(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn top_product(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn bottom_product(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//connector equation
  tray[1].liqMolFlo[1] = top_feed.mixMolFlo;
  tray[1].liqCompMolFrac[1, :] = top_feed.mixMolFrac[1, :];
  tray[1].liqMolEnth[1] = top_feed.mixMolEnth;
  tray[1].vapMolFlo[2] = top_product.mixMolFlo;
  tray[1].vapCompMolFrac[2, :] = top_product.mixMolFrac[1, :];
//  tray[1].vapMolEnth[2] = top_product.mixMolEnth;
  tray[1].T = top_product.T;
  tray[noOfStages].liqMolFlo[2] = bottom_product.mixMolFlo;
  tray[noOfStages].liqCompMolFrac[2, :] = bottom_product.mixMolFrac[1, :];
//  tray[noOfStages].liqMolEnth[2] = bottom_product.mixMolEnth;
  tray[noOfStages].T = bottom_product.T;
  tray[noOfStages].vapMolFlo[1] = bottom_feed.mixMolFlo;
  tray[noOfStages].vapCompMolFrac[1, :] = bottom_feed.mixMolFrac[1, :];
  tray[noOfStages].vapMolEnth[1] = bottom_feed.mixMolEnth;
  for i in 1:noOfStages - 1 loop
    connect(tray[i].liquid_outlet, tray[i + 1].liquid_inlet);
    connect(tray[i].vapor_inlet, tray[i + 1].vapor_outlet);
  end for;
//tray pressures
  for i in 2:noOfStages - 1 loop
    tray[i].P = tray[1].P + i * (tray[noOfStages].P - tray[1].P) / (noOfStages - 1);
  end for;
  tray[1].P = top_feed.P;
  tray[noOfStages].P = bottom_feed.P;
  tray[1].P = top_product.P;
  tray[noOfStages].P = bottom_product.P;
end AbsCol;
