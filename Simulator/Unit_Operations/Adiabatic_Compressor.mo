within Simulator.Unit_Operations;

model Adiabatic_Compressor
  // This is generic Adibatic Compressor model. For using this model we need to extend this model and respective thermodynamic model and use the new model in flowsheets. Refer adia_comp models in Test section for this.
  extends Simulator.Files.Models.Flash;
  //====================================================================================
  Real inMolFlo(min = 0, start = 100) "inlet mixture molar flow rate", outMolFlo(min = 0, start = 100) "outlet mixture molar flow rate", reqPow "required Power", inP(min = 0, start = 101325) "Inlet pressure", outP(min = 0, start = 101325) "Outlet pressure", pressInc "Pressure Increase", inT(min = 0, start = 273.15) "Inlet Temperature", outT(min = 0, start = 273.15) "Outlet Temperature", tempInc "Temperature increase";
  Real inMixMolEnth "inlet mixture molar enthalpy", outMixMolEnth "outlet mixture molar enthalpy", inMixMolEntr "inlet mixture molar entropy", outMixMolEntr "outlet mixture molar entropy";
  Real inVapPhasMolFrac(min = 0, max = 1, start = 0.5) "Inlet vapor mol fraction", outVapPhasMolFrac(min = 0, max = 1, start = 0.5) "Outlet Vapor Mole fraction", mixMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "mixture mole fraction";
  parameter Real eff "Efficiency";
  parameter Integer NOC "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  //========================================================================================
  Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
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
  energy.enFlo = reqPow;
//=============================================================================================
  inMolFlo = outMolFlo;
//material balance
  outMixMolEnth = inMixMolEnth + (phasMolEnth[1] - inMixMolEnth) / eff;
  reqPow = inMolFlo * (phasMolEnth[1] - inMixMolEnth) / eff;
//energy balance
  inP + pressInc = outP;
//pressure calculation
  inT + tempInc = outT;
//temperature calculation
//=========================================================================
//ideal flash
  inMolFlo = totMolFlo[1];
  outP = P;
  inMixMolEntr = phasMolEntr[1];
  mixMolFrac[:] = compMolFrac[1, :];
end Adiabatic_Compressor;
