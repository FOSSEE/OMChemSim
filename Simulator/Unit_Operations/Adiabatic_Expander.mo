within Simulator.Unit_Operations;

model Adiabatic_Expander
  extends Simulator.Files.Icons.Adiabatic_Expander;
  // This is generic Adibatic Expander model. For using this model we need to extend this model and respective thermodynamic model and use the new model in flowsheets. Refer adia_comp models in Test section for this.
  extends Simulator.Files.Models.Flash;
  //====================================================================================
  Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", genPow "generated Power", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", pressDrop "Pressure Drop", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature", tempDrop "Temperature increase";
  Real inMixMolEnth(PhasMolEnth_mix_guess) "inlet mixture molar enthalpy", outMixMolEnth(PhasMolEnth_mix_guess) "outlet mixture molar enthalpy", inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy";
  Real inVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Inlet vapor mol fraction", outVapPhasMolFrac(min = 0, max = 1, start = Beta_guess) "Outlet Vapor Mole fraction", mixMolFrac[NOC](start = CompMolFrac) "mixture mole fraction";
  parameter Real eff "Efficiency";
  parameter Integer NOC "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  //========================================================================================
  Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  energy.enFlo = genPow;
//=============================================================================================
  inMolFlo = outMolFlo;
//material balance
  outMixMolEnth = inMixMolEnth + (phasMolEnth[1] - inMixMolEnth) * eff;
  genPow = inMolFlo * (phasMolEnth[1] - inMixMolEnth) * eff;
//energy balance
  inP - pressDrop = outP;
//pressure calculation
  inT - tempDrop = outT;
//temperature calculation
//=========================================================================
//ideal flash
  inMolFlo = totMolFlo[1];
  outP = P;
  inMixMolEntr = phasMolEntr[1];
  mixMolFrac[:] = compMolFrac[1, :];
end Adiabatic_Expander;
