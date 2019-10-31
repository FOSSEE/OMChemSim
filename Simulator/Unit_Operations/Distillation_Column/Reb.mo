within Simulator.Unit_Operations.Distillation_Column;

model Reb
  import Simulator.Files.*;
  parameter Integer NOC = 2;
  parameter Boolean boolFeed = false;
  parameter Chemsep_Database.General_Properties comp[NOC];
  Real P(start = Press), T(start = Temp);
  Real feedMolFlo(start = Feed_flow), sideDrawMolFlo(start = Liquid_flow), outVapMolFlo(start = Vapour_flow), inLiqMolFlo(start = Liquid_flow), feedMolFrac[NOC](start = CompMolFrac), sideDrawMolFrac[NOC](start = CompMolFrac), outVapCompMolFrac[NOC](start = y_guess), inLiqCompMolFrac[NOC](start = x_guess), feedMolEnth(start = PhasMolEnth_mix), outVapMolEnth(start = PhasMolEnth_vap_guess), inLiqMolEnth(start = PhasMolEnth_liq_guess), outVapCompMolEnth[NOC](start = compMolEnth_vap), heatLoad, sideDrawMolEnth;
  Real compMolFrac[3, NOC](each min = 0, each max = 1, start = {CompMolFrac, x_guess, y_guess}), Pdew(start = Pmax), Pbubl(start = Pmin);
  replaceable Simulator.Files.Connection.matConn feed(connNOC = NOC) if boolFeed annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  replaceable Simulator.Files.Connection.matConn dummy_feed(connNOC = NOC, P = 0, T = 0, mixMolFrac = zeros(3, NOC), mixMolFlo = 0, mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not boolFeed annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn side_draw(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn heat_load annotation(
    Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends Guess_Models.Initial_Guess;
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
  side_draw.mixMolFrac[1, :] = sideDrawMolFrac;
  side_draw.mixMolFlo = sideDrawMolFlo;
  side_draw.mixMolEnth = sideDrawMolEnth;
  liquid_inlet.mixMolFlo = inLiqMolFlo;
  liquid_inlet.mixMolEnth = inLiqMolEnth;
  liquid_inlet.mixMolFrac[:] = inLiqCompMolFrac[:];
  vapor_outlet.mixMolFlo = outVapMolFlo;
  vapor_outlet.mixMolEnth = outVapMolEnth;
  vapor_outlet.mixMolFrac[:] = outVapCompMolFrac[:];
  heat_load.enFlo = heatLoad;
//Adjustment for thermodynamic packages
  compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + outVapMolFlo .* outVapCompMolFrac[:]) ./ (sideDrawMolFlo + outVapMolFlo);
  compMolFrac[2, :] = sideDrawMolFrac[:];
//This equation is temporarily valid since this is only "partial" reboiler. Rewrite equation when "total" reboiler functionality is added
  compMolFrac[3, :] = outVapCompMolFrac[:];
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
//  feedMolFlo + inLiqMolFlo = sideDrawMolFlo + outVapMolFlo;
  for i in 1:NOC loop
    feedMolFlo .* feedMolFrac[i] + inLiqMolFlo .* inLiqCompMolFrac[i] = sideDrawMolFlo .* sideDrawMolFrac[i] + outVapMolFlo .* outVapCompMolFrac[i];
  end for;
//equillibrium
  outVapCompMolFrac[:] = K[:] .* sideDrawMolFrac[:];
//summation equation
//    sum(outVapCompMolFrac[:]) = 1;
  sum(sideDrawMolFrac[:]) = 1;
  for i in 1:NOC loop
    outVapCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
  end for;
  outVapMolEnth = sum(outVapCompMolFrac[:] .* outVapCompMolEnth[:]) + resMolEnth[3];
// bubble point calculations
  P = sum(sideDrawMolFrac[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]));
//    sideDrawMolFlo = 10;
  feedMolFlo * feedMolEnth + inLiqMolFlo * inLiqMolEnth = sideDrawMolFlo * sideDrawMolEnth + outVapMolFlo * outVapMolEnth + heatLoad;
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    __OpenModelica_commandLineOptions = "");
end Reb;
