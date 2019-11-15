within Simulator.Unit_Operations.PF_Reactor;

 model PFR         
  
  //=========================================================================
  //Header Files and Parameters
        extends Simulator.Files.Icons.PFR;
        import Simulator.Files.*;
        import Simulator.Files.Thermodynamic_Functions.*; 
        parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
        parameter Real Pdel  "Pressure Drop";
        extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
        parameter Real Zv = 1 "Cressiblity Factor";
        parameter Integer Nc "number of Cin_cunds ";
        parameter Integer Nr "Number of reactions";
        parameter Integer Phase;
        parameter Integer Mode;
        parameter Integer Base_C = 1;
        parameter Real Tdef;
  //=========================================================================
  //Model Variables
        Real Tin(min = 0, start = 273.15) "Inlet Temperature";
        Real Pin(min = 0, start = 101325) "Inlet pressure";
        Real Fin_pc[3, Nc](each min = 0, each start = 100) "Total molar flow rates of respective phases";
        Real Fin_p[3](each min = 0, each start = 100) "Total inlet molar flow rate";
        Real xin_pc[3, Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)) "Mole Fraction at inlet ";
        Real Hin "Inlet Enthalpy", Sin "Inlet Entropy", xvapin(min = 0, max = 1, start = 0.5) "Vapor Fraction";
        Real Tout(min = 0, start = 273.15) "Outlet Temperature";
        Real Pout(min  = 0, start = 101325) "Outlet Pressure";
        Real Fout_p[3](each min = 0, each start = 50) "Total Outlet Molar Flow Rate";
        Real Fout_pc[3, Nc](each min = 0, each start = 50) "Component outlet molar flow rate";
        Real xout_pc[3, Nc](each min = 0, each start = 0.5) "Mole Fraction of Component in outlet stream";
        Real Hout "Outlet Enthalpy", Sout "Outlet Entropy", xvapout(min = 0, max = 1, start = 0.5) "Vapor Fraction at inlet";
        Real Pdewin(unit = "Pa", start = max(C[:].Pc), min = 0) "Dew point pressure at inlet";
        Real Pbublin(min = 0, unit = "Pa", start = min(C[:].Pc)) "Bubble point pressure at inlet";
        Real xmvapin(start = 0.5) "Vapor Mass Fraction";
        Real Pdewout(unit = "Pa", start = max(C[:].Pc), min = 0) "Dew point pressure at outlet";
        Real Pbublout(min = 0, unit = "Pa", start = min(C[:].Pc)) "Bubble point pressure at outlet";
        Real xmvapout(start = 0.5) "Vapor Mass Fraction at Outlet";
        Real MWout_p[3](each start = 30) "Outlet Molecular Weight";
        Real Fmin_p[3](each start = 50) "Mass Flow Rate of phases";
        Real xm_pc[3, Nc] "Mass Fraction of Cin_cnents in all phases";
        Real MW_p[3](each start = 30);
        Real Fv_p[3](each start = 30);
        Real rholiq_c[Nc] "Liquid Density";
        Real rholiq "Liquid Phase Density";
        Real rhovap_c[Nc](unit = "kg/m^3") "Vapor Density";
        Real rhovap "Vapor Phase Density";
        Real rho "Mixture Density";
        Real Cin_c[Nc] "Inlet Concentration";
        Real Fin_c[Nc](each min = 0, each start = 100) "Inlet Mole Flow";
        Real Fout_c[Nc](each min = 0, each start = 100) "Outlet Mole Flow";      
        Integer n "Order of the Reaction";
        Real k_r[Nr] "Rate constant";
        Real Hr "Heat of Reaction";
        Real Fin_cr[Nc, Nr] "Number of moles-initial state";
        Real X_r[Nc](each min = 0, each max = 1, each start = 0.5) "Conversion of the reaction Cin_cnents";
        Real V(min = 0, start = 1) "Volume of the reactor";
        
        
       extends Simulator.Files.Models.ReactionManager.Reaction_Manager(Nc = Nc, C = C, Nr = 1,Bc = {1}, Sc = {{-1}, {-1}, {1}}, DO = {{1}, {0}, {0}}, RO = {{0}, {0}, {0}}, A1 = {0.005}, E1 = {0}, A2 = {0}, E2 = {0});
        //===========================================================================================================
    //Instantiation of Connectors
        Real Q "The total energy given out/taken in due to the reactions";
        
      Simulator.Files.Connection.enConn En annotation(
          Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Files.Connection.matConn In(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-348, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-348, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Files.Connection.matConn Out(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {350, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
        //============================================================================================================
      equation
//connector-Equations
    In.P = Pin;
    In.T = Tin;
    In.F = Fin_p[1];
    In.H = Hin;
    In.S = Sin;
    In.x_pc[1, :] = xin_pc[1, :];
    In.xvap = xvapin;
        
    Out.P = Pout;
    Out.T = Tout;
    Out.F = Fout_p[1];
    Out.H = Hout;
    Out.S = Sout;
    Out.x_pc[1, :] = xout_pc[1, :];
    Out.xvap = xvapout;
    En.enFlo = Q;
    
//Phase Equilibria
//==========================================================================================================
//Bubble point calculation
    Pbublin = sum(gmabubl_c[:] .* xin_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / Tin + C[:].VP[4] * log(Tin) + C[:].VP[5] .* Tin .^ C[:].VP[6]) ./ philiqbubl_c[:]);
//Dew point calculation
    Pdewin = 1 / sum(xin_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / Tin + C[:].VP[4] * log(Tin) + C[:].VP[5] .* Tin .^ C[:].VP[6])) .* phivapdew_c[:]);
  if Pin >= Pbublin then
//below bubble point region
      xin_pc[3, :] = zeros(Nc);
      sum(xin_pc[2, :]) = 1;
    elseif Pin <= Pdewin then
//above dew point region
      xin_pc[2, :] = zeros(Nc);
      sum(xin_pc[3, :]) = 1;
    else
//VLE region
      for i in 1:Nc loop
        xin_pc[3, i] = K[i] * xin_pc[2, i];
      end for;
      sum(xin_pc[2, :]) = 1;
//sum y = 1
    end if;
//RachFin_crd Rice Equation
    for i in 1:Nc loop
      xin_pc[1, i] = xin_pc[3, i] * xmvapin + xin_pc[2, i] * (1 - xmvapin);
    end for;
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
    if xmvapin <= 0 then
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
//rholiq
      rholiq_c = Thermodynamic_Functions.Density_Racket(Nc, Tin, Pin, C[:].Pc, C[:].Tc, C[:].Racketparam, C[:].AF, C[:].MW, Psat[:]);
      rholiq = 1 / sum(xm_pc[2, :] ./ rholiq_c[:]) / MW_p[2];
//Vapour Phase Density
      for i in 1:Nc loop
        rhovap_c[i] = 0;
      end for;
      rhovap = 0;
//Density of Inlet-Mixture
      rho = 1 / ((1 - xmvapin) / rholiq) * sum(xin_pc[1, :] .* C[:].MW);
//====================================================================================================
    elseif xmvapin == 1 then
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
        rhovap_city[i] = Pin / (Zv * 8.314 * Tin) * C[i].MW * 1E-3;
      end for;
      rhovap = 1 / sum(xm_pc[3, :] ./ rhovap_city[:]) / MW_p[3];
//Density of Inlet-Mixture
      rho = 1 / (xmvapin / rhovap) * sum(xin_pc[1, :] .* C[:].MW);
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
      rholiq_c = Thermodynamic_Functions.Density_Racket(Nc, Tin, Pin, C[:].Pc, C[:].Tc, C[:].Racketparam, C[:].AF, C[:].MW, Psat[:]);
      rholiq = 1 / sum(xm_pc[2, :] ./ rholiq_c[:]) / MW_p[2];
//Vapour Phase Density
      for i in 1:Nc loop
        rhovap_city[i] = Pin / (Zv * 8.314 * Tin) * C[i].MW * 1E-3;
      end for;
      rhovap = 1 / sum(xm_pc[3, :] ./ rhovap_city[:]) / MW_p[3];
//Density of Inlet-Mixture
      rho = 1 / (xmvapin / rhovap + (1 - xmvapin) / rholiq) * sum(xin_pc[1, :] .* C[:].MW);
    end if;
//=====================================================================================================
//Phase Flow Rates
//Phase Molar Flow Rates
    Fin_p[3] = Fin_p[1] * xmvapin;
        Fin_p[2] = Fin_p[1] * (1 - xmvapin);
//Cin_cnent Molar Flow Rates in Phases
    Fin_pc[1, :] = Fin_p[1] .* xin_pc[1, :];
        Fin_pc[2, :] = Fin_p[2] .* xin_pc[2, :];
        Fin_pc[3, :] = Fin_p[3] .* xin_pc[3, :];
//======================================================================================================
//Phase Volumetric flow rates
    if Phase == 1 then
      Fv_p[1] = Fmin_p[1] / rho;
      Fv_p[2] = Fmin_p[2] / (rholiq * MW_p[2]);
      Fv_p[3] = Fmin_p[3] / (rhovap * MW_p[3]);
    elseif Phase == 2 then
      Fv_p[1] = Fmin_p[1] / rho;
      Fv_p[2] = Fmin_p[2] / (rholiq * MW_p[2]);
      Fv_p[3] = 0;
    else
      Fv_p[1] = Fmin_p[1] / rho;
      Fv_p[2] = 0;
      Fv_p[3] = Fmin_p[3] / (rhovap * MW_p[3]);
    end if;
//Mixture Phase
//=============================================================================================================
//Inlet concentration
    if Phase == 1 then
      Cin_c[:] = Fin_pc[1, :] / Fv_p[1];
      for i in 1:Nc loop
        if i == Base_C then
          Fin_c[i] = Fin_pc[1, i];
          Fout_c[i] = Fin_cr[i, 1] * Fin_c[i] + Sc[i, 1] / Bc[1] * X[Base_C] * Fin_c[Base_C];
        else
          Fin_c[i] = Fin_pc[1, i];
          Fout_c[i] = Fin_cr[i, 1] * Fin_c[i] + Sc[i, 1] / Bc[1] * X[Base_C] * Fin_pc[1, Base_C];
        end if;
      end for;
//Conversion of Reactants
      for j in 2:Nc loop
        if Sc[j, 1] < 0 then
          X[j] = (Fin_pc[Phase, j] - Fout_C[j]) / Fin_pc[Phase, j];
        else
          X[j] = 0;
        end if;
      end for;
//=========================================================================================
//Liquid-Phase
    elseif Phase == 2 then
      Cin_c[:] = Fin_pc[2, :] / Fv_p[2];
      for i in 1:Nc loop
        if i == Base_C then
          Fin_c[i] = Fin_pc[2, i];
          Fout_c[i] = Fin_c[i] + Sc[i, 1] / Bc[1] * X[Base_C] * Fin_c[Base_C];
        else
          Fin_c[i] = Fin_pc[1, i];
          Fout_c[i] = Fin_c[i] + Sc[i, 1] / Bc[1] * X[Base_C] * Fin_c[Base_C];
        end if;
      end for;
//Cin_cnversion of Reactants
      for j in 2:Nc loop
        if Sc[j, 1] < 0 then
          X[j] = (Fin_pc[Phase, j] - Fout_pc[Phase, j]) / Fin_pc[Phase, j];
        else
          X[j] = 0;
        end if;
      end for;
    else
//Vapour Phase
//======================================================================================================
      Cin_c[:] = Fin_pc[3, :] / Fv_p[3];
      for i in 1:Nc loop
        if i == Base_C then
          Fin_c[i] = Fin_pc[3, i];
          Fout_c[i] = Fin_c[i] + Sc[i, 1] / Bc[1] * X[Base_C] * Fin_c[Base_C];
        else
          Fin_c[i] = Fin_pc[1, i];
          Fout_c[i] = Fin_c[i] + Sc[i, 1] / Bc[1] * X[Base_C] * Fin_c[Base_C];
        end if;
      end for;
//Cin_cnversion of Reactants
      for j in 2:Nc loop
        if Sc[j, 1] < 0 then
          X[j] = (Fin_pc[Phase, j] - Fout_pc[Phase, j]) / Fin_pc[Phase, j];
        else
          X[j] = 0;
        end if;
      end for;
    end if;
//================================================================================================
//Reaction Manager
    n = sum(DO[:]);
//Calculation of Rate Cin_cnstants
    for i in 1:Nr loop
        k_r[i] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, A1[i], E1[i], Tin);
    end for;
