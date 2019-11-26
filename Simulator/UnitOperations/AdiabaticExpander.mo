within Simulator.UnitOperations;

model AdiabaticExpander "Model of an adiabatic expander to extract energy from a vapor stream in form of pressure"
  //=====================================================================================
  //Header Files and Parameters
  extends Simulator.Files.Icons.AdiabaticExpander;
  extends Simulator.Files.Models.Flash;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
  parameter Integer Nc "Number of components";
  parameter Real Eff(unit = "-") "Expander efficiency";
  //====================================================================================
  //Model Variables
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy";
  Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mole fraction";
  Real xin_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Component mole fraction";
  Real Sin(unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Q(unit = "W") "Generated Power";
  Real Pdel(unit = "Pa") "Pressure drop";
  Real Tdel(unit = "K") "Temperature change";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Fout(unit = "mol/s", min = 0, start = Fg) "Outlet stream molar flow rate";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Hout(unit = "kJ/kmol") "Outlet stream molar enthalpy";
  Real Sout(unit = "kJ/[kmol.k]") "Outlet stream molar entropy";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";
  //========================================================================================
  //Instantiation of connectors
  Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  extends GuessModels.InitialGuess;
  
equation
//========================================================================================
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = xin_c[:];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = xin_c[:];
  Out.xvap = xvapout;
  En.Q = Q;
//=============================================================================================
//Material and Energy balance
  Fin = Fout;
  Hout = Hin + (H_p[1] - Hin) * Eff;
  Q = Fin * (H_p[1] - Hin) * Eff;
//=============================================================================================
//Pressure and Temperature calculation
  Pin - Pdel = Pout;
  Tin - Tdel = Tout;
//=========================================================================
//Ideal flash
  Fin = F_p[1];
  Pout = P;
  Sin = S_p[1];
  xin_c[:] = x_pc[1, :];
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Adiabatic Expander is generally used to extract energy from a vapor material stream. The energy extracted is in form of pressure.</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">To simulate an adiabatic expander, Efficiency of the expander should be provided as calculation parameter. Additionally, one of the following variables must be defined:</span><div style=\"font-size: 12px;\"><ol><li>Outlet Pressure</li><li>Pressure Drop</li><li>Power Required</li></ol><div><br></div></div><div style=\"font-size: 12px;\">For example on simulating an adiabatic expander, go to&nbsp;<i><b>Examples</b></i>&nbsp;&gt;&gt;&nbsp;<b><i>Expander</i></b></div></body></html>"));
end AdiabaticExpander;
