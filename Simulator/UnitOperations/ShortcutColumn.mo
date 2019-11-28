within Simulator.UnitOperations;

model ShortcutColumn "Model of a shortcut column to calculate minimum reflux in a distillation column"

//==============================================================================
  //Header Files and Parameters
  extends Simulator.Files.Icons.DistillationColumn;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.GeneralProperties C[Nc];
  parameter Integer Nc "Number of components";
  parameter Integer HKey "Heavy Key component";
  parameter Integer LKey "Light Key component";
  parameter String Ctype = "Total" "Condenser type: Total or Partial";
  //==============================================================================
  //Model Variables
  Real F_p[3](each unit = "mol/s", each min = 0, each start = Fg) "Inlet stream molar flow";
  Real x_pc[3, Nc](each unit = "-",  start = {xguess,xg,yg}, each min = 0, each max = 1) "Inlet stream mole fraction";
  Real H_p[3](each unit = "kJ/kmol",start={Htotg,Hliqg,Hvapg}) "Inlet stream molar enthalpy ";
  Real S_p[3](each unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg)"Inlet stream temperature";
  Real xin_pc[3, Nc](each unit = "-", each min = 0, each max = 1, start={xguess,xg,yg}) "Inlet stream components mole fraction";
  
  Real Ntmin(unit = "-", min = 0, start = 10) "Minimum Number of trays";
  Real RRmin(unit = "-", start = 1) "Minimum Reflux Ratio";
  Real alpha_c[Nc](unit = "-") "Relative Volatility";
  Real theta(unit = "-", start = 1) "Fraction";
  Real T(start=Tg) "Thermodynamic Adjustment", P(start=Pg) "Thermodynamic Adjustment";
  Real Tcond(unit = "K", start = max(C[:].Tb), min = 0)"Condenser temperature";
  Real Pcond(unit = "Pa", min = 0, start = 101325) "Condenser pressure";
  Real Preb(unit = "Pa", min = 0, start = 101325)"Reboiler pressure";
  Real Treb(unit = "K", start = min(C[:].Tb), min = 0) "Reboiler temperature";
  Real xvap_p[3](each unit = "-", each min = 0, each max = 1, each start = xvapg) "Vapor Phase Mole Fraction";
  Real Hliqcond(unit = "kJ/kmol",start=Hliqg) "Enthalpy of liquid in condenser";
  Real Hvapcond(unit = "kJ/kmol",start=Hvapg) "Enthalpy of vapor in condenser";
  Real Hvapcond_c[Nc](each unit = "kJ/kmol") "Component enthalpy of vapor in condenser";
  Real Hliqcond_c[Nc](each unit = "kJ/kmol") "Component enthalpy of vapor in condenser";
  Real xliqcond_c[Nc](each unit = "-", each min = 0, each max = 1,  start = xg)"Component mole fraction in liquid phase in condenser";
  Real xvapcond_c[Nc](each unit = "-", each min = 0, each max = 1,  start = yg)"Component mole fraction in vapor phase in condenser";
  
  Real Pdew(unit = "Pa", min = 0, start = Pmax)"Dew point pressure";
  Real Pbubl(unit = "Pa", min = 0, start = Pmin)"Bubble point pressure";
  Real RR "Actual Reflux Ratio";
  Real Nt "Actual Number of Trays";
  Real x "Intermediate variable";
  Real y "Intermediate variable";
  Real Intray "Feed Tray";
  Real Fliqrec(unit = "mol/s", min = 0, start = Fg) "Liquid molar flow in rectification section";
  Real Fvaprec(unit = "mol/s", min = 0, start = Fg)"Vapor molar flow in rectification section";
  Real Fliqstrip(unit = "mol/s", min = 0, start = Fg) "Liquid molar flow in stripping section";
  Real Fvapstrip(unit = "mol/s", min = 0, start = Fg)"Vapor molar flow in stripping section";
  Real Qr(unit = "W") "Reboiler Duty";
  Real Qc(unit = "W") "Condenser Duty";

