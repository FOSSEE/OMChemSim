within Simulator.UnitOperations;

model Evaporator
//=============================================================================
//Header Files and Parameters
 import data = Simulator.Files.ChemsepDatabase;
 parameter data.GeneralProperties C[Nc];
 import Simulator.Files.*;
 import Simulator.Files.ThermodynamicFunctions.*;
 extends Simulator.Files.Icons.Evaporator;
 parameter Integer Nc "Number of Compounds";
 parameter Real U = 2500 "Overall Heat-transfer coefficient";
 parameter Real Pm = 1e4 "Pressure Maintained in the Evaporator";
 
//=============================================================================
//Variables
 Real Pin "Inlet Pressure", Pout "Outlet Pressure", Tin "Inlet Temperature", Tout "Outlet Temperature", Hin "Inlet Enthalpy", Hout "Liquid Enthalpy", Hvapout "Vapor Enthalpy", Q "Heat supplied", A "Area Required for Heat Transfer", lamda "Latent Heat of steam", Fmsteam "Steam Molar Flow Required", Msteam "Mass Flowrate of steam", F_p[3] "Molar Flowrates", x_pc[3, Nc] "Mole Fraction of feed components in respective phases", T(start = 300) "Boiling Temperature at the Pressure", Tdel "Driving Force for Heat-Transfer", MW_p[3] "Molecular Weight of Phases", Ts(start = 300) "Saturated Steam Temperature", Ps  "Saturated Stream Pressure";
  
//=============================================================================
//Connector Instantiation
 Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-86, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Simulator.Files.Interfaces.matConn Out1(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {36, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {94, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Simulator.Files.Interfaces.matConn Out2(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {36, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {94, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

 //=============================================================================
 //Connector Equation 
  In.P = Pin;
  In.T = Tin;
  In.F = F_p[1];
  In.H = Hin;
  In.x_pc[1, :] = x_pc[1, :];
  Out1.P = Pout;
  Out1.T = Tout;
  Out1.F = F_p[2];
  Out1.H = Hout;
  Out1.x_pc[1, :] = x_pc[3, :];
  Out2.P = Pout;
  Out2.T = Tout;
  Out2.F = F_p[3];
  Out2.H = Hvapout;
  Out2.x_pc[1, :] = x_pc[2, :];
  
 //=============================================================================
 //Mole Balance Equation
 F_p[1] = F_p[2] + F_p[3] ;
 F_p[1] * x_pc[1, Nc] = F_p[2] * x_pc[2, Nc] ;
 F_p[1] * x_pc[1, 1] = F_p[2] * x_pc[2, 1] + F_p[3] * x_pc[3, 1];
 sum(x_pc[2,:]) = 1;
 sum(x_pc[3,:]) = 1;
 Pout = Pm;
 Tdel = Ts - T;
 Tout = Ts - Tdel;
 
 //=============================================================================
 //Energy Balance
 Pm = Simulator.Files.ThermodynamicFunctions.Psat(C[1].VP, T);
 Ps = Simulator.Files.ThermodynamicFunctions.Psat(C[1].VP, Ts);
 lamda = Simulator.Files.ThermodynamicFunctions.HV(C[1].HOV, C[1].Tc,Ts);
 F_p[1] * Hin + Q = F_p[2] * Hout + F_p[3] * Hvapout;
 Q = U * A * Tdel;
 Q = Fmsteam * lamda;
 Msteam = Fmsteam * C[1].MW;
 
 //=============================================================================
 //Average Molecular Weight Calculation
 algorithm
  for i in 1:Nc loop
    MW_p[:] := MW_p[:] + C[i].MW * x_pc[:, i];
  end for;
end Evaporator;
