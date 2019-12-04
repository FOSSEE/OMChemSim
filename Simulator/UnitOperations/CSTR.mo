within Simulator.UnitOperations;

model CSTR
//===============================================================================
  //Header Files and Parameters
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.GeneralProperties C[Nc];
  import Simulator.Files.*;
  import Simulator.Files.ThermodynamicFunctions.*;
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  extends Simulator.Files.Icons.CSTR;
  parameter Integer Nc "Number of Compounds", Nr "Number of Reactions", BC_r[Nr] "Base component";
  parameter Real Pdel "Pressure Drop", Mode "Mode of Operation", Tdef "Define outlet Temperature", Coef_cr[Nc, Nr] "Stochiometry", Phase "Reaction Phase", VHspace "Volume of Headspace";
  Integer n "Order of the reaction";
  //===============================================================================
  //Model Variables
  Real Pin(unit = "Pa") "Inlet Pressure", Tin(unit = "K") "Inlet Temperature", P(unit = "Pa"), Pout(unit = "Pa") "Outlet Pressure", Tout(unit = "K") "Outlet Temperature", T(unit = "K"), Hin(unit = "kJ/kmol") "Mixture Mol Enthalpy in the inlet", Hout(unit = "kJ/kmol") "Mixture Mol Enthalpy in the outlet", xvapin(unit = "-") "Vapor fraction in the inlet", xvapout(unit = "-") "Vapor fraction in outlet", Fin(unit = "mol/s") "Inlet total mole flow", Fout_p[3](each unit = "mol/s") "Outlet total mole flow", F_pc[3,Nc](each unit = "mol/s") "Component mol-flow at outlet", xin_pc[1,Nc](each unit = "-") "Component mol-frac at inlet", xout_pc[3,Nc](each unit = "-")"Component mol-frac at outlet", xmout_pc[3,Nc](each unit = "-") "Component Mas-Frac at outlet", Fmout_pc[3,Nc](each unit = "kg/s"), rholiq_c[Nc](each unit = "kg/m^3") "Density of Liquid", MW[3](each unit = "kg/kmol") "Average Molecular Weight", Fmout_p[3](each unit = "kg/s") "Outlet Mass Flow", En_flo(unit = "W") "Energy supplied/removed", Hr(unit = "kJ/kmol") "Heat of Reaction", psat[Nc](each unit = "Pa") "Saturated Vapor Phase", rhovap_c[Nc](each unit = "kg/m^3") "Vapor Density", rholiq(unit = "kg/m^3") "Density of Liquid", rhovap(unit = "kg/m^3") "Density of Vapor", rho(unit = "kg/m^3") "Phase Density", Fvout_p[3](each unit = "m^3/s") "Outlet Volumetric Flow", VFrac(unit = "-"), Pbubl(unit = "Pa") "Bubble point", Pdew(unit = "Pa") "Dew point", xvap(unit = "-") "Vapor Mole-Fraction", xmvap(unit = "-") "Vapor Mass-Fraction", FO_cr[Nc,Nr](each unit = "mol/s")"Inlet Flow", F_cr[Nc,Nr](each unit = "mol/s") "Outlet Flow", X(unit = "-") "Conversion of Base componet", k_r[Nr]"Rate constant", r_r[Nr](each unit = "mol/m^3.S") "Rate of Reaction", C_r[BC_r[Nr]](each unit = "mol/m^3") "Concentration of Base Component", VRxn(unit = "liters") "Volume of Reaction", V(unit = "liters") "Volume of the reactor";

//===============================================================================
  //Instatiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100,2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -158}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends Simulator.Files.Models.ReactionManager.KineticReaction(Nr = 1, BC_r = {1},Comp = 3, Coef_cr = {{-1}, {-1}, {1}}, DO_cr = {{1}, {0}, {0}},  Af_r = {0.5}, Ef_r = {0}); 
  
equation

  T = Tout;
  P = Pout;
//===============================================================================
//Connector-Equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.x_pc[1, :] = xin_pc[1, :];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout_p[1];
  Out.H = Hout;
  Out.x_pc[1, :] = xout_pc[1, :];
  Out.xvap = xvapout;
  En.Q = En_flo;
