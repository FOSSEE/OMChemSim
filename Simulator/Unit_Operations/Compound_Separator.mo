within Simulator.Unit_Operations;

model Compound_Separator
  extends Simulator.Files.Icons.Compound_Separator;
  parameter Integer NOC "Number of components", sepStrm "Specified Stream";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] "Components array";
  Real inP(start = Press) "inlet pressure", inT(start = Temp) "inlet temperature", inMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "inlet mixture mole fraction", inMixMolFlo(start = Feed_flow) "inlet mixture molar flow", inCompMolFlo[NOC](each min = 0, each start = Feed_flow) "inlet compound molar flow", inCompMasFlo[NOC](each min = 0, each start = Feed_flow) "inlet compound mass flow", inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy";
  Real outP[2](each min = 0, start = {Press, Press}) "outlet Pressure", outT[2](each min = 0, start = {Temp, Temp}) "outlet temperature", outMixMolFrac[2, NOC](each min = 0, each max = 1, start = CompMolFrac) "outlet mixture mole fraction", outMixMolFlo[2](each min = 0, each start = Feed_flow) "Outlet mixture molar flow", outCompMolFlo[2, NOC](each min = 0, each start = Feed_flow) "outlet compounds molar flow", outCompMasFlo[2, NOC](each min = 0, each start = Feed_flow) "outlet compound mass flow", outMixMolEnth[2] "outlet mixture molar enthalpy";
  Real enReq "energy required";
  Real sepFactVal[NOC] "Separation factor value";
  parameter String sepFact[NOC] "Separation factor";
  // separation factor: Molar_Flow, Mass_Flow, Inlet_Molar_Flow_Percent, Inlet_Mass_Flow_Percent.
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet1(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet2(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends Guess_Models.Initial_Guess;
equation
// Connector equation
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFlo = inMixMolFlo;
  inlet.mixMolFrac[1, :] = inMixMolFrac[:];
  inlet.mixMolEnth = inMixMolEnth;
  outlet1.P = outP[1];
  outlet1.T = outT[1];
  outlet1.mixMolFlo = outMixMolFlo[1];
  outlet1.mixMolFrac[1, :] = outMixMolFrac[1, :];
  outlet1.mixMolEnth = outMixMolEnth[1];
  outlet2.mixMolFlo = outMixMolFlo[2];
  outlet2.mixMolFrac[1, :] = outMixMolFrac[2, :];
  outlet2.mixMolEnth = outMixMolEnth[2];
  outlet2.P = outP[2];
  outlet2.T = outT[2];
  energy.enFlo = enReq;
// Pressure and temperature equations
  outP[1] = inP;
  outP[2] = inP;
  outT[1] = inT;
  outT[2] = inT;
// mole balance
  inMixMolFlo = sum(outMixMolFlo[:]);
  inCompMolFlo[:] = outMixMolFrac[1, :] * outMixMolFlo[1] + outMixMolFrac[2, :] * outMixMolFlo[2];
// Conversion
  inCompMolFlo = inMixMolFrac .* inMixMolFlo;
  inCompMasFlo = inCompMolFlo .* comp[:].MW;
  for i in 1:2 loop
    outCompMolFlo[i, :] = outMixMolFrac[i, :] .* outMixMolFlo[i];
    outCompMasFlo[i, :] = outCompMolFlo[i, :] .* comp[:].MW;
  end for;
  sum(outMixMolFrac[2, :]) = 1;
  for i in 1:NOC loop
    if sepFact[i] == "Molar_Flow" then
      sepFactVal[i] = outCompMolFlo[sepStrm, i];
    elseif sepFact[i] == "Mass_Flow" then
      sepFactVal[i] = outCompMasFlo[sepStrm, i];
    elseif sepFact[i] == "Inlet_Molar_Flow_Percent" then
      outCompMolFlo[sepStrm, i] = sepFactVal[i] * inCompMolFlo[i] / 100;
    elseif sepFact[i] == "Inlet_Mass_Flow_Percent" then
      outCompMasFlo[sepStrm, i] = sepFactVal[i] * inCompMasFlo[i] / 100;
    end if;
  end for;
//Energy balance
  enReq = sum(outMixMolEnth .* outMixMolFlo) - inMixMolFlo * inMixMolEnth;
  annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    __OpenModelica_commandLineOptions = "");
end Compound_Separator;
