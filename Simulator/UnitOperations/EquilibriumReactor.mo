within Simulator.UnitOperations;

model EquilibriumReactor

extends Simulator.Files.Icons.EquilibriumReactor;

//EquiibriumReactor Code works for all the valid phases and all modes available in DWSIM
  //The reaction basis included are PartialPressure, Activity and MoleFraction
  //The base component need not be specified and is directly calculated from an external function
  //==========================================================================================================
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] annotation(
    Dialog(tab = "General-Specifications", group = "Component-parameters"));
  
  parameter Integer Nc annotation(
    Dialog(tab = "General-Specifications", group = "Component-parameters"));
  //======================================================================================

  
  extends Simulator.GuessModels.InitialGuess;
  //Connector Variables
  Real Pin, Tin, Fin, Hin, Sin, xin_c[Nc], xvapin;
  Real Pout, Tout, Fout, Hout, Sout, xout_c[Nc], xvapout;
  Real Q;

//Model Variables
  Real Psat[Nc]"Vapour Pressure";
  Real Kmod[Nr]"Modified Equiibrium Contant";
  Real Fin_c[Nc]"Component Molar Flow Rates";
  Real Hr"Reaction Heat";
  //Model Parameters
  parameter String Phase;
  parameter String Basis;
  parameter String Mode;
  parameter Real Pdel;
  parameter Real Tdef;
  //Reaction Variables
  Real SC_rc[Nr,Nc];
  Integer BC_r[Nr]"Base component of reaction";
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
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})));
end EquilibriumReactor;
