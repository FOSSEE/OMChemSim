within Simulator.Unit_Operations;

model Cooler
  extends Simulator.Files.Icons.Cooler;
  // This is generic cooler model. For using this model we need to extend this model and incorporte ouput material stream since this model is not doing any flash calculations. Refer cooler models in Test section for this.
  //====================================================================================
  Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", heatRem "Heat removed", inP(start = Press) "Inlet pressure", outP(min = 0, start = 101325) "Outlet pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempDrop "Temperature Drop", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole Fraction";
  Real inMixMolEnth(start = PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(start = PhasMolEnth_mix_guess) "outlet mixture molar enthalpy";
  Real inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy", mixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor phase mole fraction";
  //========================================================================================
  parameter Real pressDrop "Pressure drop", eff "Efficiency";
  parameter Integer NOC "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  //========================================================================================
  Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
  extends Guess_Models.Initial_Guess;
equation
//connector equations
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFlo = inMolFlo;
  inlet.mixMolEnth = inMixMolEnth;
  inlet.mixMolEntr = inMixMolEntr;
  inlet.mixMolFrac[1, :] = mixMolFrac[:];
  inlet.vapPhasMolFrac = inVapPhasMolFrac;
  outlet.P = outP;
  outlet.T = outT;
  outlet.mixMolFlo = outMolFlo;
  outlet.mixMolEnth = outMixMolEnth;
  outlet.mixMolEntr = outMixMolEntr;
  outlet.mixMolFrac[1, :] = mixMolFrac[:];
  outlet.vapPhasMolFrac = outVapPhasMolFrac;
  energy.enFlo = heatRem;
//=============================================================================================
  inMolFlo = outMolFlo;
//material balance
  inMixMolEnth - eff * heatRem / inMolFlo = outMixMolEnth;
//energy balance
  inP - pressDrop = outP;
//pressure calculation
  inT - tempDrop = outT;
//temperature calculation
end Cooler;