//===============================================================================
//Flash of Outlet Stream
  Pbubl = sum(gmabubl_c[:] .* xout_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
  Pdew = 1 / sum(xout_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
//===============================================================================
//Below bubble point region
  if Pout >= Pbubl then
    xout_pc[3, :] = zeros(Nc);
    Fout_p[3] = 0;
    xout_pc[2, :] = xout_pc[1, :];
    xmout_pc[3, :] = zeros(Nc);
    Fmout_pc[1, :] = xmout_pc[1, :] .* Fmout_p[1];
    xmout_pc[2, :] = xmout_pc[1, :];
//===============================================================================
//Above dew point region
  elseif Pout <= Pdew then
    xout_pc[2, :] = zeros(Nc);
    Fout_p[2] = 0;
    xout_pc[3, :] = xout_pc[1, :];
    xmout_pc[2, :] = zeros(Nc);
    Fmout_pc[1, :] = xmout_pc[1, :] .* Fmout_p[1];
    xmout_pc[3, :] = xmout_pc[1, :];
  else
//===============================================================================
//VLE region
    for i in 1:Nc loop
      xout_pc[3, i] = K_c[i] * xout_pc[2, i];
      xout_pc[1, i] = (1 - xvap) * xout_pc[2, i] + xvap * xout_pc[3, i];
//      xout_pc[2, i] = xout_pc[1, i] ./ (1 + xvap * (K_c[i] - 1));
    end for;
    sum(xout_pc[2, :]) - sum(xout_pc[3, :]) = 0;
    for i in 1:Nc loop
      Fmout_pc[:, i] = Fmout_p[:] .* xmout_pc[:, i];
    end for;
  end if;
//===============================================================================
//Mole Balance
  FO_cr[:, 1] = xin_pc[1, :] * Fin; 
  for i in 1:Nc loop
  F_cr[i, 1] = FO_cr[i, 1] + Coef_cr[i, 1] * r_r[1] * VRxn;
  end for;
  X = (FO_cr[BC_r[1],1] - F_cr[BC_r[1],1]) / FO_cr[BC_r[1],1] ; 
  sum(F_cr[:,1]) = Fout_p[1];
  for i in 1:Nc loop
    xout_pc[1, i] = sum(F_cr[i, :]) / Fout_p[1];
    F_pc[:, i] = Fout_p[:] .* xout_pc[:, i];
    psat[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);
  end for;
  Fout_p[1] = Fout_p[2] + Fout_p[3];
  xvap = Fout_p[3] / Fout_p[1];
  for i in 1:Nc loop
  Fmout_pc[:, i] = F_pc[:, i] * C[i].MW;
  end for; 
  Fmout_p[:] = Fout_p[:] .* MW[:];
  xmvap = Fmout_p[3] / Fmout_p[1] ;
  k_r[:] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, Af_r[:], Ef_r[:], T); 
  rholiq_c = ThermodynamicFunctions.DensityRacket(Nc, T, Pout, C[:].Pc, C[:].Tc, C[:].Racketparam, C[:].AF, C[:].MW, psat[:]);
//===============================================================================
//Calculation of Mixer Density and Volumetric Flowrate
  rhovap_c[:] = Pout .* C[:].MW / (8.314 * T) * 1E-03;
  rholiq = 1 / sum(xmout_pc[2, :] ./ rholiq_c[:]) ;
  rhovap = 1 / sum(xmout_pc[3, :] ./ rhovap_c[:]) ;
  rho = 1 / ((xmvap / rhovap) + ((1-xmvap) / rholiq)); 
  n = sum(DO_cr[:]);
  Fvout_p[1] = Fmout_p[1]  / (rho*1000) ;
  Fvout_p[2] = Fmout_p[2]  / (rholiq*1000) ;
  Fvout_p[3] = Fmout_p[3]  / (rhovap*1000) ;
//===============================================================================
//Volume of Reaction
  if Phase == 1 then
    C_r[BC_r[:]] = F_pc[1, BC_r[:]] ./ Fvout_p[1];
    VFrac = VHspace;
    VRxn = V + VFrac;
  elseif Phase == 2 then
    VFrac = Fvout_p[2] / Fvout_p[1];
    C_r[BC_r[:]] = F_pc[2, BC_r[:]] ./ Fvout_p[2];
    VRxn = V * VFrac;
  elseif Phase == 3 then
    VFrac = Fvout_p[3] / Fvout_p[1];
    C_r[BC_r[:]] = F_pc[3, BC_r[:]] ./ Fvout_p[3];
    VRxn = V * VFrac;
  end if;
//===============================================================================
//Rate Equation
  for i in 1:Nr loop
    r_r[i] = k_r[i] * C_r[BC_r[i]] ^ n;
  end for;
  Pout = Pin - Pdel;
//===============================================================================
//Energy Balance
//===============================================================================
//Isothermal Operation
  if Mode == 1 then
    Hr = Hr_r[1] * FO_cr[BC_r[Nr], Nr] .* X;
    Fin * Hin - Fout_p[1] * Hout + En_flo - Hr = 0;
    Tin = Tout;
//===============================================================================
//Outlet Temperature Defined
  elseif Mode == 2 then
    Tout = Tdef;
    Hr = Hr_r[1] * FO_cr[BC_r[Nr], Nr] .* X;
    Fin * Hin - Fout_p[1] * Hout + En_flo - Hr = 0;
//===============================================================================
//Adiabatic Operation
  elseif Mode == 3 then
    En_flo = 0;
    Hr = Hr_r[1] * FO_cr[BC_r[Nr], Nr] .* X;
    Fin*Hin + En_flo  =  Fout_p[1]*Hout + Hr;
  end if;
//===============================================================================
//Average Molecular Weight Calculation
algorithm
  for i in 1:Nc loop
    MW[:] := MW[:] + C[i].MW * xout_pc[:, i];
  end for;
end CSTR;
