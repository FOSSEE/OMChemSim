within Simulator.Unit_Operations.PF_Reactor;

model PFR
  //Plug Flow Reactor
  //Instantiation of Simulator-Package
  import Simulator.Files.*;
  import Simulator.Files.Thermodynamic_Functions.*;
  parameter Simulator.Files.Chemsep_Database.General_Properties comp[NOC];
  parameter Integer NOC "number of compounds ";
  parameter Integer Nr "Number of reactions";
  //Input Variables-Connector
  Real T(min = 0, start = 273.15) "Inlet Temperature";
  Real P(min = 0, start = 101325) "Inlet pressure";
  //Component Molar Flow rates of respective phases
  Real compMolFlow[3, NOC](each min = 0, each start = 100);
  //Total molar flow rates of respective phases
  Real totMolFlow[3](each min = 0, each start = 100) "Total inlet molar flow rate";
  //Mole Fraction of components in respective phases
  Real compMolFrac[3, NOC](each min = 0, each max = 1, each start = 1 / (NOC + 1)) "Mole Fraction of components in inlet stream";
  Real Enth, Entr, Vapfrac(min = 0, max = 1, start = 0.5);
  //Output Variables-Connectors
  Real Tout(min = 0, start = 273.15) "Temperature for which calculations are made";
  Real Pout(min = 0, start = 101325) "outlet pressure in Pa";
  //Total molar flow rates of respective phases in the outlet streams
  Real outTotMolFlow[3](each min = 0, each start = 50) "Total Outlet Molar Flow Rate";
  Real outCompMolFlow[3, NOC](each min = 0, each start = 50) "Component outlet molar flow rate";
  Real outCompMolFrac[3, NOC](each min = 0, each start = 0.5) "Mole Fraction of components in outlet stream";
  Real outEnth, outEntr, outVapfrac(min = 0, max = 1, start = 0.5);
  //Phase-Equilibria
  Real Pdew(unit = "Pa", start = max(comp[:].Pc), min = 0);
  Real Pbubl(min = 0, unit = "Pa", start = min(comp[:].Pc));
  Real Beta(start = 0.5);
  //Phase-Equilibria-Outlet Stream
  Real Poutdew(unit = "Pa", start = max(comp[:].Pc), min = 0);
  Real Poutbubl(min = 0, unit = "Pa", start = min(comp[:].Pc));
  Real Betaout(start = 0.5);
  //Average Molecular weights-Outlets
  Real Moutavg[3](each start = 30);
  //Material Balance-Variables
  parameter Real delta_P "Pressure Drop";
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //Mass Flow Rates and Compositions
  Real totMasFlow[3](each start = 50) "Mass Flow Rate of phases";
  Real compMasFrac[3, NOC] "Mass Fraction of components in all phases";
  //Average Molecular weights
  Real Mavg[3](each start = 30);
  //Phase Volumetric Flow Rates
  Real totVolFlow[3](each start = 30);
  //Transport Properities
  Real LiqDens[NOC];
  Real Liquid_Phase_Density;
  Real VapDensity[NOC](unit = "kg/m^3");
  Real Vapour_Phase_Density;
  Real Density_Mixture;
  parameter Real Zv = 1;
  //Inlet Concentration
  Real Co[NOC];
  //Molar Flow rate inlet to reactor depending on reaction phase
  Real Fo[NOC](each min = 0, each start = 100);
  Real F[NOC](each min = 0, each start = 100);
  //Reaction-Manager-Data
  //Reaction-Phase
  parameter Integer Phase;
  Integer n "Order of the Reaction";
  Real k1[Nr] "Rate constant";
  parameter Integer Mode;
  parameter Real Tdef;
  Real Reaction_Heat "Heat of Reaction";
  //Material Balance
  Real No[NOC, Nr] "Number of moles-initial state";
  Real X[NOC](each min = 0, each max = 1, each start = 0.5) "Conversion of the reaction components";
  Real Volume(min = 0, start = 1) "Volume of the reactor";
  //Base-comp indicates the position of the base component in the comp-array
  parameter Integer Base_comp = 1;
  extends Simulator.Files.Models.ReactionManager.Reaction_Manager(NOC = NOC, comp = comp, Nr = 1, Bc = {1}, Comp = 3, Sc = {{-1}, {-1}, {1}}, DO = {{1}, {0}, {0}}, RO = {{0}, {0}, {0}}, A1 = {0.005}, E1 = {0}, A2 = {0}, E2 = {0});
  //===========================================================================================================
  //Energy-Stream-Connector
  Real energy_flo "The total energy given out/taken in due to the reactions";
  Simulator.Files.Connection.matConn inlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {74, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn en_Conn annotation(
    Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-12, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //============================================================================================================
equation
//Connector-Equations
  inlet.P = P;
  inlet.T = T;
  inlet.mixMolFlo = totMolFlow[1];
  inlet.mixMolEnth = Enth;
  inlet.mixMolEntr = Entr;
  inlet.mixMolFrac[1, :] = compMolFrac[1, :];
  inlet.vapPhasMolFrac = Vapfrac;
  outlet.P = Pout;
  outlet.T = Tout;
  outlet.mixMolFlo = outTotMolFlow[1];
  outlet.mixMolEnth = outEnth;
  outlet.mixMolEntr = outEntr;
  outlet.mixMolFrac[1, :] = outCompMolFrac[1, :];
  outlet.vapPhasMolFrac = outVapfrac;
  en_Conn.enFlo = energy_flo;
//Phase Equilibria
//==========================================================================================================
//Bubble point calculation
  Pbubl = sum(gammaBubl[:] .* compMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Pdew = 1 / sum(compMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / T + comp[:].VP[4] * log(T) + comp[:].VP[5] .* T .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
  if P >= Pbubl then
//below bubble point region
    compMolFrac[3, :] = zeros(NOC);
    sum(compMolFrac[2, :]) = 1;
  elseif P <= Pdew then
//above dew point region
    compMolFrac[2, :] = zeros(NOC);
    sum(compMolFrac[3, :]) = 1;
  else
//VLE region
    for i in 1:NOC loop
      compMolFrac[3, i] = K[i] * compMolFrac[2, i];
    end for;
    sum(compMolFrac[2, :]) = 1;
//sum y = 1
  end if;
//Rachford Rice Equation
  for i in 1:NOC loop
    compMolFrac[1, i] = compMolFrac[3, i] * Beta + compMolFrac[2, i] * (1 - Beta);
  end for;
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
  if Beta <= 0 then
    Mavg[1] = sum(compMolFrac[1, :] .* comp[:].MW);
    Mavg[2] = sum(compMolFrac[2, :] .* comp[:].MW);
    Mavg[3] = 0;
    totMasFlow[1] = totMolFlow[1] * 1E-3 * Mavg[1];
    totMasFlow[2] = totMolFlow[2] * 1E-3 * Mavg[2];
    totMasFlow[3] = 0;
    compMasFrac[1, :] = compMolFrac[1, :] .* comp[:].MW / Mavg[1];
    compMasFrac[2, :] = compMolFrac[2, :] .* comp[:].MW / Mavg[2];
    for i in 1:NOC loop
      compMasFrac[3, i] = 0;
    end for;
//Liquid_Phase_Density
    LiqDens = Thermodynamic_Functions.Density_Racket(NOC, T, P, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, Psat[:]);
    Liquid_Phase_Density = 1 / sum(compMasFrac[2, :] ./ LiqDens[:]) / Mavg[2];
//Vapour Phase Density
    for i in 1:NOC loop
      VapDensity[i] = 0;
    end for;
    Vapour_Phase_Density = 0;
//Density of Inlet-Mixture
    Density_Mixture = 1 / ((1 - Beta) / Liquid_Phase_Density) * sum(compMolFrac[1, :] .* comp[:].MW);
//====================================================================================================
  elseif Beta == 1 then
    Mavg[1] = sum(compMolFrac[1, :] .* comp[:].MW);
    Mavg[2] = 0;
    Mavg[3] = sum(compMolFrac[3, :] .* comp[:].MW);
    totMasFlow[1] = totMolFlow[1] * 1E-3 * Mavg[1];
    totMasFlow[2] = 0;
    totMasFlow[3] = totMolFlow[3] * 1E-3 * Mavg[3];
    compMasFrac[1, :] = compMolFrac[1, :] .* comp[:].MW / Mavg[1];
    for i in 1:NOC loop
      compMasFrac[2, i] = 0;
    end for;
    compMasFrac[3, :] = compMolFrac[3, :] .* comp[:].MW / Mavg[3];
//Calculation of Phase Densities
//Liquid Phase Density-Inlet Conditions
    for i in 1:NOC loop
      LiqDens[i] = 0;
    end for;
    Liquid_Phase_Density = 0;
//Vapour Phase Density
    for i in 1:NOC loop
      VapDensity[i] = P / (Zv * 8.314 * T) * comp[i].MW * 1E-3;
    end for;
    Vapour_Phase_Density = 1 / sum(compMasFrac[3, :] ./ VapDensity[:]) / Mavg[3];
//Density of Inlet-Mixture
    Density_Mixture = 1 / (Beta / Vapour_Phase_Density) * sum(compMolFrac[1, :] .* comp[:].MW);
  else
    Mavg[1] = sum(compMolFrac[1, :] .* comp[:].MW);
    Mavg[2] = sum(compMolFrac[2, :] .* comp[:].MW);
    Mavg[3] = sum(compMolFrac[3, :] .* comp[:].MW);
    totMasFlow[1] = totMolFlow[1] * 1E-3 * Mavg[1];
    totMasFlow[2] = totMolFlow[2] * 1E-3 * Mavg[2];
    totMasFlow[3] = totMolFlow[3] * 1E-3 * Mavg[3];
    compMasFrac[1, :] = compMolFrac[1, :] .* comp[:].MW / Mavg[1];
    compMasFrac[2, :] = compMolFrac[2, :] .* comp[:].MW / Mavg[2];
    compMasFrac[3, :] = compMolFrac[3, :] .* comp[:].MW / Mavg[3];
//Calculation of Phase Densities
//Liquid Phase Density-Inlet Conditions
    LiqDens = Thermodynamic_Functions.Density_Racket(NOC, T, P, comp[:].Pc, comp[:].Tc, comp[:].Racketparam, comp[:].AF, comp[:].MW, Psat[:]);
    Liquid_Phase_Density = 1 / sum(compMasFrac[2, :] ./ LiqDens[:]) / Mavg[2];
//Vapour Phase Density
    for i in 1:NOC loop
      VapDensity[i] = P / (Zv * 8.314 * T) * comp[i].MW * 1E-3;
    end for;
    Vapour_Phase_Density = 1 / sum(compMasFrac[3, :] ./ VapDensity[:]) / Mavg[3];
//Density of Inlet-Mixture
    Density_Mixture = 1 / (Beta / Vapour_Phase_Density + (1 - Beta) / Liquid_Phase_Density) * sum(compMolFrac[1, :] .* comp[:].MW);
  end if;
//=====================================================================================================
//Phase Flow Rates
//Phase Molar Flow Rates
  totMolFlow[3] = totMolFlow[1] * Beta;
  totMolFlow[2] = totMolFlow[1] * (1 - Beta);
//Component Molar Flow Rates in Phases
  compMolFlow[1, :] = totMolFlow[1] .* compMolFrac[1, :];
  compMolFlow[2, :] = totMolFlow[2] .* compMolFrac[2, :];
  compMolFlow[3, :] = totMolFlow[3] .* compMolFrac[3, :];
//======================================================================================================
//Phase Volumetric flow rates
  if Phase == 1 then
    totVolFlow[1] = totMasFlow[1] / Density_Mixture;
    totVolFlow[2] = totMasFlow[2] / (Liquid_Phase_Density * Mavg[2]);
    totVolFlow[3] = totMasFlow[3] / (Vapour_Phase_Density * Mavg[3]);
  elseif Phase == 2 then
    totVolFlow[1] = totMasFlow[1] / Density_Mixture;
    totVolFlow[2] = totMasFlow[2] / (Liquid_Phase_Density * Mavg[2]);
    totVolFlow[3] = 0;
  else
    totVolFlow[1] = totMasFlow[1] / Density_Mixture;
    totVolFlow[2] = 0;
    totVolFlow[3] = totMasFlow[3] / (Vapour_Phase_Density * Mavg[3]);
  end if;
//Mixture Phase
//=============================================================================================================
//Inlet Concentration
  if Phase == 1 then
    Co[:] = compMolFlow[1, :] / totVolFlow[1];
    for i in 1:NOC loop
      if i == Base_comp then
        Fo[i] = compMolFlow[1, i];
        F[i] = No[i, 1] * Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
      else
        Fo[i] = compMolFlow[1, i];
        F[i] = No[i, 1] * Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * compMolFlow[1, Base_comp];
      end if;
    end for;
//Conversion of Reactants
    for j in 2:NOC loop
      if Sc[j, 1] < 0 then
        X[j] = (compMolFlow[Phase, j] - F[j]) / compMolFlow[Phase, j];
      else
        X[j] = 0;
      end if;
    end for;
//=========================================================================================
//Liquid-Phase
  elseif Phase == 2 then
    Co[:] = compMolFlow[2, :] / totVolFlow[2];
    for i in 1:NOC loop
      if i == Base_comp then
        Fo[i] = compMolFlow[2, i];
        F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
      else
        Fo[i] = compMolFlow[1, i];
        F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
      end if;
    end for;
//Conversion of Reactants
    for j in 2:NOC loop
      if Sc[j, 1] < 0 then
        X[j] = (compMolFlow[Phase, j] - outCompMolFlow[Phase, j]) / compMolFlow[Phase, j];
      else
        X[j] = 0;
      end if;
    end for;
  else
//Vapour Phase
//======================================================================================================
    Co[:] = compMolFlow[3, :] / totVolFlow[3];
    for i in 1:NOC loop
      if i == Base_comp then
        Fo[i] = compMolFlow[3, i];
        F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
      else
        Fo[i] = compMolFlow[1, i];
        F[i] = Fo[i] + Sc[i, 1] / Bc[1] * X[Base_comp] * Fo[Base_comp];
      end if;
    end for;
//Conversion of Reactants
    for j in 2:NOC loop
      if Sc[j, 1] < 0 then
        X[j] = (compMolFlow[Phase, j] - outCompMolFlow[Phase, j]) / compMolFlow[Phase, j];
      else
        X[j] = 0;
      end if;
    end for;
  end if;
//================================================================================================
//Reaction Manager
  n = sum(DO[:]);
//Calculation of Rate Constants
  k1[:] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, A1[:], E1[:], T);
//Material Balance
//Initial Number of Moles
  for i in 1:Nr loop
    for j in 1:NOC loop
      if Sc[j, i] > 0 then
        Sc[j, i] = No[j, i];
      else
        Sc[j, i] = -No[j, i];
      end if;
    end for;
  end for;
//Calculation of volume with respect to conversion of limiting reeactant
  Volume = Performance_PFR(n, Co[Base_comp], Fo[Base_comp], k1[1], X[Base_comp]);
//============================================================================================================
//Calculation of Heat of Reaction at the reaction temperature
//Outlet temperature and energy stream
//Isothermal Mode
  if Mode == 1 then
    Reaction_Heat = HOR[1] * 1E-3 * Fo[Base_comp] * X[Base_comp];
    Tout = T;
    energy_flo = Reaction_Heat - Enth / Mavg[1] * totMasFlow[1] + outEnth / Mavg[1] * totMasFlow[1];
//Outlet temperature defined
  elseif Mode == 2 then
    Reaction_Heat = HOR[1] * 1E-3 * Fo[Base_comp] * X[Base_comp];
    Tout = Tdef;
    energy_flo = Reaction_Heat - Enth / Mavg[1] * totMasFlow[1] + outEnth / Mavg[1] * totMasFlow[1];
//Adiabatic Mode
  else
    Reaction_Heat = HOR[1] * 1E-3 * Fo[Base_comp] * X[Base_comp];
    energy_flo = 0;
    outEnth / Moutavg[1] = Enth / Mavg[1] - Reaction_Heat;
  end if;
//===========================================================================================================
//Calculation of Outlet Pressure
  Pout = P - delta_P;
//Calculation of Mole Fraction of outlet stream
  outCompMolFrac[1, :] = F[:] / outTotMolFlow[1];
  sum(F[:]) = outTotMolFlow[1];
//===========================================================================================================
//Phase Equilibria for Outlet Stream
//Bubble point calculation
  Poutbubl = sum(gammaBubl[:] .* outCompMolFrac[1, :] .* exp(comp[:].VP[2] + comp[:].VP[3] / Tout + comp[:].VP[4] * log(Tout) + comp[:].VP[5] .* Tout .^ comp[:].VP[6]) ./ liqfugcoeff_bubl[:]);
//Dew point calculation
  Poutdew = 1 / sum(outCompMolFrac[1, :] ./ (gammaDew[:] .* exp(comp[:].VP[2] + comp[:].VP[3] / Tout + comp[:].VP[4] * log(Tout) + comp[:].VP[5] .* Tout .^ comp[:].VP[6])) .* vapfugcoeff_dew[:]);
  if Pout >= Poutbubl then
//below bubble point region
    outCompMolFrac[3, :] = zeros(NOC);
    sum(outCompMolFrac[2, :]) = 1;
  elseif Pout <= Poutdew then
//above dew point region
    outCompMolFrac[2, :] = zeros(NOC);
    sum(outCompMolFrac[3, :]) = 1;
  else
//VLE region
    for i in 1:NOC loop
      outCompMolFrac[3, i] = K[i] * outCompMolFrac[2, i];
    end for;
    sum(outCompMolFrac[2, :]) = 1;
//sum y = 1
  end if;
//Rachford Rice Equation
  for i in 1:NOC loop
    outCompMolFrac[1, i] = outCompMolFrac[3, i] * Betaout + outCompMolFrac[2, i] * (1 - Betaout);
  end for;
  outTotMolFlow[3] = outTotMolFlow[1] * Betaout;
  outTotMolFlow[2] = outTotMolFlow[1] * (1 - Betaout);
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
  if Betaout <= 0 then
    Moutavg[1] = sum(outCompMolFrac[1, :] .* comp[:].MW);
    Moutavg[2] = sum(outCompMolFrac[2, :] .* comp[:].MW);
    Moutavg[3] = 0;
//====================================================================================================
  elseif Betaout == 1 then
    Moutavg[1] = sum(outCompMolFrac[1, :] .* comp[:].MW);
    Moutavg[2] = 0;
    Moutavg[3] = sum(outCompMolFrac[3, :] .* comp[:].MW);
  else
    Moutavg[1] = sum(outCompMolFrac[1, :] .* comp[:].MW);
    Moutavg[2] = sum(outCompMolFrac[2, :] .* comp[:].MW);
    Moutavg[3] = sum(outCompMolFrac[3, :] .* comp[:].MW);
  end if;
//=====================================================================================================
//Component Molar Flow Rates in Phases
  outCompMolFlow[1, :] = outTotMolFlow[1] .* outCompMolFrac[1, :];
  outCompMolFlow[2, :] = outTotMolFlow[2] .* outCompMolFrac[2, :];
  outCompMolFlow[3, :] = outTotMolFlow[3] .* outCompMolFrac[3, :];
//==================================================================================================
  annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Bitmap(origin = {3, -6}, extent = {{-75, 28}, {75, -28}}, imageSource = "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")}));
end PFR;
