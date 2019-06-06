within Simulator.Unit_Operations;

model Mixer
  import Simulator.Files.*;
  parameter Integer NOC "Number of Components", NI = 6 "Number of Input streams";
  parameter Chemsep_Database.General_Properties comp[NOC];
  parameter String outPress;
  Real outP(min = 0, start = 101325), inP[NI](min = 0, start = 101325);
  Real inCompMolFrac[NI, NOC](each start = 1 / (NOC + 1), each min = 0, each max = 1) "Input stream component mol fraction", inMolFlo[NI](each min = 0, each start = 100) "Input stream Molar Flow";
  Real outCompMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Output Stream component mol fraction", outMolFlo(each min = 0, each start = 100) "Output stream Molar Flow";
  Real inTotMolEnth[NI] "Inlet molar enthalpy of each stream", outTotMolEnth "Outlet molar enthalpy";
  Real inT[NI](each min = 0, each start = 273.15) "Temperature of each stream", outT(each min = 0, each start = 273.15) "Temperature of outlet stream", inTotMolEntr[NI] "Inlet molar enthalpy of each stream", outTotMolEntr "Outlet molar entropy", inVapPhasMolFrac[NI](each min = 0, each max = 1, each start = 0.5) "Inlet vapor phase mol fraction", outVapPhasMolFrac(min = 0, max = 1, start = 0.5) "Outlet vapor phase mol fraction";
  //================================================================================
  //  Files.Connection.matConn inlet[NI](each connNOC = NOC);
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Files.Connection.matConn inlet[NI](each connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
//Connector equation
  for i in 1:NI loop
    inlet[i].P = inP[i];
    inlet[i].T = inT[i];
    inlet[i].mixMolFlo = inMolFlo[i];
    inlet[i].mixMolEnth = inTotMolEnth[i];
    inlet[i].mixMolEntr = inTotMolEntr[i];
    inlet[i].mixMolFrac[1, :] = inCompMolFrac[i, :];
    inlet[i].vapPhasMolFrac = inVapPhasMolFrac[i];
  end for;
  outlet.P = outP;
  outlet.T = outT;
  outlet.mixMolFlo = outMolFlo;
  outlet.mixMolEnth = outTotMolEnth;
  outlet.mixMolEntr = outTotMolEntr;
  outlet.mixMolFrac[1, :] = outCompMolFrac[:];
  outlet.vapPhasMolFrac = outVapPhasMolFrac;
//===================================================================================
//Output Pressure
  if outPress == "Inlet_Minimum" then
    outP = min(inP);
  elseif outPress == "Inlet_Average" then
    outP = sum(inP) / NI;
  elseif outPress == "Inlet_Maximum" then
    outP = max(inP);
  end if;
//Molar Balance
  outMolFlo = sum(inMolFlo[:]);
  for i in 1:NOC loop
    outCompMolFrac[i] * outMolFlo = sum(inCompMolFrac[:, i] .* inMolFlo[:]);
  end for;
//Energy balance
  outTotMolEnth = sum(inTotMolEnth[:] .* inMolFlo[:] / outMolFlo);
end Mixer;