//==============================================================================
  //Instantiation of Connections
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out1(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {250, 336}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out2(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {250, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En1 annotation(
    Placement(visible = true, transformation(origin = {248, 594}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, 600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En2 annotation(
    Placement(visible = true, transformation(origin = {254, -592}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {250, -600}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  extends GuessModels.InitialGuess;
equation
//==============================================================================
// Connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = F_p[1];
  In.x_pc[1, :] = x_pc[1, :];
  In.H = H_p[1];
  In.S = S_p[1];
  In.xvap = xvap_p[1];
  Out2.P = Preb;
  Out2.T = Treb;
  Out2.F = F_p[2];
  Out2.x_pc[1, :] = x_pc[2, :];
  Out2.H = H_p[2];
  Out2.S = S_p[2];
  Out2.xvap = xvap_p[2];
  Out1.P = Pcond;
  Out1.T = Tcond;
  Out1.F = F_p[3];
  Out1.x_pc[1, :] = x_pc[3, :];
  Out1.H = H_p[3];
  Out1.S = S_p[3];
  Out1.xvap = xvap_p[3];
  En2.Q = Qr;
  En1.Q = Qc;
//==============================================================================
//Adjustment for thermodynamic packages
  xin_pc[1, :] = x_pc[1, :];
  xin_pc[2, :] = xin_pc[1, :] ./ (1 .+ xvap_p[1] .* (K_c[:] .- 1));
  for i in 1:Nc loop
    xin_pc[3, i] = K_c[i] * xin_pc[2, i];
  end for;
  T = Tin;
  P = Pin;
//==============================================================================
//Bubble point calculation
  Pbubl = sum(gmabubl_c[:] .* xin_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / Tin + C[:].VP[4] * log(Tin) + C[:].VP[5] .* Tin .^ C[:].VP[6]) ./ philiqbubl_c[:]);
//==============================================================================
//Dew point calculation
  Pdew = 1 / sum(xin_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / Tin + C[:].VP[4] * log(Tin) + C[:].VP[5] .* Tin .^ C[:].VP[6])) .* phivapdew_c[:]);
  for i in 1:Nc loop
    if x_pc[1, i] == 0 then
      x_pc[3, i] = 0;
    else
      F_p[1] .* x_pc[1, i] = F_p[2] .* x_pc[2, i] + F_p[3] .* x_pc[3, i];
    end if;
  end for;
  sum(x_pc[3, :]) = 1;
  sum(x_pc[2, :]) = 1;
//==============================================================================
//Distillate and Bottom composition
  for i in 1:Nc loop
    if i <> HKey then
      if Ctype == "Total" then
        x_pc[3, i] / x_pc[3, HKey] = alpha_c[i] ^ Ntmin * (x_pc[2, i] / x_pc[2, HKey]);
      elseif Ctype == "Partial" then
        x_pc[3, i] / x_pc[3, HKey] = alpha_c[i] ^ (Ntmin + 1) * (x_pc[2, i] / x_pc[2, HKey]);
      end if;
    end if;
  end for;
//==============================================================================
//Relative Volatility
  alpha_c[:] = K_c[:] / K_c[HKey];
//==============================================================================
//Calculation of temperature at Distillate and Bottoms
  if Tcond <= 0 and Treb <= 0 then
    if Ctype == "Partial" then
      1 / Pcond = sum(x_pc[3, :] ./ (gma_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Tcond .^ C[:].VP[6])));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    elseif Ctype == "Total" then
      Pcond = sum(gma_c[:] .* x_pc[3, :] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Tcond .^ C[:].VP[6]));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    end if;
//==============================================================================
  elseif Tcond <= 0 then
    if Ctype == "Partial" then
      1 / Pcond = sum(x_pc[3, :] ./ (gma_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Tcond .^ C[:].VP[6])));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / Treb + C[:].VP[4] * log(Treb) + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    elseif Ctype == "Total" then
      Pcond = sum(gma_c[:] .* x_pc[3, :] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Tcond .^ C[:].VP[6]));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / Treb + C[:].VP[4] * log(Treb) + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    end if;
//==============================================================================
  elseif Treb <= 0 then
    if Ctype == "Partial" then
      1 / Pcond = sum(x_pc[3, :] ./ (gma_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / Tcond + C[:].VP[4] * log(Tcond) + C[:].VP[5] .* Tcond .^ C[:].VP[6])));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    elseif Ctype == "Total" then
      Pcond = sum(gma_c[:] .* x_pc[3, :] .* exp(C[:].VP[2] + C[:].VP[3] / Tcond + C[:].VP[4] * log(Tcond) + C[:].VP[5] .* Tcond .^ C[:].VP[6]));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / 1 + C[:].VP[4] * 1 + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    end if;
//==============================================================================
  else
    if Ctype == "Partial" then
      1 / Pcond = sum(x_pc[3, :] ./ (gma_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / Tcond + C[:].VP[4] * log(Tcond) + C[:].VP[5] .* Tcond .^ C[:].VP[6])));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / Treb + C[:].VP[4] * log(Treb) + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    elseif Ctype == "Total" then
      Pcond = sum(gma_c[:] .* x_pc[3, :] .* exp(C[:].VP[2] + C[:].VP[3] / Tcond + C[:].VP[4] * log(Tcond) + C[:].VP[5] .* Tcond .^ C[:].VP[6]));
      Preb = sum(gma_c[:] .* x_pc[2, :] .* exp(C[:].VP[2] + C[:].VP[3] / Treb + C[:].VP[4] * log(Treb) + C[:].VP[5] .* Treb .^ C[:].VP[6]));
    end if;
  end if;
