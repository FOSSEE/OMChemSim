within Simulator.Unit_Operations.PF_Reactor;

model PFR
  //Plug Flow Reactor
  //Instantiation of Simulator-Package
  extends Simulator.Files.Icons.PFR;
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
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn outlet(connNOC = NOC) annotation(
    Placement(visible = true, transformation(origin = {74, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn en_Conn annotation(
    Placement(visible = true, transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  for i in 1:Nr loop
    k1[i] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, A1[i], E1[i], T);
  end for;
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
    Icon(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
    Diagram(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
    __OpenModelica_commandLineOptions = "");
end PFR;
