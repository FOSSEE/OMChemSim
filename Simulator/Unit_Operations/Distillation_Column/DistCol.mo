within Simulator.Unit_Operations.Distillation_Column;

model DistCol
  parameter Integer NOC;
  import data = Simulator.Files.Chemsep_Database;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  parameter Boolean boolFeed[noOfStages] = Simulator.Files.Other_Functions.colBoolCalc(noOfStages, noOfFeeds, feedStages);
  parameter Integer noOfStages = 4, noOfSideDraws = 0, noOfHeatLoads = 0, noOfFeeds = 1, feedStages[noOfFeeds];
  parameter String condType = "Total";
  //Total or Partial
  Real refluxRatio(min = 0);
  Simulator.Files.Connection.matConn feed[noOfFeeds](each connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-98, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn distillate(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {98, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn bottoms(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn condensor_duty annotation(
    Placement(visible = true, transformation(origin = {60, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn reboiler_duty annotation(
    Placement(visible = true, transformation(origin = {60, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn side_draw[noOfSideDraws](each connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn heat_load[noOfHeatLoads](each connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  for i in 1:noOfFeeds loop
    if feedStages[i] == 1 then
      connect(feed[i], condensor.feed);
    elseif feedStages[i] == noOfStages then
      connect(feed[i], reboiler.feed);
    elseif feedStages[i] > 1 and feedStages[i] < noOfStages then
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
      feed[i].P = tray[feedStages[i] - 1].dummyP1;
      feed[i].T = tray[feedStages[i] - 1].dummyT1;
      feed[i].mixMolFlo = tray[feedStages[i] - 1].dummyMixMolFlo1;
      feed[i].mixMolFrac = tray[feedStages[i] - 1].dummyMixMolFrac1;
      feed[i].mixMolEnth = tray[feedStages[i] - 1].dummyMixMolEnth1;
      feed[i].mixMolEntr = tray[feedStages[i] - 1].dummyMixMolEntr1;
      feed[i].vapPhasMolFrac = tray[feedStages[i] - 1].dummyVapPhasMolFrac1;
    end if;
  end for;
  connect(condensor.side_draw, distillate);
  connect(reboiler.side_draw, bottoms);
  connect(condensor.heat_load, condensor_duty);
  connect(reboiler.heat_load, reboiler_duty);
  for i in 1:noOfStages - 3 loop
    connect(tray[i].liquid_outlet, tray[i + 1].liquid_inlet);
    connect(tray[i].vapor_inlet, tray[i + 1].vapor_outlet);
  end for;
  connect(tray[1].vapor_outlet, condensor.vapor_inlet);
  connect(condensor.liquid_outlet, tray[1].liquid_inlet);
  connect(tray[noOfStages - 2].liquid_outlet, reboiler.liquid_inlet);
  connect(reboiler.vapor_outlet, tray[noOfStages - 2].vapor_inlet);
//tray pressures
  for i in 1:noOfStages - 2 loop
    tray[i].P = condensor.P + i * (reboiler.P - condensor.P) / (noOfStages - 1);
  end for;
  for i in 2:noOfStages - 1 loop
    tray[i - 1].sideDrawType = "Null";
    tray[i - 1].side_draw.mixMolFrac = zeros(3, NOC);
    tray[i - 1].side_draw.mixMolFlo = 0;
    tray[i - 1].side_draw.mixMolEnth = 0;
    tray[i - 1].side_draw.mixMolEntr = 0;
    tray[i - 1].side_draw.vapPhasMolFrac = 0;
    tray[i - 1].heatLoad = 0;
  end for;
  refluxRatio = condensor.outLiqMolFlo / condensor.side_draw.mixMolFlo;
end DistCol;
