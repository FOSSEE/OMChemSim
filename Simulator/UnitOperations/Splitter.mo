within Simulator.UnitOperations;

model Splitter
//============================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.Splitter;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc = 2 "Number of Components", No = 2 "Number of outlet streams";
  parameter String CalcType "Split_Ratio, Mass_Flow or Molar_Flow";
  
//=============================================================================
//Model Variables
  Real Pin(min = 0, start = Pg) "Inlet pressure";
  Real Tin(min = 0, start = Tg) "Inlet Temperature";
  Real xin_c[Nc](each min = 0, each max = 1,  start =xg) "Inlet Mixture Mole Fraction";
  Real Fin(min = 0, start = Fg) "Inlet Mixture Molar Flow";
  
  Real SplRat_s[No](each min = 0, each max = 1) "Split ratio";
  Real MW(each min = 0) "Average molecular weight";
  Real SpecVal_s[No] "Specification value"; 
  
  Real Pout_s[No](each min = 0, each start = Pg) "Outlet Pressure";
  Real Tout_s[No](each min = 0, each start = Tg) "Outlet Temperature";
  Real xout_sc[No, Nc](each min = 0, each max = 1, start = xguess) "Outlet Mixture Molar Fraction";
  Real Fout_c[No](each min = 0,  start = Fg) "Outlet Mixture Molar Flow";
  Real Fmout_c[No](each min = 0, start = Fg) "Outlet Mixture Mass Flow";
  

//==============================================================================
//Instantiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out[No](each Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
  
  equation
//==============================================================================
//Connector equations
  In.P = Pin;
  In.T = Tin;
  In.x_pc[1, :] = xin_c[:];
  In.F = Fin;
  for i in 1:No loop
    Out[i].P = Pout_s[i];
    Out[i].T = Tout_s[i];
    Out[i].x_pc[1, :] = xout_sc[i, :];
    Out[i].F = Fout_c[i];
  end for;
//================================================================================
//Specification value assigning equation
  if CalcType == "Split_Ratio" then
    SplRat_s[:] = SpecVal_s[:];
  elseif CalcType == "Molar_Flow" then
    Fout_c[:] = SpecVal_s[:];
  elseif CalcType == "Mass_Flow" then
    Fmout_c[:] = SpecVal_s[:];
  end if;
//=================================================================================
//Balance equation
  for i in 1:No loop
    Pin = Pout_s[i];
    Tin = Tout_s[i];
    xin_c[:] = xout_sc[i, :];
    SplRat_s[i] = Fout_c[i] / Fin;
    MW * Fout_c[i] = Fmout_c[i];
  end for;
//==================================================================================
//Average Molecular Weight Calculation
algorithm
  MW := 0;
  for i in 1:Nc loop
    MW := MW + C[i].MW * xin_c[i];
  end for;
end Splitter;
