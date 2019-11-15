within Simulator.Unit_Operations.Absorption_Column;

model AbsTray
    import Simulator.Files.*;
    parameter Integer Nc;
    parameter Chemsep_Database.General_Properties C[Nc];
    Real P(min = 0, start = 101325), T(min = 0, start = sum(C[:].Tb) / Nc);
    Real Fvap_s[2](each min = 0, each start = 100), Fliq_s[2](each min = 0, each start = 100), xvap_sc[2, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)), xliq_sc[2, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)), Hvap_s[2], Hliq_s[2], Hvapout_c[Nc], Hliqout_c[Nc];
    Real x_pc[3, Nc](each min =0, each max = 0, each start = 1/(Nc + 1)), Pdew(min = 0, start = sum(C[:].Pc)/Nc), Pbubl(min = 0, start = sum(C[:].Pc)/Nc);
  
    Simulator.Files.Connection.trayConn In_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn Out_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn Out_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn In_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//connector equation
    In_Liq.F = Fliq_s[1];
    In_Liq.H = Hliq_s[1];
    In_Liq.x_c[:] = xliq_sc[1, :];
    Out_Liq.F = Fliq_s[2];
    Out_Liq.H = Hliq_s[2];
    Out_Liq.x_c[:] = xliq_sc[2, :];
    In_Vap.F = Fvap_s[1];
    In_Vap.H = Hvap_s[1];
    In_Vap.x_c[:] = xvap_sc[1, :];
    Out_Vap.F = Fvap_s[2];
    Out_Vap.H = Hvap_s[2];
    Out_Vap.x_c[:] = xvap_sc[2, :];
//Adjustment for thermodynamic packages
    x_pc[1, :] = (Fvap_s[2] .* xvap_sc[2, :] + Fliq_s[2] .* xliq_sc[2, :]) / (Fliq_s[2] + Fvap_s[2]);
    x_pc[2, :] = xliq_sc[2,:];
    x_pc[3, :] = xvap_sc[2,:];
//Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
//Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
//molar balance
    Fvap_s[1] .* xvap_sc[1, :] + Fliq_s[1] .* xliq_sc[1, :] = Fvap_s[2] .* xvap_sc[2, :] + Fliq_s[2] .* xliq_sc[2, :];
//equillibrium
    xvap_sc[2, :] = K[:] .* xliq_sc[2, :];
//raschford rice
//  xliq_sc[2, :] = ((Fvap_s[1] .* xvap_sc[1, :] + Fliq_s[1] .* xliq_sc[1, :])/(Fvap_s[1] + Fliq_s[1]))./(1 .+ (Fvap_s[1]/(Fliq_s[1] + Fvap_s[1])) .* (K[:] .- 1));
//  for i in 1:Nc loop
//    xvap_sc[2,i] = ((K[i]/(K[1])) * xliq_sc[2,i]) / (1 + (K[i] / (K[1])) * xliq_sc[2,i]);
//  end for;
//summation equation
    sum(xliq_sc[2, :]) = 1;
    sum(xvap_sc[2, :]) = 1;
// Enthalpy balance
    Fvap_s[1] * Hvap_s[1] + Fliq_s[1] * Hliq_s[1] = Fvap_s[2] * Hvap_s[2] + Fliq_s[2] * Hliq_s[2];
//enthalpy calculation
    for i in 1:Nc loop
      Hliqout_c[i] = Thermodynamic_Functions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
      Hvapout_c[i] = Thermodynamic_Functions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    end for;
    Hliq_s[2] = sum(xliq_sc[2, :] .* Hliqout_c[:]) + Hres_p[2];
    Hvap_s[2] = sum(xvap_sc[2, :] .* Hvapout_c[:]) + Hres_p[3];
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      __OpenModelica_commandLineOptions = "");
  end AbsTray;
