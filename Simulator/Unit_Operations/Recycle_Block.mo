within Simulator.Unit_Operations;

model Recycle_Block
  extends Simulator.Files.Icons.Mixer;
  //========================================================================================
  Real inMolFlo(start = Feed_flow) "inlet mixture molar flow rate", outMolFlo(start = Feed_flow) "outlet mixture molar flow rate", inP(start = Press) "Inlet pressure", outP(start = Press) "Outlet pressure", inT(start = Temp) "Inlet Temperature", outT(start = Temp) "Outlet Temperature";
  //========================================================================================
  Real inmixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "mixture mole fraction", outmixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac);
  parameter Integer NOC "number of components";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  //========================================================================================
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //=========================================================================================
  extends Simulator.Guess_Models.Initial_Guess;
equation
//connector equations
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFlo = inMolFlo;
  inlet.mixMolFrac[1, :] = inmixMolFrac[:];
  outlet.P = outP;
  outlet.T = outT;
  outlet.mixMolFlo = outMolFlo;
  outlet.mixMolFrac[1, :] = outmixMolFrac[:];
//=============================================================================================
  inMolFlo = outMolFlo;
//material balance
  inmixMolFrac = outmixMolFrac;
//energy balance
  inP = outP;
//pressure calculation
  inT = outT;
//temperature calculation
end Recycle_Block;
