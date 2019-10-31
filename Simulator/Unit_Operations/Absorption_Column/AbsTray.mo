within Simulator.Unit_Operations.Absorption_Column;

model AbsTray
  import Simulator.Files.*;
  parameter Integer NOC;
  parameter Chemsep_Database.General_Properties comp[NOC];
  Real P(start = Press), T(start = Temp);
  Real vapMolFlo[2](start = {Liquid_flow, Vapour_flow}), liqMolFlo[2](start = {Liquid_flow, Vapour_flow}), vapCompMolFrac[2, NOC](start = {x_guess, x_guess}), liqCompMolFrac[2, NOC](each min = 0, each max = 1, start = {x_guess, x_guess}), vapMolEnth[2](start = {PhasMolEnth_liq_guess, PhasMolEnth_vap_guess}), liqMolEnth[2](start = {PhasMolEnth_liq_guess, PhasMolEnth_vap_guess}), outVapCompMolEnth[NOC](start = compMolEnth_vap), outLiqCompMolEnth[NOC](start = compMolEnth_liq);
  Real compMolFrac[3, NOC](each min = 0, each max = 0, start = {CompMolFrac, x_guess, x_guess}), Pdew(start = Pmax), Pbubl(start = Pmin);
  Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends Guess_Models.Initial_Guess;
equation
//connector equation
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
//Adjustment for thermodynamic packages
  compMolFrac[1, :] = (vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :]) / (liqMolFlo[2] + vapMolFlo[2]);
  compMolFrac[2, :] = liqCompMolFrac[2, :];
  compMolFrac[3, :] = vapCompMolFrac[2, :];
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
//molar balance
  vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :] = vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :];
//equillibrium
  vapCompMolFrac[2, :] = K[:] .* liqCompMolFrac[2, :];
//raschford rice
//  liqCompMolFrac[2, :] = ((vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :])/(vapMolFlo[1] + liqMolFlo[1]))./(1 .+ (vapMolFlo[1]/(liqMolFlo[1] + vapMolFlo[1])) .* (K[:] .- 1));
//  for i in 1:NOC loop
//    vapCompMolFrac[2,i] = ((K[i]/(K[1])) * liqCompMolFrac[2,i]) / (1 + (K[i] / (K[1])) * liqCompMolFrac[2,i]);
//  end for;
//summation equation
  sum(liqCompMolFrac[2, :]) = 1;
  sum(vapCompMolFrac[2, :]) = 1;
// Enthalpy balance
  vapMolFlo[1] * vapMolEnth[1] + liqMolFlo[1] * liqMolEnth[1] = vapMolFlo[2] * vapMolEnth[2] + liqMolFlo[2] * liqMolEnth[2];
//enthalpy calculation
  for i in 1:NOC loop
    outLiqCompMolEnth[i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
    outVapCompMolEnth[i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
  end for;
  liqMolEnth[2] = sum(liqCompMolFrac[2, :] .* outLiqCompMolEnth[:]) + resMolEnth[2];
  vapMolEnth[2] = sum(vapCompMolFrac[2, :] .* outVapCompMolEnth[:]) + resMolEnth[3];
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
    __OpenModelica_commandLineOptions = "");
end AbsTray;
