within Simulator.UnitOperations.DistillationColumn;

  model Cond
    import Simulator.Files.*;
    parameter Integer Nc = 2;
    parameter Boolean Bin = false;
    parameter ChemsepDatabase.GeneralProperties C[Nc];
    Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
    Real Fin(min = 0, start = 100), Fout(min = 0, start = 100), Fvapin(min = 0, start = 100), Fliqout(min = 0, start = 100), xin_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xout_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xvapin_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xliqout_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), Hin, Hvapin, Hliqout, Q, Hout, Hliqout_c[Nc];
    Real x_pc[3, Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), Pdew(min = 0, start = sum(C[:].Pc)/Nc), Pbubl(min = 0, start = sum(C[:].Pc)/Nc);
    //String sideDrawType(start = "Null");
    //L or V
    parameter String Ctype "Partial or Total";
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
