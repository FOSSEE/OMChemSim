within Simulator.Unit_Operations;

model CSTR
  import data = Simulator.Files.Chemsep_Database;
  parameter data.General_Properties comp[NOC];
  import Simulator.Files.*;
  import Simulator.Files.Thermodynamic_Functions.*;
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //================
  //Variables
  parameter Integer NOC;
  parameter Real Phase;
  Real inTotMasFlo[3](each min = 0) "Inlet Mass Flow", outTotMasFlo[3](each min = 0) "Outlet Mass Flow";
  parameter Real pressDrop "pressure drop";
  Real V_Rxn;
  //==================
  //Density Variables
  Real inLiqDens[NOC] "Density of Liquid";
  Real inVapDens[NOC] "Density of Vapor", PhaseDens "Mixture Density";
  Real outLiqDens[NOC] "Density of Liquid";
  Real outVapDens[NOC] "Density of Vapor";
  Real outPhaseDens "Mixture Density";
  //==================
  //Volumetric Flow Variables
  Real inPhasevolflo(min = 0.003063) "Volumetic flowrate of Phase";
  Real outPhasevolflo(min = 0.0025) "Volumetic flowrate of Phase";
  Real inVO_L(start = 0.01), inVO_V(start = 0.01), outVO_L(start = 1), outVO_V(start = 1);
  //=================
  //Molecular Weights
  Real MWphase(min = 0) "Phase Molecular Weight", MWliq(min = 0) "Liquid Molecular Weight", MWvap(min = 0) "Vapor Molecular Weight";
  Real outMWphase(min = 0) "Phase Molecular Weight", outMWliq "Liquid Molecular Weight", outMWvap "Vapor Molecular Weight";
  //================
  //Reaction Variables
  Real k1[Nr] "Rate Constant of the reaction";
  Integer n;
  Real r[Nr] "Rate of reaction";
  parameter Integer Nr "Number of Reaction";
  Real V(min = 0.1) "Volume of Reactor";
  parameter Real V_HS(min = 0.1) "Head space reactor volume";
  parameter Integer Bc[Nr] "Base component";
  parameter Real Sc[NOC, Nr] "Stochiometry";
  Real FO[NOC, Nr](each min = 0) "Inlet Molar flow of BC", F[NOC, Nr](each min = 0) "Outlet Molar Flow", X[Nr] "Conversion of BC for the reaction", C[Bc[Nr], Nr](each min = 0) "Outlet Concentration";
  //================
  //Flow Variables
  Real a, b, c, d;
  Real rhoinL, rhoinV, rhooutL, rhooutV;
  Real P(min = 0, start = 101325) "Inlet Pressure", T "Inlet Temperature";
  Real outP(min = 0, start = 101325) "Outlet Pressure", outT "Outlet Temperature";
  Real H_in "Mixture Mol Enthalpy in the inlet", S_in "Mixture Mol Entropy in the inlet";
  Real H_out "Mixture Mol Enthalpy in the outlet", S_out "Mixture Mol Entropy in the outlet";
  //Real H_vap "Vapor Mol Enthalpy", S_vap "Vapor Mol Entropy";
  Real Vapfrac(start = 0) "Vapor fraction in the inlet", outVapfrac "Vapor fraction in outlet";
  // vapvapfrac "Vapor phase vapor fraction";
  Real inTotMolFlo[3](start = 10) "Inlet Molar Flow", outTotMolFlo[3] "Outlet Molar Flow";
  // vapflo[3] "Vapor Molar Flowrate";
  Real compMolFrac[3, NOC](each start = 0.25) "Component Mole Fraction", outcompMolFrac[3, NOC] "Component Mole Fraction at outlet";
  Real compMasFrac[3, NOC](each start = 0.25) "Component Mole Fraction", outcompMasFrac[3, NOC](each start = 0.6638065) "Component Mole Fraction at outlet";
  //,vapmolfrac[3,NOC] "Component Mole Fraction";
  //=============================
  //Inlet and outlet component mole fraction and flow
  Real compMolFlo[3, NOC](each start = 10) "Component Mole Flow";
  Real outcompMolFlo[3, NOC](each start = 10) "Component Mole Flow at outlet";
  //=====================
  //Mode of calculations
  parameter Real Mode "Mode of Operating the reactor";
  Real Rxnheat "Heat of Reaction";
  parameter Real Tdef "Outlet temperature desired";
  //=================
  //Vapor Pressure Variables
  Real inPsat[NOC] "Saturated vapor pressure at inlet", outPsat[NOC] "Saturated vapor pressure at outlet";
  Real Beta, Betain;
  Real Pb, Pd;
  //=================
  Real En_flo "Heat added to /removed from reactor depends on reaction";
  Simulator.Files.Connection.matConn Feed(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-86, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-96, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Liquid(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {36, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {38, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn Q annotation(
    Placement(visible = true, transformation(origin = {-52, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-48, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  extends Simulator.Files.Models.ReactionManager.Reaction_Manager(Nr = 1, Bc = {1},Comp = 3, Sc = {{-1}, {-1}, {1}}, DO = {{1}, {0}, {0}}, RO = {{0}, {0}, {0}}, A1 = {0.5}, E1 = {0}, A2 = {0}, E2 = {0});
  
equation
//=========================
//Connector-Equations
  Feed.P = P;
  Feed.T = T;
  Feed.mixMolFlo = inTotMolFlo[1];
  Feed.mixMolEnth = H_in;
  Feed.mixMolEntr = S_in;
  Feed.mixMolFrac[:, :] = compMolFrac[:, :];
  Feed.vapPhasMolFrac = Vapfrac;
  Liquid.P = outP;
  Liquid.T = outT;
  Liquid.mixMolFlo = outTotMolFlo[1];
  Liquid.mixMolEnth = H_out;
//H_out = -26141.6;
  Liquid.mixMolEntr = S_out;
  Liquid.mixMolFrac[1, :] = outcompMolFrac[1, :];
  //Liquid.vapPhasMolFrac = outVapfrac;

  Q.enFlo = En_flo;
//==========================
// Molar Flowrates of NOC for 1 reaction
  for i in 1:NOC loop
    FO[i, 1] = inTotMolFlo[1] .* compMolFrac[1, i];
    if Nr == 1 then
//F[i,1] = FO[i,1] - (Sc[i,1] / Sc[Bc[1],1]) * X[1] * FO[Bc[1],1];
      F[i, 1] = FO[i, 1] + Sc[i, 1] * r[1] * V_Rxn;
    end if;
  end for;
  X[1] = (FO[1,1] - F[1,1]) / FO[1,1] ; 
//  for i in 1:Nr loop
//  V_Rxn = (FO[Bc[i], i] - F[Bc[i],i]) ./ r[i] ;
//  end for;
//===========================
//Molar Flowrates for NOC more than 1 reaction
//  if Nr > 1 then
//  for i in 1:NOC loop
//  for j in 2:Nr loop
//  FO[i,j] = inTotMolFlo[1] .* compMolFrac[1, i];
//  F[i,j] = FO[i,j] - (Sc[i, j] / Sc[Bc[j],j]) .* X[j] .* FO[Bc[j],j];
//  end for;
//  end for;
//  end if;

//==========================================================================================================
//Bubble point calculation
  Pb = sum(gammaBubl[:] .* outcompMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pd = 1 / sum(outcompMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / outT + comp[:].VP[4] * log(outT) + comp[:].VP[5] .* outT .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
if P >= Pb then
//below bubble point region
    outcompMolFrac[3, :] = zeros(NOC);
    sum(outcompMolFrac[2, :]) = 1;
  elseif P <= Pd then
//above dew point region
    outcompMolFrac[2, :] = zeros(NOC);
    sum(outcompMolFrac[3, :]) = 1;
  else
//VLE region
    for i in 1:NOC loop
      outcompMolFrac[3, i] = K[i] * outcompMolFrac[2, i];
    end for;
    sum(outcompMolFrac[2, :]) = 1;
//sum y = 1
  end if;
//Rachford Rice Equation
  for i in 1:NOC loop
    outcompMolFrac[1, i] = outcompMolFrac[3, i] * outVapfrac + outcompMolFrac[2, i] * (1 - outVapfrac);
  end for;
//

//========================
//Inlet and Outlet Component Mole flow and fractions
  inTotMolFlo[2] = inTotMolFlo[1] * (1 - Vapfrac);
  inTotMolFlo[3] = inTotMolFlo[1] * Vapfrac;
  outTotMolFlo[1] = sum(F[:, :]);
  outTotMolFlo[2] = outTotMolFlo[1] * (1 - outVapfrac);
  outTotMolFlo[3] = outTotMolFlo[1] * outVapfrac;
  for i in 1:3 loop
    compMolFlo[:, i] = inTotMolFlo[:] .* compMolFrac[:, i];
    outcompMolFlo[:, i] = outTotMolFlo[:] .* outcompMolFrac[:, i];
  end for;
  for i in 1:NOC loop
    outcompMolFrac[1, i] = sum(F[i, :]) / outTotMolFlo[1];
  end for;
  for i in 1:NOC loop
    inPsat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, T);
    outPsat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP, outT);
  end for;
//===========================
//Component Mass fraction in inlet and outlet
  for i in 1:NOC loop
    compMasFrac[1, i] = compMolFrac[1, i] * comp[i].MW / sum(compMolFrac[1, :] .* comp[:].MW);
    outcompMasFrac[1, i] = outcompMolFrac[1, i] * comp[i].MW / sum(outcompMolFrac[1, :] .* comp[:].MW);
    if MWliq == 0 then
      compMasFrac[2, i] = 0;
    else
      compMasFrac[2, i] = compMolFrac[2, i] * comp[i].MW / MWliq;
    end if;
    if outMWliq == 0 then
      outcompMasFrac[2, i] = 0;
    else
      outcompMasFrac[2, i] = outcompMolFrac[2, i] * comp[i].MW / outMWliq;
    end if;
    if MWvap == 0 then
      compMasFrac[3, i] = 0;
    else
      compMasFrac[3, i] = compMolFrac[3, i] * comp[i].MW / MWvap;
    end if;
    if outMWvap == 0 then
      outcompMasFrac[3, i] = 0;
    else
      outcompMasFrac[3, i] = outcompMolFrac[3, i] * comp[i].MW / outMWvap;
    end if;
  end for;
//=======================
// Molecular weight and Density Calculation at the inlet
  MWphase = MWvap * Vapfrac + MWliq * (1 - Vapfrac);
//Inlet Phase MW
  MWvap = sum(compMolFrac[3, :] .* comp[:].MW);
// Inlet vapor MW
  MWliq = sum(compMolFrac[2, :] .* comp[:].MW);
// Inlet Liquid MW
  inLiqDens[:] = Thermodynamic_Functions.Density_Racket(NOC, T, P, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, inPsat[:]);
  outLiqDens[:] = Thermodynamic_Functions.Density_Racket(NOC, outT, outP, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, outPsat[:]);
  for i in 1:NOC loop
    inVapDens[i] = P .* comp[i].MW / (8.314 * T) * 1E-03;
    outVapDens[i] = outP .* comp[i].MW / (8.314 * outT) * 1E-03;
  end for;
  a = sum(compMolFrac[2, :] ./ inLiqDens[:]);
  b = sum(compMasFrac[3, :] ./ inVapDens[:]);
//====================
//Calculation of phase density and volumetric flowrates
  if Vapfrac == 0 then
    rhoinL = 1 / a;
    inVO_L = inTotMasFlo[2] / (1000 * rhoinL);
    rhoinV = 0;
    inVO_V = 0;
    PhaseDens = rhoinL;
  elseif Vapfrac == 1 then
    inVO_L = 0;
    rhoinL = 0;
    rhoinV = 1 / b;
    inVO_V = inTotMasFlo[3] / (1000 * rhoinV);
    PhaseDens = rhoinV;
  else
    rhoinL = 1 / a;
    if b == 0 then
      rhoinV = 0;
      PhaseDens = rhoinL;
      inVO_V = 0;
      inVO_L = inPhasevolflo;
    else
      rhoinV = 1 / b;
      inVO_L = inTotMasFlo[2] / (1000 * rhoinL);
      inVO_V = inTotMasFlo[3] / (1000 * rhoinV);
      PhaseDens = 1 / (Betain / rhoinV + (1 - Betain) / rhoinL);
    end if;
  end if;
//=======================
//Inlet and Outlet Mass flowrate
  inTotMasFlo[1] = inTotMolFlo[1] * MWphase;
  inTotMasFlo[2] = inTotMolFlo[2] * MWliq;
  inTotMasFlo[3] = inTotMolFlo[3] * MWvap;
  outTotMasFlo[1] = outTotMolFlo[1] * outMWphase;
// Outlet Total Mass flow
  outTotMasFlo[2] = outTotMolFlo[2] * outMWliq;
  outTotMasFlo[3] = outTotMolFlo[3] * outMWvap;
  Betain = inTotMasFlo[3] / inTotMasFlo[1];
  Beta = outTotMasFlo[3] / outTotMasFlo[1];
//=======================
// Molecular weight and Density Calculation at the outlet
  outMWphase = outMWvap * outVapfrac + outMWliq * (1 - outVapfrac);
  outMWvap = sum(outcompMolFrac[3, :] .* comp[:].MW);
  outMWliq = sum(outcompMolFrac[2, :] .* comp[:].MW);
  c = sum(outcompMolFrac[2, :] ./ outLiqDens[:]);
  d = sum(outcompMasFrac[3, :] ./ outVapDens[:]);
//================
//Calculation of Outlet density and Volumetric flowrates
  if outVapfrac == 0 then
    rhooutL = 1 / c;
    outVO_L = outTotMasFlo[2] / (1000 * rhooutL);
    rhooutV = 0;
    outVO_V = 0;
    outPhaseDens = rhooutL;
  elseif outVapfrac == 1 then
    rhooutL = 0;
    outVO_L = 0;
    rhooutV = 1 / d;
    outVO_V = outTotMasFlo[3] / (1000 * rhooutV);
    outPhaseDens = rhooutV;
  else
    rhooutL = 1 / c;
    if d == 0 then
      rhooutV = 0;
      outPhaseDens = rhooutL;
      outVO_V = 0;
      outVO_L = outPhasevolflo;
    else
      rhooutV = 1 / d;
      outVO_L = outTotMasFlo[2] / (1000 * rhooutL);
      outVO_V = outTotMasFlo[3] / (1000 * rhooutV);
      outPhaseDens = 1 / (Beta / rhooutV + (1 - Beta) / rhooutL);
    end if;
  end if;
//=======================
//Volumetric Flowrates at inlet and outlet
  inPhasevolflo = inTotMasFlo[1] / (PhaseDens * 1000);
  outPhasevolflo = outTotMasFlo[1] / (outPhaseDens * 1000);
//==========================
//Rate of reaction and Rate contant
  if Nr == 1 then
    if Phase == 1 then
      C[Bc[:], 1] = outcompMolFlo[1, Bc[:]] ./ outPhasevolflo;
    elseif Phase == 2 then
      C[Bc[:], 1] = outcompMolFlo[2, Bc[:]] ./ outVO_L;
    elseif Phase == 3 then
      C[Bc[:], 1] = outcompMolFlo[3, Bc[:]] ./ outVO_V;
    end if;
  end if;
  n = sum(DO[:]);
  k1[:] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, A1[:], E1[:], T);
//===========================
//Performance Equation
  for i in 1:Nr loop
    r[i] = k1[i] * C[Bc[i], i]^n;
  end for;
  if Phase == 1 then
    V + V_HS = V_Rxn;
  elseif Phase == 2 then
    V * (outVO_L / outPhasevolflo) = V_Rxn;
  elseif Phase == 3 then
    V * (outVO_V / outPhasevolflo) = V_Rxn;
  end if;
  outP = P - pressDrop;
//====================
//Energy Balance
//Isothermal Operation
  if Mode == 1 then
    Rxnheat = HOR[1] * 1E-3 .* FO[Bc[Nr], Nr] .* X[Nr];
    En_flo = inTotMolFlo[1] * H_in - outTotMolFlo[1] * H_out - Rxnheat;
    T = outT;
//Outlet Temperature Defined
  elseif Mode == 2 then
    outT = Tdef;
    Rxnheat = HOR[1] * 1E-3 * FO[Bc[Nr], Nr] .* X[Nr];
    En_flo = inTotMolFlo[1] * H_in - outTotMolFlo[1] * H_out - Rxnheat;
//Adiabatic Operation
  elseif Mode == 3 then
    Rxnheat = HOR[1] * 1E-3 * FO[Bc[Nr], Nr] .* X[Nr];
    En_flo = 0;
    En_flo = inTotMasFlo[1] * H_in - outTotMasFlo[1] * H_out - Rxnheat;
  end if;
  annotation(
    Icon(graphics = {Rectangle(origin = {-23, 10}, lineColor = {4, 89, 24}, extent = {{-41, 40}, {39, -28}}), Line(origin = {-26, 25}, points = {{0, 35}, {0, -35}, {0, -35}, {0, -35}}, color = {54, 109, 81}), Ellipse(origin = {-42, -7}, extent = {{16, -3}, {-16, 3}}, endAngle = 360), Ellipse(origin = {-9, -7}, lineColor = {53, 107, 79}, extent = {{-17, -3}, {17, 3}}, endAngle = 360), Line(origin = {-24, 20}, points = {{-40, 0}, {40, 0}}, color = {49, 98, 0}, pattern = LinePattern.Dash, thickness = 0.5)}));
end CSTR;
