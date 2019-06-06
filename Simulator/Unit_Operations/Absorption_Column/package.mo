within Simulator.Unit_Operations;

package Absorption_Column
  model AbsTray
    import Simulator.Files.*;
    parameter Integer NOC;
    parameter Chemsep_Database.General_Properties comp[NOC];
    Real P(min = 0, start = 101325), T(min = 0, start = sum(comp[:].Tb) / NOC);
    Real vapMolFlo[2](each min = 0, each start = 100), liqMolFlo[2](each min = 0, each start = 100), vapCompMolFrac[2, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), liqCompMolFrac[2, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)), vapMolEnth[2], liqMolEnth[2], outVapCompMolEnth[NOC], outLiqCompMolEnth[NOC];
    Real compMolFrac[3, NOC](each min =0, each max = 0, each start = 1/(NOC + 1)), Pdew(min = 0, start = sum(comp[:].Pc)/NOC), Pbubl(min = 0, start = sum(comp[:].Pc)/NOC);
  
    Simulator.Files.Connection.trayConn liquid_inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn liquid_outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn vapor_outlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn vapor_inlet(connNOC = NOC) annotation(
      Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    compMolFrac[2, :] = liqCompMolFrac[2,:];
    compMolFrac[3, :] = vapCompMolFrac[2,:];  
    //Bubble point calculation
    Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
    //Dew point calculation
    Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
    
//molar balance
    vapMolFlo[1] .* vapCompMolFrac[1, :] + liqMolFlo[1] .* liqCompMolFrac[1, :] = vapMolFlo[2] .* vapCompMolFrac[2, :] + liqMolFlo[2] .* liqCompMolFrac[2, :];
//equillibrium
    vapCompMolFrac[2, :] = K[:] .* liqCompMolFrac[2, :];
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

end Absorption_Column;
