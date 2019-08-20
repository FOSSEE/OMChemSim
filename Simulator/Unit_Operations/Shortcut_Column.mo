within Simulator.Unit_Operations;

model Shortcut_Column
  extends Simulator.Files.Icons.Distillation_Column;
  import data = Simulator.Files.Chemsep_Database;
  parameter data.General_Properties comp[NOC];
  parameter Integer NOC;
  Real mixMolFlo[3](each min = 0, each start = 100), mixMolFrac[3, NOC](each start = 1 / (NOC + 1), each min = 0, each max = 1), mixMolEnth[3], mixMolEntr[3];
  Real minN(min = 0, start = 10), minR(start = 1);
  Real alpha[NOC], theta(start = 1);
  Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
  Real condT(start = max(comp[:].Tb), min = 0), condP(min = 0, start = 101325), rebP(min = 0, start = 101325), rebT(start = min(comp[:].Tb), min = 0);
  parameter Integer HKey, LKey;
  parameter String condType = "Total";
  Real vapPhasMolFrac[3](each min = 0, each max = 1, each start = 0.5), condLiqMixMolEnth, condVapMixMolEnth, condVapCompMolEnth[NOC], condLiqCompMolEnth[NOC], condLiqMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), condVapMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1));
  Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc) / NOC), Pbubl(min = 0, start = sum(comp[:].Pc) / NOC);
  Real actR, actN, x, y, feedN;
  Real rectLiq(min = 0, start = 100), rectVap(min = 0, start = 100), stripLiq(min = 0, start = 100), stripVap(min = 0, start = 100), rebDuty, condDuty;
  Simulator.Files.Connection.matConn feed(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn distillate(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {250, 336}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn bottoms(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {250, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn condenser_duty annotation(
    Placement(visible = true, transformation(origin = {248, 594}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn reboiler_duty annotation(
    Placement(visible = true, transformation(origin = {254, -592}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// Connector equations
  feed.P = P;
  feed.T = T;
  feed.mixMolFlo = mixMolFlo[1];
  feed.mixMolFrac[1, :] = mixMolFrac[1, :];
  feed.mixMolEnth = mixMolEnth[1];
  feed.mixMolEntr = mixMolEntr[1];
  feed.vapPhasMolFrac = vapPhasMolFrac[1];
  bottoms.P = rebP;
  bottoms.T = rebT;
  bottoms.mixMolFlo = mixMolFlo[2];
  bottoms.mixMolFrac[1, :] = mixMolFrac[2, :];
  bottoms.mixMolEnth = mixMolEnth[2];
  bottoms.mixMolEntr = mixMolEntr[2];
  bottoms.vapPhasMolFrac = vapPhasMolFrac[2];
  distillate.P = condP;
  distillate.T = condT;
  distillate.mixMolFlo = mixMolFlo[3];
  distillate.mixMolFrac[1, :] = mixMolFrac[3, :];
  distillate.mixMolEnth = mixMolEnth[3];
  distillate.mixMolEntr = mixMolEntr[3];
  distillate.vapPhasMolFrac = vapPhasMolFrac[3];
  reboiler_duty.enFlo = rebDuty;
  condenser_duty.enFlo = condDuty;
//adjustment for thermodynamic packages
  compMolFrac[1, :] = mixMolFrac[1, :];
  compMolFrac[2, :] = compMolFrac[1, :] ./ (1 .+ vapPhasMolFrac[1] .* (K[:] .- 1));
  for i in 1:NOC loop
    compMolFrac[3, i] = K[i] * compMolFrac[2, i];
  end for;
//  sum(compMolFrac[1,:] .* (K[:] .- 1) ./ (1 .+ vapPhasMolFrac[1] .* (K[:] .- 1))) = 0;
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
equation
  for i in 1:NOC loop
    if mixMolFrac[1, i] == 0 then
      mixMolFrac[3, i] = 0;
    else
      mixMolFlo[1] .* mixMolFrac[1, i] = mixMolFlo[2] .* mixMolFrac[2, i] + mixMolFlo[3] .* mixMolFrac[3, i];
    end if;
  end for;
  sum(mixMolFrac[3, :]) = 1;
  sum(mixMolFrac[2, :]) = 1;
  for i in 1:NOC loop
    if i <> HKey then
      if condType == "Total" then
        mixMolFrac[3, i] / mixMolFrac[3, HKey] = alpha[i] ^ minN * (mixMolFrac[2, i] / mixMolFrac[2, HKey]);
      elseif condType == "Partial" then
        mixMolFrac[3, i] / mixMolFrac[3, HKey] = alpha[i] ^ (minN + 1) * (mixMolFrac[2, i] / mixMolFrac[2, HKey]);
      end if;
    end if;
  end for;
  alpha[:] = K[:] / K[HKey];
  //Calculation of temperature at distillate and bottoms
  if condT <= 0 and rebT <= 0 then
  if condType == "Partial" then
    1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
    
  elseif condType == "Total" then
    condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
  end if;
  
elseif condT<=0 then
  if condType == "Partial" then
    1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
    
  elseif condType == "Total" then
    condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
  end if;

elseif rebT<=0 then
  if condType == "Partial" then
    1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
    
  elseif condType == "Total" then
    condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / 1 + comp[:].VP[4] * 1 + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
  end if;

else
  if condType == "Partial" then
    1 / condP = sum(mixMolFrac[3, :] ./ (gamma[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6])));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
    
  elseif condType == "Total" then
    condP = sum(gamma[:] .* mixMolFrac[3, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / condT + comp[:].VP[4] * log(condT) + comp[:].VP[5] .* condT .^ comp[:].VP[6]));
    
    rebP = sum(gamma[:] .* mixMolFrac[2, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / rebT + comp[:].VP[4] * log(rebT) + comp[:].VP[5] .* rebT .^ comp[:].VP[6]));
  end if;
  
end if;
//Minimum Reflux, Underwoods method
if theta > alpha[LKey] or theta < alpha[HKey] then
  0= sum((alpha[:] .* mixMolFrac[1, :])./ (alpha[:] .- theta));
  //This is mathamatical adjustment for right convergence of theta
else
  vapPhasMolFrac[1] = sum((alpha[:] .* mixMolFrac[1, :])./ (alpha[:] .- theta));
end if;
  minR + 1 = sum(alpha[:] .* mixMolFrac[3, :] ./ (alpha[:] .- theta));
//Actual number of trays,Gillilands method
  x = (actR - minR) / (actR + 1);
  y = (actN - minN) / (actN + 1);
  if x >= 0 then
    y = 0.75 * (1 - x ^ 0.5668);
  else
    y = -1;
  end if;
// Feed location, Fenske equation
  feedN = actN / minN * log(mixMolFrac[1, LKey] / mixMolFrac[1, HKey] * (mixMolFrac[2, HKey] / mixMolFrac[2, LKey])) / log(K[LKey] / K[HKey]);
//rectifying and stripping flows
  rectLiq = actR * mixMolFlo[3];
  stripLiq = (1 - vapPhasMolFrac[1]) * mixMolFlo[1] + rectLiq;
  stripVap = stripLiq - mixMolFlo[2];
  rectVap = vapPhasMolFrac[1] * mixMolFlo[1] + stripVap;
  for i in 1:NOC loop
    condVapCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, condT);
    condLiqCompMolEnth[i] = Simulator.Files.Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, condT);
  end for;
  if condType == "Total" then
    condLiqMixMolEnth = mixMolEnth[3];
  elseif condType == "Partial" then
    condLiqMixMolEnth = sum(condLiqMolFrac[:] .* condLiqCompMolEnth[:]);
  end if;
  condVapMixMolEnth = sum(condVapMolFrac[:] .* condVapCompMolEnth[:]);
  rectVap .* condVapMolFrac[:] = rectLiq .* condLiqMolFrac[:] + mixMolFlo[3] .* mixMolFrac[3, :];
  if condType == "Partial" then
    mixMolFrac[3, :] = K[:] .* condLiqMolFrac[:];
  elseif condType == "Total" then
    mixMolFrac[3, :] = condLiqMolFrac[:];
  end if;
//Energy Balance
  mixMolFlo[1] * mixMolEnth[1] + rebDuty - condDuty = mixMolFlo[2] * mixMolEnth[2] + mixMolFlo[3] * mixMolEnth[3];
  rectVap * condVapMixMolEnth = condDuty + mixMolFlo[3] * mixMolEnth[3] + rectLiq * condLiqMixMolEnth;
annotation(
    Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
    Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
    __OpenModelica_commandLineOptions = "");end Shortcut_Column;