//==============================================================================
//Minimum Reflux, Underwoods method
  if theta > alpha_c[LKey] or theta < alpha_c[HKey] then
    0 = sum(alpha_c[:] .* x_pc[1, :] ./ (alpha_c[:] .- theta));
  else
    xvap_p[1] = sum(alpha_c[:] .* x_pc[1, :] ./ (alpha_c[:] .- theta));
  end if;
  RRmin + 1 = sum(alpha_c[:] .* x_pc[3, :] ./ (alpha_c[:] .- theta));
//==============================================================================
//Actual number of trays,Gillilands method
  x = (RR - RRmin) / (RR + 1);
  y = (Nt - Ntmin) / (Nt + 1);
  if x >= 0 then
    y = 0.75 * (1 - x ^ 0.5668);
  else
    y = -1;
  end if;
//==============================================================================
// Feed location, Fenske equation
  Intray = Nt / Ntmin * log(x_pc[1, LKey] / x_pc[1, HKey] * (x_pc[2, HKey] / x_pc[2, LKey])) / log(K_c[LKey] / K_c[HKey]);
//==============================================================================
//Rectifying and Stripping flows Calculation
  Fliqrec = RR * F_p[3];
  Fliqstrip = (1 - xvap_p[1]) * F_p[1] + Fliqrec;
  Fvapstrip = Fliqstrip - F_p[2];
  Fvaprec = xvap_p[1] * F_p[1] + Fvapstrip;
  for i in 1:Nc loop
    Hvapcond_c[i] = Simulator.Files.ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Tcond);
    Hliqcond_c[i] = Simulator.Files.ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, Tcond);
  end for;
  if Ctype == "Total" then
    Hliqcond = H_p[3];
  elseif Ctype == "Partial" then
    Hliqcond = sum(xliqcond_c[:] .* Hliqcond_c[:]);
  end if;
  Hvapcond = sum(xvapcond_c[:] .* Hvapcond_c[:]);
  Fvaprec .* xvapcond_c[:] = Fliqrec .* xliqcond_c[:] + F_p[3] .* x_pc[3, :];
  if Ctype == "Partial" then
    x_pc[3, :] = K[:] .* xliqcond_c[:];
  elseif Ctype == "Total" then
    x_pc[3, :] = xliqcond_c[:];
  end if;
//==============================================================================
//Energy Balance
  F_p[1] * H_p[1] + Qr - Qc = F_p[2] * H_p[2] + F_p[3] * H_p[3];
  Fvaprec * Hvapcond = Qc + F_p[3] * H_p[3] + Fliqrec * Hliqcond;
annotation(
    Icon(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
    Diagram(coordinateSystem(extent = {{-250, -600}, {250, 600}})),
    __OpenModelica_commandLineOptions = "",
  Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The shortcut column is used to calculate the minimum reflux in a distillation column by Fenske-Underwood-Gilliland (FUG) method.&nbsp;</span><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\"><br></span></div><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">The column should have following inputs:</span></div><div><ol><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">a single feed stage</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">two products (top and bottom)</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">condenser (total or partial)</span></li><li><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13.3333px; orphans: 2; widows: 2;\">reboiler</span></li></ol><div style=\"orphans: 2; widows: 2;\"><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">The results are:</span></font></div><div><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Minumum Reflux Ratio</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Actual Reflux Ratio</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Total Number of Stages</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Feed Stage</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Condenser and Reboiler Duty</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Liquid and Vapor flows in Rectification and Stripping section</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Pressure and Temperature of Condenser and Reboiler</span></font></li></ol><div><br></div></div></div><div style=\"orphans: 2; widows: 2;\"><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">To simulate a shortcut column, following calculation parameters must be provided:</span></font></div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Condenser Type</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">High Key Component</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Low Key Component</span></font></li></ol></div><div style=\"orphans: 2; widows: 2;\"><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 13px;\">Additionally, following input for following variables must be provided:</span></div><div style=\"orphans: 2; widows: 2;\"><ol><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Reflux Ratio</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Heavy Key Component Mole Fraction in Distillate</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Light Key Component Mole Fraction in Bottoms</span></font></li><li><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">Condenser and Reboiler Pressure</span></font></li></ol></div><div style=\"orphans: 2; widows: 2;\"><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\"><br></span></font></div><div><font face=\"Arial, Helvetica, sans-serif\"><span style=\"font-size: 13px;\">For example on simulating a Shortcut Column, go to <i><b>Examples</b></i> &gt;&gt; <i><b>ShortcutColumn</b></i></span></font></div></div><!--EndFragment--></div></body></html>"));
  end ShortcutColumn;
