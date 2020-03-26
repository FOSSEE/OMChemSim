within Simulator.UnitOperations.DistillationColumn;

  model DistTray "Model of a tray used in distillation column"
    import Simulator.Files.*;
    parameter ChemsepDatabase.GeneralProperties C[Nc];
    parameter Integer Nc = 2 "Number of components";
    parameter Boolean Bin = true;
    Real P(unit = "Pa", min = 0, start = Pg) "Pressure";
    Real T(unit = "K", min = 0, start = Tg) "Temperature";
    Real Fin(unit = "mol/s", min = 0, start = Fg) "Feed molar flow";
    Real xin_c[Nc](each unit = "-", each min = 0, each max = 1,start=xg) "Feed components mole fraction"; 
    Real Hin(unit = "kJ/kmol",start=Htotg) "Feed molar enthalpy"; 
    
    Real Fout(unit = "mol/s", min = 0, start = Fg) "Sidedraw molar flow";
    Real Fvap_s[2](each unit = "mol/s", each min = 0,start={Fg,Fg}) "Vapor molar flow";
    Real Fliq_s[2](each unit = "mol/s", each min = 0,start={Fg,Fg}) "Liquid molar flow";  
    Real xout_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Components mole fraction at sidedraw";
    Real xvap_sc[2, Nc](each unit = "-", each min = 0, each max = 1, start={yg,yg}) "Components vapor mole fraction";
    Real xliq_sc[2, Nc](each unit = "-", each min = 0, each max = 1, start={xg,xg}) "Components liquid mole fraction";
 
    Real Hvap_s[2](unit = "kJ/kmol",start=Hvapg) "Vapor molar enthalpy";
    Real Hliq_s[2](unit = "kJ/kmol",start=Hliqg) "Liquid molar enthalpy";
    Real Q(unit = "W") "Heat load";
    Real Hout(unit = "kJ/kmol",start=Htotg) "Side draw molar enthalpy";
    Real Hvapout_c[Nc](unit = "kJ/kmol",start=Hvapg) "Outlet components vapor molar enthalpy";
    Real Hliqout_c[Nc](unit = "kJ/kmol",start=Hliqg) "Outlet components liquid molar enthalpy";
    Real x_pc[3, Nc](each min =0, each max = 0,start={xguess,xguess,xguess});
    
    Real Pdew(unit = "Pa", min = 0, start = Pmax) "Dew pressure";
    Real Pbubl(unit = "Pa", min = 0, start = Pmin) "Bubble pressure";
    Real Pdmy1, Tdmy1, xdmy1_pc[3,Nc], Fdmy1,Hdmy1, Sdmy1, xvapdmy1;
  //this is adjustment done since OpenModelica 1.11 is not handling array modification properly
    String OutType(start = "Null");
    //L or V
    replaceable Simulator.Files.Interfaces.matConn In(Nc = Nc) if Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    replaceable Simulator.Files.Interfaces.matConn In_Dmy(Nc = Nc, P = 0, T = 0, F = 0, x_pc = zeros(3, Nc), H = 0, S = 0, xvap = 0) if not Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn In_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn Out_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn Out_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn In_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.enConn En annotation(
      Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  extends GuessModels.InitialGuess;
  
  equation
//connector equation
    if Bin then
      In.P = Pdmy1;
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
      In.T = Tdmy1;
      In.x_pc = xdmy1_pc;
      In.F = Fdmy1;
      In.H = Hdmy1;
      In.S = Sdmy1;
      In.xvap = xvapdmy1;
    else
      In_Dmy.P = Pdmy1;
      In_Dmy.T = Tdmy1;
      In_Dmy.x_pc = xdmy1_pc;
      In_Dmy.F = Fdmy1;
      In_Dmy.H = Hdmy1;
      In_Dmy.S = Sdmy1;
      In_Dmy.xvap = xvapdmy1;
    end if;
//this is adjustment done since OpenModelica 1.11 is not handling array modification properly
    xdmy1_pc[1, :] = xin_c[:];
    Hdmy1 = Hin;
    Fdmy1 = Fin;
    
    Out.P = P;
    Out.T = T;
    Out.F = Fout;
    Out.H = Hout;
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
    En.Q = Q;
//Adjustment for thermodynamic packages
    x_pc[1, :] = (Fout .* xout_c[:] + Fvap_s[2] .* xvap_sc[2, :] + Fliq_s[2] .* xliq_sc[2, :]) / (Fliq_s[2] + Fvap_s[2] + Fout);
   x_pc[2, :] = xliq_sc[2,:];
   x_pc[3, :] = xvap_sc[2,:];
//Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* Pvap_c[:] ./ philiqbubl_c[:]);
//Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* Pvap_c[:]) .* phivapdew_c[:]);
//molar balance
//Fin + Fvap_s[1] + Fliq_s[1] = Fout + Fvap_s[2] + Fliq_s[2];
    Fin .* xin_c[:] + Fvap_s[1] .* xvap_sc[1, :] + Fliq_s[1] .* xliq_sc[1, :] = Fout .* xout_c[:] + Fvap_s[2] .* xvap_sc[2, :] + Fliq_s[2] .* xliq_sc[2, :];
//equillibrium
    xvap_sc[2, :] = K_c[:] .* xliq_sc[2, :];
//raschford rice
//    xliq_sc[2,:] = ((Fin .* xin_c[:] + Fvap_s[1] .* xvap_sc[1, :] + Fliq_s[1] .* xliq_sc[1, :])./(Fin + Fvap_s[1] + Fliq_s[1])) ./(1 .+ (Fvap_s[2]/ (Fvap_s[2] + Fliq_s[2])) * (K[:] .- 1));
//  for i in 1:Nc loop
//    xvap_sc[2,i] = ((K[i]/(K[1])) * xliq_sc[2,i]) / (1 + (K[i] / (K[1])) * xliq_sc[2,i]);
//  end for;
//summation equation
    sum(xliq_sc[2, :]) = 1;
    sum(xvap_sc[2, :]) = 1;
// Enthalpy balance
    Fin * Hin + Fvap_s[1] * Hvap_s[1] + Fliq_s[1] * Hliq_s[1] = Fout * Hout + Fvap_s[2] * Hvap_s[2] + Fliq_s[2] * Hliq_s[2] + Q;
//enthalpy calculation
    for i in 1:Nc loop
      Hliqout_c[i] = ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
      Hvapout_c[i] = ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    end for;
    Hliq_s[2] = sum(xliq_sc[2, :] .* Hliqout_c[:]) + Hres_p[2];
    Hvap_s[2] = sum(xvap_sc[2, :] .* Hvapout_c[:]) + Hres_p[3];
//sidedraw calculation
    if OutType == "L" then
      xout_c[:] = xliq_sc[2, :];
    elseif OutType == "V" then
      xout_c[:] = xvap_sc[2, :];
    else
      xout_c[:] = zeros(Nc);
    end if;
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      __OpenModelica_commandLineOptions = "");
  end DistTray;
