within Simulator.UnitOperations;

model CSTR
  //===============================================================================
  //Header Files and Parameters
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
  import Simulator.Files.*;
  import Simulator.Files.ThermodynamicFunctions.*;
  extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  extends Simulator.Files.Icons.CSTR;
  parameter String Mode "Required mode of operation: Isothermal, Define_Out_Temperature, Adiabatic" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Integer Nc "Number of Components" annotation(
    Dialog(tab = "Reactor Specifications", group = "Component Parameters"));
  //parameter Integer Nr "Number of Reactions";
  // parameter Integer BC_r[Nr] "Base component";
  parameter Real Pdel(unit = "Pa") "Pressure Drop" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real Tdef(unit = "K") "Define outlet Temperature , applicable if Define_Out_Temperature mode is chosen" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  //parameter Real Coef_cr[Nc, Nr] "Stochiometry";
  parameter Real Phase "Reaction Phase: 1-Mixture, 2-Liquid, 3-Vapour" annotation(Dialog(tab = "Reactions", group = "Kinetic Reaction Parameters"));
  parameter Real VHspace(unit = "m^3") = 0 "Reactor Headspace" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  parameter Real V(unit = "m^3") "Reactor Volume" annotation(
    Dialog(tab = "Reactor Specifications", group = "Calculation Parameters"));
  //===============================================================================
  //Model Variables
  Real Pin(unit = "Pa") "Inlet Pressure";
  Real Tin(unit = "K") "Inlet Temperature";
  Real Pout(unit = "Pa") "Outlet Pressure";
  Real Tout(unit = "K") "Outlet Temperature";
  Real Hin(unit = "kJ/kmol") "Mixture Mol Enthalpy in the inlet";
  Real Hout(unit = "kJ/kmol") "Mixture Mol Enthalpy in the outlet";
  Real Fin(unit = "mol/s") "Inlet total mole flow";
  Real Fout_p[3](each unit = "mol/s") "Outlet total mole flow";
  Real Fout_pc[3, Nc](each unit = "mol/s") "Component mole flow at outlet";
  Real xin_pc[1, Nc](each unit = "-") "Component mole fraction at inlet";
  Real xout_pc[3, Nc](each unit = "-") "Component mol-frac at outlet";
  Real Q(unit = "W") "Energy supplied/removed";
  Real Hr(unit = "kJ/kmol") "Heat of Reaction";
  Real VFrac;
  Real C_c[Nc](each unit = "mol/m^3") "Concentration of Component";
  Real rholiq_c[Nc](each unit = "mol/m^3");
  Real rholiq(unit = "mol/m^3");
  Real Fvout_p[3](each unit = "m^3/s") "Mixture Volumetric Flow rate";
  Real FO_cr[Nc, Nr](each unit = "mol/s") "Inlet Flow";
  Real F_cr[Nc, Nr](each unit = "mol/s") "Outlet Flow";
  Real X(unit = "-") "Conversion of Base componet";
  Real k_r[Nr] "Rate constant";
  Real r_r[Nr](each unit = "mol/m^3.S") "Rate of Reaction";
  Real VRxn(unit = "m^3") "Volume of Reaction Mixture";
  Real Pbubl(unit = "Pa") "Bubble Point Pressure";
  Real Pdew(unit = "Pa") "Dew Point Pressure";
  Real xvap(unit = "-") "Vapor Phase Mole Fraction";
  Real T(unit = "K");
  Real P(unit = "Pa");
  //===============================================================================
  //Instatiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends Simulator.Files.Models.ReactionManager.KineticReaction(Nr = 1, BC_r = {1}, Coef_cr = {{-1}, {-1}, {1}}, DO_cr = {{1}, {0}, {0}}, Af_r = {0.5}, Ef_r = {0});


equation
//===============================================================================
//Connector-Equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.x_pc[1, :] = xin_pc[1, :];
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout_p[1];
  Out.H = Hout;
  Out.x_pc[1, :] = xout_pc[1, :];
  En.Q = Q;