//Material Balance
//Initial Number of Moles
    for i in 1:Nr loop
      for j in 1:Nc loop
        if Sc[j, i] > 0 then
          Sc[j, i] = Fin_cr[j, i];
        else
          Sc[j, i] = -Fin_cr[j, i];
        end if;
      end for;
    end for;
//Calculation of V with respect to Cin_cnversion of limiting reeactant
    V = Performance_PFR(n, Cin_c[Base_C], Fin_c[Base_C], k_r[1], X_r[Base_C]);
//============================================================================================================
//Calculation of Heat of Reaction at the reaction temperature
//Outlet temperature and energy stream
//Isothermal Mode
    if Mode == 1 then
      Hr = HOR[1] * 1E-3 * Fin_c[Base_C] * X_r[Base_C];
      Tout = Tin;
      Q = Hr - Hin / MW_p[1] * Fmin_p[1] + Hout / MW_p[1] * Fmin_p[1];
//Outlet temperature defined
    elseif Mode == 2 then
      Hr = HOR[1] * 1E-3 * Fin_c[Base_C] * X_r[Base_C];
      Tout = Tdef;
      Q = Hr - Hin / MW_p[1] * Fmin_p[1] + Hout / MW_p[1] * Fmin_p[1];
//Adiabatic Mode
    else
      Hr = HOR[1] * 1E-3 * Fin_c[Base_C] * X_r[Base_C];
      Q = 0;
      Hout / MWout_p[1] = Hin / MW_p[1] - Hr;
    end if;
