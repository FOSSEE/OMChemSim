within Simulator.UnitOperations;

model AdiabaticCompressor
  extends Simulator.Files.Icons.AdiabaticCompressor;
  // This is generic Adibatic Compressor model. For using this model we need to extend this model and respective thermodynamic model and use the new model in flowsheets. Refer adia_comp models in Test section for this.
  extends Simulator.Files.Models.Flash;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc "number of components";

  //====================================================================================
  Real Fin(min = 0, start = 100) "inlet mixture molar flow rate";
  Real Pin(min = 0, start = 101325) "Inlet pressure"; 
  Real Tin(min = 0, start = 273.15) "Inlet Temperature";
  Real Hin "inlet mixture molar enthalpy";
  Real Sin "inlet mixture molar entropy";
  Real xvapin(min = 0, max = 1, start = 0.5) "Inlet vapor mol fraction";   
  
  Real Fout(min = 0, start = 100) "outlet mixture molar flow rate";
  Real Q "required Power";
  Real Pdel "Pressure Increase"; 
  Real Tdel "Temperature increase"; 

  Real Pout(min = 0, start = 101325) "Outlet pressure";
  Real Tout(min = 0, start = 273.15) "Outlet Temperature";
  Real Hout "outlet mixture molar enthalpy";
  Real Sout "outlet mixture molar entropy";
  Real xvapout(min = 0, max = 1, start = 0.5) "Outlet Vapor Mole fraction";
  Real x_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "mixture mole fraction";
 
  parameter Real Eff "Efficiency";

  //========================================================================================
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
equation
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = x_c[:];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = x_c[:];
  Out.xvap = xvapout;
  En.Q = Q;
//=============================================================================================
  Fin = Fout;
//material balance
  Hout = Hin + (H_p[1] - Hin) / Eff;
  Q = Fin * (H_p[1] - Hin) / Eff;
//energy balance
  Pin + Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
//=========================================================================
//ideal flash
  Fin = F_p[1];
  Pout = P;
  Sin = S_p[1];
  x_c[:] = x_pc[1, :];
end AdiabaticCompressor;
