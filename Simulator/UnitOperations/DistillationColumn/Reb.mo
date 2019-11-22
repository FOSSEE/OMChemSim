within Simulator.UnitOperations.DistillationColumn;

  model Reb
    import Simulator.Files.*;
    parameter Integer Nc = 2;
    parameter Boolean Bin = false;
    parameter ChemsepDatabase.GeneralProperties C[Nc];
    Real P(min = 0, start = 101325);
    Real T(min = 0, start = 273.15);
    Real Fin(min = 0, start = 100);
    Real Hin;
    Real Hliqin;
    Real xin_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)); 
    Real Fliqin(min = 0, start = 100);
    Real xliqin_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1));
   
    Real Fout(min = 0, start = 100);
    Real Fvapout(min = 0, start = 100);
    Real xout_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1));
    Real xvapout_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1));
    Real Hvapout;
    Real Hvapout_c[Nc];
    Real Q;
    Real Hout;
    Real x_pc[3, Nc](each min = 0, each max = 1, each start = 1/(Nc + 1));
    Real Pdew(min = 0, start = sum(C[:].Pc)/Nc);
    Real Pbubl(min = 0, start = sum(C[:].Pc)/Nc);
   
    replaceable Simulator.Files.Interfaces.matConn In(Nc = Nc) if Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    replaceable Simulator.Files.Interfaces.matConn In_Dmy(Nc = Nc, P = 0, T = 0, x_pc = zeros(3, Nc), F = 0, H = 0, S = 0, xvap = 0) if not Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn In_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Interfaces.trayConn Out_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Out.x_pc[1, :] = xout_c;
    Out.F = Fout;
    Out.H = Hout;
    In_Liq.F = Fliqin;
    In_Liq.H = Hliqin;
    In_Liq.x_c[:] = xliqin_c[:];
    Out_Vap.F = Fvapout;
    Out_Vap.H = Hvapout;
    Out_Vap.x_c[:] = xvapout_c[:];
    En.Q = Q;
//Adjustment for thermodynamic packages
    x_pc[1, :] = (Fout .* xout_c[:] + Fvapout .* xvapout_c[:]) ./ (Fout + Fvapout);
     x_pc[2, :] = xout_c[:];
//This equation is temporarily valid since this is only "partial" reboiler. Rewrite equation when "total" reboiler functionality is added
    x_pc[3, :] = xvapout_c[:];
//Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* Pvap_c[:] ./ philiqbubl_c[:]);
//Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* Pvap_c[:]) .* phivapdew_c[:]);
//molar balance
//  Fin + Fliqin = Fout + Fvapout;
    for i in 1:Nc loop
      Fin .* xin_c[i] + Fliqin .* xliqin_c[i] = Fout .* xout_c[i] + Fvapout .* xvapout_c[i];
    end for;
//equillibrium
    xvapout_c[:] = K_c[:] .* xout_c[:];
//summation equation
//    sum(xvapout_c[:]) = 1;
    sum(xout_c[:]) = 1;
    for i in 1:Nc loop
      Hvapout_c[i] = Simulator.Files.ThermodynamicFunctions.HVapId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    end for;
    Hvapout = sum(xvapout_c[:] .* Hvapout_c[:]) + Hres_p[3];
// bubble point calculations
    P = sum(xout_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]));
//    Fout = 10;
    Fin * Hin + Fliqin * Hliqin = Fout * Hout + Fvapout * Hvapout + Q;
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      __OpenModelica_commandLineOptions = "");
  end Reb;