//===========================================================================================================
//Calculation of Outlet Pressure
    Pout = Pin - Pdel;
//Calculation of Mole Fraction of outlet stream
    xout_pc[1, :] = Fout_c[:] / Fout_p[1];
        sum(Fout_c[:]) = Fout_p[1];
//===========================================================================================================
//Phase Equilibria For Outlet Stream
//Bubble point calculation
    Pbublout = sum(gmabubl_c[:] .* xout_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / Tout + C[:].VP[4] * log(Tout) + C[:].VP[5] .* Tout .^ C[:].VP[6]) ./ philiqbubl_c[:]);
//Dew point calculation
    Pdewout = 1 / sum(xout_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / Tout + C[:].VP[4] * log(Tout) + C[:].VP[5] .* Tout .^ C[:].VP[6])) .* phivapdew_c[:]);
  if Pout >= Pbublout then
//below bubble point region
      xout_pc[3, :] = zeros(Nc);
      sum(xout_pc[2, :]) = 1;
    elseif Pout <= Pdewout then
//above dew point region
      xout_pc[2, :] = zeros(Nc);
      sum(xout_pc[3, :]) = 1;
    else
//VLE region
      for i in 1:Nc loop
        xout_pc[3, i] = K[i] * xout_pc[2, i];
      end for;
      sum(xout_pc[2, :]) = 1;
//sum y = 1
    end if;
//RachFord Rice Equation
    for i in 1:Nc loop
      xout_pc[1, i] = xout_pc[3, i] * xmvapout + xout_pc[2, i] * (1 - xmvapout);
    end for;
        Fout_p[3] = Fout_p[1] * xmvapout;
        Fout_p[2] = Fout_p[1] * (1 - xmvapout);
//===========================================================================================================
//Calculation of Mass Fraction
//Average Molecular Weights of respective phases
    if xmvapout <= 0 then
      MWout_p[1] = sum(xout_pc[1, :] .* C[:].MW);
      MWout_p[2] = sum(xout_pc[2, :] .* C[:].MW);
      MWout_p[3] = 0;
//====================================================================================================
    elseif xmvapout == 1 then
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
  annotation(Icon(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
      Diagram(coordinateSystem(extent = {{-350, -100}, {350, 100}})),
      __OpenModelica_Cin_cmmandLineOptions = "");
  end PFR;