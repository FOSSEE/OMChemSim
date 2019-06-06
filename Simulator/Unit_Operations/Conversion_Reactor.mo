within Simulator.Unit_Operations;

model Conversion_Reactor
  //This is generic conversion reactor model. we need to extend reaction manager model with this model for using this model.
  parameter Real X[Nr] = fill(0.4, Nr) "Conversion of base component";
  parameter Integer NOC "Number of components";
  parameter Real pressDrop = 0 "pressure drop";
  parameter Real Tdef = 300 "Defined outlet temperature, only applicable if define outlet temperature mode is chosen";
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  parameter String calcMode = "Isothermal" "Isothermal, Define_Outlet_Temperature, Adiabatic; choose the required operation";
  Real inMolFlo(min = 0, start = 100) "Inlet Molar Flowrate";
  Real outMolFlo(min = 0, start = 100) "Outlet Molar Flowrate";
  Real inCompMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Inlet component Mole Fraction";
  Real outCompMolFrac[NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Outlet component Mole Fraction";
  Real inMixMolEnth "Inlet Molar Enthalpy";
  Real outMixMolEnth "Outlet Molar Enthalpy";
  Real inP(min = 0, start = 101325) "Inlet pressure";
  Real outP(min = 0, start = 101325) "Outlet pressure";
  Real inT(min = 0, start = 273.15) "Inlet Temperature";
  Real outT(min = 0, start = 273.15) "Outlet Temperature";
  Real N[NOC, Nr] "Number of moles of components after reactions";
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  inlet.P = inP;
  inlet.T = inT;
  inlet.mixMolFlo = inMolFlo;
  inlet.mixMolEnth = inMixMolEnth;
  inlet.mixMolFrac[1, :] = inCompMolFrac[:];
  outlet.P = outP;
  outlet.T = outT;
  outlet.mixMolFlo = outMolFlo;
  outlet.mixMolEnth = outMixMolEnth;
  outlet.mixMolFrac[1, :] = outCompMolFrac[:];
//Reactor equations
  for i in 1:NOC loop
    N[i, 1] = inMolFlo * inCompMolFrac[i] - Sc[i, 1] / Sc[Bc[1], 1] * inMolFlo * inCompMolFrac[Bc[1]] * X[1];
  end for;
  if Nr > 1 then
    for j in 2:Nr loop
      for i in 1:NOC loop
        N[i, j] = N[i, j - 1] - Sc[i, j] / Sc[Bc[j], j] * inMolFlo * inCompMolFrac[Bc[j]] * X[j];
      end for;
    end for;
  end if;
  outMolFlo = sum(N[:, Nr]);
  for i in 1:NOC loop
    outCompMolFrac[i] = N[i, Nr] / outMolFlo;
  end for;
  inP - pressDrop = outP;
  if calcMode == "Isothermal" then
    inT = outT;
    energy.enFlo = outMixMolEnth * outMolFlo - inMixMolEnth * inMolFlo;
  elseif calcMode == "Adiabatic" then
    outMixMolEnth * outMolFlo = inMixMolEnth * inMolFlo;
    energy.enFlo = 0;
  elseif calcMode == "Define_Outlet_Temperature" then
    outT = Tdef;
    energy.enFlo = outMixMolEnth * outMolFlo - inMixMolEnth * inMolFlo;
  end if;
end Conversion_Reactor;
