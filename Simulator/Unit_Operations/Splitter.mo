within Simulator.Unit_Operations;

model Splitter
  extends Simulator.Files.Icons.Splitter;
  parameter Integer NOC = 2 "number of Components", NO = 2 "number of outputs";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  Real inP(start = Press) "inlet pressure", inT(start = Temp) "Inlet Temperature", outP[NO](start = {Press, Press}) "Outlet Pressure", outT[NO](start = {Temp, Temp}) "Outlet Temperature", inMixMolFrac[NOC](each min = 0, each max = 1, start = CompMolFrac) "inlet Mixture Mole Fraction", outMixMolFrac[NO, NOC](each min = 0, each max = 1, start = {CompMolFrac, CompMolFrac}) "Outlet Mixture Molar Fraction", splRat[NO](each min = 0, each max = 1) "Split ratio", MW(each min = 0) "Stream molecular weight", inMixMolFlo(start = Feed_flow) "inlet Mixture Molar Flow", outMixMolFlo[NO](each min = 0, start = Feed_flow) "Outlet Mixture Molar Flow", outMixMasFlo[NO](each min = 0, each start = Feed_flow) "Outlet Mixture Mass Flow", specVal[NO] "Specification value";
  parameter String calcType "Split_Ratio, Mass_Flow or Molar_Flow";
  //  Simulator.Files.Connection.matConn outlet[NO](each connNOC = NOC);
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet[NO](each connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends Guess_Models.Initial_Guess;
equation
//Connector equations
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFrac[1, :] = inMixMolFrac[:];
  inlet.mixMolFlo = inMixMolFlo;
  for i in 1:NO loop
    outlet[i].P = outP[i];
    outlet[i].T = outT[i];
    outlet[i].mixMolFrac[1, :] = outMixMolFrac[i, :];
    outlet[i].mixMolFlo = outMixMolFlo[i];
  end for;
//specification value assigning equation
  if calcType == "Split_Ratio" then
    splRat[:] = specVal[:];
  elseif calcType == "Molar_Flow" then
    outMixMolFlo[:] = specVal[:];
  elseif calcType == "Mass_Flow" then
    outMixMasFlo[:] = specVal[:];
  end if;
//balance equation
  for i in 1:NO loop
    inP = outP[i];
    inT = outT[i];
    inMixMolFrac[:] = outMixMolFrac[i, :];
    splRat[i] = outMixMolFlo[i] / inMixMolFlo;
    MW * outMixMolFlo[i] = outMixMasFlo[i];
  end for;
algorithm
  MW := 0;
  for i in 1:NOC loop
    MW := MW + comp[i].MW * inMixMolFrac[i];
  end for;
end Splitter;
