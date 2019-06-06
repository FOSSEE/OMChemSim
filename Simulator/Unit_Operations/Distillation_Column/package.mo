within Simulator.Unit_Operations;

package Distillation_Column
  model Cond
    import Simulator.Files.*;
    parameter Integer NOC = 2;
    parameter Boolean boolFeed = false;
    parameter Chemsep_Database.General_Properties comp[NOC];
    Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
    Real feedMolFlo(min = 0, start = 100), sideDrawMolFlo(min = 0, start = 100), inVapMolFlo(min = 0, start = 100), outLiqMolFlo(min = 0, start = 100), feedMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), sideDrawMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), inVapCompMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), outLiqCompMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), feedMolEnth, inVapMolEnth, outLiqMolEnth, heatLoad, sideDrawMolEnth, outLiqCompMolEnth[NOC];
    Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc)/NOC), Pbubl(min = 0, start = sum(comp[:].Pc)/NOC);
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
      compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + outLiqMolFlo .* outLiqCompMolFrac[:])./(sideDrawMolFlo + outLiqMolFlo);
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










  model DistTray
    import Simulator.Files.*;
    parameter Integer NOC = 2;
    parameter Boolean boolFeed = true;
    parameter Chemsep_Database.General_Properties comp[NOC];
    Real P(min = 0, start = 101325), T(min = 0, start = (min(comp[:].Tb) + max(comp[:].Tb)) / 2);
    Real feedMolFlo(min = 0, start = 100), sideDrawMolFlo(min = 0, start = 100), vapMolFlo[2](each min = 0, each start = 100), liqMolFlo[2](each min = 0, each start = 100), feedMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), sideDrawMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), vapCompMolFrac[2, NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), liqCompMolFrac[2, NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), feedMolEnth, vapMolEnth[2], liqMolEnth[2], heatLoad, sideDrawMolEnth, outVapCompMolEnth[NOC], outLiqCompMolEnth[NOC];
    Real compMolFrac[3, NOC](each min =0, each max = 0, each start = 1/(NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc)/NOC), Pbubl(min = 0, start = sum(comp[:].Pc)/NOC);
    Real dummyP1, dummyT1, dummyMixMolFrac1[3,NOC], dummyMixMolFlo1,dummyMixMolEnth1, dummyMixMolEntr1, dummyVapPhasMolFrac1;//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
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
      feed.P = dummyP1;//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
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
    dummyMixMolFrac1[1,:] = feedMolFrac[:];
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
   compMolFrac[2, :] = liqCompMolFrac[2,:];
   compMolFrac[3, :] = vapCompMolFrac[2,:];  
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

  model Reb
    import Simulator.Files.*;
    parameter Integer NOC = 2;
    parameter Boolean boolFeed = false;
    parameter Chemsep_Database.General_Properties comp[NOC];
    Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
    Real feedMolFlo(min = 0, start = 100), sideDrawMolFlo(min = 0, start = 100), outVapMolFlo(min = 0, start = 100), inLiqMolFlo(min = 0, start = 100), feedMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), sideDrawMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), outVapCompMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), inLiqCompMolFrac[NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), feedMolEnth, outVapMolEnth, inLiqMolEnth,
   outVapCompMolEnth[NOC], heatLoad, sideDrawMolEnth;
   Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1/(NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc)/NOC), Pbubl(min = 0, start = sum(comp[:].Pc)/NOC);
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
     compMolFrac[1, :] = (sideDrawMolFlo .* sideDrawMolFrac[:] + outVapMolFlo .* outVapCompMolFrac[:])./(sideDrawMolFlo + outVapMolFlo);
     compMolFrac[2, :] = sideDrawMolFrac[:];//This equation is temporarily valid since this is only "partial" reboiler. Rewrite equation when "total" reboiler functionality is added
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
      elseif (feedStages[i] > 1 and feedStages[i] < noOfStages) then
      //this is adjustment done since OpenModelica 1.11 is not handling array modification properly
          feed[i]. P = tray[feedStages[i] - 1].dummyP1;
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
  
end Distillation_Column;
