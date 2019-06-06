within Simulator.Unit_Operations.Distillation_Column;

model Cond
  import Simulator.Files.*;
  parameter Integer NOC = 2;
  parameter Boolean boolFeed = false;
  parameter Chemsep_Database.General_Properties comp[NOC];
  Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
  Real feedMolFlo(min = 0, start = 100), sideDrawMolFlo(min = 0, start = 100), inVapMolFlo(min = 0, start = 100), outLiqMolFlo(min = 0, start = 100), feedMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), sideDrawMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), inVapCompMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), outLiqCompMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), feedMolEnth, inVapMolEnth, outLiqMolEnth, heatLoad, sideDrawMolEnth, outLiqCompMolEnth[NOC];
  Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc) / NOC), Pbubl(min = 0, start = sum(comp[:].Pc) / NOC);
  //String sideDrawType(start = "Null");
  //L or V
  parameter String condType "Partial or Total";
  replaceable Simulator.Files.Connection.matConn feed(connNOC = NOC) if boolFeed annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn dummy_feed(connNOC = NOC, P = 0, T = 0, mixMolFrac = zeros(3, NOC), mixMolFlo = 0, mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not boolFeed annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn side_draw(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn heat_load annotation(
    Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//connector equation
  if boolFeed then
    feed.mixMolFrac[1, :] = feedMolFrac[:];
    feed.mixMolEnth = feedMolEnth;
    feed.mixMolFlo = feedMolFlo;
  else
    dummy_feed.mixMolFrac[1, :] = feedMolFrac[:];
    dummy_feed.mixMolEnth = feedMolEnth;
    dummy_feed.mixMolFlo = feedMolFlo;
  end if;
  side_draw.P = P;
  side_draw.T = T;
  side_draw.mixMolFrac[1, :] = sideDrawMolFrac[:];
  side_draw.mixMolFlo = sideDrawMolFlo;
  side_draw.mixMolEnth = sideDrawMolEnth;
  liquid_outlet.mixMolFlo = outLiqMolFlo;
  liquid_outlet.mixMolEnth = outLiqMolEnth;
  liquid_outlet.mixMolFrac[:] = outLiqCompMolFrac[:];
  vapor_inlet.mixMolFlo = inVapMolFlo;
  vapor_inlet.mixMolEnth = inVapMolEnth;
  vapor_inlet.mixMolFrac[:] = inVapCompMolFrac[:];
  heat_load.enFlo = heatLoad;
//Adjustment for thermodynamic packages
  compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + outLiqMolFlo .* outLiqCompMolFrac[:]) ./ (sideDrawMolFlo + outLiqMolFlo);
  compMolFrac[2, :] = outLiqCompMolFrac[:];
  compMolFrac[3, :] = K[:] .* compMolFrac[2, :];
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
//feedMolFlo + inVapMolFlo = sideDrawMolFlo + outLiqMolFlo;
  feedMolFlo .* feedMolFrac[:] + inVapMolFlo .* inVapCompMolFrac[:] = sideDrawMolFlo .* sideDrawMolFrac[:] + outLiqMolFlo .* outLiqCompMolFrac[:];
//equillibrium
  if condType == "Partial" then
    sideDrawMolFrac[:] = K[:] .* outLiqCompMolFrac[:];
  elseif condType == "Total" then
    sideDrawMolFrac[:] = outLiqCompMolFrac[:];
  end if;
//summation equation
//  sum(outLiqCompMolFrac[:]) = 1;
  sum(sideDrawMolFrac[:]) = 1;
// Enthalpy balance
  feedMolFlo * feedMolEnth + inVapMolFlo * inVapMolEnth = sideDrawMolFlo * sideDrawMolEnth + outLiqMolFlo * outLiqMolEnth + heatLoad;
//Temperature calculation
  if condType == "Total" then
    P = sum(sideDrawMolFrac[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]));
  elseif condType == "Partial" then
    1 / P = sum(sideDrawMolFrac[:] ./ exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]));
  end if;
// outlet liquid molar enthalpy calculation
  for i in 1:NOC loop
    outLiqCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
  end for;
  outLiqMolEnth = sum(outLiqCompMolFrac[:] .* outLiqCompMolEnth[:]) + resMolEnth[2];
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    __OpenModelica_commandLineOptions = "");
end Cond;
