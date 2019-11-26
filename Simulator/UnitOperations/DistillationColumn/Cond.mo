within Simulator.UnitOperations.DistillationColumn;

  model Cond "Model of a condenser used in distillation column"
    import Simulator.Files.*;
    parameter ChemsepDatabase.GeneralProperties C[Nc];
    parameter Integer Nc = 2 "Number of components";
    parameter Boolean Bin = false;
    Real P(unit = "K", min = 0, start = Pg) "Pressure";
    Real T(unit = "Pa", min = 0, start = Tg) "Temperature";
    Real Fin(unit = "mol/s", min = 0, start =Fg) "Feed molar flow rate";
    Real xin_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Feed components mole fraction"; 
    Real xvapin_c[Nc](each unit = "-", each min = 0, each max = 1, start=xvapg) "Inlet components vapor molar fraction"; 
    Real Hin(unit = "kJ/kmol",start=Htotg) "Feed inlet molar enthalpy";
   
    Real Fout(unit = "mol/s", min = 0, start = Fg) "Side draw molar flow";
    Real Fvapin(unit = "mol/s", min = 0, start = Fg) "Inlet vapor molar flow";
    Real Fliqout(unit = "mol/s", min = 0, start = Fg) "Outlet liquid molar flow";
    Real xout_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Side draw components mole fraction";
    Real xliqout_c[Nc](each unit = "-", each min = 0, each max = 1, start=xliqg) "Outlet components liquid mole fraction";
    
    Real Hvapin(unit = "kJ/kmol",start=Hvapg) "Inlet vapor molar enthalpy";
    Real Hliqout(unit = "kJ/kmol",start=Hliqg) "Outlet liquid molar enthalpy";
    Real Q(unit = "W") "Heat load";
    Real Hout(unit = "kJ/kmol",start=Htotg) "Side draw molar enthalpy";
    Real Hliqout_c[Nc](each unit = "kJ/kmol") "Outlet liquid components molar enthalpy";
    Real x_pc[3, Nc](each unit = "-", each min = 0, each max = 1,start={xguess,xguess,xguess}) "Component mole fraction";
    Real Pdew(unit = "Pa", min = 0, start = Pmax) "Dew point pressure";
    Real Pbubl(unit = "Pa", min = 0,start=Pmin) "Bubble point pressure";
    
    //String sideDrawType(start = "Null");
    //L or V
    parameter String Ctype "Condenser type: Partial or Total";
    replaceable Simulator.Files.Interfaces.matConn In(Nc = Nc) if Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn In_Dmy(Nc = Nc, P = 0, T = 0, x_pc = zeros(3, Nc), F = 0, H = 0, S = 0, xvap = 0) if not Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn Out_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn In_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.enConn En annotation(
      Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
    extends GuessModels.InitialGuess;
    
  equation
//connector equation
    if Bin then
      In.x_pc[1, :] = xin_c[:];
      In.H = Hin;
      In.F = Fin;
    else
      In_Dmy.x_pc[1, :] = xin_c[:];
      In_Dmy.H = Hin;
      In_Dmy.F = Fin;
    end if;
    
    Out.P = P;
    Out.T = T;
    Out.x_pc[1, :] = xout_c[:];
    Out.F = Fout;
    Out.H = Hout;
    Out_Liq.F = Fliqout;
    Out_Liq.H = Hliqout;
    Out_Liq.x_c[:] = xliqout_c[:];
    In_Vap.F = Fvapin;
    In_Vap.H = Hvapin;
    In_Vap.x_c[:] = xvapin_c[:];
    En.Q = Q;
//Adjustment for thermodynamic packages
    x_pc[1, :] = (Fout .* xout_c[:] + Fliqout .* xliqout_c[:]) ./ (Fout + Fliqout);
     x_pc[2, :] = xliqout_c[:];
     x_pc[3, :] = K_c[:] .* x_pc[2, :];
//Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* Pvap_c[:] ./ philiqbubl_c[:]);
//Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* Pvap_c[:]) .* phivapdew_c[:]);
//molar balance
//Fin + Fvapin = Fout + Fliqout;
    Fin .* xin_c[:] + Fvapin .* xvapin_c[:] = Fout .* xout_c[:] + Fliqout .* xliqout_c[:];
//equillibrium
    if Ctype == "Partial" then
      xout_c[:] = K_c[:] .* xliqout_c[:];
    elseif Ctype == "Total" then
      xout_c[:] = xliqout_c[:];
    end if;
//summation equation
//  sum(xliqout_c[:]) = 1;
    sum(xout_c[:]) = 1;
// Enthalpy balance
    Fin * Hin + Fvapin * Hvapin = Fout * Hout + Fliqout * Hliqout + Q;
//Temperature calculation
    if Ctype == "Total" then
      P = sum(xout_c[:] .* Pvap_c[:]);
    elseif Ctype == "Partial" then
      1 / P = sum(xout_c[:] ./ Pvap_c[:]);
    end if;
// outlet liquid molar enthalpy calculation
    for i in 1:Nc loop
      Hliqout_c[i] = Simulator.Files.ThermodynamicFunctions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    end for;
    Hliqout = sum(xliqout_c[:] .* Hliqout_c[:]) + Hres_p[2];
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      __OpenModelica_commandLineOptions = "");
  end Cond;
