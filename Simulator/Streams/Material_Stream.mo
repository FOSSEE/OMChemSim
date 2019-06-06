within Simulator.Streams;

model Material_Stream
  //1 -  Mixture, 2 - Liquid phase, 3 - Gas Phase
  extends Modelica.Icons.SourcesPackage;
  import Simulator.Files.*;
  parameter Integer NOC;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  Real P(min = 0, start = 101325) "Pressure", T(start = 273) "Temperature";
  Real Pbubl(min = 0, start = sum(comp[:].Pc) / NOC) "Bubble point pressure", Pdew(min = 0, start = sum(comp[:].Pc) / NOC) "dew point pressure";
  Real liqPhasMolFrac(start = 0.5, min = 0, max = 1) "Liquid Phase mole fraction", vapPhasMolFrac(start = 0.5, min = 0, max = 1) "Vapor Phase mole fraction", liqPhasMasFrac(start = 0.5, min = 0, max = 1) "Liquid Phase mass fraction", vapPhasMasFrac(start = 0.5, min = 0, max = 1) "Vapor Phase Mass fraction";
  Real totMolFlo[3](each min = 0, each start = 100) "Total molar flow", totMasFlo[3](each min = 0, each start = 100) "Total Mass Flow", MW[3](each start = 0, each min = 0) "Average Molecular weight of Phases";
  Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Component mole fraction", compMasFrac[3, NOC](each start = 1 / (NOC + 1), each min = 0, each max = 1) "Component Mass fraction", compMolFlo[3, NOC](each start = 100, each min = 0) "Component Molar flow", compMasFlo[3, NOC](each min = 0, each start = 100) "Component Mass Fraction";
  Real phasMolSpHeat[3] "phase Molar Specific Heat", compMolSpHeat[3, NOC] "Component Molar Specific Heat";
  Real phasMolEnth[3] "Phase Molar Enthalpy", compMolEnth[3, NOC] "Component Molar Enthalpy";
  Real phasMolEntr[3] "Phase Molar Entropy", compMolEntr[3, NOC] "Component Molar Entropy";
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Connector equations
  inlet.P = P;
  inlet.T = T;
  inlet.mixMolFlo = totMolFlo[1];
  inlet.mixMolEnth = phasMolEnth[1];
  inlet.mixMolEntr = phasMolEntr[1];
  inlet.mixMolFrac = compMolFrac;
  inlet.vapPhasMolFrac = vapPhasMolFrac;
  outlet.P = P;
  outlet.T = T;
  outlet.mixMolFlo = totMolFlo[1];
  outlet.mixMolEnth = phasMolEnth[1];
  outlet.mixMolEntr = phasMolEntr[1];
  outlet.mixMolFrac = compMolFrac;
  outlet.vapPhasMolFrac = vapPhasMolFrac;
//=====================================================================================
//Mole Balance
  totMolFlo[1] = totMolFlo[2] + totMolFlo[3];
  compMolFrac[1, :] .* totMolFlo[1] = compMolFrac[2, :] .* totMolFlo[2] + compMolFrac[3, :] .* totMolFlo[3];
//component molar and mass flows
  for i in 1:NOC loop
    compMolFlo[:, i] = compMolFrac[:, i] .* totMolFlo[:];
  end for;
  if P >= Pbubl then
//below bubble point region
    compMasFrac[3, :] = zeros(NOC);
    compMasFlo[1, :] = compMasFrac[1, :] .* totMasFlo[1];
    compMasFrac[2, :] = compMasFrac[1, :];
  elseif P >= Pdew then
    for i in 1:NOC loop
      compMasFlo[:, i] = compMasFrac[:, i] .* totMasFlo[:];
    end for;
  else
//above dew point region
    compMasFrac[2, :] = zeros(NOC);
    compMasFlo[1, :] = compMasFrac[1, :] .* totMasFlo[1];
    compMasFrac[3, :] = compMasFrac[1, :];
  end if;
//phase molar and mass fractions
  liqPhasMolFrac = totMolFlo[2] / totMolFlo[1];
  vapPhasMolFrac = totMolFlo[3] / totMolFlo[1];
  liqPhasMasFrac = totMasFlo[2] / totMasFlo[1];
  vapPhasMasFrac = totMasFlo[3] / totMasFlo[1];
//Conversion between mole and mass flow
  for i in 1:NOC loop
    compMasFlo[:, i] = compMolFlo[:, i] * comp[i].MW;
  end for;
  totMasFlo[:] = totMolFlo[:] .* MW[:];
//Energy Balance
  for i in 1:NOC loop
//Specific Heat and Enthalpy calculation
    compMolSpHeat[2, i] = Thermodynamic_Functions.LiqCpId(comp[i].LiqCp, T);
    compMolSpHeat[3, i] = Thermodynamic_Functions.VapCpId(comp[i].VapCp, T);
    compMolEnth[2, i] = Thermodynamic_Functions.HLiqId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
    compMolEnth[3, i] = Thermodynamic_Functions.HVapId(comp[i].SH, comp[i].VapCp, comp[i].HOV, comp[i].Tc, T);
    (compMolEntr[2, i], compMolEntr[3, i]) = Thermodynamic_Functions.SId(comp[i].AS, comp[i].VapCp, comp[i].HOV, comp[i].Tb, comp[i].Tc, T, P, compMolFrac[2, i], compMolFrac[3, i]);
  end for;
  for i in 2:3 loop
    phasMolSpHeat[i] = sum(compMolFrac[i, :] .* compMolSpHeat[i, :]) + resMolSpHeat[i];
    phasMolEnth[i] = sum(compMolFrac[i, :] .* compMolEnth[i, :]) + resMolEnth[i];
    phasMolEntr[i] = sum(compMolFrac[i, :] .* compMolEntr[i, :]) + resMolEntr[i];
  end for;
  phasMolSpHeat[1] = liqPhasMolFrac * phasMolSpHeat[2] + vapPhasMolFrac * phasMolSpHeat[3];
  compMolSpHeat[1, :] = compMolFrac[1, :] .* phasMolSpHeat[1];
  phasMolEnth[1] = liqPhasMolFrac * phasMolEnth[2] + vapPhasMolFrac * phasMolEnth[3];
  compMolEnth[1, :] = compMolFrac[1, :] .* phasMolEnth[1];
  phasMolEntr[1] = liqPhasMolFrac * phasMolEntr[2] + vapPhasMolFrac * phasMolEntr[3];
  compMolEntr[1, :] = compMolFrac[1, :] * phasMolEntr[1];
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
  if P >= Pbubl then
//below bubble point region
    compMolFrac[3, :] = zeros(NOC);
    sum(compMolFrac[2, :]) = 1;
  elseif P >= Pdew then
//VLE region
    for i in 1:NOC loop
      compMolFrac[3, i] = K[i] * compMolFrac[2, i];
    end for;
    sum(compMolFrac[3, :]) = 1;
//sum y = 1
  else
//above dew point region
    compMolFrac[2, :] = zeros(NOC);
    sum(compMolFrac[3, :]) = 1;
  end if;
algorithm
  for i in 1:NOC loop
    MW[:] := MW[:] + comp[i].MW * compMolFrac[:, i];
  end for;

end Material_Stream;
