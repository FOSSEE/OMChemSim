within Simulator.UnitOperations;

model CentrifugalPump
//===========================================================================
//Header files and Parameters
  extends Simulator.Files.Icons.CentrifugalPump;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component array";
  parameter Integer Nc = 2 "Number of Components";
  parameter Real Eff "Efficiency";
  
//===========================================================================
//Model Variables
  Real Pin(min = 0, start = 101325) "Inlet Pressure";
  Real Tin(min = 0, start = 273.15) "Inlet Temperature"; 
  Real Hin "Inlet Mixture Molar Enthalpy"; 
  Real Fin(min = 0, start = 100) "Inlet Mixture Molar Flow";
  Real xin_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Inlet Mixuture Molar Fraction";  

  Real Tdel "Temperature increase";
  Real Pdel "Pressure Increase";
  Real Q "Power required";
  Real rho_c[Nc](each min = 0) "Component density";
  Real rho(min = 0) "Density";
  Real Pvap(min = 0, start = 101325) "Vapor pressure of Mixture at Outlet Temperature";
  Real NPSH "NPSH"; 
  
  Real Pout(min = 0, start = 101325) "Outlet Pressure";
  Real Tout(min = 0, start = 273.15) "Outlet Temperature"; 
  Real Hout "Outlet Mixture Molar Enthalpy";
  Real Fout(min = 0, start = 100) "Outlet Mixture Molar flow";
  Real xout_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "Outlet Mixture Molar Fraction";

//============================================================================
//Instantiation of Connectors  
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
//============================================================================
//Connector equation
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
  En.Q = Q;
  
//=============================================================================
//Pump equations
  Fin = Fout;
  xin_c = xout_c;
  Pin + Pdel = Pout;
  Tin + Tdel = Tout;
  
//=============================================================================
//Calculation of Density
  for i in 1:Nc loop
    rho_c[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tin, Pin);
  end for;
  rho = 1 / sum(xin_c ./ rho_c);
  
//==============================================================================
//Energy Balance and NPSH Calculation
  Hout = Hin + Pdel / rho;
  Q = Fin * (Hout - Hin) / Eff;
  NPSH = (Pin - Pvap) / rho;
  
//===============================================================================
//Vapor Pressure of mixture at Outlet Temperature
  Pvap = sum(xin_c .* exp(C[:].VP[2] + C[:].VP[3] / Tout + C[:].VP[4] * log(Tout) + C[:].VP[5] .* Tout .^ C[:].VP[6]));
end CentrifugalPump;
