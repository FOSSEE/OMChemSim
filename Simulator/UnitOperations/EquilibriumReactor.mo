within Simulator.UnitOperations;

model EquilibriumReactor "Model of an equilibrium reactor to calculate the outlet stream mole fraction of components"

extends Simulator.Files.Icons.EquilibriumReactor;

//EquiibriumReactor Code works for all the valid phases and all modes available in DWSIM
  //The reaction basis included are PartialPressure, Activity and MoleFraction
  //The base component need not be specified and is directly calculated from an external function
  //==========================================================================================================
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
  parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
  //======================================================================================
  extends Simulator.GuessModels.InitialGuess;
  //Connector Variables
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy";
  Real Sin(unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real xin_c[Nc](each unit = "K", each min = 0, each max = 1, start=xg) "Inlet stream component mole fraction";
  Real xvapin;
  Real Pout(unit = "Pa", min = 0, start =Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Fout(unit = "mol/s", min = 0, start = Fg) "Outlet stream molar flow rate";
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real Sout(unit = "kJ/[kmol.K]") "Outlet stream molar entropy";
  Real xout_c[Nc](each unit = "=", each min = 0, each max = 1, start=xg) "Outlet stream component mole fraction";
  Real xvapout;
  Real Q;

//Model Variables
  Real Psat[Nc]"Vapour Pressure";
  Real Kmod[Nr]"Modified Equiibrium Contant";
  Real Fin_c[Nc]"Component Molar Flow Rates";
  Real Hr"Reaction Heat";
  //Model Parameters
  parameter String Phase  = "Vapour" "Required phase: Liquid, Vapour" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
  parameter String Basis = "Activity" "Required basis: MoleFraction, Activity, PartialPressure" annotation(
    Dialog(tab = "Reactions", group = "Equilibrium Reaction Parameters"));
  parameter String Mode = "Isothermal" "Required mode of operation: Isothermal, OutletTemperature, Adiabatic" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real Pdel(unit = "Pa") = 0 "Pressure drop" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real Tdef(unit = "K") = 300 "Defined outlet temperature, applicable if OutletTemperature mode is chosen" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  //Reaction Variables
  Real SC_rc[Nr,Nc]"Stoichiometric coefficients of the components";
  Integer BC_r[Nr] "Base component of reaction";
  Real Ndel[Nr];
  Real Scabs[Nr,Nc]"Relative stoichiometry with respect to base component";
  Real Ext_r[Nr](each start=xvapg) "Reaction Extent";
  Real X_r[Nr,Nc]"Conversion of reactants";
 //============================================================================================================
 extends Simulator.Files.Models.ReactionManager.EquilibriumReaction( Nr = 1,Coef_cr = {{-1}, {-1}, {1},{1}},Rmode="ConstantK",Kg={0.5},T =Tout);
 Simulator.Files.Interfaces.matConn Out(Nc=Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Simulator.Files.Interfaces.enConn enConn annotation(
    Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Simulator.Files.Interfaces.matConn In(Nc=Nc) annotation(
    Placement(visible = true, transformation(origin = {-98, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 //=========================================================================================
equation
//=========================================================================================
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = xin_c;
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = xout_c;
  Out.xvap = xvapout;
  enConn.Q = Q;
 
  Pout = Pin - Pdel;
 
for i in 1:Nc loop
Psat[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP,Tin);
end for;
//Automated calculation of base component
  for i in 1:Nc loop
    Fin_c[i] = Fin * xin_c[i];
  end for;

for i in 1:Nr loop
BC_r[i] = Simulator.Files.Models.ReactionManager.BaseCalc(Nc,Fin_c,SC_rc[i,:]);
end for;


for j in 1:Nr loop
for i in 1:Nc loop
SC_rc[j,i] = Coef_cr[i,j];
end for;
end for;
//==========================================================================================================
  for i in 1:Nr loop
    Ndel[i] = sum(SC_rc[i, 1:Nc]);
  end for;

if Mode == "Isothermal" then
  Tout = Tin;
  Hr = Hr_r[1] * 1E-3 * (Fin_c[BC_r[1]]*X_r[1,BC_r[1]])/(Coef_cr[BC_r[1],1]) * (Coef_cr[BC_r[1],1]);
  Q= (Hout*Fout*1E-3) - (Hin*Fin*1E-3) -Hr;
  
else
  if Mode=="OutletTemperature" then
  Tout = Tdef;
  Hr = Hr_r[1] * 1E-3 * (Fin_c[BC_r[1]]*X_r[1,BC_r[1]])/(Coef_cr[BC_r[1],1]) * (Coef_cr[BC_r[1],1]);
  Q= (Hout*Fout*1E-3) - (Hin*Fin*1E-3) -Hr;
 
  else
  Q=0;
  Hr =Hr_r[1] * 1E-3 * (Fin_c[BC_r[1]]*X_r[1,BC_r[1]])/(Coef_cr[BC_r[1],1]) * (Coef_cr[BC_r[1],1]);
  Q = (Hout*Fout*1E-3) - (Hin*Fin*1E-3) -Hr;
  end if;
end if;
for i in 1:Nr loop
  for j in 1:Nc loop
    Scabs[i, j] = SC_rc[i, j] / abs(SC_rc[i, BC_r[i]]);
  end for;
end for;
if Phase == "Vapour" then
  if Basis == "MoleFraction" then
    for i in 1:Nr loop
      Kmod[i] = K[i];
      Kmod[i] = product((xin_c+ Ext_r * Scabs) .^ SC_rc[i, 1:Nc]) / (1 + sum(Ext_r * Scabs)) ^ sum(SC_rc[i, 1:Nc]);
    end for;
  else
    if Basis == "Activity" then
      for i in 1:Nr loop
        Kmod[i] = K[i] / (Pin / 101325) ^ Ndel[i];
        Kmod[i] = product((xin_c + Ext_r * Scabs) .^ SC_rc[i, 1:Nc]) / (1 + sum(Ext_r * Scabs)) ^ sum(SC_rc[i, 1:Nc]);
      end for;
    else
      for i in 1:Nr loop
        Kmod[i] = K[i] / (Pout) ^ Ndel[i];
        Kmod[i]=product((xin_c+Ext_r * Scabs).^ SC_rc[i, 1:Nc])/(1 + sum(Ext_r * Scabs))^sum(SC_rc[i, 1:Nc]);
      end for;
    end if;
  end if;
else
  if Basis == "MoleFraction" then
    for i in 1:Nr loop
      Kmod[i] = K[i];
      Kmod[i]=product((xin_c + Ext_r *Scabs).^ SC_rc[i,1:Nc])/(1 + sum(Ext_r * Scabs))^sum(SC_rc[i, 1:Nc]);
    end for;
  else
    if Basis == "Activity" then
      for i in 1:Nr loop
        Kmod[i] = K[i] /( Pout ^ (-Ndel[i]));
     Kmod[i]=product((Psat.*(xin_c + Ext_r * Scabs)).^ SC_rc[i, 1:Nc])/(1 + sum(Ext_r * Scabs))^sum(SC_rc[i, 1:Nc]);
      end for;
    else
      for i in 1:Nr loop
     Kmod[i] = K[i];
    Kmod[i]=product((Psat.*(xin_c + Ext_r * Scabs)).^ SC_rc[i, 1:Nc])/(1 + sum(Ext_r * Scabs))^sum(SC_rc[i, 1:Nc]);
      end for;
    end if;
  end if;
end if;

Fout = (1 + sum(Ext_r * Scabs))*Fin;
for i in 1:Nc loop
  xout_c[i] = (xin_c[i] + Ext_r * Scabs[1:Nr, i])*(Fin/Fout);
end for;

for j in 1:Nr loop
for i in 1:Nc loop
if(SC_rc[j,i]<0) then
X_r[j,i] =((Fin *xin_c[i]) - (Fout * xout_c[i]))/(Fin * xin_c[i]);
else
X_r[j,i]=0;
end if;
end for;
end for;
//===========================================================================================================
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
 Documentation(info = "<html><head></head><body><div>The <b>Equilibrium&nbsp;Reactor</b>&nbsp;is used to calculate the mole fraction of components at outlet stream when the equilibrium constant of the reaction is defined.</div><div><br></div><div><div style=\"font-size: 12px;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The plug flow reactor model have following connection ports:</span></div><div style=\"font-size: 12px;\"><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">heat added</span></li></ul></ol></div></div></div><div><br></div>To simulate an equilibrium reactor, following calculation parameters must be provided:<div><ol><li>Calculation Mode (<b>Mode</b>)</li><li>Reaction Basis (<b>Basis</b>)</li><li>Reaction Phase (<b>Phase</b>)</li><li>Calculation Mode (<b>Mode</b>)</li><li>Outlet Temperature&nbsp;(<b>Tdef</b>)&nbsp;(If calculation mode is OutletTemperature)</li><li>Pressure Drop (<b>Pdel</b>)</li><li>Number of Reactions (<b>Nr</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li><li>Mode of specifying Equilibrium Constant (<b>Rmode</b>)</li><li>Equilibrium Constant (<b>Kg</b>) (<span style=\"font-size: 12px;\">If Equilibrium Constant mode is ConstantK</span>)</li><li>Temperature function coefficients (<b>A</b>&nbsp;and&nbsp;<b>B</b>)&nbsp;(<span style=\"font-size: 12px;\">If Equilibrium Constant mode is Tempfunc</span>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">Among the above variables, first one (<b>CalcMode</b>) is of type&nbsp;<i>parameter String</i>. It can have either of the sting values among following:</span></div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><ol><li><b>Isothermal</b>: If the reactor is operated isothermally</li><li><b>OutletTemperature</b>: If the reactor is operated at specified outlet temperature</li><li><b>Adiabatic</b>: If the reactor is operated adiabatically</li></ol><div><div><span style=\"orphans: auto; widows: auto;\">Mode of specifying Equilibrium Constant (<b>Rmode</b>) </span><span style=\"orphans: auto; widows: auto;\">is also of type&nbsp;</span><i style=\"orphans: auto; widows: auto;\">parameter String</i><span style=\"orphans: auto; widows: auto;\">. It can have either of the sting values among following:</span></div><div><ol><li><b>ConstantK</b>: If the equilibrium constant is defined directly</li><li><b>Tempfunc</b>: If the equilibrium constant is to be calculated from given function of temperature</li></ol></div></div></div></div><div><div style=\"font-size: 12px;\">The other variables are of type&nbsp;<i>parameter Real.&nbsp;</i></div></div></div><div style=\"font-size: 12px;\"><span style=\"orphans: 2; widows: 2;\">During simulation, their values can specified directly under&nbsp;</span><b style=\"orphans: 2; widows: 2;\">Reactions&nbsp;</b><span style=\"orphans: 2; widows: 2;\">tab</span><b style=\"orphans: 2; widows: 2;\">&nbsp;</b><span style=\"orphans: 2; widows: 2;\">by double clicking on the reactor model instance.</span></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate an Equilibrium Reactor, go to&nbsp;</span><a href=\"modelica://Simulator.Examples.EquilibriumReactor\" style=\"font-size: 12px;\">Eqilibrium Reactor Example</a><span style=\"font-size: 12px;\">.</span></div><div><span style=\"font-size: 12px;\"><br></span></div></body></html>"));
end EquilibriumReactor;
