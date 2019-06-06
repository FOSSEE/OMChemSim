within Simulator.Unit_Operations;

model Centrifugal_Pump
  parameter Integer NOC = 2 "Number of Components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC] "Component array";
  Real inP(min = 0, start = 101325) "Inlet Pressure", outP(min = 0, start = 101325) "Outlet Pressure", inT(min = 0, start = 273.15) "Inlet Temperature", outT(min = 0, start = 273.15) "Outlet Temperature", tempInc "Temperature increase", pressInc "Pressure Increase", inMixMolEnth "Inlet Mixture Molar Enthalpy", outMixMolEnth "Outlet Mixture Molar Enthalpy", reqPow "Power required", compDens[NOC](each min = 0) "Component density", dens(min = 0) "Density", vapPress(min = 0, start = 101325) "Vapor pressure of Mixture at outlet Temperature", NPSH "NPSH", inMixMolFlo(min = 0, start = 100) "inlet Mixture Molar Flow", outMixMolFlo(min = 0, start = 100) "Outlet Mixture Molar flow", inMixMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Inlet Mixuture Molar Fraction", outMixMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Outlet Mixture Molar Fraction";
  parameter Real eff "efficiency";
  Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
