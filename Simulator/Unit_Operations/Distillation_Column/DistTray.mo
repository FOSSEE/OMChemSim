within Simulator.Unit_Operations.Distillation_Column;

model DistTray
  import Simulator.Files.*;
  parameter Integer NOC = 2;
  parameter Boolean boolFeed = true;
  parameter Chemsep_Database.General_Properties comp[NOC];
  Real P(min = 0, start = 101325), T(min = 0, start = (min(comp[:].Tb) + max(comp[:].Tb)) / 2);
  Real feedMolFlo(min = 0, start = 100), sideDrawMolFlo(min = 0, start = 100), vapMolFlo[2](each min = 0, each start = 100), liqMolFlo[2](each min = 0, each start = 100), feedMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), sideDrawMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), vapCompMolFrac[2, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), liqCompMolFrac[2, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), feedMolEnth, vapMolEnth[2], liqMolEnth[2], heatLoad, sideDrawMolEnth, outVapCompMolEnth[NOC], outLiqCompMolEnth[NOC];
  Real compMolFrac[3, NOC](each min = 0, each max = 0, each start = 1 / (NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc) / NOC), Pbubl(min = 0, start = sum(comp[:].Pc) / NOC);
  Real dummyP1, dummyT1, dummyMixMolFrac1[3, NOC], dummyMixMolFlo1, dummyMixMolEnth1, dummyMixMolEntr1, dummyVapPhasMolFrac1;
  //this is adjustment done since OpenModelica 1.11 is not handling array modification properly
  String sideDrawType(start = "Null");
  //L or V
  replaceable Simulator.Files.Connection.matConn feed(connNOC = NOC) if boolFeed annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable Simulator.Files.Connection.matConn dummy_feed(connNOC = NOC, P = 0, T = 0, mixMolFlo = 0, mixMolFrac = zeros(3, NOC), mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not boolFeed annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn side_draw(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn heat_load annotation(
    Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//connector equation
  if boolFeed then
    feed.P = dummyP1;
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
    feed.T = dummyT1;
    feed.mixMolFrac = dummyMixMolFrac1;
    feed.mixMolFlo = dummyMixMolFlo1;
    feed.mixMolEnth = dummyMixMolEnth1;
    feed.mixMolEntr = dummyMixMolEntr1;
    feed.vapPhasMolFrac = dummyVapPhasMolFrac1;
  else
    dummy_feed.P = dummyP1;
    dummy_feed.T = dummyT1;
    dummy_feed.mixMolFrac = dummyMixMolFrac1;
    dummy_feed.mixMolFlo = dummyMixMolFlo1;
    dummy_feed.mixMolEnth = dummyMixMolEnth1;
    dummy_feed.mixMolEntr = dummyMixMolEntr1;
    dummy_feed.vapPhasMolFrac = dummyVapPhasMolFrac1;
  end if;
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
  dummyMixMolFrac1[1, :] = feedMolFrac[:];
  dummyMixMolEnth1 = feedMolEnth;
  dummyMixMolFlo1 = feedMolFlo;
  side_draw.P = P;
  side_draw.T = T;
  side_draw.mixMolFlo = sideDrawMolFlo;
  side_draw.mixMolEnth = sideDrawMolEnth;
  liquid_inlet.mixMolFlo = liqMolFlo[1];
  liquid_inlet.mixMolEnth = liqMolEnth[1];
  liquid_inlet.mixMolFrac[:] = liqCompMolFrac[1, :];
  liquid_outlet.mixMolFlo = liqMolFlo[2];
  liquid_outlet.mixMolEnth = liqMolEnth[2];
  liquid_outlet.mixMolFrac[:] = liqCompMolFrac[2, :];
  vapor_inlet.mixMolFlo = vapMolFlo[1];
  vapor_inlet.mixMolEnth = vapMolEnth[1];
  vapor_inlet.mixMolFrac[:] = vapCompMolFrac[1, :];
  vapor_outlet.mixMolFlo = vapMolFlo[2];
  vapor_outlet.mixMolEnth = vapMolEnth[2];
  vapor_outlet.mixMolFrac[:] = vapCompMolFrac[2, :];
  heat_load.enFlo = heatLoad;
//Adjustment for thermodynamic packages
  compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :]) / (liqMolFlo[2] + vapMolFlo[2] + sideDrawMolFlo);
  compMolFrac[2, :] = liqCompMolFrac[2, :];
  compMolFrac[3, :] = vapCompMolFrac[2, :];
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
//feedMolFlo + vapMolFlo[1] + liqMolFlo[1] = sideDrawMolFlo + vapMolFlo[2] + liqMolFlo[2];
  feedMolFlo .* feedMolFrac[:] + vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :] = sideDrawMolFlo .* sideDrawMolFrac[:] + vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :];
//equillibrium
  vapCompMolFrac[2, :] = K[:] .* liqCompMolFrac[2, :];
//  for i in 1:NOC loop
//    vapCompMolFrac[2,i] = ((K[i]/(K[1])) * liqCompMolFrac[2,i]) / (1 + (K[i] / (K[1])) * liqCompMolFrac[2,i]);
//  end for;
//summation equation
  sum(liqCompMolFrac[2, :]) = 1;
  sum(vapCompMolFrac[2, :]) = 1;
// Enthalpy balance
  feedMolFlo * feedMolEnth + vapMolFlo[1] * vapMolEnth[1] + liqMolFlo[1] * liqMolEnth[1] = sideDrawMolFlo * sideDrawMolEnth + vapMolFlo[2] * vapMolEnth[2] + liqMolFlo[2] * liqMolEnth[2] + heatLoad;
//enthalpy calculation
  for i in 1:NOC loop
    outLiqCompMolEnth[i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
    outVapCompMolEnth[i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
  end for;
  liqMolEnth[2] = sum(liqCompMolFrac[2, :] .* outLiqCompMolEnth[:]) + resMolEnth[2];
  vapMolEnth[2] = sum(vapCompMolFrac[2, :] .* outVapCompMolEnth[:]) + resMolEnth[3];
//sidedraw calculation
  if sideDrawType == "L" then
    sideDrawMolFrac[:] = liqCompMolFrac[2, :];
  elseif sideDrawType == "V" then
    sideDrawMolFrac[:] = vapCompMolFrac[2, :];
  else
    sideDrawMolFrac[:] = zeros(NOC);
  end if;
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    __OpenModelica_commandLineOptions = "");
end DistTray;
