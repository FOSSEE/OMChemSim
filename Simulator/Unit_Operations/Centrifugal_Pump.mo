within Simulator.Unit_Operations;

model Centrifugal_Pump
  extends Simulator.Files.Icons.Centrifugal_Pump;
  parameter Integer NOC = 2 "Number of Components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] "Component array";
  Real inP(start = Press) "Inlet Pressure", outP(start = Press) "Outlet Pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempInc "Temperature increase", pressInc "Pressure Increase", inMixMolEnth(start = PhasMolEnth_mix_guess) "Inlet Mixture Molar Enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "Outlet Mixture Molar Enthalpy", reqPow "Power required", compDens[NOC](each min = 0) "Component density", dens(min = 0) "Density", vapPress(start = Press) "Vapor pressure of Mixture at outlet Temperature", NPSH "NPSH", inMixMolFlo(min = 0, start = Feed_flow) "inlet Mixture Molar Flow", outMixMolFlo(min = 0, start = Feed_flow) "Outlet Mixture Molar flow", inMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Inlet Mixuture Molar Fraction", outMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "Outlet Mixture Molar Fraction";
  parameter Real eff "efficiency";
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends Guess_Models.Initial_Guess;
equation
//Connector equation
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFlo = inMixMolFlo;
  inlet.mixMolEnth = inMixMolEnth;
  inlet.mixMolFrac[1, :] = inMixMolFrac[:];
  outlet.P = outP;
  outlet.T = outT;
  outlet.mixMolFlo = outMixMolFlo;
  outlet.mixMolEnth = outMixMolEnth;
  outlet.mixMolFrac[1, :] = outMixMolFrac[:];
  energy.enFlo = reqPow;
//Pump equations
//balance
  inMixMolFlo = outMixMolFlo;
  inMixMolFrac = outMixMolFrac;
  inP + pressInc = outP;
  inT + tempInc = outT;
//density
  for i in 1:NOC loop
    compDens[i] = Simulator.Files.Thermodynamic_Functions.Dens(comp[i].LiqDen, comp[i].Tc, inT, inP);
  end for;
  dens = 1 / sum(inMixMolFrac ./ compDens);
//energy balance
  outMixMolEnth = inMixMolEnth + pressInc / dens;
  reqPow = inMixMolFlo * (outMixMolEnth - inMixMolEnth) / eff;
//NPSH
  NPSH = (inP - vapPress) / dens;
//vap pressure of mixture at outT
  vapPress = sum(inMixMolFrac .* exp(comp[:].VP[2] + comp[:].VP[3] / outT + comp[:].VP[4] * log(outT) + comp[:].VP[5] .* outT .^ comp[:].VP[6]));
end Centrifugal_Pump;