//===============================================================================
//Flash of Outlet Stream
  T = Tout;
  P = Pout;
    Pbubl = sum(gmabubl_c[:] .* xout_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
  Pdew = 1 / sum(xout_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
//===============================================================================
//Below bubble point region
  if Pout >= Pbubl then
    xout_pc[3, :] = zeros(Nc);
    Fout_p[3] = 0;
    xout_pc[2, :] = xout_pc[1, :];
//===============================================================================
//Above dew point region
  elseif Pout <= Pdew then
    xout_pc[2, :] = zeros(Nc);
    Fout_p[2] = 0;
    xout_pc[3, :] = xout_pc[1, :];
  else
//===============================================================================
//VLE region
    if Phase == 1 or Phase == 3 then
      for i in 1:Nc loop
        xout_pc[3, i] = K_c[i] * xout_pc[2, i];
        xout_pc[2, i] = xout_pc[1, i] ./ (1 + xvap * (K_c[i] - 1));
      end for;
    elseif Phase == 2 then
      for i in 1:Nc loop
        xout_pc[2, i] = xout_pc[1, i] ./ (1 + xvap * (K_c[i] - 1));
        xout_pc[1, i] * Fout_p[1] = xout_pc[2, i] * Fout_p[2] + xout_pc[3, i] * Fout_p[3];
      end for;
    end if;
    sum(xout_pc[2, :]) - sum(xout_pc[3, :]) = 0;
  end if;
//===============================================================================
//Mole Balance
  FO_cr[:, 1] = xin_pc[1, :] * Fin;
  for i in 1:Nc loop
    F_cr[i, 1] = FO_cr[i, 1] + Coef_cr[i, 1] * r_r[1] * VRxn / abs(Coef_cr[BC_r[Nr],1]);
  end for;
  VRxn = (FO_cr[BC_r[1], 1] * X) / r_r[1] ;
  sum(F_cr[:, 1]) = Fout_p[1];
  for i in 1:Nc loop
    xout_pc[1, i] = F_cr[i, Nr] / Fout_p[1];
    Fout_pc[:, i] = Fout_p[:] .* xout_pc[:, i];
  end for;
  Fout_p[1] = Fout_p[2] + Fout_p[3];
  xvap = Fout_p[3] / Fout_p[1];
  k_r[:] = Simulator.Files.Models.ReactionManager.Arhenious(Nr, Af_r[:], Ef_r[:], Tout);
//===============================================================================
//Calculation of Mixer Density and Volumetric Flowrate
  for i in 1:Nc loop
    rholiq_c[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tout, Pout);
  end for;
rholiq = 1 / sum(xout_pc[2, :] ./ rholiq_c[:]);
Fvout_p[1] = Fvout_p[2] + Fvout_p[3];
Fvout_p[2] = Fout_p[2] / rholiq;
Fvout_p[3] = (Fout_p[3] * 8.314 * Tout) / Pout;
//===============================================================================
//Volume of Reaction
  if Phase == 1 then
    VRxn = V;
    VFrac = 0;
    C_c[:] = Fout_pc[1, :] ./ Fvout_p[1];
  elseif Phase == 2 then
    VRxn = V * VFrac;
    VFrac = Fvout_p[2] / Fvout_p[1];
    C_c[:] = Fout_pc[2, :] ./ Fvout_p[2];
  elseif Phase == 3 then
    VRxn = V * VFrac;
    VFrac = Fvout_p[3] / Fvout_p[1];
    C_c[:] = P .* xout_pc[3, :] / (8.314 * T);
  end if;
//===============================================================================
//Rate Equation
  for i in 1:Nr loop
    r_r[i] = k_r[i] * product(C_c[:] .^ DO_cr[:, i]);
  end for;
  Pout = Pin - Pdel;
//===============================================================================
//Energy Balance
//===============================================================================
//Isothermal Operation
  if Mode == "Isothermal" then
    Hr = Hr_r[1] * FO_cr[BC_r[Nr], Nr] .* X;
    Fin * Hin - Fout_p[1] * Hout + Q - Hr = 0;
    Tin = Tout;
//===============================================================================
//Outlet Temperature Defined
  elseif Mode == "Define_Out_Temperature" then
    Tout = Tdef;
    Hr = Hr_r[1] * FO_cr[BC_r[Nr], Nr] .* X;
    Fin * Hin - Fout_p[1] * Hout + Q - Hr = 0;
//===============================================================================
//Adiabatic Operation
  elseif Mode == "Adiabatic" then
    Q = 0;
    Hr = Hr_r[1] * FO_cr[BC_r[Nr], Nr] .* X;
    Fin * Hin + Q = Fout_p[1] * Hout + Hr;
  end if;
//===============================================================================
  annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">The <b>Continuous Stirred Tank&nbsp;Reactor (CSTR)</b>&nbsp;is used to calculate the mole fraction of components at outlet stream when the reaction kinetics and reactor volume is defined.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2;\">The CSTR model have following connection ports:</span></div><div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Two Material Streams:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">feed stream</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">outlet stream</span></li></ul><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">One Energy Stream:</span></font></li><ul><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">heat added</span></li></ul></ol></div></div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\">To simulate a CSTR, following calculation parameters must be provided:</span><div><ol style=\"font-size: 12px;\"><li>Calculation Mode (<b>Mode</b>)</li><li>Reaction Phase (<b>Phase</b>)</li><li>Outlet Temperature&nbsp;(<b>Tdef</b>)&nbsp;(If calculation mode is Define_Out_Temperature)</li><li>Number of Reactions (<b>Nr</b>)</li><li>Base Component (<b>Base_C</b>)</li><li>Stoichiometric Coefficient of Components in Reaction (<b>Coef_cr</b>)</li><li>Reaction Order (<b>DO_cr</b>)</li><li>Pre-exponential Factor (<b>Af_r</b>)</li><li>Activation Energy (<b>Ef_r</b>)</li><li>Pressure Drop (<b>Pdel</b>)</li><li>Reactor Volume (<b>V</b>)</li><li>Reactor Headspace (<b>VHspace</b>)</li></ol><div><div style=\"font-size: 12px; orphans: 2; widows: 2;\"><span style=\"orphans: auto; widows: auto;\">Among the above variables, only the first variable is of type&nbsp;<i>parameter String</i>. Calculation Mode (<b>Mode</b>) can have either of the sting values among the following:</span></div><div style=\"orphans: 2; widows: 2;\"><ol style=\"font-size: 12px;\"><li><b>Isothermal</b>: If the reactor is operated isothermally</li><li><b>Define_Out_Temperature</b>: If the reactor is operated at specified outlet temperature</li><li><b>Adiabatic</b>: If the reactor is operated adiabatically</li></ol><div style=\"font-size: 12px;\"><br></div></div></div><div style=\"font-size: 12px;\">The other variables are of type&nbsp;<i>parameter Real.</i></div></div><div style=\"font-size: 12px;\"><div>During simulation, their values can specified directly under&nbsp;<b>Reactor Specifications and Reactions&nbsp;</b>by double clicking on the CSTR model instance.</div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">For detailed explaination on how to use this model to simulate a Continuous Stirred Tank Reactor, go to&nbsp;<a href=\"modelica://Simulator.Examples.CSTR\">CSTR Example</a>.</div><div><br></div></body></html>"));
    end CSTR;
