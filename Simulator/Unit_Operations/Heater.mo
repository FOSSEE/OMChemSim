within Simulator.Unit_Operations;

model Heater
  extends Simulator.Files.Icons.Heater;
  // This is generic heater model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer heater models in Test section for this.
  //========================================================================================
  Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", heatAdd "Heat added", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempInc "Temperature Increase", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole Fraction";
  Real inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "outlet mixture molar enthalpy";
  //========================================================================================
  parameter Real pressDrop "Pressure drop", eff "Efficiency";
  Real mixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor phase mole fraction";
  parameter Integer NOC "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  //========================================================================================
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //=========================================================================================
  extends Guess_Models.Initial_Guess;
equation
//connector equations
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFlo = inMolFlo;
  inlet.mixMolEnth = inMixMolEnth;
  inlet.mixMolFrac[1, :] = mixMolFrac[:];
  inlet.vapPhasMolFrac = inVapPhasMolFrac;
  outlet.P = outP;
  outlet.T = outT;
  outlet.mixMolFlo = outMolFlo;
  outlet.mixMolEnth = outMixMolEnth;
  outlet.mixMolFrac[1, :] = mixMolFrac[:];
  outlet.vapPhasMolFrac = outVapPhasMolFrac;
  energy.enFlo = heatAdd;
//=============================================================================================
  inMolFlo = outMolFlo;
//material balance
  inMixMolEnth + eff * heatAdd / inMolFlo = outMixMolEnth;
//energy balance
  inP - pressDrop = outP;
//pressure calculation
  inT + tempInc = outT;
//temperature calculation
end Heater;
