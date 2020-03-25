within Simulator.UnitOperations.PFR;

 model PFR "Model of a Plug Flow Reactor to calculate the outlet stream mole fraction of components while describing chemical reactions in continuous, flowing systems of cylindrical geometry"          
//=========================================================================
  //Header Files and Parameters
        extends Simulator.Files.Icons.PFR;
        import Simulator.Files.*;
        import Simulator.Files.ThermodynamicFunctions.*; 
        parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
        parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
        parameter Real Zv = 1 "Compressiblity factor" annotation(
    Dialog(tab = "Reactions", group = "Reaction Parameters"));
   
        parameter Integer Nr "Number of reactions" annotation(
    Dialog(tab = "Reactions", group = "Reaction Parameters"));
        parameter String  Phase "Reaction Phase: Mixture, Liquid, Vapor" annotation(
    Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
        parameter String  Mode "Mode of Operation: Isothermal, Define Outlet Temperature, Adiabatic" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
      parameter String  Basis "Reaction Basis : Molar Concentration,Mass Concentration,Molar Fractions,Mass Fraction" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
        parameter Real Tdef(unit = "K") "Outlet temperature when Mode = Define Outlet Temp" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
        parameter Real Pdel(unit = "Pa")  "Pressure Drop" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
        Integer Base_C  "Base component";
  //=========================================================================
  //Model Variables
        Integer Phaseindex;
        //Inlet Stream Variables
        Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
        Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
        Real Fin_pc[3, Nc](each unit = "mol/s", each min = 0, start={Fg,Fliqg,Fvapg}) "Inlet stream components molar flow rate in phase";
        Real Fin_p[3](each unit = "mol/s", each min = 0,start={Fg,Fliqg,Fvapg}) "Inlet stream molar flow rate in phase";
        Real xin_pc[3, Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Inlet stream mole fraction";
        Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream enthalpy";
        Real Sin(unit = "kJ/[kmol.K]") "Inlet stream entropy";
        Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mole fraction";
        Real Cin_c[Nc] "Inlet Concentration";
        Real Fin_c[Nc](each min = 0, each start = Fg) "Inlet Mole Flow";
        //Outlet Stream variables
        Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
        Real Pout(unit = "Pa", min  = 0, start = Pg) "Outlet stream pressure";
        Real Fout_p[3](each unit = "mol/s", each min = 0, start={Fg,Fliqg,Fvapg}) "Outlet stream molar flow rate";
        Real Fout_pc[3, Nc](each unit = "mol/s", each min = 0, start={Fg,Fliqg,Fvapg}) "Outlet stream components molar flow rate";
        Real xout_pc[3, Nc](each min = 0,start=xg) "Mole Fraction of Component in outlet stream";
        Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
        Real Sout(unit = "kJ/[kmol.K]") "Outlet stream molar entropy";
        Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";

        Real MWout_p[3](each unit = "kg/kmol") "Outlset stream molecular weight in phase";
        Real Fmin_p[3](each unit = "kg/s",start={Fg,Fliqg,Fvapg}) "Inlet stream mass flow rate";
        Real xm_pc[3, Nc](each unit = "-",start=xg) "Component mass fraction in phase";
        Real MW_p[3](each unit = "kg/kmol")"Molecular weight of phase";
        Real Fv_p[3](start={Fg,Fliqg,Fvapg});
        //Phase and Total Densities
        Real rholiq_c[Nc](each unit = "kg/m3") "Components density in liquid phase";
        Real rholiq(unit = "kg/m3") "Liquid phase density";
        Real rhovap_c[Nc](each unit = "kg/m3") "Components density in vapor phase";
        Real rhovap(unit = "kg/m3") "Vapor phase density";
        Real rho(unit = "kg/m3") "Mixture density";
        //Outlet
        Real Fout_c[Nc](each unit = "mol/s", each min = 0, each start = 100) "Outlet Mole Flow";      
        Integer n "Order of the Reaction";
        Real k_r[Nr] "Rate constant";
        Real Hr(unit = "kJ/kmol") "Heat of Reaction";
        Real Fin_cr[Nc, Nr](each unit = "mol/s") "Number of moles at initial state";
        Real X_r[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Conversion of the components in reaction";
        Real V(unit = "m3", min = 0) "Volume of the reactor";
        Real tr(unit = "s")"Residence Time";
        
        Real Deln;
        Real Foutv_p[3];
        Real Ephsilon;
        Real Cout_c[Nc];
        //Vapour Pressure at the inlet and outlet temperatures
        Real Pvapin_c[Nc];
        Real Pvapout_c[Nc];
   
       extends Simulator.Files.Models.ReactionManager.KineticReaction( Nr = 1,BC_r = {1}, Coef_cr = {{-1}, {-1}, {1}}, DO_cr = {{1}, {0}, {0}}, Af_r = {0.005}, Ef_r = {0});
        //===========================================================================================================
  //Instantiation of Connectors
    Real Q "The total energy given out/taken in due to the reactions";
    Real X_dummy[Nc-1];
    Real Co_dummy[Nc-1];
    Real DO_dummy[Nc-1,Nr];
        
      Simulator.Files.Interfaces.enConn En annotation(
          Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-348, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-348, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 //============================================================================================================
      extends GuessModels.InitialGuess;
     
      equation
//connector-Equations
  In.P = Pin;
    In.T = Tin;
    In.F = Fin_p[1];
    In.H = Hin;
    In.S = Sin;
    In.x_pc = xin_pc;
    In.xvap = xvapin;
        
    Out.P = Pout;
    Out.T = Tout;
    Out.F = Fout_p[1];
    Out.H = Hout;
    Out.S = Sout;
    Out.x_pc = xout_pc;
    Out.xvap = xvapout;
    En.Q = Q;
//Phase Equilibria
//==========================================================================================================
  Base_C = BC_r[1];
for i in 1:Nc loop
   Pvapin_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, Tin);
   Pvapout_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, Tout);
 end for;  
 
 if(Phase=="Mixture") then
 Phaseindex=1;
 elseif(Phase=="Liquid") then
 Phaseindex=2;
 else
 Phaseindex=3;
 end if;
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
  if xvapin <= 0 then
    MW_p[1] = sum(xin_pc[1, :] .* C[:].MW);
    MW_p[2] = sum(xin_pc[2, :] .* C[:].MW);
    MW_p[3] = 0;
    Fmin_p[1] = Fin_p[1] * 1E-3 * MW_p[1];
    Fmin_p[2] = Fin_p[2] * 1E-3 * MW_p[2];
    Fmin_p[3] = 0;
    xm_pc[1, :] = xin_pc[1, :] .* C[:].MW / MW_p[1];
    xm_pc[2, :] = xin_pc[2, :] .* C[:].MW / MW_p[2];
    for i in 1:Nc loop
      xm_pc[3, i] = 0;
    end for;
//Liquid Phase Density
    rholiq_c = ThermodynamicFunctions.DensityRacket(Nc, Tin, Pin, C[:].Pc, C[:].Tc, C[:].Racketparam, C[:].AF, C[:].MW, Pvapin_c[:]);
    rholiq = 1 / sum(xm_pc[2, :] ./ rholiq_c[:]) / MW_p[2];
//Vapour Phase Density
    for i in 1:Nc loop
      rhovap_c[i] = 0;
    end for;
    rhovap = 0;
//Density of Inlet-Mixture
    rho = 1 / ((1 - xvapin) / rholiq) * sum(xin_pc[1, :] .* C[:].MW);
//====================================================================================================
  elseif xvapin == 1 then
    MW_p[1] = sum(xin_pc[1, :] .* C[:].MW);
    MW_p[2] = 0;
    MW_p[3] = sum(xin_pc[3, :] .* C[:].MW);
    Fmin_p[1] = Fin_p[1] * 1E-3 * MW_p[1];
    Fmin_p[2] = 0;
    Fmin_p[3] = Fin_p[3] * 1E-3 * MW_p[3];
    xm_pc[1, :] = xin_pc[1, :] .* C[:].MW / MW_p[1];
    for i in 1:Nc loop
      xm_pc[2, i] = 0;
    end for;
    xm_pc[3, :] = xin_pc[3, :] .* C[:].MW / MW_p[3];
//=========================================================================
//Calculation of Phase Densities
//Liquid Phase Density-Inlet Conditions
    for i in 1:Nc loop
      rholiq_c[i] = 0;
    end for;
    rholiq = 0;
//Vapour Phase Density
    for i in 1:Nc loop
      rhovap_c[i] = Pin / (Zv * 8.314 * Tin) * C[i].MW * 1E-3;
    end for;
    rhovap = 1 / sum(xm_pc[3, :] ./ rhovap_c[:]) / MW_p[3];
//Density of Inlet-Mixture
    rho = 1 / (xvapin / rhovap) * sum(xin_pc[1, :] .* C[:].MW);
  else
    MW_p[1] = sum(xin_pc[1, :] .* C[:].MW);
    MW_p[2] = sum(xin_pc[2, :] .* C[:].MW);
    MW_p[3] = sum(xin_pc[3, :] .* C[:].MW);
    Fmin_p[1] = Fin_p[1] * 1E-3 * MW_p[1];
    Fmin_p[2] = Fin_p[2] * 1E-3 * MW_p[2];
    Fmin_p[3] = Fin_p[3] * 1E-3 * MW_p[3];
    xm_pc[1, :] = xin_pc[1, :] .* C[:].MW / MW_p[1];
    xm_pc[2, :] = xin_pc[2, :] .* C[:].MW / MW_p[2];
    xm_pc[3, :] = xin_pc[3, :] .* C[:].MW / MW_p[3];
//=========================================================================
//Calculation of Phase Densities
//Liquid Phase Density-Inlet Conditions
    rholiq_c = ThermodynamicFunctions.DensityRacket(Nc, Tin, Pin, C[:].Pc, C[:].Tc, C[:].Racketparam, C[:].AF, C[:].MW, Pvapin_c[:]);
    rholiq = 1 / sum(xm_pc[2, :] ./ rholiq_c[:]) / MW_p[2];
//Vapour Phase Density
    for i in 1:Nc loop
      rhovap_c[i] = Pin / (Zv * 8.314 * Tin) * C[i].MW * 1E-3;
    end for;
    rhovap = 1 / sum(xm_pc[3, :] ./ rhovap_c[:]) / MW_p[3];
//Density of Inlet-Mixture
    rho = 1 / (xvapin / rhovap + (1 - xvapin) / rholiq) * sum(xin_pc[1, :] .* C[:].MW);
  end if;
//=====================================================================================================
//Phase Flow Rates
//Phase Molar Flow Rates
  Fin_p[3] = Fin_p[1] * xvapin;
    Fin_p[2] = Fin_p[1] * (1 - xvapin);
//Cin_cnent Molar Flow Rates in Phases
  Fin_pc[1, :] = Fin_p[1] .* xin_pc[1, :];
    Fin_pc[2, :] = Fin_p[2] .* xin_pc[2, :];
    Fin_pc[3, :] = Fin_p[3] .* xin_pc[3, :];
//======================================================================================================
//Phase Volumetric flow rates
  if Phase == "Mixture" then
    Fv_p[1] = Fmin_p[1] / rho;
    Fv_p[2] = Fmin_p[2] / (rholiq * MW_p[2]);
    Fv_p[3] = Fmin_p[3] / (rhovap * MW_p[3]);
  elseif Phase == "Liquid" then
    Fv_p[1] = Fmin_p[1] / rho;
    Fv_p[2] = Fmin_p[2] / (rholiq * MW_p[2]);
    Fv_p[3] = 0;
  else
    Fv_p[1] = Fmin_p[1] / rho;
    Fv_p[2] = 0;
    Fv_p[3] = Fmin_p[3] / (rhovap * MW_p[3]);
  end if;
//=================================================================================
//Inlet concentration
  if Phase == "Mixture" then
    if Basis == "Molar Concentration" then
      Cin_c[:] = Fin_pc[Phaseindex, :] / Fv_p[Phaseindex];
    else
      Cin_c[:] = Fin_pc[1, :] / Fv_p[1] * MW_p[2] / rholiq;
    end if;
    for i in 1:Nc loop
      if i == Base_C then
        Fin_c[i] = Fin_pc[1, i];
        Fout_c[i] = Fin_cr[i, 1] * Fin_c[i] + Coef_cr[i, 1] / BC_r[1] * X_r[Base_C] * Fin_c[Base_C];
      else
        Fin_c[i] = Fin_pc[1, i];
        Fout_c[i] = Fin_cr[i, 1] * Fin_c[i] + Coef_cr[i, 1] / BC_r[1] * X_r[Base_C] * Fin_pc[1, Base_C];
      end if;
    end for;
//Conversion of Reactants
    for j in 2:Nc loop
      if Coef_cr[j, 1] < 0 then
        X_r[j] = (Fin_pc[Phaseindex, j] - Fout_c[j]) / Fin_pc[Phaseindex, j];
      else
        X_r[j] = 0;
      end if;
    end for;
//=========================================================================================
//Liquid-Phase
  elseif Phase == "Liquid" then
//Molar Concentration
    if Basis == "Molar Concentration" then
      Cin_c[:] = Fin_pc[2, :] / Fv_p[2];
//Molar Fractions
    elseif Basis == "Molar Fractions" then
      Cin_c[:] = Fin_pc[2, :] / Fv_p[2] * MW_p[2] / rholiq;
//Mass Concentration
    elseif Basis == "Mass Concentration" then
      Cin_c[:] = Fin_pc[2, :] / Fv_p[2] * 1000 / MW_p[2];
//Mass Fractions
    else
      Cin_c[:] = Fin_pc[2, :] / Fv_p[2] * rholiq * 1000 / MW_p[2];
    end if;
    for i in 1:Nc loop
      if i == Base_C then
        Fin_c[i] = Fin_pc[2, i];
        Fout_c[i] = Fin_c[i] + Coef_cr[i, 1] / BC_r[1] * X_r[Base_C] * Fin_c[Base_C];
      else
        Fin_c[i] = Fin_pc[1, i];
        Fout_c[i] = Fin_c[i] + Coef_cr[i, 1] / BC_r[1] * X_r[Base_C] * Fin_c[Base_C];
      end if;
    end for;
//Cin_cnversion of Reactants
    for j in 2:Nc loop
      if Coef_cr[j, 1] < 0 then
        X_r[j] = (Fin_pc[Phaseindex, j] - Fout_pc[Phaseindex, j]) / Fin_pc[Phaseindex, j];
      else
        X_r[j] = 0;
      end if;
    end for;
  else
//Vapour Phase
//======================================================================================================
    if Basis == "Molar Concentration" then
//Molar Concentration
      Cin_c[:] = Fin_pc[Phaseindex, :] / Fv_p[Phaseindex];
//Molar Fractions
    elseif Basis == "Molar Fractions" then
      Cin_c[:] = Fin_pc[Phaseindex, :] / Fv_p[Phaseindex] * Zv * 8.314 * Tin / Pin;
//Mass Concentration
    elseif Basis == "Mass Concentration" then
      Cin_c[:] = Fin_pc[Phaseindex, :] / Fv_p[Phaseindex] * 1000 / MW_p[3];
    else
//Mass Fractions
      Cin_c[:] = Fin_pc[Phaseindex, :] / Fv_p[Phaseindex] * Zv * 8.314 * Tin / Pin * 1000 / MW_p[3];
    end if;
//=======================================================================================================
    for i in 1:Nc loop
      if i == Base_C then
        Fin_c[i] = Fin_pc[3, i];
        Fout_c[i] = Fin_c[i] + Coef_cr[i, 1] / BC_r[1] * X_r[Base_C] * Fin_c[Base_C];
      else
        Fin_c[i] = Fin_pc[1, i];
        Fout_c[i] = Fin_c[i] + Coef_cr[i, 1] / BC_r[1] * X_r[Base_C] * Fin_c[Base_C];
      end if;
    end for;
//Cin_cnversion of Reactants
    for j in 2:Nc loop
      if Coef_cr[j, 1] < 0 then
        X_r[j] = (Fin_pc[Phaseindex, j] - Fout_pc[Phaseindex, j]) / Fin_pc[Phaseindex, j];
      else
        X_r[j] = 0;
      end if;
    end for;
  end if;
//================================================================================================
//Reaction Manager
  n = sum(DO_cr[:]);
//Calculation of Rate Cin_cnstants
  for i in 1:Nr loop
    k_r[i] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, Af_r[i], Ef_r[i], Tin);
  end for;
//Material Balance
//Initial Number of Moles
  for i in 1:Nr loop
    for j in 1:Nc loop
      if Coef_cr[j, i] > 0 then
        Coef_cr[j, i] = Fin_cr[j, i];
      else
        Coef_cr[j, i] = -Fin_cr[j, i];
      end if;
    end for;
  end for;
//Calculation of V with respect to Cin_cnversion of limiting reeactant
//    V = PerformancePFR(n, Cin_c[Base_C], Fin_c[Base_C], k_r[1], X_r[Base_C]);
  V = PFR.PerformancePFR(Nc, Nr, n, Base_C, Co_dummy, DO_dummy, X_dummy, DO_cr, Cin_c, Coef_cr, BC_r, Fin_c[Base_C], k_r[1], X_r[Base_C]);
 
  tr = V / Fv_p[1];
//============================================================================================================
//Calculation of Heat of Reaction at the reaction temperature
//Outlet temperature and energy stream
//Isothermal Mode
  if Mode == "Isothermal" then
    Hr = Hr_r[1] * 1E-3 * Fin_c[Base_C] * X_r[Base_C];
    Tout = Tin;
    Q = Hr - Hin / MW_p[1] * Fmin_p[1] + Hout / MWout_p[1] * Fmin_p[1];
//Outlet temperature defined
  elseif Mode == "Define Outlet Temperature" then
    Hr = Hr_r[1] * 1E-3 * Fin_c[Base_C] * X_r[Base_C];
    Tout = Tdef;
    Q = Hr - Hin / MW_p[1] * Fmin_p[1] + Hout / MWout_p[1] * Fmin_p[1];
//Adiabatic Mode
  else
    Hr = Hr_r[1] * 1E-3 * Fin_c[Base_C] * X_r[Base_C];
    Q = 0;
    Q = Hr - Hin / MW_p[1] * Fmin_p[1] + Hout / MWout_p[1] * Fmin_p[1];
  end if;
//===========================================================================================================
//Calculation of Outlet Pressure
  Pout = Pin - Pdel;
//Calculation of Mole Fraction of outlet stream
  xout_pc[1, :] = Fout_c[:] / Fout_p[1];
        sum(Fout_c[:]) = Fout_p[1];
//===========================================================================================================
  Fout_p[3] = Fout_p[1] * xvapout;
       Fout_p[2] = Fout_p[1] * (1 - xvapout);
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
  if xvapout <= 0 then
    MWout_p[1] = sum(xout_pc[1, :] .* C[:].MW);
    MWout_p[2] = sum(xout_pc[2, :] .* C[:].MW);
    MWout_p[3] = 0;
//====================================================================================================
  elseif xvapout == 1 then
    MWout_p[1] = sum(xout_pc[1, :] .* C[:].MW);
    MWout_p[2] = 0;
    MWout_p[3] = sum(xout_pc[3, :] .* C[:].MW);
  else
    MWout_p[1] = sum(xout_pc[1, :] .* C[:].MW);
    MWout_p[2] = sum(xout_pc[2, :] .* C[:].MW);
    MWout_p[3] = sum(xout_pc[3, :] .* C[:].MW);
  end if;
//=====================================================================================================
//Component Molar Flow Rates in Phases
  Fout_pc[1, :] = Fout_p[1] .* xout_pc[1, :];
    Fout_pc[2, :] = Fout_p[2] .* xout_pc[2, :];
    Fout_pc[3, :] = Fout_p[3] .* xout_pc[3, :];
//==================================================================================================
  for i in 2:Nc loop
    X_dummy[i - 1] = X_r[i];
    Co_dummy[i - 1] = Cin_c[i];
    DO_dummy[i - 1, 1] = DO_cr[i, 1];
  end for;
//Change in conversion with change in temperature of the reactor
  Deln = sum(Coef_cr[:, :]);
      for i in 1:Nr loop
        Ephsilon = Deln / Fin_cr[Base_C, i] * xin_pc[1, Base_C];
      end for;
      if Phase == "Vapour" then
        Foutv_p[2] = Fv_p[2];
        Foutv_p[1] = Foutv_p[3];
        Foutv_p[3] = Fv_p[3] * (1 + Ephsilon * X_r[Base_C]) * (Pin / Pout) * (Tout / Tin);
        Cout_c[:] = Fout_pc[3, :] /Foutv_p[3];
      elseif Phase == "Liquid" then
        Foutv_p[2] = Fv_p[2];
        Foutv_p[1] = Foutv_p[3];
        Foutv_p[3] = Fv_p[3] * (1 + Ephsilon * X_r[Base_C]) * (Pin / Pout) * (Tout / Tin);
        Cout_c[:] = Fout_pc[2, :] / Foutv_p[2];
      else
        Foutv_p[2] = Fv_p[2];
        Foutv_p[1] = Foutv_p[3];
        Foutv_p[3] = Fv_p[3] * (1 + Ephsilon * X_r[Base_C]) * (Pin / Pout) * (Tout / Tin);
        Cout_c[:] = Fout_pc[1, :] / Foutv_p[1];
      end if;
  
  annotation(Icon(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
      Diagram(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
      __OpenModelica_Cin_cmmandLineOptions = "",
 Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">The&nbsp;<b>Plug Flow Reactor (PFR)</b>&nbsp;is used to calculate the mole fraction of components at outlet stream when the conversion of base component for the reaction is defined.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The plug flow reactor model have following connection ports:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">heat added</span></li></ul></ol></div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">To simulate a plug flow reactor, following calculation parameters must be provided:</span><div><ol style=\"font-size: 12px;\"><li>Calculation Mode (<b>Mode</b>)</li><li>Reaction Basis (<b>Basis</b>)</li><li>Reaction Phase (<b>Phase</b>)</li><li>Outlet Temperature&nbsp;(<b>Tdef</b>)&nbsp;(If calculation mode is Define Outlet Temperature)</li><li>Number of Reactions (<b>Nr</b>)</li><li>Base Component (<b>Base_C</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li><li>Reaction Order (<b>DO_cr</b>)</li><li>Pre-exponential Factor (<b>Af_r</b>)</li><li>Activation Energy (<b>Ef_r</b>)</li><li>Pressure Drop (<b>Pdel</b>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">Among the above variables, first three variables are&nbsp;of type&nbsp;<i>parameter String</i>. First one, Calculation Mode (<b>Mode</b>) can have either of the sting values among the following:</span></div><div style=\"orphans: 2; widows: 2;\"><ol style=\"font-size: 12px;\"><li><b>Isothermal</b>: If the reactor is operated isothermally</li><li><b>Define Outlet Temperature</b>: If the reactor is operated at specified outlet temperature</li><li><b>Adiabatic</b>: If the reactor is operated adiabatically</li></ol><div style=\"font-size: 12px;\">Second one, Reaction Basis (<b>Basis</b>) can have either of the string values among the following:</div><div><ol><li><b>Molar Concentration</b>: If the reaction rate is defined in terms of Molar Concentration</li><li><b>Mass Concentration</b>:&nbsp;If the reaction rate is defined in terms of Mass Concentration</li><li><b>Molar Fractions</b>:&nbsp;If the reaction rate is defined in terms of Molar Fractions</li><li><b>Mass Fractions</b>:&nbsp;If the reaction rate is defined in terms of Mass Fractions</li></ol><div>Third one, Reaction Phase (<b>Phase</b>), can have either of the string values among the following:</div></div><div><ol><li><b>Mixture</b>: If the reaction is a mixed phase reaction</li><li><b>Liquid</b>: If the reaction is a liquid phase reaction</li><li><b>Vapour</b>: If the reaction is a vapour phase reaction</li></ol></div><div style=\"font-size: 12px;\"><br></div></div></div><div style=\"font-size: 12px;\">The other variables are of type&nbsp;<i>parameter Real.</i></div></div><div style=\"font-size: 12px;\"><div>During simulation, their values can specified directly under&nbsp;<b>Reactor Specifications and Reactions&nbsp;</b>by double clicking on the PFR model instance.</div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Plug Flow Reactor Reactor, go to&nbsp;<a href=\"modelica://Simulator.Examples.PFR\">Plug Flow Reactor Example</a>.</div><div><br></div></body></html>"));
  end PFR;
