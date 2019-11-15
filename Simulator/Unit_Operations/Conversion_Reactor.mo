within Simulator.Unit_Operations;

model Conversion_Reactor

//=============================================================================
//Header Files and Parameters
  extends Simulator.Files.Icons.Conversion_Reactor;
  parameter Real X_r[Nr] = fill(0.4, Nr) "Conversion of base component";
  parameter Integer Nc "Number of components";
  parameter Real Pdel = 0 "Pressure drop";
  parameter Real Tdef = 300 "Defined Out temperature, only applicable if define Out temperature mode is chosen";
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc];
  parameter String CalcMode = "Isothermal" "Isothermal, Define_Out_Temperature, Adiabatic; choose the required mode of operation";
 
//=============================================================================
//Model Variables
  Real Fin(min = 0, start = 100) "Inlet Molar Flowrate";
  Real Fout(min = 0, start = 100) "Outlet Molar Flowrate";
  Real xin_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Inlet component Mole Fraction";
  Real xout_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Outlet component Mole Fraction";
  Real Hin "Inlet Molar Enthalpy";
  Real Hout "Outlet Molar Enthalpy";
  Real Pin(min = 0, start = 101325) "Inlet pressure";
  Real Pout(min = 0, start = 101325) "Outlet pressure";
  Real Tin(min = 0, start = 273.15) "Inlet Temperature";
  Real Tout(min = 0, start = 273.15) "Outlet Temperature";
  Real Fout_cr[Nc, Nr] "Number of moles of components after reactions";
  
//=============================================================================
//Instanstiation of Connectors
  Simulator.Files.Connection.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn energy annotation(
    Placement(visible = true, transformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

//=============================================================================
//Connector Equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.x_pc[1, :] = xin_c[:];
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.x_pc[1, :] = xout_c[:];
  
//=============================================================================
//Mole Balance
  for i in 1:Nc loop
    Fout_cr[i, 1] = Fin * xin_c[i] - Coef_cr[i, 1] / Coef_cr[Bc_r[1], 1] * Fin * xin_c[Bc_r[1]] * X_r[1];
  end for;
  if Nr > 1 then
    for j in 2:Nr loop
      for i in 1:Nc loop
        Fout_cr[i, j] = Fout_cr[i, j - 1] - Coef_cr[i, j] / Coef_cr[Bc_r[j], j] * Fin * xin_c[Bc_r[j]] * X_r[j];
      end for;
    end for;
  end if;
  Fout = sum(Fout_cr[:, Nr]);
  for i in 1:Nc loop
    xout_c[i] = Fout_cr[i, Nr] / Fout;
  end for;
  
//=============================================================================
//Outlet Pressure
  Pin - Pdel = Pout;

//=============================================================================
//Energy Balance
  if CalcMode == "Isothermal" then
    Tin = Tout;
    energy.enFlo = Hout * Fout - Hin * Fin;
  elseif CalcMode == "Adiabatic" then
    Hout * Fout = Hin * Fin;
    energy.enFlo = 0;
  elseif CalcMode == "Define_Outlet_Temperature" then
    Tout = Tdef;
    energy.enFlo = Hout * Fout - Hin * Fin;
  end if;
annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    __OpenModelica_commandLineOptions = "");end Conversion_Reactor;
